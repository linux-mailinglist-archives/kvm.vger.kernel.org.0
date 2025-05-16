Return-Path: <kvm+bounces-46779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F22EAAB984B
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 11:03:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B825218922A1
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 09:03:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76A6822E3FF;
	Fri, 16 May 2025 09:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iFQu8Yzj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1E01DFE8;
	Fri, 16 May 2025 09:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747386193; cv=fail; b=MLn73yXB74xVnWLKWEA+ltZ5hb6kxkvoeoRvVt4u7GTnNR1fnCpSk78VoJzd8InKqHXcYX9eVZTNi9HfkFBeOTvhJds2jtPKJ5cJzMC+KljSgpMHiNluOVPLn4EczdJ/2pgt5y8HlUemvZMNkvHzpcLpfWC8yhBAS5TI5n6fc/4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747386193; c=relaxed/simple;
	bh=Nx2XCc/TbdZebWVujUwBZ6rVU2ct4QgHNA9/Ltpf3Xs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FMN5iSA455EQk/qe7uirYCtUC0vRfILZE92/DORiA+yCt/OXerr1oBEiuFxEfKv+yZWJV2cjAQIp9Ei0XbRBsPHrE5lVAP056o5uteJGKY5k7zd4kjrYl66X9DqTlEWUOSAkakgnJ3uRczmIs7kVgMavBC9mEgjbBW1TBZBfvM0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iFQu8Yzj; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747386192; x=1778922192;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=Nx2XCc/TbdZebWVujUwBZ6rVU2ct4QgHNA9/Ltpf3Xs=;
  b=iFQu8YzjxeseF06UP83rb16LfltBxPGRUJuYwgDJvXjdlAV6FpjaJ0kc
   oVVGEM20KpB18PgsSLQRa0MLk/l1Zh6wUtL9QTFWTFyneJHmYcHPefMZa
   XM/sMOZGycXnAZ5rB3fEyC6nzMb9nnlgl1snSTiV+JpnbG+70Fmuaq3zX
   t2QdroruAhU3IqNzjDCZvgipPhHvDrcw9aYnT2af4r0urGRCXBdqDyALj
   jyqAbXsvQiMNMYB9SJk7VscAsFmdF0IhCb+r1AYHn4LbgosAHIFWpLumN
   /PuE8iyDtsCOAz4NKmcwB6R64z5ng1RN8bGKEVevX1g2M7oSAxx8qOHSG
   A==;
X-CSE-ConnectionGUID: 4CjYuib8T/+DtHJihrxdYA==
X-CSE-MsgGUID: OWWJUwIiT0WIomvvuJeQtg==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="60008882"
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="60008882"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 02:03:11 -0700
X-CSE-ConnectionGUID: cCN4p4bHQ7+UIPfgLj1Aow==
X-CSE-MsgGUID: g6NnDVVhRru1RRPJgPqy2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="169691588"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 02:03:11 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 16 May 2025 02:03:10 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 16 May 2025 02:03:10 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 16 May 2025 02:03:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X1+whXTsHZJw3OSy5x/ovgE2kthNcxcwso5jYOkQkSpBsKcvOL3W52y1JxvlZ9fyd5PBl0wnKxROGNE1qtFudxwbgw6z7l/bosaJOdwLb+fy8mwh9NnqROLJIJOdh8GSkmi5UR3Za+AReZ0OC/vatwIKmritCAJQQiL1JGsrTL1xyDufNGIgQM8/kfzkLb/Yi3dLk5okZKjtdNg+aFrYiEVYqPK3yBNeiTDoea5CItqgL1plI9l5Vuzz+B62z1Oblszv/Zop+PdoY3LdY5oPKz+E8QvNcwvqyE8l4EU0HgP7CXEVz3dp7e4l1Q0+3w49TSrzYQeQgWthfaYVVb1IEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eFcb2yWcHcse2ixqbDyl2CBm+HJ7jOvvfFXnanbhhZk=;
 b=LVnT3DKbU0cP7z/5QAn147z/q+3YCJMBDeD3CcYzON2mLmhrcqYsq7+d2uoPIdyhfDXrDuQFqUfokxu9rXIbNAwrxP/kXwNMQpsJb1iO+ewQeTHcCgL6U2smr/DjR+LlImt/lmTA0aBIrpN+i7mu2PqWZIUGaFNv5OHaEWXpErjqAhG9CBKvrBVVZR3fm/5cGaiRBbN8LclAqAcYSQm5Da/EdmR4c2ElsaZuhekBBxnF8f+ujVOmlZxKVIbjQ076vwhvZpdf3ACROeH669fsebpNHWaj1ZsrnZz4rNKlKwdhidhl2jAaB7GNVR6IdYbCrvlDCK6BfFpelbj/BJL2jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH7PR11MB6546.namprd11.prod.outlook.com (2603:10b6:510:212::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Fri, 16 May
 2025 09:02:54 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8699.019; Fri, 16 May 2025
 09:02:53 +0000
Date: Fri, 16 May 2025 17:02:37 +0800
From: Chao Gao <chao.gao@intel.com>
To: Uros Bizjak <ubizjak@gmail.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<tglx@linutronix.de>, <dave.hansen@intel.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>,
	<chang.seok.bae@intel.com>, <xin3.li@intel.com>, Aruna Ramakrishna
	<aruna.ramakrishna@oracle.com>, Dave Hansen <dave.hansen@linux.intel.com>,
	Eric Biggers <ebiggers@google.com>, "H. Peter Anvin" <hpa@zytor.com>, "Ingo
 Molnar" <mingo@redhat.com>, Kees Cook <kees@kernel.org>, Maxim Levitsky
	<mlevitsk@redhat.com>, Mitchell Levy <levymitchell0@gmail.com>, "Nikolay
 Borisov" <nik.borisov@suse.com>, Oleg Nesterov <oleg@redhat.com>, "Samuel
 Holland" <samuel.holland@sifive.com>, Sohil Mehta <sohil.mehta@intel.com>,
	Stanislav Spassov <stanspas@amazon.de>, Vignesh Balasubramanian
	<vigbalas@amd.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v7 0/6] Introduce CET supervisor state support
