Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1D6B4FEB3A
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 01:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbiDLXah (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 19:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbiDLX3k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 19:29:40 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8263B9D4F3
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 15:31:38 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id q10-20020a17090a2dca00b001cb87691fbaso44353pjm.5
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 15:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=V6V2TPuMdTxTk1xnNTQfyxQ4GmRrM22L/5AR5NHn5BY=;
        b=BpQaRUcKQFv13J2AZVT8UkwOAg+1T7KE/RdxOgFVbzqEfe7GDwD8YRp5tTwQndJjca
         TiR3NOCWJaXSJjxW88tcwmi58Z2eNCbC7PnHLR+j2hV7ewP0/pJva8fQlonve7FN28jf
         E2ZNZWxJGLAx0eEL/4pNZDru+WoN9m6zldNw3qSPIlHLM7ncQzWCqjC1PYn8XEQOHZ0+
         tZhciJOzvMhusN98ibjtpsUC0aq7E7yXzrPvEXaDlF8b1af1dFNBXcJYx0s+fBq0BLGC
         nDlFiQRgvDivpn0Yr7IPx0FQ0kOxyaYJJteArvGKXxUke/LIVS7jkieuO76U8OC54W9W
         mY8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=V6V2TPuMdTxTk1xnNTQfyxQ4GmRrM22L/5AR5NHn5BY=;
        b=MlNApfcgEKGmyJBzMTN/EtcCjdy9DERiVbJivyc9SrXY8NS2kGfQuPFIu603jkKHWP
         KkD5xR9Jx7QfS7y3oJVkrrkyJcdN+x/ZrKFDrUht0rFtrQ/xph73zIsghZ0T99m1AFHJ
         KAU37IhDTH3Xf2xkNz5gpRbqZOfB9UqnX1BzbHw9sXGGGb17X/51ub8uPMas1w3WtEPz
         RFOyXZZXckhWIxTRjNSBhUoOHJHsynCSQUx9YzeFRM6u8KYRP/xwpDrdDLHXgGVaPjq7
         nfkDcCmWksUogoqLpqCdJNkTu1HmattOVBE0+8NE37TvmKIj/OXpG5Babn+/RHEvBpal
         EREQ==
X-Gm-Message-State: AOAM532ZxLxTtiK06WM+KABZ/fGEtMw1+daIN9vjpe5AFymrA5coBgay
        lAG1hiQfxzWKpc3QYshSEGN/EKnv
X-Google-Smtp-Source: ABdhPJyKeT9BuzXgxsj+68dJNbv1UwzS0Cv71pDo3sAMccyVhIrEgyKtSthgbyQ8hsrIFgN+0PDkkUcW
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:6315:7654:72ee:17c3])
 (user=juew job=sendgmr) by 2002:a05:6a00:22cf:b0:505:c880:41dc with SMTP id
 f15-20020a056a0022cf00b00505c88041dcmr11592468pfj.80.1649802697981; Tue, 12
 Apr 2022 15:31:37 -0700 (PDT)
Date:   Tue, 12 Apr 2022 15:31:30 -0700
Message-Id: <20220412223134.1736547-1-juew@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v2 0/4] KVM: x86: Add support of CMCI signaling and UCNA
From:   Jue Wang <juew@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        Jue Wang <juew@google.com>
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

This patch series add support for Corrected Machine Check Interrupt (CMCI)
signaling and UnCorrectable No Action required (UCNA) error injection to
KVM.

UCNA errors signaled via CMCI allow a guest to be notified as soon as
uncorrectable memory errors get detected by some background threads, e.g.,
threads that migrate guest memory across hosts.

Upon receiving UCNAs, guest kernel isolates the poisoned pages
immediately, preventing future accesses that may result in fatal Machine
Check Exceptions.

Jue Wang (4):
  KVM: x86: Clean up KVM APIC LVT logic.
  KVM: x86: Add LVTCMCI support.
  KVM: x86: Add support for MSR_IA32_MCx_CTL2 MSRs.
  KVM: x86: Add support for MCG_CMCI_P and handling of injected UCNAs.

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/lapic.c            | 56 ++++++++++++++------
 arch/x86/kvm/lapic.h            | 24 ++++++++-
 arch/x86/kvm/vmx/vmx.c          |  1 +
 arch/x86/kvm/x86.c              | 94 +++++++++++++++++++++++++++++----
 5 files changed, 149 insertions(+), 27 deletions(-)

-- 
2.35.1.1178.g4f1659d476-goog

