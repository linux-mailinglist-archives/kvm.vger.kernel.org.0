Return-Path: <kvm+bounces-51072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C237EAED653
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 09:58:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 777331899221
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 07:58:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B80C23F434;
	Mon, 30 Jun 2025 07:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bm6m72Tx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34AC123AE66;
	Mon, 30 Jun 2025 07:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751270268; cv=none; b=sKrk2BQe9L0NLOk367AX8IjoifvzQsGlSL9TExqqT/GHYWYedEfe66HDOMQAiLk92kofVJnjWjauNdQoET7zARrgGmp03/Y4d5EEw4Rr33qvoZKoc9sRwMH6lSumyPRW3DfPSCYl2Bu0Q4NkCtNNHgd7Qf476xtP2FW9SfwwwuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751270268; c=relaxed/simple;
	bh=yYhC1SvTr4r/q4aKyafrkgVQ1b+GHoCyO4kJ6c3v10c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Kd4lc0LbGeTnd/FJsy8DUsIcn6qeQlLXkG0D0Z0eEsygaiHp81aqgw6dOvK3RafV+6t9wj1DZxhydaZ+ZAc2Hwcok0DUjuNfj/ZdTtvC+DNdkzKCCg29411fIATDVFvqhFJjKakMbU7IXWDCcBdtKKUwyZ/WeGkEYnofTULzwbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bm6m72Tx; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-235d6de331fso20464895ad.3;
        Mon, 30 Jun 2025 00:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751270266; x=1751875066; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Te1ubGn4t4pkro6tbCWw9qlZ7DcNvsq3ids6nDR7Ezw=;
        b=bm6m72TxS2FOTgZ68HvjBygKgMt1EgxAWWPY7PJV3L+h6vIclrxRqsHg7Zo/FVYzM4
         clVjCZ+MUMeXZPm429Aa29pUPTpQ1vkZg3U+RbfSGE+bFVsj4QFZ4Je1tUJQY5KcjWYQ
         +l/ai/Wymg0BgDNW5pK2qIWRKJCj8kXLiqKx/4Fi1wdje2eIvh7CkC6m6uXFcbadst3l
         mSYZ6AgbGNaG4mxZVpD/KeOa/8yfw6mTMLwr/rbB0k6sR5Ql3o0ea21L7ZFuzs8ORLSr
         2KoQLspZuxyfEhOakGkzU8JnjK2KfiPA3cHVotKAg0Mf3FUoNDlls/sp2mkySB6WZ5Gv
         GNjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751270266; x=1751875066;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Te1ubGn4t4pkro6tbCWw9qlZ7DcNvsq3ids6nDR7Ezw=;
        b=Hka0rQtYn9aMuK3/xIMHjrZWsnGxpQJnPlURjhBflT1awgCpSCt/bXFV2JAK+PW4lo
         Xv9NdfaW3INL9NjBQUhFIUs3DvZpwAEv7ZxIcFq/mZxKRFQzo8ABpvYzdTLkQKXnyevJ
         1sNK/FwLbg1PBVdOHZwpRqRxrgGhUe7cUPHUyTgK2VmIKhgQbD7Ck96JWcUIr+53rhh8
         pyc9UhqoWXqhOGtTjbPiHvMzDM0OBj63eCJl/QgfZkcqiIo/IEFFT6jsTSfAz/n2vUrK
         GnINflG7hh6nMJ/2lIj3Q+3E181oZa7AHw7NmaBJa1iB1NhMd2NAlCSZn4G2tU//Xjwy
         EHhQ==
