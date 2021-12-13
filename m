Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6623473839
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 23:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244112AbhLMW7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 17:59:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244109AbhLMW7n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 17:59:43 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8BF5C061748
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 14:59:42 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id l7-20020a622507000000b00494608c84a4so10898475pfl.6
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 14:59:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qw/gci8IX1okT5YydzCOdlI7c/eHaurUYfspM0RXE+0=;
        b=Dp9m6CaTA99gmmT5gmsRnzU95V2hN1Hndv8sfxTz7ZB+pG/Wc4zURE24VPitdFxv2I
         Sj7fQ7LyiBR/WoFNHlzQasvbEl+DLcVjxVOBIodkSEP7rVYL227Z070+2ZsnoME8LSBe
         crJ/mUA5xD2mO6oMVCsM1jymYigsdm3mjG62Vt3/K840NMHuxckMoUPCX0A+u4A/Mzac
         u8o8XRxQ91D4rlf1rz0Xm/h6F4Ig9ZvR0r9MdcVcG6k053yS5JlHVrTCTFXFgHDgQMzp
         K+0jHC3siLzccTpGxwBs6Vg1lvAWx2OxH3Ct8E2CrrIS3ssc8Z56IK5c4e4NsCQegjYE
         Goaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qw/gci8IX1okT5YydzCOdlI7c/eHaurUYfspM0RXE+0=;
        b=Sed53e22HfGpmrdik1cl89HbOX+q53NpkYuFcOeXqdLTiy/WYaMS+W1K3qyjtG1tZY
         UKhxZ3PqMkQwr0xukAWR4ONfWOB0SooLcNdVco4Ff98norxJGc95BMapZRi8xikxDfZl
         nzevmJFqd9eW+tvNjbKp4i+WTtubcnvU/CZqNp7xYWsaaGB4RTZbg7Z6LKR8R1F+xYKz
         Qmf7yK4xngIPKM/9d15c4AdC3oM/zsGKNDtDudSEcAf2zg5qLdKQb6gf0Uyh7h2L79HP
         UDHTfPiH1tZcOw/WZ8tEHb9lE10cEczLf3s85nYztOri/LdPUdg9rGwTGt8eh74q/5vi
         hewQ==
X-Gm-Message-State: AOAM533udS/dcSZCUfML2CvfCXJSXHJXbQTD0CWbb4ewH6+dZlij0Gsg
        F6GY26J9nzJIBpY9bwXENf739nWQOz7QsQ==
X-Google-Smtp-Source: ABdhPJw1PtDtdtBdiIicIEZAR/xU2ss5GOasKvclx/0EvAYEZ3m4CJGf/UUcDcviwTnTsJdcORTT776h5wEDDQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a63:3285:: with SMTP id
 y127mr1098792pgy.479.1639436382406; Mon, 13 Dec 2021 14:59:42 -0800 (PST)
Date:   Mon, 13 Dec 2021 22:59:18 +0000
In-Reply-To: <20211213225918.672507-1-dmatlack@google.com>
Message-Id: <20211213225918.672507-14-dmatlack@google.com>
Mime-Version: 1.0
References: <20211213225918.672507-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH v1 13/13] KVM: selftests: Add an option to disable
 MANUAL_PROTECT_ENABLE and INITIALLY_SET
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an option to dirty_log_perf_test to disable MANUAL_PROTECT_ENABLE
and INITIALLY_SET so the legacy dirty logging code path can be tested.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/dirty_log_perf_test.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 1954b964d1cf..a0c2247855f6 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -298,12 +298,15 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 static void help(char *name)
 {
 	puts("");
-	printf("usage: %s [-h] [-i iterations] [-p offset] "
+	printf("usage: %s [-h] [-i iterations] [-p offset] [-g]"
 	       "[-m mode] [-b vcpu bytes] [-v vcpus] [-o] [-s mem type]"
 	       "[-x memslots]\n", name);
 	puts("");
 	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
 	       TEST_HOST_LOOP_N);
+	printf(" -g: Use the legacy dirty logging mode where KVM_GET_DIRTY_LOG\n"
+	       "     fetches and *clears* the dirty log. By default the test will\n"
+	       "     use MANUAL_PROTECT_ENABLE and INITIALLY_SET.\n");
 	printf(" -p: specify guest physical test memory offset\n"
 	       "     Warning: a low offset can conflict with the loaded test code.\n");
 	guest_modes_help();
@@ -343,8 +346,11 @@ int main(int argc, char *argv[])
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "hi:p:m:b:f:v:os:x:")) != -1) {
+	while ((opt = getopt(argc, argv, "ghi:p:m:b:f:v:os:x:")) != -1) {
 		switch (opt) {
+		case 'g':
+			dirty_log_manual_caps = 0;
+			break;
 		case 'i':
 			p.iterations = atoi(optarg);
 			break;
-- 
2.34.1.173.g76aa8bc2d0-goog

