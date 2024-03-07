Return-Path: <kvm+bounces-11278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FD858749DA
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 09:39:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37104284700
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 08:39:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A8CE8289D;
	Thu,  7 Mar 2024 08:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TpQRSnot"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E06F5B1E3;
	Thu,  7 Mar 2024 08:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709800762; cv=fail; b=oIHROWS8hKGPEe9SzLgSNFkUPWdfaXYB1eQYQnKPUehqMFa66HIdmUMuIkkx7DoXDEK8eryaiEg0ivBKnJAp8Mmni0ZwjiccYobqNvJjZ6KDJi11VONL1/uJsstWmNsRZ33XmmineusquALPhOKA2NyWHKjBRXCqe14Rkbfr/v0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709800762; c=relaxed/simple;
	bh=8F62I+I2OXY9ob+GGRW4IaQk3NMSvHQbTPwZR/llU0I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YQOK4JVPkVtS6DmA96oM+x1TG20Z2uuMhuOyuVFj6El/KUzwKniGpJQYRQ8+19JYexatWoA3y0BrpizySENPCe96/TvpCbksDB/hiQ/3cuW2Fu48FuMUnLu2pgwKuKqvSbJcPC681fuz5uZ5NFEh2iTXq35+LmCvDoalM4tY4Wc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TpQRSnot; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709800761; x=1741336761;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8F62I+I2OXY9ob+GGRW4IaQk3NMSvHQbTPwZR/llU0I=;
  b=TpQRSnotYvVRxPgf4NDor2ptIzqyCp9SK4bCT/Cubo12jqmlJEpJHmsI
   2NufAuobjy1SqCAMCEwi/MsbVDr2PjJ8ZaNLVvql2BtEL56WSwkkTBQ/s
   m9UsuT7U/sfnB1AOPtqUveAewu09CREijwi+8+RtQNUpFBSMMo4HG9te+
   I6rZdJWb+HgJSSZCiHP1JT32ybo7+8AXr5I/sk3BGx6gMvrmDainDBFEQ
   axO2lWsbHGqqCCoWl9Ho+dzoHb1oFWox/QR/C/I/RQf4dq2DZLA2CyiTg
   H1EvbpyB7lgAtX8gYgMnmTv3dR3KPnIUQF883ymTiSdNEhi9KYi/B/VPR
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="7398047"
X-IronPort-AV: E=Sophos;i="6.06,211,1705392000"; 
   d="scan'208";a="7398047"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 00:39:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,210,1705392000"; 
   d="scan'208";a="10475352"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Mar 2024 00:39:20 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Mar 2024 00:39:19 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Mar 2024 00:39:18 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 7 Mar 2024 00:39:18 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 7 Mar 2024 00:39:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nHcW66xT2hkeLv04fkkI9SNXYXMriTPnABdhIMA4yc+DAirQPFVi7FoMbyMPSnPM6mzh19njPf2iYRqstGoUZpjtbotY+loa1Szrw6tyMOZ0vx1a4tyh29bovDR+/4IuGG/CtEv896ld2vIgHWpysOxvk8aQa6dWhQ5UebNNOI1VEW6Ski6QiX3FgU7eN6xwZecXWMixR7OM4qqPkjrAghsEdMzN4czqdDDSP5TiGRZLIdmHqI+GNbeYYobfvTsXQ7gk0sqJhgGlsdpExudpxeSuWrRozvHEWxoAhR9OnZ6HONiVzuvc0tK1ApeAGFqNEm9aipNVb7adqnCtFux57w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VKwJNO1/F9uoZkW9nR4GC3AYC9Izdk3MzBcoSehlpPQ=;
 b=nlve39b/7DcevyqprvjdQZ8mMsJjC+0+VNryXBV9MMSWBlajrYY12kA+D6HLviw4piPA0mQ4va4KcAHzTxjQVBJMZsJs3VZB4JFD7sj4fH5s+wAqFoGPZm+AIC7MFmzIHZny2FU8hfN6v2BGX55kS59FEuNOJqsuZkh6qXwwhWRKM5vkmjHmKxExTw1MkN9ZbJSAUGP4tDVr5eFzUnEU8ruQNMi+WfbHpccPoAEx7lThZOP9m38fxoG2zQUpjjWUFkY0YHf6MIQNJQXHEJsfEOjx5NZNSB2vj0mKsXAlS+qN6IHzngHtKUZXyD3kM9LFKDAh9tZ9FOySsH0FtANlYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by IA1PR11MB6417.namprd11.prod.outlook.com (2603:10b6:208:3ab::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.24; Thu, 7 Mar
 2024 08:39:16 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::ca67:e14d:c39b:5c01]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::ca67:e14d:c39b:5c01%4]) with mapi id 15.20.7386.006; Thu, 7 Mar 2024
 08:39:16 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "clg@redhat.com" <clg@redhat.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/7] vfio/pci: Disable auto-enable of exclusive INTx IRQ
