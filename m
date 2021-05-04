Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABE61372C38
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 16:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbhEDOli (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 10:41:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31434 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231490AbhEDOla (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 May 2021 10:41:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620139235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r9Ktu9if4V7oYPGEWrItYebb+UdxeR5QQrWuE47aGr4=;
        b=BdbLzF69wyeT2hpxY9phusAO0C30W1F3lQh05FjX5V4oVw6axmYe8t8ikXl3jbjLG17EAT
        zsM+9X8UBgmZ1WNsrmLocWiVZhETWyelEUqW3dCHJvWd5yYmbh+oQkKAaDbynqx84KEq2r
        BHiubu+V0ZtmW5PBZXW0lXMhcEoikwM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-TwrWjQkAPnWtLzHtGrT70g-1; Tue, 04 May 2021 10:40:31 -0400
X-MC-Unique: TwrWjQkAPnWtLzHtGrT70g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0814D1009606;
        Tue,  4 May 2021 14:40:30 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.193.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B8FE25D9F2;
        Tue,  4 May 2021 14:40:23 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 1/2] KVM: nSVM: always restore the L1's GIF on migration
Date:   Tue,  4 May 2021 17:39:35 +0300
Message-Id: <20210504143936.1644378-2-mlevitsk@redhat.com>
In-Reply-To: <20210504143936.1644378-1-mlevitsk@redhat.com>
References: <20210504143936.1644378-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While usually the L1's GIF is set while L2 runs, and usually
migration nested state is loaded after a vCPU reset which
also sets L1's GIF to true, this is not guaranteed.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 32400cba608d..b331446f67f3 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1314,6 +1314,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	else
 		svm->nested.vmcb02.ptr->save = svm->vmcb01.ptr->save;
 
+	svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));
+
 	svm->nested.nested_run_pending =
 		!!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);
 
-- 
2.26.2

