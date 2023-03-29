Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF1E6CD916
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 14:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjC2MHA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 08:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjC2MGy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 08:06:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9378146BD
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 05:06:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A2E1B822EB
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 12:06:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EEC1C4339B;
        Wed, 29 Mar 2023 12:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680091589;
        bh=z4Ik417BImN4hbm49tiPZOdN2hV0HZEk1iVS2bs2Wto=;
        h=From:To:Cc:Subject:Date:From;
        b=WXrY3bdkpRzCYuhTI/uvKNA4+BoDlkrVWoO4UZ0T0PTus5/RESirL4G2tLrEmjmCR
         3623YXQr13CUSl9AT+4b2RFV5XISrmfuGvTKKPBz11KTyUXuwXGVo3l0galL3DzhZu
         vclgwILC03lB2psEt8guG8pHmLJJocvupEwZ1S/pvjxPWByKrLuigBBOKm8dNEakkO
         F6xXNg0VFxSgUBX+TtWuXKlleLXJamawJyf2yYByEddq0kZiuwNcX2iwrqpe6qX4WC
         3whdojbracyDox5G5HzhIwF8Vf6lwhrDXyOAjqPWoyNI0X7uipdewfga00sutmSIFr
         bkjjtjaK1E16g==
From:   Simon Horman <horms@kernel.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Simon Horman <horms@kernel.org>
Subject: [PATCH vfio] vfio: correct kdoc for ops structures
Date:   Wed, 29 Mar 2023 14:06:03 +0200
Message-Id: <20230329120603.468031-1-horms@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Address minor omissions from kdoc for ops structures flagged by check-kdoc:

  ./scripts/kernel-doc -Werror -none include/linux/vfio.h

  include/linux/vfio.h:114: warning: Function parameter or member 'name' not described in 'vfio_device_ops'
  include/linux/vfio.h:143: warning: Cannot understand  * @migration_set_state: Optional callback to change the migration state for
   on line 143 - I thought it was a doc line
  include/linux/vfio.h:168: warning: Cannot understand  * @log_start: Optional callback to ask the device start DMA logging.
   on line 168 - I thought it was a doc line

Signed-off-by: Simon Horman <horms@kernel.org>
---
 include/linux/vfio.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 93134b023968..cb46050045c0 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -68,6 +68,7 @@ struct vfio_device {
 /**
  * struct vfio_device_ops - VFIO bus driver device callbacks
  *
+ * @name: Name of the device driver.
  * @init: initialize private fields in device structure
  * @release: Reclaim private fields in device structure
  * @bind_iommufd: Called when binding the device to an iommufd
@@ -140,6 +141,8 @@ int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id);
 #endif
 
 /**
+ * struct vfio_migration_ops - VFIO bus device driver migration callbacks
+ *
  * @migration_set_state: Optional callback to change the migration state for
  *         devices that support migration. It's mandatory for
  *         VFIO_DEVICE_FEATURE_MIGRATION migration support.
@@ -165,6 +168,8 @@ struct vfio_migration_ops {
 };
 
 /**
+ * struct vfio_log_ops - VFIO bus device driver logging callbacks
+ *
  * @log_start: Optional callback to ask the device start DMA logging.
  * @log_stop: Optional callback to ask the device stop DMA logging.
  * @log_read_and_clear: Optional callback to ask the device read
-- 
2.30.2

