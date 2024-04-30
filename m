Return-Path: <kvm+bounces-16235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7898E8B75B2
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 14:26:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2DF08284257
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 12:26:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5835C140360;
	Tue, 30 Apr 2024 12:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Wg4EkaJ5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2086.outbound.protection.outlook.com [40.107.243.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C361134412
	for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 12:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714479983; cv=fail; b=ZfF0Jz6IvV4jcecJPZ9akqQMBRM5iVNIi5t4Z00GU4lNKHrWWbqTHY5MHOSU0rqTTBoL9oZdelZqj0MzHM2ZTyhtH3mlL4GXmbG7iTi6O/sfOofRZiOBxLXwUrGRonf/yFQth1miZwGMzO7MbLSSBqtHrVb1oY2V1c1+f6tDatU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714479983; c=relaxed/simple;
	bh=RKv2pwb9o9n27NvltoufmgV145iCGSNYPmZRb8TbDno=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=aEZOupc8mvBUo44HxjWvjrEYM4YdFtWolln1QTre7/Pd2NIbqVQuCELvdc6fdufR0qM2k3umclYKU5dJJmL6akOIXmrYwqnVhdBCteoOcopRfT31v6I7GZ+3TaPR2IpAwWyKAiml3lPB7m5ZF85LHdO0j10BiypFZEtxORAYhF4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Wg4EkaJ5; arc=fail smtp.client-ip=40.107.243.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iFlrivaiylXkfEKxDLx0vglq62qz8bXINM1ldU9TjA5aeBGxA2UKxCdtbU99ifAgzuu4cAslBKsYKNSLqd+EtU3Yboc+rxudevq/ksLcUy/t1lP0VFx0W1sBVuuN6G7OL53F93GymcaeLcEQcNgKYEJf72RiIH1YjiyjtGZa4EEqz2G2u5dmNTUipkF/uR3VbbUTLyfGrMqrloOGVojTjShK2oZD9wVmbC4lNXytklMiY3y0R+b62NzReC1d4Nvd0Aq/IhYWjC29kPoWc2qIie/5MEn6k1+AnfWMeRprYcI7wc9Mo+o2eRlvq9sig+4TCMxKkcpc/x0HMzzqu/7wKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o5SUizTj7ApEHQlYKv2y/3fVMY4OYKXXpUImGymjpZ4=;
 b=G+5VM5Xgc5XHXj+oSvuM8JKf2GyFrMg432WsX/yMbLNFPVO9DCz8+B15zUhTKyWJ5z+P6IWQoKubFkTJ6s6b9duEUET6s+ceIeNC4dndzpbaB6Y7wBfxh9hc004xKEICcyM1uX/UdFpDN6RDHQ0B8TyF2JVsdr+yDprO9KKGVc0rfzc6kpKORJ3kIjeEzLDeDkVjrTQDVsMOtuo5Huson9cZUp4wJhxQKwnU6I+VJoXd/f1iHJJJf2wOxnitGSzSyJOjXBLAklBnqmGsBKNV145oF1fL5UDmuk5U+WGYxLTzxeFqA7+aVh1HC1fJZuaxONjxtEw5yeYn73RawJgQ/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o5SUizTj7ApEHQlYKv2y/3fVMY4OYKXXpUImGymjpZ4=;
 b=Wg4EkaJ51W9SjCut/fvDpKV/p0iuc2W4IO59DYErfGLJ8VPukVmdrznA4v8VhGhrBYxKucCg4/SsPypVfSv31f14Ev/KQ7YyxT7jAaKoDw0Mn5Yjlj4i7SZZI9wZrBLjsPF7wCVOuaidhLwKP8QDoa+ggCvVQ/ps5zrNQzTDzAB97oROJfhOvmikKcwGm/c2Uz1dcqvsomtyMFe3tF/nxJiP+UeC/iV1bRGsAH6dNHx9RFdAM9/tJXwB1T24BKV4fzSS4SGOBV3PpvprXQHVxt5y1CcuXCO8QXnUpNUah0dEwl7avEqEzQ5qOpBclWeRr6FXZxY8ndEwxwtDTceuTw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SN7PR12MB8818.namprd12.prod.outlook.com (2603:10b6:806:34b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Tue, 30 Apr
 2024 12:26:17 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.031; Tue, 30 Apr 2024
 12:26:16 +0000
Date: Tue, 30 Apr 2024 09:26:15 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: joro@8bytes.org, kevin.tian@intel.com, baolu.lu@linux.intel.com,
	alex.williamson@redhat.com, robin.murphy@arm.com,
	eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
	zhenzhong.duan@intel.com, jacob.jun.pan@intel.com
Subject: Re: [PATCH v2 02/12] iommu: Introduce a replace API for device pasid
Message-ID: <20240430122615.GM941030@nvidia.com>
References: <20240412081516.31168-1-yi.l.liu@intel.com>
 <20240412081516.31168-3-yi.l.liu@intel.com>
 <20240429135512.GC941030@nvidia.com>
 <00a1bdf1-1539-4960-93f9-6290307744f7@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00a1bdf1-1539-4960-93f9-6290307744f7@intel.com>
X-ClientProxiedBy: SA1P222CA0068.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2c1::27) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SN7PR12MB8818:EE_
X-MS-Office365-Filtering-Correlation-Id: 8698e914-bfa5-4d8c-4e7e-08dc6910bb89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015|7416005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3SsjybkMJU/REkMYLkcTgTJ3zqIr49nh99mDiXR96kxn96+kJjYu07HNMsye?=
 =?us-ascii?Q?aK+/hTwpOT5Ozh7O3ZfXbSVkuuN+1yRq4pds9Ont4jR3//ZKdyYbn4r8d4PC?=
 =?us-ascii?Q?nacvViCvjcFIt7nYIasBYkj1RxVEhAeAG4Sgecwxef/+okqBvMZ13W3DioQ/?=
 =?us-ascii?Q?IyMm+BwkCjHsA+LAd9hmJ8Gjeqd61+BI+b5sRl4qHwzhlXu5/EMBeXCBnK0t?=
 =?us-ascii?Q?LAGGKoLdQxw0oa3m9jMWOYeLK4EnIzbZkDmzo9S64RMAvJz3Xs02IAL351pP?=
 =?us-ascii?Q?zr+Ll8IZMPOPZNBa5ovX0Mo7bcfZa+y374oakFHC6/VEqXwliPPyqc3ZcMcJ?=
 =?us-ascii?Q?iJZneReRtlGiv9Tr8x999jJLPOhwNOFr66TiPMSQlsc1rVdISbzeYMYzTYqI?=
 =?us-ascii?Q?YMVrHy0DnumuVwG+nJkb9P85smcrnqsu5GeTQrTBvaLfu1pMUkwss5dT5Fhu?=
 =?us-ascii?Q?lV6Jk1Gf0V2DsEgy9P4OIoJrlev19Au7gM/TUO5bGg2MfA8kUwEGhjy4sTNx?=
 =?us-ascii?Q?4kFiwyG/QZ/tOz/h/J54DSC9jc4Bt+xvA5xKDi7goKzAjOjJ6OzbgkvobwSS?=
 =?us-ascii?Q?DxqN0TxE8uQK8jtb9b+IhJeXL3ozudRFL+RLxOJR8S6vS8cK/9Th0dMfoEe9?=
 =?us-ascii?Q?zrWcNAXl8lPOGCwbvWlwEFBejrCUxpBa65aQIqosNw08J1+MG2rGCx9Hi/OM?=
 =?us-ascii?Q?mxQy0i6xR2/MCNjXrgK3rB6xxmx9L9srLVjCv9p8Dxe+gfQsaEo8BpJpQcRx?=
 =?us-ascii?Q?rTQzRoLWyJ6S68RchqAq3Z3lP9AQXBD16Dk2hctvkHLPXtGHNauzk1G2w54s?=
 =?us-ascii?Q?+x5nZBxFY8rpoWS8aJP51mrebkNrch+cZx734L7Y+JkxptGx43m0ZdNttN0M?=
 =?us-ascii?Q?h0/DpoQ4/ZqztRKKWsvFUftmz1kTE+xVooY/bjoa+F59KelUntkc4Hs4HN9m?=
 =?us-ascii?Q?fGH1No+j+gLiqb4F1Bdx3HqdTIrGxWvYdqAiJRNH3U1VTrP70TP/tKCPrnuG?=
 =?us-ascii?Q?q7V/nz3/deT5uSmt0hwaXWPa4In8HzuxDuhOpiKbqhMxAe6CDIzIqkXufRm2?=
 =?us-ascii?Q?SwLn77ioD3biOFmj8hn2/PACbx9A7tU0qmDbOx/fQ7suvQmviKGy7yJQ0p2m?=
 =?us-ascii?Q?4L4KEf9+0cDj4rwsTutrtxP302YtMq7AH5ydgY9wwY1H9tTRlEvSKeHdeNYQ?=
 =?us-ascii?Q?y9qqxp+cHW90cXjopgFJ+y9SiNwRKm03csD/w43O53ocHTKeWxaCP3wAOHzW?=
 =?us-ascii?Q?T7HhExR33XpzbPowMA7ihzz71MM1Q/AY+LF11jUOlA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?60j7GoRZpt3FE7qmf+Q937lklpBkzC8EKeIf9LEzTPD3EsTRllW2vKfD+NbX?=
 =?us-ascii?Q?3PoLtWbYj9PAW2Ko/d/hwBv92F93cgn3gP4WMQ3aKsFmg0dymnCNUMU4HN4O?=
 =?us-ascii?Q?cl5EaeO1UGM3c+L3xKmaXXBSSDYZuOZy9X0jZCPHiW2bPVsi6X3E2AcoSP+7?=
 =?us-ascii?Q?TRyRvKpvngyz/B3HiuoptAQAMZX8+FnKv3oXWdu0ddIQcrSIOqPGizE6/dk1?=
 =?us-ascii?Q?4v7jOfn7UrhlVUUiYu/ttrPNcsfaFJHMhYWS2TdosrTV2lnab1/MgRmrhW6P?=
 =?us-ascii?Q?XNbfstZLTa0nA8Hp4ae+xmZ2sgnDi2JLePQNkVQula5eYRbP8u/tEExb1RuJ?=
 =?us-ascii?Q?B35Tz1YgxtiIC9k/kYlTWlUgn/bouz9RqFNPPLCgE2Vty3GuUqEWVNAHqYB+?=
 =?us-ascii?Q?zTkmUTE1H9sUkkO4Z1Q3sIQT6FtMawD0y8VzIKTtWipD7Wvaw/3GB2BQTMzz?=
 =?us-ascii?Q?Nm6bC1mJ4yGCWHzksHr82vCBFmgPtPKfx4RKFqtB4Vbm1so5/LFNvXTFdaIs?=
 =?us-ascii?Q?Tmi8121iSCwQBxeVyEFB19oDpihprC1seNKboyVN1dZgO9dLwlEwd6OmFeae?=
 =?us-ascii?Q?e6mEorZ3P+/zDw5+0U7X6Jh7i1CFvsMLa8nQhY9oGv25NwaXp2UH3KJUITIl?=
 =?us-ascii?Q?+9cEVyX5CaEDfyLG/KloBsxjTm1Ratfscnt1rXV6RiOqLqBNHfEr5KSC1aYw?=
 =?us-ascii?Q?0SND5tTUqbCxSkZEJEux3v/CQhvV/cFGgZt7gORbmyhkJg0I59KUlgK03ReT?=
 =?us-ascii?Q?2GxYsK07vpctcxHQzeTtNVWLMaZnm/49XM+WNhLrVL1qYX4J2h+65TbeHiEy?=
 =?us-ascii?Q?gjWrbo5zF/VS+ImvqFROWixSL2a+avF4gI+J3VSLXW1G+s+Or1UIi9HTsmJL?=
 =?us-ascii?Q?ik/sWnVPIwRvJbKznZmwocq4+xGAQrkV7AngvlD6OP+POT3PEhPgW6afIpVv?=
 =?us-ascii?Q?9X+ayn9ReiK58MMGqbHo4cjfzifQJxIRRjVpIeO3KcnfsmE/N/aiN/MC4ObT?=
 =?us-ascii?Q?Kb5ktNU43XQExtyJJ+ThzN/36H0qe0AyX+VLK18nwIl1h4ll3okCADvejjrx?=
 =?us-ascii?Q?k1+I8TXIRWml8yRbpGmeiKXNaQQvcgt2iSQzBGc3CFNyb3j4I7KPGj9zOPfn?=
 =?us-ascii?Q?vQb+niIQRLcWTWge1bpM8/Ioa0IOVqyW5z/puwyeAZs7npRq0XxFg0mnTyjD?=
 =?us-ascii?Q?9k3NoiaoP+Dkg8wjnECDg9vaRCKmT8MphJDw4hIYWLqwgq/TvMr0p7UDYfnV?=
 =?us-ascii?Q?e6JdOv9atywHqRw03Tf/PenUbO+MipTAHaUXA+fUES+giPxMRuRrhvFJK/eg?=
 =?us-ascii?Q?NOF0vFbnzyqIpyRlEMpKiky5tP/zhJD9U5p31JjmtFB9ecifD9n0VmALF7lb?=
 =?us-ascii?Q?TGigijlCOAc6qYVAOt61ajqAxkfwVbdilt5G6VMJMjU/abCniF30/6cA34Wu?=
 =?us-ascii?Q?I/g3iBx+nL8fOofmP9T/wSLGVnzDfcyMaqV4ZeBQ5fDsMd4WcQtrcVlKex2i?=
 =?us-ascii?Q?GvQNbHn4UMZR72gSrKavQ2Lfr1fD+cTqBLIXM6CLLDqKF2VwVCDN06PkKJ4c?=
 =?us-ascii?Q?y9teAiuAV2SgQA/FR1Em1GvyL4Yg/9lL+M4JVhK9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8698e914-bfa5-4d8c-4e7e-08dc6910bb89
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2024 12:26:16.8151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jyh9cy6QC0t/PUca7SJdmFoMpQMDNyDhTsfSpSdphgnFPtPX+b55Z1i+GUsWRlOA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8818

On Tue, Apr 30, 2024 at 01:00:57PM +0800, Yi Liu wrote:

> > There is nothing to do about this race, but lets note it and say the
> > concurrent PRI path will eventually become consistent and there is no
> > harm in directing PRI to the wrong domain.
> 
> If the old and new domain points to the same address space, it is fine.
> How about they point to different address spaces? Delivering the PRI to
> new domain seems problematic. Or, do we allow such domain replacement
> when there is still ongoing DMA?

New PRI could happen an instant later and hit the new domain, or an
instant before and hit the old domain. It is fine

> > Let's also check that receiving a PRI on a domain that is not PRI
> > capable doesn't explode in case someone uses replace to change from a
> > PRI to non PRI domain.
> 
> Just need to refuse the receiving PRI, is it?

Yes

> BTW. Should the PRI cap
> be disabled in the devices side and the translation structure (e.g.
> PRI enable bit in pasid entry) when the replacement is done?

Yes, after domain attachment completes

Jason

