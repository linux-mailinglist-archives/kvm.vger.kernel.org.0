Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C11D65F2FB
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 18:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234788AbjAERkn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 12:40:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233739AbjAERkl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 12:40:41 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41FBF1EAC1
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 09:40:40 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id z9-20020a17090a468900b00226b6e7aeeaso2721260pjf.1
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 09:40:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0kbXgKOJsS8Z+jbEn56fulyxmGj5FZh1oxId45OhR8M=;
        b=N8XIhK045MkkRIiP6O5EdZ7OigBujdKSVRsliZrO2igyKTDNqw+6zG4NuTIjXnrm9n
         /aENa52CaJYwGt45hRQMIHj3cF7y6pgc4/fZAC8RLOcwl610aBTkiQlsDwrap/yJtFMz
         YvcNKNGhnbLHKd9jpzfUewGfN8u470pWga6OUDWMj264VwXQdqtfv3m8B9G+NXr1mMh+
         lIapdYshhh4t4u4bZMAMiCsKc16p+Xqn5rduSXP6ThQc0n86DYpFgfc9oARWSesGmQKL
         Igg1CRErPZLx16gHnRbE9DCGaFKzrrtmEw4/8vHok1Yn7Ox+Z1urn7Q8xJMA1ODmTrRH
         4A2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0kbXgKOJsS8Z+jbEn56fulyxmGj5FZh1oxId45OhR8M=;
        b=5kWQs5ayUmQG8fizdEeqPlG1prk5GAQu6HFdtQTWcHaO6GQJu5QtlgDAXijJZkVBr7
         ozlXSBOjhbLsk4NU6vi0S3wkWxMpgzctmuCXQU6Ye7V8yUggKTi9ME5my8n0aBimHh8R
         AkomVKL8MXFlLbVGp83SpoGKM81+Zt9snkvhkLv+DGbdJonx8HRKpVgDl42RqAO9AaAH
         Zt5D9K+bhQSERVjZkygrpMLCoaEO4F9geU5r6dSAu5NIQmcuxUayh7Y8cp5ZTZB8YYNw
         KaTXATxleuZHJIKV21WtWwJS32qsuid9IC64/B6WLOwqZhP46qaU0J1BWuYQjKuR6806
         GQyA==
X-Gm-Message-State: AFqh2kp8yIAIdaNgG0XaM3R9oAxlzbCSz32SOL4+FVfDvHJ0I9nn/dhh
        3FFLEeL337Hk16Vfw3zoKBFn3A==
X-Google-Smtp-Source: AMrXdXvePNSVad+Quj8sWC2rRAHirPmdt1mq9PKarW0GCZMUR3HO7TrM/aj7vHPEwJOF/+hzfbe9Qg==
X-Received: by 2002:a05:6a20:9e49:b0:a3:49d2:9504 with SMTP id mt9-20020a056a209e4900b000a349d29504mr250818pzb.3.1672940439549;
        Thu, 05 Jan 2023 09:40:39 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i12-20020a63584c000000b004785a63b44bsm21924802pgm.43.2023.01.05.09.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 09:40:37 -0800 (PST)
Date:   Thu, 5 Jan 2023 17:40:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 03/27] drm/i915/gvt: Incorporate KVM memslot info into
 check for 2MiB GTT entry
Message-ID: <Y7cLkLUMCy+XLRwm@google.com>
References: <20221223005739.1295925-1-seanjc@google.com>
 <20221223005739.1295925-4-seanjc@google.com>
 <Y6vXTcxDNovrmeVB@yzhao56-desk.sh.intel.com>
 <Y7SaklDQD0EoIs8l@google.com>
 <Y7Y+759IN2DH5h3h@yzhao56-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7Y+759IN2DH5h3h@yzhao56-desk.sh.intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 05, 2023, Yan Zhao wrote:
> On Tue, Jan 03, 2023 at 09:13:54PM +0000, Sean Christopherson wrote:
> > On Wed, Dec 28, 2022, Yan Zhao wrote:
> > > On Fri, Dec 23, 2022 at 12:57:15AM +0000, Sean Christopherson wrote:
> > > > Honor KVM's max allowed page size when determining whether or not a 2MiB
> > > > GTT shadow page can be created for the guest.  Querying KVM's max allowed
> > > > size is somewhat odd as there's no strict requirement that KVM's memslots
> > > > and VFIO's mappings are configured with the same gfn=>hva mapping, but
> > > Without vIOMMU, VFIO's mapping is configured with the same as KVM's
> > > memslots, i.e. with the same gfn==>HVA mapping
> > 
> > But that's controlled by userspace, correct?
> 
> Yes, controlled by QEMU.

...

