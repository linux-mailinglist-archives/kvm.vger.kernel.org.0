Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 735AD5F9B9
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 16:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbfGDOHh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jul 2019 10:07:37 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53212 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbfGDOHY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jul 2019 10:07:24 -0400
Received: by mail-wm1-f68.google.com with SMTP id s3so5878935wms.2;
        Thu, 04 Jul 2019 07:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3gBAtjCyB1jrwqmoh6QmCHwkfZISQRiVeu5oDYjwX/Q=;
        b=ehHn/PYWRVFpRj+83eCrNV/3QBLL2DW7nvMsj9XWw458nYGRvi9s2l2GMvp4Vissyj
         vvREul25ttaQoHWHd6L4x/K5PWLGWB3LPb3QckaqkaZVeRSTQ/rcEJrTX12E7oAXjlvA
         b4TmPcl9IpBKeNq1FO7Va+sS0emrK+2/5T9VqsOEhQLvDAz5YecGt791CeeiJ2RTIg4m
         EivsERRAyLGupGgXyaR7MWmw76Dhc629IozrAZ/z02mAQDHmUbyKeyiLpIeFvUR7tl6B
         K5xYIdQybCyEefGP1PVGiBlXPbBlLkRrAOqaKyLjyLLi9bpErwfW/pcU0ViGKnmu+gYq
         XNiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=3gBAtjCyB1jrwqmoh6QmCHwkfZISQRiVeu5oDYjwX/Q=;
        b=akK55PSkFB6YKQk8RJ/3QkfXhbqml3rjI6dGeeXxq9YghG5JAaLfADumeqhHx6eRgM
         LB2gm5h6okPXnB4+VJSpHrN9l2vtwO26M1vNvUo3B5nsM09CHjp/gkZeCyZAX7HQfHsw
         Mc1AbEoM4p5NN1dU6DKOoKqoPi4Pl+hhxPmReTfj1hm2p3O1Aulpw1zIUq7HvaTPzVon
         5zK8kNW0qJn3je1VG7Mj2D/nMDcGXSW0wHWYOo5sbB9xjbBKBndYeQX3tGnDH87y6N+P
         zJsg6i9It3vttOrjEzvhbAfzzBbihKfHyDhr3Q6kfZP6yeRQH/nITkxsx6m0q6iXjdX0
         wUBg==
X-Gm-Message-State: APjAAAUjnLaQiZfwkZWVIs8Dw/nNHzrGB6QxoGy0EPvUBvZvLnSfPesN
        KeVYqlpRXOwVzkrJkFH1MA4J0Lm1gfc=
X-Google-Smtp-Source: APXvYqzA0oGvMnlxC+wQBSZY14og5z8OQCs7HbzUrr6q4tHQOfzS/Sp/SFmYQeUsEo61JH0ZfsheaA==
X-Received: by 2002:a7b:c774:: with SMTP id x20mr12619743wmk.30.1562249242148;
        Thu, 04 Jul 2019 07:07:22 -0700 (PDT)
Received: from donizetti.redhat.com (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id n5sm4458060wmi.21.2019.07.04.07.07.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 07:07:21 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jing2.liu@linux.intel.com
Subject: [PATCH 5/5] KVM: cpuid: remove has_leaf_count from struct kvm_cpuid_param
Date:   Thu,  4 Jul 2019 16:07:15 +0200
Message-Id: <20190704140715.31181-6-pbonzini@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190704140715.31181-1-pbonzini@redhat.com>
References: <20190704140715.31181-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The has_leaf_count member was originally added for KVM's paravirtualization
CPUID leaves.  However, since then the leaf count _has_ been added to those
leaves as well, so we can drop that special case.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index d403695f2f3b..243613bf5978 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -791,7 +791,6 @@ static int do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 func,
 
 struct kvm_cpuid_param {
 	u32 func;
-	bool has_leaf_count;
 	bool (*qualifier)(const struct kvm_cpuid_param *param);
 };
 
@@ -835,11 +834,10 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
 	int limit, nent = 0, r = -E2BIG, i;
 	u32 func;
 	static const struct kvm_cpuid_param param[] = {
-		{ .func = 0, .has_leaf_count = true },
-		{ .func = 0x80000000, .has_leaf_count = true },
-		{ .func = 0xC0000000, .qualifier = is_centaur_cpu, .has_leaf_count = true },
+		{ .func = 0 },
+		{ .func = 0x80000000 },
+		{ .func = 0xC0000000, .qualifier = is_centaur_cpu },
 		{ .func = KVM_CPUID_SIGNATURE },
-		{ .func = KVM_CPUID_FEATURES },
 	};
 
 	if (cpuid->nent < 1)
@@ -869,9 +867,6 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
 		if (r)
 			goto out_free;
 
-		if (!ent->has_leaf_count)
-			continue;
-
 		limit = cpuid_entries[nent - 1].eax;
 		for (func = ent->func + 1; func <= limit && nent < cpuid->nent && r == 0; ++func)
 			r = do_cpuid_func(&cpuid_entries[nent], func,
-- 
2.21.0

