Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D08031D1AC
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 21:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhBPUkt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 15:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbhBPUks (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Feb 2021 15:40:48 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91DF2C061574
        for <kvm@vger.kernel.org>; Tue, 16 Feb 2021 12:40:07 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id o3so11765109edv.4
        for <kvm@vger.kernel.org>; Tue, 16 Feb 2021 12:40:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qsbkrWZGkD91kMd27lJYVWXYLDx45J5nDBTki3Poz/Y=;
        b=GYlUAEcxf+YrKRO9EV5o4/Z+28j3rfdzii+w6iCzZUbQExjtVDl60KciVFUspFaevd
         xQSimjJ/cKCSAjpA2c6+1IwGP+b9RsJeFUgaGgIQI9CHFXTR045ViXPxwRMKJbmKzBsQ
         dAYOvturlAhwMrFBnspAhiHq5WWA2Hkdic64X8Rcert/bP/eE1q1Jv7U4+KFDK5bEbTc
         /CSI3/tdjWwHApgQq7qDVuwhFwQXKrhmaTsx+j7jU6+/8SJ3r9U8+h3wqTu3CVO4gC9b
         /RRgmqX0ARNglqqE3GjZ6Ihebj0PnyzmcQHZB0bQ0S4W5F+0TaIpoP+exgxw3GtFqYl4
         am7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qsbkrWZGkD91kMd27lJYVWXYLDx45J5nDBTki3Poz/Y=;
        b=X5UJS9I1oNYgo7DHoHfG37UGHtzSsEz7uMUwEqfe9QFHNKH01h9m4sJuKLHtib8XGv
         yTVFu70GNFTl+lxn18+at6clLeZoj82DYUQL2t3roCUI4z53O7Ms2xT5ridIG1Fki8Df
         k6J4AVWSuz44AfAeNYdYDvWiOoHAl243Ku145P1z4zEziz5bQgJUF6DEore564262rzT
         LkFmJwwx6gBmji54wlNYV0UY+kpd7JPC4q1MwxmiAoftLJcYkto/MxZJ9y8rWkQZrSFV
         KtqWDcgrC5NID64W9Vlw9sXOB3FJCcZogBP3Dm4tuajoUnj60RDUbfBUX5TH/Vq2D2Hc
         Iadg==
X-Gm-Message-State: AOAM533pZYi098rZj06Iy2eSP67LNCDkh7IRRISJNbvInEX5CMNVNyr2
        JgJ9d8JVphcNbIRceoa6e86beBYtSJaxd3OrHzyZWg==
X-Google-Smtp-Source: ABdhPJzItTBAgOKzcio391IOuVIAv/Zadl6m2XXBki/3fUYt940zA/MAddwv1fJXGyV5MfPeAf92HQRO8cYR7bKO5J8=
X-Received: by 2002:a05:6402:559:: with SMTP id i25mr15504185edx.300.1613508006214;
 Tue, 16 Feb 2021 12:40:06 -0800 (PST)
MIME-Version: 1.0
References: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
 <161255840486.339900.5478922203128287192.stgit@djiang5-desk3.ch.intel.com>
 <20210210235924.GJ4247@nvidia.com> <8ff16d76-6b36-0da6-03ee-aebec2d1a731@intel.com>
In-Reply-To: <8ff16d76-6b36-0da6-03ee-aebec2d1a731@intel.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 16 Feb 2021 12:39:56 -0800
Message-ID: <CAPcyv4jDmofa+77q_hG1EimaKxq2_hYu-kVOVbU4mN4XSdOUWA@mail.gmail.com>
Subject: Re: [PATCH v5 05/14] vfio/mdev: idxd: add basic mdev registration and
 helper functions
To:     Dave Jiang <dave.jiang@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kwankhede@nvidia.com, Thomas Gleixner <tglx@linutronix.de>,
        Vinod Koul <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>, Yi L Liu <yi.l.liu@intel.com>,
        Baolu Lu <baolu.lu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Sanjay K Kumar <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>, eric.auger@redhat.com,
        Parav Pandit <parav@mellanox.com>, netanelg@mellanox.com,
        shahafs@mellanox.com, Paolo Bonzini <pbonzini@redhat.com>,
        dmaengine@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 16, 2021 at 11:05 AM Dave Jiang <dave.jiang@intel.com> wrote:
>
>
> On 2/10/2021 4:59 PM, Jason Gunthorpe wrote:
> > On Fri, Feb 05, 2021 at 01:53:24PM -0700, Dave Jiang wrote:
> >
> >> +static int check_vma(struct idxd_wq *wq, struct vm_area_struct *vma)
> >>   {
> >> -    /* FIXME: Fill in later */
> >> +    if (vma->vm_end < vma->vm_start)
> >> +            return -EINVAL;
> > These checks are redundant
>
> Thanks. Will remove.
>
> >
> >> -static int idxd_mdev_host_release(struct idxd_device *idxd)
> >> +static int idxd_vdcm_mmap(struct mdev_device *mdev, struct vm_area_struct *vma)
> >> +{
> >> +    unsigned int wq_idx, rc;
> >> +    unsigned long req_size, pgoff = 0, offset;
> >> +    pgprot_t pg_prot;
> >> +    struct vdcm_idxd *vidxd = mdev_get_drvdata(mdev);
> >> +    struct idxd_wq *wq = vidxd->wq;
> >> +    struct idxd_device *idxd = vidxd->idxd;
> >> +    enum idxd_portal_prot virt_portal, phys_portal;
> >> +    phys_addr_t base = pci_resource_start(idxd->pdev, IDXD_WQ_BAR);
> >> +    struct device *dev = mdev_dev(mdev);
> >> +
> >> +    rc = check_vma(wq, vma);
> >> +    if (rc)
> >> +            return rc;
> >> +
> >> +    pg_prot = vma->vm_page_prot;
> >> +    req_size = vma->vm_end - vma->vm_start;
> >> +    vma->vm_flags |= VM_DONTCOPY;
> >> +
> >> +    offset = (vma->vm_pgoff << PAGE_SHIFT) &
> >> +             ((1ULL << VFIO_PCI_OFFSET_SHIFT) - 1);
> >> +
> >> +    wq_idx = offset >> (PAGE_SHIFT + 2);
> >> +    if (wq_idx >= 1) {
> >> +            dev_err(dev, "mapping invalid wq %d off %lx\n",
> >> +                    wq_idx, offset);
> >> +            return -EINVAL;
> >> +    }
> >> +
> >> +    /*
> >> +     * Check and see if the guest wants to map to the limited or unlimited portal.
> >> +     * The driver will allow mapping to unlimited portal only if the the wq is a
> >> +     * dedicated wq. Otherwise, it goes to limited.
> >> +     */
> >> +    virt_portal = ((offset >> PAGE_SHIFT) & 0x3) == 1;
> >> +    phys_portal = IDXD_PORTAL_LIMITED;
> >> +    if (virt_portal == IDXD_PORTAL_UNLIMITED && wq_dedicated(wq))
> >> +            phys_portal = IDXD_PORTAL_UNLIMITED;
> >> +
> >> +    /* We always map IMS portals to the guest */
> >> +    pgoff = (base + idxd_get_wq_portal_full_offset(wq->id, phys_portal,
> >> +                                                   IDXD_IRQ_IMS)) >> PAGE_SHIFT;
> >> +    dev_dbg(dev, "mmap %lx %lx %lx %lx\n", vma->vm_start, pgoff, req_size,
> >> +            pgprot_val(pg_prot));
> >> +    vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> >> +    vma->vm_private_data = mdev;
> > What ensures the mdev pointer is valid strictly longer than the VMA?
> > This needs refcounting.
>
> Going to take a kref at open and then put_device at close. Does that
> sound reasonable or should I be calling get_device() in mmap() and then
> register a notifier for when vma is released?

Where does this enabling ever look at vm_private_data again? It seems
to me it should be reasonable for the mdev to die out from underneath
a vma, just need some tracking to block future uses of the
vma->vm_private_data from being attempted.
