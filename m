Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8282F3AE9
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 20:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436825AbhALTnn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 14:43:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436814AbhALTnl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 14:43:41 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6839DC0617BD
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 11:42:08 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id d13so3717610wrc.13
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 11:42:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=u0kBDkZSof0LwbMWuYCOPhj4hHVMvwb36KmGU51ii7Y=;
        b=qXPm6RRC85TTK9KaSiUv157OWNC4uLnK5R55zCcddSz/OH6u6hYx1S9F76b6fwU3/m
         L5598+Ur8w96+Gg+RoiczvrXtQYRI8O+fGupwlj+IkNmOGSHUsW9Tf1BtX3kiNe71Rgx
         WKTBblBdOSXaDLvovQo/HLN7qCMsRVlCKSDg9YBktWJQB59pnUT8dN+HdiYyVYBkhQuJ
         CvKCRk6Kcw/A1SvK/Qud7BzT6mgq06tzFkvkVxffAFW66gfIBLQhmu6VrRnGc6K1j6UJ
         Fl4DWwsqoJ4iK+vFlmlYQCh6SYdu4g5kQNpVx2IBQVS/3tq45sNhLUGPnbg8Ifcy6piT
         l22A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=u0kBDkZSof0LwbMWuYCOPhj4hHVMvwb36KmGU51ii7Y=;
        b=ftuk73exa5G31oEC0A9f9XuGzLVz94h+lKwGL/4nWIyekvetGXC8chWLa8B3A17ApB
         VO1z753ffBnrqhTMf8jbyHltw658EYG9rAI8vpExfV0ZgswK1UP7NFiujyRowIwWChk8
         hcJukAwsX/IyUSD5phmJk+K/u24vfxb6ZsGu87OKa4R3I3WFDVkJfYk+eUeYgciQQKF5
         murZr8spYNJDP+5CuivyK/9QpWzNWV+yr51oet2Z1dWbKGbqOvL6xJwNFmgXHfrf0Jqz
         kIVeVQiBHedsT/JnuFWQXIm2rJgJT787TvWFfXQhR+WkehpHo0QvPE3hYpTI9JZtskX+
         KktQ==
X-Gm-Message-State: AOAM531/Mo5IL0OiJUA8iLWmbgPIpb0ATsZlAmskDeOTGvRuIkG06K55
        OJogjY6yZsfUo1r3fANmn0ItIA==
X-Google-Smtp-Source: ABdhPJwQIJTkLLUDMFNxy3mBWVt2sZtp82KzceRnAi/2Dy2UB4frEHQodHJV577V0ALRuxgqVPsWHg==
X-Received: by 2002:a5d:674b:: with SMTP id l11mr423783wrw.247.1610480527197;
        Tue, 12 Jan 2021 11:42:07 -0800 (PST)
Received: from f2.redhat.com (bzq-79-183-72-147.red.bezeqint.net. [79.183.72.147])
        by smtp.gmail.com with ESMTPSA id z63sm4885315wme.8.2021.01.12.11.42.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Jan 2021 11:42:06 -0800 (PST)
From:   Yuri Benditovich <yuri.benditovich@daynix.com>
To:     davem@davemloft.net, kuba@kernel.org, mst@redhat.com,
        jasowang@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        rdunlap@infradead.org, willemb@google.com, gustavoars@kernel.org,
        herbert@gondor.apana.org.au, steffen.klassert@secunet.com,
        nogikh@google.com, pablo@netfilter.org, decui@microsoft.com,
        cai@lca.pw, jakub@cloudflare.com, elver@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Cc:     yan@daynix.com
Subject: [RFC PATCH 4/7] tun: free bpf_program by bpf_prog_put instead of bpf_prog_destroy
Date:   Tue, 12 Jan 2021 21:41:40 +0200
Message-Id: <20210112194143.1494-5-yuri.benditovich@daynix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210112194143.1494-1-yuri.benditovich@daynix.com>
References: <20210112194143.1494-1-yuri.benditovich@daynix.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The module never creates the bpf program with bpf_prog_create
so it shouldn't free it with bpf_prog_destroy.
The program is obtained by bpf_prog_get and should be freed
by bpf_prog_put. For BPF_PROG_TYPE_SOCKET_FILTER both
methods do the same but for other program types they don't.

Signed-off-by: Yuri Benditovich <yuri.benditovich@daynix.com>
---
 drivers/net/tun.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 455f7afc1f36..18c1baf1a6c1 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2218,7 +2218,7 @@ static void tun_prog_free(struct rcu_head *rcu)
 {
 	struct tun_prog *prog = container_of(rcu, struct tun_prog, rcu);
 
-	bpf_prog_destroy(prog->prog);
+	bpf_prog_put(prog->prog);
 	kfree(prog);
 }
 
-- 
2.17.1

