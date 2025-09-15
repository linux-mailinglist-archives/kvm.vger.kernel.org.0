Return-Path: <kvm+bounces-57584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 40B7EB57F9C
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 16:55:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6ADF72A0E99
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 14:54:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3438343D73;
	Mon, 15 Sep 2025 14:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="N6U9Bn7o"
X-Original-To: kvm@vger.kernel.org
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012027.outbound.protection.outlook.com [52.101.53.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFF62FD1C2;
	Mon, 15 Sep 2025 14:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757947948; cv=fail; b=ABeoOlNPFErcuNcJshJ0dqJ+98fpBbz5DVqZldSd/nCEhw7PoJmvvaDhCkivkZqkndmd/2SHOT48TyCZcxkL16KPuVrTwkD+dpdQAZsZrGV7CojnBHkP0Wax67EzwoYYsgUOTL+GC5yBZoyOnXoGNysuE0+ZClAqVEeigXrz75g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757947948; c=relaxed/simple;
	bh=Nn6A3WBitidrdBcgzP3chQMbRjDruoOUM2QLoRCOHDk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PQvTmCPKWqAuZP3K3+Y6zCjCnWSa/i4/uB99qhnj7lTZNKQg8cXtyZC8ujhS1w77KSi318pMMXCIuA5L8YjRYT+UhimcUagNXLeD9QPR5LTgC3UhIItpjAM8kh9NwTXUzT9i7ageuBoaasetmfeJDzGRKLOSbhirf6MKzKLhJpI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=N6U9Bn7o; arc=fail smtp.client-ip=52.101.53.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tfeb+w+06RVlilRr9fhKyrnFJtJoeESvFmMLMBketiPVN4rdxqVYxMxamtAunQEXAZr8MFYuc83BTP9sqhuGHHjLppLtmRGCm1IOpcEf681g6FXtXT7CQp0gfHj7mTjvmzdfIG0E7II09N2hGPflAK3jr9r+1NJkcbf9Nwu0Pou13joCUBGeQtmFcQ6+a3q0k48jAEObIyPrHjU9Chy1dWX7J+SLmBX/+waR8G4erLRpV0VV7YvQFaSWfDGdITR9QM1pj3opLDwhG7NCqv8qUEc8v+cdPzWhdLIclejU7BXCuwVHRNB7BvlAjf6UAqGm1lWXv58No7fRnhOnEbSweQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0zyUUQkV+kXAKAAdYLmtuoQqdA4ZFee95Syc4QxNVgU=;
 b=c727K+txNVBv1M4hg+XidGvuYpA8KlBM/QtRgi55fpOOIBZN4X27RRE/PSTr0kgMu65KhGdAMNeja0smL+hOE1WzNcIsLIK1fwUQsuvsBwVd3uxQ5qLSEKUrJCFUbywpGaqXtkzszGOPxv9/J4cSC1und3BP1FKnFKc/7QBocHvNUdQLcwPKxas70LnKI6fINuB4SHwyOV+g7y0JEo12GSHQCTHrKWmcRxHuri45VTDtVL6lGG4cE+ThwYNlPVGRB+W+pcTveoRJ2HTYcGIKevb/AJpcW10XTcKGXJ5Ar9UmK4dpHBZ/oj1tyHYSpQ1208f0nEYzFIunxdaPPWWxyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0zyUUQkV+kXAKAAdYLmtuoQqdA4ZFee95Syc4QxNVgU=;
 b=N6U9Bn7oUU2ltv8WWtDTSJnis4nxPYBG4hA09dhXMH6x52X8u438j98fKZ5K46yt+GENFjiDAFrwWF9qJq0wGoaticgqgEGTT3kJ3FFZBGMWKWS2lFCHPIapA7POnOZa68anwZuE4GDyIlY0VPd+29bORia3jtkJgIyXeBdJT7I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by CH2PR12MB4327.namprd12.prod.outlook.com (2603:10b6:610:7d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Mon, 15 Sep
 2025 14:52:23 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::4c66:bb63:9a92:a69d]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::4c66:bb63:9a92:a69d%3]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 14:52:23 +0000
Date: Mon, 15 Sep 2025 09:52:08 -0500
From: John Allen <john.allen@amd.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
	pbonzini@redhat.com, dave.hansen@intel.com,
	rick.p.edgecombe@intel.com, mlevitsk@redhat.com,
	weijiang.yang@intel.com, chao.gao@intel.com, bp@alien8.de,
	dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
	tglx@linutronix.de, thomas.lendacky@amd.com
Subject: Re: [PATCH v4 0/5] Enable Shadow Stack Virtualization for SVM
Message-ID: <aMgoGLL65vUPGYW0@AUSJOHALLEN.amd.com>
References: <20250908201750.98824-1-john.allen@amd.com>
 <aMSkp7e7IryG2ZAj@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMSkp7e7IryG2ZAj@google.com>
X-ClientProxiedBy: BY3PR10CA0022.namprd10.prod.outlook.com
 (2603:10b6:a03:255::27) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|CH2PR12MB4327:EE_
