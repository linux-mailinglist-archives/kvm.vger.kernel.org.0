Return-Path: <kvm+bounces-18124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EB0098CE658
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 15:50:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A4781C20A11
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 13:50:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCBE812C463;
	Fri, 24 May 2024 13:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iP7mSUH1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2084.outbound.protection.outlook.com [40.107.244.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C28539FF4;
	Fri, 24 May 2024 13:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716558606; cv=fail; b=kUAgHJ5Y3u/nZ3SKir+5UbS/KYdfONniI6UXrhkey4jg4yfab1fegCZKVI5zvOef8oAteBUDa/k4Tmm71+nP5AEMclnnvQVdbcsaKlE4HnINeWgOlm2pqKqGUKWlOTQN36Cuk3ZRI0jOUltULcJrL7RbuQAGiLmGhRIv0Boad9o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716558606; c=relaxed/simple;
	bh=tIq7bag9QNivcDxhTXzObAd3hx4NO2pOkzMyzMrODOk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TnxFLj4n7zDFs2aN6xWgL4i/99IvpU88wv9+OmDLZTfSfRWmzd+qLVvcSNr8Oozsufv8jdAvkFaiASSXRe9su2uJO5syXDaGWBgMbKGL46auJnIntno2n3WzPNzqfnpykzsKOi7om1NxixZTZNV5xd24H7cYBdas1r3Z+e6XWCg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iP7mSUH1; arc=fail smtp.client-ip=40.107.244.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QBH1/qsYHkUxU//SRwFpOgMuIdLFFWKYwd6t7WJI6wTBW/e0jkawMG8n9xszN319hRHK4MYc1j3Q7COzvOB7AMraDDN2z943mlZ8s3l3C+SUOTiYiYXKaIdH7eCohE7Pp6naSQ+5AzcJYEfLtM4UntX7Iyt2Z/JcN9PWvALE258pGcVm8Wrwdh3T2K3pszluqC1kBM+a+fMJoh8Fie/NpyBSBN/UuI8mL9C/FrxDXz7WOO15xtKwBk6gUOFbnRiCyDgn8Nx5e/IGL4ObV/k+xnqU8X/HxVhdKBVqCWRsbvimb8zoYYDSJXOj/V3gypWvx2cpRyMG1JnMe4cgddhn+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uFd0Q+4SyUgR+368N01G8HRYTOiQfBnSRCKZzqyiitU=;
 b=d+AGImsu5iPJG0hWvu/LULlkrEhBUFkkKtTMLGqgvrjvrDR5REulYfD1kRQpMbfEV6tRvCKyrYk5dhUx8BcAGxhrKFQWRD1i+Gy7dSptDoTthUjnyZYUej9lrKtbygk8VUDNvlFuTW07q3tLVpkfMBurnN/1e1IBi7z3qcGDfLX2q3c/fTWzY2C/Rl0nayyCzm8q4nqsaiXl7DXZSjN0CZ2sL/BGK+q7ySy7D5LTaeOmu6EfiRabUiblQ67893bY2ilW6hztrtzleXGJJ9Cz6pQsKr7oEC4KqrfxSRqW0tzQSC9Ac7J00vdZIzjXd1GJ7w25pNzQ7UXtpyy/dXjxXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uFd0Q+4SyUgR+368N01G8HRYTOiQfBnSRCKZzqyiitU=;
 b=iP7mSUH1wnuCITzSz6iznXisNfcG8zAAr2uxwoBc6P3ffYhn8eqnqWc1pOy9kPW7Soq1VD8k0XnoAiUAQ0/FwzM2SMwUrMa+ZRyIQQ+DoTYIlaTOOBwfd4pAA8hvFD3ckn31bQjb+dsjYzyyHQsJKqZh7mMtoecSzlAFbniOcy2mp8fQTYRYkdZKRFFnCWerS7o+/J+n3li9sZjRLkrlcBxVUWHokr0b8ENiEJ7EcvrW8N1bOBT+Wfut7AAvljz4dV6D7tTx6czNXxeiCCqKMxgJeGFu+yfDvHcD/B16Li5yQdZ+d/prESXEnWajSC3tjSzOQORSyO3fihcifYr5zA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by IA0PR12MB8327.namprd12.prod.outlook.com (2603:10b6:208:40e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.20; Fri, 24 May
 2024 13:50:01 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7611.016; Fri, 24 May 2024
 13:50:01 +0000
Date: Fri, 24 May 2024 10:50:00 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
	"Vetter, Daniel" <daniel.vetter@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"luto@kernel.org" <luto@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"will@kernel.org" <will@kernel.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH 4/5] vfio/type1: Flush CPU caches on DMA pages in
 non-coherent domains
Message-ID: <20240524135000.GY20229@nvidia.com>
References: <20240521163400.GK20229@nvidia.com>
 <20240521121945.7f144230.alex.williamson@redhat.com>
 <20240521183745.GP20229@nvidia.com>
 <BN9PR11MB52769E209C5B978C7094A5C08CEB2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240522122939.GT20229@nvidia.com>
 <BN9PR11MB527604CDF2E7FA49176200028CEB2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240522233213.GI20229@nvidia.com>
 <BN9PR11MB5276C2DD3F924ED2EB6AD3988CEB2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240523145848.GN20229@nvidia.com>
 <20240523164753.32e714d5.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240523164753.32e714d5.alex.williamson@redhat.com>
X-ClientProxiedBy: YT1P288CA0021.CANP288.PROD.OUTLOOK.COM (2603:10b6:b01::34)
 To DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|IA0PR12MB8327:EE_
X-MS-Office365-Filtering-Correlation-Id: 1199e791-5d96-4817-cc3f-08dc7bf86866
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HlqkLdOgkpZL+LaOBishs32c5poLj3JUoxjsBpH2khIiFzkZM6CXVqWaoxdX?=
 =?us-ascii?Q?Je3G9T6Ia2L1aw+7w9u+ZbGjlqCB+942katqjRyyAQE4TcyNcvbOiBj8bvSH?=
 =?us-ascii?Q?P3oxT01Isc1ICtZrjDYa4csVN2q54pFmk1svTg0DOjrasM109VO/qH1EDnK+?=
 =?us-ascii?Q?Ibwpsuc0NDKHrmqfLVBV7HSVxJ0BPX++hz7x1g3lGUgPkBNZXJJSLXAixzBh?=
 =?us-ascii?Q?KF8sG0ZLVNoXmcxX6UK9OKOCsUtnKZAZ1b4znooUSIRtVpPrHISOr2FxQBGf?=
 =?us-ascii?Q?Yzmqdg/WO7cFFnj6iWyEmzp0tZrBlNesIKJjoWyqrqg8PeFovttrR2FNwm5x?=
 =?us-ascii?Q?WMq//r9OE91k3UCLjUG/OSMkvzCKvEws5uupt7f21jnKcuGY9e1Zf8sKAM47?=
 =?us-ascii?Q?Q48SnFHzMwMDpsBpr5bdlkwzZLO6VVp2g/q4Sbs59Y8tOX1A0r0ht/BinKiw?=
 =?us-ascii?Q?s4P+6DOGhr8gFx6Mm6HKze31wslh/uLLZG+P7AvtQng6Mjvh8cJMjhmmVhIX?=
 =?us-ascii?Q?s5fNZeySjK86g+zDfJ+Jka3pmzjr+OUEnIANejSxGtirgt56SWQ2SmRO87DE?=
 =?us-ascii?Q?ZGkuNOtLvebfY08Ur+uMlCc3MsOzY0Eaw/o4mWuNle+SdJcD5fv/RfAMO+X2?=
 =?us-ascii?Q?VhZJBHQo8rYEH06Cr2/ozAYMtD2mwVEDB+2j3RhQTnOAffOucYXqljm+utaN?=
 =?us-ascii?Q?hoofxrMPnPUiOd41bmwSifra1jb24+qczAibgC2B2Pjqz28CPBvfGmWV1Bvh?=
 =?us-ascii?Q?uX+eZ+RnKQhlVnGvi4VsPDLrt5V4jsiK57TC6fKJzTV60J+X1iyeDMDr9LE+?=
 =?us-ascii?Q?01roB592Q5qsg/pzIYBrB6o69VCfbnn9IyAMgRQKuNn22Lh4+VR48czUlKyJ?=
 =?us-ascii?Q?hN0/Npoxd8ixyuPPzPNLVJ6NWIusBmjX2JO5Br5mpYM/y+FcYNasUwJxyIWW?=
 =?us-ascii?Q?ynIOlGTECLezILr4/e/112x2AV1nOx4PKmuDvqEuks86S1iPcDT1Qihu3F6x?=
 =?us-ascii?Q?UrqOFDV31EVP2CIx0HJ9czD5fAndM0/8XYiQ0vLL7ONHuOoykjeKOcgxo2zp?=
 =?us-ascii?Q?7X+GFQKYbpWA4846+PTLUyDjXoTokIkF0RmZR4EBuFCV3hPizUSa1KsfCu78?=
 =?us-ascii?Q?wby5akqGdtCZdFl+2Z7zq9aAVqQOUJmKqYTWp+CdeBit2TrVL3MZMoEMmYaN?=
 =?us-ascii?Q?pm+Bebv6vTYxObWSMVep9u2YQB4GygivvaDAXVYYVvwECBiSEXcM/FWBtTX6?=
 =?us-ascii?Q?Ii3HynGD/1bgSo2TcVtU3R/ee192XufrvtFDNjMwPg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qyi20CXaTPund6bEb/XpGHrRnKjIizQDQhvknlmBZyctoEA8dZ0BGTT4CJVm?=
 =?us-ascii?Q?nM+RfU7ZDdzQxm6v1BR3aV6gZN/78k3pLmJttpYZrcAT1Px/lqnI3DcE88Q5?=
 =?us-ascii?Q?GWLgk2cWOJlVeiqEhkkrszDq80zZyWmJHfHgEczmlrOIRWd18RtZs242Qeic?=
 =?us-ascii?Q?jX9WUv4gNxUwcjjLz1zMJ/637pzL719sH9xKJrDJYpHYiNu6T8VknBjmomry?=
 =?us-ascii?Q?L9RRu0kVRNMxa4g9cHHw/ag5Ll9OeT524s3pNiFp1nk8l5KYRd1YM+NXVUUw?=
 =?us-ascii?Q?fC99kUKFLgqeTD8YYiQfCjOu2hhrrgp+vdB+56CmnC493xYQ85KUHhEQgSDV?=
 =?us-ascii?Q?NJVd8Isvm2B71jzUzGyZbf7igxb0WBjD0TmKG0Cv3fyrkeG/gIY/EsrSlFyI?=
 =?us-ascii?Q?/+ILKYM/aUfYgp16xZ6mEwXH4yEkXCwZRO4yfkJVyUglQBnr+wP7HAG8OpBz?=
 =?us-ascii?Q?UDoWC9d1ArxLqrt5s4kHhU8NsvDpWaVGHh5aL+VU7jbq02UVr9ApDRRTtbxz?=
 =?us-ascii?Q?CH7YMGDU8D/dxSrQp+hYvmwiZChrLFAbcN4QXWuS9Se0L5z9AZg01Pc3kHdU?=
 =?us-ascii?Q?bwEh+jySaDpQX13urnFt5lnleghW/ea3XPIxNHchTBC/xY2P9pWvy2uAj8DX?=
 =?us-ascii?Q?7vB2ajiZuxzxmCVCmGaGeRm6EpLiC00ElujiZxIbufZOFoaaVYB3KXTKgci2?=
 =?us-ascii?Q?MrWfbjFrCzy2k25qaJkBpph5tzBA2qLXgRVmnYSd/zbwaumM0nJeyq6UTlFm?=
 =?us-ascii?Q?2cWiAwOyc4eR+fAy/7VZM9G9b7BkXtRwug9/KLciNxS+5EidSl23WQmuGFdF?=
 =?us-ascii?Q?f0bNud/oJ2wxGdlMq9VcXbuQ1ta+LoOHTjfQo970R2/SulE/akZXGN8wQJvk?=
 =?us-ascii?Q?pzylNm+j/eVGOuM3MPPg/FDPSJ1+hnXpBkJokg4q0N5A6403i5nNa2O1UxBb?=
 =?us-ascii?Q?c4Btq50Lru4psANdjKxrtYr7eEyRiRMApMRhICEXdgJk66p0cf71KAsd3rXy?=
 =?us-ascii?Q?a1KpsxavPNumR5GaS0F9QOBawhM4AWmijv0uMc0T/Ymvc67n9HXwq79yr9TV?=
 =?us-ascii?Q?dSG9mY0OnRpny+AZ/cNLZkwLuanJ8zX2aVAdJJiPgpeN1blCzXkINJYr53mP?=
 =?us-ascii?Q?m1rlTBMuV9XWddqfLrrdfC/UeoLCJzUn9mMUrPAn0UDl/YZsVZC0W0Myjk40?=
 =?us-ascii?Q?iFeS7qT9AJd+JMWOwqYQCqu/mvRhF+mVGBkaEyhvidVnaN5wuDPQSwp6Hiq3?=
 =?us-ascii?Q?V7hSL7+Spq1wHIW21JFhV9sXwo/Jd9JyA050xDCKKcwpa2TR5LbBZOxgNOyO?=
 =?us-ascii?Q?YCG3hhZQBTGbDzux/Sa/LgK6KQom/mpYheTj87ZrlLJldo3nzDU3V2AbgRXV?=
 =?us-ascii?Q?NY+im8Iq4meTNwd4ASpOQ+HJuNEIEBVdXxNsLHmT7kef87Xi3mtK/GuioHM2?=
 =?us-ascii?Q?45YsBQmzTDU/vQ/bbVqR44PF37DE5JAtVeFuk2F0cQuUZaqOLYfnXdwzctgI?=
 =?us-ascii?Q?zKbl3dcP3SgVj01yGvtW2Dc9hcjBUgXta0kuyYE+ttZrgV1bItq4h0Yddq8/?=
 =?us-ascii?Q?Q15cf/Jx07elv9AddDqsUVqX42ivoD/jziJoe7Hi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1199e791-5d96-4817-cc3f-08dc7bf86866
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2024 13:50:01.4578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NYamzHYGlQdkhhfS717TDub7F4llImwOhhVMp6ENay7w6zJX9NcDl7p4hjKW/ij4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8327

On Thu, May 23, 2024 at 04:47:53PM -0600, Alex Williamson wrote:

> > > > I am suggesting to do both checks:
> > > >  - If the iommu domain indicates it has force coherency then leave PCI
> > > >    no-snoop alone and no flush
> > > >  - If the PCI NOSNOOP bit is or can be 0 then no flush
> > > >  - Otherwise flush  
> > > 
> > > How to judge whether PCI NOSNOOP can be 0? If following PCI spec
> > > it can always be set to 0 but then we break the requirement for Intel
> > > GPU. If we explicitly exempt Intel GPU in 2nd check  then what'd be
> > > the value of doing that generic check?  
> > 
> > Non-PCI environments still have this problem, and the first check does
> > help them since we don't have PCI config space there.
> > 
> > PCI can supply more information (no snoop impossible) and variant
> > drivers can add in too (want no snoop)
> 
> I'm not sure I follow either.  Since i915 doesn't set or test no-snoop
> enable, I think we need to assume drivers expect the reset value, so a
> device that supports no-snoop expects to use it, ie. we can't trap on
> no-snoop enable being set, the device is more likely to just operate
> with reduced performance if we surreptitiously clear the bit.

I'm not sure I understand this paragraph?

> The current proposal is to enable flushing based only on the domain
> enforcement of coherency.  I think the augmentation is therefore that
> if the device is PCI and the no-snoop enable bit is zero after reset
> (indicating hardwired to zero), we also don't need to flush.

Yes, that is a good additional starting point.
 
> I'm not sure the polarity of the variant drive statement above is
> correct.  If the no-snoop enable bit is set after reset, we'd assume
> no-snoop is possible, so the variant driver would only need a way to
> indicate the device doesn't actually use no-snoop.  For that it might
> just virtualize the no-snoop enable setting to vfio-pci-core.  Thanks,

I wrote that with the idea that VFIO would always force no-snoop to
0. The variant driver could opt out of this. We could also do the
reverse and leave no-snoop alone and have something force it off.

The other issue to keep in mind is that if no-snoop is disabled when
we attach the domains we shouldn't allow the VMM to turn it on later.

Jason

