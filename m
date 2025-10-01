Return-Path: <kvm+bounces-59377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 125B3BB20FB
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 01:24:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0559F7A2D49
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 23:22:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA5B32BD037;
	Wed,  1 Oct 2025 23:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TDc/Fte7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDB4228CBC;
	Wed,  1 Oct 2025 23:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759361031; cv=fail; b=vA3DiIKaS/nWvcAMXxogb9GyFvw9K7mwlp/P+Y0dDS4MpHmm0B1cx1O2seXsfS9F/uZWqZ5Lrmg7oP77SL28OL8q0naorNl9bNJclikHKT4qcHjEVcHVIz6i6Bs+ByhTbIW7p0EFsV9dbgeBhXd0YUaGrhPD/9btVvruPQ7gg+w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759361031; c=relaxed/simple;
	bh=3pyr2GhjtRUMfbj2hawwmC/ZU72Yuve8VG+CTmvCeOU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mxZnLHeRinOfQ6WuE6FA6bH9n+tPwM8Jh/o5trojUkgVdBSPpQ33EXYSos85ZgywhNmvNK0n+ENHkyXTiUqK8nSFJznntBIcHrPUbHwcXg6x2ikbMPcr06hkrRHXnWZy9Nh5XCsFMD3eA65kFVck+li+8SsMYNw/xLL2OLA6aBs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TDc/Fte7; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759361029; x=1790897029;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=3pyr2GhjtRUMfbj2hawwmC/ZU72Yuve8VG+CTmvCeOU=;
  b=TDc/Fte7gF+TaoLBp/3g8KYPvTVfcGkcTN59NGkLBN0i+EW6e8bfFCLd
   C4L5880qhUneikNldseHxR7Bk8swpa6Hk1K4Izn/Jtr6DRKAQL++K2jNR
   xzjqPWtiOyuu14YUbz+G3vUDL2ZATIKiNCIVYtIkeJ8eQ0TRMIMyYWr8H
   FrFRsTRUzb1rmjdK6rDnlq6/JxkbPqsKhU8iX1THsWSHzUh6z9ke65g5V
   jqXpI3OBTjATVew+iU/3Tbg4dzy3XwLSoQtCF4t08g1R6lZGUBLpyCf+U
   W36M9MJxE6sLqKguxFvsnDH+PLjQdbB/ivy+L6xP6NZ26XBwFaiI+5zUC
   g==;
X-CSE-ConnectionGUID: 0PSiORIIR0ikbWMRO5jTzw==
X-CSE-MsgGUID: MdNV9lVgTcm5O0eMEYa2Jg==
X-IronPort-AV: E=McAfee;i="6800,10657,11569"; a="61535719"
X-IronPort-AV: E=Sophos;i="6.18,308,1751266800"; 
   d="scan'208";a="61535719"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 16:23:48 -0700
X-CSE-ConnectionGUID: HKRxCuwHRjajVUkhPzr+Fw==
X-CSE-MsgGUID: muEOyuOORnaC/dDGv4F1zQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,308,1751266800"; 
   d="scan'208";a="178944654"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 16:23:48 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 1 Oct 2025 16:23:46 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 1 Oct 2025 16:23:46 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.41) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 1 Oct 2025 16:23:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yV7XzD4sBdTQGDhqPJ3tLZlU4Et8iSf44MUBtiygsxOnZQlZa9L35Ca5g6We0WnaDfZIgPymVPgqSZpycOxxiEaqVOJMzO3V1f3s1U0MXsw8wsDO01I5UJNzNcBgsPfFya4f6ngdBZlh4OrUD+XKAS4lGo2zrT15ibaWNujSBmYek/gOWlfyBQ/d76CmmuSQkUqh5cxGFDuTgTI8az1R2ufBwxNp4RCRnq8SGA/rqZBrZpc+idNyrpAamgcUA/hd8FFQQkTtWC4yGp8vGKcF6JLHccBdUT0oXcGgMIAqFxbf8+Oi9N0se+FysHM7ok5g/Rj0y9yDKZqsLOVNOfR8DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KZKZ4hAXo0nNYwEuH02X30D29YtnjA8/+bba/Kh7GmI=;
 b=kYSl5JvAUBqfs3Z/0KrvejOD9cvLy2JsmLOsrk8OO/gKG9ZS3oC9Qs6Q4RCaeq3Na/3/YrndPfDG0K1FJ4Aqa0DaoXL2Pw9XsKNlBnRVt/AdOsR0U5td3IxPr3TOtTPkbbuKNt2PbTrYE1dV7ul3jhr/0jBkWWTgDz+2B6QkoLoOK9He7uuLUkpAfEYardVlBANi9bSiXzmRlXiJzRsHD8sso5gXzkOgJkW1oDoxewzh2AbmFg8dVpkkdLTVOzHycNTsdrwnt752IhSTUaYMCfEpKmjJFojrHfcCGuPRygQ0W7okor4fswAWOBPWVn+5ih8c3qmn1FvkQR4HisNK8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA4PR11MB9131.namprd11.prod.outlook.com (2603:10b6:208:55c::11)
 by DM3PPF96964A2A1.namprd11.prod.outlook.com (2603:10b6:f:fc00::f3b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Wed, 1 Oct
 2025 23:23:43 +0000
Received: from IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2]) by IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2%5]) with mapi id 15.20.9115.020; Wed, 1 Oct 2025
 23:23:43 +0000
