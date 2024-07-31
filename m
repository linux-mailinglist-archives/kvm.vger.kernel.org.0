Return-Path: <kvm+bounces-22742-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1541F942A6B
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 11:27:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F72E1C20D0B
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 09:27:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A05A1AAE22;
	Wed, 31 Jul 2024 09:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z9vjeVhS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E231A8C1A
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 09:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722418045; cv=none; b=fOoHXQJ6yk0YnePcQ+iFQUqN36M8Ncm7jsKmFlLAqSJizxbWlZQJPTmwy23UUtO1Ml7kIyR32ft3APL4efbAXMxgWiKL1JzC0wER/L9UY1FK7YdyBdBscT6OrFj19OYL9YESClV2UguX+nODWpsmwrzz+VBTgt+V3MKweYztiso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722418045; c=relaxed/simple;
	bh=mbnzezB2UMmjEjyUn7wWSub29nvt97B0Zk9VC4w5FDo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dw+ePlUVQ5+005ZlTFZFcJnP19JOEMGfg2g+yaidL3WY2O7EHy0kAu8C9MWXVcZipuV2fK/cXKQgZQahrbSL2VpheQvI/SpI1PfrjLK9flcPdkfnD1NnDMNLzA+M1eoNpW/eMzYvCyEhWQb0raH/KoAFdSfrwZ3Kt6ac+10XHpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z9vjeVhS; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1fc611a0f8cso38624805ad.2
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 02:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722418044; x=1723022844; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gcU+2y+gAmL68ia36FYMslri4pIx9WZ8sUTL5g3K7f4=;
        b=Z9vjeVhSl4GF1+kp0PvNfH97IucZM1JelkVq6NaCiruoWBkQwIkwD2IZuytZ1pbRZx
         N5W8mU3BHKChRuzliWeHzY7CxOiKK7BIxaDxPYxHuXLQdFF6Sbqc0Gv9RFPTG9LYJ0NA
         fvsJwxWqN4TFegKzYont4+EwoOTJFOreRKROHpTkO3ePKB2io7D16rsLpxN74/ghyrmT
         BsW8rGkt3T7OMOuB6B7czlQpcywxzMGkBpMr8R+fRJ6Cey3F+aMLcCbD1L9hjTMzJQ7J
         7TgWB5k0/hFodRWkAZ0lYc4MldJMstHe8w+e4D/Q+PiG67+P79+zaXdzZ/v6R7YkC/MD
         K0jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722418044; x=1723022844;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gcU+2y+gAmL68ia36FYMslri4pIx9WZ8sUTL5g3K7f4=;
        b=Tak7P5UmuW2wT9oGwH9tul2mywmowH0mwA9HZzu/BAUJM4PUysaE03PNAcO9IhAnEJ
         2u6jUSJHnX1XpTmbTi2k4wm+IKlYWXi1Fyp7i2VNR5zZNtZd1Va0H3EBlhOwGPmX/CEc
         3wro4tgDC17iz6KpS/BHEHypUm/VYQkVZcvVvc08dGyQSWZq6j+14ab/8JICVrdJ3+mh
         xLCfUyDFHbVzK2itwE4/tDYYAbnOcANRpy9lAUJJ/MA+sPc4JFcJv68ZsSZbXqpW8C01
         FTQwHIo9Cz36fZD+DM81LUIbqGt6Mxc/g5voddSjDMSpP3vQUFBy050LG4q2NON+J9/t
         11xw==
X-Gm-Message-State: AOJu0YzWn/xRHoM0Br1uUJsVwvqtuzsVahp8rgpMJfGXe9mWYwHJodbA
	USJsLMcjti4KXbPqChT+txmhicTNmGldAeGqE13qb8tu9KigjOYX741YwQ==
X-Google-Smtp-Source: AGHT+IHId6TUccdQ4UgLhakzsniLWqhAIlnYLMjzJcS2fGWh5MXD2evFVSkMBZRy76Cb1XEGOGptow==
X-Received: by 2002:a17:903:120e:b0:1fb:3474:9527 with SMTP id d9443c01a7336-1ff04828285mr122337825ad.25.1722418043668;
        Wed, 31 Jul 2024 02:27:23 -0700 (PDT)
Received: from FLYINGPENG-MB1.tencent.com ([103.7.29.30])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fed7fe9cccsm115387795ad.289.2024.07.31.02.27.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 31 Jul 2024 02:27:23 -0700 (PDT)
From: flyingpenghao@gmail.com
X-Google-Original-From: flyingpeng@tencent.com
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	Peng Hao <flyingpeng@tencent.com>
Subject: [PATCH v2]  KVM: x86/mmu: Optimize kvm_zap_obsolete_pages execution time
Date: Wed, 31 Jul 2024 17:27:16 +0800
Message-Id: <20240731092716.44159-1-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Peng Hao <flyingpeng@tencent.com>

Optimize function execution by checking whether the active_mmu_pages
list is empty.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 arch/x86/kvm/mmu/mmu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 901be9e420a4..e8abf4387d1e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6353,6 +6353,9 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
 	int nr_zapped, batch = 0;
 	bool unstable;
 
+	if (list_empty(&kvm->arch.active_mmu_pages))
+		return;
+
 restart:
 	list_for_each_entry_safe_reverse(sp, node,
 	      &kvm->arch.active_mmu_pages, link) {
-- 
2.27.0


