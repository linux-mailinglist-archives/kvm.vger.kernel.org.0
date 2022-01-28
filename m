Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB33449F006
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 01:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344947AbiA1Axv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 19:53:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344952AbiA1Axj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 19:53:39 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147CDC06175E
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:26 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id e7-20020a17090ac20700b001b586e65885so5237853pjt.1
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=2j8iaEuz/tIBAA+GjS6JoDFbk1lAQCK3PPm1k48P+4I=;
        b=KVG8nNQ2+1dkTL7ilZT+29OjKphirmaq4NpKKPehEmteGNFicoJYOBq29I2w/xr/Jc
         9UbTOOCLG4KTUB/3N1j4my19D7mP5FI6R+mBy24DFK/8RmzIdfDoro785nmzMWUPwCet
         fSgVLWCMxCSowuxI3Uyws0D4mBNIUGmgHVSFGFnohvYZCsQw38q9Bb1fJgSR/4fb67c/
         JmuVAf/Hcft984rBeKzO9z9qcE2HrSP+PKqh2TBiUPz3xHhtHwYKWkeYAvKXtphqeaTH
         t13kFtEmFdwGimVQNlqBC1PQVbuBdSmxgYIGtRIgoGjpTCVhsWDTzEzEy9FOj7xZja2z
         tACg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=2j8iaEuz/tIBAA+GjS6JoDFbk1lAQCK3PPm1k48P+4I=;
        b=U2MZRu1dVqkqcZFH1D/3cZVSxwbfcPeVPUE0ntycn8ssU0a2vx4ZtitPFaJtX13jrz
         q5Kk9aN1+BTLW410HbijYmvBspGe+oWv1FpIDIapKdQFzV8YG1IEYkV7EqAfyeh+EJVB
         dJlINftcKiAIlwx+yWSTUWZhf3wPC1XN9u+GWgZJ/NVsSfFQkvF+uFcGahKjRWL7e9M5
         +BgsaruDy9tRZ2WnttwPZNZi5p4ZuWUis0vc/lXKxlzJqtY7Q8RpGoP8oUP7qIJ4K8Zb
         MlWiBuqGgFBwmUeIQpNf71WmklXX8XbXsKz7SQ1ujAqwidLi/v7WDxoMvcPY02Dr0Gqw
         YJvQ==
X-Gm-Message-State: AOAM531yiNG4JBeb2bQMJpZsxUqK4ktJEBymsTxQG0zUCXC1kCozqNsp
        so62MyFnO2trlfmRs/qgD/48XrtQMgo=
X-Google-Smtp-Source: ABdhPJxEBzacSqFLF93miUHudGeoua8Whi1PUfT85tGo4RFFXXAaVXJGHBB0mgwvLwUa1HKa82wdKXGahlY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4a47:: with SMTP id
 lb7mr17068491pjb.58.1643331205595; Thu, 27 Jan 2022 16:53:25 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jan 2022 00:51:53 +0000
In-Reply-To: <20220128005208.4008533-1-seanjc@google.com>
Message-Id: <20220128005208.4008533-8-seanjc@google.com>
Mime-Version: 1.0
References: <20220128005208.4008533-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH 07/22] KVM: xen: Use static_call() for invoking kvm_x86_ops hooks
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use static_call() for invoking kvm_x86_ops function that already have a
defined static call, mostly as a step toward having _all_ calls to
kvm_x86_ops route through a static_call() in order to simplify auditing,
e.g. via grep, that all functions have an entry in kvm-x86-ops.h, but
also because there's no reason not to use a static_call().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/xen.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index bad57535fad0..419bae180930 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -695,7 +695,7 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
 		instructions[0] = 0xb8;
 
 		/* vmcall / vmmcall */
-		kvm_x86_ops.patch_hypercall(vcpu, instructions + 5);
+		static_call(kvm_x86_patch_hypercall)(vcpu, instructions + 5);
 
 		/* ret */
 		instructions[8] = 0xc3;
@@ -830,7 +830,7 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
 	vcpu->run->exit_reason = KVM_EXIT_XEN;
 	vcpu->run->xen.type = KVM_EXIT_XEN_HCALL;
 	vcpu->run->xen.u.hcall.longmode = longmode;
-	vcpu->run->xen.u.hcall.cpl = kvm_x86_ops.get_cpl(vcpu);
+	vcpu->run->xen.u.hcall.cpl = static_call(kvm_x86_get_cpl)(vcpu);
 	vcpu->run->xen.u.hcall.input = input;
 	vcpu->run->xen.u.hcall.params[0] = params[0];
 	vcpu->run->xen.u.hcall.params[1] = params[1];
-- 
2.35.0.rc0.227.g00780c9af4-goog

