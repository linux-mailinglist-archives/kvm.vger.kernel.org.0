Return-Path: <kvm+bounces-48131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 62E55AC9BAD
	for <lists+kvm@lfdr.de>; Sat, 31 May 2025 18:18:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 46DD918986BA
	for <lists+kvm@lfdr.de>; Sat, 31 May 2025 16:19:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 668DE17A301;
	Sat, 31 May 2025 16:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IVSQ+vYl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEC117E0;
	Sat, 31 May 2025 16:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748708323; cv=none; b=RBsj6Kts9bANKdLiVW/Q+SLOsd8JciFW1qF2DcQDPhS06QvUrm9rY5dWAZ4Dvf2NRXHHEDEcG6elrn/j4Qx1baoID8kWDPk9hwFX7MxuERIGsRqLvFeH7FxxgjVh7OdjK2Kaln1OT8ZOwNpXgnZndaTiz2Lm2Rm3vxIwJU0YwuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748708323; c=relaxed/simple;
	bh=pWx0JtByz5bQLz9/8RlWnYuB53qfTidcpdVzrM66O4A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pQGbqLZjrZ8V+ZfcsD8ijrw8gCk8ads0qyCrvtHnvazUFRCNvhzfCaPU0UfeYevB3QqVAXAxBfU1evobWcNgYKNkvDXirLMWlXALdCN8EHu0wBgu+rBomo9L61BiBGo+EpksHv9gAKuO+fx5ij8rHKi3yx+i7yTgGr0+u7UFSvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IVSQ+vYl; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3a4ebfaa623so415002f8f.1;
        Sat, 31 May 2025 09:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748708319; x=1749313119; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7amG+fgm0XQ6pvWnBFAM72MHD6qJuia+zLfGed4C86Q=;
        b=IVSQ+vYlcFg3eyhB+sCJuyWO+BE4vtXbGja140pTM/IShoctUALwd/roFZggtRMgMB
         tXnRvwo02iM7iQfi0ryO4Vo2tIIM/SZIfaG4a+foU9mgMdwrQ9Ar66yEEelq1/O6+p79
         i/qgx3lZXTzMmw5NbzUrksee9Jhzl/e+j1za0lysgLmylIWHlebNePTwWI4F4GaYs6JE
         2JpJy437F1Tw8K0Qq3Htje8ILSop80yQtnUM5weSVx3iVc8GKACAdLC0d+vBxks3uy7k
         p3YSt+4N9dnAUMVpYI0AkQoucFjQ0EqD6yBogfBNDBkpz86pFRKj6JuWAcXcur6nNwJG
         UQUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748708319; x=1749313119;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7amG+fgm0XQ6pvWnBFAM72MHD6qJuia+zLfGed4C86Q=;
        b=FAY3yFSScX2ei4PzEAct8OkdmRxFa5XH40bTwYuQdhXD5CPmI93++5xDSA0dVGvpEd
         OB1yNEMRzfkLFhE6QLdKebOHgyw5D6js7mlLEmWhLjESnEkiaXeZxZ5JjuqPs4wOYAqz
         gg/4edWww5LhEJvtYiAA9Y4OMFeY3k5P7W4/W0ZvIxM81kZbDsQt1mptSKwgr43HEeUs
         GtY31r51w5jVAMDbqb6iMoplNaF1QDyvJor3RXRKP3Xv4hGGVv4XcxN8jIc9bnlJgodg
         6U03bBpHZyV3KF3ISoGcKXVrWfOVR3axOha2p2VHnNI48Hr57aiXcWrnG+IQRv97GR98
         AytA==
X-Forwarded-Encrypted: i=1; AJvYcCWfMizWRoI86dxSY0fm3WIWX3iAVYnKDAoTfHxlOgJ87dPAc4sf6pcz9S4bHdc1bl0xDdc=@vger.kernel.org, AJvYcCXbz7ZdCyo1c9EAhePWV+nMBm7p4L/2irOx5jv3gi3HP0zbX5qf6E8lNctasMOP/e3pdjb5uGhmok0vyfJF@vger.kernel.org
X-Gm-Message-State: AOJu0Yz16GcTPR/kOQw3s/BQCZNpydtY1RKsZ0PsxASo0FjsoNwC0eTq
	kgBo0GD9cPsMrAMTgnNsiGar0HO1lJZ4SHtKbLkWv+RFSETsMbfa5VM=
X-Gm-Gg: ASbGncududfVtxTxOZBmgJlBFnuHP7xhrtp3lSdXdCfgGvJD6eZd3c51dthBIVfQGoU
	9XS7WbIp6d2k2WVxLNLYmPBuThhPHJUnH0cJDj0xDpU1n3B4K6xX5/KJtMcJ43hz61jOoccPvPy
	pfr2CUmN95SRXAdeBHzsMOzpMUYP9sNK1IU4kJ++yezbPOjhEXYnMq8RrOVYs9RZq45vu2sGz5m
	HrOSoytR3oVgELCKzPfkcBr///JNIKE4N7OIrHIB3XV7Yv+T/7wRR/byXmpLkzFSaXb+5Wm230Y
	hsXtEfZnmpcp7+LABhJ3qppzDTS6xuRU7tvezR8oDtoZjMkdFCztP6AftI7K4i+oJIJ/sQxl6ZZ
	NHcIQLfp7M93P44k=
X-Google-Smtp-Source: AGHT+IF9bBR1PKckeUO+MJfzEpp1rgDSET7GZgiUK6KY0LN83z9QYZ1kxXD3RKW2wAP2M4isY2TISA==
X-Received: by 2002:a5d:64ed:0:b0:3a4:e8c8:fba1 with SMTP id ffacd0b85a97d-3a4f897ee54mr1918196f8f.10.1748708319258;
        Sat, 31 May 2025 09:18:39 -0700 (PDT)
Received: from localhost (131.red-80-39-31.staticip.rima-tde.net. [80.39.31.131])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4efe73f22sm8367944f8f.43.2025.05.31.09.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 May 2025 09:18:37 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	KVM ML <kvm@vger.kernel.org>,
	KERNEL ML <linux-kernel@vger.kernel.org>
Subject: [PATCH] samples: vfio-mdev: mtty.c: delete MODULE_VERSION
Date: Sat, 31 May 2025 18:18:36 +0200
Message-ID: <20250531161836.102346-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Reminiscence of ancient times when modules were developed outside the kernel.

Cc: Kirti Wankhede <kwankhede@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: KVM ML <kvm@vger.kernel.org>
Cc: KERNEL ML <linux-kernel@vger.kernel.org>
---
 samples/vfio-mdev/mtty.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index 59eefe2fed10..f9f7472516c9 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -35,7 +35,6 @@
  * #defines
  */
 
-#define VERSION_STRING  "0.1"
 #define DRIVER_AUTHOR   "NVIDIA Corporation"
 
 #define MTTY_CLASS_NAME "mtty"
@@ -2057,5 +2056,4 @@ module_exit(mtty_dev_exit)
 
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("Test driver that simulate serial port over PCI");
-MODULE_VERSION(VERSION_STRING);
 MODULE_AUTHOR(DRIVER_AUTHOR);
-- 
2.49.0


