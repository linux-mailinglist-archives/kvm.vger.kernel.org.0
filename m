Return-Path: <kvm+bounces-9992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 530F6868172
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 20:50:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08B2828BDFE
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 19:50:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10AF7130ADF;
	Mon, 26 Feb 2024 19:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YTydaQDo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2058.outbound.protection.outlook.com [40.107.243.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7614612EBF1;
	Mon, 26 Feb 2024 19:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708976999; cv=fail; b=e5gOzkJPftAc6q4PB5fj62veY9oK6d88N/hEcEUROWXn4Aum4PfXn+UjwxDrsJaiCf4RkX6wHbo3HsVmylc9mpDR33VVU8SfhSUGzOj3orz7Y3UFWSQLSSQI5YseV+iLdRnnhy356/tTahPVZ2y7FMw1mNcTAjpOEUV8MswCLHo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708976999; c=relaxed/simple;
	bh=qVvj1AmAiMhrmjHIX6V3U4+EaTurjYNjwNYephV7LX8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HxcmXPf0nbDurquzSaCzVXfD4x9TgsAfsjEuICy7y3rzb610zOURWVRf4jct+GNyX3aZISu4MzoFu4FeGQ4N5N+/l5kqtBTYC+1RXh3VVDfQYQTAX2fLIHjdlzsZHz7w9Vkcukaz0bitozBMWC5TdFfc1R+ZpBm8zB5R8Kb3EV4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YTydaQDo; arc=fail smtp.client-ip=40.107.243.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NhvBORg4fC+P1NPmJyG+0K5Lw68Jsw6yPUx571P0fTzNHqlUQAN+B8znCV/AkO1YBvm1wIE5Q7ZBzbTubkndCIDpQyyiEBSOcutoIylJgW1y0Sry2joUFlLnfk/CaGXjSphY1/4IX55cV6j7FFTiUsFIVou8k93DRdWdQuTMt1WJYrb9kj6h3GXnD5ORLb8uFTye7TpoNpCfcbzYa0CDj9s077NpnBzQ65EZErAvdA484EJsEv5wD0V2+bYEFv3lr16qpPPCvZyDYXK88/yCyDhe9QU+NFkpcZIlT6xPqruBEPjbZ4fzkBfe22ChwkRFW6O7pyftB5Kxz5cAmCbhSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cYcDA9MTEZXqc7dnNsFqpLpz33Z+wJ9kCw41IhdiBe0=;
 b=DHjKq8KgaKuTdVdQs7GSUgFf/mircvg6GrORdBX3NBzNmX7JhOg+7SX0p+KtddNJoR7RgR9/HnWjP+8ya3tZXzQ0klEozYu/AS6z20pTjpKJFmzXGqQ+McyshWO3j+LT2NBsTTA9K/ZSAPzRgYm0ZJedZ63IQsv/BJ0T0IhF2seVOuBn/SR0BGLjblgMTs0eEffIQEB+r8jpO2k4icPNIutExvSMQ1xmfAaQGuV4HAoxihoosYHB+bqYX4dpZ0p8AG25OZU0B51qgzotpujcbPfkRSBxxCQlZTv1NWp6NlNt0F/kEsQk0It9ILCp+WH5rJMDctU++aA2BayitrxHYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cYcDA9MTEZXqc7dnNsFqpLpz33Z+wJ9kCw41IhdiBe0=;
 b=YTydaQDo0+2CgRPToioSZgar8HkA0XLPlPTizzrdnVibQyrTrhgJUj5r1N/LkTBwnvC+8WX35FsmYq9+7v99Gvu1y6i0borWlmFbajJ8BPFGYcCgnWp7zTowd7MViN28zTmVK35QTM1E3RJ4zScPKONgh/Iv0w8lzRv+Vu7ZdylK8HrnRroaZalBFFv4RZBHpLnSS7iM+P9xA8saaqqYWjD/41IU0vB/6GQUIF7JPfTl083CmyDJ2ZthaGgr8fpEAXEMmSF4KF/aJUs1S+/WIHUOnuiG+XlAahCCiPhSBJQK6Gh4KKpAyhEFOxlO2bl6st5RLZvK4Qtnci0QiXlRVw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DM4PR12MB7526.namprd12.prod.outlook.com (2603:10b6:8:112::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.33; Mon, 26 Feb
 2024 19:49:54 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941%6]) with mapi id 15.20.7316.034; Mon, 26 Feb 2024
 19:49:54 +0000
Date: Mon, 26 Feb 2024 15:49:52 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Xin Zeng <xin.zeng@intel.com>, herbert@gondor.apana.org.au,
	yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com, linux-crypto@vger.kernel.org,
	kvm@vger.kernel.org, qat-linux@intel.com,
	Yahui Cao <yahui.cao@intel.com>
