Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F769A9AA6
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 08:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731582AbfIEG0g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 02:26:36 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39792 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731570AbfIEG0f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Sep 2019 02:26:35 -0400
Received: by mail-pg1-f194.google.com with SMTP id u17so813798pgi.6;
        Wed, 04 Sep 2019 23:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AziVDiNsJfWSoLEyeTjoxxBYGSeB6j2LvcpA2gkjX9Y=;
        b=snr+7JsvbIfvpSDRxAoAa9XtG8kcTu0x20sFyZBuc1LG+RRbdITGufDsg2QRL2gKJk
         J1twKplySDIR+kI5oIOg7h8eNBU7eLxVKx7tP//i4EKH5THVSXOukQZUGh7v9M1WiuBF
         jOL36ziqYZWkeWM0vVgdMzpqGSKLH+YTsKgEYMEiBLwPROMsHUVps1xQMv4EW2yEDVHZ
         FJMZXitwdr3OstV2sTa5gBJaEDtKI65Mbk4ya6WAzhyT5rcNCgW0y+5T7ZWrU5NsM158
         Ur+SDe3iGpjrEZUI2L2jbCMdFOV0nnZb+uelqlpFIuz2R5ypKllyP9MQ2I7r+CH5IMlj
         9yxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AziVDiNsJfWSoLEyeTjoxxBYGSeB6j2LvcpA2gkjX9Y=;
        b=HQp8DhO0L8fjiLHRnw/PDGSknJHIxC3c5scbr03OUNDIIjqFjBGobTdIcB4KxQBgB6
         /eJg5r0YkxXGmzxmKE1pgfFrxKHvFe7HS1ZWs1Z7C95qMI3mtOxvdnl8b9MqDrtF1OIa
         TRBMgp9p6GSjOc/lET4xf2vsRimrp3eCgsf/+TK4x0iha+AffEfkXdm/9zAWfuFx/lMs
         6uqC1/XLtJJ1JEM27Uw1W0AbnsMVEab7ZIX/cJnW0MAyXvLptlG75fSQ5gMXU/L652SU
         jLAzDGhIhtqt5qzl9J9Syf33uooTNzr0Vzt28cYyN0y/BgtYbbByXYQLDBx4appE1htz
         8+iA==
X-Gm-Message-State: APjAAAWyVe3IcvSUeC3H4hXv/QN3k3/1j8QOH+xByh9ESD6avPe/Pmd+
        q/nvdMkk2ttrDIy1ExiojUgIUhvN
X-Google-Smtp-Source: APXvYqxSMXgpLfyQpBqsSE4U5weR8hDwgwbVXZkW1nsGMJzKXWjlgiKGN5qy4WA2vqDOIJGNUfWwMA==
X-Received: by 2002:a62:e50c:: with SMTP id n12mr1879416pff.206.1567664795032;
        Wed, 04 Sep 2019 23:26:35 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id d69sm1102941pfd.175.2019.09.04.23.26.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 04 Sep 2019 23:26:34 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 2/2] KVM: VMX: Stop the preemption timer during vCPU reset
Date:   Thu,  5 Sep 2019 14:26:28 +0800
Message-Id: <1567664788-10249-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567664788-10249-1-git-send-email-wanpengli@tencent.com>
References: <1567664788-10249-1-git-send-email-wanpengli@tencent.com>
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

