Return-Path: <kvm+bounces-36052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E14C1A170F1
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 18:01:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6631F188991D
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 17:01:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 198A21EBFF8;
	Mon, 20 Jan 2025 17:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YdaPt8kH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2087.outbound.protection.outlook.com [40.107.244.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9C21494CC;
	Mon, 20 Jan 2025 17:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737392497; cv=fail; b=iahd/HjJM28tcRPZwmsblgy8Fay61D6Sgir49sBqP1t4BX5g/yQJTlKZQr/RVcqsKxVQ2Q2nsDhrm9Isg34QWGk8kp6KYwmzhLsidinQ97PCdNvde+EBY7XamQiivebpOOG0V3uxNSuTK4n34sZjVSJ2Ly3Q/jU3AtJeuz7OCHU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737392497; c=relaxed/simple;
	bh=4yet1xNtkQeFb/3tchYZ/KUTXHJLxSntDLglAWoeLL8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VoMtSxrUhMwuWrDv9bwZbUsxJuB+KiPm+EYi3YgmYW2qMyZSPkYuHqJS7NJkLMBBWHAx4z5O4smNTQ4OWNiwx673sca4xKoHXelLABITX2K18IYKGp3O7rYG3mhweu3MOEF8TaiDSF1ONEtal1f3J0DknNn8lMfclUYowwg0efY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YdaPt8kH; arc=fail smtp.client-ip=40.107.244.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sUx3mW0qvDyzVyfR9Jb4qqOt8Cx8VLUZ+AzYpECLl+epsrfzTi467L7BpAd3ek6eGVpl3gJ+odbmukMgEzYutgalKIh4FXsJ14feWmb9+ogsL43R6IDYh1hvTFwy04DDb+O84Jc3DX9RLQdZvG6Km0BhzSfIH91mLWYPnq5TIOKQYGUMG+rQ/9hyL8kdQyLhE1l+XLoQeyfE779uF/1OuqADRUFVU97hMsw0r/TXZ7BDjjKrCv4xsdqT+ABPYPG80LiBje1b3f1ee97gW7Hldnn/ucpcgTEo1FiI5gCzaLAQv/PGak5HjU9ww+I7SwAGTIOmSW2Ok6P9/gb0cYZeNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4yet1xNtkQeFb/3tchYZ/KUTXHJLxSntDLglAWoeLL8=;
 b=Fr3G2RFYqfJQVivWCTEw3djIsoRxnmOZ+f4VcZv/B+J+h8IqQHLtcHjrhmZJ6uCWT4JJoIljWGRZZXgY6GbB75Xpml0DnPAVQTZ4LYZI8K4nPAFrz/1jDkR73rvogYVG1AHheCoB9YuZVb/SfxU4BNgGRax0GUhFUR+XTKM0ThEB6Wqg5+8nTtEWPnuggQ8nFhHcynAOB1rKG+HAa/Arxm5w7cyQKTPXeKvAhNeJysFDSCynNniT6+WeFCr2L/HKRzYBqkEB1U9NhEvZRDzTtitzcRxyxOmNDvni2hIS2EmbMI6lcR13yyM63y8K270bAewSuO29YM/t6gg4h1XWLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4yet1xNtkQeFb/3tchYZ/KUTXHJLxSntDLglAWoeLL8=;
 b=YdaPt8kHPXuO0nc0HSZgPIsvbme5KLsCXcjaXTv3T6G8GozRt+RaGpR3IQg3ZjT5bRShOeczgDBz1D64Sih1PtRo74uAK8bB67J7y/SKhGpng1GApXtOzy69ymBJUKLTUFSaGrRep/Sfh5YFv08ktVJVE0Of6MQiKMla/sYgTBDq7ZhLj1QSy+w0VOxYHpLHQCf/amrDvThPfCN00BmVniaUOR7IwCHakXQ/MbKBmN0dTfb64tqiQHVCN2KUh7CISu1Y4VVOgXS82tzZ1iiSTBJyvI192NvB2zqUK9pTbG3E7W8X3zroeFMiNn2SfIaDQnBDtQwdOQpoWuhudXkr/g==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by PH7PR12MB6786.namprd12.prod.outlook.com (2603:10b6:510:1ac::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.22; Mon, 20 Jan
 2025 17:01:33 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%5]) with mapi id 15.20.8356.020; Mon, 20 Jan 2025
 17:01:33 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, Yishai Hadas
	<yishaih@nvidia.com>, "shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, Zhi Wang <zhiw@nvidia.com>
