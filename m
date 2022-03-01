Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4B94C8C43
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 14:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234767AbiCANJF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 08:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233631AbiCANJE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 08:09:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9456F1CFC1
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 05:08:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646140101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=G47XnttoMjqU/tQxN3E9pOF1GgvxHfmes01K+EO8oi0=;
        b=IHnnxXbIXRYAI3M8TAryoqID4t/aBCg8XuCco8S4z/WGSZXXGyazmAIaiAVa2RaAdRVOR2
        fonlktCFv7ioLUBOMSCQBmSRqqD3kW59BIUFX0vnApxk7T4s+CLOPX4qAa6DRXF//4lpEz
        sDFMY4OKHsUUOr0OPTMvCdYE2SFeN0M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-80-onNUPhVdMhaFdFUkDab97A-1; Tue, 01 Mar 2022 08:08:18 -0500
X-MC-Unique: onNUPhVdMhaFdFUkDab97A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F517800422;
        Tue,  1 Mar 2022 13:08:17 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AB9FF78363;
        Tue,  1 Mar 2022 13:08:16 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for 5.17-rc7
Date:   Tue,  1 Mar 2022 08:08:15 -0500
Message-Id: <20220301130815.151511-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit e910a53fb4f20aa012e46371ffb4c32c8da259b4:

  KVM: x86: nSVM: disallow userspace setting of MSR_AMD64_TSC_RATIO to non default value when tsc scaling disabled (2022-02-24 13:04:47 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to ece32a75f003464cad59c26305b4462305273d70:

  Merge tag 'kvmarm-fixes-5.17-4' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2022-02-25 09:49:30 -0500)

----------------------------------------------------------------
The bigger part of the change is a revert for x86 hosts.  Here the
second patch was supposed to fix the first, but in reality it was
just as broken, so both have to go.

x86 host:

* Revert incorrect assumption that cr3 changes come with preempt notifier
  callbacks (they don't when static branches are changed, for example)

ARM host:

* Correctly synchronise PMR and co on PSCI CPU_SUSPEND

* Skip tests that depend on GICv3 when the HW isn't available

----------------------------------------------------------------
Mark Brown (1):
      KVM: selftests: aarch64: Skip tests if we can't create a vgic-v3

Oliver Upton (1):
      KVM: arm64: Don't miss pending interrupts for suspended vCPU

Paolo Bonzini (1):
      Merge tag 'kvmarm-fixes-5.17-4' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD

Sean Christopherson (2):
      Revert "KVM: VMX: Save HOST_CR3 in vmx_set_host_fs_gs()"
      Revert "KVM: VMX: Save HOST_CR3 in vmx_prepare_switch_to_guest()"

 arch/arm64/kvm/psci.c                            |  3 +--
 arch/x86/kvm/vmx/nested.c                        | 11 +++++++---
 arch/x86/kvm/vmx/vmx.c                           | 28 ++++++++++++++----------
 arch/x86/kvm/vmx/vmx.h                           |  5 ++---
 tools/testing/selftests/kvm/aarch64/arch_timer.c |  7 +++++-
 tools/testing/selftests/kvm/aarch64/vgic_irq.c   |  4 ++++
 tools/testing/selftests/kvm/lib/aarch64/vgic.c   |  4 +++-
 7 files changed, 41 insertions(+), 21 deletions(-)

