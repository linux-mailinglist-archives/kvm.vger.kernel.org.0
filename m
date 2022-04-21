Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A45D50A7D1
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 20:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391246AbiDUSHu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 14:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391229AbiDUSHl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 14:07:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B00324B1F5
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 11:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650564289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=YOH2Qpi3OWvJdj6PxZT56UXJ38oEXRy/KfJlwINMGqU=;
        b=DhU5JDQ1Ev4eYXn/GiLrzFkJlaOB/qFUGAk55pr/J/D5h538bnEMG/CXJw6LX7EvoEXscy
        qN0sNa0ERbMp3SP3FJl7XmwJOS/eVv0NjABPauHuWJEv8NZHL/cdkBtmY70/MVizESjXvi
        JFnZ4W63glkV3IGz5FC/xnIs+IWLCoc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-547-ZUyglecdOV2CRHb3TKRkZA-1; Thu, 21 Apr 2022 14:04:44 -0400
X-MC-Unique: ZUyglecdOV2CRHb3TKRkZA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DAA72811E78;
        Thu, 21 Apr 2022 18:04:43 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 97A0140E80F5;
        Thu, 21 Apr 2022 18:04:43 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     will@kernel.org, maz@kernel.org, apatel@ventanamicro.com,
        atishp@rivosinc.com, seanjc@google.com, pgonda@google.com
Subject: [PATCH 0/4] KVM: fix KVM_EXIT_SYSTEM_EVENT mess
Date:   Thu, 21 Apr 2022 14:04:39 -0400
Message-Id: <20220421180443.1465634-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM_SYSTEM_EVENT_NDATA_VALID mechanism that was introduced
contextually with KVM_SYSTEM_EVENT_SEV_TERM is not a good match
for ARM and RISC-V, which want to communicate information even
for existing KVM_SYSTEM_EVENT_* constants.  Userspace is not ready
to filter out bit 31 of type, and fails to process the
KVM_EXIT_SYSTEM_EVENT exit.

Therefore, tie the availability of ndata to a system capability;
if the capability is present, ndata is always valid, so patch 1
makes x86 always initialize it.  Then patches 2 and 3 fix
ARM and RISC-V compilation and patch 4 enables the capability.

Only compiled on x86, waiting for acks.

Paolo

Paolo Bonzini (4):
  KVM: x86: always initialize system_event.ndata
  KVM: ARM: replace system_event.flags with ndata and data[0]
  KVM: RISC-V: replace system_event.flags with ndata and data[0]
  KVM: tell userspace that system_event.ndata is valid

 Documentation/virt/kvm/api.rst        | 29 +++++++++++++++------------
 arch/arm64/kvm/psci.c                 |  3 ++-
 arch/riscv/include/asm/kvm_vcpu_sbi.h |  2 +-
 arch/riscv/kvm/vcpu_sbi.c             |  5 +++--
 arch/riscv/kvm/vcpu_sbi_replace.c     |  4 ++--
 arch/riscv/kvm/vcpu_sbi_v01.c         |  2 +-
 arch/x86/kvm/svm/sev.c                |  3 +--
 arch/x86/kvm/x86.c                    |  2 ++
 include/uapi/linux/kvm.h              |  2 +-
 virt/kvm/kvm_main.c                   |  1 +
 10 files changed, 30 insertions(+), 23 deletions(-)

-- 
2.31.1

