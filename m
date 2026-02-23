Return-Path: <kvm+bounces-71452-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wHkqFOH8m2kC+wMAu9opvQ
	(envelope-from <kvm+bounces-71452-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 08:08:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E33FA1728C9
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 08:08:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 42B7D306146D
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 07:05:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42FF434C808;
	Mon, 23 Feb 2026 07:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ez/3KcGf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3292034AB1F
	for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 07:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771830298; cv=none; b=ZarEvpfAU9saPnNauRTDXeOApsy9ci4L2dldCoHvO/NNqiMMTr8OvxSX5HjM6b9ldqBQ2CJaC5mL6rRSBKZFf6lBrSUoWBJaqEmXj3XXcRLMOvfepGxwDxw9/idw3PwZhYGB0XAha2e/9HTe5szCCioHCvAYWlZGJIz1FaB6SWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771830298; c=relaxed/simple;
	bh=5o3tmYQd6rVeF2e0eOelASFd7dC8E+r7apcrcv6Ycco=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o72tcTA4KDtnRp2eNzjYZnw17dVaTdIgE8ppgJ/oGt7d3kyvwJitgO8d3FWe8W5gJH2bdrY73cGc0uS0DvU7VVZv622jy1CILxocJhGbNqfFZy8w/VNF3oKABv2rdv93DRhqdElcSrwTeSxdMtsfMbZ0BlPl+qYoB3QL9xAZPzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ez/3KcGf; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3545dbb7f14so3711583a91.0
        for <kvm@vger.kernel.org>; Sun, 22 Feb 2026 23:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771830297; x=1772435097; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9REamna2TtkXRPR+lDCH1E9Zwr056ciH8ECe5GsnKJE=;
        b=ez/3KcGfOGok7/1uy/hqoY/izmes1tk3WFr/masXPa79JGodDOboLXk4nYMYeEhsYm
         TA+MMaXTiQTdr1TE3cVxKWauEMS2bCizZB3/n1JpaLi0B5qtIX98a8lY4Lsr/YnEd96C
         fOLluIAcdk5zFutXxO5GjEC/dXqC6tvfC75Tti+2hhjK50jVBaFXw/BC3znrlq+ARK7G
         8gWLWAkvFckMHnZnCMnBdc8NFEDx9ezbHHSit95aEQq87uSr8HB8nmgeUg1pnr/i6aDV
         ujGE21U3iLfhFuZ8hygg+nB3kHCd1thFWkH2+bOtxCkMqLTzkLBtccmuRLiaXoYDSJbs
         ZBqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771830297; x=1772435097;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9REamna2TtkXRPR+lDCH1E9Zwr056ciH8ECe5GsnKJE=;
        b=KxEHZ8K3uBLT+BV0M2rmMD24nDq+UtHYtU5bqRF7dGkMy4d9UjJRHhPZvfXw69O1KL
         ZRn0WIznzJ0CKzA902a52872jrMmDXOU3xusuWE+83N/J03Dcsx8Ru8EYIAZz3nJuMto
         oxu84NMPZTZqskOUZBTpnC+NIQ5cn4IUALjKFQMHFTcQlS2ufvdjhrHSYAriCrjsEbU0
         fBIn5CaIcdzhPGXfHiknkX+fByYsPEmKglf9qyM9K4Hm3GdmPFTPXstpd/dk5zz5NTmX
         fxboy4VPYtTy9yxS5ZFVB+AULEc+WpbC8RRsDRMV2BB6rVZcibA/GqxcqRu3FDBePTaJ
         qTqw==
X-Forwarded-Encrypted: i=1; AJvYcCUvtWnBO7MUD73WTcL8ukITPWWWorPkX8et42v2mUa1Jd7bvTOXE2r1QufACNNCpfvNNzA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZocmz7p635JtqFacBLClOvrvEm0H0I+dFpuqKH1AdhowGx7qE
	FH7e/LBZtQamGsRItC9QKB9HQoChisWA5tGtG1nfJoUAackh69FXGCcLrSszcodAgkKF84zSDgM
	aJQqq3x+8vcDBIZV1zRecAPPTHg==
X-Received: from pjst15.prod.google.com ([2002:a17:90b:18f:b0:34c:ab9b:76d2])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:56cb:b0:353:4f7:cc3a with SMTP id 98e67ed59e1d1-358ae6a20c3mr5721991a91.0.1771830296257;
 Sun, 22 Feb 2026 23:04:56 -0800 (PST)
Date: Mon, 23 Feb 2026 07:04:37 +0000
In-Reply-To: <cover.1771826352.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1771826352.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <85a7e5a06f0fff049e5440daea079f0be4c47ff5.1771826352.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 04/10] KVM: guest_memfd: Implement evict_inode for guest_memfd
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-71452-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[30];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E33FA1728C9
X-Rspamd-Action: no action

In a later patch, guest_memfd will be using a custom truncation
routine. This is a preparatory patch, which implements .evict_inode for
guest_memfd, but just performs exactly what would have been done if
.evict_inode were not implemented.

No functional change intended.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 2488d7b8f2b0d..57dec458bfa77 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -978,11 +978,23 @@ static void kvm_gmem_free_inode(struct inode *inode)
 	kmem_cache_free(kvm_gmem_inode_cachep, GMEM_I(inode));
 }
 
+static void kvm_gmem_evict_inode(struct inode *inode)
+{
+	struct address_space *mapping = inode->i_mapping;
+
+	truncate_inode_pages_final_prepare(mapping);
+
+	truncate_inode_pages_range(mapping, 0, inode->i_size);
+
+	clear_inode(inode);
+}
+
 static const struct super_operations kvm_gmem_super_operations = {
 	.statfs		= simple_statfs,
 	.alloc_inode	= kvm_gmem_alloc_inode,
 	.destroy_inode	= kvm_gmem_destroy_inode,
 	.free_inode	= kvm_gmem_free_inode,
+	.evict_inode	= kvm_gmem_evict_inode,
 };
 
 static int kvm_gmem_init_fs_context(struct fs_context *fc)
-- 
2.53.0.345.g96ddfc5eaa-goog


