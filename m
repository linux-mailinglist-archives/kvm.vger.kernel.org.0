Return-Path: <kvm+bounces-54691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E4CAFB26FE1
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 21:56:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 28B791CC644D
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 19:55:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FE7D248F74;
	Thu, 14 Aug 2025 19:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tMXLEr6D"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DFFC319860;
	Thu, 14 Aug 2025 19:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755201317; cv=none; b=RwCpGhbSQoqFNp3MvOszEi6sQDpEKWbokAM22kXiJu5RG/Em+NOwW7O/0K2I3+i6F70iZ+goDBGUQIYEbshHdh+9uwAto2TFC+jBfvgrEHvZnO2kyAFkNRzJbrUY5PaLgjUJiu0agLM6i2Jaoq/DQFdJeyyyD4fqRGldLA4D6Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755201317; c=relaxed/simple;
	bh=0i8cW5M5m+7JEgSkZFyO/032aF8/lsoFSFhI6mCkEek=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=H3q8wKxGaHU4axaiwahmineuHn4fukE50/yirQ15Vl4xfYJVGOwPHvRy4uuI6BAiTnLv/jo8q4loZEP7mWWgoeTVYV0XAEher452o/3cZKP/iVsmbm5bgU6fjtqAumC71UJyogrsrzAYJFTbMIoHEQ0EUBAfGg+i5xlEV54Ioo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tMXLEr6D; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57EEVbjI019333;
	Thu, 14 Aug 2025 19:55:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=38HN9A
	F5z4GEPvqgX9Vr6GaLmIlpg2FTE24xMYLPJJs=; b=tMXLEr6DXt9pO3ir6VdwGK
	heLS5ziuFkmuFwGGnt2Opy3nEeBGKsjeraRcewGFSHofqDlVX2bkt640yhYbZHui
	VLFKSKueo5Wk+Aa84gxnJ3edEsOic4FSW9yeY7N+nmLRbyw+/lTNKbXz3twMC6cV
	vnSefQLWEhz2j2E/LOsfQpIoziiGpO/UgQQun1jg4JXYNW1hX8DmcawPc1K34l99
	lsApaqlMoxZud0plaA7xb/7DYctiVilpI9lhiMxXrLrz6zr8H4M/idW1tTkQVWW7
	ikcuTcX4g1LZMgKYYfehLmooLSaSHth/0sxkVAVePObJXjwQWr+56qiKMZ+9oWeg
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48gypee5pv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 14 Aug 2025 19:55:05 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57EGqQog010622;
	Thu, 14 Aug 2025 19:55:04 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 48egnux09u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 14 Aug 2025 19:55:04 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57EJt2hp7865038
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Aug 2025 19:55:03 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B112158067;
	Thu, 14 Aug 2025 19:55:02 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 72F3E58052;
	Thu, 14 Aug 2025 19:55:01 +0000 (GMT)
Received: from [9.87.142.31] (unknown [9.87.142.31])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 14 Aug 2025 19:55:01 +0000 (GMT)
Message-ID: <d6ca10cd8b131fabed1c5dba5917b95a3df95324.camel@linux.ibm.com>
Subject: Re: [PATCH v1 5/6] vfio-pci/zdev: Perform platform specific
 function reset for zPCI
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Farhan Ali <alifm@linux.ibm.com>,
        Alex Williamson
	 <alex.williamson@redhat.com>,
        Bjorn Helgaas <helgaas@kernel.org>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mjrosato@linux.ibm.com
Date: Thu, 14 Aug 2025 21:55:00 +0200
In-Reply-To: <350a9bd5-c2a9-4206-98fd-8a7913d36112@linux.ibm.com>
References: <20250813170821.1115-1-alifm@linux.ibm.com>
	 <20250813170821.1115-6-alifm@linux.ibm.com>
	 <20250813143034.36f8c3a4.alex.williamson@redhat.com>
	 <7059025f-f337-493d-a50c-ccce8fb4beee@linux.ibm.com>
	 <20250813165631.7c22ef0f.alex.williamson@redhat.com>
	 <5c76f6cfb535828f6586a67bd3409981663d14d8.camel@linux.ibm.com>
	 <350a9bd5-c2a9-4206-98fd-8a7913d36112@linux.ibm.com>
