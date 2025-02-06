Return-Path: <kvm+bounces-37421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 54456A29EC8
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 03:28:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8968C7A290F
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 02:27:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B79613AD18;
	Thu,  6 Feb 2025 02:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g4AAzhXm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD792E62B;
	Thu,  6 Feb 2025 02:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738808885; cv=none; b=ET+yiP+iguZTyzgCSGoztPjlefNsnsekcVG9zq6CQ/+lCyklvYFBLegSx6HmwMtBDRvPnqFUsN5ZJjO3sn6dY4O2uRIEuKB88TO3vb92jwpTwqL5ZVB69M9Aoq2PnziJD35sOF6qYzMvhM65t1sBqbKDlA4hm4V7zryA9VbjWHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738808885; c=relaxed/simple;
	bh=DPw0go0Y18F04glHsPQpVXcm7nfmsAETxFGR+REmBFw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HYtu+tGIvbW5HJ/vZ2YDhEAI9Uf3RtQ/hG6yAyMW/zEXhLnKLHjtBztRT7/9a1BlATRxZj10S5PeTq0QmZ03kqfzDyuwiVtRdlaYpil2V2L9wXvfm4eMWMNu6fHsdrkOKraQB0aNhPuqXyVfuTphNomyvV0OWOmzzQdvCr89Tm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g4AAzhXm; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2165448243fso11809435ad.1;
        Wed, 05 Feb 2025 18:28:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738808883; x=1739413683; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=f//6Pfy0m+QkunQmAbDm03FlQjJ3Qr3k1+W3orkRYWI=;
        b=g4AAzhXmV0+eOREkR4jruxqwuWxQOxvXA9uS7fTf2HDCmyfJdZlDrJ6G3TmaGwd9YK
         MC14vVRWf3qKVaFeAq+GrGAaTu5TSsYDbDL3BpZrRAMWOsIJ9kWlphbmOLtDn4rVTS24
         IL59wFwoyyKCNZwbOxCJp4d4yshJZD6Kdn8vG77GGXE3EK5TO35UvAq53WXOmRCCRbIz
         L450wXFzV+uC300F5w1/WNXSv4bbt6WqF7BHEXjT+jmN0R69KE5k1bzWnZlo1aXV4898
         2GYp9VCycLTvV1oUVwJ+qU+Xa0hflz0liOw11NE5CcFloBHLKNG0AFY1SzoVRCd86elv
         Ynew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738808883; x=1739413683;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f//6Pfy0m+QkunQmAbDm03FlQjJ3Qr3k1+W3orkRYWI=;
        b=VAEC798W3BOco/GG+Cuk3BnU0qXIB8Ouf9oqV4DvKUsOJ85KLbCWGSV+rsAAAr1KVa
         lmWWRtre+moPa4/SD3nUrHrsDM9PKadbTFxkIL0oXMv4ccxH4Aef4eucbS22RoVC8uD9
         5k8avZFhL7YcFkjt7eoUZB5CiHvQ7o+ayT96aHQfxtVGBxagfYptKRnqM9OYyAGNGB+S
         AkB9JirJAPrgNXGCZpRGIeC/JEIcMnsCFRJsqgh522MuqXKpUUHaV8BmxFrhd6GzDMWA
         HygdNDUWqM5Dg1aPNBM3Ohzm5E0+EffFQi+5uSNiQ7adAAFizwPyxi2I2LvW0UNggZEb
         6oQg==
X-Forwarded-Encrypted: i=1; AJvYcCUYxV2lwN8W0IeAydSholWwvdXOjQOmH2DWGyYMjG+gUxgGSE0iNl6A0WdZmCwOSVUx47+OjFghQVxMf8w=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVN19oGX5vKCgW6Av+kKWrdPrsLk/XqMh29C7i5ygqnCocUkdO
	yXBfFB/1D8OB1KbU+PsDp/Lki1960cjerXLdUtIWoTeMHWkFVL7c1gLvyE/7ixY=
X-Gm-Gg: ASbGnct3ncMsra3/1O0cSvBn7Welif/ugFSpFJgLUSC3q6VX9GSLkVrMAFZIzyQzpUt
	+wItFGiz0HV4LYcaPmbvXnVRpRmOab4gCtAdl3tbw7ZC9RNkkclSHU0dZJFiCJkb6MqR9poRTmP
	dm8p99KIKWrL1jcabDdovJs9ZA2ZZQBK/di8ql+ydAalAinxxxfWT2+67V/+oJXgwuRNuDXRvOf
	P/0Q5aqwsznxNkKWYp52Ifv8fenf12f9YYW9MAR898dkjiwNnL90ArqvIrnzJEKPUjW4nGDOi/2
	WbO8fzzUWH3vMfdZEdO16ZrFGIyWqz4=
X-Google-Smtp-Source: AGHT+IF7i4Ie6oj57/Bqz7uVn9oDviSllTX9XOv0hdUACzbYl5F3ZNLVVNVU2I6gCiRA49ou8epBsw==
X-Received: by 2002:a05:6a21:7101:b0:1e0:c50c:9842 with SMTP id adf61e73a8af0-1ede88ab965mr10830856637.31.1738808882916;
        Wed, 05 Feb 2025 18:28:02 -0800 (PST)
Received: from localhost.localdomain ([116.196.121.10])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73048e20bb4sm151605b3a.164.2025.02.05.18.28.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 18:28:02 -0800 (PST)
From: fuqiang wang <fuqiang.wng@gmail.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	wangfuqiang49 <wangfuqiang49@jd.com>
Subject: [PATCH] kvm: delete unused variables iommu_noncoherent in struct kvm_arch
Date: Thu,  6 Feb 2025 10:26:56 +0800
Message-ID: <20250206022656.3752383-1-fuqiang.wng@gmail.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The code of legacy device assignment is deleted entirely in commit
ad6260da1e23 ("KVM: x86: drop legacy device assignment") and the
variable iommu_noncoherent in struct kvm_arch is also not referenced by
any other code. So it is deleted in this patch.

Signed-off-by: wangfuqiang49 <wangfuqiang49@jd.com>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b15cde0a9b5c..98555afb6f10 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1354,7 +1354,6 @@ struct kvm_arch {
 	u64 shadow_mmio_value;
 
 	struct iommu_domain *iommu_domain;
-	bool iommu_noncoherent;
 #define __KVM_HAVE_ARCH_NONCOHERENT_DMA
 	atomic_t noncoherent_dma_count;
 #define __KVM_HAVE_ARCH_ASSIGNED_DEVICE
-- 
2.47.0


