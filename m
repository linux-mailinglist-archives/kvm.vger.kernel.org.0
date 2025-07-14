Return-Path: <kvm+bounces-52286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 00C86B03B8C
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 11:59:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 863447A2A3F
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 09:57:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 411F724337D;
	Mon, 14 Jul 2025 09:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="XbOMrdkV"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE4F242930
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 09:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.19.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752487094; cv=none; b=ng/lsNxG6+JDj11RNzHh+NRB8h08yaKKxGCQw3/YvGbvf/QsNtpR0rjiSvZkNDepjypswde94VKqFW7WZrPieAGz9aSEyeDhEvLc1TDgDC7lpCLkqIFnXeOtCAlSpk8K6MAX4belq/5b1f19fW2cLriVIf1NAHim/0eNOe4Dwjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752487094; c=relaxed/simple;
	bh=3JxyGduxoKfpBfNPCoClE2fonMXWAcHTNOvurq5RQN8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=CeLCkiUANJJLA1TksNmxxVXFI1ADtdFch9Nb3RRR4SaxSrMtt/6pppFwPaaCEoEDlIA7Dg26f+G49NQ6xGldKakh2lmbTtQAKbNg5e6Rk+j1rCjP4pA4scdFFKTZjVD63nw185yNERxpOKVA8tTn03BIebD5Me4P3ZYAwuCnpRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=XbOMrdkV; arc=none smtp.client-ip=54.207.19.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1752486992;
	bh=1VLZ/TxnScpdUwIKEh3OguVq0kTcER2qBYmnDf1YyUs=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=XbOMrdkVXYyXld44pQC1QrDCTlVtdWl2pye31+KlJld7g9RZFLOqNjrKly5G+/CNd
	 BalS6YWT0bpb6Jhy72EcV7GP7Hu8RjIL0LpiFTcxKd7nWZNOM+uqSrCJye7ZYn0gGl
	 btAooULWEh5tf0OYN6STfe0aFBiXb/PuCyqMuYvo=
