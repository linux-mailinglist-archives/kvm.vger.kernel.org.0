Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBF47546A66
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 18:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344640AbiFJQce (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 12:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240625AbiFJQcd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 12:32:33 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 51E9A56B08
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 09:32:28 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D881612FC;
        Fri, 10 Jun 2022 09:32:27 -0700 (PDT)
Received: from myrica (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9CDBC3F73B;
        Fri, 10 Jun 2022 09:32:26 -0700 (PDT)
Date:   Fri, 10 Jun 2022 17:31:58 +0100
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
To:     Will Deacon <will@kernel.org>
Cc:     Andre Przywara <Andre.Przywara@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>
Subject: Re: [PATCH kvmtool 00/24] Virtio v1 support
Message-ID: <YqNx/lW+avOlv1Mf@myrica>
References: <20220607170239.120084-1-jean-philippe.brucker@arm.com>
 <20220609123948.GA2599@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220609123948.GA2599@willie-the-truck>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 09, 2022 at 01:39:48PM +0100, Will Deacon wrote:
> On Tue, Jun 07, 2022 at 06:02:15PM +0100, Jean-Philippe Brucker wrote:
> > Add support for version 1 of the virtio transport to kvmtool. Based on a
> > RFC by Sasha Levin [1], I've been trying to complete it here and there.
> > It's long overdue and is quite painful to rebase, so let's get it
> > merged.
> >
> > Several reasons why the legacy transport needs to be replaced:
> >
> > * Only 32 feature bits are supported. Most importantly
> >   VIRTIO_F_ACCESS_PLATFORM, which forces a Linux guest to use the DMA
> >   API, cannot be enabled. So we can't support private guests that
> >   decrypt or share only their DMA memory with the host.
> 
> Woohoo!
> 
> > * Legacy virtqueue address is a 32-bit pfn, aligned on 4kB. Since Linux
> >   guests bypass the DMA API they can't support large GPAs.
> >
> > * New devices types (iommu, crypto, memory, etc) and new features cannot
> >   be supported.
> >
> > * New guests won't implement the legacy transport. Existing guests will
> >   eventually drop legacy support.
> >
> > Support for modern transport becomes the default and legacy is enabled
> > with --virtio-legacy.
> >
> > I only tested what I could: vsock, scsi and vhost-net are currently
> > broken and can be fixed later (they have issues with mem regions and
> > feature mask, among other things). I also haven't tested big-endian.
> 
> If these are broken, then shall we default to legacy mode and have the
> modern transport be opt-in? Otherwise we're regressing people in a
> confusing way.

What I meant was that even without these patches, I wasn't able to use any
of the vhost devices, they already had several bugs. But now that I spent
a little more time trying to fix them, it looks like the modern transport
does add one regression (vhost ioeventfd is set on I/O port but modern
transport uses MMIO).

I'll sort this out and resend. Thanks for picking up the base patches!

Thanks,
Jean
