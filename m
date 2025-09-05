Return-Path: <kvm+bounces-56882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 49AEFB4593F
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 15:38:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 121924807B0
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 13:35:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8038035334B;
	Fri,  5 Sep 2025 13:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Yh5/PhEx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2075.outbound.protection.outlook.com [40.107.212.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB5B1A704B;
	Fri,  5 Sep 2025 13:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757079281; cv=fail; b=XBGaK1AXUHx8IdiENse6P5wMjFGMPfyfG6nADqsrDRw8SIVP0ZRWPVrNmfH+Zcd/jInNSBc3opxPIzrMtKvsq9yQglI59XLNHtiGijRFTm87gBmnaOJw+ljy3d406mwGUOlatdrlyFxOF1lr2/eY1xfDhaDvjXQs8+8PiVPzuEk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757079281; c=relaxed/simple;
	bh=jzjO0vH4LAVElCwskIJnGMiDkmzsZaZpi+aksUgTB6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=c901bF3Nmi4Vi0piXOZjsHhkrcXb5auHj4HOMBTNC4q5cJzmRP0yDOVIEBOjNahnuR+vV+Qe1lh3Qcnh4/GyrcWEAjMY6R7ADEzuKUgWp6aHKQTKIyrFUYVCRxwwE3NDF0iMA9w3f6/J3op0cEsddIA1d5EVf20tIUKLEnCzoVE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Yh5/PhEx; arc=fail smtp.client-ip=40.107.212.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=actdSItVSOdNcNvDPGoZ/2S5R/1D9z4FVXEHZks91hEtLZ/cGmiDTMplTfdUhB6UtGbavAB0ZV62ROAp+c+OVUC1MzcX3HH1foyn2NNR+tVFAE+niwxhWUEINNthtnCyrjMcluJIzy3gF1NPnqpL00EzP8d/cK/eXH2wz5l0U7I8/OmGT02kGjznPCaEieC7FCPkFFUbFvU4l/XcaFY/Jqv4VsO/+RzRpWw1DKJ7fyzLbgXjhAB0pNhtFSgFqepjMZZ39SVN14HfQHYzUnapziP2E11QS8kS7bivkpWIlZCzByRfmUuvGqjCYxltiWXR1Ho+Y58UwRv82w/u1MMXLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oBPFpaoNpizuNAlC8uT6eeo5gbq59Y/05aNQBoFwABs=;
 b=BSyzXQ7VkzvBO6YGIo3cupfdLkVpXmdpC0BTGqQOwgYVxe606M9AybI2jQ6p3JzAiDuyj4GQT/vk2PLhl7PFn4wvvpGH0iKwTkjkUH/uR9XQhvvE1VHku6PB06jQfCKM4b/6ROFDpRkgP0WHbuJbcW1CIuHH7FQQ4x3maZvd4AAfl4iG1qCV+e1DZbHhohfBZOKvHERyuh0tsLw96jKwujEbRPd1SZfpSISerkLTZSR/8X3wTz8CF6U4bzVIiGo2WujkT9X89kVsJxaKHpoMW0yegfIDeFLuUmnaRE6qmjwD0MsQOqOu5cHoeAI5ghhSBnPeTVdT+JNYu410ADbCUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oBPFpaoNpizuNAlC8uT6eeo5gbq59Y/05aNQBoFwABs=;
 b=Yh5/PhExzHpwdwU73ts5woQEH67JeuzRgOSJOKMArxfmfo+9PBhRPdQIb1hqvq88ul9CdLa3cXRlEUpDyb+T9FFVWG7E/eXeArtsstNvbLJAM2P4xfdRQawOURwUYD8y6+UkHUho2xDofUhvqji+LHDatWFcp9SBJLL9/5C7UBIiAOZf4yIubgf1bGb7tKMoFEFTNkSVepCLO64rzVOge1NxwLuezotMaBC7++SH9BFULWFmGoEAiFYZtvoZ/nvIeGWmRKvV2lyUD/RZCH7xNx151QXuorSzpnw2WyFGO+/cFfAt6b8VVec2v85JfrpSNh2kEkOgbCdKvjK9hjVaIw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by CYYPR12MB8871.namprd12.prod.outlook.com (2603:10b6:930:c2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Fri, 5 Sep
 2025 13:34:36 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9094.017; Fri, 5 Sep 2025
 13:34:36 +0000
Date: Fri, 5 Sep 2025 10:34:34 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: ankita@nvidia.com
Cc: alex.williamson@redhat.com, yishaih@nvidia.com, skolothumtho@nvidia.com,
	kevin.tian@intel.com, yi.l.liu@intel.com, zhiw@nvidia.com,
	aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
	targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
	apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
	anuaggarwal@nvidia.com, mochs@nvidia.com, kjaju@nvidia.com,
	dnigam@nvidia.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC 08/14] vfio/nvgrace-egm: Expose EGM region as char device
Message-ID: <20250905133434.GE616306@nvidia.com>
References: <20250904040828.319452-1-ankita@nvidia.com>
 <20250904040828.319452-9-ankita@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904040828.319452-9-ankita@nvidia.com>
X-ClientProxiedBy: YT1PR01CA0125.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2c::34) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|CYYPR12MB8871:EE_
X-MS-Office365-Filtering-Correlation-Id: 349ad7d7-d1f0-46ef-4035-08ddec80f48d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dPW+fFFWwScSXG6xOUaZYNLlx50onZFT12kNghBhETJ5gGrboH89ptcvEnx+?=
 =?us-ascii?Q?bw62I0KPUd+Y24JBhtrDIzEsiP2lUo7GpTm5cqmqpyke3isW7zx1xkxZU8uj?=
 =?us-ascii?Q?B2cYhPKhcp0623muDTNk/gRgsf9ACQgDCta+WQZoaLC7B7ACWevoQ+yYZqJR?=
 =?us-ascii?Q?sR7G72zNhDDLiy7LGjPt/6dQOnwM7NIpyvNw+ur6m34nVfdvtY63CXcY2s4B?=
 =?us-ascii?Q?sqF0mo3z+0A+kMAvotMzF2Levtl9eS90zHgftFDSlmvx7Ve2JoRFgYJwvQeY?=
 =?us-ascii?Q?F+ifv4v1Y+nt09kmYDu6nSI2kHOC1NOltyaxADRRv2MzpNLqlyU7dHimZCzR?=
 =?us-ascii?Q?Mzyj76cnlSkmrYXfo2PvcbdXrIkQLfIicNaheDmHBcEGiQ5ZN/xAX138ksfV?=
 =?us-ascii?Q?RBpkTc7vsBGaQhcS8ZeNMwJjtIAo+jjp2OcXp/0+3nACGEGTZ516qTJqQsXg?=
 =?us-ascii?Q?fjcdZ8Kcv+SMFTWL2E5iLNNpJGHTXUB0kOAWlxFPFz+d9SGG36JyQMEK+NHC?=
 =?us-ascii?Q?7kyo2V8QlCvo0QkyQxba82LebCN/TQx7KovYDI3Y7d3p7nOdUtdXptHxk2Sw?=
 =?us-ascii?Q?kDqVurYmHVSa0sGvFDy2cialZuDx5JZKwsluGERPJQr+y+sZMKRWzBoknA9Y?=
 =?us-ascii?Q?itwbKZILc2sp4Gdps9I0XlfrPaadguwPkasJLeZvzyaZFUzmlWsln5G5KYBb?=
 =?us-ascii?Q?CN/Shqc9nqdBEH9BXEffeI9vBboKPm0N1GJ6kR59gtt9muBWGO5P8kWKvlPz?=
 =?us-ascii?Q?jrJVi9sNd7JC9qXivBSSHFsyO6QpwZpQuot9ZT+Lot5hxLVqZWYB+ADv/eES?=
 =?us-ascii?Q?I0CZ+mGrmzT4atUlaugljFhhdiAtUkCPo2okh6Ppk4R/BeRZ/3nD0ebZ3MWV?=
 =?us-ascii?Q?xXhCDQoOT1zPEjX/pOWKx9ygJPYxsibCRC+YTPUcXRLHrEQ1XvnKK8YZDlJv?=
 =?us-ascii?Q?wzRq2j0GGPNhkuIU08c/uyNZuCfqdAcHdCilPtnnedmy85ytYSu+j6Lenqml?=
 =?us-ascii?Q?gHBsCP5d1IREL6ePp+ONmTettDrV/cy6wFMCc/REquZl/csBkJm+sRrI1lyX?=
 =?us-ascii?Q?WqvufNfJwbQEPalM3rtt3annzECsLhQIc2zMCkZarNE94Lv/IpfqwtTjKmg3?=
 =?us-ascii?Q?02SB5VJDVF1+IumPP9+Wx18OgNA0Sjs6XvTBtaj7/6S/Tt0gXILn79HI6/Tn?=
 =?us-ascii?Q?a3mv/DRfdEBm3e9vNSyhwU/JXMhJyjWRuJ8y1I5bVCMEFvWNu8clgZb8VASv?=
 =?us-ascii?Q?Clupz/JG/mTbumU2J+a6AelRoJN8fyYh+EUvGMYeii8DOxZqFyFx8bduQuwD?=
 =?us-ascii?Q?517Mtm7UEb86X4uYS18fg1uffJFp6phu1LYwNB6vZQ9jdWTyINw3ProvWOgB?=
 =?us-ascii?Q?8p5V29JUV0g/bNJhqiVOUd8mTEEVf99s1l1UsI5r0gl9Alaw1b5o/qK2vf4D?=
 =?us-ascii?Q?Q4XR74y9CxU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?37rgzFArgdaqB7kdigQ8AgbBb29xz/QScfGhd/cO1dLCBWmtmofAkhO7WnIe?=
 =?us-ascii?Q?TUv94Cra6wiCWlG9tDyHHOTe7T5S247yUVNqndbJZ02kfGdx6DbkC78xeaHa?=
 =?us-ascii?Q?EtNz2/WRtfz+Ke6y+uJ3Z0+RESRKq+/9X0V1xq+ZPR5m0clTxo4UURV2BuU9?=
 =?us-ascii?Q?wNrx3NuH2F/GfIV7TqJRMXJxlJTWX4UZtAMZOhefLa6qtNZYE0tQeUeCUYrW?=
 =?us-ascii?Q?bm+BS4eLZFYmh7Qqug8evKaXdoL0+1CKeOT4MVGuwuY7GN2Odlse+9DMfxDe?=
 =?us-ascii?Q?znn5IRhqPu0kIEvE3ThCWz3t1vY7JqBppVEGpVB+g/AxLDiUqpDzOC0plTbv?=
 =?us-ascii?Q?4HdeE/MpgzNsjb9+/h0mJJxjp19V53eBgcgUlVJ11xIxJVROiVAi8zs9KCtI?=
 =?us-ascii?Q?lO5fY7hk9Lm/5D9OQHpO0dFZBuyCq5E3FxbHWIaEpqhttHX8vBo+vibRHnbC?=
 =?us-ascii?Q?nkShpCDzeeflJfUSWEpKVd/dYJ33XrQ11RbRK9qLeGkIr466nvx8zuynCS81?=
 =?us-ascii?Q?Mmi0JgB3EaSC7EFVdJmy5/Wa1aWJFZbUiZ/2ylTPwfLrqckcIa55L7M51yDb?=
 =?us-ascii?Q?H3iDBXqRNcOS5/MDvTzXblVQ/80bH0uv1YSqBuBTT1oGQazexEimsmfD6Nwq?=
 =?us-ascii?Q?YSO7seJy2+w2tfdK80RUX2LxdW45pIoDyBj3lzci6A8XfYaWF9eiwX2lIrWB?=
 =?us-ascii?Q?dpJsRQ1JEWS8/JeIZeR+O+UY5npQldF/LwY/wifMOLEy/G54QWRNkvLOwUDK?=
 =?us-ascii?Q?aefwnjDcsnHx/A6CcXQl4d7a+zlycgc4b6SKryNtztH82Yn+0WMlhHkmC+Co?=
 =?us-ascii?Q?/nCupZWg10qUnFqdBw8IIDKkNtqvGk5eGRcCKrhuc/lTGOp82l6JXSV10V1j?=
 =?us-ascii?Q?Ce1hDbH0WINYLQM5cI3tIZRbQLueiom3+sC7sWaKTUBeBWnh0+RD/tgpAldE?=
 =?us-ascii?Q?WImIaXsMppFuZtyWt018KsspbnoB7c51DpzP42n6PvB4WnCs4G0Ud3i08NB2?=
 =?us-ascii?Q?xL3HuYI1UVoQEQ/64Hncqjx6Rp10G/UPUfwIAnqULEmitgOWbMtDTyKbhA+d?=
 =?us-ascii?Q?CayG0VixUPc9+GHScg4/vz29mzvkOu868GzhSATgfFSWjJnecP78WrBGZBFR?=
 =?us-ascii?Q?viNxYM0lKwWDX4dCY0RbEVJFlWFqlYMz60CyL7W+lwi/BkPi228p95mGyW9y?=
 =?us-ascii?Q?qt5PDtnuWfGXqn3HqbfOeAvFu5LXCSckUK7adcZnAuVihcVAajx2wRS+QtPS?=
 =?us-ascii?Q?G210PF1PFDU9FdCYi+7v2aJP954tVMms0WpLF8i58U0MD/Tcu54IGBpFV9V6?=
 =?us-ascii?Q?wuoTfHa4M9hvMCTyTSr49u//KAq5MQmM8IhysRYjQVWo5cZ3munk4+o3ulCt?=
 =?us-ascii?Q?c7I0ZkkyAYCUS0qN3wObb5omzZCms+sR6rIy4gjUE0oJ7IfYzwMwIRJRBljE?=
 =?us-ascii?Q?eNJuG9xPCe19004WQBgxNKHiSSDJ68TwF5WonwXociBKCSmtD/5JYpj0DlYb?=
 =?us-ascii?Q?WZtE/sG0PSudR3z3TCeKBXMLtWtheHa8qVlq/KhmxHb2tjW8fT/ndiVztF6q?=
 =?us-ascii?Q?JiLffgzLkO/PdKSPrEs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 349ad7d7-d1f0-46ef-4035-08ddec80f48d
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 13:34:36.1975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fGMe99Sg03eU/6cr8vFrT0m4GIAcATKyY+R4PFw5ajn0RyiXFwyITgYUvmm824Xs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8871

