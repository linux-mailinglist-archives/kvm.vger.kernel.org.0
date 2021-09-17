Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671A640FEB2
	for <lists+kvm@lfdr.de>; Fri, 17 Sep 2021 19:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239075AbhIQRiY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 13:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238825AbhIQRiX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Sep 2021 13:38:23 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14AAAC061574
        for <kvm@vger.kernel.org>; Fri, 17 Sep 2021 10:37:01 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id w10-20020a170903310a00b0013a74038765so5305936plc.22
        for <kvm@vger.kernel.org>; Fri, 17 Sep 2021 10:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=u1OAR41r2GpWUk2BdYhf5uWfvH4fDJfLEKCuUMQO/c0=;
        b=EAWmlOckMv1wxFUUJVK6C4XY6nu99H0EfkfSnbMJiF/U5m+SFJbrju1z4xQ9xexsIP
         QiDhrjKFsuVGib/I8Qfpd22syWMjBwipIsSk+vC7gCVyxCUnPNUH5USszFXb0/NvBAm7
         V2abBkukohQW3qnB36kHKtuNjIV4/VXCP45m13UdlcEmC7jK9NvoKaBtPMFJEDGGDjNx
         gv297T1av0RPzcCUO9ADqwCLb6G7u/tFinCG9BvvH/alq+/83I8qFZ8U3F5v3WCn8aQ5
         9CaUFkqkyx1UMiQ63tHKOnRr4ZpzqMb4uppAzh7TsRUAYPNmBXdgv8Bztn9eIOanqlC5
         D7/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=u1OAR41r2GpWUk2BdYhf5uWfvH4fDJfLEKCuUMQO/c0=;
        b=oZA6WiF7uQT0bqHhKLffZLUNRLPXvwqb744onF6E3at6Zqv4s4qH+K7HrgoeHh7asR
         zF1+nYL7VMN9kWAd2YMSqGJ6dO0yiHWXojsOyfpmHy15Zi4qb8MCl2k7PHm/yf3bOsyR
         jfiy14WgqCftC+ommcqGtUm5JgGG/jt8SfBbOh+BHqV33Fu2IqW2zwO+G58OLBmDIyn9
         6eW4Ew7lB/H/747lAGAKj6yUWLGDUWA+l+Sko/hS7ypMqcUZBG8G9U9Os0MdoHrgwtP/
         7Hl0R2T/DzQK2VgfdtpC1wdmDsiW9slknYMLkBSxWiZtMuCCmpvG4Ptzq1OHD1emVcLC
         BH3Q==
X-Gm-Message-State: AOAM53144vvVzC9PRuskFNiAOgI4UFoMODY3QItdBhFEOvDidDROaFPm
        wL+DJvKzV3DZBffM143ILmOqskGcFVvH/w==
X-Google-Smtp-Source: ABdhPJyDIZRAOvmebZitDRoRG0AgTUNysqkuDg3uMb7yUgBgxXN7+YrcwBQtIw1xs9YxjmksggnCzzVuradp5A==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:fd7:: with SMTP id
 gd23mr735942pjb.1.1631900220281; Fri, 17 Sep 2021 10:37:00 -0700 (PDT)
Date:   Fri, 17 Sep 2021 17:36:55 +0000
In-Reply-To: <20210917173657.44011-1-dmatlack@google.com>
Message-Id: <20210917173657.44011-2-dmatlack@google.com>
Mime-Version: 1.0
References: <20210917173657.44011-1-dmatlack@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v2 1/3] KVM: selftests: Change backing_src flag to -s in demand_paging_test
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Every other KVM selftest uses -s for the backing_src, so switch
demand_paging_test to match.

Reviewed-by: Ben Gardon <bgardon@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/demand_paging_test.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index e79c1b64977f..735c081e774e 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -416,7 +416,7 @@ static void help(char *name)
 {
 	puts("");
 	printf("usage: %s [-h] [-m vm_mode] [-u uffd_mode] [-d uffd_delay_usec]\n"
-	       "          [-b memory] [-t type] [-v vcpus] [-o]\n", name);
+	       "          [-b memory] [-s type] [-v vcpus] [-o]\n", name);
 	guest_modes_help();
 	printf(" -u: use userfaultfd to handle vCPU page faults. Mode is a\n"
 	       "     UFFD registration mode: 'MISSING' or 'MINOR'.\n");
@@ -426,7 +426,7 @@ static void help(char *name)
 	printf(" -b: specify the size of the memory region which should be\n"
 	       "     demand paged by each vCPU. e.g. 10M or 3G.\n"
 	       "     Default: 1G\n");
-	printf(" -t: The type of backing memory to use. Default: anonymous\n");
+	printf(" -s: The type of backing memory to use. Default: anonymous\n");
 	backing_src_help();
 	printf(" -v: specify the number of vCPUs to run.\n");
 	printf(" -o: Overlap guest memory accesses instead of partitioning\n"
@@ -446,7 +446,7 @@ int main(int argc, char *argv[])
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "hm:u:d:b:t:v:o")) != -1) {
+	while ((opt = getopt(argc, argv, "hm:u:d:b:s:v:o")) != -1) {
 		switch (opt) {
 		case 'm':
 			guest_modes_cmdline(optarg);
@@ -465,7 +465,7 @@ int main(int argc, char *argv[])
 		case 'b':
 			guest_percpu_mem_size = parse_size(optarg);
 			break;
-		case 't':
+		case 's':
 			p.src_type = parse_backing_src_type(optarg);
 			break;
 		case 'v':
@@ -485,7 +485,7 @@ int main(int argc, char *argv[])
 
 	if (p.uffd_mode == UFFDIO_REGISTER_MODE_MINOR &&
 	    !backing_src_is_shared(p.src_type)) {
-		TEST_FAIL("userfaultfd MINOR mode requires shared memory; pick a different -t");
+		TEST_FAIL("userfaultfd MINOR mode requires shared memory; pick a different -s");
 	}
 
 	for_each_guest_mode(run_test, &p);
-- 
2.33.0.464.g1972c5931b-goog

