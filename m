Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE36F17881C
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 03:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387432AbgCDCRB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 21:17:01 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:29910 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387397AbgCDCRA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Mar 2020 21:17:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583288219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zwpmLVhYAg+RzC4wgoFG5yb2Ol28WwASDz+oEeK9Uow=;
        b=RkMGg80ReMekloKrhUk7steiD/j0iRh1+Vg3U/b+El4vCyvrWwy7FAqUmhwkFEumaMavTB
        yyo4gZhAS0aiTs+3CflFE1aYwSnfRmDEMhiMnSKZzylnMYVUWBF+GFNB9acgZlPZw8QwKi
        zUM2QXWC7m24dzz5CaeSzNhmK7aZvFo=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-88-f7HNbWEsPbCV5WQKnCRhXw-1; Tue, 03 Mar 2020 21:16:54 -0500
X-MC-Unique: f7HNbWEsPbCV5WQKnCRhXw-1
Received: by mail-qv1-f69.google.com with SMTP id l16so93519qvo.15
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 18:16:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zwpmLVhYAg+RzC4wgoFG5yb2Ol28WwASDz+oEeK9Uow=;
        b=ff+avXzZPEbV4bsd2xdAJdGcXvc7kr38TaxFaTyGElVcKvCJlrBMPPk80LZoCl2WjH
         XOFkOgkmD0SekmIOOZK/RQ3Dmhz+APR0swsAMJDeYLTKLoVBlgS+ZzEGRtPwOa5R8HTe
         ukwxH7Keeoz1VgPR5T5KohRV8yAnzSkCXY83vaX0aAt9O5WLJVYkoHKMlR0Xp2R/RStB
         9hNaN6OEjy3unyqc2VfQXnfAVbYg0Hih4dAt5XSKY7BrxAIi/gkGYxHF1MKMtbdPz8D3
         EPDj1FHwoecJbR3FQix40IADXC05++MfITVpFJ0dpnI0088brmRi5R24IU2fEEPZCtXD
         IPOw==
X-Gm-Message-State: ANhLgQ2y0WySlIBfHct3eXOYdNNUnGgTZvhndNFNeLwKqtxrkp2MT2+I
        5orfGQ4x2y4xJJ0qXQd/qKh9X87jaD44YETHMlTColQXGoDzl+z6MkI2p+qr4Z7aSz6Fnq1h8Qp
        0kl2n8yla/5Zm
X-Received: by 2002:a05:620a:350:: with SMTP id t16mr936781qkm.238.1583288214462;
        Tue, 03 Mar 2020 18:16:54 -0800 (PST)
X-Google-Smtp-Source: ADFU+vu1ZMXcr1gqC/Zi87ZN+GHeSsAkSbjaQbQrEwLisqJpF+0jVmM6F3RpKZnuzgvqnsEWVWUn7Q==
X-Received: by 2002:a05:620a:350:: with SMTP id t16mr936762qkm.238.1583288214196;
        Tue, 03 Mar 2020 18:16:54 -0800 (PST)
Received: from xz-x1.hitronhub.home ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id n59sm4185363qtd.77.2020.03.03.18.16.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 18:16:53 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH] KVM: X86: Avoid explictly fetch instruction in x86_decode_insn()
Date:   Tue,  3 Mar 2020 21:16:37 -0500
Message-Id: <20200304021637.17856-1-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

insn_fetch() will always implicitly refill instruction buffer properly
when the buffer is empty, so we don't need to explicitly fetch it even
if insn_len==0 for x86_decode_insn().

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/emulate.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index dd19fb3539e0..04f33c1ca926 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -5175,11 +5175,6 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
 	ctxt->opcode_len = 1;
 	if (insn_len > 0)
 		memcpy(ctxt->fetch.data, insn, insn_len);
-	else {
-		rc = __do_insn_fetch_bytes(ctxt, 1);
-		if (rc != X86EMUL_CONTINUE)
-			goto done;
-	}
 
 	switch (mode) {
 	case X86EMUL_MODE_REAL:
-- 
2.24.1

