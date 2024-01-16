Return-Path: <kvm+bounces-6336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 74D7382EF50
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 14:03:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A9AC285CCC
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 13:02:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 506FE1BC47;
	Tue, 16 Jan 2024 13:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZGueLNcz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CEF1BC30;
	Tue, 16 Jan 2024 13:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40GCMc4E019240;
	Tue, 16 Jan 2024 13:02:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=EfWGAM8cHh2fyhjlFktI+Y9aDiXLWY6nklK/vYn+FVk=;
 b=ZGueLNczu+0aRTbQxrJLPEZyuzhRwjlXNznMUfL8NgTMbBojssoqH5cKIBSic12jRjp8
 pRT53n6+lfNBkC0BXxEYpKgJgHK7+ICi0wnfWY3/CZGHbV8J7grBfTRDEZhdGcLqo5a1
 KbE2GJ1yClCnhjOT4hTcpMTKeX+HCAQmJ2NnibAhKZloMOABqLaOTEV6F/CW5Z9VciuD
 Cw+4NZ9Q05o3ct14vVFkeK+TK72e8D4WAN+o8jZvVdr21QVHhxbT8dMlZnzfaOo2hPr1
 alWYz1Wg85nFSIBBLf4e/61MUddHSmX05KP6Gs0eVYcobZYLP0zzHCT7hxoLbQIZFeWx oA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vnsras5pu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 13:02:39 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40GCtdHu004061;
	Tue, 16 Jan 2024 13:02:39 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vnsras5pf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 13:02:39 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40GAFbGp014845;
	Tue, 16 Jan 2024 13:02:38 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vm4uspvwh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 13:02:38 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40GD2Zc732244038
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jan 2024 13:02:35 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 64A1720040;
	Tue, 16 Jan 2024 13:02:35 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E4F1820049;
	Tue, 16 Jan 2024 13:02:34 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.171.59.12])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 16 Jan 2024 13:02:34 +0000 (GMT)
Message-ID: <186d63da6c58181cc355ea41f70b4cbe75fed338.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 0/5] s390x: Dirty cc before executing
 tested instructions
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nrb@linux.ibm.com
Date: Tue, 16 Jan 2024 14:02:34 +0100
In-Reply-To: <20240108132921.255769-1-frankja@linux.ibm.com>
References: <20240108132921.255769-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GTSbMtx1bQhonKwbPJhREIwlaseGoUyl
X-Proofpoint-GUID: rJzm6JxJnHNnfAu5c-QEY5lReHro10mO
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-16_06,2024-01-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 adultscore=0 clxscore=1015 mlxlogscore=455 malwarescore=0
 priorityscore=1501 phishscore=0 suspectscore=0 lowpriorityscore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401160102

On Mon, 2024-01-08 at 13:29 +0000, Janosch Frank wrote:
> A recent s390 KVM fixpatch [1] showed us that checking the cc is not
> enough when emulation code forgets to set the cc. There might just be
> the correct cc in the PSW which would make the cc check succeed.
>=20
> This series intentionally dirties the cc for sigp, uvc, some io
> instructions and sclp to make cc setting errors more apparent. I had a
> cursory look through the tested instructions and those are the most
> prominent ones with defined cc values.
>=20
> Since the issue appeared in PQAP my AP test series is now dependent on
> this series.
>=20
> [1] https://lore.kernel.org/kvm/20231201181657.1614645-1-farman@linux.ibm=
.com/

Using SET PROGRAM MASK the way you're doing in this series will also set the
program mask to 0, right?

In case you have some non zero register %[reg] and you want to set CC to 1 =
you
could do:

or	%[reg],%[reg] /* set CC to 1 */

In general, if I understand TEST UNDER MASK right, you could do:

tmll	%[set_cc],3

to set the CC to the value in %[set_cc] (without any shifting).=20

