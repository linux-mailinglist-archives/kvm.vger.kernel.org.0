Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAC6B299423
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 18:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1788140AbgJZRm3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 13:42:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54566 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1422241AbgJZRm3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Oct 2020 13:42:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603734148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Hr1VQIx12LkmscyRlZRpOxFqnwDRH9JcTtWbe8gtWCs=;
        b=EKMRuDH8l7t1Ok2qqkAhp3gGSiRkA5DS1+6bYyYc19RvppVcWmfMJeg7YyeYHSG+Q8c3M/
        wqvDtwfi4m0dKUAL7CkTjs++uwcxNFzSIJ6K+u+pweGYk7avmtMrcXz82MpTJMmH+dJ6YW
        DT0LhYawz4VVAsMIVrOdz28E2QDbwqQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-qjATM9bqNNS3voDuo7s8og-1; Mon, 26 Oct 2020 13:42:24 -0400
X-MC-Unique: qjATM9bqNNS3voDuo7s8og-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8879C56C89;
        Mon, 26 Oct 2020 17:42:23 +0000 (UTC)
Received: from virtlab710.virt.lab.eng.bos.redhat.com (virtlab710.virt.lab.eng.bos.redhat.com [10.19.152.252])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D84675577D;
        Mon, 26 Oct 2020 17:42:22 +0000 (UTC)
From:   Cathy Avery <cavery@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     vkuznets@redhat.com, wei.huang2@amd.com, mlevitsk@redhat.com,
        sean.j.christopherson@intel.com
Subject: [PATCH v3 0/2] KVM: SVM: Create separate vmcbs for L1 and L2
Date:   Mon, 26 Oct 2020 13:42:20 -0400
Message-Id: <20201026174222.21811-1-cavery@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

svm->vmcb will now point to either a separate vmcb L1 ( not nested ) or L2 vmcb ( nested ).

Changes:
v2 -> v3
 - Added vmcb switching helper.
 - svm_set_nested_state always forces to L1 before determining state
   to set. This is more like vmx and covers any potential L2 to L2 nested state switch.
 - Moved svm->asid tracking to pre_svm_run and added ASID set dirty bit
   checking.

v1 -> v2
 - Removed unnecessary update check of L1 save.cr3 during nested_svm_vmexit.
 - Moved vmcb01_pa to svm.
 - Removed get_host_vmcb() function.
 - Updated vmsave/vmload corresponding vmcb state during L2
   enter and exit which fixed the L2 load issue.
 - Moved asid workaround to a new patch which adds asid to svm.
 - Init previously uninitialized L2 vmcb save.gpat and save.cr4

Tested:
kvm-unit-tests
kvm self tests
Loaded fedora nested guest on fedora

Cathy Avery (2):
  KVM: SVM: Track asid from vcpu_svm
  KVM: SVM: Use a separate vmcb for the nested L2 guest

 arch/x86/kvm/svm/nested.c | 125 ++++++++++++++++++--------------------
 arch/x86/kvm/svm/svm.c    |  58 +++++++++++-------
 arch/x86/kvm/svm/svm.h    |  51 +++++-----------
 3 files changed, 110 insertions(+), 124 deletions(-)

-- 
2.20.1