Autocrypt: addr=schnelle@linux.ibm.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-1.fc42) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=eaU9f6EH c=1 sm=1 tr=0 ts=689e3f19 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=qSN40DPSLCjNzlicjagA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 6UOYz480YT_XhDGQjbyjkdWSLf_EAveW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEzMDE2NyBTYWx0ZWRfX+Tfm1H+klyfL
 wXA317dtA1nJS3TfZrJD1tLQbslJIbW8VkRZCk3UEOY5qGOlTiVlTMZA5QnjzKYcBM4PaX21cz1
 TDvz1eGuQVqtb08E0cQjNdbfN+AswK49i7h6UZxyD4lwM3trq3m7QPWLMV1OynXbolQpSDGEt+c
 /F8mrGnqFkjHUngsETsvgWDyx1zqd+vWYMJs9QUWCb7rkson8dI3MXITok6EqibOZyvKZ7GyHSJ
 tQlAgUR5coJGlvYbc6aK4Ha+5pCIxDP0NaB64WwsAplZ9LhdRO/BV3YI7OfYCMi0BUMkVwxqDmY
 I3TYGhwdHeIVl9vEJzOmNJinEnVRVAGFjEz9+uIxduFc8Efy+eFsg5LUaoeewl9Qqg7G3X4KfsF
 +ZdQJW3B
X-Proofpoint-ORIG-GUID: 6UOYz480YT_XhDGQjbyjkdWSLf_EAveW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_02,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 clxscore=1015 priorityscore=1501 spamscore=0
 bulkscore=0 malwarescore=0 adultscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508130167

On Thu, 2025-08-14 at 09:33 -0700, Farhan Ali wrote:
> On 8/14/2025 6:12 AM, Niklas Schnelle wrote:
> > On Wed, 2025-08-13 at 16:56 -0600, Alex Williamson wrote:
> > > On Wed, 13 Aug 2025 14:52:24 -0700
> > > Farhan Ali <alifm@linux.ibm.com> wrote:
> > >=20
> > > > On 8/13/2025 1:30 PM, Alex Williamson wrote:
> > > > > On Wed, 13 Aug 2025 10:08:19 -0700
> > > > > Farhan Ali <alifm@linux.ibm.com> wrote:
> > > > >  =20
> > > > > > For zPCI devices we should drive a platform specific function r=
eset
> > > > > > as part of VFIO_DEVICE_RESET. This reset is needed recover a zP=
CI device
> > > > > > in error state.
> > > > > >=20
> > > > > > Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> > > > > > ---
> > > > > >    arch/s390/pci/pci.c              |  1 +
> > > > > >    drivers/vfio/pci/vfio_pci_core.c |  4 ++++
> > > > > >    drivers/vfio/pci/vfio_pci_priv.h |  5 ++++
> > > > > >    drivers/vfio/pci/vfio_pci_zdev.c | 39 ++++++++++++++++++++++=
++++++++++
> > > > > >    4 files changed, 49 insertions(+)
>=20
--- snip ---
> > Now for pci_reset_hotplug_slot() via VFIO_DEVICE_PCI_HOT_RESET I'm not
> > sure why that won't work as is. @Farhan do you know?
>=20
> VFIO_DEVICE_PCI_HOT_RESET would have been sufficient interface for=20
> majority of PCI devices on s390x as that would drive a bus reset. It was=
=20
> sufficient as most devices were single bus devices. But in the latest=20
> generation of machines (z17) we expose true SR-IOV and an OS can have=20
> access to both PF and VFs and so these are on the same bus and can have=
=20
> different ownership based on what is bound to vfio-pci.
>=20

Talked to Farhan a bit off list. I think the problem boils down to
this. The s390 PCI support, due to there always being a hypervisor,
does hot and cold plug on a per PCI function basis. And so the hotplug
driver's reset_slot() is just a wrapper around zpci_hot_reset_device()
and also does per PCI function reset.=C2=A0

Now when doing a VFIO_PCI_HOT_RESET this still doesn't give us a usable
per function reset because vfio_pci_ioctl_get_pci_hot_reset_info()'s
grouping assumes, quite naturally, that as a slot reset this will reset
an entire slot and so the ownership checks fail when we use this reset
on e.g. an SR-IOV capable device with PFs + VFs where s390 exposes
their PCI topology even while retaining per function hotplug.=C2=A0

As some more background, we've had the virtual PCI topology for SR-IOV
capable devices since commit 44510d6fa0c0 ("s390/pci: Handling
multifunctions") added in v6.9 but only with z17 will they be generally
available.

Thanks,
Niklas

