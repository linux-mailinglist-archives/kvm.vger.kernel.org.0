Return-Path: <kvm+bounces-19370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 77B55904780
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 01:07:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E9731C23884
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 23:07:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0857A155CA0;
	Tue, 11 Jun 2024 23:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HNUgiDC/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC2E9475;
	Tue, 11 Jun 2024 23:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718147242; cv=fail; b=M6Y/Os2M0OqmYtw17yR9JBEMlvrOI/X7c4e7hzVGN3g+pZFvQ3ghuJR3zjuQn2lqZVaA7XeIZvVnDTm9y/qmGKxUXNZH2CixK04K+55ClFsiNVNcSMkFit6rJWzOCIORRrVtq25u4yK6ohx0bSme/cw9BWxH3JnatyUFE7HGNjI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718147242; c=relaxed/simple;
	bh=QYjOFY04x7ZHAQzA5UGkB2jL7wNP3qnt9ZML+qOc7oA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tr2jLaLAjIhEihTAn7jEN8fBwadREl0jAds9diJGbo1DTHujH2P8XtML4fgahkqgDHo2BQqfHNW6lyFfnYourgzyiAcHTLJlPFuI2kLCpBalb+Px+/jyQtXoHYf55Bx7UJdQ2YG4I+PgduMw2c+opQJcJc1aysQhBd05l3BTIiA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HNUgiDC/; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718147241; x=1749683241;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QYjOFY04x7ZHAQzA5UGkB2jL7wNP3qnt9ZML+qOc7oA=;
  b=HNUgiDC/CU/V5eLuUuNVF60KuzyT6xvZ+P5fZNrPjkJpa8hxbINe6sjA
   QtpQpHyYkw2g8OCL2pq9XofQqfHC1WN1PiRvWzP7x3bIgxGz/zzWtU+RH
   H//X7hnf3YNICZLajffZhYlvt/l+cV4MFNyNTrZ+ywBPepAZW7ffX6Cln
   LOh4+qrmdZugwIrLLzsj7IfgW3qGcVvF6irOYVUm49DNdquO5z4WjaYmz
   fkvLHPDXHIMfJgDiBqs9oNGFN+tBWnmGPdLQV3YrqsmQxLlUH2zT10bjT
   qkHTG9f06i4ijAmvRrcYm9FPgqZX1Rh2xdvZkpt6VkNWMulyyeDQGFsf7
   Q==;
X-CSE-ConnectionGUID: vUaGDEh3RyuIJPVhG0+vmg==
X-CSE-MsgGUID: nznNFgrsQ2aRpb3nRbYfWQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11100"; a="14686611"
X-IronPort-AV: E=Sophos;i="6.08,231,1712646000"; 
   d="scan'208";a="14686611"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 16:07:20 -0700