> > Strictly speaking, no.  E.g. if a 2MiB region is covered with multiple memslots
> > and the memslots have different properties.
> > 
> > > If for some reason, KVM maps a 2MiB range in 4K sizes, KVMGT can still map
> > > it in IOMMU size in 2MiB size as long as the PFNs are continous and the
> > > whole range is all exposed to guest.
> > 
> > I agree that practically speaking this will hold true, but if KVMGT wants to honor
> > KVM's memslots then checking that KVM allows a hugepage is correct.  Hrm, but on
> > the flip side, KVMGT ignores read-only memslot flags, so KVMGT is already ignoring
> > pieces of KVM's memslots.
> KVMGT calls dma_map_page() with DMA_BIDIRECTIONAL after checking gvt_pin_guest_page().
> Though for a read-only memslot, DMA_TO_DEVICE should be used instead
> (see dma_info_to_prot()),
> as gvt_pin_guest_page() checks (IOMMU_READ | IOMMU_WRITE) permission for each page,
> it actually ensures that the pinned GFN is not in a read-only memslot.
> So, it should be fine.
> 
> > 
> > I have no objection to KVMGT defining its ABI such that KVMGT is allowed to create
> > 2MiB so long as (a) the GFN is contiguous according to VFIO, and (b) that the entire
> > 2MiB range is exposed to the guest.
> > 
> sorry. I may not put it clearly enough.
> for a normal device pass-through via VFIO-PCI, VFIO maps IOMMU mappings in this way:
> 
> (a) fault in PFNs in a GFN range within the same memslot (VFIO saves dma_list, which is
> the same as memslot list when vIOMMU is not on or not in shadow mode).
> (b) map continuous PFNs into iommu driver (honour ro attribute and can > 2MiB as long as
> PFNs are continuous).
> (c) IOMMU driver decides to map in 2MiB or in 4KiB according to its setting.
> 
> For KVMGT, gvt_dma_map_page() first calls gvt_pin_guest_page() which
> (a) calls vfio_pin_pages() to check each GFN is within allowed dma_list with
> (IOMMU_READ | IOMMU_WRITE) permission and fault-in page. 
> (b) checks PFNs are continuous in 2MiB,
> 
> Though checking kvm_page_track_max_mapping_level() is also fine, it makes DMA
> mapping size unnecessarily smaller.

Yeah, I got all that.  What I'm trying to say, and why I asked about whether or
not userspace controls the mappings, is that AFAIK there is nothing in the kernel
that coordinates mappings between VFIO and KVM.  So, very technically, userspace
could map a 2MiB range contiguous in VFIO but not in KVM, or RW in VFIO but RO in KVM.

I can't imagine there's a real use case for doing so, and arguably there's no
requirement that KVMGT honor KVM's memslot.  But because KVMGT taps into KVM's
page-tracking, KVMGT _does_ honor KVM's memslots to some extent because KVMGT
needs to know whether or not a given GFN can be write-protected.

I'm totally fine if KVMGT's ABI is that VFIO is the source of truth for mappings
and permissions, and that the only requirement for KVM memslots is that GTT page
tables need to be visible in KVM's memslots.  But if that's the ABI, then
intel_gvt_is_valid_gfn() should be probing VFIO, not KVM (commit cc753fbe1ac4
("drm/i915/gvt: validate gfn before set shadow page entry").

In other words, pick either VFIO or KVM.  Checking that X is valid according to
KVM and then mapping X through VFIO is confusing and makes assumptions about how
userspace configures KVM and VFIO.  It works because QEMU always configures KVM
and VFIO as expected, but IMO it's unnecessarily fragile and again confusing for
unaware readers because the code is technically flawed.

On a related topic, ppgtt_populate_shadow_entry() should check the validity of the
gfn.  If I'm reading the code correctly, checking only in ppgtt_populate_spt() fails
to handle the case where the guest creates a bogus mapping when writing an existing
GTT PT.

Combing all my trains of thought, what about this as an end state for this series?
(completely untested at this point).  Get rid of the KVM mapping size checks,
verify the validity of the entire range being mapped, and add a FIXME to complain
about using KVM instead of VFIO to determine the validity of ranges.

static bool intel_gvt_is_valid_gfn(struct intel_vgpu *vgpu, unsigned long gfn,
				   enum intel_gvt_gtt_type type)
{
	unsigned long nr_pages;

	if (!vgpu->attached)
		return false;

	if (type == GTT_TYPE_PPGTT_PTE_64K_ENTRY)
		nr_pages = I915_GTT_PAGE_SIZE_64K >> PAGE_SHIFT;
	else if (type == GTT_TYPE_PPGTT_PTE_2M_ENTRY)
		nr_pages = I915_GTT_PAGE_SIZE_2M >> PAGE_SHIFT;
	else
		nr_pages = 1;

	/*
	 * FIXME: Probe VFIO, not KVM.  VFIO is the source of truth for KVMGT
	 * mappings and permissions, KVM's involvement is purely to handle
	 * write-tracking of GTT page tables.
	 */
	return kvm_page_track_is_contiguous_gfn_range(vgpu->vfio_device.kvm,
						      gfn, nr_pages);
}

static int try_map_2MB_gtt_entry(struct intel_vgpu *vgpu, unsigned long gfn,
				 dma_addr_t *dma_addr)
{
	if (!HAS_PAGE_SIZES(vgpu->gvt->gt->i915, I915_GTT_PAGE_SIZE_2M))
		return 0;

	return intel_gvt_dma_map_guest_page(vgpu, gfn,
					    I915_GTT_PAGE_SIZE_2M, dma_addr);
}

static int ppgtt_populate_shadow_entry(struct intel_vgpu *vgpu,
	struct intel_vgpu_ppgtt_spt *spt, unsigned long index,
	struct intel_gvt_gtt_entry *ge)
{
	const struct intel_gvt_gtt_pte_ops *pte_ops = vgpu->gvt->gtt.pte_ops;
	dma_addr_t dma_addr = vgpu->gvt->gtt.scratch_mfn << PAGE_SHIFT;
	struct intel_gvt_gtt_entry se = *ge;
	unsigned long gfn;
	int ret;

	if (!pte_ops->test_present(ge))
		goto set_shadow_entry;

	gfn = pte_ops->get_pfn(ge);
	if (!intel_gvt_is_valid_gfn(vgpu, gfn, ge->type))
		goto set_shadow_entry;

	...


set_shadow_entry:
	pte_ops->set_pfn(&se, dma_addr >> PAGE_SHIFT);
	ppgtt_set_shadow_entry(spt, &se, index);
	return 0;
}