X-MS-Office365-Filtering-Correlation-Id: e84c4a09-9240-4e72-4a00-08ddf4677a6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?e9psYkw9bNPKfgxWq0+UOxnzC792s8hzqoAywy6/90fa0U5DSrJgWrlB55Th?=
 =?us-ascii?Q?PSe5HRjK6X0k6yOAzX4q1n1HK/uVG1YHaf94rqnI4H+xtDtK6IUIWuiYVGIa?=
 =?us-ascii?Q?47CsMgjO0BbFpA2DkYNEA5vcrtBG2SHQPFjtlSUlTqLRSifLqFhVDskf5Aw7?=
 =?us-ascii?Q?DloPAfybLEGDV8l9pqgwAdqAAUwR4iXLEfIbKBVrFM/m3Biq8062odcURqC4?=
 =?us-ascii?Q?aYwy//VRHumffRxjcWpQGF32Dh7jI+manPb+rONZQSQFBIfQ1rLu4kWHYC0s?=
 =?us-ascii?Q?/JPe9YPFVGk6fzmGtf7FwD7s6rlEsPNYPh/k7cPm7CSU35ixSpi3flYQo7HM?=
 =?us-ascii?Q?BvPZUTY1ERtAQGlVIlLbqQBWVYRwjsIIJPf2uDDKpmIgW1CzlC+GmFp2H91l?=
 =?us-ascii?Q?yJ6ucoIah4lofMdFgCbaFL2Xd8j0GnyvgvSLNnfq5m3gXFvVOmAHimdFuT40?=
 =?us-ascii?Q?YYkZyl/F1oAziEKgSkGZFtn40anGLCY5Lhozm6vZbhZsbpDgh4VFkgNZKfy0?=
 =?us-ascii?Q?C5G/w8Lix6iiT4o4M8IiEIZ1LhGB9iS7UU15tpz5sOyyoyIjuy+xK1BKXTF5?=
 =?us-ascii?Q?vqtKK3o9qzHh/BSv/zPX+BHW2JBxDZgVJ5XTQiktlfyhH5jFN9MOCJwy8nJt?=
 =?us-ascii?Q?To4UQqkLfkMl/VvjPJVoT9b4Wp130L2G9c8/xzfQqlLggHjf5oLYtkay9LtZ?=
 =?us-ascii?Q?CgWIgWo5hVkuDV4M9lDihQyi2GdepNolSYoawjenH1t4MV3oyWzsyf+dkn3V?=
 =?us-ascii?Q?/ttmxfWysEtsF7VCAvk1VZ0p8+++DPRpIqQprBPeeLOl+jqaqMUZ/d0EDjkf?=
 =?us-ascii?Q?tLh/OYTQCtRZVigMCNo1MbTww478OTbv9sY5rLQzgUwjdvguXKQ52WtW+MXE?=
 =?us-ascii?Q?yYNh0dbSfDMaUTzSGSvSNlEqw/+CvEUKFYh6gOKmJm6ajdaqj8WO6mWJQEzg?=
 =?us-ascii?Q?8tcsgjxV2wwbjJNW8GtPBfMX050oj0+Vm6W4L6jt+RGtUfi9IzVDlnsPey+U?=
 =?us-ascii?Q?jR8QYjvnjjWpa9lQsnNu4HgwNGOfv5CpdcPMX9xUV0/buQQPitD7NV1rQ7Fq?=
 =?us-ascii?Q?t+sijt7cL8ppRiWd6m8Q/smK6GAoN3AjHnojIvd29Mu5Fqk3EzC8RcE3kqaq?=
 =?us-ascii?Q?0LwVpYX1tQDVZMaDZYtIeYZiIwlSpwB3WMEcPfz1LBiYxyqWR/I+GXMDvnZz?=
 =?us-ascii?Q?HacOq+vkUr888MJ7HtQisicjV2gUn8Eb+MMfQ+mYC/H2ofqlLgpiDq8fM1Dv?=
 =?us-ascii?Q?TKW3XWcL9uiPh67nM2nWB+xjFtzby//TslY6R81gbZL0vVAMfg/oLgP+8qwv?=
 =?us-ascii?Q?UXatirYpQzFv+eTxpMuT5CInj7+ZSR6XXW+IOrq0JrRYFQxPut6vMtXJcuZK?=
 =?us-ascii?Q?LDM+tv96NQ4hyL7uFbrfMr2vh+2Lhl94G+Xr7s26qD4yru73JQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Zy06V18NKp+AKwypy/5hVbAtH5G/y5OfhXtgF3iwUgHllLIg/PWiellgaSMQ?=
 =?us-ascii?Q?TsVKgslKpIcDtFbysjvzKHta7TygIezZQYqnPiNr1SKtvXsHLlnDKWs93VuK?=
 =?us-ascii?Q?WsCujgsPWDxUq3vUcxrQLBE3fdNCncer6LIDbfMAEAPvrQqg0YSwIcaADtLS?=
 =?us-ascii?Q?qEkkrHBpURQ87xNkZ0bFmgw0j4IHubBuCQ8LU6UAhvr+s5y1O+E9Ns1Y5yyA?=
 =?us-ascii?Q?5oqGS/ZYpMpzxDFcBJZJGEIDtw1pjGr+cUQv4AkcVovbll6Ct8oXgeq/7IiV?=
 =?us-ascii?Q?uoM7kGGttNszWvO6mbm6SXAg0XwVk7Upm2Wu6zD0ESmO1yBon1spf8GCHZfa?=
 =?us-ascii?Q?YKG81j7GmFA2eQEUkxpGeP9e1+InJlPqZHPt4Ad6ModN5iUMfNnVISNggTQD?=
 =?us-ascii?Q?ewYgits1B0wK56yz4TucyMHjMoztGEbRpB3AENzlUeisBsQKVOkqT93iT6/X?=
 =?us-ascii?Q?wM9Sz1qn2k6zrQCvH0WnIN+rEZbuznB+b/jnhho9Dkk8ePrbN/RNMq/L00+R?=
 =?us-ascii?Q?EIrNjrnREc0/AQKpv+Dm/Jkm81Pa60RCnBUpZD39AW4Vpb7+YMdm0aZ8wxcr?=
 =?us-ascii?Q?FD4jNWHBfxxEKtBISLKvAxnJR/Ok8tUyNv671pzh/HS3FIYE84qufzehfXm4?=
 =?us-ascii?Q?VoXvZDbddKmSffvIpCCqsiASLkg+wcDDLJVN0j0dfRvfn5as6/G0uDKhJQEy?=
 =?us-ascii?Q?QwHceWZVbVRJhMCxXzUmz+u32nFEY9rgvA6ZfQENkfiJrnEqMwdtJ0xRqN1n?=
 =?us-ascii?Q?BB9//VosbNteW9xUrnRWEYHuo46dWN5pOQ1Nxeyhd+N2XUX84Ygm5XaNSLRk?=
 =?us-ascii?Q?RbGDHmVk426rQnFsVSabFm+I3DeWbEup0YrJNLvON+sLCuSFEpsA7dCuYQ6e?=
 =?us-ascii?Q?0H1MTAxEgwik/DZF9/PMaC4GbvnGcpeTGxhBLQq5AsMZqV4fvBNTKUz+YXDv?=
 =?us-ascii?Q?9xw38luChib1qIq6UXEZGxbxjbnSPGJoIxhOqlgmo8+w0QPv3Msq8BKww333?=
 =?us-ascii?Q?+ueYuXDbFC31opDQJ0mH95+qAsZ69NJlRiB/VMJ/t9L1OKBOtH7VBF/EgLJK?=
 =?us-ascii?Q?BD7dhvh8rtx/p5qaINir9lnbQ83E4lA3YGHDiqvqF0cjhl471LSGMMvnlcCx?=
 =?us-ascii?Q?ewAGXsiEb8d2mVB0ZpPQSN3WL34U8RW+kFoZjrKp3uwmGacn21Ao6o3sU+6/?=
 =?us-ascii?Q?1N6bHiVywAh8Bts0BnLYPp211Iba5M4rR1LxEjtAJSFiSvnZWkXKm21vL7Hi?=
 =?us-ascii?Q?/tfFqBnzkAdYbf7JlcRSc2/vo0tWGFSBs31FkGFgXNvqjDSmnrAEtLQ8WswI?=
 =?us-ascii?Q?25JPRbjaNrGh3GC7hP7fYAZr4O5eY9iFyt0tLp8FxfyKA5zvvjSaNqPFgf6s?=
 =?us-ascii?Q?yZR8avYI5qWs1gTVd9c2tcQJAyJcrXRQDnpbHwQxYMIOJ377CJ2jbGZTywyD?=
 =?us-ascii?Q?mXs/0+0pLiTsx1AyYnPCmxp8bxtbB05jiQg/W+yPML/3ry6vY0c70Vd6pHIv?=
 =?us-ascii?Q?C9G8WdpBhpJzHYJlB5IRgqiBR4wdgz/XNoDB4axsB5Uf3c5sZmevo2ofJKQd?=
 =?us-ascii?Q?BuP5tluRlCS8MrUU+XHs+gcOjJng1SEUzyx3nw30?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e84c4a09-9240-4e72-4a00-08ddf4677a6a
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 14:52:23.1737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L6GXKp0JCdjN47LsnIKFKnNUdKaQLEz1JgqitAmVnGPfkv0HbiNCFjDQfbGqnJHP3Bxvy0kMarmgiqwX3NpRVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4327

On Fri, Sep 12, 2025 at 03:54:31PM -0700, Sean Christopherson wrote:
> On Mon, Sep 08, 2025, John Allen wrote:
> > This series adds support for shadow stack in SVM guests
>                   ^
>                   |
>                 some
> 
> I mean, who cares about nested, right?
> 
> Sorry for being snippy, but I am more than a bit peeved that we're effectively
> on revision 6 of this series, and apparently no one has thought to do even basic
> tested of nested SVM.

Hi Sean,

I have been testing nested with this feature (or so I thought). Can you
explain what you did to test and what wasn't working?

Apologies, and thanks for taking the time to look into the problem.

Thanks,
John

