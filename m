Return-Path: <kvm+bounces-71451-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iKU5KrX8m2kC+wMAu9opvQ
	(envelope-from <kvm+bounces-71451-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 08:07:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D8AF1728AC
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 08:07:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 223C43053E38
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 07:05:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AD3934CFAE;
	Mon, 23 Feb 2026 07:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="os+Qowy6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863C734B682
	for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 07:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771830297; cv=none; b=ARt1oJwDQSqVbUg+2iCbmow5ZOolp2PRKK8Jayw21iaFfGWHcqMfqTYJvvRdkEFPFUJ/fQeAivyNVHzv1lLlwdDRovYyunKjyHDuPAPYpc4LOvF+2mGUbhDE8wwF7rZziRNXQQqPQK55mMdrCnAcIjMfF+Nt/86J+1t9SS9pdOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771830297; c=relaxed/simple;
	bh=A7tFVwaDg2WHLYtVEoEto9tIear/R+w5LOCLvvXMBnQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oi8SbjZ+udULDIITSsJhNumJWY22I8d9YaTbXHjCYGxG+PvRjJcC8dBpQY0EbyMSYJG7/vXfl627fjbYMmzSrrjBHOBGlj3LLGXNTuCkxt9SUyEX398UD5WoNOXK0a3g/LbeyfwRhqqa7nTGIrx6G3TnYTsJL5b+36pFTeoI8rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=os+Qowy6; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-354490889b6so20787777a91.3
        for <kvm@vger.kernel.org>; Sun, 22 Feb 2026 23:04:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771830295; x=1772435095; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pw3wTOQIfqz4K2I03v4IFEHinUKdB/xRwD0FbZ6/43I=;
        b=os+Qowy6NbZZucya5MsR5k364hse9R1HS6gyBMgK466FMpru5jbmPhlbuLxTHAju5F
         D5v1vWrh86guromec4WsEvL0rHBNLiYWzvwixAUAZsDnfiaQYN/c6Zuwyu671j/G8tTu
         MonJlhWac3Y3RElDpOvCL6mM+Z9zDA4FsH1axKVULMqtbpEidyrcdb5kVYLjXJ/Um4nj
         b5uyygwzZvpCDFgj3cuZnq7bUnEy+7OgNMKPtVb9ecNVi5kMUEBmvj6ws11q9RfSMpgT
         aLUxHrkbhZ3M4mpfba8cL80sZF3A6b7g7byUt8uNSk8uvai0sK6nJDqAtahItgfdDbha
         87+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771830295; x=1772435095;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pw3wTOQIfqz4K2I03v4IFEHinUKdB/xRwD0FbZ6/43I=;
        b=mybDx4ImjhxqC/f+n6JtdXMk7YYdYAprBrDeAl5A1C0VJb9PcTL6nVWwFPjzFxxMdp
         uapJ0QLo/GZCxPillODwahCnDcqiKcsFdZG/44BORq2G4OHfm83nsjP5hnhFSB6V7mMe
         iGPHi11xekbqxx5fVVEUSrM8+ZADw9rXSTL/gwenZfuKEqHW0/bmblKGijXQHOXrwa4E
         fZoHc84Yx3OhBFNdlePLiRkIONTN2RZoBqFjKuGr9MUxVoWm3qB+28cvVPbDZhWGS5o8
         OgCgc0/o+s0PM143UmcnTX8UmEAzloZ75lekmMB5uFOlkt8e/CXjKKAzVG4uGY161AxU
         y7CA==
X-Forwarded-Encrypted: i=1; AJvYcCVPQpk0gwlVAmehum05tsN85pDEsK7lotwt46YEOmBW/Ymyvx4zTAiEhzeQFFV9YqUA5Fk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHBp/BmTBqL3Khr66fbxrwVb4hz0cpZtsMHQLT99ZCw9vsHcvI
	lQM9Qc8zTmq17MAl8GiBY9lIcLpM6ZW/ck9UB+3fwqPXFuvtB2E1rWujdRog7j8Tj3kaJZ6LAC0
	B8ZT8JyJL26LlUR4lpEdxvuOubg==
X-Received: from pjbjs23.prod.google.com ([2002:a17:90b:1497:b0:34a:c430:bd91])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2550:b0:340:776d:f4ca with SMTP id 98e67ed59e1d1-358ae8d5d3amr5969350a91.26.1771830294754;
 Sun, 22 Feb 2026 23:04:54 -0800 (PST)
Date: Mon, 23 Feb 2026 07:04:36 +0000
In-Reply-To: <cover.1771826352.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1771826352.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <14fcfc2a032b85c7de09e9dd39668c8061742661.1771826352.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 03/10] mm: truncate: Expose preparation steps for truncate_inode_pages_final()
From: Ackerley Tng <ackerleytng@google.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, willy@infradead.org, pbonzini@redhat.com, shuah@kernel.org, 
	ackerleytng@google.com, seanjc@google.com, shivankg@amd.com, 
	rick.p.edgecombe@intel.com, yan.y.zhao@intel.com, rientjes@google.com, 
	fvdl@google.com, jthoughton@google.com, vannapurve@google.com, 
	pratyush@kernel.org, pasha.tatashin@soleen.com, kalyazin@amazon.com, 
	tabba@google.com, michael.roth@amd.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-71451-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[30];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2D8AF1728AC
X-Rspamd-Action: no action

Expose preparation steps for truncate_inode_pages_final() to allow
preparation steps to be shared by filesystems that want to implement
truncation differently.

This preparation function will be used by guest_memfd in a later patch.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/mm.h |  1 +
 mm/truncate.c      | 21 +++++++++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f0d5be9dc7368..7f04f1eaab15a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3732,6 +3732,7 @@ extern unsigned long vm_unmapped_area(struct vm_unmapped_area_info *info);
 void truncate_inode_pages(struct address_space *mapping, loff_t lstart);
 void truncate_inode_pages_range(struct address_space *mapping, loff_t lstart,
 		uoff_t lend);
+void truncate_inode_pages_final_prepare(struct address_space *mapping);
 void truncate_inode_pages_final(struct address_space *mapping);
 
 /* generic vm_area_ops exported for stackable file systems */
diff --git a/mm/truncate.c b/mm/truncate.c
index 12467c1bd711e..0e85d5451adbe 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -487,7 +487,9 @@ void truncate_inode_pages(struct address_space *mapping, loff_t lstart)
 EXPORT_SYMBOL(truncate_inode_pages);
 
 /**
- * truncate_inode_pages_final - truncate *all* pages before inode dies
+ * truncate_inode_pages_final_prepare - Prepare the mapping for final
+ * truncation but not actually truncate the inode pages. This could be
+ * used by filesystems which want to add custom truncation of folios.
  * @mapping: mapping to truncate
  *
  * Called under (and serialized by) inode->i_rwsem.
@@ -495,7 +497,7 @@ EXPORT_SYMBOL(truncate_inode_pages);
  * Filesystems have to use this in the .evict_inode path to inform the
  * VM that this is the final truncate and the inode is going away.
  */
-void truncate_inode_pages_final(struct address_space *mapping)
+void truncate_inode_pages_final_prepare(struct address_space *mapping)
 {
 	/*
 	 * Page reclaim can not participate in regular inode lifetime
@@ -516,6 +518,21 @@ void truncate_inode_pages_final(struct address_space *mapping)
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
2.53.0.345.g96ddfc5eaa-goog


