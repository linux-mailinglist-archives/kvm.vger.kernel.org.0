Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7E43B23C7
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 01:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhFWXId (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 19:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbhFWXIa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 19:08:30 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0169C061756
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 16:06:10 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id 12-20020a05621420ecb02902766cc25115so4720339qvk.1
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 16:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ECxHPd8ARt3g/FbXO6kaB2YAiLV+c0qQVpIxsjvN8ho=;
        b=sEtH99jwiQ93AFFZ+4qGZKG6dGPffpY3n63kic4KqeOVt+fqR+Uuaqjvl2aPaOs5LV
         +kAOO2CbASDeHPRmOqt/NzKURFkBm6luGWNTqkWADfEsQKkEDyk/v4fPH7zLfREIo8nS
         VlR9OensOnYHTVVaqLwGXPkGTdFY8ZsdPz0jRF0dSt11MlKK5XBqT0yKVrJBErLszjD5
         l+tQEpYQELkuyN5LBtOKNsJ0S8HEGlQW1ZbIYrCKYdUA81ANlFmwvgmxlj/FPUs38ywk
         xHkha3JfyoMkZ93y5B7uADrAJtxUP/QrRQ5h9Q0ljV3nO7y3rKi7Ud8kNpOiz/xLIRQF
         dqjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ECxHPd8ARt3g/FbXO6kaB2YAiLV+c0qQVpIxsjvN8ho=;
        b=ELCSwdKwqnCW3A8GuJZcOHGaubWuxyh7SHk3GXoZYQ98im9fjKuOyozj5QD1yUpzjU
         hfzO3AK9AQy7DtGpSEVcWaFlYR/q0G23DPM0Mh2/go5fulwmcCSRYmtW/SXAdZW7+2hv
         Ch8xA5Esrtmb2skhKi0YLHTAEhiuVOod3ddWMunk2Wcxliclqk7Y24o7Aem6vUGTzoQO
         cE+vub468dL45fWH4h/67Cbb1S+M0JD6isiJhWD3Pe3jnz0LcXDPo8KkYzg5veQ3zHv9
         Hrd2ZSGCecLAW0gY2sVp7KsnP2E7Yhkd96tRyxarUKAWMlesCcEYnvq+5txUrpympSbI
         7Xlg==
X-Gm-Message-State: AOAM531fZdI9w1xTycWmrCzBZLv9Ktuc9t24LVc4r9T4PG1HXAqFUvve
        ZBosXb49KkNlpbQVR+6cKoGBcOBVWzg=
X-Google-Smtp-Source: ABdhPJwGGkYrzt9VXDp9VVzM6DTgXp7pCLDTPfh12+pCsTsoR+0WhHJK2RbX/l1BTJ0xgBwdpzwy9aOHv2Q=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e9e:5b86:b4f2:e3c9])
 (user=seanjc job=sendgmr) by 2002:a05:6902:522:: with SMTP id
 y2mr730525ybs.12.1624489569847; Wed, 23 Jun 2021 16:06:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 23 Jun 2021 16:05:50 -0700
In-Reply-To: <20210623230552.4027702-1-seanjc@google.com>
Message-Id: <20210623230552.4027702-6-seanjc@google.com>
Mime-Version: 1.0
References: <20210623230552.4027702-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 5/7] KVM: VMX: Refactor 32-bit PSE PT creation to avoid using
 MMU macro
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Compute the number of PTEs to be filled for the 32-bit PSE page tables
using the page size and the size of each entry.  While using the MMU's
PT32_ENT_PER_PAGE macro is arguably better in isolation, removing VMX's
usage will allow a future namespacing cleanup to move the guest page
table macros into paging_tmpl.h, out of the reach of code that isn't
directly related to shadow paging.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ab6f682645d7..f6fa922ca6e3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3584,7 +3584,7 @@ static int init_rmode_identity_map(struct kvm *kvm)
 	}
 
 	/* Set up identity-mapping pagetable for EPT in real mode */
-	for (i = 0; i < PT32_ENT_PER_PAGE; i++) {
+	for (i = 0; i < (PAGE_SIZE / sizeof(tmp)); i++) {
 		tmp = (i << 22) + (_PAGE_PRESENT | _PAGE_RW | _PAGE_USER |
 			_PAGE_ACCESSED | _PAGE_DIRTY | _PAGE_PSE);
 		if (__copy_to_user(uaddr + i * sizeof(tmp), &tmp, sizeof(tmp))) {
-- 
2.32.0.288.g62a8d224e6-goog

