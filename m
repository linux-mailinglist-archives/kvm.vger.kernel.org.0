Return-Path: <kvm+bounces-35939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A3AC1A16688
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 07:06:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 26AD11888972
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 06:06:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5C34183CD1;
	Mon, 20 Jan 2025 06:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FXlLGq4z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5967F2770C
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 06:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737353207; cv=fail; b=PTG03qNWd0w9v9s+OiPwvSoDIs02yOVIJQ6pmfw1Uc9eymXcZ04ga/dGPillka2D9a4/80RWctYzmQAqUBbuADoabx8HdDcLTPX66cQbzTyFvHzvlxRnmDwJQPU2/HXfUCZ7/iAEKY9U8hOXbZn8spJ/WwlhWoME6vuZ+RvzYLA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737353207; c=relaxed/simple;
	bh=uYWRaZDVxamzxcgssyzgl9h6zGWIiFTEnnMtE8OMvDY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mVjPOiOPVzWVvuD2kgc0OebxPrQuPFbjsc9bCIGESB8m0Xy9hl2UWPpyuAJitjAjRwvtZ1RtuyIQb4pD/EU077Lr+aJbW0ntWR5tPZoVCiJCbS9xq506SLXS9pN+ESx3IJ35+e+bQFM13N1H2F0iXoV0ndMZ3kvt37pyaiQOGbU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FXlLGq4z; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737353206; x=1768889206;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=uYWRaZDVxamzxcgssyzgl9h6zGWIiFTEnnMtE8OMvDY=;
  b=FXlLGq4zXotFbt4i9FevkFOmyVYYY9LvNnhTZAumlvolVZHgh19XxfLp
   /BgwW90PYb8XeV2MBwSO7iFTgIDqvaBKP2Z5YCVIoNfO4r9TUCm8OLcW6
   ggVJ1oI+YfmykNk3Z+l/yH/XveVoIHkPsKokXEUhPRxhSe0QSNOunvdnu
   unq+lWrbxj2zHOULYdE58jgLXPFH37783ZzUb8EGR4yqyxall0a9rWlBm
   dz62X8S4KnGAeoXk+NxMjBxCrlxUd2+75r2U/PHXULhr9gDK2HptBeU9J
   qLN4nC5y6lfgEy+lDYJ/kY7a0L480NrkmyZxuLlKlkj973T6bICT8me7A
   A==;
X-CSE-ConnectionGUID: yemlfoMOS2SOdnypdF7I5g==
X-CSE-MsgGUID: B3EOHceeRW2XRp/CXTknNA==
X-IronPort-AV: E=McAfee;i="6700,10204,11320"; a="37870952"
X-IronPort-AV: E=Sophos;i="6.13,218,1732608000"; 
   d="scan'208";a="37870952"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2025 22:06:45 -0800
