Return-Path: <kvm+bounces-8347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CE76284E347
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 15:34:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4465FB213AD
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 14:34:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 830B979DBB;
	Thu,  8 Feb 2024 14:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qP02rFPM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2088.outbound.protection.outlook.com [40.107.94.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9976A347;
	Thu,  8 Feb 2024 14:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707402860; cv=fail; b=Q2baTPjRVZuY1LAJXZiweWbw2CwGbWzUI2rlE2SRshFdxbIDtPTS7rxzI1Pd9PbdU+Yo5u6RQziA1QIH98B06/I/3rsMknVjCENrHbdzrkf2JG0JDivAbr2UHHAitB4v0baNpTwxfPcQe4o8608+dnMEAR1q4oy8jeVxDYkYJYc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707402860; c=relaxed/simple;
	bh=H322p8apanlqwErVpQFsYDBiRbEab/Ujd/hsjW1V/20=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=r9tonwcBaV5xhFw6vJYj+h6o0zwchAhn/w3y1MNnAsKOZmSKtaCjbWVVsikuvwmZq4PAFirbWK0n0+ExPQwNvg0c1J69NXyM0jqT0u+9YhtmI0kE4SF2b68lGSIP/JCjlAzf1i9Mwr+zmIA8kbrutQTSvCNFYbSLwtUxlbJ/WJo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qP02rFPM; arc=fail smtp.client-ip=40.107.94.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dDxSD4cVzVV8CYyXEPT1Z7Jo3Lmqd1i9eWMXmg6fbLHkH+f2tUGDCcN+nvIhp30vdBlVJGp85oRtBhbPj2rthzUmKO8puBQNMng4TgoXbgbMJfQmH1yoq8HUkXBO/Pf2dcyaDolyUTWTDxca4+HBwBhPXkC7Aw2mTyuDOmLakSyy344CZCMoMT6zmkPiypvWOdbpTbBOK5GtzCyt/+Ry17Q4BDfruShWakxa9/xGuSEBqY3HQM7BZhiX8+yGAl4Vzncllm+aFH4VHWyu1fnGz679p4IEugZUYcuFC2fhFrpy92iktT3RjAyg61ut5YPGzvAxYUldlTgMYbqRy6qU2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VIFlEL6KqjpTDlSEP8XudKkIxz16vybrXCwt9KiDZ4w=;
 b=c3yQzsVUNBp7Tl4GPAzk5nmStUOaJji5IHLDF7UDj7g2hxa8qQ6+aeL8iDkDcyX+vC/9tqv6Nj2oH2EIe+wM1AtOTtiZc3/NOFC2G8z/OeBLQVSDjknYReNMoOMeSJwFVTgEe0gb7W5JPxFXeqgL36goQPzYprM4dvWccMC7jvPnSn7tQd8CpyZxBP/FDxS9SHekEAtN7wHhNOM+fnJFWSm+zrHrvBguIgN9Z2MTOC/3+NPPWsLcap9/zBJjJur7Q2jbY1+MkbUsSPCybwXNRxxsCgu1L1kVsnsb8rOqevJ7yXMVgdWA9wSvQ1kmLLuX6U3g8gOlyL3Rw1+ywGffzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VIFlEL6KqjpTDlSEP8XudKkIxz16vybrXCwt9KiDZ4w=;
 b=qP02rFPM5jajXzFmbpTg+L+xXO7svmypVdBFCK6IrmgAu2bzmGygkDVeVc27c0boby0kkYh5xZLn86XxBE3evjKSa5QY4EuISaFJA+TlGXWobwJQg1xVxsCXTEGAucd6YOhBHdCl7ZXF/uDgMUD7rF36DRD7OYQeZdM8/zoFukHPK8AManwB6kWUXBVwSHEGWYzq3JXyXgY3HAZNlmqDnZ0GYdT26yWSDEn4Crh85U3nfSYkSKzPOS2c98u1b5BD/qi8hWlNBL0wMZlN+2u8T59BDe3hYarfltcv3sLOFyLGcNLFuEXsiiXkUwkN+UeWHtDjauZ7GXFPnv92Xz/r7Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN0PR12MB5932.namprd12.prod.outlook.com (2603:10b6:208:37f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.11; Thu, 8 Feb
 2024 14:34:15 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7270.012; Thu, 8 Feb 2024
 14:34:15 +0000
Date: Thu, 8 Feb 2024 10:34:14 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: ankita@nvidia.com, maz@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	reinette.chatre@intel.com, surenb@google.com, stefanha@redhat.com,
	brauner@kernel.org, will@kernel.org, mark.rutland@arm.com,
	alex.williamson@redhat.com, kevin.tian@intel.com,
	yi.l.liu@intel.com, ardb@kernel.org, akpm@linux-foundation.org,
	andreyknvl@gmail.com, wangjinchao@xfusion.com, gshan@redhat.com,
	ricarkol@google.com, linux-mm@kvack.org, lpieralisi@kernel.org,
	rananta@google.com, ryan.roberts@arm.com, aniketa@nvidia.com,
	cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com, kvmarm@lists.linux.dev,
	mochs@nvidia.com, zhiw@nvidia.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v6 2/4] mm: introduce new flag to indicate wc safe
Message-ID: <20240208143414.GJ10476@nvidia.com>
References: <20240207204652.22954-1-ankita@nvidia.com>
 <20240207204652.22954-3-ankita@nvidia.com>
 <ZcTRH1rzfPbuQ_qj@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZcTRH1rzfPbuQ_qj@arm.com>
X-ClientProxiedBy: SA1P222CA0077.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2c1::24) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN0PR12MB5932:EE_
X-MS-Office365-Filtering-Correlation-Id: 62252bd5-c86b-4b29-27b2-08dc28b306af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	w+ZlK9Hj5PeKQTWOwTB6UJerHE7dk1qKoBkd7xeOlQ3s+Uk0psBCmDNEA/yGJ/zwgWyDm+hbyCvLWJl/ck4cvjv6YnOvYgHsvSkEDS+xNmS1oF4HpwGXwV1sPJBvHjJcs+9PJ2SNPvtdRxgpcla9rU1lJpU3ZYgfyYgOkHoSXJMO0ex7PH5ZUv3XAfOWqaSAwrrnG2Ed0iYB/jMBP3ZM5WGb+DatTDb1UVyAr7GCrUOnTcsteW1aymIq8+Jqr8DfzLw8ppLaIQNoMWzyGbj8NK6760xRFeEd9XGnB+g+xw3GKywcIf8ZMr7elF6zqwO6oUoOsEL9dSRT3cchb6B6G+ycKazXVzmh21xt7q62rx2WBnQUt9jj1Oz6HTH693HDOtvGa8sH3d6J4kiUT710MzEWC3G92tYqWYU56AQOzZM3oaFrTslg2Bx0rGRb+l3zjTwMHgg/zw7F5eH9qbfYe3TEicfgqyRSo+P1YJOTuEeLyDu6ZlgLuypba/FIXokBY1FDBcyLvF9kmw1HFmF/KyBWgZGn/ZoClvYZ521nGC4Z/Ztykite55+Ja2fVW2GQ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(366004)(346002)(376002)(39860400002)(230922051799003)(1800799012)(64100799003)(451199024)(186009)(5660300002)(2906002)(4326008)(8936002)(8676002)(7406005)(7416002)(41300700001)(83380400001)(86362001)(36756003)(1076003)(26005)(66946007)(66556008)(66476007)(6506007)(316002)(2616005)(6486002)(38100700002)(6916009)(478600001)(6512007)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bNZrM9xEU6WI1x70e3Hi91k1B36LyjdRDON1CkDSIlWMwsB1TSBilHWLVRjK?=
 =?us-ascii?Q?AZUEJrgzmeKzRYBWv1W/rPyDmMWIAeut0aDo9dnJb3JwZ501H32MmtSmJk5a?=
 =?us-ascii?Q?HCNbM2d552NyGlZ0x8sGo01aDd5YL9b4B6wEUNDJWDss/5g2BAo5ml/aiOJ9?=
 =?us-ascii?Q?Ge5VW0rVnSbNblN7/200pFW0TcfDcUHfU+8BOHKLcILmgTIl41pVohPfcuzI?=
 =?us-ascii?Q?xXMnQoNV7G5XqZsGwKC7B/YwTeq9m9cuJ2XTyUcg2q+ZVm3CR6stq5qTQvXS?=
 =?us-ascii?Q?LfriJ29VELnkcBy15TjHwkZ8HsXSJXml4Fk9X/12ueKzW5qx47JRNXyB59zw?=
 =?us-ascii?Q?O4do0P3buYrZ+aer9IQNn0YCSsZWx1sHO7ahcUEMoS6QF8LYPO3H3aHsHELU?=
 =?us-ascii?Q?lKPF54XOnyz2MLoI/tAfUdJJWf1DaDpryoSpnD1GEIG4Z0/SJNAAeham4BYT?=
 =?us-ascii?Q?s90QkMzI31lK1SKqUCVH2yZR7MyQNpX0pnVw/AjVg6zvXFCMV3OypNoSev9w?=
 =?us-ascii?Q?owMB9bci+g7Ey3tW5dfv+cDS2vkBGhUwsm0KY7SKufzSBEvfUlCSq0KrmMc6?=
 =?us-ascii?Q?i1UaAi27O0Zf88GiRo0t5DeXLxstCABoUc0PGupxv9M8KEcts1zUnm7WxPe9?=
 =?us-ascii?Q?YP+AU7puk9p1cPVUOxosEt1d5WCjiGamxyj914WZajo4b4s5wQx7IYC7Rqvt?=
 =?us-ascii?Q?GlgwAPdl2lLYYIIrJCk9C+wwreAVg6YOj1XYAJoxA3cSumVjWnesRtqSd25t?=
 =?us-ascii?Q?rm1b5Ij7ursoaXka1lEbrCAv0U9Cer9d/rgDLhRndAMyeSLjlZMtqveQOLby?=
 =?us-ascii?Q?61FiDhRJmoNRFSxxBneNaXpEVeMEYiddGIn3ZV5jVb3D5vREcvrxonBdRaxb?=
 =?us-ascii?Q?QcuH5EZBB73/id2fE9JnlFOyvGr1ftxizxxis6Ug4msh9ahDHqfGd7qlq/Ws?=
 =?us-ascii?Q?Nhr/8U9whxzxrCHbvcQ98Z2SzpPXwTbI26DqKzciMVD+bqFkP/cTVmBwsZU8?=
 =?us-ascii?Q?Y00MXkpcqwxt1fUAKDB/ghIOc4JphrnygB22mHYoG8F+cscZ+Hgc8mzKgN8g?=
 =?us-ascii?Q?Ox0VuM+eGOOkKWj34CUrAXnhEfqynkiIYyNMhMquDvXA3+qBcvqibZCp6xNA?=
 =?us-ascii?Q?ROHMWHiM73tasVoChj4Cin1Ft0tanODvj18XCGjyL/IlukaR0fqc7M4vSoX8?=
 =?us-ascii?Q?c5pq9FODp85Q7+xC1APP4NIB9PTFl9pmT6Bb4/ePSgiNhmcXxxAFygQ1xVpR?=
 =?us-ascii?Q?F8v1P+rLOXygMy6p2+/MuKRDc3Q3XNYtE6XMsWaECKY5mGnowP7bgOKDLJBo?=
 =?us-ascii?Q?ZXczubaQObPchNjNeTQ44AhBXoXMvF8EEonqmAHcBS/nK0jofPXmbS48OMTe?=
 =?us-ascii?Q?KkQOUW/nZIHrqGM4GMrP6MqpoxXbXBXUmZ0Y2KzbO55jn/5yJKUKGpIrgDJ+?=
 =?us-ascii?Q?a3rrLKWyHRAXiYLizlW3uD/6l7p6xl0+b5gKnNvJfzdv3fRNjE+QtmhE7NEy?=
 =?us-ascii?Q?vtA+wjxkKuCkCiGcSOcktqNn/aMncuYA8b5cmJz0UAGAiCRKof5Nr4c6mjSv?=
 =?us-ascii?Q?bmGKcb+29fayRdYGK+DL8juRyMghPaBhmM6nlzea?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62252bd5-c86b-4b29-27b2-08dc28b306af
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2024 14:34:15.7511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: scbb7YXhBWFTvqlTFNPNCkCK4/uucn/uup/xLrFQqZ7lMbUuB2TkE1c/9MaM1woC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5932

