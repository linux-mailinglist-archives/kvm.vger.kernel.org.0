Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F533101F2
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 02:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbhBEA72 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 19:59:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232417AbhBEA7N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 19:59:13 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B175C061226
        for <kvm@vger.kernel.org>; Thu,  4 Feb 2021 16:58:18 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id c12so5124329ybf.1
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 16:58:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=zhnkOXEYGGvZNVp7PlqQHShfXtqu89TjnS07HxN7000=;
        b=v3xY0+AjayzfDFJ4rhW4ndqao6mYOCSrmtDqP4z1GkiyskXCgiyk6yJRsuOvemh0ie
         ipmt4heAlIsTksA9NwG9WaiyaL9WsbsGhzfNGYk3EVXhOz+GmikrlGoEUjdzcHjt4SUa
         /WkRCHyWubIU9033YXbJD5jQzCSeF6AfiS1hE9L27brH9fTndB91IqZAfQb8rb6IGm4l
         NjDWwPBuU3mhtb8wpAfvUhyD/YuqL69Cz65mm34ruJxmzlIR/FK+mSNTim0P1g01A3B9
         WGaQPRp/3SYZCQrSMJFK1MTtu5St6gVgsoVyUUXXYoDr9/KCxyfNnv/mBrn+IKoWEbv7
         inrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=zhnkOXEYGGvZNVp7PlqQHShfXtqu89TjnS07HxN7000=;
        b=e5j2rWCknMvx+ihbUqy55BLwv5e2IzQ4zrj9d8Jb/0xlL5iX8CYMNtTdX1VTPCLcUS
         gM9kUtwg8LxJYs82O/SUB/C/tDeHYoi7rTs/0dVPKdhQw5VuXYGitwJvEeqVX4n1eIzV
         sW4ACPJuDQwbTgM54LJ3aGiRe9MrOK4fdKZ3LoQkoT1wP2Hw9quuSijbeEyNOf9I0QuJ
         xF061Bvjlx+5o4nVrkuxjduNAIOp0I5qwhsDA/H3/00oLVN0b/9EcNgQLRq0wmZiTMIY
         ICdM2eyXJM0rfeDHR449qCWXdQ9MjIEnulgzGPTkiqdfVD+zHSuathVyebkUJcyqXByZ
         n6kQ==
X-Gm-Message-State: AOAM530bgiJn6wAS7fprK/zTlj5QdoNjj3ufP3Mm2JytyZkUM9zWU0NF
        Mq8plUSGiWyPHqaW1ejNGFqs1wp03iY=
X-Google-Smtp-Source: ABdhPJyeJYXLD3wzMkPJBW4dn66bVJC7SUnrMv/p/lsj3Jmxge7QxalGkueRPMcLh9Tn5k4m+31mhhKm+28=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:f16f:a28e:552e:abea])
 (user=seanjc job=sendgmr) by 2002:a25:d150:: with SMTP id i77mr3127408ybg.55.1612486697624;
 Thu, 04 Feb 2021 16:58:17 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Feb 2021 16:57:50 -0800
In-Reply-To: <20210205005750.3841462-1-seanjc@google.com>
Message-Id: <20210205005750.3841462-10-seanjc@google.com>
Mime-Version: 1.0
References: <20210205005750.3841462-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH 9/9] KVM: SVM: Skip intercepted PAUSE instructions after emulation
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jiri Kosina <trivial@kernel.org>
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

Skip PAUSE after interception to avoid unnecessarily re-executing the
instruction in the guest, e.g. after regaining control post-yield.
This is a benign bug as KVM disables PAUSE interception if filtering is
off, including the case where pause_filter_count is set to zero.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b6acc73d356a..ac634b9eba8a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2992,7 +2992,7 @@ static int pause_interception(struct kvm_vcpu *vcpu)
 		grow_ple_window(vcpu);
 
 	kvm_vcpu_on_spin(vcpu, in_kernel);
-	return 1;
+	return kvm_skip_emulated_instruction(vcpu);
 }
 
 static int invpcid_interception(struct kvm_vcpu *vcpu)
-- 
2.30.0.365.g02bc693789-goog

