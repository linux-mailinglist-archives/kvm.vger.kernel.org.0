Return-Path: <kvm+bounces-38162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E4A9A35DC8
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 13:42:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D2B113AD07F
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 12:41:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9668263F4C;
	Fri, 14 Feb 2025 12:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JQYfBs5X"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2048.outbound.protection.outlook.com [40.107.223.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EEE8263F25;
	Fri, 14 Feb 2025 12:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739536916; cv=fail; b=mtIeR+IPpz2H4396GAMwOhk+7Zj8Fu2M/5mZmbkkxueMj22HhawGJWoePuQqeUi8xs0ZbvyzrRZu/7lH9TqDJ63rbMUDci7Vyh7dv+GhhvVM6TWkIMpxBXlFBtI7xRxDKS2kPB2+29HisZQvOvAYJzahrp1z50holRFd4HAgDaY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739536916; c=relaxed/simple;
	bh=I5g3tx+2V9N8aJ0gn2jdq3x6XCE/3YDvIva8TlIC7qA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kVaoq2U+PVBBgbW2QrdFsnzXyJZSv3EGdrXKZsxAy17aZAyx/T/JC2vU6J8m6EgH51qs4Wx5MC19LwNpM2/MIGrWsPO0t3XBC6PHg2+t/diRctDfzbKzcl/8sRVE2w7Ge8a2shx3wd9YzjI/Az4qQRvj3R2RqE8lIsBS/xJksGE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JQYfBs5X; arc=fail smtp.client-ip=40.107.223.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f0nj+mkaDIiSk6aHovo75DC+qkG0aVdR6JFy837/k/sC0y4O7t0W1DnHEqqh79co7uQyfrfvSZ47Z5rZbmy7xuAnJRgcAAu2zNrwP9gooW698Wpv1+WimBSRuMF9NhG3bR8fudbPa1zMu1I+tjiupDb80btd7lNTVs2zUVOLaVxC4M5m6a4Z4EvJxzr4qvVmlqazYSQORmO1q2v6vktOgW864bAQJnGlaA1V/6MsMyvm8etWbGdu6PeBW8KjdafXsnJ2vHBaAeDyCCrQ2nOhqY7QYGlnMuYdV2ire9wPt/0Dp+bMAKDXGMnc85IXEgnaICGN4L8lgcl4cLg3xRT/PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XQWl9xMuYY85rdQlvHJ5W+SEW8wy6U7MVkaB2+luvW8=;
 b=n2w63VHrbetnImx6tG8sy8z8PcdE0ZT0ve/BsDqMjtXUmTmh5GJco0dbL29jXq4x54uOfMkz/LJ+o+hkjFFrYJsQ1mZNdh5QKDAd0QPvgN2xMMWMpS0iR5lCE23Vqs2SL80+cV1NehjQ7R3+TLlYOiBN0txCy4uwCwnHU9KHHJR2QGVHkECsDHF1wrUKoeD6O3o6cwLUoTz8XRWYMpjMWACgL0hmEnoEJ8NH/1zkYEBR88a152j2ki6MAeYEpQ6AKHUFfzQn7+RtAifCH8iTQmAj8gtuz0DKLtjaiAIRKVAH8SpNRp7P8wmj5Em6jkngYoIPyYFoKKzvha4JT51T0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XQWl9xMuYY85rdQlvHJ5W+SEW8wy6U7MVkaB2+luvW8=;
 b=JQYfBs5XuGYyZyzQEEfLFxRSO9Zs9z7SqcR588vIEJStFUtMNePYfjiJ0mAXOsAOibcdkJ3pT5S2A2JWSePP1D2NIyEkbwiS2OvoGTcy7K4kY9lWiVJNJOG0ULobZRM9ix7Y8jbF9KLk71V9t6zUeGvWPkkSazN+IjIzd2j1pnzP73ZIGxbGgP8Wn8fHgSbVdXkl9SOPl1X8omWA9Si1Qc/w0WfTffV6h7XDI92roMo4GUJZSiGpLeZce1nBAMeb6JBIQrzM+DJE0HSZMzaFc+iGBP+CtmkIzrzN2s1DPaUW1xgiu1ogE5oW5Im6xUmdQxfDtZhlI7vbo4Mj3KqzQg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH8PR12MB7423.namprd12.prod.outlook.com (2603:10b6:510:229::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.11; Fri, 14 Feb
 2025 12:41:51 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8445.013; Fri, 14 Feb 2025
 12:41:51 +0000
Date: Fri, 14 Feb 2025 08:41:50 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: Zhangfei Gao <zhangfei.gao@linaro.org>, acpica-devel@lists.linux.dev,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Donald Dutile <ddutile@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v4 00/12] Initial support for SMMUv3 nested translation
Message-ID: <20250214124150.GF3886819@nvidia.com>
References: <20241113012359.GB35230@nvidia.com>
 <9df3dd17-375a-4327-b2a8-e9f7690d81b1@linux.intel.com>
 <20241113164316.GL35230@nvidia.com>
 <6ed97a10-853f-429e-8506-94b218050ad3@linux.intel.com>
 <20241115175522.GA35230@nvidia.com>
 <20250122192622.GA965540@nvidia.com>
 <284dd081-8d53-45ef-ae18-78b0388c98ca@linux.intel.com>
 <f7b6c833-b6c1-4154-9b77-13553e501f2b@linux.intel.com>
 <20250213184317.GB3886819@nvidia.com>
 <bc9f4477-7976-4955-85dc-3e05ebe95ead@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc9f4477-7976-4955-85dc-3e05ebe95ead@linux.intel.com>
