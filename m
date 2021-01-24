Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3673301D41
	for <lists+kvm@lfdr.de>; Sun, 24 Jan 2021 16:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbhAXPkX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Jan 2021 10:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726041AbhAXPkW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Jan 2021 10:40:22 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730C5C061573
        for <kvm@vger.kernel.org>; Sun, 24 Jan 2021 07:39:42 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id u14so8586885wmq.4
        for <kvm@vger.kernel.org>; Sun, 24 Jan 2021 07:39:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=ybdGXy7fYHQwxdAdxWWqKCMj1iRKZt4hZLcHd2KduIs=;
        b=BpoqF/fW+DGPpkUU/WoYjzgcmt8kZc/6VtAeV2Tnmpr4IaFaCyPVVm6sg7NIRFeXhx
         DrxEKtPbzF2qqj+24cu60NZt5qPz5xFddd+mTEPYqEXrhsDI2MmhnpDHCT1W1x7ehOS2
         ox4tylX3bNQNktOJoqyVbU9Nng8V26ha7Rq+zcRZiwWxyNu6NB/htv+u5KjrKyWTciho
         uvfWzibluPoPf3klW0Mn8OUca+pyexUcPKzNOt7Ab1Z26lLrp9MdR8utKDytMgfPQO3M
         FSXEUOA94x3lIplHcK0b8UY6QAL0lC0BE1jSuleGz3BtIMJIj3raV5v0c8P5/Gq71a8+
         zq1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=ybdGXy7fYHQwxdAdxWWqKCMj1iRKZt4hZLcHd2KduIs=;
        b=Vq3dEDIPpYEnW1tE8Y7b/c64vgYsdslg2PF1Uaq0lZrTrLFdGxWe87/ajjwfQS0GVU
         NPa1womOi2qdm9QS+C3XNe/6KZ9ghrU04Jn1crKytJSXXjRvSFBhEfGKGxZCO3hvSzea
         1O7fk8wR/iaSlJS9UykKoxao70ydIi8LC6ixPGoq/RYaDpwFVI9oHA7+3KorUwG92WAP
         1wRvtTPDawoxFQ2z1d6XQIi90tWCWKiSdjZJUjsblsNR13j344tSo3SqT6q5f7tJfbq5
         C3kNFZqgF/CqvEupTXc8zy4q+mRQj/cGenflJF9C0EBv3WKCOR0dvshMVQcRhWbRfEnL
         7zMQ==
X-Gm-Message-State: AOAM5302YjjHNN6qfmAgI20oCRSq5Pm3ovbLYeAcdVYWgN4K465HoQ7j
        Q5Oagu08Z4PGd3wUGYOw1vZ2MDiJxSE=
X-Google-Smtp-Source: ABdhPJzFBnKuANyMYXfM6xOubiL9KzDMxea1njYPZNVPxL8D/hSXdalPZ5QzqRdWsucUCRr3bnnEnQ==
X-Received: by 2002:a1c:8095:: with SMTP id b143mr566829wmd.71.1611502780680;
        Sun, 24 Jan 2021 07:39:40 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:6d62:6718:4fcc:a925? (p200300ea8f0655006d6267184fcca925.dip0.t-ipconnect.de. [2003:ea:8f06:5500:6d62:6718:4fcc:a925])
        by smtp.googlemail.com with ESMTPSA id b12sm12633796wrr.35.2021.01.24.07.39.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Jan 2021 07:39:39 -0800 (PST)
To:     Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH] vfio/pci: Fix handling of pci use accessor return codes
Message-ID: <3d14987b-278c-be28-be7b-8f3c733fc4e9@gmail.com>
Date:   Sun, 24 Jan 2021 16:35:41 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pci user accessors return negative errno's on error.

Fixes: f572a960a15e ("vfio/pci: Intel IGD host and LCP bridge config space access")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/vfio/pci/vfio_pci_igd.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
index 53d97f459..e66dfb017 100644
--- a/drivers/vfio/pci/vfio_pci_igd.c
+++ b/drivers/vfio/pci/vfio_pci_igd.c
@@ -127,7 +127,7 @@ static size_t vfio_pci_igd_cfg_rw(struct vfio_pci_device *vdev,
 
 		ret = pci_user_read_config_byte(pdev, pos, &val);
 		if (ret)
-			return pcibios_err_to_errno(ret);
+			return ret;
 
 		if (copy_to_user(buf + count - size, &val, 1))
 			return -EFAULT;
@@ -141,7 +141,7 @@ static size_t vfio_pci_igd_cfg_rw(struct vfio_pci_device *vdev,
 
 		ret = pci_user_read_config_word(pdev, pos, &val);
 		if (ret)
-			return pcibios_err_to_errno(ret);
+			return ret;
 
 		val = cpu_to_le16(val);
 		if (copy_to_user(buf + count - size, &val, 2))
@@ -156,7 +156,7 @@ static size_t vfio_pci_igd_cfg_rw(struct vfio_pci_device *vdev,
 
 		ret = pci_user_read_config_dword(pdev, pos, &val);
 		if (ret)
-			return pcibios_err_to_errno(ret);
+			return ret;
 
 		val = cpu_to_le32(val);
 		if (copy_to_user(buf + count - size, &val, 4))
@@ -171,7 +171,7 @@ static size_t vfio_pci_igd_cfg_rw(struct vfio_pci_device *vdev,
 
 		ret = pci_user_read_config_word(pdev, pos, &val);
 		if (ret)
-			return pcibios_err_to_errno(ret);
+			return ret;
 
 		val = cpu_to_le16(val);
 		if (copy_to_user(buf + count - size, &val, 2))
@@ -186,7 +186,7 @@ static size_t vfio_pci_igd_cfg_rw(struct vfio_pci_device *vdev,
 
 		ret = pci_user_read_config_byte(pdev, pos, &val);
 		if (ret)
-			return pcibios_err_to_errno(ret);
+			return ret;
 
 		if (copy_to_user(buf + count - size, &val, 1))
 			return -EFAULT;
-- 
2.30.0

