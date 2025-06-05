Return-Path: <kvm+bounces-48514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DDB48ACED51
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 12:08:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5732A3AC871
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 10:07:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3CC82144A3;
	Thu,  5 Jun 2025 10:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tY74RYV+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685AF2114;
	Thu,  5 Jun 2025 10:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749118076; cv=none; b=LM02QgGrrGSz3YgiPr9pZJR45bIgYTIcJEp6YZ4PA4SN2DeH9j8nu8agWnEX/FtvsMcdUr1wTs1bdDLhBKH1a9F8Fsi910K/g9kavemTQr9hPU5h5RGmFrxJVksbwjAebPyijrEQFNnquGBcXoRlLldWweLDzF9Pt5mDa3Zk4tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749118076; c=relaxed/simple;
	bh=xcO14dewg4FcbNqFj6D6wR4kgIY2w6CGgXESOxl+3rs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CEjzvoxkplJQk1TtnstsFpYJiWfmuGnxIL4O1fHblAhM8Qw7nL17d42D5mE05mGBcySbL5Na/coJAffnBT8qwwDVKEpu9UUx7D0cmGdqQpm5l31mjp1FIWmudS9SN1xJmO25r+z/CdEG3fHdlzxME/l9OhZybpWzfE2j00BYPAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tY74RYV+; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5550ouVW027947;
	Thu, 5 Jun 2025 10:07:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=3k0Fj+5oFD/lJmXjDWH0dPHd9i5r9x
	rmm7K1dHq1o6E=; b=tY74RYV+1qmM4IwEMpAnMnzuoLvhoMhSlN/PwY9MJ+28iO
	19VDcCWYsV5wuZWW6YnBCVWAlP80eGRW0FJs9PW+wyTwwe9yq1F9APBxFl3tJr5l
	u6QcRZ2a9hzIANVoGtuUR+oZ/ZeCHeKP7vBwNG7OgoMICKBAJ4YsOid/CFfq8z9I
	wuLI0lfNNzMwsudeui8TcKVCYkVtpDV6dsWG5nbQsm7Mp+aFZqHeujghuN7qpOdU
	UgCHk7fBixoraPpWvQQzSj9k6QzJ+Asc88iBuRiMpookUu2IYVMz1UkgbauNv9iS
	UD4BnzucwnMgWQpW+oWaHeLk0ar7pMoDchKQOPkQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 471geyg2r5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Jun 2025 10:07:51 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5558U2lX028442;
	Thu, 5 Jun 2025 10:07:50 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 470eakm03e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Jun 2025 10:07:50 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 555A7k4k45613386
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 5 Jun 2025 10:07:47 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DB6932006C;
	Thu,  5 Jun 2025 10:07:46 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 87C012006A;
	Thu,  5 Jun 2025 10:07:46 +0000 (GMT)
Received: from osiris (unknown [9.152.212.133])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  5 Jun 2025 10:07:46 +0000 (GMT)
Date: Thu, 5 Jun 2025 12:07:43 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s390/mm: Fix in_atomic() handling in
 do_secure_storage_access()
Message-ID: <20250605100743.7808A03-hca@linux.ibm.com>
References: <20250603134936.1314139-1-hca@linux.ibm.com>
 <aEB0BfLG9yM3Gb4u@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <20250604184855.44793208@p-imbrenda>
 <aECCe9bIZORv+yef@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <20250604194043.0ab9535e@p-imbrenda>
 <aEFdoYSKqvqK572c@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <408922a2-ec1a-4e60-841a-90714a3310de@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <408922a2-ec1a-4e60-841a-90714a3310de@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=ea09f6EH c=1 sm=1 tr=0 ts=68416c77 cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=VnNF1IyMAAAA:8 a=gvX5ooVSYO26w0DQ4S0A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: Gw3x4D75CZi7wll0UC1wl7wpcWgkJ5Mv
X-Proofpoint-ORIG-GUID: Gw3x4D75CZi7wll0UC1wl7wpcWgkJ5Mv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA1MDA4OCBTYWx0ZWRfX69/S5tlYnxG6 6PCpS4evIL77CJOTjEwpI0ld1kzas0mtQi8lKI15tRvzCFAiFlvdN/FnsA8gKbJvlj2B1dsBCao tudbXssQwKMg7CwT1e7pF5/B+jxB/K7vurAWmtgGjo3WZEpYsKcFYucViuZaSG4nylbDCr6REwb
 NE7/hJd30DDvA2c09W9qEE9ORUD3W/EvOK9lXvr0JMXFButWZdwlrd81W64A5UxFsC1j3qKYxve EQhugzysAk0DfJa+6txXUU7OGnkFVxjgyXT0n29bL5c3EzfINEzeR8DtqDIBSR7aWTqgAbr+KaF 0MbTU15jzJ10u+eqTyLVpU9YyGc6YQxdqwKibNrj1SE9z4vQ115KUcorpHLk9AF8nLS1yUn59V7
 Hd91pmHQTulllTL9tnady2dsZ3cnUfuYPyvJrRiB/9UZHe0u5IpQD1eqgSOhd84++GY+0TlY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-05_02,2025-06-03_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=461 bulkscore=0
 spamscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 impostorscore=0 phishscore=0 mlxscore=0 adultscore=0 clxscore=1015
 priorityscore=1501 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506050088

On Thu, Jun 05, 2025 at 11:06:29AM +0200, Christian Borntraeger wrote:
> Am 05.06.25 um 11:04 schrieb Alexander Gordeev:
> > On Wed, Jun 04, 2025 at 07:40:43PM +0200, Claudio Imbrenda wrote:
> > > > > > This could trigger WARN_ON_ONCE() in handle_fault_error_nolock():
> > > > > > 
> > > > > > 		if (WARN_ON_ONCE(!si_code))
> > > > > > 			si_code = SEGV_MAPERR;
> > > > > > 
> > > > > > Would this warning be justified in this case (aka user_mode(regs) ==
> > > > > > true)?
> > > > > 
> > > > > I think so, because if we are in usermode, we should never trigger
> > > > > faulthandler_disabled()
> > > > 
> > > > I think I do not get you. We are in a system call and also in_atomic(),
> > > > so faulthandler_disabled() is true and handle_fault_error_nolock(regs, 0)
> > > > is called (above).
> > > 
> > > what is the psw in regs?
> > > is it not the one that was being used when the exception was triggered?
> > 
> > Hmm, right. I assume is_kernel_fault() returns false not because
> > user_mode(regs) is true, but because we access the secondary AS.
> > 
> > Still, to me it feels wrong to trigger that warning due to a user
> > process activity. But anyway:
> > 
> > Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
> 
> Can we trigger a WARN from userspace?

No. If the warning triggers, then this indicates a bug in the kernel (exit to
user with faulthandler_disabled() == true). I managed to screw up the kernel
exactly with such a bug. See commit 588a9836a4ef ("s390/stacktrace: Use break
instead of return statement"), which lead to random unexplainable user space
crashes.

Note that we have the identical check/code in do_exception().

