Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587443A20F7
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 01:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbhFIXpt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 19:45:49 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:46939 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbhFIXpt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 19:45:49 -0400
Received: by mail-qt1-f201.google.com with SMTP id h20-20020ac87d540000b0290249d0777b80so2376528qtb.13
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 16:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=TSyhgxkAM87zPQDaBTB/xYIGoMe0SaHqhMUIzhv8SIc=;
        b=uAMj2WkqpBB4NV2SMlBv+LrSjvGsZgAFPCUKGdnlt4go5X6wG+GmFSR0KLzuX/PVbZ
         OAKh5QDgt5Q1OGS7e2dDtyN08kHG5SeRB4uBeduWhaq+63jDEA3KvST5qi77s/+BZUC1
         Aeowf1/E6dAnI1Gg9ibHAijPlDTQHgxpPsl9duyrM2ymFI8Xzt2caAriDboHDXm6ma3y
         e22v2GJ6swXY+gSKwr58QSKwO4FzW99NFvVYwz+Jt4CH00t+zeJy36tN6gq6enzNhYmI
         W5P6+ACmEzBZJIvnIAKvNdrfKeO2L09H6zUMSPlnLbELvLFKWoc3hiPzJjUeGyIlXLbL
         soiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=TSyhgxkAM87zPQDaBTB/xYIGoMe0SaHqhMUIzhv8SIc=;
        b=uoMiVWFYIl+fCcyilGIiecu7OB3IuD7nnmemHM4CxxCRqyDSRKi1MwaId2wBsRgK5L
         s+wrpPMLdA8dQr6LO50eiycwxhEi8EB+XrCemJisAKUqzqKaCC6pI2puwVd1eMhNv7Uh
         o8Yn4pI3/Hk+Bbgg2EhsdOg4SToBQf5TFqyIu/KxUzmGTKtNca/Kh0LK6FgX2t0wl32q
         +Dy0zMjNhFo89DsfsaNte4dmIG9gccln708EV1Al+j3UTLth7MnaqmQDG5M+qDVXUTAG
         u+ip6QqVE9aIu/DURZDqMj5cbFZO9QOvpvNIWTsQWfiq8HqBH3Xy35vJ0Fq0nAt57lKo
         pmHQ==
X-Gm-Message-State: AOAM531ex06VsbEP55Lg2rqwwgz9E6/lp3rW5w6LLnku9BfY39hPPtou
        WqKao3G5V7QZ4zkSS6AGjS6QpY3jb/M=
X-Google-Smtp-Source: ABdhPJxt9s6tpqX+2vXnuajtY+tmND2r+hdonH3bjIK3Ank/XmwdAQ1TFT/vKoKqFPLk2R1fpLNcv5HUggQ=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:8daf:e5e:ae50:4f28])
 (user=seanjc job=sendgmr) by 2002:ad4:4dcb:: with SMTP id cw11mr2243546qvb.54.1623282173808;
 Wed, 09 Jun 2021 16:42:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  9 Jun 2021 16:42:25 -0700
In-Reply-To: <20210609234235.1244004-1-seanjc@google.com>
Message-Id: <20210609234235.1244004-6-seanjc@google.com>
Mime-Version: 1.0
References: <20210609234235.1244004-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 05/15] KVM: x86: Uncondtionally skip MMU sync/TLB flush in MOV
 CR3's PGD switch
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Junaid Shahid <junaids@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Stop leveraging the MMU sync and TLB flush requested by the fast PGD
switch helper now that kvm_set_cr3() manually handles the necessary sync,
frees, and TLB flush.  This will allow dropping the params from the fast
PGD helpers since nested SVM is now the odd blob out.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e2f6d6a1ba54..02ceb1f606f4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1136,7 +1136,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 		return 1;
 
 	if (cr3 != kvm_read_cr3(vcpu))
-		kvm_mmu_new_pgd(vcpu, cr3, skip_tlb_flush, skip_tlb_flush);
+		kvm_mmu_new_pgd(vcpu, cr3, true, true);
 
 	vcpu->arch.cr3 = cr3;
 	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
-- 
2.32.0.rc1.229.g3e70b5a671-goog

