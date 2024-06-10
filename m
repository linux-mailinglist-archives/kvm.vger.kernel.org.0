Return-Path: <kvm+bounces-19239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B12B90259E
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 17:29:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58DDE289B41
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 15:29:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E32B14372C;
	Mon, 10 Jun 2024 15:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QtDLSjNW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD95A140E29;
	Mon, 10 Jun 2024 15:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718033235; cv=fail; b=gXpjNHQ0/NZj4QCxncmhi5B7ZTF5Y9qDy4PKqPAmfqbWZGSD8EeCXIJ1gNoKN/Kj5j/oOQO+UbAizP4GSLH4qF/RPUwqHYOFQ6yPAxW1emzufKosAbNGQGkBWMjHRfQT0XNM+bi7YKpnCGzbijbfi6dEcfffYRCIwo+cdchMPdk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718033235; c=relaxed/simple;
	bh=5/cAN70ZdvhLQzpjM1rKIgNgLqyJc1CWePO/xkKz0zQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VI4Tlh3x+OAadnsrN1vUzRxA0TlOdZiO+cZrzfWpGvTosVJddxs0wY014kJwUImOq3FyBJt/l3JPuBgDW48m+IJn1/wiD8WmSo6RFSe7P+zWsLsDtFLHauBfbL97M5B8+Owx9raIDbbJQrEUVLXnT8aVGr7aSqHTYJQ2Fn/tOXw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QtDLSjNW; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718033234; x=1749569234;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=5/cAN70ZdvhLQzpjM1rKIgNgLqyJc1CWePO/xkKz0zQ=;
  b=QtDLSjNWNrEWMLOwNXKiO+IzHt3ciF5+sNhILyXUEO1Oh0YMVtPgLJsd
   IWd034dc2YYKG+A9nRybOgkjl29/PAq19p46NW2vCU011ujPtRo+t5dCH
   K4WXpsGcGiNb4u1PQKOt5+odr1pc3Imc4DsRfpY0ydmLgZCxU4cufaJFM
   C+Kve98ddH9VAxzzBP0VcX6UBC4RxvF6Rn87ZuxyRxVoBg8RfZseujEYo
   TvmC/3T9YbOMwwZ5OxO/CZxe+zBF7BSij0XLJMFCSRqfsUt+LjmfOixd1
   Np2eFK8j9um+8pg5MebvEjRp3tSqOybkM/qI6c5iYT+M5Cj5Q2a73gAoy
   A==;
X-CSE-ConnectionGUID: hhC4Q0+qTtKTfIqGL1usQg==
X-CSE-MsgGUID: aM5jQAUkS/yVVKBXbX38Cg==
X-IronPort-AV: E=McAfee;i="6600,9927,11099"; a="14821493"
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="14821493"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 08:27:13 -0700
X-CSE-ConnectionGUID: OwBOAazZSiSpFzlCyAF9JA==
X-CSE-MsgGUID: gH/ohJngQYyaYoar5IYKVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="43530905"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Jun 2024 08:27:13 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 10 Jun 2024 08:27:12 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 10 Jun 2024 08:27:11 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 10 Jun 2024 08:27:11 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 10 Jun 2024 08:27:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T5iAxzQPt26wZQIwhdOjhj0+37LbFxJlbE+E17vhAFG11IfnK1haQQld/EyKG5uN67ItuLmT41r+pSWTeEYuUz5NGwZ6nXB/EBz7a4oBtq4hgipqTNV0om4EpKlSeheF8c36QCMmJZP3sWkXpZhZps6Sll6YCkg19YH1fgxHaRhvDhD0imyoc2iVSdZ1vkzN3MNBm5HETr71op8wK+hbyohuD5owasgvBmGx/VyQ4Bi5eqa+vCG9Ma6iuKcekxTpOHIxr2LJz3H7XAOsSrXOLM3XDlTzy/v5aO+qdK6ssKlVrWna1whc+9YvJIIYlJBjl0Der11WtlF7HllZE8EKCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/7O5ofad0GIbjS5rideon5cGOn5cgRBhnC6sZgP77V4=;
 b=O94fcfF6JGv1NXBARXyphcWHMX89JCNqnzZUvArUemD4CJRQAK/Awup09M9YhJDtGLA+Jsl9erh6Qt2L6nuvflh82kFtf2Zc0lJKhonDBsnrFJiF+nMmyP31L3w/wkKwYOKYJ5RBPYPLBlg0AiNYCiC9mscQH9Xf+fBlcWqDYJqe8LTeajkFqeSap9XTzUOh5AU/gglezLlNldcK6whri3Bwee87LM6QnIlEtcyMuWh9F5ainkWbpaWBC3XAqtO483L212lu91n8Ac2I338OZiDdasyN+g3hHsD5/HCwr+8X313i1lEkvPduDP0KS4NjRcxtIup/LekOgM2HO4zTew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by CY5PR11MB6282.namprd11.prod.outlook.com (2603:10b6:930:22::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Mon, 10 Jun
 2024 15:27:08 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%7]) with mapi id 15.20.7633.036; Mon, 10 Jun 2024
 15:27:08 +0000
