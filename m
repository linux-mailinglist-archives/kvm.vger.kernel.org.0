Return-Path: <kvm+bounces-844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 35AE47E3720
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 10:05:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C72781F215CE
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 09:05:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7C4112B91;
	Tue,  7 Nov 2023 09:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rj4GBbeX"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82DA11704
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 09:05:21 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9B7FA
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 01:05:19 -0800 (PST)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A78cGlQ003829
	for <kvm@vger.kernel.org>; Tue, 7 Nov 2023 09:05:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : to : subject : message-id : date; s=pp1;
 bh=rHYh3syRv9Y0dEJ8+n9hM2cKuq4ADZb/64HLSmCV4u0=;
 b=rj4GBbeXP2Rvtoz70WgqyJZsJBvbFO4qDSE6KqcKiviGUkLs71ZujyNv63AgQ5lX9Lb7
 7tGrGpRxnwMOf6jQSNCljofQ3pNvhmvYX+7maCadaeseb8R1jlWm0M9zkeH+/Zdvq6AU
 dI67yPfpVnNK8G5R4KsOdm3S6ZYWcxWlXEgwkSC2xLXzhhfUJQ1KKL8zR2tqjxO7XABJ
 CAIQ0enfkK6gCqCYRWtYboa68KtKvRLM+9unfAmPYStyvGV39u8ywkJYH6VkyEY0iuTc
 BaXEhFF0Ybo2zUFtPwXCGGvZ93FRLuhC/wxsL/CWu3b//7fWzD1h8Q/m4VFM9pDyzZbO 4g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u7hmk94es-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 09:05:17 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A78cNsm004639
	for <kvm@vger.kernel.org>; Tue, 7 Nov 2023 09:05:13 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u7hmk94c8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Nov 2023 09:05:13 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A78QrXw028251;
	Tue, 7 Nov 2023 09:05:10 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u62gjy580-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Nov 2023 09:05:10 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A7957AT12517894
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 Nov 2023 09:05:07 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B1DD220040;
	Tue,  7 Nov 2023 09:05:06 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 42A152004B;
	Tue,  7 Nov 2023 09:05:06 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.68.65])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  7 Nov 2023 09:05:06 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20231031095519.73311-1-frankja@linux.ibm.com>
References: <20231031095519.73311-1-frankja@linux.ibm.com>
Cc: imbrenda@linux.ibm.com, thuth@redhat.com, david@redhat.com
From: Nico Boehr <nrb@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 0/3] s390x: Improve console handling
Message-ID: <169934790505.10115.11927388061265417211@t14-nrb>
User-Agent: alot/0.8.1
Date: Tue, 07 Nov 2023 10:05:05 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PQIuccl9g66t5fBJab3ygV6sdrUPXfGw
X-Proofpoint-ORIG-GUID: ba-pjaNZIKGupHLU8Nk4iDWbQaiUvD72
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_15,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=656
 lowpriorityscore=0 phishscore=0 bulkscore=0 clxscore=1015 adultscore=0
 malwarescore=0 mlxscore=0 priorityscore=1501 spamscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311070074

Quoting Janosch Frank (2023-10-31 10:55:16)
> Console IO is and has been in a state of "works for me". I don't think
> that will change soon since there's no need for a proper console
> driver when all we want is the ability to print or read a line at a
> time.
>=20
> However since input is only supported on the ASCII console I was
> forced to use it on the HMC. The HMC generally does not add a \r on a
> \n so each line doesn't start at column 0. It's time to finally fix
> that.
>=20
> Also, since there are environments that only provide the line-mode
> console it's time to add line-mode input to properly support them.

Thanks, queued.