Date: Wed, 1 Oct 2025 18:25:47 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Ackerley Tng <ackerleytng@google.com>, Sean Christopherson
	<seanjc@google.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yan Zhao
	<yan.y.zhao@intel.com>, Fuad Tabba <tabba@google.com>, Binbin Wu
	<binbin.wu@linux.intel.com>, Michael Roth <michael.roth@amd.com>, Ira Weiny
	<ira.weiny@intel.com>, Rick P Edgecombe <rick.p.edgecombe@intel.com>, "Vishal
 Annapurve" <vannapurve@google.com>, David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH v2 02/51] KVM: guest_memfd: Introduce and use
 shareability to guard faulting
Message-ID: <68ddb87b16415_28f5c229470@iweiny-mobl.notmuch>
References: <cover.1747264138.git.ackerleytng@google.com>
 <b784326e9ccae6a08388f1bf39db70a2204bdc51.1747264138.git.ackerleytng@google.com>
 <aNxqYMqtBKll-TgV@google.com>
 <diqzbjmrt000.fsf@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <diqzbjmrt000.fsf@google.com>
X-ClientProxiedBy: MW4PR03CA0241.namprd03.prod.outlook.com
 (2603:10b6:303:b4::6) To IA4PR11MB9131.namprd11.prod.outlook.com
 (2603:10b6:208:55c::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR11MB9131:EE_|DM3PPF96964A2A1:EE_
X-MS-Office365-Filtering-Correlation-Id: 97ccec5b-41b0-4c37-6cde-08de01418fc8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?QZ6ogD2yZl7QyE19AHB2byVV2lEOZ4pZt9fOCXMdf7xdHRfOKue9V2b5WObc?=
 =?us-ascii?Q?J6S2oj0FmDBuyxpKGgfLCHjTS6QcOelVScKFHkQCMHYdHDQJl38Vzgvjwuc7?=
 =?us-ascii?Q?EUfFzmcvoeIB/VHDursuDJpx8jKc7IcUkQFJ0Tqf96TaMmh6uGKq3rHJhuWD?=
 =?us-ascii?Q?WXHvSb7jy2YfydreprBs2yX3TP3EB91B/LqWz7XXNx/rV2tK0U++Imufwn8j?=
 =?us-ascii?Q?Wkq6gx9n4oXTN2rSeF5Ktejh3ch6JS6fZxAv/wchcxVfh4OIgOCyxbMO8OFz?=
 =?us-ascii?Q?drmWT5DjRTzkDMZhCl20icYv5PKU1MpxhQwflqHKVcekVTdlI6uqEfuhUubg?=
 =?us-ascii?Q?QG3ijF5ylSsnKqNIIMQEi1XhEiCTcHCaYufjLgzi4cMQQ0kDmW5Hb3+eYBHk?=
 =?us-ascii?Q?cyTL2LdF3bg3JzJHhZ+ZzB7sH76lTr7NtCgf9Q/6XMPK2+MTWjEQZ1/WtSfD?=
 =?us-ascii?Q?TcskRFnwe8ojArcPNDpV40IU7xNeWkpocCVv91PbByqkSaErMEqPvcIFkD3R?=
 =?us-ascii?Q?pv1ML2YYMWBc3R2bIRXTLHa8qV2ldRs5vTH1/IX9qLUBQCeV+7+Gz/d5gCkz?=
 =?us-ascii?Q?LKbrev4uRR93nbe34rzkXjC1C78h8H79FxWAEz7Z6Ah//EbvfETZ56rp3PMB?=
 =?us-ascii?Q?ZTi1sAi5W/fPalRhroWGcpEfptbqHqp4k+m55ug9asf1SR93m8GzbCF8TSCo?=
 =?us-ascii?Q?+gx80OSuhhUlMlboBbIMDFkRWVop0rd++Bae1h3QEHK3984Ty4yCxSkF3Jfw?=
 =?us-ascii?Q?QOd6L2Z+y3WCj74Mw6662V4C5fffSWZb/dbJqUNRPO8+UiVY1hFOesERwVHD?=
 =?us-ascii?Q?OcCvqo/3kMDqjhzWwKi32jYuZcg+QQYLG2Z7KBQZ/YyneOUKIHWd2DcgU3cc?=
 =?us-ascii?Q?f8sHPJHxE701N2sDGQLfvwML5Crgqq54AvIGMm13ooIksDt6+w5+er4SHB10?=
 =?us-ascii?Q?gbHOPn0+nmi1ODpDXV5UBjNL7KoKSqLM5zDOddkGlYp1O3DE5D5XMMZWHZSx?=
 =?us-ascii?Q?T5NJ9XW8lTs76/StKo+YYkgVWY18SyAWDuNEBeRyb429hiB7hws0a5iPAH2Z?=
 =?us-ascii?Q?Cwkr7rnTaMrvdy56Zp5j7BHFg9E6hVkknC99o0/IKFzkTemglAwGgwbJ0pZ0?=
 =?us-ascii?Q?EhmpqgkTOepkzUnv4WvjpHmy7vHIhSQUvz3RfX36RcTRWf/8sgvXx/sFyaiV?=
 =?us-ascii?Q?+/YZmoI4l0j4UC4jsyc93ghXpn7/4shM8LNQCCFHfwYOOBL3cPR0I64v2e/Y?=
 =?us-ascii?Q?IZA6sXc3Pfp2r2givZ5QAgQHsUONViS3rPMtvgZD+2J/ajjr/ohd3an6hDxz?=
 =?us-ascii?Q?8nOSyl+jNakOYWHDggvBH3+T/bM1FWFB6CI0/jL/Kr5wXWqyG89e6WQV7KJS?=
 =?us-ascii?Q?/dG4mt2c9SYYsHFVADF0pw8sBmVMhnXc5cAgTqX1UTv0PvAbj44TkLZMx/mu?=
 =?us-ascii?Q?c3IHa69MS65Idf58T9Z2UmUjbLMTXvIw?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9131.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?01e8tsE+xm279aRQ9gJDeaJ7ov7MK4pGW0tmVspGN3cvH2TS5VnGhwJ47Ovk?=
 =?us-ascii?Q?aFQ4zjUOjIZ+wvdLsYbQn85WksQOIU3vP7QUe8cyJ2N2WbgIqNjtUgGET9FC?=
 =?us-ascii?Q?Mc/tCpYPNWfo7wR22YRNah5DnlZTrdHZUjD+x9oAK0FZelQnCbsOq6pmCnRp?=
 =?us-ascii?Q?/kMc4BNRBoeFjU0Xo3ASvyla06SGP2qco0kWI2AcQJlSOYUW0wWk6bwK026d?=
 =?us-ascii?Q?2Pi95z17a/G6pUsZvn3Hvb2hOLU7VHIf6D6/b+VvVDYNYDIjdAEBjoCpqceA?=
 =?us-ascii?Q?Gj3D3ANt27nHd2dlBbklyU/YYyHS6AXB3IJhCVhXEExwv9aqR+ivz+sW2ri+?=
 =?us-ascii?Q?EFjDrIORSAejLJSKush/luP4EuhVXBLvGaoasWJfspnGDNVbUdtHIKGvRvDf?=
 =?us-ascii?Q?7HH3MYvG9iyRbv5vnkq26URPhYy0++aLSSlu/JJNrb/eVbfXw8tMo9S2+c31?=
 =?us-ascii?Q?/fQeMRN321JqHH9kSEWkmQnUpwKgihA9ncyaKnL0FH42ph0swKf4/6NXlz9p?=
 =?us-ascii?Q?wGdzGB9QG1lSQvh9d64XHQYWopQwZkgDq5wKrVsHMX/p1Ou3T4Fni0hj3lgs?=
 =?us-ascii?Q?azvWJTNM7cpePsfdGWIPerTKs0eHGeHXTJSf8ACbeqQ/SyMVFbukeP7hFLs+?=
 =?us-ascii?Q?GMCIwj/tJtZLIAhKtpavBeLG4k8WsYl1JlXcBVC43k6yDiDdPvNcfXz07KCE?=
 =?us-ascii?Q?pZDhANZFoAs3TUdGNDTm3ek7GhPK8+srHow5cscJvT5dMmc8pqFyPeyAD16b?=
 =?us-ascii?Q?M33ZXw3zrpET7t8bkn/jTZWG8CNq3msJN1t5O0SUPizVCjO/3vGpAkXCrQiu?=
 =?us-ascii?Q?grmw/D489DD1N+A4Elex5NzPICOg5qJMEM4wp2vT0xtyNO4d7JPGD0+etwW5?=
 =?us-ascii?Q?6ZM94Un/NFSW3OZU6O9iYr/f4siwCtWI1Z6doLdGuGbH3KiKbenouU2iirWa?=
 =?us-ascii?Q?cxZsesh7FQecVAbvrrF3K4k6SjuNCmiAR7T3xeKqIOi/wu5noOlZSFmLwbwN?=
 =?us-ascii?Q?XY9eArDp74n4rQYmFLk2Y2wTmzr7j0fZM3+99/6TsYiIpAY8FcwJodPF+7Xr?=
 =?us-ascii?Q?f0TatNRJeFclZs0O154b1O+zORBxuiLGTibNKTQfW/wbY8OQS6BQ+JqIpDwj?=
 =?us-ascii?Q?flAZ6dvskNDhhwe3qEhue+BNrusguWWtzmR+Q17iqpUeVqiUQfkA4fP3njdX?=
 =?us-ascii?Q?6muhQbi/hJ5aSfkrGtw/ZdgwVQ1lbZNJA6rrokOoHYwn5JvTMTcIxbzS9iby?=
 =?us-ascii?Q?RqY8LaPorJF6naxBfKGXTUdKurv/CHR1M2vgDmZ+c7jVo2kccZis9jciiEos?=
 =?us-ascii?Q?qcPgMBiEerWhfMRgxoKhdc6IovcTYEN4UbSuQEsFp1M/AGvUaVXdaZpC35pX?=
 =?us-ascii?Q?djgblXTpeV8odxTZG3riTmMO+XoSN1o+4ky+5B8cw8VIbKwM9n9Baak0BhSA?=
 =?us-ascii?Q?4ofM5o+jIZOv4S1Fmk5nXsLVD4krvp4K5GK1o+RzOnYVGLYv0bTcJ1bfPY3Z?=
 =?us-ascii?Q?cKcno29g6KAPRESMd4ut5g+Im6gc1D6UziCuUOzgfU9vmpJ06hBPJxh7wM35?=
 =?us-ascii?Q?+PHaVrA9YHvg+i31lNcIkKEpKtsnkRE7zofF2tF6?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 97ccec5b-41b0-4c37-6cde-08de01418fc8
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9131.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2025 23:23:43.1469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1055heFo1slkmVQsCmQHCykIPsqQ2Sv6NPLVtE30KL7xlltydpYd91BLtNGPukL2oHL21ucxoxVC43L5gx6rnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF96964A2A1
X-OriginatorOrg: intel.com

Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 

[snip]

> 
> > Internally, that let's us do some fun things in KVM.  E.g. if we make the "disable
> > legacy per-VM memory attributes" a read-only module param, then we can wire up a
> > static_call() for kvm_get_memory_attributes() and then kvm_mem_is_private() will
> > Just Work.
> >
> >   static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
> >   {
> > 	return static_call(__kvm_get_memory_attributes)(kvm, gfn);
> >   }
> >
> >   static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> >   {
> > 	return kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
> >   }
> >
> > That might trigger some additional surgery if/when we want to support RWX
> > protections on a per-VM basis _and_ a per-gmem basic, but I suspect such churn
> > would pale in comparison to the overall support needed for RWX protections.
> >
> 
> RWX protections are more of a VM-level property, if I understood the use
> case correctly that some gfn ranges are to be marked non-executable by
> userspace. Setting RWX within guest_memfd would be kind of awkward since
> userspace must first translate GFN to offset, then set it using the
> offset within guest_memfd. Hence I think it's okay to have RWX stuff go
> through the regular KVM_SET_MEMORY_ATTRIBUTES *VM* ioctl and have it
> tracked in mem_attr_array.
> 
> I'd prefer not to have the module param choose between the use of
> mem_attr_array and guest_memfd conversion in case we need both
> mem_attr_array to support other stuff in future while supporting
> conversions.

I'm getting pretty confused on how userspace is going to know which ioctl
to use VM vs gmem.

I was starting to question if going through the VM ioctl should actually
change the guest_memfd flags (shareability).

In a prototype I'm playing with shareability has become a bit field which
I think aligns with the idea of expanding the memory attributes.  But I've
had some issues with the TDX tests in trying to decipher when to call
vm_set_memory_attributes() vs guest_memfd_convert_private().

> 
> > The kvm_memory_attributes structure is compatible, all that's needed AFAICT is a
> > union to clarify it's a pgoff instead of an address when used for guest_memfd.
> >
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index 52f6000ab020..e0d8255ac8d2 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1590,7 +1590,10 @@ struct kvm_stats_desc {
> >  #define KVM_SET_MEMORY_ATTRIBUTES              _IOW(KVMIO,  0xd2, struct kvm_memory_attributes)
> >  
> >  struct kvm_memory_attributes {
> > -       __u64 address;
> > +       union {
> > +               __u64 address;
> > +               __u64 offset;
> > +       };
> >         __u64 size;
> >         __u64 attributes;
> >         __u64 flags;
> >
> 
> struct kvm_memory_attributes doesn't have room for reporting the offset
> at which conversion failed (error_offset in the new struct). How do we
> handle this? Do we reuse the flags field, or do we not report
> error_offset?

We could extend this for gmem's version of the struct.

> 
> >> +static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index);
> >> +
> >> +static struct kvm_gmem_inode_private *kvm_gmem_private(struct inode *inode)
> >> +{
> >> +	return inode->i_mapping->i_private_data;
> >
> > This is a hilarious bad helper.  Everyone and their mother is going to think
> > about "private vs. shared" when they see kvm_gmem_private(), at least on the x86
> > side.
> >
> 
> Totally missed this interpretation of private, lol. Too many
> interpretations of private: MAP_PRIVATE, CoCo's private vs shared, and
> i_private_data.
> 

FWIW this did not confuse me and it probably should have...  ;-)  I'm fine
with Sean's suggestion though.

> >> +}
> >> +
> >> +#else
> >> +
> >> +static int kvm_gmem_shareability_setup(struct maple_tree *mt, loff_t size, u64 flags)
> >> +{
> >> +	return 0;
> >> +}
> >> +
> >> +static inline struct folio *kvm_gmem_get_shared_folio(struct inode *inode, pgoff_t index)
> >> +{
> >> +	WARN_ONCE("Unexpected call to get shared folio.")
> >> +	return NULL;
> >> +}
> >> +
> >> +#endif /* CONFIG_KVM_GMEM_SHARED_MEM */
> >> +
> >>  static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
> >>  				    pgoff_t index, struct folio *folio)
> >>  {
> >> @@ -333,7 +404,7 @@ static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
> >>  
> >>  	filemap_invalidate_lock_shared(inode->i_mapping);
> >>  
> >> -	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> >> +	folio = kvm_gmem_get_shared_folio(inode, vmf->pgoff);
> >
> > I am fairly certain there's a TOCTOU bug here.  AFAICT, nothing prevents the
> > underlying memory from being converted from shared=>private after checking that
> > the page is SHARED.
> >
> 
> Conversions take the filemap_invalidate_lock() too, along with
> allocations, truncations.
> 
> Because the filemap_invalidate_lock() might be reused for other
> fs-specific operations, I didn't do the mt_set_external_lock() thing to
> lock at a low level to avoid nested locking or special maple tree code
> to avoid taking the lock on other paths.

I don't think using the filemap_invalidate_lock() is going to work well
here.  I've had some hangs on it in my testing and experiments.  I think
it is better to specifically lock the state tracking itself.  I believe
Michael mentioned this as well in a previous thread.

Ira

[snip]

