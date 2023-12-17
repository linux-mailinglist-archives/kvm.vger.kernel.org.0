Return-Path: <kvm+bounces-4648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E22A8815DFB
	for <lists+kvm@lfdr.de>; Sun, 17 Dec 2023 09:10:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9985C283BD3
	for <lists+kvm@lfdr.de>; Sun, 17 Dec 2023 08:10:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE5E47490;
	Sun, 17 Dec 2023 08:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="18StM74x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906EF6D19
	for <kvm@vger.kernel.org>; Sun, 17 Dec 2023 08:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5d064f9e2a1so19780447b3.1
        for <kvm@vger.kernel.org>; Sun, 17 Dec 2023 00:09:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702800564; x=1703405364; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QMKZfo7MQTdL4MON6ILyvITz6v7ECb8JCcQoDm+y1oY=;
        b=18StM74xDhwud0tInlqDNyUZWnx4NYG6hfMYbYEBqjguAvrdoX4aDCVjiBHq1K0wde
         VtZAiLUJGw2eg5Q77ipohAPJ22T7Dk5LZsHdhB0K7rlIti1/yHOYtcGqIGjV7+2bXvn3
         kdK5bIUdpdWGcdlgdMOwkUBu24aLoZl6e8YTPcD4E6P7O699b493lp8H0HC8Ybt5OvjX
         4QDvBezVhjDKw7lHNE6luDlFUx/GoqfCCk4f0A+lX7aPV8ERCDQUwsJpbUsJ42t8QXqg
         ZDL14opL+JIPzIsGQrre/Tr6J4e0w2VoVA3pIRUnbLpqphhgwNDUss97TgC8+gAYgYQF
         ZNrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702800564; x=1703405364;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QMKZfo7MQTdL4MON6ILyvITz6v7ECb8JCcQoDm+y1oY=;
        b=aA86s4vG4HXpGanIRC3eo2JBOKSzeUuLCjlkWhtqAxSpBzljFSC9CG12r6CWDyIF98
         0gAgee6R3jYrcgWP7DnZWUhFhB1dq6LmXjfSQiT1Os5kqHp0n+UQ0jMrm20Mw0GMEHrQ
         28HON/0TZ2pYZipfcYQmgI1/wcyUz6IYyQFE0jkBsu9oklUXZOnlS+eNO0CVrJsHq449
         JI5jryxjQS6N0idn+MKdLr5LQtMriJT/04xe9BVMdAv51XDwfs1KfsxKJuohT+DIH/I5
         0DoiB+aKhEiQ5WJoD63cPwVg/50C85aBKSgUxXg49LdC/C6q6pRLfcB28+f5ZQGOUmd2
         zWGg==
X-Gm-Message-State: AOJu0Yx8gO738KboFDPVJBo7DcVr/SZfEumRxS+oHTd7lJSfOWb8+gvQ
	vBJzkxxyoOYMIIvPXtZaM2fDApjcaef9ONJ/4g==
X-Google-Smtp-Source: AGHT+IFJCnycDJwsU67lKu1qB4q73cruRdEMF2MdI6NqbIK/eO/tqFob5FbZApzAiGPawGrZ+fw8MgSBnnOaG1MLLw==
X-Received: from almasrymina.svl.corp.google.com ([2620:15c:2c4:200:3eb4:e132:f78a:5ba9])
 (user=almasrymina job=sendgmr) by 2002:a05:690c:c02:b0:5e6:2989:a661 with
 SMTP id cl2-20020a05690c0c0200b005e62989a661mr94697ywb.10.1702800564661; Sun,
 17 Dec 2023 00:09:24 -0800 (PST)
Date: Sun, 17 Dec 2023 00:09:11 -0800
In-Reply-To: <20231217080913.2025973-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231217080913.2025973-1-almasrymina@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231217080913.2025973-4-almasrymina@google.com>
Subject: [PATCH net-next v2 3/3] net: add netmem_t to skb_frag_t
From: Mina Almasry <almasrymina@google.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev
Cc: Mina Almasry <almasrymina@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, 
	"=?UTF-8?q?Christian=20K=C3=B6nig?=" <christian.koenig@amd.com>, Shakeel Butt <shakeelb@google.com>, 
	Yunsheng Lin <linyunsheng@huawei.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Use netmem_t instead of page directly in skb_frag_t. Currently netmem_t
is always a struct page underneath, but the abstraction allows efforts
to add support for skb frags not backed by pages.

There is unfortunately 1 instance where the skb_frag_t is assumed to be
a bio_vec in kcm. For this case, add a debug assert that the skb frag is
indeed backed by a page, and do a cast.

Add skb[_frag]_fill_netmem_*() and skb_add_rx_frag_netmem() helpers so
that the API can be used to create netmem skbs.

Signed-off-by: Mina Almasry <almasrymina@google.com>

