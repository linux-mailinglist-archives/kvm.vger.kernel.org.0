Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 305E43C52D
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 09:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404127AbfFKHe0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 03:34:26 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35611 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404104AbfFKHe0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 03:34:26 -0400
Received: by mail-pl1-f196.google.com with SMTP id p1so4731698plo.2;
        Tue, 11 Jun 2019 00:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=owbqSh211AKwsKjq12eXf8pHk0Rdlubwz6kTs8w1ndw=;
        b=I/HrQ0PvzhoU0g8k5X+f3U0EluhM3zVifZKtvm0froNQlYfHHDoAFUxZa5cfNyt7f6
         +s9/t7coYUCM05sOeoswz6jg01pmOqCu1I3i+xy93VUArSTtRmsLAtmwdjwzkRgzdon1
         AElg7KuJyq96fGxwKEc8fVXs8bxy1RgSRhZ+M9W2ShJN7PBDuqhMKCawyru8N9oA3vmW
         fo8MDu2XT3QuLM+6Q7DLbfICAqXgvFpcHMf8kKngCywUNq0bgjQLdHq6WQxuF9gGIOFc
         kaXzxnp1RmqrEp5/nO1E+8iIemGV3oEaHyFgz3k883wUaAY9zfkJYn1ApASjPuJvN1t/
         zY4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=owbqSh211AKwsKjq12eXf8pHk0Rdlubwz6kTs8w1ndw=;
        b=cHC6ggbVYE6Tq1GqOKq1bvkVOdSsRTd4eZ0wwE2o3MKgBkL8ZKN5SQeFdNV9tSFe8C
         Jo3lYjbVg4Gk417Od9kQ1AugnoWDbO2EMZTyYQL+kpHXYErdm7AtsTmFo858e21JjFnR
         hxVrHIGuLOschRQ0g7oJgXC5V1rdbnnkASOUA802iy1m2qMdspNtMCz4O/p7ovS3Wc0H
         bKrznXp9t8/qhNGFHY23vZ5CHjFQsAGRQM/b2ubP/qRucbZdJsi9Nek1+TWb+WO3fZ/3
         FyVq7c+Q53EQC+lBBWO+0WrJO1/FCYSHPDU9Gb6Z5cZHPr37WfQWfopdj5tStxaSjiKN
         1WMA==
X-Gm-Message-State: APjAAAXziZpKWVGMjDaaQY4h0EgBYal06/obERjG+bb5mtgL4ERMlHjX
        Qb7S64368O//ia/llMaGkkwznqu0
X-Google-Smtp-Source: APXvYqzfkf2IK3HIQPTFyo6DGrWw9vsjE3AIh9+mbGDixR22u8bRAfqjZtBTaQYsKPTrx67NJQo0Cw==
X-Received: by 2002:a17:902:a516:: with SMTP id s22mr35377839plq.178.1560238465784;
        Tue, 11 Jun 2019 00:34:25 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id 14sm6860800pfj.36.2019.06.11.00.34.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 11 Jun 2019 00:34:25 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v2 2/5] KVM: X86: Introduce residency msrs read/write operations
Date:   Tue, 11 Jun 2019 15:34:08 +0800
Message-Id: <1560238451-19495-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560238451-19495-1-git-send-email-wanpengli@tencent.com>
References: <1560238451-19495-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Both live migration and vCPU migrates between pCPUs possibly to set the MSRs 
in the host to change the delta between the host and guest values. This patch 
introduces msrs read/write operations in the host.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/x86.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cc97aae..841a794 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1331,6 +1331,51 @@ void kvm_enable_efer_bits(u64 mask)
 }
 EXPORT_SYMBOL_GPL(kvm_enable_efer_bits);
 
+u64 kvm_residency_read_host(struct kvm_vcpu *vcpu,
+		struct kvm_residency_msr *msr)
+{
+	u64 host_value;
+	rdmsrl_safe(msr->index, &host_value);
+	return kvm_scale_tsc(vcpu, host_value);
+}
+
+struct kvm_residency_msr *find_residency_msr_index(struct kvm_vcpu *vcpu,
+		u32 msr_index)
+{
+	int i;
+	struct kvm_residency_msr *msr;
+
+	for (i = 0; i < NR_CORE_RESIDENCY_MSRS; i++)
+		if (vcpu->arch.core_cstate_msrs[i].index == msr_index) {
+			msr = &vcpu->arch.core_cstate_msrs[i];
+			return msr;
+		}
+
+	return NULL;
+}
+
+u64 kvm_residency_read(struct kvm_vcpu *vcpu, u32 msr_index)
+{
+	struct kvm_residency_msr *msr = find_residency_msr_index(vcpu, msr_index);
+
+	if (msr)
+		return msr->value +
+			(msr->delta_from_host ? kvm_residency_read_host(vcpu, msr) : 0);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_residency_read);
+
+void kvm_residency_write(struct kvm_vcpu *vcpu,
+		u32 msr_index, u64 value)
+{
+	struct kvm_residency_msr *msr = find_residency_msr_index(vcpu, msr_index);
+
+	if (msr)
+		msr->value = value -
+			(msr->delta_from_host ? kvm_residency_read_host(vcpu, msr) : 0);
+}
+EXPORT_SYMBOL_GPL(kvm_residency_write);
+
 /*
  * Writes msr value into into the appropriate "register".
  * Returns 0 on success, non-0 otherwise.
-- 
2.7.4

