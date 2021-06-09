Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB5023A2103
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 01:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbhFIXqa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 19:46:30 -0400
Received: from mail-yb1-f202.google.com ([209.85.219.202]:39428 "EHLO
        mail-yb1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbhFIXqP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 19:46:15 -0400
Received: by mail-yb1-f202.google.com with SMTP id r5-20020a2582850000b02905381b1b616eso33580891ybk.6
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 16:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=TUFUQ1j7f0KidBMcnav4RlAHSJzXFRaH+3nAG9epvWY=;
        b=vuUcivnIlKiksHf5E7Skc7ygl7tdHKj97QOsLpmVDT2r5vAldHZDQfDZ5d0f8A0rQb
         X0+XQWIqMtmrbDQUGGwYj5zI06RpeL9gK8pf+9uSaxSTCYgpjKmarjBFk7ZNDyVRhS54
         ZtPPT0vfxfhRul9wwY/fQqDmS8rWbchKT8ZlRzmnebA1Bv97Ydt1sRVlsubNkreq91DI
         GpIP5aLsRXXr6k8mslPOd5+gLPYZ3q8XHBayPZYtit3kJu28HAovlISFF16Y10vye5se
         r4H7jniF6dFZY2IFaTnpGqxATVJ+Or2u3XKa67DkuWUQUsnmsnAQAR+jxMJC+TTo3a58
         HL9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=TUFUQ1j7f0KidBMcnav4RlAHSJzXFRaH+3nAG9epvWY=;
        b=n39jMF7sq9xIn+/dY3P3jR5tRGdVcT/wkgfRRJ6OT2OSJ+g74Cb/fmqcXPp8yd5xcm
         J6rlBImNZgDYk00HkEpPQUfmleqn2UBLKP7TeFDqa9aYI/vDkLNlD+NiCMOTN5LuXx9C
         t0UJ85ouSPGm0e7P1vNJKEVLUi/L00lvcE40FTyupPb3VU/uejYXvOUlbT6d6HyPjhzJ
         Ky8D7VeB6EFAEeLVx81OdlUO40T+PSGl8pVmrW4tod2NYWll5oLW89/wG/FSd48Q3PhR
         RnKXT9RZEO0EkUcIIzqpLCGgkABTMa2/BJqX86Yhj+681aY6tctEJyEo3I7iURAyH4j+
         rVRA==
X-Gm-Message-State: AOAM530/Hp9YeWoMLqvXhvI7lbAd2XxYjuCxxyQeaQTe7wh63azu+tGX
        GsUqrN5NtoizET5+5MQi0A0T6yaD4ss=
X-Google-Smtp-Source: ABdhPJzLzGmIn1+LCDpkY+ny6vWC8ch9yN7MkPjoJ1hLDKBLYRlvN68idXIRLbm+4yMdYAr5xOT5ljpdDNM=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:8daf:e5e:ae50:4f28])
 (user=seanjc job=sendgmr) by 2002:a25:868d:: with SMTP id z13mr3614585ybk.270.1623282185838;
 Wed, 09 Jun 2021 16:43:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  9 Jun 2021 16:42:30 -0700
In-Reply-To: <20210609234235.1244004-1-seanjc@google.com>
Message-Id: <20210609234235.1244004-11-seanjc@google.com>
Mime-Version: 1.0
References: <20210609234235.1244004-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 10/15] KVM: x86: Use KVM_REQ_TLB_FLUSH_GUEST to handle
 INVPCID(ALL) emulation
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

Use KVM_REQ_TLB_FLUSH_GUEST instead of KVM_REQ_MMU_RELOAD when emulating
INVPCID of all contexts.  In the current code, this is a glorified nop as
TLB_FLUSH_GUEST becomes kvm_mmu_unload(), same as MMU_RELOAD, when TDP
is disabled, which is the only time INVPCID is only intercepted+emulated.
In the future, reusing TLB_FLUSH_GUEST will simplify optimizing paths
that emulate a guest TLB flush, e.g. by synchronizing as needed instead
of completely unloading all MMUs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 117acfbc7ba9..9620d8936dc4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11776,7 +11776,7 @@ int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
 
 		fallthrough;
 	case INVPCID_TYPE_ALL_INCL_GLOBAL:
-		kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
+		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
 		return kvm_skip_emulated_instruction(vcpu);
 
 	default:
-- 
2.32.0.rc1.229.g3e70b5a671-goog