On Thu, Feb 08, 2024 at 01:03:27PM +0000, Catalin Marinas wrote:
> On Thu, Feb 08, 2024 at 02:16:50AM +0530, ankita@nvidia.com wrote:
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index f5a97dec5169..884c068a79eb 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -391,6 +391,20 @@ extern unsigned int kobjsize(const void *objp);
> >  # define VM_UFFD_MINOR		VM_NONE
> >  #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_MINOR */
> >  
> > +/*
> > + * This flag is used to connect VFIO to arch specific KVM code. It
> > + * indicates that the memory under this VMA is safe for use with any
> > + * non-cachable memory type inside KVM. Some VFIO devices, on some
> > + * platforms, are thought to be unsafe and can cause machine crashes if
> > + * KVM does not lock down the memory type.
> > + */
> > +#ifdef CONFIG_64BIT
> > +#define VM_VFIO_ALLOW_WC_BIT	39
> > +#define VM_VFIO_ALLOW_WC	BIT(VM_VFIO_ALLOW_WC_BIT)
> > +#else
> > +#define VM_VFIO_ALLOW_WC	VM_NONE
> > +#endif
> 
> Adding David Hildenbrand to this thread as well since we briefly
> discussed potential alternatives (not sure we came to any conclusion).

FWIW, with my mm hat on:

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

But I'm interested if David has an alternative. We don't have a
shortage of bits here so I'm not sure it is worth much fuss.

Jason