Message-ID: <aCb/LduH6akVppRU@intel.com>
References: <20250512085735.564475-1-chao.gao@intel.com>
 <CAFULd4Y3VvqNS8VEvw0ObnqnVDtsC-q3kDEnyc070=gZ9oehgg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFULd4Y3VvqNS8VEvw0ObnqnVDtsC-q3kDEnyc070=gZ9oehgg@mail.gmail.com>
X-ClientProxiedBy: KL1PR02CA0032.apcprd02.prod.outlook.com
 (2603:1096:820:d::19) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH7PR11MB6546:EE_
X-MS-Office365-Filtering-Correlation-Id: 06368eb0-c130-4906-af5e-08dd94587148
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OHFPWTFiRTkrd3NrdlNvanBlN2Zoa24xTk50YmZwVExuWjlPd3gzUlNXT1NQ?=
 =?utf-8?B?UFFxYWdzeVlscUhuUE5odm9xdVIySjVoUGEvUzA2THhqU3hId0lzQlJwc0NJ?=
 =?utf-8?B?aEd5SlF6d2dqUitrQU13blRuR3FUbzhCbVV4WEUzMGg5djIvamZFbXNqMHdJ?=
 =?utf-8?B?ZmJ3TTRob1pKaDNZYXVNTTNydjBXWHJhcFZxRlpVNCtVN2ZyUS9wbzBrR2Qv?=
 =?utf-8?B?em5OQ3I0OWhaRjVLY2gzWW1RK3ZhelpFQWM2OGJpQWcxVlVQUzhqT3BBb0s0?=
 =?utf-8?B?ZlpGUmhyUnRRanQwd1cvTStrK05pL1VkY21rTjFLQXdsanhsdTZGb2dlUDhC?=
 =?utf-8?B?WWV0eGtZWHQyY3pweEZsYkp6QW12THV2YWNKSWdYMWhJdjdkYkV6K0NlL0cw?=
 =?utf-8?B?NTJQM21KMlBLWklxa1JXdHZKOWxKMU1LNG81WndEQjFLdHBmclZsc252a2xX?=
 =?utf-8?B?SXpsK3F3ZlFLQmg5dS9YcGtXRjZvQnFqdXRJOTloOWlIVzNDdkxMYmNIU3Zn?=
 =?utf-8?B?Q2ZQaWZXUjJJSCtNY2dXakV6OFpkekw4N0N1L1IzUGZUcWNGcmdpSXhWWEdQ?=
 =?utf-8?B?b1FkVDFOM0ErelR6YnhIQTRBeThsTmNCZ0ZVU1k5TmpGOHlZQTV4cHMwVDI0?=
 =?utf-8?B?VGZtSFlqUTVFTGp3TUNiSkdpYlEzSHFKMDZJRnIyVUhkNWF4UlV4amhwOTVt?=
 =?utf-8?B?bjl1OHN1OFAwdThjdFRYWGQ0UmJTSmJhaTJ6WFZhclNsbVBhaXkwZlVwc25w?=
 =?utf-8?B?RVNBajN2TzhEMFlMdU1aN1l2ajc3eStTZkszRTRCb1BFbnVqenl0bmZUdnB0?=
 =?utf-8?B?bHlPaUo1WWtKczBORnV1SGU3ZDByMmpSc09odURjMnZYOTRIT0NseHVwZGx0?=
 =?utf-8?B?bW0rbDhaOW5hRHFJd2dpeEY3bWVWMnJiWEpqa3ZrdXYzSTdTWEl5cytOSjZh?=
 =?utf-8?B?Vi9Yekd5NVR4REtGUmtsVlY0K0RVSHFEKzdiQzQycC9Ob3NtYllBNnloRlRm?=
 =?utf-8?B?YUdqcUxMSkpuUkJZSTZYcXNNekhDbFVlZXg2N0NPc3RGSWd5bjBaVzd4MXp5?=
 =?utf-8?B?ZmFYS3crSjU4NzdMQ3I0dHVRTTM2dm9hbTdNZVdkdXdrTVlPUmxDeUZJRmFD?=
 =?utf-8?B?aVJSNFc3WU02cURLVzd0LzdYSU10VnpXUmFFNitXZEpUcHQvaDIzZHdyZ2tx?=
 =?utf-8?B?S1c0NGhZNkhya1pPMXFqV0Vid2toeFI0bHRIR2VsYkZlREpoemgxbnNHMnlU?=
 =?utf-8?B?QndEYk9yc0djamEzOU1vbERjaStQMktMcHFFSm5KbGdnS3ltdVBFQWJlNzJB?=
 =?utf-8?B?c2lFTGtQd1ljMUFKTTY3Z3lmeU5hZFJEQWdyUUdqQXdncUYvU3FIQkRSUW9t?=
 =?utf-8?B?azVzbUZLWG1DZjRxQll1ZnhHU1lEQnJtK2tiL1A5NUFLN2tVamhTWCtka29R?=
 =?utf-8?B?TFMrY2pUVFh5TWoyNUVZS2JpWE8rQm1mRlkvMFJkOUphVmE4TlJHS0xCUnRJ?=
 =?utf-8?B?U1E2NW12YXJJcUNIeUFZZWhNWmtMYWhWTmRuS1ZnWVg5TFMyWXN4UGR5NXc4?=
 =?utf-8?B?N05jY21lYWgzaVNYUktkWng5My9NSS9mV1RNdHd4MlcwMXlTazhLb3lkRGdy?=
 =?utf-8?B?c1E4Y3paTDRmZ2tjTGlDQm5YcEc5YWxGR1d5TzhkYUlxMk5aWk1QRmIxb0wr?=
 =?utf-8?B?WUZoSmFYckQxcHd6cUwyR3BEZ3pkb0M4ZW4vY0k4Q2pONlBnamFrS04zeHJI?=
 =?utf-8?B?LzZ1Snc4ZFV2V3FxMFdXMW9rSERYenFRM3lCNG4vVHlTVGRlVGlEdzlUbnFJ?=
 =?utf-8?B?OXQvU3Zoa2Fxa05NbTY5RFlpWExDUUJOSk0yYlh3eGhzQ0EzS25reGNya2F6?=
 =?utf-8?B?cGhPVFk3ZmF5N2xjMFluZFh0WWY3Y2J5KytIeTNOcUpsRkMzc0dRMGwrRkZm?=
 =?utf-8?Q?4l/BdSCI+2c=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Rm1QenBIV2VKWkozQkhXSTM1NGRyejBpQ1FnYWJZUXFiUEFSRngwRUxoZkdU?=
 =?utf-8?B?cFBDam5LOU43VUEyRjBJSko3V21tY2VJSC9YYU9jT1Z6R0pnNDlVOGJiWUhJ?=
 =?utf-8?B?VWJTMFdiejUxL1BiNjJHbVMvMjZQVlNmckZlRXpmbU9GdVhwRXBPMDk0TFAv?=
 =?utf-8?B?aUxnNVQycVRuYWZzV0RiNElRaEkwMERuUEcxencwM25XbXdWRzdnOHhzc2dR?=
 =?utf-8?B?UHIwaFFQUitsT0cvUDQ5WGllSE9jeElZdVh0VHBFUFdoOUdEbVc2ZllPeU1l?=
 =?utf-8?B?UVQ0M0xEa3NQZE83NTFSMDUySTJDVklIK0tqeG5YZEhTcFRtdU9KNVRQcGE2?=
 =?utf-8?B?OU5mN3hTaGlqTURSTitvS2VscEdGNFVYRE9jaElNallJUmJPVWMwSDVmSlJE?=
 =?utf-8?B?TmlmM0pmT1RvWWEzaU5XQ0UyOW5McmJYUnpFWHBoRllTUml0TlBiNzJVbGdz?=
 =?utf-8?B?N2xVRk11Y1M3dUh5MjBWUjl4YUZUSUl2RnFiSDUwLy9oRGJKYjNWclluc0dG?=
 =?utf-8?B?ZXJpdlUxUjh6QzJGenZBOVBjak4yelI4bkxoRlQySTV0VFM2QkpUNzRNZ0xy?=
 =?utf-8?B?cHduR3hjSEZtMDRYbnN4OC9rR2FWNzVsbmlHa3RQM2x1STFkeXQ3eXFHejV4?=
 =?utf-8?B?aGJkbXVXa0tOWWNmaS9hSERNWWM2SVhTUTROMGJxc1B3ZEp5QVVKUEhrM1hJ?=
 =?utf-8?B?aVp2bk4zcHpLWU5VNTBhTjhJa0pWYnJlcWVMZlQrUUpEdGxudVJQTHI5WmlW?=
 =?utf-8?B?RmhETGdUc05LcW5yL293MmFZOGZBMjFBa09uRWtoTGx2SlFPV3pTVWljakNn?=
 =?utf-8?B?MHBFRWlyRWU0NTNLcmdrL1A5T2JIY1RjZEs2T0ZWMWluU0Q3bFNVYkptMFRY?=
 =?utf-8?B?ZkNnWHNRcSswTE9iaWZLakxYZmMxYVRkNEtoTnkyY05sWWQzd0dYVFhDSmoz?=
 =?utf-8?B?Qmhsckc0eGpSOEpZV1hPZjJyaGlsdHpHL1k4STJ3eC9FcS9vNHh2bGZMeTh6?=
 =?utf-8?B?V0h1REhwWC9VK1BmRVZBeXR3OUdpTlY0VFNxWkpxTldIV2k4ZVFtTnd2R1g5?=
 =?utf-8?B?K3pybnJoL0FCOEFLdmhzNEttTWZnZEpOOUxjSEJGeEtRbVE4NXBGaytLa0lL?=
 =?utf-8?B?clVpSk82K0hUY1FsVmlNdm5vWmJHdGZVdVhBSnhiR1BZTGVLSWtTZTB4RndW?=
 =?utf-8?B?L0NkeUpQUDUvY0JEQlU4OEFZWUpYVnpoZy9TNVJxb3ZzOFpGVG9vbG1US2lV?=
 =?utf-8?B?NVh2RXB3akVuV1dncEdzN1A5RzdIak5jUDRURVFLY2d3NXUxNTZYT1hTTXBN?=
 =?utf-8?B?a2ZsZWYwc0ludHc2WTN5Vlg3U0lpeURnb2F5L0FOTkxGZlhHNzhzNC9FOXJl?=
 =?utf-8?B?eFhXTnlqbjhGdkNXREFvSnRMOEw4STF6TGlEVDlmN256NWFPSDQ5YXZET2I0?=
 =?utf-8?B?czBhNCs4aGpWaUZQYVg5L1NWa0Y2TkkwMC80YWs3czZoYm8xbzdFRlJhWFFX?=
 =?utf-8?B?Z0Q5REJYcVlCYzZlRVY0dERaOXNVZ2labHpPN3dLL04wZG1oNXhmb0RKSE90?=
 =?utf-8?B?K3U0Ymw3aUw1L0drWFhCZEZ6VGRkcmFmcGNvTExMNjk4L0w4S0RwcUdmeTdL?=
 =?utf-8?B?N0o3NkZNZmxhYnlQVUVEQkhycDVTMHU2N2ZkdlYwQ1ZVTUVGNGV3dUdjd1h6?=
 =?utf-8?B?bXB6NGxPeEx0ZGxGSHZRaUpJU0ZmOTV4eFV3K2dqb0JhUTEzYWxOallJN043?=
 =?utf-8?B?QVVnRzA1QjViMmdNQzdSa01qUVd5emhnRkc3cDBJRFhJUVdvdVBFNUZrck11?=
 =?utf-8?B?TnZVdGdSUUxYMjNxb0tFMi9DaE4rUnV1T0VPNVp0cHlOb3FPOUt2ZGhHblNp?=
 =?utf-8?B?cG5HQTZpTDZ4QjRCbnk0UmF6L1dsZFkzWW9aVWJFQTRPNkpGaThjaVpOa0xT?=
 =?utf-8?B?STNjZStmY1FjbDdjSGU4VU5Ka0FrTmtMY29TbGM5RkFkNW0rQ1BNWHRyNWxl?=
 =?utf-8?B?b1J2R2hPelRIOEE2U3ByL0t3ZjF0T0VhNDRFNWkxQWpiN3JOcGExWlJCV211?=
 =?utf-8?B?WldycU1kV0VON3EwT3hybXhydXFGOCtzWTV4blkzNkVqYTkzeWlDeGdlZWIy?=
 =?utf-8?Q?1I/LrBy8uGX/WykSn2W+6LM8S?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 06368eb0-c130-4906-af5e-08dd94587148
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2025 09:02:53.7320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +PVbaORXrIiCzxo+TqgoPOGd1lyfBprnyD4KkdTqrA0GrwhIfEYVJAvXzeNd0drrmPHx0qHGSNLgHh3NxKvhhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6546
X-OriginatorOrg: intel.com

