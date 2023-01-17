Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB66B670D8C
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 00:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbjAQXca (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 18:32:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjAQXbw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 18:31:52 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A4C460AD;
        Tue, 17 Jan 2023 12:51:22 -0800 (PST)
Date:   Tue, 17 Jan 2023 20:51:13 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1673988680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tBfVFTcOroevwU21TT12BjG/YfB4gGjHAdUTut1zEfE=;
        b=k3SfH990JxjLMD1azdUqAYV3qH2dpILCHNOUpFvPnnEGaH4o8DSODDMapBT1XqN7p/g17I
        FDQg2C1oQtzrxNeH/+hJZ80tH9djmqM9cQTroEfpGdJahiPMqM3ol6tXjLcSH6C9cycGBq
        tq4cav0IOHAblnomIdYMP6zRzfCCFw4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, maz@kernel.org, corbet@lwn.net,
        james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
        catalin.marinas@arm.com, will@kernel.org, ricarkol@google.com,
        eric.auger@redhat.com, yuzhe@nfschina.com, renzhengeek@gmail.com,
        ardb@kernel.org, peterx@redhat.com, seanjc@google.com,
        shan.gavin@gmail.com
Subject: Re: [PATCH 1/4] KVM: arm64: Allow saving vgic3 LPI pending status in
 no running vcpu context
Message-ID: <Y8cKQRIbpLWVcdcw@google.com>
References: <20230116040405.260935-1-gshan@redhat.com>
 <20230116040405.260935-2-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116040405.260935-2-gshan@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Gavin,

On Mon, Jan 16, 2023 at 12:04:02PM +0800, Gavin Shan wrote:
> When dirty ring is enabled, the dirty page information is pushed to
> the dirty ring if there is a running VCPU context. Otherwise, the
> dirty page information is still tracked by the backup dirty bitmap.
> In order to detect if there is a running VCPU context when a guest
> page becomes dirty, kvm_arch_allow_write_without_running_vcpu() was
> introduced to warn when no running VCPU context exists on unknown
> cases.
> 
> Other than the site of saving ITS tables, it's possible to save vgic3
> LPI pending status in no running vcpu context because it can happen when
> ITS ITE is restored through the command KVM_DEV_ARM_ITS_RESTORE_TABLES
> on 'kvm-arm-vgic-its' device.
> 
> Fix it by allowing to save vgic3 LPI pending status in no running
> vcpu context.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  Documentation/virt/kvm/api.rst | 5 +++--
>  arch/arm64/kvm/vgic/vgic-its.c | 3 ++-
>  arch/arm64/kvm/vgic/vgic-v3.c  | 3 +++
>  include/kvm/arm_vgic.h         | 1 +
>  4 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 9807b05a1b57..18b245a0ba02 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8071,8 +8071,9 @@ state is final and avoid missing dirty pages from another ioctl ordered
>  after the bitmap collection.
>  
>  NOTE: One example of using the backup bitmap is saving arm64 vgic/its
> -tables through KVM_DEV_ARM_{VGIC_GRP_CTRL, ITS_SAVE_TABLES} command on
> -KVM device "kvm-arm-vgic-its" when dirty ring is enabled.
> +tables and vgic3 LPI pending status through KVM_DEV_ARM_{VGIC_GRP_CTRL,
> +ITS_SAVE_TABLES} and KVM_DEV_ARM_{VGIC_GRP_CTRL, ITS_RESTORE_TABLES}
> +command on KVM device "kvm-arm-vgic-its" when dirty ring is enabled.
>  
>  8.30 KVM_CAP_XEN_HVM
>  --------------------
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index 94a666dd1443..119a9c7a0a52 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -2792,7 +2792,8 @@ bool kvm_arch_allow_write_without_running_vcpu(struct kvm *kvm)
>  {
>  	struct vgic_dist *dist = &kvm->arch.vgic;
>  
> -	return dist->save_its_tables_in_progress;
> +	return dist->save_vgic_v3_tables_in_progress ||
> +	       dist->save_its_tables_in_progress;

I'd much prefer using a single bool to keep track of this, i.e:

	return dist->save_tables_in_progress;

>  }
>  
>  static int vgic_its_set_attr(struct kvm_device *dev,
> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index 2074521d4a8c..32998c8587a8 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -304,6 +304,7 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
>  int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq)
>  {
>  	struct kvm_vcpu *vcpu;
> +	struct vgic_dist *dist = &kvm->arch.vgic;
>  	int byte_offset, bit_nr;
>  	gpa_t pendbase, ptr;
>  	bool status;
> @@ -339,7 +340,9 @@ int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq)
>  	if (status) {
>  		/* clear consumed data */
>  		val &= ~(1 << bit_nr);
> +		dist->save_vgic_v3_tables_in_progress = true;
>  		ret = kvm_write_guest_lock(kvm, ptr, &val, 1);
> +		dist->save_vgic_v3_tables_in_progress = false;

With the above suggestion of using a bool, this should become a helper
used at all the affected callsites:

  static int vgic_write_guest_lock(struct kvm *kvm, gpa_t gpa,
  				   const void *data, unsigned long len)
  {
  	struct vgic_dist *dist = &kvm->arch.vgic;
	int ret;

	dist->save_tables_in_progress = true;
	ret = kvm_write_guest_lock(kvm, gpa, data, len);
	dist->save_tables_in_progress = false;

	return ret;
  }

--
Thanks,
Oliver
