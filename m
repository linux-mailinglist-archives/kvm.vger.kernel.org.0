Return-Path: <kvm+bounces-59506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D76AEBB9B7C
	for <lists+kvm@lfdr.de>; Sun, 05 Oct 2025 21:16:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35F053AF5D9
	for <lists+kvm@lfdr.de>; Sun,  5 Oct 2025 19:16:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAEC91D6DA9;
	Sun,  5 Oct 2025 19:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hhsYY7RI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C2A191F98
	for <kvm@vger.kernel.org>; Sun,  5 Oct 2025 19:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759691779; cv=none; b=A3KQNe2XEPWKlwSaGxhTZwkhUPL0p1cJA0fvDOqy+G7JH0KI288ZUnf+CbBz6vRagjcx3lo4FCRHPlosp94Dt+/IKJDhFEFqXUmEMHHU5kFYqpig8rDaSeULTD0x7TexqzvDlIKKiRiYDE0hr9jSCs1wuTbkRr/E6sZ4Q+G+sJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759691779; c=relaxed/simple;
	bh=/q8XSUUjAjJgMK2A54W/MUOzXy2VJYD8YamC71SuYp8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l2yKFrNwM/Fl2AEXoaq7JcRmZOtpOwGf4Gpejl93TdamTcNpgRjt+nvh0f/15KVncoQmCynEFH1SV8V098ogDtPxorwH8kyViEIQV+h0v/+cwVgnf4hiOPmKl5DbqaRNoGegy0IiEKuAG0KCG3y1ZFceLcjnfmCB6+tjWN5EjFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hhsYY7RI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759691774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=co3VQJs0tdvZzjIbzfak6bX2un3VvU+zoV0UkR/KKBs=;
	b=hhsYY7RIZ+AL4GbQQpdL0sbhkwn6lK0qVqzCNL7jCStm/qickIlhH+ZBbVf8eYVT9M0Cgb
	YBXR1cSoCIKKEl/4ulMUnrqPvhmj/eTuT7zswCtYzux7Y57HGHiPARFdht8iRtOD87LKWn
	3zF8AhBe25K/moUrO3kGs3W0abkaDqA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-587-MZdTvB0lPl21n6oX_CxrWA-1; Sun, 05 Oct 2025 15:16:13 -0400
X-MC-Unique: MZdTvB0lPl21n6oX_CxrWA-1
X-Mimecast-MFC-AGG-ID: MZdTvB0lPl21n6oX_CxrWA_1759691772
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e47d14dceso17542425e9.2
        for <kvm@vger.kernel.org>; Sun, 05 Oct 2025 12:16:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759691772; x=1760296572;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=co3VQJs0tdvZzjIbzfak6bX2un3VvU+zoV0UkR/KKBs=;
        b=sCjlFQX97CxEshtDjdW1Qo+DQtGWVaueTkxKvGWE5X98i9t34v8D/t5xGbe0cEyXnf
         tunIHfAeHRNNsq+GGAm9iZTSEJiYjOPOSCxbhSeUmPlXnLNl4P7ELPKeXMY7zh8G8Mnk
         RSAWNPrAbPOYy0dq3EHejF2zwHeRk6jpi8tHHLMpfiqoak4iAsfzpG27EqY8T/RA/fgH
         Z/PQaf6b1+jitaaEhePb7vuSxxLCPC8Y6e5oLW+BXoZkNcEdEPIHfCZKvpXt5Z1Qk+L6
         GlSCryjd6vAa1eUBvaSiq/+SxjQSNR6RztHTTlPakMicPclfFkvVSIZhB09Er/kCBdGx
         O7Mw==
X-Forwarded-Encrypted: i=1; AJvYcCXBnB7CCS9oBVtxDSZO4tMYOqb9bdoWHGXK6XD29GBp9iJ9+mMOr3uYJd+uRc4MPh9IUBE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxScJopu1GPukfKfQ5NV6W+xfPrEpSdXVUZne+AEW0ecGOEYtTM
	hZTj9dhpXZkBHC7x8sWHL5ELINNC6QnhhzMv8pLAJ09/7cSpO/pjqP3hv4UPFVlOlIkTMKkcq+V
	ro5a55JiAreiNggp5MIW7JIFxAsCpnYyykgP5FqKnDmtvHC1SwwI8dA==
X-Gm-Gg: ASbGncvXqLef3ERbXz2qSLgUEY8wTdCrXYFho/d/j8QfArh7sTT0855+I+Mueqsh3uQ
	cHx0lEOKu1zo8WO7TUXpQn7WcQJJEUdWy/asnc4FRjEW5FoX8Cp8YmoYLy9dmoBs7k22lVeAeeP
	jtwddtXNSpGkGHh4NFE6MCqC4flrmqiwrMbQO5iZ01+qwnNLVud5L2QI3oYzdjKi6Mv/3qHiaYF
	3EVFDx1jPFFmhIN1SYAHkHPbaf2AUkh5i9swh73g+d5WS5mLQXdJ0aEO5ZhFExuwGhgDpVqu6Gy
	MCBfGSZiNkt87gyBDiggafiSaLfy3cp0Dl9SA5A=
X-Received: by 2002:a05:600c:3d87:b0:46e:206a:78cc with SMTP id 5b1f17b1804b1-46e71144748mr58024545e9.28.1759691771104;
        Sun, 05 Oct 2025 12:16:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGQ2Bj5/JQuSV1uFr1EsIq8o65PRmM5LUx85rgj5OQ0OucEKxUAEadpGhJ4HfrHIJF/BPCgGg==
X-Received: by 2002:a05:600c:3d87:b0:46e:206a:78cc with SMTP id 5b1f17b1804b1-46e71144748mr58024345e9.28.1759691770413;
        Sun, 05 Oct 2025 12:16:10 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1518:6900:b69a:73e1:9698:9cd3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e723614c9sm122976045e9.14.2025.10.05.12.16.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Oct 2025 12:16:09 -0700 (PDT)
Date: Sun, 5 Oct 2025 15:16:08 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
	Jason Wang <jasowang@redhat.com>, Lei Yang <leiyang@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PULL 03/75] linux-headers: Update to Linux v6.17-rc1
Message-ID: <8de6cd5452eb9c58c0d105dbc9718bd0e83cc70f.1759691708.git.mst@redhat.com>
References: <cover.1759691708.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1759691708.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent

From: Paolo Abeni <pabeni@redhat.com>

Update headers to include the virtio GSO over UDP tunnel features

