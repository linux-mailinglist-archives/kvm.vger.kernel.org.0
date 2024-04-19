Return-Path: <kvm+bounces-15285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E420F8AAF7C
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 15:37:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3AAA7B247F0
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 13:37:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E85E312AADF;
	Fri, 19 Apr 2024 13:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LeMb8iJj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2161E867
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 13:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713533811; cv=fail; b=NhIXxI26yMNsV3TW4SIdJsN17NngITJSkEsU4QT0p++iG2I4RXsQLWtGDKpDIU0tGDp4lXQWMmG4ZJ1m/kuM/2COOCacUA44ypA2mAYvAewyPu7FFXDQ2FqV/bARFssXicEJFahOB+tLBfuT7NJLpocgtXQSOz6GRSg381tRnNQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713533811; c=relaxed/simple;
	bh=zDAixs8K1GPal4WGD7GRlWjfA35YBxeKaBUPjCYBKS4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Cjos5ZZVf/7V0Q3DTzB4+z+PIkD2CC2+PJYeFXX4fz5GCoiISStLDNh0fiqZ8b3cf8YPFq8o/sYX1DzU1jS09O6hxqSpK1FKkzrODbqNZ91Zld/BIrByt1qSKg9P82yudvIPU5E4kvAhUPySdqFedkmoIAPmCTpm7sigUe3b/1g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LeMb8iJj; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713533810; x=1745069810;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zDAixs8K1GPal4WGD7GRlWjfA35YBxeKaBUPjCYBKS4=;
  b=LeMb8iJj7epzAm1zcQPRjw/JUNpFEIpGJA7bL7CnrSiBGrSKyTtmplk6
   rJGsG83+nS/tr+nKRBEgTWgfk7IP6yya3axt//5gIpYRIJczGxxD8uhEA
   JDjHXMAc3zbc9lhBDQUPRikyg8P2BENMSVZoHj0EI9956mbNTOMBA/Le0
   DCmTXif9QLneSOzIt8ny+OGohYk7U4kqnzUl96ozZ7k8kA2NybVcwS2oj
   IlrGffznq0CgoTcpmyfwMZljz4PecinP83WKWi895RhQUA6TpCtZZIOmc
   mjusHokVFJI1rcv5yvo9+6ktViFCotc48cT0QKJc58LLJsY8SR8M3Vc8G
   g==;
X-CSE-ConnectionGUID: t8Cr9QuQSCe3ctuct/vcRQ==
X-CSE-MsgGUID: dronv+SZT0y66FIxh0tVKw==
X-IronPort-AV: E=McAfee;i="6600,9927,11049"; a="12915148"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="12915148"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 06:36:49 -0700
X-CSE-ConnectionGUID: xRPDpmU+SQKdnu2Oz/a/Mw==
X-CSE-MsgGUID: QNEiltuTS02Co467PP5nXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="23774974"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Apr 2024 06:36:49 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 19 Apr 2024 06:36:47 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 19 Apr 2024 06:36:46 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 19 Apr 2024 06:36:46 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 19 Apr 2024 06:36:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TGfwIKbxXzg8kDQaraTsKQb5dO5wnLDLhjQ/zvG7DM3gdQ/x/HICOL4zH754DqucxjypIUl9au5BxU3XdswaXggtn0OGydO3DWotR0NbQivAH4nwLjTvdSSgzZcQ82qpB9BF9ndz0Ad8yO+3cpB4RUuiJSmCmtGo9cOWDsBPVKUmx75HoOvKI7ULMGYz/9HHZa/M6UX2qbNojXmpoulFsLqgumi3rf9366J1yUMCamacUgLsMfxCFPL+y6npqnlOjQZF4hqt0i3Y+FaQxxRc2qXkOmR+CutoLmQhqJD6d9sWF/fh+/y35WYLdi1AP1sapYxnwqzHmCW2wp/7z9PjBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S1/mV0kM9zw9ZjWFHe6SDmE8SYerEd2caawyAhpkDuY=;
 b=ews6umKprUH0WK/3aMBRgbg+8HHvSnDA6Sl1NGo3/Twj2svQLSa+XDixAcl0/U1JM46GuvUR9tlsFG/mntjweMgN3vvoKa7fteevG0P6OBgYIcGcu2mPF4qTiG6B56Z2BQdI8b7+qw3CzohbZaZin3wsYj36dsjFJeSYZ5wyuOSMM9lL4x+3ID41axhe/SrctJnMolQ0XscyF1eosdmWLPiW2eks68SC+lcuFuHFH5b1zc/aeqQdAT4xCYPTUPyIomjuLOJPHW8bC9kEYBJkIp9fImLwLl8jcIzXffQvmVE1Z2EsVN64/UyqeoebXfdq3lWQ+gFbbnJdFWPx4kA9iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BY1PR11MB7982.namprd11.prod.outlook.com (2603:10b6:a03:530::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.26; Fri, 19 Apr
 2024 13:36:43 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%7]) with mapi id 15.20.7519.010; Fri, 19 Apr 2024
 13:36:43 +0000
