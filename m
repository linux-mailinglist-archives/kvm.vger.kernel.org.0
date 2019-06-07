Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D62A43840C
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 08:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbfFGGCx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 02:02:53 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39050 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbfFGGCx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 02:02:53 -0400
Received: by mail-lj1-f196.google.com with SMTP id v18so656457ljh.6
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 23:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-disposition:content-transfer-encoding:user-agent;
        bh=ehLz7BXTzkKePFW0yF7URiswDSc0WhRHwoIzOdFE8Ps=;
        b=umzU0dMq+Sp/wwjjYsipPLfqqxFuDWVrFi9CQotVm4NBdoQ2MnLszcBTeQsERtXWfI
         GBTXHyklJjxt9lGT483f/Y46V6TyYnvUjHKifZcQ3LMcW7ci1fYriCLds2uQtT0CvMfl
         /N68n3f/oCgpYOqap16JTAy2CfnN+ELdkW+YCKDrltAkWNOZKLvaJ1qCWyLqsLw/cyr/
         yI+AItCOuXdHdBkG3EJDqyWc5ekqlO3tkF0r7Zf8qOX8pEj91sZpIImj9kg7dJsZ4NZ1
         8GLZcte8PoIWlS/qSsBt1a8SVgQ5/5r228lAcauZGV/9jVNpmhu4bTB6HYqNmfaolNy9
         D5Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:mime-version:content-disposition
         :content-transfer-encoding:user-agent;
        bh=ehLz7BXTzkKePFW0yF7URiswDSc0WhRHwoIzOdFE8Ps=;
        b=OT4ArdiUHg6IF1GW4bnBHjJlO9o9VR9Tzp+15MfFrZMh5z8OmJBKRtgNuyXqgNTM7d
         orboyQS7DZOvEU3uczZrFnVplcMZDlqRNpL0bFP1GVKvHoDOvds+Yb+61ASuJ5zjaMM3
         rZ5QB04VHk9UNLvUd2SARlqHFGuVWw5eliWkJezpO50fgHhFSXio6XmYHDc6k5gKtYEi
         eIr4rHothNimNvZrVlT6hhJ2UYviXSdx7XwM4YXip62jBqDIr+nwBon0zJIg2tKVEK77
         coFBhtppANnaUJGGwA/5pL0Re1fLyeHjy4woPDF4oHgMzBUGmFYfNwb23R6WWstcMFga
         tbIg==
X-Gm-Message-State: APjAAAXVXeNlAGvFQJ29F3DW065Z0e8C9LxG4ezZXcHz+ETTkUZz34vB
        cYCffvT7ed2HnfTv+MTxNgM7PsGl
X-Google-Smtp-Source: APXvYqwZfKz1eAhOKQjv+JiUs2HTKUEX61tp7k0nam7vsAf33ysoCY9zUJp5KV6Vsu8KbrE81ue3Pw==
X-Received: by 2002:a2e:9f41:: with SMTP id v1mr20701975ljk.66.1559887370937;
        Thu, 06 Jun 2019 23:02:50 -0700 (PDT)
Received: from dnote ([31.173.87.118])
        by smtp.gmail.com with ESMTPSA id s20sm208428lfb.95.2019.06.06.23.02.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Jun 2019 23:02:50 -0700 (PDT)
Date:   Fri, 7 Jun 2019 09:02:48 +0300
From:   Eugene Korenevsky <ekorenevsky@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v5 1/3] kvm: vmx: fix limit checking in get_vmx_mem_address()
Message-ID: <20190607060248.GA29087@dnote>
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

Also avoid integer overflow of `off` at 32-bit KVM by casting it to u64.

Note: access length is currently sizeof(u64) which is incorrect. This
will be fixed in the subsequent patch.

Signed-off-by: Eugene Korenevsky <ekorenevsky@gmail.com>
---
Changes in v3 since v2: fixed limit checking condition to avoid underflow;
added note
Changes in v4 since v3: fixed `off` overflow at 32-bit by casting to u64

 arch/x86/kvm/vmx/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f1a69117ac0f..1a51bff129a8 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4115,7 +4115,7 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 		 */
 		if (!(s.base == 0 && s.limit == 0xffffffff &&
 		     ((s.type & 8) || !(s.type & 4))))
-			exn = exn || (off + sizeof(u64) > s.limit);
+			exn = exn || ((u64)off + sizeof(u64) - 1 > s.limit);
 	}
 	if (exn) {
 		kvm_queue_exception_e(vcpu,
-- 
2.21.0

