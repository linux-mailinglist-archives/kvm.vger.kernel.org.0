Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58AEC17E401
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 16:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbgCIPwh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 11:52:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46697 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727171AbgCIPwg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 11:52:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583769155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kEZnDQ3EPN69hzxp+XwMgJi39q3+ALjlYK44BICSftw=;
        b=GvZT5/J4pkkznu2EBQOZY/Bs6XiUBrRRBJuKY6WWCwST1YFVv5nIvcDGyXseJjyT+8UGp/
        GLtsLA0E/9kC9L6m+/TGtjUD3IkUF+IdeuRmEpX8Hts3e0AvZsS+ZEKiISpxFwGKDPK+XV
        1HhTHICsmQRfUN7ojIraYEGb97ZdYYM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-8hg-rbRHP_ON8fBtS4JqUA-1; Mon, 09 Mar 2020 11:52:34 -0400
X-MC-Unique: 8hg-rbRHP_ON8fBtS4JqUA-1
Received: by mail-wr1-f69.google.com with SMTP id j5so433883wrt.1
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 08:52:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kEZnDQ3EPN69hzxp+XwMgJi39q3+ALjlYK44BICSftw=;
        b=JsvJaMl+RB5oW4S8nV71gTQpM7A5T4ubA8Fb8TDZeZgdntTUHm959hHt+Fkvd2b4uq
         9/LLkG5pxOEvnBI+jS6L749HJ/OgOMEsosyijRGYtsy8J/Nq17KYnwd8fRxHGM14aKMo
         XG9w353YVuHOY3wT4p26hkvqmdAJVX6xYsrtzJ9dbnK5Nign1cWisl3xoKreh+WEOG3H
         WJ0gCVRhKux2n6mMxK7EShKCya12erl2FR2nar6xptJMgvWm/GZ+OXHYMZ41uIO6iUp4
         6WFaEVnqLtZQfUih62+BVC1kzw677onykvxqYkjFKX1VcXHk3arAxlVkjbJ8oCiKyOgT
         jU9A==
X-Gm-Message-State: ANhLgQ30KAjofYzesvjMs8lElZnK2jfVLKwLbA/VuR2xoT7/a/GsCg/f
        cHu8a6aD1kGwn2ZfkZBHGp8nos4FXL5hU4MF42lFwLoqsutooRv4SJghYzPkhbzo+LVcNnI0w6y
        FJ+goWYtvwKlB
X-Received: by 2002:a1c:a345:: with SMTP id m66mr21683093wme.114.1583769152544;
        Mon, 09 Mar 2020 08:52:32 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuBsFwL/38WqBZvYsDczlUIj4JLSMvzr77wkabrGWT0xBQqHgpF8sih91f14RuhC/Y3HCPJng==
X-Received: by 2002:a1c:a345:: with SMTP id m66mr21683080wme.114.1583769152339;
        Mon, 09 Mar 2020 08:52:32 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id q4sm17294521wro.56.2020.03.09.08.52.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 08:52:30 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liran Alon <liran.alon@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>
Subject: [PATCH 5/6] KVM: selftests: test enlightened vmenter with wrong eVMCS version
Date:   Mon,  9 Mar 2020 16:52:15 +0100
Message-Id: <20200309155216.204752-6-vkuznets@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200309155216.204752-1-vkuznets@redhat.com>
References: <20200309155216.204752-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check that VMfailInvalid happens when eVMCS revision is is invalid.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/x86_64/evmcs_test.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
index 92915e6408e7..10e9c158dc96 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -21,10 +21,10 @@
 
 void l2_guest_code(void)
 {
-	GUEST_SYNC(6);
-
 	GUEST_SYNC(7);
 
+	GUEST_SYNC(8);
+
 	/* Done, exit to L1 and never come back.  */
 	vmcall();
 }
@@ -50,12 +50,17 @@ void l1_guest_code(struct vmx_pages *vmx_pages)
 
 	GUEST_SYNC(5);
 	GUEST_ASSERT(vmptrstz() == vmx_pages->enlightened_vmcs_gpa);
+	current_evmcs->revision_id = -1u;
+	GUEST_ASSERT(vmlaunch());
+	current_evmcs->revision_id = EVMCS_VERSION;
+	GUEST_SYNC(6);
+
 	GUEST_ASSERT(!vmlaunch());
 	GUEST_ASSERT(vmptrstz() == vmx_pages->enlightened_vmcs_gpa);
-	GUEST_SYNC(8);
+	GUEST_SYNC(9);
 	GUEST_ASSERT(!vmresume());
 	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
-	GUEST_SYNC(9);
+	GUEST_SYNC(10);
 }
 
 void guest_code(struct vmx_pages *vmx_pages)
-- 
2.24.1

