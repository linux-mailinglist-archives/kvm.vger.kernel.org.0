Return-Path: <kvm+bounces-18001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 95B4B8CC9B2
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 01:33:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EF9E9B20F05
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 23:33:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BD6814EC79;
	Wed, 22 May 2024 23:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="o58k4Jp4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2088.outbound.protection.outlook.com [40.107.93.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F5E8060B;
	Wed, 22 May 2024 23:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716420745; cv=fail; b=NrEAXZ1aQ/H0PzVJSSnGbxJnrnzJ+KiVkGaG6EZQ1li3USnW+Tz/1kGXBOh/L5LUAQFLWR7EZMoxD+mTcJYFDeYNPNgAwf6lbDm5S8ei7aWK34m7WWN6BBBsk9sedLxbv01t8WaxfTlrUr2T5z4QIFOH2gcRrLLZ0Nkul35/qFs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716420745; c=relaxed/simple;
	bh=O42SdY0wb2S/Xq8HiT/u/WlhuhouWstGD+pcHHUZmPk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UO0Pi6HgxXNEjuLLqjzarQZr8q2HUD7ww30Rtgva3FDPNb1TCyUtJPehc+DgFIWXqOI+gnn73rXicFU+wg2Ar4257UOelAlXGQ5CiLSETcFRKY+ASLFYIXcLmOlsA7QVLspegx1P/TvKCr6EXdz/8dpF6plPGzxSqLDCRyg9S44=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=o58k4Jp4; arc=fail smtp.client-ip=40.107.93.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fUlhi5Z2fsg3SOI3AWs+qarj4Oak2AD9ylBnxjI409G8H1woCE70SjYyAcGcAMrINXP/0aGt3H75asLwy6GeAhB7qDXUWWTMvGU3URlVms76Rmgm9Q3Z4jcyevjPKO9ogPXNkerAK1gTYyURjcpLJbRqO3PERti9DMxlueySGNvHKeJ+f9LnjkEegk9PSUVDkgyYejZ+pgwGHK4M7jxgtGx3xW73MDcVym1gbDJHzIv88Kp7c6HMNr9uA8eCQPhQ1kuS5nneN63stXu7xdBA6rN+2MVCwbJ+OibKVmnCh3jjc2DGocOVIDd5H2ZMLh6+vp6ZWRppGPjxLQTxEgVugg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=124OOnjs6xmNWBL3lheSYbecO4K+ZbLrgXKa5W/qJdc=;
 b=BIK60sqaPA3vzfIEZ9VdFh9Y2O4ZpvIzExnFpIgUN7LopBH/S8O6I3w74aHdj5KnP0YeOAbXJFmJ5GTEDUffv5Nhg082nUWewDDK+BmdwE9xG9OmmlqYCyvRWVTrOhw3/H9MGP/X/1nKOZKovnBPTFYENWVYsSw2BSBCqPZ8pKDjGJr+hF4IQ/cVT46xZ7Ot8n5dUbr47hdYtXXa3YvZplPqFcGo8U1ZBmfuzVMV0+lGI18ImhDChlKTG+iZNosOFXDF/P8qLWz8a0wH2OuCMgd3TPugtsQnqGcN95XQdyEQS4yZHefUyfS+HdbiCHc52pazWe65J4dEoG88cqQA1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=124OOnjs6xmNWBL3lheSYbecO4K+ZbLrgXKa5W/qJdc=;
 b=o58k4Jp4tGrzwHCEX1wTAciJOYlCGlWLjMaQ683Ltf8y/ZIq7C8EETvd9TENdI9nyZ5ZnsefDVocosqH3G9x//VWhHG/nizG0UexnUxbToTp93hgqq02zEqmPyFiDtIgu6bGyrWDqyOIOapyEuJq+g6EUiaK9jGOmzdKKPdsuM4o893XjeEI/lYGtVFk1Xf1d9XCuBS5vfq4LOcoGuKktL33HJ93JuFW+q3gs5OVaP4c37j2d3+mi/0Tb6crYkNQLv+eIWcBoZC3XDx6qLtgvcbyvsKeS6tU8WkmUzd87rEhUzU8sqA1R+Br69tihVrW/k/W+1w69Zx2OJrCgMqbYQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH7PR12MB5593.namprd12.prod.outlook.com (2603:10b6:510:133::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Wed, 22 May
 2024 23:32:16 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7587.035; Wed, 22 May 2024
 23:32:16 +0000
