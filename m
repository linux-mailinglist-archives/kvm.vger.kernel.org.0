Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E68214DF1B
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 17:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbgA3Q2N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 11:28:13 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42791 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727267AbgA3Q2N (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jan 2020 11:28:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580401691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/xZLVXcqwiAx0V+bSTR2trqI1rrBSIY/my/Op3nqR6Q=;
        b=FU3dMlFBe8kpH96VDicI+yMYAF9YEdgU810vsuJEYsGqDJkgQ+FgCJAoO0oK8O6ABY994v
        Ag/FR5DGNctI8HOKkZDk0Bjon+yYrrYTF1dp/0uaAyxUuXKpMEWuZ44JYFNObGdCpDFIC2
        T56CjTiFbzmWUVpTBZ3QF03XRNiKkSA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-6YY1tMpKN2y_ywLnjby5Sw-1; Thu, 30 Jan 2020 11:28:06 -0500
X-MC-Unique: 6YY1tMpKN2y_ywLnjby5Sw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD1A21137842;
        Thu, 30 Jan 2020 16:28:04 +0000 (UTC)
Received: from gondolin (ovpn-117-199.ams2.redhat.com [10.36.117.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C88F260BE1;
        Thu, 30 Jan 2020 16:28:00 +0000 (UTC)
Date:   Thu, 30 Jan 2020 17:27:57 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, borntraeger@de.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org
Subject: Re: [PATCH v9 6/6] selftests: KVM: testing the local IRQs resets
Message-ID: <20200130172757.09b1bbed.cohuck@redhat.com>
In-Reply-To: <20200130123434.68129-7-frankja@linux.ibm.com>
References: <20200130123434.68129-1-frankja@linux.ibm.com>
        <20200130123434.68129-7-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 30 Jan 2020 07:34:34 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> From: Pierre Morel <pmorel@linux.ibm.com>
> 
> Local IRQs are reset by a normal cpu reset.  The initial cpu reset and
> the clear cpu reset, as superset of the normal reset, both clear the
> IRQs too.
> 
> Let's inject an interrupt to a vCPU before calling a reset and see if
> it is gone after the reset.
> 
> We choose to inject only an emergency interrupt at this point and can
> extend the test to other types of IRQs later.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>[minor fixups]
> ---
>  tools/testing/selftests/kvm/s390x/resets.c | 46 ++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/s390x/resets.c b/tools/testing/selftests/kvm/s390x/resets.c
> index 4e173517f909..8a2507930e7d 100644
> --- a/tools/testing/selftests/kvm/s390x/resets.c
> +++ b/tools/testing/selftests/kvm/s390x/resets.c
> @@ -14,6 +14,9 @@
>  #include "kvm_util.h"
>  
>  #define VCPU_ID 3
> +#define LOCAL_IRQS 32

The choice of 32 here is still a bit unclear (although not a problem).

> +
> +struct kvm_s390_irq buf[VCPU_ID + LOCAL_IRQS];
>  
>  struct kvm_vm *vm;
>  struct kvm_run *run;
> @@ -53,6 +56,27 @@ static void test_one_reg(uint64_t id, uint64_t value)
>  	TEST_ASSERT(eval_reg == value, "value == %s", value);
>  }
>  
> +static void assert_noirq(void)
> +{
> +	struct kvm_s390_irq_state irq_state;
> +	int irqs;
> +
> +	if (!(kvm_check_cap(KVM_CAP_S390_INJECT_IRQ) &&
> +	    kvm_check_cap(KVM_CAP_S390_IRQ_STATE)))
> +		return;

I think you should drop the capability check here as well.

> +
> +	irq_state.len = sizeof(buf);
> +	irq_state.buf = (unsigned long)buf;
> +	irqs = _vcpu_ioctl(vm, VCPU_ID, KVM_S390_GET_IRQ_STATE, &irq_state);
> +	/*
> +	 * irqs contains the number of retrieved interrupts, apart from the
> +	 * emergency call that should be cleared by the resets, there should be
> +	 * none.

What about the updated comment? :)

> +	 */
> +	TEST_ASSERT(irqs >= 0, "Could not fetch IRQs: errno %d\n", errno);
> +	TEST_ASSERT(!irqs, "IRQ pending");
> +}
> +
>  static void assert_clear(void)
>  {
>  	struct kvm_sregs sregs;

Else, looks sane to me.

