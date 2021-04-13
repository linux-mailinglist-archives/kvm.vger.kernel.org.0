Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0472635E323
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 17:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346094AbhDMPtN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 11:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345993AbhDMPtH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 11:49:07 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68370C061574
        for <kvm@vger.kernel.org>; Tue, 13 Apr 2021 08:48:47 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id 15so8671262qkv.16
        for <kvm@vger.kernel.org>; Tue, 13 Apr 2021 08:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=EYvFdtdmniOP0Ta43kxjqQJmZwEspknxzVV5/mYBlog=;
        b=m0xoCRoLT0iZ4P8XjVDhFfVoF1j2PxsxEBaD3bnVNEhvgEKw+yRZjJF/wK9wojc1rV
         MYxui5C+ivI2IZaD+dPP2S1xD3w6WCZcuuuptvPuhBLvNDSdBWB65SBiRmgFRIWav9j6
         ZYqXXWKu2FIlmxMPw4r9miz4uk6Wo5MXVdJZgXiiaj9KD9Pv002Gn+xy2P77DT3hYT5d
         NM2lZZzn+GoSEsQndtHKRB2Cy0aKVwjQeXGtuDv6exFSMfGbGfqNImjatq7uUjO3opGd
         jjn+cdOt2gadDjF6NcQJpFHfloB3yBOqs0Kv4LjmcCUIrpH8Jazpm0ShGy2hZL86Yz1Q
         Is8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=EYvFdtdmniOP0Ta43kxjqQJmZwEspknxzVV5/mYBlog=;
        b=fWfL8YPhTctWMuZW+NkH0UhPtoR5gICU1sCWV1XfgkgBQaZn2e9Xd3dykPrbS7ecso
         8KW39JLl/VRg1XS26DTo/H4LkHANyaBZ/i7wQhh9DRTLXgdw1G3OquFoeGb7H9NSgTR6
         baUubQvhmXw+rcr6QFNi6ynnU8Ix8U8Y+nNDEcjs9N6b8USgtO1HaDaLKI0NLJlI/LYs
         XXACObW3Upry7S31U3cWCOj51+/D8DmcYLlt8dxizwWBRrotKNacmpj3SATeyzpED2YC
         mmZ9+GwZ6Pu6qYqsN1eYjOXlxtz+lkgMYgR+Yugw434NEKZjLG3DVW16b980AB7CWkdU
         PWjg==
X-Gm-Message-State: AOAM530dHOseOWWf7b5/EViJ41a8gt8GbYLZmmxieQgitBVKRSVbbErI
        01x1Y0zSxq5Np5LmjvA3P2P3VEWxF9Ik8szp3aK3ZRdyLIDmS9HUaftEgPQcEGm02mGt8VmPI3m
        TeoqGpRY3DP06st1tr74BMyrk58CSvhahcZuAg4LDBfoye9f6onrkmghSfw==
X-Google-Smtp-Source: ABdhPJywB/NR5QM6336xCXTD26lcC3/uKRuJ1usxRQ70uM4FvOK/Rqm1zXEyReY3HsRtnLqYz+aW5r6BX1c=
X-Received: from reiji-vws.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:a0c:f901:: with SMTP id v1mr25205488qvn.26.1618328926505;
 Tue, 13 Apr 2021 08:48:46 -0700 (PDT)
Date:   Tue, 13 Apr 2021 15:47:40 +0000
Message-Id: <20210413154739.490299-1-reijiw@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.295.g9ea45b61b8-goog
Subject: [PATCH] KVM: VMX: Don't use vcpu->run->internal.ndata as an array index
From:   Reiji Watanabe <reijiw@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Reiji Watanabe <reijiw@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

__vmx_handle_exit() uses vcpu->run->internal.ndata as an index for
an array access.  Since vcpu->run is (can be) mapped to a user address
space with a writer permission, the 'ndata' could be updated by the
user process at anytime (the user process can set it to outside the
bounds of the array).
So, it is not safe that __vmx_handle_exit() uses the 'ndata' that way.

Fixes: 1aa561b1a4c0 ("kvm: x86: Add "last CPU" to some KVM_EXIT information")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 32cf8287d4a7..29b40e092d13 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6027,19 +6027,19 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	     exit_reason.basic != EXIT_REASON_PML_FULL &&
 	     exit_reason.basic != EXIT_REASON_APIC_ACCESS &&
 	     exit_reason.basic != EXIT_REASON_TASK_SWITCH)) {
+		int ndata = 3;
+
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_DELIVERY_EV;
-		vcpu->run->internal.ndata = 3;
 		vcpu->run->internal.data[0] = vectoring_info;
 		vcpu->run->internal.data[1] = exit_reason.full;
 		vcpu->run->internal.data[2] = vcpu->arch.exit_qualification;
 		if (exit_reason.basic == EXIT_REASON_EPT_MISCONFIG) {
-			vcpu->run->internal.ndata++;
-			vcpu->run->internal.data[3] =
+			vcpu->run->internal.data[ndata++] =
 				vmcs_read64(GUEST_PHYSICAL_ADDRESS);
 		}
-		vcpu->run->internal.data[vcpu->run->internal.ndata++] =
-			vcpu->arch.last_vmentry_cpu;
+		vcpu->run->internal.data[ndata++] = vcpu->arch.last_vmentry_cpu;
+		vcpu->run->internal.ndata = ndata;
 		return 0;
 	}
 
-- 
2.31.1.295.g9ea45b61b8-goog

