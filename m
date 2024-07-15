Return-Path: <kvm+bounces-21643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DD9B9313FE
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 14:20:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8DB0E1F21060
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 12:20:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 422C918A95A;
	Mon, 15 Jul 2024 12:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ejmqIuzT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2061.outbound.protection.outlook.com [40.107.220.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC03E2AD31
	for <kvm@vger.kernel.org>; Mon, 15 Jul 2024 12:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721045993; cv=fail; b=P92EmCmPT0+PgOaxS1Ef0GmduB7oeP0bkgkH49sADlbHFPX7FflxIMvjMshpcsOMB4jezR+UE+5GCzikIqOdxxBPtVjQD0F7bKY1AwoT33vcJnTi9oGWwAJivDCejOnShsEb3HeyDa/veqHenbtB4uk6X8+4dN5g3srxjtazdco=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721045993; c=relaxed/simple;
	bh=aJkCIU2w1M25l95NkwYlLSXgG3yktIAitlsK/SA7anU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=eCt5ZtijsGGpP+S/Q5iZgQ8ml9y4IMxggdv7ZWd5JV99bW9kRh6q4ryClURxMW4dCHiBTU4eJajf8COc+cxM7R/13foF4UQ4MXVH//GPEhi8Ifpjy4pOyq2MHmaZX3h/PuD64fBkmOoa+Yb4cTrZ20DSyKkuZY22hx+JbefEczk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ejmqIuzT; arc=fail smtp.client-ip=40.107.220.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s17IP/gaLELOZH21NXM9sCS2dK5/xQsVDMyGtCGK4zz7GdBNljHKtkAZ/21seH3yfizgH4BbVSSUZ+bIOZ5PJoK0KcKmMDe5pAvvjZX4WxLjoKJqkfYjLXsH0EEIPN4nzaEHhFLqvrlqDXQTdgSCJnrHKvXpBok75Ic9+N8qam0xs5536EdZb1VB6JVAdsfRrGwPbErAedOuboXyOLmdPx0mTV1k7IhcX3zQ72r0MVpCOhnrPrJGioNQrnwKNmv2cG0o8Hqa67uARZ0XsJtN+PU5VbYkRPAIo7x606PB4430JLas/DTdFVzfpWA2nyXQEFxIle9VtkYAEIWWYNSLYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lWkVNnCRnD3ro+S8NS1WP4rV2pB93bQmxa1qMSmmjr0=;
 b=a7kV7yNDbbZVYQIrPNWE10YYjLh7hjM7BzZ0vEjPk146JzcPkrIyooXiBvLDPCGhJt5+VWry1SZVfP/rQl9eZaoVfl3ieLJZYzpgOwseeEoX3dWLOMmvRKwOvwivmEotjXAT80j/6Ulk4BberUsQy3jSrnuduNvrgcY3N35kRF2fJk8/D1zyWZKgu/JM9GSJx7cfsXG6dW2QLpJyj8hnX6CoC++4pUMBwgpou9bOOgc8JGXUnzSS/ovhpeww8LzEeHVefrJbDxlZuHCAh//mYgRHEUcohc6QCuukK6ORjs3JIynwdrGgKsQQgpVZ9dqzj1N+ZWdQEHuJnQln86sp1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lWkVNnCRnD3ro+S8NS1WP4rV2pB93bQmxa1qMSmmjr0=;
 b=ejmqIuzTmg/4/Jtdf1OWdUj0HQ/iNJXo4+9u240ME7+VVgVkqbZSHIf3mYt82IovwNxDbBeFlfeETzSUTWF6v5xk7fI7xOAM07GOsylCpt0KqZgzufRv4QIZmxvS03jxmfGl/+qHs2i9PtNB2qE+TmrjWdOYkwiGhOT2kurpY0ajCjjAvBmLU+6Zg5N99+SvFPQBWbchpq9hkh2YGgR+Y8dypg0QY/EFoyjcHsxyOjtHNyJAMKW7bcP5WAojKE9hItNPuK+IvbqA+86EElfrYCVOH9teOq46wQLpSCfEsQnF2cwkeWwqDp1BEjn0q5QAVFBmGff83NeiXZa4489EMw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH7PR12MB8779.namprd12.prod.outlook.com (2603:10b6:510:26b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Mon, 15 Jul
 2024 12:19:48 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7762.027; Mon, 15 Jul 2024
 12:19:48 +0000
Date: Mon, 15 Jul 2024 09:19:46 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>
Subject: Re: [PATCH 0/6] Make set_dev_pasid op supportting domain replacement
Message-ID: <20240715121946.GT1482543@nvidia.com>
References: <20240628085538.47049-1-yi.l.liu@intel.com>
 <BN9PR11MB5276F74566E3CBE666FCD3BB8CA42@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240711184119.GL1482543@nvidia.com>
 <a3848458-b41c-4ef1-ae0e-28bf5f3ad43c@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3848458-b41c-4ef1-ae0e-28bf5f3ad43c@intel.com>
X-ClientProxiedBy: MN2PR18CA0024.namprd18.prod.outlook.com
 (2603:10b6:208:23c::29) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH7PR12MB8779:EE_
X-MS-Office365-Filtering-Correlation-Id: a1e0fe36-11bd-4da0-9331-08dca4c86b56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7wBIjJUe5/fLYLdVxzVUUjuOsU9mMZ8GT+n6hGsSB6ZRUJSEJg+j4ze8+wOw?=
 =?us-ascii?Q?1CtVN0GNf37ykM4MhCvZXUqDoLdinx0MQ55WT16ZJDAB9+eujkgWwU4RaL7J?=
 =?us-ascii?Q?nO443MnpIImpwlamHsZLGeIoUwOJKYAkc+tXHSyxO4sEyBM4pFoAmgSfsNfc?=
 =?us-ascii?Q?m5iIUdwQS1XcyPmU5uVxlhAnWXIcjuaduk7U6DCgav9kPUEcJwYiJUjRQ/HS?=
 =?us-ascii?Q?38TEqsQvviFPpQadD+IU3TwqSe76Se+2WBs2qpBwJCk7cg+SQfwTIoX5ivJA?=
 =?us-ascii?Q?ZOjcneiHJnqxyxZy9TRwpnbGNOpKGkKP3bjibTilyoP5LQBA5LvSV5sNWj7Q?=
 =?us-ascii?Q?A8Yrk7vbnfhbndzu0FtoZi71kXp3TqwnoL7gTA7QxJMZjV7cgF+PbGgbZfGU?=
 =?us-ascii?Q?pKyW79v6M+AwFt46nr4cgFxDlbOYsMp0ftuScPwDDZ0TuGtVod6LmsiYptt0?=
 =?us-ascii?Q?N5KSbXqk309QGj0SZWCybcQHxRplgL1npr2ho7qTK8uampxyYrXvsCNdelSR?=
 =?us-ascii?Q?R+VuYcVFyvuhlkRrGuvv6eYqaozu7GUQgVHXO/Ja1COxafZHfGiL4H4UIPQZ?=
 =?us-ascii?Q?EV6QKEPCwoj8VCDljdYP5WtDBP3eakTtEJ0P2mhT/cE4hmEZ5BgFtRgXZzpI?=
 =?us-ascii?Q?6ciNoHUWiJ+K7+fGlZIKd9xAyH2OnNp8tGxO1FeCRYn0/wkTI6ykPCqbOXWY?=
 =?us-ascii?Q?le1/nd9oYozcoIlKF06s82ZmKLL/K4xye0U/LPxRmGAUt88/+3AqVkY2YRnF?=
 =?us-ascii?Q?t8XS7b6M+SWa1slHT0ed6W6a6Gp/6oqNgspWVEvC2i88l/twQP4Exx7gO3um?=
 =?us-ascii?Q?z27wK9JvifpM8Tl2HkzZ8yT/8H0Y4lamZ0/GLh43VginGRYjHZwO31eZ07dh?=
 =?us-ascii?Q?9BIHH486jGY80OUghz4Z3WsoMLsnvnA9627dTT6OggB3R9RaU1SL4B7vqZuY?=
 =?us-ascii?Q?xm4TqBc060upXafya/tX31GAAWQ+oWiAi3q/jlILBMzZScxW7n5xq+LVpKBU?=
 =?us-ascii?Q?mzbmG/ZfeMhEkwsfAgrPVJ4PagLz+tW+5C0DrZ0FPeTGJHzMCWWtaY29D3wU?=
 =?us-ascii?Q?+QfgGPbKoncmCTkpPMQQm26VQ4lOz3m9gWwCpa7WKaIoxdGGvc3pbPkh0HX/?=
 =?us-ascii?Q?SzaoK0KvV2jZo8Z5axDJFpmjvM6HpQ/2ExAJ5Hx8VcjZYAAyD5lI3FGdO4mB?=
 =?us-ascii?Q?fj7NcmX00JVLQGbvxsfaAtCy0BmHSNU5AN2FNhfdfarJoNmwRaBnAZ1jHjyu?=
 =?us-ascii?Q?NxqgvFWsdHhJzck8lZN2NFG9aUAXMySp5YExuNZE3wsQ2CG/EPbhzqOQTXQo?=
 =?us-ascii?Q?T6Hhl+24EEmStHr5MPs+W6wAfXms1Y+f80ih5mmHdxZkIA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Fw5tukAMPqd0ThIGjbMnDHOGHr4eB8pVqcnzYx/qy7ZrTu2QlSjF4Xo0ewwe?=
 =?us-ascii?Q?2jsZqdeMDhU9Y78ddYdmfwEYNaakh+n3LDm9KD2uCPvdwOEjuGus+VzcXFIG?=
 =?us-ascii?Q?Z8ZcuTON0+fAN5h6CJBL/x4fUYD4W0ibJPp4GNbP6qhS4dA1afZnSM1VXY/6?=
 =?us-ascii?Q?U+HgcnfG3J8WPrKjrDvK8QhemBqOfHJ6AbMPCLauKW9IT1pEEKv30b12/UQt?=
 =?us-ascii?Q?g9LKy5J9gCtAZkSaWSKlfPbdsNS+eWO4IjrbspGO0tVWh4e+HVOlRGN1SuRY?=
 =?us-ascii?Q?7Mu9wAeyWJlikJXi+x2PtsZuxoASsUYrhQSBvAYk2YsP0veg8tmglnR68Ae0?=
 =?us-ascii?Q?b1fQTy5V7YO+WWm/YufBW+9samOlUX9YnfD0GMPedXPC8gdf/cvMF4wWTYlk?=
 =?us-ascii?Q?DMcgrbvxe6fJUveMoFX1jcBT1XJHR+qUSobMs0XQEYAp5Ibv1kGliOh9G57r?=
 =?us-ascii?Q?9wNIbMDSSTQ7vkjrAejQqjlv52jqyHbfJ5BhuB6okJKWhzuUSmSIAGH/hF3y?=
 =?us-ascii?Q?g9GwitJbGXDT5/YKtxbO6FdwcPspxcnhrDjrR0i4E4k0nMjtbdsFG/QpCwGR?=
 =?us-ascii?Q?GXBxKntGSMVqe40VDXyENOFpRYsiIeQD4nBoPDcHPVXjcgehHfTkS0arHLo1?=
 =?us-ascii?Q?jCcZmi+n7/0OWwrm1NjVtECGGMg9fhLV0lAgWtOqYrr1aiYOq2TC9N3+grxs?=
 =?us-ascii?Q?ys92l9iUqeEzir9vsoQsXuOe43zaY8eR/dOFZM51VYqkz92+LO/tfrHz5bRA?=
 =?us-ascii?Q?Ct1il6m4drcBHpGzUJXKXnjbaKMfpx0D5H2sORz53ZnY66IIckQGOtbk6g7s?=
 =?us-ascii?Q?jvKeGzGmzsNgguSfyzIawbgYW7Kwg4b4hd0N431Gh82J9N2PrcrRS2kyB364?=
 =?us-ascii?Q?3HAeJcLB5R2e3Q151TDo46w+tf6WIqjKypAT0LBIb5mo0Sekedx9pihnJcnE?=
 =?us-ascii?Q?Ql+RocD4v2k+urfkLBGsHbNi64Jdgr6KU4WZLsM6brvOKVKSvWDO96YMSW6Y?=
 =?us-ascii?Q?dE1ZrxQj42j1vPsEkWCtDRqM2rh4V4R1xLd2QsJmnsR0ds8S4K+BMltuPA8e?=
 =?us-ascii?Q?uYObYDwxzyuf2efXzunvjKzhQI8rAiYA4PZycmOvVoO3I8oLSqbjubO4tBKl?=
 =?us-ascii?Q?ZbMcqr3a0AQQjQ4gBH/hyXkkkX0G33Sw0Sq1RJPQX9J8ll6c3QA4FYNU/8G6?=
 =?us-ascii?Q?v2RNU7Ou8gsRsbvx15Lgq8sZ3UwZSpKcm1xs4pBIXTv1k2CoJhuI3dhyajq/?=
 =?us-ascii?Q?pM9zq8T/7hpNZygBRW3GrxgMNHeUvvoRY8Jib33Hnsrk7ZBL0r2nsbhrjgx+?=
 =?us-ascii?Q?D9l2CdOx0GhH30XElIE7IyT4PgfySTrwm1AA36WlnKvY0BdsJkKSdEeUgNPh?=
 =?us-ascii?Q?A2mlZqyviLS0i4ysBPsGprIHA4vUFfGO1pjPMUsuuJARHnzbXuaG4TuONLtW?=
 =?us-ascii?Q?akE2K/icyj562h7ssNsN1BhPpk5Mv1gvCQ+hnyaqD+EFfd6xiosGejWbkQ46?=
 =?us-ascii?Q?R3nPn92GXKXsXRs/8jZXvHg1fP4GnblHb0GWPFM4RLuE7WdjRWgl0SRDQnO6?=
 =?us-ascii?Q?OIyECAMoNOf6UzgnWX4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1e0fe36-11bd-4da0-9331-08dca4c86b56
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2024 12:19:48.2126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ySArfzF2tYBoFy3DS18VE+pyFfEio3jFdW2FSs4wfcSBvxMTkMBc4oCzNIGw4mKY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8779

On Mon, Jul 15, 2024 at 04:23:07PM +0800, Yi Liu wrote:
> > Then the description is sort of like
> > 
> > Replace is useful for iommufd/VFIO to provide perfect HW emulation in
> > case the VM is expecting to be able to change a PASID on the fly. As
> > AMD will only support PASID in VM's using nested translation where we
> > don't use the set_dev_pasid API leave it disabled for now.
> 
> Does it apply to SMMUv3 as well? IIRC. ARM SMMUv3 also has the CD table
> (a.k.a PASID table) within the guest. And I think this is the major reason
> for your above statement. right?

It does, but it also supports replace so no need to explain why we
don't enable it :)

Jason

