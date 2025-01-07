Return-Path: <kvm+bounces-34686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A5D19A044EF
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 16:41:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9838B166315
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 15:41:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3FCF1F0E31;
	Tue,  7 Jan 2025 15:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="R27tIdc/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7049B2940F;
	Tue,  7 Jan 2025 15:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736264467; cv=none; b=opKQmYW+c5UeNplZUqEsIpp2OYIOAzXVaBhVjEY/0Ve6RDxyqCc2QwXK7OUfG2ltFr8UJv5dbs/Qrh/p5AIO3C4RW9aNydieF/ogwJw2cwqb4vAoddr+PSm7AqkGmVzONDoH3cawGKMwqtUIxAy/970+NuyJVY5hwlBYWtqeRJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736264467; c=relaxed/simple;
	bh=wU3AmXqWeebtBzG3iuP8K5ZfOVmS72pFtFks1Kfmdhc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K2jdIiyCJy95uhV1jb3xxGaMeIp0Pj5H+dg0/YSfKz+xDt6+dHcthZ6J8wW9NMCrRnmyu8YF248mSWsb9LWRpIPAEnga7MEIt6K5UIrBBJfKNgfcXpxR3hdyWGrMJ0YikM0zT5ynzxt0Dcd+sidzezNlU44SBGgWY6rxRtka/LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=R27tIdc/; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 507F07W8021223;
	Tue, 7 Jan 2025 15:40:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=evmVHb
	l1d3vQvc1aZxdCbI7PcZy58sDxPlK5whrOGuk=; b=R27tIdc/bafAcLou81yqmY
	gI0LKsh2Q+b5MYy16kSvC7IcP0VB31PzN1+6PttaaTKMIRPHGb8KOCnvhlUJFX2C
	y5gyzL0x7dJN2lLhOx8mvueT9J4G9OYv/uV5kYXpOxoXv0OGPP5BH9mekM52YHq4
	f390uF+DTQrxZSOrogNmL2VA1N27sYgZIAfzpl4oey4xnRBVXlTnEvssT+ec+AUK
	PXwxSs8I1M6EOeYFwWGC1QPrmCc5IP4V8Yr8AN25gqYthkBtL3ekXFjp5RPidAPJ
	KJR8cHSpfw/9olebEYEASKK9VNVlLhZ+uSKZkpJ4WcK/EG0gAzFdWkjvQ4HRutrw
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 440s0abpcy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Jan 2025 15:40:56 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 507EGVhK026238;
	Tue, 7 Jan 2025 15:40:55 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 43yj122uxm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Jan 2025 15:40:55 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 507FenxF61669744
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 Jan 2025 15:40:50 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DAE232004B;
	Tue,  7 Jan 2025 15:40:49 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5F60E20040;
	Tue,  7 Jan 2025 15:40:49 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.93.72])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
	Tue,  7 Jan 2025 15:40:49 +0000 (GMT)
Date: Tue, 7 Jan 2025 16:40:47 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank
 <frankja@linux.ibm.com>, KVM <kvm@vger.kernel.org>,
        S390
 <linux-s390@vger.kernel.org>,
        Christoph Schlameuss
 <schlameuss@linux.ibm.com>,
        Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List
 <linux-next@vger.kernel.org>
Subject: Re: linux-next: Fixes tag needs some work in the kvms390-fixes tree
Message-ID: <20250107164047.5a6799bb@p-imbrenda>
In-Reply-To: <20250106064232.3c34fdb1@canb.auug.org.au>
References: <20250106064232.3c34fdb1@canb.auug.org.au>
Organization: IBM
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jEQ5GHeOuQUOe4-7UZ4xMSQU5WTTRhHk
X-Proofpoint-ORIG-GUID: jEQ5GHeOuQUOe4-7UZ4xMSQU5WTTRhHk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1011
 phishscore=0 mlxlogscore=960 lowpriorityscore=0 impostorscore=0
 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501070130

On Mon, 6 Jan 2025 06:42:32 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> In commit
> 
>   6c2b70cc4887 ("selftests: kvm: s390: Streamline uc_skey test to issue iske after sske")
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
> 

ironically, it turns out that the patch creates more problem than it
solves, and therefore I'm removing it from the branch.

