Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 770EA15F147
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 19:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389159AbgBNSAv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 13:00:51 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35552 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387735AbgBNP4V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 10:56:21 -0500
Received: by mail-qt1-f194.google.com with SMTP id n17so7265534qtv.2
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2020 07:56:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=6jSjfGtvFx4do4NAPL9uHx8+n+x5lxROSkL2jkHQC4Y=;
        b=ovPYHpFItMqqLAWAG5S/QB+rnCBig0/hdfLXqhp+WoudHfMZv8ItTZEURE/T2JN/fG
         hHlcOAIA6218GMm8dOC2tX+c6bzmMfE/SCjST9/1qO+PvQogsKtLhwgPlvrdl+4i2OVp
         BSIo5nZaGtE3HuqY9vBT9rWd+INyAaitqr5Itn9gVkjQ94r/bJ9+I9rGK1cpDJ/0sfq+
         IuxNGkagkPX5nxsu0eN3Aoh2LHQaBA1/Ds3xFYqRMQjs5QmLCZd2Om9GbVTvk2ZJrl4U
         1nJHOAQz+8VSrN0npIApaha+jOG5/VVTiYLsoZQYOA63vasiwiFWXZieLBmcvPvZThio
         JyOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6jSjfGtvFx4do4NAPL9uHx8+n+x5lxROSkL2jkHQC4Y=;
        b=S/HTLNhk/mlBJKoD4Q6RfGE7kINqA0xdJinx2OYJByd+oZmdyS300ZjmhL9Fd95wxP
         Z7hGnSHjAiU8640y1clVatogBsqrlPrNtGy1I1heJ+JUSyNFomed3RjdB2Y3B8tSy2tU
         K/zew6cALRGrzljcescFoebAKzKCOJ/A/k86225qQYF10hsGztnMF5CNLKRLAbQq+Abn
         VQiaBcu7eDK+CY5pToqRHqNjuL48ffUk5GrBUiUF/huF0rvT9HChcLLdM137sS3Ti4Ke
         Pem23WvPC/D/PoYX0xVj/bu4bFkNNtwbBmYYaECU5I6dL/BYqOhgF1JBuaP6GWbZhaD8
         3F/g==
X-Gm-Message-State: APjAAAVuyzKlKdxu4i2G8rr6mFi3oc2RjQqkz1KowJWOW+dGXR/FdYZY
        34RKpygZgcp8Bx005/FsulwoSA==
X-Google-Smtp-Source: APXvYqwj23CiFbMj1wbnSnflDYnJuNbdcFJZX73WW4OaMAYoszvD8eOpzafx1TSsWDYcMrkV/LvINg==
X-Received: by 2002:ac8:33f8:: with SMTP id d53mr3067141qtb.86.1581695780463;
        Fri, 14 Feb 2020 07:56:20 -0800 (PST)
Received: from qcai.nay.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id w9sm3449497qka.71.2020.02.14.07.56.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Feb 2020 07:56:20 -0800 (PST)
From:   Qian Cai <cai@lca.pw>
To:     pbonzini@redhat.com
Cc:     sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qian Cai <cai@lca.pw>
Subject: [PATCH] kvm/emulate: fix a -Werror=cast-function-type
Date:   Fri, 14 Feb 2020 10:56:08 -0500
Message-Id: <1581695768-6123-1-git-send-email-cai@lca.pw>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

arch/x86/kvm/emulate.c: In function 'x86_emulate_insn':
arch/x86/kvm/emulate.c:5686:22: error: cast between incompatible
function types from 'int (*)(struct x86_emulate_ctxt *)' to 'void
(*)(struct fastop *)' [-Werror=cast-function-type]
    rc = fastop(ctxt, (fastop_t)ctxt->execute);

Fixes: 3009afc6e39e ("KVM: x86: Use a typedef for fastop functions")
Signed-off-by: Qian Cai <cai@lca.pw>
---
 arch/x86/kvm/emulate.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index ddbc61984227..17ae820cf59d 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -5682,10 +5682,12 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 		ctxt->eflags &= ~X86_EFLAGS_RF;
 
 	if (ctxt->execute) {
-		if (ctxt->d & Fastop)
-			rc = fastop(ctxt, (fastop_t)ctxt->execute);
-		else
+		if (ctxt->d & Fastop) {
+			fastop_t fop = (void *)ctxt->execute;
+			rc = fastop(ctxt, fop);
+		} else {
 			rc = ctxt->execute(ctxt);
+		}
 		if (rc != X86EMUL_CONTINUE)
 			goto done;
 		goto writeback;
-- 
1.8.3.1