CC: Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti
 Wankhede <kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)"
	<targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy Currid
	<acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John Hubbard
	<jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, "Anuj Aggarwal
 (SW-GPU)" <anuaggarwal@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/3] vfio/nvgrace-gpu: Read dvsec register to determine
 need for uncached resmem
Thread-Topic: [PATCH v4 1/3] vfio/nvgrace-gpu: Read dvsec register to
 determine need for uncached resmem
Thread-Index: AQHbaTjBZtIyf03Z0EKujaCWGd7uu7MfQe2AgACjJnU=
Date: Mon, 20 Jan 2025 17:01:32 +0000
Message-ID:
 <SA1PR12MB7199773CE7D83F39479EB2C2B0E72@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250117233704.3374-1-ankita@nvidia.com>
 <20250117233704.3374-2-ankita@nvidia.com>
 <BN9PR11MB5276B46605C1C15EF39808098CE72@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To:
 <BN9PR11MB5276B46605C1C15EF39808098CE72@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|PH7PR12MB6786:EE_
x-ms-office365-filtering-correlation-id: ef8c2a24-d2cf-46db-5703-08dd39741777
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?RQtLJtVW8kSrszscLpac7wO5SU/bFUA2hahR57Yc6dJn9uX4sbPwKmp88+?=
 =?iso-8859-1?Q?VrmxYpHHA/vIIDudYsVeQC+pEgaMOcdYCZg5wPiwT8Ew8ztnAJ2q3yCymm?=
 =?iso-8859-1?Q?jylQnP/VcFt44P1PP5p/rmNw2CjbJn3wBeZv9GmV0x2GVzr1WrGRBLsMCh?=
 =?iso-8859-1?Q?pfLfvbCNzES1psLfnHD+6MZLYXR9Yrix6116bemun6X7WPM3QIx8QHGpZw?=
 =?iso-8859-1?Q?fdSswvn+E/TiHrG7W6v8Vb8NLIS9+0ZzvXVUjztIctbz+YGL8bK3JCKLgm?=
 =?iso-8859-1?Q?kKibRFXNs3WDJbX5lerkBF1tUeFfRZqJCXkx+Od0y/sUO37TvG1dQOzDMf?=
 =?iso-8859-1?Q?3b2ARgje5dYKLxcO2R0I22OWL0oHOxMXpEg7w1uzxFHWfCAl7zJjEWDPTU?=
 =?iso-8859-1?Q?zCOnGcBEinlZoHGfiJ4e8TwbBv7YkWeyZBmLZblDhUc8NtIvmQOpEX4EW1?=
 =?iso-8859-1?Q?H3j1/7AyqTqa53LVvQGiPPXlFRncZu1il9kqb7Xt4ymsyqujRR5j9qY7r0?=
 =?iso-8859-1?Q?GN9/oAWRzGSYiZx+Ex/rEwlrM/HXfNrGfe/a5F/piSzibfKs9b4jxIrunD?=
 =?iso-8859-1?Q?731df+FrKjfEG35xW/jKR+a1mhxE8iEx9pEucaOzYPSUKGXt8yONlHGwO7?=
 =?iso-8859-1?Q?UQfRrfk1bCg6JZAzkmsh/wuKdIZzMCdgqHfuKaS6x/8MqwC5DVwpK+C9mn?=
 =?iso-8859-1?Q?fGFQYqztzP8c15geOPCrPDb8IT+I5rwtJfklDy/mkONGjnb4KzgyOH1bpF?=
 =?iso-8859-1?Q?iXW1Fcc+XGlkRwyfV80Kb9cNZoGsQrVts/51XAp4GhkHi+Vn5hmOmI89GW?=
 =?iso-8859-1?Q?8lxxNVDy+LzID8r7bkRJX7w7bYV8gU3TSwDEtx5R+8MT10RDw3mLFpxL6u?=
 =?iso-8859-1?Q?mgZ6tI/VsYtisngatK3zLxcWPIkZMijs9EPhiKMx0Ho2RBLSSoAmki9n4R?=
 =?iso-8859-1?Q?PyQyXtrW4CXOcp+BcD0gRtUJNr3EP2VFSE+nOz57VpauH15RxWcpUkcYib?=
 =?iso-8859-1?Q?khnCWJQcSnuWwLkD04dWgQoxiq8g8LI+WJvsCP0oZM26RwBkJdD9T4xcIH?=
 =?iso-8859-1?Q?GtBf58mQwr8i+dlEw2TiCNcz3L7oDIQsH7KNiT9aWinbeEuVsDdoDEkioZ?=
 =?iso-8859-1?Q?5JI03qQljfKfMUo4sqMOY69pCpxYgFIwMhTnLWxNYFSvrACiJxff8YLFzA?=
 =?iso-8859-1?Q?8fskQ+dwQHmJwynEqtJDJ5+HKjl5D32OaqnXiTrJJ8rn2nZP+AuaMvamyc?=
 =?iso-8859-1?Q?LuXtflMfZOj1qLv1nBIOqHhSB5z9EqUzWi/np/lJHL5anEcfmCF2rB10UQ?=
 =?iso-8859-1?Q?qmXgzqDC8T1q3jCpAV2gz0eMj1LXfHRQQ75N/bu0RJLvZuVE31TtdikKcq?=
 =?iso-8859-1?Q?TMmS2ATH8yXHr7CX0O4IviF4DD6XL9FO6nv9XsFmc8G8Q03KfDHSgXMSPI?=
 =?iso-8859-1?Q?egRGpnPy3IepfFNNaQ05bW4XDJUSkiMFppu7cu//pNi1xMQ9F0YjIhRor/?=
 =?iso-8859-1?Q?pLPpEzYArtrKEOhSLHWZuN?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?aIa8+9CTysf2BHIJeDT4YCFKP6N7B7Jltq0kEpvARFtFQP+mBp4P1nSiVd?=
 =?iso-8859-1?Q?To9/rZP3kJafei2j3VYIRtYsQg8goR8OezFnjB4yATHDdESukGLXHYVW8R?=
 =?iso-8859-1?Q?RU2g2qgdE0azwjz/mSEF6yceclFysPF6yqt+OPwzgh26VhOqmoMlcD7uoQ?=
 =?iso-8859-1?Q?5PWMt7rqBUHKIO4AKly5wSHf2uTtOiMtiFSkWOTbt2jgQZg7l3NHxJq6dK?=
 =?iso-8859-1?Q?6kXsgqh0btyijncwG2ZpJ5IJcLWj+rCFTF0TrIF0CdouO6nqWphtsEY1Pf?=
 =?iso-8859-1?Q?qLrT08yjPcYX46Yi/+EZPNSRM1xqcmnkhuGqLRfpbUz9gRKTHM7Y0nwi1P?=
 =?iso-8859-1?Q?1DTJ3/4tm6oGLlu5lVDt5+nfxNZ+Gfp25yzClfOj1TxqC2WeEy9i89zY2e?=
 =?iso-8859-1?Q?E4NAhCHI1WyKrXatgghPKTWwNzU6IAVwHrg/ESk6iXRQP0ejUL7pKcn2S6?=
 =?iso-8859-1?Q?jyDZBZ1SZBm5kM88bOnIRaYGA3CEZRj58QZ0zxNBnwqa5Z0OVxtAfzPp4Q?=
 =?iso-8859-1?Q?D7ud9Wu94uPFy+2bvW201cbkohxKjUo9C/VeqQ+33D+tCozAzpPQXqr0Yv?=
 =?iso-8859-1?Q?IxSd/AMm//YNHa65B1VSUe/tLdu2QSyfdwbeD/Kfhg9uHxzihvvEtvnqMM?=
 =?iso-8859-1?Q?enhhyPwNFQrZ22vSS4OzuKTqNVq+I6wBZOBwrT+CTNUdfsdGdZAZUVYJ1U?=
 =?iso-8859-1?Q?1gxmfQ/QgQbDIYGsjYi8XgAOXPP8bK6I+Qf2rsyuowVFQbqJfjzlvqbo+q?=
 =?iso-8859-1?Q?A6UPmj3pXZ0ruffGZnmhQ9aC5j2NcJv2o9ACpuTBzwHgxpbJl2Wlxf4KKd?=
 =?iso-8859-1?Q?4sBF/cFUlyKEwE05r8arhhscxxvyWJVeJVju8fjttQiN4AboTEPgtac/Az?=
 =?iso-8859-1?Q?RSYYml1mK1kqK3eVKN4Yv88utD0ile0kZny0K4rkUxHkiOYtiKKKf3WR6r?=
 =?iso-8859-1?Q?U342VS8MbdbrlHN7W7S8Ib2rEwcTMqvHBIzt99Ndhm3ecmiOh+WvmYFlXN?=
 =?iso-8859-1?Q?xQq+OQoMHlCVpAlDqwnCLDCvlLeuCWAtNx8Hrkr27MfIbsGZyCML3YVlQB?=
 =?iso-8859-1?Q?6BwEX3cIrp1/RhPkOU3rtcfF98rgBb/oGETALYIqeSmhI3/lW+zj+ffaNg?=
 =?iso-8859-1?Q?Tf4I4YlwpVlvknEm6Is2Tzgi5ZzfesPoG4q6rQKrmX3GakB3LlvjeedfF9?=
 =?iso-8859-1?Q?bTEA3QxO4nsc0XaNaDW3+sckS7vPxVLC4ybzAg+4TCVXk5khQDtTSXiAco?=
 =?iso-8859-1?Q?5hOg3XMR2eW5arTaDFmEadhb9yVa4ShRX2xX4CxQIB3dGpSpXcdFCt66ex?=
 =?iso-8859-1?Q?u+mRnaUgcAtf9IjR4NUsYIQdwbebffaDSb0oDZMBBVAc/3VftwlLZ1vRmO?=
 =?iso-8859-1?Q?t0EivJSGTBmAnCIvoexrGFktl14k8BX80/VlcsOzF2gYsQXorNp1LFPRDU?=
 =?iso-8859-1?Q?+2UC7z7kEH2r/+iyficYaN1+Cb49LBlNASJ/K8yR7ZcpGnUMU7deD6Wdbm?=
 =?iso-8859-1?Q?4xkH63iR6BP5NnKApEA7ECZ/0dvshPb0C1tC3f4ZdpheXKC/6KSu8KwPQY?=
 =?iso-8859-1?Q?ZXH2MfYnn52HdPL8UCutY84rOumn3/clZIe2hZu9MxY1zSW/v9+Ms2iNCK?=
 =?iso-8859-1?Q?1QiswoLnToY3Y=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ef8c2a24-d2cf-46db-5703-08dd39741777
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2025 17:01:32.8592
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M0lTiDrfm7B59Z2+MncEzb60hErJ91eFwqQWBZ+G0qTIZ1XEMBD1h38DaceI6L3vkadzJk9Z1DuIXq35qSD3EQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6786

