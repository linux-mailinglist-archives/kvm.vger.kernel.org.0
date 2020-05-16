Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 809D31D6170
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 15:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgEPNxU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 May 2020 09:53:20 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33592 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726374AbgEPNxT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 16 May 2020 09:53:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589637198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=FF/ooaDDfU4o/ecS6s5UdO9199Vv4g2oaCID5N2AiVg=;
        b=EBjpjrb2DMMUUXub+YBWeZhd4uv+QMBZy+5T+3tnTvlwixEecWpt17W2j5Lu4VYdJ3LyFR
        P023xjkqtZB8QzZUIyHc/pEwQaTlTM6qRtmiyLe7WKrhRBT5QNNusqJG7EguIULaj9dGQQ
        JPCyy6tnq3/Pq2QV4EjCun8d6vl/d1g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-MBor5CpnOA-WkrEwIEn2Rg-1; Sat, 16 May 2020 09:53:16 -0400
X-MC-Unique: MBor5CpnOA-WkrEwIEn2Rg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE81E80183C;
        Sat, 16 May 2020 13:53:15 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5FFEB5D9D3;
        Sat, 16 May 2020 13:53:15 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com
Subject: [PATCH 1/4] KVM: nSVM: fix condition for filtering async PF
Date:   Sat, 16 May 2020 09:53:08 -0400
Message-Id: <20200516135311.704878-2-pbonzini@redhat.com>
In-Reply-To: <20200516135311.704878-1-pbonzini@redhat.com>
References: <20200516135311.704878-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Async page faults have to be trapped in the host (L1 in this
case), since the APC reason was passed from L0 to L1 and stored
in the L1 APF data page.  This was completely reversed, as the
page faults were passed to the guest (a L2 hypervisor).

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 44b09ae419cf..e98ce5f6d562 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -889,8 +889,8 @@ int nested_svm_exit_special(struct vcpu_svm *svm)
 			return NESTED_EXIT_HOST;
 		break;
 	case SVM_EXIT_EXCP_BASE + PF_VECTOR:
-		/* When we're shadowing, trap PFs, but not async PF */
-		if (!npt_enabled && svm->vcpu.arch.apf.host_apf_reason == 0)
+		/* Trap async PF even if not shadowing */
+		if (!npt_enabled || svm->vcpu.arch.apf.host_apf_reason)
 			return NESTED_EXIT_HOST;
 		break;
 	default:
-- 
2.18.2


