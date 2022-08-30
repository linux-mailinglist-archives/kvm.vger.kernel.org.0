Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7CDF5A719D
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 01:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbiH3XS2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 19:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231945AbiH3XR5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 19:17:57 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47BC9F184
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:16:33 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id s129-20020a632c87000000b00411564fe1feso6112954pgs.7
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=9+JwBO4nX8GrUd03Z9QeV/uS8dpKH0L2avVFFDeS0ks=;
        b=jXXAcjBui2gp6SLGVf6HlOAyNamaRGTU9bCBd9OArQqpSgOWiNRYQyFS62VJGb7awZ
         MbuBS3ATOMu1rcMKmcDipN0/qy5F57JkCRaDfJ8OzL0FWE0F/2/jJJFZCaIcWkBt6K90
         hT7ipBF3zGzKt+qniGAPX03UTOKgY8OwzTWBCzpJbB5x7/JfQT9NAgVGuLzHBOql6xlZ
         b8HdfQbExvTD11n0LeyLbG8nyXbqIJ1AzHlQQmVBHqmMDsoPRqbZNY6VfIfhsGPlphTl
         +2JFMldCRzJ733cuFpTajJrH9E1bJPrAe2kCY13SFhAscyaCw8rg4YEiSmpBMzYOCKPi
         pLUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=9+JwBO4nX8GrUd03Z9QeV/uS8dpKH0L2avVFFDeS0ks=;
        b=XXJUNHNRq2lfw0WivbwXGFEHLPi8asZfiLH1BrVKaWnefH11NCZwAOpt1L3Lp5NphF
         zFYNtXy4dvPYrEH/+aZV7rA+nLGMZlA43oig10QfzIvMJFjB5fou8GVNOtwLgT4ReftL
         UcdKjXLiX9Cbq3nD2Cwfmj0ch7CuR4wYz3h8/Qdu9JBDN9GcWd2nKFQnCql6KMcie3N+
         +vGmnhky3KiL4CnhSmohCGrrjwnhQv51zICMICtRxQ1H+mPcXkFv7bpuiQATKRbXeaqn
         rdS8mUBiAyQcCsfoaLL4fBnR73M2gfjwchFvQp/rv2qKD6M1pFE83iHG8PHYLxWkXQQx
         9fVQ==
X-Gm-Message-State: ACgBeo1NWQgTXn1K9EYtlkCKFj8gfNYDRsgGwRoDkVZ0NMoN/DL0n4n5
        051BetY1UUu3W4Bmt2t3Fx+I+IPExSw=
X-Google-Smtp-Source: AA6agR7PpDK+dfX65Z2sMzsgx3m7tePN1WvJ9Hmgkqc960RY99L9vi3njldBIFNLzBOkYTsKCrRRz71/Pr4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr11231pje.0.1661901391766; Tue, 30 Aug
 2022 16:16:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 30 Aug 2022 23:15:56 +0000
In-Reply-To: <20220830231614.3580124-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220830231614.3580124-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830231614.3580124-10-seanjc@google.com>
Subject: [PATCH v5 09/27] KVM: x86: Use DR7_GD macro instead of open coding
 check in emulator
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use DR7_GD in the emulator instead of open coding the check, and drop a
comically wrong comment.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/emulate.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index f092c54d1a2f..59b61a41125a 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4168,8 +4168,7 @@ static int check_dr7_gd(struct x86_emulate_ctxt *ctxt)
 
 	ctxt->ops->get_dr(ctxt, 7, &dr7);
 
-	/* Check if DR7.Global_Enable is set */
-	return dr7 & (1 << 13);
+	return dr7 & DR7_GD;
 }
 
 static int check_dr_read(struct x86_emulate_ctxt *ctxt)
-- 
2.37.2.672.g94769d06f0-goog

