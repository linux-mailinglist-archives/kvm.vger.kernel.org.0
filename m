Return-Path: <kvm+bounces-10522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4497686CF73
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 17:40:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4A108B270BF
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 16:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D179270AE4;
	Thu, 29 Feb 2024 16:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="D1ELQ90Q"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2049.outbound.protection.outlook.com [40.107.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0448470AC3;
	Thu, 29 Feb 2024 16:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709224149; cv=fail; b=mWUcEJWTAppcPxrgE2lUn2qYJqhfJZTf4/kcKlm9oOs2Nr9vJjRIXPsja3E5jVe5ko8SjfMJG1ykNQqc9AQ0rj+1DQn5njI+7hSdpK4AX3S4kMu1dA0NqwS3mIWOMw2kZ5N37K/A7VdFmJBHw2uI2UxHKcRWWp5H3p2aJ68O0r0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709224149; c=relaxed/simple;
	bh=hve+xvBKTxM5PVZ6iUVdye9neb/OZl1OBRmyNfiBW5M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jHrQWHN4ko0pgpsnTb/4NZFSggLM9iSYEkWivtpvmFSpVZDjO4DaComvhv1sffzWy52YzlzCJ4ZcDoPpkvjw9hs1Xn1bNcB0iTPQU1eez1xTTjaAGw3FvOFWtwE+0WyRTdlLt7VYxqbJaz5hAOL4RH8hNuJMRd0oP+aZ9hetkss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=D1ELQ90Q; arc=fail smtp.client-ip=40.107.220.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E0cgcCdzyMHKawIUHYOh0JCLYcKseNs08KZ1AH1E1NyJIeP1JpWRqThieKDU2pVq1hbqAAksP9w8LhX8BSro/rL7wAWxYuMkK9BgFQgNL/29xEBU8dPlSfFpJ/oYUj7guOmaaNGiKZGLb0Jca2b1wLKBprmm+J/hV8RkDI1TSeoIzptDtkduEg79Snz4Jy1Iai+S++dZBZX8rj1wd3FRHRRl+S47hgnRmURSyxHvdc5rt0nVhDPJ5CRCNFBti9rbign4SWZB/h4jX8e48gMGvUo7Unum5Rg5iahB8yfBfymuHZpHda3e6wCKEJ/AZ2ja4cUDPD780bS3RZqaIEY46g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hve+xvBKTxM5PVZ6iUVdye9neb/OZl1OBRmyNfiBW5M=;
 b=P071q50llGAYNzBIEO+0dW31LTk8ZK5mXnCf2nEqOSQ56bPpB1NyKzN6r2+nJynOkaR/Td2DPjGbBIsnID+BFZLjkIdCJ83Vd8MxEhVn+mkW4fLYL9O42NXMzlhYIW8Lapv8+t1+fKe9bbUYGlBGTehkVKC2jRzuuMlogslspqeCeLgBjoAZdHS0CVoyZtuTX1shq1/30LpQ3GetNKWRzPcdLlmFgMdF1rP8UHSeYwp6cmLwiG8fdUE3A6XZLVFAy48SPxAzaQpTcwx+KDuKOXB4+CiKu4iyxUqrOk4ugvrhQWhdwa8J7DPM2wvUQnu3mA/qDaC/HbaLvYaf11IoYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hve+xvBKTxM5PVZ6iUVdye9neb/OZl1OBRmyNfiBW5M=;
 b=D1ELQ90QjiKsIADgRRDSb32xs150oLWuJxIXF4SHz0GuExwhoWgpEZJAfJaQd5Vf3cEIbSccThfOGvR88bwu+mrxyutHkkwTZBEDY3o9y51pft+04evixK0IvxbtHVbNnX4r+FJa4Rf4DvuFEX2rkhriFc3hMCEk6aO2V+HdwiZqvNngnq47+VXN/gqIOxYOnIW+59WjzNogK/QgvS7C3zk8FFaxHkSAk1HcHgmW3/QU456CaJ+YzCjjO2+x7qqzN0+54HHebhR1dkdsAtcsRT4vbTczsvk9z8L0BDvgpsYQtwja/euF2Ti8yVjknXRqGE6rvRZqE+ySMurbk9BwWg==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by MN2PR12MB4406.namprd12.prod.outlook.com (2603:10b6:208:268::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.41; Thu, 29 Feb
 2024 16:29:04 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::284c:211f:16dc:f7b2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::284c:211f:16dc:f7b2%5]) with mapi id 15.20.7316.032; Thu, 29 Feb 2024
 16:29:04 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Alex Williamson
	<alex.williamson@redhat.com>