X-QQ-mid: zesmtpsz7t1752486977t03bc3352
X-QQ-Originating-IP: VBUv8AB24h/qlMCQoqldEWulkzF9VWqRBnkTf0D3l58=
Received: from localhost.localdomain ( [123.114.60.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 14 Jul 2025 17:56:16 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 10135975146205815428
EX-QQ-RecipientCnt: 3
From: Qiang Ma <maqianga@uniontech.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	Qiang Ma <maqianga@uniontech.com>
Subject: [kvm-unit-tests PATCH] x86: nSVM: Fix exit_info_2 check error of npt_rw_pfwalk_check()
Date: Mon, 14 Jul 2025 17:56:14 +0800
Message-Id: <20250714095614.30657-1-maqianga@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: MUe2PhP7Eq79W/mOFq7B/rsAj3FH04XmzZ2aA8McmrOUbYh0DZ+LJeqe
	VRJlN/lOvGhj/stTXmk0Ti8OkRiYwbfsGS50iGS5KOmwIIxrbEJv2xrB/ivxte2YqELrZCu
	xO+M0EL8J9eq6I77+iz96KPKZViZJ/IHYY3wUQifH5+pdbNqhQVRl3xixG/8R9Y+dhhzhco
	DEoNLeq4JwDF9Ns4QM/KDVrPOls3Yk0bwckiIjoDHAVJJ9O06yOuNHT17XZ0FHWIB0FLV8t
	6RM5lzbSzAUPIo9obuMRqRE8dOXP2+1As+dYijINSTKCfWsnzx7EgqFYKjdATkUsqWVHM31
	08P0edX4uqKTm/ARt4mXSO23E6cpKxbAiSVuGlhulfAfkfMbJ4qDih5SRIwwyD9jD3to3qF
	FUuqEgL6gkZI1bN3FXSQTEXA+ONCiX1SrTceVQARPiJEjyTDE9v7BYG5RBH5ipfD8DjJ3WT
	5L7aAn4cN9/jt+twnuFpqTQMQtVGcxETiF6a7fShTKD141/bVVGc97nU52oZLj/f4loQdLv
	hnOeuFz7AKpzE7nukWoFFWEeVk43LaXNqTqySsN+qdFyMKGXtDQpLjcbdPLicWm+3/fhiSB
	V3BOAZjQojS1QqUPlioxp0/k5uwJCKZGeG2tMP2Urstv/80iJOhLKYPcdYo9BZNt+87m09C
	/ZmlBlocUoRDz5t/qsX6hHZ7ftfbmQy7tJiBwCmHNmfx4P4l1scxB+ibsadhYvpeiZ4m+a+
	rmPXduCvZ2dc+n/CljGn/ALXfvHGCbFJa92oxlr5whsvv9l7dvFW+XjiTSiGmstIrflgMP+
	2L1LUAT2In2bFlwJmTgWM/VnEm55R/6624JbklVvn/7BCE6PpoqosWVR+xlnqOa/W+Z+9/M
	kdMZYU0bYFA4mV7kzLmSEGIUjQsNfVopYOSW6T9sBdphesdqV7Ky9euMR8qSvW1J7kQ8951
	MmaJw+x/2I3K7daXjYJCFVKBwcN4jxJQtpqE63p//iGh5VA2P6e6Uda59RjGNgNI80a+Z+K
	rK8oQuxksZkBuB4xpA51ZHG869tDyr6CxTOlaYhvnnw2cLcYGYdpfuYiSp7AWZMVtJKdhzZ
	g==
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
X-QQ-RECHKSPAM: 0

The testcase log:

kvm-unit-tests]# TESTNAME=svm_npt TIMEOUT=90s MACHINE= ACCEL= ./x86/run x86/svm_npt.flat -smp 2 -cpu max,+svm -m 4g
...
enabling apic
smp: waiting for 1 APs
enabling apic
setup: CPU 1 online
paging enabled
cr0 = 80010011
cr3 = 10bf000
cr4 = 20
NPT detected - running all tests with NPT enabled
PASS: npt_nx
PASS: npt_np
PASS: npt_us
PASS: npt_rw
npt_rw_pfwalk_check: CR3: 10bf000 EXIT_INFO_2: 10bf5f8
FAIL: npt_rw_pfwalk
...

CR4=0x20, PAE is enabled, CR3 is PDPT base address, aligned on a 32-byte
boundary, looking at the above test results, it is still 4k alignment in reality,
exit_info_2 in vmcb stores the falut address of GPA.

So, after aligning the GPA to PAGE_SIZE, compare the CR3 and GPA.

PAE Paging (CR4.PAE=1)—This field is 27 bits and occupies bits 31:5.
The CR3 register points to the base address of the page-directory-pointer
table. The page-directory-pointer table is aligned on a 32-byte boundary,
with the low 5 address bits 4:0 assumed to be 0.

Table C-1. SVM Intercept Codes (continued):
Code Name       Cause
400h VMEXIT_NPF EXITINFO2 contains the guest physical address causing the fault.

This is described in the AMD64 Architecture Programmers Manual Volume
2, Order Number 24593.

Signed-off-by: Qiang Ma <maqianga@uniontech.com>
---
 x86/svm_npt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/svm_npt.c b/x86/svm_npt.c
index bd5e8f35..08614d84 100644
--- a/x86/svm_npt.c
+++ b/x86/svm_npt.c
@@ -132,7 +132,7 @@ static bool npt_rw_pfwalk_check(struct svm_test *test)
 
 	return (vmcb->control.exit_code == SVM_EXIT_NPF)
 	    && (vmcb->control.exit_info_1 == 0x200000007ULL)
-	    && (vmcb->control.exit_info_2 == read_cr3());
+	    && ((vmcb->control.exit_info_2 & PAGE_MASK) == read_cr3());
 }
 
 static bool was_x2apic;
-- 
2.20.1


