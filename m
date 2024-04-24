Return-Path: <kvm+bounces-15859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F1BDF8B1276
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 20:36:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 81B121F21C58
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 18:36:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD59817758;
	Wed, 24 Apr 2024 18:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qUR4D4/x"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2060.outbound.protection.outlook.com [40.107.236.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1D215EA2
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 18:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713983793; cv=fail; b=q2vBn6u9laYpefE18yIhcxYQN7y3+k4J+jMiNbZ7K0RMzLtp44dPpvUZkxwY/tjnbKvOXpINbfk8GsW1LOAxMFvRV7OO99AR6o/ltTS5jIQaC8Oh0IbHuSUDnHuexMcAKhhN9CXVF76tkMboue4xRCdfWu58YFxIac9aemtaykE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713983793; c=relaxed/simple;
	bh=+ewuRYP72stzVC2fXbR80GozA+Pt65YOKpW523HHFgA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BEjoySPZ/rT+m77c2t9bR+R9QO1aKM/6DyE9JiADivrUpu8L5Om67wTv2R/zXVLY9vnoegmdp9DrfC/RoeqVm3aiqXURI2Sv6/I5ErwXg1Abf/U/9f+1oCULPOcfvxn55bnaNeKZon2kohi4nYchmV6iRw6KU0XepgmiEzSIKGk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qUR4D4/x; arc=fail smtp.client-ip=40.107.236.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P/myGXjSL51jdp0z5q2k7UXuELMCIQys8JzGLTs2RyWwM3bVhl+UiFF1rXtXgRolJaVjpep92J+sfJVX00hPEH8F63KBfIEmv/782fXwKgxD1GW3CNpTozLgcGiNpb4LpFudYAovlZIOwPugDN/P1Ie0g4BvQFf/y2kWOYy+rl6860ET1ZlQk4WuDgMpbqVYGE7MiD7lEVmIWC0mvTQT4CgyLX8qmsSDQNl20rnVbKNnmZlZWID7G7OH7VWJrDf3KyuTlD2ZsejWz9fFvV2dsdHg2CamAhED80OJHA4Y8rJfXuPDL3sU3Yu2N4yWRPRltwKCfy8fI8IyuBAx42B0nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3B2yAYBNd2lc/478ebn6JBFBczf6piQrzAOt+BaupNk=;
 b=nYFINYvqxhTqOc6fN/TqDlWXf+LZadbpWV/KcpyKWcowIRjnoUZ7/BlAedGiBDsp8TGosVQzMcCU00ai8pKF7oBpb7+8qnoLAx1lQsbM84fF/N/A4FyzZ3hv6lFmFpB6pZquynkPC0TlZ6sulb4pfrJy2YX+qYxc4HeJkBOwLSWxST/3gP6KphwsRQ+NqDdQmZrnJGjoqTWSngAgkVAxL+JhhsyXVOvWcydQelMzVMKs4ppDaCTa6dtp6sq2DrhstuEI2kR2YrBwIL8rSC89BxxocpX4Q0/7p8JgfOC8k7eBx4uzvck/puU5hv67Is0G92rU+G8Cfn3htQa1b4RRhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3B2yAYBNd2lc/478ebn6JBFBczf6piQrzAOt+BaupNk=;
 b=qUR4D4/xw/aKQfliuc4lrtZ69fKkhCkev9dlOc0KcTT+unA4x3F/OojY3DVcxHygHrzroALe6+hFN5iny51J5iw6hynrNDnldcntQJWwSd5GxN6412oLrbrnc+TjXQ3n3iZcnt7mvUlbS4Mivdl7Jid158Lwl6LncuyHLvwpaljBRv93ZZ/xUmjE8kAL9Ys4hU5d2LJJMUBvt1oyQ7w0CTHa41UDhtydstNVlwJpWv0r/EHRA9rDGhQUiL7LOpyYOx0mOGE1+VEEG6AmEYcnVpBVv3qrit6dwWcU/eJNax6kAuhYUhUgF6NmbSexKjHyUzIPl++b+5ryEHuoedhbsw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CH3PR12MB8074.namprd12.prod.outlook.com (2603:10b6:610:12b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Wed, 24 Apr
 2024 18:36:28 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.021; Wed, 24 Apr 2024
 18:36:28 +0000
Date: Wed, 24 Apr 2024 15:36:26 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
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
Message-ID: <20240424183626.GT941030@nvidia.com>
References: <BN9PR11MB52765314C4E965D4CEADA2178C0E2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <4037d5f4-ae6b-4c17-97d8-e0f7812d5a6d@intel.com>
 <20240418143747.28b36750.alex.williamson@redhat.com>
 <BN9PR11MB5276819C9596480DB4C172228C0D2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240419103550.71b6a616.alex.williamson@redhat.com>
 <BN9PR11MB52766862E17DF94F848575248C112@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240423120139.GD194812@nvidia.com>
 <BN9PR11MB5276B3F627368E869ED828558C112@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240424001221.GF941030@nvidia.com>
 <20240424122437.24113510.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240424122437.24113510.alex.williamson@redhat.com>
X-ClientProxiedBy: DM6PR21CA0016.namprd21.prod.outlook.com
 (2603:10b6:5:174::26) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CH3PR12MB8074:EE_
X-MS-Office365-Filtering-Correlation-Id: d696660b-a605-4600-90f8-08dc648d741b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WRA9GvKJTiqh1KsHPZX4is1rPLZcQ72DWJB/zFVPyjIwqfPpo4X1TZUl8+qz?=
 =?us-ascii?Q?81a9VEWRGnlhPoFRIT+t9y70+xRK+ZMwlfoWsqROCozQJi8wQCK9E5dVfD1/?=
 =?us-ascii?Q?qzTLWBoBlTuGC53JlvpRmIjjRYn+IkADsFEn2rMPGNtUKgmBF8+z4+BUlAkI?=
 =?us-ascii?Q?aaqaQuCSa8K7vOcLLtBy7eo8w3/XnHqK+yjDPSVo85PLV5QPjpCK8BibCknc?=
 =?us-ascii?Q?2xSLyv9i8trmBJKip9cKWQ+Anegm++5pB4HRqncZj8NdajQ+5nJauYk71553?=
 =?us-ascii?Q?OStkwk/CYDCe1SoaVXvejt0o7KLDpWF5nDRGS7tsTEnMAlAOQFfGCV9JDlwa?=
 =?us-ascii?Q?pzG+9V0dDL9RFofwl197OLlCxBNcULGGk7gYDMBBGTRwfTWEmbm/1qT2uasd?=
 =?us-ascii?Q?rwpSp9gM0i6IyVSlYU9hpDnu/15R6dWmfutv39FB0iCMLZ9yHqNXv8OpNUDL?=
 =?us-ascii?Q?3FpHDplUUy+idsLFR7/XTP7+nWRLt457Ca6G0FqPBze+tzNodiKmOBQL8jpO?=
 =?us-ascii?Q?++7sEZFZ+uxJVC9yRKMNUXVdSqLb+PUOAdarwMGM0KcMkKuuou1ZwTWY8DTX?=
 =?us-ascii?Q?SOs8T0sTzYILPFKZeyC+TdlU0GWBbLQNtd/T2dBH0j7bFCSPsJUF0ixN2xuS?=
 =?us-ascii?Q?U3693Kh6ddEv8zDCPy28qpwXehaCENTtKXDl65TAPsCbEk/NDaE71ys30SE8?=
 =?us-ascii?Q?Ksy7iWyIQ+uYxoxRIm1jsUET/8xlvOQ2AAzYyStcYGs8yWlmozOhdrWJXvIO?=
 =?us-ascii?Q?YbcoL4Zj8Z1/lSsRN8OeR3kPtUBJqL0TxMajUvtG74J3vXz/W88po2JozqBt?=
 =?us-ascii?Q?Anu4dCO5nciNF82LAw/5qEcF0+2Iz8XpWzlMpDFdF+/sawCCZis7D7nWqvzJ?=
 =?us-ascii?Q?zezYT5Zh0d2bDntSEUElCxMxZZWGOsAvMAfUQGpEnnctgeGLxwufhojGfQrw?=
 =?us-ascii?Q?aDhBeGWIp919IlUqt0nXcmFuPv3IbmLWWR07751cbuJhrLtC9dOBv742CtDt?=
 =?us-ascii?Q?1UPLww+QAgW68lNKdlkZYtQFVl0GCxIXXQtV/jifpEZevPGwWQabGWVQpAmn?=
 =?us-ascii?Q?+Goi815XBBu0Z45mydU6P0w/aMdAmlndoJEnhi9uqutQfZ/lvJtLjYUHy9tC?=
 =?us-ascii?Q?F04id49sBEZxqry6puQC7G6qMqSUUSqrz+WfuhK84zaiM1Rj9LertNHHuRoM?=
 =?us-ascii?Q?qu+nObFg3kCaRW5v5/6c2kHsP+aYv9KtsXUYyyArANVltEj9WQcJgX3XARN5?=
 =?us-ascii?Q?ctFLMnNoH5v3UXmnBfMGKWLaf7U4hjg+B33O1D2R+g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?az/ij5KIjo0hzNKfTIlcjPR54PNBqL3nv00YtflC4RiiIZIlSipGJlNUMh8j?=
 =?us-ascii?Q?4qFaoIzuIlvfTrNnwyEhZh0il4JNv6H8WJ9agUgBbIev52pBHUamY4EyB4+E?=
 =?us-ascii?Q?WqIilZSWCEQDwJ6EB2I+4Lml2p63IFNmisaqo+n6iDZB6tZDsNRtDlJFiD4O?=
 =?us-ascii?Q?q3Z7l0Zw+ST21Lj79pPVxgxh6M9W2AmrnvFu4uA620FGHPe9kwqYfIvV1965?=
 =?us-ascii?Q?JehPIivfe5552lzMGZJIbN4A8nV+gAvphrm74cU914L/DjYJpnZHRpGrj/z1?=
 =?us-ascii?Q?OHXxviL45hitnBxELa731ZeHZdXcj4h+xBT2gDaozK/k2EBc6+bsjoETjMww?=
 =?us-ascii?Q?AaDYskIfjaU6tHFvfCfXoS/pmS7MQtVHwM/rXSm+x2JYEiYFIDTzYzCLDu8a?=
 =?us-ascii?Q?V3gorPrVlQOK7ZTkdACqsz+W4Tl62lkImVfwZ/49oSh+cLFjUOmMC4gpiWBs?=
 =?us-ascii?Q?ZZnYG7HgMHXubKBCVKrg07iKp5Jt2PPJlOA8WTCW+k/1/MV344qHqp7fvovc?=
 =?us-ascii?Q?iabbxEeGwMnXD7Sgw1VZutWnyRyIRVUrzZhzrYZc0KKCuRMJzwV3EP29iPMm?=
 =?us-ascii?Q?JWvbwYd3wOkK5dXOxhaFPVXvc+AzviGf5BtCLR0dYcFCk5/vdMjgcykNWjKW?=
 =?us-ascii?Q?02kPkQA4SSTvTFVNGS4B0yjAeqSvZqaI5hEOY45QhJhOw9TSi9YCp/oMI0Gi?=
 =?us-ascii?Q?mbA0Lxq0MPQ6SOPGmjRQkk4tryzznNSbWxZPJ/jqy+KVPKY6VDsIG38F2Nwf?=
 =?us-ascii?Q?FOdbG2q5AU5gqCA00v+omJ0+NUZoiOz04fQI/A1hiudsvNCZKcpQMYxncNK9?=
 =?us-ascii?Q?kK8SqDP/nOt8dogxrfE3DEkBMWK2XhEKs6/oY/Hoi6jNoywT92KYZVd9+/IH?=
 =?us-ascii?Q?WESRn8i/b3xOc6IX5k5W1/5jMX4OS4IYiauzcBQRL8RnCvO/R5jNrtEYHOlb?=
 =?us-ascii?Q?VIdvN5xuObhGIUJsnOlUFWWf+AEPWs8Z5uxJmVub3kjQt0WLQv1PzXYMZQsb?=
 =?us-ascii?Q?Mdm1tbXCgIL8+im2htvEU7pzKCEMgQQh5cDogr57Ek20r0BASjo9n2joFus2?=
 =?us-ascii?Q?86oUwlb0eaVUdouDwJZzuKe1Mf5Kpwc9SvSNbFlp1Wm+ZMNq+Eimare9AxUE?=
 =?us-ascii?Q?7/XMcOE3bjxAyvDhFsp4DbXce5zntBafLkPhUNtVEG1czZpPt8gwP68FvtJO?=
 =?us-ascii?Q?hafIT2xvcqNhHeiPygTyfHeLNz7INaGx2IhS8podidIZU13tVUAyGVgmKPCN?=
 =?us-ascii?Q?GTar+YU33pjWEYLr9PcUTO2Lry5chMUcHhE/Ixafwa19dfJePf8BZcOU6bIK?=
 =?us-ascii?Q?ZYaXtIaszA9SOg6VdhG8VhfvsLSazsMqeIQgSc5gODtavc3Szd+kpLcHf9uO?=
 =?us-ascii?Q?m9uW2XpvqRtYa5x53aNg9r4sIp7CIIAynyAj/uxIJ6VcsPAJNP9kmdz7jtZT?=
 =?us-ascii?Q?Z4YzeGEIbOmWBzQH01YfRM7yx0dANUJVVOjzANbeQPnaQHJSLWGMB0HhfOCg?=
 =?us-ascii?Q?Xf2gA0s5xFjpQXyL9fODQuL39IVmQhDBT4bapp6RLRaoSfvkODw2e/DmYWZM?=
 =?us-ascii?Q?iYXakpFSQj1WXFmmHcY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d696660b-a605-4600-90f8-08dc648d741b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2024 18:36:28.2917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KhvFZlkWFL3VCghVjLellh5aIWeRiT7/yJUmtxqp1a48ljFnSACmpNwISlppallD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8074

On Wed, Apr 24, 2024 at 12:24:37PM -0600, Alex Williamson wrote:
> > The only reason to pass the PF's PASID cap is to give free space to
> > the VMM. If we are saying that gaps are free space (excluding a list
> > of bad devices) then we don't acutally need to do that anymore.
> 
> Are we saying that now??  That's new.

I suggested it a few times

> 
> > VMM will always create a synthetic PASID cap and kernel will always
> > suppress a real one.
> > 
> > An iommufd query will indicate if the vIOMMU can support vPASID on
> > that device.
> > 
> > Same for all the troublesome non-physical caps.
> > 
> > > > There are migration considerations too - the blocks need to be
> > > > migrated over and end up in the same place as well..  
> > > 
> > > Can you elaborate what is the problem with the kernel emulating
> > > the PASID cap in this consideration?  
> > 
> > If the kernel changes the algorithm, say it wants to do PASID, PRI,
> > something_new then it might change the layout
> > 
> > We can't just have the kernel decide without also providing a way for
> > userspace to say what the right layout actually is. :\
> 
> The capability layout is only relevant to migration, right?  

Yes, proabbly

> A variant
> driver that supports migration is a prerequisite and would also be
> responsible for exposing the PASID capability.  This isn't as disjoint
> as it's being portrayed.

I guess..  But also not quite. We still have the problem that kernel
migration driver V1 could legitimately create a different config space
that migration driver V2

And now you are saying that the migration driver has to parse the
migration stream and readjust its own layout

And every driver needs to do this?

We can, it is a quite big bit of infrastructure I think, but sure..

I fear the VMM still has to be involved somehow because it still has
to know if the source VMM has removed any kernel created caps.

> Outside of migration, what does it matter if the cap layout is
> different?  A driver should never hard code the address for a
> capability.

Yes, talking about migration here - migration is the hardest case it
seems.
 
> > At least if the VMM is doing this then the VMM can include the
> > information in its migration scheme and use it to recreate the PCI
> > layout withotu having to create a bunch of uAPI to do so.
> 
> We're again back to migration compatibility, where again the capability
> layout would be governed by the migration support in the in-kernel
> variant driver.  Once migration is involved the location of a PASID
> shouldn't be arbitrary, whether it's provided by the kernel or the VMM.

I wasn't going in this direction. I was thinking to make the VMM
create the config space layout that is approriate and hold it stable
as a migration ABI.

I think in practice many VMMs are going to do this anyhow unless we
put full support for config space synthesis, stable versions, and
version selection in the kernel directly. I was thinking to avoid
doing that.
 
> Regardless, the VMM ultimately has the authority what the guest
> sees in config space.  The VMM is not bound to expose the PASID at the
> offset provided by the kernel, or bound to expose it at all.  The
> kernel exposed PASID can simply provide an available location and set
> of enabled capabilities. 

And if the VMM is going to ignore the kernel layout then why do so
much work in the kernel to create it?

I think we need to decide, either only the VMM or only the kernel
should do this.

Jason

