Return-Path: <kvm+bounces-15674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B22928AF358
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 17:59:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 67DA7286E7D
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 15:59:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE7D813CA83;
	Tue, 23 Apr 2024 15:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mqps9JPz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E8413C687;
	Tue, 23 Apr 2024 15:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713887979; cv=none; b=bV6oRYg7VuLhE/IBtRs4deZHtOaUD3Czra8wlbWKch+jpXP0wWhPexDGUZZLjNxnBMiuWP7ST24NmkmqWV5FFMlBI0HDJG9NvjRr0Ko1GvpYqVS7XTreEhBvbhkcfzfw0FgvG2F9x71fwtmkycvtB9R+KfjyWHgxxZbhiRf4vjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713887979; c=relaxed/simple;
	bh=3W3+gTlMMlGg1n5siDppY1Jls5G/5X/Gqih9vYnq/kU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YXPxuCS6OfCHGQpCHygXdKQbOihpful64yMuJ4C/c6UFxxHFe/K9cnQC8E0LsStv+Gyy6ZxsTWce+PeSmCkJRl4pjB/MPT08X6coRPtOQ4uFIEHXwf61852re9UXAHKpiOe3uU8ZyI96aRlYF8ZVaP4B/OAxwApWMyHGqSA2+SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mqps9JPz; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43NDYXPe022325;
	Tue, 23 Apr 2024 15:59:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=3W3+gTlMMlGg1n5siDppY1Jls5G/5X/Gqih9vYnq/kU=;
 b=mqps9JPzmmucqUQt1PS5DpvKXj+m+I4wBgM99Xeublap5Lm4PUB52nQ6oJEy7dF4lmNG
 oyCc2GSF3y/4aZ09KbqCMzTbTpmeMwF/e2EObUBBCZ7jhdoxHJir0WwQ78oTjg4H2eYw
 sEGzZrN0GMgQhj+rywyUJkBqkxTzAlqxwarrwr3ak0lIOdjplVXo2ujXeAi0IVAnrUuR
 O9MDgl1ua9IRLpVHA7OxroOgD2NxRUcyaMSYGDU5wahzm1zlVBy/71KpFqHFlno1/AUf
 Tk7S4gzP2+sCcC24C2stgMHjnzp9LpDcBIHlFlNvU852DnjY3bBSYwWAZzkoOVu2lh1C Nw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xpdyg0ats-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Apr 2024 15:59:34 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43NFxXdY029213;
	Tue, 23 Apr 2024 15:59:33 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xpdyg0atp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Apr 2024 15:59:33 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43NFqeKZ005328;
	Tue, 23 Apr 2024 15:59:32 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xmx3cd7p1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Apr 2024 15:59:32 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43NFxRhe27066918
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Apr 2024 15:59:29 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 54DD520043;
	Tue, 23 Apr 2024 15:59:27 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1B1A420040;
	Tue, 23 Apr 2024 15:59:27 +0000 (GMT)
Received: from [9.152.212.201] (unknown [9.152.212.201])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 23 Apr 2024 15:59:27 +0000 (GMT)
Message-ID: <6300ad008ed0822e3cfb93a57e16745510dff441.camel@linux.ibm.com>
Subject: Re: [PATCH v2] vfio/pci: Support 8-byte PCI loads and stores
From: Gerd Bayer <gbayer@linux.ibm.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Niklas Schnelle
 <schnelle@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Ankit Agrawal <ankita@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>, Halil
 Pasic <pasic@linux.ibm.com>,
        Julian Ruess <julianr@linux.ibm.com>, Ben
 Segal <bpsegal@us.ibm.com>
Date: Tue, 23 Apr 2024 17:59:22 +0200
In-Reply-To: <20240422174305.GB231144@ziepe.ca>
References: <20240422153508.2355844-1-gbayer@linux.ibm.com>
	 <20240422174305.GB231144@ziepe.ca>
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
X-Proofpoint-ORIG-GUID: 9-odmDINHHJ3gKzDZSoa6-wA3JiKwOgN
X-Proofpoint-GUID: ImA8AYdnkIuKeZXyWWOTRGQt0Bd9_i_F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-23_13,2024-04-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 adultscore=0 lowpriorityscore=0 priorityscore=1501 mlxlogscore=894
 impostorscore=0 spamscore=0 phishscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404230037

On Mon, 2024-04-22 at 14:43 -0300, Jason Gunthorpe wrote:
> On Mon, Apr 22, 2024 at 05:35:08PM +0200, Gerd Bayer wrote:
> > From: Ben Segal <bpsegal@us.ibm.com>
> >=20
> > Many PCI adapters can benefit or even require full 64bit read
> > and write access to their registers. In order to enable work on
> > user-space drivers for these devices add two new variations
> > vfio_pci_core_io{read|write}64 of the existing access methods
> > when the architecture supports 64-bit ioreads and iowrites.
> >=20
> > Since these access methods are instantiated on 64bit architectures,
> > only, their use in vfio_pci_core_do_io_rw() is restricted by
> > conditional
> > compiles to these architectures.
> >=20
> > Signed-off-by: Ben Segal <bpsegal@us.ibm.com>
> > Co-developed-by: Gerd Bayer <gbayer@linux.ibm.com>
> > Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
> > ---
> > Hi all,
> >=20
> > we've successfully used this patch with a user-mode driver for a
> > PCI
> > device that requires 64bit register read/writes on s390. A quick
> > grep
> > showed that there are several other drivers for PCI devices in the
> > kernel
> > that use readq/writeq and eventually could use this, too.
> > So we decided to propose this for general inclusion.
> >=20
> > Thank you,
> > Gerd Bayer
> >=20
> > Changes v1 -> v2:
> > - On non 64bit architecture use at most 32bit accesses in
> > =C2=A0 vfio_pci_core_do_io_rw and describe that in the commit message.
> > - Drop the run-time error on 32bit architectures.
> > - The #endif splitting the "else if" is not really fortunate, but
> > I'm
> > =C2=A0 open to suggestions.
>=20
> Provide a iowrite64() that does back to back writes for 32 bit?

Hi Jason,

unfortunately, the nomenclature in vfio_pci_rdwr.c is not very clear...
vfio_io{read|write}64 are mapped to io{read|write}64 as defined in
include/asm-generic/io.h prior to my change already. OTOH, looks like
vfio_io{read|write}64 are consumed only by the
vfio_pci_core_io{read|write}64 functions. This however is an exported
symbol - that seems to be used only as vfio_pci_core_io{read|write}16,
so far.

vfio_pci_core_io{read|write}X is also used by vfio_pci_core_do_io_rw()
which does "bulk" reads/writes using the largest suitable access size.
I think there, we can live without 64bit accesses as the while loop
there will use 32bit read/writes back-to-back as applicable.

So I think 64bit accesses on 32bit architectures through VFIO are
somewhat uncharted territory - and I'm not sure that back-to-back 32bit
accesses are the right thing to do. If the device defined 64bit
registers, you could trigger side-effects in the wrong order (or not at
all).

Somewhat overwhelmed,
Gerd


