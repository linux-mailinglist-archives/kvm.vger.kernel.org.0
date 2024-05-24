Return-Path: <kvm+bounces-18122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89BFC8CE643
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 15:42:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E2E83B2198D
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 13:42:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 978D712BF28;
	Fri, 24 May 2024 13:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="COrHDNKy"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7088A48CCC;
	Fri, 24 May 2024 13:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716558169; cv=none; b=HZxCCWPNQOms6MUVVxaWO9tuaeAmnbQpWS/xvaGQGbBWGsL2E9A434+AotmIy4girsGlM3mEwa8Sd7AvWc+KmllUfdaWWPcHuGl+yk/n3TpaOB1XNlCbFBgw8fFPkVrLQkpXQNJm8wHIRXy/v5mLNq6AR0Uky+/YLOKHH3yXzAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716558169; c=relaxed/simple;
	bh=kPSkmn6cHWFn0+BYM5ctJCrWSKG+QGjVtlxOyGnU+38=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bTmnY8yf9rBCD4rfP+bG85yjo4zrPAmrbRLOYOpHa4Cr6tcfvGG5+fDqTXp4bQWNcbuDATDsmwSBZmrVVrxX5T1LhtPSyARK2bLLX71YniFSutWsWXpqbQuZ/HO+FbZLPL33/ikFhLbs/3z41tzuAU65DKmbv6oWAwQgIsalA8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=COrHDNKy; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44ODgSDC010784;
	Fri, 24 May 2024 13:42:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=kPSkmn6cHWFn0+BYM5ctJCrWSKG+QGjVtlxOyGnU+38=;
 b=COrHDNKyGnkXqbKsJkS8rjAQJ13r8jA4zYl1v/kMNnhdXBdZea1PjcbVHoCgG2zUFUfQ
 bErNqiXKZzVPuHse7jeczkyuchYZO5xV6RTQaKY6E3ib/azhjyddybL0ASD41z9cHOb8
 xA8M3uUmJCVYev6B6xgpMJJ6RBZ7631s7Fva8XzDoFTgBlFWForei+yctdifxGCLxRn8
 lYnMUnRJHm8g8MBjd53gDH3e6pXJX+Kfsl2DmTLSO0/7jZXdoeLLr4DvEAOcoiQ8VZRr
 bULQ4nBzYiGY1TjH1y+VjR1uzSoAVAhSeZkuwTk+rdgsv7ovXhOia+RQA4xaOrF/QJMc Mg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yav0r801t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 May 2024 13:42:44 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44ODghOS011468;
	Fri, 24 May 2024 13:42:43 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yav0r801q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 May 2024 13:42:43 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44OCC3eF022112;
	Fri, 24 May 2024 13:42:42 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3y76nu94fr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 May 2024 13:42:42 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44ODga4J14025018
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 May 2024 13:42:38 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ACA802004F;
	Fri, 24 May 2024 13:42:36 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EC3DC2004D;
	Fri, 24 May 2024 13:42:35 +0000 (GMT)
Received: from [9.171.48.154] (unknown [9.171.48.154])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 24 May 2024 13:42:35 +0000 (GMT)
Message-ID: <b0a5bf684bc264dd4bc1a13657c51db5ee006b59.camel@linux.ibm.com>
Subject: Re: [PATCH v4 2/3] vfio/pci: Support 8-byte PCI loads and stores
From: Gerd Bayer <gbayer@linux.ibm.com>
To: Ramesh Thomas <ramesh.thomas@intel.com>,
        Alex Williamson
 <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Niklas
 Schnelle <schnelle@linux.ibm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Ankit Agrawal
	 <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
        Halil Pasic
	 <pasic@linux.ibm.com>,
        Julian Ruess <julianr@linux.ibm.com>, Ben Segal
	 <bpsegal@us.ibm.com>
Date: Fri, 24 May 2024 15:42:35 +0200
In-Reply-To: <8675abf2-00ca-4140-93be-8b45b04a5b7b@intel.com>
References: <20240522150651.1999584-1-gbayer@linux.ibm.com>
	 <20240522150651.1999584-3-gbayer@linux.ibm.com>
	 <2b6e91c2-a799-402f-9354-759fb6a5a271@intel.com>
	 <b1ee705ee3309405273ed1914a4326b9b024edf8.camel@linux.ibm.com>
	 <8675abf2-00ca-4140-93be-8b45b04a5b7b@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.52.1 (3.52.1-1.fc40app1) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nNSy0tfT6t5EFCQrl6H3UiAF6uHuOV-6
X-Proofpoint-ORIG-GUID: xZgIp47IbEMHrCSSkokOgiJPohgsDC1j
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-24_04,2024-05-24_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1011
 priorityscore=1501 spamscore=0 suspectscore=0 phishscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=250 bulkscore=0 impostorscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405240095

