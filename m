Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C50C414EC47
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 13:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbgAaMGk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 07:06:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56595 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728374AbgAaMGk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jan 2020 07:06:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580472398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O8Za+S+RT8N2UwLMl2kq7dZ6BHikmL9Pgno023mZKr8=;
        b=SB21G3a9BqRB5ykpuKF1GzKwBWl69Pr/mZOtw563SHeiY6kx9AN+0n7Cf0925c53nAkTKA
        0N5CdyPNv2Aqf7e46BNXGbf4s7FzQgPx3txSHVDhb3bE9aYX8okH3fmKUm5lDWuEP68uRS
        WgLet5sJAICOvD5H6csuEgEYKPniNps=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-136-Ih36PAVQOHGA5sgccpxLOw-1; Fri, 31 Jan 2020 07:06:36 -0500
X-MC-Unique: Ih36PAVQOHGA5sgccpxLOw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 738599275B;
        Fri, 31 Jan 2020 12:06:33 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 46DCC5C3FA;
        Fri, 31 Jan 2020 12:06:18 +0000 (UTC)
Date:   Fri, 31 Jan 2020 13:06:15 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] KVM: Pass kvm_init()'s opaque param to additional
 arch funcs
Message-ID: <20200131130615.3b21b28d.cohuck@redhat.com>
In-Reply-To: <20200130001023.24339-2-sean.j.christopherson@intel.com>
References: <20200130001023.24339-1-sean.j.christopherson@intel.com>
        <20200130001023.24339-2-sean.j.christopherson@intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 29 Jan 2020 16:10:19 -0800
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> Pass @opaque to kvm_arch_hardware_setup() and
> kvm_arch_check_processor_compat() to allow architecture specific code to
> reference @opaque without having to stash it away in a temporary global
> variable.  This will enable x86 to separate its vendor specific callback
> ops, which are passed via @opaque, into "init" and "runtime" ops without
> having to stash away the "init" ops.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/mips/kvm/mips.c       |  4 ++--
>  arch/powerpc/kvm/powerpc.c |  4 ++--
>  arch/s390/kvm/kvm-s390.c   |  4 ++--
>  arch/x86/kvm/x86.c         |  4 ++--
>  include/linux/kvm_host.h   |  4 ++--
>  virt/kvm/arm/arm.c         |  4 ++--
>  virt/kvm/kvm_main.c        | 18 ++++++++++++++----
>  7 files changed, 26 insertions(+), 16 deletions(-)

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index eb3709d55139..5ad252defa54 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4345,14 +4345,22 @@ struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void)
>          return &kvm_running_vcpu;
>  }
>  
> -static void check_processor_compat(void *rtn)
> +struct kvm_cpu_compat_check {
> +	void *opaque;
> +	int *ret;
> +};
> +
> +static void check_processor_compat(void *data)
>  {
> -	*(int *)rtn = kvm_arch_check_processor_compat();
> +	struct kvm_cpu_compat_check *c = data;
> +
> +	*c->ret = kvm_arch_check_processor_compat(c->opaque);
>  }

This function also looks better now :)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Tested-by: Cornelia Huck <cohuck@redhat.com> #s390