Subject: Re: [PATCH v3 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Message-ID: <20240226194952.GO13330@nvidia.com>
References: <20240221155008.960369-1-xin.zeng@intel.com>
 <20240221155008.960369-11-xin.zeng@intel.com>
 <20240226115556.3f494157.alex.williamson@redhat.com>
 <20240226191220.GM13330@nvidia.com>
 <20240226124107.4317b3c3.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226124107.4317b3c3.alex.williamson@redhat.com>
X-ClientProxiedBy: DS7PR03CA0077.namprd03.prod.outlook.com
 (2603:10b6:5:3bb::22) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DM4PR12MB7526:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ec1ab55-0ed5-4c40-a55e-08dc37041a61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	1hY/qD/435Fp7ebhDCqMs9EMQvJeJ62hKmpsMyc5WD1QbCoU6kLLLojH5I48UW/EjVNeAjqMaH9AJZIKOqBgPbRTBTvuLu0Pjgh4szkTwR4d05S7O8b3t3pTFFoegFXhIn09eEC5QWpvUE17sszzeaKt+2MtAdRKQnn+6Fmr+DZ3DCC6irAp27o5lSnXopz+9ItFXKFOcj3lkoxx7e3blw2o5DcCl58+sqsHBfaY4oY0HXG8UOvlW5chPiPdpR7x0WPlgzVPAM9MlHeNQm/mnRuHjNNF1I1iOpA/wDyFSXow4EH1g7MOS5sTRw5dn3P7XE4LOr8pIT7MBmNfDQI8zy1oLYIxZPZTGxDGY8Tn9KBagoPtmqvmfzcFaU/OCONnBkygt6I0hvFFWm152k5CElhKY/tjbPkOoUxGjb4T23j73odARgeQfaKG0o2f20oFpI0xAMS9+s2xlTaqBOgiP1Pg20B/UhOUQxnN2EwL1eZw6imAkt4r2o+FeRSpn4jiOQ69jrKHxkPW3ZrftdlxvrsM89LKWKBhQYyZKt7RU8DrjTMdziBe+OEHrJOOkPFQnhToVwOs+QR2OpBTj8098uYVBfj+ZtVKQ5rVZmc2BMxioxITBXefa/gfQjMXutscJrifZsOCxn560sI4V8hULA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6LuH/ufHdjffC+o7A8jgAsT+pFNAg5+6zUs35XtSr2CPp2c3pngdCpXb79U7?=
 =?us-ascii?Q?JMTU9TOlMhl9+pSzhQTWz0N0zwdQAkQchgCf3DzqxLloOktKZgGpC5U2wNk1?=
 =?us-ascii?Q?nW36OziHXh50pn+QXjh0gDyQKl2sW9RwGZezmoIWIq5mIDIebzDRDRpFi+Fo?=
 =?us-ascii?Q?BsuR1Hl76Sjq5F7XfgC0uV/938ENG7K57A7TKGbuzYK816jGJJy6Xcu37MiY?=
 =?us-ascii?Q?HJNlnBO0kCIMAf+RQDc2D0djxo4FPd3Xh4MZ+qh+r7fErtD5BIRCORl+wG/U?=
 =?us-ascii?Q?7msineP+tiEojjChbSGrcQvRldxlKz9uUeflW5VtWRyQfJRnhFwAQ59dx14c?=
 =?us-ascii?Q?QSCJ0hNSzrCZLRGXJ7wqa1hsy+STy7SVAC9se7WIVqebHKnCtZTmIPMZXq7p?=
 =?us-ascii?Q?LatHyxQxZrc5pFTqDgXSnjAoj9VzETqtPWY1PCCZt23/vanpaW50mVhhWS66?=
 =?us-ascii?Q?uNpmMlC4tLsFxnIDcFE8tNUMUR+1hIjzyHZVfcPKycipRk8ALiM6V3cvBXh2?=
 =?us-ascii?Q?pDSkp50fQwuoNgMkTHW2htPSpLDcfC5fwSGc6Nzn/3NULwA/DpKaCPQY4Pp2?=
 =?us-ascii?Q?2q4Dkrb+IYeXwVbzq4YHDknab8EV5jUTm1yqO6/3VCGqfIhHblbD6lH+TGmL?=
 =?us-ascii?Q?o1HSu/ZoAeqZLDtIqOYBnhwvUVI+9W0l+VlrQzHueg5Tyvq8JWqyFRKW9dm1?=
 =?us-ascii?Q?KkTWCrI5BJDyVbejOpEx7f4II2TINPd1ls5lIgdSKSlsKXO5FcHAT02isoQq?=
 =?us-ascii?Q?HYH5fg7TI3scwGOSeZEFq+R3JeQ8ky3ECf0J3Mfk9PGMIE70mWoXJwnpdYS2?=
 =?us-ascii?Q?MibHD2Z/WPtLPCRlRb/SfJHsJHRme9Ap3gOD21DNLfegvJFwxy/jpsYqItHJ?=
 =?us-ascii?Q?zgtivdx3OMgS+HmSkaFs4/Ezh5o1VNIexCldlcUI3GJk7DKFnaSzMnfdZfuS?=
 =?us-ascii?Q?z+WsS5FEfjmBpXpUocCL7b52owrx3Nw8gu8RcUxzWXbNTOe9TlLWgAWxalYK?=
 =?us-ascii?Q?CAkn7uiXLJzc/Kvpq0XCzfEyQw9Vxn8sVXRmzT2iISUz7YfF3MhqUPe8iI+C?=
 =?us-ascii?Q?ZjrO4/lMcZiNsvT2VEDj76utBn8BFjTbQrj+coLt+zns1oBgSZwOL25wq6Xw?=
 =?us-ascii?Q?H5im1CJk6n2NzsAvIXd/a2tSTazTXASUf4kPGRYHR2Xr9m/3qfx8EftgO96X?=
 =?us-ascii?Q?EM6T4EVd/5ETyid6H67ZUFAmoSo8SbTtL6pyNJIyM/jmj+FqlZLCob2+ndHj?=
 =?us-ascii?Q?EIJjyljCg8qF+7dleUTqD+8/u/dKb0F9GKBkQT8noiMt/H02yr+IOqIhCT7I?=
 =?us-ascii?Q?ghYmRGfLhOni6303qKZzF9gdTtxaMIkBhPe9HqXrj8O9okPJ0IIm/0q6rCrT?=
 =?us-ascii?Q?OJamWNT6LN1RHHfqMImTd8xdSAKhFvab0djDASNrYHdxDuCwZBNOyJpQW+BK?=
 =?us-ascii?Q?0FRMghF8u0Qs2qGBDQy9yYi5blTEtzTpx6TPDdBtCuZJA0TW+aKrbAwBPDeH?=
 =?us-ascii?Q?SfyCfLf6E9Xe7EOZHbBNE4vbmnlMaLTUqrZLZnr/h8yxzpN9gdAu352+H2kC?=
 =?us-ascii?Q?3I5/nK8kEqyROE6X+xD0MuEWPqu2hHywk6HLFTsk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ec1ab55-0ed5-4c40-a55e-08dc37041a61
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 19:49:54.2887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dzKFo+2VEt4I5K5rPp7vMZUyrEe3nrbcro6f071AKC2N2cDfuMu9dTLL1Hr2KQIF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7526

On Mon, Feb 26, 2024 at 12:41:07PM -0700, Alex Williamson wrote:
> On Mon, 26 Feb 2024 15:12:20 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Mon, Feb 26, 2024 at 11:55:56AM -0700, Alex Williamson wrote:
> > > This will be the first intel vfio-pci variant driver, I don't think we
> > > need an intel sub-directory just yet.
> > > 
> > > Tangentially, I think an issue we're running into with
> > > PCI_DRIVER_OVERRIDE_DEVICE_VFIO is that we require driver_override to
> > > bind the device and therefore the id_table becomes little more than a
> > > suggestion.  Our QE is already asking, for example, if they should use
> > > mlx5-vfio-pci for all mlx5 compatible devices.  
> > 
> > They don't have to, but it works fine, there is no reason not to.
> 
> But there's also no reason to.  None of the metadata exposed by the
> driver suggests it should be a general purpose vfio-pci stand-in.

I think the intent was to bind it to all the devices in its ID table
automatically for VFIO use and it should always be OK to do that. Not
doing so is a micro optimization.

Userspace binding it to other random things is a Bad Thing.

> > You are worried about someone wrongly loading a mlx5 driver on, say,
> > an Intel device?
> 
> That's sort of where we're headed if we consider it valid to bind a CX5
> to mlx5-vfio-pci just because they have a host driver with a similar
> name in common. 

I hope nobody is doing that, everyone should be using a tool that
checks that ID table.. If we lack a usable tool for that then it that
is the problemm.

> It's essentially a free for all.  I worry about test matrices, user
> confusion, and being on guard for arbitrary devices at every turn in
> variant drivers if our policy is that they should all work
> equivalent to a basic vfio-pci-core implementation for anything.

Today most of the drivers will just NOP themeslves if they can't find
a compatible PF driver, the most likely bug in this path would be a
NULL ptr deref or something in an untested path, or just total failure
to bind.

We could insist that VF drivers are always able to find their PF or
binding fails, that would narrow things considerably.

> libvirt recently implemented support for managed="yes" with variant
> drivers where it will find the best "vfio_pci" driver for a device
> using an algorithm like Max suggested, but in practice it's not clear
> how useful that will be considering devices likes CX7 require
> configuration before binding to the variant driver.  libvirt has no
> hooks to specify or perform configuration at that point.

I don't think this is fully accurate (or at least not what was
intended), the VFIO device can be configured any time up until the VM
mlx5 driver reaches the device startup.

Is something preventing this? Did we accidentally cache the migratable
flag in vfio or something??

> The driverctl script also exists and could maybe consider the
> "vfio-pci" driver name to be a fungible alias for the best matching
> vfio_pci class driver, but I'm not sure if driverctl has a sufficient
> following to make a difference.

I was also thinking about this tool as an alternative instruction to
using libvirt.

Maybe this would ecourage more people to use it if it implemented it?

Jason

