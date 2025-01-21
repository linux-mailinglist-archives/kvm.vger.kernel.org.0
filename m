Return-Path: <kvm+bounces-36180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C578A185C6
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 20:41:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0063516B3EF
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 19:41:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 755BA1F7545;
	Tue, 21 Jan 2025 19:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ko+KtbFi"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF231F542C;
	Tue, 21 Jan 2025 19:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737488428; cv=none; b=WuiDLuYmGn/CtgnaVhcY62jCtZrIp2j1rGc19MvRSUksrAgpQyTuzc3tW9lyBlhU5ZmaFZRu1g5bx10zehB0aOXeM9nEXysX0LG4wlrio92Zue67CV48DFjKVRuc5hhu7swDewzIw93z8QqTqsOCn+TzgkTQs0w+zF4L6sf2An4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737488428; c=relaxed/simple;
	bh=4cvR1y6KWG5u8IVWCsjFn0BlJ/+xrsZNVHE0KIFjACQ=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=DDk4hDlvQ9thT1gfYw79whuGR9MIbHr1eX/boEUdlyTsNLFSWimQXwEul5VuOhn/UpQI7+YW1bByMDA7CPLNK25hQ/2JoKX8aSlbXlZuu1Obx6ee0eY/HyyjGe86oUEgkC7DkfiUsy6sLIqVVv0zekv7w5NqanuDQE+WL4/ty0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ko+KtbFi; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50LFN5J6011302;
	Tue, 21 Jan 2025 19:40:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=6rwAP8
	uqcAoTDRjTuuQqi+K2CnOP9cjuaGsxhFvpP3U=; b=Ko+KtbFiF5W4FkkAvJm2zJ
	S8I1emtjQkCYngtfw8I1abWQC+rSlbUHS84gg5ySOkPao3cBMPaeI/zpWljqSKOV
	fBME1+QUeMfhzYZbTVD89CTk39A66sJX4SRk9MVnw6/9Dm4F/XdvpBWrQ41jFBUW
	7CR8NQjdIYPoIekRt4odZUvS7y7/RjZCvW6Q0EemuDQ1kyeEBxpxL+TLXiRxLOVE
	xFtMBmPDZtMfDePdbM4MIdL/XfP7r8609H4BtX9eIo19ldrkKYbR7VRqQhfak28f
	qKfcpBcUX3vhCO/5R5nuQKUb0FETACzShEs+cvR/CGxsgKoVg/2wqzuLDgDLdVsQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44a5d7kxgm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jan 2025 19:40:23 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50LJdRxK011630;
	Tue, 21 Jan 2025 19:40:23 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44a5d7kxgj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jan 2025 19:40:23 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50LJXcUY020997;
	Tue, 21 Jan 2025 19:40:22 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 448sb1cbgp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jan 2025 19:40:22 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50LJeIc035717518
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Jan 2025 19:40:18 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6A22320043;
	Tue, 21 Jan 2025 19:40:18 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3A9FE20040;
	Tue, 21 Jan 2025 19:40:18 +0000 (GMT)
Received: from darkmoore (unknown [9.171.68.110])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 21 Jan 2025 19:40:18 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 21 Jan 2025 20:40:12 +0100
Message-Id: <D7808LRDCJ71.L6G17QHODL5Y@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Paolo Bonzini"
 <pbonzini@redhat.com>,
        "Tao Su" <tao1.su@linux.intel.com>,
        "Christian
 Borntraeger" <borntraeger@de.ibm.com>,
        "Xiaoyao Li" <xiaoyao.li@intel.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
        "Sean Christopherson"
 <seanjc@google.com>
Subject: Re: [PATCH v2 3/5] KVM: Add a dedicated API for setting
 KVM-internal memslots
X-Mailer: aerc 0.18.2
References: <20250111002022.1230573-1-seanjc@google.com>
 <20250111002022.1230573-4-seanjc@google.com>
 <D76ZBOXNTIGF.3D0BBERDWTY2C@linux.ibm.com> <Z4_F5dNstl3Xzhox@google.com>
 <20250121171756.1e2a2603@p-imbrenda>
In-Reply-To: <20250121171756.1e2a2603@p-imbrenda>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8JUjVtHWFSaWpUmRxnUA9exYBM_AQMTO
X-Proofpoint-ORIG-GUID: NbGqqgbjYzpIJFexF7oBf5z_Vs8uDeko
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-21_08,2025-01-21_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 mlxscore=0 spamscore=0 clxscore=1015 mlxlogscore=825
 lowpriorityscore=0 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501210155

On Tue Jan 21, 2025 at 5:17 PM CET, Claudio Imbrenda wrote:
> On Tue, 21 Jan 2025 08:05:57 -0800
> Sean Christopherson <seanjc@google.com> wrote:
>
> > On Mon, Jan 20, 2025, Christoph Schlameuss wrote:
> > > On Sat Jan 11, 2025 at 1:20 AM CET, Sean Christopherson wrote: =20
> > > > Add a dedicated API for setting internal memslots, and have it expl=
icitly
> > > > disallow setting userspace memslots.  Setting a userspace memslots =
without
> > > > a direct command from userspace would result in all manner of issue=
s.
> > > >
> > > > No functional change intended.
> > > >
> > > > Cc: Tao Su <tao1.su@linux.intel.com>
> > > > Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > > > Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> > > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > > ---
> > > >  arch/x86/kvm/x86.c       |  2 +-
> > > >  include/linux/kvm_host.h |  4 ++--
> > > >  virt/kvm/kvm_main.c      | 15 ++++++++++++---
> > > >  3 files changed, 15 insertions(+), 6 deletions(-) =20
> > >=20
> > > [...]
> > >  =20
> > > > +int kvm_set_internal_memslot(struct kvm *kvm,
> > > > +			     const struct kvm_userspace_memory_region2 *mem)
> > > > +{
> > > > +	if (WARN_ON_ONCE(mem->slot < KVM_USER_MEM_SLOTS))
> > > > +		return -EINVAL;
> > > > + =20
> > >=20
> > > Looking at Claudios changes I found that this is missing to acquire t=
he
> > > slots_lock here.
> > >=20
> > > guard(mutex)(&kvm->slots_lock); =20
> >=20
> > It's not missing.  As of this patch, x86 is the only user of KVM-intern=
al memslots,
> > and x86 acquires slots_lock outside of kvm_set_internal_memslot() becau=
se x86 can
> > have multiple address spaces (regular vs SMM) and KVM's internal memslo=
ts need to
> > be created for both, i.e. it's desirable to holds slots_lock in the cal=
ler.
> >=20
> > If it's annoying for s390 to acquire slots_lock, we could add a wrapper=
, i.e. turn
> > this into __kvm_set_internal_memslot() and then re-add kvm_set_internal=
_memslot()
> > as a version that acquires and releases slots_lock.
>
> I think it's fine as it is, just document that the lock needs to be
> held
>
> I'll add the necessary locking in the s390 code

I see. Thank you for the elaboration, Sean!

