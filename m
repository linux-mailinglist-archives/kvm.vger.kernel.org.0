Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A050044888
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388899AbfFMRIS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:08:18 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36956 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393304AbfFMRDy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:03:54 -0400
Received: by mail-wm1-f66.google.com with SMTP id 22so10898990wmg.2;
        Thu, 13 Jun 2019 10:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=whDprreeVfoXYE9X/DIRq/T6TGZeDGcOo63ZQC7YwS4=;
        b=phL3709W658YyQp9NuVbHh1NmXl3Jaf8zbxYGivIG9x9e+2FYaRAe9LunVedJvonX0
         6H7rtFHApAxu7jz6Ak3dL8HAtfqkQ3HHJ5D/q8+EdOGIgvH1mjFi+qjZderoBDyJuslx
         2X2nfL019CCKT37cL43gLlcyTmvw1v2OHfG1IAuklOvmqHuXy1JoV8PevQR6YAe5k8Vy
         Uh/b1j2UXWr7EzR482bOu2Q3Bj6km064HA8GbmPKvDMRocHspSWPyLAGiDzVCF1CJ+0k
         LNxN4r8ZHavc41APsP2vgiydzFQuvWxqvaIRmkY3kSr9kTVNmV/QHYl80g9RCqjwlqdD
         fGow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=whDprreeVfoXYE9X/DIRq/T6TGZeDGcOo63ZQC7YwS4=;
        b=O/MZHt2fByRWAssxHHz2iliDah9LZER1imy76jYPWfseFum29K2AaDFrfdlR+7ieqM
         PijmE8Bdftqb+4/QVC55u4hGxL5ZB9wKm3yqlg0PLJGw/W4lJvw8Pq94NZjllwBowssE
         Y4Irn1I+N7QK2a3r2UP7RyoM9wh36Yr7H4KBLUTOKESrSDM6rN/8+M/4tSJndCMU2u7a
         v2LQFel/wGvKs9+NfLI/VO2xyMY8lfbDOOSSMTqsanbZm/Kmz6k0IxB4rPSW3OjORgh/
         hjY4I7DXdrwVAbkjGtVpUARsED4spkVOGwmGq+XrgWeD/MoZI/bSvE+j1rQwDWz8RAeq
         LFug==
X-Gm-Message-State: APjAAAU/gOJTfQhxnwfMpJWFjLZNTdVI0XBqL01DAAVkijlwIsh/EWAX
        DyI1fv8l7pVANlsIlccBMQkCiz94
X-Google-Smtp-Source: APXvYqy0r+P0L6dxBXThM/MBlUiH7VMW9XQU8ZaqX0qS4J34O/t4ViWPaS/4tPyhD+AOE5frpphokw==
X-Received: by 2002:a1c:f20f:: with SMTP id s15mr4395044wmc.33.1560445432474;
        Thu, 13 Jun 2019 10:03:52 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.03.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:03:51 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 18/43] KVM: nVMX: Don't rewrite GUEST_PML_INDEX during nested VM-Entry
Date:   Thu, 13 Jun 2019 19:03:04 +0200
Message-Id: <1560445409-17363-19-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Emulation of GUEST_PML_INDEX for a nested VMM is a bit weird.  Because
L0 flushes the PML on every VM-Exit, the value in vmcs02 at the time of
VM-Enter is a constant -1, regardless of what L1 thinks/wants.

Fixes: 09abe32002665 ("KVM: nVMX: split pieces of prepare_vmcs02() to prepare_vmcs02_early()")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index fee297a5edda..01275cbd7478 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1940,8 +1940,17 @@ static void prepare_vmcs02_constant_state(struct vcpu_vmx *vmx)
 	if (cpu_has_vmx_msr_bitmap())
 		vmcs_write64(MSR_BITMAP, __pa(vmx->nested.vmcs02.msr_bitmap));
 
-	if (enable_pml)
+	/*
+	 * The PML address never changes, so it is constant in vmcs02.
+	 * Conceptually we want to copy the PML index from vmcs01 here,
+	 * and then back to vmcs01 on nested vmexit.  But since we flush
+	 * the log and reset GUEST_PML_INDEX on each vmexit, the PML
+	 * index is also effectively constant in vmcs02.
+	 */
+	if (enable_pml) {
 		vmcs_write64(PML_ADDRESS, page_to_phys(vmx->pml_pg));
+		vmcs_write16(GUEST_PML_INDEX, PML_ENTITY_NUM - 1);
+	}
 
 	if (cpu_has_vmx_encls_vmexit())
 		vmcs_write64(ENCLS_EXITING_BITMAP, -1ull);
@@ -2102,16 +2111,6 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	vm_exit_controls_init(vmx, exec_control);
 
 	/*
-	 * Conceptually we want to copy the PML address and index from
-	 * vmcs01 here, and then back to vmcs01 on nested vmexit. But,
-	 * since we always flush the log on each vmexit and never change
-	 * the PML address (once set), this happens to be equivalent to
-	 * simply resetting the index in vmcs02.
-	 */
-	if (enable_pml)
-		vmcs_write16(GUEST_PML_INDEX, PML_ENTITY_NUM - 1);
-
-	/*
 	 * Interrupt/Exception Fields
 	 */
 	if (vmx->nested.nested_run_pending) {
-- 
1.8.3.1


