Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E81D260F09
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 11:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728873AbgIHJxa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 05:53:30 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:36795 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728804AbgIHJx3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Sep 2020 05:53:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599558808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FBNH2TKloZYz+VQ8z5rDqMA5CzFUqgJN9jmog9OO4ZQ=;
        b=NbEhs6nO1P0J2iuwCGF6/C+rPwNHtcWXvrCAxAlz24hwQ8qHUfoTN8WSUOukappj96vBSd
        OOWNMaJULIVm1pXv4HOvjcpNemNHlmk/8HcAHochY7Y0vRcpOSaejyzm/7J7+EnRFqkSLR
        r21DVlMh7JYmUbBQGqWgnJv1/UGRfWU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288--kGdKwDyOlCWDSa31-TTbw-1; Tue, 08 Sep 2020 05:53:24 -0400
X-MC-Unique: -kGdKwDyOlCWDSa31-TTbw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A328A800469;
        Tue,  8 Sep 2020 09:53:22 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.171])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CF272805F0;
        Tue,  8 Sep 2020 09:53:20 +0000 (UTC)
Date:   Tue, 8 Sep 2020 11:53:18 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com, graf@amazon.com,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v3 1/5] KVM: arm64: Refactor PMU attribute error handling
Message-ID: <20200908095318.nzbnadvgcmxvt3xs@kamzik.brq.redhat.com>
References: <20200908075830.1161921-1-maz@kernel.org>
 <20200908075830.1161921-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908075830.1161921-2-maz@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Tue, Sep 08, 2020 at 08:58:26AM +0100, Marc Zyngier wrote:
> The PMU emulation error handling is pretty messy when dealing with
> attributes. Let's refactor it so that we have less duplication,
> and that it is easy to extend later on.
> 
> A functional change is that kvm_arm_pmu_v3_init() used to return
> -ENXIO when the PMU feature wasn't set. The error is now reported
> as -ENODEV, matching the documentation.

Hmm, I didn't think we could make changes like that, since some userspace
somewhere may now depend on the buggy interface. That said, I'm not really
against the change, but maybe it should go as a separate patch.

> -ENXIO is still returned
> when the interrupt isn't properly configured.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/pmu-emul.c | 21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index f0d0312c0a55..93d797df42c6 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -735,15 +735,6 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
>  
>  static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
>  {
> -	if (!kvm_arm_support_pmu_v3())
> -		return -ENODEV;
> -
> -	if (!test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
> -		return -ENXIO;
> -
> -	if (vcpu->arch.pmu.created)
> -		return -EBUSY;
> -
>  	if (irqchip_in_kernel(vcpu->kvm)) {
>  		int ret;
>  
> @@ -796,6 +787,15 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
>  
>  int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  {
> +	if (!kvm_arm_support_pmu_v3())
> +		return -ENODEV;
> +
> +	if (!test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
> +		return -ENODEV;

nit: could combine these two if's w/ an ||

> +
> +	if (vcpu->arch.pmu.created)
> +		return -EBUSY;
> +
>  	switch (attr->attr) {
>  	case KVM_ARM_VCPU_PMU_V3_IRQ: {
>  		int __user *uaddr = (int __user *)(long)attr->addr;
> @@ -804,9 +804,6 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  		if (!irqchip_in_kernel(vcpu->kvm))
>  			return -EINVAL;
>  
> -		if (!test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
> -			return -ENODEV;
> -
>  		if (get_user(irq, uaddr))
>  			return -EFAULT;
>  
> -- 
> 2.28.0
> 

Thanks,
drew

> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 