Date: Mon, 10 Jun 2024 16:26:59 +0100
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>, Herbert Xu
	<herbert@gondor.apana.org.au>
CC: "Zeng, Xin" <xin.zeng@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
	Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas
	<yishaih@nvidia.com>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>, "Cao, Yahui" <yahui.cao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, qat-linux <qat-linux@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfio/qat: add PCI_IOV dependency
Message-ID: <ZmcbNa4yn+/0NnTD@gcabiddu-mobl.ger.corp.intel.com>
References: <20240528120501.3382554-1-arnd@kernel.org>
 <BN9PR11MB5276C0C078CF069F2BBE01018CF22@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DM4PR11MB55026977EA998C81870B32E688F22@DM4PR11MB5502.namprd11.prod.outlook.com>
 <BN9PR11MB5276ABB8C332CC8810CB1AD18CF22@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DM4PR11MB5502763ABCC526E7F277363888FC2@DM4PR11MB5502.namprd11.prod.outlook.com>
 <20240607153406.60355e6c.alex.williamson@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240607153406.60355e6c.alex.williamson@redhat.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: ZR0P278CA0124.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::21) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|CY5PR11MB6282:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f35482e-fcc5-447f-d151-08dc8961cab9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?5DPRR2IVZdRENgwR5WdYEh4UqTWYcf3VnrrxoDf3SgvxCWNo6LY+FQ37brDY?=
 =?us-ascii?Q?/Tk0QNBLazyj2FUPElce9U9laXozgeVKvyioinsY9SjJACHD62i/+x8imED5?=
 =?us-ascii?Q?SyqfgB3UML/B/RYhPqxsg4sm764fwoPAib5uZTiJDqWLTMvfhE9TXI6I1+Gk?=
 =?us-ascii?Q?iSob3/FZ/p4SdLmV+CNu/FjKp+s/H1BTWdjgx+WZ6wFYUIVZH/AHaSz1pzuC?=
 =?us-ascii?Q?WL85/WRfD/T/Go+Tp5Nf8HlHTpooVGMsTj4J264FXawENRhZdxAEMq23I3Zo?=
 =?us-ascii?Q?CMK+LnNdJBXYTzFLDmq4NvaQa9x5Xhc3Kz2axKP7Ajy9efiAq5iyoSK9Z7VO?=
 =?us-ascii?Q?oGl6Hka3EWudg+Wwp3ryPicoF727sJnI1dXmJ3TJh9j0ABAhJzMryeEyKC/l?=
 =?us-ascii?Q?40zYfmwT97pbf3j10fsOz5e5Lh/YRcZJ/4fcZjk23aI8nZd5m7nQzIIMYeV1?=
 =?us-ascii?Q?wPc0CHv8mEukVJrVHaJhAulPQuyke82TI7lvb2QGACEUDgG1ShzjQXb3tUJV?=
 =?us-ascii?Q?sVn6Do3eVz7rcjU529yuzO+UDoXs9CgZhoY8goUyYoA70MMJIZdDgnGs3cX6?=
 =?us-ascii?Q?5WyYWRnJ3qznoCKxOwOdsi0QOp/AU9x6Qu7tHM14yBRmpD5WwRZ1c3zWZuhe?=
 =?us-ascii?Q?FscPZDogJAmn6NHWoai1GQHZrSxuSPmDIUqV4fKFUdB17nQ/EzLGVcVx2X2H?=
 =?us-ascii?Q?z4ZVFi6F1u4FZT9p+VfkR6CC5dsUjPjy/1wHEs4e9FNf+w2Llj+ZbWqKUU8I?=
 =?us-ascii?Q?VXnAyUfS2AsAEKpyKOSORGXisCLoTo+Oy7LUvg9H+q/K2ufCW3Ices3d7Fb8?=
 =?us-ascii?Q?ggxY60Ia/H67Wn6IIUH4J0c7hEfZWh46Q9kb94tifHUgmxZJj/3p9sWz280K?=
 =?us-ascii?Q?r06ezpbt3cxQ1QO8ZwdSaSD3RdgaS/slDNutaVrgkaoBaMAnz+gdPiuC7c3r?=
 =?us-ascii?Q?vioIi+UebpRbpiub9Nza571kCzXwRlc/ifG0DW3S988BVQx4zdm0SSaLuYXm?=
 =?us-ascii?Q?4HgyPT1CusVcEnYUG7PC0CjV84jIKmYg7yUPslh4OjHQg32pzRJT+agB4aOI?=
 =?us-ascii?Q?Na/HxfQw2ynAvE+PqR/w/aFw+okUKDp6AXoW8hRCto+GwjLCOPvlegPT+qu6?=
 =?us-ascii?Q?LWd0psaHFSe6UID+yoo5MPNs4BTqjamvTf3s2n1uQQ3I+5mvfxDYUJAoXjv+?=
 =?us-ascii?Q?eT9zb61tQlhz48Rgz7SzENHXNwtcQz7t77j3cPXw1LrAD1yOFRDXXpbK0+iI?=
 =?us-ascii?Q?iqYrrDItjlOaj2EJDmyA2rSnW8ZcqFbXlkE5tM6aGPrB2TGs0GO20M1NcPdH?=
 =?us-ascii?Q?WdY8GXCVSGUZdCLME9ZGpjAo?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KD4pkGeonT2eBOfXdfyFvhBjT7A4CUdaegeU2sUhHPUOXuwjdC4cLxkwweqX?=
 =?us-ascii?Q?7URIIn28+YtRLjS343+2yOgRYYy4j/8Rmk7qmz+PJjdV8AfGWXi/tKu6p0SB?=
 =?us-ascii?Q?g1yUiB0nWSb592AQQlZLtKNlyF6PEAP5jFod0wy3K/As45WDGxsBQHn0lYxi?=
 =?us-ascii?Q?fK1vIBcfpf0qNd9G3DQQz1WmDFxmtnaj6LHzfJkUFnU3DJbtd3+cUuaiqqdu?=
 =?us-ascii?Q?E0v2qYsHO/xJMStb4D4/CuRsFsYYRgAiuJQPtpjvzRvON+WtwVFurJaNN2tb?=
 =?us-ascii?Q?V7ZOY6qfA1fwhWM5lfgrWmE1tNjqpuPMlWVjo+xNBR4tHHQP98u8P6rG7zyM?=
 =?us-ascii?Q?UG/wb3jNwGAWTVg7yhWzJNLsmu1WDtQsoWtI/LhwdE/C74cqo75qRPd+jq/n?=
 =?us-ascii?Q?QdsjReMEQxfnk1uYH96mCyYiR0Cu15lVdZD/D/GNSoUr5uubrwKKtI7xQB/O?=
 =?us-ascii?Q?/BuxS8WuCgYQ8XwNXDiMpOz979Xia9w6eDWyJF/YlSwOVSJicYq1Xgfz7PwN?=
 =?us-ascii?Q?/kE8Itb52mJ7/cCifD2QA6qzTwUo8FzD0BeJGA7KcUAQNlJ93MfcVAwkXezy?=
 =?us-ascii?Q?ZyjaDRhl3YnqyQnC1o9SNpkdiq/rOIRByYqgoZbjFvUVuWM0R8CFgR2+KLzL?=
 =?us-ascii?Q?dhR+xFMC+jrnfutt56cPvhgY6dKvNDytFIjg7uSsrtM1ZnbJWhb5wewvoRat?=
 =?us-ascii?Q?l3hHgvAb/561gZERH72/NMQv/QWvyWEzhwMmpLJUVeZbc82jft8KCmh72jjE?=
 =?us-ascii?Q?I1iOAMN7o6iVlb+a51jQxknQjYSe3rzoSWUBIeco9ZSFxNaba6tRVYcNJX90?=
 =?us-ascii?Q?EMOruaSbqQEIVMseOXwlxTelZI+bog0LPb7XPQ1PRLZxzQx9/IgrF4eEc1i1?=
 =?us-ascii?Q?OtNNq2iNjktHXGud5ylw0XNCXUsalxraVRwa+m6J21szeipIJS68kh05BWAy?=
 =?us-ascii?Q?6bYeq7Fo0cOlCmcUzYU/RNDtviAHIE4jfgsyZK72jIE8Puislb27ouOj3D7i?=
 =?us-ascii?Q?9L8zc/SJy3B56eomkJ1vafvx4ezDnyCLW8gSr1WygWfR5F4ipcYUEABlQ7ua?=
 =?us-ascii?Q?k4IDyO/HDm5liuqYr4Rnqt46hgG1zDpbsM1ug2uQJ/2JpZNC/DeJqu4ZTu6N?=
 =?us-ascii?Q?epjhBLXsk1FHgdHWy04onHDQStnkyyd1b8oc5UOGr1uTnZVymSb2UX5F6spq?=
 =?us-ascii?Q?yJkxgrDw447PShfnO/t36jK39gVPf2eVU6RmeaVl4wJ3ow6xIzJIDTgsTZtT?=
 =?us-ascii?Q?VkeROx5smxcp0dJpPVu/MM5HRKA/DwxglaptapH+vRDKEDVadVyq+fqgk2ch?=
 =?us-ascii?Q?TSLLH1xUH+DhqR3a1NLD3ltSBd27LelhtXVlSwJMhOMwTq++cHn4XDJna6bZ?=
 =?us-ascii?Q?uxpM7u1ZbUuwZtv0iqdCm/Ly3XMid073vpA5g1IO3/lkZPTN1Sfk/33b1Oac?=
 =?us-ascii?Q?T0PlvuOjoma520n55dYLoIrftbHG4QI5WdbYh/AhKHMmVbMEepyQnwA/F/ra?=
 =?us-ascii?Q?9rMVso+1fjjAHfubS0kw7PMju0AZ+l+U1vQ3o9cSe0Z6Yi8Y+aXloRscTDhK?=
 =?us-ascii?Q?xw45Wlg5ITY57iplG0VwJJ1YQ7Z5fzvT5CiPi8R35NVFvijxDhf4BSGQFMqZ?=
 =?us-ascii?Q?dw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f35482e-fcc5-447f-d151-08dc8961cab9
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2024 15:27:08.7338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5ItRFNG5mwiBi6C0UDqAFrrISnZT9yHHS87zCdcfIJQg37dhUVcDM3qm8ptXpueb+8CsykHOD8BqNM/CBUhgIzu2t77wCpktDF4nGRmL4/I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6282
X-OriginatorOrg: intel.com

On Fri, Jun 07, 2024 at 03:34:06PM -0600, Alex Williamson wrote:
> Is this then being taken care of in the QAT PF driver?  Are there
> patches posted targeting v6.10?
Yes. This is being taken care in the QAT PF driver. Xin just sent a fix
for it [1].
@Herbert, can this be sent to stable after the review?

> Is there an archive of qat-linux list somewhere?
> I can't find any relevant postings on linux-crypto@vger and
> can't find a public archive of qat-linux(??).  Thanks,
There isn't a public archive of qat-linux. All patches to the QAT driver
are sent to linux-crypto@vger.kernel.org.

[1] https://lore.kernel.org/all/20240610143756.2031626-1-xin.zeng@intel.com/

Regards,

-- 
Giovanni

