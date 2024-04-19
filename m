Return-Path: <kvm+bounces-15323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 63D478AB2A0
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 17:58:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CFB3F1F235D8
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 15:58:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0739130A79;
	Fri, 19 Apr 2024 15:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="j+Ex7nRZ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCDF7641E;
	Fri, 19 Apr 2024 15:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713542286; cv=none; b=EE1MTq1KzUlclXHO5OFzCkTnHL1+VQg8Tlj4UiS29nO3hWnBlNm1OW3iB6kVDhSKoHUqgptYnN4/hxy3I1Gsw+Hl76Deo+ANSIrg1Tb4h4XKCahqo+t8DF6UbgjwJVNb7H4wMSqpdbRJvuDeUXAfr782kPSn0sDPVvfsYUXYVjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713542286; c=relaxed/simple;
	bh=/rScmpp2gchLBJb0Ntk40XRLfZuxIRxTtIS/k3Lz3eo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VN2KZDOqRUTTp/EwBAoDBhkA7M7y9Iidus8RXe2sJpP8Auu9QnFIudHAgKQS0SHGKw9TD2mpvjY5I+g9oDM15MrULcMB+auc1R4cdZUeN42I3j2cTvsbTwu46Q2ZgFj0gUfLmZeFri0Gtvnrj/Wr5cla1lueaGuwYWhxFTp0YLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=j+Ex7nRZ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43JFvHjH016803;
	Fri, 19 Apr 2024 15:58:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=/rScmpp2gchLBJb0Ntk40XRLfZuxIRxTtIS/k3Lz3eo=;
 b=j+Ex7nRZZv5yRdlvOIXDoBzneDIQAYRFwtcm6PquLQiL9BtCc8ctPOlOYM0HVgXSDGiI
 2Nt37BidlhkqQL5zYOY5toisoJqkOk5rBy6UEo44+kIUbgP0ah7ThGe61o+Z3wrIod4k
 UomNr4uoR/SezTpQTcnkgBb8loGciurpC8qnEjV/kjbObpw4AwBkWBXDQkpFVDNwQCNR
 Wdo2C3Fb/8WXTUChjU3okiZPZEBqsdPhjFxB+TpNIVWkaf9Q5XSAw1YeYWpYNGDotTX0
 AbElcFc9uwW1aRazYinNPRg5kRRGwL/jqqgDf8Wx055qKh/yx4oMXX7MWfs5DmMk2TCM XA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xkupyg06p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 19 Apr 2024 15:58:00 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43JFw0fj018025;
	Fri, 19 Apr 2024 15:58:00 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xkupyg068-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 19 Apr 2024 15:58:00 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43JFDbLR022762;
	Fri, 19 Apr 2024 15:57:59 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xkbk94j5f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 19 Apr 2024 15:57:59 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43JFvrUK45285846
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Apr 2024 15:57:55 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4D0BC2004B;
	Fri, 19 Apr 2024 15:57:53 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 10D822004E;
	Fri, 19 Apr 2024 15:57:53 +0000 (GMT)
Received: from [9.152.212.236] (unknown [9.152.212.236])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 19 Apr 2024 15:57:53 +0000 (GMT)
Message-ID: <c5ba134a1d4f4465b5956027e6a4ea6f6beff969.camel@linux.ibm.com>
Subject: Re: [PATCH] vfio/pci: Support 8-byte PCI loads and stores
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Gerd Bayer <gbayer@linux.ibm.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Ankit Agrawal
 <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Halil Pasic
 <pasic@linux.ibm.com>, Ben Segal <bpsegal@us.ibm.com>
Date: Fri, 19 Apr 2024 17:57:52 +0200
In-Reply-To: <20240419135823.GE223006@ziepe.ca>
References: <20240419135323.1282064-1-gbayer@linux.ibm.com>
	 <20240419135823.GE223006@ziepe.ca>
Autocrypt: addr=schnelle@linux.ibm.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.4 (3.50.4-1.fc39) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _nohi_2QuZKuEpacTUSbpWz2MLHPHFSh
X-Proofpoint-ORIG-GUID: wg5GccEPjM00Ap0LJyncEYyYSYR-yxGy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-19_11,2024-04-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 clxscore=1011 suspectscore=0 malwarescore=0 mlxlogscore=648 adultscore=0
 priorityscore=1501 mlxscore=0 phishscore=0 lowpriorityscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404190121

On Fri, 2024-04-19 at 10:58 -0300, Jason Gunthorpe wrote:
> On Fri, Apr 19, 2024 at 03:53:23PM +0200, Gerd Bayer wrote:
> > From: Ben Segal <bpsegal@us.ibm.com>
> >=20
> > Many PCI adapters can benefit or even require full 64bit read
> > and write access to their registers. In order to enable work on
> > user-space drivers for these devices add two new variations
> > vfio_pci_core_io{read|write}64 of the existing access methods
> > when the architecture supports 64-bit ioreads and iowrites.
> >=20
> > Signed-off-by: Ben Segal <bpsegal@us.ibm.com>
> > Co-developed-by: Gerd Bayer <gbayer@linux.ibm.com>
> > Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
> > ---
> >=20
> > Hi all,
> >=20
> > we've successfully used this patch with a user-mode driver for a PCI
> > device that requires 64bit register read/writes on s390.
>=20
> But why? S390 already has a system call for userspace to do the 64 bit
> write, and newer S390 has a userspace instruction to do it.
>=20
> Why would you want to use a VFIO system call on the mmio emulation
> path?
>=20
> mmap the registers and access them normally?

It's a very good point and digging into why this wasn't used by
Benjamin. It turns out VFIO_PCI_MMAP is disabled for S390 which it
really shouldn't be especially now that we have the user-space
instructions. Before that though Benjamin turned to this interface
which then lead him to this limitation. So yeah we'll definitely verify
that it also works via VFIO_PCI_MMAP and send a patch to enable that.

That said I still think it's odd not to have the 8 byte case working
here even if it isn't the right approach. Could still be useful for
debug/testing without having to add the MIO instructions or the our
special syscall.

Thanks,
Niklas

