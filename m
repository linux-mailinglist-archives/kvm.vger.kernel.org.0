Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 869A7494564
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 02:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358281AbiATBIW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 20:08:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358161AbiATBHp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 20:07:45 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABEAC061756
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 17:07:38 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id i16-20020aa78d90000000b004be3e88d746so2625638pfr.13
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 17:07:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=1MqJcaQdNhP8SCL+NFeqeJWTrEaCvBpqs2dZuCdHK2Y=;
        b=TJ2FWW5fCZHdNotJ03suK35FRY2TDUvVarJkAb30a3e7GfYJF3iobX7j9DJFQG53Z1
         wgPWmvuR7JMQvfC1HUgUxnySnvI8sjgfuIVo5whsXbAoVZWpCZGbcuz7lNCXs65mElDw
         HmtE71ykIxTNGP/rpz/VYH/dxgTy4KNJcVNglaLAj7sx/wzdbZTfrhsagKyLHEovu6BO
         +ZT651eiEOAcNUPKG3XIEQx2guE8OsYQTfnAsCWPww8AVHvTD4kuNMFNg/DJoq/syDdd
         wDJoUhAwQKejmydJGZ6wQJgVZZBrM3mIi7WEOJxyk1skav8lgp0o5i6SAiW391uQXlM5
         kyYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=1MqJcaQdNhP8SCL+NFeqeJWTrEaCvBpqs2dZuCdHK2Y=;
        b=DQbmixyce4o7d+64FH7Nex1FiAarqH1dMCWpNi/aWEkgD464F7b2VDo1c8kj3M86Wn
         BgEJ2qsYUxCEhAYQd26KqNpz6EtQZNRa5Ool4+W/wiS2BYLEImrnfY705EkyP8p6Fawr
         BuWbiNfaAMk/uPqq0jAcytTmVnfCa0oyTJ6niEW5/rC0rm3Grph/Rj+zErNYRVxI/Fwd
         cLIGa/RU91B83ojobmlnt9lcgyiv4Wi/mgtSiFs4DhrJuFdHontsj9JPm/RsEWf+6u0C
         6uoIy4zurlScviEpnpvzr6Ianxb3ju8JxucooMEV92Tw0bClD+PfsdP5nyXv/sQ50Bzy
         2euw==
X-Gm-Message-State: AOAM533V8FM7l6maJ/oUMVKRmZCqsa7Yazj2K+M777T15IU8xCgk468J
        cdqCESCkZKL3T0YbHniuTmUQ/Ee47Zo=
X-Google-Smtp-Source: ABdhPJxUXXXgJMFRI9avsCMLkEs0eKS2r5rCEsC4DcQm9gjKQZO2bQl/XiEdt6JpSu4zT5a4hJg577BHrD0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1c8f:: with SMTP id
 oo15mr7460001pjb.125.1642640858187; Wed, 19 Jan 2022 17:07:38 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 20 Jan 2022 01:07:19 +0000
In-Reply-To: <20220120010719.711476-1-seanjc@google.com>
Message-Id: <20220120010719.711476-10-seanjc@google.com>
Mime-Version: 1.0
References: <20220120010719.711476-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH 9/9] KVM: SVM: Don't kill SEV guest if SMAP erratum triggers
 in usermode
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Liam Merwick <liam.merwick@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Inject a #GP instead of synthesizing triple fault to try to avoid killing
the guest if emulation of an SEV guest fails due to encountering the SMAP
erratum.  The injected #GP may still be fatal to the guest, e.g. if the
userspace process is providing critical functionality, but KVM should
make every attempt to keep the guest alive.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a4b02a6217fd..88f5bbb0e6a1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4357,7 +4357,21 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
 	is_user = svm_get_cpl(vcpu) == 3;
 	if (smap && (!smep || is_user)) {
 		pr_err_ratelimited("KVM: SEV Guest triggered AMD Erratum 1096\n");
-		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+
+		/*
+		 * If the fault occurred in userspace, arbitrarily inject #GP
+		 * to avoid killing the guest and to hopefully avoid confusing
+		 * the guest kernel too much, e.g. injecting #PF would not be
+		 * coherent with respect to the guest's page tables.  Request
+		 * triple fault if the fault occurred in the kernel as there's
+		 * no fault that KVM can inject without confusing the guest.
+		 * In practice, the triple fault is moot as no sane SEV kernel
+		 * will execute from user memory while also running with SMAP=1.
+		 */
+		if (is_user)
+			kvm_inject_gp(vcpu, 0);
+		else
+			kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 	}
 
 resume_guest:
-- 
2.34.1.703.g22d0c6ccf7-goog

