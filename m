Return-Path: <kvm+bounces-18570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 360BA8D6CF3
	for <lists+kvm@lfdr.de>; Sat,  1 Jun 2024 01:42:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8C2511F2640E
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 23:42:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 407AF12F596;
	Fri, 31 May 2024 23:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H4Yt711J"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A899134BC
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 23:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717198947; cv=fail; b=mZLz2za+OKAz50ZFJuUTMGvLNh1kaY7k8UU2ggt/yUkmdXPvV50iVdwPWyLQhCzGNj4kdALAKInWakCdguImLE6IBPBz/C+J4POH5ZPkcK0aYhFCW0vR33TGA1UlHZII++zS8qzrCOa16ybE74jJj/WLKkvchZiUYV+/Mvvrg+k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717198947; c=relaxed/simple;
	bh=kP400DPJBt9Ve0g6FFCkkGR3f7pNUN29CsgwVAYQv5s=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uSPSvUV/NXB2C2BkVC7syZCA21S/NFEBbmKx/0GCH1EJgIXgV8xsyhQ2I+Qni9/m0ByXAIrCVK1DyJNtfwE8ksok0x0acgGs/LLi0KjLidg5rd0pIvKEh/d8axkD7RHwnVtobQ+1M2LdHUVP+i0nZkoyQ0tPhswvrwNOjk4BpTY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H4Yt711J; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717198945; x=1748734945;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=kP400DPJBt9Ve0g6FFCkkGR3f7pNUN29CsgwVAYQv5s=;
  b=H4Yt711JAj9ZdbDnnOZxwdLo7q5XCYA9Faqo3m9ZBAlBDmD3gReEVSH/
   RFl5H/BlQdl30iwue8Ouh4G1K3N+JZ6nbXVFtfG86pcgJNWZ/zKP0c8rv
   Fre0CyYb1t99TKLJDX/1mIoOlcvFRa7wXhPk9WiA/s0Xfe8FLD3YKCmr7
   sHwBu1EHaQvudRotReCrMWsgnMbU2LwTkg3VCv6h3Qf2kA+Fw7zMrSeku
   8452IiRpeZp9MpuiSsdTs2TOq1WkePsq33JJEWd7MTvLObr6NMQJsNcRN
   E9SGGNRBYnga3J2XuBmJ6X66EzZbFIpOkZXXagNV0AitZkz50Ln1wDBoa
   w==;
