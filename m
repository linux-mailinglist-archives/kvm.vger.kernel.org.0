Return-Path: <kvm+bounces-17951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37EA38CC135
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 14:26:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E24EA284B64
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 12:26:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6099713D639;
	Wed, 22 May 2024 12:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PrqwbbG6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2071.outbound.protection.outlook.com [40.107.236.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5B313D623;
	Wed, 22 May 2024 12:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716380772; cv=fail; b=Qen+zkG0j7IJhXMKyfMnMOt8ka3k5cYAU+8gnPgCdHPdFWydZwbyRBZcw85EDSVpWY38BNx/ybowklcpVuUfHXXHPAIb2zQLWWRpdT2STu3odce+WYMt/IPKasRTO4pghyR/2+G9dhhzHzhJUBmT6qRU9IphuEiaXANi+bBwMKs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716380772; c=relaxed/simple;
	bh=bL7yr/gg36LlLcz2iCjrgXLSztmi3ngQm/W04MZzobo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=a8LhCHqFhKQHV1MPP3vz8T//d6BhuDCe72LrtYKaLrhKwXQPyVxImBJEPjF5GGHxtjAtZywpAQzRuotxwuEsDFzuFyg9chSLktYxEBliKxe7zWYcZmjKbzJs41xxyeQYXHi3WbNOmjUdYZ6OY49NI7Ueiv379WrYPY/jhZmBdPQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PrqwbbG6; arc=fail smtp.client-ip=40.107.236.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fI+49BSfPyRxz4KkLhXAb2ES1LIlMVa/CFsA5ssLuBCHhSjhNx2KvIfKy5856roIhfgMNMWBVQ7cYzCpdBPN9P/LumlOIvbN/9d8nwGw5wEbivZ2TmVHg+PdSO4tdUcAH2uHCvEUiDRtXmQ1DOAvNJcfthX1kl4hwvsnc7Hea//vnMvWXSei/DosA96bfmjVGgNlof6W0LvkUgOmK8KdKavJFwVCEDrCWjXajUKVpvKYWj+bLrR4EYwqscbIrW/Mzxx1f2aDUnpissAu7SY77Z/G1loD+VmZQrks5oN1yRdL/rfnz/RM10dEu8hHydaC5gzMMp6TkpBkdMAVMyzRaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ErUdUZxhevCGwPkZCF88dc+64kPotIwXqXIqbcXG3/I=;
 b=GFjV+GmrtDduFHlm8HfzbEU5fEX2/bF+6jgVdJxN5TpfTSlEpO8lrKMc3XKulONbV/tXm5SfjqnY5msB802LuzCrVBDp2CQrXV6KnbE0SoAXWYWJrCEpPmHMJ3Qt9Cw5ggYjVk90J32wQTVUPiLiI0IN79BN+lbtdmRmc8vHVH5BXRy06IxH3w3ugtsPXgLw3VsH+ZsdeOiNYyL8qf9FDBOxWSPNgqZs7WKE9+8oz2PvCAd4wWF8pHwVZFzAP0ZoIlFlTaUQdPUi+5kTMHGZBz9KgrRa8RDc0pBTb78MNsul5Kzhpx8fxXCrRq4VxFcfoswUXUVyxEneQvX6IHWPew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ErUdUZxhevCGwPkZCF88dc+64kPotIwXqXIqbcXG3/I=;
 b=PrqwbbG6YxXLkfrC/bkXM1Af5aHiKAQYJfYb8WnjSjdQ8pCRqUeQucV/ZiEbC+MimL8yCaFWYy3EPod26jWByu6rONJf7LmIPGmXpXYFCsUpRNJbyZt684jNB09vOTjWazahkguqV20P2P3rb7DRimiSihSCQsM3o+UAhN7C1VIEWrT0CG0op4C8G7Cj+h2JOl8dC+ayPeoJXxWdJwpzTqlWMZocuMWh3EmeKerCzfuyQs0pe6u5YtrYTkUArTLok7LwFKIO1dav+z/IowARM3ZOkWRd2mBsO+druBKtgYMDghWWsxrj3vYkjRnVKTMwQhfqNP4niXwfKM04S4b08A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH8PR12MB6915.namprd12.prod.outlook.com (2603:10b6:510:1bc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.19; Wed, 22 May
 2024 12:26:07 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7587.035; Wed, 22 May 2024
 12:26:07 +0000
Date: Wed, 22 May 2024 09:26:05 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	"Tian, Kevin" <kevin.tian@intel.com>,
	"Vetter, Daniel" <daniel.vetter@intel.com>,
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
Message-ID: <20240522122605.GS20229@nvidia.com>
References: <20240510105728.76d97bbb.alex.williamson@redhat.com>
 <ZkG9IEQwi7HG3YBk@yzhao56-desk.sh.intel.com>
 <BN9PR11MB52766D78684F6206121590B98CED2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240516143159.0416d6c7.alex.williamson@redhat.com>
 <20240517171117.GB20229@nvidia.com>
 <BN9PR11MB5276250B2CF376D15D16FF928CE92@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240521160714.GJ20229@nvidia.com>
 <20240521102123.7baaf85a.alex.williamson@redhat.com>
 <20240521163400.GK20229@nvidia.com>
 <Zk1lZNCPywTmythz@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zk1lZNCPywTmythz@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: BLAPR03CA0049.namprd03.prod.outlook.com
 (2603:10b6:208:32d::24) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH8PR12MB6915:EE_
X-MS-Office365-Filtering-Correlation-Id: f20991d1-6af3-4935-d45c-08dc7a5a5ad8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|7416005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qAi/i+oWQul+MJsTujTc5MvBpqAyS+DzstZjT+YLwNr5T6FLZ0P5VAs7NGxg?=
 =?us-ascii?Q?wuJ95xl/tEKK6+8BrKsAoCG+9TzCe+IaBe4frVS3P76LEVcoiiXTzmIO9FD6?=
 =?us-ascii?Q?TbL88EnD/R3pVLcD0cFTBLQ7n0fcKFrusfQxwKXWz0yX7IlSQ3du9kLnHqSd?=
 =?us-ascii?Q?rgSwCQpexvqf7gFtuaSPHm5o+HdZ3KIGhSEpkkt4GLEEZm+XZlrQAFfHLO07?=
 =?us-ascii?Q?bu5tRX19+iiAAhUtnLve6nUI+7VYNzZq6+MHmvltIbLQZZd802j0PviMdG/w?=
 =?us-ascii?Q?JV3KtL05F0OIv9OqMrqIlprvg9CsnSec69hHbLQKGM6iTfOwdBiAm/6vcLTN?=
 =?us-ascii?Q?zFD1SVxvqEOywZTV3rXSqpODT7iu0e8oGxKpyuMSojL3hLonkogTAZt8U0/U?=
 =?us-ascii?Q?koGUExhZ06KM9YlkS0904JiIKABq4vcWLMwygh0QKeoRAMo6MASP3J6V9vfA?=
 =?us-ascii?Q?0R9NcfxSgBPdHzcWiOY4YzQOeu+eFyPyBoghpADHuv1yvd/tUEIHnA+WZFI3?=
 =?us-ascii?Q?XeirIowPjSuK4fRRkWzWI14zJZOuBtaQZIVLezIFJ+BeWPCeOSOKeardkamo?=
 =?us-ascii?Q?/1+yipAYZsR0xWqbbZUlkjqJyctENiiY2KUEABghcauqx8fA6rCrjUyyfB6v?=
 =?us-ascii?Q?Z012CNPGw5tFJDBvcjAD2yaENFFUUe68/npiedbvgbl5PUrGHA8CpKjPj6vC?=
 =?us-ascii?Q?67c25JM8jRdQ9QdhUiBBdzhLc/+gPLV2rGiG/3WpnAtj0fv7fm4imFYXixyc?=
 =?us-ascii?Q?s0/yOThn+YwECEMM6o9/4ocUcP8l0u19VAeoi8xXIgJLys7EKaVmXzhYCgwK?=
 =?us-ascii?Q?6GXKojgsplRZoxGYdQmrhitnyMP+JlnUX6ffzFWQofrV/JpvgjerSzyyS7VT?=
 =?us-ascii?Q?3HnQ87iYjCfJ7052OOYEUb1kcONFsI6iAnbj23ZFz3RCIju/09DT6uidB5wX?=
 =?us-ascii?Q?wdLxswCiF0qM69tOYvQ4iVVfb1uBAIN19qkd66BeqxTxBtKPkiYy4X+Snq9j?=
 =?us-ascii?Q?pLS18O7HiwF6MfQcfLvcH7buUnLqKzlIws2A4sBHF6sbDRpYL3r13P1hpxsa?=
 =?us-ascii?Q?Jy/Am5BoUIrLIFc7bFGQeRL84mY2PnBWuNYN91NZqGoUunFhoKhdiuX9zjey?=
 =?us-ascii?Q?SrLP56pd6UCOK0xDd/07K/R2vKjRr/Dh5aqjIM2dYqxIR9VBBn+Fiiczyvqh?=
 =?us-ascii?Q?XUXwivdLDkACo/IqUdUWC7jmedyWK9dJV1zGFSdgHnG2ocvGwQPDGauC2PYh?=
 =?us-ascii?Q?ELHYyx9Ubi1Sq3Zc6tAeKeEVvao4brQyeeipftQ/Cw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ym6QmUdYN0FN6Xv20P59mW+ySuVArnYi20HqvlVLZB2hYZXsNbkblUunO0Cp?=
 =?us-ascii?Q?vhNAX0/vELI8HnK3aCwh7fomMKAe86cJvz0nSbWymrS8QBAB3fDZv4QeDi6e?=
 =?us-ascii?Q?t8AiBgCZDeMalrAsmQxmusMMfa2NLfGE0wKrBFyYb/eGT3DKQpPDev4MG3ch?=
 =?us-ascii?Q?sS/4Pr4ITqb2z96y7ysPNk7kVsUV6Oi7o6ZnS4RiG/6w+DF/gyS71PHBSCPp?=
 =?us-ascii?Q?WaNScKdQH9Ys3bHF0kvlirXSnEMoNox0YNqZ8njqX/7th0AFka9A3N2yQJlr?=
 =?us-ascii?Q?s18gEI8wNol0LvgGLwnbNdWT6cK3dLKNem7TpL6HBffyzqJDXRgIH+pscCpB?=
 =?us-ascii?Q?av14Uq4SJbVmVkrqwFnelXvXrteHapFi2fnt8jW/DK5ssKwk8alT6VMpfCwo?=
 =?us-ascii?Q?0cSecb46Xcxtbg2mXFaXVcom5DirINBbvzvvvpfOSGkdBNHMAQzONYCNTcNj?=
 =?us-ascii?Q?bVsr+GTZyVwVhqC3z6ohAM2IMP73Qv87TbkWSbaKxUE0H+F3I71tQ8FlGhDD?=
 =?us-ascii?Q?HSL5ShZuW4V1E/Bb976a9Q9GGS/xOJMLCoAUv306bDSVFSsN953K7HoCPAAA?=
 =?us-ascii?Q?s1F306jFPz7KXmAcIWeeZK9BAmNHWWCCnh0UdDOK1ki33u1GDfwOLXctjUlk?=
 =?us-ascii?Q?qHAqvBbKO+OJ1cQGd4qC0zntIpXE+nV7l9+Ys1uYSE8tNzLbQfMBdgWLJCQt?=
 =?us-ascii?Q?0bHPa4hAlLptonCRuAO/46PUjGTud0wwGVBUG3CJkXbmcyI4myGVbPSN/htV?=
 =?us-ascii?Q?J+YKcTLdSifNiq2Qam6CDYgEtbtw91B0LWTHBPwJglUHuyssDNGg1BfTF/8E?=
 =?us-ascii?Q?1lAsV6yKsZ0JnJNoXvpeKth+MHqE/oNUwKQL7EJwTolR/xocR449CsePsKI4?=
 =?us-ascii?Q?5MmnNfWKM1c16qlrQJnUyphj5VKrQNzHz9VCNaXgeprkPEdTyM6hVJLNFK/w?=
 =?us-ascii?Q?5hMBhWfatJNPqhWdBoADMw0OAr3jd6kh7qzbQKQdBPnoM3+L4BsLbqyDdQsX?=
 =?us-ascii?Q?IyzR5/byWDwwdR5izxKlfAc+VlEb8A3eivmG7IdolYGzT43/SN3ibwe7T7fC?=
 =?us-ascii?Q?zfS9VwrW9XVJN4baGqgAEdkafMrSVEBqJtMlvio/xggp5aGDAt681tXptEzD?=
 =?us-ascii?Q?UBqr9x0fx5W6Kw8yGlDo/CN8QzN6kxifgd3woCFf5xM4vyuY227aPIHgSM/S?=
 =?us-ascii?Q?ZYer++5uvvZF4A0S6ygL4Gi/HuKcAE3Cp8otV0qq2WJfI0UfKM2ispu6Awk2?=
 =?us-ascii?Q?U8WmV9NaCNNTRlr+VmVip65iu+w6g/r3Xy7IR6jbB0Q5tRrwuLK7tESb84Vf?=
 =?us-ascii?Q?+fN9l63zrWC8ueK8EzmSuBKsQ8V5xLYm4JS1PDW3/nVXB5gvM5slwAWIALJl?=
 =?us-ascii?Q?WsveCwtv+QPj3ASEV0KMvr+it9CNzfBdrEiM5rr6LuErWEPEgepPKui7zUYS?=
 =?us-ascii?Q?ApxINrMI4wCw6xMIuB90msyLEftl9zkrpEou/VOIjVI0UYZw63WXYGaL8wDp?=
 =?us-ascii?Q?nFW6t7+rHqiwdk/hRoMZ658V96+GAe3iI+1E+8HSaLG9axHiAPH88jDt25wm?=
 =?us-ascii?Q?mjgnoP9pUwtwKjLT29Q=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f20991d1-6af3-4935-d45c-08dc7a5a5ad8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 12:26:07.0825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 939zBfZ+RP37m2v/OeukDvjC5a2nCm2GSbb9rhHKFGaZgCzTh8mQ+3MLPjUum8Eh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6915

On Wed, May 22, 2024 at 11:24:20AM +0800, Yan Zhao wrote:
> On Tue, May 21, 2024 at 01:34:00PM -0300, Jason Gunthorpe wrote:
> > On Tue, May 21, 2024 at 10:21:23AM -0600, Alex Williamson wrote:
> > 
> > > > Intel GPU weirdness should not leak into making other devices
> > > > insecure/slow. If necessary Intel GPU only should get some variant
> > > > override to keep no snoop working.
> > > > 
> > > > It would make alot of good sense if VFIO made the default to disable
> > > > no-snoop via the config space.
> > > 
> > > We can certainly virtualize the config space no-snoop enable bit, but
> > > I'm not sure what it actually accomplishes.  We'd then be relying on
> > > the device to honor the bit and not have any backdoors to twiddle the
> > > bit otherwise (where we know that GPUs often have multiple paths to get
> > > to config space).
> > 
> > I'm OK with this. If devices are insecure then they need quirks in
> > vfio to disclose their problems, we shouldn't punish everyone who
> > followed the spec because of some bad actors.
> Does that mean a malicous device that does not honor the bit could read
> uninitialized host data?

Yes, but a malicious device could also just do DMA with the PF RID and
break everything. VFIO substantially trusts the device already, I'm
not sure trusting it to do no-snoop blocking is a big reach.

Jason

