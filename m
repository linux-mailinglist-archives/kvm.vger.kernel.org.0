Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8423957AA94
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 01:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbiGSXuR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 19:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiGSXuQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 19:50:16 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA241F609
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 16:50:15 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id s6-20020a25c206000000b0066ebb148de6so4430071ybf.15
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 16:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ujDspcENCnSk6XB+L/ju3ZofyInxxwCikiRXtPerKsk=;
        b=n5WDsRHI3KzCmAARBrHlvXvlWi70Ptb4Dg75GtraCU9Q15jPVlUbnz/UITyrd2qx3Y
         SIY0NI67jxKoR72t6+7gmenPBW4SgrFH7nCWTqpAJQcSspVJqNit5tgAotfeNMj8MSl3
         D+dmGJzZyhTMHw2IMkT7LTY3JMZ22uARwzcfIMfwyOn4jQmpaPYF/cMBD1W16buyaD52
         V6LY/JRNTSWjjKjulCAV+2/eYybShLeTd4R90E/AZslO0EWQmBDCW6yKbwz31Hka6DHM
         5ZB6HfL944YYbOLpkROTyGsL2ecVj0swgfXcJTva5jP0b3MohoMncTjvt+ZRkiLfYpoN
         XylA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ujDspcENCnSk6XB+L/ju3ZofyInxxwCikiRXtPerKsk=;
        b=cxLOmkQqmUmlEkvmQfAoTZFpXma1JET9XIF4n7ZO1px/+6yo/E2by2+o9083lHApG/
         xYV/ktkwi0g0SDR7g3f/vVPvmfJJy0q0Ix38+sSlNT1Y4XUMIIy8ZPc7cNReIrjawX3M
         Iy1a2736NsZR/syhIMYLbl+LskPHufbbpiHGWhURncEN617Le+cLHLeB8Apy5mymG8QD
         sn0KQUALc18QwRyqyoEENIkEm4BLasUM5a1TKIJETXaz4XZaqukQDgnZXvY1Q4oTp5wD
         Ogt74MJRpMlOlSbqs5konS/zjHWoyBWp0qwweDZKf1haIgjKce82sLz0p3JdCShAlgoW
         6BiQ==
X-Gm-Message-State: AJIora8mI1qNx7T364emn0KtXpAyA6zG1Ya/yrqQ+va94lndS5gqa3KY
        21vbsAaB8LhSj3GXL3VvMQMM/b7lUsw1EAg7+Rjx0b4NJ8al8O4RM/wKL/cxOqEW7IkqWQK3iWN
        fOJ8EHgk21txVXBUdhGHCYWlFcyG87KKfoEAyrIMpz7sD6HQc5pVwfad4/m3ffy8unHjC
X-Google-Smtp-Source: AGRyM1s1DflAvSvRh6eycmEyii6t1z7RzTfONj4niHdz7sOc0XzzeUyIvyADx1A2KNNMRpRfyrJ6+TqlQKoUemDz
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a0d:dec2:0:b0:31c:a9dc:b372 with SMTP
 id h185-20020a0ddec2000000b0031ca9dcb372mr38298541ywe.481.1658274614890; Tue,
 19 Jul 2022 16:50:14 -0700 (PDT)
Date:   Tue, 19 Jul 2022 23:49:48 +0000
Message-Id: <20220719234950.3612318-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [RFC PATCH v2 0/3] MSR filtering / exiting flag cleanup
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

Posting as an RFC to get feedback whether it's too late to protect the
unused flag bits.  My hope is this feature is still new enough, and not
widely used enough, and this change is reasonable enough to be able to be
corrected.  These bits should have been protected from the start, but
unfortunately they were not.

Other approaches to fixing this could be to fix it with a quirk, or the
tried and true KVM method of adding a "2" (e.g. KVM_CAP_X86_USER_SPACE_MSR2).
Both approaches, however, complicate the code more than it would otherwise
be if the original feature could be patched.

For long term simplicity my hope is to be able to just patch
the original change.

Note: the second patch in this series does not contain any functional changes,
so it is not an RFC.  The others do, so they are.

v1 -> v2
 - Added valid masks KVM_MSR_FILTER_VALID_MASK and
   KVM_MSR_EXIT_REASON_VALID_MASK.
 - Added patch 2/3 to add valid mask KVM_MSR_FILTER_RANGE_VALID_MASK, and
   use it.
 - Added testing to demonstrate flag protection when calling the ioctl for
   KVM_X86_SET_MSR_FILTER or KVM_CAP_X86_USER_SPACE_MSR.

Aaron Lewis (3):
  KVM: x86: Protect the unused bits in the MSR filtering / exiting flags
  KVM: x86: Add a VALID_MASK for the flags in kvm_msr_filter_range
  selftests: kvm/x86: Test the flags in MSR filtering / exiting

 arch/x86/include/uapi/asm/kvm.h               |  3 +
 arch/x86/kvm/x86.c                            |  8 +-
 include/uapi/linux/kvm.h                      |  3 +
 .../kvm/x86_64/userspace_msr_exit_test.c      | 95 +++++++++++++++++++
 4 files changed, 108 insertions(+), 1 deletion(-)

-- 
2.37.1.359.gd136c6c3e2-goog