X-CSE-ConnectionGUID: DJU81A3TQ4uZScPul93MoQ==
X-CSE-MsgGUID: HT20l0X/QoeCUQ7ZulGfgg==
X-IronPort-AV: E=McAfee;i="6600,9927,11089"; a="13610567"
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="13610567"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 16:42:25 -0700
X-CSE-ConnectionGUID: QlbGwvflRRihr0xencnYFw==
X-CSE-MsgGUID: iXcq4b/bQBONGnSYtpUdzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="36308633"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 May 2024 16:42:24 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 31 May 2024 16:42:24 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 31 May 2024 16:42:23 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 31 May 2024 16:42:23 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 31 May 2024 16:42:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T7HBiJfb5XaoVqeT5xjf9XrjNNYZFYWkVXhE0rx6nNX3V1dAoY9qlP9wcUsXLROdLIstHZLdzZyUCslfEFKTEWn+wJFCCxkz7gMftDB49q2TOxJyg4//Hv98Uollgv8C6MojLe/Qtcw0kqlS4pdA8FAAsUXPWvLy/908PFaWZyEj0ng9nmLbup9xfyrD7+x8usWB+oAP22d+ppc3fCdDmDR9yw0fyANHDsRqbQuqWVvcjPXlYvFdAzYLgtYr8RJekkJqamIdL1y8P/1+O2fzPsdBR+b1w4jwfqYDCXB1KzQBNOPzeDTIFbqu5K5j2EMeYbiaolJnHoGLq1IBWN04zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d7hRQOoYRAaIxlgy1VeDSbXDUCxU6jpTN77RRbRVm3I=;
 b=g3+xK3OyDMMg80DXYOkXcsI8NsPASoBQX4DTBJSnfbQhgdSuGUwwY2retOim4PZ+rQhPUKse5LlkBbEIvO1jK+ETqnN6SI2AghMdGKyjgClSDGEYU/fCQ42YPMUwJNGITx+eIZVsMSrpAy2VdM0K8s/MlesEs05du8NPOwq4ZWCcq5jU8fGCwE1MqkR73jQqImypnzzBZjgco0ciYB0p8A2uoH6aLCOUmjXbCd38In1noeqpje1neFssuPAdTckS3Qp10l9G1JTT/0IMiYuePt7US8POxE2fYDwT7P0FckTijmaqulwqF2ybKHArA8A/q1y01b2USkyLzvBPn3iXsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 BY1PR11MB7983.namprd11.prod.outlook.com (2603:10b6:a03:52b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.21; Fri, 31 May 2024 23:42:21 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7633.021; Fri, 31 May 2024
 23:42:21 +0000
Date: Sat, 1 Jun 2024 07:41:27 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: <kvm@vger.kernel.org>, <ajones@ventanamicro.com>, <kevin.tian@intel.com>,
	<jgg@nvidia.com>, <peterx@redhat.com>
Subject: Re: [PATCH v2 2/2] vfio/pci: Use unmap_mapping_range()
Message-ID: <ZlpgJ6aO+4xCF1+b@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240530045236.1005864-1-alex.williamson@redhat.com>
 <20240530045236.1005864-3-alex.williamson@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240530045236.1005864-3-alex.williamson@redhat.com>
X-ClientProxiedBy: SG2PR06CA0240.apcprd06.prod.outlook.com
 (2603:1096:4:ac::24) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|BY1PR11MB7983:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f93fb57-1cab-4ca6-6577-08dc81cb50ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?gST7v1Mn036+1A9E1mD3SY/zc9Fi0zuGhiH/qtdXK9c2J1MpFVOI7EkiwoWs?=
 =?us-ascii?Q?tLKHfPUUquyRC1DieoOUJMLDHejP7Y65DM1yXmovL5C7ZcM7Zp6CvldkoUKj?=
 =?us-ascii?Q?ToDbDPTkXHkD9FBNp8gO6X7qUDELR/zM7d9Ll2z67G0Et+RC8uEiK3JKcBGv?=
 =?us-ascii?Q?GxRcaFDq+4NgpwGVJpmcqvKp9MhLvAy/UPmfS5mzj8P8O7qvctwucKU7ZUcZ?=
 =?us-ascii?Q?g6rSNpfQG5puVKReIqbZVelpNPEJB7FB9bIQcNwhBrmyxch3QSWW+tarHvkT?=
 =?us-ascii?Q?6DcsVhhNKGPxsWmqV3xeTK899SKk1Gh4wrsNPWcsiyTfMNqERyfebrmXpBsy?=
 =?us-ascii?Q?0VMGSFu0V+5Bw0vCE3W+6GPBIT7eSr8M201oJI0hamLPNefe3WWZDBJrMdVW?=
 =?us-ascii?Q?h0HaO9/kErX+UOSVBzFj7PGDVMn21Voo6GZKQxpHbhhOg2cpyYqUG4ZScy5k?=
 =?us-ascii?Q?+slHE642tQTcNbId/FJwaAyO0JWiPYZ7/zQ8H/0yuINxdQhpVzw6eOL6dhhB?=
 =?us-ascii?Q?eLXydLNbPiTEeb+Rzz2Qc2tKCEVXsCjPw9T4c3S9ilnTc5NIMv1vqr+rj7rB?=
 =?us-ascii?Q?nmSGMADVOgNjTMdu+/yhrSEJ+tQZdk3O7hPY4EwUxhQRQWNUNHuK8UeqKQfb?=
 =?us-ascii?Q?0vSog/iT8LUSrS3sU7yrczeOmCDsdt+Z1TEmFeAdTwDgIKh0ZWaVDWN+WQnj?=
 =?us-ascii?Q?tg6mRVdaBkpX24/SXJjG3eVvDLGZNkfMmXOPCJFJGO+Gv6M/N2+32+G5XLtd?=
 =?us-ascii?Q?xg9F0wD3NqDnPqC6idSTXSFbsLlbAUrV1eWh7hjkdrNyN04GXHVSLHdGRdYd?=
 =?us-ascii?Q?fhHAfDzmk4Lhi2iXUOPYgrSRx8WsWLqCNZ3u8ZH8LafWSQI2U7h1oJJ1UcWF?=
 =?us-ascii?Q?Agx0gyFrHEnnV0rYnc2+OqB3TDb0H4sWqYLpTNCy/r7BIoUhPPIMxshmui+7?=
 =?us-ascii?Q?mg5gNnNL3y/0MtCpzRYpDYCv8TiTBmJNGdMjkmJjpbe4txCPjQMiJaeQ7gGl?=
 =?us-ascii?Q?jbx070WW0kaST0SXvUtY5XyLn+cKbyd+YNWJgLWv3Q9WKQgYiHntlwq7OyZ0?=
 =?us-ascii?Q?HZuUhmOpN2gCb+Sl4HQHznL14spaOyrNe+u3+6bsj+A1Re+LVxaNwFVpMe30?=
 =?us-ascii?Q?qaFGwORu48hz3+NQUcd5xEtcUoOUqAiWI+Z3GQEwAWM5ecyVJBXaX2MMhSW+?=
 =?us-ascii?Q?JQN2ofSZpnY17Xfn0iv1V5PpG2a/twz25r8kaLQVn1ii3uZ1kQM2qxcYXH/4?=
 =?us-ascii?Q?SazyZgfxzqj0TbAPd8CoH0JZFgRokI4ajKxMuo/stg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vwVwKCpd0wVmxnus7flhiCKe8CAu+GsrKh23ON4S6o0nRerGvBU7bdQf8b7f?=
 =?us-ascii?Q?xmuot8F90yXCeIU5w0SDw6tfB6xTOYnX4FpX3+zy8sYj/lH77BAVNtgAilCm?=
 =?us-ascii?Q?XV3Auw8gTo/ZG3Dlqr1NEIr3n324f3yQaS9440/tDnrW/vO4QZAUj5cAC4q+?=
 =?us-ascii?Q?8sQvBjSolLub57goTuihEY6EUF+1k+V/BoAQR0bZ6J9stzZITBFJFGfY/ybB?=
 =?us-ascii?Q?0bxD8Z8z3+1AoV9GNiyUKxFNHby4emA/Wrz78zHnabgop1jEuS3Nt+WnilFq?=
 =?us-ascii?Q?BLNrV/xVrizZNqPWD8z57oKNNMldbudeRTaDIt+5dD4Xzx1omshh0VqsOdlp?=
 =?us-ascii?Q?TTu7Wuy/oikiKTamnYfjCM9izAjXvV8MOaShZfVpyFWvRHtiknYIz/nUcw2d?=
 =?us-ascii?Q?nkPFIFYXWsYMXwLRhfy4XUXUNx2aBtFpalk6tdrbsZOZvjvjpW8URt8YaGBl?=
 =?us-ascii?Q?ybVDbF/XaC/OzuxEcf/hVSwBks5kEIFLa6CpcrxyhE9VYwBTJjPVzaaifBZG?=
 =?us-ascii?Q?9zMWnH0rcTaPwgJmkmZBO5JpxfeCZ/BtlxgbYJmxhRxmtr0vtF3LB0mbCHdJ?=
 =?us-ascii?Q?ro2tA/IjdyX5UHV9l/dzfRbVtu0NI0sQxjm8mU4/vDXfvF6+Tme31YUpT+Ze?=
 =?us-ascii?Q?U27Ta/hwk2yrSL1n8WDTEI+aJe68T01LXaTymTCYD3lQD9HT9Sy/KQ6GMSdW?=
 =?us-ascii?Q?p8ulBJxXaL08CBISWeAEBn+PPgx+PHMcNIvPDxU9l3fuF8jiPg1Al4BrJpTT?=
 =?us-ascii?Q?E6ac8nE1rZcuSBeSWnPPzwXEIpgYzTPDfMN4ES8HuIlU4l0dgA7VHv38wkvh?=
 =?us-ascii?Q?EwOj7cIZlfcrYm0XIhn8gBj/XImr4C7Q0HW7pGiObUR7OhggV81F+r1PGfNW?=
 =?us-ascii?Q?2/Cf/YzHz9885qyARZmrTYRxGO6Syzo3TGZmEwimsw/VQFfixHc1Qf96QPM3?=
 =?us-ascii?Q?ooU3Q+lognyihHnmI6deYHKSbOeGag+E6xNZw/kI0MRbijHGyrYlegYgUOCw?=
 =?us-ascii?Q?N2BmMxir832Y0U16hNivGDPtQO5YkSZ78DamASlcIm/I83m4DDhz+JqIMNsh?=
 =?us-ascii?Q?rorJsf5/a3ok6BezdgAQKp1Mvk7KgLMqT89xxZnWQvMvBIp9BE3TQhYYIQe0?=
 =?us-ascii?Q?fP0JzPDKAmtTEa9zVVcZd1qQ5EfrAUZmPdBK5SGLbSG4BJ/hATglN0fEGkrI?=
 =?us-ascii?Q?Cn38VqNSKcf944/3ZTPPnibykj20apdASEATSJHnic5Max/YnWYO5pS4ScMS?=
 =?us-ascii?Q?JswW64eCe3hvswFeUi0hMPvrv50GBod+6LKbF7omP5T0fP+H/R6GeHVTu5ad?=
 =?us-ascii?Q?YtM24e9z1eqaTbYjMX26//Qn8c/7joho6nIZOSLzUUgknEYx10eo51AihQEs?=
 =?us-ascii?Q?eCqbSfTXXRd75I8CRcjTSO4smZPnkh7P8pc1QJ9y0Gjxy9WIMqcZYcT/I/oq?=
 =?us-ascii?Q?NJRh2pdFHq117yStyFIF++EuN0fKLCm0ACZ2CE+PqA07uqt0MPTvMdpPMP59?=
 =?us-ascii?Q?+nZbOJO6cVL2J+JvgYYM+tDPOpQPXL1mfEWUPsKLlB7SQC/9M6QFYG5K6vrb?=
 =?us-ascii?Q?I1jcAl/aNnv5lxUPjm/jbarg37IRuyOzJk+Rd1PG?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f93fb57-1cab-4ca6-6577-08dc81cb50ed
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 23:42:21.6865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qBCwfDeB/ooubwzLPblOaX0vS566i0CwAOA3VOYBLub5+C2SSr7HuZEkVF/hSnLPWSGdJLKkrIEmREYgWaV9eA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB7983
X-OriginatorOrg: intel.com

On Wed, May 29, 2024 at 10:52:31PM -0600, Alex Williamson wrote:
> With the vfio device fd tied to the address space of the pseudo fs
> inode, we can use the mm to track all vmas that might be mmap'ing
> device BARs, which removes our vma_list and all the complicated lock
> ordering necessary to manually zap each related vma.
> 
> Note that we can no longer store the pfn in vm_pgoff if we want to use
> unmap_mapping_range() to zap a selective portion of the device fd
> corresponding to BAR mappings.
> 
> This also converts our mmap fault handler to use vmf_insert_pfn()
> because we no longer have a vma_list to avoid the concurrency problem
> with io_remap_pfn_range().  The goal is to eventually use the vm_ops
> huge_fault handler to avoid the additional faulting overhead, but
> vmf_insert_pfn_{pmd,pud}() need to learn about pfnmaps first.
>
Do we also consider looped vmf_insert_pfn() in mmap fault handler? e.g.
for (i = vma->vm_start; i < vma->vm_end; i += PAGE_SIZE) {
	offset = (i - vma->vm_start) >> PAGE_SHIFT;
	ret = vmf_insert_pfn(vma, i, base_pfn + offset);
	if (ret != VM_FAULT_NOPAGE) {
		zap_vma_ptes(vma, vma->vm_start, vma->vm_end - vma->vm_start);
		goto up_out;
	}
}

Thanks
Yan

