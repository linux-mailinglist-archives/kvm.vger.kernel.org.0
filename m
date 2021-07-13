Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3129F3C74A6
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233371AbhGMQgh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233268AbhGMQgf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 12:36:35 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD990C0613EE
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:33:44 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id x84-20020a2531570000b029055d47682463so26320035ybx.5
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=AGAjMyxP8Kz+nybtWUECIkFt/HGEOoMESc1mkCwzAiw=;
        b=UCQx6DBF7jZuuIBk/LPOaIgpig7BPufPBP1HccKEpPWjOVUUq2+vOZCpyk45K55qfp
         IkuPgFkVYU4NmkVbDXfrYp/H5AaJ7Z+DcRzUrLSCLZfOnxLnPUj08XVdXKqz8sAuYuuf
         Q8/+nsvzS7H9XvNpXs5ViM+41tnfVgbpU7l+P7tno+mb1Uo26SRvha9xzM2KvWSW5L8C
         ndiUikKd7/v8Flub24h2PE485cDvfS5vRnYIzDM16YMR/fFrJlaGPWFStEhUGkvp1HUh
         xAPbEHG9+4CH0XASSTBS4FdMeBpMtV/mPuAaWrm4G/rUytfIQOlUEle9k2NlpI/ojg0A
         U70g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=AGAjMyxP8Kz+nybtWUECIkFt/HGEOoMESc1mkCwzAiw=;
        b=XbY0YBffQoJQ7s7iLc9UWAi0idvMEVMOZ3LL3ZPl3rxyDfKZU4kxCWOiDDY9Ln/jFR
         bkIaSkaqUXQIucZUDG4CKkF7Cyhle3uaXqrSOTdM6GKFcblQUqdjJT9QFbM+2bbj9QTp
         RK84aucnI5Q1fFMEeTVeaCIfKD++Wwc7CIxSNpOddvazk3vuKyUvsSieWD0sBFsH1V/6
         OanY3viH1ENhAja4chLpTzhCaqOShw2/E0HKI/2gHsjNXe8jzgVbFswv8PjsRmQZwsL8
         vXvSQa1OfR3r5Do5l92wxc5W17WcZKL8bMfJrPfznDyFS5E4we+JsRGsNWdtPoHtYnju
         D3LA==
X-Gm-Message-State: AOAM532TQSURsg7bWyl8x4QS5MprHt8CddDGWlhNkfKi/v5vOkyd4IoS
        e8i/OzIOPudlgrCzyMV2+lI3YmwoRPM=
X-Google-Smtp-Source: ABdhPJyfcF3/EzRv4tHswNTrHoKijaTLQxcVLSWE/9QuBQ3MsAO9+Y4R2BDk6XtS3whc0LgFUVxHhUHC310=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:825e:11a1:364b:8109])
 (user=seanjc job=sendgmr) by 2002:a25:b55:: with SMTP id 82mr6710404ybl.501.1626194024052;
 Tue, 13 Jul 2021 09:33:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jul 2021 09:32:43 -0700
In-Reply-To: <20210713163324.627647-1-seanjc@google.com>
Message-Id: <20210713163324.627647-6-seanjc@google.com>
Mime-Version: 1.0
References: <20210713163324.627647-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 05/46] KVM: SVM: Require exact CPUID.0x1 match when
 stuffing EDX at INIT
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Do not allow an inexact CPUID "match" when querying the guest's CPUID.0x1
to stuff EDX during INIT.  In the common case, where the guest CPU model
is an AMD variant, allowing an inexact match is a nop since KVM doesn't
emulate Intel's goofy "out-of-range" logic for AMD and Hygon.  If the
vCPU model happens to be an Intel variant, an inexact match is possible
if and only if the max CPUID leaf is precisely '0'. Aside from the fact
that there's probably no CPU in existence with a single CPUID leaf, if
the max CPUID leaf is '0', that means that CPUID.0.EAX is '0', and thus
an inexact match for CPUID.0x1.EAX will also yield '0'.

So, with lots of twisty logic, no functional change intended.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2150642e1bef..12e49dc16efe 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1359,7 +1359,7 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	}
 	init_vmcb(vcpu);
 
-	kvm_cpuid(vcpu, &eax, &dummy, &dummy, &dummy, false);
+	kvm_cpuid(vcpu, &eax, &dummy, &dummy, &dummy, true);
 	kvm_rdx_write(vcpu, eax);
 
 	if (kvm_vcpu_apicv_active(vcpu) && !init_event)
-- 
2.32.0.93.g670b81a890-goog

