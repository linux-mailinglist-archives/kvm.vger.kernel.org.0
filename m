Return-Path: <kvm+bounces-26400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C68A597469F
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 01:48:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA69C1C24CA3
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 23:48:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86E871ACDF9;
	Tue, 10 Sep 2024 23:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vHt0X+YR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2658D1B3F2F
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 23:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726011888; cv=none; b=rtZ4roMlwT1FdHqD9uWdUIzNsu5PjjDIhda1vKglvz8JyvvNjsFze7ekSF/UbsL+s8yIbedAu+cRhl+Cgtf0E2nCDwIuWqJDGpBHyqAWIL9iFAHAqI5NkQCuD8Sk55E7uzxi3DH4S+q6MLtwd8c6Zr0CqAR/WzgSGKZB9ocw71g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726011888; c=relaxed/simple;
	bh=P/1nrx2IuQ6u/tRlLat3CEqnsSzaylehYsr5F1KL3bU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Kqyp+djC9v1CbuJRwZcfrRoqw6ZLNCRRapRgAPtQNGVwIp0yNK5gZd0OxM0dhtaOeVZ1Bbnq4FgT9MgHS8rfKp/SR34ncLJEz/dKGNIgP74p9xYVnl3bHIPjbD8ksxK3/CuxzYGSKWY62DzUHnRuLqchu1C6gfCa0A8Pz8f4nw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vHt0X+YR; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7d50777abf1so3526089a12.3
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 16:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726011886; x=1726616686; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wCQtr3LYUTrh92YO/TM3BLSTa63Bn54Ak3CYVuDQSOE=;
        b=vHt0X+YRa0IQq9jff12LFWszMiRmTu81WRf95qZCHH2FBFUHpH3OwFaOVCXEKoGMwP
         eMxv1VWr2rKqOz+YKdr4jqT0avOy9isYIwsd2fbrWA3CzjCYYV+lmtLuk0PzgdP7akFX
         Ek4uF0STXC/7BaEF3Eq4GGTc26AZMh/U4GRo1UstG0GfjVCfU4CPCBHc7YZe36soVp+b
         oz2MIUONVw3/0DRYNAnue1KkJbWu5PDcD/nS/fZrudA3tdV16DX6TZTd6H0PB8L4VTSU
         RILZ1f89ZweoYEzrmeymJzi9RL07tHEb34uBq5ta9ImJNjo4vul0b2DgzCZ8hXogLLk+
         I+1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726011886; x=1726616686;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wCQtr3LYUTrh92YO/TM3BLSTa63Bn54Ak3CYVuDQSOE=;
        b=qiIzNyW4W3hmp73sDx549itFzrd0Q48AT17P4o1FPXuaOWQzsgD+TFC8DlWrjstqnc
         vfNkFQLXMwOQJaNi3/dxVNuC1JJF0VPWtV4inC7DsXuyeef9z1sJrg1sJg+IPVTYyhOU
         yZVmgPyH6/xQrAi+f9W9rBUrpB6ZX078Qk3ORj/09XiaLyAB3x1RDfnxWtJlXzN1u2qJ
         YbkxACjILG15uPey0nKrKk79MQrKOL0B7umaR+RRj5NRTiDutm0MdMJOrjBu8Uhip1aB
         eADaI+TIFPAk51KGm5qv9g33icJSfqHWg2/tvHD1wi+ZyI26lsj3aKR4XxGycHd4FsM4
         Mk+g==
X-Forwarded-Encrypted: i=1; AJvYcCWyz4f/H9sQ5ZunJwa93X/E98tOxAjOx52dr+ekt5eaAdv7e4V/M/A3XjgRLcnS2qhg3og=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYKuvtZfL9L/AD/0WAHQQY72yHNGupSsWK+FghncYdxNqc/f+a
	wQuoTjGwUSS2Ig2x1uwdraVTq+AJMvw23JzWHbLxg8B2Hy5H+TUOOuD17sbOvVdrI1Svt4dJo5E
	OsVxDXckDMVwB+JflpiFjeA==
X-Google-Smtp-Source: AGHT+IH5Nj5kPHNo6rBfhQxFH2WNjr8MfjXL+h+toY4sJe8PVOOMsYFK1lr+WyYqGBk0WvcoCe7tmQGhI2Eo6rySgw==
X-Received: from ackerleytng-ctop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:13f8])
 (user=ackerleytng job=sendgmr) by 2002:a17:902:b686:b0:205:5db4:44b8 with
 SMTP id d9443c01a7336-2074c63a9cemr948735ad.5.1726011886284; Tue, 10 Sep 2024
 16:44:46 -0700 (PDT)
