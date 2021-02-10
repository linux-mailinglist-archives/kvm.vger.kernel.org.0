Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2599316EAC
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 19:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233326AbhBJSaM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 13:30:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234195AbhBJS1w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 13:27:52 -0500
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624DBC0617AB
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 10:26:24 -0800 (PST)
Received: by mail-qv1-xf4a.google.com with SMTP id h13so2069056qvo.18
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 10:26:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=QyQE3EdrqBvyx/EpOPhJj5SBwQHKK6yPydf0zBuWnjI=;
        b=IZQDi86ZCM/UWeCQWeODOWfhtsGqzS5/TOXfadVuSw6WuPvR8j13JDMi2i0sh6vESF
         IqAhmzewaORsdMThrJ9fVlCP/yep47VjEFXUTMJkhK3r5Zhwv9A+tQqr8bRCa6hFjoZM
         G6SefOgNDG7bNlOY/Ue9Xivk/y6AZ7JJaBjyb9xm4HX+7ZRA5hWsHdjBaSM0URW9ku1e
         RWbeGJiqdnlT/vqcmw92OFOT8xxDu3+SSOlnov4hDv0Ty3iqzSpRTVFcgHDlKhmjmtce
         k1t/pP2AKolsdY9WIZZeEPTVi9Pb8oAnwhUhWG21frgllQ/vS9giudZ10Ft7+UaJbgf0
         cheQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=QyQE3EdrqBvyx/EpOPhJj5SBwQHKK6yPydf0zBuWnjI=;
        b=qgj4KpIscJaqt0LnOPKPc3BjPk+Z+EHHjY/dEKXkexJMVQMSRVab6n3IMqaMWBEEli
         T77bo3/JIwKQRAqSsX8H6nY9KY0DHvuABv7EPByXOySG93RYqsWlLJiTBhKYnuYAS2Yr
         Kj2nnb0sb9ryATwzRuClw8xc2R5rLPo7MLPoQMHAF1OJZUtmAJFbqndiRcYviwyEpida
         crWkTPIVU1Ej1ToRyDMOr3spD9nEGpYpoIBznd7EtWjxX6B+qxBGh4vMd5WRuyz6dhcK
         dukSZ/R04V4Wu+pE/6wPOwGrIhx5TJ8izajDPlr6tjEXPZTGZLjlWjrZslsjhuuStxAV
         jmrA==
X-Gm-Message-State: AOAM530lkRps37TS/bbNSPb37+NT8AirwXwZz/Po+pKCVihuUGpF+o6Z
        PNEM0MkctpxPJ5rM7JLxw8RrEjER49s=
X-Google-Smtp-Source: ABdhPJz4sOmQy0NThSlPmmMSaR5smiCWwLuIHxk9+mbZKXuUI0AT3Lq++1jU3lJsPrUA7M5PBCzKczekcuE=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:11fc:33d:bf1:4cb8])
 (user=seanjc job=sendgmr) by 2002:a0c:bd93:: with SMTP id n19mr4048142qvg.5.1612981583481;
 Wed, 10 Feb 2021 10:26:23 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 10 Feb 2021 10:26:08 -0800
In-Reply-To: <20210210182609.435200-1-seanjc@google.com>
Message-Id: <20210210182609.435200-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210210182609.435200-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH 4/5] KVM: sefltests: Don't bother mapping GVA for Xen shinfo test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't bother mapping the Xen shinfo pages into the guest, they don't need
to be accessed using the GVAs and passing a define with "GPA" in the name
to addr_gva2hpa() is confusing.

Cc: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index b2a3be9eba8e..9246ea310587 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -80,7 +80,6 @@ int main(int argc, char *argv[])
 	/* Map a region for the shared_info page */
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
 				    SHINFO_REGION_GPA, SHINFO_REGION_SLOT, 2, 0);
-	virt_map(vm, SHINFO_REGION_GPA, SHINFO_REGION_GPA, 2, 0);
 
 	struct kvm_xen_hvm_config hvmc = {
 		.flags = KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL,
@@ -147,9 +146,9 @@ int main(int argc, char *argv[])
 	struct pvclock_wall_clock *wc;
 	struct pvclock_vcpu_time_info *ti, *ti2;
 
-	wc = addr_gva2hva(vm, SHINFO_REGION_GPA + 0xc00);
-	ti = addr_gva2hva(vm, SHINFO_REGION_GPA + 0x40 + 0x20);
-	ti2 = addr_gva2hva(vm, PVTIME_ADDR);
+	wc = addr_gpa2hva(vm, SHINFO_REGION_GPA + 0xc00);
+	ti = addr_gpa2hva(vm, SHINFO_REGION_GPA + 0x40 + 0x20);
+	ti2 = addr_gpa2hva(vm, PVTIME_ADDR);
 
 	vm_ts.tv_sec = wc->sec;
 	vm_ts.tv_nsec = wc->nsec;
-- 
2.30.0.478.g8a0d178c01-goog

