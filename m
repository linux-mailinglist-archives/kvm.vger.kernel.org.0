Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF043AB025
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 03:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391928AbfIFBaY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 21:30:24 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37628 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391915AbfIFBaY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Sep 2019 21:30:24 -0400
Received: by mail-pg1-f194.google.com with SMTP id d1so2496983pgp.4;
        Thu, 05 Sep 2019 18:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AziVDiNsJfWSoLEyeTjoxxBYGSeB6j2LvcpA2gkjX9Y=;
        b=puPqJNuU2re3ZarBofADdbCQPRA4Nexdfs0IazA91Nh/pAC0CdSSGIy/aM/XrewZaD
         Zs49HgtAeUSmbE644alwC4NcOKIgUZ80JrsVWPB9tFfOzHHuoCNx24trIsZFgvF6v8mo
         kZ+ryhZ4TAoPVq5N7Yd3XzQBrj68Smus+JiRND9WzsWRyVIClfuciOGRtikbProl+7GL
         mPEGUPHk+WwWio6t5YxhE6uhlWKB4dcvXWdJnyHjpyKtNnfrWVsQ4rKrIUNpFHRrr0bP
         A7F7F37KJOaO0RdWim4j/FCmuKSCPP6K7xq+8CbLOufjID17J3G0oV75CQ6Nl57WMbHg
         SkAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AziVDiNsJfWSoLEyeTjoxxBYGSeB6j2LvcpA2gkjX9Y=;
        b=Ieemg7/lT5QvmmH8WN52UYT5nWgq+O7tMox03m0YNuMxt48JuNagZENVCPmZEUPkt3
         hbXuXMY2UVzWCB4YpNyQk2yD177frQG39z2qNywun2kAm8T6OSkSY5qYYzMBJTQH6Hxy
         4qXyHIRtEzmkpoq8WutMlSSv4kVhPEjKsKmehkcmm4g3npY30nQ9nDVw/OneXg1U+45A
         Bh+zr2h+CZdltI1fjhvEz98003CpLpfdUxSw3HjLFZilGXl5z7yzFkLo9OggLkpX8oJf
         tSPHjqLFf3skh7U8w24RnoDTr5r/PCNSdaKvvs+VceQytMTVx0LM9YPp9pPV1i82gZVQ
         zXFw==
X-Gm-Message-State: APjAAAWVxZQzb3OTPJKSV0O3H/CAtmu9NjVhwLnJl2aJ7Wy76h7nzW8P
        xWESGen2dOmxmkobVBnApqApSp7w
X-Google-Smtp-Source: APXvYqy1fUbJXE5zasPgxg4UQV5TR/ejP9L4h//1lvPpmqMTiUelwv/c0XoLmR3pFUht8zTHGnmYKA==
X-Received: by 2002:a63:2903:: with SMTP id p3mr5863365pgp.306.1567733423455;
        Thu, 05 Sep 2019 18:30:23 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id g11sm3332294pgu.11.2019.09.05.18.30.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 05 Sep 2019 18:30:22 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH RESEND 4/5] KVM: VMX: Stop the preemption timer during vCPU reset
Date:   Fri,  6 Sep 2019 09:30:03 +0800
Message-Id: <1567733404-7759-4-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567733404-7759-1-git-send-email-wanpengli@tencent.com>
References: <1567733404-7759-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

The hrtimer which is used to emulate lapic timer is stopped during
vcpu reset, preemption timer should do the same.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/vmx/vmx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 570a233..f794929 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4162,6 +4162,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	vcpu->arch.microcode_version = 0x100000000ULL;
 	vmx->vcpu.arch.regs[VCPU_REGS_RDX] = get_rdx_init_val();
+	vmx->hv_deadline_tsc = -1;
 	kvm_set_cr8(vcpu, 0);
 
 	if (!init_event) {
-- 
2.7.4