On Thu, 2024-05-23 at 14:47 -0700, Ramesh Thomas wrote:
> On 5/23/2024 8:01 AM, Gerd Bayer wrote:
> > Hi Ramesh,
> >=20
> > On Wed, 2024-05-22 at 16:38 -0700, Ramesh Thomas wrote:
> > > The removal of the check for iowrite64 and ioread64 causes build
> > > error because those macros don't get defined anywhere if
> > > CONFIG_GENERIC_IOMAP is not defined. However, I do think the
> > > removal of the checks is correct.
> >=20
> > Wait, I believe it is the other way around. If your config *is*
> > specifying CONFIG_GENERIC_IOMAP, lib/iomap.c will provide
> > implementations for back-to-back 32bit operations to emulate 64bit
> > accesses - and you have to "select" which of the two types of
> > emulation (hi/lo or lo/hi order) get mapped onto ioread64(be) or
> > iowrite64(be) by including linux/io-64-nonatomic-lo-hi.h (or -hi-
> > lo.h).
>=20
> Sorry, yes I meant to write they don't get defined anywhere in your
> code path if CONFIG_GENERIC_IOMAP *is defined*. The only place in
> your code path where iowrit64 and ioread64 get defined is in
> asm/io.h. Those definitions are surrounded by #ifndef
> CONFIG_GENERIC_IOMAP. CONFIG_GENERIC_IOMAP gets defined for x86.

Now I got it - I think. And I see that plain x86 is aleady affected by
this issue.

> > > It is better to include linux/io-64-nonatomic-lo-hi.h which
> > > define those macros mapping to generic implementations in
> > > lib/iomap.c.
> > > If the architecture does not implement 64 bit rw functions
> > > (readq/writeq), then=C2=A0 it does 32 bit back to back. I have sent a
> > > patch with the change that includes the above header file. Please
> > > review and include in this patch series if ok.
> >=20
> > I did find your patch, thank you. I had a very hard time to find a
> > kernel config that actually showed the unresolved symbols
> > situation:
> > Some 64bit MIPS config, that relied on GENERIC_IOMAP. And with your
> > patch applied, I could compile successfully.
> > Do you have an easier way steer a kernel config into this dead-end?
>=20
> The generic implementation takes care of all conditions. I guess some
> build bot would report error on build failures. But checks like
> #ifdef iowrite64 would hide the missing definitions error.

Yes definitely, we need to avoid this.

> >=20
> > > Thanks,
> > > Ramesh
> >=20
> > Frankly, I'd rather not make any assumptions in this rather generic
> > vfio/pci layer about whether hi-lo or lo-hi is the right order to >
> > emulate a 64bit access when the base architecture does not support
> > 64bit accesses naturally. So, if CONFIG_64BIT is no guarantee that
> > there's a definitive implementation of ioread64/iowrite64, I'd
> > rather
>=20
> There is already an assumption of the order in the current=20
> implementation regardless e.g. vfio_pci_core_do_io_rw(). If there is
> no iowrite64 found, the code does back to back 34 bit writes without=20
> checking for any particular order requirements.
>=20
> io-64-nonatomic-lo-hi.h and io-64-nonatomic-hi-lo.h would define=20
> ioread64/iowrite64 only if they are not already defined in asm/io.h.
>=20
> Also since there is a check for CONFIG_64BIT, most likely a 64 bit=20
> readq/writeq will get used in the lib/iomap.c implementations. I
> think we can pick either lo-hi or hi-lo for the unlikely 32 bit fall
> through when CONFIG_64BIT is defined.

I dug into lib/iomap.c some more today and I see your point, that it is
desireable to make the 64bit accessors useable through vfio/pci when
they're implemented in lib/iomap.c. And I follow your argument that in
most cases these will map onto readq/writeq - only programmed IO (PIO)
has to emulate this with 2 32bit back-to-back accesses.

If only the code in lib/iomap.c was structured differently - and made
readq/writeq available under ioread64/iowrite64 proper and only fell
back to the nonatomic hi-lo or lo-hi emulation with 32bit accesses if
PIO is used.

As much as I'd like to have it differently, it seems like it was a
lengthy process to have that change accepted at the time:
https://lore.kernel.org/all/20181106205234.25792-1-logang@deltatee.com/

I'm not sure if we can clean that up, easily. Plus there are appear to
be plenty of users of io-64-nonatomic-{lo-hi|-hi-lo}.h in tree already
- 103 and 18, resp.

> > revert to make the conditional compiles depend on those
> > definitions. But maybe Alex has an opinion on this, too?
> >=20
> > Thanks,
> > Gerd

So I'd like to hear from Alex and Tian (who was not a big fan) if we
should support 64bit accessors in vfio/pci (primarily) on x86 with this
series, or not at all, or split that work off, maybe?

Thanks,
Gerd


