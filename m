Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB7B5F17CD
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 03:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbiJABBc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 21:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232964AbiJABAd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 21:00:33 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9197C481CC
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 17:59:54 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id n18-20020a056a000d5200b0053e16046751so3588380pfv.7
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 17:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=R71/O1P9jP2UCrSl2xyd7gUnWafXM9iFFvICxHImjJ0=;
        b=AYxux+7e23c/mGRsa0oWHBBFkLGtZl861dd7syAbRuO7+Ds5sEWlh6juenHY/Ytezx
         7rgZYiCikzb8acdYu/zEJxsJRxtR1JAoR5zDGIshNA4Vf85IivSYdGQMMft5PWfN8EDQ
         qSR1wqQV1MJIrhkVDAdqiPq9tRraTer3NTC7Ujg0YbwQYp24mgz4Agnncjy+RsfYyJ8s
         gH/km0nAmfWe2IpsjzSC6I8qUj3YXrVQj2P/IOqkoBAky3VX0aXqwlog8dP00gEGViFU
         PVnZAfF+DGsHTJW18hef0cf/mlDCdKkO2Jis5CG0mwmvGNC8sEgbH3j1OHWzmf2zky1n
         4pqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=R71/O1P9jP2UCrSl2xyd7gUnWafXM9iFFvICxHImjJ0=;
        b=mpYiW77MwDGMiqhQuQBrdAkBrouvqzXMtmEHMeYf8/b0RIgkY6lw/hltfXkAXGAtsG
         XEDNDobYJHtqGeqWv2h0psqeDXdNScQnUqjJLkL1wLbmtLnHD16OMXTCVANwe11D9N23
         o7EQuTcx0WI7f4vjm8p8RIJHAhrQa9iUq+BWHI0/h18XtZxrATgQfhfwh8RrnEzRGKO8
         QDIqX3JY0jDPtydglJq4Ctd97jlz7jw6JrZBVNp7XCMR2z5CQ8AzKazyAPDKGETOBlc7
         +yxsgaST5P3WMtbJpbSHLFKfnSoouOjXoBvHRCq0a6l866t46lBVUaW3USrxROoE2J3z
         iNSg==
X-Gm-Message-State: ACrzQf17kQiP3bhbSUrAMqoIrEsIR9668/FwPCFHsb8zh17gsyVq1nYE
        UsqE83O1HxRo5QkRuG1E2dTUzJyprYA=
X-Google-Smtp-Source: AMsMyM7qCmzQLjzaNVTFgQBGLOTfMEkezvJYAbDwak7x/wzNrXvUQ95sIVSrL0jchLKF+6hUoIv3m/R6pRY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:8891:0:b0:55a:daf4:c188 with SMTP id
 z17-20020aa78891000000b0055adaf4c188mr11606489pfe.82.1664585980821; Fri, 30
 Sep 2022 17:59:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  1 Oct 2022 00:58:56 +0000
In-Reply-To: <20221001005915.2041642-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221001005915.2041642-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221001005915.2041642-14-seanjc@google.com>
Subject: [PATCH v4 13/32] KVM: SVM: Compute dest based on sender's x2APIC
 status for AVIC kick
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Compute the destination from ICRH using the sender's x2APIC status, not
each (potential) target's x2APIC status.

Fixes: c514d3a348ac ("KVM: SVM: Update avic_kick_target_vcpus to support 32-bit APIC ID")
Cc: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 84beef0edae3..e9aab8ecce83 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -429,6 +429,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
 				   u32 icrl, u32 icrh, u32 index)
 {
+	u32 dest = apic_x2apic_mode(source) ? icrh : GET_XAPIC_DEST_FIELD(icrh);
 	unsigned long i;
 	struct kvm_vcpu *vcpu;
 
@@ -444,13 +445,6 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
 	 * since entered the guest will have processed pending IRQs at VMRUN.
 	 */
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		u32 dest;
-
-		if (apic_x2apic_mode(vcpu->arch.apic))
-			dest = icrh;
-		else
-			dest = GET_XAPIC_DEST_FIELD(icrh);
-
 		if (kvm_apic_match_dest(vcpu, source, icrl & APIC_SHORT_MASK,
 					dest, icrl & APIC_DEST_MASK)) {
 			vcpu->arch.apic->irr_pending = true;
-- 
2.38.0.rc1.362.ged0d419d3c-goog

