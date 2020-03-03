Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA149177906
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 15:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729551AbgCCOd0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 09:33:26 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24364 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729261AbgCCOd0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Mar 2020 09:33:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583246004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=89Ze1It+GtPoLXw9gXBuQh65Mg9trWRIkcttx5v04pM=;
        b=iun4E6T8nnWqn7xTU7sn0q8lu3rPvu1Uj7OpU8MBa40gf82X+5IxE7rzGRYy3c237hXRgP
        9zMBhyOjP5Grqei1uv0jSSQlchjtEZ+q4FGBSkkMuXoW/+X+Vh+a7R0Lo/8UkY0tEq3Dou
        YLJRLJkjcPormJUfmY80Hh4gHpEUfhs=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-t6SzJZrWPGWaoz4gc-7-_A-1; Tue, 03 Mar 2020 09:33:23 -0500
X-MC-Unique: t6SzJZrWPGWaoz4gc-7-_A-1
Received: by mail-wr1-f69.google.com with SMTP id w18so1310151wro.2
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 06:33:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=89Ze1It+GtPoLXw9gXBuQh65Mg9trWRIkcttx5v04pM=;
        b=l73r/krDsybk9Zmslo4K69kN+cdni7Odgr/2CKYKLdaWuNVWihy1vIdkjkHXyNihs5
         VY9hCaUPuUdJTCXh5rPRd/QPKORwIxtCRVjkIT4FVoOr3Qc2hOLUHirzXg/qsZUC639j
         ue6Jc4Y916IPdtoRagMvD/mddFrqD01+Ld5CbhU4GVjHt/I/hjj46FYnrtsdi7edZqYv
         jS9cMP8o6XOrtoIrFhyrv4ahYCLw7l72j2X3Bi/PwXeUfCdYt6YWhVJER1G3Cgrxkocy
         T/vFjCLUifULXTMMdTdVoO2X/cxTgrpHYCQIVLEAXiIUUcuaEwmwzHt6gykAelpYvvr+
         P1Ow==
X-Gm-Message-State: ANhLgQ0pMQEnbVhAPTti+GS6vl+cpxJmmyDxTfwHH7MVwgJmbltUuz57
        BpoZouaVLU1Sfqa/QGShV4SzF2NRDB8Fh4aPRTmeUL30bXjbncACLJEU0rSEXES+/TQja1a6VrW
        6MkXVxb75C5dw
X-Received: by 2002:a05:600c:24b:: with SMTP id 11mr4505868wmj.1.1583246000303;
        Tue, 03 Mar 2020 06:33:20 -0800 (PST)
X-Google-Smtp-Source: ADFU+vuINeyCMJT4x0cTD7jAV6m0Gk8tTQJGisiIxOqoW5FQMhdO0tVh7STf4uEv41BsxDxn3roLAw==
X-Received: by 2002:a05:600c:24b:: with SMTP id 11mr4505852wmj.1.1583246000102;
        Tue, 03 Mar 2020 06:33:20 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id s5sm32248504wru.39.2020.03.03.06.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 06:33:19 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Bandan Das <bsd@redhat.com>, Oliver Upton <oupton@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: x86: clear stale x86_emulate_ctxt->intercept value
Date:   Tue,  3 Mar 2020 15:33:15 +0100
Message-Id: <20200303143316.834912-2-vkuznets@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200303143316.834912-1-vkuznets@redhat.com>
References: <20200303143316.834912-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit c44b4c6ab80e ("KVM: emulate: clean up initializations in
init_decode_cache") reduced the number of fields cleared by
init_decode_cache() claiming that they are being cleared elsewhere,
'intercept', however, seems to be left uncleared in some cases.

The issue I'm observing manifests itself as following:
after commit 07721feee46b ("KVM: nVMX: Don't emulate instructions in guest
mode") Hyper-V guests on KVM stopped booting with:

 kvm_nested_vmexit:    rip fffff802987d6169 reason EPT_VIOLATION info1 181
    info2 0 int_info 0 int_info_err 0
 kvm_page_fault:       address febd0000 error_code 181
 kvm_emulate_insn:     0:fffff802987d6169: f3 a5
 kvm_emulate_insn:     0:fffff802987d6169: f3 a5 FAIL
 kvm_inj_exception:    #UD (0x0)

Fixes: c44b4c6ab80e ("KVM: emulate: clean up initializations in init_decode_cache")
Fixes: 07721feee46b ("KVM: nVMX: Don't emulate instructions in guest mode")
Cc: stable@vger.kernel.org
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/emulate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index dd19fb3539e0..bc00642e5d3b 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -5173,6 +5173,7 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
 	ctxt->fetch.ptr = ctxt->fetch.data;
 	ctxt->fetch.end = ctxt->fetch.data + insn_len;
 	ctxt->opcode_len = 1;
+	ctxt->intercept = x86_intercept_none;
 	if (insn_len > 0)
 		memcpy(ctxt->fetch.data, insn, insn_len);
 	else {
-- 
2.24.1

