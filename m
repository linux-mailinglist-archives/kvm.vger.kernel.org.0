Return-Path: <kvm+bounces-15482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BA5E8ACBAB
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 13:08:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F4361C21F1A
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 11:08:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B56E0146581;
	Mon, 22 Apr 2024 11:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tawZ/Z05"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF5C14601F;
	Mon, 22 Apr 2024 11:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713784116; cv=none; b=Z70ApHsyWiOT7BxP8dBd49jqYmFXcxZkJbI/gMVCm0+YWimwqBhSWcuI+pVzXwUo9NcRu7dBKMoLFUHZseGQ3rHAsJBNek2n8bUloOS0G0kO23sVXSjYhA3fGFXBXdV14Ujv/g9GT2gOlkU43gLxQorDv+LVBhFti51y6cuOGEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713784116; c=relaxed/simple;
	bh=/WBjXrhKs3Vk7S/GTe32slJtuFE1Vv6/BDiUV4NM6wQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cNnYVNefAsBl13v5uf4mpt7u+ZZm8E4UkZrO2b2niMbArnV6idXTkSmd8UznvkwgWABPKyCQyAYwT9CjjzcK1kD2H14WyNGF5Z57AbOgdF+q2eYHCHXOs/D4QLd8/Uo++iWN66EIDHgNr/5TjGDh8be1qkqyuom65TpBR0a4+aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tawZ/Z05; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43MATDev024208;
	Mon, 22 Apr 2024 11:08:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=/WBjXrhKs3Vk7S/GTe32slJtuFE1Vv6/BDiUV4NM6wQ=;
 b=tawZ/Z05Ys8xGypNOq2TbhoW0v+3D/uYXnGlIixj6o9Jjgr7pKTFfnuTd1iDmfs/dR3K
 cGRfUf/ZQoQ1YZt5yCaQLAblPLgjX8YtvhDUo2dFLaJQ5FMGrh0IzfpgdmuWOLaI91jQ
 jYwF9t9YVippy/O3YOQi3rpND7RuizMlDm9/pyg1VIFZ21kwnzVXPyYCoORAUyskTnKx
 j6lGW3XQ7YzY4wD7aAb4+AEFgihdpFGVDHqBizvJWRrK5AX0sE/aFq/YqCD6XrX3Cnio
 ZlOH6c8Q9lR3fmqkH+iJUXv+vtOK6rpmn6opU0P0ZQm+A9HGW0+eu+HtjnFheUUOA8I3 fg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xnp5h82mr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Apr 2024 11:08:31 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43MB8UM9023891;
	Mon, 22 Apr 2024 11:08:30 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xnp5h82mk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Apr 2024 11:08:30 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43M80RiS005352;
	Mon, 22 Apr 2024 11:08:29 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xmx3c62c2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Apr 2024 11:08:29 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43MB8OqX16646428
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Apr 2024 11:08:26 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 006D52004B;
	Mon, 22 Apr 2024 11:08:24 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8DDE920040;
	Mon, 22 Apr 2024 11:08:23 +0000 (GMT)
Received: from [9.171.18.8] (unknown [9.171.18.8])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 22 Apr 2024 11:08:23 +0000 (GMT)
Message-ID: <5fe2171422c4ca388e351cd55c14ec3bd8aefe40.camel@linux.ibm.com>
Subject: Re: [PATCH] vfio/pci: Support 8-byte PCI loads and stores
From: Gerd Bayer <gbayer@linux.ibm.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe
 <jgg@ziepe.ca>
Cc: Niklas Schnelle <schnelle@linux.ibm.com>,
        Ankit Agrawal
 <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Halil Pasic
 <pasic@linux.ibm.com>, Ben Segal <bpsegal@us.ibm.com>
Date: Mon, 22 Apr 2024 13:08:23 +0200
In-Reply-To: <20240419104745.01ebb96f.alex.williamson@redhat.com>
References: <20240419135323.1282064-1-gbayer@linux.ibm.com>
	 <20240419135823.GE223006@ziepe.ca>
	 <c5ba134a1d4f4465b5956027e6a4ea6f6beff969.camel@linux.ibm.com>
	 <20240419161135.GF223006@ziepe.ca>
	 <20240419104745.01ebb96f.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.4 (3.50.4-2.fc39app4) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: M0Q70jls1TvizGsyJ_kCMoW4u5antUWp
X-Proofpoint-ORIG-GUID: cLHKeSBxSQBz_Vuh5crlM-xAmIA7y7pv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-22_09,2024-04-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=867 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=0 impostorscore=0 priorityscore=1501 adultscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404220050

On Fri, 2024-04-19 at 10:47 -0600, Alex Williamson wrote:
> On Fri, 19 Apr 2024 13:11:35 -0300
> Jason Gunthorpe <jgg@ziepe.ca> wrote:
>=20
> > On Fri, Apr 19, 2024 at 05:57:52PM +0200, Niklas Schnelle wrote:
> > > On Fri, 2024-04-19 at 10:58 -0300, Jason Gunthorpe wrote:=C2=A0=20
> > > > On Fri, Apr 19, 2024 at 03:53:23PM +0200, Gerd Bayer wrote:=C2=A0=
=20
> > > > > From: Ben Segal <bpsegal@us.ibm.com>
> > > > >=20
> > > > > Many PCI adapters can benefit or even require full 64bit read
> > > > > and write access to their registers. In order to enable work
> > > > > on
> > > > > user-space drivers for these devices add two new variations
> > > > > vfio_pci_core_io{read|write}64 of the existing access methods
> > > > > when the architecture supports 64-bit ioreads and iowrites.
> > > > >=20
> > > > > Signed-off-by: Ben Segal <bpsegal@us.ibm.com>
> > > > > Co-developed-by: Gerd Bayer <gbayer@linux.ibm.com>
> > > > > Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
> > > > > ---
> > > > >=20
> > > > > Hi all,
> > > > >=20
> > > > > we've successfully used this patch with a user-mode driver
> > > > > for a PCI device that requires 64bit register read/writes on
> > > > > s390.=C2=A0=20
> > > >=20
> > > > But why? S390 already has a system call for userspace to do the
> > > > 64 bit write, and newer S390 has a userspace instruction to do
> > > > it.
> > > >=20
> > > > Why would you want to use a VFIO system call on the mmio
> > > > emulation path?
> > > >=20
> > > > mmap the registers and access them normally?=C2=A0=20
> > >=20
> > > It's a very good point and digging into why this wasn't used by
> > > Benjamin. It turns out VFIO_PCI_MMAP is disabled for S390 which
> > > it really shouldn't be especially now that we have the user-space
> > > instructions. Before that though Benjamin turned to this
> > > interface which then lead him to this limitation. So yeah we'll
> > > definitely verify that it also works via VFIO_PCI_MMAP and send a
> > > patch to enable that.=C2=A0=20
> >=20
> > Make sense to me!
> >=20
> > > That said I still think it's odd not to have the 8 byte case
> > > working here even if it isn't the right approach. Could still be
> > > useful for debug/testing without having to add the MIO
> > > instructions or the our special syscall.=C2=A0=20
> >=20
> > Yes, this also makes sense, but this patch needs some adjusting
>=20
> Yes, I think so too, falling back to 4-byte accesses of course if
> 8-byte is not available.=C2=A0 Thanks,

So I'll rework this to simply fall back to 32-bit if 64-bit is not
available in a v2. And we'll investigate the VFIO_PCI_MMAP case
separately.

Thank you,
Gerd

