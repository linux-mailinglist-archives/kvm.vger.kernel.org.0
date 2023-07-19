Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C672759EAE
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 21:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbjGSTdC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 15:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjGSTcv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 15:32:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB89B1FE6;
        Wed, 19 Jul 2023 12:32:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C49261804;
        Wed, 19 Jul 2023 19:32:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCAE6C433C9;
        Wed, 19 Jul 2023 19:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689795164;
        bh=hZI4hitD39aZ+Qdl1lmi9pA61QSLLLHm+XV9ADPTsus=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=eQXfqj+zST5V+UqVLxrOjyGA+WFrIALYwsndDf8yb+d/ZcAhNbmKZDq169VZaA9sf
         25+bBsBNSvp0yYQUkVL2vtrX8ooa/xyi+l+HGRTJ1LyPinE1QFLpb5R0Cg36sW3qNn
         YgZrsKi4oHpxkgHsNexLn2gxv7Eeh2OoajZB5APtfPQ+10fXyIgjl2R3+z+WXlvO86
         Qn893HS/fbI8ZKTtw08zvDfUMSHa1Fv8E+7oGp9QKbDJfH1c2kWXr4T2FGBMg+JkXS
         oxjrRjZ46Nr7EXvdUaNgc1xypDfdpbsWW38ebY+nmePmjVTAwUQssX3tnWVYHKKP77
         X9BK/nT/OlPNA==
Date:   Wed, 19 Jul 2023 14:32:41 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Sui Jingfeng <sui.jingfeng@linux.dev>
Cc:     David Airlie <airlied@gmail.com>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-fbdev@vger.kernel.org,
        Sui Jingfeng <suijingfeng@loongson.cn>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 0/9] PCI/VGA: Improve the default VGA device selection
Message-ID: <20230719193241.GA510805@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230711164310.791756-1-sui.jingfeng@linux.dev>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[+cc linux-pci]

On Wed, Jul 12, 2023 at 12:43:01AM +0800, Sui Jingfeng wrote:
> From: Sui Jingfeng <suijingfeng@loongson.cn>
> 
> Currently, the default VGA device selection is not perfect. Potential
> problems are:
> 
> 1) This function is a no-op on non-x86 architectures.
> 2) It does not take the PCI Bar may get relocated into consideration.
> 3) It is not effective for the PCI device without a dedicated VRAM Bar.
> 4) It is device-agnostic, thus it has to waste the effort to iterate all
>    of the PCI Bar to find the VRAM aperture.
> 5) It has invented lots of methods to determine which one is the default
>    boot device on a multiple video card coexistence system. But this is
>    still a policy because it doesn't give the user a choice to override.
> 
> With the observation that device drivers or video aperture helpers may
> have better knowledge about which PCI bar contains the firmware FB,
> 
> This patch tries to solve the above problems by introducing a function
> callback to the vga_client_register() function interface. DRM device
> drivers for the PCI device need to register the is_boot_device() function
> callback during the driver loading time. Once the driver binds the device
> successfully, VRAARB will call back to the driver. This gives the device
> drivers a chance to provide accurate boot device identification. Which in
> turn unlock the abitration service to non-x86 architectures. A device
> driver can also pass a NULL pointer to keep the original behavior.

I skimmed all these patches, but the only one that seems to mention an
actual problem being solved, i.e., something that doesn't work for an
end user, is "drm/ast: Register as a vga client ..."  Maybe
"drm/loongson: Add an implement for ..." also solves a problem, but it
lacks a commit log, so I don't know what the problem is.

In the future, can you please cc: linux-pci with the entire series?
In this posting, only the patches that touched drivers/pci/vgaarb.c
went to linux-pci, but those aren't enough to make sense of the series
as a whole.

>   video/aperture: Add a helper to detect if an aperture contains
>     firmware FB
>   video/aperture: Add a helper for determining if an unmoved aperture
>     contain FB
>   PCI/VGA: Switch to aperture_contain_firmware_fb_nonreloc()

Since this subject includes the function name (which is nice!), it
would also be helpful if the "Add a helper ..." subject included the
same function name.

>   PCI/VGA: Improve the default VGA device selection

If you can make this subject any more specific, that would be useful.
There's more to say about that patch, so I'll respond there.

>   drm/amdgpu: Implement the is_primary_gpu callback of
>     vga_client_register()
>   drm/radeon: Add an implement for the is_primary_gpu function callback
>   drm/i915: Add an implement for the is_primary_gpu hook
>   drm/ast: Register as a vga client to vgaarb by calling
>     vga_client_register()
>   drm/loongson: Add an implement for the is_primary_gpu function
>     callback

There's unnecessary variation in the subject lines (and the commit
logs) of these patches.  If they all do the same thing but in
different drivers, it's useful if the patches all *look* the same.

You might be able to write these subjects as
"Implement .is_primary_gpu() callback" for brevity.

Bjorn
