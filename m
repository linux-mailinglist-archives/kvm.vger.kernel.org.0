Return-Path: <kvm+bounces-20037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E03C890FBD1
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 06:01:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04DC61C2192B
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 04:01:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F95228E0F;
	Thu, 20 Jun 2024 04:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OhLwUy3z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891DDEC7;
	Thu, 20 Jun 2024 04:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718856053; cv=fail; b=pwWTkDNMGFkCdpLA+A4iMpCHOmSshZOCDhHBCtjyuAMjwANRW++fCNUB6YYwDqV/fSfOci1GRkQKUqM/wu5g+r+xx2J2m/VmoK4wJIvMDjnilEL2Ju7na31Hvd5Uh5P9KuX9Xl9e35acI1sV3pibhnemDjbZbQSowkGaFA2Pths=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718856053; c=relaxed/simple;
	bh=xnxDkmK+fxGtEA2Gpgp11dq5yJEGYSXNJVlCRdAvt5Q=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=puOIo5mHCaRULtQZeCw+DjtAzVBIC+FK1jOWJYV+AqnLCVm+dVojIfMGKX0DGEqUKwUjKCf4Ujb2MZsgM7VCcRTTm0TZ0LE8OIu76Ke6t/h2QDK3GN0is153fZcaX023Lkiosj1K7q3vrG3qgj9DPFRmafl03P+MM2zUMe9VNZY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OhLwUy3z; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718856052; x=1750392052;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=xnxDkmK+fxGtEA2Gpgp11dq5yJEGYSXNJVlCRdAvt5Q=;
  b=OhLwUy3zgQSC8bjqjOtijbRZZJ3ejle5DMrMYAtzpVnGe53DMxuvK+f1
   1fqOkFPGcchcmDeCZus/xlIIxeRGAifXjyLwS7x0p8MG0wj92zJyM7dKe
   J4Ho+3cl8vdu5RJuPvMusTVwgsEg3QjRncAau/3YM70qbKJCgr4tnqbBP
   CBnP4IexZPGJSQnCsyiPlMKG2nMEXOLP+BJsy7oq+7iWzu+s6RfGRumYP
   KXW+34k6o04drvFzUU5uS/0Vn6HW32q0ARNhzJZaUWOBIxRHPuguGB+dY
   1qnSsQ8ZhRlXd61FPL0E5DSHerl2uC/ZrkrlImrguWnoKT6Bq6p48RiSA
   g==;
