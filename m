Return-Path: <kvm+bounces-51314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8193AAF5DF1
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 18:02:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83AB95236AA
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 16:01:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C9302D46BE;
	Wed,  2 Jul 2025 16:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HzOseMR6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2060.outbound.protection.outlook.com [40.107.243.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692E22F363F
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 16:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751472039; cv=fail; b=oxwwX0SJ/Yx6r151Re2noZs1bfvSz7ILFOMwVpMXnDhGUzD7QbbZhUzdiZ4xkzA08vzW9Mbp0AntbXjT7/UiQOalJhz+vipg1J/axNYWN0hctl1f1J6dnDL2XWQUiiCYy3FexN1gjYnCQNkSuyVKGSpH9aK7Sww5LOFNzRaXLo0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751472039; c=relaxed/simple;
	bh=ZbL+2+pE9ZVBCE/DndW3rZ3Y3JzVgf6B4hnvaf+wRQo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lBl3EHkkM9bfaVmvk7FolEOstCy6Y7l9JyuVhNl6X7eeoF94h3DJRvsHhAaGxyqiObr243+KfPqXSTmMDbIngK56VKdiks+yJg5KorCeUDKeEjDVPTPvroDtDXLg0RN+LYEZbext/ZjgPqMd0eYjDJA7mKJUlWmZrnJa07z7tec=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HzOseMR6; arc=fail smtp.client-ip=40.107.243.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iNwykeqW1zGnZcvj/PP+p8/xeSeDtDAj91l5RWyUi85OdDnNqeFHpQ/EWKZAlFZYQf43esPJOSopIGWgWwlGEsuZj44OEp+KfUY9u102DS+Xz//gY34U9wvjXYmdOEuv6BIZcHlZJ49Iu0aNWFeJEl7yBGGAaVoJSrHBYBgv35B3Z/VIiw8hLLJTY9WcOm+FaUNnRmOf6sSvdz3fn/IAfiiJaIDqIGULp4eFqJ1qwHKT231FINbTPjcW8QwmgLaRTRrsONA8NQR4xhl7wsk0vdxoydHFq/JnNzE/b58TuvljDZazAAosggGgscpjIoQZc4jNAwIiVGSz+gvgXYlMfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iL2HHwt+Gz5+Vn1iSGK+Uf30zGd2DS9eGR8mbvjl6Pk=;
 b=JcuEAImGzZqUkn9j9H9at9Sw5ox28S3A4fX6FfyVNxNiw062U7pEf1/6Yi8rjKaHFtPlkVMZp5n8Zq4CFIBfa+v8Q5shoBVZb1JHTimza0Gj9pUMDqKrbjuTI7zyWytr3tgkg0cHgtnqUTsyyEPzIK0cWw52xJ4OqmBRrxf36CzhO6Jj5rSafnuwlfO/h76v6kxwsGHTUfhFMhG5gyQqqYtBHsYHB8PEgjRkHMuSOzz4tvlCqeY0iRQEGRHEt0hdSpcjxctHWY3ONXgc9SFGSb8G5Owq6KHzv+t67J2VuXxSaJ+5kREi8Iu/t9EIu326u3eeYZRcpLoxn/3QzKFabQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iL2HHwt+Gz5+Vn1iSGK+Uf30zGd2DS9eGR8mbvjl6Pk=;
 b=HzOseMR6G/8HtO09WUSvMNstwK9FLQq71R9cfixApGNOTE9gUexrR2op1qCGKlq11kGveQn27Urpe5E+w5GUZSPBFNv45jjkdhFnOsoHQFgiIKHLuRq7qkdmTs2Hhx4O8emM1DJHJwzc5hfHnQ3RTDbRcPMP62EG/76e71S3sw/8ar1b5wIZKsy0FEZcu8d5fQJwv5Tn0NvZl7cBEKgmcIdmhwqCCYDqsVnEjCOwWpOKSnVwFL56elTXAVrhDN2CJa8UmNMwTl3PStA5VxYGApQTnNF6uHQvmn6Bvog1fz7uml/vlpCVd/7moqGpMnSvGmsJBFzrreOakLo8Zw/jhw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by LV8PR12MB9336.namprd12.prod.outlook.com (2603:10b6:408:208::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Wed, 2 Jul
 2025 16:00:34 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Wed, 2 Jul 2025
 16:00:34 +0000
Date: Wed, 2 Jul 2025 13:00:31 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, aaronlewis@google.com, bhelgaas@google.com,
	dmatlack@google.com, vipinsh@google.com, seanjc@google.com,
	jrhilke@google.com, kevin.tian@intel.com
Subject: Re: [PATCH] vfio/pci: Separate SR-IOV VF dev_set
Message-ID: <20250702160031.GB1139770@nvidia.com>
References: <20250626225623.1180952-1-alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250626225623.1180952-1-alex.williamson@redhat.com>
X-ClientProxiedBy: SN7PR04CA0208.namprd04.prod.outlook.com
 (2603:10b6:806:126::33) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|LV8PR12MB9336:EE_
X-MS-Office365-Filtering-Correlation-Id: b6dd0660-857f-4fb2-7e26-08ddb9819395
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TcdcdkOTXRJ2hmKKhwTzJsqtgxWAYQFKhD3xLxTiLjauFCQM9GsUHTfrmfMC?=
 =?us-ascii?Q?e3GNIelfjCZ6D2BkjWxcAhZ9nXz25avKRgWlD/dD8zniBm4NRHWbCNfwzsn2?=
 =?us-ascii?Q?4TGpbc0ZYBieAGFSQVwC0+aKZpTPKVkp2d7+evz3gnQnil5l0FUpY9TXh0J/?=
 =?us-ascii?Q?+BeDSwQEjs124/qXrOTrWywCtXbfx3/dbLhhDNScVJoQN7GMO/VSbpJsELtO?=
 =?us-ascii?Q?sCkmItuUOLULu8Khp4i+zELbSQya1Cz/mUTsdTyswvggU+Y5BbTMjHEV62ok?=
 =?us-ascii?Q?oRo5keXDYKdyAfiidkPKieWJ2/hF/QoR6E2pLnZVXIeJ6mxr06DLQlpFo4Zz?=
 =?us-ascii?Q?S8yYOaVtpiAJjqWQ/pMIJCYN0E9BYKk3qCZzoMmji9Uf8cVyI/aNVm3lluEZ?=
 =?us-ascii?Q?Raa1BPq0/v7teL1uSi7CHCwcPIU+bXkg3sGfaU4IQ64zxR6ef6/FMrhXn1Ot?=
 =?us-ascii?Q?aKD1iUWN4nSGqhqh+/8FqyefAbtJQRNJ5xbzUMNqSBVAQJc0kM8XZv449iER?=
 =?us-ascii?Q?t4wRG4iJOXSpPw4chFXREORXlug99NIjhlCnvqeF4BfxdsZsQMDvCMZJeMxT?=
 =?us-ascii?Q?YuIL3WWWGRYRN4Wng4BtWoB+cWLpX5PuHR0w+y1EDfy7jBAcWhnaD/OISsof?=
 =?us-ascii?Q?Hx1H7JmA7w+7ShnTISRtqwoJRgrkYLXjpRGCRGBWa1xjIcmj1Ob6UvIVBlaP?=
 =?us-ascii?Q?yHLdmnldamht5tL3W153YPudOt80+HwQsIvlma8xKLYiPHbEhWG/hvFaJsP0?=
 =?us-ascii?Q?Wg6ezp+iO9F3ZVtjGr3FV+0Xi/9q/id/i1KxBh6VGKLDvM/YVMuw3ljR5Zlu?=
 =?us-ascii?Q?FDvNI0msQRi1QX6HuxCO09RrPvfrcmCjvaKVjTFX+lhSooAgE9Kix/7Tm4Oc?=
 =?us-ascii?Q?2A5/61QbnRr+LVMZsm75tbFD0a8YyjOCk3BRhP+gcsO6s/VRnU3Q3EGe9oHK?=
 =?us-ascii?Q?6E8Kk+c+W+AGF2H8PAoUdynaB8rGZfeF2UXpLcymaucaeh/rxC5IRgvG1E7S?=
 =?us-ascii?Q?eEfNyQFrGFrJQ96uCni86gZucjghm65HfAbOESL5F7BoPA+bngJjShzEqVIx?=
 =?us-ascii?Q?z6iRemYIKeb0yLVFfzOe1RV5zeYqXramDd5DjSvp3Yp0rviqE3H+Uy+MwX70?=
 =?us-ascii?Q?34te19xZJf+KdwJI6qp8dW0cgIKalaUpsKGANBY5r6a56wKJpOgkf5kdh7Cw?=
 =?us-ascii?Q?Qqp9zn43Tw+pZxqHwaLe04oJ9n/ZqzH9HZ2JnMlIytmHhr3e2UNEl7QONHwV?=
 =?us-ascii?Q?el1HqZS8828eAZfmgoGEOHYJWyGc4OKo4grpk9gbSuYKzqJsCIPDVwDzmIDX?=
 =?us-ascii?Q?LUIlrNAmFtn2YHqbQY9RVwUFnTdKYVISn4yOrEBuEX3kSBmA+8xIMSyzzhDD?=
 =?us-ascii?Q?JfAdUP1Rl3jgIe/2Xrf7nLZ0APnZyJDzDOPEnjtxvS2Ha7jU6KP8yHZdQZLg?=
 =?us-ascii?Q?MrBaa5kT4kI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CmbNn+sravQZwG7UW0Vulmbp4YepCp98BsB2dPKe6PvQTKvPAx7xds3pp55I?=
 =?us-ascii?Q?pxoo3qUpOBJ3ASh/EJURUoKLIusV/IZ5Fi8EpGugTjzI5Fn6VjrUilGtiaAe?=
 =?us-ascii?Q?NiBffLcAIrBhtp+gL+QwM3j1FzbUjEUk09HG+BiTGiip0u9jXhGGJcf3Q0mS?=
 =?us-ascii?Q?NdDY4xIMPWGOs6eC907sHF1zAVpo/p75XQuKXoyUdbB8xEHmQlWBPc0kvemm?=
 =?us-ascii?Q?4x5BKiLT9D+VPugPYTsc+aXgafi/i9zQ1cDvnDojliI5Kl33qsI7CDlgtM9E?=
 =?us-ascii?Q?D+8edwZBLy/KBbXqmw7TVcBy9ymCvgZqxUAm4VeIwMz+rSF44Ghto0bHZBBU?=
 =?us-ascii?Q?ufPapq2FpsyxGDmt6hU1S9aOuSUB5Ds3/ap2z2lhVYHHmi+6zX8iqGh8Qout?=
 =?us-ascii?Q?lPNjdsVRjMMZBs17/t9EfccNDztRZwuAbU+vj/P0l3+SNkyn+gnPug4pEduG?=
 =?us-ascii?Q?Ux0B0maOFSaNqqjbmsbBKc9ryzd/+1sd9ll4ke9ebkqwumcrMBNhNka7G8cS?=
 =?us-ascii?Q?EEa5JipCCNF4scrWZjmoCd3BJEa6dYG+9cYxVY4M4d8Zi/NcW3wNc1fWJmyj?=
 =?us-ascii?Q?Kq8sW+IulcnLggt3XTW9Bw5CPHdvCDCf07KQlcmWoLhSGtFskyzYKmYgVv9v?=
 =?us-ascii?Q?FvagsvvBZCHPEAqA0jnv2e9hFGxu/Hpk7he2gJNtHHGFI/j/fElquH9zn2zi?=
 =?us-ascii?Q?jvokzaa+Vid2brgrXBuy/XAZTkAjYuQKCn4oWJ9qfi0vGWbqk0YPMEzJRV8s?=
 =?us-ascii?Q?AKiwqG+2ZxG0AJP8eqNfFfD8voXrqKJE2n4v6pwDacBjQ3k3lYBBSSllMGSL?=
 =?us-ascii?Q?15uZIHqkcW0g/MgbpMAPU2+3rMtStL9Mji5E1gY2IOOdzjLubjxfkeTfFy+D?=
 =?us-ascii?Q?P/JiJ5AgeKLiBerVLWgF0ZMAjP982Q2zsKLT6e7YBOarhgvWviDaufzsW0CF?=
 =?us-ascii?Q?dqdTSRTgp8MhrtT8MHb2zI8OnwsZDL5qiQSCUAy93jMOUHUYx+6IN6uuWmlJ?=
 =?us-ascii?Q?X7LsyiUsxHvgosIAWwNeH5bajhtH13gqWUAIV8QzKXXKjjbyFC+s1qvTMU8f?=
 =?us-ascii?Q?msL9qLi4VwnEanARJzQmNUAECBqqs2KWhe25pi0DVm1SFwRC8wWne//13FfV?=
 =?us-ascii?Q?a7SKkULEnL20W5f7QY/PW5Mj+aMhr0hYUNLG2THLRBJ4R3SN4D2hJK7d3pOq?=
 =?us-ascii?Q?9F31eZeOcT6M3xiFKW70bfSnKYDxb1aKR4MXlfTsNSBUjLRi55By35DLMUiZ?=
 =?us-ascii?Q?DRrY3rQy3Fyat+hs6ptqj62rt4IJzxAwMRqBIUA9IeVrss9lY5IGw/xjONrd?=
 =?us-ascii?Q?aTuBxiKpGAtbdtX9zbS9A1sYjbMcPOAF/Yu08gIwgyHi5KJN9XOjvZzyLO5b?=
 =?us-ascii?Q?4iY9FKcrbUC8oTuH8Uvv/ZmaawYkABOyCDL7sxRvVQu53NCx1I+jug3Dnc2D?=
 =?us-ascii?Q?ZqBEnzBgimlSePGiC9va/hx7inRlsAENMcYwOPR74KoydTXJIkSOHDqlT1R1?=
 =?us-ascii?Q?yjiRAkjrFodPaVht5zqwGUuhjPnPy48ekcRP0Ish3q+MgMce5nA7x0gA/6de?=
 =?us-ascii?Q?Hs1kNcU85y16M24G8dMYuNudYi2VWjcvUlaXHh/x?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6dd0660-857f-4fb2-7e26-08ddb9819395
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2025 16:00:34.0094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RwBbq9FIbvLDy9UC5B2RWPnJVgKZmxVeAImMzVswZmYpRh/MIkYFG1kaoEDhhYvH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9336

On Thu, Jun 26, 2025 at 04:56:18PM -0600, Alex Williamson wrote:
> @@ -2149,7 +2149,7 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
>  		return -EBUSY;
>  	}
>  
> -	if (pci_is_root_bus(pdev->bus)) {
> +	if (pci_is_root_bus(pdev->bus) || pdev->is_virtfn) {
>  		ret = vfio_assign_device_set(&vdev->vdev, vdev);
>  	} else if (!pci_probe_reset_slot(pdev->slot)) {
>  		ret = vfio_assign_device_set(&vdev->vdev, pdev->slot);

What about the logic in vfio_pci_dev_set_resettable()?

I guess in most cases vfio_pci_dev_set_resettable() == NULL already
for VFs since it would be rare that the PFs and VFs are all under
VFIO.

But it could happen and this would permanently block hot reset? Maybe
just mention it in the commit?

I guess the commit message is also trying to say that we don't use
VFIO_DEVICE_PCI_HOT_RESET if VFs are present on either the VF or
PF - and this change will block that.

All VF resets should go through VFIO_DEVICE_RESETF. If you want to
slot/bus reset the PF then you have to disable SRIOV first.

?

Jason