X-ClientProxiedBy: BN9PR03CA0033.namprd03.prod.outlook.com
 (2603:10b6:408:fb::8) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH8PR12MB7423:EE_
X-MS-Office365-Filtering-Correlation-Id: 47647c5d-caac-4efd-f7dc-08dd4cf4f44f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?R9CalbDn7zrDJxi6P7m53Pasin+gYdKpvBSNjWbhU4FkfGmvun1nv5xhzekq?=
 =?us-ascii?Q?JlRGucdQa8GAMMJtviyawEZW08o6k8En1NqBLR7WF7Tz3ayxTRF38DzjtJw8?=
 =?us-ascii?Q?6QizdwcFwnl9hx25nStjINPafS7Gv6HobeCiofsn0wZQxR1z2/7aRinEYvkL?=
 =?us-ascii?Q?PllntjDU+bBOJ1NgkqUwkLVL62eH6cucjMWXLrDmyFFPLWRCRXJfqInpDtwt?=
 =?us-ascii?Q?t/fC6P2IKcvqgVV/TiCL5cO/5pr7JC/lNiDjrVb3Aoh2H3ge779+rOQ++UzD?=
 =?us-ascii?Q?b43FbSMk2c40MGBpEHtS7khvkaVEfAPO0hXX4q74Zttuz5L+4tVR6DbIM5SA?=
 =?us-ascii?Q?gbGwBbm5lMLHbigZcYNpAtd4JQwlHISFHcxcyWc7L+ChkfuvC4qg5IytzfyR?=
 =?us-ascii?Q?cnrkjVQM+KS8rWJPk+d8+U8urnIBQaUmmZKBF2wsJqxrPyKZt06+wbHZOs3W?=
 =?us-ascii?Q?oTWjK/B3OxGZEg9r3yXxTlVZq7dGbIqBO2j1lvttulB1KA63x61o0kOncW3a?=
 =?us-ascii?Q?ETAnv7LTB2YzitrNCTu8YAyyyntsVRQdHJKUxBfgHUnEghFySf1h4lLpllUY?=
 =?us-ascii?Q?knNfPp5r3cZOohzFQNsEFYxg6Yvr8LTrk/qxUTNUHSiP7MhFDXJ9iNQmOO/5?=
 =?us-ascii?Q?W8wDTN73/z+s3NTX2t3lSaUFQ0g0w0t95oBapKRbeDCC5KNxNfbFzCzs+syi?=
 =?us-ascii?Q?9dUW2Nn5b33ySZhdnOnuI0XEPKL9RnN3bRvBeDJ06taEobrMWdx1pIOWbTmb?=
 =?us-ascii?Q?A7vSr5blxQHRAQGoFQ3VCjpIdcqImi0Gbb8ytTaMn6UPgum4Me9iDeU8/X/l?=
 =?us-ascii?Q?nTku494s41jfwZoVcnei2CRzENXT7/2XubwwtLGu5p7hUXdvJKP2GT6wBEGW?=
 =?us-ascii?Q?pj6w1VcnnvmwzVPOI6BkjwMJV/M+BzZvzppMamjMUq2HV8mj4ytnFr7R83JH?=
 =?us-ascii?Q?JndBCs4KMcOavzKIYFqynAoAhlj+hvm1XPtMJjnCDmeGZ48h5DfTi+eYiAdr?=
 =?us-ascii?Q?4lQwjlfPr5vMvBA+H1iym4Ay13chkeH5kjr0IrEdQOvayKhQSvjJW3XPHC0y?=
 =?us-ascii?Q?n+ZmpVj4xTLNoAqtf248RzrPitK2wdkdon0P1kJaZAAAa01WmrYthrZlEOrP?=
 =?us-ascii?Q?iCHnBWQY4dSkbW/D+CHANhivvohfB59rIvwG/qAeTRUiFJ0SBfSwrLkVgBZN?=
 =?us-ascii?Q?VQDCEKEbZuhMFzbW3lRPYfpZvOfvu0gxrm3A2sXzkWCZKahQiSDBRfmxeSzw?=
 =?us-ascii?Q?L+LJq94Aao5wqJDMMGrpxSKDn9YcLxfjiMEps5T/sxKlVdkxjZXg4WuiJYES?=
 =?us-ascii?Q?sNygX7HUfD0SnBLUq4Q+8m+hdyh+2ORkTb3ok/0XWklbLIfnl+66JjfFIViz?=
 =?us-ascii?Q?cvzIab+S478It+a44axHC/rjFf8S?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lhxir4xWtiDPiwiTzAo/7caf5AnupSTrVxxxzX8CFr5G2c0WkeRskIbjHTmf?=
 =?us-ascii?Q?trpYtnwISXtKf/CIEx66CgTYuJWTXbBx72VYPG3n1YVcypVysj8mgKVInxWI?=
 =?us-ascii?Q?Xuos7HPxb1S/IJPaZcHdY7AOei6bs66NxosZQhsf24gh67soeXMQ6jLO1QSD?=
 =?us-ascii?Q?ll64kseFi5W3/0HkUhLaW7XhkIFPiOtNWInb8m+xlRYiDAFC1goeEdRFQGlX?=
 =?us-ascii?Q?rWiIvI4TiWhVXaUInw+qJLybWHywiK/LMN8JmlcBKy29KzA0DX1V4QUfKDwD?=
 =?us-ascii?Q?kD/R/+2QsBvqkanWso5lSGRI4WuFrUou7XoRKwzDN6eeP4hKvE2cUk7XbIMi?=
 =?us-ascii?Q?eFENivqjYcYjS9wyNfieQywjr+9eTZvKTF6NhTLw9MhCgM23KKtzkHsfeVMQ?=
 =?us-ascii?Q?fCXKvjylWIcnFo1495vBxhBDdah5nLtlDUIMQoPzGCJSyDupZ+ywDVWDQ6jD?=
 =?us-ascii?Q?iwkR8XOTj3BWxU56ShqW3/dXjWRqYTOkA8lFy0kE4ZJLlLoqbNqAV8+FGNfq?=
 =?us-ascii?Q?bJRlNh9awpVtXnynmEV8em9+F88IWuF9EgmBzJZgR+eKdZpm+i7E5sx9s0DJ?=
 =?us-ascii?Q?F9gr/JbaLAmw9sgDEFXgFwRXLEvdlulP7l3ObKwgflmv2STWjR0L8AHpEy+S?=
 =?us-ascii?Q?VXgipr9nXwrxLAKTwTPqwlNeHKtk1XecKxC27FX+focBZeU/tFKmhLFjghvt?=
 =?us-ascii?Q?EHliFBeQqBOy6O3PzM3IXKAyhXfYDOHb7KubaNdmf3UhZuPRj+pP9Wh/9n0w?=
 =?us-ascii?Q?W3n3cvhJmPq45JrQPD5POI4A+/uyouwaXWWHp9IDOD9vYnCtatkiqK2SyYwT?=
 =?us-ascii?Q?9dCt8dL7hYcPa+GUhD+PhWtMGaIitqoGMzvWoekQ/aLrlvRk0f52lRDI4buv?=
 =?us-ascii?Q?+4t/AupFnwtxDJeaGZzjqUiXmnBcA80hYjZgNJC92T9WkV1wQ458ARynOTRb?=
 =?us-ascii?Q?an2x21CB1jtPLIVTm/e6C9LEQnYf+qw8cBx8G7xmL3Tc7jhp6DkfnZBmT2ef?=
 =?us-ascii?Q?wXzc5ny0Vpd2xS3by1kvVpOboR/YBIEdyyDBKXlUUcJcjjqg738lA7eGREGa?=
 =?us-ascii?Q?LCu67xA0/+69ROXLy6H1TBzGRQ2IUIIIQU3CHkOkUYIB7ugkhsD7NCUhPGT/?=
 =?us-ascii?Q?pqoTspFTj0RnZ4IPTfiVrWvPEgkj18v8DO6KJqHqhC6TQoZ7FMlHrnHj1gg7?=
 =?us-ascii?Q?QRrFB3x3DLYF+OWxWcPzrDd401SxQoZ9mWfXzwNMB/pM+LM3+9N6hXt/PiMc?=
 =?us-ascii?Q?TGKW2xynEdS/bC6wR864Oz6fEdw/feYfLMsL7LPk8yCh5bl7cfXjmWGRH/NV?=
 =?us-ascii?Q?Vk83m7/AuneBiD5Wm2O6dgokGdEz3N1MfxwQ8VPLOdoPQXShj+Fjds6m5Vfe?=
 =?us-ascii?Q?khbcwPP0/AciRndo6I5KY93vR3LX4/I6CsMqEjXgHLe5S18fIUwxH963pE6S?=
 =?us-ascii?Q?iKFCN1h2yzQ543/eYGMLPu7p9t1jw/OPkq6Es+3iJ710ufod1/sGHi2We+3k?=
 =?us-ascii?Q?o6b3GT6aM8QrfCbr2t1KqngYQ4TOHi61KfxNpmpnCbLC8yibLVfXAz/hHnSF?=
 =?us-ascii?Q?796w9rdql/n6Ux1efr0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47647c5d-caac-4efd-f7dc-08dd4cf4f44f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 12:41:51.3120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zFZn5PxV3nd7tfzvxuooKcu7P+hqiIczeJ3GJU6ofDqrLALWG/P+8PmTU5JtmKB4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7423

