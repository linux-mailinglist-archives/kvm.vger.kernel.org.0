Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74C8E70AE04
	for <lists+kvm@lfdr.de>; Sun, 21 May 2023 14:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjEUMSK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 May 2023 08:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjEUMSI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 May 2023 08:18:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBCFB0
        for <kvm@vger.kernel.org>; Sun, 21 May 2023 05:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684671440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=PVI1SUuvnV8gNQBr8/dAeXC/qHkJbwltv/7php7lDhI=;
        b=ZZcrDerdH4Mj4kX0lUQhr2rdWlmRhodO8/uWQvd/ofQuM+CwuR96MmZVnRn3QbGT3DvsXK
        n4q49s3gwgl2DU8eIRGXrRJ27+Xs95BQZeg8gk5au93LtqPx2Ctng6uO1Q2mN630L5dtre
        AoiZ4kqoMfKF9gXzTODJ3239SfAQGHY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-557-LcsKmLGMPUeS_mfMisKkTA-1; Sun, 21 May 2023 08:17:19 -0400
X-MC-Unique: LcsKmLGMPUeS_mfMisKkTA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-30932d15a30so2897387f8f.1
        for <kvm@vger.kernel.org>; Sun, 21 May 2023 05:17:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684671438; x=1687263438;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PVI1SUuvnV8gNQBr8/dAeXC/qHkJbwltv/7php7lDhI=;
        b=J7W746xyv7uNo4iBBOi88wDm9F7wjjN0eY/O1PIv0xhbGKAl52YrX0TygB39otLitc
         Gj2g89La1M3qhrUmWiwK/OjxA3d5XIzMsTb2+NBK6KuSUevqQY9TM7IPEeSljBC5OpoN
         XQE1EorB63W2Z+VdGTurRCe4cVLiHM2QU6OaBK6nDsibCYi94IZOmwikntQ3yEX4txlU
         eAi9hUgbid+/+g/4fX1WrfBcQrikIY6HwPCA5Z7hiZ3uJtZvHg94L0ch2J7VDl6jaoXO
         CRPdieULcrFihWKVNpFtb8C0AIREupxIv/EhjGNZrGnptCdmvwz+4YTT6X4i5gCflF/Z
         drSw==
X-Gm-Message-State: AC+VfDzAefQs84IerTRNpWX3/NbKXOon0+Dig0+AKIKO/rcThLezkBkW
        WXQTvBGAuZjfBuYNw4pywQJfAAeZ+6XOytno7otT+r6MvlEzTcho6gd6hh+UD+82m7gwvNxa1gq
        L53EmvsSi6MukkoRIFNvx
X-Received: by 2002:adf:ef02:0:b0:304:6a26:1f6 with SMTP id e2-20020adfef02000000b003046a2601f6mr5438315wro.59.1684671437923;
        Sun, 21 May 2023 05:17:17 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7MabypKyS43fFTGDOIMddCh8GmeAQuT0OWOFj+HgMqjnBfB1qqcakVGaLM+RJUoDZY8N6ccg==
X-Received: by 2002:adf:ef02:0:b0:304:6a26:1f6 with SMTP id e2-20020adfef02000000b003046a2601f6mr5438307wro.59.1684671437551;
        Sun, 21 May 2023 05:17:17 -0700 (PDT)
Received: from [192.168.10.118] ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id o16-20020a5d62d0000000b002fb60c7995esm4602199wrv.8.2023.05.21.05.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 May 2023 05:17:16 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 6.4-rc3
Date:   Sun, 21 May 2023 14:17:15 +0200
Message-Id: <20230521121715.45809-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit f1fcbaa18b28dec10281551dfe6ed3a3ed80e3d6:

  Linux 6.4-rc2 (2023-05-14 12:51:40 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to b9846a698c9aff4eb2214a06ac83638ad098f33f:

  KVM: VMX: add MSR_IA32_TSX_CTRL into msrs_to_save (2023-05-21 04:05:51 -0400)

----------------------------------------------------------------
ARM:
* Plug a race in the stage-2 mapping code where the IPA and the PA
  would end up being out of sync

* Make better use of the bitmap API (bitmap_zero, bitmap_zalloc...)

* FP/SVE/SME documentation update, in the hope that this field
  becomes clearer...

* Add workaround for Apple SEIS brokenness to a new SoC

* Random comment fixes

x86:

* add MSR_IA32_TSX_CTRL into msrs_to_save

* fixes for XCR0 handling in SGX enclaves

Generic:

* Fix vcpu_array[0] races

* Fix race between starting a VM and "reboot -f"

----------------------------------------------------------------
Christophe JAILLET (2):
      KVM: arm64: Slightly optimize flush_context()
      KVM: arm64: Use the bitmap API to allocate bitmaps

Jacob Xu (1):
      KVM: VMX: Fix header file dependency of asm/vmx.h

Jingyu Wang (1):
      KVM: arm64: Fix repeated words in comments

Marc Zyngier (4):
      KVM: arm64: Constify start/end/phys fields of the pgtable walker data
      KVM: arm64: vgic: Add Apple M2 PRO/MAX cpus to the list of broken SEIS implementations
      Merge branch kvm-arm64/misc-6.4 into kvmarm-master/fixes
      Merge branch kvm-arm64/pgtable-fixes-6.4 into kvmarm-master/fixes

Mark Brown (3):
      KVM: arm64: Document check for TIF_FOREIGN_FPSTATE
      KVM: arm64: Restructure check for SVE support in FP trap handler
      KVM: arm64: Clarify host SME state management

Michal Luczaj (1):
      KVM: Fix vcpu_array[0] races

Mingwei Zhang (1):
      KVM: VMX: add MSR_IA32_TSX_CTRL into msrs_to_save

Oliver Upton (2):
      KVM: arm64: Infer the PA offset from IPA in stage-2 map walker
      KVM: arm64: Infer PA offset from VA in hyp map walker

Paolo Bonzini (1):
      Merge tag 'kvmarm-fixes-6.4-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD

Sean Christopherson (4):
      KVM: Use syscore_ops instead of reboot_notifier to hook restart/shutdown
      KVM: Don't enable hardware after a restart/shutdown is initiated
      KVM: VMX: Don't rely _only_ on CPUID to enforce XCR0 restrictions for ECREATE
      KVM: x86: Don't adjust guest's CPUID.0x12.1 (allowed SGX enclave XFRM)

 arch/arm64/include/asm/cputype.h        |  8 +++++
 arch/arm64/include/asm/kvm_pgtable.h    |  1 +
 arch/arm64/kvm/fpsimd.c                 | 26 ++++++++++-----
 arch/arm64/kvm/hyp/include/hyp/switch.h | 12 +++++--
 arch/arm64/kvm/hyp/pgtable.c            | 41 ++++++++++++++++++-----
 arch/arm64/kvm/inject_fault.c           |  2 +-
 arch/arm64/kvm/vgic/vgic-v3.c           |  4 +++
 arch/arm64/kvm/vmid.c                   |  7 ++--
 arch/x86/include/asm/vmx.h              |  2 ++
 arch/x86/kvm/cpuid.c                    | 16 ---------
 arch/x86/kvm/vmx/sgx.c                  | 11 ++++--
 arch/x86/kvm/x86.c                      |  6 +++-
 virt/kvm/kvm_main.c                     | 59 +++++++++++++++++++++------------
 13 files changed, 129 insertions(+), 66 deletions(-)

