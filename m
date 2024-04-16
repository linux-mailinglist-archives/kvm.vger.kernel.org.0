Return-Path: <kvm+bounces-14896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B8B08A76CC
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 23:37:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E1831C21C67
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 21:37:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 158F713C662;
	Tue, 16 Apr 2024 21:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AihuDIZ/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9A56BFBB;
	Tue, 16 Apr 2024 21:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713302923; cv=fail; b=on7BIfyhOEYYGOE2cMXvWHdjszAFzyRc8M7MnfRIYvdK6G091FpcqgcGLq7H8Gx3axYKMAQz2Ntx4OoUFPpNEjYuTSY6sauFDxRCGFqOkBjgLjf/F1kAH9xoSevsv2gXiYlJBWMLHHk4HeG+zWgR8SMGTdHaysIqpgzUb3VxmS4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713302923; c=relaxed/simple;
	bh=49qDgV4M7gNUlLCaMAo0dhrRuczCeXIdAr8C5mVnT48=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tm1L1AnsFk4YtlreKiwpZMvLz3sqlnLTse8H1NFJeUsr3x997e9R+fTCqbq++6n+NuCYqOhji3INs4wC4CWo2SMdYDWlYJ1iW/JlYRVwPxiCwRcQqL5X5WxSgvCXgGqcYEb0rYTqvD1ho1zfkazO6JUgSk41q1iGsTMpvdg+X5Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AihuDIZ/; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713302922; x=1744838922;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=49qDgV4M7gNUlLCaMAo0dhrRuczCeXIdAr8C5mVnT48=;
  b=AihuDIZ/FaqmN0t8DxhN0da7YYW1BYTibS17KWciuHB5vXsVAo1jtlo2
   XdZxlSnw3LigVZhx/79KyL8rumNNoX4pOupbqdWB6Il2N3HBNkA6j0VbG
   bI894vVzXvC2xcd/hVNO0frc3NLFKTWv5g1OF8NJurii1FO5UOI240jZQ
   tlSVl+uTOUetuCwxy/Q7IkjBWpd71Xl9iq7gfHNvmdDiHQ2/Wqli3IClN
   whNEE0ZiW5g9QSVRXYqmjWV4QVkH6014ZcDKf4cDpT3cxeG8/gM+IX145
   BmgiZNu+CqBdsosgFVfDpHc/IYZIakm3KL22vk+zPzJxUU1NPMV525oEk
   g==;
X-CSE-ConnectionGUID: UwbeMayqQriFgmorz4K3fg==
X-CSE-MsgGUID: wSyO9a/fQ+m91oHJLTBLeg==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="19329536"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="19329536"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:28:42 -0700
X-CSE-ConnectionGUID: XlzyshuxQ1Cw+S7jzMap3g==
X-CSE-MsgGUID: NUalYmBOQfO/w8jnd0f0ng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="27186896"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Apr 2024 14:28:42 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 14:28:41 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Apr 2024 14:28:40 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Apr 2024 14:28:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SBf+tFyd7oPBGyDySBhGymprIVYqDTv9e5fdATX6DyohKtGycOZ/oVgh2YIANs5lwRUijOSr5KTC9lQKnEzIRvtKP820NnbQmu9clUI97jyaJymvIaL2GlJtUhD7Heia0BR8GZCXJRNrbahrugfLfNUi94G9HEGmafM0vTwLgQ+Ei2QYXQPXYfxCUM+94sG+5P2Vv4Td97e3PBHk44N/Q9qLAlcjLRrsIsIXF68ABibN+7Vrb9iTEEeDIRto6TYC+BdiHNAd3qz8NkZ9zK51hleegVmaViqEqbudtQjgU6VlHl2+VKWMxF1adXLv+5j4FLDbM5564ya7je6Qq4p37Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nmKs0ccb91fNhIe1ZcLCi11ot3ZihAts/PmIlSQc8sE=;
 b=Jz9t9fMQZ2AixzNl6p5grug4bxAGLevTZCfwFSsAoyd3rUW6ILQV/Sx1uvklqVVRqSMiT3qdnFHU8xwI8j+APcbZwd97Dob/Vk6gmz/dR54lR66kACMrziJgLry5lKp5pLhLj+JoE4+JXv7pomA6qAkkpRhief3GSnaz36KAJ4O6Qx/jspBoJzfCz8PvZTcAu8UPLS/RD/VTBQ5B9sQEJulQdeF06RgoMfbbMGn5wlrIbpRvp8Ei4KzlbqL+c0WPsZlu2SgLFw2Fq1KUzpjjruNYr0RFZ8wUqMT0VYt0QjXOGcn+AIcGBbm+VUsM/KsC+dom2Vp219kjqXlw7Ifb4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB7246.namprd11.prod.outlook.com (2603:10b6:208:42e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7430.46; Tue, 16 Apr
 2024 21:28:34 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::d610:9c43:6085:9e68]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::d610:9c43:6085:9e68%7]) with mapi id 15.20.7452.049; Tue, 16 Apr 2024
 21:28:34 +0000