Thanks Kevin for the comments.=0A=
=0A=
>>=0A=
>> @@ -46,6 +51,7 @@ struct nvgrace_gpu_pci_core_device {=0A=
>>=A0=A0=A0=A0=A0=A0 struct mem_region resmem;=0A=
>>=A0=A0=A0=A0=A0=A0 /* Lock to control device memory kernel mapping */=0A=
>>=A0=A0=A0=A0=A0=A0 struct mutex remap_lock;=0A=
>> +=A0=A0=A0=A0 bool has_mig_hw_bug_fix;=0A=
>=0A=
> Is 'has_mig_hw_bug" clearer given GB+ hardware should all inherit=0A=
> the fix anyway?=0A=
=0A=
IIUC, are you suggesting an inverted implementation? i.e. use=0A=
has_mig_hw_bug as the struct member with the semantics=0A=
!has_mig_hw_bug_fix?=0A=
=0A=
>>=0A=
>>=A0=A0=A0=A0=A0=A0 if (ops =3D=3D &nvgrace_gpu_pci_ops) {=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 nvdev->has_mig_hw_bug_fix =3D=0A=
>> nvgrace_gpu_has_mig_hw_bug_fix(pdev);=0A=
>> +=0A=
>=0A=
> Move it into nvgrace_gpu_init_nvdev_struct() which has plenty=0A=
> of information to help understand that line.=0A=
=0A=
Ack, will update in the next version.=