On Fri, May 16, 2025 at 09:51:50AM +0200, Uros Bizjak wrote:
>On Mon, May 12, 2025 at 10:57 AM Chao Gao <chao.gao@intel.com> wrote:
>>
>> Dear maintainers and reviewers,
>>
>> I kindly request your consideration for merging this series. Most of
>> patches have received Reviewed-by/Acked-by tags.
>>
>> Thanks Chang, Rick, Xin, Sean and Dave for their help with this series.
>>
>> == Changelog ==
>> v6->v7:
>>  - Collect reviews from Rick
>>  - Tweak __fpstate_reset() to handle guest fpstate rather than adding a
>>    guest-specific reset function (Sean & Dave)
>>  - Fold xfd initialization into __fpstate_reset() (Sean)
>>  - v6: https://lore.kernel.org/all/20250506093740.2864458-1-chao.gao@intel.com/
>>
>> == Background ==
>>
>> CET defines two register states: CET user, which includes user-mode control
>> registers, and CET supervisor, which consists of shadow-stack pointers for
>> privilege levels 0-2.
>>
>> Current kernel disables shadow stacks in kernel mode, making the CET
>> supervisor state unused and eliminating the need for context switching.
>>
>> == Problem ==
>>
>> To virtualize CET for guests, KVM must accurately emulate hardware
>> behavior. A key challenge arises because there is no CPUID flag to indicate
>> that shadow stack is supported only in user mode. Therefore, KVM cannot
>> assume guests will not enable shadow stacks in kernel mode and must
>> preserve the CET supervisor state of vCPUs.
>>
>> == Solution ==
>>
>> An initial proposal to manually save and restore CET supervisor states
>> using raw RDMSR/WRMSR in KVM was rejected due to performance concerns and
>> its impact on KVM's ABI. Instead, leveraging the kernel's FPU
>> infrastructure for context switching was favored [1].
>
>Dear Chao,
>
>I wonder if the same approach can be used to optimize switching of
>Intel PT configuration context. There was a patch series [1] posted
>some time ago that showed substantial reduction of overhead when
>switching Intel PT configuration context on VM-Entry/Exit using
>XSAVES/XRSTORS instructions:

No, the guest-only infrastructure utilizes the FPU core to switch states
during context switches, whereas Intel PT state is switched at different
points, i.e., on VM entry/exit.

Switching Intel PT state on VM entry/exit is necessary only for the
"host-guest" mode, which is currently marked as BROKEN. Unless functional
issues are addressed first, there's no point in optimizing its state
switching.

If we ever reinstate support for the "host-guest" mode, I think Intel PT
state probably could be implemented as an independent feature, similar to
LBR state.

