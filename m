Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 382EF399D59
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 11:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhFCJEf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 05:04:35 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:40638 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbhFCJEe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 05:04:34 -0400
Received: by mail-pl1-f175.google.com with SMTP id e7so2538037plj.7;
        Thu, 03 Jun 2021 02:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VHW0SKHklWAgWtYYy5kuW4QSKesps7dxwkUE5RXkEhA=;
        b=GcvWwgMudrXyFjgg8ItvU/VICVB/GoG64AMRkrGnbe1n4+th8Mp97hulVtrvjEtqbW
         Ygc7cKGOXddU440w0h4QEMQj2NJ+9a2+jvHxsntM1eHY5da3Huggs2hlavSuOvdARCHT
         nzHXK/6hLhIXdVh/FZRX6LiUcHsDEQ19Av3IYP7V6lValhhOE+nI7ZOsMBtR4xOZOS7M
         1ND0nV4wTSZoGS65Dq4tSADTHigdzkU7AwuG43VVr6Rgw0XezwLrYNPzzyiiYhOepg6e
         1gQuwrVgiTF1oFfIRclQoH0pSsvK00fY09ig5w6coJ57gFOrU9D6ilHOi5MeiXDEz3VJ
         8HwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VHW0SKHklWAgWtYYy5kuW4QSKesps7dxwkUE5RXkEhA=;
        b=uoA9vJcZtWD6FrjKvVIqlInep6KVrA45MVMzK6mAyFGxCcvp6rI3np103FWLJWvUjh
         SKFVxKjCMWg/myvOdV9ZxTRO8A5qiqKOFj4wgZV2hL7a4/hgvw2o54VKiuwiafTQUZiO
         24rqiHqSrtmKx69pgJFlifb/fCCbwg6WxhWhi7lnRkFPm1OfEylAHCg/Jl7Se7jTFdQY
         ts1M+2QIUWDD48GnDnRkQ+OrqGdbb2GUZMwqInWTYZiti8O1YkArr4zfTdzWSdedvl1f
         DGwg/kN6Au1frzZBSKVBjCOTjsplD003E+2SzvfbpeN6NbB5PWqHf63xYvJk7XdlYeSy
         g/Xg==
X-Gm-Message-State: AOAM531j/gv35C441E5W9iygQzVBk+7yQrWUVQXEZ37LMSxdA+HKMEe7
        WotFTucPT7FAqOzEqmSY++Rw9HfZP2U=
X-Google-Smtp-Source: ABdhPJwHHTrq4XTUIKdTtX0gb0TcKKTPTlExm7KXMsPb8IuTLnsK9l0KuF60kQeGrlW5xScqgAn5EA==
X-Received: by 2002:a17:90a:b796:: with SMTP id m22mr34695887pjr.220.1622710896563;
        Thu, 03 Jun 2021 02:01:36 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.56])
        by smtp.googlemail.com with ESMTPSA id gg22sm1625668pjb.17.2021.06.03.02.01.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Jun 2021 02:01:36 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 2/2] KVM: LAPIC: reset TMCCT during vCPU reset
Date:   Thu,  3 Jun 2021 02:00:41 -0700
Message-Id: <1622710841-76604-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1622710841-76604-1-git-send-email-wanpengli@tencent.com>
References: <1622710841-76604-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

The value of current counter register after reset is 0 for both Intel 
and AMD, let's do it in kvm.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 20dd2ae..9ba539b 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2352,6 +2352,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 	kvm_lapic_set_reg(apic, APIC_ICR2, 0);
 	kvm_lapic_set_reg(apic, APIC_TDCR, 0);
 	kvm_lapic_set_reg(apic, APIC_TMICT, 0);
+	kvm_lapic_set_reg(apic, APIC_TMCCT, 0);
 	for (i = 0; i < 8; i++) {
 		kvm_lapic_set_reg(apic, APIC_IRR + 0x10 * i, 0);
 		kvm_lapic_set_reg(apic, APIC_ISR + 0x10 * i, 0);
-- 
2.7.4

