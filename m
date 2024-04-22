Return-Path: <kvm+bounces-15480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CE5B8ACB7A
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 12:57:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A32591F234CE
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 10:57:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3573E145FF1;
	Mon, 22 Apr 2024 10:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KWdTjC+0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8C9145FE9;
	Mon, 22 Apr 2024 10:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713783453; cv=none; b=clszFH6UrVqzMLd2AxqWpIdAcfmGeglo13UQt3LgZtqwJuXIqVJf7fXjjdzLumWgOTCdYeByT7hUYjRxMe+bVJfTjI9ISC8eztehfuV3s75/qVi0kdxmlzuattUbQH1EbJMniEzSH5ieeFnPvE34q7mh32IxlYX0SvWiISos6HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713783453; c=relaxed/simple;
	bh=w1xzUgbJohFNYDJ47fkGDKBV6P/N+AsaTUPNxllhWDo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PTsL8pT53a6/VUeCw6fCtR6ytWRlBNKawNh/lKEHAEBY9acpi4XhyPg9rcRGu0WjOZB6pmGvSfYyr9RrEfrg2peyXClKbv90iBVXVPqANVjgB3Dslj+UfTySKHaUbF61ZzId2Vnv4sA2A2qqJcGBdHXGauiT4szTFfPJucrXyLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=KWdTjC+0; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43MAvOjx007414;
	Mon, 22 Apr 2024 10:57:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=E2JjMnB+6XWiJTS20ld80YrCy2ZrbJKAL1QUTd1Wobs=;
 b=KWdTjC+0r9HumlCcjrqHaAG36rSDAP5hVYRcIcNZujN+GxDsEKPko6jTjW8kNEiP/dXn
 YeaCLzJB3LrlDj0jSksmjVZKzUWZw4iBvi3sF8T6e/fbat4FGIm5PP/xwrOz4bNUdSjR
 +QfJSa0TC4JT9uRtsQ6VI8WfJ+lG/Erjs86Xqaypc/nHy5AYmcxBSb+h+G5kRf8P4xEl
 yhhocuGffBqb7jpCJiEnOF+aRc3AM6KYPecg9/i00SrIoa4lGbjzS7m0d8Rmj/bMCJgw
 Rh7an9+SELGDTsoTVOYQ7kquAdsnOTVnFbo9CdLOQ83op0V79FFMlt1IbM0puvEHeM+o Hw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xnpk9r01s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Apr 2024 10:57:28 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43MAvS0G007456;
	Mon, 22 Apr 2024 10:57:28 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xnpk9r01q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Apr 2024 10:57:28 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43M99tHZ029873;
	Mon, 22 Apr 2024 10:57:27 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xmr1t7fa9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Apr 2024 10:57:27 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43MAvMUo48103686
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Apr 2024 10:57:24 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5AE842004D;
	Mon, 22 Apr 2024 10:57:22 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D1E5420040;
	Mon, 22 Apr 2024 10:57:21 +0000 (GMT)
Received: from osiris (unknown [9.171.64.210])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 22 Apr 2024 10:57:21 +0000 (GMT)
Date: Mon, 22 Apr 2024 12:57:20 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Nico Boehr <nrb@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com
Subject: Re: [kvm-unit-tests RFC 2/2] lib: s390x: css: Name inline assembly
 arguments and clean them up
Message-ID: <20240422105720.31205-A-hca@linux.ibm.com>
References: <20240201142356.534783-1-frankja@linux.ibm.com>
 <20240201142356.534783-3-frankja@linux.ibm.com>
 <171377182433.14316.15188579220205837716@t14-nrb>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171377182433.14316.15188579220205837716@t14-nrb>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 64M-261fymZT47P5BtbO2OBj7ptNXLQZ
X-Proofpoint-GUID: i7qSE7pIYoGZLUyo2iGT_OQ8VBmQz28b
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-22_09,2024-04-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 adultscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 priorityscore=1501 mlxscore=0
 mlxlogscore=600 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404220050

On Mon, Apr 22, 2024 at 09:43:44AM +0200, Nico Boehr wrote:
> Quoting Janosch Frank (2024-02-01 15:23:56)
> [...]
> > diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> > index 504b3f14..e4311124 100644
> > --- a/lib/s390x/css.h
> > +++ b/lib/s390x/css.h
> [...]
> > @@ -167,11 +167,11 @@ static inline int msch(unsigned long schid, struct schib *addr)
> >         int cc;
> >  
> >         asm volatile(
> > -               "       msch    0(%3)\n"
> > -               "       ipm     %0\n"
> > -               "       srl     %0,28"
> > -               : "=d" (cc)
> > -               : "d" (reg1), "m" (*addr), "a" (addr)
> > +               "       msch    0(%[addr])\n"
> > +               "       ipm     %[cc]\n"
> > +               "       srl     %[cc],28"
> > +               : [cc] "=d" (cc)
> > +               : "d" (reg1), [addr] "a" (addr)
> 
> I think there was a reason why the "m"(*addr) was here. Either add it back
> or add a memory clobber.

It is there to tell the compiler that the memory contents at *addr are used
as input. Without that, and only the "a" contraint, the compiler is free to
discard any potential previous writes to *addr.

The best solution here would be to use the Q constraint (memory reference
with short displacement and without index register) for the second operand
address of msch. Or simply copy the current implementation from the kernel
(drivers/s390/cio/ioasm.c).

