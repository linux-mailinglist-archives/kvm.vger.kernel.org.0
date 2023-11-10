Return-Path: <kvm+bounces-1479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06F407E7CBE
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 14:56:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3D240B21419
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 13:56:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD46F208D0;
	Fri, 10 Nov 2023 13:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tu89auA1"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73A736B1D
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 13:54:44 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9481438221
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 05:54:42 -0800 (PST)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AADkZpZ017553;
	Fri, 10 Nov 2023 13:54:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=E2FGw/iZ3TgxIchk14iadgte2VsbK4rKmFKavuiu/5M=;
 b=tu89auA1ZcoJfksxDM0sN4Iu/tGt+houMX3EgdoN5M+viR+wLdA4QAnUYDTHszRo9MHf
 lJNkIzmANwC4ZrSvJPFy9mIN2/rOvp24c9gQSVYOploFeu5RNSBhl6FaO3OWaIQppndl
 Y2HNt8l31zM40mYGfMOYjU4kZppc7SyMO5KhHbxsiA8DraUkX/AFmin/CCtDc/FODb/F
 7pVIfAT7025RD7i5EzUMPgInqdxW2ukhhwHt2yLSkVBSbgJEsnoML7Sdn7Pa5gA4YU/F
 98160bY3dOpY14/fECpaDcRhRouqEI8LyezPDUVhKlvu2jy3v78cMKDxwRAFYuN3CZgM 5Q== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9n6uhff4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:40 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AADmSuL026540;
	Fri, 10 Nov 2023 13:54:39 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9n6uhfen-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:39 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AADsB2L019256;
	Fri, 10 Nov 2023 13:54:38 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u7w24b6g9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:38 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AADsZT921496330
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Nov 2023 13:54:36 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B6AF520040;
	Fri, 10 Nov 2023 13:54:35 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 47F6220043;
	Fri, 10 Nov 2023 13:54:35 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.179.18.113])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Nov 2023 13:54:35 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 18/26] s390x: topology: Add complex topology test
Date: Fri, 10 Nov 2023 14:52:27 +0100
Message-ID: <20231110135348.245156-19-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231110135348.245156-1-nrb@linux.ibm.com>
References: <20231110135348.245156-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HpORnAwbH6E6DstC53oda50XopthvhEt
X-Proofpoint-ORIG-GUID: 87mbED1TDoDuaqaqyzRVsnahh7VErLyw
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-10_10,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 mlxlogscore=999
 spamscore=0 bulkscore=0 malwarescore=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311100114

From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Run the topology test case with a complex topology configuration.
Randomly generated with:
python -c 'import random
ds=bs=ss=2
cs=16
cids=list(range(1,ds*bs*ss*cs))
random.shuffle(cids)
i = 0
for d in range(ds):
    for b in range(bs):
        for s in range(ss):
            for c in range(cs):
                if (d,b,s,c) != (0,0,0,0):
                    ded=["false","true"][random.randrange(0,2)]
                    ent="high" if ded == "true" else ["low", "medium", "high"][random.randrange(0,3)]
                    print(f"-device max-s390x-cpu,core-id={cids[i]},drawer-id={d},book-id={b},socket-id={s},entitlement={ent},dedicated={ded}")
                    i+=1'

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Link: https://lore.kernel.org/r/20231030160349.458764-11-nsg@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/unittests.cfg | 133 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 133 insertions(+)

diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 68e119e..b08b0fb 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -247,3 +247,136 @@ file = topology.elf
 [topology-2]
 file = topology.elf
 extra_params = -cpu max,ctop=on -smp sockets=31,cores=8,maxcpus=248  -append '-sockets 31 -cores 8'
