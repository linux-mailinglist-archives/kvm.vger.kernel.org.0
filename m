Return-Path: <kvm+bounces-14528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34A258A305A
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 16:19:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 63B1BB247F1
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 14:19:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 998E986AE6;
	Fri, 12 Apr 2024 14:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HKlOsMAu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30625205E22;
	Fri, 12 Apr 2024 14:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712931571; cv=fail; b=o9ggXBMy1GiekpjqG7n5hsat71B80qXayXNZhLY+WERdM+o/DjhQMS1aTpkNq6xNtnBOjDdM4Nog7aYlGWgS4KFrXS6VJRXharewi7Yzf+dKKS5ADNFKiNLEcA11sD9lr043lc/ajyZsg+jr6LC36j18stZcl7flsSUlIqLBX68=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712931571; c=relaxed/simple;
	bh=fXDI1CbnL6LbdxJEWoxI0CRD+tx/gFeBMyQXbK5bKcI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YAG5obk2v3ZoLTezsPN/ksLneFnbIaZccnwaIjwIxwB9UKC+xrEzdUgD972/A2ww2ySIhdz2TRfFZZW6qyBynkc0mHwojfQRwCpQNDYMx5MZKukx8pPFhvXqZpzn1In0HggUp++e+SBU/2jyAwsnX6m2XzLvQNRInM6Gnuoued8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HKlOsMAu; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712931570; x=1744467570;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=fXDI1CbnL6LbdxJEWoxI0CRD+tx/gFeBMyQXbK5bKcI=;
  b=HKlOsMAu1ecrtsZWkPkjhKO1KmlrXXRyigcYWR03fc43XhX8vp1wtkml
   cgRlYi5jBosU87j8xOL7B9yVqyh0/OoiDN6xblUBOxV9NYdGV21zGa+G/
   Xsy7G1yewqixKBscBkiah0wDJDi3gdQp7hGJAohu/xBMwT8FayPBWQhok
   D2xcmNFwxBq59bL+3dd1Cbg7RL84ssb3wKIaC3NjsO6XXes4T4UzJPJ8u
   aeL3xS/UH7vl5eQW6dJldy85Dic1SIRZy4n9lgl9FzhiFVtYtJl7jEvC/
   uH7UcV8iepo2TNLp4fsgZdNumLePBBfUnYLvXU83MeryxXkcq26hE53wG
   g==;
X-CSE-ConnectionGUID: EFBcbWG8RTC3FQvyZV39+g==
X-CSE-MsgGUID: Ab0Uqtd8S/67jys/yuiDMw==
X-IronPort-AV: E=McAfee;i="6600,9927,11042"; a="12169875"
X-IronPort-AV: E=Sophos;i="6.07,196,1708416000"; 
   d="scan'208";a="12169875"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 07:19:28 -0700
X-CSE-ConnectionGUID: CAljDWayS1au+7WT9bDYEw==
X-CSE-MsgGUID: 1weFsEeGR3OUQjXDxZjN2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,196,1708416000"; 
   d="scan'208";a="21314424"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Apr 2024 07:19:26 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 12 Apr 2024 07:19:24 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 12 Apr 2024 07:19:24 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 12 Apr 2024 07:19:24 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 12 Apr 2024 07:19:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MuT6wxZcP96JuVyCj6XB+BLo1//XnY/LmiLA5pxUD9TnozvWimecIXTL7hZ1Vs0VRWktYEPEBpDXPyGoFP5nMMCyPmN5e4v3hjlhQ+lt1SQHCTHFEQOqHSuqPx0aB895Qs2CriS7/sbphEX48jdMmzlVuqfbWP1bgulaNUj9HZyaghr3ciIEqXoClBsYt0njhoPme2Z94xdp7mSAfoWEvqFpDIVHPAJ9vHmNixrvDAeghrgpLLJk7zlMgIeye+0TYF7Ahr9HHPg3f5hRwVRcj5pv0Udvo0/rZbyLxksbiElIYk4pbfkiskvl4nfKKF3oc9fEghIdr2soES2y5fYvHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f2g2FuUgmd1OwWmTsO9C27BJWr3nfpy5v8avH9G8/3o=;
 b=fAG6evHeLSAN4S64h5REos3boReaQN0gWxbnvE8nSXme+sUf9gwpFaEO/PeSOVvUR9qSj8UROj/pjY/0t+QiM/jhlkJabos2ZBBQHuE4oB9+nDnhOHe+MK4E1n/M9WQnpGkAPW3umsIWFYk4gJvK0Rp7EbjcPJKyDFnb//jY/2JRQG9xyfNBlDZPSdTE9SNP8ktJiLxr9uOqkXXywHGZbxYHUb9bGxRyCQZuCLePDt8jc6AC1xxucM/zciick3rmfBXEqTyrMGAbkT1BIxwsZ+AVKn0WX5qmiVnQlzobJhYB5MwHZxW0tgv5OL6Aw+4Et7j//Gyhf6yFRftkY3VUQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by SJ2PR11MB7476.namprd11.prod.outlook.com (2603:10b6:a03:4c4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.26; Fri, 12 Apr
 2024 14:19:22 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::90e5:7578:2fbf:b7c4]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::90e5:7578:2fbf:b7c4%4]) with mapi id 15.20.7452.019; Fri, 12 Apr 2024
 14:19:22 +0000