X-CSE-ConnectionGUID: 58Z5wRqJRQiLiA5GUgJk6w==
X-CSE-MsgGUID: c1rbjawBRAmeJ0YkVpyFwg==
X-IronPort-AV: E=McAfee;i="6700,10204,11108"; a="15932122"
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="15932122"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 21:00:48 -0700
X-CSE-ConnectionGUID: +OQ060eTSS2cecnFqJVEBQ==
X-CSE-MsgGUID: 6OcMAJNbTCGy1rF0V9SqqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="41927975"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Jun 2024 21:00:47 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 19 Jun 2024 21:00:47 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 19 Jun 2024 21:00:47 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 19 Jun 2024 21:00:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D3WGLBVtw2yro/6rXhcDjgxKleFOP13bCEO92fR+k22zJp2VZJ/A+DYAMbZVJmnIoqmNtKIDWIUDgAUSCK7mNEcVGphBGKqR2kjoaqNHm/wB3LXW2EgA3RL6scix27eRe9uV7MNmMSZK5uUXPrBhckB1Yv5oTzYeTHm00MoQsI7t7QwfjValpf5HJUBhTni/P4WB9PUo6sFf6WvyLDM3c4q4bffuacSGUNgHRjsSQka2MxHF7KBaZoCXlxFqxI6C50vj5+TRmkQtXgXAd8xkDh4n9rjB1hFm1/1lYsrBETuJSuhnCsXFkwQv57OvKXEo/6CUtCJXV/gqhg5A1V0Fnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EDCqideasCcU3cwV4+1x9+zz/EUFeHmBaPxY17p7dvY=;
 b=JHXS4A8T2rrA+RtnAuaAUXKc0w7unKPKyMqcsoOtkMiImKgEbONwk65lROLm9EN2rFLmEzKJohIUYy9pPz0OEsiSOBLEoFi73J4AT5xllaHVk6ko1HHyDgIh8WJLbCPt7FA+t3Z0F1TsuNdJQmwa4i1b2arTFGF6X6DNycqrKPEyMvkPKSlULhICdZ3L215zbVvhC0gIfG8Qs5WBgtbL9iJ53qVVd0QYtVE647ndHAw2FOY0WtXzKv5x+mr48Y+l6H8vT/95fg1/6seZ/7JKpf2ztL8UiMnUNzfGw8eOvnLFngXJJLGUNgmF3X6sbV/P226bH77t1nCgvSr3QNloQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM4PR11MB6453.namprd11.prod.outlook.com (2603:10b6:8:b6::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.31; Thu, 20 Jun 2024 04:00:40 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7677.030; Thu, 20 Jun 2024
 04:00:40 +0000
Date: Thu, 20 Jun 2024 11:59:31 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"sagis@google.com" <sagis@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "dmatlack@google.com" <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>,
	Erdem Aktas <erdemaktas@google.com>
Subject: Re: [PATCH 0/5] Introduce a quirk to control memslot zap behavior
Message-ID: <ZnOpIxUkQpbMDY4x@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240613060708.11761-1-yan.y.zhao@intel.com>
 <aa43556ea7b98000dc7bc4495e6fe2b61cf59c21.camel@intel.com>
 <ZnAMsuQsR97mMb4a@yzhao56-desk.sh.intel.com>
 <ZnGa550k46ow2N3L@google.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZnGa550k46ow2N3L@google.com>
X-ClientProxiedBy: SG2PR06CA0203.apcprd06.prod.outlook.com (2603:1096:4:1::35)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM4PR11MB6453:EE_
X-MS-Office365-Filtering-Correlation-Id: ed997a90-616a-4c00-2f67-08dc90dd8c75
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|1800799021|376011;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?JlWWRwcSnd6rxz6Ew37tU59omz9NVRJ3Z+BrJh4oJocCKMbOxyCxYfqfY4?=
 =?iso-8859-1?Q?mcWdcqmiKqwEXxbEkunrzanKtCbIu+uhB/lzPKpGnCqzv+cG484QtBcT3n?=
 =?iso-8859-1?Q?+h3vlHU0Fui2NLte43zqPu+XwrvQxNNc0AiqYiyiaZ0I9amT3VamCRZnvR?=
 =?iso-8859-1?Q?BUywcxSlvBfBnTMiko1oSj9gKwADE5UqWjmtHdar+p/iSo3NF1USgh74fX?=
 =?iso-8859-1?Q?Pze0kky0ultRI4sTYSrRcP8kOOKPBzTArsJPjyma5+OLiX8lMVGPLIrhFv?=
 =?iso-8859-1?Q?BCX4sGbZDhXOtfjP6O7ZJfoJunO7RyX90qod76InNMTbLRfOv2Sk5XhUvr?=
 =?iso-8859-1?Q?op7ho0Fi5yOnHBEuwcZpi11hzCgN+jg02kT3gKYMfB4FZOmBiZjZ8CPaS4?=
 =?iso-8859-1?Q?nbFXi9e3fl3ES+NLewUY3WlfzyRQxFcBg0uYoi5de++qcbKCI011rwcOhl?=
 =?iso-8859-1?Q?USEvlQZpH4LqLDsquaB8CeExIolMR3UY2ygIBVSgDmEajVb766QskymFZs?=
 =?iso-8859-1?Q?hHg5fUS65JfU7QYpFhNBKRp+SlYVs5imVg8XfJv7v/WsBb8ei6ZQK7iJ5z?=
 =?iso-8859-1?Q?iA1VtDo7SP3tJ8UX9ZIH+Z0ghfSIYqATB5XuhrSp3oRwVm7RNrkHSS2wqW?=
 =?iso-8859-1?Q?89CSTD44LcJKtowTLWd0fvU20O2n8dMiE0NWsI6MY53c1T2FLWA00d7L1E?=
 =?iso-8859-1?Q?0AENXjgs/tQttOsZjcQW5JNW0B62tKewHUeFnDDEEWi7cviEoGncLdbObk?=
 =?iso-8859-1?Q?wg0O/jOt2nonq9dSV14QSCrR1ltiUMynnkcXX4oZxjrcvKkDHpWd+zYz7Z?=
 =?iso-8859-1?Q?Jh2TkAgUU2VD129mXKexRUgUpYZCMXY+2MvmYAHQgJFhqIuVAYT18ABD2q?=
 =?iso-8859-1?Q?UDrBNoN0Dk5HQBoj8xx0aq1LV7vgYSVpAFTd0dZ+gdjJ7btw+LzXSovfya?=
 =?iso-8859-1?Q?vMfGtSIge9AHvK5EvnaQBERbFy+7KhU1rI8sLOOFQ1tx+bF5Rj2EpESkj0?=
 =?iso-8859-1?Q?n7a2d9vxpNUVO6RcClkanEch0aYJmoZvIMhr2OF1q3ptBBdiG2Jcx+X3I5?=
 =?iso-8859-1?Q?tbIm5GqrRiC6qWDkLuTtWDC0vzKRBhSsEtSqFkfGeCN8wAVxzvkt79R7WM?=
 =?iso-8859-1?Q?7PpT1KMN+IOLLnzP39TLF3/xBl/kjENkSLjNQZkuuHAFG+IWe76eWB3P9X?=
 =?iso-8859-1?Q?1rQy9OZwNTCAqwWkkjyw6bVEmOTLrY5Nvga87HVmnc0ge9vvEp9gSXj4k3?=
 =?iso-8859-1?Q?5qvZTFGm1cSSWBLRXl7Ika9kIuog4SAxrciU7oR36m8kNbujDaKyysAWWJ?=
 =?iso-8859-1?Q?+NVullqg/4IiqsEt98mR6eXgZ2F/UtJ5+M0KQTQ4CcueMlcmyBzzGcXTNE?=
 =?iso-8859-1?Q?uTvDW7vJfs?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(1800799021)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?tizmpZzOuhZCiW5YvOyS3kM4uX3quxKYPD5TnnPmjAQDnXJOH6qZuOTzBx?=
 =?iso-8859-1?Q?J/M4mH39wKN2hkTtN0qcdDnEH8YiYumUkgh/8n7DufFpXNUK9L+zBJ8uZF?=
 =?iso-8859-1?Q?8Twn7mzlM/ytSVDwWV3ZNQwuX/IFdbAMU/xZv+JQXoMBM55PfWiZ9ZdfaS?=
 =?iso-8859-1?Q?kzToMgjPDfJ33aGpLYXxZNvGde4zkGYm54PiOzpITdsmNnTASujkyz8thm?=
 =?iso-8859-1?Q?Rqy8IxXrubIcxRaAEWqyhpGvXyoY9GkGICUKbbKAV0Mg00ewyYYqps9Aq1?=
 =?iso-8859-1?Q?lVns4oeyBI0qk2A3RbCShyoLXEnKwruxhTZff2T/nsKWllqO+UCwMyG6KW?=
 =?iso-8859-1?Q?lGcuavr2jEC4Mx0D9a0v1zHJlhSnIo2wXd0mKJjqUVZYwWEUYAuuXqFXZB?=
 =?iso-8859-1?Q?Vfa8LwG1X4WD5rditQ6P6n+iUUsLZ/TSUwmj9bEce79Ct+FVIlk1uMhMMQ?=
 =?iso-8859-1?Q?i4MwAFmgKg/cmqJ/ZTP8hfZe4wwUcQBSJy3Q0YI0x4I1esSgGn9SbNIXI5?=
 =?iso-8859-1?Q?I8d7hcTd+wvAN0JgolPOpffBBIcytSfaolOOCmz15MBW0LTghD5CwPOJKG?=
 =?iso-8859-1?Q?bjvGCPKkW9ATT0F+oqA/fxMaWGQCS27+Ri7ECd0gP7rjQCEHG+wjkQdgZd?=
 =?iso-8859-1?Q?7ZpslJ1tyhIQzFdlYS3MVkkUkIvQZltnZ2gUK5pdIF+kspsgKTyaSyPlgs?=
 =?iso-8859-1?Q?VROHlRVJadY5b76/ZXDRUisjqZubjKWgujIDtG379TojtIeMRb7EuYf1AP?=
 =?iso-8859-1?Q?KisdSlbIgDUywfcTVBIbqmvnQYZ260H1EmKHBsbXEVXYVntKZb+oGfWB6P?=
 =?iso-8859-1?Q?e7IEYLM0jG7z5r85AHyOfx1lqflxWXrQTBCLn3FKu6v4yk9Qqdz1kSetBo?=
 =?iso-8859-1?Q?C8H/zx8P5ZoU+fGFV9n3jT7cqz+8Eqrsj7hQyfzw/0KMXZsfPB7MZatu+q?=
 =?iso-8859-1?Q?dfMbPa/QGh3bxcYVAxQQTkH1q3NOIVUda0OGXfiTgX2OzyfIrL+YrWrtw6?=
 =?iso-8859-1?Q?n77NxRixXRBdwgB0Olt/pR/0p5EVR6MYCW81aK0fn/RW8dl97HSuNj1MHG?=
 =?iso-8859-1?Q?64E2aFmJqqKaxzthm596qAqoj+b+LXky1tlQWgMJffQLvCxf3bTfemyaFK?=
 =?iso-8859-1?Q?0wNCR4AOk+jr61Gn4FVUOlP7Jp+83r4LJWN8hkilKKzzavHvgBqbivaDX0?=
 =?iso-8859-1?Q?eDrYuqzQP1af7hbDT6LufBqKK+AmYDMh5FanNZHE+SIpqIZMo0BSVv/Hs/?=
 =?iso-8859-1?Q?dqosqonMDr+L1Awm5MZETJDJrnFZwnms51x/9iIJYL4i4dekiB0s8nR3er?=
 =?iso-8859-1?Q?vzFAC1ai+qFYglFLTVNOvfdPR6q9MJijS5tJZdUcbvs6DwnLE/ntvNZLNQ?=
 =?iso-8859-1?Q?Pv53lddhJ5n6YVhgJs1bM6Q6x75UZUdqYfVGYQ2AJQLxv1y6EGNKhBIAZb?=
 =?iso-8859-1?Q?iC9TQ9JCFMVOrzHxibRPF87g3aPlnzCaAcGOj6rdYkYA69BCho/6POyRz6?=
 =?iso-8859-1?Q?HTHeZVwvRmDsro+X4+mZjSxDFwY0XAJVTVzUxe17NElZHvpr+AFwLnrCoP?=
 =?iso-8859-1?Q?2YO8ZeZ5x2mhz6+vDeFuD6EyIEyrvhnbSeMrlBHEHxhQjXpql7UZO7Lbre?=
 =?iso-8859-1?Q?N03qoi4rAnbaLBnd86vT1fQtB/zny1tVmB?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ed997a90-616a-4c00-2f67-08dc90dd8c75
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 04:00:39.9755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4hg/oILpi8CmxExySL4u+VtCWRkrLv6RW94xH9bQEf6p+NwNBTOhOqWjuUDAPoVVY24U0BeMz5fDFZ6P7uzlqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6453
X-OriginatorOrg: intel.com

On Tue, Jun 18, 2024 at 07:34:15AM -0700, Sean Christopherson wrote:
> On Mon, Jun 17, 2024, Yan Zhao wrote:
> > On Fri, Jun 14, 2024 at 04:01:07AM +0800, Edgecombe, Rick P wrote:
> > > On Thu, 2024-06-13 at 14:06 +0800, Yan Zhao wrote:
> > > >       a) Add a condition for TDX VM type in kvm_arch_flush_shadow_memslot()
> > > >          besides the testing of kvm_check_has_quirk(). It is similar to
> > > >          "all new VM types have the quirk disabled". e.g.
> > > > 
> > > >          static inline bool kvm_memslot_flush_zap_all(struct kvm
> > > > *kvm)                    
> > > >         
> > > > {                                                                             
> > > >    
> > > >               return kvm->arch.vm_type != KVM_X86_TDX_VM
> > > > &&                               
> > > >                      kvm_check_has_quirk(kvm,
> > > > KVM_X86_QUIRK_SLOT_ZAP_ALL);                
> > > >          }
> > > >          
> > > >       b) Init the disabled_quirks based on VM type in kernel, extend
> > > >          disabled_quirk querying/setting interface to enforce the quirk to
> > > >          be disabled for TDX.
> 
> There's also option:
> 
>             c) Init disabled_quirks based on VM type.
> 
> I.e. let userspace enable the quirk.  If the VMM wants to shoot its TDX VM guests,
> then so be it.  That said, I don't like this option because it would create a very
> bizarre ABI.
> 
> > > 
> > > I'd prefer to go with option (a) here. Because we don't have any behavior
> > > defined yet for KVM_X86_TDX_VM, we don't really need to "disable a quirk" of it.
> 
> I vote for (a) as well.
> 
> > > Instead we could just define KVM_X86_QUIRK_SLOT_ZAP_ALL to be about the behavior
> > > of the existing vm_types. It would be a few lines of documentation to save
> > > implementing and maintaining a whole interface with special logic for TDX. So to
> > > me it doesn't seem worth it, unless there is some other user for a new more
> > > complex quirk interface.
> > What about introducing a forced disabled_quirk field?
> 
> Nah, it'd require manual opt-in for every VM type for almost no benefit.  In fact,
> IMO the code itself would be a net negative versus:
> 
> 		return kvm->arch.vm_type == KVM_X86_DEFAULT_VM &&
> 		       kvm_check_has_quirk(kvm, KVM_X86_QUIRK_SLOT_ZAP_ALL);
> 
> because explicitly checking for KVM_X86_DEFAULT_VM would directly match the
> documentation (which would state that the quirk only applies to DEFAULT_VM).
Makes sense.
Then, (a) looks good to me :)
Do you prefer to include the document update (i.e. the quirk only applies to
DEFAULT_VM) in this series or in TDX MMU series?
And it means the quirk will not be enabled for all other VM types, e.g.
KVM_X86_SW_PROTECTED_VM, and SEV, SNP..., right?



