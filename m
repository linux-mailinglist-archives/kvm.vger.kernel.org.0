Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA703A20F1
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 01:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbhFIXp1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 19:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbhFIXpR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 19:45:17 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038BEC0617A6
        for <kvm@vger.kernel.org>; Wed,  9 Jun 2021 16:43:09 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id f17-20020ac87f110000b02901e117339ea7so12478015qtk.16
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 16:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=fb8S+8E9GBSwAg++L6gtt8Nn1MrMQ2oNQg5Qhp48JOI=;
        b=Ree6kn2WyBZamEhL9hgHMOjzUSQOjH+eIYk+p+gjbUP0mikIvxbVSfgE+0Z4N0XyX3
         87WO6x8RsY9ZBtZWyDeL5/88a7ayzvS+7KY4JTduCKwezoHGwdZgZ0pU0rHqTqZv+OKi
         UIIc+DG/Q1BEE9lE0BXj0eZb2OgKg8dPMbxDBHVGuJ2KSX0t8560Ddrc7UWcbDMNF7EJ
         ms3Jy09sEfyNNhdjPYTyywwtkofXcpIlrWoW4axvzniVFb6EjNwQ0D3Oc7bek0wTkJdD
         r/ix5fhoF4SKxEHoyVn3zdEzmMna9bRXGApvBJkg/G9FzSC9x795tDrrM3DtrJKIYi+O
         lq5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=fb8S+8E9GBSwAg++L6gtt8Nn1MrMQ2oNQg5Qhp48JOI=;
        b=pksTkLWgSnZdQY8qX0ymMI+xlfXT0Dgyi05sY1ZhHOfKrnM9nxg27gitTw0tQ0Tk+y
         cqUdPF2egUBhvT6zGv6aor1Dby0X+1eg+mTILOcr0V5yEVtfND1eIuxuGvx5rcB11v8w
         an38F9SjDJUHwORSXgaFId8zrEhZSvHyu8Exk28CeXheDfS2vnGZ/L9udc++dLqnxSrW
         KjyBFRIoBpxuqF8mFiARGhHQwiJCSDWuHUSgTjicWRy5HKD6iKL8JiE3BBcSx9XEwvkk
         cpykZVPv+NMoZnjJOYqFLMAYzEHdrhXrI8IJ8FP4hmCTWliJ0D7vgUkmV42gxf+N7lAB
         iYKA==
X-Gm-Message-State: AOAM533eizFSeA2hHSaUuPC5kRlvkhzlTjMfZiIMQiB8ZMQMnlL1eTcs
        h7CkK5LEVocjuvUIoYYobPSXH04vYLQ=
X-Google-Smtp-Source: ABdhPJzhbO4/J4uB9VkFdBImQ4cEiICxjk+UoMkmyRx/RSskI7a7LuITuCfxoTsTCavmVeYe2LqcU+RZ83s=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:8daf:e5e:ae50:4f28])
 (user=seanjc job=sendgmr) by 2002:ad4:50c6:: with SMTP id e6mr2458346qvq.6.1623282188110;
 Wed, 09 Jun 2021 16:43:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  9 Jun 2021 16:42:31 -0700
In-Reply-To: <20210609234235.1244004-1-seanjc@google.com>
Message-Id: <20210609234235.1244004-12-seanjc@google.com>
Mime-Version: 1.0
References: <20210609234235.1244004-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 11/15] KVM: nVMX: Use fast PGD switch when emulating VMFUNC[EPTP_SWITCH]
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

Use __kvm_mmu_new_pgd() via kvm_init_shadow_ept_mmu() to emulate
VMFUNC[EPTP_SWITCH] instead of nuking all MMUs.  EPTP_SWITCH is the EPT
equivalent of MOV to CR3, i.e. is a perfect fit for the common PGD flow,
the only hiccup being that A/D enabling is buried in the EPTP.  But, that
is easily handled by bouncing through kvm_init_shadow_ept_mmu().

Explicitly request a guest TLB flush if VPID is disabled.  Per Intel's
SDM, if VPID is disabled, "an EPTP-switching VMFUNC invalidates combined
mappings associated with VPID 0000H (for all PCIDs and for all EP4TA
values, where EP4TA is the value of bits 51:12 of EPTP)".

Note, this technically is a very bizarre bug fix of sorts if L2 is using
PAE paging, as avoiding the full MMU reload also avoids incorrectly
reloading the PDPTEs, which the SDM explicitly states are not touched:

  If PAE paging is in use, an EPTP-switching VMFUNC does not load the
  four page-directory-pointer-table entries (PDPTEs) from the
  guest-physical address in CR3. The logical processor continues to use
  the four guest-physical addresses already present in the PDPTEs. The
  guest-physical address in CR3 is not translated through the new EPT
  paging structures (until some operation that would load the PDPTEs).

In addition to optimizing L2's MMU shenanigans, avoiding the full reload
also optimizes L1's MMU as KVM_REQ_MMU_RELOAD wipes out all roots in both
root_mmu and guest_mmu.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2a881afc1fd0..4b8f5dca49ac 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -346,16 +346,21 @@ static void nested_ept_inject_page_fault(struct kvm_vcpu *vcpu,
 	vmcs12->guest_physical_address = fault->address;
 }
 
+static void nested_ept_new_eptp(struct kvm_vcpu *vcpu)
+{
+	kvm_init_shadow_ept_mmu(vcpu,
+				to_vmx(vcpu)->nested.msrs.ept_caps &
+				VMX_EPT_EXECUTE_ONLY_BIT,
+				nested_ept_ad_enabled(vcpu),
+				nested_ept_get_eptp(vcpu));
+}
+
 static void nested_ept_init_mmu_context(struct kvm_vcpu *vcpu)
 {
 	WARN_ON(mmu_is_nested(vcpu));
 
 	vcpu->arch.mmu = &vcpu->arch.guest_mmu;
-	kvm_init_shadow_ept_mmu(vcpu,
-			to_vmx(vcpu)->nested.msrs.ept_caps &
-			VMX_EPT_EXECUTE_ONLY_BIT,
-			nested_ept_ad_enabled(vcpu),
-			nested_ept_get_eptp(vcpu));
+	nested_ept_new_eptp(vcpu);
 	vcpu->arch.mmu->get_guest_pgd     = nested_ept_get_eptp;
 	vcpu->arch.mmu->inject_page_fault = nested_ept_inject_page_fault;
 	vcpu->arch.mmu->get_pdptr         = kvm_pdptr_read;
@@ -5463,8 +5468,10 @@ static int nested_vmx_eptp_switching(struct kvm_vcpu *vcpu,
 			return 1;
 
 		vmcs12->ept_pointer = new_eptp;
+		nested_ept_new_eptp(vcpu);
 
-		kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
+		if (!nested_cpu_has_vpid(vmcs12))
+			kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
 	}
 
 	return 0;
-- 
2.32.0.rc1.229.g3e70b5a671-goog

