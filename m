Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8727674F53F
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 18:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbjGKQcW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 12:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbjGKQcT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 12:32:19 -0400
Received: from out-39.mta0.migadu.com (out-39.mta0.migadu.com [91.218.175.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4891D10C2
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 09:32:15 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689093133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=AOe2sK5corMJVr8s18spKTEHFO7S6COQNSRgsjkc54A=;
        b=ixKAhLu28/nq1vazDkLtGsR/XEiVHt1ra2tNTmdDLo9BPHekHQ7OViZ9PZCadSk3DSxHL1
        6Md7s5pSxG/rbDPk5WiAXKGCJ9q1jxF9DVPaEOAcGbdFMUXTFAqhY+mtay7NocxBghXDdE
        nl8Q8HRCQmWsB+O7po7KrEn9IlnkOKE=
From:   Sui Jingfeng <sui.jingfeng@linux.dev>
To:     Alex Deucher <alexander.deucher@amd.com>,
        Christian Koenig <christian.koenig@amd.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Jocelyn Falempe <jfalempe@redhat.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Maxime Ripard <mripard@kernel.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Ben Skeggs <bskeggs@redhat.com>, Lyude Paul <lyude@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Helge Deller <deller@gmx.de>,
        Mario Limonciello <mario.limonciello@amd.com>
Cc:     amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Sui Jingfeng <suijingfeng@loongson.cn>
Subject: [PATCH v3 0/9] PCI/VGA: Improve the default VGA device selection
Date:   Wed, 12 Jul 2023 00:31:46 +0800
Message-Id: <20230711163155.791522-1-sui.jingfeng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sui Jingfeng <suijingfeng@loongson.cn>

Currently, the default VGA device selection is not perfect. Potential
problems are:

1) This function is a no-op on non-x86 architectures.
2) It does not take the PCI Bar may get relocated into consideration.
3) It is not effective for the PCI device without a dedicated VRAM Bar.
4) It is device-agnostic, thus it has to waste the effort to iterate all
   of the PCI Bar to find the VRAM aperture.
5) It has invented lots of methods to determine which one is the default
   boot device on a multiple video card coexistence system. But this is
   still a policy because it doesn't give the user a choice to override.

With the observation that device drivers or video aperture helpers may
have better knowledge about which PCI bar contains the firmware FB,

This patch tries to solve the above problems by introducing a function
callback to the vga_client_register() function interface. DRM device
drivers for the PCI device need to register the is_boot_device() function
callback during the driver loading time. Once the driver binds the device
successfully, VRAARB will call back to the driver. This gives the device
drivers a chance to provide accurate boot device identification. Which in
turn unlock the abitration service to non-x86 architectures. A device
driver can also pass a NULL pointer to keep the original behavior.

This series is applied on the drm-tip branch (with a cleanup patch set[1]
applied beforehand)

[1] https://patchwork.freedesktop.org/series/120548/

v2:
	* Add a simple implemment for drm/i915 and drm/ast
	* Pick up all tags (Mario)
v3:
	* Fix a mistake for drm/i915 implement
	* Fix patch can not be applied problem because of drm/amdgpu merged
          other people's patch.

Sui Jingfeng (9):
  video/aperture: Add a helper to detect if an aperture contains
    firmware FB
  video/aperture: Add a helper for determining if an unmoved aperture
    contain FB
  PCI/VGA: Switch to aperture_contain_firmware_fb_nonreloc()
  PCI/VGA: Improve the default VGA device selection
  drm/amdgpu: Implement the is_primary_gpu callback of
    vga_client_register()
  drm/radeon: Add an implement for the is_primary_gpu function callback
  drm/i915: Add an implement for the is_primary_gpu hook
  drm/ast: Register as a vga client to vgaarb by calling
    vga_client_register()
  drm/loongson: Add an implement for the is_primary_gpu function
    callback

 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 12 +++-
 drivers/gpu/drm/ast/ast_drv.c              | 29 +++++++++
 drivers/gpu/drm/drm_aperture.c             | 16 +++++
 drivers/gpu/drm/i915/display/intel_vga.c   | 31 ++++++++-
 drivers/gpu/drm/loongson/lsdc_drv.c        | 10 ++-
 drivers/gpu/drm/nouveau/nouveau_vga.c      |  2 +-
 drivers/gpu/drm/radeon/radeon_device.c     | 12 +++-
 drivers/pci/vgaarb.c                       | 74 ++++++++++++++++------
 drivers/vfio/pci/vfio_pci_core.c           |  2 +-
 drivers/video/aperture.c                   | 65 +++++++++++++++++++
 include/drm/drm_aperture.h                 |  2 +
 include/linux/aperture.h                   | 14 ++++
 include/linux/vgaarb.h                     |  8 ++-
 13 files changed, 247 insertions(+), 30 deletions(-)

-- 
2.25.1

