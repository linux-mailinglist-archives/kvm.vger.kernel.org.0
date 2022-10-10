Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35DFF5F99D7
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 09:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232106AbiJJHR4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 03:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbiJJHR3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 03:17:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E42E60503
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 00:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ULxnTo/ejBNX95cLu/E+hk81uQQ+3j2U/gQuYNziL2k=; b=WW/36KLIunVp6LVN2dsVz2Yx39
        XDAMSrJhtUziCYpCidSIBZxDXzgyLZoYULSc2NGuLzspNI41wXHasMylEtrSintKP3W1y0Mssk2ds
        rQpJVMwd/PbD6eGxqR2Vm4ePvhXMO7DUwi+6INlK6bIhiQTmxkL//I1tm9VGT8FwI8M6Zl+T2P6O7
        /hDA3xLQIGB3LgiZsVcskuSC6OcFfBpQdbCVU2g1t4HklMLp+UHYb+bEG1eCuBjEqEYQG8pYESReN
        doKH/0lJHvP1xQahNpI8PWJr3GDXIA498yrdT47Febxeeo6lTSeFiwOtwKrBedBVMcDDBCHuxPerK
        XgsMWprQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ohmul-00HKjE-NJ; Mon, 10 Oct 2022 07:09:27 +0000
Date:   Mon, 10 Oct 2022 00:09:27 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/4] vfio: Move vfio_spapr_iommu_eeh_ioctl into
 vfio_iommu_spapr_tce.c
Message-ID: <Y0PFJwIlaeJY0nSe@infradead.org>
References: <0-v2-18daead6a41e+98-vfio_modules_jgg@nvidia.com>
 <2-v2-18daead6a41e+98-vfio_modules_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2-v2-18daead6a41e+98-vfio_modules_jgg@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 03, 2022 at 12:39:31PM -0300, Jason Gunthorpe wrote:
> So we don't need to worry about the fact that asm/eeh.h doesn't define
> enough stuff to compile vfio_spapr_iommu_eeh_ioctl() in !CONFIG_EEH. If
> someday someone changes the kconfig around they can also fix the ifdefs in
> asm/eeh.h to compile this code too.

Please just break it up by opencoding the VFIO_CHECK_EXTENSION
cases and just having a helper for VFIO_EEH_PE_OP.  I could look
for my patch doing that but again it should be trivial to redo.
