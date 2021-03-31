Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE543508E3
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 23:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232903AbhCaVJe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 17:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232787AbhCaVJO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Mar 2021 17:09:14 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA749C061574
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 14:09:13 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id p24so2104141pff.8
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 14:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+bpx1iaqeW64f43Q16KGFU1OSLWhWp6bSNi8pmvu8l0=;
        b=jyJf6Erx3Vr6KJglW79Mt9jpWyBfKg1VDB6pFb+pByemXvErG6JRy0FUoOJxqxgitM
         10ZFCQFLqwwLahmtcTRSEG8U5PYqEgLzB6vvamJL0TgokxBg77NuafD9FmSLUGAWlR2l
         TO1feqWom5WBJZ+PB0Jmc10dFZTo892Ejo3/q+DFMrYEMN3Z6/Zdy70xY80/PkSy5Y1i
         rfytyXljgwnj7OpY8WgeZW0p7ytlGlgDAOrcKAjZRLPVrnq/fQIfoWK/9JkQs0F4WJgh
         8E79NeK4u9cKNIpcodpfc7hxvLn3royzuTgDWLm2XMza+HJBfLwc/62q0MXM2Pka3rtc
         Sz3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+bpx1iaqeW64f43Q16KGFU1OSLWhWp6bSNi8pmvu8l0=;
        b=AtQVxdrwvyvTsXVi0Nf+FisK62dMLxdxmD+dZs0jrypjZgkpjt0l3ZgaPapAu84bnC
         phnQUahiNwglhQYscTecbWy8FiBZGCJvjO/SAq2KGzL2Xb9FlFCXEw5X0hZFB15wv0PH
         3PGBlUfvtuS993iJ6PdRYfZuYyyXcvzHhoWZzUKDdWt88x9HRZ0E+eV7ssguD9TL0cRG
         Vv/mPWsuxVjCcx0HdS7FIBYoC5+KpizLOHyC8D/E7KEcvnvLml/3EQWXhT5b3ezCQci3
         cfeRtCS8qIDLGREEhmZbQJQ0VF43b9shSw724anYZe54JxiRDEhm9NHt5VYjCAUnFvDi
         HKDQ==
X-Gm-Message-State: AOAM532sd0BgtjT9OGkWYrehxffXvUgM2MMxTcnFV0k/yw0VGobbfabD
        UuLZPeF43xGFJWBA6X/sNFNSB5P5Nkqw
X-Google-Smtp-Source: ABdhPJwkN2GKx1FcEh1BYC9eoqZXYP0omsgJCtYeXf9CgVLacsMfVHLK0cd5Q4NDJf1CNg+xFmGUQnWibMfl
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:8026:6888:3d55:3842])
 (user=bgardon job=sendgmr) by 2002:a62:8811:0:b029:1ef:2105:3594 with SMTP id
 l17-20020a6288110000b02901ef21053594mr4789197pfd.70.1617224953241; Wed, 31
 Mar 2021 14:09:13 -0700 (PDT)
Date:   Wed, 31 Mar 2021 14:08:33 -0700
In-Reply-To: <20210331210841.3996155-1-bgardon@google.com>
Message-Id: <20210331210841.3996155-6-bgardon@google.com>
Mime-Version: 1.0
References: <20210331210841.3996155-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 05/13] KVM: x86/mmu: comment for_each_tdp_mmu_root requires
 MMU write lock
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, iterating over the list of TDP MMU roots can only be done
under the MMU write lock, but that will change in future commits. Add a
defensive comment to for_each_tdp_mmu_root noting that it must only be
used under the MMU lock in write mode. That function will not be
modified to work under the lock in read mode.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 368091adab09..365fa9f2f856 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -103,6 +103,7 @@ static inline struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 	     tdp_mmu_next_root_valid(_kvm, _root);			\
 	     _root = tdp_mmu_next_root(_kvm, _root))
 
+/* Only safe under the MMU lock in write mode, without yielding. */
 #define for_each_tdp_mmu_root(_kvm, _root)				\
 	list_for_each_entry(_root, &_kvm->arch.tdp_mmu_roots, link)
 
-- 
2.31.0.291.g576ba9dcdaf-goog

