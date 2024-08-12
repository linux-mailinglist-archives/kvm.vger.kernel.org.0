Return-Path: <kvm+bounces-23842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5740594EBE4
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 13:36:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CDECD1F2244A
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 11:36:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3674175D45;
	Mon, 12 Aug 2024 11:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rhmVwmoO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2068.outbound.protection.outlook.com [40.107.101.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7503C0B;
	Mon, 12 Aug 2024 11:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723462564; cv=fail; b=ZmIqbF1ezZ47rJMvVsWO/jjuESOcsoHndXqukpjBZMIOHyvvGRP4YmXbsmp1hi4Hu7jJe3xyzTfTUxT9NtYsEww8X4GJM2HrAaTz5Oogonnanh/T5+5L6dTX2heybzHB80ZxMuxsK+ziZiYf0rwaNNxokC1Ig3fLTJwRb1BgtOA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723462564; c=relaxed/simple;
	bh=x1ntV6PH7c+4XTJTAc70wDPCCAMjrHWpX9sH7QMB+QM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=f7UtbEpuYCWhhrmKh6ZFeJuwD8RT+cAUVJZZDr8y018u+84i9OwtDt6PG1ZkkdWPF+6XTc6ZN8QnUAUtLhShHhiqBHTM2PRa/2NIEXpHEgZD72j1C5qfoUZZMC40ddDDm6+Lj3cSsBMQctX8Qxrun6w4vH9IBWFLol+p6a0YnL4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rhmVwmoO; arc=fail smtp.client-ip=40.107.101.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=plIOgukjGLpb84ksP7IgSpzBLAZHSGcgMBC049C8NkUS7clZpd0zn1vq9D9XzJXxsSWQa6g4AOz81PQgmtDEerK+BCgBe4Gss15ugTUAmFvANvMbUrTTl3c7mB9A4DGlK12APgOqaD5vLVg21RnS+vDRBNf2fWmazzKA3eY06p8AbKPb3Dq1bcNtRxPfe8j2vxd+xURD6xBfsJSIBhpB8kc0TrdoRSolqq2KpP6W2iFk65mtwCDQ5IYQlffHZUNVQNXapu+q3/ITq5pGvOgz4VOLPgduVnfXiKQczWC2M+f08MpQvLqFlY2fxRH1IX7s5QMdQeGjmOv/cAXjv5cSFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qf/Fm5H9y9e4Xwe2WMM6Bptxg+juiFxn8ts5SvBOPhQ=;
 b=jGmQ7gZD7OTMVKWpNeUY3dQhzz1BJ1p4RNcPtUk+OHT8thwMAJCQhR5sIOQIoNaPypbutuMUv9mIOr54oXOuT/iB8d1PPfgR8bGpZU6M53pLjBlg4pa1Q7Z+mFLvo0GBvLabv6S7Eg8RIBTawdE99S7lGS/qGuS0NX4H+vssRPFA1xFQuEfLPfF/gbnyrsZ2KZevWCtnJQyNLJzojMe+WxCb0resnM7I+GHsW+IotheJK79/H1/Ee4jYNCbNdSIcfp9O4psexs9QURzpoQk5QlQ+aaHKlVzDNgH/1Ln16h0gEd+mND2B3AiJ16rfrsDrRxz9tpeaL5n6Hw5DfA8e5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qf/Fm5H9y9e4Xwe2WMM6Bptxg+juiFxn8ts5SvBOPhQ=;
 b=rhmVwmoOR0a5h+acUB/TKPc4yuKPvc2dllKewNz7BNPCChD2Hy8AUfd3IEKSIyQbrEVM6V62ld6HcSkoIMwmdsxpIUnzRAhAzewDMcdAS6/Z33VzT2ve+HfDfEQibTGJilZSPIndXUf70JWJ+uEAOysm11G0VT2486WiHVJfNaZp7//AX8mFpFTMzMFROZfpPIopCLdbKZzuqaoplwafldtQJyF9+ObA/i57CJEGB7atYWEBR9hufaiqb1ox+fHZ0jSKqhXNGglgCnh1PIIYX4+Px51/Kd6QJFfQIYebqUts4W4qB8g6vRDjFb+Twao9eS+v6XLIfrodolDHQc9dcA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SJ0PR12MB5636.namprd12.prod.outlook.com (2603:10b6:a03:42b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.20; Mon, 12 Aug
 2024 11:35:57 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7849.021; Mon, 12 Aug 2024
 11:35:57 +0000
Date: Mon, 12 Aug 2024 08:35:55 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	David Woodhouse <dwmw2@infradead.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH] iommu: Allow ATS to work on VFs when the PF uses IDENTITY
Message-ID: <20240812113555.GP8378@nvidia.com>
References: <0-v1-0fb4d2ab6770+7e706-ats_vf_jgg@nvidia.com>
 <BN9PR11MB52762296EEA7F307A48591518CBA2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240809132845.GG8378@nvidia.com>
 <880c1858-afee-4c30-aac5-5da2925aaf11@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <880c1858-afee-4c30-aac5-5da2925aaf11@intel.com>
