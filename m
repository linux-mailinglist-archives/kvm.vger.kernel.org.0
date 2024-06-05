Return-Path: <kvm+bounces-18899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A8F0B8FCE22
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 15:01:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C1D61F2A85D
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 13:01:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7256D1B29D7;
	Wed,  5 Jun 2024 12:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="CBitWUsR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517731B29CD
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 12:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717589756; cv=none; b=f82E0LhAzzpKTA81gRqCxOK8cM7aI8j75AAI/b7evsDiPS4mTViY2RKBcIywoxiQViNJig1CE6vxDle6S0WW2nLe4ILAyzk7QnicYJ2BhqpaBo105Fq/bAFFbzjYbAjtHXHlOvTRd3tdPqgX0k8oO+qbx6B+3E1Tb4HN+8O1BSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717589756; c=relaxed/simple;
	bh=jTQnCjAYiOnyg83RQMSJJfcBlJdwMJJeulbs10TuFN0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=dkLLRIBYBLvs5UGDgEcLEfZyKviFnkND2vWquVo4ZzHHmu8KE/+yKlpuAy9wL4hLHbLNhQUb5Bq0sD00ZHmlrVkELPiHpAw87u5cBHS+yo8nB/kFK7Cs8PjHwvApLi2KFeeT3mngS9i5zwf6Cr9A+N3dcgommpaO6DUl4ixby+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=CBitWUsR; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-70260814b2dso757127b3a.1
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 05:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1717589755; x=1718194555; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=s1s067gNcLroY85Io7X9j2HhTsy4/JNlR/TnSjjDyVA=;
        b=CBitWUsR33hB9HOopjBrDaBMynnxWxj9jsJptpQQEiMRYqcDTNOrzWqgU12T6nM/if
         Js42uzlCtjQ54l343H/Qt6ze3cksIGBBpN3P85Eu9VQg8F3J8rkPF7wr3jdciHklWuN7
         LpqsnFHlIKWARFzMcHv95e3qd5iT1U88MdTD19Noi6zqiitE6BJY+DzB8FVAQL17neoe
         FHIV14Orizcq46ErCe3sEfnfdJwVLMbYHHHvcF/ZI684TX7hIvmosQNFCuTq0JQCKSPl
         gu6lrE2kQfKaf0IHv1QfA94jGI9yeJQQSKzFsOj87i1oolHhpvndPscP647SKDNs4ol1
         qcwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717589755; x=1718194555;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s1s067gNcLroY85Io7X9j2HhTsy4/JNlR/TnSjjDyVA=;
        b=GWSLD38lTidlRdLaju5x744sGnwAui6Lazh5L3507Rl2OMux87WN/esjm8n2x+P0l6
         WbaHSsI2UAl3O2pn6kzzHs3HhNqjXhDHf5+SRxxRqP/HDQUbadvop8PZEw0UNFfCtRbc
         0zQ0+60F2bJo3aY2hOwI/Fk+wWxhCn7KVe/jOtiPHp+qhkqCFJxWLKr7+hE1OLikfIQz
         aQqcEZMrqLVmmn2vmsJhj2qqf66TNvFVGpE9bhrrgxGnOCgk5w9cnN3w3cNHVGPuWnK6
         Lj+1XwjjlPU9QMVGoaetdHz94qKG9wHp6EdL3MjJSgkrMfHGDu/6g4zhqq4zs2h1942+
         CQaA==
X-Forwarded-Encrypted: i=1; AJvYcCUtoT0l8hBcxEfw8vIxG+g9UOw1Q8VuK5Gv+j48vMB8vwo31vlmnTgn/BhUpfDOHTR0RdfokVV+JBYGIu9ksFKgS4jy
X-Gm-Message-State: AOJu0YyQjVJ8WGeDhaoD0OLzPK2QNNnzv04eZEYdOfWPEyTvm6GpvYjp
	yCWAhfNlvgpx5qE2eDM+4fjxQn84LCOl4UKIEcJ8qRbPtsCWGyUUrRBLFdGs7vw=
X-Google-Smtp-Source: AGHT+IE2uyoTxe3pUNkQoaQt0ajX+GBn9F8zoOHdbUYCJhav/6GYlnkgU9F3LAFV0i5BxmNjeJ1V1Q==
X-Received: by 2002:a05:6a00:6082:b0:702:5514:4cb8 with SMTP id d2e1a72fcca58-7027fba0d23mr6188351b3a.4.1717589754693;
        Wed, 05 Jun 2024 05:15:54 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-703ee672fb3sm885379b3a.216.2024.06.05.05.15.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 05:15:54 -0700 (PDT)
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
To: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: apatel@ventanamicro.com,
	alex@ghiti.fr,
	ajones@ventanamicro.com,
	greentime.hu@sifive.com,
	vincent.chen@sifive.com,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v5 4/4] KVM: riscv: selftests: Add Svade and Svadu Extension to get-reg-list test
Date: Wed,  5 Jun 2024 20:15:10 +0800
Message-Id: <20240605121512.32083-5-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240605121512.32083-1-yongxuan.wang@sifive.com>
References: <20240605121512.32083-1-yongxuan.wang@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Update the get-reg-list test to test the Svade and Svadu Extensions are
available for guest OS.

Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
---
 tools/testing/selftests/kvm/riscv/get-reg-list.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
index 222198dd6d04..1d32351ad55e 100644
--- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
+++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
@@ -45,6 +45,8 @@ bool filter_reg(__u64 reg)
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SSAIA:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SSCOFPMF:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SSTC:
+	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SVADE:
+	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SVADU:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SVINVAL:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SVNAPOT:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SVPBMT:
@@ -411,6 +413,8 @@ static const char *isa_ext_single_id_to_str(__u64 reg_off)
 		KVM_ISA_EXT_ARR(SSAIA),
 		KVM_ISA_EXT_ARR(SSCOFPMF),
 		KVM_ISA_EXT_ARR(SSTC),
+		KVM_ISA_EXT_ARR(SVADE),
+		KVM_ISA_EXT_ARR(SVADU),
 		KVM_ISA_EXT_ARR(SVINVAL),
 		KVM_ISA_EXT_ARR(SVNAPOT),
 		KVM_ISA_EXT_ARR(SVPBMT),
@@ -935,6 +939,8 @@ KVM_ISA_EXT_SIMPLE_CONFIG(h, H);
 KVM_ISA_EXT_SUBLIST_CONFIG(smstateen, SMSTATEEN);
 KVM_ISA_EXT_SIMPLE_CONFIG(sscofpmf, SSCOFPMF);
 KVM_ISA_EXT_SIMPLE_CONFIG(sstc, SSTC);
+KVM_ISA_EXT_SIMPLE_CONFIG(svade, SVADE);
+KVM_ISA_EXT_SIMPLE_CONFIG(svadu, SVADU);
 KVM_ISA_EXT_SIMPLE_CONFIG(svinval, SVINVAL);
 KVM_ISA_EXT_SIMPLE_CONFIG(svnapot, SVNAPOT);
 KVM_ISA_EXT_SIMPLE_CONFIG(svpbmt, SVPBMT);
@@ -991,6 +997,8 @@ struct vcpu_reg_list *vcpu_configs[] = {
 	&config_smstateen,
 	&config_sscofpmf,
 	&config_sstc,
+	&config_svade,
+	&config_svadu,
 	&config_svinval,
 	&config_svnapot,
 	&config_svpbmt,
-- 
2.17.1


