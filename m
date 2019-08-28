Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38829A0E58
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 01:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbfH1Xlx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 19:41:53 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:52731 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727104AbfH1Xlw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 19:41:52 -0400
Received: by mail-pl1-f202.google.com with SMTP id g18so871550plj.19
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2019 16:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=t8NJxxfAVMTnTgBD37YHgq3f5K8noVf+qHSJxfXKSr4=;
        b=IjWqXSFb7XVl+Bz6Uku0KoNtZeQWPPQ0S+bbprL3PZg/HlvBFGWLyGYrmAAnI6myaw
         njzFNvZwriThkPsxGUwibaE9mngbuD2uWXu+R6brZaERGDmv2iMSouT06O/vuT8r5qn4
         3XnGukOWRXFnY4/ZEGZNMKFYPzch1hPA+88EzJd7Qk6QBav0WvmUpba2nlm809iIqsvW
         wagRtx0SyyLt57sIhqZB3P9CAIkygSwAg+15vUgY0Xf8ZJd1NROryuFxo0P2pmaT7nNt
         5KQ6xMSn6FBTq5zcl7wbCorteoHF75lPte3O2vJFnjwOJEq1flwABIAtfVRLkaOjwb13
         w22A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=t8NJxxfAVMTnTgBD37YHgq3f5K8noVf+qHSJxfXKSr4=;
        b=VbzueryKed1UDX0tq2C4MhnOpIgRyDrtosfLCJWuSmVr9Ya/cQjXGlSnwfpwnCmhSP
         30bljNBcAm5sEgZUT9cbSHvB3WToqLzdKsmJ44cPl7EHrHQ/SSMUHghYUv7EGcpTux7u
         1ieM4ySAnVDmApFF1Om0L3DXNxARjGBqi5f7r1wodJlhYxTB944+0OeWUOnlqwYqYefI
         PE/KmQoEqtM9rsrNJjMhRU1vuQui/BBvxzIlUh6FoRSEFfqepSL7mTwNUXVjx6C/xTW2
         txBg+1JZXmFwzwTmIchj5ilQ6NDcHYlypz0R/aPN1hMzDOiVTvzbwk5Qdkk5ic63Hn8r
         BqyA==
X-Gm-Message-State: APjAAAXLW9vsQgfECvGJdWKmbWI24rFGbrByZ2psl0eRB75YhCtEkbVU
        t9UTpZee+iD9SQrwIu9Lghzt80J9/MmNBeRyo+jvOdnV6K+MbtckU2EccfBgSQi+vcJ5RXYyaVG
        tknfBg0iXl/DgJmoRkMN1dPSaBbLSKfonHpWuvvFS4oEEt0m4Mee/oel3jw==
X-Google-Smtp-Source: APXvYqwfd/hvuh9nlpasBhOUXxnlBlKbqKiF767fjQONL5on0uhTd2zj6V5BsBB0WRDFlUKuDk+Rieo/5Fg=
X-Received: by 2002:a65:6846:: with SMTP id q6mr5725165pgt.150.1567035711240;
 Wed, 28 Aug 2019 16:41:51 -0700 (PDT)
Date:   Wed, 28 Aug 2019 16:41:32 -0700
In-Reply-To: <20190828234134.132704-1-oupton@google.com>
Message-Id: <20190828234134.132704-6-oupton@google.com>
Mime-Version: 1.0
References: <20190828234134.132704-1-oupton@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH 5/7] KVM: nVMX: Check HOST_IA32_PERF_GLOBAL_CTRL on VM-entry
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to the SDM 26.2.2, "If the "load IA32_PERF_GLOBAL_CTRL"
VM-exit control is 1, bits reserved in the IA32_PERF_GLOBAL_CTRL
MSR must be 0 in the field for that register"

Adding condition to nested_vmx_check_host_state that checks the validity
of HOST_IA32_PERF_GLOBAL_CTRL if "load IA32_PERF_GLOBAL_CTRL" is
set on the VM-exit control.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/vmx/nested.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 8d6f0144b1bd..d294b7d2d2cd 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2650,6 +2650,11 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 	    !kvm_pat_valid(vmcs12->host_ia32_pat))
 		return -EINVAL;
 
+	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL &&
+	    !kvm_is_valid_perf_global_ctrl(vcpu,
+					   vmcs12->host_ia32_perf_global_ctrl))
+		return -EINVAL;
+
 	ia32e = (vmcs12->vm_exit_controls &
 		 VM_EXIT_HOST_ADDR_SPACE_SIZE) != 0;
 
-- 
2.23.0.187.g17f5b7556c-goog

