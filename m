Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 695AC5257BE
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 00:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359141AbiELW1W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 18:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359127AbiELW1U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 18:27:20 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C0A06898C
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 15:27:19 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id d125-20020a636883000000b003db5e24db27so1760700pgc.13
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 15:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=CrGCN5hRJnxUm62pjm+0PSN0YfT03Pp0nPuxePlcuw4=;
        b=MAGgCVYbJbmTsUUkI04sS6wT4yI/vXAHYumXdYwQEPtPH3iOreL73vIeL1vS8CyaHs
         JR0mKpqbMETPdtOA+m/8H6q1G60wjrAv/hJ0ACZI+VpoCYnV+rTBXmoMSpWsk6TX0NhP
         Fl2OVJBMFGEKjvCl4085AUi0R2t7hbMxPTn9sOZSPBVwbrTkDIL8kqel05LFc+ro1fiy
         quntsRhh8JnuQlXnVrtbup64U9e8jmraf6JoUd7esjMO//YCkiBjjCmvMc4dHsw7gSmD
         yONXWUYGQib7sPoQxAS6EsfT/R5opTukg4PzVlhY1emTrym/iyC2pUEnzLy5pfc0BeHr
         G2jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=CrGCN5hRJnxUm62pjm+0PSN0YfT03Pp0nPuxePlcuw4=;
        b=ETdMI8xJGABkdD9xKIMKzSDLp13sIZ1HoEEXU3YK+KSgJxsYhu4wVD8loHsg+hr+8D
         XYyo+pDVi/cMlE0bl21A+u04hGuImoDn0btCgc6cRx9MTNLSoG2YIZAjhfadYyaOAVjT
         Z5r6Yro6VLONHl3Ipv4WW2PzDFBIom29EyHxflBenkn/5pV7s7vjeAKRBTnXG9umTLKc
         6gUQrqVGb0f7f+DQD2YPj3tId63/50ZgzpG47hAwrO/tK2/vE7zf8suyIMNvx1IPNFIb
         2Ta7zkvkNCgCTb/kwejEqKXPjk6IsQAHmGt09X85QpaxrgpxiqhMghsDuj9G2pRXfd58
         S73A==
X-Gm-Message-State: AOAM532nmk1VDC/JLFs7JChCUKrzTlHH5yNyc+5OW53SHgBv8oqUAPgM
        qWdUg9tOdZEtqiEDtOeSc2omVT5QTCk=
X-Google-Smtp-Source: ABdhPJxysQ+f8JO9eJpsr+WBwomg/Q2eFPxh5nGPZwJdh+D3jwr+jPeE90E/ROgn+BZfD26jiLeWJqUm4xw=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:e819:0:b0:510:693e:b20c with SMTP id
 c25-20020a62e819000000b00510693eb20cmr1667809pfi.60.1652394438872; Thu, 12
 May 2022 15:27:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 12 May 2022 22:27:13 +0000
Message-Id: <20220512222716.4112548-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH 0/3] KVM: x86: WRMSR MCi_CTL/STATUS bug fix and cleanups
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jue Wang <juew@google.com>
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

Fix bugs in set_msr_mce() where KVM returns '-1' instead of '1' when
rejecting a WRMSR, which results in -EPERM getting returned to userspace.

Patches 2 and 3 are cleanups to make {g,s}et_msr_mce a bit less wierd
(especially with respect to Jue's CMCI series) and a bit less magical.

Sean Christopherson (3):
  KVM: x86: Signal #GP, not -EPERM, on bad WRMSR(MCi_CTL/STATUS)
  KVM: x86: Use explicit case-statements for MCx banks in
    {g,s}et_msr_mce()
  KVM: x86: Add helpers to identify CTL and STATUS MCi MSRs

 arch/x86/kvm/x86.c | 84 +++++++++++++++++++++++++++-------------------
 1 file changed, 50 insertions(+), 34 deletions(-)


base-commit: 2764011106d0436cb44702cfb0981339d68c3509
-- 
2.36.0.550.gb090851708-goog

