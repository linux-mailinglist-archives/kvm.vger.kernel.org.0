Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9EC36899D
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 02:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239964AbhDWAHX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 20:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239953AbhDWAHV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 20:07:21 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5378C061574
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 17:06:45 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id n18-20020a05620a1532b02902e4141f2fd8so6534900qkk.0
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 17:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=YGll+NjmGWhramX5dXO7MOZlqzk3DnLvXUr2tOwm9cI=;
        b=VmqDeC6LHr1iBA3uHHzTF19eQT9ZPzL0WCJWZ/KSl4CzR3JbDocs1AIcGKdBZWxaCg
         scgSm8jtEiGjaYmHC9MgKAR36RUq5/5Y+hk+wbPc6vL+yAEfY0DeW8KPgACsuiscJZJh
         cE5nBAN3WxqTf2gin9fqtvJo+CCQWItX2fyJuYxPLaurFY2raJF3j/93B2C4WhyD7hAD
         iFJiKMc79SVw2BSpksDunA4aM2Sz9xXbl34vBbLM8qFaVL6V47RS78yUX9+6GIyf/1H8
         3fpjHTXHQN+nmRStXRQ/NixqCPC4yy8psW7idFr14GoRpoqjwUrQtKiYecHmY5lbN2rT
         MFcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=YGll+NjmGWhramX5dXO7MOZlqzk3DnLvXUr2tOwm9cI=;
        b=fdL6Wb07QWfECCD+YmZ4qJIslJD3Yew5+ouvAceCvDuJ911E5TDVhUWU1iIRKkPQpx
         NuJ4RABmtzomW3NR2uGtrm8uc/MgJXMX5cmjtqYFsQT/hoVDE++N7IaZpqTtkKXUeJnA
         chvHZ2WeWi+ymKQkD9oWZAe8zO91RCL0OBvvebVh85ZuD/kO6GAowAypJoVUdtT64tV9
         LzK+hoG7uPlG3lYpmnsaYIi9QEu2WewWB9Bt4rUvAYdyFN2CZ7LLf0vfPzGmMX0XYfZ8
         2M7muytkA+5IbDu4e8UUCmQ0mxsFgtjJeU5FIBf5hFPmky/zKvlGKBe15tNJHUluRV9o
         7gDw==
X-Gm-Message-State: AOAM530o3zcwx5+9fsHwZEeePjj5228BMt0Z6QN7XWR7ky3L8nuxepIA
        Z4RgAGY0ZjLSb41X9v4jaerozn1RqWA=
X-Google-Smtp-Source: ABdhPJyOWctz83RlNz3iwtG+qeHndbWdhpCEfTLgpALU6PWqDeoLl2Hzmnt6/bS04IMpCFE450LPAyUq+h4=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:a05:6214:246a:: with SMTP id
 im10mr1410628qvb.7.1619136404945; Thu, 22 Apr 2021 17:06:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 22 Apr 2021 17:06:35 -0700
In-Reply-To: <20210423000637.3692951-1-seanjc@google.com>
Message-Id: <20210423000637.3692951-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210423000637.3692951-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 2/4] KVM: nSVM: Drop pointless pdptrs_changed() check on
 nested transition
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the "PDPTRs unchanged" check to skip PDPTR loading during nested
SVM transitions as it's not at all an optimization.  Reading guest memory
to get the PDPTRs isn't magically cheaper by doing it in pdptrs_changed(),
and if the PDPTRs did change, KVM will end up doing the read twice.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 540d43ba2cf4..9cc95895866a 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -391,10 +391,8 @@ static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 		return -EINVAL;
 
 	if (!nested_npt && is_pae_paging(vcpu) &&
-	    (cr3 != kvm_read_cr3(vcpu) || pdptrs_changed(vcpu))) {
-		if (CC(!load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3)))
-			return -EINVAL;
-	}
+	    CC(!load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3)))
+		return -EINVAL;
 
 	/*
 	 * TODO: optimize unconditional TLB flush/MMU sync here and in
-- 
2.31.1.498.g6c1eba8ee3d-goog