CC: Yishai Hadas <yishaih@nvidia.com>, "shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, Aniket Agashe <aniketa@nvidia.com>, Neo Jia
	<cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy
 Currid <acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John
 Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, Rahul
 Rameshbabu <rrameshbabu@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, "Anuj
 Aggarwal (SW-GPU)" <anuaggarwal@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 1/1] vfio/nvgrace-gpu: Convey kvm that the device is wc
 safe
Thread-Topic: [PATCH v1 1/1] vfio/nvgrace-gpu: Convey kvm that the device is
 wc safe
Thread-Index: AQHaan8STeXbyerayU2Kw+zSatmIBbEhesSAgAACnQCAAAUMTA==
Date: Thu, 29 Feb 2024 16:29:04 +0000
Message-ID:
 <SA1PR12MB71990CC60F96FEBFA9CABC58B05F2@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20240228194801.2299-1-ankita@nvidia.com>
 <20240229085639.484b920c.alex.williamson@redhat.com>
 <20240229160600.GJ9179@nvidia.com>
In-Reply-To: <20240229160600.GJ9179@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|MN2PR12MB4406:EE_
x-ms-office365-filtering-correlation-id: bdec695d-8e8c-4b71-e4e1-08dc39438b72
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 hm3HR27jKXDZynHbXwrVd0p9UocD8FxnLzgpUK+JkrDb/Cp3CeXzA0FV9b8Wn/j24bAxziO06uYa9ohPCMQ41rr5jqyFGIzak1u7mIF6pYNpZ6CYjxfcQjqxx8EApQ2gyC7t87uXKfEB4BOXkAMCwxUdoKF60ZIXvgPpvfTqoIl70yXR2mCsjyRTlIAOiDQj16iD2ciczhz0Im7Y9R6iWmIZyLYb3gGX8c+HZZUse/u/BF5+4/XOnLE1YZz27olk2HoSBiQz/srAKOxu2//dTUOrLY+mQnk880n1v9Mil91Evmw9OpwQyOIAypi6iv0UuH2Ak6enUeid1epLG4ucVZpPjr9P3R01bGCBo+4PfUadVEgoiIx3eyU4klYwvqEBVaLaQnN/Eu0ZkD7CxW3CvaZhIbR4/mluOa0Vs8H9KYajvD9Myj1nYf30OBaH0fklvr/U7izHptiPytNBPKjcWuvuF5s5yGMC1fLi9VnT0gQIDVQnNjz+YyCj4q20NEFDgDPp7mXQhLScotyOCvUG+fS7fMpvz76Q+N5/zjBsBDHVD6ame2enP+40JUYGTgSO2qcHxTZiMwzC28AFloEeL/5BjOXiONUn2F/lBIj266gYAYBv2ktJkGlOmYnzrKVFM3Xr5xTT4WWqD094Z6Ud3GsSXBW/bKFpnaC/eXELaLM0UxLs795ie19PVBpPzomcaPde39iCyFK8iwakviGGX50Mzw8jxumRPs8JQWnVySI=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?GwYtnkjb8nZLDjAr/wlrcKynY5Z94gxipXw0K87V+DrTKVRfvNJSflrU3k?=
 =?iso-8859-1?Q?Cywv1hN3Xkqa1WRtrYQZB8BJH9YOPpVV2UbQ5PnildKr1dbrilHNDYbvq0?=
 =?iso-8859-1?Q?/hej4qt/ezQwu/L3RyOHCmp2D5t/wu+1EoUiSlBddPKcOX/Gnzzt67XDfr?=
 =?iso-8859-1?Q?Ijl45Y7XQ/8fjlrQlTYp08BrMCuNQfb2ruXsqRj1c7VYvC3uytGuK7BMhC?=
 =?iso-8859-1?Q?GK9T4l1E265SK96Z6tCaGYSkChF0WbHZzdyIZq9FJt9V9gWbpucAFkh3zV?=
 =?iso-8859-1?Q?Y7cE5ydr2jSi1FIFHGo+pxjFxhDJu2//IyZoeuLELF/I6qVFzUjWmJNohY?=
 =?iso-8859-1?Q?FC8likAAEansbtkXP3acLggsFsJusHsZAKYMlJNhD62beXMhu6YYyFd1th?=
 =?iso-8859-1?Q?sa87QDoeALyN3Ahdu+pivNFk4c94hXYHTawYA4pYo2Yq4BGzVgXwC3ghAV?=
 =?iso-8859-1?Q?KXtVgk6cTY+C0UPAEgppl1oFbNP7YNmv374jeEVJ/rWP2kffMwf5nWlrhj?=
 =?iso-8859-1?Q?Sfk1/hhaeyqFwRwWtNEcbojfeV9JcntaUuOngSoDjtdJdKlMwN3ITJ2oKK?=
 =?iso-8859-1?Q?pPaHOZcsmhNY5qS5Tb6FS2kSfyCjAZUl759/BLn16oJvAqAJkjGsBk24Hw?=
 =?iso-8859-1?Q?5koY/Sqxej+Y3uO10GNBZdEQrj35Qqw5On09t3WW+Aco229mL6zeweOMoN?=
 =?iso-8859-1?Q?h5zhRreGLes7wnulWb25qCLG5598ReAiSu/sz6i3N+uDZwC5Zq3PSX281a?=
 =?iso-8859-1?Q?+D8F9glZHJRju6LslSupTqFF9CsCp91A4aKVgK3N0ZFnmjxep5MQZoXRLG?=
 =?iso-8859-1?Q?Dt5dGq0Ec2nFTr+fh98cEMgmQzxLjHa8aFnePSrtZ2+4izgJP/TV+jSqWs?=
 =?iso-8859-1?Q?m3bneNM45TxXaondAMif2UJeOSVzl7q7c5oZArofiqtNy02pnMlWPrzk7U?=
 =?iso-8859-1?Q?5RgFg4WzCUuCMSXwEmdlQFOtIfSMJuwMx5FK3ZdIW5QK1qIXodhbB+I0v/?=
 =?iso-8859-1?Q?VJFCGgw8MVrINOwowGeLIrdtXYQ8AJGv4Y6LycYmXD2dE7x500CXf+Wo6v?=
 =?iso-8859-1?Q?kW3mZfDyOZhJ3y86tlAG53O/KRBpjgcFW/XD2E8sjd18Xl55Dtkk7ZqaFA?=
 =?iso-8859-1?Q?FtctJbMIRmRCTYQMJPvyt7GtKvR8cy1CJyy9Nch7n+En2UuGX+6HXJuSD0?=
 =?iso-8859-1?Q?7xTngtYiH7f3Bp04cdPJMaCM9LRe+6dWZ2gnh9l/+82eKZJBa42ZczHBmP?=
 =?iso-8859-1?Q?BGjIv9dHMwv//iakqWObY+wxTQOZGi3MUam7ZlKlxf3xQ/NtvXBDxe2j8K?=
 =?iso-8859-1?Q?sDF+kSwNgqMaVT8DL5ot9JwBRqgurWZ6oeujOWQXdrrmo8iArSlRB9LrG/?=
 =?iso-8859-1?Q?YmZ/15ucglCAV7JIrdsCxq3MLGWWPoKM0zyCawyGFTDnsc7iroKhefmX7F?=
 =?iso-8859-1?Q?tB0q7RCfzAjoRecAdxRIv4uwv4rP4UzwsmPjKRMTPU18J3FOLGE5RBx3Yt?=
 =?iso-8859-1?Q?TSjma46+U64ZHCGn87DGhTVfBhsF1hAkRNbdEmpS0rtKLql+cMygJzvV1e?=
 =?iso-8859-1?Q?iV9YnZupv2fVAL3aS5Pg9V2s39JC1zvbfPZ6BRAw4DLL+XULxRU8QwfG/y?=
 =?iso-8859-1?Q?WUK5kb/MNqGDc=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB7199.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdec695d-8e8c-4b71-e4e1-08dc39438b72
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Feb 2024 16:29:04.4890
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GpJbdJeY+J1wYM3yj5wEVbsscxQdvopSbMvw1Czfk4HWqBTIkttHwy+zTYYmxTyz6zjcUdofJxBWrD7VGgiD1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4406

