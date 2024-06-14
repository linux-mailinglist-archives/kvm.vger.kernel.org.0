Return-Path: <kvm+bounces-19717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 79071909360
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 22:29:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2BAF41F22FA6
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 20:29:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 390BB1AB51B;
	Fri, 14 Jun 2024 20:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="TzcGQvEH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49FA1836F9
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 20:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718396948; cv=none; b=o6saXUtdp9Ka6zlHUHlh0j1iSc76+GW0tgZX1CdRqlnDmNXJvXdQ2UVGQs8MV2wc4Bk6w/BI6ccbEGlW+VBu3j99Kx5EmBOA6PubrkyKMlJPjBkZ2DjQymLluYealyhKzb03F03VPwSPg8T2h3W13i8FUzAc7Fe5yBPc+mPbed0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718396948; c=relaxed/simple;
	bh=1waVZBSBgmkVTRzD47YLiwSpWUY2zTLGJrDORugnwOA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=M/Enctvev4+B/Rv1kXlHiISFsIo22XDfFnGGXNHm1aGkQZxLPY8W0isoWHlG8/VeAGXgbMkrAaaDUpAPeDIaTeOhCsNE59n6uYWHcKiLQ8zb42R26eJgKpczVOyrz0UhvkbDa7rE3BCBMsBU/RXazqsjEH+agdNlvvS4pTZ4hhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=TzcGQvEH; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-52bbf73f334so2811981e87.2
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 13:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1718396945; x=1719001745; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TM0RpYUvwtwCNY9Q6H4dViSdw/nY+sKwQUbKlWbVJNw=;
        b=TzcGQvEHwh5tOM+Mg3zJe8JOtluHWkK4v7xS3Hu6gqnCTS3SAxsy1vyzhj9hrKrgP5
         /kDLvQa3pna10rsVw2lY+k6ZY8qf6eeNy4rn+wDfnO1JSLCfFkr4bjbH/rwd57iz12xW
         YkredxNO7Uhxqej1ZMb6SUSaCfaeytMVo/VJTn0cXH+R/XC075D4sB82KT0AjV5U/mqz
         iMDXjyY5r4+aNbvwuDMrS06R/aGMLXErXD+EZrum8yRQC5mFtgXDQE+nNWBdc6C6am8+
         p7HWulf2GMhLQd5LCRTfelhf/PaGkZ0DevpZQzd9Y246vRVkaprS34R3EEACbSCcgbWm
         xk3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718396945; x=1719001745;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TM0RpYUvwtwCNY9Q6H4dViSdw/nY+sKwQUbKlWbVJNw=;
        b=EdamRTuR1YtKIMpUoh7Cnt0/C3Kp2eL7tv6U6I+EMF1eG5dpn8PlfIhv2RimBHRMqa
         pQKjC+ZkcqsFSInzd1555ZqZRES8veORIHgBrGRW3w9LCDF6X1EIgKUyBR5bC8+rV++g
         Guqv0IrfwbZFKyw2SgJTc9H/QFV4Nqeo6b5qAMdJANl/P6o9yWhfIFbd/M3Z+ysVONpi
         irhooDf8Qvi2DST+MwGh+XuCW7Kww5ehvTeGWmBsnWHPvdelS8nAbk45iCK3fA8by+yd
         TB5vnVGiAPQragEX6Hfe9VDpITtDSfa5ounWB/pNtbsYscCUsf3LJhdrG40DWFjG8mfa
         fiMA==
X-Gm-Message-State: AOJu0YxnofnTyHrPO1faP47i3gPQZ7y1SKZTi7OTQHCgQmgpHgvOfG/0
	xwABQsphveJfUoTBOdvcMgvWO6VCecetM3icvvvhqIhYVS5n/Gsa6+k/iGSV3FA=
X-Google-Smtp-Source: AGHT+IH0pnDNNADT+RIDBfDocnjEDQBm9SFNoNatGvNoCsRLbL/2wERti+n4EFLVtNtRtVTXr4XMrw==
X-Received: by 2002:a05:6512:41a:b0:52c:8933:d743 with SMTP id 2adb3069b0e04-52ca6e91534mr2399101e87.47.1718396944893;
        Fri, 14 Jun 2024 13:29:04 -0700 (PDT)
Received: from bell.fritz.box (p200300f6af332a00214df27025e50a49.dip0.t-ipconnect.de. [2003:f6:af33:2a00:214d:f270:25e5:a49])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f56ed3685sm217474166b.126.2024.06.14.13.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jun 2024 13:29:04 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH v3 2/5] KVM: x86: Limit check IDs for KVM_SET_BOOT_CPU_ID
Date: Fri, 14 Jun 2024 22:28:56 +0200
Message-Id: <20240614202859.3597745-3-minipli@grsecurity.net>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240614202859.3597745-1-minipli@grsecurity.net>
References: <20240614202859.3597745-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Do not accept IDs which are definitely invalid by limit checking the
passed value against KVM_MAX_VCPU_IDS and 'max_vcpu_ids' if it was
already set.

This ensures invalid values, especially on 64-bit systems, don't go
unnoticed and lead to a valid id by chance when truncated by the final
assignment.

Fixes: 73880c80aa9c ("KVM: Break dependency between vcpu index in vcpus array and vcpu_id.")
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
v3:
- check against arch.max_vcpu_ids too, if already set (Sean)
- switch to else-if instead of goto (Sean)

 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 082ac6d95a3a..686606f61dee 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7222,6 +7222,9 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 		mutex_lock(&kvm->lock);
 		if (kvm->created_vcpus)
 			r = -EBUSY;
+		else if (arg > KVM_MAX_VCPU_IDS ||
+			 (kvm->arch.max_vcpu_ids && arg > kvm->arch.max_vcpu_ids))
+			r = -EINVAL;
 		else
 			kvm->arch.bsp_vcpu_id = arg;
 		mutex_unlock(&kvm->lock);
-- 
2.30.2


