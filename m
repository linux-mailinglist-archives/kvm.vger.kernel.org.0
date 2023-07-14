Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3092C7532B7
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 09:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235278AbjGNHNq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 03:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235268AbjGNHNo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 03:13:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA7AD26BC;
        Fri, 14 Jul 2023 00:13:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A90461C31;
        Fri, 14 Jul 2023 07:13:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46118C433C9;
        Fri, 14 Jul 2023 07:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689318813;
        bh=yxMZs+zIPg/nbSwHmzMT15oL30VbrmEltq+sX79aaIo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RtZ05w9jFT2zJahoc8Fl0q6Tbr7+eCrILqdKV32hu/Yp/HOkhl1rmP0Mrld49oocp
         NJiUSSqRTiTtUpSCudcTvsZmGI8Z1G9rON6CR2DwY/3OxnZTT+OVgUvj1b4olTBK2S
         FocQskhn1LgqA/B3CiyFv+DDnXpizYJAqI3GZrX3fUtJZz0CN9Mb7gvxhtW/JjuZGQ
         zxH07tV525TY9xjl50otKouq9A04O1CTZSuC9Uk7MP7f8KRtLuS/19EYJ1sTFYOg+q
         h6kkYmkbzLJfmy+17YFzswMFmRgz9x6Nzsx6AUBzbkjtvOb6Jx5Axd3RZ+KLGW7fvE
         WNV48vn7iiebA==
Date:   Fri, 14 Jul 2023 09:13:27 +0200
From:   Lorenzo Pieralisi <lpieralisi@kernel.org>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        alex.williamson@redhat.com, osamaabb@amazon.com,
        linux-pci@vger.kernel.org, Clint Sbisa <csbisa@amazon.com>,
        catalin.marinas@arm.com, jgg@nvidia.com, maz@kernel.org
Subject: Re: VFIO (PCI) and write combine mapping of BARs
Message-ID: <ZLD1l1274hQQ54RT@lpieralisi>
References: <2838d716b08c78ed24fdd3fe392e21222ee70067.camel@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2838d716b08c78ed24fdd3fe392e21222ee70067.camel@kernel.crashing.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[+Catalin, Marc, Jason]

On Fri, Jul 14, 2023 at 12:32:49PM +1000, Benjamin Herrenschmidt wrote:
> Hi Folks !
> 
> I'd like to revive an old discussion as we (Amazon Linux) have been
> getting asks for it.
> 
> What's the best interface to provide the option of write combine mmap's
> of BARs via VFIO ?

There is an ongoing thread on this topic that we should use to
bring this discussion to completion:

https://lore.kernel.org/linux-arm-kernel/ZHcxHbCb439I1Uk2@arm.com
> 
> The problem isn't so much the low level implementation, we just have to
> play with the pgprot, the question is more around what API to present
> to control this.
> 
> One trivial way would be to have an ioctl to set a flag for a given
> region/BAR that cause subsequent mmap's to use write-combine. We would
> have to keep a bitmap for the "legacy" regions, and use a flag in
> struct vfio_pci_region for the others.
> 
> One potentially better way is to make it strictly an attribute of
> vfio_pci_region, along with an ioctl that creates a "subregion". The
> idea here is that we would have an ioctl to create a region from an
> existing region dynamically, which represents a subset of the original
> region (typically a BAR), with potentially different attributes (or we
> keep the attribute get/set separate).
> 
> I like the latter more because it will allow to more easily define that
> portions of a BAR can need different attributes without causing
> state/race issues between setting the attribute and mmap.
> 
> This will also enable other attributes than write-combine if/when the
> need arises.
> 
> Any better idea ? thoughs ? objections ?
> 
> This is still quite specific to PCI, but so is the entire regions
> mechanism, so I don't see an easy path to something more generic at
> this stage.
> 
> Cheers,
> Ben.
> 
