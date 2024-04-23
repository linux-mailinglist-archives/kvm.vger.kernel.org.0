Return-Path: <kvm+bounces-15641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BB48B8AE580
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 14:07:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F4082874C3
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 12:07:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24491134CC7;
	Tue, 23 Apr 2024 12:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lPj6HXzg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2087.outbound.protection.outlook.com [40.107.223.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DEC84FB9
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 12:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713873707; cv=fail; b=rPjDZNnTlUDI5bOip9KQPLRLl7O4chWCn1gNueoLmst2KZxXgx/MeDwiiKXyCIIYryG4h1iDi4DldZhp+BqFBG7IARChlen4M55oPvUTT0mVKfmfC1CRA7D2Vox1RReZ2ih3ZV8KDZo+I3TqmdMJvICQ4K3adp3LQo3rCRDaiwk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713873707; c=relaxed/simple;
	bh=KMW2tweOK0wPsiEKmAFkBbnLyuQ14x9oF+5aURd7Hrg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PubX8gBV5E6MyBT3mN3jNWzEkODpAqYx4RqNaxKrGwpr8QOQXCdX5/+Lno71DPMLSXueH8CxnAN52kDjqWsRuIK2l7RzDdMPX+ka8u7kmgKdv/zd6K1C5Z2ktFf+ZF6eXYMt7zAKPuxX69Ar/YLGija565vGpFFo7C+uIJHYB4Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lPj6HXzg; arc=fail smtp.client-ip=40.107.223.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JHW2N2R0wRpQkHgFeYfGQX9uKPY6urKlVGsQ0taKfDfn+2jKPO3oR3YLdRFx1hqk7cs4A3Lj5E2xiZqMYUiuPtCV0sT4OpJBLdnFgIEln2vK6A5ny8ie+RNXD1s0S02J4E+kQAR5v3uWzXtjyN+TzusRI5wIybiIIOw07TgFWMOn4rT/D+rRmCHRahr5YP6TEtc+t/BQLcGdW3EzHgZyfCsHZiG5+TwP/QogLRMsHtviRIf2XEXLcyKLCvwA4j1MbG44ezZfikYf+1JiFcyF5gIZlT9wKyZPOU1kTUD0ErSbjoFfys33eDUoyGqTJR/9R9M1Dm2MR61dlrIRxIjyrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UdIaCJ43ezfL3C+MxIilxsccVDQICXPpVmzWDJUwUqk=;
 b=YWMBP8YBl3+AdSwQPRC+jd5AjVPkZAii9BzpjGmabMK+SH2MZ8mFdIs1x7h8VkzT9ZNoFw0+5uwRWI7Jqcu7GKiKyNhwyrAUaYOMskDnQBBOjWA7xBjBS+UiICE6gh1RZKNWLvttIHsKOLY5hTo5/mEbdJAHqL5I6YBIMw/K0y7LunNyNhecCBI9ObTMlsCQBR87OaXooijm7no9tTt+FU41GKr0Ors6JOFZutwYLOy3QPxT0VRadssZ1EjMaOChZKG/uFBG9myJv4be9pJfB3apwFTCpBLJFXn4QvG4eDCJ2qdM4naWbIvtgqnsO/fQEdT04K5fkxd7o6+OPhqzPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UdIaCJ43ezfL3C+MxIilxsccVDQICXPpVmzWDJUwUqk=;
 b=lPj6HXzgu8W1wS3920Rqmu4BTIoHvVbHA4ifpRS9GuZiVFQPNjCXc/JXDVzQMDCmtIr9rKUoeFWDtCN+uLbdJqSEbfp4SKB9JhM3Qoh7RepFiczB6U+hzEqYFSi54uZ+ipvp5tCSyxAt3zmw3vFL/b/Jx1KqIvq4c/eGdQyGPq79nd28Z1cUFgXfo7eWtf21fk6pizwPAZLtRdj73iW7YUMLLa03M6Tia8PJ4PR+5ZD1WMgNJXqLig+doTZgZJY4pcMYHCaF6MRSd8C2MTEHjmHsLFopgH1qxIlsfhE4xOGmf8N7LVZ6TduA3tbGWR/lCiwTyDOh9NlR019PUJnQlg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH0PR12MB8100.namprd12.prod.outlook.com (2603:10b6:510:29b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Tue, 23 Apr
 2024 12:01:42 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.021; Tue, 23 Apr 2024
 12:01:41 +0000
Date: Tue, 23 Apr 2024 09:01:39 -0300
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
Message-ID: <20240423120139.GD194812@nvidia.com>
References: <20240416175018.GJ3637727@nvidia.com>
 <BN9PR11MB5276E6975F78AE96F8DEC66D8C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240417122051.GN3637727@nvidia.com>
 <20240417170216.1db4334a.alex.williamson@redhat.com>
 <BN9PR11MB52765314C4E965D4CEADA2178C0E2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <4037d5f4-ae6b-4c17-97d8-e0f7812d5a6d@intel.com>
 <20240418143747.28b36750.alex.williamson@redhat.com>
 <BN9PR11MB5276819C9596480DB4C172228C0D2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240419103550.71b6a616.alex.williamson@redhat.com>
 <BN9PR11MB52766862E17DF94F848575248C112@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52766862E17DF94F848575248C112@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0001.namprd13.prod.outlook.com
 (2603:10b6:208:256::6) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH0PR12MB8100:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d6c610c-22b2-47b3-9a73-08dc638d232f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oSc+vy6RQnp69OWQ6WCp0t3vHtjvHySDNcgbzJ17y9j+DeK0Bw16XF0EQeum?=
 =?us-ascii?Q?twOIrGRHr8uSy7kq8rWDxoLmdxbNwYq2A8jKEKcXrvtaECoyUk1Q9tnd71N1?=
 =?us-ascii?Q?Si83gfChyBu0elICTdJH80QG5TtA+QY1WGXv/UR16Rx/C50YTZJAd1Qtlxim?=
 =?us-ascii?Q?bYUNDgduZj+gDh6AWooUSbsXsXfd/86NtuuLkykOjbEO9bxqorNPqGwzGZPw?=
 =?us-ascii?Q?k5xB187TFl18kKHp+MC1/YWvBoH8WL0BtLjNdugf9kdsRxC/X0mRI2MLZLkV?=
 =?us-ascii?Q?4d4htkNMrId0jfJ5mUwXQPQHJFwDLgKdhkV+N6oAW5y02Jb6qm5vsSSxCoxn?=
 =?us-ascii?Q?caDRGUcFmbPr1CSiID+XNu81oNR2DPvOuPBzwmNTKqLaHalIb0ODtP0NRhpK?=
 =?us-ascii?Q?1i5lu1l7nbGi+LKv9jYfyZg5y18glDR/5/VlnSk7uxKCaWTvO0MzFTPMejdg?=
 =?us-ascii?Q?iW+EWEv/ztf+Ry2nPaf3xSFrs0zuVmFWjrwEcfcpua8TsOL5yjYydcsQ84C0?=
 =?us-ascii?Q?wcjcW17YrVe+2g4WdB9VBXTUgMASi1OQooLBfopgIDg94+S7941d3Ezhknpk?=
 =?us-ascii?Q?c2ZfqyJH8NkRJrwx626S/llQRt11ZsZkYlcOE9MaSpJFKg6lVKtrd7LqUIKb?=
 =?us-ascii?Q?WzUhJLOn3eDYTAxvtWQXF/nQ00FKMhTFPUJW249PlkWmUoMKW9AA8sAOJULf?=
 =?us-ascii?Q?RHnLnFurE+nL9ImRDwBxEhBEBjtfADgJI4WtowHjcr62+cRqv4oUTOnC0f0t?=
 =?us-ascii?Q?pVIJKOIa3gFqt9Bp5T1BXQ7wpRirOEL2K2OUvIoAlcH8qgM3gKZjgssqr+Z6?=
 =?us-ascii?Q?Rn4PcnGrtdB37N+qk6ne/IKq22GwQLwYQbg8Sd4Svo/mQpO5nu/z414IXwlX?=
 =?us-ascii?Q?dq1Zr6xY09K23xeOXNb8j2iHZMLwatJOcM4krdpeKcqBTcvSjxS7XGaPSKw1?=
 =?us-ascii?Q?mSdk9VoYaIM/I+fKuuJBVIpYIdt8p5oWWSO68IJoYcVjBtIzIpdagAK+l/6w?=
 =?us-ascii?Q?4ijO1vLsPo1lGpyY9dUyLKf5fz8s0IbLpdKMcYAWzf3TuOAk7I1Xt9/4diA6?=
 =?us-ascii?Q?nQBIhC0BVOV6ZgL8uj2v6IQA25W5NWw2Cxa9EN31TrTpcp60PpxLDfE8YRie?=
 =?us-ascii?Q?dB2dg1QH2wpU1HjbXvyEUc6cxi1WjjBKEIeUdMASZjDYpu8VWUrHnV8aTiMR?=
 =?us-ascii?Q?y6VJXjq+2cNQPH/wbGoWi6SLnn/BHzeMK4Wwh/2Wf+7gJoXlCdaSs3fLfoZd?=
 =?us-ascii?Q?BkRfvydSFtZZpXgu6b3mTXbBIcqDWqWkzDgnmxVXFA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?stMna9dZXYnSf6TS/9M/RFMVW1xtGukrzGkRewXSRe2UDXDsSmGHPO5hJEsk?=
 =?us-ascii?Q?0CKv9lsr0+3SQ2eKR8KcRLrjgcyd4yPdANttLEix5tRM59lOPCd6yDkJpGm1?=
 =?us-ascii?Q?qGYEEy1qb/Pb5fjN//g0A6wjQPeRMUwNZRO0+6Saln+OeI2tP3xUKKkJXymb?=
 =?us-ascii?Q?nWPml936acCRNexcPPIqNIHd2ILz+5OzHMxu1ApXoRmri8jliBMqbMv9RqOO?=
 =?us-ascii?Q?GLHYYhxrzmg9kCajwneDS7Ol/XLvVJvFKbSX74cbKmpOoCxcaA4lSNjpeuJZ?=
 =?us-ascii?Q?OFifW+KO/tUCmHhR9+kFxAhxzqj9B2AXpulzeKCmQkg9bt/D88DCJlRTs0mu?=
 =?us-ascii?Q?knEDL7YMCLB7RbTcNLaPL6TTKhqMLXkVPn2xp2GnWkiV1hwxgHby9hX0/sHR?=
 =?us-ascii?Q?Rk+k6lXecMHSmlVWR++uF2iOhuR1wWv60AuWHl/MLHu0zKE40R7tfKBJSnkS?=
 =?us-ascii?Q?OMHykQ393agJ2alzaiH+NpxNY4hW00CuI6VpENZKid8E5hRy4RMKBRa2OoDW?=
 =?us-ascii?Q?KkJThF1ifgEB3thTlqhlDxcvG16YRik6mGcpVE/Er5Vg8XkXOHzl/HjKaYcZ?=
 =?us-ascii?Q?LMqk4uiIEsU7rfcR4cNg327E5KoCSiUejjjKln6J6bHkDJ0YnwAvInJ9SGB/?=
 =?us-ascii?Q?pufQmj/UUFTrisCfKoDpoy70g5nEKKzJZCTnwja00mGBm3z2ijAvnXnTU1rL?=
 =?us-ascii?Q?S/9te2mEdv27v/XcHKGoaqgsKxBAIdnuInhNi59SS5O8AjgoQhQCHcDP7doh?=
 =?us-ascii?Q?FM+ucg08WInr9TxeEExLc+cKGPSrP1eQ/+KpC+hjMJvCt611a4nE8dVVIDgF?=
 =?us-ascii?Q?gLj98urHY4necpgK38d0PO0koI/BstfvHd4TcY2jFDLmXWO4WK29saBfSPw3?=
 =?us-ascii?Q?/inI/qQIEI6DW6HeFItg/XXLcWK9xEi/oxHKqsOCl/cP6mssAPeqqIhcltk9?=
 =?us-ascii?Q?EykglVRY2C73x39FD+61GfGQH0JJR1eyHfkvPFsyF6ZxA7+lr06G1RAQYXgw?=
 =?us-ascii?Q?P7Y9koQto3a5/q5qpj0/rOn/yqxBQizZ68/qpMSQyw9TB5H0EeDssGWRqmRS?=
 =?us-ascii?Q?xbSSV2Z+n2K/EMtykaIs3OV43MIs2829oYEQrc82bDvY0E00/Zp9NwIJU6OD?=
 =?us-ascii?Q?Io9s2FFICs8Tv9UAb2e9YlXfUlXpmSUzW8k1UC1tuGr5LcTSraXcu8Cn3db3?=
 =?us-ascii?Q?aeNZpvklK0XpfEvu+DlVI7ofcTzEggBHbDaY38sETCNWCftWypEufZYXUm/7?=
 =?us-ascii?Q?f6x5g6cbusnK7N9icboJB1R4yFRS1w5rMK0TnwNCsKGkVdj8FQAN/asIa0OZ?=
 =?us-ascii?Q?2isH+oQHx9Yif/1nDr8zKaCF12o0fw+xwpFHyMIqp6gvvFEMWOTP0JwENUYD?=
 =?us-ascii?Q?bbJwtVKvxLzh8nVVpf1HbzbQnnyk9JdilM9KRSe1ZvdgLnVLohpDSMNH/D+M?=
 =?us-ascii?Q?xBVvAePiVevEd3ud990xEP5ElYTrBoCKNGzphF1OIZscebWv1/L4xs3l6sag?=
 =?us-ascii?Q?vgtY50oIY/7KxMsJRg3YhmBmYyA318vdNzzQ9h7dfythUthOhV3ZvLFHl/eo?=
 =?us-ascii?Q?rFlPPMdAwy8wzt8OrmWY52AkWrTI1mDfWWXb0hKz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d6c610c-22b2-47b3-9a73-08dc638d232f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 12:01:41.3583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G3MLgxL4qjq6l/gq2tD4MGJt4QlT30HnHYb77QB6V6FxEiaoBOcW8SI2Y6k8Mb6N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8100

On Tue, Apr 23, 2024 at 07:43:27AM +0000, Tian, Kevin wrote:
> I'm not sure how userspace can fully handle this w/o certain assistance
> from the kernel.
> 
> So I kind of agree that emulated PASID capability is probably the only
> contract which the kernel should provide:
>   - mapped 1:1 at the physical location, or
>   - constructed at an offset according to DVSEC, or
>   - constructed at an offset according to a look-up table
> 
> The VMM always scans the vfio pci config space to expose vPASID.
> 
> Then the remaining open is what VMM could do when a VF supports
> PASID but unfortunately it's not reported by vfio. W/o the capability
> of inspecting the PASID state of PF, probably the only feasible option
> is to maintain a look-up table in VMM itself and assumes the kernel
> always enables the PASID cap on PF.

I'm still not sure I like doing this in the kernel - we need to do the
same sort of thing for ATS too, right?

It feels simpler if the indicates if PASID and ATS can be supported
and userspace builds the capability blocks.

There are migration considerations too - the blocks need to be
migrated over and end up in the same place as well..

Jason

