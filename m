Return-Path: <kvm+bounces-36469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DE3EA1B123
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 08:51:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83E9916D25B
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 07:51:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57C4A1DB139;
	Fri, 24 Jan 2025 07:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lyaoeqhk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214F6156991
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 07:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737705078; cv=none; b=teiJr+XwmfZfR+TsTMw7BkJTf64U/VrVz5CZzmnBRv5qCqMjUirwG1gAzZe697m7AjRpLI6T44FORzCvOSk6h2SLwuUGW1lYfCfHLljUI2FfbD//5/Thcaf6eGCcOr/w6BQh72X7/G1DABXHsuN0li9ZTOVqnNtcrOP4w07thqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737705078; c=relaxed/simple;
	bh=WROXb7LX81HPDhayD22s2nSfRBh8Nfr5IKmB803aKLA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JsKp6Eo85urlWCh9rWkOWHsHnL8lekmbXbVKTuglpKXFb/2RZpWygyc0+jrN8TmodTbOlukNAcgQd/yKLTuSMZf8np4DRtR3EoW6/Dq4GLRsgHJWz2voFF1yzhbSVeriKyYlhIe/8JqDSGStZ39rVMV6zRVtW2nQYNpz96jlxh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lyaoeqhk; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-71e10e6a1ceso467747a34.0
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 23:51:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737705076; x=1738309876; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QUk1cUbIeqkaSgpmSq7UPSiJxZgFd6SUDhx+JdmeF3o=;
        b=lyaoeqhkU2DVrNZCQjiM0KfIc4DQa9zHazyg7nbLSA3YkgAu3sYKSGaL1zUjW8p6lI
         o8PsqwE6TZ8DIypWi9YxPAUNX37Hf/l7GxhaFKjXfoXnYYphlCMfflS16vRnfbNMvDKi
         rJ3BAhuhhjyo9FSMmlTPZ16Mhv0HnVFXQt1eZ5/+pwUOY6HiRj6WYHFKiR3zOowjtz+J
         CxuRg2WY+KQNgGxpuryqGJXC0DL3aMFwJpsp5XgOAzq6HDm1QpLW2vz30mrSJMxn5zfX
         9zLNGy5Nw7JpD/GLlaHNgj89do+ebOCvcq+yMtv9fJx9ep104oebup5MgRTaPSxrVeee
         wLXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737705076; x=1738309876;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QUk1cUbIeqkaSgpmSq7UPSiJxZgFd6SUDhx+JdmeF3o=;
        b=aqAp66f6El7mh/AvxYFQ6ZShnSO3LLzY4SEkFWucvAn/Qw9xRjPDNFe6mVQktKpGMP
         8E8ZKnWcOEprulE7zOqqBf8OFOn6Ypx1VTjAV3dXlsUWMQ50Fp4PdqJ/0GMvdmJKphEn
         zMSJcMF0Rq14ovHYyZ6UXiQnvm1mciPYSeKKxVzzuaPvSV3BXgvuPWayemKuSmwUe9E9
         sUZAu6NyL1qdSvj6AQVMa6FazBid40elDWZXIvkB9ez+gdzTKMoLsT0KJo5TzFMmx2bm
         nwaQD8QjcX6oams4FpfWVO8JQ3UoammJkPSzkUAyCkhHJOAWAfewtpU9kHmw3h8qCEej
         bhEA==
X-Gm-Message-State: AOJu0YxlzsYx5sfNn5WrvM07+MxTffbiJvkLW7JbnTHDan7lsuAhcc1q
	0GveLQJw8blcB0x0CJp5YGAT65qjNDhvanWVE+tTbVKissPAE3M=
X-Gm-Gg: ASbGncuRNBgQVCFl1yGwh8mrnZYYkqyqssXHY2bxEZVqdnKoemvxDbvpYzrRkAExjOL
	mQV9mXQ9+II2L9SHDwZe4iWvPUyewnjDhQyO+QzYB7dle5yH8AKZZlx8LGENiFIrdnWsgX+OkBs
	HPYqIP0nAyV97xmU/dwY9ayhDUb32ij6rlIC1kSAgGQlHyACTcBFu98eerxe/8JDbWRIiI6mQ1X
	iqAJTtfvljsr8VWASpfOiHKX3gGy9PGaTtGjLAGODha/bXn7z3rXTJjEOVBcOTiKU+CzvCsG6HR
	jl7Pptg=
X-Google-Smtp-Source: AGHT+IFFaAFiTHt6eWBR+XZaFHQKOn8JVzprARbZ7QQ9adXau4g17bKOTUl4eBLLIsqi1rMUS52KJA==
X-Received: by 2002:a05:6830:618d:b0:71e:f1:3df with SMTP id 46e09a7af769-7249da57fb7mr16100422a34.6.1737705076067;
        Thu, 23 Jan 2025 23:51:16 -0800 (PST)
Received: from ted-dallas.. ([2001:19f0:6401:18f2:5400:4ff:fe20:62f])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-724ecddbee3sm327908a34.32.2025.01.23.23.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2025 23:51:15 -0800 (PST)
From: Ted Chen <znscnchen@gmail.com>
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	Ted Chen <znscnchen@gmail.com>
Subject: [PATCH] KVM: x86: Remove unused iommu_domain and iommu_noncoherent from kvm_arch
Date: Fri, 24 Jan 2025 15:50:55 +0800
Message-Id: <20250124075055.97158-1-znscnchen@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the "iommu_domain" and "iommu_noncoherent" fields from struct
kvm_arch, which are no longer used since commit ad6260da1e23 ("KVM: x86:
drop legacy device assignment").

Signed-off-by: Ted Chen <znscnchen@gmail.com>
---
 arch/x86/include/asm/kvm_host.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5193c3dfbce1..c75156fdd395 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1345,8 +1345,6 @@ struct kvm_arch {
 
 	u64 shadow_mmio_value;
 
-	struct iommu_domain *iommu_domain;
-	bool iommu_noncoherent;
 #define __KVM_HAVE_ARCH_NONCOHERENT_DMA
 	atomic_t noncoherent_dma_count;
 #define __KVM_HAVE_ARCH_ASSIGNED_DEVICE
-- 
2.34.1


