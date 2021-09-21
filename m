Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91DD9413823
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 19:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhIURM7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 13:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhIURM4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 13:12:56 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9906EC061574
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 10:11:27 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id e22-20020a05620a209600b003d5ff97bff7so184548206qka.1
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 10:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jbjtkKJClRIdxDxc/X394uGXktg3U8/Y+QRIQienfdo=;
        b=mWyNrrEh7r2ySTiW4Dae4QnrEPDgY8hXI/P5NufdPFUir6Y5L1t9mujB8p860FHuh1
         SkaMHh2ZuA1gBH/UCa5MOFmkQh4d6dDm9uxwx/G2ArlH+4Oim4gB5YUHp83i4cMlNyIK
         18rU1nqfj0abE/L6uEOAHDD27ah2ztfzg9ixYn08nweN6UI9yBG2sX3EFrUH/vRUJRT+
         mYKQYyPIk7W0nOqEqZGnfNAakiuSl4Myn4dFO9vmOUe0ckxXrfENjdZuPxFYuDZQ4kV1
         KcfN2jvnXwIQnQ0MkHp9bYrkYsS9+EMUpup7y93HrhHcrN5jcH7ADq655ZTZFj4qScZH
         xDfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jbjtkKJClRIdxDxc/X394uGXktg3U8/Y+QRIQienfdo=;
        b=K/skbVaTEyfTB+R8yK3YOuCdpWi3d4h0+Mg3VchOKFrCkAhwkEpAbnkGPEtjqXRYNn
         zqQ1EGBsb9fasF+n4qSakHxMcbSUCoOzzn8cENH6NNTu4Q3H0LylBZFiWeIdCwBlwhNr
         kqnjDmd8wRp6JLOkFIFm+plJlDY6U2TcvVuQv1ge1NW7Gz8a/bV56e0Djo2blpYV1PE6
         Pdv7W293cJYXqGU7FtqzYP6HdPgO26JVCKGOqzYAGne25+d8zE5YdAmm72G4jhSOqGAj
         PV4cUkxGvdu+nyi8MkXwiiy+CM4Sc0fibAaXJCFV3cE7FEoJoFHdOwrSD8CIUXg4MrIb
         leEg==
X-Gm-Message-State: AOAM5318Tj2xXjjA9WtPJn3MhyeWecHeP7q6BHvL/0GM379b4MuBOqZT
        LfLf+CY/garJyZ2s3HqspcDSx0qD30Dz3Rfpw7RamksrZWWx/PiyEDnCsRQ22mp9AQ5RKkvyyl0
        ZldBBGHTGhcWVm3Tz2Ups4ontAaACW4456BxvKoAy103tmTkifHOkyJCTAQ==
X-Google-Smtp-Source: ABdhPJwfa7oXjKMcTr6hpyAwdrgF4UuepCosJxs3eddjQEmY8Byeb5DZI6myHOWAQLWj8DDqFVtOMt3A/Zw=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:424a:: with SMTP id p71mr41188110yba.243.1632244286770;
 Tue, 21 Sep 2021 10:11:26 -0700 (PDT)
Date:   Tue, 21 Sep 2021 17:11:21 +0000
In-Reply-To: <20210921171121.2148982-1-oupton@google.com>
Message-Id: <20210921171121.2148982-3-oupton@google.com>
Mime-Version: 1.0
References: <20210921171121.2148982-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v2 2/2] selftests: KVM: Align SMCCC call with the spec in steal_time
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SMC64 calling convention passes a function identifier in w0 and its
parameters in x1-x17. Given this, there are two deviations in the
SMC64 call performed by the steal_time test: the function identifier is
assigned to a 64 bit register and the parameter is only 32 bits wide.

Align the call with the SMCCC by using a 32 bit register to handle the
function identifier and increasing the parameter width to 64 bits.

Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/steal_time.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index ecec30865a74..aafaa8e38b7c 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -118,12 +118,12 @@ struct st_time {
 	uint64_t st_time;
 };
 
-static int64_t smccc(uint32_t func, uint32_t arg)
+static int64_t smccc(uint32_t func, uint64_t arg)
 {
 	unsigned long ret;
 
 	asm volatile(
-		"mov	x0, %1\n"
+		"mov	w0, %w1\n"
 		"mov	x1, %2\n"
 		"hvc	#0\n"
 		"mov	%0, x0\n"
-- 
2.33.0.464.g1972c5931b-goog

