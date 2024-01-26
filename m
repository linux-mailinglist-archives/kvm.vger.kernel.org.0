Return-Path: <kvm+bounces-7140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C3C883DA61
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 13:56:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 103681F28342
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 12:56:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E1581B7F3;
	Fri, 26 Jan 2024 12:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NsKxfYVD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C131B7E1;
	Fri, 26 Jan 2024 12:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706273783; cv=fail; b=bh5aZc93Ccw7Uh90ZB9mswFGHsG0nMt2Q8zTNKoUKnINR7BV+zBgVrBjDqatRr2iavYc/RXKoxsbGf15z2kdo4RoVTdYJKrHyZLN9FYX3QmINB/UyRoedb0wsTrJFi5PP/YaUzf1A/rGaTSAw3o6y07IFqdKs7ugg11Qrph5Ctg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706273783; c=relaxed/simple;
	bh=neK5UfnO6y8XterSBFhe4LZUMTb6i4cygZYwT/57y5w=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ubNYnJC+wrUd6TTxxec2oSWCAv6751CTXt+d14sItcGfE+RZIdhF8hDTDGqnziZX4sN9s/YawY+UqtLlhdEBzvcmP9t/ZTTPPEvZ0QUr7Ts+vV+FTrzS62IRJOXFTd0DuTULhWXpMoY0IgmJ+Ljwf66+Ma3J4XmICerSD8Ep90s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NsKxfYVD; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706273782; x=1737809782;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=neK5UfnO6y8XterSBFhe4LZUMTb6i4cygZYwT/57y5w=;
  b=NsKxfYVDK/C7ONbksMyhBS2zz748rJYQR05gJv0499ZraH/dj2nSP6La
   Fx51v7aF5RIPSIQPffcXKN/JCR0v7m79ECRAALyR0bzsMRLexNQKyEaf6
   UysAElDBEu30lRrMoIzAv5gPh2Fre7IgNHuJtTvfgLXZunzPI8WTffSt/
   ZejfclpcyNHtf31r5NqmadT/pZitfJ+mgZPQhib7tRN7ThWXz+NLzTqZy
   nDldP/uSQKYvl0+jLpk/9gT87H8gaN19d1ccZgIMgKrwbAozEjtKv9vca
   UxFV96I576bFDGEKrb2tUrmZ8PkIHhVUa9tf2cGhrns1m5/Y1Sd1m0Xf2
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="2297798"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2297798"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 04:56:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="960197762"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="960197762"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Jan 2024 04:56:20 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 26 Jan 2024 04:56:19 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 26 Jan 2024 04:56:19 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 26 Jan 2024 04:56:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ivEH63rYgkMEPwe+obM4TgTKWkLfAmAuC0RWriZOSE0LZqdkC1RuKl6VeauZvT+cDlsILokRshG/SK0+CRDuTir1vI8coWeP/GDwL55UCsJUihIbe/i6fcqnOoCAB6SOsL9y7Lbl+7fI8hqbOYBSiv/euZ5sz5m52s7/E6TPQ8Z/3Rg19cC0caZgqgQ0LKcQ5yw8IZKHrcvASIxUXfaUih69NxqrJW656Y7qW2wujU4qW6cdJWJATx9Dqqcg0jLWrNmiZpIRdm/5NXDOjXCyulbFIDsKKwWelLf25E2wLKAcqSxcjloQ/Xd6+Y83oZAd9D9t8ItX9SVZi7TSRUr2aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h+KNyK8+Fscdx566QbSe1v8BGj8CFUjgPRvE2/eCiw8=;
 b=H+TjI/qnOhViVwRRhOpE1aEWJlg540uyJ/7Q/1wG5GColpXjDPz7TrPMWovw07fzcp6coWW9y578PrhySOyKnZwYVf/jmUUkT/QBE0K+/Isup1HlHsxmavn86LdkB0TlGtf65y5/b993CIyYw2sgCqX/vzwSg9DZEeFBI9I+MHwpjV7TxTrMPo6LGpnND7afVKXytxJG1Fjql7pMEBUAJiiJyTiEOJo9dX/auemInnuvvzTjMAOVZewSKF/4eR7g/nMpis6nVjfjr0vSByxFl4zl3Uo/CTCiuwhUbuDoGFbiR381JrCTxFGlWYIMHU5YPPUT87Vrho/XLKuPrtSrcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DM4PR11MB5376.namprd11.prod.outlook.com (2603:10b6:5:397::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27; Fri, 26 Jan
 2024 12:56:17 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::5d67:24d8:8c3d:acba]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::5d67:24d8:8c3d:acba%5]) with mapi id 15.20.7228.027; Fri, 26 Jan 2024
 12:56:17 +0000