Date: Fri, 12 Apr 2024 15:19:14 +0100
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>, Xin Zeng <xin.zeng@intel.com>,
	<jgg@nvidia.com>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>, <qat-linux@intel.com>
Subject: Re: [PATCH v5 00/10] crypto: qat - enable QAT GEN4 SRIOV VF live
 migration for QAT GEN4
Message-ID: <ZhlC4lWg1ExOuNnl@gcabiddu-mobl.ger.corp.intel.com>
References: <20240306135855.4123535-1-xin.zeng@intel.com>
 <ZgVLvdhhU6o7sJwF@gondor.apana.org.au>
 <20240328090349.4f18cb36.alex.williamson@redhat.com>
 <Zgty1rGVX+u6RRQf@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Zgty1rGVX+u6RRQf@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DB7PR02CA0018.eurprd02.prod.outlook.com
 (2603:10a6:10:52::31) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|SJ2PR11MB7476:EE_
X-MS-Office365-Filtering-Correlation-Id: b67a0cdd-6887-4879-c68d-08dc5afb8c61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CzOUjQYpCJVeccyEgMdxCJc54eOKuZJPndoVfVGIjtXMruem4Q9wUckwbNIX5ThWAQT+uFBG5CmcNjmKA68vwxE9Jm2eu0CFJqb5aIbSZ8bpGl2Sm8G8B8Ivxe09amC3uy5e22/5aN1aaMdFRm1ZrSMKvb1O4UGM8iNHV+YJiZyWlKjaAYEHAWP6TZKNLg5AflXB/cKevOdgYa9ZxAi3RxQ5ymEDpR/RBwGTN8V6lU8Q0NUQdPBSSwPQuVjxeWZBRzlNfbdwp34q4bgZGOavHUVeOCYKTuqnpKj+WXP+FA9N4Q6Nprhc2vTH9cUE+jbFd2+RaTf8MlCm2Rkd0mpUpVx2UArhppc4FQHmHIYw99be96OGgGqQJ+5Z32All2VpieH13gzVsg5IWz91CTCtTtqROiVCIwzXbYVQzbHWNmJxW7uojCqZFETFutQC0HpWpQWVFCpz+j714sWlQqtGxe8pC/5yJKFXNCbJBHF5jGC2oXojjxDhjQBUUQnCS1HiGzU09mV+A35aIZIylLAtSZiAqOa/MzMTmoDPY14WvSD+6AmPQszADZk2wCTbLrwnfHsrbsEux0L3E7ZY/wwLQEcCn4WjUXNIvz8vmFIeikuHOOSaKHpWzRPRIJUyIhhe+7wk9fk3HEsKES4fAfXU8VarC3ARB10gqfNxUYbSKO0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9CBi9xpAocgxlR17+IkytLRy6TPoCW98xAuDVGek8lzZ0yPjPqEw1tVdcssY?=
 =?us-ascii?Q?E6TiYZOaRybpBE3rbm6JFhSY3uED0bqnuwHcOks7fodbu5GjqCvMx0r2VVej?=
 =?us-ascii?Q?oqEwjTPamxvTMAaCdlYSR4hrI6l/AbtLN2M4/ayyjIeGXV46v1kBv8tz97jm?=
 =?us-ascii?Q?XUIBgY0vsc7PN7B1Pp6WuItyKvRXCpvz295aBOExAFl25zGU+J9dya+GO0QF?=
 =?us-ascii?Q?PqybiBN6PWbI8PIlXdsldUNeKNn5g4y6sNSgQAxLUoQvrNxgBcNwmRl1mUln?=
 =?us-ascii?Q?NYQL4dfGD+NGxWkoS6DofD3buYnbfGXq/MIrPPFcbYZHxp9RRT9/0+2kXj1y?=
 =?us-ascii?Q?8IynJIYgtfxmWtmyD1otVMGSytDzEPQ+4CvVMsfFz3jJ8+6ps4RJJHGUryjK?=
 =?us-ascii?Q?Yb7t5BIbIKmn5lblOBI0nv45Ce9kFpR/OBUFmJ1BybMi1P8Xlr/V8C7dXIg8?=
 =?us-ascii?Q?v5TuBIXsik6VOdyX7GbhQaAmaZyCd8mlj4o+lfVuwYplZBVZBRHDvUIvG2Fy?=
 =?us-ascii?Q?2QJ1wqKysMt1b3bbaTuVRSlrHamNxEZy6MEN+gfGjQRYE4aKSjVDr+AEc00O?=
 =?us-ascii?Q?NQJYbrg8KOEwkJqWsAXhgYxhjOOjFUJzX5fCE+7rvQz/fHN3M/QL59qoeCII?=
 =?us-ascii?Q?82IBjXcgoxJEIvUe5jglyxxqCroxTe2vvYEX+K7Ngw5iXtUrnNLVhfXu5k9e?=
 =?us-ascii?Q?f+1SVDps9NSZwRLf9Aip/Jhim9etSBp89B+k5nsyxOVHVH4+y6hVQ3hEKHIn?=
 =?us-ascii?Q?P5Gwhe/gdPf9eG3Q9fLv7K6l3kW1+IB34O2s6xNvnbQqIgFsiAIShDBPNeNH?=
 =?us-ascii?Q?lALENhl2JhaARo/52uK3eDVuBXghuegt9G/UcfMdk4xzP2feh3rqvELg12bZ?=
 =?us-ascii?Q?/63zn4MPmQ5bW0s6qm4l2dQhPZMae98V119YE2hPcH8aY5asgen791eXOXii?=
 =?us-ascii?Q?p8jp5bMpBkHMR6zoNJqAuDXk3Y49Hslso881expOXa8KWnLzJIsKNj9K1B59?=
 =?us-ascii?Q?BAgkToBlSiWUWRtDo3Yuh48gz3jTxJYF3fBH7Is4qlZywaJ8/fd3RtIY9DEs?=
 =?us-ascii?Q?lsvXq6gk/CSIBAswKb6AHxmpI/MiwatQuolxlPOaDwsXq3sCoQtxMoi5yAbW?=
 =?us-ascii?Q?RKn1o/s/u2GUWLPOdMsaBC04Yrg9xlYw6k9vWapI5wlf7VyNGR1TFrKveJQ5?=
 =?us-ascii?Q?Rpy+RFxa0bBHR60gX3ok+kewlvyynK+ytl2LexrwONDCxiPV7xQENsYdrexa?=
 =?us-ascii?Q?ZVbAeTZAK96knDXxkGFoUlgOOyWw5V6g/NofzOyJ6I6kBmXlY1OlERrexyI9?=
 =?us-ascii?Q?TMeSMM4PXgDbP0jGz8U9EiuHVzCu+d4NQwpUwQDXsS8OS+vDdyCuKIEF3nlx?=
 =?us-ascii?Q?uCA8dyAnPIazudomW6F9nXPV8uE2w6GwG3u7pJbv/lhBU+moH/Yp1ddhLk0T?=
 =?us-ascii?Q?bnRyUDyV+AWgV1NRkJ8Y3akvzQpWjejTyGIMmTT0JkzS6yvbsgYBybiIQ0iQ?=
 =?us-ascii?Q?ojJKh06B2lgGLKSIrazoY+OSW+ZOJLdwksmdyaniu9J6INtDSd2R5w3eA8AT?=
 =?us-ascii?Q?j8Vr0qs1Br+whEowLkOpu1a1UbhylgqeKaamg8iX+x+XKRIPU7ZWejZU3wYW?=
 =?us-ascii?Q?Dw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b67a0cdd-6887-4879-c68d-08dc5afb8c61
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2024 14:19:21.9408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4umI5JZoqztiCyfEaxuX6ZtMeCIT9Sw4iiXzXNx281jcaZXoqMLBgMARlWmzZtgL4PbIWXf3Y7FtROsDJkUn3DAzv0qq3h58y7Ke0n7iudE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7476
X-OriginatorOrg: intel.com

Hi Alex,

On Tue, Apr 02, 2024 at 10:52:06AM +0800, Herbert Xu wrote:
> On Thu, Mar 28, 2024 at 09:03:49AM -0600, Alex Williamson wrote:
> >
> > Would you mind making a branch available for those in anticipation of
> > the qat vfio variant driver itself being merged through the vfio tree?
> > Thanks,
> 
> OK, I've just pushed out a vfio branch.  Please take a look to
> see if I messed anything up.
What are the next steps here?

Shall we re-send the patch `vfio/qat: Add vfio_pci driver for Intel QAT
VF devices` rebased against vfio-next?
Or, wait for you to merge the branch from Herbert, then rebase and re-send?
Or, are you going to take the patch that was sent to the mailing list as is
and handle the rebase? (There is only a small conflict to sort on the
makefiles).

Thanks,

-- 
Giovanni

