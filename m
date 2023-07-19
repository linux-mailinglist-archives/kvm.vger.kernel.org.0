Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D56675A019
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 22:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbjGSUny (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 16:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbjGSUnw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 16:43:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6370B1FED;
        Wed, 19 Jul 2023 13:43:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E145A61807;
        Wed, 19 Jul 2023 20:43:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2564EC433C8;
        Wed, 19 Jul 2023 20:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689799425;
        bh=tjOjdSqSd3UKBynevaKWHcXD+EhI+M4v0jnzU2q7Kcs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=hoIuUAXNfvO3M5AutVXnVrVmIL15s0aDDjv5sTYY7QwPsMEjGwZYCwvmBAa1rSdaJ
         G23BZB20qaA1vwMkix+TGC8n2/pi7HmJ+ZjiqlswwHNDjrvqGJIjGUmzzmFP8u0tCV
         h///K7shd6BCvmJ66/CeMedszQb9KNLBPSUv10r+Dw2aDdcvCh6njSJVvvDh5tMYUB
         4fGyuwhn/0YJTytmhTSd/vJGtvF21ZcrrmIJfO4sQrwpRWfpo5JoVtjNfk66WxLXUc
         L24L1XsaP0Gnnmk31klc/45lESRc+Lky137WSqVbg/grtvs+05Ntx1wsjylkjwtxri
         q+znIJLt8j6Tg==
Date:   Wed, 19 Jul 2023 15:43:43 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Sui Jingfeng <sui.jingfeng@linux.dev>
Cc:     David Airlie <airlied@gmail.com>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-fbdev@vger.kernel.org,
        Sui Jingfeng <suijingfeng@loongson.cn>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Helge Deller <deller@gmx.de>
Subject: Re: [PATCH v3 1/9] video/aperture: Add a helper to detect if an
 aperture contains firmware FB
Message-ID: <20230719204343.GA513226@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230711164310.791756-2-sui.jingfeng@linux.dev>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 12, 2023 at 12:43:02AM +0800, Sui Jingfeng wrote:
> From: Sui Jingfeng <suijingfeng@loongson.cn>
> 
> This patch adds the aperture_contain_firmware_fb() function to do the
> determination. Unfortunately, due to the fact that the apertures list
> will be freed dynamically, the location and size information of the
> firmware FB will be lost after dedicated drivers call
> aperture_remove_conflicting_devices(),
> aperture_remove_conflicting_pci_devices() or
> aperture_remove_all_conflicting_devices() functions

> We solve this problem by introducing two static variables that record the
> firmware framebuffer's start addrness and end addrness. It assumes that the
> system has only one active firmware framebuffer driver at a time. We don't
> use the global structure screen_info here, because PCI resources may get
> reallocated (the VRAM BAR could be moved) during the kernel boot stage.

s/addrness/address/ (twice)
