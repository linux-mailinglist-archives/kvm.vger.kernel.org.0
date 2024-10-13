Return-Path: <kvm+bounces-28702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 273E399BB75
	for <lists+kvm@lfdr.de>; Sun, 13 Oct 2024 22:19:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AA5E31F217AC
	for <lists+kvm@lfdr.de>; Sun, 13 Oct 2024 20:19:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7010B1514E4;
	Sun, 13 Oct 2024 20:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b="exIvs+i/"
X-Original-To: kvm@vger.kernel.org
Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581047F48C;
	Sun, 13 Oct 2024 20:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.134.164.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728850693; cv=none; b=HfBruTqb7LNmJUiO4htNyniHlxe8R8otcYTeado2p2kykbJRcUj6rTMiYNrMd1hmjmna15fcZ3COAuOgexZphAIM8j/a0dKz/0hh0ztfYuo9Q8hdOfVNNlxNoFok5gbsHP/G8dl4f308Vebp9JPjXfzxIXLeAH9a7/Dohv0Cp9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728850693; c=relaxed/simple;
	bh=2uXmFeIEmUi172m67TxMp84JNKzsDgsI9o/AeKyM2yc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ResDTWNsgJvHCWHNpBfkWHFiYGyNcQzG3Tvro7hAjRNjYGfZ3YsuWd/s2/77VW3nPiYGPNL/Gkro6wAPWnNtwhxzVsylwhAy3XlRnCHOENMbDolvurAinI2hltmlTOCw/U06xSi5ebtpEy2+LLaXEf4B1ZA1e5qRK3MISLGnkKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr; spf=pass smtp.mailfrom=inria.fr; dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b=exIvs+i/; arc=none smtp.client-ip=192.134.164.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inria.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Sja7FWx2J2pFF7H03F4ldwixL8Qb/r4LwdjP0v1pkNc=;
  b=exIvs+i/vmrrOC1BhG1dWTdYhowcV77JbThYwDdjK0/Wqiaqq9Fr0cce
   rNzCFJlH0Zl3Gc94qiLI1s9PCSVuCYpsLvZjcvp+ULtzzTXbcfRvMqOYM
   ncj7g6L1s1poZOa9BL666TBGtZjDcSWk9IcDnPVvWZAmigUTgCebAcAqC
   Y=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="6.11,201,1725314400"; 
   d="scan'208";a="98968275"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2024 22:17:57 +0200
From: Julia Lawall <Julia.Lawall@inria.fr>
To: linux-nfs@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	vbabka@suse.cz,
	paulmck@kernel.org,
	Tom Talpey <tom@talpey.com>,
	Dai Ngo <Dai.Ngo@oracle.com>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Neil Brown <neilb@suse.de>,
	linux-can@vger.kernel.org,
	bridge@lists.linux.dev,
	b.a.t.m.a.n@lists.open-mesh.org,
	linux-kernel@vger.kernel.org,
	wireguard@lists.zx2c4.com,
	netdev@vger.kernel.org,
	ecryptfs@vger.kernel.org,
	linux-block@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Naveen N Rao <naveen@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: [PATCH 00/17] replace call_rcu by kfree_rcu for simple kmem_cache_free callback
Date: Sun, 13 Oct 2024 22:16:47 +0200
Message-Id: <20241013201704.49576-1-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since SLOB was removed and since
commit 6c6c47b063b5 ("mm, slab: call kvfree_rcu_barrier() from kmem_cache_destroy()"),
it is not necessary to use call_rcu when the callback only performs
kmem_cache_free. Use kfree_rcu() directly.

The changes were done using the following Coccinelle semantic patch.
This semantic patch is designed to ignore cases where the callback
function is used in another way.

// <smpl>
#spatch --all-includes --include-headers

@r@
expression e;
local idexpression e2;
identifier cb,f,g;
position p;
@@

(
call_rcu(...,e2)
|
call_rcu(&e->f,cb@p)
|
call_rcu(&e->f.g,cb@p)
)

@r1@
type T,T1;
identifier x,r.cb;
@@

 cb(...) {
(
   kmem_cache_free(...);
|
   T x = ...;
   kmem_cache_free(...,(T1)x);
|
   T x;
   x = ...;
   kmem_cache_free(...,(T1)x);
)
 }

@s depends on r1@
position p != r.p;
identifier r.cb;
@@

 cb@p

@script:ocaml@
cb << r.cb;
p << s.p;
@@

Printf.eprintf "Other use of %s at %s:%d\n" cb (List.hd p).file (List.hd p).line

@depends on r1 && !s@
expression e;
identifier r.cb,f,g;
position r.p;
@@

(
- call_rcu(&e->f,cb@p)
+ kfree_rcu(e,f)
|
- call_rcu(&e->f.g,cb@p)
+ kfree_rcu(e,f.g)
)

@r1a depends on !s@
type T,T1;
identifier x,r.cb;
@@

- cb(...) {
(
-  kmem_cache_free(...);
|
-  T x = ...;
-  kmem_cache_free(...,(T1)x);
|
-  T x;
-  x = ...;
-  kmem_cache_free(...,(T1)x);
)
- }

@r2 depends on !r1@
identifier r.cb;
@@

cb(...) {
 ...
}

@script:ocaml depends on !r1 && !r2@
cb << r.cb;
@@

Printf.eprintf "need definition for %s\n" cb
// </smpl>

---

 arch/powerpc/kvm/book3s_mmu_hpte.c  |    8 ------
 block/blk-ioc.c                     |    9 ------
 drivers/net/wireguard/allowedips.c  |    9 +-----
 fs/ecryptfs/dentry.c                |    8 ------
 fs/nfsd/nfs4state.c                 |    9 ------
 kernel/time/posix-timers.c          |    9 ------
 net/batman-adv/translation-table.c  |   47 ++----------------------------------
 net/bridge/br_fdb.c                 |    9 ------
 net/can/gw.c                        |   13 ++-------
 net/ipv4/fib_trie.c                 |    8 ------
 net/ipv4/inetpeer.c                 |    9 +-----
 net/ipv6/ip6_fib.c                  |    9 ------
 net/ipv6/xfrm6_tunnel.c             |    8 ------
 net/kcm/kcmsock.c                   |   10 -------
 net/netfilter/nf_conncount.c        |   10 -------
 net/netfilter/nf_conntrack_expect.c |   10 -------
 net/netfilter/xt_hashlimit.c        |    9 ------
 17 files changed, 23 insertions(+), 171 deletions(-)

