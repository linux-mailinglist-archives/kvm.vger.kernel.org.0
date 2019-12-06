Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2659114EFC
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 11:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbfLFKZe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 05:25:34 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:44105 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbfLFKZe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 05:25:34 -0500
Received: by mail-qk1-f193.google.com with SMTP id i18so6020386qkl.11
        for <kvm@vger.kernel.org>; Fri, 06 Dec 2019 02:25:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=poU4coC1wpEnGRHnApg5z8cKyUslXoAMtkEQeEix3YE=;
        b=OfA4h5x466F13+EJ6RAM3rEK2XQXeqRQWVoYD9x7iKGEqTUVkJVKX2xdBb0uK7Wiy8
         +K3lV6Ttr9mWyHEWzqLfsOXpVaoyIgO0Z7sucDUc5ml8tWFEQx/VSTgDfzKC/7ts+9tw
         Uo0K8cEOVQCNU+30QTyVLUHJ2glanPx6QqbpFY+xVb6A3XF0oMul+CpcqSe8Z35w2dZo
         ewoSVe3v+Tq8NBBaubsauIIlFA/zUxnBp8Pw/r37SJwO+aI5dxmsVQ7EzGHFv/9Bo/ks
         M4iMFTRX1g39U7AWBmfcXeI9aiBakRBcEVi2x8Bs2FWOfBsJCaLVK7xPUmK3LcBKuPUg
         94Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=poU4coC1wpEnGRHnApg5z8cKyUslXoAMtkEQeEix3YE=;
        b=i4iYGRggECSdrAteE2tNY9x1bEAb1L5rrxOscGrgNaP4c3xzxheMgi7s3TF3BWksoG
         bPe0/mgLAg7tVWL7TRKze/BnZ+8ZRWxoINXNMlAIPZmoZj9/ZXyWqGX0EA8Jjog5RVHF
         FsKlsczb4v6fg+npwEv7Qov0xiEwdm86wdqxTWe3b78FW/zk+MVsRS41syj4D/h+2KMd
         W9ptlPjwb59SXXonxNfL3g9idY8E5b+O1E77jr6BwxTafG+VtgCtr/RG09plUslNZZeQ
         B/6+AcVTK25Rr8/gPTDfr4PzKrD/txjj0R4Ur0QXn62/CkRLx7R1wXwyK3u/dh8q3Nmo
         Et5A==
X-Gm-Message-State: APjAAAXb76/pB10kV/INuU9kD+5+HfzBMrGR7V4IV/xevCzKfVs1tCMJ
        pZTsBIJnE9LabDKaPo0oIlI=
X-Google-Smtp-Source: APXvYqyHAGUvqCWHS5evYFAogikSLDtFd1xrmclCYnoYpwWw+dIWtypuzUWGf2XoUfxoQEICD0mGNQ==
X-Received: by 2002:a37:a257:: with SMTP id l84mr13084095qke.22.1575627933529;
        Fri, 06 Dec 2019 02:25:33 -0800 (PST)
Received: from host.localdomain (104.129.187.94.16clouds.com. [104.129.187.94])
        by smtp.gmail.com with ESMTPSA id o7sm2117654qkd.119.2019.12.06.02.25.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Dec 2019 02:25:32 -0800 (PST)
From:   Catherine Ho <catherine.hecx@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org
Cc:     Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Catherine Ho <catherine.hecx@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] target/i386: skip kvm_msr_entry_add when kvm_vmx_basic is 0
Date:   Fri,  6 Dec 2019 05:23:37 -0500
Message-Id: <1575627817-24625-1-git-send-email-catherine.hecx@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <3a1c97b2-789f-dd21-59ba-f780cf3bad92@redhat.com>
References: <3a1c97b2-789f-dd21-59ba-f780cf3bad92@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 1389309c811b ("KVM: nVMX: expose VMX capabilities for nested
hypervisors to userspace") expands the msr_based_features with
MSR_IA32_VMX_BASIC and others. Then together with an old kernel before
1389309c811b, the qemu call KVM_GET_MSR_FEATURE_INDEX_LIST and got the
smaller kvm_feature_msrs. Then in kvm_arch_get_supported_msr_feature(),
searching VMX_BASIC will be failed and return 0. At last kvm_vmx_basic
will be assigned to 0.

Without this patch, it will cause a qemu crash (host kernel 4.15
ubuntu 18.04+qemu 4.1):
qemu-system-x86_64: error: failed to set MSR 0x480 to 0x0
target/i386/kvm.c:2932: kvm_put_msrs: Assertion `ret ==
cpu->kvm_msr_buf->nmsrs' failed.

This fixes it by skipping kvm_msr_entry_add when kvm_vmx_basic is 0

Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Catherine Ho <catherine.hecx@gmail.com>
---
 target/i386/kvm.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index a8c44bf..8cf84a2 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -2632,8 +2632,13 @@ static void kvm_msr_entry_add_vmx(X86CPU *cpu, FeatureWordArray f)
                                          f[FEAT_VMX_SECONDARY_CTLS]));
     kvm_msr_entry_add(cpu, MSR_IA32_VMX_EPT_VPID_CAP,
                       f[FEAT_VMX_EPT_VPID_CAPS] | fixed_vmx_ept_vpid);
-    kvm_msr_entry_add(cpu, MSR_IA32_VMX_BASIC,
+
+    if (kvm_vmx_basic) {
+	/* Only add the entry when host supports it */
+        kvm_msr_entry_add(cpu, MSR_IA32_VMX_BASIC,
                       f[FEAT_VMX_BASIC] | fixed_vmx_basic);
+    }
+
     kvm_msr_entry_add(cpu, MSR_IA32_VMX_MISC,
                       f[FEAT_VMX_MISC] | fixed_vmx_misc);
     if (has_msr_vmx_vmfunc) {
-- 
1.7.1

