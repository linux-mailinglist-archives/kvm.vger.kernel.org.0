Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81E8654BB81
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357350AbiFNUID (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352283AbiFNUHm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:07:42 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF25E55A8
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:35 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 15-20020a63020f000000b003fca9ebc5cbso5441858pgc.22
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=+K2U9ZQLTr9r2599616R5ArFkm9I26JZTi1y24xJeZM=;
        b=WCW721NtOLXF8OgreyIUQne2OjoMN1a3eLd251FVPN/55Ud0cP8y/Sjc+VYwrSgwnB
         zam6Y0aljOPtgfYno6oLzsHbjGoBbt1ynomyy8Q0OH+ea0bk81TZwoY9uUUin22XifI9
         NGDNq8M5BtvqYlT2zVdhMTM0Feyar4QiZQTvb4qgSH07ySOk88fhw8fjGbp6ykYiWYOP
         8xCPe8GzJKD3U6Q/THOKV27Dg7CQ3V4cCqju09EIGzs7wvhvwVvst48GaFaUI2nwPAOG
         IMWG4Asu+x1J6EsTdwiu+JGe/w9pc+hfPbLTUJ1BFTYoIpzTCGzeo/Mb4ph6OgFPbzO3
         Fjcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=+K2U9ZQLTr9r2599616R5ArFkm9I26JZTi1y24xJeZM=;
        b=JkCrXl+G6iReteFNHLoDIwYOpg8vzDf4J0EAskQusv3QzTW/vBTd4VMC7fioGrosJH
         P7BCMN6AxgSxQxjyf/zVOC56V1gimZ9cVTY68hsnEPxFUNkZ80/lkHp1s0cFTPzpEaM6
         96voFWvZl+Gunup82UzlI3jIXGsVg2OgDId7e+BCEW5LC0ejHLumdo2MbBTkkQqgonSC
         SbO8gQfu7A5/ro6FnoxS/ahD9ND6gR76WZ3IDYl87bSnTK6qRCG0NHeezPbxqq6yuj0S
         4YRxXFi3Q2Vg/ArL67YT+kC17iQFvI5Rut4AAuU3a6nIP3+sswNMIBMGtT/P3mDCyhUX
         HBLQ==
X-Gm-Message-State: AJIora88m16TCTogdxVEee5kUnQAHncRbt+PJ5B0EHT0oYERgaIeSKTW
        I7qtIdzSpC+CMKZe5cvX2oqWaeILg8Y=
X-Google-Smtp-Source: AGRyM1umlki2IGqUel3cRE/RbccGMPSY0ssB0AV3HHohG2BDAlbagsZzWAxDSe3r8RwVDj60wIYIjKRYl0Q=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:cf0f:b0:15a:24e0:d9b0 with SMTP id
 i15-20020a170902cf0f00b0015a24e0d9b0mr5869347plg.42.1655237254915; Tue, 14
 Jun 2022 13:07:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:06:37 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-13-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 12/42] KVM: selftests: Use kvm_cpu_has() for XSAVE in cr4_cpuid_sync_test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use kvm_cpu_has() in the CR4/CPUID sync test instead of open coding
equivalent functionality using kvm_get_supported_cpuid_entry().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
index 8b0bb36205d9..092fedbe6f52 100644
--- a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
@@ -63,11 +63,9 @@ int main(int argc, char *argv[])
 	struct kvm_run *run;
 	struct kvm_vm *vm;
 	struct kvm_sregs sregs;
-	struct kvm_cpuid_entry2 *entry;
 	struct ucall uc;
 
-	entry = kvm_get_supported_cpuid_entry(1);
-	TEST_REQUIRE(entry->ecx & CPUID_XSAVE);
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XSAVE));
 
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
-- 
2.36.1.476.g0c4daa206d-goog

