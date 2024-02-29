Return-Path: <kvm+bounces-10340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B28186BF2B
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 03:59:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3698828613E
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 02:58:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F29BC381DE;
	Thu, 29 Feb 2024 02:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Od541j0o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA4538388
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 02:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709175498; cv=none; b=Bd5SqVHfX5Y/mUpIA+6Wwld8nS7NgpakGkOwL7rsYzq4NbHvu0euO6MemPgMxqjCwrJu6n0zpcSDGNmtHJUtVQecfcMYs5g3NoZHoPVG4lWjmuYakvO//qYrq3v6sunawP7i5QuV9aIYUT2sfcNxlmtNDhrxBNhLeyUv0WkDNc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709175498; c=relaxed/simple;
	bh=vBxpG3Dz9ZyzQmLOVkEwkMADJ6mdtbcyVLq+Z9tdtMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfrj1RQWu0fi7Kb9hkHr9gpIxatN6zPUkEk0cKrYav09l44h0ypd9KB73yfSJ/8nYNDZRLRhPSEVB/q0/UpD5hu2O8lXuPMR1h2IfPfLhTxr0CDjsa1dfnoSMCyTftGcPWvK0ZXlt3uoChnPxlqMR70ce59cCswNbPlBuq9bD4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=Od541j0o; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-5ce9555d42eso304558a12.2
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 18:58:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1709175496; x=1709780296; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DqzBf0lbp1ARHQDBEkHQmEKBBGeWS/SzkM01JYF1z0o=;
        b=Od541j0o8r+l+813ZW6A63LYTtnUz48u1QrOxZ8ejUtOwR0zg0WrWI/dyD3Z9WuPcr
         GCPqD5el18IKluc49eM9k2Vs8TAFpxK+7qTE/pYOviYsCCqQkbalD6oQi1oZw/Q83RF8
         DoKinC/gJLAs9Mi9xpHEENjFW9V28EBNW54WU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709175496; x=1709780296;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DqzBf0lbp1ARHQDBEkHQmEKBBGeWS/SzkM01JYF1z0o=;
        b=KTlyjgoGEnpLtq7TmupRG8XGMFaPoL+LAY2OGjhF87gvepArNDF1pXuKK8ubLNj4zh
         zOKQ+qSjMX8RS1P9nUDFbL5LJzLkYnxApHhCMFw1Xk/81QLermOwRjT5CxpdRL4l2bI3
         us9EvaAfqAvXecH5TK810z1svjYZ04/V6DPZH/AIbZPFdJCNjscr6XzQNJDF53m7mGgf
         BfvDclRSBCrZ2EMaNKnKNdpLp3YG9frSS1nJ6RCq6N0yJhhjjawt+VyArUti1T5aykGA
         k1dtX+gnnEudSOiXlClOtQ6Uw98Tl3l2gYN7ZLAaWYWlO5TC3HW9om/FzUGKRcntQpEk
         f+/Q==
X-Forwarded-Encrypted: i=1; AJvYcCX3GZXZpNfxpndHt0I68K3VnT//9jmzw42J/SF1bCKUYqQNOswxhWXBhmypGnM/aDA0a+WNEfhtbGm8fhhXQlYT3gh3
X-Gm-Message-State: AOJu0Yx/W4Dt1iTpoI8eDYP13oo7SiGbCqj7iHarpZr6ILEGbWBtPW0K
	5/PaRpN8b1zn126Lj+xtwAW7BUYEQr3HNoInE3Ve5NKK4KtDe/pAOQPJ4xf03g==
X-Google-Smtp-Source: AGHT+IEaA3Yk5H5sm7OqlYuWJldrbQt1FyGNtf9CVSLw7qF8ebCkHsyFpFiViHyqoeQ9pbU7fRjgjg==
X-Received: by 2002:a05:6a20:c887:b0:1a0:f713:8317 with SMTP id hb7-20020a056a20c88700b001a0f7138317mr1259104pzb.61.1709175496202;
        Wed, 28 Feb 2024 18:58:16 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:f51:e79e:9056:77ea])
        by smtp.gmail.com with UTF8SMTPSA id a1-20020a17090aa50100b002997f192d4esm2055537pjq.1.2024.02.28.18.58.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 18:58:15 -0800 (PST)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	David Stevens <stevensd@chromium.org>
Subject: [PATCH v11 2/8] KVM: Relax BUG_ON argument validation
Date: Thu, 29 Feb 2024 11:57:53 +0900
Message-ID: <20240229025759.1187910-3-stevensd@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
In-Reply-To: <20240229025759.1187910-1-stevensd@google.com>
References: <20240229025759.1187910-1-stevensd@google.com>
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
2.44.0.rc1.240.g4c46232300-goog


