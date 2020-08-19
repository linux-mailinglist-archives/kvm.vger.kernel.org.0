Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F713249919
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 11:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgHSJNl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 05:13:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21720 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726728AbgHSJNi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Aug 2020 05:13:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597828416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e07YZVxjb6RlgEcp1q+BS9DHoI90/8xUo23kfep//QI=;
        b=UtsSeCXSDPzPjjpXYgKYl/IijzlcaiYVj23FuaNWCvSWjksKfG9qnvR1jngz+9YBpiDCzj
        mqRK9mZuZp5+K3L6DxXW2wltRXC3w6uH/gy+7qyYCb0Vv3j2EGw2XMD4oV+tIXUOMqdCqP
        /riet/1NgnVEAEUG5L0G3sBjLaAUwlU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-uhRjvtmAMgOzyr1aE3QVBg-1; Wed, 19 Aug 2020 05:13:32 -0400
X-MC-Unique: uhRjvtmAMgOzyr1aE3QVBg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A0D2186A563;
        Wed, 19 Aug 2020 09:13:31 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.144])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E4D602635E;
        Wed, 19 Aug 2020 09:13:29 +0000 (UTC)
Date:   Wed, 19 Aug 2020 11:13:27 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     jmattson@google.com, graf@amazon.com, pshier@google.com,
        oupton@google.com, kvm@vger.kernel.org
Subject: Re: [PATCH v3 09/12] selftests: kvm: Clear uc so UCALL_NONE is being
 properly reported
Message-ID: <20200819091327.iqlsa734griykhkz@kamzik.brq.redhat.com>
References: <20200818211533.849501-1-aaronlewis@google.com>
 <20200818211533.849501-10-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818211533.849501-10-aaronlewis@google.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 18, 2020 at 02:15:31PM -0700, Aaron Lewis wrote:
> Ensure the out value 'uc' in get_ucall() is properly reporting
> UCALL_NONE if the call fails.  The return value will be correctly
> reported, however, the out parameter 'uc' will not be.  Clear the struct
> to ensure the correct value is being reported in the out parameter.
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
> 
> v2 -> v3
> 
>  - This commit is new to the series.  This was added to have the ucall changes
>    separate from the exception handling changes and the addition of the test.
>  - Added support on aarch64 and s390x as well.
> 
> ---
>  tools/testing/selftests/kvm/lib/aarch64/ucall.c | 3 +++
>  tools/testing/selftests/kvm/lib/s390x/ucall.c   | 3 +++
>  tools/testing/selftests/kvm/lib/x86_64/ucall.c  | 3 +++
>  3 files changed, 9 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/ucall.c b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> index c8e0ec20d3bf..2f37b90ee1a9 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> @@ -94,6 +94,9 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc)
>  	struct kvm_run *run = vcpu_state(vm, vcpu_id);
>  	struct ucall ucall = {};
>  
> +	if (uc)
> +		memset(uc, 0, sizeof(*uc));
> +
>  	if (run->exit_reason == KVM_EXIT_MMIO &&
>  	    run->mmio.phys_addr == (uint64_t)ucall_exit_mmio_addr) {
>  		vm_vaddr_t gva;
> diff --git a/tools/testing/selftests/kvm/lib/s390x/ucall.c b/tools/testing/selftests/kvm/lib/s390x/ucall.c
> index fd589dc9bfab..9d3b0f15249a 100644
> --- a/tools/testing/selftests/kvm/lib/s390x/ucall.c
> +++ b/tools/testing/selftests/kvm/lib/s390x/ucall.c
> @@ -38,6 +38,9 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc)
>  	struct kvm_run *run = vcpu_state(vm, vcpu_id);
>  	struct ucall ucall = {};
>  
> +	if (uc)
> +		memset(uc, 0, sizeof(*uc));
> +
>  	if (run->exit_reason == KVM_EXIT_S390_SIEIC &&
>  	    run->s390_sieic.icptcode == 4 &&
>  	    (run->s390_sieic.ipa >> 8) == 0x83 &&    /* 0x83 means DIAGNOSE */
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/ucall.c b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> index da4d89ad5419..a3489973e290 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> @@ -40,6 +40,9 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc)
>  	struct kvm_run *run = vcpu_state(vm, vcpu_id);
>  	struct ucall ucall = {};
>  
> +	if (uc)
> +		memset(uc, 0, sizeof(*uc));
> +
>  	if (run->exit_reason == KVM_EXIT_IO && run->io.port == UCALL_PIO_PORT) {
>  		struct kvm_regs regs;
>  
> -- 
> 2.28.0.220.ged08abb693-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

