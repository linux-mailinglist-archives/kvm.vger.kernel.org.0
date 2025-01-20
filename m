Return-Path: <kvm+bounces-35931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CD50BA16555
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 03:24:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7ABB87A24F8
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 02:24:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDA5A41C71;
	Mon, 20 Jan 2025 02:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XGlXC/Vb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2071.outbound.protection.outlook.com [40.107.244.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE0E8F6B;
	Mon, 20 Jan 2025 02:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737339860; cv=fail; b=XPM08RpiBiUlSGlj4TY+FpIozhH7vKz37hJ+UeSM7qpMJ6563/hVlt+QKX8psgV7juWt9KEPn44WMdgUqYYjGfN3Av+1YpY/HFAEYKUawT2Hb564XuHq/fx3uYlWvBsxWFFQ9W1ub7oXUUHj1mIY4yePeFsTr6Xo91Q4aXCofFE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737339860; c=relaxed/simple;
	bh=6Drs3dTKkUDrJd/Dxg1J8oAz2hJG5OjxfVhUUEAzLkE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=A36bmdhd8DG8L1etWZhWSmIxEf/LZj9g5B1L/h1VOHOJqXHRTdiMRMXbzlAznQNIJb9MUO+iboz8Lh1h9A90ZYl8GB/jzxHPD5Df6zqNZhApnXLFLWz2Dlf9fnt45PSP4gKeXPrDRr9Guf86I5gD8TAdUF02fs4alsj9TuQAopI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XGlXC/Vb; arc=fail smtp.client-ip=40.107.244.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wp+IdHufUgyV04SL6JGM91sNLShvu39zZ+H3VSDR6msZ8E6jWLaB/IMm/loQei+um8ue+hUYFC24Qi2NIW9LHvYkbHPr7x8wbGgpvvqoEGGpKxzYW/xjerdjkWjNkyZy4FoN21KNcKfJ1/wY2p2pc9zhHcXxL47d17VgxNVdVPiQFaiv8ZWMTa5zc27pUfKdqVF8ifuTZYeDszc5Un9GRrtnPtsMeL/U4kGXIZuS8/6prHwDli38aBPi3cyM0kwBIXIaiv4z+jMI8W9qU4Zydm6zxka1qPe9BlCU2q1QVycRxShhvjoF/V5DUra0Cuh5ucUF3ZFBJaE9F2ZBx9dekw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Drs3dTKkUDrJd/Dxg1J8oAz2hJG5OjxfVhUUEAzLkE=;
 b=xGsSCv95KaAHQ/w1kvi867qVoJXFWxSJp13cMT7fZTt97HeM7GK991BVkiz1TV6XJa6D/kHkTdOBFDZ/PnDOnEv2M/U9/2M2kC7BLuIEWVHtwa4DXx78amEHzJhbh06tHjItAGV+hxoNOmUVXRfAiNg4nKaynMLNNT836wHz48dREsn1vjEl/L9v7xC5yliY6PYGesTRyxdJi36CGfEFFPkviN71qzkshL5X5ySNPObZ58RE18j2HRSvD5LiopAldNNglxYm7rfpjr6gfe7fh3ikeKAje0iP0av9fheV/dWVD0r+UPbDIW2FrPahBcrLo/9CUK73ezvTseIR6qTUew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Drs3dTKkUDrJd/Dxg1J8oAz2hJG5OjxfVhUUEAzLkE=;
 b=XGlXC/VbOY/feeedOFUsr8C7f7j8roUqmfHI0M1Rn4Wg9oDrVqhu2xGD3iJndVRh5aWJ2dSbqV5fYzI/6rK5QIrOx4r6KWf/mYT7WXlSJ8K1p4qt6dBDxt7Wh3AvXi0p2Xf7KuZhvv9BLcTFgovJFX6c6nng7mH/v5AssmI30HRjK0eRkCC8ZKMfJKk2Pxoutm+fW3UuVdGOeTNjUCi3TxQcITaAZ8RjzuGxYD+3+oFI7YCpKslY/t0XmaMannl1vHyRb5QWHMo3ysM7EGMinB7bO/QUVDxX8tMt9pUOq1R+iQtEeDFMmBhF96ysfqiyptYpRfjIgBO43nLqvYmw8g==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by CH3PR12MB9284.namprd12.prod.outlook.com (2603:10b6:610:1c7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Mon, 20 Jan
 2025 02:24:14 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%5]) with mapi id 15.20.8356.020; Mon, 20 Jan 2025
 02:24:14 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, Zhi Wang <zhiw@nvidia.com>, Aniket Agashe
	<aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, Vikram
 Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>, Alistair Popple
	<apopple@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Dan Williams
	<danw@nvidia.com>, "Anuj Aggarwal (SW-GPU)" <anuaggarwal@nvidia.com>, Matt
 Ochs <mochs@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3/3] vfio/nvgrace-gpu: Check the HBM training and C2C
 link status
