Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A447182CFE
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 11:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgCLKGB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 06:06:01 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33329 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbgCLKGB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 06:06:01 -0400
Received: by mail-pg1-f193.google.com with SMTP id m5so2845715pgg.0;
        Thu, 12 Mar 2020 03:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=m7J0hu742fhuCj58D6loBGDul106B3xhX45qJX3dumI=;
        b=Nk/8iiRytuUjG0q9uprwJcaBhevtJfnkqyMusWXWllzk9B3U15QqaAOCVgtSUF5AT0
         nasrar5TZvGnNo60DZgYe9E8TuRT13ugqNuZ2o/dvsAQsfkW7tImySNBo4Q1dLJ/H6vu
         xOkaQO7xO+Rzpj+gMpTdtNrNG06jIUlYorXv5/7GJhG9Bz9sQyjL/FEFvuCfkNFJ/4Ts
         NRcwFQ9PKX+zMhozWIoQWGCazfQksDlzVW5OJZvwQqj45Tkz4WX2tumu3Ve/iiFfb4CQ
         XRP1rfPnohtrFoEe7zwxHN6iwF1TsJ7ksNYJz8Qmqkl9KkjjSDRjNvKD31vXT+mFWctf
         /UAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=m7J0hu742fhuCj58D6loBGDul106B3xhX45qJX3dumI=;
        b=QhtM8swv/wqEfCLF3zL5fnYIlUi8i0slmlTBlnwPdTbwfDAkYfGPioxTOK48jz6+nO
         396Wo8J7EXA2/kJpp+zNz8/LxqaYZoD5lsRbV78kZH9G/VGriPhdleW5NK6PR+zAz+xp
         i9Qf6hXrj7dAHYJwLpL0QavCOuiSH/lavdtF6GgDW85R2d3LkwhmcZVjxGVkE7mtbdLd
         mq2wRGDHsHL89ULCLr8YstoRm8ytM7UQA3hgqXdzTjEgPyHVIx8h1TvWyonYMZUM64zL
         OEsAW8BiqPGCsN34PbJP6jo+7vvnBupgKpunWknTwP9WWDFNkvtqTUlUe3IrwB6yInGn
         4qNw==
X-Gm-Message-State: ANhLgQ2BvY+078gVk8WiDgfSR4kOmsfKE5scRfwzdhejNTr3a25nvZVb
        zHgEIQ5NuHLz0AUP795s1+e1wVLL
X-Google-Smtp-Source: ADFU+vs2sY6uZfcGRvB4mw5lbE4o/npk0iLwC+R5UumZdHwq3N7seEjGFaYl+X0PfD6VX6QEHtIDmQ==
X-Received: by 2002:aa7:8552:: with SMTP id y18mr7503815pfn.0.1584007560431;
        Thu, 12 Mar 2020 03:06:00 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id dw19sm8234226pjb.16.2020.03.12.03.05.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 12 Mar 2020 03:05:59 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] KVM: VMX: Micro-optimize vmexit time when not exposing PMU
Date:   Thu, 12 Mar 2020 18:05:47 +0800
Message-Id: <1584007547-4802-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

PMU is not exposed to guest by most of cloud providers since the bad performance 
of PMU emulation and security concern. However, it calls perf_guest_switch_get_msrs()
and clear_atomic_switch_msr() unconditionally even if PMU is not exposed to the 
guest before each vmentry. 

~1.28% vmexit time reduced can be observed by kvm-unit-tests/vmexit.flat on my 
SKX server.

Before patch:
vmcall 1559

After patch:
vmcall 1539

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/vmx/vmx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 40b1e61..fd526c8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6441,6 +6441,9 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 	int i, nr_msrs;
 	struct perf_guest_switch_msr *msrs;
 
+	if (!vcpu_to_pmu(&vmx->vcpu)->version)
+		return;
+
 	msrs = perf_guest_get_msrs(&nr_msrs);
 
 	if (!msrs)
-- 
2.7.4

