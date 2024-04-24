Return-Path: <kvm+bounces-15809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F33F8B0C3F
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 16:15:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A28121C24059
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 14:15:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C121515ECEA;
	Wed, 24 Apr 2024 14:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nbEQZhUb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2040.outbound.protection.outlook.com [40.107.237.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4959815ECD9
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 14:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713968131; cv=fail; b=Kk6HUcWK+ziErXAS46D7se1OJK+Dmm1+q2nlQ/+9cbuwTn7zKfbogl30fizrLn5Pk30/CHNaomCMzJntDVP38Tnc8F0rNykIIRHScbayyTCU2oA4pWyNYolNNG2YD7a2TmqKEvQtoDnaP1r6C190d1BSNNZfCDwnclR/6JXrWTQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713968131; c=relaxed/simple;
	bh=eXzSSFlzcUl16Bhexv387Hf5oLGKUN/4XA8awSWG8r0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dKRz8iEaXDxZUOf/gaNz5uw5tDptih88g5Nl/aP627cnvctFLl+qGnp6JMhNf53U8FJ5xbde/nggPL3UWa2s4k/68SH0JzTTzAptgtPNSTjohQk5uUnymPvsExBEe9GOUoOapV+7eM/qEvtGscL5oMtJbeikbbXUAlC9fKg3lSw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nbEQZhUb; arc=fail smtp.client-ip=40.107.237.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ekpwNpyNuhKuC87+fwcZMM1q0iHqE0bDwmU54hPgGWJFvCtWKSkCrhW8tLjtjE84J7nQMIsJe9PW1bKCTrHRfhezmww0D8xfGcVQCG3pAdNkFPhfQj19oCFn5r91PmzNfmv33Oaj8BaA0vSYfadNmlE7tULm+IIZGPBc4V+sA5epJCMaNbByXJRaBvzzIKucv5U1qm6cKKu4Sk0HRDhC5wgp0lppKkQNbe+BO+agXbcIQwgeAMKPD8YX5fwN68PpYlctS2rgb9t0ZoEffyp0wm78yXI+oUmRDjQU2dJ3EuoYGpYiy12VZWsMLHo6yLbSteZUu9Y/zT2ivxicwFz/3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6yrUKLzVUGlNCoLu3/XEEdtULFWUTsjqE0A31pRkmxg=;
 b=hHEXsWvWpV6t2h3zHXVF4OjksQqTXh2tz/E4hrKqis6EIdmacmtp+fGEvJNSjYVfdUbs4MPgLtPbUXzXtDAmfxUF2Gv+SyATcU4e/FrULK0co4rmJXxfFYCnebu/kvhgI2GkHl4wXwcjyZaeRtcRPm0gjVtxGJDBgqig9YTtRgUQ9e8FiRtR6iCKDDnOb7oSg2DeUyCcdxIPxFLPCKW9endnHsCxqO431J5tOoSB4c9ewTYaWtisWm+T9MEdHWuHjwByOkGRiQcgXeDq0g+DPvbTFwPDJwwr12xF34Ysx8NZfJh6quYQur7VUtAPqPztdEpjG3MRcIAwKrX58Uliqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6yrUKLzVUGlNCoLu3/XEEdtULFWUTsjqE0A31pRkmxg=;
 b=nbEQZhUb5eQdRRJG+qtJiadSm22wnytLyYbgXf3zcJjf/1gZ9VyXLVpG/pJKw5TUcu5cKRKEESAP1QdVA+Limv/WdWQ9zs+knBFt7dqoCFZJIppOvMlLZTpQ+CeFIE85Sh3Lur3VM5U1F31EHN6NppxHLl5wt4u+WF4mzbV3un+8e/d2J6n7vLV83y8qpZYosce14dgOFHKLGVwzrPCziKD1lVlUmNfa8GnNJCx+jChdhBHSdPwkTiPjHL44cFW3jsMlLseODSf7LbULD9Q9UZ3C145bTNXLYqRDO3buXfAehdwm4Q/2ld4WANVAv7B0ufFTD9EJDCIjPdMTsCLHtg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by LV2PR12MB5872.namprd12.prod.outlook.com (2603:10b6:408:173::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Wed, 24 Apr
 2024 14:15:26 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.021; Wed, 24 Apr 2024
 14:15:26 +0000
Date: Wed, 24 Apr 2024 11:15:25 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	"Liu, Yi L" <yi.l.liu@intel.com>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Message-ID: <20240424141525.GN941030@nvidia.com>
References: <BN9PR11MB52765314C4E965D4CEADA2178C0E2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <4037d5f4-ae6b-4c17-97d8-e0f7812d5a6d@intel.com>
 <20240418143747.28b36750.alex.williamson@redhat.com>
 <BN9PR11MB5276819C9596480DB4C172228C0D2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240419103550.71b6a616.alex.williamson@redhat.com>
 <BN9PR11MB52766862E17DF94F848575248C112@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240423120139.GD194812@nvidia.com>
 <BN9PR11MB5276B3F627368E869ED828558C112@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240424001221.GF941030@nvidia.com>
 <BN9PR11MB5276183377A6D053EFC837FD8C102@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276183377A6D053EFC837FD8C102@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: SN7PR18CA0006.namprd18.prod.outlook.com
 (2603:10b6:806:f3::8) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|LV2PR12MB5872:EE_
X-MS-Office365-Filtering-Correlation-Id: 29b75038-49f8-4123-764d-08dc6468fd2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/aQW5KY1/e04K+6lDXhZY1zWq5+4fV2gaoFmgR6PMvt8HVftwVHQG7hHloFC?=
 =?us-ascii?Q?1z9wC+RuS9S1T7e0Yu3/UsspfJPoSQbOX6NcnesaaxNLI5FJplzLAxfHjD1p?=
 =?us-ascii?Q?zqzGBVPASvilpg6Xt9PcmDf72u1c0TGitr+ZMlmo+FNNJtV3JjPNX807kCdd?=
 =?us-ascii?Q?6ebkXkLsemorpi6/OCgmzWKbjKQ9BPwWKDfRba5MlUhd1AmpiBCIzBe2q71T?=
 =?us-ascii?Q?cVa49kVqwG5IzZDKMZzH+HSMhFmONggCSSq//5AEh7EHe4ccmRjkLL8DX3tJ?=
 =?us-ascii?Q?I6GZtASRjXYIpmSWw4/kH/KcTYJVprvDbts3IQL6Y7uY4MHIX+IF0jTzJLa5?=
 =?us-ascii?Q?rvRDsRgbu6lCBiluieU9+LEppJB0IyW5aqXLVb+RvIAw2mgN9hvCbZsxjr8q?=
 =?us-ascii?Q?ZfPoGTcw1kDo4nctKirCG2cXAC2c6UiewHzN1CRr7DWWvwQ7QGAEUSwxu8HW?=
 =?us-ascii?Q?vq0QuMy8vv6/vDBIHg5IBug0CQsesqtyxqCoLtn7fK/ajSMJeh0Id3ygSJ6n?=
 =?us-ascii?Q?AEIhmW3kjfaAkWMx55OiGoXgjVKSKCaEQBC5TaC/gvTq0FNwTRs/v32/XEVj?=
 =?us-ascii?Q?dICOSkeg5XbpRQ0l6gElWnMDDx51PrlPpV+S0pqlQlLdIg/00RFuNCJROsaq?=
 =?us-ascii?Q?lRehK40sUTrs3xKEI08ylrgGPwscCpNQ0mrMlaBxDPPttkkrJxqEYahPz4Xb?=
 =?us-ascii?Q?wN5hQvBEoBbRNRcb7gUHz2xFhVvfHatPmzrXmJDY+GyCF4zJXcNyN2lyyXxG?=
 =?us-ascii?Q?eMGX9pZ2RIDNyOyiyQHcsiJzE72d4J0Ml7h4AvFD7zeGPYI5tmQeGLLFhZSO?=
 =?us-ascii?Q?JO5KCjpawoXRUFKKpzvBTvv40FyzQupaHyISx1uNdALlfyNigUrdW3NARqMq?=
 =?us-ascii?Q?+bBmH5rGUr2Lir8rV2kpAp+i4zJCXDD67Q/JlrUfHOavy+54Yo6TC2vezUfN?=
 =?us-ascii?Q?/BY6NsYiK7LfickweuYxEIQIkjf7e2z5Oic78HviTxmFTJLWvrk7GMAW30J0?=
 =?us-ascii?Q?Tm+covbuUBEc5q+QFiMqqeo2cQD11SjYY+w3RV1AFzORxEZD/b661J5plwoF?=
 =?us-ascii?Q?l/tQlpMXbr8GDrd1FD9QSVbD9LvkKsFaoHjNyhBHISomE9h2u8zzMYLWMQzN?=
 =?us-ascii?Q?hgDewW1vtBNdpBa+aeHifVYEv0Rec47vW7p4fKjkNVFykS0bPbz486bfuB0k?=
 =?us-ascii?Q?yiBbl5uuHPvKY9ZRWOEbz2orLHJJQ78V3D5ovWeXEuKwY+E/tKrZwlBai6E4?=
 =?us-ascii?Q?xmBHiQrdB3I86rKciyClHI9oWSe60S70VWXDJ79byg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sY1Y2CDYLAy6ekdYnzLi/OSC4ZLTExY9oiTBu50BkLrSbt3ALZiAdam8snVH?=
 =?us-ascii?Q?IeNkat541jQyS+FGHZhmiswHJVS4teyUxE2hzKFmYDQu/B28RPvLrrSDJ9E/?=
 =?us-ascii?Q?ZDjgJZJJ1zPi6li0wlfE+nowB6HwbaZoa1LZUgEO48j+Afp0cz5cF8SCSm4c?=
 =?us-ascii?Q?rFqVMzR1niYvBLmCjvVzuy8SpGf28ExEYbmuDSupCS69Q8XErTf3jy2YcJ8a?=
 =?us-ascii?Q?zVCX6neFyDkuSumkTufgNMxpDUe+95eDwF1yTe4lVBAdMUIFz1gjNGUXmIIZ?=
 =?us-ascii?Q?2lDRkj65ripn6R8bNch2/kISV4nuNAxm3gJ/Npq+cZxfiAUbIxkFMqB65CPM?=
 =?us-ascii?Q?kPGJH2+sMHguuU/rQ/DGD5cOv2O9DUKIUz34o/2eacpl+jhXW/kQbNc1ccrf?=
 =?us-ascii?Q?Gx98pHVnA0ASFxOAnWudrQvpgA7qtF6D4vsHMdUa4xiIe5JWeeCAxe6RmUcm?=
 =?us-ascii?Q?AHkVevmQGSuqEem6F3WbUsjKgKq1wtJgsGCCa4TKXPc0yzdUj7ZlVXe9At66?=
 =?us-ascii?Q?4xjif8wSBk0QqNUPCimPeeZ2pachYM+DZifr+rLNoFCJkTl4fft16txxJ0PN?=
 =?us-ascii?Q?ZgytGGkkzZ/UOvXAgGOYkk2szfoEWquH27zze1ZEdzG4aCg9vPve90Z7R3QX?=
 =?us-ascii?Q?RY3urRF8KcOzNUKV5MsOa/O0NOwlQzVRUtq4a1PWZEdQn88heIXj+PG73894?=
 =?us-ascii?Q?BP22LtB2dHm7yN1ZLsW0tm1KmpuE7BvrtZJ9Nt5FgWhpk+p6j8a/N3AgKzSf?=
 =?us-ascii?Q?Kk0vnSN/lq0hx6hvBYIvpmQla8zGCEs9T+tctfFXv31TbZ32VdxoCkZ6Z6W5?=
 =?us-ascii?Q?1lZjJZRlvxYUYAIPX8NqVTvkIIc/I1FGrr6OkWgNfTpKGpVoVAHNHZx9ChJn?=
 =?us-ascii?Q?V8MxgvOnLG3F9yUPecu7nF4U70x4oVoUf6aPoeuEi8016wnYTb+gk0pmhXZl?=
 =?us-ascii?Q?fwziMvXkk//r1eTdZyZdhH3CvpjsPn9OFnsfqdZ/0SIwzpn6cMxU44w5bQKz?=
 =?us-ascii?Q?TEmNZ/0YmKoN9+p8vPwtKAcU+AfZhUrbP81IyavVC4kn3FejHCGOGqWPWjws?=
 =?us-ascii?Q?glvvkPdx5mKds6UbJ/4qRfB+4PCrf/AEE3rXXcA6SdxSocx/W4U5PvrPvU0C?=
 =?us-ascii?Q?B9ylSKgF8cQQRoJPsoOqlo6/zIyDFlVOyCmV4S/vP4mG35crwACBU0rbOUWf?=
 =?us-ascii?Q?JIN47zl5SYZ1YL4M5QgVPfLva2r24QPRDSNgmv/IX8NFa1JSss+2E62HEPwU?=
 =?us-ascii?Q?F6k9EPkaSOUdTdIa6beGpspzwXF4aIjvI1hIApc6Y9m+B7oUWllLhLcHKBY9?=
 =?us-ascii?Q?6J1O0Zcf/hbd82V0DDmIra3C4PlKr3h3VXo8FZcuUkRp2wevlhoUWrnHo3xm?=
 =?us-ascii?Q?s4PFRnTe2sj4/DTeqP8warDUm7t5XSOFjqeGxHD7zspeCiZ63qCcxUUr0dLG?=
 =?us-ascii?Q?GlwnSM0ur24lNve5WzIeynRYQYGwk5s9Mp8+C7S42yj0NhHsmiv8r1l2gjIr?=
 =?us-ascii?Q?4zBal/0ZLenC4IDVA5iMfXGhTQSAEx1ghOyuc8vtWoEE6rYW7fuwUgo9OamU?=
 =?us-ascii?Q?x+52QOaEgujzKIRAzFo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29b75038-49f8-4123-764d-08dc6468fd2a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2024 14:15:26.7886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UCiByFlwpdYUzqKIrnYAjOd01llILunX1VrZ2Mfgnn4wiGEfEOfO/NIqWzW7bE20
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5872

On Wed, Apr 24, 2024 at 05:19:31AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, April 24, 2024 8:12 AM
> > 
> > On Tue, Apr 23, 2024 at 11:47:50PM +0000, Tian, Kevin wrote:
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Tuesday, April 23, 2024 8:02 PM
> > > >
> > > > It feels simpler if the indicates if PASID and ATS can be supported
> > > > and userspace builds the capability blocks.
> > >
> > > this routes back to Alex's original question about using different
> > > interfaces (a device feature vs. PCI PASID cap) for VF and PF.
> > 
> > I'm not sure it is different interfaces..
> > 
> > The only reason to pass the PF's PASID cap is to give free space to
> > the VMM. If we are saying that gaps are free space (excluding a list
> > of bad devices) then we don't acutally need to do that anymore.
> > 
> > VMM will always create a synthetic PASID cap and kernel will always
> > suppress a real one.
> 
> oh you suggest that there won't even be a 1:1 map for PF!

Right. No real need..

> kind of continue with the device_feature method as this series does.
> and it could include all VMM-emulated capabilities which are not
> enumerated properly from vfio pci config space.

1) VFIO creates the iommufd idev
2) VMM queries IOMMUFD_CMD_GET_HW_INFO to learn if PASID, PRI, etc,
   etc is supported
3) VMM locates empty space in the config space
4) VMM figures out where and what cap blocks to create (considering
   migration needs/etc)
5) VMM synthesizes the blocks and ties emulation to other iommufd things

This works generically for any synthetic vPCI function including a
non-vfio-pci one.

Most likely due to migration needs the exact layout of the PCI config
space should be configured to the VMM, including the location of any
blocks copied from physical and any blocks synthezied. This is the
only way to be sure the config space is actually 100% consistent.

For non migration cases to make it automatic we can check the free
space via gaps. The broken devices that have problems with this can
either be told to use the explicit approach above,the VMM could
consult some text file, or vPASID/etc can be left disabled. IMHO the
support of PASID is so rare today this is probably fine.

Vendors should be *strongly encouraged* to wrap their special used
config space areas in DVSEC and not hide them in free space.

We may also want a DVSEC to indicate free space - but if vendors are
going to change their devices I'd rather them change to mark the used
space with DVSEC then mark the free space :)

Jason

