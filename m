Return-Path: <kvm+bounces-15675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BDDE8AF39A
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 18:12:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 305AD2827E4
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 16:12:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98DE013CABE;
	Tue, 23 Apr 2024 16:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MPfyDXcX"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE56B13BC29;
	Tue, 23 Apr 2024 16:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713888735; cv=none; b=n5b22wLBEGkPLLyPfpecnP+4Mc3kTdSHf8XkPMFiWOcZ3pkVCVf60FzAW1B9vKYblyNnS2PbRnKgO6FX/vhdMzhEYf56L4DsmDcz+jXVTohz7UN2fe2cQZZKQc2YbMf9/ytsh9rblsoL/OONGXdOaic6DuPecrdp/jvXr8UQxAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713888735; c=relaxed/simple;
	bh=7aFBq2gInw7F/n6GOx1KjytYL/krd7ZbL8KsKZT52bs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UEp5iNlP/RVIYdvp//WVdt5dPxIr9h/+ja3iYGdY9n8668nD7Ql1oH1DB4B/g4eIYKiwa/vGEgD7pdV8X/lOJk7t+0eRmz1mB2H6Sl3WkHlpKiJEEzvTM4BOGa5EAFSz9c0td4E/w4mR1arDsBCjBuW2ji5e6UMlyk7i8B/63mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MPfyDXcX; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43NDgQdd032685;
	Tue, 23 Apr 2024 16:12:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=7aFBq2gInw7F/n6GOx1KjytYL/krd7ZbL8KsKZT52bs=;
 b=MPfyDXcXhDJigZ2r3yEG8fZiEjpvqYtdu/2YS8KJUCpMvgrPs71SBcMCYXd9NR3VJEN4
 4i+XOWuVup8aozlVnBf18o/GWIR+gzUcOusETHNCvZ6EcsffgCBbMW4hW8x6B7n4SGWP
 OQ0IvoQ0PBKp4OM3tLnO7dYCZpkpLGiwEvSkdw7LvL1pLdj8IJ05+C2WmUfGYGLHPB4x
 uSMXeoQ3GqH2B7YYZkeQtie3MSJPciogcD79br7BgE04bO9tpQQUgFURSPKeO9cDrOKp
 rzLGi6XJ/MnRw/J2w44p1TFWLRBfuhSpki+ENxR59eP5o3fS7b6EaZm6PeaCIwUuoLPq TQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xpcxa8hv0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Apr 2024 16:12:09 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43NGC9bY030604;
	Tue, 23 Apr 2024 16:12:09 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xpcxa8huw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Apr 2024 16:12:09 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43NEsMK7023068;
	Tue, 23 Apr 2024 16:12:07 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xms1nxhtn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Apr 2024 16:12:07 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43NGC2l350594084
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Apr 2024 16:12:04 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 160242004B;
	Tue, 23 Apr 2024 16:12:02 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D09F020049;
	Tue, 23 Apr 2024 16:12:01 +0000 (GMT)
Received: from [9.152.212.201] (unknown [9.152.212.201])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 23 Apr 2024 16:12:01 +0000 (GMT)
Message-ID: <311395d0817e9c2c6a0415b5ece97c68f4c4ba95.camel@linux.ibm.com>
Subject: Re: [PATCH v2] vfio/pci: Support 8-byte PCI loads and stores
From: Gerd Bayer <gbayer@linux.ibm.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe
 <jgg@ziepe.ca>
Cc: Niklas Schnelle <schnelle@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Ankit Agrawal <ankita@nvidia.com>,
        Yishai Hadas
	 <yishaih@nvidia.com>, Halil Pasic <pasic@linux.ibm.com>,
        Julian Ruess
	 <julianr@linux.ibm.com>, Ben Segal <bpsegal@us.ibm.com>
Date: Tue, 23 Apr 2024 18:11:57 +0200
In-Reply-To: <20240422163353.24f937ce.alex.williamson@redhat.com>
References: <20240422153508.2355844-1-gbayer@linux.ibm.com>
	 <20240422174305.GB231144@ziepe.ca>
	 <20240422163353.24f937ce.alex.williamson@redhat.com>
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
X-Proofpoint-ORIG-GUID: kWbyzbp8ttO41gfCcgdEvzjHq06qAdNA
X-Proofpoint-GUID: sq0GsdgsGd4Jll59vLpOtx20L1JECjlR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-23_12,2024-04-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 impostorscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 phishscore=0 bulkscore=0 suspectscore=0 mlxlogscore=428
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404230037

On Mon, 2024-04-22 at 16:33 -0600, Alex Williamson wrote:
> On Mon, 22 Apr 2024 14:43:05 -0300
> Jason Gunthorpe <jgg@ziepe.ca> wrote:
>=20
> > On Mon, Apr 22, 2024 at 05:35:08PM +0200, Gerd Bayer wrote:
> > > From: Ben Segal <bpsegal@us.ibm.com>
> > >=20
> > > Many PCI adapters can benefit or even require full 64bit read
> > > and write access to their registers. In order to enable work on
> > > user-space drivers for these devices add two new variations
> > > vfio_pci_core_io{read|write}64 of the existing access methods
> > > when the architecture supports 64-bit ioreads and iowrites.
> > >=20
> > > Since these access methods are instantiated on 64bit
> > > architectures,
> > > only, their use in vfio_pci_core_do_io_rw() is restricted by
> > > conditional
> > > compiles to these architectures.
> > >=20
> > > Signed-off-by: Ben Segal <bpsegal@us.ibm.com>
> > > Co-developed-by: Gerd Bayer <gbayer@linux.ibm.com>
> > > Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
> > > ---
> > > Hi all,
> > >=20
> > > we've successfully used this patch with a user-mode driver for a
> > > PCI
> > > device that requires 64bit register read/writes on s390. A quick
> > > grep
> > > showed that there are several other drivers for PCI devices in
> > > the kernel
> > > that use readq/writeq and eventually could use this, too.
> > > So we decided to propose this for general inclusion.
> > >=20
> > > Thank you,
> > > Gerd Bayer
> > >=20
> > > Changes v1 -> v2:
> > > - On non 64bit architecture use at most 32bit accesses in
> > > =C2=A0 vfio_pci_core_do_io_rw and describe that in the commit message=
.
> > > - Drop the run-time error on 32bit architectures.
> > > - The #endif splitting the "else if" is not really fortunate, but
> > > I'm
> > > =C2=A0 open to suggestions.=C2=A0=20
> >=20
> > Provide a iowrite64() that does back to back writes for 32 bit?
>=20
> I was curious what this looked like.=C2=A0 If we want to repeat the 4 byt=
e
> access then I think we need to refactor all the read/write accesses
> into macros to avoid duplicating code, which results in something
> like [1] below.=C2=A0 But also once we refactor to macros, the #ifdef
> within the function as originally proposed gets a lot more bearable
> too [2].
>=20
> I'd probably just go with something like [2] unless you want to
> further macro-ize these branches out of existence in the main
> function.=C2=A0Feel free to grab any of this you like, the VFIO_IORDWR
> macro should probably be it's own patch.=C2=A0 Thanks,
>=20
> Alex

Hi Alex,

thanks for your suggestions, I like your VFIO_IORDWR macro in [1].
As I just explained to Jason, I don't think that the back-to-back 32bit
accesses are a safe emulation of 64bit accesses in general, though. So
I'd rather leave that out.

However, I'm working on an idea - extending on the VFIO_IORDWR macro -
to convert the if - else if - chain into a switch/case construct, where
I can more easily #ifdef out the 64bit case if not available.

Now I "just" need to test this ;)

Thanks,
Gerd


