Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D04D157E843
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 22:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236341AbiGVUXN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 16:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233195AbiGVUXM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 16:23:12 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5481FAF870
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 13:23:10 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id v1-20020a259d81000000b0066ec7dff8feso4394350ybp.18
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 13:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=3DKrfoh61Dqk6Sa/nAKARj+FQDg0i5e4KBmQvEvcS2s=;
        b=j0/4QiM2sGxSn//FUxRPUuhp++Ne+jXeznezeNxC2YIXonamyN3Wv9QQfO6wGmabZy
         CkUcvXobHBYBvgfvBloT29Ah14Yads9R/V5KHZqJObNImKuVWRSBoZHxGLk3bi8NUVJK
         sTgPCBVdz+X+uMZuaLrYE7bj7QeQCn3HFI2p2INBX3kok+DAbErkDHPb2mTOMb3n1TcR
         4/exj5aARp/ILpXpVcV+8mfmwKmgNoryT6ksBrJHJj8KBq1lO3Nk0MXvUJN/CzUu6OCe
         qaCkR26ZDW6wE6+pAgGTAh9uShGM55nqxYwLLaci4hLSVpEw9rTKBI73gKbvmU5rTAc8
         8Guw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=3DKrfoh61Dqk6Sa/nAKARj+FQDg0i5e4KBmQvEvcS2s=;
        b=xMHE57rOg/N1LtGBHT3oxl5V9EzdoON15oPHsuAWOuYwrQvz4BLmjd9yzNpoQXva+E
         Xli7Rp64UMkF6SSBcmFH9Q9t00i3QUAEk+huhR8ek+FKyutc0HgpOlvqL1PxOOT5uoMN
         xILmPC0X2gRWQ04cPo+y9Y1tWfmCAaeFLSi/Hxtu5EibeviVPNUTsTJ6G0+0UUawL0ZA
         2odkoVkRyrbH2AbNMd3Y/hxm0UgpCcWCRPypBtCNF6jFCKZUa51DDr7n+dgbcg4EpSI5
         l8QDtNVH6F966+rmqrkIlCGHWCKWQqAvHdr3Gr78b1jYmD1QZ9QTDXI6xYY/X3BxrHAY
         U0yg==
X-Gm-Message-State: AJIora9swbJjTOI1S5nlbVwK0gNX1xkuNgr1kkwUtuVJhPtGvl/AbS3P
        J67Uxh2NxlxcI2OLGQHzGcG+bsAfk9lqDBmmcjkPL6CmAUkumwjL0uQfNtPR8fgY7cC9B7Gy7X/
        5bJ+z3vWA00EwvDzd4+pJsUSEj8beK69QYn0PTVctTNUg9X3KeT4X2F1hpcljjBr4JOc6
X-Google-Smtp-Source: AGRyM1uNzE+SHMa2FmYt1lsh0VTiAdvlqVzeqcA1kudP6HfJekAEsfTbVlCNF8GF5QmYN4dd2gdeSlZNiWwjn0H7
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a81:1545:0:b0:31e:73f6:13f4 with SMTP
 id 66-20020a811545000000b0031e73f613f4mr1399348ywv.127.1658521389552; Fri, 22
 Jul 2022 13:23:09 -0700 (PDT)
Date:   Fri, 22 Jul 2022 20:22:59 +0000
Message-Id: <20220722202303.391709-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [RFC PATCH v3 0/4] MSR filtering / exiting flag cleanup
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

Note: Patch 1/4 does not change the ABI and patch 3/4 does not contain
functional changes, so they are not labeled as RFCs.

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

Aaron Lewis (4):
  KVM: x86: Do not allow use of the MSR filter allow flag in the kernel
  KVM: x86: Protect the unused bits in the MSR filtering / exiting flags
  KVM: x86: Add a VALID_MASK for the flags in kvm_msr_filter_range
  selftests: kvm/x86: Test the flags in MSR filtering / exiting

 arch/x86/include/uapi/asm/kvm.h               |  5 ++
 arch/x86/kvm/x86.c                            |  8 +-
 include/uapi/linux/kvm.h                      |  3 +
 .../kvm/x86_64/userspace_msr_exit_test.c      | 85 +++++++++++++++++++
 4 files changed, 100 insertions(+), 1 deletion(-)

-- 
2.37.1.359.gd136c6c3e2-goog

