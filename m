Return-Path: <kvm+bounces-15119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ACBE88AA0CF
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 19:12:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 640B128276E
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 17:12:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34D3F173359;
	Thu, 18 Apr 2024 17:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pEfE3NU7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2057.outbound.protection.outlook.com [40.107.94.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C932016F911
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 17:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713460335; cv=fail; b=N8NFyNKZSU9RcD6bdIst+oCckGZ1aupX1GngH6kS3YXn0PuOoU4AyVPyaC7CLiTwLoUvNRsQflL3yl5Yj7qrvVuCRySBaGqJh0e8IHtxXNrMt6u8MKJTfHd0eTJDPS97O3GU4g5bcnKAgyYNoT+RTK54Y5vjoiTQ0HqRG7Mi22A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713460335; c=relaxed/simple;
	bh=ihki8Blv9xztFKh4PwvP3Jpdzt1t98CwV93dAvJWd1o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=P2THcoDNg9riCMCVEOZaJekZ8C7pCqKPhh1/S7bq0eHg/AUIr8uUlWBWizJGzzjoIdggdE3jtLZB4uXfEZYRVtMqX8Ldgs8T8qSKrTlJc1gr9K8Yd4N70htf33PRpxhqQQRK1jizMt0OfsQyPwdGOmheNEaNpIznV/gBg07jiT0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pEfE3NU7; arc=fail smtp.client-ip=40.107.94.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=erNxzpBfpEdwX5js2dN7eTElur/gLBR7mSTpAm6u9CVciku9miSUkF7kBYDV8oyU8xBRR9cS522VSiUJqNjgMC2tkt+xyqQy5kq2LMrJDMAG4XbINC2Zl3FMBL5rNJrTr5DkKb8LGusak5bzS0dS9M3l+LsGSCbGz4idF5QaDRPgLfeTgBV8q61xCAENbigMxXeVFyNMrDnouZB1JLP9uI5qqa3eDfkpxyYxSeuf/ggrYW6bXCNrh9OYJLmaT9gROHw2KvHz1T+vAe7btNDfMk1upgF+8zy2AtHIXUdv9jkaapCmoAr2H01rhz1OLLGY2JjXiidTZzxYx1NeQ2H+EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DGr/pnrLGWingnDtjK2nXJbIOz+vAt/9uTeiQCyQ1ZA=;
 b=ih2aeraU1VfCYU9j/EjBqdP8gSs7z1g/WLHm4it9f28RuHpUSAA1ODuKV6yoxv53JobZTCbDvF9YfmS+pE2KlkBth3aluN66m04AGT2dma/gPcYHkvrWwrwZWiaQqtwQQ0ZzX2BSaGCyvQtaufkgxstqYSGu+otWjunxrHsLsRELEpy+j/WejEzhxSZo23IgixFBIuon/HgsDL+NUWk4xJwl6g7JbNgzP4r9NvJv+/ivvsZzcj2ghIlapPBcRQd8QlhiymXCKegMT09f++RBy9Q7vh/tJ/k3RtAtuIMHJU1mfKMYUOtLKpdC4PYxNmeGBvwJGGlM1DjHw9HO6LCnbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DGr/pnrLGWingnDtjK2nXJbIOz+vAt/9uTeiQCyQ1ZA=;
 b=pEfE3NU7x0RuxaGDu1qiwYGwlL+Be9xXERxdnIja0yZB21OLK1KqBozG4rQ9ghilmdX8nceKeHwoathOUbCwWtEEGrFrF/UvXkCjkGOjfrMzwOl0RTGLhdnrZFDhtzNLDOv1RAW3iGk62Vn7ktwIpQuE1CcSB+6WFBRJ8x0JHtc4pU+Xfluj1hh8cAjceC8Ub4a1sZtqKHQl2rHluSjKctZ9CXWfTRuktHw51AyHBMkem5XBSLgo1vFhEeJfy19SZjQduWdHxAIdmTrilCdeDLF7H3QsIwI3I34oP+2k4M0cJRS2IS32edKUfepP2zsme51JnfRLWvnG9mcRguTlVg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SN7PR12MB6741.namprd12.prod.outlook.com (2603:10b6:806:26f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Thu, 18 Apr
 2024 17:12:10 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7472.037; Thu, 18 Apr 2024
 17:12:10 +0000
Date: Thu, 18 Apr 2024 14:12:08 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Yi Liu <yi.l.liu@intel.com>, kevin.tian@intel.com, joro@8bytes.org,
	robin.murphy@arm.com, eric.auger@redhat.com, nicolinc@nvidia.com,
	kvm@vger.kernel.org, chao.p.peng@linux.intel.com,
	iommu@lists.linux.dev, baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com, jacob.jun.pan@intel.com,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2 1/4] ida: Add ida_get_lowest()
Message-ID: <20240418171208.GC3050601@nvidia.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
 <20240412082121.33382-2-yi.l.liu@intel.com>
 <20240416100329.35cede17.alex.williamson@redhat.com>
 <e3531550-8644-4a7e-94bd-75bdb52182be@intel.com>
 <20240418102314.6a3d344a.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240418102314.6a3d344a.alex.williamson@redhat.com>
X-ClientProxiedBy: DM5PR07CA0059.namprd07.prod.outlook.com
 (2603:10b6:4:ad::24) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SN7PR12MB6741:EE_
X-MS-Office365-Filtering-Correlation-Id: 568b52f7-5520-44e3-3a53-08dc5fcaaecd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	uW+AynhnIkX+9dARjC6m4Goqiit/k5PMRTnd2gCsfj+UJ8U3DyjYU79A42EkVf4NNmtoD2qvN3loeBkkyqKmarcg0Cbgo/k4M0vdGVuaqzLtVG4GwRrmOSNcC1q3QKi4YoCan/YqHncK5XzHaZH4ySlTiR/rebjs4IyKqaz7LpDpiB846AV/6T3hwytcZ4pmpDUrwsId4cjj3+S8/Q8q7LoFJwT7bWHSUo5ThSDvxuV66wmputcCL0TYI80+hNYrfxFiAJTdTOf1sWifo1X8NX2SZ1xvuitcOpsvRXR49Y5nJDl/2+5Zf8SyfYHy/ACKV1ooEuHh6CxfzuVWJ+PbWWSfg9T8yuJR4NjV6fZjKKVkriJmSpK0X1EJYiuGyTL9u5Y5pNGgjydxHlMNNidxNXT6LPf5ZLNMWRRJByhRN8JRuKvXGZ/SW8lJ4haJpMMamNzxNFpK8oPswkDenKhdKJbdazdlzzHnSCSXbxasENubsfyvtFVne2QkoK1Cwo2b4J3UeWfNOrqlKtBxVIeD4+yeh0XMUbN3/w/3q9va6hqXleEt7LD0mQPjDn5137UIFqFLGQFyVEjEOpsLlAqmjsxF/EfCdsLtsZTpRxcmBnMtakYqiH5wQlTSlz/XHB7Kl+TSHoWP3MvgsQ3+c5PhpF/fjHIqAw7KONCG+2I6wTg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7TVukMcHGMPQ6vpWoMowhT29CLN2F93Pr5FasjbwsM6ZCBPTO5YgovxFhzyv?=
 =?us-ascii?Q?Vv21cEQwEu5QaqmVytH2lc1hi+tBrqgq/6cWV2vcjQsAiaPoCtvTTVk0VOBf?=
 =?us-ascii?Q?uFtOSXcHNlWRviHck2H8hfjAmSp7PEk5NvSluc9ftDOb5LQr0nrMthDHwMXB?=
 =?us-ascii?Q?8keaxHXakr5o9wofc0iUjeIiq8DMIiZPWHvIe3/LYTgLE3yYdkXKdEL2bag3?=
 =?us-ascii?Q?BCel24v/HyU8T5kJIuzuTw5nB5iJkQo/zMdwvDU8jQSzUI4dNfoSitP46Cv3?=
 =?us-ascii?Q?jVfqs7qLTeb8h2gL+twV/CPEHbXF2JWa15/EOr016RtH1rMC05mpynLcimDM?=
 =?us-ascii?Q?IQ8UC6z211h6th9Yy0aXLQRuoJzph9pBGyqZyjYvk7I+mgc71txsRcoRnseo?=
 =?us-ascii?Q?7rWyJn/1ZONSC6wrMjgXnDJYIc+eCHUOI5s77jzKmA4N01+iOOJcqFvU6GME?=
 =?us-ascii?Q?UyvDRr70H2AwsUEaRnLlQGDp5SdcZA7Z/92z0alM3Do800Va7ZP5cu2U1b5z?=
 =?us-ascii?Q?wbMGjFx4K4qYjm+guR7W7J4OtRi8FM/zv9/fjg4VheKJuavCL6u9AYt0RqTM?=
 =?us-ascii?Q?uptw71o0Tra3vpnce3FS9pn6IpXEqI05lvIPD2LwjiiNm1/uYkOXXK/aD5Hx?=
 =?us-ascii?Q?DDJm3V1/uv0ZbEct3rsZaIFk0NR1Se5uzikNMyFwJwx25RhxRFYiexmxI60o?=
 =?us-ascii?Q?uxae2Uj3JnSfuDFtqiTTTE36pz3BPF8s6Yc8jDdr7YYQVbaTiBso+BXAKYLx?=
 =?us-ascii?Q?1eZwrIFhGkLuB+Pj3RAj2Gzcr9qK8A/DbGs+J114Iwbx2kyZ2lNwEgNbqNeY?=
 =?us-ascii?Q?FlXI+XdA0Mx5bbgxqw2jEm+ltiHoy8qDx6S1JGJ6WSlahAkYiQOtltTB+/28?=
 =?us-ascii?Q?Zt6hEMC179IuvifFB8BkT5tApm72p4SzePRrCBnEhUfiV6FIjYUfDmn7oX2s?=
 =?us-ascii?Q?yyjR6VLRPsStKJpeg7VnVTUM84IhvAIcjn8YKFoYmR/kY5Ow8ZotVAEYUN1i?=
 =?us-ascii?Q?wkzV85siHTegSso7o+RNuZabIro9ITLcUynXwL5feCXo6yWCRat8waPPEop6?=
 =?us-ascii?Q?SxY1HJtQwzOhnYruiiKjTMIaYK7N6lY215foeEz5XnwI2xL828mWfLUkTbob?=
 =?us-ascii?Q?+rkpLI8lwsOXny+KPcXAu6u3kkM2VBb1G+1jznwBLn3nM8z+a+8mavcBdu6Y?=
 =?us-ascii?Q?Q3HjRftXPfQV1k3wlSEFZGhxHdEX8IU9IBKBSYcBkUfn5OPWXTkYyzTVt7bU?=
 =?us-ascii?Q?CmN74O6s7PltEcOqWt6by0OBw7EQzLStuqtUkwHsAVYDLBJtG1mm6j5PVcoY?=
 =?us-ascii?Q?efplbUW28Q2eSszU7bsMd+OqF0PcBSh5OtT1CzfPTyJnsbQuo9BqMR6xHn+r?=
 =?us-ascii?Q?qlU+V3pfcwgJ+LgcDeOXNpHyBZbY0JJlnrpjTg1fB+nkBVG3RVQt9YUmT7Al?=
 =?us-ascii?Q?zrf9ADKs+BYOvgDazMK18pyrD5xEUoGqghYt8pWYaXh2jK/91N0TNbobtoPK?=
 =?us-ascii?Q?ZYjTQy0VlNM70IMXEfMIjXRhJDeaHKu1400WKtV0zPLN+UzlVmitVche40OS?=
 =?us-ascii?Q?mF5Us084vwFbBkEISD+BjfQJZugsfdMnTnEzuOnX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 568b52f7-5520-44e3-3a53-08dc5fcaaecd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2024 17:12:10.1453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EDvfAkjkmERq0C/aH50jx/4ZZvKgoeEKfINIKXvmdOToFFpnj2Afir9VWaaE/Oqx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6741

On Thu, Apr 18, 2024 at 10:23:14AM -0600, Alex Williamson wrote:
> > yep. maybe we can start with the below code, no need for ida_for_each()
> > today.
> > 
> > 
> >   	int id = 0;
> > 
> >   	while (!ida_is_empty(&pasid_ida)) {
> >   		id = ida_find_first_range(pasid_ida, id, INT_MAX);
> 
> You've actually already justified the _min function here:
> 
> static inline int ida_find_first_min(struct ida *ida, unsigned int min)
> {
> 	return ida_find_first_range(ida, min, ~0);
> }

It should also always start from 0..

Ideally written more like:

while ((id = ida_find_first(pasid_ida)) != EMPTY_IDA) {
  ida_remove(id);
}

Jason

