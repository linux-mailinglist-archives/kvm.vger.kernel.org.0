Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCC832F2AD
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 19:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbhCESfY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 13:35:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhCESbw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 13:31:52 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C357CC061574
        for <kvm@vger.kernel.org>; Fri,  5 Mar 2021 10:31:52 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id y7so3333238ybh.20
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 10:31:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=VJQbdhbCWyNk4Q85Oh9qgYOeUZXmpotWEbehzwgzXvA=;
        b=tpcTqy0NmGqO15Oj70zENzNSj2GWhEUMFj4hFwqOjkZwT+4+qtw4ahDONdmhqYAyCZ
         mOiIVvss7585J72kdpTDQSCCUFxa94tFXNEnuuk8K5x6ToOwvX4fhaBt/+C03Pqzcjx5
         zUHUz7S7UDzMisaw5izb/WkZifGVDlVfb+msPrM32ydHOLCAgcW/u++kFxQnM+J60OT4
         aS/nnZp9uN/uIUY6WqpVrPh7/I6vUb8+/dblyuaAM5iguQCvJU+qDz2RU4hGqQt4N1DU
         y7pBpWz3AwtUa5w7Po4cOjywIEx+za/Id29wZ4zrt2u31V4zi83jik3LkTpAdXEuM49m
         1FRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=VJQbdhbCWyNk4Q85Oh9qgYOeUZXmpotWEbehzwgzXvA=;
        b=kYbFiWG+wuN/VjevVCbF3+Tc8Nb17rY9BVtI/Y83TzCqu5dpHwe/kwoMbgxraNZskn
         Tlb80bNK36E+JlkJXob2Os+NIe7efv3fIT6n7Tkm0kw3ixrxnJddzhT0LQkqnXyTONSE
         rb5NTKQUpJKYSdGmgKHd1GBfsM2zSeW04fbPSDHSgYdsS+NcIux7SK94fQWgEfAhaeKS
         YdT/NQFPghRGtbs3vGHpX+nLL6aMjHhNzwq2EPIl+A0XQzVQiwfL72RsFSKoTliQJ5i6
         Y4QNFJbmC8oEmcyd/HuNf6oV0MQ7kEfMYciz+fYit8yUTjXE0MLz2uCTFDW8HWY92Imc
         6oyw==
X-Gm-Message-State: AOAM531RY+ogZbSP5jsVVyjNXX2peggwaiidfa3AGpmIpxEWOmegurOL
        pyGv5j6ilOSHsxD9bRIirv2wOwc5cCg=
X-Google-Smtp-Source: ABdhPJy2oVGL1F/enUJcmeJKH8KtY1MgerK3ptc1eh7T8ht+g7Fgpuv3AMeMcmd3+9aJmwQOAIx825UbtRI=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
 (user=seanjc job=sendgmr) by 2002:a25:2cce:: with SMTP id s197mr15752377ybs.88.1614969112047;
 Fri, 05 Mar 2021 10:31:52 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  5 Mar 2021 10:31:22 -0800
In-Reply-To: <20210305183123.3978098-1-seanjc@google.com>
Message-Id: <20210305183123.3978098-11-seanjc@google.com>
Mime-Version: 1.0
References: <20210305183123.3978098-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 10/11] KVM: VMX: Skip additional Hyper-V TLB EPTP flushes
 if one fails
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Skip additional EPTP flushes if one fails when processing EPTPs for
Hyper-V's paravirt TLB flushing.  If _any_ flush fails, KVM falls back
to a full global flush, i.e. additional flushes are unnecessary (and
will likely fail anyways).

Continue processing the loop unless a mismatch was already detected,
e.g. to handle the case where the first flush fails and there is a
yet-to-be-detected mismatch.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 78bda73173d2..720dcfe2a57d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -528,7 +528,15 @@ static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
 			if (++nr_unique_valid_eptps == 1)
 				kvm_vmx->hv_tlb_eptp = tmp_eptp;
 
-			ret |= hv_remote_flush_eptp(tmp_eptp, range);
+			if (!ret)
+				ret = hv_remote_flush_eptp(tmp_eptp, range);
+
+			/*
+			 * Stop processing EPTPs if a failure occurred and
+			 * there is already a detected EPTP mismatch.
+			 */
+			if (ret && nr_unique_valid_eptps > 1)
+				break;
 		}
 
 		/*
-- 
2.30.1.766.gb4fecdf3b7-goog

