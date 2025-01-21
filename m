Return-Path: <kvm+bounces-36145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DED0A181E1
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 17:18:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E33216BF67
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 16:18:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A23A1F4E33;
	Tue, 21 Jan 2025 16:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ci1xpJQM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912151F4705;
	Tue, 21 Jan 2025 16:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737476291; cv=none; b=hmejBv1f6PJjGM/R/moW2HbD7VqsO/yBkjOcRvrMDgZaCfV4WIL9Fs9Pmqu6FTwjfNmwNOEz7+wxB6V42K1eEI4zW1TbJexWX3vxnY4My6GMhkDPNW6+xixDBwxPwxieiL2o0qF7tHxaPzAKNkche0TePdj1P+OfSlRt96RybX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737476291; c=relaxed/simple;
	bh=dg9nKFnOYmWopx8IC+qQiR6bzodKOGsytdfWlSbWsx4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eoC/15QBmAHWIYep6hspbgtWzOFjMvMqltZCXGCLlOq6CQewuJ0A1wdU8Ap8FrTeFyxD/nVRc6SkN+dKgAzjouD3zOP9Nkn4in+vOerZeQn5t/w/LR0ZUj7mHDibfGklthLdASnl4NBPGeP+s4MAB85oAWOo/hAvXh2Fy4E3+hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ci1xpJQM; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50LDk9Al021738;
	Tue, 21 Jan 2025 16:18:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Z+mveW
	djwbfEGc4Y+F9LjHpqZ7sL9KI4GhC7FgagRv4=; b=Ci1xpJQMVUss5jYvScFvAP
	y8AW2YvHULypp/MN8TbRvfRzJegEX6QIV+r2FxIBksdwN9dDAMUg3gW8CNKhSAF0
	Xkv4ZBTjUsD3YjDmGTZhGOzjkiUV4y0Dl8to7gVBjQZvcYBjuQrkkGqtno8lay+w
	yZaNKwLrN7t/zFAp5cpXCYEWLqgh4BnDYNAVXtwbKa+7r9diYyvOMTiwg9dqD2TX
	rZ0QLq1dRm6J/hmYnY2FgBc9tCDdsglG5wGjH8IPKXL8UvLZT6BtACvSdGF1E5zk
	DFC35Cnh4t/hsD3ILz5ywaHkgkY903Xm7pp0avOTnBgIP54UfAREXPdqYFudLfog
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44a1n9bt0m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jan 2025 16:18:05 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50LG3tPc024275;
	Tue, 21 Jan 2025 16:18:05 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44a1n9bt0f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jan 2025 16:18:05 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50LD2Dfh019218;
	Tue, 21 Jan 2025 16:18:04 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 448pmsc4ar-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jan 2025 16:18:04 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50LGI0jM34275634
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Jan 2025 16:18:00 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 59EC72004D;
	Tue, 21 Jan 2025 16:18:00 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CC05820040;
	Tue, 21 Jan 2025 16:17:59 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.11.211])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Tue, 21 Jan 2025 16:17:59 +0000 (GMT)
Date: Tue, 21 Jan 2025 17:17:56 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Christoph Schlameuss <schlameuss@linux.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Tao Su
 <tao1.su@linux.intel.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v2 3/5] KVM: Add a dedicated API for setting
 KVM-internal memslots
Message-ID: <20250121171756.1e2a2603@p-imbrenda>
In-Reply-To: <Z4_F5dNstl3Xzhox@google.com>
References: <20250111002022.1230573-1-seanjc@google.com>
	<20250111002022.1230573-4-seanjc@google.com>
	<D76ZBOXNTIGF.3D0BBERDWTY2C@linux.ibm.com>
	<Z4_F5dNstl3Xzhox@google.com>
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
X-Proofpoint-ORIG-GUID: nibtvxumwVXWegXQwTbyZ4p_me_Mdzhv
X-Proofpoint-GUID: 13mvluOIz-z5NH-VofCkz5qklqFl3b7Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-21_06,2025-01-21_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 bulkscore=0 suspectscore=0 adultscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 impostorscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=901
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501210130

On Tue, 21 Jan 2025 08:05:57 -0800
Sean Christopherson <seanjc@google.com> wrote:

> On Mon, Jan 20, 2025, Christoph Schlameuss wrote:
> > On Sat Jan 11, 2025 at 1:20 AM CET, Sean Christopherson wrote:  
> > > Add a dedicated API for setting internal memslots, and have it explicitly
> > > disallow setting userspace memslots.  Setting a userspace memslots without
> > > a direct command from userspace would result in all manner of issues.
> > >
> > > No functional change intended.
> > >
> > > Cc: Tao Su <tao1.su@linux.intel.com>
> > > Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > > Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  arch/x86/kvm/x86.c       |  2 +-
> > >  include/linux/kvm_host.h |  4 ++--
> > >  virt/kvm/kvm_main.c      | 15 ++++++++++++---
> > >  3 files changed, 15 insertions(+), 6 deletions(-)  
> > 
> > [...]
> >   
> > > +int kvm_set_internal_memslot(struct kvm *kvm,
> > > +			     const struct kvm_userspace_memory_region2 *mem)
> > > +{
> > > +	if (WARN_ON_ONCE(mem->slot < KVM_USER_MEM_SLOTS))
> > > +		return -EINVAL;
> > > +  
> > 
> > Looking at Claudios changes I found that this is missing to acquire the
> > slots_lock here.
> > 
> > guard(mutex)(&kvm->slots_lock);  
> 
> It's not missing.  As of this patch, x86 is the only user of KVM-internal memslots,
> and x86 acquires slots_lock outside of kvm_set_internal_memslot() because x86 can
> have multiple address spaces (regular vs SMM) and KVM's internal memslots need to
> be created for both, i.e. it's desirable to holds slots_lock in the caller.
> 
> If it's annoying for s390 to acquire slots_lock, we could add a wrapper, i.e. turn
> this into __kvm_set_internal_memslot() and then re-add kvm_set_internal_memslot()
> as a version that acquires and releases slots_lock.

I think it's fine as it is, just document that the lock needs to be
held

I'll add the necessary locking in the s390 code


