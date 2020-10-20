Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4AC28A974
	for <lists+kvm@lfdr.de>; Sun, 11 Oct 2020 20:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgJKSsY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Oct 2020 14:48:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27443 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727610AbgJKSsX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 11 Oct 2020 14:48:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602442102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Gis8IAfCSpyprY3jmYjG/eOLjrGcLccHLqCYUZm6G+4=;
        b=fbm+DgT0qnOmAPAcIqDAb8DzFfgAhsaRkQyVKXCkhfYS9qE0E6/wvhFzmzp4t/NWcEehW/
        +A1LtkHYPohiY9DISfNEu48Guki04jvk93RAuLkw8tDPhLCAvQyu/lRVRFMJ9O5OL6pAda
        jlMnrr1pAJcVjj4DPuDBXinH4jSUphQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372--EPAkvl1O2WZo7bPhVnjGA-1; Sun, 11 Oct 2020 14:48:20 -0400
X-MC-Unique: -EPAkvl1O2WZo7bPhVnjGA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A06702FD01;
        Sun, 11 Oct 2020 18:48:19 +0000 (UTC)
Received: from virtlab710.virt.lab.eng.bos.redhat.com (virtlab710.virt.lab.eng.bos.redhat.com [10.19.152.252])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E5DFD5C1DC;
        Sun, 11 Oct 2020 18:48:18 +0000 (UTC)
From:   Cathy Avery <cavery@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     vkuznets@redhat.com, wei.huang2@amd.com, mlevitsk@redhat.com
Subject: [PATCH v2 0/2] KVM: SVM: Create separate vmcbs for L1 and L2
Date:   Sun, 11 Oct 2020 14:48:16 -0400
Message-Id: <20201011184818.3609-1-cavery@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

svm->vmcb will now point to either a separate vmcb L1 ( not nested ) or L2 vmcb ( nested ).

Changes:
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
  KVM: SVM: Move asid to vcpu_svm
  KVM: SVM: Use a separate vmcb for the nested L2 guest

 arch/x86/kvm/svm/nested.c | 117 +++++++++++++++++---------------------
 arch/x86/kvm/svm/svm.c    |  46 ++++++++-------
 arch/x86/kvm/svm/svm.h    |  50 +++++-----------
 3 files changed, 93 insertions(+), 120 deletions(-)

-- 
2.20.1

