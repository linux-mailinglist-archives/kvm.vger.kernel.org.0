Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA80B72D7D3
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 05:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239374AbjFMDEG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 23:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239650AbjFMDDp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 23:03:45 -0400
Received: from 189.cn (ptr.189.cn [183.61.185.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5E8433AA9;
        Mon, 12 Jun 2023 20:02:27 -0700 (PDT)
HMM_SOURCE_IP: 10.64.8.43:47948.1267835893
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-114.242.206.180 (unknown [10.64.8.43])
        by 189.cn (HERMES) with SMTP id CFD121002CE;
        Tue, 13 Jun 2023 11:01:53 +0800 (CST)
Received: from  ([114.242.206.180])
        by gateway-151646-dep-75648544bd-7vx9t with ESMTP id 959ce8b3422a4ec298e3af6accf345e8 for bhelgaas@google.com;
        Tue, 13 Jun 2023 11:01:54 CST
X-Transaction-ID: 959ce8b3422a4ec298e3af6accf345e8
X-Real-From: 15330273260@189.cn
X-Receive-IP: 114.242.206.180
X-MEDUSA-Status: 0
Sender: 15330273260@189.cn
From:   Sui Jingfeng <15330273260@189.cn>
To:     Bjorn Helgaas <bhelgaas@google.com>
Cc:     amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: [PATCH v7 0/8] PCI/VGA: Introduce is_boot_device function callback to vga_client_register
Date:   Tue, 13 Jun 2023 11:01:43 +0800
Message-Id: <20230613030151.216625-1-15330273260@189.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FROM_LOCAL_DIGITS,
        FROM_LOCAL_HEX,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vga_is_firmware_default() function is arch-dependent, it's probably
wrong if we simply remove the arch guard. As the VRAM BAR which contains
firmware framebuffer may move, while the lfb_base and lfb_size members of
the screen_info does not change accordingly. In short, it should take the
re-allocation of the PCI BAR into consideration.

With the observation that device drivers or video aperture helpers may
have better knowledge about which PCI bar contains the firmware fb,
which could avoid the need to iterate all of the PCI BARs. But as a PCI
function at pci/vgaarb.c, vga_is_firmware_default() is not suitable to
make such an optimization since it is loaded too early.

There are PCI display controllers that don't have a dedicated VRAM bar,
this function will lose its effectiveness in such a case. Luckily, the
device driver can provide an accurate workaround.

Therefore, this patch introduces a callback that allows the device driver
to tell the VGAARB if the device is the default boot device. Also honor
the comment: "Clients have two callback mechanisms they can use"

Sui Jingfeng (8):
  PCI/VGA: Use unsigned type for the io_state variable
  PCI/VGA: Deal only with VGA class devices
  PCI/VGA: Tidy up the code and comment format
  PCI/VGA: Replace full MIT license text with SPDX identifier
  video/aperture: Add a helper to detect if an aperture contains
    firmware FB
  PCI/VGA: Introduce is_boot_device function callback to
    vga_client_register
  drm/amdgpu: Implement the is_boot_device callback function
  drm/radeon: Implement the is_boot_device callback function

 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |  12 +-
 drivers/gpu/drm/drm_aperture.c             |  16 +++
 drivers/gpu/drm/i915/display/intel_vga.c   |   3 +-
 drivers/gpu/drm/nouveau/nouveau_vga.c      |   2 +-
 drivers/gpu/drm/radeon/radeon_device.c     |  12 +-
 drivers/pci/vgaarb.c                       | 153 +++++++++++++--------
 drivers/vfio/pci/vfio_pci_core.c           |   2 +-
 drivers/video/aperture.c                   |  29 ++++
 include/drm/drm_aperture.h                 |   2 +
 include/linux/aperture.h                   |   7 +
 include/linux/vgaarb.h                     |  35 ++---
 11 files changed, 184 insertions(+), 89 deletions(-)

-- 
2.25.1