>> >=A0=0A=
>> > +=A0=A0 /*=0A=
>> > +=A0=A0=A0 * The VM_ALLOW_ANY_UNCACHED VMA flag is implemented for ARM=
64,=0A=
>> > +=A0=A0=A0 * allowing KVM stage 2 device mapping attributes to use Nor=
mal-NC=0A=
>> > +=A0=A0=A0 * rather than DEVICE_nGnRE, which allows guest mappings=0A=
>> > +=A0=A0=A0 * supporting write-combining attributes (WC). This also=0A=
>> > +=A0=A0=A0 * unlocks memory-like operations such as unaligned accesses=
.=0A=
>> > +=A0=A0=A0 * This setting suits the fake BARs as they are expected to=
=0A=
>> > +=A0=A0=A0 * demonstrate such properties within the guest.=0A=
>> > +=A0=A0=A0 *=0A=
>> > +=A0=A0=A0 * ARM does not architecturally guarantee this is safe, and =
indeed=0A=
>> > +=A0=A0=A0 * some MMIO regions like the GICv2 VCPU interface can trigg=
er=0A=
>> > +=A0=A0=A0 * uncontained faults if Normal-NC is used. The nvgrace-gpu=
=0A=
>> > +=A0=A0=A0 * however is safe in that the platform guarantees that no=
=0A=
>> > +=A0=A0=A0 * action taken on the MMIO mapping can trigger an uncontain=
ed=0A=
>> > +=A0=A0=A0 * failure. Hence VM_ALLOW_ANY_UNCACHED is set in the VMA fl=
ags.=0A=
>> > +=A0=A0=A0 */=0A=
>> > +=A0=A0 vm_flags_set(vma, VM_ALLOW_ANY_UNCACHED);=0A=
>> > +=0A=
>> >=A0=A0=A0=A0=A0 return 0;=0A=
>> >=A0 }=0A=
>> >=A0=0A=
>>=0A=
>> The commit log sort of covers it, but this comment doesn't seem to=0A=
>> cover why we're setting an uncached attribute to the usemem region=0A=
>> which we're specifically mapping as coherent... did we end up giving=0A=
>> this flag a really poor name if it's being used here to allow unaligned=
=0A=
>> access?=A0 Thanks,=0A=
>=0A=
> Yeah, I sugged to fold that hunk into this:=0A=
>=0A=
>=A0=A0=A0=A0=A0=A0=A0 if (index =3D=3D RESMEM_REGION_INDEX)=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 vma->vm_page_prot =3D pgprot=
_writecombine(vma->vm_page_prot);=0A=
>=0A=
> So it makes more sense. VM_ALLOW_ANY_UNCACHED shouldn't be used on the=0A=
> cachable mapping. The comment should be more specific to this driver=0A=
> and not so generic:=0A=
>=0A=
> /*=0A=
> * nvgrace has no issue with uncontained failures on NORMAL_NC=0A=
>=A0* access. Tell KVM to open up guest usage of NORMAL_NC for this mapping=
.=0A=
>=A0*/=0A=
=0A=
Sure, I will restrict this to resmem. Also will update the comment accordin=
gly.=0A=
=0A=
>=0A=
> Jason=

