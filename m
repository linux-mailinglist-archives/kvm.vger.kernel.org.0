Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B6C39A92F
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 19:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbhFCRa1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 13:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbhFCRa0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 13:30:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C18C06174A;
        Thu,  3 Jun 2021 10:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=C2x93GCoZiin4wmQCRttzlu4GmKci1Z97/29V5OUIBQ=; b=GRDRbyMv6qCSE0sh84jmHsdNkF
        Ca7KqDDXhE6PMeMjq9YlXaVzupQWhipW2IItm4ocsfSpw+d/efAwGK8FtYyzr6e9U2OdG0QNXnu1+
        4QMVh94o4r91Nb9pKuH/aEiHNN/RaaYLJk1EDj7snekcEw+wEoPAM7KtleMUX7IvQ0ursPrzg7ZF/
        gXXzGmAwjg3XV30CvwWJ354CMua5g6UeT0oN8FI3A0frhhHpPWm8cujn3JtHZoyDZpU/SxKz+S99B
        vDFcvTD2d81achEPArKXYaS7aFfuHurRAPSgV0E+UgPbkBvDEdjoVzzfxyhE5YcHK539uoPArzXor
        gytVNA5Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lor85-00COf2-Ei; Thu, 03 Jun 2021 17:27:46 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 63300300269;
        Thu,  3 Jun 2021 19:27:35 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 400C72BF86F79; Thu,  3 Jun 2021 19:27:35 +0200 (CEST)
Date:   Thu, 3 Jun 2021 19:27:35 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Suleiman Souhlal <suleiman@google.com>, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [RFC][PATCH] kvm: add suspend pm-notifier
Message-ID: <YLkRB3qxjrXB99He@hirez.programming.kicks-ass.net>
References: <20210603164315.682994-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603164315.682994-1-senozhatsky@chromium.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 04, 2021 at 01:43:15AM +0900, Sergey Senozhatsky wrote:
> Add KVM suspend/hibernate PM-notifier which lets architectures
> to implement arch-specific VM suspend code. For instance, on x86
> this sets PVCLOCK_GUEST_STOPPED on all the VCPUs.
> 
> Our case is that user puts the host system into sleep multiple
> times a day (e.g. closes the laptop's lid) so we need a reliable
> way to suspend VMs properly.
> 
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> ---
>  arch/arm64/kvm/arm.c       |  4 ++++
>  arch/mips/kvm/mips.c       |  4 ++++
>  arch/powerpc/kvm/powerpc.c |  4 ++++
>  arch/s390/kvm/kvm-s390.c   |  4 ++++
>  arch/x86/kvm/x86.c         | 21 ++++++++++++++++++++
>  include/linux/kvm_host.h   |  8 ++++++++
>  virt/kvm/kvm_main.c        | 40 ++++++++++++++++++++++++++++++++++++++
>  7 files changed, 85 insertions(+)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 1126eae27400..547dbe44d039 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1311,6 +1311,10 @@ static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
>  	}
>  }
>  
> +void kvm_arch_pm_notifier(struct kvm *kvm)
> +{
> +}
> +
>  long kvm_arch_vm_ioctl(struct file *filp,
>  		       unsigned int ioctl, unsigned long arg)
>  {
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index 4d4af97dcc88..d4408acd2be6 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -980,6 +980,10 @@ void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
>  	kvm_flush_remote_tlbs(kvm);
>  }
>  
> +void kvm_arch_pm_notifier(struct kvm *kvm)
> +{
> +}
> +
>  long kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>  {
>  	long r;
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index a2a68a958fa0..96e8a7b6fcf0 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -2334,6 +2334,10 @@ static int kvmppc_get_cpu_char(struct kvm_ppc_cpu_char *cp)
>  }
>  #endif
>  
> +void kvm_arch_pm_notifier(struct kvm *kvm)
> +{
> +}
> +
>  long kvm_arch_vm_ioctl(struct file *filp,
>                         unsigned int ioctl, unsigned long arg)
>  {
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 1296fc10f80c..c5f86fc1e497 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2367,6 +2367,10 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>  	return r;
>  }
>  
> +void kvm_arch_pm_notifier(struct kvm *kvm)
> +{
> +}
> +
>  long kvm_arch_vm_ioctl(struct file *filp,
>  		       unsigned int ioctl, unsigned long arg)
>  {

What looks like you wants a __weak function.
