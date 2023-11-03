Return-Path: <kvm+bounces-486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DEDE97E03CA
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 14:33:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 17EFB1C2107D
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 13:33:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27C5218643;
	Fri,  3 Nov 2023 13:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mjp/Z2Ou"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69175182D8
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 13:33:40 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D770E19D;
	Fri,  3 Nov 2023 06:33:38 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A3ClQsK002546;
	Fri, 3 Nov 2023 13:33:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=11N3AKxv/uI/ych5uaC5SjixpZfUaaCVhhmjfqY9x90=;
 b=mjp/Z2OuAY7Ib4XP07nX9ZH3Ng9tyDeaEgoAOA55c4LX9lNEofolxX5sYfovrt2tKihw
 iRp3lKLW+CbTceYaYRUQIkKl8f8dcfWq+73h5JtI2PpBNGyissrNacuilqa2bQYNfe90
 RPsJFqat8b/cBuXFOa3udMmooM/V8D+LtxAmQWsWXQ27G2jkxGnqpydxrL9M8joDdSey
 0yDDTsycAyYIhgtHMEwlPogGKjDvDJ203q3pgC3poSfICH5hs+yWJ2Uc8auqWVDymqLA
 myhIlo0/atzQ183iJepQkWaJlSCEUngNeFUIDRtzvkbDvaQcnbFGLgAr1mNDa5AQu0AA rQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u5160t1nx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 13:33:38 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A3CnVvA010887;
	Fri, 3 Nov 2023 13:33:37 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u5160t1n2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 13:33:37 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A3AoPVW031364;
	Fri, 3 Nov 2023 13:33:36 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u1fb2np5j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 13:33:36 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A3DXXaK24380140
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 3 Nov 2023 13:33:34 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D71EB20043;
	Fri,  3 Nov 2023 13:33:33 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B2D5120040;
	Fri,  3 Nov 2023 13:33:33 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  3 Nov 2023 13:33:33 +0000 (GMT)
Date: Fri, 3 Nov 2023 13:14:46 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nico Boehr <nrb@linux.ibm.com>
Cc: frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1 0/2] s390x: Align SIE tests to 2GB
Message-ID: <20231103131446.5cd34558@p-imbrenda>
In-Reply-To: <20231103064132.11358-1-nrb@linux.ibm.com>
References: <20231103064132.11358-1-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3a6ZCjlfyOVWm9xFWPofHtqAh-2VwtxL
X-Proofpoint-GUID: VvmP-pwdgcUhdoRhGxZ5Z-YuMnn8_fd4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-03_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 spamscore=0 clxscore=1015 impostorscore=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311030114

On Fri,  3 Nov 2023 07:35:45 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

> Some environments on s390x require guests to be aligned to 2GB. This is a
> problem when kvm-unit-tests act as a hypervisor, since guests run with MSO/MSL
> there and guest memory doesn't satisfy this requirement.
> 
> This series ensures kvm-unit-tests fulfills the 2G alignment requirement.
> 
> Note that this currently breaks the mvpg-sie test case under KVM due to prefix
> issues, a fix is due for upstream submission.

I disagree with the wording.

The mvpg-sie test does not break, it will fail because there is an
actual KVM bug, so the test works as intended :)

> 
> Nico Boehr (2):
>   s390x: spec_ex-sie: refactor to use snippet API
>   s390x: sie: ensure guests are aligned to 2GB
> 
>  lib/s390x/sie.c     | 42 ++++++++++++++++++++++++++++++++++++++++++
>  lib/s390x/sie.h     |  2 ++
>  lib/s390x/snippet.h |  9 +++------
>  s390x/sie.c         |  4 ++--
>  s390x/spec_ex-sie.c | 13 ++++++-------
>  5 files changed, 55 insertions(+), 15 deletions(-)
> 


