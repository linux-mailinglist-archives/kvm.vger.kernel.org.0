Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 820175A52D6
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 19:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbiH2RLg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 13:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbiH2RL3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 13:11:29 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5602726A2
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 10:11:04 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id v65-20020a626144000000b0052f89472f54so3358407pfb.11
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 10:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=faHDPR33m1K+EQWiVoL8b03bkn/+sib5ALODSi8oxlM=;
        b=bbC9oDe56U6cVXMzD0t1tIcAdVbDbwF0t0J9c/QscUe1+D90/CWAKgmVJlY4xDAu31
         rypdHiqiu8s00EQ2rOWyf4j+A1awKy+g6gu6no4h8EjWqEvGZKNgQVJjR8jmi93eD0Cb
         lSCIqchtAncZO7jSOBYVrd+AGLqNl5RT1R9ewuTqcG8KqZ6ckFe0qlfsVrQAsyPBLxWj
         RS09JyIkaXukyA7Q9RBUiT6Ratwn9XBulmX/q7fS2Bp2LKFyS9mCeiLJSxZoxJ37EaDE
         Yxb26iwGmopetj03VVjFJLtcouz4o5VOz2x8nDoDsjiCRuJLNYaeJ04uC/oycVHF9Qbp
         7Xkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=faHDPR33m1K+EQWiVoL8b03bkn/+sib5ALODSi8oxlM=;
        b=XHuZcWkMS/Rcp3oDk8KLIli3SeMM2a9h5E4UjcQuKXnwTPCxgECFQB7uik348oKF1L
         s8IZTx0gWtRryjAGtdqGYznIT8y8c82nbBUwn+bbdqFuIIsxNk3+HQK/1aPew9axZVAk
         /CDYepXmBh33sdZw+we2Pmw9piJgWqIsnXigx9Wv/BRvrLfE60p3jVWacxORPHBCh4A3
         jjqY+J4OY3ONm9e+8eit2r7MeePjSi/d140UX+hlM0xuFtbu00Ma6LEw4JQqO8OhKGzk
         tl4dDTdQW1uFGrG6s2pHxCjE4wqWir1cPivFGCmY+16HasMrOQZytS62CdqhOZ8Kg7aV
         48EA==
X-Gm-Message-State: ACgBeo3zrXyOUnGQw9latmkPmRiveWomnhhg26HMuEW+qZLRltYsO+6p
        lUHMGw+TWGCBTNSxZWM8eKDf9VfszqVCnK75zQh71dH/P1XEKi+sodXwdTXaTvXwVu0DMtkS+2G
        pqZP+CqqVDTux7VE1dw2OClGPThIxwZRRQa9NmvPs5pEJITY2CJjyNw0vgg==
X-Google-Smtp-Source: AA6agR5+zI82TokFysYMOruQ5Cg3tQXZMltp+qDYB8UGqRTHvOXBtBSX7aMB9/yGsgQli3WPYP7aQq0kTw0=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:cddb:77a7:c55e:a7a2])
 (user=pgonda job=sendgmr) by 2002:a17:90b:1e53:b0:1fb:3aba:372e with SMTP id
 pi19-20020a17090b1e5300b001fb3aba372emr19808530pjb.34.1661793063298; Mon, 29
 Aug 2022 10:11:03 -0700 (PDT)
Date:   Mon, 29 Aug 2022 10:10:20 -0700
In-Reply-To: <20220829171021.701198-1-pgonda@google.com>
Message-Id: <20220829171021.701198-8-pgonda@google.com>
Mime-Version: 1.0
References: <20220829171021.701198-1-pgonda@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Subject: [V4 7/8] KVM: selftests: Update ucall pool to allocate from shared memory
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, marcorr@google.com,
        seanjc@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        andrew.jones@linux.dev, Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update the per VM ucall_header allocation from vm_vaddr_alloc() to
vm_vaddr_alloc_shared(). This allows encrypted guests to use ucall pools
by placing their shared ucall structures in unencrypted (shared) memory.
No behavior change for non encrypted guests.

Signed-off-by: Peter Gonda <pgonda@google.com>
---
 tools/testing/selftests/kvm/lib/ucall_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index cc79d497b6b4..8e164c47e2fb 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -22,7 +22,7 @@ void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 	vm_vaddr_t vaddr;
 	int i;
 
-	vaddr = vm_vaddr_alloc(vm, sizeof(*hdr), KVM_UTIL_MIN_VADDR);
+	vaddr = vm_vaddr_alloc_shared(vm, sizeof(*hdr), KVM_UTIL_MIN_VADDR);
 	hdr = (struct ucall_header *)addr_gva2hva(vm, vaddr);
 	memset(hdr, 0, sizeof(*hdr));
 
-- 
2.37.2.672.g94769d06f0-goog

