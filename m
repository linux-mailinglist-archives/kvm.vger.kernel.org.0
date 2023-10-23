Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1347D4006
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 21:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbjJWTPw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 15:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232032AbjJWTPs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 15:15:48 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70DF127
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 12:15:43 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d815354ea7fso3445011276.1
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 12:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698088543; x=1698693343; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=uBymkLXaIbVAZxvVvhT6TDkhrUvJ108nxwLs5k3r9KY=;
        b=uZIUldtCFmWR/4Zm5R907+OzW1iVXo0Ev3zll4Ko/bdCvIk22hbb/gZTUBZ34R9+kf
         2Kv2p7z/lZ1W54pvJzsvhT6BzYzv972nmXQznbmo1xBffP/AKSiPejRf6gqr9j/CKdoa
         CrF9OZiBYiTv1PHYKF0QnIYsTbtP5TgjcHism8RNgY4jVZDQ28MzGDXzhkbOcojkP3ev
         FTzUNxnM7H5gwexvipJr3HJdpjqCrqNS8f8th+vUm0n/Qo+tHb9wLEYk3SJ1VDnAToWE
         lDZ+5HCOscBj+UVtNgKmo4ySWmvolH7wHqZcRrbEwBpf+ibvESBcmbPN7QT2tYQkoEc6
         yK+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698088543; x=1698693343;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uBymkLXaIbVAZxvVvhT6TDkhrUvJ108nxwLs5k3r9KY=;
        b=Z/uQghU4hl30NAqOD4IUQF/dDwt411HlB2Hh5zS5xSITPdlxZfD4nLFpYHVRsSFdWj
         SO+p3XFu0HiK+RfojF5BQr6fNr/ChLcarLccBu2MnybV8L/OEy2CZR5Pi60VM0SwZpf9
         jJXI1fG0UpPT8lzaYO8JkA+oKUYPoYn83/5BBCh8unfNkLAPN9UdTYnvJLC+dMDqruY4
         oDYk961nn1a+mgTKzmCxiepMMcSzYZCwmkxyx8RJpu/5MdpACgO9TUhFWBvMpTBRTyho
         vV57M0lHGcrZXZIP0CrzLdrQYBQzpvskD+A6+42XrGxjh9SgE7dmdmM/Vm3ujVFfkSaW
         sCuA==
X-Gm-Message-State: AOJu0YyW3AxaFfPLP0Az0znAmJ5mINhT2X6z7B6Bn27iJjkg7IRJs9xa
        xXYg2znUG4JFRAD3pZW9NjJxhtgWxS0=
X-Google-Smtp-Source: AGHT+IEsbW+5jIJToDeWeuFRsel0Z/eWZAZjCRG0B0xBXMEdLdbn9pQrSfDt02b+FeV7Rcn80ixxiAKmPjM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d3d1:0:b0:d9a:6b0b:1bc8 with SMTP id
 e200-20020a25d3d1000000b00d9a6b0b1bc8mr199602ybf.11.1698088542952; Mon, 23
 Oct 2023 12:15:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 23 Oct 2023 12:15:31 -0700
In-Reply-To: <20231023191532.2405326-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231023191532.2405326-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
Message-ID: <20231023191532.2405326-5-seanjc@google.com>
Subject: [PATCH gmem 4/5] KVM: selftests: Use dedicated pattern for testing
 that mem is shared by default
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Somewhat arbitrarily use 0xaa as the data pattern when testing that memory
is shared by default.  Inverting the bits of the init pattern (0xcc)
yields 0x33, which just so happens to be the same as pattern #3, i.e. makes
triaging failures on the default check unnecessarily difficult.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/private_mem_conversions_test.c     | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
index 3f6d8d4dbc53..8a2f924fd031 100644
--- a/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86_64/private_mem_conversions_test.c
@@ -122,13 +122,15 @@ struct {
 
 static void guest_test_explicit_conversion(uint64_t base_gpa, bool do_fallocate)
 {
+	const uint8_t def_p = 0xaa;
 	const uint8_t init_p = 0xcc;
 	uint64_t j;
 	int i;
 
 	/* Memory should be shared by default. */
-	memset((void *)base_gpa, ~init_p, PER_CPU_DATA_SIZE);
-	guest_sync_shared(base_gpa, PER_CPU_DATA_SIZE, (uint8_t)~init_p, init_p);
+	memset((void *)base_gpa, def_p, PER_CPU_DATA_SIZE);
+	guest_sync_shared(base_gpa, PER_CPU_DATA_SIZE, def_p, init_p);
+
 	memcmp_g(base_gpa, init_p, PER_CPU_DATA_SIZE);
 
 	for (i = 0; i < ARRAY_SIZE(test_ranges); i++) {
-- 
2.42.0.758.gaed0368e0e-goog

