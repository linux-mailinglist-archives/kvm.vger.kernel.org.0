Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEB7B2BC97
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 02:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727730AbfE1Axb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 20:53:31 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43004 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727684AbfE1Ax1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 20:53:27 -0400
Received: by mail-pl1-f194.google.com with SMTP id go2so7570092plb.9;
        Mon, 27 May 2019 17:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i/suq6wlpwcJ3ogbpvRkyctj8x187X3vDma99VWceU4=;
        b=KUbzMapXKqbb8qpOqbungemfdaYcq1y//4HlaOQCqMfle1WwAQbq7J4XHSl+E4ruq0
         JZrWbNgZwIu7QAyj19p9oQeB+QcWLgJKPPIurANw9pq+Mufif5NxdfzA2oge93d8MODI
         NPY62dgndrt6QhFhHCaK0YvTyfcuJ3c/Qt0OMjGlOmSDB5c+cQmZbytFgFiJvPypONrt
         Kxa+zFK6BBVzsAgykRM+BZx5Dzq0e7lyVVr0/ZH3aRoRyDtY+n3kUSe5iZLzqGa04gk5
         EWaysJWMxsvXIP2PT47l7BkWV7IlexG1UY4JZfa+lhWc8HgktSNdS76ZWyYU3sk2aCv3
         qT9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i/suq6wlpwcJ3ogbpvRkyctj8x187X3vDma99VWceU4=;
        b=pE8fm4WPppxxz3FUtkE/qoqdIy5ZHGjTfyeD421HomRdRcwT6+4uGsJuXQn1cQcKpi
         ukaT3V5OQt4twmY32ZOtVwLZgLFsA9atcfowPu9+xm2kOcdFAqLL+3YrLv1zcgftVggg
         G+jnhV3K+Dzq8cZrJYd4gKZdOqs1GNxqDZR0cA3HayHvxFskJRMgA1KVlTYjHL8GO3F3
         BdkL6dlHiH34rKzP8fSC656/F8cJh2Bz/f+acu9F4jsT9GNWJltygLLjk/cddLpTC7qq
         IpaiE3jlfkRbnfA4ypkEvCJKK+ql0EcZwNoa8WHJ9b0TnX9ScBJT6Cf1TsG5vl9/bKVw
         1WVA==
X-Gm-Message-State: APjAAAVQRXTS9wFVAHi1xsFiBqemRhFiv0d8bpVexGQ8a8pmj2lUvI4w
        6ZBJ0I1wtcxYxcpXOz93Jr01W7C/
X-Google-Smtp-Source: APXvYqwm/zSuKPsQd9NRX27U70KMaijoOMBi/urAJVF2EsGFJ9F+AKsskjuPg25BpF+TMgYJqaPL3A==
X-Received: by 2002:a17:902:42a5:: with SMTP id h34mr107943969pld.178.1559004806452;
        Mon, 27 May 2019 17:53:26 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id f16sm622085pja.18.2019.05.27.17.53.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 27 May 2019 17:53:26 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v2 3/3] KVM: X86: Expose PV_SCHED_YIELD CPUID feature bit to guest
Date:   Tue, 28 May 2019 08:53:15 +0800
Message-Id: <1559004795-19927-4-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559004795-19927-1-git-send-email-wanpengli@tencent.com>
References: <1559004795-19927-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Expose PV_SCHED_YIELD feature bit to guest, the guest can check this
feature bit before using paravirtualized sched yield.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 Documentation/virtual/kvm/cpuid.txt | 4 ++++
 arch/x86/kvm/cpuid.c                | 3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/virtual/kvm/cpuid.txt b/Documentation/virtual/kvm/cpuid.txt
index 97ca194..1c39683 100644
--- a/Documentation/virtual/kvm/cpuid.txt
+++ b/Documentation/virtual/kvm/cpuid.txt
@@ -66,6 +66,10 @@ KVM_FEATURE_PV_SEND_IPI            ||    11 || guest checks this feature bit
                                    ||       || before using paravirtualized
                                    ||       || send IPIs.
 ------------------------------------------------------------------------------
+KVM_FEATURE_PV_SHED_YIELD          ||    12 || guest checks this feature bit
+                                   ||       || before using paravirtualized
+                                   ||       || sched yield.
+------------------------------------------------------------------------------
 KVM_FEATURE_CLOCKSOURCE_STABLE_BIT ||    24 || host will warn if no guest-side
                                    ||       || per-cpu warps are expected in
                                    ||       || kvmclock.
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index e18a9f9..c018fc8 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -643,7 +643,8 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 			     (1 << KVM_FEATURE_PV_UNHALT) |
 			     (1 << KVM_FEATURE_PV_TLB_FLUSH) |
 			     (1 << KVM_FEATURE_ASYNC_PF_VMEXIT) |
-			     (1 << KVM_FEATURE_PV_SEND_IPI);
+			     (1 << KVM_FEATURE_PV_SEND_IPI) |
+			     (1 << KVM_FEATURE_PV_SCHED_YIELD);
 
 		if (sched_info_on())
 			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
-- 
2.7.4

