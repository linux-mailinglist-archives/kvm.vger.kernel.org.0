Return-Path: <kvm+bounces-26874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 76A31978B3A
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 00:09:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A96401C21C90
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 22:09:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39E531714AA;
	Fri, 13 Sep 2024 22:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c3FbuHBr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED035146580;
	Fri, 13 Sep 2024 22:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726265354; cv=fail; b=BjdttNS1OPc9RpGq/dhyGKBEx2OiFUiBEB/pBmwVbVcA24f7MNh6+tj/spvymuXD9keQBsqruCdOhgyGzL7dK0D30fXsFItjmnQOF3sEGVRzudaDkBNXA3CqaA4gY7eGTfjRNFf2ebwudT4eUQOsf9jB14NHOrJBTyCAWF+bIdY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726265354; c=relaxed/simple;
	bh=bAP2VpX2fpurLPXkmuOAZss5aa3KYcy1NJpZaiW03TQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uoRjVQGI1ZdWDBHWfJC0j49cQG90//2Ft8OOOQyN0e5bsFn/sMEXNCnP7imLxkzFQdANTMS0hnFWRZugr3I6SPoKIf4J12mPpW+LKkASLs3Ma+UGSZVQ6Pby4t6RKm474pwMZ6s/+y3eY933kbLlQXxv/JNY6545J3ztQLM7Au0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c3FbuHBr; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726265353; x=1757801353;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=bAP2VpX2fpurLPXkmuOAZss5aa3KYcy1NJpZaiW03TQ=;
  b=c3FbuHBr6dgHUA3X7zK+e/NNa29zq/yRRwIhKdFmaBK6XVzn5Dpk87LT
   D7qVEFU8FAM3mh7y3ddTX2tNZJh+LUHJUflcl/y2/aJ5vd2eHIUqHO1ka
   hfyAIAysXkxEvHI+KqncY2MVmC1gXHAiEij6CHeVDi3eyofxZ+6vjzr3j
   Ht6Wc7fDaUh3fEHKWIds8MC57gbAuW0phY5IQPOu5eAZyfLSom4hMMdFS
   /LyFJaYB4X/gHrIXLpcISDLzy8p9IP98HaRCMFYLSkXrhBOLgKm8jd49x
   K4878WrtlZrEIpEsE+qFe1ciNCfhjZ0nUNvsTr+4Qe8mA0frI23l8nRNQ
   w==;
X-CSE-ConnectionGUID: XZ7iF6UkRz+6sjHY+rDo/A==
X-CSE-MsgGUID: 3fL1KMsSTgyMN4No933HvQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11194"; a="35756115"
X-IronPort-AV: E=Sophos;i="6.10,227,1719903600"; 
   d="scan'208";a="35756115"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2024 15:09:12 -0700
X-CSE-ConnectionGUID: lyLk2Q4HTcGedkbVZcmW2g==
X-CSE-MsgGUID: ZMCQbjCfRve9h9fdlAtwRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,227,1719903600"; 
   d="scan'208";a="68074968"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Sep 2024 15:09:12 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 13 Sep 2024 15:09:10 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 13 Sep 2024 15:09:10 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 13 Sep 2024 15:09:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Odr1ZAnYHTpelgDB9Q7j72dXZDJZUYm+7InxCAqrxjcQBd2exvAjzZOeQ7xenJ+oU9nTZiGIHlqDKJOi+tguUYXrSzMMVnievw0IFr/zJq3dncgpxkiUbMzgF4omLdMhndgdyc7sWkhYJqrM0eJya34OOyPauHwEwVUSWm73ZqOhSQ1UA2PJTd7pSTvCcNixhQJGWOGsye0aaWHVgZ3xDtbxYyF0uHwO4qUgOoEM8j7AfmIPkINsKLAbhKxvpigxWPnKGfXkE5OhZ9oy0ltIrOcI3BIF8WnJb7NgUAK7vkrqcowy/XcelKySV1cIXXNb00MoejbL6thl+m2Pvd6tqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rsCftbEw7sldZR+QRKQkUlnCdHB08t13J9TvVoo7HFI=;
 b=NNqmiJdu2yjObJlH24R4UHPDQBpAvaHh5B3LuJNmfjjbRYpJK9qBr/y+NX+SPNjO7qIOtwWP4r9Z5CqoZlcxre+kBtSDuNT788+SDLz9CSvSmcvgJeUTkI4obBBmMJQR/S05ZLzRcgb9g5Tn4xdIQNo8rqjQ7r+nBoIIovdMIVUmfJYnEs+HioxawD4zn3O0EBmKJdmKY3gYOVjhIJi571Dhtdr3EHiAu5XlwftBWGx5sD6/g/O/jlY8f6/kI0MDHcH6+SqB8JE67Iavh1n7fe3tXLV707tKC53owIEst9OrcNOI91wXmFLdMD9KACnspMIHzkFo/FpcPajnBrJCkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by MW6PR11MB8438.namprd11.prod.outlook.com (2603:10b6:303:241::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.18; Fri, 13 Sep
 2024 22:09:02 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%7]) with mapi id 15.20.7939.022; Fri, 13 Sep 2024
 22:09:02 +0000
