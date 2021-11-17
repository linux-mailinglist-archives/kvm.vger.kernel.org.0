Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92D3D454B1C
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 17:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235435AbhKQQlO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 11:41:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41780 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230292AbhKQQlM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Nov 2021 11:41:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637167093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=lPGN5sNnc45JU/u7eNCeUG16Q1MypWiIp4F+fUE+9/s=;
        b=DKaoHHiHorJrdA1LktUhiKOrqZNIsvQDUtD2cWy6pnBRa0DYRY3l2T4xBQjQP6CUaUMiIS
        TSNJu06ARwFEhEATdhH7fVMYkcfL8cIootgW2gdiXh8jSRnUZNOLwHIi3Iiz9FvDIQRq8g
        jkdrd+M0Ja8E8jYlbHN1kbJctXWZCsI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-rRdrb1cMNKWvOUW4MiAPSw-1; Wed, 17 Nov 2021 11:38:11 -0500
X-MC-Unique: rRdrb1cMNKWvOUW4MiAPSw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 992E815723;
        Wed, 17 Nov 2021 16:38:10 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3AFBF604CC;
        Wed, 17 Nov 2021 16:38:10 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pgonda@google.com, seanjc@google.com
Subject: [PATCH 0/4] MOVE/COPY_ENC_CONTEXT_FROM locking cleanup and tests
Date:   Wed, 17 Nov 2021 11:38:05 -0500
Message-Id: <20211117163809.1441845-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patches 1 and 2 are the long-awaited tests for COPY_ENC_CONTEXT_FROM,
based on the ones for intra-host migration.  The aim of patches 3
and 4 is to simplify the locking for COPY_ENC_CONTEXT_FROM, and solving
(by sidestepping the question) the problem of a VM's encryption
context being moved from and copied from at the same time.

These patches are an alternative to Sean's patch with subject "KVM:
SEV: Explicitly document that there are no TOCTOU races in copy ASID"
(https://lore.kernel.org/kvm/76c7c752-f1b0-f100-03dd-364366eff02f@redhat.com/T/).

There is another bug: a VM that is the owner of a copied context must not
be migrated, otherwise you could have a dangling ASID:

1. copy context from A to B (gets ref to A)
2. move context from A to L (moves ASID from A to L)
3. close L (releases ASID from L, B still references it)

The right way to do the handoff instead is to create a fresh mirror VM
on the destination first:

1. copy context from A to B (gets ref to A)
[later] 2. close B (releases ref to A)
3. move context from A to L (moves ASID from A to L)
4. copy context from L to M

I'll take a look at this later, probably next week after this series has
been reviewed.

Paolo


Paolo Bonzini (4):
  selftests: sev_migrate_tests: free all VMs
  selftests: sev_migrate_tests: add tests for
    KVM_CAP_VM_COPY_ENC_CONTEXT_FROM
  KVM: SEV: cleanup locking for KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM
  KVM: SEV: Do COPY_ENC_CONTEXT_FROM with both VMs locked

 arch/x86/kvm/svm/sev.c                        | 118 ++++++++----------
 .../selftests/kvm/x86_64/sev_migrate_tests.c  | 113 +++++++++++++++--
 2 files changed, 155 insertions(+), 76 deletions(-)

-- 
2.27.0

