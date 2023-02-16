Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80DD1699099
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 11:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbjBPKAn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 05:00:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBPKAm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 05:00:42 -0500
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0641E10EF
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 02:00:40 -0800 (PST)
Received: from 8bytes.org (p200300c27714bc0086ad4f9d2505dd0d.dip0.t-ipconnect.de [IPv6:2003:c2:7714:bc00:86ad:4f9d:2505:dd0d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.8bytes.org (Postfix) with ESMTPSA id 367F92245E3;
        Thu, 16 Feb 2023 11:00:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
        s=default; t=1676541639;
        bh=ECcHlosMEjmFtUse35OeJBXoREt01AQegbavKKJmYS8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=7tqbSHOFvdUWadBzElpKWejdm3y7QuuYC0OCMN1XpJlHQshWHiWFM7sBb/K3uZbS9
         AKNmtypEv58gLLvd9Kj45tA4sxMf8RpnXTJkO3YxUbclLEkY+hA+mJ/s8omAM59nnB
         iNGrxHOOXxI7BW2BjBhU4zj5SH/QW9FMX4AAWDjxI/pNc/zNrLVpF9axIdRDfdPOsn
         mo53OyR5zhjsh/MTPMWovRdZ5EmYlUplSTfw8pmcKCwpU8s+NHdtVCKYP4MK/JyGQ9
         Cj+l/tGlweZeJxg4Gsv3H08ZlW50ZXePC97odYXX7H8QPI1Fpx4wz0stsxgTOHV27z
         HPhgG5oIEgNEQ==
Date:   Thu, 16 Feb 2023 11:00:38 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     iommu@lists.linux.dev, Vasant Hegde <vasant.hegde@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v1] iommu/amd: Don't block updates to GATag if guest mode
 is already on
Message-ID: <Y+3+xtof4tC8koSj@8bytes.org>
References: <20230208131938.39898-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208131938.39898-1-joao.m.martins@oracle.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Missing Signed-off-by.

Also adding Vasant from AMD for review.

On Wed, Feb 08, 2023 at 01:19:38PM +0000, Joao Martins wrote:
> On KVM GSI routing table updates, specially those where they have vIOMMUs
> with interrupt remapping enabled (e.g. to boot >255vcpus guests without
> relying on KVM_FEATURE_MSI_EXT_DEST_ID), a VMM may update the backing VF
> MSIs with new VCPU affinities.
> 
> On AMD this translates to calls to amd_ir_set_vcpu_affinity() and
> eventually to amd_iommu_{de}activate_guest_mode() with a new GATag
> outlining the VM ID and (new) VCPU ID. On vCPU blocking and unblocking
> paths it disables AVIC, and rely on GALog to convey the wakeups to any
> sleeping vCPUs. KVM will store a list of GA-mode IR entries to each
> running/blocked vCPU. So any vCPU Affinity update to a VF interrupt happen
> via KVM, and it will change already-configured-guest-mode IRTEs with a new
> GATag.
> 
> The issue is that amd_iommu_activate_guest_mode() will essentially only
> change IRTE fields on transitions from non-guest-mode to guest-mode and
> otherwise returns *with no changes to IRTE* on already configured
> guest-mode interrupts. To the guest this means that the VF interrupts
> remain affined to the first vCPU these were first configured, and guest
> will be unable to either VF interrupts and receive messages like this from
> spurious interrupts (e.g. from waking the wrong vCPU in GALog):
> 
> [  167.759472] __common_interrupt: 3.34 No irq handler for vector
> [  230.680927] mlx5_core 0000:00:02.0: mlx5_cmd_eq_recover:247:(pid
> 3122): Recovered 1 EQEs on cmd_eq
> [  230.681799] mlx5_core 0000:00:02.0:
> wait_func_handle_exec_timeout:1113:(pid 3122): cmd[0]: CREATE_CQ(0x400)
> recovered after timeout
> [  230.683266] __common_interrupt: 3.34 No irq handler for vector
> 
> Given that amd_ir_set_vcpu_affinity() uses amd_iommu_activate_guest_mode()
> underneath it essentially means that VCPU affinity changes of IRTEs are
> nops if it was called once for the IRTE already (on VMENTER). Fix it by
> dropping the check for guest-mode at amd_iommu_activate_guest_mode().  Same
> thing is applicable to amd_iommu_deactivate_guest_mode() although, even if
> the IRTE doesn't change underlying DestID on the host, the VFIO IRQ handler
> will still be able to poke at the right guest-vCPU.
> 
> Fixes: b9c6ff94e43a ("iommu/amd: Re-factor guest virtual APIC (de-)activation code")
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
> Some notes in other related flaws as I looked at this:
> 
> 1) amd_iommu_deactivate_guest_mode() suffers from the same issue as this patch,
> but it should only matter for the case where you rely on irqbalance-like
> daemons balancing VFIO IRQs in the hypervisor. Though, it doesn't translate
> into guest failures, more like performance "misdirection". Happy to fix it, if
> folks also deem it as a problem.
> 
> 2) This patch doesn't attempt at changing semantics around what
> amd_iommu_activate_guest_mode() has been doing for a long time [since v5.4]
> (i.e. clear the whole IRTE and then changes its fields). As such when
> updating the IRTEs the interrupts get isRunning and DestId cleared, thus
> we rely on the GALog to inject IRQs into vCPUs /until/ the vCPUs block
> and unblock again (which is when they update the IOMMU affinity), or the
> AVIC gets momentarily disabled. I have patches that improve this part as a
> follow-up, but I thought that this patch had value on its own onto fixing
> what has been broken since v5.4 ... and that it could be easily carried
> to stable trees.
> 
> ---
>  drivers/iommu/amd/iommu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index cbeaab55c0db..afe1f35a4dd9 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -3476,7 +3476,7 @@ int amd_iommu_activate_guest_mode(void *data)
>  	u64 valid;
>  
>  	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) ||
> -	    !entry || entry->lo.fields_vapic.guest_mode)
> +	    !entry)
>  		return 0;
>  
>  	valid = entry->lo.fields_vapic.valid;
> -- 
> 2.17.2
> 
