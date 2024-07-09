Return-Path: <kvm+bounces-21161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A22F92B278
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 10:45:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1064D1F21CA0
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 08:45:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DCB9153BC3;
	Tue,  9 Jul 2024 08:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GBGYso/q"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A482C14F13A;
	Tue,  9 Jul 2024 08:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720514713; cv=none; b=jHWieiMmV8oTmUSxn6MXgXnelpMMpP0SV7v5wfsesro5XOKYhIyoZYM8XmffqTyaoouNA/mjGPaQ/A9KDTIFTJAkK8RIymqiVom67JFZhqmNBpDKAKWgrOc6eaWGMDmDJpzJPdNp8BGLnSuPM8IDCe6ltvUu4iG+n9H8104ge+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720514713; c=relaxed/simple;
	bh=KyH5U1pumNojFcQuwTq/G7SisPQVkZOVM9mntQbyaQ8=;
	h=Content-Type:MIME-Version:In-Reply-To:References:Cc:From:To:
	 Subject:Message-ID:Date; b=YbbbCINUZ1YjMqSfqeEkvMcCANzEvimH+zn3I4V/ibGGRX4AKG97IEd4FpqyiSsX2OTJjk1Ny0mZTiANvqqA3jk9PS82efBQ/ni8B62b/s5FvF+vep11S6Yv+VpuluFtjEBx3cVME4rsIWPEmPuU1q54F0h/rA+T8sBqSsOtFPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GBGYso/q; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4695TG1R023707;
	Tue, 9 Jul 2024 08:45:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-type:mime-version:content-transfer-encoding:in-reply-to
	:references:cc:from:to:subject:message-id:date; s=pp1; bh=KyH5U1
	pumNojFcQuwTq/G7SisPQVkZOVM9mntQbyaQ8=; b=GBGYso/qu4N2A7ys2EcTfj
	CehZ7UdGkMFAjIuHUfLh7zD42ryCu7YasJW9/fMI0x5/1nH2KifBtV7mgLNudp3J
	jONBRcjJi488Q1uoO/egg0WQUmlACLhuMsdtfnEkVJ53KNBTaFqMPPCcNBAR4j+/
	Le06ThBTYMsEd7I8yK0J2VasVvfakJsxhS2PuiYDEDlS+Xrtnafdu1IIAG3uIraG
	h6nVX+TadmhhGTeuFUC3pF4iAYWqjZDZWShz65SxH+RIXnBEUhvax9OKLV5RMPQB
	eVztSD32xGNKU3DnAfprr+GJUWbLV0iFsP0I9+m+o+i1alzv8xV6Cz50VJ0rBilw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 408y380ejv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Jul 2024 08:45:09 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4698j97H026968;
	Tue, 9 Jul 2024 08:45:09 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 408y380ejr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Jul 2024 08:45:09 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4697kum9024680;
	Tue, 9 Jul 2024 08:45:08 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 407g8u3sap-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Jul 2024 08:45:08 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4698j24w53805474
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 9 Jul 2024 08:45:05 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D23AA20043;
	Tue,  9 Jul 2024 08:45:02 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B41322004D;
	Tue,  9 Jul 2024 08:45:02 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.72.32])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  9 Jul 2024 08:45:02 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20240703155900.103783-3-imbrenda@linux.ibm.com>
References: <20240703155900.103783-1-imbrenda@linux.ibm.com> <20240703155900.103783-3-imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, hca@linux.ibm.com,
        svens@linux.ibm.com, agordeev@linux.ibm.com, gor@linux.ibm.com,
        nsg@linux.ibm.com, seiden@linux.ibm.com, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, gerald.schaefer@linux.ibm.com,
        david@redhat.com
From: Nico Boehr <nrb@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] s390/kvm: Move bitfields for dat tables
Message-ID: <172051470220.243722.11724961453286234156@t14-nrb>
User-Agent: alot/0.8.1
Date: Tue, 09 Jul 2024 10:45:02 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FyT6R0dpv90eMsaW6KTbr7YQu1veB98A
X-Proofpoint-GUID: E65jeJ3xYUP11FkG8PiCNu9M_C8J6kwr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-08_15,2024-07-08_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 spamscore=0 mlxscore=0 bulkscore=0 priorityscore=1501 clxscore=1015
 suspectscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0
 mlxlogscore=655 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2407090055

Quoting Claudio Imbrenda (2024-07-03 17:59:00)
> Move and improve the struct definitions for DAT tables from gaccess.c
> to a new header.
>=20
> Once in a separate header, the structs become available everywhere. One
> possible usecase is to merge them in the s390 pte_t and p?d_t
> definitions, which is left as an exercise for the reader.
>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>