On Fri, Feb 14, 2025 at 01:39:52PM +0800, Baolu Lu wrote:

> When the IOMMU is working in scalable mode, PASID and PRI are supported.
> ATS will always be enabled, even if the identity domain is attached to
> the device, because the PASID might use PRI, which depends on ATS
> functionality. This might not be the best choice, but it is the
> simplest and functional.

The arm driver keeps track of things and enables ATS when PASIDs are
present

> If any device does not work with the identity domain and ATS enabled,
> then we can add a quirk to the driver, as we already have such a
> mechanism.

The device should not care, as long as the HW works.. ARM has a weird
quirk where one of the two ways to configure an identity domain does
not work with ATS. If you have something like that as well then you
have to switch ATS off if the IOMMU is in a state where it will not
respond to it.

Otherwise, the HW I'm aware of uses ATS pretty selectively and it may
not make any real difference..

> > I feel like we should leave "iommu: Move PRI enablement for VF to
> > iommu driver" out for now, every driver needs this check?  AMD
> > supports SVA and PRI so it needs it too.
> 
> Yes, agreed.

Although, I'm wondering now, that check should be on the SVA paths as
well as the iommufd path..

> > Do you want to squash those fixup patches and post it?
> 
> Yes, sure. Let me post it for further review.

Thanks

Jason

