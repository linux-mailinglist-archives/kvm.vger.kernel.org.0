Return-Path: <kvm+bounces-73277-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EFykOtqYrmmqGgIAu9opvQ
	(envelope-from <kvm+bounces-73277-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 10:54:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CFDD123693C
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 10:54:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 56C8230175E6
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 09:54:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1635A387578;
	Mon,  9 Mar 2026 09:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tPYz9xrz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C9B385519
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 09:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773050059; cv=none; b=uBVx50BBkTGGCd9kNGq7rf+hYcsVBpanK1dnCEpDiYKmk/mxbFX+bQ530TCjeB090EUjzrzN1X6a7RL8x6R92dV2Obl5G7u9O76nBFc9m3ofWe3XirLkBFrPlu6hD0HJ1/WnqGXUrukrpMlcuuucxqI5DACu0mFDmJCd2k/bZnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773050059; c=relaxed/simple;
	bh=0dslHDfc8e0m/ec8VD6G1x697Vl+o1F8eHqZCQrHxw8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LIIFSb888XWXu7gagkwVVdWaF0WnjyCyccVmcNjVXa4McmkDpV+cRiQLGvloYpt3Yr/Sl+3knAOH+Zajqrw0y7BEjLqbhYPr+zVLFhNkNupKVSYfSY3cnQAbg+t6EKvZ+UePanqr5PHEi3tMlVqePCG1vx5uV+xIEeNYpY5m9iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tPYz9xrz; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2ae4f27033cso80754115ad.3
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 02:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773050055; x=1773654855; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QgiSP3km688q6ojjEduHXzfYAonyqsNdhLOg8lFMsCA=;
        b=tPYz9xrzAiBA9mLrq+Pxvw7CMRlncd2bEcNV/TK9pRDzsGousLh9yF2h2ESkf99tud
         wU6aO6lVS12eXMFrM7EfJKdfHCgGO2oZItM9lPcgDmfZMZYI3aihb83/VqzwJDG6MM7J
         YwKtR1231up7r07dVfTI9fMT4KHaERAiLaE/19oD5GVXXAMmwcLPR5lwUesgRXKS6cOr
         jJ9fLgIMnXL4DqUZAdN31Sr7drLjOsN3nj6osr7f8QKgKU1oBdhcRglXCCmG65eDi0HN
         lOScGOvIe9wtIqY9RHhLTTn2uRyldrAxWikvIbGpzWBaPWJA0VnQIBCGJcgKr1dAOUQN
         yabQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773050055; x=1773654855;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QgiSP3km688q6ojjEduHXzfYAonyqsNdhLOg8lFMsCA=;
        b=DQFZZFuCY6j0z1Ea4ismeDifpZLViZ94I9KANU7uUpLHwJv77o8oNFrlBqmHxdkdDj
         +S83oQDCFEW8xLaj7xDTJs/ZUa7NtnGjmFN0SUyMBepkHx5COGKFV+vQOGsshaY4RC7/
         PxChZp1xCDp0M5oVoynCdMrQuP2kgX97H9egC385BsETR3IpmH2uDnW1JUG0wS2AWnDl
         QvQqTyji3pmA8mN2HcM9mlAUIOjoCVqQVOZra4ymdaa4br6oFCGYJaDq2+fIsOW0VkgF
         uCIGZhzC9EnB3Zta6gMKlk1iVGaVl+OwtTqHYsq/H6N/ItIXM/kSuG6hO+6uibQMmFZX
         bhKA==
X-Gm-Message-State: AOJu0YwegbFkmpkZd9WoVU13gSqsEamnaEuSPKPebwH2MnhdqX2cRNle
	LWRWhuI7qEE2WYlmq9OvfQdl5J3GZM+7Al/nn53k2g9FvXYdtdSWW1hoyahGoS09u+y2JrGY/ug
	gk4nnG/7Apyi0JysDEBWOrZXFPg==
X-Received: from plef1.prod.google.com ([2002:a17:902:f381:b0:2a5:9a43:6fdf])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:18b:b0:2ae:7fa3:df1c with SMTP id d9443c01a7336-2ae823985a0mr98528365ad.21.1773050055283;
 Mon, 09 Mar 2026 02:54:15 -0700 (PDT)
Date: Mon, 09 Mar 2026 09:53:53 +0000
In-Reply-To: <20260309-gmem-st-blocks-v3-0-815f03d9653e@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260309-gmem-st-blocks-v3-0-815f03d9653e@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773050050; l=820;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=0dslHDfc8e0m/ec8VD6G1x697Vl+o1F8eHqZCQrHxw8=; b=eOCypP2XtIK7WY3YqZd54ElrueSK8F6DJhK/7Y2HZaR12KKA6z53pp3vMBE5jxXzUPXRiI7/S
 mHsrhIlZsLlCMKxkujWBCQjp/ZE0AdpD8N7mP1eC2QkmTI2K/92Y0+b
X-Mailer: b4 0.14.3
Message-ID: <20260309-gmem-st-blocks-v3-2-815f03d9653e@google.com>
Subject: [PATCH RFC v3 2/4] KVM: guest_memfd: Set release always on
 guest_memfd mappings
From: Ackerley Tng <ackerleytng@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	seanjc@google.com, rientjes@google.com, rick.p.edgecombe@intel.com, 
	yan.y.zhao@intel.com, fvdl@google.com, jthoughton@google.com, 
	vannapurve@google.com, shivankg@amd.com, michael.roth@amd.com, 
	pratyush@kernel.org, pasha.tatashin@soleen.com, kalyazin@amazon.com, 
	tabba@google.com, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: CFDD123693C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73277-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[35];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.908];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

Set release always on guest_memfd mappings to enable the use of
.invalidate_folio, which performs inode accounting for guest_memfd.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 77219551056a7..8246b9fbcf832 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -607,6 +607,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	mapping_set_inaccessible(inode->i_mapping);
 	/* Unmovable mappings are supposed to be marked unevictable as well. */
 	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
+	mapping_set_release_always(inode->i_mapping);
 
 	GMEM_I(inode)->flags = flags;
 

-- 
2.53.0.473.g4a7958ca14-goog