Date: Fri, 13 Sep 2024 15:08:59 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Zhi Wang <zhiwang@kernel.org>, Alexey Kardashevskiy <aik@amd.com>
CC: <kvm@vger.kernel.org>, <iommu@lists.linux.dev>,
	<linux-coco@lists.linux.dev>, <linux-pci@vger.kernel.org>, "Suravee
 Suthikulpanit" <suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, Dan Williams <dan.j.williams@intel.com>,
	<pratikrajesh.sampat@amd.com>, <michael.day@amd.com>, <david.kaplan@amd.com>,
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
Subject: Re: [RFC PATCH 11/21] KVM: SEV: Add TIO VMGEXIT and bind TDI
Message-ID: <66e4b7fabf8df_ae21294c7@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-12-aik@amd.com>
 <20240913165011.000028f4.zhiwang@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240913165011.000028f4.zhiwang@kernel.org>
X-ClientProxiedBy: SJ0PR13CA0191.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::16) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|MW6PR11MB8438:EE_
X-MS-Office365-Filtering-Correlation-Id: 646a688c-a0ac-4584-4b92-08dcd440ac7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Yf51nM0dyT8k37TEHUSPvrGYBcMl9hDDyCDdeQAmHMiNRuaZX3NKdmp7ShDS?=
 =?us-ascii?Q?Egjmn0F98o5AMlLVKBsI1soNkJVfNh+DpWqcYxQbsV2vpJEKcCfiKlNc2BSi?=
 =?us-ascii?Q?CqGsVLFD6vMBTGd/7aV13JAfmQ9Cc45KXg7/Hqi+ffpMG7daHP1wLxblRlau?=
 =?us-ascii?Q?JUB8J56u8RaIvqXQn2grSISftQmr+RQiHNs8vZhhLUKmwu7QbW/M2c2lHaPk?=
 =?us-ascii?Q?LjpwYrdRbu54UfH8jnAU0nbetxnqfWa7sTEsLAQVqdWG5RAovL/brx4aJPeX?=
 =?us-ascii?Q?xSs6bOKH5vlPFCilxwBldo3bLIm3Fovo4eUCI8kRxStoH2AXrzN2HSbGdUCm?=
 =?us-ascii?Q?nMYop4S4Fv7jBCgQ2HVQHnJOdVMhoxRsL1FJjzkvD2jhBfQ62GyqFuqueEKN?=
 =?us-ascii?Q?ojwKl61ySB2gvEj0YaxLbsMA3Qp1Gv8I+IApx9lUwpMheNDhd34DWeTlA/7/?=
 =?us-ascii?Q?OnZpOrGYRaW0qOqpCUq/2gmKkGmmtMkqqhFzIN2mA+Z1bwYNf47f7rQ6tsky?=
 =?us-ascii?Q?aLAukObBOACojI4b5xJB44+u/WLv+p1Fcp9rLNcOIg/peaZS9+fQ89AAAVDH?=
 =?us-ascii?Q?6mja+NhxwUgCRoGKVDXfFNUJc0CMIayzjohpo5f5WrtABp6qvT+0k2HwpuOe?=
 =?us-ascii?Q?xbv5p7X/+aDMLKRHtolV3ag5fBcYxn+8VB1veRne8+8N71Pe0E3XKTkAU5N6?=
 =?us-ascii?Q?Ne8gYKKe6byj+A4IRI9PKi43NsqLmJidnVtuh4e7cmoScRbY+0pfI3AAnDHR?=
 =?us-ascii?Q?yoRQuMsDiOlYurpzJ9kHy7K+nbGZjoliAOIi1mo7ATB4FagMlQCOjN3d+kAN?=
 =?us-ascii?Q?BsIDKDtDR3B1I1U93s+zcNk10kOgZfc5AJOTZAOyVvRoRKz0tapEEqDoAUsj?=
 =?us-ascii?Q?cx8V3MrdKFfBbD6KLRAwhU9DJ7PPiTJyLgUOfLCbcNl8CoAUQIRPBSQ7Jj91?=
 =?us-ascii?Q?3GdOFUUwagkD3RkoES/QJk406By3R1ewgQKHlIJ7FU21ArFr3eIHqdRG+on9?=
 =?us-ascii?Q?MfaXNM9LN9T26o+hcOxf3vsbKeqjBBmBDlmGij8dIHZWh3RiHMtwm8j1LOgg?=
 =?us-ascii?Q?h0h/Rqhe83/Fu/Q8j4EP+pIKJc05tacDziBOlc3qBOCgcNzPQP731EZEPYl2?=
 =?us-ascii?Q?ohBLhBZ9O7NmC04mbJIspX+MxpUIX/Cl74rHOraGCtk2+B5bs87zP/CtPvFH?=
 =?us-ascii?Q?n61UZyXZJ+J94rgKZCWDepNUlVUqqP/XIxr/taumCZhZbPppKvvuba5uYb+i?=
 =?us-ascii?Q?XdIYksNqVMkmk0mxjt3KmKSUD1z70/Tg5kH7pAWmIWAKZbORwW0D0CcblGBj?=
 =?us-ascii?Q?gCidRbu5TrazsgMRQJ/XTZGJUrPPQ4VZCRkhUc+TSrnQjA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UOEFy3wptIKDT9f8x1MNm9SlhnHKBHWXsBqN180N4vzBUZUJeYlHzoOJ/kRT?=
 =?us-ascii?Q?dyGqqdD+pPntHRW6kQeT76LPtuiMmogFHLZHf4fjQ+RQJwOi1tFVzeEXbVmc?=
 =?us-ascii?Q?WXHZduBWJyHToM3bh1PCGDYLjD+diRLrUYCD0EVHSnjkFHBbgkCJCIXvzdAL?=
 =?us-ascii?Q?GnJgZAn0WgoO34h3FLLUjWwkPBoIUFjEx+iKh8ntqsosmf5AfU77km6C0yf8?=
 =?us-ascii?Q?gPqUECZdM7DcmAD9Z5MvyHtcTJfF/VaelDCw0WHjhaJ2dhMs+ZtJRZOFZA6c?=
 =?us-ascii?Q?Klf/SDHzCuHCgob7vTO+yp17VEU1+nhH8us9kA//GVyAHvKNMrSmeb86Jn5c?=
 =?us-ascii?Q?Ml5v3q3A6eRYMRlrN0PFkuvVeaK+z7jKmG+2ucx0/XkiBdFXALWqVkElnPFV?=
 =?us-ascii?Q?wBNRCvK6d7nFp4Wv+x9DADfLMfcMQq/I3KT1M9Y6EN0b44LQ2BHvOPapgrtB?=
 =?us-ascii?Q?iNUF20Nm6zBcAD789Ft/qrmuSD2X9wUoFsf8zBxOsXCLzhRUbnxPtgQw2rlM?=
 =?us-ascii?Q?fiyFQPn3m1+9WUCPl92Wdaf1gKwYQAFSVeGmTWennS27HELBLGBOpJxpLPKb?=
 =?us-ascii?Q?iR5SKnIj22fFqOL4v3jlmYgjm7uuRbNdriK+vj5+n9dxq8RANvpMCPvgcvkP?=
 =?us-ascii?Q?nb3kOQfMSp8nsghXLFAiVzvXyYxixzuMzmP9A94/kPo7ziU/d3hCgltiSLXq?=
 =?us-ascii?Q?Wh7klJKYtol4brTj9jKS8FGfVQW6gudhk/kAOc0Ox9v709u6WLOY5uXAco+W?=
 =?us-ascii?Q?q8KFCSc/m+rQ6eC9cay7+zBDp5UCF8IQ7haljQrwMIT/CMatN7UcPcp8IEYB?=
 =?us-ascii?Q?qfW+dxyGSwcAYmjuRMXRj2VZGSWiqcUFp/DOvOBSsmtmvW2lRerWbG4G2B4I?=
 =?us-ascii?Q?JcO0HqfP/l1keeRgUxvME2+YhpBKRPLk6jb+CWdpSN7gifoMpB1BUA+7/UCG?=
 =?us-ascii?Q?yUOBOBwZJ+ZJr5TgWY37FR0p52lOKJQSufLQgNri4p4JjMvPN1beRAIXG4KG?=
 =?us-ascii?Q?nocOVykLazfzAnGM1Mq1utLW+dUKDMT34hr2jHIrfabPOwzjL8Qw/j/YW3QM?=
 =?us-ascii?Q?ZiOBKUIGK6H2BjH0o/YLEN8JCsV4U78b727AB7DsQrbRFB25DIpOqpzrTlEj?=
 =?us-ascii?Q?ZKe2ou4itRhPxoNEoCcrAkgnFtO8UXeWcBNWj+rVXSG55tBcXEPOkt4At7dN?=
 =?us-ascii?Q?Dpxcb/uKXWYa9c/RaFDGpFYQHWvWknmv9CF8Vf3oSd2ply4zhx0gf4pimdkT?=
 =?us-ascii?Q?KH4N6nwfh466g7YNxcqRpW2tPKbWdzU/UnKpxfwaRHtteoDZRmXh/T0dQNHy?=
 =?us-ascii?Q?yeTmIkuJDv4ZWaKd6k2W2VDgKsdGCM9ywKKFNmOhR55zYt6jVKj8lN62aMpK?=
 =?us-ascii?Q?Dg9d3F8hJsdjQqw3YnDXR2cUxJZbAro1dUrhHEvChcRRg/ckzYGGTmYoiv7K?=
 =?us-ascii?Q?H2ezJjBC6jiQOHBuNYv14w3Ep5nfjemnD4ytdfy0AUQkDd+rMnEEt1puwlnf?=
 =?us-ascii?Q?u3tIuyNZsGTyrBqXBywd7/qwguqI7kHFWObzFsOSUMg4HlUOMwgRcXDzgrIP?=
 =?us-ascii?Q?pwKtk9OT13YAWdInR9qGtD7pGdepNgk6dAapfPLt?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 646a688c-a0ac-4584-4b92-08dcd440ac7a
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 22:09:01.9386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rz7Y6ptqxRMijub9WCYcbOBbZ0B4Yb9lPEvOkvx1U/V24cx6xJHNOFWYsWF7b+FU0Nrd2LrVULCoYnVsMHqbXpOFXQJuInnnHNbfOfn13nY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8438
X-OriginatorOrg: intel.com

