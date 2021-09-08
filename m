Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11904031D2
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 02:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbhIHAZM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 20:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbhIHAZM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Sep 2021 20:25:12 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA90C061575
        for <kvm@vger.kernel.org>; Tue,  7 Sep 2021 17:24:05 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 124-20020a251182000000b005a027223ed9so338428ybr.13
        for <kvm@vger.kernel.org>; Tue, 07 Sep 2021 17:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=eECNEybjWQ2PoVflYqmH9Ss/tHTEVMaEvYYBIsHokWk=;
        b=KCQwWabnOZHPBdoppj+q/i1OmGIqoG6FtmQSu3XNb4D9Z11Zr6bbEEgjmtHBtMMgfl
         6ZofGOtxUxvdQWwDKq60DBkANY/+x+K3Mr/Mvif6+Lal5SRevhy1XAF7z+DS6y/yF6ZE
         YdeVJy07desRWit2hA6abp20jtGFj063Q2R8NMbdHCp3SI5mSfdi1lrayCXCJla8f6zR
         bScLVXHxxIZXcBVA3xl7zlItog1Y/MJB7RAqtSaTp4DS1P/xu8YMWbuyPRKjS4ce1SxU
         YLpG80fqQ4dMt4a3dGdHudp7rpdUeDZi+FZV7xTb4ryQy0rfcfiomP7974s6PhxTooAK
         ZuOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=eECNEybjWQ2PoVflYqmH9Ss/tHTEVMaEvYYBIsHokWk=;
        b=OvDk549FUcbMZYAKpADPjt0semNriwB76hB/0bsFg0kOLZ1hrbKlf5PUPyCNpWilvf
         N/RXNjplGIylnzUmLlVfIs72ZjtteEwsdZLjIAJ3Br+NODTjgsLwbcFQraiMzjoDQVap
         12NZRlBZQlIVH0MgpxFWiyNrS7VL+QiBVDc2Eb6VXRGg6fEp6KwOOiTWqcHP5pZu0fuM
         caV1n2Ijc9ljrueTfld0NVQ82NPGP3BfX/VYpg9AXL5mbGwMM3xA/ZjbGS7VCpco/prk
         oTJL/Pq6YanTWX/cBFvLlQ6XRkkq/eOoyULul3E1CWTgxlGqvvb4SuvAgaRqE6RJRBwh
         viyw==
X-Gm-Message-State: AOAM533SS0AyQIYvr1TFk/TGnKMvAgueDXYVTjx7lLRqcyp+yQ+/h6pj
        Om0dmOFXR/uUiqKaWlaw76Dg9BIXB34=
X-Google-Smtp-Source: ABdhPJyltULn5jF+JE9zJFXzO5Cg7xV9DjZaXnXK2vKEv9y1LzXZQh+tRvh/VGB2PX6cN6p1il+5mi908MU=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:bd1:945f:2492:aa51])
 (user=seanjc job=sendgmr) by 2002:a25:ba08:: with SMTP id t8mr1473912ybg.111.1631060644483;
 Tue, 07 Sep 2021 17:24:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  7 Sep 2021 17:24:01 -0700
Message-Id: <20210908002401.1947049-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH] KVM: VMX: Remove defunct "nr_active_uret_msrs" field
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove vcpu_vmx.nr_active_uret_msrs and its associated comment, which are
both defunct now that KVM keeps the list constant and instead explicitly
tracks which entries need to be loaded into hardware.

No functional change intended.

Fixes: ee9d22e08d13 ("KVM: VMX: Use flag to indicate "active" uret MSRs instead of sorting list")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 4858c5fd95f2..02ab3468885f 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -248,12 +248,8 @@ struct vcpu_vmx {
 	 * only loaded into hardware when necessary, e.g. SYSCALL #UDs outside
 	 * of 64-bit mode or if EFER.SCE=1, thus the SYSCALL MSRs don't need to
 	 * be loaded into hardware if those conditions aren't met.
-	 * nr_active_uret_msrs tracks the number of MSRs that need to be loaded
-	 * into hardware when running the guest.  guest_uret_msrs[] is resorted
-	 * whenever the number of "active" uret MSRs is modified.
 	 */
 	struct vmx_uret_msr   guest_uret_msrs[MAX_NR_USER_RETURN_MSRS];
-	int                   nr_active_uret_msrs;
 	bool                  guest_uret_msrs_loaded;
 #ifdef CONFIG_X86_64
 	u64		      msr_host_kernel_gs_base;
-- 
2.33.0.309.g3052b89438-goog

