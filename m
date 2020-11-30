Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6DB2C86FD
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 15:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbgK3Ola (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 09:41:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34146 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726220AbgK3Ol3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 09:41:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606747203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=cPuNmdbqLgkjH8YEAT3ik4nIW0hCX379Trx0CgGX7Vg=;
        b=gCvjFIJgr18cOM0ErD3++EZCMEWjNzyfcg6J4qBFn0t2hgGF/T32uKOZoDgOleFSVWx6uA
        HNRT4UJqZ+BgZOTr/kALZx9J4MJCSwdVm9naiMnUTFOoj49uo/f3p3DC3784OJcq4V46Z4
        paaXmZdef+xYJmP4uQBC3/75ncUjnac=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-137-f6kD4QFNNFq5arfZiyo9Bg-1; Mon, 30 Nov 2020 09:40:01 -0500
X-MC-Unique: f6kD4QFNNFq5arfZiyo9Bg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76917107ACFA;
        Mon, 30 Nov 2020 14:40:00 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 154D460C62;
        Mon, 30 Nov 2020 14:40:00 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>
Subject: [PATCH] KVM: x86: adjust SEV for commit 7e8e6eed75e
Date:   Mon, 30 Nov 2020 09:39:59 -0500
Message-Id: <20201130143959.3636394-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since the ASID is now stored in svm->asid, pre_sev_run should also place
it there and not directly in the VMCB control area.

Reported-by: Ashish Kalra <Ashish.Kalra@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c0b14106258a..3418bb18dae7 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1187,7 +1187,7 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
 	int asid = sev_get_asid(svm->vcpu.kvm);
 
 	/* Assign the asid allocated with this SEV guest */
-	svm->vmcb->control.asid = asid;
+	svm->asid = asid;
 
 	/*
 	 * Flush guest TLB:
-- 
2.26.2