Message-ID: <8fa9d499-dd5a-401f-9f69-60c456604c5b@intel.com>
Date: Fri, 26 Jan 2024 20:56:10 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 27/27] KVM: x86: Stop emulating for CET protected
 branch instructions
Content-Language: en-US
To: Chao Gao <chao.gao@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<yuan.yao@linux.intel.com>, <peterz@infradead.org>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>, <john.allen@amd.com>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
 <20240124024200.102792-28-weijiang.yang@intel.com>
 <ZbNy7TVq62JurQRc@chao-email>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZbNy7TVq62JurQRc@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0022.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::14) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DM4PR11MB5376:EE_
X-MS-Office365-Filtering-Correlation-Id: a650ec35-3e80-4238-d7f6-08dc1e6e2f95
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4W5bWiCtvoUfb7h4vh5ygUZOO2hpPQ0mP25rIbupu83fnO4+0WhQmxbI8rTy6IqV5uTUzr6aHR8tuFxiPtfk78RkxwS1/0K7v6uJfaNb9NSQSgKXVCx+z4EWI+1RXq7SC7t0fILm9jFUQliDXqXTF/oo19+HdhS+M1D/KmtsxsDuiozjBWyILxcdRQplwUHnlLpHMpxR75Q0Dy/VrHmGtn/0flwQFuiH3DFMdZ4OUUmhAh91eRV5szTvCmPvO3i9xqHmu0qQgQCss1wrnrQ2u22BYsyyXjjQvOgZZxh8PLidVuPmDKNrzr1ftdBgAGqoP5KBd2bvR3GnqQ9PE7zr5HAugFnOswPPRoYXQHb09eIDIEPLl888ueOOifg4Za11KUcYUceyzDXhk3rXl+RzoaCogClUa+vgpwykV1mSjZrYzIknoiCaDJrm0CLhQk5yup+4NwfIU2rMrDPvwZTg19gKAnjoD8/nhg4lltmaeo6ObUYjK5cu2o0D7dB3ybTla1UJg7j/RvkIRJAlxP5swbQJr0ZOdrrjSeG9CRT8zH9tU3rSvDFqlMzUwFvaqENUdS4olCapv4/83mmhqNHrEnyNuTIAVXO06ndpF3w93Ax6uweAnfu5nGUC6UkYIo4hV8jj0oWRFMMIv1wS1vSjhA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(376002)(396003)(39860400002)(366004)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(83380400001)(2616005)(6512007)(26005)(38100700002)(6506007)(5660300002)(8676002)(6862004)(66556008)(8936002)(4326008)(2906002)(478600001)(6486002)(6636002)(66946007)(53546011)(37006003)(66476007)(6666004)(316002)(41300700001)(31696002)(82960400001)(86362001)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WWNVZXdKZVg5UHI4ZTQyaGl2Z3NSTXNPaHhsV0E1aHMyV1hQTFNjZ0RMaVBt?=
 =?utf-8?B?Sm9BSnBvcDkxRzFuWitldUJNREQweHlQZ1daWWRCVDFwSndXQnVNUzFuOXR4?=
 =?utf-8?B?K28wWTFJeTd3d2JKVkVsUDltVEF5aXZTWkNVdnRqR2kyNmZ3UGJHRGRnTHdT?=
 =?utf-8?B?bHp1KzBEc3Q5VlR3STJrT0hQVVRZNGZ0cmttOSt4TzdXQVJzdWFDeTE5NW83?=
 =?utf-8?B?TDVNSmoyYlFWSlVOczdrQzlJVzBlQm5yNGJweXluVEFHMDdNVEQ3VWZEcUZL?=
 =?utf-8?B?V3IvUG1jNUVGZ3Q1L3RUN1JWNzdOVlpqV0xTOXNDV1MwMHdVRE51ZmlvcUNr?=
 =?utf-8?B?bFJRRUZFVmszMlc0VkRIK1BQTGxxZzI0cTRjQ2dLS0t1TUZkeWFqbVBhVkov?=
 =?utf-8?B?L3JLSjBoUXVraHRJUW9QYjVpYjd1L0NOc2Z4VExlQmcwbmhDZWR1UlA2bDdr?=
 =?utf-8?B?VUwyVlIwSHgxYkRsZC9Za3NHQWo1LzJRWjBNblNwVXdpVXl2ejFKVGEvNzVt?=
 =?utf-8?B?VEFhSGNJUzl5WDJPYUlpb29Ic2FBbzZycllWc1V0VUJYV1BEcUoyQUo4dDZj?=
 =?utf-8?B?WmQ5L2w3VW0xMXZLTGpJdEhyai9tdGg5SE9BWGl4bnY1cnFvSmpkOW1KMlZQ?=
 =?utf-8?B?TVZjQUh1cEs5MEdaWDJjMFlOeWpQeDdNSUxLSHFuRW1CMnE0WDdiaXJYZTdL?=
 =?utf-8?B?U0NRZGk4eHM1NXAxLzJvTXRkcWJoNEQ5TElHUm5iWXpXLzZEcHNIZmZTYVds?=
 =?utf-8?B?aDJTS3NZMm1yTHRDUGIzS29JTzRuV3VoZzBCNmpiZHRRK1pIK2VCSnBXTEtW?=
 =?utf-8?B?VUJ1WkV2bm4ySnIyRExWVXpFbGxUMGVPOFpEVzA4aVRDTXdmRU95VG0vMkFa?=
 =?utf-8?B?WEFZenNTYURhQ1k0bjJQbzFFU1I4dTZPNHRvRFJad28yQm1vRDE1c2ZvRThw?=
 =?utf-8?B?ZWE2ZEZ5OWVVQndlaFYwaHJVSWx5bnVkdDVHck5weFZESWRGQWtLNW9jTkN0?=
 =?utf-8?B?TkpBSFBLZXNhaEtBUW81RjZKejYyUXJ1UnFhYU8rZHl2REtNUTV5eEdCRFN3?=
 =?utf-8?B?WDJ6WHNVeGNOL2p5N3Nlc1NlZ3dTQVU1b0VQN3pqNDhNa0ltWUV5TzRhbXhi?=
 =?utf-8?B?ZGZaRXBTQmFlWU1aRzJDcWdQSHYrY3l2MGpUUHlIakZ3TENrM1p1YWZrR0NI?=
 =?utf-8?B?WDVUdDVtalBidjNWTjRhcVN0MWErQUhnUEJuRy9CVHJQS3IyM2RCOE1Tdmsz?=
 =?utf-8?B?cWtPWk9yRUpVMHNCc1p0aHBuVlVJSkpXQlFGbGVDY25uVHJIazIybVFnQktX?=
 =?utf-8?B?K01FT3p6Wmw2SVpOYjZ1ZzNsNGh6L3RjWDN5b1BhV0cwVlRseVh1bEpvWmVX?=
 =?utf-8?B?M2JVSnhnZ2dFOEJna0dFSEJvczJkZ2dSN3BzbmhvdTFZK1p5SzQ2M0FZdXd2?=
 =?utf-8?B?TVdCQVAvWmI3eXdYRVdWY1ZYVFVubUh4L0NHcnFIYlVJbjAvMUljbkFCaEgy?=
 =?utf-8?B?bk9DRGpJVUZjYXVxV0ZkaHV5WGxNUUVtWmtTWUhQUGgvWmprTHVRZVFQMlRT?=
 =?utf-8?B?R0tlWHI1WEhsNEJlaTJDSEVmSTVyUVc3Q0gzZ2ZXWERGdU1DNWFYRkxjMmV0?=
 =?utf-8?B?cHd1TmpIbnUzKzhOZm9NejF4K2JoSUNjbTZmTmcxaTdpRjUzTTM1QnlJdURR?=
 =?utf-8?B?dU5GQlFCMDV3QTB4SSs3RGJST2xTdGJZNk1iVmFpWXQ2TWNIZzBpdzByZTNL?=
 =?utf-8?B?RlBxbGd0VXRpbGtEcTUwRzY0QWNsUmlFN0I3bG9tK2dWZTVoc3QvTDVVRUZ0?=
 =?utf-8?B?Nm9aMUw5ZE1QQkNaemVUNTgzdFlsNXVIQzBYdTFVcVhaRTYxR2lIOG5FU1Zu?=
 =?utf-8?B?TXJsSG80cDB0dDhxR0xUY1BPbmNkRTRGNjF0Tm5pcS8rRHJJdzZsU3lmSkxY?=
 =?utf-8?B?ZlFoUStjcWJrN2VVZEVLbVJ4TWpnYkwzNkRUL2VCME1JSG9vYVNtT0xsdCt6?=
 =?utf-8?B?dzhhNFRRRTdRUytseDdmQkZyTmV0REZ4V09JSzZsQUlobUI2VEtiSWVFd2VJ?=
 =?utf-8?B?a3VSSG9ucDI2eFc1OUtSeW9NWmtJeWV6M1FUbnFhWnhJWVdZTE9HczdmWHdJ?=
 =?utf-8?B?cWNiM3BuRGVrN2VIRndUcG5aT1JSQkxHNjZnR2RWT2xSczZ3ellwb0xldE9P?=
 =?utf-8?B?Y1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a650ec35-3e80-4238-d7f6-08dc1e6e2f95
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 12:56:17.6287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MuZApplB8GigN1KAM9gQGadMvr61Au9U5xPj2MdeygrTznvoOjIlKpry141m40RlDGumOKIior8HX0twucsLKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5376
X-OriginatorOrg: intel.com

