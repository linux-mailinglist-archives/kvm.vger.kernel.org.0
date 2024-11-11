Return-Path: <kvm+bounces-31513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A6DA39C4548
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 19:51:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 75532B28310
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 18:40:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 532171AAE3B;
	Mon, 11 Nov 2024 18:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QTvSjVLN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8AB450EE;
	Mon, 11 Nov 2024 18:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731350398; cv=none; b=FKJXqhBIytOrbxQ1QrjbgVgsfFiQ23SgI/yZWuxZ9khWU/qQybiJDHE4MgzJVJ/EkZBQHkY3ZWmsIBbTcLt83tuHaOwMDr2NpNYd84L45rD5iflcQ4PRt0iGcvwO5ZUoVuOgiwAb91EKrYYtFmYhDQH5saLcvRkGpvy7nHIBcyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731350398; c=relaxed/simple;
	bh=Mkf8d4ycutLC3OawYLhiBBp12Y3I2OyMomLoWhibygY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MXJ0sb46uOM7B8/BYfUUsSYRiQB9k981ou8PkEJu9BS3NbNGJCt85DjqVLYxF/+/wDZ6aIRb9yfKthhUWBLTOSHxgfGnsRl3jVWqLwOLVBVtdvVZMc3Yc27QeammzsW93qk3878t1cNLDNsQHZJE27uTtSh6LIcnt+NBS7MdFnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QTvSjVLN; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-20c805a0753so45913895ad.0;
        Mon, 11 Nov 2024 10:39:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731350397; x=1731955197; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=is2dX1BvkV4gQvPfSQkwfTIdaReamJ5nfgtDMnPyLNk=;
        b=QTvSjVLNIng+EH4zzlJGK59jrzQh/qfU4qn4tMlOjZ5K/1ZFem+RNbI6IjBbLqrbcT
         s2BSVNqEcKaUrk1mpMCTjW4fawbyCWs1ghhL9EW1LcgnQyl+l/KbOQ0YVDyLA35S/Gnu
         s2UGJEx/2I/mc78hJzY7tKfgTr51Jxv/P7eiujn7rB66sCtY/r7oAi+pO4ij4KWu+wqL
         DQbULRvi/cGx/7xsKAj5WpIWgFm31oC7dCUR9C6PxyURw/kPVC1yBt1MCravv1z7k9np
         gE7HUMw8lmNjGTh6POl8dX3yJofKMly/qO8bE00tyhIMQEWVDDmhg6upYm9XPkW41IsR
         +UGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731350397; x=1731955197;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=is2dX1BvkV4gQvPfSQkwfTIdaReamJ5nfgtDMnPyLNk=;
        b=FtFjjG8zQonpsZiNYq8/LI6gGeTDh6jlQYCIlqeQQQdIgMdVco/E6tm04R2xKs8iak
         Pfvgzh76iZquVvdMFvvaj0e3sNDiqlqbWPhxM1+REG8Smsxg70Ms1bNy8gytTVDwu98u
         bAhVmNKqWHKdlKY3BNfkucPqT/mQFMU0UWv5YNs1a0GHJNgFDzlSAVkQqGcxJ1bgqsbU
         7h7eG00XsDZA0U5WNzDr+iV2ME/9+mvYhGJldNQS8GgwjtRqlcnuXgO88xMC4wrUi/K1
         k7gTd0nRGuLBm58qtKSW9xP/NMygg+60/Qackf7y5X+negIRg1kt8g9sr/Qgd8lTh26N
         uKDA==
X-Forwarded-Encrypted: i=1; AJvYcCVnM+1T7TNINWPVCDYP4Ca0Q0y/hDOJu3EBUpiq0D/KpZIMOo4UaKZoHdBY/TyRxZLZdrL27yFGtRgt7wI=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywl+5apeKteFduWeXjzG0j/PXvyq8/11IxU1KJqMhIPIDYQW+An
	Cg1zMao5RfIEAsuCHBA8y6bxcBuR2z9NMpoiLKJUaGq8bsWNWoAnC/t0lwys
X-Google-Smtp-Source: AGHT+IGEYA+Tlv87Xjls4JLjmwWZezIuJutVxmFPz43mU/MFltEMX24LiSAfLkHDhngqoU4rDwvLtw==
X-Received: by 2002:a17:902:f541:b0:20d:1866:ed6f with SMTP id d9443c01a7336-21183ccf11bmr185647305ad.4.1731350396455;
        Mon, 11 Nov 2024 10:39:56 -0800 (PST)
Received: from advait-kdeneon.lan ([2409:40d0:1170:6e90:2801:34a4:f903:135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21177e4278dsm78621345ad.159.2024.11.11.10.39.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2024 10:39:55 -0800 (PST)
From: Advait Dhamorikar <advaitdhamorikar@gmail.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	hpa@zytor.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	anupnewsmail@gmail.com,
	Advait Dhamorikar <advaitdhamorikar@gmail.com>
Subject: [PATCH-next] KVM: x86/tdp_mmu: Fix redundant u16 compared to 0
Date: Tue, 12 Nov 2024 00:09:35 +0530
Message-Id: <20241111183935.8550-1-advaitdhamorikar@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An unsigned value can never be negative,
so this test will always evaluate the same way.
`_as_id` a u16 is compared to 0.

Signed-off-by: Advait Dhamorikar <advaitdhamorikar@gmail.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 4508d868f1cd..b4e7b6a264d6 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -153,7 +153,7 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 	for (_root = tdp_mmu_next_root(_kvm, NULL, _only_valid);		\
 	     ({ lockdep_assert_held(&(_kvm)->mmu_lock); }), _root;		\
 	     _root = tdp_mmu_next_root(_kvm, _root, _only_valid))		\
-		if (_as_id >= 0 && kvm_mmu_page_as_id(_root) != _as_id) {	\
+		if (kvm_mmu_page_as_id(_root) != _as_id) {	\
 		} else
 
 #define for_each_valid_tdp_mmu_root_yield_safe(_kvm, _root, _as_id)	\
-- 
2.34.1


