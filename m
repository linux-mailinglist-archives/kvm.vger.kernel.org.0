Return-Path: <kvm+bounces-73318-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2Dq0EMTmrmlRKAIAu9opvQ
	(envelope-from <kvm+bounces-73318-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 16:27:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DB5A23BA10
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 16:26:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DF18E30A584E
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 15:19:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA9F73D903A;
	Mon,  9 Mar 2026 15:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U8TGSaQ0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB163D75D8;
	Mon,  9 Mar 2026 15:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773069573; cv=none; b=umlSadiTvzfiSVkis/Fu/6XLUBQWXYwICrqOb8c72+N+GSqPKr7zKMiVCb1+VD03WhsBT5rQDdnRknIisblGVRN8qln//ba4fHXhVG4H0dKYn7aaRGYwn2VL67zoUNvwAYTbp3/mztnp9kKYy1vDi/8XoTItPGz7R8aRJDKKuLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773069573; c=relaxed/simple;
	bh=1Tpg8dpXogI43ldKvRVlXnwzZdDW6L9YkP34QCbqGtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uxZRi0g26/XX6VbeCUrgn59oxD4JNThGCgGJ6WKyLPPi5yhK29bOmOsuxOv/yQKe82EbCrRG7gjZy700wJMbSeMDWBNTOhvVVoDKC8amakovdBzcvZlLDeO+ORmv2dljRw/65R44w/ad0gtX5GAdg9LtEXLjVhuVfKmuUcSbgF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U8TGSaQ0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70011C4CEF7;
	Mon,  9 Mar 2026 15:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773069573;
	bh=1Tpg8dpXogI43ldKvRVlXnwzZdDW6L9YkP34QCbqGtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U8TGSaQ09iR0FrKwfQh/wBeA8JtXPa5xh1Ijd5GD24HH22yWtc+WRIYBBREe/zHoX
	 mim+0F4xyogg6j27YYr6oJKdiXjqBE929wUafl3JTo8XBlu9GK0F3BawY08nMnNnN5
	 +dZqqJk/DQlH12qhxFlRweFgExjYT5kIvUesROaZ4jsW99zDPzXaNBzmbx0Z9pzSya
	 FVcCIb3miryqet2ggbFgd0dGu1BmqGwHdYr/EJT5KzwbLnzwxP6bklbZHFaXUh5xdO
	 wano4BfHvih62oU0ZcLBupR6QdJQT1Qvl6hD0050OGIcjN1HThoOUCGOUqmWope7ZF
	 BXIeXML+1yMnA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 3/4] KVM: remove hugetlb.h inclusion
Date: Mon,  9 Mar 2026 16:19:00 +0100
Message-ID: <20260309151901.123947-4-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260309151901.123947-1-david@kernel.org>
References: <20260309151901.123947-1-david@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9DB5A23BA10
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kvack.org,lists.ozlabs.org,vger.kernel.org,kernel.org,linux-foundation.org,linux.ibm.com,gmail.com,ellerman.id.au,linux.dev,suse.de,oracle.com,google.com,suse.com,redhat.com,intel.com];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-73318-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[david@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-0.990];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

hugetlb.h is no longer required now that we moved vma_kernel_pagesize()
to mm.h.

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 virt/kvm/kvm_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 22f8a672e1fd..58059648b881 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -41,7 +41,6 @@
 #include <linux/spinlock.h>
 #include <linux/compat.h>
 #include <linux/srcu.h>
-#include <linux/hugetlb.h>
 #include <linux/slab.h>
 #include <linux/sort.h>
 #include <linux/bsearch.h>
-- 
2.43.0


