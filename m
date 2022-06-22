Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCB3554C04
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 16:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354653AbiFVOBj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 10:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234575AbiFVOBi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 10:01:38 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6DC6369E2;
        Wed, 22 Jun 2022 07:01:37 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 83EF221C18;
        Wed, 22 Jun 2022 14:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655906496; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=YUedw22uTonupl5S/QuQDfVjYG8TUjcgcNCTZyOGnGE=;
        b=ZJpLVCcp3pQ+pNJiwsh0FsMhcXDcJWNOu73JOqO+um4z3crgtaMcEtIAETajwojd6MS48H
        DqWAILnUWNje2m+SZqpwueDpfbR0JpKrzoETnksDa3zcGXWnvuCHEZC93NJkDUjJ5NbunZ
        FT9lCISK233TJHx2C9L4aSvv2Gqn/YM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655906496;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=YUedw22uTonupl5S/QuQDfVjYG8TUjcgcNCTZyOGnGE=;
        b=esfq23hcixQZ1wWVeJjTN87GXtpefgt1iutwZJocxJ22QJRRUWVHEaxVFoqKHRbTmi7vex
        8e3F+6Sw5P0EpgAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 34A2B134A9;
        Wed, 22 Jun 2022 14:01:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id eezhC8Ags2IVRwAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Wed, 22 Jun 2022 14:01:36 +0000
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     alex.williamson@redhat.com, corbet@lwn.net,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        airlied@linux.ie, daniel@ffwll.ch, deller@gmx.de,
        gregkh@linuxfoundation.org, javierm@redhat.com, lersek@redhat.com,
        kraxel@redhat.com
Cc:     linux-doc@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH v3 0/3] Improve vfio-pci primary GPU assignment behavior
Date:   Wed, 22 Jun 2022 16:01:31 +0200
Message-Id: <20220622140134.12763-1-tzimmermann@suse.de>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

(I'm taking over this patchset from Alex, [1] as we agreed that it should
go through the drm-misc tree.)

When assigning a primary graphics device to VM through vfio-pci device
assignment, users often prevent binding of the native PCI graphics
driver to avoid device initialization conflicts, however firmware
console drivers may still be attached to the device which can often be
cumbersome to manually unbind or exclude via cmdline options.

This series proposes to move the DRM aperture helpers out to
drivers/video/ to make it more accessible to drivers like vfio-pci,
which have neither dependencies on DRM code nor a struct drm_driver
to present to existing interfaces.  vfio-pci can then trivially call
into the aperture helpers to remove conflicting drivers, rather than
open coding it ourselves as was proposed with a new symbol export in
v1 of this series. [2]

v3:
	* add aperture_ prefix to all interfaces (Javier)
	* improved documentation (Javier)
	* update MAINTAINERS [3] and add aperture helpers

[1] https://lore.kernel.org/all/165541020563.1955826.16350888595945658159.stgit@omen/
[2] https://lore.kernel.org/all/165453797543.3592816.6381793341352595461.stgit@omen/
[3] https://lore.kernel.org/all/20220518183006.14548-2-tzimmermann@suse.de/

Alex Williamson (1):
  vfio/pci: Remove console drivers

Thomas Zimmermann (2):
  MAINTAINERS: Broaden scope of simpledrm entry
  drm: Implement DRM aperture helpers under video/

 Documentation/driver-api/aperture.rst |  13 +
 Documentation/driver-api/index.rst    |   1 +
 MAINTAINERS                           |   6 +-
 drivers/gpu/drm/drm_aperture.c        | 178 +------------
 drivers/gpu/drm/tiny/Kconfig          |   1 +
 drivers/vfio/pci/vfio_pci_core.c      |   5 +
 drivers/video/Kconfig                 |   6 +
 drivers/video/Makefile                |   2 +
 drivers/video/aperture.c              | 351 ++++++++++++++++++++++++++
 drivers/video/console/Kconfig         |   1 +
 drivers/video/fbdev/Kconfig           |   7 +-
 include/linux/aperture.h              |  56 ++++
 12 files changed, 456 insertions(+), 171 deletions(-)
 create mode 100644 Documentation/driver-api/aperture.rst
 create mode 100644 drivers/video/aperture.c
 create mode 100644 include/linux/aperture.h


base-commit: 7025c1f111b7a057243de45bd56c14b906242a53
-- 
2.36.1