Thread-Topic: [PATCH v4 3/3] vfio/nvgrace-gpu: Check the HBM training and C2C
 link status
Thread-Index: AQHbaTjDvXSIdfxj4keeAz0umh3JrbMbxNQAgAMrU3c=
Date: Mon, 20 Jan 2025 02:24:14 +0000
Message-ID:
 <SA1PR12MB7199DB6748D147F434404629B0E72@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250117233704.3374-1-ankita@nvidia.com>
	<20250117233704.3374-4-ankita@nvidia.com>
 <20250117205232.37dbabe3.alex.williamson@redhat.com>
In-Reply-To: <20250117205232.37dbabe3.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|CH3PR12MB9284:EE_
x-ms-office365-filtering-correlation-id: 00fd152c-4b03-4639-907f-08dd38f98886
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?aUV8c0fYZH9ouM6sOvx4bax8BrfVxaosk78deZt1mpLI/uFpISLHFiKmtp?=
 =?iso-8859-1?Q?mu5mozLuDKoNA1v/3jy8s30d1xRjtm4b3Z8SjAfZ9BUY867vXKnDeMxGIO?=
 =?iso-8859-1?Q?3OHdpmsO13YdPvWJjVgW5c5gH41q4d9GZNINkMivPue4rvhkaVHvlTr5Fa?=
 =?iso-8859-1?Q?0K9NQT+ph6bRP9AW48JqKjOZIupDV/kJDE9teOEIwnBjqbrZQ1Dy9h1nSC?=
 =?iso-8859-1?Q?ziLpbBx7bG0n+nj6r6BWpzsC6qQL/+bKWr3QceS/6tukSKGI3CgDXsfYwH?=
 =?iso-8859-1?Q?hfti7KbCokaMOEv4d7pGBy2NqJxVGgevZ6NX1HdMjS/vzTZKU2djjjPmQ0?=
 =?iso-8859-1?Q?2f7/aNckJ7xaYFIZpC7OA5NIIThmTXW6qzLkX6fS53WbbF4dfBQOFTy+7i?=
 =?iso-8859-1?Q?jD7RVK41RDbrCtkJdfaxoh/x6o5EXriHPncJ/uRYaqTnQMOnn0FfiLFR87?=
 =?iso-8859-1?Q?Pj+mT3vJCJCXYneQvg5JslK+qnorcaWX5eEThnljmKubJU4qZYWF3eJhW0?=
 =?iso-8859-1?Q?dXG2/ChaH64WogGEsY/CCzmFHuu/Hawq8p4saBDdUpb8NA1t1LC7WnvnmV?=
 =?iso-8859-1?Q?ed+YRmlsuczN9nb6qT4iZohyLzPc3xJ/7eVduQU1V+4TxWhFX19Nj8kHV7?=
 =?iso-8859-1?Q?e9qB0elgV7Q7QmHBZeHFbDDYPsX9aPKl5vjzEgUxBsW1SzinnmR4s5UNZO?=
 =?iso-8859-1?Q?c18n4dF4Tw7iqLhgi2qG7PO4UXdCiLVqN57Yl+ZzzhZGUvX54jGu1+zBBn?=
 =?iso-8859-1?Q?BrUG/9ayPXLaq+tIEyXKgyIVJgHox19QdRXycePEuyZ1ttZ/8F5it/EdDl?=
 =?iso-8859-1?Q?Of0Alud0G6ME/g/QEpE7O4+3gCZWYOEBot5aVeRbJo0zRZR7rx1A06/Z1N?=
 =?iso-8859-1?Q?48o4svI3an19vV5qb8TKXem5CPn+8Z3mV48wz9SuCpGt3TxJydL+muarPE?=
 =?iso-8859-1?Q?w7uNT4A86HpRyiOpLROLrgxu3rUjWXyEaI4fsEiCiSvDZITzcM8xT+RcdZ?=
 =?iso-8859-1?Q?0I8kgXOb4b8cGumjcYnWXWhV6Pw7KbTN4CKdd11ZQ8Ee4WkO1RvANKIUOF?=
 =?iso-8859-1?Q?VwI2fgKa21ZXoN1QDIJGvSeXpEsP4kRVuH+rRFYKOI2HsbjrkGalCvKAcR?=
 =?iso-8859-1?Q?Kem9T1xu4cW+KXvJje9b+2TMiUjqRz/+W5ZbC4yale5dNX42Q9hShfI/+c?=
 =?iso-8859-1?Q?9t1+rsttM0tP11u0TicUR/pOjFGFNkNSO0zjKT96StMc2OxEq+5ZyLqbJx?=
 =?iso-8859-1?Q?c1M/kXPAxKCiFSTmS1beu3nPnvSyzZa8zbambXhow5g795VF5bh8ViaWrA?=
 =?iso-8859-1?Q?+GnWjfw6bJ9IpQd1vWHSag7Rcs3G99GJOdVZ8lY7yZGKpgr0Op1cb2U9s6?=
 =?iso-8859-1?Q?8FXLw0uJBQwbHmTiBbibSWQPjTEoWZF4uhkF0lBA7dNr2HECM6gtNiOLAa?=
 =?iso-8859-1?Q?HhuGRBQpGjMtC/q6An4/FhbjLaqwPyzTfFzG15Pj62QPwp5v9JKDSeEtuO?=
 =?iso-8859-1?Q?ncJwyZ3ivc2reFwrlWcS+N?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?yH8lha7xXhwpPWpFZj6wGfP8RVSvv8PJHpq7hi97KbRfVYb3qWgJYEIIl8?=
 =?iso-8859-1?Q?v9+5rMMruQVErmcCZtRx5WukLZQMGRpVaQbKT3XQH1f3hePRpn7EyXq4Kk?=
 =?iso-8859-1?Q?UruGGhWMwJK1hOkZKJ+O1VrJlIJT0L/WQ4qwVwuzctXcDKldSLrQsR5J15?=
 =?iso-8859-1?Q?U1mK4uN8MT1d7HQ99lwN7vWXeyl8cIeWwGg9uoocEgoXCgl4/3aJGd28dI?=
 =?iso-8859-1?Q?AhZJ1ItNWN2jaPDggNMqB1x60+kCbFqr/3H0omG3L3q0lWinBm59TjSOc1?=
 =?iso-8859-1?Q?VrlgiZ92RUDvwbj55VWCTm9HgReyRTeKcwhtKu/PyMW88FZ6Q+LG3sBR+2?=
 =?iso-8859-1?Q?ZCiUw9wlH5KGlyMucu1Jiw+LwC1kisjZyi2K5hY2gJa7WK4wc8uegU+iGT?=
 =?iso-8859-1?Q?FqjV7Hf0Jmyon0e1qXi9tm0+Fo09eJioF7DKdzU0afEL94DiI55xLyUUDz?=
 =?iso-8859-1?Q?yQ4SeiWHGYrQBNzWPOdRnqEgS9YpLfsF9KMN9yRiAvmpbdRgadUFKSv0QC?=
 =?iso-8859-1?Q?edbL4jTeBJPqCM8/axA8c2pkj0kf9SWe4fN9y7cnMvyxb9TCakeJt6Bp4m?=
 =?iso-8859-1?Q?VY/w8zgihSADRAmH++SS6pvx3hqWV/mJG290mijqMDfS5dyYATx4rKbBDl?=
 =?iso-8859-1?Q?/KAMnGgeD4fb6R3uCFBy6bD9n29PyeGr+Mds5VYz788om3N9RS9K/ZgfpC?=
 =?iso-8859-1?Q?MGpD5350wKCDiMXWzTaXUdek4HAgPxtVIdnKpbKSLupN/eG/Y0+mo8PJ9A?=
 =?iso-8859-1?Q?xRyc+2DxIxSk2OxfG+fqHaNc3owBotmZ01bR2hW2JDqlhfMuMcejRFzF6s?=
 =?iso-8859-1?Q?Tn6MW5FATx/k07LwFztQ1LhjgpppAX+7B3CFW76nZT6DIlGeFXMlo/CkYw?=
 =?iso-8859-1?Q?iMtWgXl6FF4KhtN/tc3+XiRc2RKyBw4DWK4IOqr7Th8wBrYAg+m3SdeD9t?=
 =?iso-8859-1?Q?yGkypDbXMdSUzfVR9cBXcl0ywLYQINXLnZFaddx8Rz7eL5hzjM22eHuhpB?=
 =?iso-8859-1?Q?VnOnBQmYRfvcCDly/SDdwVFpwZpXDWApdMIVuXHj+h368jZ2oRxm9HWxdw?=
 =?iso-8859-1?Q?UzfNdK/PApZFLLNkTMIczIjdCmKSg0hh2mLpQob0zUUue3mQcOSaiDGcL8?=
 =?iso-8859-1?Q?A7QLdIHhY20qdk9WhVZb2kGyJ/4r6kojnwGBF5rWetB9/ilU/pY2spdSN8?=
 =?iso-8859-1?Q?TtKEf8jHDEUgjoECKSOPpttqc6DaXDHFLCLBXk8Y/Wo6SaNg8aHUgfMV7Y?=
 =?iso-8859-1?Q?C02ETubMU8UWl6NEqwAluIOePyMYjZWPakDazlQkIWvRU54jaoGL1jw/1U?=
 =?iso-8859-1?Q?mzxgLHwckLHhoua+YBA4S/CcsJ6YicjDjaej6QwGR/fDw4vttcVaxbKcsX?=
 =?iso-8859-1?Q?6jM17Qwh4rTsXa3zBiSTKnrALH0BR10dOsniw/WHTO5/27mP3n0x9LPAI+?=
 =?iso-8859-1?Q?tecZZffkJEpX4KmDFEmJ2AzZi2PBgkpfebwZSW0pkJaKP82r73prhUmsLV?=
 =?iso-8859-1?Q?8povBWNIy04umVywLmc9ZQkD3Wsf/U5OHLu65O7z/WIcR5xU6x/y9qci/l?=
 =?iso-8859-1?Q?XTOmpaHgKulnjyppttJTZdspt3xLCJnh28j+6aWgA+pqWW3Xt03hL6u2eF?=
 =?iso-8859-1?Q?lEXfZa2UOCeuQ=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 00fd152c-4b03-4639-907f-08dd38f98886
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2025 02:24:14.4707
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oy6yG0Kquo3TDIF/ZwEdQ8zMQ/z7AQpR+do7iDUsu24FgE7dTx+7tkSTW75XW27Y4a68ruXl4z6ppRnr48w2cQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9284

