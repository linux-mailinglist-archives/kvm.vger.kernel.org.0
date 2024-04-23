Return-Path: <kvm+bounces-15595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EC8778ADC2C
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 05:19:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 63D451F21E44
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 03:19:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 233101B952;
	Tue, 23 Apr 2024 03:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="onctW1bg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18ED718E1D
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 03:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713842330; cv=none; b=jhs3FP6LVyhOZydf7xg8PmAReuywnU1QJNKrEc0CfWdBjtmJN4n0IANmWa8JcGD2UFrQcoo6bICuMQFZkRQJm83hZcpnvnFNFaxAlDi1ZAqa5dj4a1cXBdR90AJX9MEPpKb7u0UZPsoJY2Mi8P27Wk8+QPhQvPJlDF43H2YF8Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713842330; c=relaxed/simple;
	bh=5hPF9z8vVp0Tex9XM09IQgMiimVbCDBKFyzEcXAlE9A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IT2kLNJ4CcrTkkmSSShA248goIKBCLVs1YBu9b81PrpNH+EDFl00Wm095aE4ec4uz3SzeZevv0eBG7F24GjcIlpP2lr3VS6iNhA7WRoQvmM9sMoFvxYvswTyf3EZMUhnBtCaNHG6feS3mrd1Nkkat0hQ7cxOnk6/OmWKTLf3bD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=onctW1bg; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43N2TeoG029955
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 22:50:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=pps01; bh=s/xhC0JeXfcELFVQ8yl/dQZx5wxcMGQHNNepZEFzy74=;
 b=onctW1bgNuvGvn/KU3pey0Mni9X0C5t8azRCrrYA/Z7MV9PF2dlKOgzqGzVdfq0WbggW
 t/nUdnHZj6TiWJgOn9I/PlxPmfx2ANh429ovWg63ER3UldOSoTEJOmYhHIZcJABhAQ3a
 wK06nhTB6O7Fam08gzqKBxGzezKTWLz28lkfO3bQVhy4J4kp7rKD3MJlBq4RaF3vuC5R
 NUlWG4ImELgj6cKYx+JPO9HyV+WcvCLaWMmJYghPaFG+EUDoRl11Qu2DD9133SSFAiFk
 xT5zF2dz1Y9MKHS2wlDyj+w/UybZy0NjVSbN7rveJlvkVrY6FeLjnv09yNLpEA+ZyH0T xQ== 
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 3xm9s5tafg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 22:50:22 -0400
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-5aa3afc55c6so1712202eaf.0
        for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 19:50:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713840591; x=1714445391;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s/xhC0JeXfcELFVQ8yl/dQZx5wxcMGQHNNepZEFzy74=;
        b=UleWdoEeeZy66lVtFMafXCeoUuEcXhMnhIHdCI6RJubz5bdd0Fyfi8bQweVWA6ojaT
         WJMDaLGgPqbDJ7weRczAA9bmXY9Tfda0RVxbasxIXn1LFxIeI+FiIqhNfmSvDj67/vZ2
         2r9qnaO3JN8NhUeefs5y4IsmO4r7AvZbpw3Kr3a1fK51HeDcRKugeNahN+WgUDFRDlyD
         mr2pe3HT7/VsKR7Sm3OXZdbXFFFeNk+vWOgBbD+1xPvQ7QuSpyCfVJSwx8U59whwE3AE
         5Fu8vIsFPYvvyhaMI7myyD99ubBeU5alMYY+G2G8Y6iRpB7NmEeArcp0LGpaAF/Jiph1
         DGgA==
X-Gm-Message-State: AOJu0YwruC558A6t4kq1yNQBQa+6led0fmiHj1uBmlZGq/ZMxwcbczUj
	zla+lXl/w9FW9LacqhY6hvofnfycdH1q/Q+4G7tZTOvOWVapCyxkjHbSlku2nQxfEmh2MHgiDy2
	vY3uDaZ3iOm+qgJhpuYwOQulCJufyu4hEaE7nMWfnrdOWW2gngIY/HA==
