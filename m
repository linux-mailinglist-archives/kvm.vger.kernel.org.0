Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D30A4689DF
	for <lists+kvm@lfdr.de>; Sun,  5 Dec 2021 09:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbhLEIRO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Dec 2021 03:17:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:60778 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231848AbhLEIRO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 5 Dec 2021 03:17:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638692026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+fvYUavziIvq7sJU7R1R6ucdO1nK2nhVzkQjR1naZ5w=;
        b=U3XGzQ1cqOihA3GfeemW3g5tN1OwObW5BfkWIe6KMx0AJ9MjjhBRQ2oHm3k1KWMJltaseR
        HCBiaeyaJ4ftoKZdz1RsgiqDnbOsEXPga/fsaYWE4hdRWCJwlWYcVVylqz/YEyscVnf14R
        rpVKjuPNObSV0pXoDnKyyH2aXVl+qlY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-193-Hzs7yFY5ME-hNfCmhM5nKg-1; Sun, 05 Dec 2021 03:13:42 -0500
X-MC-Unique: Hzs7yFY5ME-hNfCmhM5nKg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A5C632F23;
        Sun,  5 Dec 2021 08:13:40 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 57C5910016F4;
        Sun,  5 Dec 2021 08:13:40 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] Second batch of KVM fixes for 5.16-rc4
Date:   Sun,  5 Dec 2021 03:13:39 -0500
Message-Id: <20211205081339.8716-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 7cfc5c653b07782e7059527df8dc1e3143a7591e:

  KVM: fix avic_set_running for preemptable kernels (2021-11-30 07:40:48 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to ad5b353240c8837109d1bcc6c3a9a501d7f6a960:

  KVM: SVM: Do not terminate SEV-ES guests on GHCB validation failure (2021-12-05 03:02:04 -0500)

----------------------------------------------------------------
* Static analysis fix
* New SEV-ES protocol for communicating invalid VMGEXIT requests
* Ensure APICv is considered inactive if there is no APIC
* Fix reserved bits for AMD PerfEvtSeln register

----------------------------------------------------------------
Dan Carpenter (1):
      KVM: VMX: Set failure code in prepare_vmcs02()

Like Xu (1):
      KVM: x86/pmu: Fix reserved bits for AMD PerfEvtSeln register

Paolo Bonzini (1):
      KVM: ensure APICv is considered inactive if there is no APIC

Sean Christopherson (3):
      KVM: x86/mmu: Retry page fault if root is invalidated by memslot update
      KVM: SEV: Return appropriate error codes if SEV-ES scratch setup fails
      KVM: SEV: Fall back to vmalloc for SEV-ES scratch area if necessary

Tom Lendacky (1):
      KVM: SVM: Do not terminate SEV-ES guests on GHCB validation failure

 arch/x86/include/asm/kvm_host.h   |   1 +
 arch/x86/include/asm/sev-common.h |  11 ++++
 arch/x86/kvm/mmu/mmu.c            |  23 ++++++++-
 arch/x86/kvm/mmu/paging_tmpl.h    |   3 +-
 arch/x86/kvm/svm/avic.c           |   1 +
 arch/x86/kvm/svm/pmu.c            |   2 +-
 arch/x86/kvm/svm/sev.c            | 102 ++++++++++++++++++++++----------------
 arch/x86/kvm/vmx/nested.c         |   4 +-
 arch/x86/kvm/vmx/vmx.c            |   1 +
 arch/x86/kvm/x86.c                |   9 ++--
 10 files changed, 106 insertions(+), 51 deletions(-)

