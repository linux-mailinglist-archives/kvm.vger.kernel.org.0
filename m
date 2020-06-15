Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2603C1FA3E1
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 01:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbgFOXIA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 19:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725960AbgFOXH7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jun 2020 19:07:59 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BFB6C061A0E
        for <kvm@vger.kernel.org>; Mon, 15 Jun 2020 16:07:58 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id a6so15490743qka.9
        for <kvm@vger.kernel.org>; Mon, 15 Jun 2020 16:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VXAPwMal3rFEc5LEt7S5U+l1GKYsWx0iuEnmtFL6amk=;
        b=UrBySeudnIqCpwrylfGeEVYbknoXKC3yfFAnP93v3haSNhT2Egfg2Xxnxilt+X6qQu
         fHjpmEptMS8DkMYh7/er+tp2lx5d10tuQ+uN3y73Rb8lPHRc+chRBN9+r211KfV2flft
         8YB6vXZ5hATVxhWCSU4DqRB1KrBpbI7sp9w7pnT7Ll598h98kMWmYKdD5zZRJA3sLcV5
         oyjV64mtQwAq+tcv2KuolSHZNzAvgFKZlXTy0KarQMRoVBEeo4ymolJsahlBhCPFVigU
         J6cYXrDK6+lmQ/q6rgo/Z9Bl3vk4njjFlb4eOyhReZy7lL+zO9okCw0aD5lsAPt5tseG
         F4UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VXAPwMal3rFEc5LEt7S5U+l1GKYsWx0iuEnmtFL6amk=;
        b=JR6UgbbC1UlHqry/EehHC+ZvalT/L67EkDluOtw+vKLOakM9+hMpQHo0xxV1l0u5BJ
         /f4qHEFRU1BKw6/L14jYMYdeAK+QvrEwiOHFnLq9SlZ5CPkNXdrfmtj6dQ1x57h986Ty
         f6QeHte858H1WNqRSVkBS9Jn/HsHvAALeoB0GouJnlyoaDh9iKfdH15QzhHt9hpNdek9
         jIFE//z6sZMKtmkStOzIiZOBEkPWEXVl0LMlvUbNMYdDQtTUfwtPdwwT97GIh/Xwdp8w
         N0D6uEkWd/xh6YowATUU0sQjEDhslQfF77fJppVtxEyQ/pnMeqfxfMLYWhBVGFGFh/vE
         zbCw==
X-Gm-Message-State: AOAM531uIX4swV9H8o4cgDKm+YjwWVVq1scrOOqSZs7aCpK+mK6qDlNf
        fIoPv6PL2xYYsRm+ZA7kpsrEZIVbCntUGn6rlnIP4Nuz0srX4SNLnDj/FseDDrY2rfxfN2aGSit
        lKnDBWiSsiVL/G6nlYe8pfGsNMhnxvmoIVzEZw0X9hLznnGj9Rh/hHQ/kjEi4cAk=
X-Google-Smtp-Source: ABdhPJyAwhs14vwGsRuh+SomTJpn3uGaChNqKbIL/Q2oATVfqDNrwq9AkAQgTXUo6tDC639IlGN4sLrBQiutAg==
X-Received: by 2002:a0c:ed26:: with SMTP id u6mr56224qvq.141.1592262477674;
 Mon, 15 Jun 2020 16:07:57 -0700 (PDT)
Date:   Mon, 15 Jun 2020 16:07:50 -0700
In-Reply-To: <20200615230750.105008-1-jmattson@google.com>
Message-Id: <20200615230750.105008-2-jmattson@google.com>
Mime-Version: 1.0
References: <20200615230750.105008-1-jmattson@google.com>
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
Subject: [PATCH 2/2] kvm: x86: Track synchronized vCPUs in nr_vcpus_matched_tsc
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use nr_vcpus_matched_tsc to track the number of vCPUs that have
synchronized TSCs in the current TSC synchronization
generation. Previously, we recorded the number of vCPUs with
synchronized TSCs minus one.

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/x86.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2555ea2cd91e..013265d61363 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1921,7 +1921,7 @@ static void kvm_track_tsc_matching(struct kvm_vcpu *vcpu)
 	struct kvm_arch *ka = &vcpu->kvm->arch;
 	struct pvclock_gtod_data *gtod = &pvclock_gtod_data;
 
-	vcpus_matched = (ka->nr_vcpus_matched_tsc + 1 ==
+	vcpus_matched = (ka->nr_vcpus_matched_tsc ==
 			 atomic_read(&vcpu->kvm->online_vcpus));
 
 	/*
@@ -2104,7 +2104,7 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	if (matched)
 		kvm->arch.nr_vcpus_matched_tsc++;
 	else
-		kvm->arch.nr_vcpus_matched_tsc = 0;
+		kvm->arch.nr_vcpus_matched_tsc = 1;
 	kvm_track_tsc_matching(vcpu);
 	spin_unlock(&kvm->arch.pvclock_gtod_sync_lock);
 }
@@ -2295,7 +2295,7 @@ static void pvclock_update_vm_gtod_copy(struct kvm *kvm)
 	int vclock_mode;
 	bool host_tsc_clocksource, vcpus_matched;
 
-	vcpus_matched = (ka->nr_vcpus_matched_tsc + 1 ==
+	vcpus_matched = (ka->nr_vcpus_matched_tsc ==
 			atomic_read(&kvm->online_vcpus));
 
 	/*
-- 
2.27.0.290.gba653c62da-goog

