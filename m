Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E13C635105
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 22:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfFDUdU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 16:33:20 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:46451 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfFDUdU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 16:33:20 -0400
Received: by mail-lf1-f65.google.com with SMTP id l26so17416950lfh.13
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2019 13:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-disposition:content-transfer-encoding:user-agent;
        bh=+qR7k4fQsvJSOTG1+GHIY0O5I4zb3htSI7DgZU8DKKc=;
        b=U2cND/4zpnbsJRsxkSQGEwPEbllRyG9TUYAjNs1Uhr/rNnxS4tfqTymzxBnA5F5v6B
         9/M6YF+gZrXqYvpPb55rQIega6czqVrSsq3cfF6T8tm+YN7tu8NH9q1vlZW65xuLkn3C
         Fh8qrY1/cFU3Q2nKyvlloEGiCmOdN+2OMjhgRGujory+ehdWsYDds/T7f6UIExC1djBf
         /MpB/tvE0FLnmdAIrTErbxGeAvtIZI/6OsDmdOiF4pDjo4PQf6PP6+1q3hdcjsZt0kZf
         L+IKwF55c0iDtf33IaopLG8HTMOCrk7q350mdIC7CZMmJuSRoNrA6j5BSIDyM31iKkmX
         noyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:mime-version:content-disposition
         :content-transfer-encoding:user-agent;
        bh=+qR7k4fQsvJSOTG1+GHIY0O5I4zb3htSI7DgZU8DKKc=;
        b=tXf1y7pPn0KJPB7EECeRMYL66SVR8LaE+TUtZxppznSEoPWthCMRUDaK7a+lWwu3OP
         NcQc1IJc4Ewd8bmguyuwBF2R4uaDbQHeV04LVCjGNTdwXeniMO4dU5Tlh84hmkWuYyo4
         OXG0D3IvmnxR8wi6z2Jwc5YAiQwWk48yoWebpA9WHoRnCI6Vb1enwIVPtmugshAluLoT
         PM8ymFK3FYog28PsHp/6xwDcmYaTmwAIfGDm9dAnGrw6lASP7lY9Ta2LsvK6cKKY1/41
         GwTOkdQMQY9Il0jZIg6VOs2IJpb4TapANk498tusHIm22WS7TkWqCE6H8xdkHbwAMLuB
         QKAg==
X-Gm-Message-State: APjAAAWBjvHf8ntdxJDl7g7f5DlHxtB8xAVcIcW8kFOEE/U1JSB38B54
        rkLAzKBr071x/SDAt4bMj4Bb3DrX
X-Google-Smtp-Source: APXvYqzoOy2/43z16voJp8F9tNIkp16qxzOJ31WFvx+H1/qplErzOTJi7jnuzcn+x5Fryi/nAr912g==
X-Received: by 2002:ac2:424b:: with SMTP id m11mr17021647lfl.163.1559680397703;
        Tue, 04 Jun 2019 13:33:17 -0700 (PDT)
Received: from dnote ([5.35.65.245])
        by smtp.gmail.com with ESMTPSA id y4sm3968646lje.24.2019.06.04.13.33.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 13:33:16 -0700 (PDT)
Date:   Tue, 4 Jun 2019 23:33:13 +0300
From:   Eugene Korenevsky <ekorenevsky@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 1/2] kvm: vmx: fix limit checking in get_vmx_mem_address()
Message-ID: <20190604203313.GA7215@dnote>
Mail-Followup-To: Eugene Korenevsky <ekorenevsky@gmail.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel SDM vol. 3, 5.3:
The processor causes a
general-protection exception (or, if the segment is SS, a stack-fault
exception) any time an attempt is made to access the following addresses
in a segment:
- A byte at an offset greater than the effective limit
- A word at an offset greater than the (effective-limit – 1)
- A doubleword at an offset greater than the (effective-limit – 3)
- A quadword at an offset greater than the (effective-limit – 7)

Therefore, the generic limit checking error condition must be

exn = off > limit + 1 - operand_len

but not

exn = off + operand_len > limit

as for now.

Signed-off-by: Eugene Korenevsky <ekorenevsky@gmail.com>
---
 arch/x86/kvm/vmx/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f1a69117ac0f..fef3d7031715 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4115,7 +4115,7 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 		 */
 		if (!(s.base == 0 && s.limit == 0xffffffff &&
 		     ((s.type & 8) || !(s.type & 4))))
-			exn = exn || (off + sizeof(u64) > s.limit);
+			exn = exn || (off > s.limit + 1 - sizeof(u64));
 	}
 	if (exn) {
 		kvm_queue_exception_e(vcpu,
-- 
2.21.0