X-Forwarded-Encrypted: i=1; AJvYcCVDYzaqXpac8r3YH+7lz6FLLSFELKCn6WAHzQ59qUrJqqgkojDQAX+hvP9e8tV4B7ruHnFj0uo/Y0elTrRL@vger.kernel.org, AJvYcCWsVVsYNXK2E5d/53S0vtWvdS1JD/hQ5xJjyZSMZmBijjw9IwI5p/9PTDWsqkBSeYmaBwJbmVAi@vger.kernel.org, AJvYcCXVuA1Mr3/VF1rdlq5EhgHNfm4cXXYjmCE+rtpP3eYAKTcz7Jn9jivVDpbY/rp76Im/vTQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7vdrCcB2s2rZ9vcbbZ92Rx+Vje2QVyDZanNtVNZ7efBn3Hy6i
	zFG39HG0IlSqNZ87iIqfAPuCoP7p9ze5NAw/Kmc5c6SpuBkC6dpcycml
X-Gm-Gg: ASbGncuQrjExa2mEqfK7WFFB6fSU9r4YzU8TtfgaC10UKpFg5Y5wOiW/naZD8N/xy0o
	p0+xa1zB1LU0iPlXoglnUm1glx1lJYDXwcFnS0dh3GSg9v3KgZb9VNXbOA9nqCckdJ2D01FuH6b
	yVWwSBiIK4KTV2JrVdtCVEv7XFWwA00CT2VAdtHhv0T2zJOXzfYYS5290HpUhZw5BqJ32ReMjTO
	KliSEewL7dhFAHTL70jqVA6vFZfkZLhIF3BDzXO0pSwhLJRRGZ00ppz0puopdfoWT+81RxNbPJn
	GHixNxIdufdCGAD1gqho0P10Sl5DoDUcPmEugeYAVBN6EqIW9fJJ1dTk4Ob6g3loIPA/4ilgwdW
	lCSW51i0G
X-Google-Smtp-Source: AGHT+IElsi4FmjD8ptxsYXp6SgY5L4HbtTxYXy+6Tm1I+pM33trhN/23GKQddZOGFvxJS5SLFMN9ng==
X-Received: by 2002:a17:903:18c:b0:235:ca87:37ae with SMTP id d9443c01a7336-23ac4637152mr195826455ad.41.1751270266294;
        Mon, 30 Jun 2025 00:57:46 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b34e31db02esm7414931a12.63.2025.06.30.00.57.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 00:57:45 -0700 (PDT)
From: Xuewei Niu <niuxuewei97@gmail.com>
X-Google-Original-From: Xuewei Niu <niuxuewei.nxw@antgroup.com>
To: sgarzare@redhat.com,
	mst@redhat.com,
	pabeni@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	stefanha@redhat.com,
	leonardi@redhat.com,
	decui@microsoft.com
Cc: virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	fupan.lfp@antgroup.com,
	Xuewei Niu <niuxuewei.nxw@antgroup.com>
Subject: [RESEND PATCH net-next v4 1/4] vsock: Add support for SIOCINQ ioctl
Date: Mon, 30 Jun 2025 15:57:24 +0800
Message-Id: <20250630075727.210462-2-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250630075727.210462-1-niuxuewei.nxw@antgroup.com>
References: <20250630075727.210462-1-niuxuewei.nxw@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for SIOCINQ ioctl, indicating the length of bytes unread in the
socket. The value is obtained from `vsock_stream_has_data()`.

Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
---
 net/vmw_vsock/af_vsock.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 2e7a3034e965..bae6b89bb5fb 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1389,6 +1389,28 @@ static int vsock_do_ioctl(struct socket *sock, unsigned int cmd,
 	vsk = vsock_sk(sk);
 
 	switch (cmd) {
+	case SIOCINQ: {
+		ssize_t n_bytes;
+
+		if (!vsk->transport) {
+			ret = -EOPNOTSUPP;
+			break;
+		}
+
+		if (sock_type_connectible(sk->sk_type) &&
+		    sk->sk_state == TCP_LISTEN) {
+			ret = -EINVAL;
+			break;
+		}
+
+		n_bytes = vsock_stream_has_data(vsk);
+		if (n_bytes < 0) {
+			ret = n_bytes;
+			break;
+		}
+		ret = put_user(n_bytes, arg);
+		break;
+	}
 	case SIOCOUTQ: {
 		ssize_t n_bytes;
 
-- 
2.34.1


