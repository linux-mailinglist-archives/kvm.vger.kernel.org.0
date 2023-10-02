Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5478A7B5999
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 20:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238393AbjJBRx0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 13:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238619AbjJBRxY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 13:53:24 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E243FFF
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 10:53:20 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C52C433C8;
        Mon,  2 Oct 2023 17:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696269200;
        bh=iNML46xP65XC6ISNmO+ehHzGf5XVNd60+CDz49bWbSo=;
        h=From:Date:Subject:To:Cc:From;
        b=k2Fcjo2dXCk/kG1Iope32OBNxU8BJA8VfAycpsMzWbB6aRnZ9WomnOQdyQSD/I2rW
         Py79YM+Ugs8m2zhTgUJPuFPHaANmOMkFTsBOmZXMgmK38dchRIxWxtpZ+ia3va1+MH
         2MnfOKeK2z4lEjOrAgAMVFhc2x83YDvWw7u9oNKofFw7/bFJuPLWjEKovjh/qwM/TJ
         FPKZaz/TDQ5KRdGpgogK9ihlosXYIEqBj0cA45uZyd5MKVsPRJx3ktAGZ9QX7Us3dE
         z6eXguGrDkDwuaGjQpMaiBnNsue+HLXQxrzHi29XWe4y0Nk4g2ck7A0U3APF/RM/N1
         Xipt0yIiixGdQ==
From:   Nathan Chancellor <nathan@kernel.org>
Date:   Mon, 02 Oct 2023 10:53:13 -0700
Subject: [PATCH] vfio/cdx: Add parentheses between bitwise AND expression
 and logical NOT
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231002-vfio-cdx-logical-not-parentheses-v1-1-a8846c7adfb6@kernel.org>
X-B4-Tracking: v=1; b=H4sIAIgDG2UC/x3NMQqAMAxA0atIZgO1gopXEYfYphqQVhoRQby7x
 fEt/z+gnIUVxuqBzJeopFjQ1BW4jeLKKL4YrLFtY4zFK0hC52/c0yqOdozpxIMyx3NjZUVyNIT
 Fd4vtByiZI3OQ+19M8/t+IV6jxHIAAAA=
To:     nipun.gupta@amd.com, nikhil.agarwal@amd.com,
        alex.williamson@redhat.com
Cc:     ndesaulniers@google.com, trix@redhat.com, shubham.rohila@amd.com,
        kvm@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1912; i=nathan@kernel.org;
 h=from:subject:message-id; bh=iNML46xP65XC6ISNmO+ehHzGf5XVNd60+CDz49bWbSo=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDKnSzP0bGk59mG7IbX93jVXSkmjVBKYeNZmIFGFjDq0Dv
 j+thDI7SlkYxDgYZMUUWaofqx43NJxzlvHGqUkwc1iZQIYwcHEKwEQ0njL8s3kwYVp+xr3UM2u9
 Yw5Hpx/iqmqtuegZLGi2e8nPrM1B2xgZblqduyV9Zvl+zjlTf76JT0kLn9HGqOst9cZ36zzhw5k
 WXAA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When building with clang, there is a warning (or error with
CONFIG_WERROR=y) due to a bitwise AND and logical NOT in
vfio_cdx_bm_ctrl():

  drivers/vfio/cdx/main.c:77:6: error: logical not is only applied to the left hand side of this bitwise operator [-Werror,-Wlogical-not-parentheses]
     77 |         if (!vdev->flags & BME_SUPPORT)
        |             ^            ~
  drivers/vfio/cdx/main.c:77:6: note: add parentheses after the '!' to evaluate the bitwise operator first
     77 |         if (!vdev->flags & BME_SUPPORT)
        |             ^
        |              (                        )
  drivers/vfio/cdx/main.c:77:6: note: add parentheses around left hand side expression to silence this warning
     77 |         if (!vdev->flags & BME_SUPPORT)
        |             ^
        |             (           )
  1 error generated.

Add the parentheses as suggested in the first note, which is clearly
what was intended here.

Closes: https://github.com/ClangBuiltLinux/linux/issues/1939
Fixes: 8a97ab9b8b31 ("vfio-cdx: add bus mastering device feature support")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/vfio/cdx/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/cdx/main.c b/drivers/vfio/cdx/main.c
index a437630be354..a63744302b5e 100644
--- a/drivers/vfio/cdx/main.c
+++ b/drivers/vfio/cdx/main.c
@@ -74,7 +74,7 @@ static int vfio_cdx_bm_ctrl(struct vfio_device *core_vdev, u32 flags,
 	struct vfio_device_feature_bus_master ops;
 	int ret;
 
-	if (!vdev->flags & BME_SUPPORT)
+	if (!(vdev->flags & BME_SUPPORT))
 		return -ENOTTY;
 
 	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_SET,

---
base-commit: fcb2f2ed4a80cfe383d87da75caba958516507e9
change-id: 20231002-vfio-cdx-logical-not-parentheses-aca8fbd6b278

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