X-CSE-ConnectionGUID: mypiPuuWRTuw2TZux853rg==
X-CSE-MsgGUID: dZ3WNHaZQlStUQsYmfKPPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,218,1732608000"; 
   d="scan'208";a="106337546"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Jan 2025 22:06:44 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Sun, 19 Jan 2025 22:06:43 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Sun, 19 Jan 2025 22:06:43 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 19 Jan 2025 22:06:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wrerjmUyElgb8r9xP6jHTLjyNZ7S3CYQfGYCrAUUwRRikwI0BHUujj+YHyuuLQ9xYvwmcbrshXVkBbtr4+oh9NZiu1vS4XvATNBFSPajXfpydAJCIno9/kPL3qmS08Z4NZu8oUbMSJoFQRI2uLUMxK9CJv1ld6GMpzRnOSMYYavK8gt1QVu5BE0Nsn2PFGvf2O6UhrnJiBnGSrku1bBr/IeQ4WKwMAp1LYSsVrpTHMj4l32haB+6yw0MFhTdhaM7VdIXvFUZ0L61khsg3Z2JoGgdXgb4eqdwc4eP5oZzrcRobiLNDmyYeXJgkiT+UbMCZCeJkiaaaDuRjzKH3i5SIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uYWRaZDVxamzxcgssyzgl9h6zGWIiFTEnnMtE8OMvDY=;
 b=UqzBuxvTAFAZRYy20lIgvb0VxD/9OIMUV+gNXYDHN7bV1uDz+/MCDddQSisxo/gaOAeraKYXub5CdSOEbAJ+oM3Ztx7wcqANiRzC3KLkN2qvrqcMX/FAgCrBAFbdswfg4jbIQnYSEBbjJAFHPtRzetA7m5dIqxIrMNOoEcXCCMU1gEEm3Ev6+8n7pohDak2LIu4i2xmyjmsOjQJWkQiyLTF9H77xHR9w0jbbeFd9qliUQxCu3GzJxLjWDwpK6iFu223GCO4ZRG19eB21e92l8SMLMYSgGZj72JQpGJsyEMz95PycqRpNuIMKH4yEtKISELDZlbBoa96VMYuhn49dkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SN7PR11MB6703.namprd11.prod.outlook.com (2603:10b6:806:268::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Mon, 20 Jan
 2025 06:06:37 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8356.020; Mon, 20 Jan 2025
 06:06:37 +0000
Date: Mon, 20 Jan 2025 14:06:28 +0800
From: Chao Gao <chao.gao@intel.com>
To: Kenta Ishiguro <kentaishiguro@sslab.ics.keio.ac.jp>
CC: <pbonzini@redhat.com>, <kvm@vger.kernel.org>, <vkuznets@redhat.com>
Subject: Re: [RFC] Para-virtualized TLB flush for PV-waiting vCPUs
Message-ID: <Z43n5J+a3BPqTBsP@intel.com>
References: <20250106155652.484001-1-kentaishiguro@sslab.ics.keio.ac.jp>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250106155652.484001-1-kentaishiguro@sslab.ics.keio.ac.jp>
X-ClientProxiedBy: SI1PR02CA0053.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::8) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SN7PR11MB6703:EE_
X-MS-Office365-Filtering-Correlation-Id: acde08a7-82bb-44f4-032a-08dd39189922
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?a2CLE/YFfMF3HZdwcrjhfWrArnMjAEFI8oMd6WnHsBFQKAnrR0x3qHshlXBT?=
 =?us-ascii?Q?cSAVlpo0KWvsMKJ+yaQexm1MIIZN3QHpP9luqHKHkBCNEtUt/ADkH8G4SMt+?=
 =?us-ascii?Q?aNO1Oe3RBNfnayGVWRjQ741ZP87CbXah46ObTPDcWQ3Xv7jf8WyQPIOe3ZLy?=
 =?us-ascii?Q?imahnQhOaYoA4tQlfIXzXXXJZFMevU4ZsI24A/oO1GKicL/Vv9n5c/fryyYB?=
 =?us-ascii?Q?ttmB3kLF3D/jHLR6vNOQ7+a+S4EvADDd9xT9WFhdhyGdVYk8a0/iGOE6u6u0?=
 =?us-ascii?Q?uajgBWFR9KSZ42LUU6u2Eg07SVFleDoHn0d9kzlPwyfF7PKAj5JK/97tb+u8?=
 =?us-ascii?Q?rLNPLlEGufPkKH9n/djDg5bfvovtBXTcL5wpLEoAX1HAkJu8MBjZHLZlYgKe?=
 =?us-ascii?Q?GvP1tSywdy33HdZ7eT5jEa+fwl54okpj2zf6gkfixTucY53gkA7ZK0mQRI6s?=
 =?us-ascii?Q?MipvnFODeSNRsvtGXuHvZuNEw6sviOyjiWOFJm/Ax5x/oPGIwiW+lweo+MA5?=
 =?us-ascii?Q?IrPz/xTywpOf7dGY71rVfDrqsTrGORNwZKU9xfVepkFkr4Jtc2RwpN5hhSRZ?=
 =?us-ascii?Q?L3tgZdGxjAJFfwYo7+JdexRMcuCMtu/L+zrdrDAXDcV1AR7CWamWsxgtcWBf?=
 =?us-ascii?Q?4aKelhnZMQaWCVai2TorjA2zW8JJFSM/SSXAfuUg1457/H8LnTSh50fJUywr?=
 =?us-ascii?Q?1gSdFnN7QpiMlZKg/oDn5lnl6cDVUn1N0gRd9DfgZaoaskU7W/JbjHMsaLC5?=
 =?us-ascii?Q?J6p+7/FfY4cqXruqiAIZbP5PBHMhyxr0Onty+PQTgUqoO6uJhf3MtuEgUz/5?=
 =?us-ascii?Q?0IsAFgHzKYvrcXbEeHKDdNEsyodzT6gbY6kpVtXLru60iteij9Qflf0PuxUg?=
 =?us-ascii?Q?uNk1TNL6WZGyUmzTN2DXEbAIx0DM8SBPkMML/a2maYG+MCV+wxAgxYCWz3GO?=
 =?us-ascii?Q?A3VQXZouUXAdm4NJlyEzcn3ySVeJAFRBhfjxhZcgNO/EHZwXEGMp7BgH3UVd?=
 =?us-ascii?Q?BbvQ5mUej1nfT2GCWbu2L576aA/9c+OAkHI+5VYa89iZiWc8J4mPn4KpYYkd?=
 =?us-ascii?Q?IQdJT6MFiLKOR+UVjxW/a4brXD1GfNe3K6cTMqQNp5Pt4OqCobFCGAu9vGnj?=
 =?us-ascii?Q?nHeF4U/TtGI3M1YMnlsw4KEWSr5YMCob6KDk8fauZlgYK/ss4gMYZyKTdTsG?=
 =?us-ascii?Q?VsDKn+b8PcaLcLnlXG8cJQzYDgefFQ6N6IgxieGnOzwv2u/sWouRZb4ywQvG?=
 =?us-ascii?Q?HF8+Q8MR4sylUW28HG0Cm4bUWhakVAE0loYGPtC4KjPmGpYF9vgpLOOB7Jnv?=
 =?us-ascii?Q?zJpTjERUeVBx03ZOaLUDngAc0sJYZrOiNIr1H+ej8/9cWgEyiyuZacsBapnj?=
 =?us-ascii?Q?XJlcDnP7BW4L3PYNfd1XLQJ2x6zf?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t3lQCl+dVUAwRH6V1iRrBOgfFMh6Qbv/i4He+daAPXJokm5XHiTZfLGaye/f?=
 =?us-ascii?Q?Sf5xpdxisApe1OsRODOmRQJ4bEMJm3p6lRcoBOYKC2POK9VUxS+aImOFhL9Q?=
 =?us-ascii?Q?/hGXQ2JMa4y96tD8RCAAMbEyHOvsPhiuqgwzrXkEmMRuRtEZA/OIVku945oL?=
 =?us-ascii?Q?4KPixhM01sqEfD8oFjUrOhUH1qDMaHaTem6MQ38RyU4e6U7ncqzRkz/qDJYT?=
 =?us-ascii?Q?kfcOF/0zkAuhfRA2PprbqeEEJn3USgvgrL6sdL+YqL0D2gQBxVbxXhnOXBKl?=
 =?us-ascii?Q?YpBWWpmKH+Ac3E1lBZa+6Ht/C3/wEKkXyv/ilmknZyB+yxXkjFmvTtUCMFi2?=
 =?us-ascii?Q?t6oDVm8J3AARV/485alYgrXGSaVwXkP4g3guKLv5Ygj1SK2zKK1qvKnH+9nn?=
 =?us-ascii?Q?q41gMizehTrP4DjFtOdA/KeN+AeD6UximjW4f7qj98EjPpz3brra3JLbE5Ks?=
 =?us-ascii?Q?RogqaugtUZQhfVGfnVgX2+um7dgkl5S6tl6vn8BCa0t82nMfvgU+9nUGvzLg?=
 =?us-ascii?Q?+A3NfO2pguRVNB96gk7/1k0tNpLZm8kzgEOQh0o+MuhyHXVaBUCCmdt6eVnX?=
 =?us-ascii?Q?4WIllx8Px6Eh6Mb8124PyKD3UtPxYDPk7WHWlKVbi5TiQsr5uw0VyMMC0q6n?=
 =?us-ascii?Q?0PkhiP5AHvPKu3C5XkiD8IF5eQUm3cEo2zZE2/A48E1dFHMBVPEvdWKbmJr1?=
 =?us-ascii?Q?ZuU00cVkFVK+U5rr26F+bOet6fN/SzyJnaQV3C0+wkNRG5Zm24i5fkEx0xSR?=
 =?us-ascii?Q?q+Lnr/Ssu7RlqmmbdPw9mSPN9GOcH7f1ODFR9rxbdKLoAOJ1YsZkF8/oa+qG?=
 =?us-ascii?Q?jfqS4vUHRXUf831JWGsk8hGT1VqgHnRY3kPH1r6OEXHzsft103U6kwXMY9QB?=
 =?us-ascii?Q?oholw0GaWA+5CQUNEW70M4XbvoH1iouoMoG4JYlA/zFYT7W4u7UThT3wo5do?=
 =?us-ascii?Q?SBL55ZDxzix9Dzuqs7swcvKkZaxQWAf/khB5wmAetBHvfCOGfuVQjJbllX2A?=
 =?us-ascii?Q?dzZn4GZbPSx0wxFCzP3NKqohy3Od9gSCWMUuU40jUBzSsOIxFAd2jpF/kvqM?=
 =?us-ascii?Q?qoUT1i3Ag/wbIiMeGuZuHocZP3uCtRLXsKK//Ei+d1ELkid6vmAi1bYBjvxV?=
 =?us-ascii?Q?248Hu07NqmN6frbHe8CL3dgIiYQf3C6c/xBiXz72jaSwWEQPTLNoAVXV4F8z?=
 =?us-ascii?Q?GASprZA6trcYmXXiPRA75xlcwUsCb/hzDaTkFEIO3w5Lj41kZFbMH+aaDqRu?=
 =?us-ascii?Q?CMROCQeRAM+C6hgqdu3AJWD8+QcSESwDMTOEX+6FZJ8DEBWkfiIi1O4sKe/K?=
 =?us-ascii?Q?7Bz0A6DI5f2jiHK6LW4spR2oXZFmypMFj6C6qbTA1Wr+qYaK6MsO5iTIcgJi?=
 =?us-ascii?Q?VOL3jLKaPgkaCt0zaweJLYSRpdLW84wN+TYunGRMO0067YxqLCWIIH3+ImZf?=
 =?us-ascii?Q?KzM1te/hCmHOJgmBKpX/72fUjmeOyozEEgutcX3Mc+Um9G9K9RGDqGJQTC9z?=
 =?us-ascii?Q?JRmbpGosYjFZxL7HJlhgk7ngAcjgrfCYUFNybfN4KTN0S5g2dt+xGWRjG1Sa?=
 =?us-ascii?Q?PB6RgjzGbmDcz4PEyNUXHBAwL8zX0KNp9UAqHXKA?=
