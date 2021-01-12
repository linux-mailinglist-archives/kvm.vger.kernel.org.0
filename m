Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A07492F360D
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 17:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404872AbhALQoo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 11:44:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28931 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404683AbhALQoo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 11:44:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610469798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=RUslB6q7RxjLtV6kH7HKHwCBZnZvPnq5E+zwqql6G8Y=;
        b=Fhax8wXJ/mrrJrjwApexltD/hWx9PNVfaPdANoKmH4Gfw8ObSVvHvW9p+36v5Frcl22Yfe
        9rqm1fzhVabJUwLn0l5rZpHnjV5QcnzESB5g/6M8UbE21hjvVrp1kkXx+UiuCvFhZSpCk+
        zpGgwef09ZSgHGdn2nlVkHorEpJoYrk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-565-mwIeKspGNryfQOsFEelNyw-1; Tue, 12 Jan 2021 11:43:15 -0500
X-MC-Unique: mwIeKspGNryfQOsFEelNyw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A72B51F7;
        Tue, 12 Jan 2021 16:43:14 +0000 (UTC)
Received: from virtlab710.virt.lab.eng.bos.redhat.com (virtlab710.virt.lab.eng.bos.redhat.com [10.19.152.252])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BC9435C1B4;
        Tue, 12 Jan 2021 16:43:13 +0000 (UTC)
From:   Cathy Avery <cavery@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     vkuznets@redhat.com, wei.huang2@amd.com,
        sean.j.christopherson@intel.com
Subject: [PATCH 0/2] KVM: SVM: Track physical cpu and asid_generation via the vmcb
Date:   Tue, 12 Jan 2021 11:43:11 -0500
Message-Id: <20210112164313.4204-1-cavery@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

Cathy Avery (2):
  KVM: nSVM: Track the physical cpu of the vmcb vmrun through the vmcb
  KVM: nSVM: Track the ASID generation of the vmcb vmrun through the
    vmcb

 arch/x86/kvm/svm/svm.c | 45 +++++++++++++++++++++++-------------------
 arch/x86/kvm/svm/svm.h |  3 ++-
 2 files changed, 27 insertions(+), 21 deletions(-)

-- 
2.20.1

