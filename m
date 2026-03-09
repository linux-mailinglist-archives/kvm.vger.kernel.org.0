Return-Path: <kvm+bounces-73319-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KPqRD5PnrmlRKAIAu9opvQ
	(envelope-from <kvm+bounces-73319-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 16:30:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C0DF723BAFB
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 16:30:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DB597305D49D
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 15:20:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CDA33D9057;
	Mon,  9 Mar 2026 15:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e5ADz3X4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1E53793AB;
	Mon,  9 Mar 2026 15:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773069579; cv=none; b=q3vzSC7hRAhqHD7W3Z5yyf4YCOarMCysVGUcBDYnC0iD4gRX8YYhe8nNwv0iYF8vR5ptmZDEDI9to4xMQ0RQi2m1XHbyJXrlF9mb8JNMvSj+WGWpUAfaicsKGCDhgsWRZ6IdadBGef8A+bZHafuFxKTutJDiIvCya28NjqdcQyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773069579; c=relaxed/simple;
	bh=q/OK9MenvejDughLrSZOznakkVUTLmx28+Vi6bUHGJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xwg8yfoO42r6AG0kWeOKxYTGJ4JKTrh87zD2MGC3zQg0MuVWTUa/13wf2A0GFLGyUKrHC24kOOfJNHCVo8w/m6vNCtiEK/IzoTk0NrRGVLcYCXcQhSGtjEKxrPZCh9wHE9exNpbK7JnYCnjd2HnWWJ9YPlQhlQisL4T2nT4rJXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e5ADz3X4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E68A3C2BC86;
	Mon,  9 Mar 2026 15:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773069579;
	bh=q/OK9MenvejDughLrSZOznakkVUTLmx28+Vi6bUHGJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e5ADz3X4fdfGQ+QEhi4NobrQcvdh+sIqHuN1lR9eH1IXLKh4ehimkDrH425UOshs6
	 cvqoazVhrxU+UDeYiyGlmsmBOHdE/Gqhy1joKiUvwHgZOeKu3MIbzsRI3rNSFZ0pOp
	 0X985TzMHB6ViaeHWx2+Stsi4ao7uIV1Fx09Hz3kQCklf53GBAm6F+oQIcmqY05hR6
	 w7rzTfbsry5MDrFfNLgFpeT0QH0ZSWVceRoG9a1pDHeUkO2cUruTyZ7lxIAA3UuZ7U
	 cNb2r8U+cFd3WnW1Tn+i6azBCX+almkPPgh4gl4k0F7UXbmkov6JCACpkkg5tOQtHp
	 v9hC3syVh165g==
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
Subject: [PATCH v2 4/4] KVM: PPC: remove hugetlb.h inclusion
Date: Mon,  9 Mar 2026 16:19:01 +0100
Message-ID: <20260309151901.123947-5-david@kernel.org>
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
X-Rspamd-Queue-Id: C0DF723BAFB
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kvack.org,lists.ozlabs.org,vger.kernel.org,kernel.org,linux-foundation.org,linux.ibm.com,gmail.com,ellerman.id.au,linux.dev,suse.de,oracle.com,google.com,suse.com,redhat.com,intel.com];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-73319-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

hugetlb.h is no longer required now that we moved vma_kernel_pagesize()
to mm.h.

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/powerpc/kvm/book3s_hv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 08e5816fdd61..61dbeea317f3 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -36,7 +36,6 @@
 #include <linux/gfp.h>
 #include <linux/vmalloc.h>
 #include <linux/highmem.h>
-#include <linux/hugetlb.h>
 #include <linux/kvm_irqfd.h>
 #include <linux/irqbypass.h>
 #include <linux/module.h>
-- 
2.43.0


