Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8357B3EFA33
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 07:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237855AbhHRFjx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 01:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237812AbhHRFjv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 01:39:51 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D424C061764
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 22:39:17 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id l85-20020a252558000000b0059537cd6aceso1689447ybl.16
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 22:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=WiP9HgfFffnWMWhcvdLBuLUWs2FAICpYV6zjCSodstc=;
        b=P5d31hh5vOF8UCVyLfij5pHCgatyTEnprnjz48lUR/QQ2E7SfxSMCwblt2FHfkDfo+
         QSTLLUyH2TsfavUcqw89bJCByn9dSp8QrIJxkxVd/lwTZKdD+Y7rjveCSbf4fztCUgca
         npdHNANe1QbR/obju31jRjMyELrgc+v+IVAcgLdFrOwN6l7zLtgE1GNTuzzf05W1bvDF
         fY0P4AHor6om6MtzOJuA8e9uQXFTQ8nkXU8FDTfNz7TLrUR9tSUNc6HmgsAiJiEwXxco
         FUPgbFeE5chpzWIuA+rznzFGsXVr1DdfILy3hnU6fUj3oehSHDHqN0nxyiH5Phmx2WSN
         oC0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=WiP9HgfFffnWMWhcvdLBuLUWs2FAICpYV6zjCSodstc=;
        b=HBGSUiyADX++zgdiVLxNwCoQ9myedcMp3Lkm8oFADj594P6MSH9ZeUxwcaSu1C7NG+
         +zHDQUmH/Q9YJ3mEF6Hh2b3MtC4L9b54qoRGzlmp1XBwInZK1xZPrc1NQkcxSfbuaeFd
         yuYbKy9FKDY12QT2db/mbP6TJ2wTKtOYFgWBp/Ukg702D7NRzL9ZdiXZqNoQ4PJ/3xJ+
         7FeSoLEo8amLN8GSkacmGvvWAJtnVsAIUQmvByg2k1dl4iLCAnj5a2z72RKMoMv+idne
         dr8b04UGw89WjPwMFQVEZmFjEuKCflBN4a9/F8B4/98k0FuYn8OsQ7mQ2WEDepm+t9AB
         /gDg==
X-Gm-Message-State: AOAM5316Z0mHOD9DkZd457jqEV6AAKlCbkTSD70S2i5Nm/+xuvG6HJ1E
        9PWzrM9X+j5InY4CAeqQ0VlkxQjqqT3J
X-Google-Smtp-Source: ABdhPJxCFOFGuoTsOROSCJ1NTKokiUsMORo0yKzUHyO06VSofqt1ILBv+0YQgs0T5mNF+jmcqNxoJCGbjPnJ
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a5b:7c4:: with SMTP id t4mr9212584ybq.509.1629265156833;
 Tue, 17 Aug 2021 22:39:16 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Wed, 18 Aug 2021 05:39:05 +0000
In-Reply-To: <20210818053908.1907051-1-mizhang@google.com>
Message-Id: <20210818053908.1907051-2-mizhang@google.com>
Mime-Version: 1.0
References: <20210818053908.1907051-1-mizhang@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v2 1/4] KVM: SVM: fix missing sev_decommission in sev_receive_start
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alper Gun <alpergun@google.com>,
        Borislav Petkov <bp@alien8.de>,
        David Rienjes <rientjes@google.com>,
        Marc Orr <marcorr@google.com>, Peter Gonda <pgonda@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

sev_decommission is needed in the error path of sev_bind_asid. The purpose
of this function is to clear the firmware context. Missing this step may
cause subsequent SEV launch failures.

Although missing sev_decommission issue has previously been found and was
fixed in sev_launch_start function. It is supposed to be fixed on all
scenarios where a firmware context needs to be freed. According to the AMD
SEV API v0.24 Section 1.3.3:

"The RECEIVE_START command is the only command other than the LAUNCH_START
command that generates a new guest context and guest handle."

The above indicates that RECEIVE_START command also requires calling
sev_decommission if ASID binding fails after RECEIVE_START succeeds.

So add the sev_decommission function in sev_receive_start.

Cc: Alper Gun <alpergun@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: David Rienjes <rientjes@google.com>
Cc: Marc Orr <marcorr@google.com>
Cc: John Allen <john.allen@amd.com>
Cc: Peter Gonda <pgonda@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vipin Sharma <vipinsh@google.com>

Fixes: af43cbbf954b ("KVM: SVM: Add support for KVM_SEV_RECEIVE_START command")
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/svm/sev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 75e0b21ad07c..55d8b9c933c3 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1397,8 +1397,10 @@ static int sev_receive_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	/* Bind ASID to this guest */
 	ret = sev_bind_asid(kvm, start.handle, error);
-	if (ret)
+	if (ret) {
+		sev_decommission(start.handle);
 		goto e_free_session;
+	}
 
 	params.handle = start.handle;
 	if (copy_to_user((void __user *)(uintptr_t)argp->data,
-- 
2.33.0.rc1.237.g0d66db33f3-goog

