Return-Path: <kvm+bounces-23214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 344CB947A0B
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 12:46:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B4A92B214EE
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 10:46:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC0461552E1;
	Mon,  5 Aug 2024 10:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RCZbc22I"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB4314F12C;
	Mon,  5 Aug 2024 10:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722854774; cv=none; b=e96/i5VRBawkhng82kXjNPJp7f/dWVa6NM/YNObEVxNql5CdzZLm/iuzulQOyXMICz2zYxxvFNedS0Q6QFlXgQeQC6uo6v6iSWxXTygd/lOjVGCgjbpORxRFI6bLtZHNjrTbHaEBWdzOyQrrCLDi7DW4MfwvdkOXrTA7Ji3ba2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722854774; c=relaxed/simple;
	bh=Yj1B6B/t40PR9MCrSV9RtkXcdWdq9UFD8Ze00CWVBp8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ga0m7ofvQ2LHnGxZ1seQHxPpl4E63L1Xn9Dz1x97pW6Xq/+UYB+gue7GQlT7NGMcZEA3nuTtReuUs8C8fSdj13WjvW7/HDVOZCLaFhmYJY4AdvvyBFLX+FvL/1MpkiS1KTjiLDWOck+LQzko+8V660ne7U5SmQsLk2MFT/FGbqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RCZbc22I; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4757RqtX020383;
	Mon, 5 Aug 2024 10:46:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	uoZMEPu3Cd0okgFE1TIGb+9g8tI2TbWzAMulmz8v3iw=; b=RCZbc22I/O2yY3gx
	9ToRhc0KN90U0mFV3/j5Qtn/T3iXGWPLHwZhBGu+8N0SCLs3cPxqqLgBoKN1bwNa
	P9hNI/jVSyU5fr4xuDCKfjSwdtTv+Fh1yJjQoqz9nNmLuccuR3JNJ311WoqEg8yO
	ojwSuHWXOtlbXdrOlSJ48197s0uAmSYp46XKw4JNdmu4eCXwkge3XHx5OBirq5yX
	6y6WEoA69eGp2ZmBu4XSxkxo7WD37I+ooa6ND/YMNPSB2MHmGkaHy5+uu9WBuSFH
	eVfVTLI5FuBYhfhr1Ei6kT0XU14bcni70MSlN+AReCs2R+M5zMzctCTOw+QFG3dN
	kl/Gew==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40tqr6rphx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Aug 2024 10:46:09 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 475AaMr1018626;
	Mon, 5 Aug 2024 10:46:08 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 40sxvtx6kd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Aug 2024 10:46:08 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 475Ak3BB16974272
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 5 Aug 2024 10:46:05 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 42CB120040;
	Mon,  5 Aug 2024 10:46:03 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 023D02004B;
	Mon,  5 Aug 2024 10:46:03 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  5 Aug 2024 10:46:02 +0000 (GMT)
Date: Mon, 5 Aug 2024 12:46:01 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com, svens@linux.ibm.com,
        seiden@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [PATCH v1 1/1] s390/uv: Panic if the security of the system
 cannot be guaranteed.
Message-ID: <20240805124601.331660f2@p-imbrenda.boeblingen.de.ibm.com>
In-Reply-To: <7f98cb85-de83-41ea-aaab-d76a22647ccb@linux.ibm.com>
References: <20240801112548.85303-1-imbrenda@linux.ibm.com>
	<7f98cb85-de83-41ea-aaab-d76a22647ccb@linux.ibm.com>
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
X-Proofpoint-GUID: JD9s8dAVLS681ZOXmXq61mQBhPEVfTLK
X-Proofpoint-ORIG-GUID: JD9s8dAVLS681ZOXmXq61mQBhPEVfTLK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-04_14,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 spamscore=0 impostorscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 suspectscore=0 phishscore=0 priorityscore=1501 mlxlogscore=897
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408050074

On Thu, 1 Aug 2024 15:20:30 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 8/1/24 1:25 PM, Claudio Imbrenda wrote:
> > The return value uv_set_shared() and uv_remove_shared() (which are
> > wrappers around the share() function) is not always checked. The system
> > integrity of a protected guest depends on the Share and Unshare UVCs
> > being successful. This means that any caller that fails to check the
> > return value will compromise the security of the protected guest.
> > 
> > No code path that would lead to such violation of the security
> > guarantees is currently exercised, since all the areas that are shared
> > never get unshared during the lifetime of the system. This might
> > change and become an issue in the future.  
> 
> For people wondering what the effects might be, this is the important 
> paragraph to read. Fortunately we're currently not unsharing anything.
> 
> Claudio already stated that there's no way out of this but I want to 
> reiterate on this. The hypervisor has to mess up quite badly to force a 
> rc > 0 for the guest. Likewise the guest has to mess up memory 
> management to achieve a rc > 0.
> 
> The only time where the cause of the rc can be fixed is when the 
> hypervisor is malicious and tracks its changes. In all other cases we 
> won't know why we ended up with a rc and it makes sense to stop the VM 
> before something worse happens.
> 
> 
> @Claudio:
> The patch subject is a bit non-specific.
> How about:
> "s390/uv: Panic for set and remove shared access UVC errors"

feel free to fix the subject when picking (unless you really want me to
send a v2)

> 
> With that fixed:
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> 


