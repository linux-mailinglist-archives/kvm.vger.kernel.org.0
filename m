Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8C962E4F2
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 20:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240364AbiKQTHR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 14:07:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240272AbiKQTHQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 14:07:16 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BDE70A36
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 11:07:15 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id w2-20020a17090a8a0200b002119ea856edso4721718pjn.5
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 11:07:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xrJm0fOsDWKeiievg8DGk4jDzdpNIiW0mf+bg8MNtpw=;
        b=LlSdd6c3uH8AImEslVqf6j4LPN+5OqFMVFx8XUIG4MxYDNB/sWYocfHxUL68QjPOfs
         Fs2uAjsQumfFIgWU3O37dSm30rbB10FPVzUebWZWy0Kz0rBTT2gsIwOozbGCCBNSbc9M
         Rvyvfb0baT4lo0RFdPLIobw9ZgRQPmDsnemOs90NeT5/Y2a9sUu5vCpkye2GiGzp6dAq
         0BKvk8AtLR5oswXiAV/W83sek2akqSgwjU/OSIJDe4lLWA/K2JxavqTG6FStHt2lUfiu
         A6NyZZ5A/a+qt4ST7DFTQYjT+qYGqrQy4eJ8J+XQr7LLFOmS/1jz6ja8FMwoop76QH0Z
         QO2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xrJm0fOsDWKeiievg8DGk4jDzdpNIiW0mf+bg8MNtpw=;
        b=AanjqpLW22/k8odVir2j6bQ3W/E0QE1o8Umg47+iEfM3SYg/qHqnVciGxcD3sOy1ZO
         vOYeJUWoAiYmvcEYzYXPNd8mRQ/F7H1DZTckd3tLVfOg00u1MoIJQz7cw67cCdTwklSP
         i2K8HWLZaQKs9eQ6DjavDldH09p5OwaSgo56j6mool81hF4PRqpqND8cGC1RBZadFlBV
         AGbyJrGUS9rb8TyBRrQ9xQwFHFlrZEwbcw9ep6Hc8eApHBWE7rkr4s/lvqSTdwK+0+Km
         1dQdlVPjtnjWvskm9gvpvFS+15ylN9JzUXG5pmQsyVm39NIwPa8iDFt30xrg5rnavsN7
         aedA==
X-Gm-Message-State: ANoB5pkeApfRKdvKMHsGbDDKflrHecMz19iKLWT94OZLL3UbqMty/LdF
        eku7zVMEtPlOGWf3chgYaQs1rGS91bAlozI754V5gFraZmXll4f42pBYUTIR2MQirOO/pb+zB0c
        GCWmF3DS5b6dpnMGKz6gbMxz2rlX1oVPfI9zrzQ17yFbVAWrpKueI95r1JTgk4JdMVwKrsxQ=
X-Google-Smtp-Source: AA0mqf5dN5F1i+NpWFSqLZBD5ZHQLpGdJtEdXfH/GyUmR7rJ1jalGswNgVczOSGZ18h/9uE3/K/6hhXB85kMjKoNYA==
X-Received: from dionnaglaze.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2ee6])
 (user=dionnaglaze job=sendgmr) by 2002:a17:90a:5990:b0:20a:68f5:a986 with
 SMTP id l16-20020a17090a599000b0020a68f5a986mr10120060pji.166.1668712035246;
 Thu, 17 Nov 2022 11:07:15 -0800 (PST)
Date:   Thu, 17 Nov 2022 19:07:02 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221117190704.1900626-1-dionnaglaze@google.com>
Subject: [PATCH v2 0/2] kvm: sev: Add SNP guest request throttling
From:   Dionna Glaze <dionnaglaze@google.com>
To:     kvm@vger.kernel.org
Cc:     Dionna Glaze <dionnaglaze@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series is based on

[PATCH Part2 v6 00/49] Add AMD Secure Nested Paging (SEV-SNP)

and is requested to be rolled into the upcoming v7 of that patch series.

The GHCB specification recommends that SNP guest requests should be
rate limited. This 2 patch series adds such rate limiting with a 2
burst, 2 second interval per VM as the default values for two new
kvm-amd module parameters:
  guest_request_throttle_s
  guest_request_throttle_burst

This patch series cooperates with the guest series,

 Add throttling detection to sev-guest

in order for guests to retry when throttled, rather than disable the
VMPCK and fail to complete their request.

Changes since v1:
  * Added missing Ccs to patches.

Dionna Glaze (2):
  kvm: sev: Add SEV-SNP guest request throttling
  kvm: sev: If ccp is busy, report throttled to guest

 arch/x86/include/asm/sev-common.h |  1 +
 arch/x86/kvm/svm/sev.c            | 46 +++++++++++++++++++++++++++++--
 arch/x86/kvm/svm/svm.h            |  3 ++
 3 files changed, 48 insertions(+), 2 deletions(-)

-- 
2.38.1.584.g0f3c55d4c2-goog

