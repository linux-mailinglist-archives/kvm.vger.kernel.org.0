Return-Path: <kvm+bounces-25936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4030D96D7C8
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 14:00:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6481A1C22945
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 12:00:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C691319AA63;
	Thu,  5 Sep 2024 12:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Xyy0jXCF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2077.outbound.protection.outlook.com [40.107.100.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42859179654;
	Thu,  5 Sep 2024 12:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725537647; cv=fail; b=HtW8wGXDhRkpIn6+wo2zMF6WwMBERZijPK87wdTIdv9ELEnLlvw67rPZHbJaQPcE0qRUT4JfwGpaeTuU+so24bbbD4T0qEqmZbdD2Isn220I4NDYjRNR2f9BVsT52YhQ96eIhd/taG/hwAQB5s0+dzbj/612IhAQMpLjQ9zPvjM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725537647; c=relaxed/simple;
	bh=kxriuiUF/F2WYWCUZ3dFmGynRTOR2/nBad06vjJHEqY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WiusuaSmFvFGn7lXhbxN0fgKgzuqwPW8OcCAHv4k2UHZ6rlpGYA+Sblr7YF9pRNhWWZw1fasI6C9S0MAOXU6BJl9zN/NEY9TvdiBxYGHXP6pDH/Pssi9N7hqnM0o8fk77E7i73g4eI+H1fJ3goxEH0oU7kqN2iEoMaEC7sZ7m9o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Xyy0jXCF; arc=fail smtp.client-ip=40.107.100.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fWlGyjuAQQhqL2UAlXVZtWa6PPFgqUEPP/KH/fRtn6MciJrfrQjEC3TRMxG4vCtF2/GZtJNtq22mfptruHSHmuiQEQ20bua0ZH4X+M1HxJfeVUFmp0cDfk7ve0g+gh62ZM9bFwjfSjpSxe/0lZ0waS2/2HagzBDvKL/F91idVy2xMEqpbCx8+4KibsnhJiTv7ZAnULmPO3Srj6FxRKnfBYpF7qyuiU+1HduCUkc+2tv/aSox5EMzmSeD4LmfPW6NIqYEkupBjp3GsJY8TF+EaSs1jTsw6wTYaZftsXh90c/RE22KS+1RCkVHlNapm36QTaX17HwNWKUsbUq8fGHrAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WleR4Hq1NnLm4X/wH4nshHflFBOJ829s4XX2XfdUuv8=;
 b=cGjdMfwBoZ7n8Jb8H1vnrkvktRKVJu5QNqR/Uq3GDpYeE/xsF8RK5TSpp4nPy8gOFrPH6WUsyMlRVNfw9mSZoNkND9JaFifxWmUbntATGWGlhN+IjD26ARDfltgiyh8g8eEhZ4wLDDgAUk4AxbECbIIOIrcLlOX3K1Gufl9FYfv0IZU2pO+2UpIs6nP9rom5yhNQPzSKGmmfipFqVF2NQBC5Z5MSUUDt3qfxDgu3w5u6Yn51D44im402c2wj8rYze+/f+/QYspZE+dBIC4wCtWz/aedAn29FKlvfOcx1V28CNBMx58ZcnmXj70PBnOQ1aLEf4Ib1WfsZUht1GLxZPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WleR4Hq1NnLm4X/wH4nshHflFBOJ829s4XX2XfdUuv8=;
 b=Xyy0jXCFOndbbKQXDYqPAEfnG2Hhio9yKcOFfsbMzLS+7wLX4w546LBpAUgIYAOUjOA5f1DLaTpp/jdnUbLnhBcWBCzYinOa+DFlteQX3sdlNHIW929/0tf7/lxJP4JmQ5vLnRDzSc9ri+YH92taL8wr714WYTFHzYN7s5PUn0BSD0Dy5o9FTwWCquXudQC84y69Xw4CfaVbcpZmH7KRPwFqpgSLTLQSvDDt7zu4FQ7QsQgH75A5Soz11fxBPFPPVPwift9hoLBCQccx4c34/mnkFK5XlVPStIBAxdhVOqZ2NMPqd54SKDoHHZfmttuFr7LA6+2W0Tt8cKrwoxSRKg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Thu, 5 Sep
 2024 12:00:42 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Thu, 5 Sep 2024
 12:00:42 +0000
Date: Thu, 5 Sep 2024 09:00:41 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Xu Yilun <yilun.xu@linux.intel.com>,
	Mostafa Saleh <smostafa@google.com>,
	"Tian, Kevin" <kevin.tian@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	"pratikrajesh.sampat@amd.com" <pratikrajesh.sampat@amd.com>,
	"michael.day@amd.com" <michael.day@amd.com>,
	"david.kaplan@amd.com" <david.kaplan@amd.com>,
	"dhaval.giani@amd.com" <dhaval.giani@amd.com>,
	Santosh Shukla <santosh.shukla@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>, Alexander Graf <agraf@suse.de>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>,
	"david@redhat.com" <david@redhat.com>
Subject: Re: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Message-ID: <20240905120041.GB1358970@nvidia.com>
References: <20240823132137.336874-13-aik@amd.com>
 <BN9PR11MB5276D14D4E3F9CB26FBDE36C8C8B2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240826123024.GF3773488@nvidia.com>
 <ZtBAvKyWWiF5mYqc@yilunxu-OptiPlex-7050>
 <20240829121549.GF3773488@nvidia.com>
 <ZtFWjHPv79u8eQFG@yilunxu-OptiPlex-7050>
 <20240830123658.GO3773488@nvidia.com>
 <66d772d568321_397529458@dwillia2-xfh.jf.intel.com.notmuch>
 <20240904000225.GA3915968@nvidia.com>
 <66d7b0faddfbd_3975294e0@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66d7b0faddfbd_3975294e0@dwillia2-xfh.jf.intel.com.notmuch>
X-ClientProxiedBy: BN9PR03CA0698.namprd03.prod.outlook.com
 (2603:10b6:408:ef::13) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|LV3PR12MB9356:EE_
X-MS-Office365-Filtering-Correlation-Id: f88daba5-7d45-4d1d-2727-08dccda25dca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/pT4z7Ci8//QKLcURbY3LnW0x484bl4SPCuLeHqEP8OmYN6fOuWLd0+jrCeF?=
 =?us-ascii?Q?y/km0Ibj655WDUjwL92SrM06xlQoxZsKuXRjfL4kzcEerF70iqgDqF9ABVBt?=
 =?us-ascii?Q?80NOfYcbd78n7AOoYQN75iGhII7WADuPTWjOhCk36Rqqt9HZFwVs8B3kbTdC?=
 =?us-ascii?Q?2xVBI91CuDkblzlZ9OC6uP6atS4YizVBBITrhaklX/LWdfzYykkLVoHXB1bs?=
 =?us-ascii?Q?IlTAy5ZUOBAVcfBRBgnwR+NZYouq0cjyj5MGKo1oTI2UXIF6CeNaCWVyQvgh?=
 =?us-ascii?Q?gu2lP3KUg2GYCUvIsVoNYq6PkdF6Bdt9f2VFuGjqVSYfy66riOFztUFu1eeJ?=
 =?us-ascii?Q?8JtWNGjo+SsfxfSh8SMmcSo8Pq3uHgDuFQln68rc9VzecC6NzzXmYFdgiYpa?=
 =?us-ascii?Q?+wg8YBhu+ssNqc2N59Il6L+H0Img/Y6KFg+Fl8Lx/JjqVWnGFJrjqpd8hxYV?=
 =?us-ascii?Q?NK3ZeuJb48fa3cLX8rKzopp1IKfsXwBf2hVxUJnUTLyzdweu20vwqpUWOG3I?=
 =?us-ascii?Q?Dl7vt6Pq84W0EzGm++xHZNNqcvxmd7u4L+hg+w9QfR+9H0uFcFI/gakkVHpq?=
 =?us-ascii?Q?8I26aqInpLGiStwiikZvSPT3AUSid/BmvV8wAqCAn5VsZu+Wk4R1HR2Gfgq9?=
 =?us-ascii?Q?/wW0n6I8q1G/Bd+xY6vyGr1R9xTTsWIZ3d9KTkq8tn+mUiBHw5sAq/DmF4+L?=
 =?us-ascii?Q?WRzUq++d01sgfSdNc1j70MJJAE+ysIDSdNl3oESXZscpSBoDTNZ3NcM9xJ34?=
 =?us-ascii?Q?ct8nyK5kUYLtiURBhsfwyFSNJeBP12VEiKnS/yS46geMVts3BQXt4ATiOMWT?=
 =?us-ascii?Q?ofu9a+IxtUqwsB02RzOV3HBA+rx3zvEvvqcPs65hZIqgpbdgK2Qwy/w8YXAC?=
 =?us-ascii?Q?68Q5C0ssckhax4CPJSdPOXPVyEOdZsSJbNqxBjF2PvjXv8sDwqkaozqEMZOJ?=
 =?us-ascii?Q?Jk1gEy/9L6A/uTxdc3WLjri+9V+YcJgkcu/vUj0V/rcvwfXqdXd+2UJq9e6r?=
 =?us-ascii?Q?ejACEyZv4oAaqVOVkKKemk7jzUl7lRixr10WEM1MGf/UDyif/HfZOmrrS/bu?=
 =?us-ascii?Q?SRuyuoJ9StZxgwDp18V2FrFFqoktr83XgHgrzpRjdO+qkbWIHaSrlfw6nxIn?=
 =?us-ascii?Q?jya+bG846WlcUeZPAbuxyy+gYruIizPVBJnSwePJ581TSKaas7MUdVOdmCha?=
 =?us-ascii?Q?ZggZSbXRrraPLK9/PkrgLWnzc2sp5XY07ODrhxn+vvPMOMPL2Kgb7hEhElZ/?=
 =?us-ascii?Q?WUgofjJXySCun85P5Z0WjbHudVTjVqEqOVTSDSyST4MqcD0+0alQOBi69kgu?=
 =?us-ascii?Q?6MtG+m82Nnt4sMGqSsH7bK8Ed9Cie/jcRRyz0dZn526Smw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4DfcCWar1960uBlm+gW0HtBsn64fShONP1EQ12s9BvPyNToleIYZcCfDgBbg?=
 =?us-ascii?Q?KMXMfcZMDvkFkBMZ+oXfgCBzJ8rg1yPg9IvODGPrSrulidv5ucrb6i/Keee9?=
 =?us-ascii?Q?wlNUggBtKCjCSjmcb6l2lZCkO6thzy3rd2I25V8CgnjvTf5z3Jb/Vl+1AoTq?=
 =?us-ascii?Q?pRbtdrZ9L1p/Eymr/7EVo4WzumIZX4WQXN2gaXbTaXEYnjkEhuJqN/CbhADn?=
 =?us-ascii?Q?wxk6n23srto+QtsD7bLvgFHDpBV7fOCc/09PHkFGRDZOVP6gNOdc7XEcbR3P?=
 =?us-ascii?Q?CoGZBHQa9jWmc7OsE2xX3zUSe2FHjNWCkesXKJUtbLy3/ab0BJzutxHN+FnF?=
 =?us-ascii?Q?+3bQCYv+uCMxITKpdykKbOaQNK/oDp+9j5ePZmVIWZBkX7if5IeDgHVxMfS1?=
 =?us-ascii?Q?Fi8qLJn8QhFw+X0vOu9RrrDwKlCIC5OMinuQOyAgjJenX3gN7r3y9giZwnfU?=
 =?us-ascii?Q?1faELsvRyXvQkn2YfFMeD25qGTHWIxgWbkQmOqd3ACBH+fT3YjirAmeKazTK?=
 =?us-ascii?Q?F9KqUpaOLBdu0LlLu5IgmK8wOluR6wwnSZ0YQKDNoa3ojvBQVywiOnOXtjfw?=
 =?us-ascii?Q?sSVTVeB8dUl63gP79ooMvutAihxqNH0D549b15fJpMXWlPU2uU+X9qi2sEc0?=
 =?us-ascii?Q?HfErtGXQesHtYfMW7dtx+sL5ZxDqSrTGWP6vrSpgZojel+SvL+8/+HXBabeL?=
 =?us-ascii?Q?SMvcIZmtcOQpkfK5iZFrE+4aC1CngZH90RykVo+eMKktatW0sTpI7f618VZB?=
 =?us-ascii?Q?XXJOuLRXTf7VHy5DT4z/rTDj0o4T2iPCDP2kkl8IO2+duTpwnY5KqW6CWZl0?=
 =?us-ascii?Q?c2pBipBQptioZ+WQLk/Mmimwx0BZ8auN4wPHoRlNU/nf/Jpc/gCcTPIvX8eD?=
 =?us-ascii?Q?8/Z0H4zXL+cP6P2HqcKfThVIXxMr7qI6nZTDtn88ESBo6KsJBvNSQKveri3/?=
 =?us-ascii?Q?v6fH2J0/wRovzgtRIS9OXPjOVcQmlif0PtG3eJ5LkLmDzZ/B4rqlztWWZTB9?=
 =?us-ascii?Q?xbHEG1FC1xXGVZSHMB/tgkzs+djrC0eaIdNn7VxhMh9tD1aeztTCWPwd8kvB?=
 =?us-ascii?Q?MDo22YZ+D2L9G+HZ3rLkYESYrRKrvEe+0LFJTWTDlb+9U3Ri7GjjXwPIZI37?=
 =?us-ascii?Q?DFOJFdYZ9l+FAbiNnG02emNXMYb/8/kGSt8M+OlGPXvp/HYgJEKVe4o+t2R2?=
 =?us-ascii?Q?mH5tZl72vu8tnIchK3iUHbn9Bz0v+IFRz2fkqPIqvb2GYgVn3Bm0baukzbXn?=
 =?us-ascii?Q?vbcTXyrPb6VECiBUBjx3NTAJgvaZWRFmxw60YT0E5HiyUMDWbwJdkIBvxXyO?=
 =?us-ascii?Q?kmJEPyxuer1rGcy9TOJYf3L+36r3UOeaYd+Sh428KZLLHZAi3AtoidccD/N1?=
 =?us-ascii?Q?gD6afb10h14XVuLnkIDdj3VmkYYtE7nfGJkQnCp2cD5ztZVXXbAu5ni+ZBwj?=
 =?us-ascii?Q?WVWpv6rBCmwaXum34VcA4ph9gytVs0AhzEJEIndtu/CQN/5yJEhBXngVHlau?=
 =?us-ascii?Q?4vvD25rTfuLQcuo3FqxGy0ugCAwE3thHThjtxaDI2A8aqY8cgYaJlS0EcEUH?=
 =?us-ascii?Q?qTfr5B1WXa/D2d76cy+6Tl5M6t05VLFr1OLdxmDp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f88daba5-7d45-4d1d-2727-08dccda25dca
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2024 12:00:42.3035
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W87KGsoI6Q63KCzsNhSPLDk+XNZ+Oin/GPywYkb82SMdpJ1bv6RPPW2pVnUAJ9/g
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9356

On Tue, Sep 03, 2024 at 05:59:38PM -0700, Dan Williams wrote:
> Jason Gunthorpe wrote:
> > On Tue, Sep 03, 2024 at 01:34:29PM -0700, Dan Williams wrote:
> > > Jason Gunthorpe wrote:
> > > > On Fri, Aug 30, 2024 at 01:20:12PM +0800, Xu Yilun wrote:
> > > > 
> > > > > > If that is true for the confidential compute, I don't know.
> > > > > 
> > > > > For Intel TDX TEE-IO, there may be a different story.
> > > > > 
> > > > > Architechturely the secure IOMMU page table has to share with KVM secure
> > > > > stage 2 (SEPT). The SEPT is managed by firmware (TDX Module), TDX Module
> > > > > ensures the SEPT operations good for secure IOMMU, so there is no much
> > > > > trick to play for SEPT.
> > > > 
> > > > Yes, I think ARM will do the same as well.
> > > > 
> > > > From a uAPI perspective we need some way to create a secure vPCI
> > > > function linked to a KVM and some IOMMUs will implicitly get a
> > > > translation from the secure world and some IOMMUs will need to manage
> > > > it in untrusted hypervisor memory.
> > > 
> > > Yes. This matches the line of though I had for the PCI TSM core
> > > interface. 
> > 
> > Okay, but I don't think you should ever be binding any PCI stuff to
> > KVM without involving VFIO in some way.
> > 
> > VFIO is the security proof that userspace is even permitted to touch
> > that PCI Device at all.
> 
> Right, I think VFIO grows a uAPI to make a vPCI device "bind capable"
> which ties together the PCI/TSM security context, the assignable device
> context and the KVM context.

I think it is more than just "bind capable", I understand various
situations are going to require information passed from the VMM to the
secure world to specify details about what vPCI function will appear
in the VM.

AMD probably needs very little here, but others will need more.

> > It would be a good starting point for other platforms to pick at. Try
> > iommufd first (I'm guessing this is correct) and if it doesn't work
> > explain why.
> 
> Yes, makes sense. Will take a look at that also to prevent more
> disconnects on what this PCI device-security community is actually
> building.

We are already adding a VIOMMU object and that is going to be the
linkage to the KVM side

So we could have new actions:
 - Create a CC VIOMMU with XYZ parameters
 - Create a CC vPCI function on the vIOMMU with XYZ parameters
 - Query stuff?
 - ???
 - Destroy a vPCI function

Jason

