Return-Path: <kvm+bounces-12660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D873F88BB74
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 08:39:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08F5A1C30EB9
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 07:39:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4E2B1327F7;
	Tue, 26 Mar 2024 07:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MuUFQBYC"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD45839E2;
	Tue, 26 Mar 2024 07:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711438729; cv=none; b=VFriFRScN4hw8ibcc7bG+rtomZfDsoW3tHArxWHINHz+Tc4GtZaAuHMhNOxhDc6iNGUF3NfZ3B8Mmrta5kYLEV6ZtabNDl4frJSQZFiFOauekHtghrn/W7B0uKi+nXzcKysvh4Zw9b56CVc5iAmDcDGsruY0hTG71jCR51Ln/yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711438729; c=relaxed/simple;
	bh=zasrgEQ8PpQSnTnjWuIuknfRyFZDN6ocuqsuM92kjzQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zei3cahctvIGHu13OO8WyvgZVRlNj3tdYKINllze5SRNS7KKm6mnfFRZ9zAvkUByELZsDGFaJku8z4ZPUP8cZZR6/IoN8zP6mO5iVnS58WcOW2/HZNoIvGQmNazi2SQbybmrOndu5CEu+35ib18847JwTUQVBCHzDzck7Q39Qew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MuUFQBYC; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42Q5LbsP026333;
	Tue, 26 Mar 2024 07:38:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=oB4/YmzW/XBsuEVbbPCASdcRnc5ejjoZ5/zY1M4QVqw=;
 b=MuUFQBYC+X5LOzvVKpOzWltKuUBvsdfLgvkn6JVxiJ0rx3/fDuZlsi8STc/zbvhuLpac
 dYVOKiEGFnNTH2j0QKmaKpqYrTF+WP+AfITlSJeKxAg4rDjsqFR3S6KA6T8VdC5r34Lx
 8QjY1cfYJh7QW8UOnkGJU0BhMhZzW9icIZkJ3uqMjmtZLMitkkTRPmswjnoko40AbkPV
 +Z2vqp2gZfGo0VK+R+wLQvkddDLClCJ8TmkqdXAL7SU5rbvk6CTbwgpSrw312mxseWjJ
 QPnZapmXpoc49x+0nnkq66IzwX8IpwaTb1/KoXQEq2lz8MRptZ26KfDTJJdnPPmVKKih hw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x3kb10ukp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Mar 2024 07:38:42 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42Q7cf4l000915;
	Tue, 26 Mar 2024 07:38:41 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x3kb10ukj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Mar 2024 07:38:41 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 42Q4bnhE003780;
	Tue, 26 Mar 2024 07:38:40 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3x2c42nu9a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Mar 2024 07:38:40 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 42Q7cZTB44958184
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 07:38:37 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 40ED32004E;
	Tue, 26 Mar 2024 07:38:35 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 02B1420040;
	Tue, 26 Mar 2024 07:38:35 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 26 Mar 2024 07:38:34 +0000 (GMT)
Date: Tue, 26 Mar 2024 08:38:33 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 0/2] s390/mm: shared zeropage + KVM fix and
 optimization
Message-ID: <20240326073833.6078-A-hca@linux.ibm.com>
References: <20240321215954.177730-1-david@redhat.com>
 <20240321151353.68f9a3c9c0b261887e4e5411@linux-foundation.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240321151353.68f9a3c9c0b261887e4e5411@linux-foundation.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: S0IbuxD46Xgg4Qw0IOpeHf3APGY4p-aQ
X-Proofpoint-ORIG-GUID: Y3fTsNA5ux-kI7T0fse-O9DbeqeHt6go
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_04,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1011 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 adultscore=0
 mlxscore=0 mlxlogscore=480 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403260051

On Thu, Mar 21, 2024 at 03:13:53PM -0700, Andrew Morton wrote:
> On Thu, 21 Mar 2024 22:59:52 +0100 David Hildenbrand <david@redhat.com> wrote:
> 
> > Based on current mm-unstable. Maybe at least the second patch should
> > go via the s390x tree, I think patch #1 could go that route as well.
> 
> Taking both via the s390 tree is OK by me.  I'll drop the mm.git copies
> if/when these turn up in the linux-next feed.

Considering the comments I would expect a v2 of this series at some
time in the future.

