Return-Path: <kvm+bounces-33585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F53A9EEC6A
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 16:34:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 153761884BAA
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 15:33:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15584217F34;
	Thu, 12 Dec 2024 15:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MjA1TeZp"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16CB6F2FE;
	Thu, 12 Dec 2024 15:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017595; cv=none; b=q5gt7qN1stCWAD5MW3sBi3KBmokuRbFS38+Ay2Yl374isLSn/bwRAD9hLa1r3nyIh7/8zpm7wdN7O+t4GRwFC/enmQbAjEdLp3SfcoFvlQtWZ4bc1J2WlU8stIhn4D7hNmk5DBNVTYWOtVCwlWNQdJl8NdBVciXdh9mOP4RrYEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017595; c=relaxed/simple;
	bh=tT+Wh1Hrn/98HHLh2dY6UB4EGQadqMgb2u7840ZYUu4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ONp8C+0z1h7iZvynEeBaNhGdhp6YHJZiMh+5V4ubiEbMCc4dC7zzvkK93nIQrRvj1u4eU6pZ3C0YRKNBzmg1VDjSARf6LRliVwlX2Jp2OlNUlizypAYs/3GD+d4skihmJ/WGAEuHoO4+0h3m0j+fqyolFNZ/vVwbfJAuUuUQEhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MjA1TeZp; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BCF35DT012146;
	Thu, 12 Dec 2024 15:33:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=tT+Wh1
	Hrn/98HHLh2dY6UB4EGQadqMgb2u7840ZYUu4=; b=MjA1TeZpHerpU2wTLxSFZd
	YpZQDcwaxPTdHVam6vpyF5FSfiHPMrYprJbKo7GUyXTEW7ez0tJg6pstgNeF/hom
	c4GC8x0cfL3S8arCMRBm2s8+nTF0hDRzjz9qW0C/zl3oN+O5+/WtVfPZGF+WEWLT
	mepjWdCnJnLwaFrIih2GwCH8HclxbcK/IIJlSHJT2B9flmB9pPdF6hhkUPoDBT3f
	XXoRMkRCpsHf7M/DJs5IykPcOoS5w8UgsdNQfEc2iYNn7WXzefeTIemi+NPZXEbr
	j6f/v2XYQ+e4vw073e9a9nFyQ/g08HuGf6MKRmx5vZnEljb8/11bn1NFgH8Gyn0g
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43ce3959x7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Dec 2024 15:33:10 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4BCFWJWt020663;
	Thu, 12 Dec 2024 15:33:10 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43ce3959x4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Dec 2024 15:33:10 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4BCEbSOl023018;
	Thu, 12 Dec 2024 15:33:09 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 43d2wk8xuw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Dec 2024 15:33:09 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4BCFX6gN37355824
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Dec 2024 15:33:06 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1E6652004B;
	Thu, 12 Dec 2024 15:33:06 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 85BFE20040;
	Thu, 12 Dec 2024 15:33:05 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.171.84.250])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 12 Dec 2024 15:33:05 +0000 (GMT)
Message-ID: <fcc8d46283daa6922c90328a1a8a36b528530166.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v4 4/6] s390x: Add library functions for
 exiting from snippet
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Nico Boehr <nrb@linux.ibm.com>, Claudio Imbrenda
 <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, Janosch Frank
 <frankja@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        Nicholas
 Piggin <npiggin@gmail.com>, linux-s390@vger.kernel.org
Date: Thu, 12 Dec 2024 16:33:05 +0100
In-Reply-To: <D67Y11RRNUJ4.3U17EAZFWQR6M@linux.ibm.com>
References: <20241016180320.686132-1-nsg@linux.ibm.com>
	 <20241016180320.686132-5-nsg@linux.ibm.com>
	 <D67Y11RRNUJ4.3U17EAZFWQR6M@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-2.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: whiVVwsuQXoSH2Ywb0xtUg5wTjTY1wCG
X-Proofpoint-ORIG-GUID: VLkzXgkd14hWWURx9GX7P7NmgSwH8rJO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 spamscore=0 clxscore=1011 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0 mlxlogscore=908
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412120112

On Tue, 2024-12-10 at 11:20 +0100, Nico Boehr wrote:
> On Wed Oct 16, 2024 at 8:03 PM CEST, Nina Schoetterl-Glausch wrote:
> > It is useful to be able to force an exit to the host from the snippet,
> > as well as do so while returning a value.
> > Add this functionality, also add helper functions for the host to check
> > for an exit and get or check the value.
> > Use diag 0x44 and 0x9c for this.
> > Add a guest specific snippet header file and rename snippet.h to reflec=
t
> > that it is host specific.
> >=20
> > Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
>=20
> Hi Nina,
>=20
> would you mind if I fix this up like this?

Looks good to me.
Thanks!


