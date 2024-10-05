Return-Path: <kvm+bounces-28012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EC255991534
	for <lists+kvm@lfdr.de>; Sat,  5 Oct 2024 10:01:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2B26283934
	for <lists+kvm@lfdr.de>; Sat,  5 Oct 2024 08:01:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13311130A73;
	Sat,  5 Oct 2024 08:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Sl7k8dk8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6ED13C695
	for <kvm@vger.kernel.org>; Sat,  5 Oct 2024 08:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728115260; cv=none; b=Ri5rn4+HywgnMvwF7q/AE1m7AotrIFo2XMrnMCji4hlBFikAobT60kG8lQvW14nZGDTlXFKReqPXYQO9ZDJY2K4CKIaDPrcV3BB2dqqdgpAQyz7cBK7hwFyMG3ZIeXzhFOBq47A48FO512l2OGuSyh6f/BqIA16BXyLMDh5sOK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728115260; c=relaxed/simple;
	bh=48fBplDQf/5b31hPKpVYiFGrrKJCSEau4WtSsTZiRoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=msy8jJHxIhHR7Sj5sF6+9moqdfSFn1XcgbNf28sxZh1NginYOTlZ3f8QXfc+mcNvdt/E1gWJHxksSuVZdQxECYCNLgx2ToGTCNbRHJqsub69Oz36P1GIs7qbkyFmCwvBU3rYJX3i7akI4p8QTGKBeWg9UKjWWCEOz1e/OgVupDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Sl7k8dk8; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2e0b93157caso2845372a91.0
        for <kvm@vger.kernel.org>; Sat, 05 Oct 2024 01:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1728115258; x=1728720058; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gp/7S79lB5Zh9ge2+3juA9ZZ6e+lGqyh8phLoy4Fqkk=;
        b=Sl7k8dk8bKTzkPKMpQxH4E2ZLzodWycWe690yTikpc4daGSyg5pCz5F6mFOY8PxtXj
         42VzjEj7Mu2cdJTgVNQF9r/TfbdQ3ttHa5ZsKX776ZRDNaKK2DWfjEhyWVPEC8RdTK7o
         zVQOCf78vSt5zEI/4DOhF02O7hNPp6WWVnL9QHV8NRBiWLJ1OaKDNCz49f+FFIuQHQg5
         qZIqK4xSHCE2LyvR/tjxhhaPg6BHpfotbziscwSpUZnfKndnp5Y87Kme7P0lBTujXpXq
         lT9smEmKDQmKIjGTybh7MUptTtNF3QDLZ0fmqLx4R0VtyZQt6ZzqbXY80aRB4khMwGku
         fccQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728115258; x=1728720058;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gp/7S79lB5Zh9ge2+3juA9ZZ6e+lGqyh8phLoy4Fqkk=;
        b=gn4n1Abwo9rY/OAqbOR8zlJnLP1YvS+fc8Nl2HQvnDULSRv45+pE9klWNvyLqvuGD5
         v6x1MiyzXDRkmlj7JUOKOcPbI94hHvk8FMkQW6rR7wBR5G0lZkfUMlzH4w9WvCyz2XJ3
         3jtPFIPqbw9g1yE65upZe1guSO8QHsDa7SappsVJqQMk5WFqiMBe2hmr0m+33pCc5lQo
         Yhu58XTQ2odWVZf2i4wpApdNjAmcT5fSa3myVSigAbkte1AeXJ0xyRLywYJJUfXNh8Yz
         m17doPw+8q44eK2lQndYKXcWykt+sYYAewttcfWElroDDheuNaoqLAdAn15XCal+dDAD
         WMeg==
X-Forwarded-Encrypted: i=1; AJvYcCUnppZSdvqLDOM4JQXVWEKnCXgJFrdJQUVPW8VKFXvlPxnCU8UVDBz1giVITaspTAD5KqA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjluIj/IW/EfyCjSfVD/+lEd+IhSXVuH9Y8VwqypC6pJ/acRHv
	hR94XBbzQWiq9fdCLBkUX0Ukg30XTvHQAi9jCG8fiGGcWQeIl6spdwVVO0DDoDE=
X-Google-Smtp-Source: AGHT+IEDZJvYZpmKhOvnAXoBzEjVj+AbmrCTo3BeIUBTxFpCKHeb5hYPdw96NRfXJTvlxB8Q4+bATg==
X-Received: by 2002:a17:90a:3482:b0:2d8:85fc:464c with SMTP id 98e67ed59e1d1-2e1b38c6e58mr14082877a91.11.1728115258179;
        Sat, 05 Oct 2024 01:00:58 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([223.185.135.6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e20ae69766sm1259172a91.8.2024.10.05.01.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2024 01:00:57 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Will Deacon <will@kernel.org>,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v2 7/8] riscv: Add Zcmop extension support
Date: Sat,  5 Oct 2024 13:30:23 +0530
Message-ID: <20241005080024.11927-8-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241005080024.11927-1-apatel@ventanamicro.com>
References: <20241005080024.11927-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the Zcmop extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 7d8a39d..768ee1f 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -36,6 +36,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"zcb", KVM_RISCV_ISA_EXT_ZCB},
 	{"zcd", KVM_RISCV_ISA_EXT_ZCD},
 	{"zcf", KVM_RISCV_ISA_EXT_ZCF},
+	{"zcmop", KVM_RISCV_ISA_EXT_ZCMOP},
 	{"zfa", KVM_RISCV_ISA_EXT_ZFA},
 	{"zfh", KVM_RISCV_ISA_EXT_ZFH},
 	{"zfhmin", KVM_RISCV_ISA_EXT_ZFHMIN},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 09ab59d..5d655cf 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -85,6 +85,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-zcf",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZCF],	\
 		    "Disable Zcf Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zcmop",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZCMOP],	\
+		    "Disable Zcmop Extension"),				\
 	OPT_BOOLEAN('\0', "disable-zfa",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZFA],	\
 		    "Disable Zfa Extension"),				\
-- 
2.43.0


