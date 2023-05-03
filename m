Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56EA66F5BB9
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 18:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbjECQIp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 12:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbjECQIn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 12:08:43 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90195FD9
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 09:08:42 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1ab0669d9c5so15067485ad.2
        for <kvm@vger.kernel.org>; Wed, 03 May 2023 09:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683130122; x=1685722122;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KcYtuxqAgVGBgurjFyNHaXvrsul7KgRgwWzw0ovjlnc=;
        b=hphZ8wd1Zv16lpYBkNFzoEJuAl578cQ/7U3agitk1KpY+w61rX7jQTq7slBGzNJF3i
         cdot16MZ+dvGln6swYXBKA5HxxOzlR+SIfdfe5JTv9Gmlj6q96nq5LoN3fzrc+++FVRN
         YDSGNGX+yRf71f37+QYCEZbuXOc75aPyh1rTOXofCG2glR+cWdpvijltvb4A4z8+DCQ6
         rk77AjIUPJOHV9Zm3eKRG1YAptSufEUzz77KMlUZ6X0V8a8FvYvWfnepOYrupv2zePKz
         cQan+Bj2BdctFglNRSkg5Mg77ykxGZav25pPDtU33IziPp3uXUGLyeHyHT5yP45x9JIk
         4HVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683130122; x=1685722122;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KcYtuxqAgVGBgurjFyNHaXvrsul7KgRgwWzw0ovjlnc=;
        b=Igldd6GlIZoEQOUlU5fdvYsf1CUEPStlmaQ/W2ni+nhFtPfT7Hqx00j4EvBiKmaqgR
         IzSWgNd4iVwV0JzM36siG56okwNQ/NWDNONCCCmIOgijLM0z+kNfK6gYimM1QkvEYZey
         FZUDgSLWeU0qlPuIp8FkfYDeNncuWVGMOmyA/hjpXR7D9AbXP9Beg29tfhDw0XP1pzV5
         TVicfR7Jm3mDqNxCm5TaSmGmFb2+VcNOJ9eKiCkIgbYagfSs+mApdzIhhIVnG4Vffll1
         jiN0CdChyB5yam63tkNWqauN5Eezv9q5c2/p58zZNkr0mCYd87qwsWajF74vTQlTAJXZ
         1W6Q==
X-Gm-Message-State: AC+VfDydVIqZDZSdb/GKEYcHtsrj6qkOArYPSyJ75/WqwQFAqs7zViMg
        1NdKcuZ5JvborM2Cv9xFotjA7tIv+k4=
X-Google-Smtp-Source: ACHHUZ7zOoQNTe0gVzNkwyUHwCla1VhS8hV2cBXkj3VC8I62zL/0MfHWKFCkq5D1dps+apmi88hMmf+JZ3k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:b591:b0:1a5:15bb:e3cb with SMTP id
 a17-20020a170902b59100b001a515bbe3cbmr152997pls.12.1683130121699; Wed, 03 May
 2023 09:08:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  3 May 2023 09:08:35 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
Message-ID: <20230503160838.3412617-1-seanjc@google.com>
Subject: [PATCH v2 0/3] KVM: x86: SGX vs. XCR0 cleanups
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Stop adjusting the guest's CPUID info for the allowed XFRM (a.k.a. XCR0)
for SGX enclaves.  Past me didn't understand the roles and responsibilities
between userspace and KVM with respect to CPUID leafs, i.e. I thought I was
being helpful by having KVM adjust the entries.

This is clearly an ABI change, but QEMU does the right thing and AFAIK no
other VMMs support SGX (yet), so I'm hopeful/confident that we can excise
the ugly before userspace starts depending on the bad behavior.
 
v2:
 - Collect reviews/testing. [Kai]
 - Require FP+SSE to always be set in XFRM, and exempt them from the XFRM
   vs. XCR0 check. [Kai]

v1: https://lore.kernel.org/all/20230405005911.423699-1-seanjc@google.com

Sean Christopherson (3):
  KVM: VMX: Don't rely _only_ on CPUID to enforce XCR0 restrictions for
    ECREATE
  KVM: x86: Don't adjust guest's CPUID.0x12.1 (allowed SGX enclave XFRM)
  KVM: x86: Open code supported XCR0 calculation in
    kvm_vcpu_after_set_cpuid()

 arch/x86/kvm/cpuid.c   | 43 ++++++++++--------------------------------
 arch/x86/kvm/vmx/sgx.c | 11 +++++++++--
 2 files changed, 19 insertions(+), 35 deletions(-)


base-commit: 5c291b93e5d665380dbecc6944973583f9565ee5
-- 
2.40.1.495.gc816e09b53d-goog