X-ClientProxiedBy: BL0PR0102CA0038.prod.exchangelabs.com
 (2603:10b6:208:25::15) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SJ0PR12MB5636:EE_
X-MS-Office365-Filtering-Correlation-Id: 5aa4d120-22e8-4229-2ccb-08dcbac2eeea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?p0GRH152BimFBgQaqpXlPzDsMjzIcPVMZqqeSJgdpGt/VEgkpoegZ7OQCWIx?=
 =?us-ascii?Q?aKVpUa1GbhvcjF3M4RM7XZfbrA0U+AVyG4hvAsS7ym6gTV1i+krd4eivwQK2?=
 =?us-ascii?Q?T4wyBZUOAXviH950i4nSFDRRWz3RGkMyyvTX6wAs97EMs+Eaqb1ntxpCXQ0B?=
 =?us-ascii?Q?iaXaC3aXy7r9R7+O1b/9ZRFLEGYD+qWm6jJEuCPxz5vq94xTMcI016fC112A?=
 =?us-ascii?Q?PQtGpjPZgg0EdwwjG5BICSDmiNPgtBl/n3GZfS1DhSVrqYA8M8gVRNY/iZXj?=
 =?us-ascii?Q?xX0Z8b8NRZu6D5wXHiPuEKt+22hIZ6YKmkkvrAiw5jsmhGakTn2fLZvHHURn?=
 =?us-ascii?Q?I3c6bKzu77XjCsbs6Py9bN3IrTg+/N50zZvdk/yDp4lbZMLw5+NHSlEPy5tk?=
 =?us-ascii?Q?pREWW+II9w6wUfKFhllhnusRH7y+rZTusYsbdJErVOEd7+COLJg+EjkGbOby?=
 =?us-ascii?Q?BGSrV+EhzeSNxzoG/gNbA30/Uc9nb74XBo0EHE6GMr1EUB76x3wAGwGiYZXz?=
 =?us-ascii?Q?4FaLTTq6B6NJiwDM2l5sINY99wQec45/AG0vpgn0oCl+WoiNBvFs1UPgLHEo?=
 =?us-ascii?Q?OP9WoqU/+uX+XNSLCU4AthcI0r/IMUa7j8n+NOxy8G4pz1zsDB8Exb6Z3lRL?=
 =?us-ascii?Q?u6jyoGm5nia/XX3mv2bvzW0M3mJbe/PPsA9/XZo1iPoMEIT331x3yEQQrhHn?=
 =?us-ascii?Q?Tedp/+UacA2DYDXK45tETmnDrvSeATFiT2weixKHPiok9Vt4j99Ag9PC1wtA?=
 =?us-ascii?Q?OOpB2Sjo4rrAMq2ZueQs5q9A80XnPxL2lmtO0Zxr929u90UoK4Vc6wL33FJ2?=
 =?us-ascii?Q?pL5E9AnrL0lPfMPgdzba01NYWdTwNCL9UTs5o+XKDNfEEnAGpy1um5iLi9+I?=
 =?us-ascii?Q?P9Vdhy5g/qWVlg/Onv57+UHH/gfeksXWbeJ78apv/YYBlfFdcAYtWt/2g4Zg?=
 =?us-ascii?Q?A/ss38yQXixSeIoFMJZ4h4MNNXp4ESVI8tTHvd8LfIRBpMtst09hz4Ni9lCQ?=
 =?us-ascii?Q?NbFsdOCnjkDIrCmZpaL1w7axW3tgWfA3gWggonEiGuhTweLwH5mXaG2E66Rc?=
 =?us-ascii?Q?IPywiHzF6aX1C0l78keNBlrnKzjz4UBbxC4v+OUzbepDUUHi/pJflIl4zXt7?=
 =?us-ascii?Q?5kRlnIsWtX+qTvYdrzxEoFOoeW/ErFfAYpnEZa93fWEVJ13NAL3zt7R6i51Q?=
 =?us-ascii?Q?k+bWuaEdOqQekChSZ+Xb6Udxs4oAeLJfYK8W1mjjTSBOxHV4tF5E+F0F4X0z?=
 =?us-ascii?Q?6uAiuyF0uiwDzGcKgLjTnWdL053W0OrbtZCBQkysh+CNP0x31kqWysOlXD7y?=
 =?us-ascii?Q?o8y2rPs7DKcjT7R0xmiOoxaGOkVMy79Raxj/2UcXnCcrfg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?D80sII8Ob7HklBgL2iVu670LI88vV30O53nS3VQBHtWUtzuatZBFSW3l28OP?=
 =?us-ascii?Q?Yu3iEZjstBfTmbPTMocxdFRb8c6cOKnik9AnHY43GVSb6u0HEp47jgY6vCAw?=
 =?us-ascii?Q?04OoXu3o7o1jrwzRmBQFMc2xVCJSpH4slH8dAhGz2ohJbvzNLead2nwa2akW?=
 =?us-ascii?Q?fRVQBsJw+Fx0Xy5Z2b41hN59gTJNBTX1eNaK6UtpaswpeEoVLAgNbf/J88/7?=
 =?us-ascii?Q?Z+fDco8OPOLWe5ImewDHy8ieW7FjaUMisgqcPL32kcDcC3lUPt/WKqTIlbiU?=
 =?us-ascii?Q?DGwFFuvl+hhgGqC56yEtFDPQEj8/sAkoxCnoMJLzdoTXOIiPX0PUcd4k5L7V?=
 =?us-ascii?Q?P2d/uCJIL4zgHy/mC4GOJOJegDsZUgA79IjuID0iPgDID1hgS+LYxkEt3wDZ?=
 =?us-ascii?Q?JnHky6ZpjYMy3HXtkF0H+HJUvVjY+ifUBYWm4HO35m3LdVBm3nL4u+82kC1B?=
 =?us-ascii?Q?/5uBKca0DKzhDZtXS1lW2j9uec2SDdzWYkv749MIRj7rD8Mqe3gcvsWZod9M?=
 =?us-ascii?Q?N6rbWgsIaPhxv7pEflIEaZNJhTKalxGdjljMNtjI1sW1k97PcA1BMTyvuIrT?=
 =?us-ascii?Q?hcpA24VstFkOr/PVrUSKSO6Efd6gqTXmC+UYISsk+IyAPB2+DSGy5yX5m+fe?=
 =?us-ascii?Q?GlHgbeeaOByPrWmCvEzroeiQxR5kQ9TqbH3K5x3zk5U3QPv3s9h9fnOIg/k6?=
 =?us-ascii?Q?cXVayvOGf++jVAyZY2XueG2Ww5NGWT4Cfsruc348EnRK8Gy0G4c+piU0zUBG?=
 =?us-ascii?Q?c+H8l6i2HfbElGTmE81W077SvVVaNqZxlhnMIi9gNN0dheuoMc4ix2j7Wuuo?=
 =?us-ascii?Q?R2zjc270w7bImTsOPkABwl8/mWeWhAEPagZuvPvIysAKvRVzvsBcga9Syrbd?=
 =?us-ascii?Q?7jkbYrCuRJIBGweW6XFHEa/wyGiPHmIlg6S1SNQbTo5jMpT1v3fyJ5FiXBPu?=
 =?us-ascii?Q?jY3gO5tVhAqra1y4n564JoWyOA3J4FtjZRW/xcd+pn01PCKIHrEmrVK6Ue3E?=
 =?us-ascii?Q?RRD4rQS5+0fLsI7JaB/jkpOMSgwVr90kLA4/UvNfCAR31Swmoc1bE34yQT3d?=
 =?us-ascii?Q?sWwDcrfS2xFHnbOM9HaCYcID1ui/y63b0Qym/hXWuh9QWTLyGnnd/KOnxWSr?=
 =?us-ascii?Q?F4s8z3yTHZG39s7sEmO+pCHGtUHH2DtXTEVuvJItMCki7Gf4o1BRZS83Lbn6?=
 =?us-ascii?Q?Aen0OXH8eBc4b6Qi2X4Egtmy10Vet5WdhhPZZjs6PdK4vuOv/R2Kde0zUvrv?=
 =?us-ascii?Q?uCMkbv0xAxey1nVLNQWPzrXfaBybaJ9KE4qo7NscikWoP+2wyIz4FCobq3jK?=
 =?us-ascii?Q?+ND8UO4/7/2UfaaMzVXBBS56oRTr2hMdICwpFhrdkuxfokA5VlqkDScja4gb?=
 =?us-ascii?Q?dtDbwMlFTug0euZ52veXpSi2XmKpufWhMsMA6bd8IddiA9nDI9XVqFiFolYi?=
 =?us-ascii?Q?WdjNst4X8uR7bI1d5uLk4PlLzs8jU/kxcILSkRtVACU2TxU4eadT1sEXX0Af?=
 =?us-ascii?Q?oh1NUC1jCqCvyZB+Pd1Ax6DHIKjRwN8CSKxzK8RV1E6mwv34IYVI3q457QOy?=
 =?us-ascii?Q?ABGKt3FPy6U/rd0rTWA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5aa4d120-22e8-4229-2ccb-08dcbac2eeea
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2024 11:35:57.5837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DQPPZhy+ViJWKCnuc4WWT/sBEQ62j2ZvUVrSyJ4cfG0t+9EzT8/NvmhfjrhyYUBF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5636

On Mon, Aug 12, 2024 at 05:03:37PM +0800, Yi Liu wrote:

> > The PASID may require ATS to be enabled (ie SVA), but the RID may be
> > IDENTITY for performance. The poor device has no idea it is not
> > allowed to use ATS on the RID side :(
> 
> If this is the only problematic case, the intel iommu driver in this
> patch could check the scalable mode before enabling ATS in the
> probe_device() op. In this way, the legacy mode iommu would keep the old
> ATS enable policy.

At some point we will need to address this.. At least when we add
PASID support to mlx5 it will need something since mlx5 is using ATS
on the RID right now.

Supporting ATS with the IDENTITY optimization is a good idea in the
IOMMU HW. The HW just has to answer the ATS with a 1:1 TA.

Next, telling the driver that ATS is enabled but doesn't work on the
RID would allow the driver to deal with it

Finally, doing things like using IDENTITY through a paging domain
would be a last resort for troubled devices.

Jason

