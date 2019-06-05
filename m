Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7823669F
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2019 23:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbfFEVRo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jun 2019 17:17:44 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:40994 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbfFEVRo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jun 2019 17:17:44 -0400
Received: by mail-lf1-f65.google.com with SMTP id 136so8637546lfa.8
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2019 14:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-disposition:content-transfer-encoding:user-agent;
        bh=ehLz7BXTzkKePFW0yF7URiswDSc0WhRHwoIzOdFE8Ps=;
        b=vfTv2v9TaK2yEXTv2WtXB+YiYsFX8oRaw20aMOx5H0ok1e9Yz69VldlJbyYGeC4VeX
         VVuH2kedoz/nBnTFluW7qoGjR050YAwQ4XUsLtWi2xRNxxMOxQSmLqZKJ31WdzbuXvUw
         dcJaKnL+g5cYKUBFMTeX7/B/pHiTxSyiPFgrmIe13ZO2g+mDnHGkp2Fr5Ll21kTHkJNW
         TXGdMn+ZAZNGRDSS6NAN6OB7LfVfIVSJcz0J7f6u2m5M25kvW7CQZiTMGGO1Rt1LZmLm
         Ugd4CQzGlPZOb5qA6Q3qBSwsvXLFHHFijufqiTbu7EhA3nx0Z+N9ynOBgbxWgXrVpXEC
         kwYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:mime-version:content-disposition
         :content-transfer-encoding:user-agent;
        bh=ehLz7BXTzkKePFW0yF7URiswDSc0WhRHwoIzOdFE8Ps=;
        b=DLmirypHN9rVANM/V+gXF3jgAPSWcfJKZUpyu0cfHuXPjqHkQqR0UTRNZ3GE0NURjP
         ToXWNmlXokDSbDALhwwIaRd1lsYi8BQzLrolRtKiGisY/lToLDJUVa1RlqxZL0rEypOt
         HAe66+FELirST6zpazfPsRbYAFpQ4munpkiJn9JvqBZ874D6+zddFerSYV4CST5+rv9d
         C0L58mwdgbBLfO4wdpfM2aUXhnx5peY5YdDX1bLlW7zTWMuO94G3BKtI266ZHxjRMTu6
         RC78B5Sd76UvJi7qEkVVPYHavSC2x/BjgFpGX+ADE/TstBYYRMWeSSgjk4ZAAU9BHg/v
         I9Rw==
X-Gm-Message-State: APjAAAWmHGSrki1ZvYpaSyKn2Yzci4bndvErDX2hezcHgl3fo/wxMBf9
        nWWPFvvmB/8R7p1xwk7vtx4uZKIJ
X-Google-Smtp-Source: APXvYqwSKVGO7P1BszRt3OIYWJX126pxGGAQKQEKT5g3SCODyWb9mhijXTSrBR1TJTMs3wRbZjFfUw==
X-Received: by 2002:ac2:484f:: with SMTP id 15mr17499782lfy.51.1559769462265;
        Wed, 05 Jun 2019 14:17:42 -0700 (PDT)
Received: from dnote ([5.35.65.245])
        by smtp.gmail.com with ESMTPSA id i23sm4160ljb.7.2019.06.05.14.17.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 05 Jun 2019 14:17:41 -0700 (PDT)
Date:   Thu, 6 Jun 2019 00:17:39 +0300
From:   Eugene Korenevsky <ekorenevsky@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v4 1/2] kvm: vmx: fix limit checking in get_vmx_mem_address()
Message-ID: <20190605211739.GA21798@dnote>
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

