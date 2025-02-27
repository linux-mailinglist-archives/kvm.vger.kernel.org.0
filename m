Return-Path: <kvm+bounces-39567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D941A47E89
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 14:07:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1ABBD188C9B5
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 13:07:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 345B122F14C;
	Thu, 27 Feb 2025 13:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ta/XMbp0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C508822E3F7
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 13:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740661641; cv=none; b=kG4yLtT4EvWNn2KkC2QQQ0jUIGeCVKf03B0OMakvOnWf/tQkom+5qgNl6lYnu22duA4K4XzggdfUy/aeP4lhdyh8YQ86Obc04VfFGY8ja3m11A1qNwZ2ivM1l2smMVOVz8RRe9oWlRBUjiTkRD3gW3CgyLYxcjNhzaRQmRu/e54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740661641; c=relaxed/simple;
	bh=z5nansO47ETzXypSi+Fx4hXGPjukljqk01STgcLu8Ao=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=HBh2ei039L5DzX3x12oyF+YcbKKaXlTetlcGwDrX8O/8EHyH25bYAesyPZYpCFe83pVJpfd3JvLOqOEJhxbuniULvffe4hju8H1fTlvqXCQlApKzrh9ucFfyy0lhhTu4y4tGeoWY7mTkflnjffDXInZ++UNxSoVoa7LuYtJ3TUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ta/XMbp0; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51R7WmJY017870;
	Thu, 27 Feb 2025 13:07:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-type:date:from:message-id:mime-version:subject:to; s=
	pp1; bh=tnlHUn6Ri5yxdjt2GtLWm9yjkPAfiYuFnH4/z8MYybg=; b=Ta/XMbp0
	+R4B9CCVqLRgJjiZ1+fuGE7NzrYJ+SEBBmcp66o5s+tcymDPKUkviOElkLn2tNgy
	Fu6Lg1EODL50j9K924/Y+JpCwMpKUxsdJxmASs7y80cZl4zCvPeWP1YN68b7in3Z
	f6UnUo1lsYR+EZR63lMtMAU5q5PsMwbkYu7quCObm5EsyCPa554/cie4snUpDEM2
	n7H81qNeXTw7kte2hXBYDAgWiuAWhDAckkZKXMd4Ux1qOCkOdlcudpfbtt9KGxGg
	BINaDJUtn02BxdDayCQDL745O4vxf4sJG+KMa9yvXYMhRi+8GFxFXOtiywQ6tFKG
	Vefxi51SjvvCvA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 452krp9ha7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Feb 2025 13:07:08 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51RC9Mdf012491;
	Thu, 27 Feb 2025 13:07:08 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44ys9yrx0x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Feb 2025 13:07:08 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51RD76CS36962584
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Feb 2025 13:07:06 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1E5B720043;
	Thu, 27 Feb 2025 13:07:06 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DC5E520040;
	Thu, 27 Feb 2025 13:07:05 +0000 (GMT)
Received: from localhost (unknown [9.171.86.210])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 27 Feb 2025 13:07:05 +0000 (GMT)
Date: Thu, 27 Feb 2025 14:07:05 +0100
From: Andreas Grapentin <gra@linux.ibm.com>
To: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH] arch-run: fix test skips when /dev/stderr
 does not point to /proc/self/fd/2
Message-ID: <ld5vg3ytv252ceaymg4mnq5jpnmklfvt2xkoldg67vkjl4awba@w3gc24eqeoxc>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: m2R1HVjBpbMaoryBA_px7w7FJCSTj-3I
X-Proofpoint-GUID: m2R1HVjBpbMaoryBA_px7w7FJCSTj-3I
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-27_06,2025-02-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 priorityscore=1501
 mlxscore=0 bulkscore=0 mlxlogscore=999 clxscore=1011 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2502270099

In configurations where /dev/stderr does not link to /proc/self/fd/2,
run_qemu in arch-run.bash leaks the stderr of the invoked qemu command
to /dev/stderr, instead of it being captured to the log variable in
premature_failure in runtime.bash.

This causes all tests to be skipped since the output required for the
grep command in that function to indicate success is never present.

As a possible fix, this patch gives stderr the same treatment as stdout
in run_qemu, producing a dedicated file descriptor and handing it into
the subshell.

Signed-off-by: Andreas Grapentin <gra@linux.ibm.com>
---
 scripts/arch-run.bash | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 2e4820c2..362aa1c5 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -33,11 +33,13 @@ run_qemu ()
 	[ "$ENVIRON_DEFAULT" = "yes" ] && echo -n " #"
 	echo " $INITRD"
 
-	# stdout to {stdout}, stderr to $errors and stderr
+	# stdout to {stdout}, stderr to $errors and {stderr}
 	exec {stdout}>&1
-	errors=$("${@}" $INITRD </dev/null 2> >(tee /dev/stderr) > /dev/fd/$stdout)
+	exec {stderr}>&2
+	errors=$("${@}" $INITRD </dev/null 2> >(tee /dev/fd/$stderr) > /dev/fd/$stdout)
 	ret=$?
 	exec {stdout}>&-
+	exec {stderr}>&-
 
 	[ $ret -eq 134 ] && echo "QEMU Aborted" >&2
 
-- 
2.48.1


