Return-Path: <kvm+bounces-71164-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6A0aLGCYlGlAFwIAu9opvQ
	(envelope-from <kvm+bounces-71164-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 17:33:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A1C414E3BC
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 17:33:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6680D3012E6C
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 16:33:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD31C37105C;
	Tue, 17 Feb 2026 16:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bOWYw/xS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1C436F42D
	for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 16:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771345978; cv=none; b=A4loxCpynF7FEcnZN0tauFn32cT4CuvsKP4qdM9FPASmrybfTSl3YpTAE0jQinJIJjcjKgoR8sLgzInLCQvAHqAShq4RPN27w15q8OGTowTvIu4IM7KEEA0JwehZlyMqpdvHi1lfVjSSFqGx/a+MHAP1aN7MBjbNILAjaShDnXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771345978; c=relaxed/simple;
	bh=5ko5sZevaLLikb5YibeDPV/ZAP+l239Wav0R9HXJvE0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ufaTDMiwi6y3B2tc8hN/IAP5e2ewsP+FnozJsVR1XiC9FZCZgMPblX9OvflAG5gBXSpc0H6bW/Shx3ZGpXXLC2bU/K7Bvs1n7Oz6gozPQvfpzwYlaq3tbictFrsftyAemqauyLIvp6iQNGvLwakYzXjQEVFLcvsWS90g7lH6Sbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--surenb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bOWYw/xS; arc=none smtp.client-ip=74.125.82.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--surenb.bounces.google.com
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2ba66faa692so5801024eec.1
        for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 08:32:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771345976; x=1771950776; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=20E8AsSTFCwzOiRhIxVDRmNYTsZqkvgm04spnyQD6co=;
        b=bOWYw/xStgqGO07nAt1N/mPv4mjbNFx5rwkOmNskCAIDmK/psW1QNnwiPfynqy3NYM
         VS7bhu9aGntGS3x9AchPlDChjJrf3hw+7z3iV6GXjRP99vVF6ZnoeT2evUXIUp9vNVFd
         vXSuHVGgDfmvVdc2ZZlNHRGbj/pCxMyJ42eoH+H/6ZvRs3MvB1VjW/ni2ApGYKfzL6F/
         8X59PEHnwE9DDzMMElmWPljhM4XR/91T13MD1n5GfZZd3K5j2db5J0Grg7kI+wGmgc01
         njnuORIIdlmXV5hzy0V4XWcpoBUbmBM/q92sTBf6U6MYg2yf2VyFpOr32Cs4A5g8UhTb
         a2MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771345976; x=1771950776;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=20E8AsSTFCwzOiRhIxVDRmNYTsZqkvgm04spnyQD6co=;
        b=w03g3Rk0psfdeNqBqihYE5hfEcxUyXgWVENfIl1gcLVMr4VOHC5QB8q4frkb0wgpPz
         ulmtEvD03zSaClpCxHQjusbjCFCsZ2PLnnrhk5I9SzWuBiaGhhC6XpnGLx+g10ywlGE5
         VHWTQ5FF62IIAUeL9YrSbubBtgYCa0rb0qOEnvjFuEZAiR3QwddXsNIDXSkZh/xLNeOF
         BUfZ39yYuvVhUtl9BEFgXvpNFwxJNiBZ7Il3R5hyRZSxjA4N2pcNohEbJX+4Y4p4Effs
         7VQXXjMEfUAnKgYqF2nyrou8cCNi8lDbSaYguAhVVElm4ov7Fb+Msj8q+kCOObxrq6EI
         dmUw==
X-Forwarded-Encrypted: i=1; AJvYcCW15T8/jAvhlmLx/tRLo8VJSS4kceZbkU5cau66ZfZ+emrsBqFa5Vsr5vQLR1AH+oK5fPI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiWGfOZKiKyZ7nFzy2wA+Ryu6/XcN+WdZU5hIMr6fNAZXqnZsP
	a5STcUMJwEnKVXsowCR2AwWry6/X8Q8Am4oIyptSlIzY1YW77YlB3XPu5rK2YKNNV7VaHE0Vx6R
	fP9xz0w==
X-Received: from dybmv5.prod.google.com ([2002:a05:7300:cd45:b0:2ba:9f53:8c70])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:693c:2c8b:b0:2ba:7f8c:6754
 with SMTP id 5a478bee46e88-2bac97ceddbmr4300008eec.37.1771345975648; Tue, 17
 Feb 2026 08:32:55 -0800 (PST)
Date: Tue, 17 Feb 2026 08:32:48 -0800
In-Reply-To: <20260217163250.2326001-1-surenb@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260217163250.2326001-1-surenb@google.com>
X-Mailer: git-send-email 2.53.0.273.g2a3d683680-goog
Message-ID: <20260217163250.2326001-2-surenb@google.com>
Subject: [PATCH v2 1/3] mm/vma: cleanup error handling path in vma_expand()
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: willy@infradead.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	agordeev@linux.ibm.com, svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71164-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[infradead.org,kernel.org,nvidia.com,intel.com,gmail.com,sk.com,gourry.net,linux.alibaba.com,oracle.com,redhat.com,arm.com,linux.dev,suse.cz,google.com,suse.com,suse.de,linux.ibm.com,ellerman.id.au,kvack.org,lists.ozlabs.org,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[43];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[surenb@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_NONE(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5A1C414E3BC
X-Rspamd-Action: no action

vma_expand() error handling is a bit confusing with "if (ret) return ret;"
mixed with "if (!ret && ...) ret = ...;". Simplify the code to check
for errors and return immediately after an operation that might fail.
This also makes later changes to this function more readable.

No functional change intended.

Suggested-by: Jann Horn <jannh@google.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 mm/vma.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index be64f781a3aa..bb4d0326fecb 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -1186,12 +1186,16 @@ int vma_expand(struct vma_merge_struct *vmg)
 	 * Note that, by convention, callers ignore OOM for this case, so
 	 * we don't need to account for vmg->give_up_on_mm here.
 	 */
-	if (remove_next)
+	if (remove_next) {
 		ret = dup_anon_vma(target, next, &anon_dup);
-	if (!ret && vmg->copied_from)
+		if (ret)
+			return ret;
+	}
+	if (vmg->copied_from) {
 		ret = dup_anon_vma(target, vmg->copied_from, &anon_dup);
-	if (ret)
-		return ret;
+		if (ret)
+			return ret;
+	}
 
 	if (remove_next) {
 		vma_start_write(next);
-- 
2.53.0.273.g2a3d683680-goog


