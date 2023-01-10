Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9906647AD
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 18:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234218AbjAJRvI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 12:51:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233030AbjAJRvF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 12:51:05 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B652E33D75
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 09:51:04 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id j1-20020aa78001000000b0057d28e11cb6so5538808pfi.11
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 09:51:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hICen6oMGDQkBaOVpNtEPss3TFZW17o9hNwTIHD4XGI=;
        b=WpvpBPEkoeRepVIhMXcWbpDTls42db3NlhJOX2Xa2fI5tCL+RRSnDNv0d1YyHoB/xL
         88vtalk4biVmwYUAr3u/epHuOQPGXZWtc65NpaPUqXDxdhfB2niD80YQ6/pZ+kCsKHj4
         RyUX1weIOE9Uqq6pL1AUuC89a/fkgQtde8WIkwVf4ld3RFW+NEXyPOseRzBHiqixNTQB
         fSzGt0mP4920wARoIPfEbVEEY36C1eBCXu1ezZlaOF/bR/2vuyKDyXSJxfSzKUXgzbCv
         ypF0kYOcvp6/BhOVuExlLyPfBWbtjKAVMg6yjAdNmFyRSVG/xdc5rpuTpt4ev8iCTyS9
         jgmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hICen6oMGDQkBaOVpNtEPss3TFZW17o9hNwTIHD4XGI=;
        b=lrcjeSscclwsBQoE9CqSADxPsdJ2ac376ta6nqwnO2kaHS0gmH08bPtx9GuUZOKOfN
         XWfTyPur7hNni1TQAQebT2pA2YzDtvkyoStKsWE0aO8AYt9V6MoZtUum39PSCc/4kTKy
         zygl/uIec7F0II/bsZNwZbmIAqcgQ7Pnwob+oDta7pV6mzKaIeOlQRpmHcfKHACYP2Cl
         w2C5oQErfcokLuVWDK+di3Xoccsji5OuEgSruJHAWGzgcbMI+gl2JJVrnAFDswcCNKQA
         pP07qrw8mpJ4dleDdD/jGxo9DsXeiXAFY9IovXi4HG2PgmK++T5Iz1fzYcI/w2/Y93r1
         0/lA==
X-Gm-Message-State: AFqh2kr/Q+uhwOa2uu583Tybs56izj3XhyiAvUGptaJ4ut4UUlXDjR//
        /KyW/zuzymVGKathg496fNHXO4uOncnH0Yalct00sMkCzFH2pzRHHXB5djAMWCpKd3M6p36vdSB
        KDDEVlcy3PsY7z0BWmkjLrxQ2UWJe7EhUXa7zko/d35MRkkAhpO93oRxwpg==
X-Google-Smtp-Source: AMrXdXtJj5IrfLfILiyHExkrE+IYgF2DxdiF4dI2bA7KWmJBpPzQvYYC44TxLRx+0lqL2HDHiUtIFtg+c40=
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:11:8358:4c2a:eae1:4752])
 (user=pgonda job=sendgmr) by 2002:a62:e512:0:b0:580:c2fb:7ed7 with SMTP id
 n18-20020a62e512000000b00580c2fb7ed7mr4521991pff.61.1673373064121; Tue, 10
 Jan 2023 09:51:04 -0800 (PST)
Date:   Tue, 10 Jan 2023 09:50:50 -0800
Message-Id: <20230110175057.715453-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Subject: [PATCH V6 0/7] KVM: selftests: Add simple SEV test
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>, marcorr@google.com,
        michael.roth@amd.com, thomas.lendacky@amd.com, joro@8bytes.org,
        pbonzini@redhat.com, andrew.jones@linux.dev, vannapurve@google.com,
        Sean Christopherson <seanjc@google.com>,
        Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series continues the work Michael Roth has done in supporting
SEV guests in selftests. It continues on top of the work Sean
Christopherson has sent to support ucalls from SEV guests. Along with a
very simple version of the SEV selftests Michael originally proposed.

