Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9279752EE4F
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 16:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350387AbiETOh4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 10:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350374AbiETOhx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 10:37:53 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D7117067F;
        Fri, 20 May 2022 07:37:52 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id i40so11049873eda.7;
        Fri, 20 May 2022 07:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SNXNCKWjPv4BzE2CH3tp7uy8+YvTS4PKnxAxp9Lue+o=;
        b=SSe/chN/e6h9trSK8Krz+duBeXvMclM1sRT+Iru9saimzJrMhlUPrvfU/ttXKXagY9
         hgeeYUyv1Ogtfg5+mjSvEEQps40cP+a3+rXBZn25LpxrjEtfVUU1n6w5o2rVK8ZemKlC
         WYI7APijNeAbks77ldOUbvOfWFwgDSs8jph3JM0gVKGX+APDgaNaYH1TXhg4ov6B9eU7
         oNS43AMy2iBAYP0l5VtQxk0XLYm1o1aLfXeonUSYGm5VqQ7GIuitl4G1Z54nx4iTzh5u
         qtZSwC/OtMINfebalIfiDeHPQCqdmo6j8k84lGwwEjMlYRT05gTlDlZEfDgY76owJUnH
         MUVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SNXNCKWjPv4BzE2CH3tp7uy8+YvTS4PKnxAxp9Lue+o=;
        b=YGCKiVz01HN/bkCZCgJFa0HkXCRbnqPxYi68aDzRQr2IFe2zYy0X0Qk72droR+F6Tn
         tT/uk9cFDdsestb5Dd0NrxKJBL9CxB9Tj0G1Mun66eHhmRaTn4vnyjhYkplRAYwqllvc
         0c73L29z7527UWOPkTqdZy2dSfBubkOyqFYNMfsUEM/Ou1sypGRPBxbtWUtbsPq8/dhm
         RXreXU6b1t8XN6cHFFjSPkkRat8lvawb/y0xqXAxqIZ4KJ4DzLjNAdUKGwoJQn/FxNZB
         la+jm67GRn3biKlGWhgLqNWLFpjVFZbrxMMJkVdUGoFlAJWqhmXFqDaNOoSNrP+Vq66N
         hx6w==
X-Gm-Message-State: AOAM530EIKLkACyMwe81Fs0SEPcszmbcnXmhx4/e0sHZ3AAvTqppgPBu
        svtQBRuXCKIkCzSDt2RB5tD+yGCtA+c=
X-Google-Smtp-Source: ABdhPJx6mzqfScSh0Z9xjgretxGpNUY4ve2pR1Vl4SldM+M92rxx0N+4cPlFRlvzN4BY89Po6tGdtw==
X-Received: by 2002:aa7:c506:0:b0:42a:b067:cbe7 with SMTP id o6-20020aa7c506000000b0042ab067cbe7mr11261756edq.4.1653057470979;
        Fri, 20 May 2022 07:37:50 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id cf5-20020a170906b2c500b006feb8cebbbfsm2473ejb.6.2022.05.20.07.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 07:37:50 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2] KVM: VMX: Use try_cmpxchg64 in pi_try_set_control
Date:   Fri, 20 May 2022 16:37:37 +0200
Message-Id: <20220520143737.62513-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use try_cmpxchg64 instead of cmpxchg64 (*ptr, old, new) != old
in pi_try_set_control.  cmpxchg returns success in ZF flag, so this
change saves a compare after cmpxchg (and related move instruction
in front of cmpxchg):

  b9:   88 44 24 60             mov    %al,0x60(%rsp)
  bd:   48 89 c8                mov    %rcx,%rax
  c0:   c6 44 24 62 f2          movb   $0xf2,0x62(%rsp)
  c5:   48 8b 74 24 60          mov    0x60(%rsp),%rsi
  ca:   f0 49 0f b1 34 24       lock cmpxchg %rsi,(%r12)
  d0:   48 39 c1                cmp    %rax,%rcx
  d3:   75 cf                   jne    a4 <vmx_vcpu_pi_load+0xa4>

patched:

  c1:   88 54 24 60             mov    %dl,0x60(%rsp)
  c5:   c6 44 24 62 f2          movb   $0xf2,0x62(%rsp)
  ca:   48 8b 54 24 60          mov    0x60(%rsp),%rdx
  cf:   f0 48 0f b1 13          lock cmpxchg %rdx,(%rbx)
  d4:   75 d5                   jne    ab <vmx_vcpu_pi_load+0xab>

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Joerg Roedel <joro@8bytes.org>
---
v2:
- use address of local variable &old

The patch is agains tip tree.
---
 arch/x86/kvm/vmx/posted_intr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 3834bb30ce54..259315ea5e44 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -42,7 +42,7 @@ static int pi_try_set_control(struct pi_desc *pi_desc, u64 old, u64 new)
 	 * update must be retried with a fresh snapshot an ON change causes
 	 * the cmpxchg to fail.
 	 */
-	if (cmpxchg64(&pi_desc->control, old, new) != old)
+	if (!try_cmpxchg64(&pi_desc->control, &old, new))
 		return -EBUSY;
 
 	return 0;
-- 
2.35.3