Reviewed-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Tested-by: Lei Yang <leiyang@redhat.com>
Acked-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <0b1f3c011f90583ab52aa4fef04df6db35cc4a69.1758549625.git.pabeni@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/standard-headers/drm/drm_fourcc.h     |  56 ++++++-
 include/standard-headers/linux/ethtool.h      |   4 +-
 .../linux/input-event-codes.h                 |   8 +
 include/standard-headers/linux/input.h        |   1 +
 include/standard-headers/linux/pci_regs.h     |   9 +
 include/standard-headers/linux/vhost_types.h  |   5 +
 include/standard-headers/linux/virtio_net.h   |  33 ++++
 linux-headers/asm-arm64/unistd_64.h           |   2 +
 linux-headers/asm-generic/unistd.h            |   8 +-
 linux-headers/asm-loongarch/unistd_64.h       |   2 +
 linux-headers/asm-mips/unistd_n32.h           |   2 +
 linux-headers/asm-mips/unistd_n64.h           |   2 +
 linux-headers/asm-mips/unistd_o32.h           |   2 +
 linux-headers/asm-powerpc/kvm.h               |  13 --
 linux-headers/asm-powerpc/unistd_32.h         |   2 +
 linux-headers/asm-powerpc/unistd_64.h         |   2 +
 linux-headers/asm-riscv/kvm.h                 |   1 +
 linux-headers/asm-riscv/unistd_32.h           |   2 +
 linux-headers/asm-riscv/unistd_64.h           |   2 +
 linux-headers/asm-s390/unistd_32.h            |   2 +
 linux-headers/asm-s390/unistd_64.h            |   2 +
 linux-headers/asm-x86/unistd_32.h             |   2 +
 linux-headers/asm-x86/unistd_64.h             |   2 +
 linux-headers/asm-x86/unistd_x32.h            |   2 +
 linux-headers/linux/iommufd.h                 | 154 +++++++++++++++++-
 linux-headers/linux/kvm.h                     |   2 +
 linux-headers/linux/vfio.h                    |  12 +-
 linux-headers/linux/vhost.h                   |  35 ++++
 linux-headers/LICENSES/preferred/GPL-2.0      |  10 +-
 29 files changed, 352 insertions(+), 27 deletions(-)