Date: Tue, 10 Sep 2024 23:43:39 +0000
In-Reply-To: <cover.1726009989.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1726009989.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <9f287e19cb80258b406800c8758fc58eff449d56.1726009989.git.ackerleytng@google.com>
Subject: [RFC PATCH 08/39] mm: truncate: Expose preparation steps for truncate_inode_pages_final
From: Ackerley Tng <ackerleytng@google.com>
To: tabba@google.com, quic_eberman@quicinc.com, roypat@amazon.co.uk, 
	jgg@nvidia.com, peterx@redhat.com, david@redhat.com, rientjes@google.com, 
	fvdl@google.com, jthoughton@google.com, seanjc@google.com, 
	pbonzini@redhat.com, zhiquan1.li@intel.com, fan.du@intel.com, 
	jun.miao@intel.com, isaku.yamahata@intel.com, muchun.song@linux.dev, 
	mike.kravetz@oracle.com
Cc: erdemaktas@google.com, vannapurve@google.com, ackerleytng@google.com, 
	qperret@google.com, jhubbard@nvidia.com, willy@infradead.org, 
	shuah@kernel.org, brauner@kernel.org, bfoster@redhat.com, 
	kent.overstreet@linux.dev, pvorel@suse.cz, rppt@kernel.org, 
	richard.weiyang@gmail.com, anup@brainfault.org, haibo1.xu@intel.com, 
	ajones@ventanamicro.com, vkuznets@redhat.com, maciej.wieczor-retman@intel.com, 
	pgonda@google.com, oliver.upton@linux.dev, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-fsdevel@kvack.org
Content-Type: text/plain; charset="UTF-8"

This will allow preparation steps to be shared

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/mm.h |  1 +
 mm/truncate.c      | 26 ++++++++++++++++----------
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index c4b238a20b76..ffb4788295b4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3442,6 +3442,7 @@ extern unsigned long vm_unmapped_area(struct vm_unmapped_area_info *info);
 extern void truncate_inode_pages(struct address_space *, loff_t);
 extern void truncate_inode_pages_range(struct address_space *,
 				       loff_t lstart, loff_t lend);
+extern void truncate_inode_pages_final_prepare(struct address_space *);
 extern void truncate_inode_pages_final(struct address_space *);
 
 /* generic vm_area_ops exported for stackable file systems */
diff --git a/mm/truncate.c b/mm/truncate.c
index 4d61fbdd4b2f..28cca86424f8 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -424,16 +424,7 @@ void truncate_inode_pages(struct address_space *mapping, loff_t lstart)
 }
 EXPORT_SYMBOL(truncate_inode_pages);
 
-/**
- * truncate_inode_pages_final - truncate *all* pages before inode dies
- * @mapping: mapping to truncate
- *
- * Called under (and serialized by) inode->i_rwsem.
- *
- * Filesystems have to use this in the .evict_inode path to inform the
- * VM that this is the final truncate and the inode is going away.
- */
-void truncate_inode_pages_final(struct address_space *mapping)
+void truncate_inode_pages_final_prepare(struct address_space *mapping)
 {
 	/*
 	 * Page reclaim can not participate in regular inode lifetime
@@ -454,6 +445,21 @@ void truncate_inode_pages_final(struct address_space *mapping)
 		xa_lock_irq(&mapping->i_pages);
 		xa_unlock_irq(&mapping->i_pages);
 	}
+}
+EXPORT_SYMBOL(truncate_inode_pages_final_prepare);
+
+/**
+ * truncate_inode_pages_final - truncate *all* pages before inode dies
+ * @mapping: mapping to truncate
+ *
+ * Called under (and serialized by) inode->i_rwsem.
+ *
+ * Filesystems have to use this in the .evict_inode path to inform the
+ * VM that this is the final truncate and the inode is going away.
+ */
+void truncate_inode_pages_final(struct address_space *mapping)
+{
+	truncate_inode_pages_final_prepare(mapping);
 
 	truncate_inode_pages(mapping, 0);
 }
-- 
2.46.0.598.g6f2099f65c-goog


