Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB9C95C00DE
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 17:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiIUPPc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 11:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiIUPPa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 11:15:30 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4AC7844CA
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 08:15:29 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id b11-20020a170902d50b00b0017828988079so4073021plg.21
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 08:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=2Z95wq2lk/XpnCodnXFtCKk4Lpt+LwWcZY4LJXGashQ=;
        b=EvbTfodWz70eYq+Vaj6NDj6K1e8d6XIPH8a71rMw+Uz71nlxJXJyGzQ9MoRqYDh0Ah
         jeyAE1RRQwCdTyGNlkBpdioxFBjg2B78qFJVgnOqj2WsCty3JD+8wXRWYMNN8nw09CY5
         pUK4KFMHgUl8fye04vdd+m0xMBGyVqQbd7XwEjS3XD1Fszf2o4OYJesnjm8jImCm6gos
         OnT+NEkSzaj3DNLQuD9qb7zofrdkjO6ANNdV7BCGA8npydfTniWZjBJRSD2o/5JRh2Ea
         zJuR/06s+7WmGS0oTdRKARBAJN3nrARKbxGSnG9UWqemhbIg2XxMJ1e4WM9JT5P9d1wT
         FYyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=2Z95wq2lk/XpnCodnXFtCKk4Lpt+LwWcZY4LJXGashQ=;
        b=QQrh7f8YYCNegSpUA91gIhzJbehvPafSBfKgEQlfqbgcpVN8J6afX0x9lDceJaq5NP
         JaVgxf1cqHVy+l09HeGzpCFx4BEX4zZm6473vnZfzBKU9nLS6coA8Zy8CeIqp876WYY/
         EhN+d6Hj85L7wzqntoy0pPC25mw3LEVDyU9/MBLfRWEYg3Sdkoej4+8G9koFM+zlFpnV
         bL0g0LPyb2yZ38WiT4Uu1qFavLVSIsHEgKSX8IGiOR2X2uAQ7/bEmmpEBZtnGL1eV4Is
         yS5rOEpPx/yX+B2i2aqzwYh4CKsAdtohIMNDQlKnsEJU1a+qEk8NVM4g5+8X1UWVeox6
         bgrA==
X-Gm-Message-State: ACrzQf0d0L5EwioDFbvd5sKcjRDT5+2H8D7VaAd76oUSE4PDQEV+BD60
        RioDPJdqK0u8o16V3lsSlXJSdxVvXMlyAu5sih79LOEkAah7V6xEp4VuxVf/rqd7wdUTt1hzpeP
        yFPnFDH0FuQ8B8WRrsZ09m9zL793uRNkrIvAHHOpgwBJ+lhwHt9/0f4xaY3a0hWVnLg6R
X-Google-Smtp-Source: AMsMyM57o9McCXi984bQuGZ85s7yE2AkYUAI89VH20NpPLz/yduVmpPJYLVu/wvCLNxfs2NjEXRO7kPaNpqp/uu1
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a05:6a00:23d0:b0:550:d950:c03e with
 SMTP id g16-20020a056a0023d000b00550d950c03emr10669466pfc.16.1663773329129;
 Wed, 21 Sep 2022 08:15:29 -0700 (PDT)
Date:   Wed, 21 Sep 2022 15:15:20 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220921151525.904162-1-aaronlewis@google.com>
Subject: [PATCH v4 0/5] MSR filtering and MSR exiting flag clean up
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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

The changes in this series were intended to be accepted at the same time as
commit cf5029d5dd7c ("KVM: x86: Protect the unused bits in MSR exiting
flags").  With that already accepted this series is the rest of the changes
that evolved from the code review.  The RFC tag has been removed because
that part of the change has already been accepted.  All that's left is the
clean up and the selftest.

v3 -> v4
 - Patches 2 and 3 are new.  They were intended to be a part of commit
   cf5029d5dd7c ("KVM: x86: Protect the unused bits in MSR exiting flags"),
   but with that accepted it made sense to split what remained into two.

v2 -> v3
 - Added patch 1/4 to prevent the kernel from using the flag
   KVM_MSR_FILTER_DEFAULT_ALLOW.
 - Cleaned up the selftest code based on feedback.

v1 -> v2
 - Added valid masks KVM_MSR_FILTER_VALID_MASK and
   KVM_MSR_EXIT_REASON_VALID_MASK.
 - Added patch 2/3 to add valid mask KVM_MSR_FILTER_RANGE_VALID_MASK, and
   use it.
 - Added testing to demonstrate flag protection when calling the ioctl for
   KVM_X86_SET_MSR_FILTER or KVM_CAP_X86_USER_SPACE_MSR.

Aaron Lewis (5):
  KVM: x86: Disallow the use of KVM_MSR_FILTER_DEFAULT_ALLOW in the kernel
  KVM: x86: Add a VALID_MASK for the MSR exit reason flags
  KVM: x86: Add a VALID_MASK for the flag in kvm_msr_filter
  KVM: x86: Add a VALID_MASK for the flags in kvm_msr_filter_range
  selftests: kvm/x86: Test the flags in MSR filtering and MSR exiting

 arch/x86/include/uapi/asm/kvm.h               |  5 ++
 arch/x86/kvm/x86.c                            |  8 +-
 include/uapi/linux/kvm.h                      |  3 +
 .../kvm/x86_64/userspace_msr_exit_test.c      | 85 +++++++++++++++++++
 4 files changed, 96 insertions(+), 5 deletions(-)

-- 
2.37.3.968.ga6b4b080e4-goog

