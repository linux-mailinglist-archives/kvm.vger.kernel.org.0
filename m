Return-Path: <kvm+bounces-34219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 46F509F9596
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 16:41:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A04A31885F08
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 15:41:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B955C218EA8;
	Fri, 20 Dec 2024 15:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AfIy/TdA"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE231754B;
	Fri, 20 Dec 2024 15:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734709250; cv=none; b=nGQSSe7txzE2aTDgp5F3RacBO8wbusdDl5Rm7jQbBjegiUznVrI/8BsbP2uqM8A8l2Hhn7Qq9HScdOb23Ii8lAYWDLVu/R972LT0B6HL3Qm5mTksYiGoJM3KaFl0Gm6Jsaky+rMzF1qxorriyaanTCzwrabUGRMqdRm7rsG8cNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734709250; c=relaxed/simple;
	bh=iIF5UlkP75jSNwLBCNg5KKY/x8Ca724Y/L/eUSnAs2Q=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=U6kkwJq97iGTfhw7LvUdFb3H8+/Ac5uqNpaEe9X72amg7E5pDGdmfEt8NEJlMXCeWQ6aloPdM9Kyc38t6xVxH9xXB8A4veGc4nfkc6JL7G29W5lqFd092tR//unXNI6g6bxs8ASdqrZxDMb+fvSlGD0y32WtncKND6NRiovpiQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=AfIy/TdA; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BKD3PI2002323;
	Fri, 20 Dec 2024 15:40:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=iIF5Ul
	kP75jSNwLBCNg5KKY/x8Ca724Y/L/eUSnAs2Q=; b=AfIy/TdA3KbPbjNVk9lOtW
	stxJ77Bs5uZheZUoO21uP87R5zus4EauuQAu36bHLXQFJqkyxnwrNcZ8mHgEqttr
	CsAdiq/GjmzF4bKI6/LmDp2K5/j2Ui8LYgCm+Put7McrhGRcCOE36irEzBFFnzW0
	o01dvheYaL0FV4Hsy8isXk5EIBZhqiRstQNknqK/e4057fH8MTIiVG6pX2Feai2y
	9GLyHyONFr1mN4dhNu9GdM1PfYy7+GKKuKEqfZJvl3gUsaVfR0vOK+YDJUTIMqtP
	9krVxvJpjjQoGHl+AO78RAnZSVytJHzGBYVSQmdkZy+l3/qOWYYnJvX7gJYCY9WQ
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43mwmhknux-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Dec 2024 15:40:46 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4BKFE3vB011249;
	Fri, 20 Dec 2024 15:40:45 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 43hpjkjgf6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Dec 2024 15:40:45 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4BKFedmj34669102
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Dec 2024 15:40:39 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AC86020043;
	Fri, 20 Dec 2024 15:40:39 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 87B1C20040;
	Fri, 20 Dec 2024 15:40:39 +0000 (GMT)
Received: from darkmoore (unknown [9.171.18.201])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 20 Dec 2024 15:40:39 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 20 Dec 2024 16:40:34 +0100
Message-Id: <D6GN3OOI30ZZ.20TBUER91ABVC@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <nrb@linux.ibm.com>, <frankja@linux.ibm.com>, <borntraeger@de.ibm.com>,
        <thuth@redhat.com>, <david@redhat.com>, <linux-s390@vger.kernel.org>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH v3 3/3] s390x: pv: Add test for large
 host pages backing
X-Mailer: aerc 0.18.2
References: <20241218135138.51348-1-imbrenda@linux.ibm.com>
 <20241218135138.51348-4-imbrenda@linux.ibm.com>
In-Reply-To: <20241218135138.51348-4-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Ig0-zt6uyUKBb60jyzgjldeBOlwsupOP
X-Proofpoint-GUID: Ig0-zt6uyUKBb60jyzgjldeBOlwsupOP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 priorityscore=1501 mlxscore=0 phishscore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 malwarescore=0 adultscore=0 mlxlogscore=899
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412200125

On Wed Dec 18, 2024 at 2:51 PM CET, Claudio Imbrenda wrote:
> Add a new test to check that the host can use 1M large pages to back
> protected guests when the corresponding feature is present.
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

LGTM

Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