X-CSE-ConnectionGUID: n/Lz2HyJTZOLyjlsdEwukg==
X-CSE-MsgGUID: ol9krfPZTJqkspNlBu91WQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,231,1712646000"; 
   d="scan'208";a="70386726"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Jun 2024 16:07:20 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 11 Jun 2024 16:07:19 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 11 Jun 2024 16:07:18 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 11 Jun 2024 16:07:18 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 11 Jun 2024 16:07:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kwGaS2Um+WtiYQyJTs+7N5I5+jq4LrLzk0fAn14aPiRjCo8mvYZC7/+FwwkJGta+Gbyl4v6n8bGdxzpA6OM7T1ZJLrq6YV2hzXcNkkzZ1gb8/yzY1cIF0cGMejlVERy9/Txc+VXs9rNwtPF5UhUWwF3gpdNHvaZ5eH9yHhROZFlKpBcra8++aW+wwjgzwDp8f/PVPLp7e5oFM5KOnVQcX8HZniEWWqEYaAdu78Zncfay5ibR3InhVD1BCV1IACoUXnMYf3dkvjd89wqn4ZfMnqPtpT7A6qJjcMO/4kfcHH/wyBam2SyGhVh2CITck90LPgmMHSQqCgTeW61zKolgog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=of2jHyyg8I1wAVM8DzmI7Zp+a8s3SqW7ZpL6NnURqmc=;
 b=X3CIXakzrT7k1vXHoifIqv0fE2Ni6Fy24RzQ8+UXRh3nkRhoJuT7k/ckoKwvOjCeu2F5+nUFq+xUDlnTQv4u0yxgo6Jvea3v0LnFuJQBpb11ji70iG1omuREG7S0AMssKBdxubZ0nCMcIXf9kcMaQQP6T8d1w7sHrCuNdpZdCXiJ2jXyDhL2RfwnGLSgz1DsgVmB1eBDqPVnm/LqZ7jerrt1uRJ2rlAUSyO+OUiwykMTk3crk1e+I4P3s3yz2dUT2kiaN+oNjgPUh70W0bN/02/wfn6dof+POkDLEWgFj7HgGtruv9pD2ggoLj6t58eZSmMtyADAgzk/7b/EZS0Fxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS0PR11MB6470.namprd11.prod.outlook.com (2603:10b6:8:c2::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.36; Tue, 11 Jun 2024 23:07:15 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7633.036; Tue, 11 Jun 2024
 23:07:15 +0000
Message-ID: <88c65b89-5174-4076-82cd-7852c8c25b66@intel.com>
Date: Tue, 11 Jun 2024 16:07:12 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V8 1/2] KVM: selftests: Add x86_64 guest udelay() utility
To: Sean Christopherson <seanjc@google.com>
CC: <isaku.yamahata@intel.com>, <pbonzini@redhat.com>,
	<erdemaktas@google.com>, <vkuznets@redhat.com>, <vannapurve@google.com>,
	<jmattson@google.com>, <mlevitsk@redhat.com>, <xiaoyao.li@intel.com>,
	<chao.gao@intel.com>, <rick.p.edgecombe@intel.com>, <yuan.yao@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <cover.1718043121.git.reinette.chatre@intel.com>
 <ad03cb58323158c1ea14f485f834c5dfb7bf9063.1718043121.git.reinette.chatre@intel.com>
 <ZmeYp8Sornz36ZkO@google.com>
 <a44d4534-3ba1-4bee-b06d-bb2a77fe3856@intel.com>
 <ZmjJnzBkOe58fFL6@google.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <ZmjJnzBkOe58fFL6@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0075.namprd03.prod.outlook.com
 (2603:10b6:303:b6::20) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS0PR11MB6470:EE_
