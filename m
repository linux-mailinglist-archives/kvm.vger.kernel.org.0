Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB6DA2F4CD6
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 15:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbhAMOMJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 09:12:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33405 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726618AbhAMOMJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 09:12:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610547042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=P+QVIP5CBe/0Vj6KzHneRhHf7M3Qi4BDmgyUB3KmL+k=;
        b=VdHHkccip8Oe85b95w746IKTMsIlhjWcgBJmg003jHaWYqEpb3VIXxGhshZrrqR21irHnv
        TlOX5KTm2CFEoDC/s/ncFRczmjKVKENUo+1dbt3BsxLAX+qKe8ERU4hXjPhQRVcFVW9+nd
        659PinWiWSlWNU4j5l63FNx70fXPq3o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-qnAJmLQsOHyJ8LYym0meCg-1; Wed, 13 Jan 2021 09:10:41 -0500
X-MC-Unique: qnAJmLQsOHyJ8LYym0meCg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 64AE2B8106;
        Wed, 13 Jan 2021 14:10:20 +0000 (UTC)
Received: from virtlab710.virt.lab.eng.bos.redhat.com (virtlab710.virt.lab.eng.bos.redhat.com [10.19.152.252])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C075B60BF1;
        Wed, 13 Jan 2021 14:10:19 +0000 (UTC)
From:   Cathy Avery <cavery@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     vkuznets@redhat.com, wei.huang2@amd.com
Subject: [PATCH v2 0/2] ] KVM: SVM: Track physical cpu and asid_generation via the vmcb
Date:   Wed, 13 Jan 2021 09:10:17 -0500
Message-Id: <20210113141019.5127-1-cavery@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the cases where vmcbs change processors from one vmrun to another updated
information in the vmcb from a prior run can potentially be lost. By tracking
the physical cpu and asid_generation per vmcb instead of svm->vcpu the following
scenario illustrated by Paolo can be avoided.

     ---------------------          ---------------------
     pCPU 1                         pCPU 2
     ---------------------          ---------------------
     run VMCB02
                                    run VMCB02 (*)
                                    run VMCB01
     run VMCB01 (**)
     run VMCB02 (***)
     ---------------------          ---------------------

     After the point marked (*), while L2 runs, some fields change in VMCB02.
     When the processor vmexits back to L0, VMCB02 is marked clean.

     At the point marked (**), svm->vcpu.cpu becomes 1 again.

     Therefore, at the point marked (***) you will get svm->vcpu.cpu == cpu
     and the VMCB02 will not be marked dirty.  The processor can then incorrectly
     use some data that is cached from before point (*).

Theses patches are intended for the kvm nested-svm branch.

The patches have been tested on nested fedora VMs, kvm self tests, and kvm-unit-tests.
They have not been tested on SEV.

Changes v1 -> v2:
- Remove outdated comment from svm_switch_vmcb().

Cathy Avery (2):
  KVM: nSVM: Track the physical cpu of the vmcb vmrun through the vmcb
  KVM: nSVM: Track the ASID generation of the vmcb vmrun through the
    vmcb

 arch/x86/kvm/svm/svm.c | 40 ++++++++++++++++++++--------------------
 arch/x86/kvm/svm/svm.h |  3 ++-
 2 files changed, 22 insertions(+), 21 deletions(-)

-- 
2.20.1

