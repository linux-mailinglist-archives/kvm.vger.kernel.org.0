Return-Path: <kvm+bounces-17421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 09B4E8C638D
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 11:19:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A8DD1C21DB9
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 09:19:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8B4F58AA7;
	Wed, 15 May 2024 09:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="SeUnuW+7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6559457CB5
	for <kvm@vger.kernel.org>; Wed, 15 May 2024 09:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715764750; cv=none; b=NRdBgJRLTrW0PBcj4ZTuX9Jc/Ou0ERLz3+1fiKnyQVFNFarvjjXz5mcK+jM1MkC/tnM4M78fW8wqSaSvaS/Kt0lFhV1+3VzP+KIx5a/SbMfiPBc/IBvLhMyUKYnXBnpFY02GdHARY4Lz+8tl/2iIBEKpm02qZVsevvzZ05Ibe3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715764750; c=relaxed/simple;
	bh=1iM4uSo7N5ChAQpU1GRltuwncZG2R6PTUv8zhzfae2Q=;
	h=From:To:Cc:Subject:Date:Message-Id; b=I6Volu5Q+bjNFNbuMAuPnFN0rq4RHv/BVHOc83Rm1s+la2ZYfvSSZISAzJcTyUpIJ3yhdcU/HTXO715KP7SU0u0yNGTONRWwXoKTswrzMhYi8N13bdXYljhAZcD8NAJ72rKQHldu7bmlaX0kXcO0+t8RYb4Sh0Mw2mYF+zPkGGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=SeUnuW+7; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1edc696df2bso57434435ad.0
        for <kvm@vger.kernel.org>; Wed, 15 May 2024 02:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1715764748; x=1716369548; darn=vger.kernel.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7BVwu4rFW+94AWdY34I4zNqztX5CFLn1Co//HIXJxwo=;
        b=SeUnuW+7dFMaf5YIDYb8AUxk5mleLXWz8GixgfBj0nA46Z3wmUiuWE7smdggiY6bbl
         rnIbPbTS2WTAdzuSFsU7o3wYUU7DhJJsMHQqGLYo9l7CuLnQtbpmKj5r5Eetk0JbRvy3
         dLSPWyxm0eaPs4+BFWdwmSg6mjfBhTmSYaX+TBuBSCoSqk9prJUOIAtIvSC2+CzD1+Dt
         7ZsfiU8RG8T+es8igZewSlvTVNp/2jO3zAlYHlAj5tk6Nins27IXYALu9mGwVDqVdmSN
         P0RJ3jbJDOIAlZLqrAhkceAfNUgbZh19/lnwgnFQRZ1Ho8CtqWZaWZDvvGCVqu2xST8C
         IGyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715764748; x=1716369548;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7BVwu4rFW+94AWdY34I4zNqztX5CFLn1Co//HIXJxwo=;
        b=TVmoL0g1bma6RtjgUDyPFUK57W4yJ8Y1fU2dn9N2FkqhoP5AYViHqeCYGWnY59ZWvo
         95Rom317heBKyG7c4asKAqME4oHyQ+7STPAp+UI65eCjtDdsXquzyuqRFO5HXJtOVMii
         UJnbzu6mS7I5EqnSsGgdjd4I+wJx4IItFiXVQy+3YPNUkFNyyWUqLbVNA3lbN4P11z4s
         6twPCtORD0GMreJLssNqNPVG4gB3anPGUNp97PBPVVFTGchnAFYHiRgWH4GA+Ju6asSU
         CSIJ8teOQUMtGcF51sUifc2cjgyUKnLoyrAfHW+R2AxLeEMnZJW3vn5UZg8xyDkzhp1t
         pmWg==
X-Forwarded-Encrypted: i=1; AJvYcCW+IRzWTLHRjMYk5O5cZbMJgwueN/8ipLrHBsEQ4PuLmkbOpkv6JoHdL8EU1NKYVA6L+NnuljK+rMxJy0IVS0n7TroO
X-Gm-Message-State: AOJu0YxnrngD1fXMwK7E+IxUWQUPRt067qTya1W11NLPdUyz8bCIdlRX
	yzIrRRJQgBY/1BzYvMoTr0Qs2ztREPe2CCJuQ0rQu3LxvGFZ2C2t1R62Qi9rbgo=
X-Google-Smtp-Source: AGHT+IHd+bGn2VdihpmBsU2mDilPtuwmXZVyUBsUgWxgGdm5kBZ7KndTQoemyKqz0sjI6URDkBfnlw==
X-Received: by 2002:a17:903:32cc:b0:1e2:3720:e9b4 with SMTP id d9443c01a7336-1ef4404a0bdmr183568035ad.54.1715764748578;
        Wed, 15 May 2024 02:19:08 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0bad99a4sm113297935ad.81.2024.05.15.02.19.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 May 2024 02:19:07 -0700 (PDT)
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
Subject: [kvmtool PATCH v2 1/1] riscv: Fix the hart bit setting of AIA
Date: Wed, 15 May 2024 17:19:02 +0800
Message-Id: <20240515091902.28368-1-yongxuan.wang@sifive.com>
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

However, if the largest hart number among groups is a power of 2, QEMU
will pass an inaccurate hart-index-bit setting to Linux. For example, when
the guest OS has 4 harts, only ceil(log2(3 + 1)) = 2 bits are sufficient
to represent 4 harts, but we passes 3 to Linux. The code needs to be
updated to ensure accurate hart-index-bit settings.

Additionally, a Linux patch[1] is necessary to correctly recover the hart
index when the guest OS has only 1 hart, where the hart-index-bit is 0.

[1] https://lore.kernel.org/lkml/20240415064905.25184-1-yongxuan.wang@sifive.com/t/

Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
---
Changelog
v2:
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


