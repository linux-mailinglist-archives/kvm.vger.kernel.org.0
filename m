Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50B142B105
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 02:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236301AbhJMAiF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 20:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236211AbhJMAiE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 20:38:04 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2767C061753
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 17:36:01 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id i83-20020a252256000000b005b67a878f56so1303504ybi.17
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 17:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Ur67iQAkeqlRv9mxlrBpPoT3NcIyXRW0G2yRaXW02qI=;
        b=YQb07mKwbr10fxF1UcmqI8DkNWqLkuUT8+dr7LjyhpZWTEOoHprPTHMmj3jOM12koF
         MMZyob7gLPEMkHDhLf57f6ema1WkqYfzC21l1e43H0/BEZLBRBEZ97oNnm2dxMmGTO0f
         xE6ueSmqND2eTuG8v6GCgcYtUaVlcV9RlU+//0H6XzYcfixD6/ucFB29reqLxtICxhfw
         KdZCazoo0k6UpIcd8VAlphTXfN2vrejL9VN5iHtMSPtXEP98v3QZExK9QNvjSK3R1jv2
         2Y9t8/0W+wodMYX13lUrJKl4Dj0f1YQ5HkNJSC+uud5kwU0yY7xClY4ymwhQnu+8ZnNZ
         3D2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Ur67iQAkeqlRv9mxlrBpPoT3NcIyXRW0G2yRaXW02qI=;
        b=gGUZudPBuzlFyqY0jFF0LnCgHYRabSq7DITcBfksWj0OsHYDMMee5IOzWTTmMMnOZr
         hmyEDKstMHYsus+FxScuwQaEFQWusm/1nIoVL3fLNvZhkrt5AHv3ad9dzgX8HpRcKfcu
         EH1iT7RgmeLV/Yfb8r5iBgag8pCjFAOLkHOpt03IZ2IGVtqbImJePaXRlIsXtaDyItoY
         hl0j8AI0gTR3+4wkLS3KdARSobqysuZnlhmZhjpGjzk0sDkUsljvK8Dnf4HBfkorncyN
         IyE1bRR6IhmeFzMLphl69wBqNvyA8mncUELwS1OrybhzNQzpmAyntUNUvaKFd6XrKYTT
         5zdw==
X-Gm-Message-State: AOAM533PaY3Oak3dVVAn+hyPecHVlYWIwE6OwAkl9Q6CNpnZnUGbT3LZ
        KRH8gbOkYcOf/Skhv+UvkOlmrKeMkaE=
X-Google-Smtp-Source: ABdhPJwyy6oF7ZIdto6mAUgPKZ9Rf90ti6UzVqI00XsbG6KKN2g13iSOxOmNQN3UqJRmHAtAxsNKnvp0LMY=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e55e:31ed:7b83:d4a6])
 (user=seanjc job=sendgmr) by 2002:a25:d3d2:: with SMTP id e201mr30426257ybf.260.1634085360999;
 Tue, 12 Oct 2021 17:36:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 12 Oct 2021 17:35:54 -0700
In-Reply-To: <20211013003554.47705-1-seanjc@google.com>
Message-Id: <20211013003554.47705-3-seanjc@google.com>
Mime-Version: 1.0
References: <20211013003554.47705-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH 2/2] KVM: x86: WARN if APIC HW/SW disable static keys are
 non-zero on unload
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+9fc046ab2b0cf295a063@syzkaller.appspotmail.com,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

WARN if the static keys used to track if any vCPU has disabled its APIC
are left elevated at module exit.  Unlike the underflow case, nothing in
the static key infrastructure will complain if a key is left elevated,
and because an elevated key only affects performance, nothing in KVM will
fail if either ey is improperly incremented.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 7af25304bda9..d6ac32f3f650 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2946,5 +2946,7 @@ int kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 void kvm_lapic_exit(void)
 {
 	static_key_deferred_flush(&apic_hw_disabled);
+	WARN_ON(static_branch_unlikely(&apic_hw_disabled.key));
 	static_key_deferred_flush(&apic_sw_disabled);
+	WARN_ON(static_branch_unlikely(&apic_sw_disabled.key));
 }
-- 
2.33.0.1079.g6e70778dc9-goog