Thread-Topic: [PATCH 1/7] vfio/pci: Disable auto-enable of exclusive INTx IRQ
Thread-Index: AQHacAtu1xn5Hoku+0au9dqEK9o17bEr9Zgw
Date: Thu, 7 Mar 2024 08:39:16 +0000
Message-ID: <BL1PR11MB527189373E8756AA8697E8D78C202@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <20240306211445.1856768-1-alex.williamson@redhat.com>
 <20240306211445.1856768-2-alex.williamson@redhat.com>
In-Reply-To: <20240306211445.1856768-2-alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|IA1PR11MB6417:EE_
x-ms-office365-filtering-correlation-id: 1432610b-fed3-421d-db47-08dc3e82130a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XJRte7ExHviAVivHNJHnw46Fdo1g+wlXOM4FhEw2NkiVtS/uaHs/dxjtWFjy3GcnFdlC2uEs7HEiz6zd4CBk9Uyg9lZTXouiqifYGAw70QHSUgUqwqwFbY5mxkG73MKK51wT3WircZBU5GhP603RomTX3jop5nUz6Y+wAeXsHqJrcckp9VZJQ1LhRrCc0ij98RdK9yrug6zP703B/3aVdS4A7aDZNESgM+5ns9FjmanXNt9x70Fg0IhLDxDAxEmHZ/i36VwvtUiNvJk4LdwS7wTz2iwXeFCF8OBQp4KPbxuVcjMrq9viFN+1GKRQpJBofaUzgYSLJ8COSroLsjSK8SgufmVOQZK7dIiwUfKwJCbeNPFPRNZquNz/GpwZz3ffLvWpm0Q7z11EmMivs1D/oLAY7+mRr8RX3d4mU6UUsTpwf2sgB844Ve1c22JI2PKkuhtr9cNuugwRwjd9y3YPluZs43NbT0y94rnisiBPkbza7ndRqYr/UqswZXdrwi60Tw61cgIZNZyjDf9N3UxME98o77kUB6e0m15yIseVC5Z0KPSCsZAkGCUdYlAVTRibI7w++AX+ALTXHQ48QkxYh1rD1Wj2NLRs6BcqyYF9qME6C02jb7xSXCRn2LcQfOg1B1QbG9NdfbEKeKEFbI7oHvMeGeDUJSiGGpiI5E+zVO8J1shVlja3/rWv0jyhHCsYse8HTDTqJ6LG06nJy97/AlrLuxZ8OIgYrHSiXVJPCyA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/q8LI44KfqlfLkEsRruj/wiMngaJMkflcq3H8AMFfL10GW64UblSMO0H9gpV?=
 =?us-ascii?Q?0KCm2/USA1GQ5z2L1ZokrC6h9BYEXBLmrzLXXF3TGbIIi2Xt7urn8h5Reufl?=
 =?us-ascii?Q?gV5zVb3kVsE/xHkidg7cGjbgI69ZndHKElrVn3syWLkNy5U0s2Eq7MP0SyvT?=
 =?us-ascii?Q?EnuzqwmCDvawT9/3Iwk2TR0mSfPd8orEkFBRqL0AHr+14vsRMjVdUVNdnJ+o?=
 =?us-ascii?Q?/FkEyaoMF0i2OgfLuncsZPdAGTZFfJ0+KhmJa1e0J8d2si+Zs16LNFcx1Vnk?=
 =?us-ascii?Q?3et5pSkGvuMLbjc+ahrY3vYMxu/pMV8zZxNXngjZjHbjMtYfDHEgcF1TY27E?=
 =?us-ascii?Q?m1HmJnxIF8yIr5CisvQIspmPafg9GBFHEXTlUorhHa13x/M+Xva2zWjHr9SC?=
 =?us-ascii?Q?AFirw5B6LTFN8BjTrpaXf0bBmZwyye0zEl064Vm2mSIlgyQZHWFnUIXLTlyq?=
 =?us-ascii?Q?VrLFFWffiNDC3plY0PdnV5lEN6/SZ+pTPHBQrBXI0i0gWBF2IImZ8o2S0sB6?=
 =?us-ascii?Q?cisyf1g6PyqckfpD7Mb8CFR/cJ3mvfy1oimrfy7fdV8C8UViScbnmUI1G1fY?=
 =?us-ascii?Q?Zdlpqmgu0VV1QZinrNFOEKo6VF6w+npUdzN5YygjqtGAC1djrm6xkMHFxWta?=
 =?us-ascii?Q?87a92HqjKjnxv/w9dTtIWdcmU1TQXx5Pzez9ei6ugRtgdVD+DX9oJItkVObh?=
 =?us-ascii?Q?POIlBnQ3tEji/WiPEWjzdet2M/glBzkL2rDsB0ZxD4QgASG4mTo3a1ti95W+?=
 =?us-ascii?Q?xtozEKnhb2tsihUf3mEMW1A4uYORb6N1pHrpCidCPnXQov24Vhp6j3tZOPiF?=
 =?us-ascii?Q?sDqKbf/a9Q79Fov39BqfNBzv3CC/UYFnpLAqbjaJYMQCyTPSRn2thIwkSRE1?=
 =?us-ascii?Q?t0rP+G91PuvbYGybuDemnjhN32ig+jmDasnt3YlNdIOIFH5TN5HVzZNVJJYi?=
 =?us-ascii?Q?dsnOYa2q0O0+csTKAqOV33+rG7yir+2UARa79zvEq2rt3ux2B8KW5PN5AXjy?=
 =?us-ascii?Q?W4sQO0Io7hf1W2cIuMbjNY0kEI3jX7XniuLNpLB5YWbsePmf/SJjFKrfB6Dv?=
 =?us-ascii?Q?FzpLwhPYGpJvG2W8WjWW02+wbt+RX/IwAL1eVNhtZ+7Fu6JV5/PU6z9QmSYD?=
 =?us-ascii?Q?o8YLV7+Uslc9GB6AubEMD99i9cG3S3CxX3u+3wPhnl3siVvHQdA0unJOs3aO?=
 =?us-ascii?Q?J2M8VA+P0SiGCvOiqPfj9xRcWDtWv0nuC+VPD6c3MXJ3kK986E8gplksdqM4?=
 =?us-ascii?Q?CunSh5hytmbhL3zWsmCKw5fJAsyv1GkgP89EvlcNPkTEC1av2ZT56lbFU6yR?=
 =?us-ascii?Q?AMM4MLO6+AHD6mIpFLjKZL/jmmkSs1tLOHwMBXyav99IvTfhZpWlSl0Eya8L?=
 =?us-ascii?Q?dwYyMPA0FG2hBzXbBqsFlHrwFiHhzIGKa46QqTR29OYo+4gbGRarfqsb3kh3?=
 =?us-ascii?Q?uDIknpVW1HJeazV0reSGhj7pQjiKxqLlSf/mDGG8oUXTtWciExZaxQSxUZg/?=
 =?us-ascii?Q?7r4dkhs9q/U5FHfJUQLB1o9rsdyztavlPyDEO4biaZ4d6igckKC83UNt6z9a?=
 =?us-ascii?Q?+f0e+6wOkp1fsRW1roDus2e+7V6gwpb87fS/ecJe?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1432610b-fed3-421d-db47-08dc3e82130a
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2024 08:39:16.5572
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xiw2SJck084dnX9Jeavhxb7qbzTXZZ7jomvmfFJAl98O6mXFguBtTDhY83Q6Ys2fOyBHVZ1k6LK620PWihDSKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6417
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, March 7, 2024 5:15 AM
>=20
> Currently for devices requiring masking at the irqchip for INTx, ie.
> devices without DisINTx support, the IRQ is enabled in request_irq()
> and subsequently disabled as necessary to align with the masked status
> flag.  This presents a window where the interrupt could fire between
> these events, resulting in the IRQ incrementing the disable depth twice.
> This would be unrecoverable for a user since the masked flag prevents
> nested enables through vfio.
>=20
> Instead, invert the logic using IRQF_NO_AUTOEN such that exclusive INTx
> is never auto-enabled, then unmask as required.
>=20
> Fixes: 89e1f7d4c66d ("vfio: Add PCI device driver")
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

CC stable?