Message-ID: <0fdfc92c-d5f6-4669-a80a-5f25edee8e3c@intel.com>
Date: Fri, 19 Apr 2024 21:40:16 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] ida: Add ida_get_lowest()
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <kevin.tian@intel.com>, <joro@8bytes.org>,
	<robin.murphy@arm.com>, <eric.auger@redhat.com>, <nicolinc@nvidia.com>,
	<kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<iommu@lists.linux.dev>, <baolu.lu@linux.intel.com>,
	<zhenzhong.duan@intel.com>, <jacob.jun.pan@intel.com>, Matthew Wilcox
	<willy@infradead.org>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
 <20240412082121.33382-2-yi.l.liu@intel.com>
 <20240416100329.35cede17.alex.williamson@redhat.com>
 <e3531550-8644-4a7e-94bd-75bdb52182be@intel.com>
 <20240418102314.6a3d344a.alex.williamson@redhat.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20240418102314.6a3d344a.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY1PR01CA0195.jpnprd01.prod.outlook.com (2603:1096:403::25)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|BY1PR11MB7982:EE_
X-MS-Office365-Filtering-Correlation-Id: fdaaa53c-21a9-43ca-e99d-08dc6075c053
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dnR6UTFCenJ3ZWx2RWY3aDB1eXl1OTdhM3pQMmFvNjZDRHdPWDdnNUtMalNr?=
 =?utf-8?B?TWlqdG1jV3lkTU5QcW1PMFhUTTZsT1dHTm4waGFyMFh0Mnh2NUJUYnpDSXRW?=
 =?utf-8?B?VUxTRXN0N2NTSmFOWDZJRmZBMHBpWVBHTmxCdDNrQnRlUGhhNDE1eGNRYUhl?=
 =?utf-8?B?aEdsdll3Q00vZUM2MlNnZEh1WEVod1VBNjk5QitYTW4vR3gwVGdjenhDelVh?=
 =?utf-8?B?Q05xcyszdWJIZFZqc0V4T0NXa3c1Q25kM0NJSlFRSElnTlMxLzBqbXptUUZE?=
 =?utf-8?B?MlQvbExwQThVTVNmTnFkbEx0UWFsS2FTb1pUeTRreHp6RHNyTjdwT2xiSFRz?=
 =?utf-8?B?Y01nL0x4Q0x4aCs0ZGRHK2NUaHpkSlRzS1hVRCtxT1BoUmpBeFJFcWcxZjA5?=
 =?utf-8?B?aS9ZUUxRSGZseFVhTlBqR1ptZ01FWlRKeWlZTE5wNGlPVlRvSkNTaWc3Zm5I?=
 =?utf-8?B?UFdldEpoZndXTmRzTXhlN0NvK3l1ZGg0WXU1QVQxUXl2c1pCMXVxR1ltK2I0?=
 =?utf-8?B?bllycCt5azBlbW1ISG5xUnVrUmxrL0dFTkl5Y1QwUGJpYWZzWS9zbDNSVk9F?=
 =?utf-8?B?RngwR0oxS1paVVd5Qlc4NXdKSUxjTXVPRlpFRjFxWjdXdU5CRXlTQVpOb3JJ?=
 =?utf-8?B?ZG5iMHVic0U5OVI5bWxkdDVvb2tvS0JqOHRvd3VyVmJWemdYUGEzTkhuemE1?=
 =?utf-8?B?aE1tOVphTkJQNXBSdzZWMTRlelhNZXUxQ3FMVkhWb3VvMUxnZ0N5My9SY3Zj?=
 =?utf-8?B?a0YraUQwbVJ2a0U2SngwWEh0MFI0aFhBMnl3SjJ1OTdnOHFPVEFwb0s1NUQ0?=
 =?utf-8?B?VnNoMHNtemszdkdtRGtqQ25OOTFsbzJOdnVObmhvOVQ5SldRaXJBc0FlSVk5?=
 =?utf-8?B?dGNqdDRwdjlzNGloYmVCaDd5eW11U0g3cWhTZm9HSXdFcE9jcVhoeEtoakIz?=
 =?utf-8?B?QVgwRmE1R0pqRU9aUXBVeXRyNkIvN0ZMNlNPVFNpQU5xOUNiemJuOENGNDZy?=
 =?utf-8?B?SVByZlNXVUJocEc4YVRsSTN4b2VyODcrRkh0djNTU0llYkNDSlhUbkU5L2Ja?=
 =?utf-8?B?bGI1cXV4M1pVMmJrQjhVY1FGWEpsaGRRZG1SWUt3a012ZitPN0JMOW9aYk5t?=
 =?utf-8?B?dTlJcE5QNml4NlhWQmpVczVybVJSN1IxU05FMXJsZnM4QmJBTThDT3FGVVcr?=
 =?utf-8?B?cEEvOVFjcFl6TUYxV09rRDhadFltWUVUQkFSVU93Qk82L3ExU1hheFRFMktO?=
 =?utf-8?B?VERoeGU4WnJLYWFIaTNJcUwzRDFSeDBWcTY4eVFnWlNGdCsrWlg3Y0Uva1kx?=
 =?utf-8?B?QlMwbHBwajBoRnRTZ1dMcFpwMk5RMytoUjBuR0Njb1VPUTBIdEdWTnVoNXJT?=
 =?utf-8?B?cUhHNDMrZ2ViTTlCcmxjK09CSk95WXBJWFZaM1p2ZExjSHlsSHYyUGZ1K1dP?=
 =?utf-8?B?ZUo3VWhLMnhsSktRL2FSanBTR1VkRE1oN3UzZDFFOGV3cFZjRXk3UERqdzdx?=
 =?utf-8?B?ai80d09XcFdXYnRQV3czRkM1QjkxV1FPYnc5S0w0Zm90am5KSjdwTkRZeWhP?=
 =?utf-8?B?LzBhZmZXVzRmVU1VMlA4Ni82bFRVN0hMcXNNamc5WkpGeWtTNHlOUUZrbDcz?=
 =?utf-8?B?R2VrU0VNdWFvRGgwRFN0NU9NT0czbXNRbUM5RVE1Zkw5MkZEcDMyNEV6aDNa?=
 =?utf-8?B?Ny81YXpMMjlzWFRIM3hqRGxpZ3VzV2kxOEFwNnRaZHdteFpiODZBcDlBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(7416005)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WW5rT25DNXlyL2FXOWplMTJHbGdNQnB6SGVPWXcydnVMN2ZxZktUSkgydHVJ?=
 =?utf-8?B?WG9Ham55RlRYUnVoWEFuRzhMWWNGbEdVMWVldFlLU3d1TjlSaU5IanRUdkxK?=
 =?utf-8?B?dzROcVI1Nkl2TDRabGcwTURsNElZOGZoOFJKUWRMcU9pbS9wRkUyRm9ZUmkz?=
 =?utf-8?B?ZzMzOFFMZm1ZeUVES09CRG1ENW8wb05jbktCTlJNOXdtUmIvNExvZUZJSU10?=
 =?utf-8?B?SHVvQmVaeitEVVNjM2cyV281bnYwTjh3RVRudDkzSVUyMWRZVDJlOENzaTV0?=
 =?utf-8?B?ak1oYWVoSkRBemJ1WnZmZnpiVjAxbW5GR3E1NUFubEt1NEc0eS8yUWIxbzBa?=
 =?utf-8?B?c0E4NHk4MjkrdkNsUERTT0xsL2x1dXk5b3FvN3ZrWERmZFFiN1doTTZtVHR4?=
 =?utf-8?B?QVI2YmVsQlVLM08xZHBkaVBKa21pVGhRRnVUUTJRN0lhMTlWdzIveFgxc1Z2?=
 =?utf-8?B?VHQ1OG5iTHBKa0lBZWlQWm1obkJLQys3TmNYdVBWUXRiNEVCZTlXM3Awc0Vx?=
 =?utf-8?B?U3dZYVNqYWFnREZKSFVUdnJ0dU8yOHVHeVpxb1dNWVdtMm9CSlZNeWRzb2hq?=
 =?utf-8?B?ZklIbnFYbjJEb3BqNGRrU3pwbkw2bUFkM0dOZk5lMWJPN25WeFh2NCtXOEtX?=
 =?utf-8?B?ZzBwSGw1RFBiZXdZaEhncEJ5OEVVeXhjUWtmakhuY0QyREZaSWtlWXlmMExT?=
 =?utf-8?B?ZmNzRDNJVzAraVFkcGNacGU2RlVFRmNsZGo0QmhVTWN0aE8rYldEbW9mY0pj?=
 =?utf-8?B?b1JveXF1MDFhVGM1RGdKSUl4OS9HamtTT3dWVXRYRHByMVh1Mkt4K0NjSE90?=
 =?utf-8?B?cVZBcGcrVzIwa28xVTQvOXY4QmdVM3NlSGFQYnZ0QnB4L3M5L212TjJUNnRV?=
 =?utf-8?B?VzV1QUtkUGZsamNqVmRCcG9XS0F6UmJELzJVYk1IUUw2cHJRdlkwREF4d1Qz?=
 =?utf-8?B?MWZWSGJSSHdGNXBWOUY4dlhWZ3NwWGNUWk5WN0syUnN5UGRlVFA5dGlERkhI?=
 =?utf-8?B?YUhvTHBtSmdsZTR3QjRYZ2VKU1dhazRWNThuRXppOGpnYzFPM2pId0dsOWJC?=
 =?utf-8?B?QVE2bnlLRzYxSlVlVXlaczRXVHRTOEx4bXRoV21JZHkvcldIbmJ4Sno2azY5?=
 =?utf-8?B?ZU1NeHp2UGRxTU52WWZKWXRVRk1FNHkxbCtMSmpselJBeVZwYloyU0U3NlVW?=
 =?utf-8?B?bGNMSlF6S3NsQnNPa0tVbTFFMEZnRDhkai94TzI1bjZkSXpic1Q5K0VOZG15?=
 =?utf-8?B?M25lU3RPb3BCRjkrTVZ5d1Ixa1QwWlprdWpYUEV3bHVmTTM1T0czQUp4dkcy?=
 =?utf-8?B?OG5WK2VmallZSzlqNlhheFZSNmNpN3ZlSDRaQmhKNnRnczM5L0c1d3VZR1dK?=
 =?utf-8?B?cEJRS0M2NUE0YVV1ZGRKWi80MFZDRlBIQTRacDVXSWRxZ29PWnpQTzRvNjBG?=
 =?utf-8?B?ZXdabTF6eDh3YU13dE1qRFA5K3lDcWMxV2MvQndnTTc0U2xWdGpURStlK2wx?=
 =?utf-8?B?VFVtZDdWM0tBN1VPclhiNjhTYjBONk5SbnFpU0NXM1ltTmpZeVoxSHl4aUU2?=
 =?utf-8?B?eWxXY1hlYnZrSTZUakZIV1hybk5GZ3R1WHBkRDhtb1hNL1N4MS9KQzAwTkZN?=
 =?utf-8?B?a0QyMXNEVjY2cjdGbGU5YmhOQnVEdU9PRzZiMDdZbkxvcDRHS0VPcjJJSTNW?=
 =?utf-8?B?a2p2Wk56LzByTUdCNjBqQ1ZxK1dETkMxNUlhYnFJWkk0M2JRUXdMUGNqZTZP?=
 =?utf-8?B?UXZzd2tGM0NPYmx2ZEFMSkhVdmxqakx3MnBxM0VhdnU3VllxTXFGTFBhbUNo?=
 =?utf-8?B?TFNSRGlXbDhhSWNMWTZVRDFGb0dTb3JsL01UMGhJUFlUM2kyeVQyM05tdUkv?=
 =?utf-8?B?NnJJbDR0MjhjcXoyRFFmUzhqWTJMcm5WWmhTUGo3RlcxRTZWaUUzNGxlWDRz?=
 =?utf-8?B?V3k0dnF4bnZKcHJ4emVHaFJldTJnNVZwVjY1b3pwSlFtZFp5YndZaURleUpa?=
 =?utf-8?B?M3E2ekJ0c3JFdWttOS9OR1l2RWpvSFRwQ1IxdnRKRmQ2WHVLOHpkSjBGVjEx?=
 =?utf-8?B?SEVJYVc1R3dZb3ByeTR6SEtEVHN6djBISC8xRkxqMHAvZkpQQ2RTbktRWE5z?=
 =?utf-8?Q?yb2xFWytnoGnblqlBsP2f/gXv?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fdaaa53c-21a9-43ca-e99d-08dc6075c053
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2024 13:36:43.6971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8mhMB3MntBjzfNxEk9CL63yxdcdv0fQS6X+43zPjiyN1bjG0IgOHyF5IW462Afzi9+4tRaiAQkKWBVucRKYRmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB7982
X-OriginatorOrg: intel.com

