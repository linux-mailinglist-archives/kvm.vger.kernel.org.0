Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6ED0300DB8
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 21:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730427AbhAVU3J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 15:29:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729851AbhAVU0Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jan 2021 15:26:25 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE298C061220
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 12:22:14 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id l3so6606806ybl.17
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 12:22:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ut/T6G9w71CC8HxNYO0u5RfiusnblVieh7wlxdxSOrI=;
        b=ZtWeshgPgZFT5yQIvxcM8SgjVvKSYldmaFOWVPWpa7cHVfKH1Vif6eY40k2Y5/9f4O
         ljrfJkzqfwvROg9IjLCwTTabk8eO35wsFAsljC7ZijOOcj2LI4ITfI2RKNxwu26GbK+J
         CEw64JAKIanQZE5O9DA4kgHRinl8/thJ66tv8mtj6J6rePNXHvhIrvNjMDhOVTgII4V8
         Wjy3gRo1RA2DLb3adHTd2KOaKhlc9a87qK3huJXbGsvZzTVfbKzMpf7+6RxADg7x3YUm
         WzNT7nYS5herjV4J3KXpLDxeNMKUzf8q8iFG8X0+OYpF52eFKqg6uw3NC9jFqoRTZQU0
         NGTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ut/T6G9w71CC8HxNYO0u5RfiusnblVieh7wlxdxSOrI=;
        b=Ale71Zpvo4uTg916o5HHBEz66ExCxyoWTYBt+aa1Hq9tqRjujUk7ydB32AwmueakZW
         TdapNyxaKnEeYmNLaLWZALL8UUvFaqgsTeG4cJm/FqXgPIs6Hx1pXAxu+j2pey1KGPmz
         XDPjwNf0BOpL7ugPltVwtBhhiJIq2oR3oZ1qEOqQ7LagWEoftWBvZ4uUZ0GjsjGW7LNd
         q2cKrHOz0TLC/szNy/+CstalYBzTSiCAI1LBHlcgzLNifEmnMr0rcf3zXmCdKwapAmv1
         LzwGlmjNAvZgnHsmjamtd3nLxGlK0K5h3QY5ut68MVzAu6bfX+c2nyMisNZ82XN3HIoo
         +Apg==
X-Gm-Message-State: AOAM533fZG4/N5jCS8eefs+2nhmrvQa8JTAIYDPVymFHTkmdTGZcEw0d
        i1TPvGKS8sG2QssAKT0N/HtJegAhj94=
X-Google-Smtp-Source: ABdhPJzU0vWM6wYGFiAUoIChr7p55Yc7uqfLcyX3pxdBDck5MZeamqNODJnRxoFV+aaIRs66gnd9KswWCuo=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a05:6902:701:: with SMTP id
 k1mr8686405ybt.342.1611346934044; Fri, 22 Jan 2021 12:22:14 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 22 Jan 2021 12:21:40 -0800
In-Reply-To: <20210122202144.2756381-1-seanjc@google.com>
Message-Id: <20210122202144.2756381-10-seanjc@google.com>
Mime-Version: 1.0
References: <20210122202144.2756381-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
Subject: [PATCH v3 09/13] KVM: SVM: Explicitly check max SEV ASID during sev_hardware_setup()
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

Query max_sev_asid directly after setting it instead of bouncing through
its wrapper, svm_sev_enabled().  Using the wrapper is unnecessary
obfuscation.

No functional change intended.

Reviewed by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 75a83e2a8a89..0c69de022614 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1278,8 +1278,7 @@ void __init sev_hardware_setup(void)
 
 	/* Maximum number of encrypted guests supported simultaneously */
 	max_sev_asid = ecx;
-
-	if (!svm_sev_enabled())
+	if (!max_sev_asid)
 		goto out;
 
 	/* Minimum ASID value that should be used for SEV guest */
-- 
2.30.0.280.ga3ce27912f-goog

