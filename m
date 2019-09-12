Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B086B07DD
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2019 06:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbfILESf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 00:18:35 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46384 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbfILESf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 00:18:35 -0400
Received: by mail-pf1-f195.google.com with SMTP id q5so15061736pfg.13;
        Wed, 11 Sep 2019 21:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=E78vnhmo9W2A2pNvQXFwnY+byAZLb8i8u9HyT6B3+sg=;
        b=EKPvBwH1+59k/jwqQdsSvQbO8k61IoR8he06AzVrsrO2S4NsaDCQj+9qXT4ifH95cA
         lStBOgUpKwZfOPXfuGwErlIXnIf/aTghhPz2KtzOPfGKEYQdagLqeEl2SZblxyZyEi/y
         RJmZb3iNgY5moYjUmvTiBw3ZeH3iD7braVQTDPznhRRcb9erM3N58YcaRlFwdlouj1A2
         nJpUVWNaCxbcbyJWc6HBs9Jeixb6LN2WjIFQpokWLIC8jXxd94OX+rP07KyEyZnZzUTU
         P0isEghZmhMU+1GBOygU1Ty4hoKqkfrs8qNbn2bEAlyYpWY7+Ir7lKSzpd48ghOnlA/d
         IbgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=E78vnhmo9W2A2pNvQXFwnY+byAZLb8i8u9HyT6B3+sg=;
        b=LKJC7ut/fOCK9o2wG2ZuE0up0ZA/W8MZX9TkzdvrM6F6WVnBfapnQtinooxfjDvS/E
         V//8Xw/Ulwh1mBTNckhy/Zp2vXyDLqYlzz7skOuTOk9vkXLHi+gBvQsKjTFnA5SOHX6L
         4n0zBEYm7H24ojvjyj2q/joyj7XBlIQRf61myF/0NR8VfbcyfHOIS5lhzomtGhR/ExI6
         4A9xbgHFryY7ngwZFHl4GmjI4CGRM9NMWauMOusBebNFfmNVJfJtst0mBHVennKcqNgz
         DWbZ9JQh+K6qsOj2u5TmGDaIKsJltmfohMYGfeKXzpOUObxNbMZ+7MLpmq+q2CZdO2qg
         cOQg==
X-Gm-Message-State: APjAAAXJ1tbxikzCrgfG8zFY6y0aS2r7+2VVLm/DzyZblKU5PLr38DBE
        /eBE9yrc9HtPoieK/A88ebs=
X-Google-Smtp-Source: APXvYqyk0x3J7D47e/P7P1oHEyTuMa/9I5ZW1O1HwuHLoVPHoU1p0ru3RMmYDsIaqnjqk5a/E1hmow==
X-Received: by 2002:a63:fa11:: with SMTP id y17mr36421144pgh.267.1568261913071;
        Wed, 11 Sep 2019 21:18:33 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id s4sm24278875pfh.15.2019.09.11.21.18.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 21:18:32 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH] KVM: x86: work around leak of uninitialized stack contents
Date:   Thu, 12 Sep 2019 12:18:17 +0800
Message-Id: <20190912041817.23984-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Emulation of VMPTRST can incorrectly inject a page fault
when passed an operand that points to an MMIO address.
The page fault will use uninitialized kernel stack memory
as the CR2 and error code.

The right behavior would be to abort the VM with a KVM_EXIT_INTERNAL_ERROR
exit to userspace; however, it is not an easy fix, so for now just ensure
that the error code and CR2 are zero.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 arch/x86/kvm/x86.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 290c3c3efb87..7f442d710858 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5312,6 +5312,7 @@ int kvm_write_guest_virt_system(struct kvm_vcpu *vcpu, gva_t addr, void *val,
 	/* kvm_write_guest_virt_system can pull in tons of pages. */
 	vcpu->arch.l1tf_flush_l1d = true;
 
+	memset(exception, 0, sizeof(*exception));
 	return kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
 					   PFERR_WRITE_MASK, exception);
 }
-- 
2.11.0