On 2024/4/19 00:23, Alex Williamson wrote:
> On Thu, 18 Apr 2024 15:02:46 +0800
> Yi Liu <yi.l.liu@intel.com> wrote:
> 
>> On 2024/4/17 00:03, Alex Williamson wrote:
>>> On Fri, 12 Apr 2024 01:21:18 -0700
>>> Yi Liu <yi.l.liu@intel.com> wrote:
>>>    
>>>> There is no helpers for user to check if a given ID is allocated or not,
>>>> neither a helper to loop all the allocated IDs in an IDA and do something
>>>> for cleanup. With the two needs, a helper to get the lowest allocated ID
>>>> of a range can help to achieve it.
>>>>
>>>> Caller can check if a given ID is allocated or not by:
>>>> 	int id = 200, rc;
>>>>
>>>> 	rc = ida_get_lowest(&ida, id, id);
>>>> 	if (rc == id)
>>>> 		//id 200 is used
>>>> 	else
>>>> 		//id 200 is not used
>>>>
>>>> Caller can iterate all allocated IDs by:
>>>> 	int id = 0;
>>>>
>>>> 	while (!ida_is_empty(&pasid_ida)) {
>>>> 		id = ida_get_lowest(pasid_ida, id, INT_MAX);
>>>> 		if (id < 0)
>>>> 			break;
>>>> 		//anything to do with the allocated ID
>>>> 		ida_free(pasid_ida, pasid);
>>>> 	}
>>>>
>>>> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
>>>> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
>>>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>>>> ---
>>>>    include/linux/idr.h |  1 +
>>>>    lib/idr.c           | 67 +++++++++++++++++++++++++++++++++++++++++++++
>>>>    2 files changed, 68 insertions(+)
>>>>
>>>> diff --git a/include/linux/idr.h b/include/linux/idr.h
>>>> index da5f5fa4a3a6..1dae71d4a75d 100644
>>>> --- a/include/linux/idr.h
>>>> +++ b/include/linux/idr.h
>>>> @@ -257,6 +257,7 @@ struct ida {
>>>>    int ida_alloc_range(struct ida *, unsigned int min, unsigned int max, gfp_t);
>>>>    void ida_free(struct ida *, unsigned int id);
>>>>    void ida_destroy(struct ida *ida);
>>>> +int ida_get_lowest(struct ida *ida, unsigned int min, unsigned int max);
>>>>    
>>>>    /**
>>>>     * ida_alloc() - Allocate an unused ID.
>>>> diff --git a/lib/idr.c b/lib/idr.c
>>>> index da36054c3ca0..03e461242fe2 100644
>>>> --- a/lib/idr.c
>>>> +++ b/lib/idr.c
>>>> @@ -476,6 +476,73 @@ int ida_alloc_range(struct ida *ida, unsigned int min, unsigned int max,
>>>>    }
>>>>    EXPORT_SYMBOL(ida_alloc_range);
>>>>    
>>>> +/**
>>>> + * ida_get_lowest - Get the lowest used ID.
>>>> + * @ida: IDA handle.
>>>> + * @min: Lowest ID to get.
>>>> + * @max: Highest ID to get.
>>>> + *
>>>> + * Get the lowest used ID between @min and @max, inclusive.  The returned
>>>> + * ID will not exceed %INT_MAX, even if @max is larger.
>>>> + *
>>>> + * Context: Any context. Takes and releases the xa_lock.
>>>> + * Return: The lowest used ID, or errno if no used ID is found.
>>>> + */
>>>> +int ida_get_lowest(struct ida *ida, unsigned int min, unsigned int max)
>>>> +{
>>>> +	unsigned long index = min / IDA_BITMAP_BITS;
>>>> +	unsigned int offset = min % IDA_BITMAP_BITS;
>>>> +	unsigned long *addr, size, bit;
>>>> +	unsigned long flags;
>>>> +	void *entry;
>>>> +	int ret;
>>>> +
>>>> +	if (min >= INT_MAX)
>>>> +		return -EINVAL;
>>>> +	if (max >= INT_MAX)
>>>> +		max = INT_MAX;
>>>> +
>>>
>>> Could these be made consistent with the test in ida_alloc_range(), ie:
>>>
>>> 	if ((int)min < 0)
>>> 		return -EINVAL;
>>> 	if ((int)max < 0)
>>> 		max = INT_MAX;
>>>    
>>
>> sure.
>>
>>>> +	xa_lock_irqsave(&ida->xa, flags);
>>>> +
>>>> +	entry = xa_find(&ida->xa, &index, max / IDA_BITMAP_BITS, XA_PRESENT);
>>>> +	if (!entry) {
>>>> +		ret = -ENOTTY;
>>>
>>> -ENOENT?  Same for all below too.
>>
>> I see.
>>
>>>> +		goto err_unlock;
>>>> +	}
>>>> +
>>>> +	if (index > min / IDA_BITMAP_BITS)
>>>> +		offset = 0;
>>>> +	if (index * IDA_BITMAP_BITS + offset > max) {
>>>> +		ret = -ENOTTY;
>>>> +		goto err_unlock;
>>>> +	}
>>>> +
>>>> +	if (xa_is_value(entry)) {
>>>> +		unsigned long tmp = xa_to_value(entry);
>>>> +
>>>> +		addr = &tmp;
>>>> +		size = BITS_PER_XA_VALUE;
>>>> +	} else {
>>>> +		addr = ((struct ida_bitmap *)entry)->bitmap;
>>>> +		size = IDA_BITMAP_BITS;
>>>> +	}
>>>> +
>>>> +	bit = find_next_bit(addr, size, offset);
>>>> +
>>>> +	xa_unlock_irqrestore(&ida->xa, flags);
>>>> +
>>>> +	if (bit == size ||
>>>> +	    index * IDA_BITMAP_BITS + bit > max)
>>>> +		return -ENOTTY;
>>>> +
>>>> +	return index * IDA_BITMAP_BITS + bit;
>>>> +
>>>> +err_unlock:
>>>> +	xa_unlock_irqrestore(&ida->xa, flags);
>>>> +	return ret;
>>>> +}
>>>> +EXPORT_SYMBOL(ida_get_lowest);
>>>
>>> The API is a bit awkward to me, I wonder if it might be helped with
>>> some renaming and wrappers...
>>>
>>> int ida_find_first_range(struct ida *ida, unsigned int min, unsigned int max);
>>
>> ok.
>>
>>> bool ida_exists(struct ida *ida, unsigned int id)
>>> {
>>> 	return ida_find_first_range(ida, id, id) == id;
>>> }
>>
>> this does helps in next patch.
>>
>>>
>>> int ida_find_first(struct ida *ida)
>>> {
>>> 	return ida_find_first_range(ida, 0, ~0);
>>> }
>>>   
>>
>> perhaps it can be added in future. This series has two usages. One is to
>> check if a given ID is allocated. This can be covered by your ida_exists().
>> Another usage is to loop each IDs, do detach and free. This can still use
>> the ida_find_first_range() like the example in the commit message. The
>> first loop starts from 0, and next would start from the last found ID.
>> This may be more efficient than starts from 0 in every loop.
>>
>>
>>> _min and _max variations of the latter would align with existing
>>> ida_alloc variants, but maybe no need to add them preemptively.
>>
>> yes.
>>
>>> Possibly an ida_for_each() could be useful in the use case of
>>> disassociating each id, but not required for the brute force iterative
>>> method.  Thanks,
>>
>> yep. maybe we can start with the below code, no need for ida_for_each()
>> today.
>>
>>
>>    	int id = 0;
>>
>>    	while (!ida_is_empty(&pasid_ida)) {
>>    		id = ida_find_first_range(pasid_ida, id, INT_MAX);
> 
> You've actually already justified the _min function here:
> 
> static inline int ida_find_first_min(struct ida *ida, unsigned int min)
> {
> 	return ida_find_first_range(ida, min, ~0);
> }

aha, I see. :)

> 
>>    		if (unlikely(WARN_ON(id < 0))
>> 			break;
>>    		iommufd_device_pasid_detach();
>>    		ida_free(pasid_ida, pasid);
>>    	}
>>
>>>    
>>>> +
>>>>    /**
>>>>     * ida_free() - Release an allocated ID.
>>>>     * @ida: IDA handle.
>>>    
>>
> 
> 

-- 
Regards,
Yi Liu

