Return-Path: <kvm+bounces-3909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6862380A217
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 12:24:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 142E01F214B3
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 11:24:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD9D01A73D;
	Fri,  8 Dec 2023 11:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DAiz5YT8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73CAB10CA;
	Fri,  8 Dec 2023 03:24:05 -0800 (PST)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B8BHvdN023292;
	Fri, 8 Dec 2023 11:24:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=JRLtADp3bCNbFs+ji25sdAY6QNr59LedRAYMmwGEKxc=;
 b=DAiz5YT8oSOhfyJOSy5quUapwLFWhJIl8JIYgGSSBuCB2b39DM2vKFzVlZ6PyOnehenY
 mkSikqnmexO5S6X2Aj8CYbJ/b88GyRqLrO5ZwSw5pvXL8PHNbdOmkag6vYPwmXojmT3j
 OaZ4Uuz+vbzjb12eT83bag+Y9coVbvJ603ZvOGfpXdkEF984eiiitKb73qpgxuhPndGD
 qVodV2pcO5MG9NT3olc0EQtsBeSkZt/SfWRPn5BQC2dpqVxQEIJXDViwmstZjfZpG6VW
 EURYyvOS7Nvr1hnCkUIQGu8JO2qRuOMI+SSlHbEtTe730h/hRIps+jtyiLhRrmoDIRDq 4Q== 
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uv254g4hy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Dec 2023 11:24:04 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B89bAsN004681;
	Fri, 8 Dec 2023 11:24:03 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3utav4s9dv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Dec 2023 11:24:03 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B8BO2wl50790804
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 8 Dec 2023 11:24:02 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2176B58057;
	Fri,  8 Dec 2023 11:24:02 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4501658059;
	Fri,  8 Dec 2023 11:24:01 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.97.239])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  8 Dec 2023 11:24:01 +0000 (GMT)
Message-ID: <0fe89d1a4ef539bef4bdf2302faf23f6d5848bf2.camel@linux.ibm.com>
Subject: Re: [PATCH] KVM: s390: fix cc for successful PQAP
From: Eric Farman <farman@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, Jason Herne <jjherne@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Date: Fri, 08 Dec 2023 06:24:00 -0500
In-Reply-To: <fe3082f7-70fd-479f-b6a2-d753d271d6d5@linux.ibm.com>
References: <20231201181657.1614645-1-farman@linux.ibm.com>
	 <fe3082f7-70fd-479f-b6a2-d753d271d6d5@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9rsho7wf6X6PBVh4jmEc8GxpS8TfXr9U
X-Proofpoint-ORIG-GUID: 9rsho7wf6X6PBVh4jmEc8GxpS8TfXr9U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-08_06,2023-12-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0
 mlxlogscore=762 malwarescore=0 priorityscore=1501 clxscore=1015
 impostorscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2311290000 definitions=main-2312080095

On Fri, 2023-12-08 at 11:31 +0100, Janosch Frank wrote:
> On 12/1/23 19:16, Eric Farman wrote:
> > The various errors that are possible when processing a PQAP
> > instruction (the absence of a driver hook, an error FROM that
> > hook), all correctly set the PSW condition code to 3. But if
> > that processing works successfully, CC0 needs to be set to
> > convey that everything was fine.
> >=20
> > Fix the check so that the guest can examine the condition code
> > to determine whether GPR1 has meaningful data.
> >=20
>=20
> Hey Eric, I have yet to see this produce a fail in my AP KVM unit
> tests.
> If you find some spare time I'd like to discuss how I can extend my
> test=20
> so that I can see the fail before it's fixed.
>=20

Hi Janosch, absolutely. I had poked around kvm-unit-tests before I sent
this up to see if I could adapt something to show this scenario, but
came up empty and didn't want to go too far down that rabbit hole
creating something from scratch. I'll ping you offline to find a time
to talk.

Eric

