Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6D575D7E8
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 01:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbjGUXjN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 19:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjGUXjK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 19:39:10 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E33130DD
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 16:39:02 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b8a7734734so14336275ad.2
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 16:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689982742; x=1690587542;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wxpv5d1dbsB02EOhCUS+N+V6wGKp/ft8bZjDfblFWp0=;
        b=6+6p+4MOaxtK+Vf0JT9BKKWNZe6ldV4PUn79DslXbhsuAlyt7oSr3ljHaBNqTMv/3U
         pYZnh3PAlttxfjDl+RD724I/kb1Y3dkipnAzFQkVQDSPVpwSIzsApj4QdWTp5IwI26Nk
         MPN7sVU5WP6DRFcOhNs1zZia5HJRTrEBZZn6ARyBCrrAkekkkBkYzCqTgdssFDglhcA3
         xLRY767xHR9Gcm9mtNArlQdI7cH+MfPCp/I9POthmYWAWRDwyAav3e+nWrTearkc04Bw
         FKgtKGOc7FGX2LW/5ndrexkCl4pAJC8EWXVvT2StRb6J5+CFrEuwuuxQlAR8ijc+81aE
         3ndg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689982742; x=1690587542;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Wxpv5d1dbsB02EOhCUS+N+V6wGKp/ft8bZjDfblFWp0=;
        b=h4mtTtDMsgcEPX0U07Ewdgm4BZxo47aDtfMy1fj4qUiNEq8CStZxw5iZxNmxsn69U2
         iSPotcY9xj5FMg+SrpHP6OKlt43fmt/kEFkv7im7ej786cyG5b67+xZa+rt6L5D97xIv
         RWkB7YDsgtgHetPt+wtmU/fRJCUWyKB2dJJTZC3BzobmedykljqkYpn/LhGSatGGbyjX
         jEe6CP/aJ7tKRBubYIJQJyExgQupEK7Zt0sljIaKBdtWkdEBYkHy4rlNjhec5vFJWktm
         jXqQwueIVGP27dgPR8P9Y5lzoMgLIx/iud+M/onLXM1xK/FbGgcY8UtkOy4wPkxHhFhT
         ipGQ==
X-Gm-Message-State: ABy/qLbePVaSSszRSPpNJPM/3JRvRvTMDTutEEWEzrSYUrdN3WTHXtf7
        qMmRz+3oicuhLZyChUaT/Pwn39EWSgs=
X-Google-Smtp-Source: APBJJlG1X+RELTKU0r2yW84zpiRaZzYEGvAZUim/uaTx2J52QSwSORgoGNZiIt5eRccKpiTbTQzOmzFGG9o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f683:b0:1ba:ff36:e0d7 with SMTP id
 l3-20020a170902f68300b001baff36e0d7mr13847plg.12.1689982741675; Fri, 21 Jul
 2023 16:39:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jul 2023 16:38:58 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721233858.2343941-1-seanjc@google.com>
Subject: [PATCH] KVM: VMX: Drop manual TLB flush when migrating vmcs.APIC_ACCESS_ADDR
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the superfluous flush of the current TLB in VMX's handling of
migration of the APIC-access page, as a full TLB flush on all vCPUs will
have already been performed in response to kvm_unmap_gfn_range() *if*
there were SPTEs pointing at the APIC-access page.  And if there were no
valid SPTEs, then there can't possibly be TLB entries to flush.

The extra flush was added by commit fb6c81984313 ("kvm: vmx: Flush TLB
when the APIC-access address changes"), with the justification of "because
the SDM says so".  The SDM said, and still says:

 As detailed in Section xx.x.x, an access to the APIC-access page might
 not cause an APIC-access VM exit if software does not properly invalidate
 information that may be cached from the EPT paging structures. If EPT was
 in use on a logical processor at one time with EPTP X, it is recommended
 that software use the INVEPT instruction with the =E2=80=9Csingle-context=
=E2=80=9D INVEPT
 type and with EPTP X in the INVEPT descriptor before a VM entry on the
 same logical processor that enables EPT with EPTP X and either (a) the
 "virtualize APIC accesses" VM- execution control was changed from 0 to 1;
 or (b) the value of the APIC-access address was changed.

But the "recommendation" for (b) is predicated on there actually being
a valid EPT translation *and* possible TLB entries for the GPA (or guest
VA when using shadow paging).  It's possible that a different vCPU has
established a mapping for the new page, but the current vCPU can't have
entered the guest, i.e. can't have created a TLB entry, between flushing
the old mappings and changing its vmcs.APIC_ACCESS_ADDR.

kvm_unmap_gfn_range() waits for all vCPUs to ack KVM_REQ_APIC_PAGE_RELOAD,
and then flushes remote TLBs (which may or may not also pend a request).
Thus the vCPU is guaranteed to update vmcs.APIC_ACCESS_ADDR before
re-entering the guest and before it can possibly create new TLB entries.

In other words, KVM does flush in this case, it just does so earlier
on while handling the page migration.

Note, VMX also flushes if the vCPU is migrated to a new pCPU, i.e. if
the vCPU is migrated to a pCPU that entered the guest for a different
vCPU.

Suggested-by: Yu Zhang <yu.c.zhang@linux.intel.com>
Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0ecf4be2c6af..3f868826db7d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6767,8 +6767,10 @@ static void vmx_set_apic_access_page_addr(struct kvm=
_vcpu *vcpu)
 	vmcs_write64(APIC_ACCESS_ADDR, pfn_to_hpa(pfn));
 	read_unlock(&vcpu->kvm->mmu_lock);
=20
-	vmx_flush_tlb_current(vcpu);
-
+	/*
+	 * No need for a manual TLB flush at this point, KVM has already done a
+	 * flush if there were SPTEs pointing at the previous page.
+	 */
 out:
 	/*
 	 * Do not pin apic access page in memory, the MMU notifier

base-commit: fdf0eaf11452d72945af31804e2a1048ee1b574c
--=20
2.41.0.487.g6d72f3e995-goog

