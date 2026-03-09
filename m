Return-Path: <kvm+bounces-73315-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AAM+ADTnrmlRKAIAu9opvQ
	(envelope-from <kvm+bounces-73315-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 16:28:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EFDA523BAAF
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 16:28:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 6FE9D3029891
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 15:19:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B8E13D6488;
	Mon,  9 Mar 2026 15:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l1HYB2V0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1672D061B;
	Mon,  9 Mar 2026 15:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773069552; cv=none; b=d0V7xcSYvAOcTfS/gzBET6lHrycmhWcW198k7TI0DeyMJih8MY0ixHnsKjbUKiDWReVv5usungBnRLaR7aMjukkX+/EUNmWrRQ4XttHsPkK5rFLDHhDlZj9OBBU0VDnzaXCuD434RMj2Jb/5HDAbu08b5KM1Y7IHWBvIF30ncbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773069552; c=relaxed/simple;
	bh=U/h2huN/IK33EUYYoVbeCNOLTX65WGNBH1yEJmt4qPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D6Zmv6eZrICPzjztTXz31NO5tiQdgHrnCzpug5r61IdogSyh1cP7yPky7ye5kzk3HCDP74x6sYkn94vW5NSn4aYlQRuIx+aCKM75v4OlR5TuzIIJRfoPUctX1Fuuh2E/JeNTvBnnTBRlgqDtQBRk4BHwpResc/718U1c834aELw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l1HYB2V0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A9EC2BC86;
	Mon,  9 Mar 2026 15:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773069552;
	bh=U/h2huN/IK33EUYYoVbeCNOLTX65WGNBH1yEJmt4qPQ=;
	h=From:To:Cc:Subject:Date:From;
	b=l1HYB2V04oJ/S42Zu9JUsjv5Owzl7dWIJVg9XjlpPgIAXwhiZ81EH5q+dmoG8nVzW
	 xKsIZQ0B9wi04tzX/z93YqUCHDJyEHEwxG4VlhASvbttYe7KGDuSCXkCLxBOhnpJY5
	 nYGMxzAJSQYtcmc82vcKd8/t+YmFKoNv+3huhkBL7y2Psz1c6sncJwBqMSLrJbdDxw
	 d7KraB89RTyGWDDFgnObhpEIBcPuRjdrpSHqBWlf3lqg1I4xb5kZ1dXqVEVCaClf/y
	 YCZDuxk4gPWFoBjI5H/fFusUYLrVRRL0VEiQCJ5LAMe9ThZsh5l2H8AzQ83CNCDS+d
	 gQvEe4ITMwnGQ==
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
Subject: [PATCH v2 0/4] mm: move vma_(kernel|mmu)_pagesize() out of hugetlb.c
Date: Mon,  9 Mar 2026 16:18:57 +0100
Message-ID: <20260309151901.123947-1-david@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EFDA523BAAF
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kvack.org,lists.ozlabs.org,vger.kernel.org,kernel.org,linux-foundation.org,linux.ibm.com,gmail.com,ellerman.id.au,linux.dev,suse.de,oracle.com,google.com,suse.com,redhat.com,intel.com];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-73315-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[david@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-0.992];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

Looking into vma_(kernel|mmu)_pagesize(), I realized that there is one
scenario where DAX would not do the right thing when the kernel is
not compiled with hugetlb support.

Without hugetlb support, vma_(kernel|mmu)_pagesize() will always return
PAGE_SIZE instead of using the ->pagesize() result provided by dax-device
code.

Fix that by moving vma_kernel_pagesize() to core MM code, where it belongs.
I don't think this is stable material, but am not 100% sure.

Also, move vma_mmu_pagesize() while at it. Remove the unnecessary hugetlb.h
inclusion from KVM code.

Cross-compiled heavily.

v1 -> v2:
* Fixup VMA test in patch #2
* Actually CC all people listed below on all patches.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>

David Hildenbrand (Arm) (4):
  mm: move vma_kernel_pagesize() from hugetlb to mm.h
  mm: move vma_mmu_pagesize() from hugetlb to vma.c
  KVM: remove hugetlb.h inclusion
  KVM: PPC: remove hugetlb.h inclusion

 arch/powerpc/kvm/book3s_hv.c       |  1 -
 include/linux/hugetlb.h            | 14 --------------
 include/linux/mm.h                 | 22 ++++++++++++++++++++++
 mm/hugetlb.c                       | 28 ----------------------------
 mm/vma.c                           | 21 +++++++++++++++++++++
 tools/testing/vma/include/custom.h |  5 +++++
 virt/kvm/kvm_main.c                |  1 -
 7 files changed, 48 insertions(+), 44 deletions(-)


base-commit: f75825cdfc4c5477cffcfd2cafa4e5ce5aa67f13
-- 
2.43.0