On 1/26/2024 4:53 PM, Chao Gao wrote:
> On Tue, Jan 23, 2024 at 06:42:00PM -0800, Yang Weijiang wrote:
>> Don't emulate the branch instructions, e.g., CALL/RET/JMP etc., when CET
>> is active in guest, return KVM_INTERNAL_ERROR_EMULATION to userspace to
>> handle it.
>>
>> KVM doesn't emulate CPU behaviors to check CET protected stuffs while
>> emulating guest instructions, instead it stops emulation on detecting
>> the instructions in process are CET protected. By doing so, it can avoid
>> generating bogus #CP in guest and preventing CET protected execution flow
>> subversion from guest side.
>>
>> Suggested-by: Chao Gao <chao.gao@intel.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>> arch/x86/kvm/emulate.c | 27 ++++++++++++++++-----------
>> 1 file changed, 16 insertions(+), 11 deletions(-)
>>
>> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>> index e223043ef5b2..ad15ce055a1d 100644
>> --- a/arch/x86/kvm/emulate.c
>> +++ b/arch/x86/kvm/emulate.c
>> @@ -178,6 +178,7 @@
>> #define IncSP       ((u64)1 << 54)  /* SP is incremented before ModRM calc */
>> #define TwoMemOp    ((u64)1 << 55)  /* Instruction has two memory operand */
>> #define IsBranch    ((u64)1 << 56)  /* Instruction is considered a branch. */
>> +#define IsProtected ((u64)1 << 57)  /* Instruction is protected by CET. */
> the name IsProtected doesn't seem clear to me. Its meaning isn't obvious from
> the name and may be confused with protected mode. Maybe we can add two flags:
> "IndirectBranch" and "ShadowStack".

Hmm, maybe it's worth to distinguish specific instruction protection type against current CET
enabling status. Let me double check.

>> #define DstXacc     (DstAccLo | SrcAccHi | SrcWrite)
>>
>> @@ -4098,9 +4099,9 @@ static const struct opcode group4[] = {
>> static const struct opcode group5[] = {
>> 	F(DstMem | SrcNone | Lock,		em_inc),
>> 	F(DstMem | SrcNone | Lock,		em_dec),
>> -	I(SrcMem | NearBranch | IsBranch,       em_call_near_abs),
>> -	I(SrcMemFAddr | ImplicitOps | IsBranch, em_call_far),
>> -	I(SrcMem | NearBranch | IsBranch,       em_jmp_abs),
>> +	I(SrcMem | NearBranch | IsBranch | IsProtected, em_call_near_abs),
>> +	I(SrcMemFAddr | ImplicitOps | IsBranch | IsProtected, em_call_far),
>> +	I(SrcMem | NearBranch | IsBranch | IsProtected, em_jmp_abs),
> In SDM, I don't see a list of instructions that are affected by CET. how do you
> get the list.

In SDM Vol. 1/17.2 and 17.3, and Vol.2 instruction references on branch instructions.



