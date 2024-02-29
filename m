Return-Path: <kvm+bounces-10523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B062686CF7D
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 17:42:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 91F68B2CBAD
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 16:34:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4581378282;
	Thu, 29 Feb 2024 16:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oOT/Llwk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2076.outbound.protection.outlook.com [40.107.220.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92846CBF4;
	Thu, 29 Feb 2024 16:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709224274; cv=fail; b=BZ31Hqa49WcJS4aGt+n3qOgmHaxMvRrTnMCJlP/wnRkquIv48xoGzoMSAeTRMiOVwweUSBkzqfZddVRZM3pzSHiqCkFtJhxqfwmV5nFGg00ZErP/odZ2ru0+tSI/1TymCBmIaMSN5aC5eZUbSntzOG9nz/5QHQRRE+Ke6J6zLQU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709224274; c=relaxed/simple;
	bh=Ff2sNFQW+idcYqc0Cf7TGscr2eX0Y5u1hP5Oh+UpWp8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=akBsucMgsD8VXjh9PZy3EZMV3oMH9in5o3DAn2DvQ589/m6xpUnyWHMEqVbct534Wg8BQxzHKXaTWHI6269J7q3uN2iszFMPlFr5MWjPs/U6sNk7K+wUL9fYBvopdrpO2okqFtPgMLyQLDr8aqyQnH1xB1EMUwmxNLxoQ3Ltd58=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oOT/Llwk; arc=fail smtp.client-ip=40.107.220.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kzTF65pxz93ep7e7HYsndxQU4cnbStjGwrnSN9VV9aK9ejnNca9I/oh3bZ1LvS+W+Nmx7jL3NDCG7/UTyg63udCfQi0asReVd4jC8L0D+DfperBnlg06151Y32wTEVFKpLSj+OyGyfRUIHg0w7PSZbsVSFaTv5Z72Ce9L3rXvxXRmBhACp42lnlbuQ1wh+VT7Dv+a626NTZLxAYlO5opg+5O4zFFy6Xu+2b+gWdIgAdEQ0dmXfXWm0PO3yDvt6C+WG5d4e/5vzX0TpyKQcaQ8mpF78gBnOMHvibyd68qMtAd+AcLoYErv+FuaHw4aL36Wi2fmoEj+ZdN27sTN1huMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ff2sNFQW+idcYqc0Cf7TGscr2eX0Y5u1hP5Oh+UpWp8=;
 b=D/k04H6Zcg3Ohn5ygbJStrNwzwEwHpG7EtZvKFEPwa0OcoLbop84R8swDh4Z6f9w2nJPn0ABlc7WBQ263I5Ph4nE9dG+7JzGAiSVoZO4lPHL2kuBAym5MFddcl6FAg4gj+0ORvbqUp5r7LjQ2sD7vIy9jpjBpMmGdcJV7tCU//wyvklmlPpVXpJM7dq/wpQ5yp3eAsU26AOIDXAiy66qFg73NAz7+/t9T7vSgCoBHjmgzCRwZQzzBGQmjzJC0CGhYoHEZZ+ywBEt69VBfmhW9m7vjrlVyAf7FsJxBOC4CvOL7HnngHatUOIexehuXRpffaZRou7rDxfq8KvH5wnFeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ff2sNFQW+idcYqc0Cf7TGscr2eX0Y5u1hP5Oh+UpWp8=;
 b=oOT/Llwk2Sts9kRPBvxQhcCITqELidm0cu8CLWmByeSFYkawof4oak8tclJq74merrdO5ZgwCPC+uq+xHakWtYVZFYu/97n1Qiln8iNMIJucK0Uw7jnOOdcEa3KjBAITBXTglci8t3ANdowEiGlBYkBMZc7EkuzrJCVD2qT7x6Y+cwdsL7VKCjjy5BJEeihqcu3/Wxozq0WtfHr1fuhGJicqr5XVr/BMcAR3/xHK5PrJr38P0kthjZWFI4KxcEuEivq+CFEMqFJTNRxcLfftW/dm6IjoJ88Nrm7DZK+gNdsvlVYGwa6bvJQFPpCUzRk6FGG1/3BzuxMrB3xZwW5LEw==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by PH7PR12MB6465.namprd12.prod.outlook.com (2603:10b6:510:1f7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.41; Thu, 29 Feb
 2024 16:31:09 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::284c:211f:16dc:f7b2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::284c:211f:16dc:f7b2%5]) with mapi id 15.20.7316.032; Thu, 29 Feb 2024
 16:31:09 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
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
Thread-Index: AQHaan8STeXbyerayU2Kw+zSatmIBbEhesSAgAAC+YCAAAYi6Q==
Date: Thu, 29 Feb 2024 16:31:09 +0000
Message-ID:
 <SA1PR12MB719972594616B5BF71356243B05F2@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20240228194801.2299-1-ankita@nvidia.com>
	<20240229085639.484b920c.alex.williamson@redhat.com>
 <20240229090717.67b9c2ca.alex.williamson@redhat.com>