V6
 * Updated SEV VM create function based on Seanjc's feedback and new
   changes to VM creation functions.
 * Removed pte_me_mask based on feedback.
 * Fixed s_bit usage based on TDX
 * Fixed bugs and took Ackerly's code for enc_region setup code.

V5
 * Rebase onto seanjc@'s latest ucall pool series.
 * More review changes based on seanjc:
 ** use protected instead of encrypted outside of SEV specific files
 ** Swap memcrypt struct for kvm_vm_arch arch specific struct
 ** Make protected page table data agnostic of address bit stealing specifics
    of SEV
 ** Further clean up for SEV library to just vm_sev_create_one_vcpu()
 * Due to large changes moved more authorships from mroth@ to pgonda@. Gave
   originally-by tags to mroth@ as suggested by Seanjc for this.

V4
 * Rebase ontop of seanjc@'s latest Ucall Pool series:
   https://lore.kernel.org/linux-arm-kernel/20220825232522.3997340-8-seanjc@google.com/
 * Fix up review comments from seanjc
 * Switch authorship on 2 patches because of significant changes, added
 * Michael as suggested-by or originally-by.

V3
 * Addressed more of andrew.jones@ in ucall patches.
 * Fix build in non-x86 archs.

V2
 * Dropped RFC tag
 * Correctly separated Sean's ucall patches into 2 as originally
   intended.
 * Addressed andrew.jones@ in ucall patches.
 * Fixed ucall pool usage to work for other archs

V1
 * https://lore.kernel.org/all/20220715192956.1873315-1-pgonda@google.com/

Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: marcorr@google.com
Cc: michael.roth@amd.com
Cc: thomas.lendacky@amd.com
Cc: joro@8bytes.org
Cc: pbonzini@redhat.com
Cc: andrew.jones@linux.dev
Cc: vannapurve@google.com
Cc: Sean Christopherson <seanjc@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>

Michael Roth (2):
  KVM: selftests: sparsebit: add const where appropriate
  KVM: selftests: add support for protected vm_vaddr_* allocations

Peter Gonda (5):
  KVM: selftests: add hooks for managing protected guest memory
  KVM: selftests: handle protected bits in page tables
  KVM: selftests: add library for creating/interacting with SEV guests
  KVM: selftests: Update ucall pool to allocate from shared memory
  KVM: selftests: Add simple sev vm testing

 tools/arch/arm64/include/asm/kvm_host.h       |   7 +
 tools/arch/riscv/include/asm/kvm_host.h       |   7 +
 tools/arch/s390/include/asm/kvm_host.h        |   7 +
 tools/arch/x86/include/asm/kvm_host.h         |  14 +
 tools/testing/selftests/kvm/.gitignore        |  84 ++++++
 tools/testing/selftests/kvm/Makefile          |   4 +-
 .../selftests/kvm/include/kvm_util_base.h     |  49 +++-
 .../testing/selftests/kvm/include/sparsebit.h |  36 +--
 .../selftests/kvm/include/x86_64/processor.h  |   1 +
 .../selftests/kvm/include/x86_64/sev.h        |  27 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    |  66 ++++-
 tools/testing/selftests/kvm/lib/sparsebit.c   |  48 ++--
 .../testing/selftests/kvm/lib/ucall_common.c  |   2 +-
 .../selftests/kvm/lib/x86_64/processor.c      |  62 ++++-
 tools/testing/selftests/kvm/lib/x86_64/sev.c  | 254 ++++++++++++++++++
 .../selftests/kvm/x86_64/sev_all_boot_test.c  |  84 ++++++
 16 files changed, 685 insertions(+), 67 deletions(-)
 create mode 100644 tools/arch/arm64/include/asm/kvm_host.h
 create mode 100644 tools/arch/riscv/include/asm/kvm_host.h
 create mode 100644 tools/arch/s390/include/asm/kvm_host.h
 create mode 100644 tools/arch/x86/include/asm/kvm_host.h
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/sev.h
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/sev.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/sev_all_boot_test.c

-- 
2.39.0.314.g84b9a713c41-goog

