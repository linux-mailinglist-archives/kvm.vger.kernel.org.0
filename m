Return-Path: <kvm+bounces-79-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 663BB7DBD66
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 17:04:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88EC81C20AD1
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 16:04:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9826E19455;
	Mon, 30 Oct 2023 16:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="M+XqU4sm"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C95418C2D
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 16:04:07 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A1EDA;
	Mon, 30 Oct 2023 09:04:03 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39UFexDI027638;
	Mon, 30 Oct 2023 16:03:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=vfy2BbXPZ3GBSfZP8lhNLksdq2mP+G/GRk1P80/4JL8=;
 b=M+XqU4smR72p+CwGJs/VcZ/L5ZmcvwhumownrIfJVQGZNYHtx+xJS2nl89G6666O+WjQ
 yF0XTn1xlY4oap9FdiChkKL7o9F7wozQNuNh2siDbXajSVs8BokZWDpFHSvfP3fONWkp
 8R49BZUCs24RVaP+3vF+xz3C7LplwoETp7JCOk0Ytc4/+Gl+sWoVYVBdJhrbnfJUN7v2
 wAXjG0lgNRHbZtd6JKpY2d4q4bS14PioZXgveNP5NBAKmLaRf9AtdDjY0lZ9FIQ3yneY
 f6L0h+dV/JVVQo19jNUZ4uEV6ChxsQx9coq7QEMJRrw4qbOYxsCPUJ7qH8qjkL5Dsuri bw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u2ex09cfp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 16:03:58 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39UFfZ3o031329;
	Mon, 30 Oct 2023 16:03:58 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u2ex09ce5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 16:03:58 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39UDeXaD000595;
	Mon, 30 Oct 2023 16:03:57 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u1cmstea3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 16:03:57 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39UG3sW511535098
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 30 Oct 2023 16:03:54 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4738420040;
	Mon, 30 Oct 2023 16:03:54 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1223A2004D;
	Mon, 30 Oct 2023 16:03:54 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 30 Oct 2023 16:03:54 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Ricardo Koller <ricarkol@google.com>,
        David Hildenbrand <david@redhat.com>, Thomas Huth <thuth@redhat.com>,
        Colton Lewis <coltonlewis@google.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Sean Christopherson <seanjc@google.com>
Subject: [kvm-unit-tests PATCH v3 10/10] s390x: topology: Add complex topology test
Date: Mon, 30 Oct 2023 17:03:49 +0100
Message-Id: <20231030160349.458764-11-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231030160349.458764-1-nsg@linux.ibm.com>
References: <20231030160349.458764-1-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fW92uTbRtG68qcA7TA9A2W_1YgrX0AwX
X-Proofpoint-ORIG-GUID: riQeGQ-t6jk8CFqDuO4hroR5-3Wi5LWE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-30_10,2023-10-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501
 clxscore=1015 phishscore=0 spamscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2310240000 definitions=main-2310300124

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
---
 s390x/unittests.cfg | 133 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 133 insertions(+)

diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 68e119e4..b08b0fb1 100644
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


