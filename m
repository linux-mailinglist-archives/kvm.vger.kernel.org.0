Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B9F32DEEB
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 02:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhCEBLq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 20:11:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbhCEBLk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 20:11:40 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3CBBC061756
        for <kvm@vger.kernel.org>; Thu,  4 Mar 2021 17:11:39 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 6so687314ybq.7
        for <kvm@vger.kernel.org>; Thu, 04 Mar 2021 17:11:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=hUIu7sVBeZPHOKAKqkQEBvI6/Cyva1cSCDUAiAjyS7A=;
        b=q44fMswbrj4G/uOTNQh4DPWIDZUCkPsS8SfokrIsEzd0Sh05bH4+ukcQa7cf2hczmN
         C/MB7qk27lN9hdkKAbP9QsSqjdRsL5EsW5YiYEO9JBT5zrJPm+ncTeqILqU4mY5OAqiA
         Z1QZjc0Y4/+T/PYnn2Psx8raSFMpDjxblzN0LlSvniDL993Ft2sUPyzEn/5S8JcImmO5
         GZSHCTH425OhbVAN9Pymg0/JOSZ6f7l3ACzTUqeZvEQnGcP0mD+ONHuYhCn2Oc9plOr+
         rlUEOxEiaSA/PSvGWwNVYZWTsHxyT8ktjyCSccwvtWx9AMhzcrqMecN00hy+i3TwDTFw
         z/1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=hUIu7sVBeZPHOKAKqkQEBvI6/Cyva1cSCDUAiAjyS7A=;
        b=nwqOvpn2Fzp6ZG9hcdfT6e8r6nEqNGHUhZ+fkjF9mxgOZWQw7veMDGYJfW9mE7ikWe
         UQZxAC9IsaUoQlRX6LnR77O60FkN2H2JFq/RNlyg9uDmlb+OLxjOoPZ42WEWlgH8zXPk
         4p04v/yb+6OPsp4yDx3D7Q6O4K9TvklVDHrpueP+nR90jDq6dfXT/lGuJP4cVgPqSXuc
         UrucTIZAxQViytLMt/N/9597WUModzfoICNx0J19dSemOJA6VN7o3znPyFBpkDh1wSjl
         adi78cdEi98bpoUD4Zx+A8rpUhyU8bewkuXE8WTCqivwGrzO6wU6NS0sZIKmr3qSDplo
         idhw==
X-Gm-Message-State: AOAM5320yo6F32Xj97WvXjKw8TCKuRwJJijSBMbcj7zk4T3UNa9d2Dn1
        UqcArhp/Q/dOXcz4GGV0ON2ouAeSdHQ=
X-Google-Smtp-Source: ABdhPJxKz/X1UR84yOmR5Dk4kEeRWgaX6x8vaKIwjASikS9HDq95CD7YKEeHICZbOpRMX3tDki/GnFoYwnw=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
 (user=seanjc job=sendgmr) by 2002:a25:254a:: with SMTP id l71mr10220487ybl.125.1614906698911;
 Thu, 04 Mar 2021 17:11:38 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Mar 2021 17:10:58 -0800
In-Reply-To: <20210305011101.3597423-1-seanjc@google.com>
Message-Id: <20210305011101.3597423-15-seanjc@google.com>
Mime-Version: 1.0
References: <20210305011101.3597423-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v2 14/17] KVM: x86: Defer the MMU unload to the normal path on
 an global INVPCID
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Defer unloading the MMU after a INVPCID until the instruction emulation
has completed, i.e. until after RIP has been updated.

On VMX, this is a benign bug as VMX doesn't touch the MMU when skipping
an emulated instruction.  However, on SVM, if nrip is disabled, the
emulator is used to skip an instruction, which would lead to fireworks
if the emulator were invoked without a valid MMU.

Fixes: eb4b248e152d ("kvm: vmx: Support INVPCID in shadow paging mode")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 828de7d65074..7b0adebec1ef 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11531,7 +11531,7 @@ int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
 
 		fallthrough;
 	case INVPCID_TYPE_ALL_INCL_GLOBAL:
-		kvm_mmu_unload(vcpu);
+		kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
 		return kvm_skip_emulated_instruction(vcpu);
 
 	default:
-- 
2.30.1.766.gb4fecdf3b7-goog

