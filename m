Return-Path: <kvm+bounces-23382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F3624949317
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 16:31:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 81A2C1F21334
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 14:31:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 870E61BE23A;
	Tue,  6 Aug 2024 14:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TJ4S7zga"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2059.outbound.protection.outlook.com [40.107.102.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDCB18D63E
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 14:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722954664; cv=fail; b=LE6XLagCIvbFs0XsSkAF4PRO7jbS6O9JEk2QHDGKKqnJzcSJIgRXlHlUWq2AoFi2uaN6c2TVC0Op0GUAZpTm4VGEasxK1cSzUjULRypwYM7PRh23VPQwG9XOV2Neml4Qas5AAv53yASbBw7Hx06DBKhQq5zyP9hwR4OseB5O6l8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722954664; c=relaxed/simple;
	bh=/wXgdU3zJlbUMIRcatsAgsf40ph3tzg9vAXV/D+wCbE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dJvZGUq+ctJ1ZaLU/X2sXaGRT95aMfAngMqXL86dg5EeU/y3FNN/rq0NfO/U7c34Fcox3fLlvQ8pKXaywMfZqWuVLJR2NHNjsRZ11i1Z8m4VoR6RuReGzQo6siVxRli7QyWGP+50aC5l4mDRuoSDTOU1K054VrU3yon1yKHg5SU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TJ4S7zga; arc=fail smtp.client-ip=40.107.102.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h/RQwZogL2CCbOBMzjGa/SuCOwoJ12Eanaidd1S53LyWYocB+744+tjceNfiP1xhPVGgJ83nhiyNFJoWg5ZE4kgWnL36hQRARWSumdsfmNE2T9X5Y1rHupG7fwzD1d3hsAw0vZBF6k0aryfpvOBMtxVLNU3qd/OreZMNA1PThQ26+x6Vh33GkRfMx2ScYZdLUfiM7z4A5QdqJ6KElkpVhPuGVytLD2RzhLuJs712atzbgO+AdIXHQeY/mijQZFGYFgKxi/AdWBAymGf9cy9/ffB7PXBbn4KOw0P/59Z4wyAZEOPIpqGytfN45lDi0pIgsC2/QYvoHo+CuRF6mQACjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6PGHSBcfR1NRqtLmR5voA834BD20HCjB0PkNZWVh158=;
 b=dnXvmUCvKcuDXKh8NaKDHZPcMwBL6VhaLS9o6al4IxzSuQXmdgt5FjMLwX1THPviwCgXQyDPOYoXYzYHJCd9229sc9eHL3n1eUhUpcNn6cqFbCB1UZFpSAukQhs+ieop/RPULY7mcILxt0WoSkFtsLum4hA0m0t8GjtrLNpNEo+cXkR04+81vkXmdYDXKPMipYj+TVsola/eGxuR4VnCymefrvIlzeFXKKdQKHpkvukeYaf4AlZWB/nViRMs3h/GhP0liu+/t9L2VH6o7K+IlIUHeDPQqhKSkhqRut4tDPNfIhoWieWW8oUXWhNvrfL5YTbXKwkbbQr8enILvOc9iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6PGHSBcfR1NRqtLmR5voA834BD20HCjB0PkNZWVh158=;
 b=TJ4S7zgatRwjTO2Re12Xv8j3iSRRo9LC+gUmQ3U4Eab9s+b/g8nlUU2yocsTqCyenS8F5mYMzNiscSmveWa/jhVGpVSPjNl7SAbcnOD3YkaYvKuaF8UaD3tu/C7i8LOIRyR3lor+u668YlFeerB6i6B7t6B9qMFWky4lN7w3WJn3mPN++teFeDCStGELq+XLX+rR28V+lT/zDlGrhzOy7DHBHNv3voxLF9/t3Oguod9K9yNWESw4WXefToffmWX2Tpq6pjzdHXhOTcesAvopFWCE10+kDcF3iRh25WdK1kxB2HKvzBKfbeY5sqTkIUXGigPij8uIHBlj/aQxPjm+3Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SA1PR12MB6822.namprd12.prod.outlook.com (2603:10b6:806:25d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.22; Tue, 6 Aug
 2024 14:30:59 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7849.008; Tue, 6 Aug 2024
 14:30:58 +0000
Date: Tue, 6 Aug 2024 11:30:57 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>,
	=?utf-8?Q?C=C3=A9dric?= Le Goater <clg@redhat.com>
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Message-ID: <20240806143057.GO478300@nvidia.com>
References: <BN9PR11MB5276B3F627368E869ED828558C112@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240424001221.GF941030@nvidia.com>
 <20240424122437.24113510.alex.williamson@redhat.com>
 <20240424183626.GT941030@nvidia.com>
 <20240424141349.376bdbf9.alex.williamson@redhat.com>
 <20240426141117.GY941030@nvidia.com>
 <20240426141354.1f003b5f.alex.williamson@redhat.com>
 <20240429174442.GJ941030@nvidia.com>
 <BN9PR11MB5276C4EF3CFB6075C7FC60AC8CAA2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240730113517.27b06160.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240730113517.27b06160.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR02CA0034.namprd02.prod.outlook.com
 (2603:10b6:208:fc::47) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SA1PR12MB6822:EE_
X-MS-Office365-Filtering-Correlation-Id: b2b45c84-92ce-4367-e823-08dcb6246366
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?R3qhcUMnVoFzeWXpHrQFO3MkAYosR7wwbR40wWc9Xb0Pwp8GGV+qXcqOa0Xl?=
 =?us-ascii?Q?g+PaoffwLEoFpBasAlWw8EN72t3OigUqSU0HNpNJyI5uGigYZdwMx7rLkMes?=
 =?us-ascii?Q?KGZNGOfjNyG9qytPVo1PT7hM2+c7OKX98slnns5WcLib+djHQoJDMtB0st7W?=
 =?us-ascii?Q?uUbjhjjOXqrThiFfU8Wbqj0DBqZQyApw+eVvIiK3oPWdBl2YzaAdEqrURv7Y?=
 =?us-ascii?Q?VZc9E4ruoyLKAmV6qM23WmOzla10szJhv7oAYGucXo1OnzFLXDcjpNwtXzTE?=
 =?us-ascii?Q?W0AFyE37xY6oKzAXfhctKnnrRUalmAIMU0ZwcPc2neaLS+VOfkwwZm0NfYnh?=
 =?us-ascii?Q?Sa85FmFFOLPK9wCiiyLUL/oBfACgp/oHnwQ9G6eHvtHjL5zcUsQFhKBBOOFq?=
 =?us-ascii?Q?FJAohuZ3ZFnzKH11P+cGIk4ppX1XvUhQVAlF05r6GXBqJ+NEXIc5FManiCO9?=
 =?us-ascii?Q?oxu/avdzykALkxoc9VyHgieKYxJSJdeGBwA02aMsCXwjKfLupAGUV8+GZZBe?=
 =?us-ascii?Q?gQpYB3uxiE4jVkUVNkFyQpkoz+om5tLW5CH13aNaYSyuM+dQgflmJyvJm5QF?=
 =?us-ascii?Q?CHXwfgl5TP1rHFe/r2fW1qCzKRSRVZIbtw4MG/2TXLP685oALBXvMCMlmcjG?=
 =?us-ascii?Q?WeSRG3eammhcbtU9c7VukcRrrT1eb/3AWpgWD5rGwO2umf3qjeXQoVGIuioZ?=
 =?us-ascii?Q?zMdwHF6QKnCco8L+ywom2taPGn/Cjq/mFDIZ5YsWF+WTYBJwMcAR9PgGzZ8T?=
 =?us-ascii?Q?ZLW210ulKiTTRaMi2r+XJXmTIGsjLQlhZ3JWNtNmQeacnbbcO3/l5BPx5KYB?=
 =?us-ascii?Q?dZYklo6qFqMLMl7gd1D75RcXRxQ71e1pccMYtA34PlUblBjWB865HaFSckA7?=
 =?us-ascii?Q?Phgmhz09keEilKkdm0Vev3MAepTxEwE1UGGMQJhv8v3jNnSxzUFB+i1FV5hN?=
 =?us-ascii?Q?X9oPJgfdVqDzgt6zJo6zvYcG+cXBwj560/8tAsT9zKzzeudIDWachUfIEWTc?=
 =?us-ascii?Q?QhtdeByHcq8ZwaWutxVQb/yxQAiwWZPH/HWZE9c7j7zIIEeFuDUqYO8HWYwP?=
 =?us-ascii?Q?5K4uvgUFOBiwHWQ5XnroIDsIFl/wckYn0CYR+1KGse94YKtDtgZWIbJ4Soxy?=
 =?us-ascii?Q?zoevIoxcG86B7N0MphIt0Qo/VdaIynqB4zz4vumtR5lWZC9JhecuZdp1LlQD?=
 =?us-ascii?Q?JMDBb42mDYe7pgSl1yYPUVgFR/fL4KEygdzKsLUroeQnchshcDqQNh8Z08Rk?=
 =?us-ascii?Q?/0jNXx4ga+6M4o4TRXNUa+wK1SIE/e14QEMDp0X6aUY1tsM5LmrM37HsRZbL?=
 =?us-ascii?Q?P215gVmM9A+3PkbM7QlrXTO6CAaKgeJz5cZMUYMuGuY/DA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wTTfe4GDJfN2woAcsbAL5hhYBTQ1xhGjI/hgXlDL8ZD4+xcltoitBplZ/JVS?=
 =?us-ascii?Q?fFzJUB66GDp4O7iwvNS0KeW/uotKPypIB8L+Bx93mBKfmHlfcQnsSRVEPpIF?=
 =?us-ascii?Q?aXnQ6yUYEKeQyq8d2Kx2ThjuUHQB8+4+Xtl9VNIV8EmmAz3REcUm20l6OXfi?=
 =?us-ascii?Q?hdbcezowxzg06TPI2sDBZp45cEEyJqJWMOugQ81CMuQ8xqHKvax9wU46Hgyu?=
 =?us-ascii?Q?v4dXEIBNHlncANRi2VxJnQwWaizJSlNxU6ttGdgS+woYp9ozXUGEuQ8RRkDR?=
 =?us-ascii?Q?1lIavuH9aMgmPPdovY+LPHnweNilpdV+BfAyJMhg7sUVK6dTO9LZI+W2WD80?=
 =?us-ascii?Q?i0szzBdhVO0bNtV5gKRA+YSeuyH1z3HEvegjn5AJP3/2mvVsV5If+/AxGJtr?=
 =?us-ascii?Q?XLwKJU4wx93FXgi83mgExfs8ifA5inA54z+dY98wmCjRSnikQt4Q2cL5bi1W?=
 =?us-ascii?Q?5lhJ9wo21bPQXMNUcrSiARAjvC28TWb7Gq6gxilOU40bmWxtjCdw1FMpIeFh?=
 =?us-ascii?Q?3+fuZ/5M2LWyQMu5MR0b6OSjhFDDkXO6oJ6jTdBKMR1sSW/b6P4Owa7pPF9M?=
 =?us-ascii?Q?KlDxXTQsczBZA+6AcJ5BcVhwOtQSOLxlTs25Hsrv8L1et8edfeqf/rxrZjbs?=
 =?us-ascii?Q?6MqJOReUpyxsOhIqzZzwspjkwC2ZmOO4hFW0cSLSrTckAzmXQsPktm4LbdQe?=
 =?us-ascii?Q?cty0my64wnj1yooS/zyM8iNnHHgtAXSMTwuc04F3Wl4HBiC0e//ogp2bpOHQ?=
 =?us-ascii?Q?jRL7rL0oDuq8LXchTZdZDbfomsicoBt2veEnDPRcW27GKxtVqBT36awBWQRd?=
 =?us-ascii?Q?AnOamgBQkim/g3VfTOSBEjGp350RYjXBhSxwHep6i5fCIQXKtR2wnZtTUyLS?=
 =?us-ascii?Q?q181WgFklrekeLUKIbY4by4pSMys8tyz1Smsqk009BDCdxS2/XV+zWBCYR8N?=
 =?us-ascii?Q?hvH3hiAKs4hbE3d0m6yssqcYXuNtxC2pz0ycwrs05WsUa7xGzKkLajIBHQX6?=
 =?us-ascii?Q?7ms/T3jNM67ZnCSi5wRQIFHoxNTK/ceKrQXrCGMs+pzhtQGk64OWq+gf2D25?=
 =?us-ascii?Q?lokyG6h3J7keDs9y5JW066MYSdh+ushnhs8R/Gk+u7TyIZQheVdvnqL5dmF/?=
 =?us-ascii?Q?r9MXiNwhbIKTY2nfp3DfRG/Q0KbuJRI+ixGREHZBqFJ4FArhRsYscQfP0RYT?=
 =?us-ascii?Q?NZv7Io7jmgEr7nv6rFKWpqstg6PtaWaCIEDkre+xq4V4zc+6S6kbrFzpzLLZ?=
 =?us-ascii?Q?hcJEK4rxosFnBlAH59gpbHZrK1qmxFfhkmEljw4fg5Fjv1GBGEPioLzIxz9H?=
 =?us-ascii?Q?vBZCcZGFC7xSm0SDNyrBCT87Wd2B9lQHZNbgJ+I8x60BeMU6PPxp1cndTg2z?=
 =?us-ascii?Q?a3lZTBrBaJaLb4HzKoJe9lby2hGb1yKBSKg/yRc1ddmJ1MbB5F1Ja+9jODYC?=
 =?us-ascii?Q?n0Ei/MZJ+nqXbb6b2WTs5PoC2QYodYlStofqnuIRneOI0LI7WABxRTwHBkww?=
 =?us-ascii?Q?CF6RRBEFPkaY0ERQcEJzuBpHbRcz6EB3J/iifd1d/8xn2wKKjYLIuMJUbmjb?=
 =?us-ascii?Q?AjqJoVa7FAMdyNo8rU3GwpiTkmeryrTP+l+PSSS4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2b45c84-92ce-4367-e823-08dcb6246366
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 14:30:58.3938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DDGb+83xU15MQsoNYTsLHbJeW9DLlvphu+NcVPqAnjKCYO6aO1W6Z4Uw4sIdVc2U
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6822

On Tue, Jul 30, 2024 at 11:35:17AM -0600, Alex Williamson wrote:

> Even if QEMU defines the layout for a device, there may be multiple
> versions of that device.  For example, maybe we just add PASID now, but
> at some point we decide that we do want to replicate the PF serial
> number capability.  At that point we have versions of the device which
> would need to be tied to versions of the machine and maybe also
> selected via a profile switch on the device command line.

This is the larger end state I see here.

When the admin asks to install a vPCI function into a VM the admin
would specify they want, say, 'virtio-net vPCI spec 1.0'.

The text of spec 1.0 would specify each and every bit of config space
and register layout. It would specify the content of the live
migration blobs, and an exact feature set/behaviors the device must
advertise.

Even if the device can do more, a combination of the VMM and the
variant PCI driver+device FW would make it do only what spec 1.0 says
it should do.

You can imagine there would be a range of these standards available,
and large sites have a high chance to have their own private forks.

This should be viewed as totally opposite the current VFIO behavior
that intends to reflect the exact device, as-is, into the VM. I think
we can reasonably have different approaches to each.

So, how we manage this as an ecosystem, I don't know. It sure would be
nice to not need kernel changes to push through a new virtual device
spec!

But I think your summary is good.

Thanks,
Jason

