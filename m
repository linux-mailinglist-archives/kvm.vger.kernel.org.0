Return-Path: <kvm+bounces-27369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CF2F98458C
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 14:07:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60EB9281144
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 12:07:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBCFB1A7074;
	Tue, 24 Sep 2024 12:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dxb6ny+a"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D28E1E4BE;
	Tue, 24 Sep 2024 12:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727179663; cv=fail; b=AfqPe8PDioBYI1vTri7ebVDoAqBsYODn9ebAGBoITlK+3F+mvyE5bbpfxIWAhMQLY90pH3vbiqFHROvL0cg+zGNyx7Nuyi+bRmjQEwEiLqFX6m70QiOwb3604wh1tzPQPCQb2W9Q4zPo0/hwENpDbYrVdcA8pfu1Ajzm5tYzpvY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727179663; c=relaxed/simple;
	bh=4/mtoymYQzJhy+yGtu6rH3tne3vgm2UfhlljFFvSSoo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UgkglEkUTc5MNyyx30xT78EQ810/kfiEYNxFp/rUceWJ8TvqTnHDds0h57ooTpZv4dbNhAVrwDgoH6mRLpWpJ6xSWNp29fgYui5tL6Ne8P8ZcbuwRFpvwaHP9eXlCENCAzsyoGKaUhmDz0qnPI2sj32i1TOM4uR4WtwolhQCuU4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dxb6ny+a; arc=fail smtp.client-ip=40.107.237.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E8JN2y9fZO6EenHRP24TYWMssI6zvnZI1cqVsMwVSOUvIEc3/xUI4AI/3Yh1n3dVWZR4dYe15FFUQ3no2IOQhqybXYNgNJbnHsV4zL6ls7/Xk3hTxVClpoR5QN8DKYeU9klI5q/Rc0NzcRLd5dhdUbZ4CvFLWBXk5iCigKuEOgzZ5m+6GTQZWLfis6x4O9RT/ewKq26l78dcyXl6ud4TMcwsHhx4Ps9rpg9ZpkfrFxnKdLeImDuELNfAwgcaIuo654QcEcUQ2HJqsZxfviN05Abm4oiwNOJwF6b9icQDQSCjWUF92aFI020tmXbEPBR5mOEobcZ4JpBFGhlYdaamhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PDoFfHSW6IajwBEtxqfNFmLx8i525iSlsxg/Z45FzHQ=;
 b=Asc6X0uOkr7KGKbPiKRJDbUFghygCvgvHUbINmI+Ko0kcg/pIvVaCwXWyAUQmK1dhLTE9G1kv0sA7m6WlYj3EneKzPlB/wBNZQFhpAE7XXN+E8Rpjbh8Dgq4iX2AV8zozOkmxYQ89I3fjm8RqLvglKxMkZjSKjBOFxd8ysJsjLlug1xN6KtoBz5/kbhJjm0oM7bTmO6peNtc7YI3S/KyCG06TtEhatGJKJJDOckZBWz5x5CSxygdhYcD076WWIr+CU8f+V0H82229Zthj95Zu5UIkQIjyI1wSgPQCqDGjvtj11ewdPyKPW4bV+gpP9OuwKRhoGtPEg0exWzLHS0RCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PDoFfHSW6IajwBEtxqfNFmLx8i525iSlsxg/Z45FzHQ=;
 b=dxb6ny+aLNnv2bMVOif7+h1cX418ZPNHdNUObvUiDUHA4zhtAzyHWvq4OCnTtGFcyM38UXV7QX6fPALUK0E/E8GbyAw2bTH2rJKRiRKp1i/Ki1t7NeNXnGGXaLlE8IoDop2mIVRFqlreX3SuGf2+HoqkJxcEJOk1ZRP5fABnCYHZYfoWmtzZsmjIhcZEChez1fJnkDgt5aZ4fcaABjCG0Qu+mffEWGD+E//vqtdYkw4c31YB8OjiGuWIkIYMxH7yANuZjnrL/LFgY31bbd5HmUATrArgvLlj36WRZVwmhcKgSMbkDf3gPg0y3H17p2kwtl6CHcy/yIu/8Kz5snU8yQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA1PR12MB8466.namprd12.prod.outlook.com (2603:10b6:208:44b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.25; Tue, 24 Sep
 2024 12:07:36 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.7982.022; Tue, 24 Sep 2024
 12:07:36 +0000