diff --git a/include/standard-headers/drm/drm_fourcc.h b/include/standard-headers/drm/drm_fourcc.h
index c8309d378b..cef077dfb3 100644
--- a/include/standard-headers/drm/drm_fourcc.h
+++ b/include/standard-headers/drm/drm_fourcc.h
@@ -209,6 +209,10 @@ extern "C" {
 #define DRM_FORMAT_RGBA1010102	fourcc_code('R', 'A', '3', '0') /* [31:0] R:G:B:A 10:10:10:2 little endian */
 #define DRM_FORMAT_BGRA1010102	fourcc_code('B', 'A', '3', '0') /* [31:0] B:G:R:A 10:10:10:2 little endian */
 
+/* 48 bpp RGB */
+#define DRM_FORMAT_RGB161616 fourcc_code('R', 'G', '4', '8') /* [47:0] R:G:B 16:16:16 little endian */
+#define DRM_FORMAT_BGR161616 fourcc_code('B', 'G', '4', '8') /* [47:0] B:G:R 16:16:16 little endian */
+
 /* 64 bpp RGB */
 #define DRM_FORMAT_XRGB16161616	fourcc_code('X', 'R', '4', '8') /* [63:0] x:R:G:B 16:16:16:16 little endian */
 #define DRM_FORMAT_XBGR16161616	fourcc_code('X', 'B', '4', '8') /* [63:0] x:B:G:R 16:16:16:16 little endian */
@@ -217,7 +221,7 @@ extern "C" {
 #define DRM_FORMAT_ABGR16161616	fourcc_code('A', 'B', '4', '8') /* [63:0] A:B:G:R 16:16:16:16 little endian */
 
 /*
- * Floating point 64bpp RGB
+ * Half-Floating point - 16b/component
  * IEEE 754-2008 binary16 half-precision float
  * [15:0] sign:exponent:mantissa 1:5:10
  */
@@ -227,6 +231,20 @@ extern "C" {
 #define DRM_FORMAT_ARGB16161616F fourcc_code('A', 'R', '4', 'H') /* [63:0] A:R:G:B 16:16:16:16 little endian */
 #define DRM_FORMAT_ABGR16161616F fourcc_code('A', 'B', '4', 'H') /* [63:0] A:B:G:R 16:16:16:16 little endian */
 
+#define DRM_FORMAT_R16F          fourcc_code('R', ' ', ' ', 'H') /* [15:0] R 16 little endian */
+#define DRM_FORMAT_GR1616F       fourcc_code('G', 'R', ' ', 'H') /* [31:0] G:R 16:16 little endian */
+#define DRM_FORMAT_BGR161616F    fourcc_code('B', 'G', 'R', 'H') /* [47:0] B:G:R 16:16:16 little endian */
+
+/*
+ * Floating point - 32b/component
+ * IEEE 754-2008 binary32 float
+ * [31:0] sign:exponent:mantissa 1:8:23
+ */
+#define DRM_FORMAT_R32F          fourcc_code('R', ' ', ' ', 'F') /* [31:0] R 32 little endian */
+#define DRM_FORMAT_GR3232F       fourcc_code('G', 'R', ' ', 'F') /* [63:0] R:G 32:32 little endian */
+#define DRM_FORMAT_BGR323232F    fourcc_code('B', 'G', 'R', 'F') /* [95:0] R:G:B 32:32:32 little endian */
+#define DRM_FORMAT_ABGR32323232F fourcc_code('A', 'B', '8', 'F') /* [127:0] R:G:B:A 32:32:32:32 little endian */
+
 /*
  * RGBA format with 10-bit components packed in 64-bit per pixel, with 6 bits
  * of unused padding per component:
@@ -376,6 +394,42 @@ extern "C" {
  */
 #define DRM_FORMAT_Q401		fourcc_code('Q', '4', '0', '1')
 
+/*
+ * 3 plane YCbCr LSB aligned
+ * In order to use these formats in a similar fashion to MSB aligned ones
+ * implementation can multiply the values by 2^6=64. For that reason the padding
+ * must only contain zeros.
+ * index 0 = Y plane, [15:0] z:Y [6:10] little endian
+ * index 1 = Cr plane, [15:0] z:Cr [6:10] little endian
+ * index 2 = Cb plane, [15:0] z:Cb [6:10] little endian
+ */
+#define DRM_FORMAT_S010	fourcc_code('S', '0', '1', '0') /* 2x2 subsampled Cb (1) and Cr (2) planes 10 bits per channel */
+#define DRM_FORMAT_S210	fourcc_code('S', '2', '1', '0') /* 2x1 subsampled Cb (1) and Cr (2) planes 10 bits per channel */
+#define DRM_FORMAT_S410	fourcc_code('S', '4', '1', '0') /* non-subsampled Cb (1) and Cr (2) planes 10 bits per channel */
+
+/*
+ * 3 plane YCbCr LSB aligned
+ * In order to use these formats in a similar fashion to MSB aligned ones
+ * implementation can multiply the values by 2^4=16. For that reason the padding
+ * must only contain zeros.
+ * index 0 = Y plane, [15:0] z:Y [4:12] little endian
+ * index 1 = Cr plane, [15:0] z:Cr [4:12] little endian
+ * index 2 = Cb plane, [15:0] z:Cb [4:12] little endian
+ */
+#define DRM_FORMAT_S012	fourcc_code('S', '0', '1', '2') /* 2x2 subsampled Cb (1) and Cr (2) planes 12 bits per channel */
+#define DRM_FORMAT_S212	fourcc_code('S', '2', '1', '2') /* 2x1 subsampled Cb (1) and Cr (2) planes 12 bits per channel */
+#define DRM_FORMAT_S412	fourcc_code('S', '4', '1', '2') /* non-subsampled Cb (1) and Cr (2) planes 12 bits per channel */
+
+/*
+ * 3 plane YCbCr
+ * index 0 = Y plane, [15:0] Y little endian
+ * index 1 = Cr plane, [15:0] Cr little endian
+ * index 2 = Cb plane, [15:0] Cb little endian
+ */
+#define DRM_FORMAT_S016	fourcc_code('S', '0', '1', '6') /* 2x2 subsampled Cb (1) and Cr (2) planes 16 bits per channel */
+#define DRM_FORMAT_S216	fourcc_code('S', '2', '1', '6') /* 2x1 subsampled Cb (1) and Cr (2) planes 16 bits per channel */
+#define DRM_FORMAT_S416	fourcc_code('S', '4', '1', '6') /* non-subsampled Cb (1) and Cr (2) planes 16 bits per channel */
+
 /*
  * 3 plane YCbCr
  * index 0: Y plane, [7:0] Y
diff --git a/include/standard-headers/linux/ethtool.h b/include/standard-headers/linux/ethtool.h
index cef0d207a6..eb80314028 100644
--- a/include/standard-headers/linux/ethtool.h
+++ b/include/standard-headers/linux/ethtool.h
@@ -2314,7 +2314,7 @@ enum {
 	IPV6_USER_FLOW	= 0x0e, /* spec only (usr_ip6_spec; nfc only) */
 	IPV4_FLOW	= 0x10, /* hash only */
 	IPV6_FLOW	= 0x11, /* hash only */
-	ETHER_FLOW	= 0x12, /* spec only (ether_spec) */
+	ETHER_FLOW	= 0x12, /* hash or spec (ether_spec) */
 
 	/* Used for GTP-U IPv4 and IPv6.
 	 * The format of GTP packets only includes
@@ -2371,7 +2371,7 @@ enum {
 /* Flag to enable RSS spreading of traffic matching rule (nfc only) */
 #define	FLOW_RSS	0x20000000
 
-/* L3-L4 network traffic flow hash options */
+/* L2-L4 network traffic flow hash options */
 #define	RXH_L2DA	(1 << 1)
 #define	RXH_VLAN	(1 << 2)
 #define	RXH_L3_PROTO	(1 << 3)
diff --git a/include/standard-headers/linux/input-event-codes.h b/include/standard-headers/linux/input-event-codes.h
index a82ff795e0..00dc9caac9 100644
--- a/include/standard-headers/linux/input-event-codes.h
+++ b/include/standard-headers/linux/input-event-codes.h
@@ -601,6 +601,11 @@
 #define BTN_DPAD_LEFT		0x222
 #define BTN_DPAD_RIGHT		0x223
 
+#define BTN_GRIPL		0x224
+#define BTN_GRIPR		0x225
+#define BTN_GRIPL2		0x226
+#define BTN_GRIPR2		0x227
+
 #define KEY_ALS_TOGGLE		0x230	/* Ambient light sensor */
 #define KEY_ROTATE_LOCK_TOGGLE	0x231	/* Display rotation lock */
 #define KEY_REFRESH_RATE_TOGGLE	0x232	/* Display refresh rate toggle */
@@ -765,6 +770,9 @@
 #define KEY_KBD_LCD_MENU4		0x2bb
 #define KEY_KBD_LCD_MENU5		0x2bc
 
+/* Performance Boost key (Alienware)/G-Mode key (Dell) */
+#define KEY_PERFORMANCE			0x2bd
+
 #define BTN_TRIGGER_HAPPY		0x2c0
 #define BTN_TRIGGER_HAPPY1		0x2c0
 #define BTN_TRIGGER_HAPPY2		0x2c1
diff --git a/include/standard-headers/linux/input.h b/include/standard-headers/linux/input.h
index 942ea6aaa9..d4512c20b5 100644
--- a/include/standard-headers/linux/input.h
+++ b/include/standard-headers/linux/input.h
@@ -272,6 +272,7 @@ struct input_mask {
 #define BUS_CEC			0x1E
 #define BUS_INTEL_ISHTP		0x1F
 #define BUS_AMD_SFH		0x20
+#define BUS_SDW			0x21
 
 /*
  * MT_TOOL types
diff --git a/include/standard-headers/linux/pci_regs.h b/include/standard-headers/linux/pci_regs.h
index a3a3e942de..f5b17745de 100644
--- a/include/standard-headers/linux/pci_regs.h
+++ b/include/standard-headers/linux/pci_regs.h
@@ -745,6 +745,7 @@
 #define PCI_EXT_CAP_ID_L1SS	0x1E	/* L1 PM Substates */
 #define PCI_EXT_CAP_ID_PTM	0x1F	/* Precision Time Measurement */
 #define PCI_EXT_CAP_ID_DVSEC	0x23	/* Designated Vendor-Specific */
+#define PCI_EXT_CAP_ID_VF_REBAR 0x24	/* VF Resizable BAR */
 #define PCI_EXT_CAP_ID_DLF	0x25	/* Data Link Feature */
 #define PCI_EXT_CAP_ID_PL_16GT	0x26	/* Physical Layer 16.0 GT/s */
 #define PCI_EXT_CAP_ID_NPEM	0x29	/* Native PCIe Enclosure Management */
@@ -1141,6 +1142,14 @@
 #define PCI_DVSEC_HEADER2		0x8 /* Designated Vendor-Specific Header2 */
 #define  PCI_DVSEC_HEADER2_ID(x)		((x) & 0xffff)
 
+/* VF Resizable BARs, same layout as PCI_REBAR */
+#define PCI_VF_REBAR_CAP	PCI_REBAR_CAP
+#define  PCI_VF_REBAR_CAP_SIZES		PCI_REBAR_CAP_SIZES
+#define PCI_VF_REBAR_CTRL	PCI_REBAR_CTRL
+#define  PCI_VF_REBAR_CTRL_BAR_IDX	PCI_REBAR_CTRL_BAR_IDX
+#define  PCI_VF_REBAR_CTRL_NBAR_MASK	PCI_REBAR_CTRL_NBAR_MASK
+#define  PCI_VF_REBAR_CTRL_BAR_SIZE	PCI_REBAR_CTRL_BAR_SIZE
+
 /* Data Link Feature */
 #define PCI_DLF_CAP		0x04	/* Capabilities Register */
 #define  PCI_DLF_EXCHANGE_ENABLE	0x80000000  /* Data Link Feature Exchange Enable */
diff --git a/include/standard-headers/linux/vhost_types.h b/include/standard-headers/linux/vhost_types.h
index fd54044936..79b53a931a 100644
--- a/include/standard-headers/linux/vhost_types.h
+++ b/include/standard-headers/linux/vhost_types.h
@@ -110,6 +110,11 @@ struct vhost_msg_v2 {
 	};
 };
 
+struct vhost_features_array {
+	uint64_t count; /* number of entries present in features array */
+	uint64_t features[] ;
+};
+
 struct vhost_memory_region {
 	uint64_t guest_phys_addr;
 	uint64_t memory_size; /* bytes */
diff --git a/include/standard-headers/linux/virtio_net.h b/include/standard-headers/linux/virtio_net.h
index 982e854f14..93abaae0b9 100644
--- a/include/standard-headers/linux/virtio_net.h
+++ b/include/standard-headers/linux/virtio_net.h
@@ -70,6 +70,28 @@
 					 * with the same MAC.
 					 */
 #define VIRTIO_NET_F_SPEED_DUPLEX 63	/* Device set linkspeed and duplex */
+#define VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO 65 /* Driver can receive
+					      * GSO-over-UDP-tunnel packets
+					      */
+#define VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO_CSUM 66 /* Driver handles
+						   * GSO-over-UDP-tunnel
+						   * packets with partial csum
+						   * for the outer header
+						   */
+#define VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO 67 /* Device can receive
+					     * GSO-over-UDP-tunnel packets
+					     */
+#define VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO_CSUM 68 /* Device handles
+						  * GSO-over-UDP-tunnel
+						  * packets with partial csum
+						  * for the outer header
+						  */
+
+/* Offloads bits corresponding to VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO{,_CSUM}
+ * features
+ */
+#define VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO_MAPPED	46
+#define VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO_CSUM_MAPPED	47
 
 #ifndef VIRTIO_NET_NO_LEGACY
 #define VIRTIO_NET_F_GSO	6	/* Host handles pkts w/ any GSO type */
@@ -131,12 +153,17 @@ struct virtio_net_hdr_v1 {
 #define VIRTIO_NET_HDR_F_NEEDS_CSUM	1	/* Use csum_start, csum_offset */
 #define VIRTIO_NET_HDR_F_DATA_VALID	2	/* Csum is valid */
 #define VIRTIO_NET_HDR_F_RSC_INFO	4	/* rsc info in csum_ fields */
+#define VIRTIO_NET_HDR_F_UDP_TUNNEL_CSUM 8	/* UDP tunnel csum offload */
 	uint8_t flags;
 #define VIRTIO_NET_HDR_GSO_NONE		0	/* Not a GSO frame */
 #define VIRTIO_NET_HDR_GSO_TCPV4	1	/* GSO frame, IPv4 TCP (TSO) */
 #define VIRTIO_NET_HDR_GSO_UDP		3	/* GSO frame, IPv4 UDP (UFO) */
 #define VIRTIO_NET_HDR_GSO_TCPV6	4	/* GSO frame, IPv6 TCP */
 #define VIRTIO_NET_HDR_GSO_UDP_L4	5	/* GSO frame, IPv4& IPv6 UDP (USO) */
+#define VIRTIO_NET_HDR_GSO_UDP_TUNNEL_IPV4 0x20 /* UDPv4 tunnel present */
+#define VIRTIO_NET_HDR_GSO_UDP_TUNNEL_IPV6 0x40 /* UDPv6 tunnel present */
+#define VIRTIO_NET_HDR_GSO_UDP_TUNNEL (VIRTIO_NET_HDR_GSO_UDP_TUNNEL_IPV4 | \
+				       VIRTIO_NET_HDR_GSO_UDP_TUNNEL_IPV6)
 #define VIRTIO_NET_HDR_GSO_ECN		0x80	/* TCP has ECN set */
 	uint8_t gso_type;
 	__virtio16 hdr_len;	/* Ethernet + IP + tcp/udp hdrs */
@@ -181,6 +208,12 @@ struct virtio_net_hdr_v1_hash {
 	uint16_t padding;
 };
 
+struct virtio_net_hdr_v1_hash_tunnel {
+	struct virtio_net_hdr_v1_hash hash_hdr;
+	uint16_t outer_th_offset;
+	uint16_t inner_nh_offset;
+};
+
 #ifndef VIRTIO_NET_NO_LEGACY
 /* This header comes first in the scatter-gather list.
  * For legacy virtio, if VIRTIO_F_ANY_LAYOUT is not negotiated, it must
diff --git a/linux-headers/asm-arm64/unistd_64.h b/linux-headers/asm-arm64/unistd_64.h
index ee9aaebdf3..4ae25c2b91 100644
--- a/linux-headers/asm-arm64/unistd_64.h
+++ b/linux-headers/asm-arm64/unistd_64.h
@@ -324,6 +324,8 @@
 #define __NR_listxattrat 465
 #define __NR_removexattrat 466
 #define __NR_open_tree_attr 467
+#define __NR_file_getattr 468
+#define __NR_file_setattr 469
 
 
 #endif /* _ASM_UNISTD_64_H */
diff --git a/linux-headers/asm-generic/unistd.h b/linux-headers/asm-generic/unistd.h
index 2892a45023..04e0077fb4 100644
--- a/linux-headers/asm-generic/unistd.h
+++ b/linux-headers/asm-generic/unistd.h
@@ -852,8 +852,14 @@ __SYSCALL(__NR_removexattrat, sys_removexattrat)
 #define __NR_open_tree_attr 467
 __SYSCALL(__NR_open_tree_attr, sys_open_tree_attr)
 
+/* fs/inode.c */
+#define __NR_file_getattr 468
+__SYSCALL(__NR_file_getattr, sys_file_getattr)
+#define __NR_file_setattr 469
+__SYSCALL(__NR_file_setattr, sys_file_setattr)
+
 #undef __NR_syscalls
-#define __NR_syscalls 468
+#define __NR_syscalls 470
 
 /*
  * 32 bit systems traditionally used different
diff --git a/linux-headers/asm-loongarch/unistd_64.h b/linux-headers/asm-loongarch/unistd_64.h
index 50d22df8f7..5033fc8f2f 100644
--- a/linux-headers/asm-loongarch/unistd_64.h
+++ b/linux-headers/asm-loongarch/unistd_64.h
@@ -320,6 +320,8 @@
 #define __NR_listxattrat 465
 #define __NR_removexattrat 466
 #define __NR_open_tree_attr 467
+#define __NR_file_getattr 468
+#define __NR_file_setattr 469
 
 
 #endif /* _ASM_UNISTD_64_H */
diff --git a/linux-headers/asm-mips/unistd_n32.h b/linux-headers/asm-mips/unistd_n32.h
index bdcc2f460b..c99c10e5bf 100644
--- a/linux-headers/asm-mips/unistd_n32.h
+++ b/linux-headers/asm-mips/unistd_n32.h
@@ -396,5 +396,7 @@
 #define __NR_listxattrat (__NR_Linux + 465)
 #define __NR_removexattrat (__NR_Linux + 466)
 #define __NR_open_tree_attr (__NR_Linux + 467)
+#define __NR_file_getattr (__NR_Linux + 468)
+#define __NR_file_setattr (__NR_Linux + 469)
 
 #endif /* _ASM_UNISTD_N32_H */
diff --git a/linux-headers/asm-mips/unistd_n64.h b/linux-headers/asm-mips/unistd_n64.h
index 3b6b0193b6..0d975bb185 100644
--- a/linux-headers/asm-mips/unistd_n64.h
+++ b/linux-headers/asm-mips/unistd_n64.h
@@ -372,5 +372,7 @@
 #define __NR_listxattrat (__NR_Linux + 465)
 #define __NR_removexattrat (__NR_Linux + 466)
 #define __NR_open_tree_attr (__NR_Linux + 467)
+#define __NR_file_getattr (__NR_Linux + 468)
+#define __NR_file_setattr (__NR_Linux + 469)
 
 #endif /* _ASM_UNISTD_N64_H */
diff --git a/linux-headers/asm-mips/unistd_o32.h b/linux-headers/asm-mips/unistd_o32.h
index 4609a4b4d3..86ac0ac84b 100644
--- a/linux-headers/asm-mips/unistd_o32.h
+++ b/linux-headers/asm-mips/unistd_o32.h
@@ -442,5 +442,7 @@
 #define __NR_listxattrat (__NR_Linux + 465)
 #define __NR_removexattrat (__NR_Linux + 466)
 #define __NR_open_tree_attr (__NR_Linux + 467)
+#define __NR_file_getattr (__NR_Linux + 468)
+#define __NR_file_setattr (__NR_Linux + 469)
 
 #endif /* _ASM_UNISTD_O32_H */
diff --git a/linux-headers/asm-powerpc/kvm.h b/linux-headers/asm-powerpc/kvm.h
index eaeda00178..077c5437f5 100644
--- a/linux-headers/asm-powerpc/kvm.h
+++ b/linux-headers/asm-powerpc/kvm.h
@@ -1,18 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 /*
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License, version 2, as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
- *
  * Copyright IBM Corp. 2007
  *
  * Authors: Hollis Blanchard <hollisb@us.ibm.com>
diff --git a/linux-headers/asm-powerpc/unistd_32.h b/linux-headers/asm-powerpc/unistd_32.h
index 5d38a427e0..d7a32c5e06 100644
--- a/linux-headers/asm-powerpc/unistd_32.h
+++ b/linux-headers/asm-powerpc/unistd_32.h
@@ -449,6 +449,8 @@
 #define __NR_listxattrat 465
 #define __NR_removexattrat 466
 #define __NR_open_tree_attr 467
+#define __NR_file_getattr 468
+#define __NR_file_setattr 469
 
 
 #endif /* _ASM_UNISTD_32_H */
diff --git a/linux-headers/asm-powerpc/unistd_64.h b/linux-headers/asm-powerpc/unistd_64.h
index 860a488e4d..ff35c51fc6 100644
--- a/linux-headers/asm-powerpc/unistd_64.h
+++ b/linux-headers/asm-powerpc/unistd_64.h
@@ -421,6 +421,8 @@
 #define __NR_listxattrat 465
 #define __NR_removexattrat 466
 #define __NR_open_tree_attr 467
+#define __NR_file_getattr 468
+#define __NR_file_setattr 469
 
 
 #endif /* _ASM_UNISTD_64_H */
diff --git a/linux-headers/asm-riscv/kvm.h b/linux-headers/asm-riscv/kvm.h
index 5f59fd226c..ef27d4289d 100644
--- a/linux-headers/asm-riscv/kvm.h
+++ b/linux-headers/asm-riscv/kvm.h
@@ -18,6 +18,7 @@
 #define __KVM_HAVE_IRQ_LINE
 
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
+#define KVM_DIRTY_LOG_PAGE_OFFSET 64
 
 #define KVM_INTERRUPT_SET	-1U
 #define KVM_INTERRUPT_UNSET	-2U
diff --git a/linux-headers/asm-riscv/unistd_32.h b/linux-headers/asm-riscv/unistd_32.h
index a5e769f1d9..6083373e88 100644
--- a/linux-headers/asm-riscv/unistd_32.h
+++ b/linux-headers/asm-riscv/unistd_32.h
@@ -315,6 +315,8 @@
 #define __NR_listxattrat 465
 #define __NR_removexattrat 466
 #define __NR_open_tree_attr 467
+#define __NR_file_getattr 468
+#define __NR_file_setattr 469
 
 
 #endif /* _ASM_UNISTD_32_H */
diff --git a/linux-headers/asm-riscv/unistd_64.h b/linux-headers/asm-riscv/unistd_64.h
index 8df4d64841..f0c7585c60 100644
--- a/linux-headers/asm-riscv/unistd_64.h
+++ b/linux-headers/asm-riscv/unistd_64.h
@@ -325,6 +325,8 @@
 #define __NR_listxattrat 465
 #define __NR_removexattrat 466
 #define __NR_open_tree_attr 467
+#define __NR_file_getattr 468
+#define __NR_file_setattr 469
 
 
 #endif /* _ASM_UNISTD_64_H */
diff --git a/linux-headers/asm-s390/unistd_32.h b/linux-headers/asm-s390/unistd_32.h
index 85eedbd18e..37b8f6f358 100644
--- a/linux-headers/asm-s390/unistd_32.h
+++ b/linux-headers/asm-s390/unistd_32.h
@@ -440,5 +440,7 @@
 #define __NR_listxattrat 465
 #define __NR_removexattrat 466
 #define __NR_open_tree_attr 467
+#define __NR_file_getattr 468
+#define __NR_file_setattr 469
 
 #endif /* _ASM_S390_UNISTD_32_H */
diff --git a/linux-headers/asm-s390/unistd_64.h b/linux-headers/asm-s390/unistd_64.h
index c03b1b9701..0652ba6331 100644
--- a/linux-headers/asm-s390/unistd_64.h
+++ b/linux-headers/asm-s390/unistd_64.h
@@ -388,5 +388,7 @@
 #define __NR_listxattrat 465
 #define __NR_removexattrat 466
 #define __NR_open_tree_attr 467
+#define __NR_file_getattr 468
+#define __NR_file_setattr 469
 
 #endif /* _ASM_S390_UNISTD_64_H */
diff --git a/linux-headers/asm-x86/unistd_32.h b/linux-headers/asm-x86/unistd_32.h
index 491d6b4eb6..8f784a5634 100644
--- a/linux-headers/asm-x86/unistd_32.h
+++ b/linux-headers/asm-x86/unistd_32.h
@@ -458,6 +458,8 @@
 #define __NR_listxattrat 465
 #define __NR_removexattrat 466
 #define __NR_open_tree_attr 467
+#define __NR_file_getattr 468
+#define __NR_file_setattr 469
 
 
 #endif /* _ASM_UNISTD_32_H */
diff --git a/linux-headers/asm-x86/unistd_64.h b/linux-headers/asm-x86/unistd_64.h
index 7cf88bf9bd..2f55bebb81 100644
--- a/linux-headers/asm-x86/unistd_64.h
+++ b/linux-headers/asm-x86/unistd_64.h
@@ -381,6 +381,8 @@
 #define __NR_listxattrat 465
 #define __NR_removexattrat 466
 #define __NR_open_tree_attr 467
+#define __NR_file_getattr 468
+#define __NR_file_setattr 469
 
 
 #endif /* _ASM_UNISTD_64_H */
diff --git a/linux-headers/asm-x86/unistd_x32.h b/linux-headers/asm-x86/unistd_x32.h
index 82959111e6..8cc8673f15 100644
--- a/linux-headers/asm-x86/unistd_x32.h
+++ b/linux-headers/asm-x86/unistd_x32.h
@@ -334,6 +334,8 @@
 #define __NR_listxattrat (__X32_SYSCALL_BIT + 465)
 #define __NR_removexattrat (__X32_SYSCALL_BIT + 466)
 #define __NR_open_tree_attr (__X32_SYSCALL_BIT + 467)
+#define __NR_file_getattr (__X32_SYSCALL_BIT + 468)
+#define __NR_file_setattr (__X32_SYSCALL_BIT + 469)
 #define __NR_rt_sigaction (__X32_SYSCALL_BIT + 512)
 #define __NR_rt_sigreturn (__X32_SYSCALL_BIT + 513)
 #define __NR_ioctl (__X32_SYSCALL_BIT + 514)
diff --git a/linux-headers/linux/iommufd.h b/linux-headers/linux/iommufd.h
index cb0f7d6b4d..2105a03955 100644
--- a/linux-headers/linux/iommufd.h
+++ b/linux-headers/linux/iommufd.h
@@ -56,6 +56,7 @@ enum {
 	IOMMUFD_CMD_VDEVICE_ALLOC = 0x91,
 	IOMMUFD_CMD_IOAS_CHANGE_PROCESS = 0x92,
 	IOMMUFD_CMD_VEVENTQ_ALLOC = 0x93,
+	IOMMUFD_CMD_HW_QUEUE_ALLOC = 0x94,
 };
 
 /**
@@ -590,17 +591,44 @@ struct iommu_hw_info_arm_smmuv3 {
 	__u32 aidr;
 };
 
+/**
+ * struct iommu_hw_info_tegra241_cmdqv - NVIDIA Tegra241 CMDQV Hardware
+ *         Information (IOMMU_HW_INFO_TYPE_TEGRA241_CMDQV)
+ *
+ * @flags: Must be 0
+ * @version: Version number for the CMDQ-V HW for PARAM bits[03:00]
+ * @log2vcmdqs: Log2 of the total number of VCMDQs for PARAM bits[07:04]
+ * @log2vsids: Log2 of the total number of SID replacements for PARAM bits[15:12]
+ * @__reserved: Must be 0
+ *
+ * VMM can use these fields directly in its emulated global PARAM register. Note
+ * that only one Virtual Interface (VINTF) should be exposed to a VM, i.e. PARAM
+ * bits[11:08] should be set to 0 for log2 of the total number of VINTFs.
+ */
+struct iommu_hw_info_tegra241_cmdqv {
+	__u32 flags;
+	__u8 version;
+	__u8 log2vcmdqs;
+	__u8 log2vsids;
+	__u8 __reserved;
+};
+
 /**
  * enum iommu_hw_info_type - IOMMU Hardware Info Types
- * @IOMMU_HW_INFO_TYPE_NONE: Used by the drivers that do not report hardware
+ * @IOMMU_HW_INFO_TYPE_NONE: Output by the drivers that do not report hardware
  *                           info
+ * @IOMMU_HW_INFO_TYPE_DEFAULT: Input to request for a default type
  * @IOMMU_HW_INFO_TYPE_INTEL_VTD: Intel VT-d iommu info type
  * @IOMMU_HW_INFO_TYPE_ARM_SMMUV3: ARM SMMUv3 iommu info type
+ * @IOMMU_HW_INFO_TYPE_TEGRA241_CMDQV: NVIDIA Tegra241 CMDQV (extension for ARM
+ *                                     SMMUv3) info type
  */
 enum iommu_hw_info_type {
 	IOMMU_HW_INFO_TYPE_NONE = 0,
+	IOMMU_HW_INFO_TYPE_DEFAULT = 0,
 	IOMMU_HW_INFO_TYPE_INTEL_VTD = 1,
 	IOMMU_HW_INFO_TYPE_ARM_SMMUV3 = 2,
+	IOMMU_HW_INFO_TYPE_TEGRA241_CMDQV = 3,
 };
 
 /**
@@ -625,6 +653,15 @@ enum iommufd_hw_capabilities {
 	IOMMU_HW_CAP_PCI_PASID_PRIV = 1 << 2,
 };
 
+/**
+ * enum iommufd_hw_info_flags - Flags for iommu_hw_info
+ * @IOMMU_HW_INFO_FLAG_INPUT_TYPE: If set, @in_data_type carries an input type
+ *                                 for user space to request for a specific info
+ */
+enum iommufd_hw_info_flags {
+	IOMMU_HW_INFO_FLAG_INPUT_TYPE = 1 << 0,
+};
+
 /**
  * struct iommu_hw_info - ioctl(IOMMU_GET_HW_INFO)
  * @size: sizeof(struct iommu_hw_info)
@@ -634,6 +671,12 @@ enum iommufd_hw_capabilities {
  *            data that kernel supports
  * @data_uptr: User pointer to a user-space buffer used by the kernel to fill
  *             the iommu type specific hardware information data
+ * @in_data_type: This shares the same field with @out_data_type, making it be
+ *                a bidirectional field. When IOMMU_HW_INFO_FLAG_INPUT_TYPE is
+ *                set, an input type carried via this @in_data_type field will
+ *                be valid, requesting for the info data to the given type. If
+ *                IOMMU_HW_INFO_FLAG_INPUT_TYPE is unset, any input value will
+ *                be seen as IOMMU_HW_INFO_TYPE_DEFAULT
  * @out_data_type: Output the iommu hardware info type as defined in the enum
  *                 iommu_hw_info_type.
  * @out_capabilities: Output the generic iommu capability info type as defined
@@ -663,7 +706,10 @@ struct iommu_hw_info {
 	__u32 dev_id;
 	__u32 data_len;
 	__aligned_u64 data_uptr;
-	__u32 out_data_type;
+	union {
+		__u32 in_data_type;
+		__u32 out_data_type;
+	};
 	__u8 out_max_pasid_log2;
 	__u8 __reserved[3];
 	__aligned_u64 out_capabilities;
@@ -951,10 +997,29 @@ struct iommu_fault_alloc {
  * enum iommu_viommu_type - Virtual IOMMU Type
  * @IOMMU_VIOMMU_TYPE_DEFAULT: Reserved for future use
  * @IOMMU_VIOMMU_TYPE_ARM_SMMUV3: ARM SMMUv3 driver specific type
+ * @IOMMU_VIOMMU_TYPE_TEGRA241_CMDQV: NVIDIA Tegra241 CMDQV (extension for ARM
+ *                                    SMMUv3) enabled ARM SMMUv3 type
  */
 enum iommu_viommu_type {
 	IOMMU_VIOMMU_TYPE_DEFAULT = 0,
 	IOMMU_VIOMMU_TYPE_ARM_SMMUV3 = 1,
+	IOMMU_VIOMMU_TYPE_TEGRA241_CMDQV = 2,
+};
+
+/**
+ * struct iommu_viommu_tegra241_cmdqv - NVIDIA Tegra241 CMDQV Virtual Interface
+ *                                      (IOMMU_VIOMMU_TYPE_TEGRA241_CMDQV)
+ * @out_vintf_mmap_offset: mmap offset argument for VINTF's page0
+ * @out_vintf_mmap_length: mmap length argument for VINTF's page0
+ *
+ * Both @out_vintf_mmap_offset and @out_vintf_mmap_length are reported by kernel
+ * for user space to mmap the VINTF page0 from the host physical address space
+ * to the guest physical address space so that a guest kernel can directly R/W
+ * access to the VINTF page0 in order to control its virtual command queues.
+ */
+struct iommu_viommu_tegra241_cmdqv {
+	__aligned_u64 out_vintf_mmap_offset;
+	__aligned_u64 out_vintf_mmap_length;
 };
 
 /**
@@ -965,6 +1030,9 @@ enum iommu_viommu_type {
  * @dev_id: The device's physical IOMMU will be used to back the virtual IOMMU
  * @hwpt_id: ID of a nesting parent HWPT to associate to
  * @out_viommu_id: Output virtual IOMMU ID for the allocated object
+ * @data_len: Length of the type specific data
+ * @__reserved: Must be 0
+ * @data_uptr: User pointer to a driver-specific virtual IOMMU data
  *
  * Allocate a virtual IOMMU object, representing the underlying physical IOMMU's
  * virtualization support that is a security-isolated slice of the real IOMMU HW
@@ -985,6 +1053,9 @@ struct iommu_viommu_alloc {
 	__u32 dev_id;
 	__u32 hwpt_id;
 	__u32 out_viommu_id;
+	__u32 data_len;
+	__u32 __reserved;
+	__aligned_u64 data_uptr;
 };
 #define IOMMU_VIOMMU_ALLOC _IO(IOMMUFD_TYPE, IOMMUFD_CMD_VIOMMU_ALLOC)
 
@@ -995,10 +1066,15 @@ struct iommu_viommu_alloc {
  * @dev_id: The physical device to allocate a virtual instance on the vIOMMU
  * @out_vdevice_id: Object handle for the vDevice. Pass to IOMMU_DESTORY
  * @virt_id: Virtual device ID per vIOMMU, e.g. vSID of ARM SMMUv3, vDeviceID
- *           of AMD IOMMU, and vRID of a nested Intel VT-d to a Context Table
+ *           of AMD IOMMU, and vRID of Intel VT-d
  *
  * Allocate a virtual device instance (for a physical device) against a vIOMMU.
  * This instance holds the device's information (related to its vIOMMU) in a VM.
+ * User should use IOMMU_DESTROY to destroy the virtual device before
+ * destroying the physical device (by closing vfio_cdev fd). Otherwise the
+ * virtual device would be forcibly destroyed on physical device destruction,
+ * its vdevice_id would be permanently leaked (unremovable & unreusable) until
+ * iommu fd closed.
  */
 struct iommu_vdevice_alloc {
 	__u32 size;
@@ -1075,10 +1151,12 @@ struct iommufd_vevent_header {
  * enum iommu_veventq_type - Virtual Event Queue Type
  * @IOMMU_VEVENTQ_TYPE_DEFAULT: Reserved for future use
  * @IOMMU_VEVENTQ_TYPE_ARM_SMMUV3: ARM SMMUv3 Virtual Event Queue
+ * @IOMMU_VEVENTQ_TYPE_TEGRA241_CMDQV: NVIDIA Tegra241 CMDQV Extension IRQ
  */
 enum iommu_veventq_type {
 	IOMMU_VEVENTQ_TYPE_DEFAULT = 0,
 	IOMMU_VEVENTQ_TYPE_ARM_SMMUV3 = 1,
+	IOMMU_VEVENTQ_TYPE_TEGRA241_CMDQV = 2,
 };
 
 /**
@@ -1102,6 +1180,19 @@ struct iommu_vevent_arm_smmuv3 {
 	__aligned_le64 evt[4];
 };
 
+/**
+ * struct iommu_vevent_tegra241_cmdqv - Tegra241 CMDQV IRQ
+ *                                      (IOMMU_VEVENTQ_TYPE_TEGRA241_CMDQV)
+ * @lvcmdq_err_map: 128-bit logical vcmdq error map, little-endian.
+ *                  (Refer to register LVCMDQ_ERR_MAPs per VINTF )
+ *
+ * The 128-bit register value from HW exclusively reflect the error bits for a
+ * Virtual Interface represented by a vIOMMU object. Read and report directly.
+ */
+struct iommu_vevent_tegra241_cmdqv {
+	__aligned_le64 lvcmdq_err_map[2];
+};
+
 /**
  * struct iommu_veventq_alloc - ioctl(IOMMU_VEVENTQ_ALLOC)
  * @size: sizeof(struct iommu_veventq_alloc)
@@ -1141,4 +1232,61 @@ struct iommu_veventq_alloc {
 	__u32 __reserved;
 };
 #define IOMMU_VEVENTQ_ALLOC _IO(IOMMUFD_TYPE, IOMMUFD_CMD_VEVENTQ_ALLOC)
+
+/**
+ * enum iommu_hw_queue_type - HW Queue Type
+ * @IOMMU_HW_QUEUE_TYPE_DEFAULT: Reserved for future use
+ * @IOMMU_HW_QUEUE_TYPE_TEGRA241_CMDQV: NVIDIA Tegra241 CMDQV (extension for ARM
+ *                                      SMMUv3) Virtual Command Queue (VCMDQ)
+ */
+enum iommu_hw_queue_type {
+	IOMMU_HW_QUEUE_TYPE_DEFAULT = 0,
+	/*
+	 * TEGRA241_CMDQV requirements (otherwise, allocation will fail)
+	 * - alloc starts from the lowest @index=0 in ascending order
+	 * - destroy starts from the last allocated @index in descending order
+	 * - @base_addr must be aligned to @length in bytes and mapped in IOAS
+	 * - @length must be a power of 2, with a minimum 32 bytes and a maximum
+	 *   2 ^ idr[1].CMDQS * 16 bytes (use GET_HW_INFO call to read idr[1]
+	 *   from struct iommu_hw_info_arm_smmuv3)
+	 * - suggest to back the queue memory with contiguous physical pages or
+	 *   a single huge page with alignment of the queue size, and limit the
+	 *   emulated vSMMU's IDR1.CMDQS to log2(huge page size / 16 bytes)
+	 */
+	IOMMU_HW_QUEUE_TYPE_TEGRA241_CMDQV = 1,
+};
+
+/**
+ * struct iommu_hw_queue_alloc - ioctl(IOMMU_HW_QUEUE_ALLOC)
+ * @size: sizeof(struct iommu_hw_queue_alloc)
+ * @flags: Must be 0
+ * @viommu_id: Virtual IOMMU ID to associate the HW queue with
+ * @type: One of enum iommu_hw_queue_type
+ * @index: The logical index to the HW queue per virtual IOMMU for a multi-queue
+ *         model
+ * @out_hw_queue_id: The ID of the new HW queue
+ * @nesting_parent_iova: Base address of the queue memory in the guest physical
+ *                       address space
+ * @length: Length of the queue memory
+ *
+ * Allocate a HW queue object for a vIOMMU-specific HW-accelerated queue, which
+ * allows HW to access a guest queue memory described using @nesting_parent_iova
+ * and @length.
+ *
+ * A vIOMMU can allocate multiple queues, but it must use a different @index per
+ * type to separate each allocation, e.g::
+ *
+ *     Type1 HW queue0, Type1 HW queue1, Type2 HW queue0, ...
+ */
+struct iommu_hw_queue_alloc {
+	__u32 size;
+	__u32 flags;
+	__u32 viommu_id;
+	__u32 type;
+	__u32 index;
+	__u32 out_hw_queue_id;
+	__aligned_u64 nesting_parent_iova;
+	__aligned_u64 length;
+};
+#define IOMMU_HW_QUEUE_ALLOC _IO(IOMMUFD_TYPE, IOMMUFD_CMD_HW_QUEUE_ALLOC)
 #endif
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 32c5885a3c..be704965d8 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -636,6 +636,7 @@ struct kvm_ioeventfd {
 #define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)
 #define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
 #define KVM_X86_DISABLE_EXITS_CSTATE         (1 << 3)
+#define KVM_X86_DISABLE_EXITS_APERFMPERF     (1 << 4)
 
 /* for KVM_ENABLE_CAP */
 struct kvm_enable_cap {
@@ -952,6 +953,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_ARM_EL2 240
 #define KVM_CAP_ARM_EL2_E2H0 241
 #define KVM_CAP_RISCV_MP_STATE_RESET 242
+#define KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED 243
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
diff --git a/linux-headers/linux/vfio.h b/linux-headers/linux/vfio.h
index 79bf8c0cc5..4d96d1fc12 100644
--- a/linux-headers/linux/vfio.h
+++ b/linux-headers/linux/vfio.h
@@ -905,10 +905,12 @@ struct vfio_device_feature {
  * VFIO_DEVICE_BIND_IOMMUFD - _IOR(VFIO_TYPE, VFIO_BASE + 18,
  *				   struct vfio_device_bind_iommufd)
  * @argsz:	 User filled size of this data.
- * @flags:	 Must be 0.
+ * @flags:	 Must be 0 or a bit flags of VFIO_DEVICE_BIND_*
  * @iommufd:	 iommufd to bind.
  * @out_devid:	 The device id generated by this bind. devid is a handle for
  *		 this device/iommufd bond and can be used in IOMMUFD commands.
+ * @token_uuid_ptr: Valid if VFIO_DEVICE_BIND_FLAG_TOKEN. Points to a 16 byte
+ *                  UUID in the same format as VFIO_DEVICE_FEATURE_PCI_VF_TOKEN.
  *
  * Bind a vfio_device to the specified iommufd.
  *
@@ -917,13 +919,21 @@ struct vfio_device_feature {
  *
  * Unbind is automatically conducted when device fd is closed.
  *
+ * A token is sometimes required to open the device, unless this is known to be
+ * needed VFIO_DEVICE_BIND_FLAG_TOKEN should not be set and token_uuid_ptr is
+ * ignored. The only case today is a PF/VF relationship where the VF bind must
+ * be provided the same token as VFIO_DEVICE_FEATURE_PCI_VF_TOKEN provided to
+ * the PF.
+ *
  * Return: 0 on success, -errno on failure.
  */
 struct vfio_device_bind_iommufd {
 	__u32		argsz;
 	__u32		flags;
+#define VFIO_DEVICE_BIND_FLAG_TOKEN (1 << 0)
 	__s32		iommufd;
 	__u32		out_devid;
+	__aligned_u64	token_uuid_ptr;
 };
 
 #define VFIO_DEVICE_BIND_IOMMUFD	_IO(VFIO_TYPE, VFIO_BASE + 18)
diff --git a/linux-headers/linux/vhost.h b/linux-headers/linux/vhost.h
index d4b3e2ae13..283348b64a 100644
--- a/linux-headers/linux/vhost.h
+++ b/linux-headers/linux/vhost.h
@@ -235,4 +235,39 @@
  */
 #define VHOST_VDPA_GET_VRING_SIZE	_IOWR(VHOST_VIRTIO, 0x82,	\
 					      struct vhost_vring_state)
+
+/* Extended features manipulation */
+#define VHOST_GET_FEATURES_ARRAY _IOR(VHOST_VIRTIO, 0x83, \
+				       struct vhost_features_array)
+#define VHOST_SET_FEATURES_ARRAY _IOW(VHOST_VIRTIO, 0x83, \
+				       struct vhost_features_array)
+
+/* fork_owner values for vhost */
+#define VHOST_FORK_OWNER_KTHREAD 0
+#define VHOST_FORK_OWNER_TASK 1
+
+/**
+ * VHOST_SET_FORK_FROM_OWNER - Set the fork_owner flag for the vhost device,
+ * This ioctl must called before VHOST_SET_OWNER.
+ * Only available when CONFIG_VHOST_ENABLE_FORK_OWNER_CONTROL=y
+ *
+ * @param fork_owner: An 8-bit value that determines the vhost thread mode
+ *
+ * When fork_owner is set to VHOST_FORK_OWNER_TASK(default value):
+ *   - Vhost will create vhost worker as tasks forked from the owner,
+ *     inheriting all of the owner's attributes.
+ *
+ * When fork_owner is set to VHOST_FORK_OWNER_KTHREAD:
+ *   - Vhost will create vhost workers as kernel threads.
+ */
+#define VHOST_SET_FORK_FROM_OWNER _IOW(VHOST_VIRTIO, 0x83, __u8)
+
+/**
+ * VHOST_GET_FORK_OWNER - Get the current fork_owner flag for the vhost device.
+ * Only available when CONFIG_VHOST_ENABLE_FORK_OWNER_CONTROL=y
+ *
+ * @return: An 8-bit value indicating the current thread mode.
+ */
+#define VHOST_GET_FORK_FROM_OWNER _IOR(VHOST_VIRTIO, 0x84, __u8)
+
 #endif
diff --git a/linux-headers/LICENSES/preferred/GPL-2.0 b/linux-headers/LICENSES/preferred/GPL-2.0
index ff0812fd89..ea8e93dc44 100644
--- a/linux-headers/LICENSES/preferred/GPL-2.0
+++ b/linux-headers/LICENSES/preferred/GPL-2.0
@@ -20,8 +20,8 @@ License-Text:
 		    GNU GENERAL PUBLIC LICENSE
 		       Version 2, June 1991
 
- Copyright (C) 1989, 1991 Free Software Foundation, Inc.
-                       51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ Copyright (C) 1989, 1991 Free Software Foundation, Inc.,
+ <https://fsf.org/>
  Everyone is permitted to copy and distribute verbatim copies
  of this license document, but changing it is not allowed.
 
@@ -322,10 +322,8 @@ the "copyright" line and a pointer to where the full notice is found.
     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
     GNU General Public License for more details.
 
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-
+    You should have received a copy of the GNU General Public License along
+    with this program; if not, see <https://www.gnu.org/licenses/>.
 
 Also add information on how to contact you by electronic and paper mail.
 
-- 
MST