On Thu, Sep 04, 2025 at 04:08:22AM +0000, ankita@nvidia.com wrote:
> +static struct chardev *
> +setup_egm_chardev(struct nvgrace_egm_dev *egm_dev)
> +{
> +	struct chardev *egm_chardev;
> +	int ret;
> +
> +	egm_chardev = kvzalloc(sizeof(*egm_chardev), GFP_KERNEL);
> +	if (!egm_chardev)
> +		goto create_err;
> +
> +	device_initialize(&egm_chardev->device);
> +
> +	/*
> +	 * Use the proximity domain number as the device minor
> +	 * number. So the EGM corresponding to node X would be
> +	 * /dev/egmX.
> +	 */
> +	egm_chardev->device.devt = MKDEV(MAJOR(dev), egm_dev->egmpxm);
> +	egm_chardev->device.class = class;
> +	egm_chardev->device.release = egm_chardev_release;
> +	egm_chardev->device.parent = &egm_dev->aux_dev.dev;
> +	cdev_init(&egm_chardev->cdev, &file_ops);
> +	egm_chardev->cdev.owner = THIS_MODULE;
> +
> +	ret = dev_set_name(&egm_chardev->device, "egm%lld", egm_dev->egmpxm);
> +	if (ret)
> +		goto error_exit;
> +
> +	ret = cdev_device_add(&egm_chardev->cdev, &egm_chardev->device);
> +	if (ret)
> +		goto error_exit;
> +
> +	return egm_chardev;
> +
> +error_exit:
> +	kvfree(egm_chardev);

After calling init you have to use put_device not kvfree.

Why kvalloc anyhow? Struct chardev is not big

>  static void egm_driver_remove(struct auxiliary_device *aux_dev)
>  {
> +	struct nvgrace_egm_dev *egm_dev =
> +		container_of(aux_dev, struct nvgrace_egm_dev, aux_dev);
> +	struct chardev *egm_chardev = xa_erase(&egm_chardevs, egm_dev->egmpxm);
> +
> +	if (!egm_chardev)
> +		return;
> +
> +	del_egm_chardev(egm_chardev);
>  }

This proceeds even if files are left open which is not going to be any
good..

Jason

