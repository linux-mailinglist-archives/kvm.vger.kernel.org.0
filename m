Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF9836504
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2019 21:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfFET5d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jun 2019 15:57:33 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:44570 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfFET5d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jun 2019 15:57:33 -0400
Received: by mail-lf1-f67.google.com with SMTP id r15so20008099lfm.11
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2019 12:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-disposition:content-transfer-encoding:user-agent;
        bh=5TjRDqwgqUcDQzgXDIdYW+oj2+r0bcTytsaeaYIr+Us=;
        b=u3t0esTI2YZ8EznUcTiR01I8KPK0bFH2rCeMYEpqbufHNlLK1sbFo0Q1xSkS6iRB6e
         dJYY+qFcz7KKE3ZgQqnXLfeJ2XUKkzN9DU6lzvbccPEXjO4izwwfVMX2UjX87bGBk0lQ
         T+KRlFD5dkuj6zcbkqeQPiiG9r/9BGXlYfhpk1peUDHYcdGYiU1laePMVZoLFE+amS3M
         bAP1/L9aIToAbVLcu4+g1qCmtfKcnQg9xBsECxsqMLNe2W8G9xyU+nILffU3+6X8gjIM
         DHwKCOtgnRCQxx/URnvQCL9jRNHlB2I43IHeXK6Ww48lP403sIwDoaFJLWHLiH2Q6RZr
         PAQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:mime-version:content-disposition
         :content-transfer-encoding:user-agent;
        bh=5TjRDqwgqUcDQzgXDIdYW+oj2+r0bcTytsaeaYIr+Us=;
        b=r1pU6XJjWtt2Dk7V8Jn48wqHw6n5K0l9Ox8BrVZWfc72VdbaqL/cBsqxVlZLHInzxJ
         IBeMUV7GvrK9wH1461zpT2ziACfYTmher2ZYz8Te3a9+wqRnlgK6HgZG3UZoTizLxgII
         72QSCneXwI9VchJAYY9QN1U32GmwC/PoHW+ELWGMWv8en7c6n2Tc79UMnLdi1ZidmeZP
         Pu9id+id39+XCvSg3C7j4kWaNnQBGXyLvCybQ0Nsoa7m6/IJySSIfjBqcSS7tp2DeC8b
         FpkSNsKZTrrVDIDnpJdAErdG9TiYXz8QB6vhbYRJmhkTiWbjqu1aXMsuy3B9jqF4bJOR
         sqHw==
X-Gm-Message-State: APjAAAUT5qD9KzII2qPFENSR+KmOjztkisB6rrcNv7Z/uBYEQTyFDDxc
        38HwFbHoV4x2qmfpWKEFYABPQOqI
X-Google-Smtp-Source: APXvYqz4LazTVC3vfIIFYQ73jvkPv0CI78wbOmekDoF0EzPzTFNcjtPb5nh36elHUG5xemVdlq/+4g==
X-Received: by 2002:a19:2d41:: with SMTP id t1mr21096134lft.79.1559764651237;
        Wed, 05 Jun 2019 12:57:31 -0700 (PDT)
Received: from dnote ([5.35.65.245])
        by smtp.gmail.com with ESMTPSA id l9sm4334072lfc.46.2019.06.05.12.57.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 05 Jun 2019 12:57:30 -0700 (PDT)
Date:   Wed, 5 Jun 2019 22:57:29 +0300
From:   Eugene Korenevsky <ekorenevsky@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v3 1/2] kvm: vmx: fix limit checking in get_vmx_mem_address()
Message-ID: <20190605195729.GA25699@dnote>
Mail-Followup-To: Eugene Korenevsky <ekorenevsky@gmail.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
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

exn = (off > limit + 1 - access_len) = (off + access_len - 1 > limit)

but not

exn = (off + access_len > limit)

as for now.

Note: access length is incorrectly set to sizeof(u64). This will be fixed in
the subsequent patch.

Signed-off-by: Eugene Korenevsky <ekorenevsky@gmail.com>
---
Changes in v3 since v2: fixed limit checking condition to avoid underflow;
added note

 arch/x86/kvm/vmx/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f1a69117ac0f..93df72597c72 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4115,7 +4115,7 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 		 */
 		if (!(s.base == 0 && s.limit == 0xffffffff &&
 		     ((s.type & 8) || !(s.type & 4))))
-			exn = exn || (off + sizeof(u64) > s.limit);
+			exn = exn || (off + sizeof(u64) - 1 > s.limit);
 	}
 	if (exn) {
 		kvm_queue_exception_e(vcpu,
-- 
2.21.0

