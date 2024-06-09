Return-Path: <kvm+bounces-19121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 52F839014FB
	for <lists+kvm@lfdr.de>; Sun,  9 Jun 2024 10:28:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C1F7E1F20F56
	for <lists+kvm@lfdr.de>; Sun,  9 Jun 2024 08:28:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C594208AD;
	Sun,  9 Jun 2024 08:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b="c3jg9XiA"
X-Original-To: kvm@vger.kernel.org
Received: from mail2-relais-roc.national.inria.fr (mail2-relais-roc.national.inria.fr [192.134.164.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB351CA89;
	Sun,  9 Jun 2024 08:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.134.164.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717921680; cv=none; b=ZQPgzDDLcl/QSGo1gkIIy7VgMsEwPZA8zCyPrtXP8d8XXrYlQGU52loGAQ0YxcC1EyiSGobzedoZQIySNxC0PqYUjGZSC1rtprAhDXMfLSDsWxYpOiVw0IS/rMoBYRaXhDRne9RRYJyQOJdImTUKTtULF1unqy2Oy5ClxFcJuGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717921680; c=relaxed/simple;
	bh=cl9fmVF+HqNubeETqLioP3KnvOsLThBpD2QkFmQe7ZM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cHqexTzfwS2VZtl2wgHwW7NnVCV5Gnx/7CQTtZRsC5mgR0Ol7JnCxa8A4u8T7CyPwakz4HnjxjPGmTmUbnRQ0AaANnLYziwdOYhlimmw+lh8MRBNh+wfJWswxtFtJey2YKpruKScdh8GjN0zpOZ5TyKP/iYvfERvpv8/36nDwrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr; spf=pass smtp.mailfrom=inria.fr; dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b=c3jg9XiA; arc=none smtp.client-ip=192.134.164.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inria.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=REYx9XJxXex1wT0g8DdBknTJa5z8s+++8BsQM1tAkdE=;
  b=c3jg9XiAgeKcNkg9Ypz1MXA57+I6z9Upi3oqzG67AIxQoc2Tb/l9+twd
   o1xqjWHj9bZB/XffVTZ6y3Q5wlIBrpiRIuaxP20ZifTf9z4PP9a6/uHrQ
   jbNAr8EHCg32T8reqfZHBfM1Bu9ssqsOLmK26M8DXHwpWqbgwQfkqJwz8
   I=;
Authentication-Results: mail2-relais-roc.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="6.08,225,1712613600"; 
   d="scan'208";a="169696895"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2024 10:27:48 +0200
From: Julia Lawall <Julia.Lawall@inria.fr>
To: linux-block@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	bridge@lists.linux.dev,
	linux-trace-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	kvm@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	"Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Nicholas Piggin <npiggin@gmail.com>,
	netdev@vger.kernel.org,
	wireguard@lists.zx2c4.com,
	linux-kernel@vger.kernel.org,
	ecryptfs@vger.kernel.org,
	Neil Brown <neilb@suse.de>,
	Olga Kornievskaia <kolga@netapp.com>,
	Dai Ngo <Dai.Ngo@oracle.com>,
	Tom Talpey <tom@talpey.com>,
	linux-nfs@vger.kernel.org,
	linux-can@vger.kernel.org,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 00/14] replace call_rcu by kfree_rcu for simple kmem_cache_free callback
Date: Sun,  9 Jun 2024 10:27:12 +0200
Message-Id: <20240609082726.32742-1-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since SLOB was removed, it is not necessary to use call_rcu
when the callback only performs kmem_cache_free. Use
kfree_rcu() directly.

The changes were done using the following Coccinelle semantic patch.
This semantic patch is designed to ignore cases where the callback
function is used in another way.

// <smpl>
@r@
expression e;
local idexpression e2;
identifier cb,f;
position p;
@@

(
call_rcu(...,e2)
|
call_rcu(&e->f,cb@p)
)

@r1@
type T;
identifier x,r.cb;
@@

 cb(...) {
(
   kmem_cache_free(...);
|
   T x = ...;
   kmem_cache_free(...,x);
|
   T x;
   x = ...;
   kmem_cache_free(...,x);
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

Printf.eprintf "Other use of %s at %s:%d\n"
   cb (List.hd p).file (List.hd p).line

@depends on r1 && !s@
expression e;
identifier r.cb,f;
position r.p;
@@

- call_rcu(&e->f,cb@p)
+ kfree_rcu(e,f)

@r1a depends on !s@
type T;
identifier x,r.cb;
@@

- cb(...) {
(
-  kmem_cache_free(...);
|
-  T x = ...;
-  kmem_cache_free(...,x);
|
-  T x;
-  x = ...;
-  kmem_cache_free(...,x);
)
- }
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

---

 arch/powerpc/kvm/book3s_mmu_hpte.c  |    8 +-------
 block/blk-ioc.c                     |    9 +--------
 drivers/net/wireguard/allowedips.c  |    9 ++-------
 fs/ecryptfs/dentry.c                |    8 +-------
 fs/nfsd/nfs4state.c                 |    9 +--------
 fs/tracefs/inode.c                  |   10 +---------
 kernel/time/posix-timers.c          |    9 +--------
 kernel/workqueue.c                  |    8 +-------
 net/bridge/br_fdb.c                 |    9 +--------
 net/can/gw.c                        |   13 +++----------
 net/ipv4/fib_trie.c                 |    8 +-------
 net/ipv4/inetpeer.c                 |    9 ++-------
 net/ipv6/ip6_fib.c                  |    9 +--------
 net/ipv6/xfrm6_tunnel.c             |    8 +-------
 net/kcm/kcmsock.c                   |   10 +---------
 net/netfilter/nf_conncount.c        |   10 +---------
 net/netfilter/nf_conntrack_expect.c |   10 +---------
 net/netfilter/xt_hashlimit.c        |    9 +--------
 18 files changed, 22 insertions(+), 143 deletions(-)

