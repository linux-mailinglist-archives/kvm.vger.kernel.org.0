Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8BE9C92F
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 08:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729581AbfHZGVY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 02:21:24 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33000 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbfHZGVX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 02:21:23 -0400
Received: by mail-pl1-f193.google.com with SMTP id go14so9487000plb.0;
        Sun, 25 Aug 2019 23:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2d6Xg7KS3QkarhAnTKzOio/9Hq5e+mOo/h5l0VKXGxw=;
        b=MySke9tNcUNjIrwwzxJfkF6sdhh+M5BgPa5ydSU+0kQLxUZjU8L6/5bJfbTpd+T866
         SxJkyOjS70uV62qM1C9X71AbV4PqA3YvZrXyMmyOBte6jr651F75D5RjBcjTjnjWTCdO
         zBjisAWOrKGA5J2ymZkqgQ0wQ6TTabDhnsbSx4BovWD00jGnPjNmZrGcuId/t1W2Mvmb
         UyiOhXO9WpwiOraKcjsM0EO9ClQsgm1Bdb3okDgdst2Zr0utKH3oGYesHCDG22WU3+Yr
         2Lhoz3Bh8tgoMQN4sEsCVCIu3fH8m3zpq+P+hTZ/XFAcz8wvD++/q3zJx1LRen85Ap7p
         wm8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2d6Xg7KS3QkarhAnTKzOio/9Hq5e+mOo/h5l0VKXGxw=;
        b=nW/DuchDNMzdVTrgvIprqTCLsaCL1RJsF1Ocrk3oE32nDxcG/b6AEq0Kebu42l6/n1
         XvX6RDraPSAvPb3ANz/nncJTd50AXfMPjU5cBtpZjhyWexczbYYWHv7UUPmdWfksdAL0
         xj56pLQxvKWQvfMdaOW4IAiQqBdT+4namhut6CUPAXydE2qF9rC4wKWfl5W+g8S7eVdo
         Tc5XnTAP63Oj5XdJwn4a/M38HmzCSyCADkV1H3ZhOZBEeDi/6jIqrSoD5kVhEJ4iyd96
         GgEs9maVdoNbs3+EAjFv9RtEPvgckYS+LU5UEWSv/DP9wX8eoDg59aYb2pWtx+2FlyZZ
         hJGA==
X-Gm-Message-State: APjAAAWOxmIyljRGi0KsKnIQ8Rty8V95hDd+dAew5M0pNAkS86ztRMzn
        SqRdB24DKrFdfP8/3e+Qg7UtrMQteHQ=
X-Google-Smtp-Source: APXvYqz+tpxbL03yBO3V/1VRszrYfoz7FK9FOUGm9jglItpanxURzyx2r4j+0lDpa6neMCPKeH7RMA==
X-Received: by 2002:a17:902:e592:: with SMTP id cl18mr17259642plb.291.1566800483049;
        Sun, 25 Aug 2019 23:21:23 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id f7sm10030353pfd.43.2019.08.25.23.21.21
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 25 Aug 2019 23:21:22 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     paulus@ozlabs.org, kvm@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: [PATCH 03/23] KVM: PPC: Book3S HV: Nested: Don't allow hash guests to run nested guests
Date:   Mon, 26 Aug 2019 16:20:49 +1000
Message-Id: <20190826062109.7573-4-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20190826062109.7573-1-sjitindarsingh@gmail.com>
References: <20190826062109.7573-1-sjitindarsingh@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't allow hpt (hash page table) guests to act as guest hypervisors and
thus be able to run nested guests. There is currently no support for
this, if a nested guest is to be run it must be run at the lowest level.
Explicitly disallow hash guests from enabling the nested kvm-hv capability
at the hypervisor level.

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index cde3f5a4b3e4..ce960301bfaa 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -5336,8 +5336,12 @@ static int kvmhv_enable_nested(struct kvm *kvm)
 		return -ENODEV;
 
 	/* kvm == NULL means the caller is testing if the capability exists */
-	if (kvm)
+	if (kvm) {
+		/* Only radix guests can act as nested hv and thus run guests */
+		if (!kvm_is_radix(kvm))
+			return -1;
 		kvm->arch.nested_enable = true;
+	}
 	return 0;
 }
 
-- 
2.13.6

