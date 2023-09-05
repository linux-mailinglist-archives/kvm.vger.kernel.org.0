Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFF2C792E26
	for <lists+kvm@lfdr.de>; Tue,  5 Sep 2023 21:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239294AbjIETAn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 15:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239485AbjIETAh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 15:00:37 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B051AE
        for <kvm@vger.kernel.org>; Tue,  5 Sep 2023 12:00:10 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-68e2c2a6abfso192528b3a.0
        for <kvm@vger.kernel.org>; Tue, 05 Sep 2023 12:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693940351; x=1694545151; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3pnfyd6yBzdd/T/rKllIScbRlqlXMgiDo0DWoktzebA=;
        b=JaKNPUOiB2kQYgY/MFE6FWpWuRhlAU7Hwxv0gZrxvBrojUPCDRBSNsY9u+Cky1VDX/
         GeGrKoxfsgsPWtVLgcc+jcmC/rdFF7o8ZpAn7V4SmvOUVAk9kp7+w5YCIk5uqQ8w8j9x
         tvInlK4/DZGjS45gHz/JZEYz3DTTd7tLfBqxeBltHvhICEQbKSkfOv8JiNTH5/invN6e
         SKUZ5IXMPZjcQ4lJcLgZkLaZSLHl6SIQTQtOEB7uqXuDQJg4/0fAy1lB0uwIpN4gDc5b
         7WU+rfQhl8tR3s8gFq1rVqYbU1xmqw1Lkvi4l/pCAIrbLy8lOVmRAW7A3zf1UxPTh9qn
         fEHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693940351; x=1694545151;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3pnfyd6yBzdd/T/rKllIScbRlqlXMgiDo0DWoktzebA=;
        b=c8b7Zuo1hvAvChOukqtp4z6uYhAbx1UiDSez2H0zTsiMJXAIYNasoYV/jKM+xzfiM3
         vyUMvSMOBm+R5E/fpA0TdeUNx5JMKizBqOT6tlVTVEnBttjP5rM7U0o69lI3jlqhIJAj
         aBALYjYN8IGp/ohrUwwsqguhrm1MlexvtTfGk34tzDKPm3HsSofPrSPKURdj0GEqsZ6h
         9KKmuJgxJhqpcp6vz18T+91AKolVzMYhOmYSzFCBwSP3cCZ4DD0pnrCCdJT1WVFc7jbl
         LHRlkwFFXxoSA1hLMAeH+c8FQxfA8shk1QKimaJ2nTbJjiQCh9UL/wQm/S4sgoV3H/pL
         MxwA==
X-Gm-Message-State: AOJu0YwtkGOg93U7JNZMdeve1wqB+jyMXhViL234Yf5YOBr2lwatYi7T
        l9PESa4zn2xhYlxW2ML1xKcnJdH8b3Q=
X-Google-Smtp-Source: AGHT+IE72/hMTQwRCNIc72pTtUS+2lyNsqg46Lcoy8pF3ZAs+Zv+1exY0kgXCsALesTF/zSq3lHwp7x4zw4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d0d:b0:68a:5937:ea87 with SMTP id
 fa13-20020a056a002d0d00b0068a5937ea87mr5290185pfb.3.1693940351350; Tue, 05
 Sep 2023 11:59:11 -0700 (PDT)
Date:   Tue, 5 Sep 2023 11:59:09 -0700
In-Reply-To: <ZPWBM5DDC6MKINUe@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <20230808085056.14644-1-yan.y.zhao@intel.com> <ZN0S28lkbo6+D7aF@google.com>
 <ZN1jBFBH4C2bFjzZ@yzhao56-desk.sh.intel.com> <ZN5elYQ5szQndN8n@google.com>
 <ZN9FQf343+kt1YsX@yzhao56-desk.sh.intel.com> <ZPWBM5DDC6MKINUe@yzhao56-desk.sh.intel.com>
Message-ID: <ZPd6Y9KJ0FfbCa0Q@google.com>
Subject: Re: [PATCH 0/2] KVM: x86/mmu: .change_pte() optimization in TDP MMU
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+swiotbl maintainers and Linus

Spinning off a discussion about swiotlb behavior to its own thread.

Quick background: when running Linux as a KVM guest, Yan observed memory accesses
where Linux is reading completely uninitialized memory (never been written by the
guest) and traced it back to this code in the swiotlb:

	/*
	 * When dir == DMA_FROM_DEVICE we could omit the copy from the orig
	 * to the tlb buffer, if we knew for sure the device will
	 * overwrite the entire current content. But we don't. Thus
	 * unconditional bounce may prevent leaking swiotlb content (i.e.
	 * kernel memory) to user-space.
	 */
	swiotlb_bounce(dev, tlb_addr, mapping_size, DMA_TO_DEVICE);

The read-before-write behavior results in suboptimal performance as KVM maps the
memory as read-only, and then triggers CoW when the guest inevitably writes the
memory (CoW is significantly more expensive when KVM is involved).

There are a variety of ways to workaround this in KVM, but even if we decide to
address this in KVM, the swiotlb behavior is sketchy.  Not to mention that any
KVM changes are highly unlikely to be backported to LTS kernels.

