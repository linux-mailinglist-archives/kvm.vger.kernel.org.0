Return-Path: <kvm+bounces-34673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3370A03F53
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 13:35:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C7FF3A02F8
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 12:35:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D8D51E47C8;
	Tue,  7 Jan 2025 12:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="X68KFNeR"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6D928E37;
	Tue,  7 Jan 2025 12:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736253338; cv=none; b=M0gpgkpQeFWT5njZdkUAkU0W/CeIAeD0OQhr9Xc29OAmYBEEiWEZX2W284qZEk07tp0dXW7gr7amJOT2aIytLjy5JDqfGNa1znb2ySt7CoE90qFqTLua7PC+AxxYElxDHe+nbWov8Q4rN0uCYkgGUNSelefd+Sv1yhtMPEtSX9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736253338; c=relaxed/simple;
	bh=0O311cBlJrQ2gPJ2KwNJEGoVZEQemESwgik+5DVRZ6M=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=TTpTfE9pVyRBFW+k2eVRzxa9YXvkYbWdYaz6KiLrmKvjY3MARJ0cNEIPZxQKYB2oz3VdcTzfIm7QokJWAT/CLKfz5yNoQFt6dQay17buPhgwKNMXz+Pw2MLZNZDNA7H04H/omCnlNDHWCP/DSpVOgoEjHGtgrERae7uxLIPBsfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=X68KFNeR; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5073t59o021223;
	Tue, 7 Jan 2025 12:35:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=QIcVh6
	cB7rM/VTSdrWxFMHfyScByyJD3LhZyhlO4RVM=; b=X68KFNeRUdj3xqWnJyajUx
	lCROUQmMUN8WufnUEGSnoRjdF0nkElYtPtpei01ePZU6juwlXEnix6/qagAuCq6K
	tXwp/k9hdXA0Zg2YYZUipGfufuF5D1hqNDUSJ95ShA4J2rim9EFeyIOaAlCrxwlU
	GWX0ttLRw9OKf+sxuy4+i0Y3iAQWS0j43RignS82YU5+m/DNZ/k0iBfE75KqPc3R
	OheNAAVmZEH5TYrg/zsPYgM/0rsDu/RtLP4FCWS2P1S2Mlgc2Lh1phBPqOdluQF/
	Y1Y/RFy26tSJf2Cf/n1vcoDmGD3R7lmLigmlnXxUVgKpI/bynCty6qEvg0X1a5ww
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 440s0aaqum-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Jan 2025 12:35:27 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 507COwxO008851;
	Tue, 7 Jan 2025 12:35:26 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43yfpythsb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Jan 2025 12:35:26 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 507CZK9H55640424
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 Jan 2025 12:35:20 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 67F7A20049;
	Tue,  7 Jan 2025 12:35:20 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 46A3A20040;
	Tue,  7 Jan 2025 12:35:20 +0000 (GMT)
Received: from darkmoore (unknown [9.171.31.59])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  7 Jan 2025 12:35:20 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 07 Jan 2025 13:35:15 +0100
Message-Id: <D6VUFLL8PPTQ.1VZ6VWPZWRVTD@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
        "Linux Kernel Mailing List"
 <linux-kernel@vger.kernel.org>,
        "Linux Next Mailing List"
 <linux-next@vger.kernel.org>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>,
        "Christian Borntraeger"
 <borntraeger@de.ibm.com>,
        "Janosch Frank" <frankja@linux.ibm.com>, "KVM"
 <kvm@vger.kernel.org>,
        "S390" <linux-s390@vger.kernel.org>
Subject: Re: linux-next: Fixes tag needs some work in the kvms390-fixes tree
X-Mailer: aerc 0.18.2
References: <20250106064232.3c34fdb1@canb.auug.org.au>
In-Reply-To: <20250106064232.3c34fdb1@canb.auug.org.au>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Cf8xlSbxDmbr82tg_VUuzZ8-ujP5302K
X-Proofpoint-ORIG-GUID: Cf8xlSbxDmbr82tg_VUuzZ8-ujP5302K
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1011
 phishscore=0 mlxlogscore=654 lowpriorityscore=0 impostorscore=0
 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501070105

On Sun Jan 5, 2025 at 8:42 PM CET, Stephen Rothwell wrote:
> Hi all,
>
> In commit
>
>   6c2b70cc4887 ("selftests: kvm: s390: Streamline uc_skey test to issue i=
ske after sske")
>
> Fixes tag
>
>   Fixes: 7d900f8ac191 ("selftests: kvm: s390: Add uc_skey VM test case")
>
> has these problem(s):
>
>   - Target SHA1 does not exist
>
> Maybe you meant
>
> Fixes: 0185fbc6a2d3 ("KVM: s390: selftests: Add uc_skey VM test case")

Yes, I double checked. Your proposal is the correct hash / commit on the ma=
ster
branch.
Sorry for the mixup.

