Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91BED3A20FA
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 01:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbhFIXp5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 19:45:57 -0400
Received: from mail-qt1-f202.google.com ([209.85.160.202]:43552 "EHLO
        mail-qt1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbhFIXpz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 19:45:55 -0400
Received: by mail-qt1-f202.google.com with SMTP id z20-20020ac845540000b0290248cbf50215so4901907qtn.10
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 16:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=LN0JaAN3T5+nq6SFVxphdupyoLpcoEoPHxPPBl9bv9U=;
        b=Tla+YY0L+7EOHZs/dedTljFCSPp26cpMfl30zgXQ+OLUmSM/PUJMr+izjPlZ5UJBMu
         ii9xWBIsKqjss/9j8fA5GoeSocniFYkln61UJap8MPcxp8XXdZNYdjT+DktrczynrTXk
         4HvgjORzpc4CzCRf9zsyU+RFcAUMMJ+8LxkVAxs+a6CgiwkBddTyvEvlApbvbFofThvp
         rrt4mM3//Ck/2FGMMZAQwtCbbly+YjzzPuIH3ZlPjGVcZdM4CpmpO/ampQMKhX9XmR70
         WQJyu/ntDcu4dKxhl0wNDj2ePL+0rNI1SIf02fEGC8Z+Zp/DNuvjBwXhnAk4lKc+eLDz
         zpvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=LN0JaAN3T5+nq6SFVxphdupyoLpcoEoPHxPPBl9bv9U=;
        b=Z765bhY0x+ZcrHg3DuIjuL3Zvf3lWqIf3V8i5Tnq4JV+2jlGLKFiW1C4Mk31tMZRro
         h0tZiLm3oj6FKg4KxRCRRyJHwGbdW3Bet//h8wg9deArEOG+lCc6TjNXcVe4uirpvxV3
         uAZBSIhJOieYmP9ALEjDf1MWlTEYTk9Tu6dBuI6PuHk5YFQunGrq/tF/ktgYp7PaK2lq
         JAgBuviu9uvjiFp+SG6kZCipEF1puHFLxeMcdxXLOhEd4Y2sepKwAe8OByTmFQ0YB/AQ
         tmtWqvUa5Vcrg45cI+ms4zHfx09mUI+o6O6huRqgyXzEul+5MSnI/UyVCwCfkd/a/N1G
         b3PA==
X-Gm-Message-State: AOAM533r4SJqkCtVxyHaP7VZLPE1XGIoRwRDeUFnsaHXLFUNyICPOEq5
        a0BzwFdRl+RyhHaHQ4Tb0di9RO0xNhk=
X-Google-Smtp-Source: ABdhPJy1wdnajK8auCAaIPjf4hKWJO3bnez97krGV/zeyw/JEJzMfsrA/ZOHXieVRy2GU1OrEiucYXPEmVQ=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:8daf:e5e:ae50:4f28])
 (user=seanjc job=sendgmr) by 2002:ad4:4c0c:: with SMTP id bz12mr2346916qvb.21.1623282166720;
 Wed, 09 Jun 2021 16:42:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  9 Jun 2021 16:42:22 -0700
In-Reply-To: <20210609234235.1244004-1-seanjc@google.com>
Message-Id: <20210609234235.1244004-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210609234235.1244004-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 02/15] KVM: nVMX: Ensure 64-bit shift when checking VMFUNC bitmap
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

Use BIT_ULL() instead of an open-coded shift to check whether or not a
function is enabled in L1's VMFUNC bitmap.  This is a benign bug as KVM
supports only bit 0, and will fail VM-Enter if any other bits are set,
i.e. bits 63:32 are guaranteed to be zero.

Note, "function" is bounded by hardware as VMFUNC will #UD before taking
a VM-Exit if the function is greater than 63.

Before:
  if ((vmcs12->vm_function_control & (1 << function)) == 0)
   0x000000000001a916 <+118>:	mov    $0x1,%eax
   0x000000000001a91b <+123>:	shl    %cl,%eax
   0x000000000001a91d <+125>:	cltq
   0x000000000001a91f <+127>:	and    0x128(%rbx),%rax

After:
  if (!(vmcs12->vm_function_control & BIT_ULL(function & 63)))
   0x000000000001a955 <+117>:	mov    0x128(%rbx),%rdx
   0x000000000001a95c <+124>:	bt     %rax,%rdx

Fixes: 27c42a1bb867 ("KVM: nVMX: Enable VMFUNC for the L1 hypervisor")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1c243758dd2c..c3624109ffeb 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5540,7 +5540,7 @@ static int handle_vmfunc(struct kvm_vcpu *vcpu)
 	}
 
 	vmcs12 = get_vmcs12(vcpu);
-	if ((vmcs12->vm_function_control & (1 << function)) == 0)
+	if (!(vmcs12->vm_function_control & BIT_ULL(function)))
 		goto fail;
 
 	switch (function) {
-- 
2.32.0.rc1.229.g3e70b5a671-goog

