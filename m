Return-Path: <kvm+bounces-7535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9005D84382C
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 08:45:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C2FA41C2582E
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 07:45:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B9A557339;
	Wed, 31 Jan 2024 07:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OI7iAzO7"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419775FBA3;
	Wed, 31 Jan 2024 07:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706687100; cv=none; b=gNEhHyLEpyc0w3m4Y/LzvrOWc//dNbrw58N2f+D0RSlegrW876XO3ubXswkzRmXIy7w6KHKA44ZZyfaiqro/uByB5ZqaXyEO4Maw6WGgiNbHEY9knbWUQWDshEqVclBKtmJ/XVhbfeFV6J4H1iZIldI1CyTyYW6Mo0zOPxdlkV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706687100; c=relaxed/simple;
	bh=UM6/zkdoNiwVS+WydWJVd2C2Pgo9XyKLremQp9WsTOg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=O10cqj6WMjRCZLTwxHWrlQbsRRVMyT8gitsjPso6i1oSMHOxPMzr3hRhUSeZK/6i2AHUWPtBfsG7FcIMsENLlD5dQoiHMqdoWM0k6QcRSKPDaJyHgvDLWttgfABY+c3hMojMMpmAXz6RzMGfW+IMnlHnGdqBG+1wTvXxvP8ks+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OI7iAzO7; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40V6Huis032268;
	Wed, 31 Jan 2024 07:44:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=Ix/2K9UVc6Dr0BIQ8Qu2PAODInqVRDkg8E05rwWw8HY=;
 b=OI7iAzO728/7YacXt56AL44jmWmf4hld0kBufir3zmgDk0iWO6y7bmLGyOQ91MHQoOhT
 gbxdsDowqhHy57oPAVPq5HOxxivilkQNoe9CBexkEnrVIZaiRBxs/QFhS5AYgrVkiYqq
 Cm3RIo9BL45kyfbY3hDOqpmLnd0T/tcaZ0pfdH5jIns2OQnfoCL1s+QUOMI2ToSyxW68
 HeNBMrHjwquEk+XQWMyjv6MfDd0vlSw7hAnoDY6Hu1vxH5eUY7iWc9brtkD11ku0VTuY
 Bzx8PGZh4aKFGfSZvLUHAW9IhThCZyO0nVljnDOnxwdqTyZPDRlk5ZKCrd70VmeO7IZM zg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vyac9a3dn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 31 Jan 2024 07:44:56 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40V6rSVI020853;
	Wed, 31 Jan 2024 07:44:56 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vyac9a3dd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 31 Jan 2024 07:44:56 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40V6kQb2010858;
	Wed, 31 Jan 2024 07:44:55 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vweckkpsn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 31 Jan 2024 07:44:55 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40V7iq0W27591192
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 07:44:52 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 85E602004D;
	Wed, 31 Jan 2024 07:44:52 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4B27820040;
	Wed, 31 Jan 2024 07:44:52 +0000 (GMT)
Received: from a46lp67.lnxne.boe (unknown [9.152.108.100])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 31 Jan 2024 07:44:52 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 0/5] s390x: Dirty cc before executing tested instructions
Date: Wed, 31 Jan 2024 07:44:22 +0000
Message-Id: <20240131074427.70871-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rWsJPSOdS9R1ePVcG9Al8bTFbaVNXIdE
X-Proofpoint-GUID: HOd9ZHUpiQ_BrxbwQSmbQZpiLgPCKLEQ
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-31_02,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=2 mlxlogscore=164 bulkscore=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0 spamscore=2
 impostorscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 mlxscore=2 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401310057

A recent s390 KVM fixpatch [1] showed us that checking the cc is not
enough when emulation code forgets to set the cc. There might just be
the correct cc in the PSW which would make the cc check succeed.

This series intentionally dirties the cc for sigp, uvc, some io
instructions and sclp to make cc setting errors more apparent. I had a
cursory look through the tested instructions and those are the most
prominent ones with defined cc values.

Since the issue appeared in PQAP my AP test series is now dependent on
this series.

[1] https://lore.kernel.org/kvm/20231201181657.1614645-1-farman@linux.ibm.com/

v2:
	* Moved from spm to tmll (thanks Nina)

Janosch Frank (5):
  lib: s390x: sigp: Dirty CC before sigp execution
  lib: s390x: uv: Dirty CC before uvc execution
  lib: s390x: css: Dirty CC before css instructions
  s390x: mvpg: Dirty CC before mvpg execution
  s390x: sclp: Dirty CC before sclp execution

 lib/s390x/asm/sigp.h |  6 +++++-
 lib/s390x/asm/uv.h   |  4 +++-
 lib/s390x/css.h      | 16 ++++++++++++----
 s390x/mvpg.c         |  6 ++++--
 s390x/sclp.c         |  5 ++++-
 5 files changed, 28 insertions(+), 9 deletions(-)

-- 
2.40.1