X-MS-Office365-Filtering-Correlation-Id: 02233e75-a19d-4fd4-68b2-08dc8a6b3bc6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230032|1800799016|366008|376006;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UWh4RjFHQUZpTnBKd0Npd0phS3d0L2pWMDFrVzJHeGgzcTR4TFpEbkI3bjhp?=
 =?utf-8?B?NllteG5FNSs3V3pXSEI0ZjQ3SUQ4WWY4eURzdVNyR0hLRDRsSUw4REtiSTd6?=
 =?utf-8?B?WE00eDFnOHNuTm9tTGh6Wkw2bExJT3RJUDRDemVKMzJyNTFUYnB2WHNHRkFx?=
 =?utf-8?B?dDM3VDZGOHJodWZJczV5VTBpUnpxa2FwZHY1S0JpTU1XNTlaSmpjNXVEWEF5?=
 =?utf-8?B?UnBiUU5qWTFlaWdRdGRCUXpmRFoyaGU3SkhqR2tFRTRSZHUvbU9mLytnSU5j?=
 =?utf-8?B?bk9IZUNGNzdBVG55NUhqamgwcDZ3RUNuaUd2Qy9RdzNHTDd6SzZQajR3bWpo?=
 =?utf-8?B?a2NMdndBeEtud3pkL1NtNXZKWXFHbDIydXZJR05UY2grRVVQRU4yV25EMURp?=
 =?utf-8?B?MklNdzc1MStWTWhpYWROUE9taStuZy9XMDA0L0JIWjRYWTdlVkRjZlZmZnlJ?=
 =?utf-8?B?eXVnRytCZ1VHWHJkeDI4TVZzMCtnOGZYSFFFT2FHMWcxWVVReVdGdk9JNWhQ?=
 =?utf-8?B?NzVOWmNvbDV1TFUwOUFFOTNrVU5td2J6WENPcHQ4bHE4YWlSdEgyclc0MlFi?=
 =?utf-8?B?bXdHYVFmZGRmdm1PbFdaZlhEdmVoQmZIQ00xNUFYRk5qNHcxTFk2M2IzL1VC?=
 =?utf-8?B?cUFjditEeDVldGFpTjF6UnROOVJjQkhaY1RHYjFrc05YM1FkM0FvMnFGOWRz?=
 =?utf-8?B?SkVaNkxzL25GY2RMYW5zUjRqeXF5bDZleHNLenFVV2dFcVVKU2hheTB1WWdo?=
 =?utf-8?B?MlNDNEgyL3UvcDNCMzBXRU1qTitrVzl3OEtrb1RRM09FdlFPQzh5VURXQmQ1?=
 =?utf-8?B?WlhiZ05jcUhSMWRRUFNzS3FGcDJiNXdNaHNaakdoZWZ6MFBITjJsOU40NTdV?=
 =?utf-8?B?ak9qeGxWZUp3akFRM3FSZ3I2RWZYOXNjdTViM3lCU01JblNaN0pYQndSdXU1?=
 =?utf-8?B?VXJsUUNFYkFoMDgvemJzVklvQ21xazFyT29HWTExNlRVSnVsWFNwVHFSK2hF?=
 =?utf-8?B?WjhTRCsrUCtqTmhtME8yeGx1alcvMG5yWWZKd1RKV1BNTVE0Yk1XSEVKWkpB?=
 =?utf-8?B?RTl6dEE0cDhycjE5UlNBdlNNM1I2OElZK0hLRXNlbmRHQ2hwd0szQmJCYlkv?=
 =?utf-8?B?WFZyazRSSk41R0lHMTVlSE8zc2JmZURWRU9CRGVzUFVGUkpvZ1pUa1NBNDli?=
 =?utf-8?B?V28yRmg5MElzUVdNVXBmRzAzdU5xUUFQUGYxZTFEUkpKSjNtSDZOSlVVcy9M?=
 =?utf-8?B?bDlOMGJEZjd1MHFoMDFVVnBZYkNHNVZTcUkzMTByeGxIWmE5RWVMbXM2S21J?=
 =?utf-8?B?c3RWN3hzeG4ybkJEWmpPOXhWd3FWbTEwNmJPOE1SYURvNCtsNFhFWmUreFhL?=
 =?utf-8?B?MlpLNlFTMG56TnpwUk5jcU5DNWd1Z0tzd3dSMEw4UUNNVlBaOXdOU0VhRUlv?=
 =?utf-8?B?YWFKTDFVTjRySWZBUHZsQ3NpQ3RSQ3c0em4yYUEyRlFaZFpUS0lzUFNlSFBU?=
 =?utf-8?B?aVNlYUhQRFIrSDdiK1owdmtCM1VWMUVKOHoyOCs5V2pNekx5V2RZWEF3Q1Fi?=
 =?utf-8?B?Q01zOFlPVjZvK2RUQlRnK0piZ3JBamtjMlBFRi9jY2pkNHVvRXpHQUg3VWlS?=
 =?utf-8?B?cWU0OWdJREFPSXpHbHZKMVM2MTNWaDFwWFNtZHlIUEprOUVvUE9TcVEvVjJa?=
 =?utf-8?B?QXRQK2dlMVB0UWk5SjI0MUNPZERPbW5VNHozdXF5RzRYNVZzelpUS1gxZXhZ?=
 =?utf-8?Q?O76qI/CCj0KffL6hxyfTNUDr1HrfY3xfHJTCE6D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230032)(1800799016)(366008)(376006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M1gxUnc4SjNWREpRM2s1Q3Q0RWhxYmY3VU1WcHlHenNiQ2hSMGl3RHdsRmI4?=
 =?utf-8?B?MFJRWU1XSVFjTVFkZEJkV2EvYlFOZUZQNHA2ZFIrSnJBb1pwajhkSlVyN3JL?=
 =?utf-8?B?bHNBSjl4am16NmVaeCtqeGVlTVVVVEJzZ1BSMkprVmNrbU1HTnVXWmtEQlk5?=
 =?utf-8?B?dWxsbUtmbjAvcW1RODRZcFRPZkw2MG5KWk9BazlQeFdMdzN3QTBoTVQ2SlJP?=
 =?utf-8?B?RXJqTG9DMFRrYXlFenlWcUJXaFB5bFp2Ny9jTUJoNjN4dHhNbUZ5NFJEMitE?=
 =?utf-8?B?SS9TY2pqZVNUcnFkd3Nub3FBOW5sMlRRaVQrc3VlOWcyUzRjNW44UDlJc3Zw?=
 =?utf-8?B?emhIZWZhU0t5RW5OWG9uSXpOaHZwMHJoanN3Yi9yZWJNUEx1ZlUyTmZOMnBF?=
 =?utf-8?B?U0hNRm5jWkJtQm5sSmNxbDJqT0tXMjYrdndTb1N1eXBuS3Fyd3RtT0JXQWtZ?=
 =?utf-8?B?dDJvYnVYWUhMUElkZ0J6bDFXK1lHUm93NDF0WWFSZ2l1RGZKZXp0YlVROFls?=
 =?utf-8?B?NVFsWk9RVDJnRGZreGt5MkhkVEcyZ01hUXF6SmFwZEUyQ0hzQi96SExLSzNu?=
 =?utf-8?B?cUc1Zi92bzV6Uld3amk3NkdUbVV4ZjJURlNYek5uUy8yaEVBTkVRTWsxVUcw?=
 =?utf-8?B?ZXdoVG9HSWY3M05KU2wrc3R3a0VxOXp3eUpPaVlWUWxXcFIyY3VUMERBNm9M?=
 =?utf-8?B?eGtETVVDODRqeFdvLzAwQUwvNldSSnowaDVFTUwyZXBidWlacFhwbkZ4R1d2?=
 =?utf-8?B?TFVzbk5ZUHJPZFprNHc5R2lLVkRYSklSSE1MTWRxNkNnbWY3cU9MaEFEdU51?=
 =?utf-8?B?M2RKUGFMM3haQ2t6ZW5tZWtKM2JVY1dQL0NCSjg5SENUNVdEWXZKWTA0OFRq?=
 =?utf-8?B?UXJVUGFmeEV1RFEzZy84cmt1WDc1UThhNm44MUJiT0c5a1dxbGQ5elZoaTZr?=
 =?utf-8?B?c05ZTWpyNkMyb2dWNVJiOXNOU1ZuM0RXV1VUNFZLR1c1NnRsQ2tsOXdXMGdl?=
 =?utf-8?B?eFl3YUFyalNhUWlxSTZKSkhCaHVzejlxYWFpNFhXVnJqbUhIZWNpUmx4bjIv?=
 =?utf-8?B?NnhON0NuQ2ZWYTVpcVI2TDlVK2FkNVhYRDVJcklJTU5kekRTbFdnNUgyVTNI?=
 =?utf-8?B?U2k5QWFKczg0TUQ3NmxFV3NvS2ZLRmF5bm1mRUJLa0VWNThDZDdXTkIvNUdz?=
 =?utf-8?B?Uko2cStxRmlacG9icWJCZDk3MjFab1lxMHhRMEI3TGlhSk5WeU41eEg1eW9I?=
 =?utf-8?B?NTZ1anpNWFl4KzBRUk1WeEl4bUhFY3BhYXE2RHp6ckthbDc4QWFkcTZSOUlU?=
 =?utf-8?B?QkUzQ3pzZm8vT0dWZGt2WWdGNHR5cnNJMGR1LzlCcUtoRWlMYVJTNi9wSUEr?=
 =?utf-8?B?Rml0Wi9QU1BObk53WjZzbU5KWllPdUZtczJISTJCTkVNQm1GSXN6NmRNUGN3?=
 =?utf-8?B?aHpXV1FMVTdrYmpFYW1RVlhZZDFNSlNZeS9mNWNlMnZnUkNaT0tqVm9FSlhj?=
 =?utf-8?B?TVpYMHduMnpxMERpb1VRNS9SdnAxd29aZE13V2JETmlRajNKZFh2alczUDZT?=
 =?utf-8?B?a2doZXF6Z042RUo0djBrT05NM2xTeVRaclVIM29NSmRiQVA3c2QybGxRZC9J?=
 =?utf-8?B?ZW4xbVBYdzZ6SWVTOFFad29xODBTZHB4eXdBTGNRcmJZT01UVkM4VHdXNjdt?=
 =?utf-8?B?QXJ0TVQvbzJPNTdPMm5xNDg0eGIvbXAwRzUyczU2ODdrRk1GT3ArMHh0aFh5?=
 =?utf-8?B?OEJkdkJzUkZrL0FhM2c0WFE5L2lpZ0lYbnF0T0NNYXgzOE1CV3lwQmlJS1Nl?=
 =?utf-8?B?SkZJUjZDd0Z4NTBuSm95T2N2bDZwWC9zL0xVdEt3Z1c1bzd2N1Rwa3B1UDNw?=
 =?utf-8?B?VytpVm9OYWlScCs2aFFNdVcybll0M21IVVdoSC8zRG44bVZyNWlaNVlGZ1dm?=
 =?utf-8?B?ZDk5NGJPemFXQ2pCU3paNlhKT0VwT3RRWk9peXVtNENQd21icENuYTc0QWpj?=
 =?utf-8?B?VzY4c2NrV1pFQmM5WXZiK0Y3UkZnU2Rzck5qd2V3UDdrNHR3Zlh0ajBtTEpw?=
 =?utf-8?B?b3BsSW9EbHp6QkdoelBGMFVpUE5MUFpVQ3dyUXV3YzBMSnc1YjYvd0UwZWJB?=
 =?utf-8?B?bW1zdUJBU0FQVHV5b2J1NFE0SWREL0VtNGZpSG9YYytmOVQ3ellycktQTkxj?=
 =?utf-8?B?N2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 02233e75-a19d-4fd4-68b2-08dc8a6b3bc6
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 23:07:15.0157
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EGTWfweXis5oJ7uGFHUaeMw5HRIThagCt7ks6NZJgJYsMteYgaXJkNmGPxHaE4q3Ydp8YhzL6qTsoL8Qack2lR2/Lbft2WdC0c8TCZQIwgc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6470
X-OriginatorOrg: intel.com

Hi Sean,

On 6/11/24 3:03 PM, Sean Christopherson wrote:
> On Tue, Jun 11, 2024, Reinette Chatre wrote:
>>> Heh, the docs are stale.  KVM hasn't returned an error since commit cc578287e322
>>> ("KVM: Infrastructure for software and hardware based TSC rate scaling"), which
>>> again predates selftests by many years (6+ in this case).  To make our lives
>>> much simpler, I think we should assert that KVM_GET_TSC_KHZ succeeds, and maybe
>>> throw in a GUEST_ASSERT(thz_khz) in udelay()?
>>
>> I added the GUEST_ASSERT() but I find that it comes with a caveat (more below).
>>
>> I plan an assert as below that would end up testing the same as what a
>> GUEST_ASSERT(tsc_khz) would accomplish:
>>
>> 	r = __vm_ioctl(vm, KVM_GET_TSC_KHZ, NULL);
>> 	TEST_ASSERT(r > 0, "KVM_GET_TSC_KHZ did not provide a valid TSC freq.");
>> 	tsc_khz = r;
>>
>>
>> Caveat is: the additional GUEST_ASSERT() requires all tests that use udelay() in
>> the guest to now subtly be required to implement a ucall (UCALL_ABORT) handler.
>> I did a crude grep check to see and of the 69 x86_64 tests there are 47 that do
>> indeed have a UCALL_ABORT handler. If any of the other use udelay() then the
>> GUEST_ASSERT() will of course still trigger, but will be quite cryptic. For
>> example, "Unhandled exception '0xe' at guest RIP '0x0'" vs. "tsc_khz".
> 
> Yeah, we really need to add a bit more infrastructure, there is way, way, waaaay
> too much boilerplate needed just to run a guest and handle the basic ucalls.
> Reporting guest asserts should Just Work for 99.9% of tests.
> 
> Anyways, is it any less cryptic if ucall_assert() forces a failure?  I forget if
> the problem with an unhandled GUEST_ASSERT() is that the test re-enters the guest,
> or if it's something else.
> 
> I don't think we need a perfect solution _now_, as tsc_khz really should never
> be 0, just something to not make life completely miserable for future developers.
> 
> diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
> index 42151e571953..1116bce5cdbf 100644
> --- a/tools/testing/selftests/kvm/lib/ucall_common.c
> +++ b/tools/testing/selftests/kvm/lib/ucall_common.c
> @@ -98,6 +98,8 @@ void ucall_assert(uint64_t cmd, const char *exp, const char *file,
>   
>          ucall_arch_do_ucall((vm_vaddr_t)uc->hva);
>   
> +       ucall_arch_do_ucall(GUEST_UCALL_FAILED);
> +
>          ucall_free(uc);
>   }
> 

Thank you very much.

With your suggestion an example unhandled GUEST_ASSERT() looks as below.
It does not guide on what (beyond vcpu_run()) triggered the assert but it
indeed provides a hint that adding ucall handling may be needed.

[SNIP]
==== Test Assertion Failure ====
   lib/ucall_common.c:154: addr != (void *)GUEST_UCALL_FAILED
   pid=16002 tid=16002 errno=4 - Interrupted system call
      1  0x000000000040da91: get_ucall at ucall_common.c:154
      2  0x0000000000410142: assert_on_unhandled_exception at processor.c:614
      3  0x0000000000406590: _vcpu_run at kvm_util.c:1718
      4   (inlined by) vcpu_run at kvm_util.c:1729
      5  0x00000000004026cf: test_apic_bus_clock at apic_bus_clock_test.c:115
      6   (inlined by) run_apic_bus_clock_test at apic_bus_clock_test.c:164
      7   (inlined by) main at apic_bus_clock_test.c:201
      8  0x00007fb1d8429d8f: ?? ??:0
      9  0x00007fb1d8429e3f: ?? ??:0
     10  0x00000000004027a4: _start at ??:?
   Guest failed to allocate ucall struct
[SNIP]

Is this acceptable? I can add a new preparatory patch with your
suggestion that has as its goal to provide slightly better error message
when there is an unhandled ucall.

Reinette

