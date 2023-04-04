Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A67086D698B
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 18:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235610AbjDDQya (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 12:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235618AbjDDQyV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 12:54:21 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3139819A4
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 09:53:58 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id j15-20020a17090a318f00b0023fe33f8825so10448972pjb.9
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 09:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680627237;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=PvU13nwZTjVVPikLp9TFHiw7qbdBEvEGiqENE7eypnw=;
        b=Ek3+B9jw7OgiLV7NYMgckr6azDI23CSYk5kmy/xp6i1mpXlKMJLFXe0gL4IegN89SC
         J+NrcWjhgTXJyig0LyEOpRzdJyFdG8DqnLSWqmUMMTq3FMH4Sca6YpxGWSwBpc+4++Tp
         Ksd4vPF2bSe+JYYZZjtL94cLzajTDMKmVvMnx4GN8x9TpfxQvIQ8TxXPMXAotHBN5OLv
         Ui8EjILc45q3ddls/DRsrfBs0IjHOfmRMBxPnaLIcHfXHzqA+59oJfNTvY8vYsXyeMFd
         3kAb/QMKlzGa1jSF7Qz04AD2BV2CiCd2gi8qomxugqCTNenI/sDcbu2KdFjyCZiwYKS/
         SNgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680627237;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PvU13nwZTjVVPikLp9TFHiw7qbdBEvEGiqENE7eypnw=;
        b=b9nvu6OYp46sZZeNtUqf2Bk4J8zAHOBV0AL55icoyXSipMroO18WoqXb0ui6JM5D5h
         PRvnNQLYXuNAAfyuOrde5yM9QMjOjOKPXffCfrr90a3Mlt3PteqjEZTOpXbLq3TU+UAH
         pBoQxxsByFaeepVVCqRjpRz3Xye7Mf4pxhq1Y3eJNRf2lBrLHdqmSVMY5Iu6gbRowS+M
         hJcQ+qoBkpuehxXbgfzg0PqJqeyUhy4w9apAcoD8spbfXt4J82/6A9FqFqiN1eMC9sXR
         W//b2yuVa/CH7uvxLE37O9+t20dUad4gQMiGt7icfSljBiVO1fN7UOXwR3gUnwR3D8vD
         LBTA==
X-Gm-Message-State: AAQBX9cV8hbzz2pRK1aJNw7iYYBF++4thLRlrOSQC5iq/457WsBCnVNw
        DRKdExisQcxHbtYB1l6TeoVWqdQZqpA=
X-Google-Smtp-Source: AKy350YW03C31a2nVqPkZDvnmdZlbsLRPEsXzuCfWwqqZM5bUn3OFF+ENQFU3asXPAEy73uTmkrCGvkXzpU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:4f85:b0:240:44c4:a09d with SMTP id
 q5-20020a17090a4f8500b0024044c4a09dmr1202634pjh.0.1680627237426; Tue, 04 Apr
 2023 09:53:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 Apr 2023 09:53:38 -0700
In-Reply-To: <20230404165341.163500-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230404165341.163500-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230404165341.163500-8-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 7/9] x86: Drop VPID invl tests from nested
 reduced MAXPHYADDR access testcase
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Mathias Krause <minipli@grsecurity.net>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the variants of the nested VMX reduced MAXPHYADDR access test that
require a nested VM-Exit in order to invalidate the to-be-tested
translation, as the combination is quite uninteresting, and those tests
have a painfully long runtime (upwards of 10+ minutes).  Alternatively,
the tests could be split out a la commit ca785dae ("vmx: separate VPID
tests"), but the probability of finding a KVM bug that only affects
VPID-based invladations in combination with a smaller MAXPHYADDR is
extremely low.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/unittests.cfg | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 6194e0ea..e325667b 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -432,7 +432,7 @@ timeout = 240
 
 [vmx_pf_exception_test_reduced_maxphyaddr]
 file = vmx.flat
-extra_params = -cpu IvyBridge,phys-bits=36,host-phys-bits=off,+vmx -append "vmx_pf_exception_test vmx_pf_no_vpid_test vmx_pf_vpid_test vmx_pf_invvpid_test"
+extra_params = -cpu IvyBridge,phys-bits=36,host-phys-bits=off,+vmx -append "vmx_pf_exception_test"
 arch = x86_64
 groups = vmx nested_exception
 check = /sys/module/kvm_intel/parameters/allow_smaller_maxphyaddr=Y
-- 
2.40.0.348.gf938b09366-goog