X-MS-Exchange-CrossTenant-Network-Message-Id: acde08a7-82bb-44f4-032a-08dd39189922
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2025 06:06:36.9304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m+96WoxIYE0KUSnqDuIxmVo4agT+F6E8SLd6EaKMLJqRoW0S1BGycH0NcqH08RU7sfCMSTrSJVwjtrjRIk7OSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6703
X-OriginatorOrg: intel.com

On Tue, Jan 07, 2025 at 12:56:52AM +0900, Kenta Ishiguro wrote:
>In oversubscribed environments, the latency of flushing the remote TLB can
>become significant when the destination virtual CPU (vCPU) is the waiter
>of a para-virtualized queued spinlock that halts with interrupts disabled.
>This occurs because the waiter does not respond to remote function call
>requests until it releases the spinlock. As a result, the source vCPU
>wastes CPU time performing busy-waiting for a response from the
>destination vCPU.
>
>To mitigate this issue, this patch extends the target of the PV TLB flush
>to include vCPUs that are halting to wait on the PV qspinlock. Since the
>PV qspinlock waiters voluntarily yield before being preempted by KVM,
>their state does not get preempted, and the current PV TLB flush overlooks
>them. This change allows vCPUs to bypass waiting for PV qspinlock waiters
>during TLB shootdowns.

This doesn't seem to be a KVM-specific problem; other hypervisors should
have the same problem. So, I think we can implement a more generic solution
w/o involving the hypervisor. e.g., the guest can track which vCPUs are
waiting on PV qspinlock, delay TLB flush on them and have those vCPUs
perform TLB flush after they complete their wait (e.g., right after the
halt() in kvm_wait()).

