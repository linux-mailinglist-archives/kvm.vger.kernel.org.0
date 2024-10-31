Return-Path: <kvm+bounces-30197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E8329B7E4C
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 16:25:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7344285658
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 15:25:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 663E01A2C0B;
	Thu, 31 Oct 2024 15:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mwPBwLLF"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36DA14901B;
	Thu, 31 Oct 2024 15:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730388297; cv=none; b=T2w0QCnIRETTu1usp2x4T7+hgR+ERRZi6mx4munx6/JsLaERY7B8Vi3pV26yqqKebPUeuuf1c3lgP/lexcmC9nMEvZlXCWvszdtgGpd/bykAgb+zHxIASMQxqDd4mLP2TMmIBQpfCQmhHiTaWZpZrPko/YaVCspofmkcNjhfeto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730388297; c=relaxed/simple;
	bh=h8gt7dAiiNhdpmiOvtJ+swZqRGR/xiNYSyWW8MhFZq4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CW+2Plu6/Mnbxzpb5ZrJVd6cJKtuBjLNPsN0yQ3tnO0ASbtfDHok3dT/tAT7PhdEy60L7DLmbhr7a8eCjvTcXFJssI51gZB+Y7af1iAQeuFGGw+FFzkQEqkNuFwFtq+xS09iMKVldektiHSCpxXi/wBULI3mjnfr8IbBAz9lUXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mwPBwLLF; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49VF2EEm012550;
	Thu, 31 Oct 2024 15:24:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=HCQM8HutoXEJgZ8P950F0KrJx/yQfY
	FDjVVjF9wUyQo=; b=mwPBwLLFZtVvM+jzWtiak2EvJUThp0IogdASEWLvwFinaq
	WXeWB2cqmRq39vkZAvqD+vQ30etqg6LiETthAkguGTVQpGzNW1SmLxiKEssFFDvZ
	Y77KPoHgjQmV1sN9rP7A1LyAnFEVQo3ktH5h/iw9E/WNdJHs5ZDNeyirOAI54aCb
	f35dXWjn+LnZOpduvja4duAwOZwUI80NQNymouzZup78zoPmUeV2DDPBtiR5Z2NY
	9C7d6N7H9voMbGceCT/JoFADNBFw/isoD9NbhxzMP78PawruCL3hUhx9ZAljmggB
	Bhk+PgGJNw9K2oCPCa/gAjjt+48SfcGfDZh7OQzg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42j3nt5j4b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 15:24:54 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49VBLC0F024535;
	Thu, 31 Oct 2024 15:24:53 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 42hcyjn5mv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 15:24:53 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49VFOocJ44302764
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Oct 2024 15:24:50 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 39B802004B;
	Thu, 31 Oct 2024 15:24:50 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A76A920040;
	Thu, 31 Oct 2024 15:24:49 +0000 (GMT)
Received: from osiris (unknown [9.171.15.29])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 31 Oct 2024 15:24:49 +0000 (GMT)
Date: Thu, 31 Oct 2024 16:24:48 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, borntraeger@de.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, frankja@linux.ibm.com, seiden@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 1/1] s390/kvm: mask extra bits from program interrupt
 code
Message-ID: <20241031152448.8297-B-hca@linux.ibm.com>
References: <20241031120316.25462-1-imbrenda@linux.ibm.com>
 <20241031123815.8297-A-hca@linux.ibm.com>
 <20241031140113.4123b8ee@p-imbrenda>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241031140113.4123b8ee@p-imbrenda>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lT4xcCf52zgZLho2uHnaxTpzLe1ZZCkl
X-Proofpoint-GUID: lT4xcCf52zgZLho2uHnaxTpzLe1ZZCkl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 bulkscore=0 mlxlogscore=881 clxscore=1015 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 mlxscore=0 impostorscore=0
 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410310113

On Thu, Oct 31, 2024 at 02:01:13PM +0100, Claudio Imbrenda wrote:
> On Thu, 31 Oct 2024 13:38:15 +0100
> Heiko Carstens <hca@linux.ibm.com> wrote:
> > > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > > index 8b3afda99397..f2d1351f6992 100644
> > > --- a/arch/s390/kvm/kvm-s390.c
> > > +++ b/arch/s390/kvm/kvm-s390.c
> > > @@ -4737,7 +4737,7 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
> > >  	if (kvm_s390_cur_gmap_fault_is_write())
> > >  		flags = FAULT_FLAG_WRITE;
> > >  
> > > -	switch (current->thread.gmap_int_code) {
> > > +	switch (current->thread.gmap_int_code & PGM_INT_CODE_MASK) {  
> > 
> > Can you give an example? When reviewing your patch I was aware of this, but
> > actually thought we do want to know when this happens, since the kernel did
> > something which causes such bits to be set; e.g. single stepping with PER
> > on the sie instruction. If that happens then such program interruptions
> > should not be passed for kvm handling, since that would indicate a host
> > kernel bug (the sie instruction is not allowed to be single stepped).
> > 
> > Or in other words: this should never happen. Of course I might have missed
> > something; so when could this happen where this is not a bug and the bits
> > should be ignored?
> 
> in some cases some guest indication bits might be set when a
> host exception happens.
> 
> I was also unaware of those and found out the hard way.

Thanks for explaining. Chances are that we need another patch to
address this for the vsie code as well (handle_fault()). But that
would be another patch.

Applied, thanks!

