Return-Path: <kvm+bounces-478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ECAE87E000D
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 10:37:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 611251F22266
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 09:37:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9359A11C82;
	Fri,  3 Nov 2023 09:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GUjYh48b"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E50DCA51
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 09:37:39 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462C5D4B
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 02:37:36 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A38lLaf008792
	for <kvm@vger.kernel.org>; Fri, 3 Nov 2023 09:37:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : from : to : cc : message-id : date; s=pp1;
 bh=ctrXTcIu6sFVOYSlvzinfXfG7E1afNYiqLbgNDUAhNw=;
 b=GUjYh48bc6xS/vGguL5uobXGzTahDqa3eFJHfDF8lj+SsVjkmmK0t4jHWOrTI//ygGkS
 X4jaI0lIOctiB84M/MWvxbGjJC5bZyHp9YNLg6r7WqjUJMz7Dt9M+Hw6xp+KSHy95F05
 LGHIra291D37NQdhfXPrZoNu1Lpq12LxOIqOY/DMzHjH36z0bU0we1uzFmtVyTQhUKl9
 WcAqDd8j8x3936MrCFT3j1qaWt5QObSqMvRUggEvB6geaprHsq4i2D2PETpdaZVCWXOP
 8HJZf6h8Ux0B9sYPOOqXFCLYdnj1ZKds+YxPfWkKnpxUtl9ih/RkTlKvbkKol4n+d7tK Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u4wnmhggv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 09:37:35 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A38mL28013002
	for <kvm@vger.kernel.org>; Fri, 3 Nov 2023 09:37:35 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u4wnmhgg9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 09:37:35 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A39PA6G011544;
	Fri, 3 Nov 2023 09:37:33 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u1e4mcu6n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 09:37:33 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A39bUBJ24379964
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 3 Nov 2023 09:37:30 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A030420049;
	Fri,  3 Nov 2023 09:37:30 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 382D820040;
	Fri,  3 Nov 2023 09:37:30 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.63.94])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  3 Nov 2023 09:37:30 +0000 (GMT)
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
Subject: Re: [kvm-unit-tests PATCH v2 0/3] s390x: Improve console handling
From: Nico Boehr <nrb@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc: imbrenda@linux.ibm.com, thuth@redhat.com, david@redhat.com
Message-ID: <169900424909.24043.13145914467338666237@t14-nrb>
User-Agent: alot/0.8.1
Date: Fri, 03 Nov 2023 10:37:29 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: UwU7NDWRN20VdS36KnamjWoYlQmQW4rJ
X-Proofpoint-GUID: R279VYjwHkju9qnVPtsQ1ebFF97whS-o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-03_09,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=656
 priorityscore=1501 spamscore=0 suspectscore=0 lowpriorityscore=0
 phishscore=0 mlxscore=0 malwarescore=0 impostorscore=0 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311030079

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

Pushed to our internal CI for coverage, thanks.