---

v2:
- Add skb frag filling helpers.
---
 include/linux/skbuff.h | 70 ++++++++++++++++++++++++++++++++----------
 net/core/skbuff.c      | 22 +++++++++----
 net/kcm/kcmsock.c      | 10 ++++--
 3 files changed, 78 insertions(+), 24 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 7ce38874dbd1..03ab13072962 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -37,6 +37,7 @@
 #endif
 #include <net/net_debug.h>
 #include <net/dropreason-core.h>
+#include <net/netmem.h>
 
 /**
  * DOC: skb checksums
@@ -359,7 +360,11 @@ extern int sysctl_max_skb_frags;
  */
 #define GSO_BY_FRAGS	0xFFFF
 
-typedef struct bio_vec skb_frag_t;
+typedef struct skb_frag {
+	struct netmem *bv_page;
+	unsigned int bv_len;
+	unsigned int bv_offset;
+} skb_frag_t;
 
 /**
  * skb_frag_size() - Returns the size of a skb fragment
@@ -2431,22 +2436,37 @@ static inline unsigned int skb_pagelen(const struct sk_buff *skb)
 	return skb_headlen(skb) + __skb_pagelen(skb);
 }
 
+static inline void skb_frag_fill_netmem_desc(skb_frag_t *frag,
+					     struct netmem *netmem, int off,
+					     int size)
+{
+	frag->bv_page = netmem;
+	frag->bv_offset = off;
+	skb_frag_size_set(frag, size);
+}
+
 static inline void skb_frag_fill_page_desc(skb_frag_t *frag,
 					   struct page *page,
 					   int off, int size)
 {
-	frag->bv_page = page;
-	frag->bv_offset = off;
-	skb_frag_size_set(frag, size);
+	skb_frag_fill_netmem_desc(frag, page_to_netmem(page), off, size);
+}
+
+static inline void __skb_fill_netmem_desc_noacc(struct skb_shared_info *shinfo,
+						int i, struct netmem *netmem,
+						int off, int size)
+{
+	skb_frag_t *frag = &shinfo->frags[i];
+
+	skb_frag_fill_netmem_desc(frag, netmem, off, size);
 }
 
 static inline void __skb_fill_page_desc_noacc(struct skb_shared_info *shinfo,
 					      int i, struct page *page,
 					      int off, int size)
 {
-	skb_frag_t *frag = &shinfo->frags[i];
-
-	skb_frag_fill_page_desc(frag, page, off, size);
+	__skb_fill_netmem_desc_noacc(shinfo, i, page_to_netmem(page), off,
+				     size);
 }
 
 /**
@@ -2462,10 +2482,10 @@ static inline void skb_len_add(struct sk_buff *skb, int delta)
 }
 
 /**
- * __skb_fill_page_desc - initialise a paged fragment in an skb
+ * __skb_fill_netmem_desc - initialise a paged fragment in an skb
  * @skb: buffer containing fragment to be initialised
  * @i: paged fragment index to initialise
- * @page: the page to use for this fragment
+ * @netmem: the netmem to use for this fragment
  * @off: the offset to the data with @page
  * @size: the length of the data
  *
@@ -2474,10 +2494,13 @@ static inline void skb_len_add(struct sk_buff *skb, int delta)
  *
  * Does not take any additional reference on the fragment.
  */