=0A=
>> +EXPORT_SYMBOL_GPL(vfio_pci_memory_lock_and_enable);=0A=
>>=0A=
>>=A0 void vfio_pci_memory_unlock_and_restore(struct vfio_pci_core_device *=
vdev, u16 cmd)=0A=
>>=A0 {=0A=
>>=A0=A0=A0=A0=A0=A0 pci_write_config_word(vdev->pdev, PCI_COMMAND, cmd);=
=0A=
>>=A0=A0=A0=A0=A0=A0 up_write(&vdev->memory_lock);=0A=
>>=A0 }=0A=
>> +EXPORT_SYMBOL_GPL(vfio_pci_memory_unlock_and_restore);=0A=
>>=0A=
>>=A0 static unsigned long vma_to_pfn(struct vm_area_struct *vma)=0A=
>>=A0 {=0A=
>=0A=
> The access is happening before the device is exposed to the user, the=0A=
> above are for handling conditions while there may be races with user=0A=
> access, this is totally unnecessary.=0A=
=0A=
Right. What I could do to reuse the code is to take out the part=0A=
related to locking/unlocking as new functions and export that.=0A=
The current vfio_pci_memory_lock_and_enable() would take the lock=0A=
and call the new function. Same for vfio_pci_memory_unlock_and_restore().=
=0A=
The nvgrace module could also call that new function. Does that sound=0A=
reasonable?=0A=
=0A=
> Does this delay even need to happen in the probe function, or could it=0A=
> happen in the open_device callback?=A0 That would still be before user=0A=
> access, but if we expect it to generally work, it would allow the=0A=
> training to happen in the background up until the user tries to open=0A=
> the device.=A0 Thanks,=0A=
>=0A=
> Alex=0A=
=0A=
The thought process is that since it is purely bare metal coming to proper=
=0A=
state while boot, the nvgrace module should probably wait for the startup=
=0A=
to complete during probe() instead of delaying until open() time.=0A=
=0A=
- Ankit Agrawal=

