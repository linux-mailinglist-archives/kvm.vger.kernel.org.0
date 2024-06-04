Return-Path: <kvm+bounces-18759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 550DC8FB19F
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 14:00:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 08D671F23AC3
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 12:00:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 876F3145B2C;
	Tue,  4 Jun 2024 12:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JezbahM5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34602145A1D;
	Tue,  4 Jun 2024 11:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717502399; cv=none; b=ikgg0OSWmSMxg4cXCtcs3BJDNJHWjc18YKxPbx6lfDl/9GuRRa1pEo2Cw5muvYdR837ZetL7X22C4KZJSc/LDbPn6bCUnMe8sfXThxu4rmbqdqx6yGw4yAUpcZbsG7UVbbDTYdqcXEwbhISq70TTcnh/HVp8rxlFdHu97rv3eEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717502399; c=relaxed/simple;
	bh=M6As7ZGhYuZoZd+CPvSeCMVOGvlPd3Hc+JcJjdBwGuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yrs8EMQN48wpanxQA1InPzg1jHbw0mJttXcP91f7GkqM9rEg2ktpHWuEUceoIxsU5GBdKy3sYLrEtKzFuy+GXpj0DxfYeGjmBRzMOMH9i6Wi9FH5liAblG588npVvWc+YRnsnXBWPZO1l4OJQ3W4RBzr4TGqFBRp5w8eeSobNWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JezbahM5; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 454BknFk004638;
	Tue, 4 Jun 2024 11:59:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : date : from : in-reply-to : message-id :
 mime-version : references : subject : to; s=pp1;
 bh=Ppv8tgE7pPzq4jYz87pmrcwToMp2s1b8v+bexG//mYE=;
 b=JezbahM5sfdOBgL+p/Sws+5/SYGLhigdBdopqXjGTAwkMM2/2en+B7suqXPIA3BBaHSu
 WbaibXVzNEIz2ZfIVggboL628jOAIUfEyPayZ69Am1R1aonJqOvxFRMpFH1lczwDHdWR
 QmbwSYjn+kr/63IfRTuHDtz0coiYNGaysmMdBEwt5AyRAHBq4mDafqeQ6kF1+Fl8bV3w
 Ia6NttoBNn6+KguDt7EXYzjVc+ioLq/keXLUhECQPmHgwwj/PlpLGhYLbbwraItRxNrB
 hraBJpQzmR3Ow9qqGEwWws6JBPDbipI6Ch7ki9mhIqrpRfTYHQEkgSehGwNj3yG/P5LP KA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yj2bsg1qx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Jun 2024 11:59:57 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 454Bvj3K023739;
	Tue, 4 Jun 2024 11:59:56 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yj2bsg1qu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Jun 2024 11:59:56 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 454APSl9022794;
	Tue, 4 Jun 2024 11:59:55 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ygg6m5ht4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Jun 2024 11:59:55 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 454Bxo8s29229498
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 4 Jun 2024 11:59:52 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 26E642004F;
	Tue,  4 Jun 2024 11:59:50 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A018A2004B;
	Tue,  4 Jun 2024 11:59:49 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.fritz.box (unknown [9.171.63.147])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  4 Jun 2024 11:59:49 +0000 (GMT)
From: Marc Hartmayer <mhartmay@linux.ibm.com>
To: <linux-s390@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>
Cc: <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Steffen Eiden <seiden@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v1 1/3] s390x/Makefile: snippets: Add separate target for the ELF snippets
Date: Tue,  4 Jun 2024 13:59:30 +0200
Message-ID: <20240604115932.86596-2-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240604115932.86596-1-mhartmay@linux.ibm.com>
References: <20240604115932.86596-1-mhartmay@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _wkKb6gq94jSzunkaH8z2w70K2kyM_0y
X-Proofpoint-GUID: c8Jfcqf5fTEzhSGDfBA3637jlUHD5del
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-04_05,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 impostorscore=0 suspectscore=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 clxscore=1015 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406040097

It's unusual to create multiple files in one target rule, and it's even more
unusual to create an ELF file with a `.gbin` file extension first, and then
overwrite it in the next step. It might even lead to errors as the input file
path is also used as the output file path - but this depends on the objcopy
implementation. Therefore, create an extra target for the ELF files and list it
as a prerequisite for the *.gbin targets.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
---
 s390x/Makefile | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/s390x/Makefile b/s390x/Makefile
index 23342bd64f44..784818b2883e 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -153,14 +153,18 @@ $(SNIPPET_DIR)/asm/%.o: $(SNIPPET_DIR)/asm/%.S $(asm-offsets)
 $(SNIPPET_DIR)/c/%.o: $(SNIPPET_DIR)/c/%.c $(asm-offsets)
 	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
 
-$(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(SNIPPET_DIR)/asm/flat.lds
+$(SNIPPET_DIR)/asm/%.elf: $(SNIPPET_DIR)/asm/%.o $(SNIPPET_DIR)/asm/flat.lds
 	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/asm/flat.lds $<
-	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $@ $@
+
+$(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.elf
+	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $< $@
 	truncate -s '%4096' $@
 
-$(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS) $(SNIPPET_DIR)/c/flat.lds
+$(SNIPPET_DIR)/c/%.elf: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS) $(SNIPPET_DIR)/c/flat.lds
 	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/c/flat.lds $< $(snippet_lib) $(FLATLIBS)
-	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $@ $@
+
+$(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.elf
+	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $< $@
 	truncate -s '%4096' $@
 
 %.hdr: %.gbin $(HOST_KEY_DOCUMENT)
-- 
2.34.1