X-Received: by 2002:a05:6359:4591:b0:186:4564:8395 with SMTP id no17-20020a056359459100b0018645648395mr13667952rwb.2.1713840591511;
        Mon, 22 Apr 2024 19:49:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFl3MunUJbYxu+yRVEDlj6Hrex5h/qk4UWtRcvcfDlsM4UzZHXXKsSxugMr7V2r6VI2j0D47g==
X-Received: by 2002:a05:6359:4591:b0:186:4564:8395 with SMTP id no17-20020a056359459100b0018645648395mr13667917rwb.2.1713840591096;
        Mon, 22 Apr 2024 19:49:51 -0700 (PDT)
Received: from rivalak.cs.columbia.edu (kele.cs.columbia.edu. [128.59.19.81])
        by smtp.gmail.com with ESMTPSA id d12-20020ac851cc000000b00438527a4eb5sm3547732qtn.10.2024.04.22.19.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Apr 2024 19:49:50 -0700 (PDT)
From: Kele Huang <kele@cs.columbia.edu>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, Kele Huang <kele@cs.columbia.edu>
Subject: [1/1] KVM: restrict kvm_gfn_to_hva_cache_init() to only accept address ranges within one page
Date: Mon, 22 Apr 2024 22:49:33 -0400
Message-ID: <20240423024933.80143-1-kele@cs.columbia.edu>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: fUAHMxAtrFb5X68sCaDnYis0yhG-JcYZ
X-Proofpoint-ORIG-GUID: fUAHMxAtrFb5X68sCaDnYis0yhG-JcYZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-23_02,2024-04-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 bulkscore=10 phishscore=0 spamscore=0 impostorscore=0 malwarescore=0
 lowpriorityscore=10 priorityscore=1501 clxscore=1011 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404230007

Function kvm_gfn_to_hva_cache_init() is exported and used to init
gfn to hva cache at various places, such as called in function
kvm_pv_enable_async_pf().  However, this function directly tail
calls function __kvm_gfn_to_hva_cache_init(), which assigns
ghc->memslot to NULL and returns 0 for cache initialization of
cross pages cache.  This is unsafe as 0 typically means a successful
return, but it actually fails to return a valid ghc->memslot.
The functions call kvm_gfn_to_hva_cache_init(), such as
kvm_lapic_set_vapicz_addr() do not make future checking on the
ghc->memslot if kvm_gfn_to_hva_cache_init() returns a 0.  Moreover,
other developers may try to initialize a cache across pages by
calling this function but fail with a success return value.

This patch fixes this issue by explicitly restricting function
kvm_gfn_to_hva_cache_init() to only accept address ranges within
one page and adding comments to the function accordingly.

Signed-off-by: Kele Huang <kele@cs.columbia.edu>
---
 virt/kvm/kvm_main.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9230ebe1753f..6efe579f6b5f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3476,11 +3476,22 @@ static int __kvm_gfn_to_hva_cache_init(struct kvm_memslots *slots,
 	return 0;
 }
 
+/*
+ * Please note that this function only supports gfn_to_hva_cache
+ * initialization within a single page.
+ */
 int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 			      gpa_t gpa, unsigned long len)
 {
 	struct kvm_memslots *slots = kvm_memslots(kvm);
-	return __kvm_gfn_to_hva_cache_init(slots, ghc, gpa, len);
+	gfn_t start_gfn = gpa >> PAGE_SHIFT;
+	gfn_t end_gfn = (gpa + len - 1) >> PAGE_SHIFT;
+	gfn_t nr_pages_needed = end_gfn - start_gfn + 1;
+
+	if (likely(nr_pages_needed == 1))
+		return __kvm_gfn_to_hva_cache_init(slots, ghc, gpa, len);
+	else
+		return -EINVAL;
 }
 EXPORT_SYMBOL_GPL(kvm_gfn_to_hva_cache_init);
 
-- 
2.44.0


