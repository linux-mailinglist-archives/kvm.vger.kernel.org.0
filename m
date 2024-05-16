Return-Path: <kvm+bounces-17498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 715A38C6FD0
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 03:06:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C6F8283E7D
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 01:06:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3362E10F1;
	Thu, 16 May 2024 01:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="HYNyei+O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4655464F
	for <kvm@vger.kernel.org>; Thu, 16 May 2024 01:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715821578; cv=none; b=dUA6fxX813HTH72HZn1lylC2xD/fTYFZ9eihl7lp5IHrKuUBkCsUX+ewdgfBPKsNhfurMGGZLwCvhEy6+zI/rfBCSY7EIjUz4tWkQnZuqiAkC0NDjOFyCHeJPzQp6tuUKjEMGuQAwr8rqyHfzOFBBx5XzGewidNkGySPwNGugJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715821578; c=relaxed/simple;
	bh=nTBHcaEi30vhNO4KJDsvNSUVVFKzWlM7Pxn1UDw77jM=;
	h=From:To:Cc:Subject:Date:Message-Id; b=mfIChng81iqIEAIypHEWISgVwk5774m3KMmxKvgBn6ODb4FzWTmA6ht/+anl+Hx9Sph1H5yUwm5mvmlThebq3dU7720XtQX5ztPR3/kcAeRHKNVKTfc7tp7k2cci8dfpBBmkIcr8n1vw+qqdsz2qrfR3AO8H2wad+x91ii/qhMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=HYNyei+O; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1ed012c1afbso58887475ad.1
        for <kvm@vger.kernel.org>; Wed, 15 May 2024 18:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1715821575; x=1716426375; darn=vger.kernel.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A/UFcDnnjy3pyeAsdnnlsyXeGMcrQPBnwopB90N131Y=;
        b=HYNyei+Ofqdt+UWGcygUKYaiI7OFoMipZM+Vkiv0fy2rHyoU1kcbSTC9DEi1356F/j
         saAdFNpiJYc0WUSseLmdsC2JwOTzCBAYOgUGrOVK6qAsL3SwwCNgUD5GpcdVmMk3J7rY
         JhRYe/YgBcCR9XCBdzeRvqO3mJNB7cdL5ONLYN24yq7WoXJruDSs+S2PfzmoOMcdTHqC
         eCrijidtfPEFMZX5bghOk72wQfdKIwXRoB5vIfJ0KGcHkx+CMGiahjIGr8dMVtGJX4m3
         kXyfwSEIlEZZuXwq3u7ef+hWff01abWMc2xCb63sK1hcBSPlWKmxkrj1xp6QwVb3W1SC
         yGNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715821575; x=1716426375;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A/UFcDnnjy3pyeAsdnnlsyXeGMcrQPBnwopB90N131Y=;
        b=lPYyh0za32WHt2J221rn+ozSRZ/o+7ktoNemx9s+Sogz86gslPvEYAwBWqOcA526WT
         8QZ21j5pONkHMnCygP+hmO3Ogn0WEFfX3fRHEvk+r+6Yuwvfc1IvI8qeJa9qs3e/IdC0
         BsC0vi9OyyUBfOp11WubKgYI6POsiPVHJIw1MBM5PV9+W2a+uxLtrAoXQKqSEAzDi7Ve
         IWOhu0RuTrhW6FVIC5I5L5LRMU/9dikkc6vjTqE5qeGXyDteWueYtDlE2906f6EzwNnX
         +7YQkpficRrTT6Q15QeV/8rggjFLAlhdo97jELhWPFcDT2KWFkXAHOpA4P7jCfHagEDo
         JI6g==
X-Forwarded-Encrypted: i=1; AJvYcCWnKvCzWDCgg7HiqlLNLPVTtueF+1mEdfrN4A6Jko6bJPd2roKxNk08VvU+MRO4zA3YosRThkb1Jyh9YhWayiZfd+1c
X-Gm-Message-State: AOJu0YwWs1iMYnm9CBPFieiKDMcGE51jfGSdJHJtT0RIRe4rJ5v0tH69
	pbEAh85zsZeK+ABoCnP/84kslekSNl3UcsBv55aYcl8VpteZozIAm8GqF4PeH2w=
X-Google-Smtp-Source: AGHT+IFWQCLfM9nDqO4/Vzf0Qykfi/rGKbCui2qknji+9I132i+xvtmVL4rM7HV3QXYTYGm9mnJRMw==
X-Received: by 2002:a17:903:120d:b0:1e3:cf18:7464 with SMTP id d9443c01a7336-1ef42d69b44mr229915525ad.3.1715821575542;
        Wed, 15 May 2024 18:06:15 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f0cb2141b0sm2054875ad.285.2024.05.15.18.06.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 May 2024 18:06:15 -0700 (PDT)
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
To: linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: will@kernel.org,
	julien.thierry.kdev@gmail.com,
	apatel@ventanamicro.com,
	greentime.hu@sifive.com,
	vincent.chen@sifive.com,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>
Subject: [kvmtool PATCH v3 1/1] riscv: Fix the hart bit setting of AIA
Date: Thu, 16 May 2024 09:06:10 +0800
Message-Id: <20240516010610.30013-1-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

In AIA spec, each hart (or each hart within a group) has a unique hart
number to locate the memory pages of interrupt files in the address
space. The number of bits required to represent any hart number is equal
to ceil(log2(hmax + 1)), where hmax is the largest hart number among
groups.

However, if the largest hart number among groups is a power of 2, kvmtool
will pass an inaccurate hart-index-bit setting to Linux. For example, when
the guest OS has 4 harts, only ceil(log2(3 + 1)) = 2 bits are sufficient
to represent 4 harts, but we passes 3 to Linux. The code needs to be
updated to ensure accurate hart-index-bit settings.

Additionally, a Linux patch[1] is necessary to correctly recover the hart
index when the guest OS has only 1 hart, where the hart-index-bit is 0.

[1] https://lore.kernel.org/lkml/20240415064905.25184-1-yongxuan.wang@sifive.com/t/

Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
Changelog
v2:
- update commit message
v3:
- update commit message
---
 riscv/aia.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/riscv/aia.c b/riscv/aia.c
index fe9399a8ffc1..21d9704145d0 100644
--- a/riscv/aia.c
+++ b/riscv/aia.c
@@ -164,7 +164,7 @@ static int aia__init(struct kvm *kvm)
 	ret = ioctl(aia_fd, KVM_SET_DEVICE_ATTR, &aia_nr_sources_attr);
 	if (ret)
 		return ret;
-	aia_hart_bits = fls_long(kvm->nrcpus);
+	aia_hart_bits = fls_long(kvm->nrcpus - 1);
 	ret = ioctl(aia_fd, KVM_SET_DEVICE_ATTR, &aia_hart_bits_attr);
 	if (ret)
 		return ret;
-- 
2.17.1


