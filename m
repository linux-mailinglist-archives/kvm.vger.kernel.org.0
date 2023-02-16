Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3F8C699917
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 16:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbjBPPlA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 10:41:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjBPPk6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 10:40:58 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B61D4D635;
        Thu, 16 Feb 2023 07:40:39 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id be8so2406128plb.7;
        Thu, 16 Feb 2023 07:40:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h/vXuc8fVl6VsZtcth3IfX6io45AzxO13DY0wosrCBk=;
        b=BZElVAoAYUOzZeZyaQa4goNiFad0IuQGI6yBFjGlwg744d4kdIaMb91+qd8j+1GSR9
         gTT1FNiLxZWC/xOWNRIVhOEN5kxO8+bQKgPJv5+ee15jUf+unBJL6Nz77vvzx2EqM9IB
         kMka1WwJzdWs/B7wy8oslODtcsqYqk/UoQ2cEL8OlvRZNxIlWFuJAaPsG0cCvGntzzV2
         b7R+Zn0X5YCokZ4MmXwJfIVoMYNsk6XnHHCZSlop3+LePB92EodhniL5VaZt8BpEFo8n
         SIUDwlRy/8ode1IGyYIfOAZSw5ohnMF3b2oVlgL66ZgZFv9DzMy1vIRUzcCjjeeiqFYS
         MNSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h/vXuc8fVl6VsZtcth3IfX6io45AzxO13DY0wosrCBk=;
        b=HoQ4DpBYfi1H503vr6naAMKosdAgHIr3DN/QHSfYZu/3WPnvq6VeSSZp/ci5CFrH0J
         kpDFKBIfPFJNslthaK/3Ki7KOhK6EVyYjVAo/0DgfkN8E4Lgiefxt9XZWgeb1wps3yda
         MZd+wBrQP2XJFSQW0jnno+TVZ2UsAATuBFTKYnR7fIGtydhBLr1h0wgACBeL2fyGmImH
         Ynqji7Ase0scTRBhe89NFi7L/1hJBqQvkpNVz9gepHWC4DaLU35TIwl3BepEvFCKJ9s1
         lvbM47ACGa7RsGU5UZ25laijuy26Vey0jUDJc2+PfHqXCs1o6vPW6hJiM6FyPvIROrnl
         LTwg==
X-Gm-Message-State: AO0yUKUiv+WP2XEKThcq9ts+Vfg5cOuPhbUGUiH/SJ/ZdL31AKcMzRqX
        SNYRhzZctPxCHI5ngpOlNBehiAX2m2Q=
X-Google-Smtp-Source: AK7set+wwEW3TstQ4wRN7vve+yhETr1EVdUD7bD0Ci6mMcUPcg1k7pJ1J/Gmy5aGF1/pzsPNnhCkjg==
X-Received: by 2002:a17:902:f54f:b0:199:26b1:17b3 with SMTP id h15-20020a170902f54f00b0019926b117b3mr7103627plf.28.1676562038618;
        Thu, 16 Feb 2023 07:40:38 -0800 (PST)
Received: from localhost ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id t2-20020a170902bc4200b0019a593e45f1sm1447545plz.261.2023.02.16.07.40.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Feb 2023 07:40:38 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH V3 06/14] kvm: x86/mmu: Reduce the update to the spte in FNAME(sync_spte)
Date:   Thu, 16 Feb 2023 23:41:12 +0800
Message-Id: <20230216154115.710033-7-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230216154115.710033-1-jiangshanlai@gmail.com>
References: <20230216154115.710033-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Sometimes when the guest updates its pagetable, it adds only new gptes
to it without changing any existed one, so there is no point to update
the sptes for these existed gptes.

Also when the sptes for these unchanged gptes are updated, the AD
bits are also removed since make_spte() is called with prefetch=true
which might result unneeded TLB flushing.

Just do nothing if the gpte's permissions are unchanged.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 0ea938276ba8..7db167876cd7 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1026,6 +1026,11 @@ static int FNAME(sync_spte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int
 		drop_spte(vcpu->kvm, &sp->spt[i]);
 		return 1;
 	}
+	/*
+	 * Do nothing if the permissions are unchanged.
+	 */
+	if (kvm_mmu_page_get_access(sp, i) == pte_access)
+		return 0;
 
 	/* Update the shadowed access bits in case they changed. */
 	kvm_mmu_page_set_access(sp, i, pte_access);
-- 
2.19.1.6.gb485710b