Zhi Wang wrote:
> On Fri, 23 Aug 2024 23:21:25 +1000
> Alexey Kardashevskiy <aik@amd.com> wrote:
> 
> > The SEV TIO spec defines a new TIO_GUEST_MESSAGE message to
> > provide a secure communication channel between a SNP VM and
> > the PSP.
> > 
> > The defined messages provide way to read TDI info and do secure
> > MMIO/DMA setup.
> > 
> > On top of this, GHCB defines an extension to return certificates/
> > measurements/report and TDI run status to the VM.
> > 
> > The TIO_GUEST_MESSAGE handler also checks if a specific TDI bound
> > to the VM and exits the KVM to allow the userspace to bind it.
> > 
> 
> Out of curiosity, do we have to handle the TDI bind/unbind in the kernel
> space? It seems we are get the relationship between modules more
> complicated. What is the design concern that letting QEMU to handle the
> TDI bind/unbind message, because QEMU can talk to VFIO/KVM and also TSM.

Hmm, the flow I have in mind is:

Guest GHCx(BIND) => KVM => TSM GHCx handler => VFIO state update + TSM low-level BIND

vs this: (if I undertand your question correctly?)

Guest GHCx(BIND) => KVM => TSM GHCx handler => QEMU => VFIO => TSM low-level BIND

Why exit to QEMU only to turn around and call back into the kernel? VFIO
should already have the context from establishing the vPCI device as
"bind-capable" at setup time.

Maybe I misunderstood your complication concern?

