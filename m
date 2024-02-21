Return-Path: <kvm+bounces-9276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD9A485D14C
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 08:27:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78AF5286EF2
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 07:27:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D2593C491;
	Wed, 21 Feb 2024 07:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="RCsgoIja"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541C23C060
	for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 07:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708500365; cv=none; b=GIqyiZ8semwDsuSkvV/aXu5Fz+BzTEQcc+tmFF3hTQgqS2XMxKtDevbi/wzej7OnITN7jmjzSTtPppqet8uv3RgNwf5YuJBqRUr65YC37H5ZfP6K+E7u+iRyQcATmSsUzU0V37PGv30DX1w799y1CGwZcdVW0z7Bmc7Cu3JWRho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708500365; c=relaxed/simple;
	bh=Eal+RK83X0qlcGcNEk7z0E4RBKeo7UGh4/zIqBRmhh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qMZP2r/WF4WWeGHCnFKLWYvjv8jTkel/+EvOD+i+HEmFSJL2KkUGgQHY30GTNmmjU19Q6OZstVfEi2XfOv5T99RW1Z/qLygmIJyA/C2GXwf4vLRv+kbdq/a8OF6ck0s9pPu3Y8DSn0gndfZJu1hy2LAa5DkRQGUBHQ2Mae97v7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=RCsgoIja; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1dba177c596so35180075ad.0
        for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 23:26:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1708500363; x=1709105163; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WLOffij4aJB+MGCya8s97VNV+p1K3jV5QIE+Q+bz00I=;
        b=RCsgoIjaY4LMlPmm2Edxq6CXzr9Xcd52w12tT2X5R7mBMwfY47Qh5R5XGbqdxgeIUX
         2+zCD8Zsd1zSlF2xVDzwYDam/c/qSDKc2CacnFlNrV3eLXw12JxfEIdmDc5viedNOhu1
         if/aBKnA7SxfDewu8Q/5sdckYA6yqJJ/g4h/I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708500363; x=1709105163;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WLOffij4aJB+MGCya8s97VNV+p1K3jV5QIE+Q+bz00I=;
        b=wzfw0qgtRVvJsox12ksFkJEwIKxhgUbzVrTYSQBqVRGaEaVP6AKN87mU5WKY9BIaoi
         HqMuKdAKx1p9AoL3bd+KtlnrGwj9LH0fuFMHh7VWq2lvqgmszlnnWrPQLGJ62E76MJ6J
         IVEl2EXIfsLtq1U/J9IxoFUoze2vqJGMvW9g9Y7x/L/PiX0l/TFwh0xdbUTN8aOmZRI9
         FkwxotG3BmcrQyJBt+ieDHEeZRVUh1oxeqUffV8rtaV5EJnZwcBLQkhXklkCFUHWnc6J
         bF7By58SB7i14Zyp30R1GgPOjjbaQd4xnlJiLyw8JAAzcya3INHOK8HRm+T/RHziDxd6
         0Dzg==
X-Forwarded-Encrypted: i=1; AJvYcCXZ7PsuK8+1R+QYX3grFLX10NPXDjiQ3rHPPYhzAlM26nYooTjT1K093o9ilu/2MO26c2Djz9RORkk+fNAOWGIE5u7Q
X-Gm-Message-State: AOJu0YxaAUUy0pIaFygC2qBbGIlsvJfBFj81MKDrd32qohWRXMT7FzE3
	gsrqiQ0mUsJR/phpSobxEhUAdFUhwxxH2DnMWk9eDXvwLCBHoWkZf2nEl5OBNqZz53qx11K6lVw
	=
X-Google-Smtp-Source: AGHT+IGuByzcDeNqa0h3/F4p6FUZXddbiOGTGnCFrf3ufIz55abOi6o/JeNcHuNQgDfA/CeMO+SZRQ==
X-Received: by 2002:a17:903:2282:b0:1db:b5be:5981 with SMTP id b2-20020a170903228200b001dbb5be5981mr17305270plh.31.1708500363442;
        Tue, 20 Feb 2024 23:26:03 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:b417:5d09:c226:a19c])
        by smtp.gmail.com with UTF8SMTPSA id t11-20020a170902d28b00b001db40e91beesm7415349plc.285.2024.02.20.23.26.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Feb 2024 23:26:03 -0800 (PST)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	David Stevens <stevensd@chromium.org>
Subject: [PATCH v10 2/8] KVM: Relax BUG_ON argument validation
Date: Wed, 21 Feb 2024 16:25:20 +0900
Message-ID: <20240221072528.2702048-3-stevensd@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
In-Reply-To: <20240221072528.2702048-1-stevensd@google.com>
References: <20240221072528.2702048-1-stevensd@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Stevens <stevensd@chromium.org>

hva_to_pfn() includes a check that KVM isn't trying to do an async page
fault in a situation where it can't sleep. Downgrade this check from a
BUG_ON() to a WARN_ON_ONCE(), since DoS'ing the guest (at worst) is
better than bringing down the host.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Stevens <stevensd@chromium.org>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c5e4bf7c48f9..6f37d56fb2fc 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2979,7 +2979,7 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
 	int npages, r;
 
 	/* we can do it either atomically or asynchronously, not both */
-	BUG_ON(atomic && async);
+	WARN_ON_ONCE(atomic && async);
 
 	if (hva_to_pfn_fast(addr, write_fault, writable, &pfn))
 		return pfn;
-- 
2.44.0.rc0.258.g7320e95886-goog