Date: Tue, 24 Sep 2024 09:07:35 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "Annapurve, Vishal" <vannapurve@google.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
	"pratikrajesh.sampat@amd.com" <pratikrajesh.sampat@amd.com>,
	"michael.day@amd.com" <michael.day@amd.com>,
	"david.kaplan@amd.com" <david.kaplan@amd.com>,
	"dhaval.giani@amd.com" <dhaval.giani@amd.com>,
	Santosh Shukla <santosh.shukla@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>, Alexander Graf <agraf@suse.de>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
Subject: Re: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Message-ID: <20240924120735.GI9417@nvidia.com>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-13-aik@amd.com>
 <ZudMoBkGCi/dTKVo@nvidia.com>
 <CAGtprH8C4MQwVTFPBMbFWyW4BrK8-mDqjJn-UUFbFhw4w23f3A@mail.gmail.com>
 <BN9PR11MB527608E3B8B354502F22DFCA8C6F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <CAGtprH-bj_+1k-jwEVS9PcAmCOvo72Vec3VVKvL1te7T8R1ooQ@mail.gmail.com>
 <BL1PR11MB5271327169B23A60D66965F38C6F2@BL1PR11MB5271.namprd11.prod.outlook.com>
 <20240923160239.GD9417@nvidia.com>
 <BN9PR11MB527605EA6D4DB0C8A4D4AFD78C6F2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527605EA6D4DB0C8A4D4AFD78C6F2@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BN9PR03CA0852.namprd03.prod.outlook.com
 (2603:10b6:408:13d::17) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA1PR12MB8466:EE_