+
+[topology-3]
+file = topology.elf
+extra_params = """-cpu max,ctop=on -smp cpus=1,drawers=2,books=2,sockets=2,cores=16,maxcpus=128 \
+-append '-drawers 2 -books 2 -sockets 2 -cores 16' \
+-device max-s390x-cpu,core-id=31,drawer-id=0,book-id=0,socket-id=0,entitlement=medium,dedicated=false \
+-device max-s390x-cpu,core-id=11,drawer-id=0,book-id=0,socket-id=0,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=95,drawer-id=0,book-id=0,socket-id=0,entitlement=medium,dedicated=false \
+-device max-s390x-cpu,core-id=73,drawer-id=0,book-id=0,socket-id=0,entitlement=high,dedicated=false \
+-device max-s390x-cpu,core-id=78,drawer-id=0,book-id=0,socket-id=0,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=13,drawer-id=0,book-id=0,socket-id=0,entitlement=medium,dedicated=false \
+-device max-s390x-cpu,core-id=40,drawer-id=0,book-id=0,socket-id=0,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=101,drawer-id=0,book-id=0,socket-id=0,entitlement=medium,dedicated=false \
+-device max-s390x-cpu,core-id=29,drawer-id=0,book-id=0,socket-id=0,entitlement=medium,dedicated=false \
+-device max-s390x-cpu,core-id=56,drawer-id=0,book-id=0,socket-id=0,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=92,drawer-id=0,book-id=0,socket-id=0,entitlement=medium,dedicated=false \
+-device max-s390x-cpu,core-id=30,drawer-id=0,book-id=0,socket-id=0,entitlement=low,dedicated=false \
+-device max-s390x-cpu,core-id=118,drawer-id=0,book-id=0,socket-id=0,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=71,drawer-id=0,book-id=0,socket-id=0,entitlement=medium,dedicated=false \
+-device max-s390x-cpu,core-id=93,drawer-id=0,book-id=0,socket-id=0,entitlement=high,dedicated=false \
+-device max-s390x-cpu,core-id=16,drawer-id=0,book-id=0,socket-id=1,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=5,drawer-id=0,book-id=0,socket-id=1,entitlement=medium,dedicated=false \
+-device max-s390x-cpu,core-id=42,drawer-id=0,book-id=0,socket-id=1,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=98,drawer-id=0,book-id=0,socket-id=1,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=44,drawer-id=0,book-id=0,socket-id=1,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=23,drawer-id=0,book-id=0,socket-id=1,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=65,drawer-id=0,book-id=0,socket-id=1,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=102,drawer-id=0,book-id=0,socket-id=1,entitlement=low,dedicated=false \
+-device max-s390x-cpu,core-id=57,drawer-id=0,book-id=0,socket-id=1,entitlement=medium,dedicated=false \
+-device max-s390x-cpu,core-id=125,drawer-id=0,book-id=0,socket-id=1,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=127,drawer-id=0,book-id=0,socket-id=1,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=82,drawer-id=0,book-id=0,socket-id=1,entitlement=high,dedicated=false \
+-device max-s390x-cpu,core-id=14,drawer-id=0,book-id=0,socket-id=1,entitlement=low,dedicated=false \
+-device max-s390x-cpu,core-id=91,drawer-id=0,book-id=0,socket-id=1,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=12,drawer-id=0,book-id=0,socket-id=1,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=8,drawer-id=0,book-id=0,socket-id=1,entitlement=high,dedicated=false \
+-device max-s390x-cpu,core-id=112,drawer-id=0,book-id=1,socket-id=0,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=109,drawer-id=0,book-id=1,socket-id=0,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=19,drawer-id=0,book-id=1,socket-id=0,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=96,drawer-id=0,book-id=1,socket-id=0,entitlement=low,dedicated=false \
+-device max-s390x-cpu,core-id=67,drawer-id=0,book-id=1,socket-id=0,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=80,drawer-id=0,book-id=1,socket-id=0,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=108,drawer-id=0,book-id=1,socket-id=0,entitlement=medium,dedicated=false \
+-device max-s390x-cpu,core-id=34,drawer-id=0,book-id=1,socket-id=0,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=18,drawer-id=0,book-id=1,socket-id=0,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=39,drawer-id=0,book-id=1,socket-id=0,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=53,drawer-id=0,book-id=1,socket-id=0,entitlement=low,dedicated=false \
+-device max-s390x-cpu,core-id=46,drawer-id=0,book-id=1,socket-id=0,entitlement=low,dedicated=false \
+-device max-s390x-cpu,core-id=3,drawer-id=0,book-id=1,socket-id=0,entitlement=low,dedicated=false \
+-device max-s390x-cpu,core-id=76,drawer-id=0,book-id=1,socket-id=0,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=15,drawer-id=0,book-id=1,socket-id=0,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=7,drawer-id=0,book-id=1,socket-id=0,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=81,drawer-id=0,book-id=1,socket-id=1,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=1,drawer-id=0,book-id=1,socket-id=1,entitlement=low,dedicated=false \
+-device max-s390x-cpu,core-id=113,drawer-id=0,book-id=1,socket-id=1,entitlement=low,dedicated=false \
+-device max-s390x-cpu,core-id=38,drawer-id=0,book-id=1,socket-id=1,entitlement=low,dedicated=false \
+-device max-s390x-cpu,core-id=90,drawer-id=0,book-id=1,socket-id=1,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=117,drawer-id=0,book-id=1,socket-id=1,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=62,drawer-id=0,book-id=1,socket-id=1,entitlement=medium,dedicated=false \
+-device max-s390x-cpu,core-id=85,drawer-id=0,book-id=1,socket-id=1,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=49,drawer-id=0,book-id=1,socket-id=1,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=24,drawer-id=0,book-id=1,socket-id=1,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=107,drawer-id=0,book-id=1,socket-id=1,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=103,drawer-id=0,book-id=1,socket-id=1,entitlement=medium,dedicated=false \
+-device max-s390x-cpu,core-id=33,drawer-id=0,book-id=1,socket-id=1,entitlement=low,dedicated=false \
+-device max-s390x-cpu,core-id=51,drawer-id=0,book-id=1,socket-id=1,entitlement=medium,dedicated=false \
+-device max-s390x-cpu,core-id=21,drawer-id=0,book-id=1,socket-id=1,entitlement=high,dedicated=false \
+-device max-s390x-cpu,core-id=72,drawer-id=0,book-id=1,socket-id=1,entitlement=low,dedicated=false \
+-device max-s390x-cpu,core-id=63,drawer-id=1,book-id=0,socket-id=0,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=105,drawer-id=1,book-id=0,socket-id=0,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=74,drawer-id=1,book-id=0,socket-id=0,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=50,drawer-id=1,book-id=0,socket-id=0,entitlement=low,dedicated=false \
+-device max-s390x-cpu,core-id=60,drawer-id=1,book-id=0,socket-id=0,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=22,drawer-id=1,book-id=0,socket-id=0,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=43,drawer-id=1,book-id=0,socket-id=0,entitlement=low,dedicated=false \
+-device max-s390x-cpu,core-id=48,drawer-id=1,book-id=0,socket-id=0,entitlement=low,dedicated=false \
+-device max-s390x-cpu,core-id=35,drawer-id=1,book-id=0,socket-id=0,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=58,drawer-id=1,book-id=0,socket-id=0,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=106,drawer-id=1,book-id=0,socket-id=0,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=123,drawer-id=1,book-id=0,socket-id=0,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=122,drawer-id=1,book-id=0,socket-id=0,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=9,drawer-id=1,book-id=0,socket-id=0,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=10,drawer-id=1,book-id=0,socket-id=0,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=25,drawer-id=1,book-id=0,socket-id=0,entitlement=low,dedicated=false \
+-device max-s390x-cpu,core-id=116,drawer-id=1,book-id=0,socket-id=1,entitlement=high,dedicated=false \
+-device max-s390x-cpu,core-id=26,drawer-id=1,book-id=0,socket-id=1,entitlement=high,dedicated=false \
+-device max-s390x-cpu,core-id=17,drawer-id=1,book-id=0,socket-id=1,entitlement=low,dedicated=false \
+-device max-s390x-cpu,core-id=20,drawer-id=1,book-id=0,socket-id=1,entitlement=high,dedicated=false \
+-device max-s390x-cpu,core-id=59,drawer-id=1,book-id=0,socket-id=1,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=54,drawer-id=1,book-id=0,socket-id=1,entitlement=high,dedicated=false \
+-device max-s390x-cpu,core-id=70,drawer-id=1,book-id=0,socket-id=1,entitlement=medium,dedicated=false \
+-device max-s390x-cpu,core-id=88,drawer-id=1,book-id=0,socket-id=1,entitlement=high,dedicated=false \
+-device max-s390x-cpu,core-id=6,drawer-id=1,book-id=0,socket-id=1,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=52,drawer-id=1,book-id=0,socket-id=1,entitlement=low,dedicated=false \
+-device max-s390x-cpu,core-id=55,drawer-id=1,book-id=0,socket-id=1,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=124,drawer-id=1,book-id=0,socket-id=1,entitlement=medium,dedicated=false \
+-device max-s390x-cpu,core-id=61,drawer-id=1,book-id=0,socket-id=1,entitlement=low,dedicated=false \
+-device max-s390x-cpu,core-id=84,drawer-id=1,book-id=0,socket-id=1,entitlement=high,dedicated=false \
+-device max-s390x-cpu,core-id=68,drawer-id=1,book-id=0,socket-id=1,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=86,drawer-id=1,book-id=0,socket-id=1,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=4,drawer-id=1,book-id=1,socket-id=0,entitlement=high,dedicated=false \
+-device max-s390x-cpu,core-id=75,drawer-id=1,book-id=1,socket-id=0,entitlement=low,dedicated=false \
+-device max-s390x-cpu,core-id=115,drawer-id=1,book-id=1,socket-id=0,entitlement=low,dedicated=false \
+-device max-s390x-cpu,core-id=28,drawer-id=1,book-id=1,socket-id=0,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=120,drawer-id=1,book-id=1,socket-id=0,entitlement=low,dedicated=false \
+-device max-s390x-cpu,core-id=41,drawer-id=1,book-id=1,socket-id=0,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=87,drawer-id=1,book-id=1,socket-id=0,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=119,drawer-id=1,book-id=1,socket-id=0,entitlement=low,dedicated=false \
+-device max-s390x-cpu,core-id=114,drawer-id=1,book-id=1,socket-id=0,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=104,drawer-id=1,book-id=1,socket-id=0,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=27,drawer-id=1,book-id=1,socket-id=0,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=121,drawer-id=1,book-id=1,socket-id=0,entitlement=high,dedicated=false \
+-device max-s390x-cpu,core-id=126,drawer-id=1,book-id=1,socket-id=0,entitlement=low,dedicated=false \
+-device max-s390x-cpu,core-id=37,drawer-id=1,book-id=1,socket-id=0,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=32,drawer-id=1,book-id=1,socket-id=0,entitlement=high,dedicated=false \
+-device max-s390x-cpu,core-id=94,drawer-id=1,book-id=1,socket-id=0,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=110,drawer-id=1,book-id=1,socket-id=1,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=77,drawer-id=1,book-id=1,socket-id=1,entitlement=medium,dedicated=false \
+-device max-s390x-cpu,core-id=36,drawer-id=1,book-id=1,socket-id=1,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=66,drawer-id=1,book-id=1,socket-id=1,entitlement=medium,dedicated=false \
+-device max-s390x-cpu,core-id=83,drawer-id=1,book-id=1,socket-id=1,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=47,drawer-id=1,book-id=1,socket-id=1,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=99,drawer-id=1,book-id=1,socket-id=1,entitlement=low,dedicated=false \
+-device max-s390x-cpu,core-id=79,drawer-id=1,book-id=1,socket-id=1,entitlement=low,dedicated=false \
+-device max-s390x-cpu,core-id=100,drawer-id=1,book-id=1,socket-id=1,entitlement=medium,dedicated=false \
+-device max-s390x-cpu,core-id=89,drawer-id=1,book-id=1,socket-id=1,entitlement=high,dedicated=false \
+-device max-s390x-cpu,core-id=2,drawer-id=1,book-id=1,socket-id=1,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=45,drawer-id=1,book-id=1,socket-id=1,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=69,drawer-id=1,book-id=1,socket-id=1,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=64,drawer-id=1,book-id=1,socket-id=1,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=97,drawer-id=1,book-id=1,socket-id=1,entitlement=high,dedicated=true \
+-device max-s390x-cpu,core-id=111,drawer-id=1,book-id=1,socket-id=1,entitlement=medium,dedicated=false \
+"""
-- 
2.41.0


