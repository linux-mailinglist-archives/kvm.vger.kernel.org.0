Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA08367725
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 04:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233824AbhDVCME (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 22:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbhDVCMD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 22:12:03 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCBEC06174A
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:11:29 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id n129-20020a2527870000b02904ed02e1aab5so6502169ybn.21
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=BgeeFXLae7p4tESr7C5iEIirYqJ/bWWbWSvsNXof9Mg=;
        b=CjnWcAI4QFKQZG0WldgHzCpcPsyGBnmDdq6p48/9ZU0hDve7babqNP2g4IWXLZPNOI
         Fmjug1K+dQvzxn7273w0d6QhBVhcbcGwlvwCc+2lWVD2Edgt9mOk9f0zjzmWK5w6DSh4
         zq1EXDdUzDWXIs3JHD7WPkPnNPggOVy/6mtL/GZNZ9pKXYY5dqK0SP2hXONRMJkEdBJQ
         6LYaXsuJP9ie+Qw1jtdvzCp/VfzpUa9ayL/PX+k+xbcXI6qVciRXg4Wp1WBe2G1tMJuG
         Pc3v9mQ+54qYMP/CVqr4UyaVH7sJRYW7ri/3QZkFmjeATDhr+6sWIfGhppqZy+Zrn3aU
         oHDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=BgeeFXLae7p4tESr7C5iEIirYqJ/bWWbWSvsNXof9Mg=;
        b=tD1QPM7F5rYGDYOm/ukxYGnoX+T5vmPrrMO+p5NvMwO1FIvglWuY3ddKiKueCtsGJB
         K4/BmfNx3BqxZzDxFT0Ayd5HYTV9N8Qv4M8/sOAsCg2/NabSXahyJcNhifY6TPLhd9Ms
         taSLNAhDGzFyCCJYaJ81Z6QPFkKcJN6XWyM6ZkEQ+uWnkkxy9ci8Yz6f/bCVZQNycaMs
         y8Nhy/SJRAZP9nhGPHraHw+fHam5PaHVAG/Ucn/HYb5JkRcknnHmbUKiZxRY1Tji7TOq
         aVY9Fswr8Ck/plOQoK3zgb+Zv9BhLNEGCTMmFCGMCNBxBEt1B6xlf6/gp8BvISrSNfL/
         /Z7A==
X-Gm-Message-State: AOAM532r6wOBFjT4/+MEnDH88Fc0cQfRBoH38OadjkOzcR+vfEHFhlVU
        VxSV1GL7VRyGecVPCwoZNe2HwoqC00U=
X-Google-Smtp-Source: ABdhPJzALDiRE9aA270oh7sykTY9Efj6ng96S+sITefYvCrazk1t93p9SRCc0wcrZvcAgc0Fn9Uqi59VR/I=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:a25:7085:: with SMTP id l127mr1381469ybc.293.1619057488960;
 Wed, 21 Apr 2021 19:11:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Apr 2021 19:11:10 -0700
Message-Id: <20210422021125.3417167-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v5 00/15] KVM: SVM: Misc SEV cleanups
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Minor bug fixes and refactorings of SEV related code, mainly to clean up
the KVM code for tracking whether or not SEV and SEV-ES are enabled.  E.g.
KVM has both sev_es and svm_sev_enabled(), and a global 'sev' flag while
also using 'sev' as a local variable in several places.

Based kvm/queue-ish, commit 0e91d1992235 ("KVM: SVM: Allocate SEV command
structures on local stack"), to avoid the conflicting CPUID.0x8000_001F
patch sitting in kvm/queue.

v5:
 - Use Paolo's version of the CPUID.0x8000_001F patch, with some of my
   goo on top.  Paolo gets credit by introducing fewer bugs; v4 missed
   the SEV/SEV-ES module params and used the wrong reverse-CPUID index...
 - Add a patch to disable SEV/SEV-ES if NPT is disabled.
 - Rebased, as above.
v4:
 - Reinstate the patch to override CPUID.0x8000_001F.
 - Properly configure the CPUID.0x8000_001F override. [Paolo]
 - Rebase to v5.12-rc1-dontuse.
v3:
 - Drop two patches: add a dedicated feature word for CPUID_0x8000001F,
   and use the new word to mask host CPUID in KVM.  I'll send these as a
   separate mini-series so that Boris can take them through tip.
 - Add a patch to remove dependency on
   CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT. [Boris / Paolo]
 - Use kcalloc() instead of an open-coded equivalent. [Tom]
 - Nullify sev_asid_bitmap when freeing it during setup. [Tom]
 - Add a comment in sev_hardware_teardown() to document why it's safe to
   query the ASID bitmap without taking the lock. [Tom]
 - Collect reviews. [Tom and Brijesh]
v2:
 - Remove the kernel's sev_enabled instead of renaming it to sev_guest.
 - Fix various build issues. [Tom]
 - Remove stable tag from the patch to free sev_asid_bitmap.  Keeping the
   bitmap on failure is truly only a leak once svm_sev_enabled() is
   dropped later in the series.  It's still arguably a fix since KVM will
   unnecessarily keep memory, but it's not stable material. [Tom]
 - Collect one Ack. [Tom]

v1:
 - https://lkml.kernel.org/r/20210109004714.1341275-1-seanjc@google.com

Paolo Bonzini (1):
  KVM: SEV: Mask CPUID[0x8000001F].eax according to supported features

Sean Christopherson (14):
  KVM: SVM: Zero out the VMCB array used to track SEV ASID association
  KVM: SVM: Free sev_asid_bitmap during init if SEV setup fails
  KVM: SVM: Disable SEV/SEV-ES if NPT is disabled
  KVM: SVM: Move SEV module params/variables to sev.c
  x86/sev: Drop redundant and potentially misleading 'sev_enabled'
  KVM: SVM: Append "_enabled" to module-scoped SEV/SEV-ES control
    variables
  KVM: SVM: Condition sev_enabled and sev_es_enabled on
    CONFIG_KVM_AMD_SEV=y
  KVM: SVM: Enable SEV/SEV-ES functionality by default (when supported)
  KVM: SVM: Unconditionally invoke sev_hardware_teardown()
  KVM: SVM: Explicitly check max SEV ASID during sev_hardware_setup()
  KVM: SVM: Move SEV VMCB tracking allocation to sev.c
  KVM: SVM: Drop redundant svm_sev_enabled() helper
  KVM: SVM: Remove an unnecessary prototype declaration of
    sev_flush_asids()
  KVM: SVM: Skip SEV cache flush if no ASIDs have been used

 arch/x86/include/asm/mem_encrypt.h |  1 -
 arch/x86/kvm/cpuid.c               |  8 ++-
 arch/x86/kvm/cpuid.h               |  1 +
 arch/x86/kvm/svm/sev.c             | 80 ++++++++++++++++++++++--------
 arch/x86/kvm/svm/svm.c             | 57 +++++++++------------
 arch/x86/kvm/svm/svm.h             |  9 +---
 arch/x86/mm/mem_encrypt.c          | 12 ++---
 arch/x86/mm/mem_encrypt_identity.c |  1 -
 8 files changed, 97 insertions(+), 72 deletions(-)

-- 
2.31.1.498.g6c1eba8ee3d-goog