Message-ID: <ad651a0b-1c91-473f-b6a5-74c3c0de5e08@intel.com>
Date: Tue, 16 Apr 2024 14:28:31 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 3/4] KVM: x86: Add a capability to configure bus
 frequency for APIC timer
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "jmattson@google.com"
	<jmattson@google.com>, "Gao, Chao" <chao.gao@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>, "Annapurve,
 Vishal" <vannapurve@google.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <cover.1711035400.git.reinette.chatre@intel.com>
 <6146ef9f9e5a17a1940b0efb571c5143b0e9ef8f.1711035400.git.reinette.chatre@intel.com>
 <7b9651b233e43af66be47bd5a20297ca2d7c7e4a.camel@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <7b9651b233e43af66be47bd5a20297ca2d7c7e4a.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0345.namprd04.prod.outlook.com
 (2603:10b6:303:8a::20) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB7246:EE_
X-MS-Office365-Filtering-Correlation-Id: a33ba62c-3741-446c-1000-08dc5e5c2bc9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JXHx910bdQResYdDeCV1dYZ7R4Cnw4ZuCd5Z2n6Ilc6N9aKY/6u6j9EBnIA6B/ggXRhT+CC7bQmfjlE9zN3jObH2zHXSZh2+RrmqHMuHhHL760cjliD4yWqIRUD6xxe4HFe16X2wwI6K9DMikpNpNZfSMd6ggZwqACKD5TIRS5Rt9wr8hkJ2X9RfSZF4Gxmzz00qaOfCM6OjFBEJa2OsrRaS0kwkQSFMJmxiEgU6gKcREdMWrSGTbJspCGR9+EKGObCyjYP5weMg00TEA9eL0H+BNKXKxv2kZw+5metUif+1JTq3qHjuEj9NZjMQh2hjXswGfVmHaC+xq8OxJrX7hyDhFm+d91AjT/ziQD1LKj0X7llso6RS+occqeFUxaJIKNS/VbOkTLV3na+ZkWLz7wiXk1v0QMejVQRvujo361nLtZ8EFORNf6Hky7WUeOqN+HtXNVpqx+31gPG03+44Jad7TCqAaOFZ7MdGUcUq1uID/ofoQc2LLcn75SjCMeggxwI/xRBZ5rFNOvTxiGhe1PeG/Cxq6CfHXNPkFZG2GYydiJH+XlP+UbABH4sFu99odQ3Qusiplosfb6okjgEOTXio8RiKsrPKdDOpGw5n8dQ+V+ZpTQf0Ijs6kWdp6GA3h3Bi727AbXTz5I1u6R25kh8A42Ecp9AMDlQJKdv4bkjAe/A0fzBy2qTS7ko46nmmeOE7GoTHYc21ZGBTDzqPyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M3FPQkYxRE1KUFJuVjhxV09SRnIySXhFeXpDUjE3RElzZzJzUXNOTjA3OG03?=
 =?utf-8?B?L20zb1ZJMVBXZ2l3eHlWd2dFNXpFcXhsb1RDWEZmN2p5RGRUZklJdENEWGw2?=
 =?utf-8?B?STVuKzB2ckZGWlZzOVd6Y0kxUVdXYnFrUDArc1U0Zzk3WWFseStuZG1YSVNC?=
 =?utf-8?B?QkRDS1l5cHNYeU4vZFcvdnFEMkNKUFlUYmc0aWlWRE9MMzBscWVFVzYySjFk?=
 =?utf-8?B?UTRBYzV6M05KdWdGeks3OUhxSWZhcktZcTF5b1k5djJUZFRHcUpUM1NNdEFv?=
 =?utf-8?B?aTZNSlFVYjBZbStUa0U3a2ROSXl1bVhudWszcThHeXJEYmhDTGYzUTZKVXNq?=
 =?utf-8?B?cjN1TjVKZGJ0SDRFUkpiTWI0VlJtcVlqZGpMQm5WSHdvWVl0MW5Td1RkWFN1?=
 =?utf-8?B?MjFxUklSODhGQUdPRVlkODRuOUlKZVJ5RzlqUDdvSXNGUEh5K0NqZEYxTEpx?=
 =?utf-8?B?L2wvWWRHMG93Q29TR1lSMEdWS3UrWW8yWHVyV245Mk05VVVvbXpBbFJqdldF?=
 =?utf-8?B?RUorK1E2cHBldEtPSzNRdU90ZjNEdDNpcGR0alM4M1JIM001VnVBR2pzb05q?=
 =?utf-8?B?ZXBJS0dtblEvcEtlc2k1R2xSenZUSlgzM3VLSXJKVkVKVEZ1SUtCYUt2NEZI?=
 =?utf-8?B?R0hRZjBDU29Tb2RoNTRaYzVGbG9kenRXUjNEYm5OQ1dhWEl2a0poMjBYTDZH?=
 =?utf-8?B?SC9zRkNmS24zYXg3dXhtVFVNcXVzdDlnV1Q0djFEWkRySU03dU1YMk9yNnY4?=
 =?utf-8?B?UGNnQnFqOXdQdlRubGJZYVVRMDgxR3E3ejV5VEcxUmVQZUR0cVRnM1BwRG9C?=
 =?utf-8?B?VGxLNnZGblpLcXY4NGpCUklUZzlBVHVWNlRieEJFWVZNVmdJQk5yRVF5VlUz?=
 =?utf-8?B?dWNVVUp5cXdNdTRLYnljUmFzbVRDSWRHZUhNSklkdW9acWcrb0FtamMrdTFt?=
 =?utf-8?B?SVdMUHhxRnNRek1TZnJoREpJYnd1bS9KNE9NRkpGNy9jMHhWRTNtOGFoUk1J?=
 =?utf-8?B?ZXZmYWhyeDQreHVPQTJGb3Z3OHJmM0YyZmdYS0dNdjVaSlFvMk95Vk9ZMTdm?=
 =?utf-8?B?T1Q1bno3bVpjd0pBaWVJWXN3a1BQQVgxTEhHc3Zkc0cvQllYQzIzVWtDdlhw?=
 =?utf-8?B?V0NYWlVqZDluNlI5RWVWS05YTE1GVEVMYm1QZUIrY0xHZVYxQWU2N08zTkYr?=
 =?utf-8?B?Tk9WYVl4VVQvSDNhY2FrYi9DK3RESGZNaUFnajFvRTc4RVRRaDEraVlycGxP?=
 =?utf-8?B?S0huMmpBU0ZXK2xSZG1FOWpHRHdzTjBqb2I4L1U2RTJOR0hBR1JnQUJjVU8y?=
 =?utf-8?B?NDZnM2l0dFhNbEkvSXdVaUZVNk9tSWNCYUx2dkVMa2FTa1hxTkJwejhaT2FY?=
 =?utf-8?B?UXhSTyttTmhpdFAwUGRibVQ3clhhei96QWdpWCtTSHZMclJMQWdYMFBTbUxG?=
 =?utf-8?B?cWl3S1p4K2Mvc0ZwYTBJZHdIMlB5KzZOU2tWUmRzSldFRE5lWUovZVExZTV1?=
 =?utf-8?B?RTUxblY5MkZhZnZkM3c3Q1VXM1k0ZjdSN2lxWGxQZ0VodXVOa0JXNDdNelBU?=
 =?utf-8?B?M0NydnVobFU1TVhxNWs4dVgxbW5zMCtCWml4cUNseXphOS9EMHZEVWtjb1FG?=
 =?utf-8?B?S3M4amlQeWJwbUlFL3hlMncyTitYN09pN1BjUnZMSDNkZnFMT1JaaGhVTTM3?=
 =?utf-8?B?TXQzMGFIMWtoNm02L3gvRklrRzJsQXZQOGY0NSszS095VFQyeHF3alcyT01O?=
 =?utf-8?B?cmVVd2hPc0I5Yk9wdUpnelNuUzFNZk5LaS9WS1Qydm42Unltbk1lV0lzcktG?=
 =?utf-8?B?Nm42QkFjakRXUXB3bnNTcTRpZHBsWE5LZ29nNTBraWN6ci83Njl4U2JUeXVt?=
 =?utf-8?B?cVdwN1FZZndleEN6V1drRUQwZzdJOEhMT3A2RVVESVY5TmlCR1RtM3NnclA2?=
 =?utf-8?B?Q3Ywenl6Z0s4aWxuYjlrVXd1aTJhZitqeWg3bi9EU2xTSitMenZtSTlHZ0Zy?=
 =?utf-8?B?N01oUm1KMW1hc2xjanBYdkx3Szd6SkxUbUJwazZmWHd0dFR5QU83dEkxZUVw?=
 =?utf-8?B?Y1pEbnpXRndsbExPcHUvczMzOEQvU1BjNE5xalNNWkMyNGRSV1B5Y2tTTjBm?=
 =?utf-8?B?MkxCZ3pYSjJFL01zbXlWVlROMWtXYlJWNkh2RURpZnE3bSs5NlBzQ1VWWE1a?=
 =?utf-8?B?Zmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a33ba62c-3741-446c-1000-08dc5e5c2bc9
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 21:28:34.6110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OShWFyxmpsJq1Eu0mg/B6tSG+nMl6YFaibq28XpZzcapyn+Ju6JTW2v0Fzdz6w47dOKPx1XdNx/8RXfE0AfhVPfPnxKHmvpfXlaI1N2tuDM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7246
X-OriginatorOrg: intel.com