In-Reply-To: <20240229090717.67b9c2ca.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|PH7PR12MB6465:EE_
x-ms-office365-filtering-correlation-id: e1388342-dd08-4dc6-5c40-08dc3943d5f9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 Cx0FFJ3LgH4IwPLC+ozsSIfjcv+rI4hKZnMC3UUic5BHNK5oTJdP4/RmnA62udFBgB5QMDShGuKoHjqp1nO4DbNx6ubCSAJ6NK5lnIGHEBDkRCaBu88s/3g24BlsJjI05Xgnqw5JZxEDFuLxi9xVJrDw0n7p82uQ9a5YcDHxP/wRBGgWjNlauInTbz2OXmxPxc44p4Enfx17O48q5sRPs0w8rwh/UMsijFKCnD0afgW7hyiSEujXMRl8jjGBDZpCAuPA6+fPAsu0O9ypmD/vqlIkE7jMUVdKVVt+ju+mXepECXDIm8Mvmyb3fwzS3N15SuMECYHI8Wy+oyxqjLQlifNr2Sj+GMOju5QHKun3ouPrDVKnGVEgAwbKSibzZdgH9FuHEuWtVomcbIftUZqO/S2oO/4aCRBsm43C7DGBUGF800U6CGg9DcKdwoK57ND1omBhuLOOZJXggIdJwjOLoDPZHjNQwr28Q44IqF4KsLoXUyDitw5F0kD9gLmsxgA29QzCk4lJXHwpXKErhlyIJ2RH07Yc+fbgyVNNtlP/r/FBuojsybbdHSD6EZeA1dEvWC1C+kmG17hLxpi//KYZM7E6AQq4j4wxOOCAplrj4rJZ4HmmDntb8NP2n2Mj/7BMm5b3tyKgElnmOwRhqgBVsi5m9hCj4Qhm22BG5VNvOaKReueIgYpylqOljkGcsRaI3i2WSDKziMJXiH7rUbqyDQSyFEbbyrqyN5JbQD9fn74=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?ukYf7fQIn5fbQ9WDJds07NrAByw6q9sSIGvhchw5EP0WqOTIzkrR3qkGGA?=
 =?iso-8859-1?Q?Ve7GWYhlNmXt3AYy6dxVBgsIruQ1OmH/+E9aMx9dkCV1CP6rgMQEJLq8Lp?=
 =?iso-8859-1?Q?coyZDMX/sDKi9pudxnjuHp4zTMqFHtErVPxW7oa+sCYAqYWTvKQt2BIl/I?=
 =?iso-8859-1?Q?bN+LzNbRo4THfgei7lZB68yNMAye5G3XV3bw2zTavyn7krLVetShT5Bb7f?=
 =?iso-8859-1?Q?lrsbUZ1wFvDFcPFWuqoM+hfcSUVDfiNn6aJTKdpEWmOaafIo7ULj2uDmZ9?=
 =?iso-8859-1?Q?gyv/3J0W/D2l9eiKVqdc792xESyaDbsgpuAF1xm83fX4rGwSegYcy4gVVM?=
 =?iso-8859-1?Q?h0QOUyX4FNazxs/qLsaLXIXMy99Mkyu+egOxockwWgj0djIg9GtXFzfct8?=
 =?iso-8859-1?Q?dvbUq0VAxcqEf+YCmSaF4F9M9oVRzyQgKh3CJlwj3AoV/wAdLhqYhN5Cvz?=
 =?iso-8859-1?Q?l4KTtyt/I0XrFlNXMSmWS1et6XTBh/V6bT8UUjuJNlVtuW8ZnhezeNT2Ht?=
 =?iso-8859-1?Q?TwkrBcrpyqb8LWPVRDgPu1hdfVOjbR5efeWPmdJFp5qH2Wv4JXWDqjXS7f?=
 =?iso-8859-1?Q?PtsOJm9Hd3JVg5dc7jy0wrDw5pmNYYtnswUtmvzN+BmEAp5bN4ToOzXOqA?=
 =?iso-8859-1?Q?pHSzdhiZ9ZHSZrSvTVe9b2o0xy1Nc1+6aysUe3R8d4nKZgygz3luk8jlyf?=
 =?iso-8859-1?Q?TzDzRTPZumEe+BNA6RPFFu1V5spsESayMSl0N11Ytiqv9i/hUpeDKs0tAy?=
 =?iso-8859-1?Q?pJ1uKbvNbDItgyC6i7cOJPY5yc13pEcaQA/418TTADvUh2A4aoRJDHITec?=
 =?iso-8859-1?Q?TR9yHysoeMaenzHf9pq7b9Q37R6o5nZxSIG3sRKlLFa+V3p8UcswxduKlW?=
 =?iso-8859-1?Q?tCbmYNMpDRG9K72bVyIxf+6HBc5S2TaIME1JRr66Fa0Z6O4O5e0beQTVAu?=
 =?iso-8859-1?Q?VZyHQB4o3oHjKC86hWPl5LTgIlisEcN3wrd2fk9CIn7X1hratZcR3adgO0?=
 =?iso-8859-1?Q?85j4tY3IO6eDp8hb+5WXV72jBhnczaniL79voMVRyS+NB8foX+cCPZ7qrt?=
 =?iso-8859-1?Q?n/Spryq1m2HT5f3V3y2MWfgwj5pw+JtR88OpoKOJv7hOOfRqIjm4k/XBXX?=
 =?iso-8859-1?Q?G5jhPW5SxJRm9nR53FWy5tsqLD3J55Pl9nlYLDAG1Lpkm7oMM6HUUIdpPk?=
 =?iso-8859-1?Q?Grln9t6ACW+d6hP1io0yhWXSvX08We3UbI7JfhW5seUC5ZJj/5BV49RmvX?=
 =?iso-8859-1?Q?Iw5dn4sNEwhImEfax++wAkHOmkRVlBAk1dSzRiA2bcLFhNzqHwcwInL9Mw?=
 =?iso-8859-1?Q?QWpcTy0IfSfSO5O/jTHmN3loMpIUVe6zakwzs0p8bbAXJekS0Vm7wiF18Y?=
 =?iso-8859-1?Q?rQIhaMWUj3NLq2zn4xkSHb5VPmE9wAQqnCatNMh0QiHDPvQW8S7mxUhgu/?=
 =?iso-8859-1?Q?cnpjKhzlsgsiUBLRpE6ydjEWd4YW/hXc7rXGmmy3qpvy8b5L2/mL7Wi5Ui?=
 =?iso-8859-1?Q?EcPx9z4QYZYKFMGNSx+dcKY1KcBJNg0M3Ef1eEvsyfSsbM4qm3RIPn5g0f?=
 =?iso-8859-1?Q?7QygrBVLy9rB2tcpHRpCBXZ5961l0f53S37yYyOc2fkpoUuisf3304VD+l?=
 =?iso-8859-1?Q?RPnBSq9IaMlTg=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e1388342-dd08-4dc6-5c40-08dc3943d5f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Feb 2024 16:31:09.5168
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wxI60WQ5djiSttmEXA9uNQKapU1UFrlb+Jhfe5vLmHKqLIgDfC8qjN+HFRpv+zXr8q8hXnPSb2S1DKgMdwNOEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6465

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
>> >=A0=A0=A0=A0 return 0;=0A=
>> >=A0 }=0A=
>> >=0A=
>>=0A=
>> The commit log sort of covers it, but this comment doesn't seem to=0A=
>> cover why we're setting an uncached attribute to the usemem region=0A=
>> which we're specifically mapping as coherent... did we end up giving=0A=
>> this flag a really poor name if it's being used here to allow unaligned=
=0A=
>> access?=A0 Thanks,=0A=
>=0A=
> Also, this is setting the vma flag *after* the call to=0A=
> remap_pfn_range(), which seems quite sketchy.=A0 Thanks,=0A=
=0A=
I will move it to the block that Jason pointed.=0A=
=0A=
> Alex=0A=