X-MS-Office365-Filtering-Correlation-Id: a32ba90b-2ddc-4372-c8a9-08dcdc917a6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OK9vrND0WbrM5jLm0EYG1+qHnCqs5M+ZuL+k2T9R2+z7rBDN5HrFv5eDBVsp?=
 =?us-ascii?Q?nHlBwbNn+7fZ7vTsxwmgxIelPSOw53HQE4ejaxG3UHF9CJU3ZWHYo3RfV9oy?=
 =?us-ascii?Q?Vv5byS5swrk7ATws3qt9Hf6Ciaxm2bEdSu11rOO1kIU0RcVjBy8q772J1pv+?=
 =?us-ascii?Q?7Zu+fThu5ZwWp/SVgCH0Bjz/eHLvrxz4uhq5+XAtxnDWq0kd/JqS1ZvmxOGN?=
 =?us-ascii?Q?2H/WWiKIJWjNvipaRaGsWcXds41ZKvRegHA12NAKi7ABC25NTXsooHN8p1F/?=
 =?us-ascii?Q?MatSjf+r8PaOinATAbW5Xfy91J80EBoibCNwr0gkcbmVz/l5G5sadGERsyiK?=
 =?us-ascii?Q?bYlfTpN3qoQsJ1eJCo17G0bMz9lVuFs7VaiiQvM+o3+gBeUwICFD1NsS3mo7?=
 =?us-ascii?Q?VTC5v8hAdFR6xi4s843njDKrL0wb2DVN4sknzleiiHOvfLuJ6M7WDpvuZRqQ?=
 =?us-ascii?Q?KZltmWylHD9QIp+xyaUtoIuK535BbrYDAArsx4QC5/vqURGidnWfzF0yYkl2?=
 =?us-ascii?Q?VT9x+uQfUTqpE4f7Yf8BcXkqAJxiKHjh6C8YPt4lQY+v8BT8XXt8/RZbs99L?=
 =?us-ascii?Q?6ODAvrN79ieCO5fURkHLv42dVAiCOtfCNJDHxnqNxKVUxEYfdOWsky04LGAZ?=
 =?us-ascii?Q?ryIBmKbC3N3t25vlaRMEr+KR8gFVI9KuAUzXEzyz9HXzQtQJx1LgRD5Ncyhm?=
 =?us-ascii?Q?2gc7Uf0oqleEkpydY8ApKxmRQl4cGSdX5v/aYqTqSVPn5FxrxINL/9AEpVNR?=
 =?us-ascii?Q?si/zfeH9mRhJ22kEJaDQ5MerPq419m3QxafaCTwSgZwG3G9ONgb7YZV6eugy?=
 =?us-ascii?Q?ayLFuBAOGYd9MIzEiwf/0/X8tyCenraJdvyE5d1WHdUboembnOXpBiZS6VtX?=
 =?us-ascii?Q?G0Ej0DHDDN9M4bZDHyeHBQgkGWFZmYtjHwr4spez2MmABT/0Ngt2+Gnl/nrb?=
 =?us-ascii?Q?HlpO2X065xDziaeIcUuLgbVlswzmTKnXGQilbLqQ5nq1P1F3NH9JHaLLyRO9?=
 =?us-ascii?Q?MbPIVqPTYQPCkkDuyJPEnfMwZVktBUkxXS8kV9QRnl6UMNHeXouEwTrbU/9W?=
 =?us-ascii?Q?x68LN93ojScuAcb8fEJLLBY5Pnfb1vIfycvRXab+h5TCpyHeGDBxpyZDZJEa?=
 =?us-ascii?Q?glfcDNIBUISy+8o2TU9JVjhzWWmXli+GCdbBEFfyurf5rp7GG2I5TD+1fyDX?=
 =?us-ascii?Q?Vwi+mQ1NO5AevVVgw8sdFXrlcbEhJ8gOktm29qAOxX/YNe5LLynlzPhaBlRI?=
 =?us-ascii?Q?sBAAAImnEjUa1M6Yeo5xvjdTYwQsBc2nKvfmDuTTnw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gT5VBt0IKgJjos1n/WjZjCGRKM9MSRzOfNBhXmCVxdxvPAn+OyZtKDeLaZXc?=
 =?us-ascii?Q?XTlG4F754l6YoVF5OspoZQdukoZfCJYxmy11Sf6EIOb3wMTuBWHRRrVyWhcR?=
 =?us-ascii?Q?pARLUBf/3Yz7vp3Ip6gvJ5hVCmCTY39stef96N2A/LSpfM0Sjh4t0jLTqVx1?=
 =?us-ascii?Q?GWrhtY1T12568NOROWWVUxPKO4LjUcV2vCV1Fl7rQBrkLZ9VmnzXB5EcwVDM?=
 =?us-ascii?Q?+QprSo+9OwxbAmTA30nvVm+On5o5HbW1vi6I+QqiIbJUh1YaC7bk2O4ATjP2?=
 =?us-ascii?Q?MTX+j8t1bCjQGE0sUf8xBBPImPxScjpatxVKeW2ars+W1XUFYlXBHmOTb20y?=
 =?us-ascii?Q?VU6wAkIsaZQYT5ss65ZrX5bgKITpHD12zmPnPOWdgkNshh0AKgMr2BGcrv8Z?=
 =?us-ascii?Q?7bqVUzcUAXF7m9gExN2U3guxp9tyZWkzh+O8c49QyTwH3sDDc9BwvMNwE8FZ?=
 =?us-ascii?Q?/tlBYbdnhHRWzP3o/LjTgP4s8JvBAxe8XkT0u5xvht2GWJexUDE30RQJec1W?=
 =?us-ascii?Q?LPqCd2sma0Mp+cBUChrLGIpchtkZ4Mt//VHtSHygxDpgwR+1Twpz77Ou1sWq?=
 =?us-ascii?Q?e6U0lRXfDx42Jt3hDAP7sht1QobcmmQJtMPCZZtm8hiCv8N9fd4QfQiFpuLe?=
 =?us-ascii?Q?ctJ6hxNAUhxD9NkQ2pKMe5JOBkF311aM0BU5U+iPuyokFpaHInr+HdeKbp/d?=
 =?us-ascii?Q?5r4R/xR1ddrUO4CvEvAr2c3fbPdOUcnsqE47KRu3Y62P+rJEUipTcGqEcf9U?=
 =?us-ascii?Q?pDVn0mgMHWD4gEFNtOPTIENxQqneP0YHX5uUQbRkk5RxNL7YZmUo5wlEd8zU?=
 =?us-ascii?Q?mnBPNy+oTV+Gs2C2tahqPyOGzfNKX15TyIUnWeQ4FB3qHOAKwUC6X2gCEmE/?=
 =?us-ascii?Q?ErXeFmYf4wnnaFQvksDttGBdqzSo8Hj0CddYuJYeqjGk8DvBzo45+tS2mg1W?=
 =?us-ascii?Q?liYREAsPNnYWYClx2UPLVqZPZmB+P0MGY/ztYOxYS8/2Rd+R/2ddHccpHQdf?=
 =?us-ascii?Q?NvmLOjlbkm/SPVTnTkN44Fyh1lnRPQ8vW/a8U76zaeoDa+BxIrWl6RBcNiFT?=
 =?us-ascii?Q?GboUAKhdsA2orV8Ouk2cMI5r2+X+wgiXCk9aElX0WxzOHTxNdthTwr5Ng2Md?=
 =?us-ascii?Q?zfQHN1dmJENkHXFmGm8Jzg7bUT3uO56bYI+JS+Mcsw21k6dBJeJQSauz9XRK?=
 =?us-ascii?Q?XqVIFeL3ufzhcX4Wup/UVYpIUbLKO5ZUdKpi03JXBGE4GhZ5VovfeEJYBKdN?=
 =?us-ascii?Q?fGpXt+p2wRVY5GK256tLZRQ3crkksfByqET4LioHxt9gvD4MYhgUSrJnh+S1?=
 =?us-ascii?Q?OWsVr2+SlvnaNnzmU/LdDdC4xwW7Y+3Fec6M+lq2zc74kY02q3PBQo57G9GK?=
 =?us-ascii?Q?JnkYtiIUlB6KXNv0mzMg1CBViA+MI4vYdygP5rMh3jZs80sd6M+hR4L3n9sJ?=
 =?us-ascii?Q?NVoM0oxMEfHYB++XtVUI1K1n7PBM5ey2bkQ4pX8oAJZz8pQcusgWXRuymekU?=
 =?us-ascii?Q?X7/YLv/IWgbzBghYON0wcOJVObI1gA24KKA/LJvI6fb3f8p8TP+ktJ0QuZQh?=
 =?us-ascii?Q?s2bvrXvhh5z6oC5ax2E=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a32ba90b-2ddc-4372-c8a9-08dcdc917a6a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2024 12:07:36.3719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C6Ibmr2NK8RUnFMEEebv1hBiDewDAiLCdHRIn5IQ+WhjCFALkbugxeyTxINwUlod
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8466

On Mon, Sep 23, 2024 at 11:52:19PM +0000, Tian, Kevin wrote:
> > IMHO we should try to do as best we can here, and the ideal interface
> > would be a notifier to switch the shared/private pages in some portion
> > of the guestmemfd. With the idea that iommufd could perhaps do it
> > atomically.
> 
> yes atomic replacement is necessary here, as there might be in-fly
> DMAs to pages adjacent to the one being converted in the same
> 1G hunk. Unmap/remap could potentially break it.

Yeah.. This integration is going to be much more complicated than I
originally thought about. It will need the generic pt stuff as the
hitless page table manipulations we are contemplating here are pretty
complex.

Jason