Hi Rick,

On 4/16/2024 10:08 AM, Edgecombe, Rick P wrote:
> On Thu, 2024-03-21 at 09:37 -0700, Reinette Chatre wrote:
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> Add KVM_CAP_X86_APIC_BUS_FREQUENCY capability to configure the APIC
>> bus clock frequency for APIC timer emulation.
>> Allow KVM_ENABLE_CAPABILITY(KVM_CAP_X86_APIC_BUS_FREQUENCY) to set the
>> frequency in nanoseconds. When using this capability, the user space
>> VMM should configure CPUID leaf 0x15 to advertise the frequency.
>>
>> Vishal reported that the TDX guest kernel expects a 25MHz APIC bus
>> frequency but ends up getting interrupts at a significantly higher rate.
>>
>> The TDX architecture hard-codes the core crystal clock frequency to
>> 25MHz and mandates exposing it via CPUID leaf 0x15. The TDX architecture
>> does not allow the VMM to override the value.
>>
>> In addition, per Intel SDM:
>>     "The APIC timer frequency will be the processor’s bus clock or core
>>      crystal clock frequency (when TSC/core crystal clock ratio is
>>      enumerated in CPUID leaf 0x15) divided by the value specified in
>>      the divide configuration register."
>>
>> The resulting 25MHz APIC bus frequency conflicts with the KVM hardcoded
>> APIC bus frequency of 1GHz.
>>
>> The KVM doesn't enumerate CPUID leaf 0x15 to the guest unless the user
>> space VMM sets it using KVM_SET_CPUID. If the CPUID leaf 0x15 is
>> enumerated, the guest kernel uses it as the APIC bus frequency. If not,
>> the guest kernel measures the frequency based on other known timers like
>> the ACPI timer or the legacy PIT. As reported by Vishal the TDX guest
>> kernel expects a 25MHz timer frequency but gets timer interrupt more
>> frequently due to the 1GHz frequency used by KVM.
>>
>> To ensure that the guest doesn't have a conflicting view of the APIC bus
>> frequency, allow the userspace to tell KVM to use the same frequency that
>> TDX mandates instead of the default 1Ghz.
>>
>> There are several options to address this:
>> 1. Make the KVM able to configure APIC bus frequency (this series).
>>    Pro: It resembles the existing hardware.  The recent Intel CPUs
>>         adapts 25MHz.
>>    Con: Require the VMM to emulate the APIC timer at 25MHz.
>> 2. Make the TDX architecture enumerate CPUID leaf 0x15 to configurable
>>    frequency or not enumerate it.
>>    Pro: Any APIC bus frequency is allowed.
>>    Con: Deviates from TDX architecture.
>> 3. Make the TDX guest kernel use 1GHz when it's running on KVM.
>>    Con: The kernel ignores CPUID leaf 0x15.
>> 4. Change CPUID leaf 0x15 under TDX to report the crystal clock frequency
>>    as 1 GHz.
>>    Pro: This has been the virtual APIC frequency for KVM guests for 13
>>         years.
>>    Pro: This requires changing only one hard-coded constant in TDX.
>>    Con: It doesn't work with other VMMs as TDX isn't specific to KVM.
>>    Con: Core crystal clock frequency is also used to calculate TSC
>>         frequency.
>>    Con: If it is configured to value different from hardware, it will
>>         break the correctness of INTEL-PT Mini Time Count (MTC) packets
>>         in TDs.
>>
>> Reported-by: Vishal Annapurve <vannapurve@google.com>
>> Closes:
>> https://lore.kernel.org/lkml/20231006011255.4163884-1-vannapurve@google.com/
> 
> Is Closes appropriate, given the issue Vishal hit was on non-upstream code?

The issue that Vishal encountered was root-caused to the APIC bus frequency
conflict between KVM and TDX that has not changed since the original report.

It would be great if this submission can get confirmation that this series addresses
the issues encountered originally. From what I can tell there has not been
any formal accept/reject of this solution (apart from agreeing that it is the
right approach [1]) since the original report.

Reinette

[1] https://lore.kernel.org/lkml/CAGtprH8-jiC+wsy2LgmZimrRUT6kuntD6EJso2Mvx5Y42za9Dw@mail.gmail.com/