-static inline void __skb_fill_page_desc(struct sk_buff *skb, int i,
-					struct page *page, int off, int size)
+static inline void __skb_fill_netmem_desc(struct sk_buff *skb, int i,
+					  struct netmem *netmem, int off,
+					  int size)
 {
-	__skb_fill_page_desc_noacc(skb_shinfo(skb), i, page, off, size);
+	struct page *page = netmem_to_page(netmem);
+
+	__skb_fill_netmem_desc_noacc(skb_shinfo(skb), i, netmem, off, size);
 
 	/* Propagate page pfmemalloc to the skb if we can. The problem is
 	 * that not all callers have unique ownership of the page but rely
@@ -2485,7 +2508,21 @@ static inline void __skb_fill_page_desc(struct sk_buff *skb, int i,
 	 */
 	page = compound_head(page);
 	if (page_is_pfmemalloc(page))
-		skb->pfmemalloc	= true;
+		skb->pfmemalloc = true;
+}
+
+static inline void __skb_fill_page_desc(struct sk_buff *skb, int i,
+					struct page *page, int off, int size)
+{
+	__skb_fill_netmem_desc(skb, i, page_to_netmem(page), off, size);
+}
+
+static inline void skb_fill_netmem_desc(struct sk_buff *skb, int i,
+					struct netmem *netmem, int off,
+					int size)
+{
+	__skb_fill_netmem_desc(skb, i, netmem, off, size);
+	skb_shinfo(skb)->nr_frags = i + 1;
 }
 
 /**
@@ -2505,8 +2542,7 @@ static inline void __skb_fill_page_desc(struct sk_buff *skb, int i,
 static inline void skb_fill_page_desc(struct sk_buff *skb, int i,
 				      struct page *page, int off, int size)
 {
-	__skb_fill_page_desc(skb, i, page, off, size);
-	skb_shinfo(skb)->nr_frags = i + 1;
+	skb_fill_netmem_desc(skb, i, page_to_netmem(page), off, size);
 }
 
 /**
@@ -2532,6 +2568,8 @@ static inline void skb_fill_page_desc_noacc(struct sk_buff *skb, int i,
 
 void skb_add_rx_frag(struct sk_buff *skb, int i, struct page *page, int off,
 		     int size, unsigned int truesize);
+void skb_add_rx_frag_netmem(struct sk_buff *skb, int i, struct netmem *netmem,
+			    int off, int size, unsigned int truesize);
 
 void skb_coalesce_rx_frag(struct sk_buff *skb, int i, int size,
 			  unsigned int truesize);
@@ -3422,7 +3460,7 @@ static inline void skb_frag_off_copy(skb_frag_t *fragto,
  */
 static inline struct page *skb_frag_page(const skb_frag_t *frag)
 {
-	return frag->bv_page;
+	return netmem_to_page(frag->bv_page);
 }
 
 /**
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 83af8aaeb893..053d220aa2f2 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -845,16 +845,24 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
 }
 EXPORT_SYMBOL(__napi_alloc_skb);
 
-void skb_add_rx_frag(struct sk_buff *skb, int i, struct page *page, int off,
-		     int size, unsigned int truesize)
+void skb_add_rx_frag_netmem(struct sk_buff *skb, int i, struct netmem *netmem,
+			    int off, int size, unsigned int truesize)
 {
 	DEBUG_NET_WARN_ON_ONCE(size > truesize);
 
-	skb_fill_page_desc(skb, i, page, off, size);
+	skb_fill_netmem_desc(skb, i, netmem, off, size);
 	skb->len += size;
 	skb->data_len += size;
 	skb->truesize += truesize;
 }
+EXPORT_SYMBOL(skb_add_rx_frag_netmem);
+
+void skb_add_rx_frag(struct sk_buff *skb, int i, struct page *page, int off,
+		     int size, unsigned int truesize)
+{
+	skb_add_rx_frag_netmem(skb, i, page_to_netmem(page), off, size,
+			       truesize);
+}
 EXPORT_SYMBOL(skb_add_rx_frag);
 
 void skb_coalesce_rx_frag(struct sk_buff *skb, int i, int size,
@@ -1868,10 +1876,11 @@ int skb_copy_ubufs(struct sk_buff *skb, gfp_t gfp_mask)
 
 	/* skb frags point to kernel buffers */
 	for (i = 0; i < new_frags - 1; i++) {
-		__skb_fill_page_desc(skb, i, head, 0, psize);
+		__skb_fill_netmem_desc(skb, i, page_to_netmem(head), 0, psize);
 		head = (struct page *)page_private(head);
 	}
-	__skb_fill_page_desc(skb, new_frags - 1, head, 0, d_off);
+	__skb_fill_netmem_desc(skb, new_frags - 1, page_to_netmem(head), 0,
+			       d_off);
 	skb_shinfo(skb)->nr_frags = new_frags;
 
 release:
@@ -3609,7 +3618,8 @@ skb_zerocopy(struct sk_buff *to, struct sk_buff *from, int len, int hlen)
 		if (plen) {
 			page = virt_to_head_page(from->head);
 			offset = from->data - (unsigned char *)page_address(page);
-			__skb_fill_page_desc(to, 0, page, offset, plen);
+			__skb_fill_netmem_desc(to, 0, page_to_netmem(page),
+					       offset, plen);
 			get_page(page);
 			j = 1;
 			len -= plen;
diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 65d1f6755f98..5c46db045f4c 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -636,9 +636,15 @@ static int kcm_write_msgs(struct kcm_sock *kcm)
 		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++)
 			msize += skb_shinfo(skb)->frags[i].bv_len;
 
+		/* The cast to struct bio_vec* here assumes the frags are
+		 * struct page based.
+		 */
+		DEBUG_NET_WARN_ON_ONCE(
+			!skb_frag_page(&skb_shinfo(skb)->frags[0]));
+
 		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE,
-			      skb_shinfo(skb)->frags, skb_shinfo(skb)->nr_frags,
-			      msize);
+			      (const struct bio_vec *)skb_shinfo(skb)->frags,
+			      skb_shinfo(skb)->nr_frags, msize);
 		iov_iter_advance(&msg.msg_iter, txm->frag_offset);
 
 		do {
-- 
2.43.0.472.g3155946c3a-goog