Date: Wed, 22 May 2024 20:32:13 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
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
Message-ID: <20240522233213.GI20229@nvidia.com>
References: <20240517171117.GB20229@nvidia.com>
 <BN9PR11MB5276250B2CF376D15D16FF928CE92@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240521160714.GJ20229@nvidia.com>
 <20240521102123.7baaf85a.alex.williamson@redhat.com>
 <20240521163400.GK20229@nvidia.com>
 <20240521121945.7f144230.alex.williamson@redhat.com>
 <20240521183745.GP20229@nvidia.com>
 <BN9PR11MB52769E209C5B978C7094A5C08CEB2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240522122939.GT20229@nvidia.com>
 <BN9PR11MB527604CDF2E7FA49176200028CEB2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527604CDF2E7FA49176200028CEB2@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1P221CA0021.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::17) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH7PR12MB5593:EE_
X-MS-Office365-Filtering-Correlation-Id: 89fe2bb1-c77c-4a51-daae-08dc7ab76a23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|7416005|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uGUlixd7OfZv/qHWYI1bwzZYOtrdED2l0gSjU6E2ShKXMFl9orqmEHKRqhd4?=
 =?us-ascii?Q?SPwHJ1BNOv8BWKco/wVDuhvZPim4/yblwcc5uf3cphJDKQprGVXgjozW5F6x?=
 =?us-ascii?Q?d6yvL2C1CY9GRKrAyE8d0nvO1SWRj4x4XyZv5lC9u0OxCJPfi0dvc+XlHFAD?=
 =?us-ascii?Q?LzcjMjuT0qdAk5mfBeR5vQZyYobdw+QlUow0/Bu1zZTL3GYrrbyIFswLqVEI?=
 =?us-ascii?Q?fRod2aIZ91AfZgAoSIusFVSP5D6LNxri9e/mVu4of0Ezx1N5vDtqbztac8yx?=
 =?us-ascii?Q?STimtraf0PP78GReBDEkcPuNpWRiT6QkwrSVzzNXRzfwmKmkCGQxb9lxOPlQ?=
 =?us-ascii?Q?TPmGYWxQFn+72yBGLndUdVbRQ90oxlG7FHU5OvxWSvKSj2YXHAtRQDsc6XmZ?=
 =?us-ascii?Q?nUNM7Sf7lJt8e5xRMX004VeUuQkNQmY1+kB5HUU3H6BjKtbkqK8LCE8ayzJX?=
 =?us-ascii?Q?9cfJ6IXSA1ADVDy0uJ5ljksVCviSDEIfzwCQi/gOcUwuHUkP6TFhR67wIOhC?=
 =?us-ascii?Q?EGb60BrnBOI9XbfWdPig3eKSi3LEJoBNp3OV08LGWKDWTx3c58Ff8Ngwi+VC?=
 =?us-ascii?Q?nuUlWh6CIGEEI3PTFNhrSS3J7Gd/9xGtqkjMPuGYWoh4556HScrLItM+g6H4?=
 =?us-ascii?Q?HQA3rGjDxLEpyV+xbOiAjFlcD8Nhwrd5LXxmueKv93mN5rZDrplLKgQSdg4B?=
 =?us-ascii?Q?99x/ITiE9yXTeK5X7cDVu0pp9I2L4kLZaYRPW9mr9wGIKGf6CuUgBsdUTCLc?=
 =?us-ascii?Q?Pb08yTPy/JdfmVxgfn1ymYAXJ3oMbDKu/s8o0h0SvlPZPWsrt1GzKew5ApvZ?=
 =?us-ascii?Q?qKtjidH8PdTD7wsOx831koCixghOZXjG4yJ6x6SOecKsON0y346yyj5ICv9P?=
 =?us-ascii?Q?+CRiQrHG2SWUuzqPBJ9YR+BOe0mwpV41lJnF6/VigwI+eHCVVjLL0eLJjRp7?=
 =?us-ascii?Q?JJORO7olKjZCFLwpuM2xOceGvKIUMfZAyKgkvyj8SE0ge/I0Td8plajYrfPa?=
 =?us-ascii?Q?rDscIM2J4ysgDsxzIlm//7xZdpfbq53GUVSVTvWpuDmP8EOGqHXpGQrksTM/?=
 =?us-ascii?Q?cJrzjsz52zk/JojsrEGqiwzViSdTcY2hLh46qlVT887Cm1zTwHOhG89xlT+2?=
 =?us-ascii?Q?xaBY520+ACQzTk8YobIrkxCeKVdsiJoJAsrtW1FqUhXiBzAO1BX57Qs8tASm?=
 =?us-ascii?Q?lZZwunz6FlOHA74N1qZ9taqcVdQTsDI6FlwLYAV2DFasl3wAiVWhMcEM9RjP?=
 =?us-ascii?Q?WnYkuoe397L6rBSb3SK/yIr+dqMlJm0M2br0IS8ZMA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9NLLO0auv1IdxIgPKR04BiKHsaeTweFHL98baYz4xptOEifXBaur+lXj4FKy?=
 =?us-ascii?Q?OpPrhNPpKYfjAYJUhWGD8X0K/3iDb/lcl5yLWELTXGQNL/Wc//kJguo6fdIt?=
 =?us-ascii?Q?q+vNqgCRIKpkBDVFUSwvfkE4xAT5RcMIrtOIowNi8VA1v481jgWl8LgEXi9P?=
 =?us-ascii?Q?7zDxeQBuh6u47Et1S/jID6Nuw1Vld20yhDod6sVLwVJvdionmDkpAhm3Ivyw?=
 =?us-ascii?Q?qbORjbirTj4dJ7+XI3Fe1Kw8v05geRjK4GxRNPtl7CK9wSf76QZ1WwWdVMwb?=
 =?us-ascii?Q?HjdZlBfoTsazwmyfy+90CHjjXOFKfayOu+UFhxEdbIfIcC9dUd3j69ht/tgn?=
 =?us-ascii?Q?vfV7tuEb7GgCs1NXNZ/+tOuZbqBlrd1gQxjkZRChiyzF4fzZeVSMM3mU4Cxf?=
 =?us-ascii?Q?ZnVQQ+KX57fDYQBe43xpyZ1AGtEee+DZwR0t5k9/x1jDSsgARLHQIMYhWFno?=
 =?us-ascii?Q?2gzNyg1v+QJCER0vNnhaiG7wrLvM6V1l79HMtqyBpSbmhzl1Ao8e7y4F/EjO?=
 =?us-ascii?Q?nBLsZv6JzKbl42PxsVISfb23Ol5L/8zyTAoeKIkCbup20CHrnsRk5o8JlxpL?=
 =?us-ascii?Q?pxpz7dzp1Qw40vmzO9XVV66tk01ZG63OsbKIH/S/4LwiUpMW+egvGvOm5JPK?=
 =?us-ascii?Q?4LugW8+ew1kU19pczq9baci/KrUQw6A1v9WORREuF58JYnw/fEiQRf7KPyPx?=
 =?us-ascii?Q?ivjSrb4c1SIw5BbzSWfQu4zDF6cuR7KI4IKAzLjKwDpT0Rkv39VS/O7qr/CD?=
 =?us-ascii?Q?VYFTfHNt+Z+fFJuDC26hJPzQDatAc18++9uWmFOm6G+T+LCKpzz1XjWZ5dco?=
 =?us-ascii?Q?vGM9GxL5gHVXUxHWKlAsAuukPzkbYIPZcgCS4cm+uq9OdJyS98v9El/ZJznC?=
 =?us-ascii?Q?6B28ZA2sm3QmSdcafx9IWq85a6KdlkF+luhcfePivU0K0R2Cynra1ecTPU+E?=
 =?us-ascii?Q?XAh0k01KfmtgfDI5MBKoZkuEfNkOk0C+/m7CYJ3r4PIpQedAT33mX81OXug1?=
 =?us-ascii?Q?UW/SM2ClnqwudzJH24SqUKAkjwlFalPzWOeXGT6+Fn/HiVUeLIhsppHuL6TJ?=
 =?us-ascii?Q?cxrYDwDlvIvuxJABeJfzcXp+/lEwQFhzzeOQGx7mgRZ2PMePcGI4uuwpnFfX?=
 =?us-ascii?Q?IC1Ri1m2ut1uHFfN3YWKrhBkhcNqV75tq78r+DjLE7E6vl8hEF5Iru91BlYu?=
 =?us-ascii?Q?oRivV/bZopi4wJpmByF9bIQPQYt4eWAlZ0JCyeV7x8VJhjJwnhwnK0PL0Cer?=
 =?us-ascii?Q?6o8w9s0vCRc/gKCtDsEwRk/tDVkbzLgaR2GP/NArFbGgi1vA241gsz1Vhfx7?=
 =?us-ascii?Q?O/fkD6ChoO5Jukt4xxNHwA/NGJHmUHKfI9lwUTb/6VwbCSNku9byBHlV+lzH?=
 =?us-ascii?Q?qcOGNJnzUnTrAalFgvUr4LuifPwjsJKYGwMdnZeGrNJczdrllvM61E1krTMC?=
 =?us-ascii?Q?LlMUhZmXFNWN9bQfCRJss5qzrdAUQEmxKi+4oXfDzE370k22EHri0KSoGtXn?=
 =?us-ascii?Q?eYm1/kHeUc9mg8KtCGkzCo8xANOa/dX4D/Dhg4u/Mm3fkO9nwguOtE8EqC8b?=
 =?us-ascii?Q?ohbheHw+uj5/mOTNnBU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89fe2bb1-c77c-4a51-daae-08dc7ab76a23
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 23:32:15.9180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hFVAwKfKNZ4EbV4lw3Y82noROQm+whAl5DxX+X32Edyvtd3rcChTBLa3qZUN8C2r
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5593

On Wed, May 22, 2024 at 11:26:21PM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, May 22, 2024 8:30 PM
> > 
> > On Wed, May 22, 2024 at 06:24:14AM +0000, Tian, Kevin wrote:
> > > I'm fine to do a special check in the attach path to enable the flush
> > > only for Intel GPU.
> > 
> > We already effectively do this already by checking the domain
> > capabilities. Only the Intel GPU will have a non-coherent domain.
> > 
> 
> I'm confused. In earlier discussions you wanted to find a way to not
> publish others due to the check of non-coherent domain, e.g. some
> ARM SMMU cannot force snoop.
> 
> Then you and Alex discussed the possibility of reducing pessimistic
> flushes by virtualizing the PCI NOSNOOP bit.
> 
> With that in mind I was thinking whether we explicitly enable this
> flush only for Intel GPU instead of checking non-coherent domain
> in the attach path, since it's the only device with such requirement.

I am suggesting to do both checks:
 - If the iommu domain indicates it has force coherency then leave PCI
   no-snoop alone and no flush
 - If the PCI NOSNOOP bit is or can be 0 then no flush
 - Otherwise flush

I'm not sure there is a good reason to ignore the data we get from the
iommu domain that it enforces coherency?

Jason

