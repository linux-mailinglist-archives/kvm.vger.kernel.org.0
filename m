Return-Path: <kvm+bounces-26789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 814DD977BAE
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 10:57:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 01821B260BE
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 08:57:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88F161D6C61;
	Fri, 13 Sep 2024 08:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="I9ZkFCeF"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF311714CD;
	Fri, 13 Sep 2024 08:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726217838; cv=none; b=eAcWNsabXHpmInYoEivz+BPQPvmAjkyJ1FA5kANU6MMYOpt4vWQBRI6SZ0GVJpNd01ldMg1jxSQl8eD7PEdgWaAQChj91asDolNpCzuQnAVCKqQGIDT+aW0myWUn7WuYTrBRpdAUvcprakxcd9y8ia6yY+n4bEa/YKw30AZr4/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726217838; c=relaxed/simple;
	bh=zcFdpQbzJKsIubxtpyJsT/HdE90nXvhgnbaRRvOMwCg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l6FXditRy8xuZ/GkPbnhAiD3h0PqzeXgwoKWLUNTR2QGpr6d6x4UK9UuBxWcYiOErHMDRCMe7M4qwzgpkcbjD+wu9pgS/2dprJZNU+SP+1hazpZhIvyLB3gQKP2ogp4mP2DvhyPQkGJKTmurW4VH44zGPv7n/9NcDt2qIwzzzFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=I9ZkFCeF; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48D89FSw018461;
	Fri, 13 Sep 2024 08:57:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=pp1; bh=axo/DjJIaLKhBTChwIp2zOOGBs
	niBf0FSboJpyh9Tss=; b=I9ZkFCeFu5e/63xEokS6kRZtQGsipliEKzhxjWxpn9
	fjaaevBv55wi3cwha7g1L396vFJ74RrK6mK9Ljh0Nvb2/CJ4B0OVOdHw6JJ13dND
	9BZKofhH4WFXgIru4jU8+nDRbIFU59uFEzYbG4cF8C7FfBVe70vO7Otq2OECaGoF
	kJJEp1pxB6jGD5CBJHxCFh7Z6HAtcRx7wzOa9q5ey88h8kjEjM9zaRZTOvOBEa6w
	4YJbT4jwiqKixrSAydq5aCe/0WV7ck++vUzxIjOnY9aBAOTKthJZrTHYCyCouKmY
	aNRRwSTcysAcQovIsQ9LKEIF7kWrKTJLPyrPySTCAumg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41gc8qs2ry-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 08:57:14 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 48D8vDSR001286;
	Fri, 13 Sep 2024 08:57:13 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41gc8qs2ru-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 08:57:13 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48D6lCZv027389;
	Fri, 13 Sep 2024 08:57:13 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 41h3v3mss2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 08:57:13 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48D8v9JM57999722
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 08:57:09 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 879F02004B;
	Fri, 13 Sep 2024 08:57:09 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6B29B20040;
	Fri, 13 Sep 2024 08:57:09 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 13 Sep 2024 08:57:09 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1] configure: process arguments not starting with dash
Date: Fri, 13 Sep 2024 10:56:44 +0200
Message-ID: <20240913085709.122017-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1zGdLyAl2thhIfuxtTpNuXgrBErww-Qk
X-Proofpoint-ORIG-GUID: yEmJrmuTNImfRBLQbETJmZSmrKMnr0Oz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-13_04,2024-09-13_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 impostorscore=0 priorityscore=1501
 malwarescore=0 adultscore=0 clxscore=1011 mlxlogscore=999 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409130058

We have arguments in the configure script which take an additional
parameter, like --host-key-document. The syntax is as follows:

  --host-key-document=PARAMETER

We always expect an equals sign (=) after the argument name and the
parameter.

If the user omits '=' between the argument name and parameter, both
words will be interpreted as parameter-less arguments.

This on its own is not a problem, since the parameter would normally not
be a valid argument name and should hence lead to an error message.
However, this doesn't work currently.

The configure script stops parsing arguments when an argument starting
with something other than a dash is encountered. This means that
specifying arguments such as:

  --host-key-document /tmp/test --gen-se-header=/usr/bin/gen-se-header

Will actually lead to --gen-se-header being ignored. Note the space
instead of equals sign after --host-hey-document.

In addition, --host-key-document only verifies its parameter when it is
not empty so we will just continue as if no arguments were specified in
the case above.

This can be highly confusing, hence consume _all_ specified arguments,
even if they don't start with a dash. This will lead to an error in the
case above.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 configure | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/configure b/configure
index 27ae9cc89657..85a2358ca20b 100755
--- a/configure
+++ b/configure
@@ -102,8 +102,11 @@ EOF
     exit 1
 }
 
-while [[ "$1" = -* ]]; do
+optno=1
+argc=$#
+while [[ $optno -le $argc ]]; do
     opt="$1"; shift
+    optno=$(( $optno + 1 ))
     arg=
     if [[ "$opt" = *=* ]]; then
 	arg="${opt#*=}"
-- 
2.46.0