On Mon, Sep 04, 2023, Yan Zhao wrote:
> ...
> > > Actually, I don't even completely understand how you're seeing CoW behavior in
> > > the first place.  No sane guest should blindly read (or execute) uninitialized
> > > memory.  IIUC, you're not running a Windows guest, and even if you are, AFAIK
> > > QEMU doesn't support Hyper-V's enlightment that lets the guest assume memory has
> > > been zeroed by the hypervisor.  If KSM is to blame, then my answer it to turn off
> > > KSM, because turning on KSM is antithetical to guest performance (not to mention
> > > that KSM is wildly insecure for the guest, especially given the number of speculative
> > > execution attacks these days).
> > I'm running a linux guest.
> > KSM is not turned on both in guest and host.
> > Both guest and host have turned on transparent huge page.
> > 
> > The guest first reads a GFN in a writable memslot (which is for "pc.ram"),
> > which will cause
> >     (1) KVM first sends a GUP without FOLL_WRITE, leaving a huge_zero_pfn or a zero-pfn
> >         mapped.
> >     (2) KVM calls get_user_page_fast_only() with FOLL_WRITE as the memslot is writable,
> >         which will fail
> > 
> > The guest then writes the GFN.
> > This step will trigger (huge pmd split for huge page case) and .change_pte().
> > 
> > My guest is surely a sane guest. But currently I can't find out why
> > certain pages are read before write.
> > Will return back to you the reason after figuring it out after my long vacation.
> Finally I figured out the reason.
> 
> Except 4 pages were read before written from vBIOS (I just want to skip finding
> out why vBIOS does this), the remaining thousands of pages were read before
> written from the guest Linux kernel.

...

> When the guest kernel triggers a guest block device read ahead, pages are
> allocated as page cache pages, and requests to read disk data into the page
> cache are issued.
> 
> The disk data read requests will cause dma_direct_map_page() called if vIOMMU
> is not enabled. Then, because the virtual IDE device can only direct access
> 32-bit DMA address (equal to GPA) at maximum, swiotlb will be used as DMA
> bounce if page cache pages are with GPA > 32 bits.
>
> Then the call path is
> dma_direct_map_page() --> swiotlb_map() -->swiotlb_tbl_map_single()
> 
> In swiotlb_tbl_map_single(), though DMA direction is DMA_FROM_DEVICE,
> this swiotlb_tbl_map_single() will call
> swiotlb_bounce(dev, tlb_addr, mapping_size, DMA_TO_DEVICE) to read page cache
> content to the bounce buffer first.
> Then, during device DMAs, device content is DMAed into the bounce buffer.
> After that, the bounce buffer data will be copied back to the page cache page
> after calling dma_direct_unmap_page() --> swiotlb_tbl_unmap_single().
> 
> 
> IOW, before reading ahead device data into the page cache, the page cache is
> read and copied to the bounce buffer, though an immediate write is followed to
> copy bounce buffer data back to the page cache.
> 
> This explains why it's observed in host that most pages are written immediately
> after it's read, and .change_pte() occurs heavily during guest boot-up and
> nested guest boot-up, -- when disk readahead happens abundantly.
> 
> The reason for this unconditional read of page into bounce buffer
> (caused by "swiotlb_bounce(dev, tlb_addr, mapping_size, DMA_TO_DEVICE)")
> is explained in the code:
> 
> /*
>  * When dir == DMA_FROM_DEVICE we could omit the copy from the orig
>  * to the tlb buffer, if we knew for sure the device will
>  * overwrite the entire current content. But we don't. Thus
>  * unconditional bounce may prevent leaking swiotlb content (i.e.
>  * kernel memory) to user-space.
>  */
> 
> If we neglect this risk and do changes like
> -       swiotlb_bounce(dev, tlb_addr, mapping_size, DMA_TO_DEVICE);
> +       if (dir != DMA_FROM_DEVICE)
> +               swiotlb_bounce(dev, tlb_addr, mapping_size, DMA_TO_DEVICE);
> 
> the issue of pages read before written from guest kernel just went away.
> 
> I don't think it's a swiotlb bug, because to prevent leaking swiotlb
> content, if target page content is not copied firstly to the swiotlb's
> bounce buffer, then the bounce buffer needs to be initialized to 0.
> However, swiotlb_tbl_map_single() does not know whether the target page
> is initialized or not. Then, it would cause page content to be trimmed
> if device does not overwrite the entire memory.

The math doesn't add up though.  Observing a read-before-write means the intended
goal of preventing data leaks to userspace is not being met.  I.e. instead of
leaking old swiotlb, the kernel is (theoretically) leaking whatever data is in the
original page (page cache in your case).

That data *may* be completely uninitialized, especially during boot, but the
original pages may also contain data from whatever was using the pages before they
were allocated by the driver.

It's possible the read of uninitialized data is observed only when either the
driver that triggered the mapping _knows_ that the device will overwrite the entire
mapping, or the driver will consume only the written parts.  But in those cases,
copying from the original memory is completely pointless.

If neither of the above holds true, then copying from the original adds value only
if preserving the data is necessary for functional correctness, or the driver
explicitly initialized the original memory.  Given that preserving source data was
recently added, I highly doubt it's necessary for functional correctness.

And if the driver *doesn't* initialize the data, then the copy is at best pointless,
and possibly even worse than leaking stale swiotlb data.

Looking at commit ddbd89deb7d3 ("swiotlb: fix info leak with DMA_FROM_DEVICE"),
IIUC the data leak was observed with a synthetic test "driver" that was developed
to verify a real data leak fixed by commit a45b599ad808 ("scsi: sg: allocate with
__GFP_ZERO in sg_build_indirect()").  Which basically proves my point: copying
from the source only adds value absent a bug in the owning driver.

IMO, rather than copying from the original memory, swiotlb_tbl_map_single() should
simply zero the original page(s) when establishing the mapping.  That would harden
all usage of swiotlb and avoid the read-before-write behavior that is problematic
for KVM.
