Return-Path: <kvm+bounces-26786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 89380977B50
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 10:40:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EA7E9B269AC
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 08:40:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50EAB1D7E5D;
	Fri, 13 Sep 2024 08:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l6i1Hl9A"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063351D6C63;
	Fri, 13 Sep 2024 08:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726216694; cv=fail; b=fsP5+UPmLTi/vBf36XO9j7Y0jnhfMdY4yTDaUbAUzmZqN5EuuZx9JmKOXSJ8D6Y7E6LRdaxpnmoI8OiXap71vGC1hxiVBqJrT2cZFug6TBOHQG6EML1YeuxS7vWatySL44y5MUuAoVID1TiUbu5S9F0NbAr4Y3JRpCNWetCQoZA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726216694; c=relaxed/simple;
	bh=baN1kdrq2bqzVX0lX3yvfXoVmeB7KEVoDIE7cuSQBsM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=r0tlOyHqMCM+k0NOtMURwYv6Bee2TJgs3TUog7DPjXu1IUeUtzvUVdgF06F283lw6xOKLQ9/HTOa5e9u9H7XQs4gYwfbRro+8m2yEgZHgcILXqicJ+J1Xu2dQb62R8zYUV+/gYH+NFdOaq6JyoTF8fQFY6v/9CIOhnMBj5n1qfI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l6i1Hl9A; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726216692; x=1757752692;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=baN1kdrq2bqzVX0lX3yvfXoVmeB7KEVoDIE7cuSQBsM=;
  b=l6i1Hl9A+zCOLeRrz6dhTtvjKAUGynAKgTiTkQxzQYmI3e3BRYcqYFth
   kl5RPB2AB5oLpxQAsJmHevPcT/DCtx91REpC0ajXpMpfnFybJ7VztK0tU
   x7e9gtV24YQxuSVz2L1OCwXrAmHwt1+qzg4BsX7EQ4woUdjn8YCjB0RtI
   eKbIBuKrMwBWnKqcJ67M4WcaJKnO4b5IVaYzj2I4YStNs4o5p1x0uDgIM
   Op5wpD+PpLoEFBt5aHsG/jGCyLRQmia9K23wk8KjLlMtjtg1DOPDSveDf
   a2YESu5lSf70FCMZrx3MB3fNCfm3MN+asm7sHwIFRur463izQ07PJXtKj
   w==;
X-CSE-ConnectionGUID: 2LGaTGpoT+qyzArl9ZRHxw==
X-CSE-MsgGUID: dzeRg4J2ScS0V5X2J8lEaw==
X-IronPort-AV: E=McAfee;i="6700,10204,11193"; a="25304632"
X-IronPort-AV: E=Sophos;i="6.10,225,1719903600"; 
   d="scan'208";a="25304632"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2024 01:38:11 -0700
X-CSE-ConnectionGUID: vKRVbUvJT6iF6z1ZLT2xXA==
X-CSE-MsgGUID: dTtlTF8bQrurzD4Dk754ig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,225,1719903600"; 
   d="scan'208";a="67919134"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Sep 2024 01:38:11 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 13 Sep 2024 01:38:10 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 13 Sep 2024 01:38:10 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 13 Sep 2024 01:38:10 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 13 Sep 2024 01:38:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eo1UA868ALwFI8AAt+fQXdMjiWGL50PVuTKLHdfjV0B5V+OHHjmqBX+hjuIt7NWyD82utafpdkdXrkgF6boB47+pVVEAFApZnVS9GOX5ikkrPdp3BqzYy/9lmN9EGVwmEFaBKgU3MKj6GTdyyy+BqzQLxaQQ76gm3rjGH7KfcV+7U2BMdaUTu/KwoNcXLMJ8pq+5gvIpSuI5obDivF+sv/JrdbixRUSXTgo0VpkSox9E/lLztk97g6qct7OVqFh0UI/x4dRDdj61JHMYkzgvQsEYabS6N1aaG1GW4mk/pUK/vYMnNR/3R96cz9LzHAdS+D4R2sWOM+iKcwBbxYC18g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T56ziQbUZVhvB5cVTzYmeW+bnVtL5/LkHJSPrpjaHyM=;
 b=OpqoQvqDYTpRae0oNrlUUlbHRsM1SGdsAZy4D/33RhN1HEcU8H9mcsZMc4EnR5mX/gETI7KPMA/rzotAA58lt/TK/MhnrUPaImEhCIHcd6lGAsrKNW42PW9eoGHhG/KpWtFnvVzIVd7uWyPF4O5rFu3rWfc0J4nr0pD9ru/UsqIhGUfEgNgmCX0MUtcbI7psVvh6+T0tYdDCAY0AXwJV3HpIl9wBveA2U4RE6U/Cjp/p2MCQIzw4tfjMgzPr9jfFdAHQSWuYHsiLbRvgZ3PMzuJy9dxEDSlnXgqcbvm4AO+MJASHvtE01nxtv2RHlAjcH+tonPm0S3JRy/BS34fDLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MW3PR11MB4553.namprd11.prod.outlook.com (2603:10b6:303:2c::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7962.19; Fri, 13 Sep 2024 08:38:07 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.7939.017; Fri, 13 Sep 2024
 08:38:07 +0000
Date: Fri, 13 Sep 2024 16:36:08 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, Yuan Yao <yuan.yao@intel.com>, Kai Huang
	<kai.huang@intel.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "dmatlack@google.com"
	<dmatlack@google.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY
 with operand SEPT
Message-ID: <ZuP5eNXFCljzRgWo@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240904030751.117579-10-rick.p.edgecombe@intel.com>
 <6449047b-2783-46e1-b2a9-2043d192824c@redhat.com>
 <b012360b4d14c0389bcb77fc8e9e5d739c6cc93d.camel@intel.com>
 <Zt9kmVe1nkjVjoEg@google.com>
 <1bbe3a78-8746-4db9-a96c-9dc5f1190f16@redhat.com>
 <ZuBQYvY6Ib4ZYBgx@google.com>
 <CABgObfayLGyWKERXkU+0gjeUg=Sp3r7GEQU=+13sUMpo36weWg@mail.gmail.com>
 <ZuBsTlbrlD6NHyv1@google.com>
 <655170f6a09ad892200cd033efe5498a26504fec.camel@intel.com>
 <ZuCE_KtmXNi0qePb@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZuCE_KtmXNi0qePb@google.com>
X-ClientProxiedBy: SI2PR01CA0021.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MW3PR11MB4553:EE_
X-MS-Office365-Filtering-Correlation-Id: e0441184-bbe7-4806-3c85-08dcd3cf644d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?muD1kzWBDKmgBxc7cNJWVadzIF1JPTWGmO/AHHLH/R4JLqCAQwtNyvc36B9e?=
 =?us-ascii?Q?b/S95uCgkd7kPzpTGH9t8tmPYV9n9N+466EWBcfWLrAAtfMjN5CtCTfzqfBr?=
 =?us-ascii?Q?0Jnzs6EdDx06y+OY8qSJ2npLXK2aoTu4s38jSMkYvJo3Nl6EYsNJg/ESeuXV?=
 =?us-ascii?Q?e4ksf2Q2QpxMlcR1x4SbhI4kOQEBQKezwLlRqCkxEbPWvJBnvxq4+cz6OygG?=
 =?us-ascii?Q?U7syznnylM1nLckv3QKqv5to7BiYYiiZTLGoigft8GCCkpeevbruOkGZbasN?=
 =?us-ascii?Q?SPXPbH8IeD5ZafUBoawHAe0O4pVjQpzydufYMTcoF5PSDpXe8SdYWI9zA7sT?=
 =?us-ascii?Q?c4GdvrAC11hNSDI57r/afzhfzkVgjl6B3pyKgNsiQz9wRVkkEcUR6BsOSHmp?=
 =?us-ascii?Q?6FXcCuIO8nGBUpL3pOdNwqdYTu5GuXKlANh2+Ki0Ne9IvggAFvdQTWOJTbkW?=
 =?us-ascii?Q?+2FOivdXx/g+8qogl1yxClL5YGvr6n+oZ++gKjgUCrjNDSB2Cxhfn2Hgx5ia?=
 =?us-ascii?Q?i9iMS9KZlDBWn18EDhiIKCOPnzj4JDBILAPIU/rYwh6o++GBgAA1e5xekKCr?=
 =?us-ascii?Q?iqNOVShuSkd9QQhJ4S/dEWVTcj+s0GCTjvnCXiP3n4pifYYzGFSLyRCGwxnR?=
 =?us-ascii?Q?yqYny3Z8bFFr2uA7Vm/lvttxtUjOD2QGDI8zSnWL1lvDh9+mzDA6U9A4ieik?=
 =?us-ascii?Q?U4e/kLQLPi81iR8FbYGPMIBS7IUKa7TnoDk3lI/98/L4bEu2jX8xsGpYd85u?=
 =?us-ascii?Q?6zcXt+98HwZPfDJCuKx4DwseZgt7SaSt6YbpUPtZVs66e/sF+Ar8VlVqX6Rj?=
 =?us-ascii?Q?oMzdi6aRo66Gs8iWB17hbrNqVRockJgoOL0o7B/xfs8RU/nlNQTGMVGVUDSo?=
 =?us-ascii?Q?xyDV89yrSbTH2/68pOgecuu+Pgg38B5mnM047Myy4kFZM5RrMnu6Y7zZuXay?=
 =?us-ascii?Q?vNGsDw7HnwQr+XozPeQDL9vuxDEqUOsD3JvNfzFQ4mDb15T3sDVOYW6YmCs5?=
 =?us-ascii?Q?K28mMcb6NRe1AaFHqTPGsKYiiqjL/4jadWUbLy2T9CQlTdn0yACKGFWmI/gh?=
 =?us-ascii?Q?qTcbzOIJVcDWx+UBGC4zIW39bC8Na38vETE4uzOfrMYxFMjRdd0Hi+GSSwlb?=
 =?us-ascii?Q?xqTJDEQwnoziKsfi82K6Ou4wmyCcjTVBiqEs7BZEhpuNp0m/i/LqwxrOiACL?=
 =?us-ascii?Q?AaAoxU2LlENNaeBnR4l+cD6mTxi+vcrJu3MMj1A9Uc7AQVPCAt+QNTFosLi6?=
 =?us-ascii?Q?/Lla5AMH7r3vnUDnxLiIqsuUWAAm/pL4NOaNfZ/xrNqK7wahkoSzUsk59oAI?=
 =?us-ascii?Q?qKR9X9fcMyKMrKqmUIQq/uLvdItbOsMtRhqPtB5e7VM3fw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MfBOtJdNx9V1vPYSQd5FmbxwHxkOn4pxpecLssuhVwrFpECze5TMEiyJ6wrE?=
 =?us-ascii?Q?ZzJA7+CJCv6nYvZXZrb8+o2Ps1LdMhC37ZgnK6YmHGxC5rFjrKgufBcZCVlM?=
 =?us-ascii?Q?OSnuX+OOZhg/Yf6M0wAIUyG2ijt8iU5m/LPFHyFG6sjTDESicSwG4XIf4pG+?=
 =?us-ascii?Q?GDBnTG9hav8XybALBvBZEJJb6+/ASIF93avbpLk0TI4GcWXAUJGVnqrJ5yoj?=
 =?us-ascii?Q?sHXuaStiuXo2F4w1JlMMjNteFHoFpUGyAK9yNogw3pkDJd6F+LZrsx+pw22D?=
 =?us-ascii?Q?7zRo8nvqGFt+4JCt9QXmfaZomzWsu+C4CGF4rqPHCTFHHPsh/I8eJ7gsYbat?=
 =?us-ascii?Q?H9geGLLmkrUZZ5fFxSLSlfQfnJEOMV2HODHEn1popyIK94xHcNH6vBuTLGBg?=
 =?us-ascii?Q?vDbb1Dy8wEcIYmvMilzNDHzdRJ2++Son/dfbYHAidjsgbHnnw9lpmSlJAIkd?=
 =?us-ascii?Q?8kCYWLkWajN31hNrougo9ac1ILBIJ6wqkyzmCKfcn9TSut2HvzWS5uROyeQR?=
 =?us-ascii?Q?vIFx5ulaRNj/HIvxH9Il2c5UnlSiMCZ4JYNSZLRU2G9aafbdhAJbNQMxdd2s?=
 =?us-ascii?Q?8Rq7aeaj8FEzHDsy/pm8WRpnDoBrYGKzrcwgJ+zL+K7mKZ0KnS12/oVNXA/z?=
 =?us-ascii?Q?4hxHGWv0c4sEdRQnAdCqY2KV8YCVuhcWUVylsP++Geiro+8TbDWkDtQUm6Fn?=
 =?us-ascii?Q?LxnyNabeIGd6X7dktxGpPVhyeH7QdZPBikKZ4eFuft0UOOpe1BwIFsg7cajS?=
 =?us-ascii?Q?N9c/tahsSp0RKFLD+wpdjzi9nJwolnkg4jLbbJk5TegHzUAg+zz7we0WcF57?=
 =?us-ascii?Q?XqW6u78hQWLecg2zw6VDhvdovLg8j+f69xJKN8KQSJxeL4tMJBFjjF/ZQ7GN?=
 =?us-ascii?Q?utDN1iLfSmKS/VMzq1JZzjmRa2SRKwAPkaN+d3+o0TOAf+SPtynLdsaPZn5T?=
 =?us-ascii?Q?7UWKzz+9wrD+noCEpe9ytof7iOGae+19GuetrOJ+5Fiha+dAmfl9k59h0+cG?=
 =?us-ascii?Q?rnMoS7hsPfBFKPu1ow+cI41Ivl+LFnZWpqoL8wSp7sjruiX/sNFmfBBx7S2B?=
 =?us-ascii?Q?km6zk9hCEn6/mxXA+sz/DhnoCef6QrGcLwbmy2ZcvGUNyY++qMcBoSZfDUn5?=
 =?us-ascii?Q?/ujZ6HzZbkQ93LJic9aNggsI/r6Z8CuQ+mb/RmuocySTs0ovGCRFM0gT8OAl?=
 =?us-ascii?Q?rEv9V8gQY3riaNTZBzIYQ8mqMVN1RaFMoFTSMkXvx5llWsonwqWIScEEukMA?=
 =?us-ascii?Q?TwWkCws3FfaVcMQxDTOqwY6iytwXk4hoFQwoLd8LM9Qcn21gE4Wza82bUEMl?=
 =?us-ascii?Q?Lpmqw3NNecSpyedMdgU22+6q6yx541xeNqeIBYZW3vJZo+0c5wX7UTngyhM1?=
 =?us-ascii?Q?TRE2iYkSXDq7MDKw6kFRg5Hed09QSybR4B9ooxPpTFISD/5EozGZXfpYMT2J?=
 =?us-ascii?Q?l8ngMa+wbmm84EtvljWIfVqf8GCEpKgGEetUDH7qVz801vsaM4Nb0U+bmrrQ?=
 =?us-ascii?Q?AQlLq7Bg5NgbAsUvGb0lcuUY5Lfp8xkUMgMWLA/weUu6bcv31QeTIuL8uwL5?=
 =?us-ascii?Q?f1B6hJLMuCNRzSWzPIys+wtQy+YF8ojFjSbniV2l?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e0441184-bbe7-4806-3c85-08dcd3cf644d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 08:38:07.5625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6AF6Y7M9ea2SrCZsQ4GrOnvlGT267tmPGo6+hx+tP/muEKOHLmcKWGZdLKi3PXln91Nv3atqAgIc18lcQeQmEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4553
X-OriginatorOrg: intel.com

This is a lock status report of TDX module for current SEAMCALL retry issue
based on code in TDX module public repo https://github.com/intel/tdx-module.git
branch TDX_1.5.05.

TL;DR:
- tdh_mem_track() can contend with tdh_vp_enter().
- tdh_vp_enter() contends with tdh_mem*() when 0-stepping is suspected.
- tdg_mem_page_accept() can contend with other tdh_mem*().

Proposal:
- Return -EAGAIN directly in ops link_external_spt/set_external_spte when
  tdh_mem_sept_add()/tdh_mem_page_aug() returns BUSY.
- Kick off vCPUs at the beginning of page removal path, i.e. before the
  tdh_mem_range_block().
  Set a flag and disallow tdh_vp_enter() until tdh_mem_page_remove() is done.
  (one possible optimization:
   since contention from tdh_vp_enter()/tdg_mem_page_accept should be rare,
   do not kick off vCPUs in normal conditions.
   When SEAMCALL BUSY happens, retry for once, kick off vCPUs and do not allow
   TD enter until page removal completes.)

Below are detailed analysis:

=== Background ===
In TDX module, there are 4 kinds of locks:
1. sharex_lock:
   Normal read/write lock. (no host priority stuff)

2. sharex_hp_lock:
   Just like normal read/write lock, except that host can set host priority bit
   on failure.
   when guest tries to acquire the lock and sees host priority bit set, it will
   return "busy host priority" directly, letting host win.
   After host acquires the lock successfully, host priority bit is cleared.

3. sept entry lock:
   Lock utilizing software bits in SEPT entry.
   HP bit (Host priority): bit 52 
   EL bit (Entry lock): bit 11, used as a bit lock.

   - host sets HP bit when host fails to acquire EL bit lock;
   - host resets HP bit when host wins.
   - guest returns "busy host priority" if HP bit is found set when guest tries
     to acquire EL bit lock.

4. mutex lock:
   Lock with only 2 states: free, lock.
   (not the same as linux mutex, not re-scheduled, could pause() for debugging).

===Resources & users list===

Resources              SHARED  users              EXCLUSIVE users
------------------------------------------------------------------------
(1) TDR                tdh_mng_rdwr               tdh_mng_create
                       tdh_vp_create              tdh_mng_add_cx
                       tdh_vp_addcx               tdh_mng_init
		       tdh_vp_init                tdh_mng_vpflushdone
                       tdh_vp_enter               tdh_mng_key_config 
                       tdh_vp_flush               tdh_mng_key_freeid
                       tdh_vp_rd_wr               tdh_mr_extend
                       tdh_mem_sept_add           tdh_mr_finalize
                       tdh_mem_sept_remove        tdh_vp_init_apicid
                       tdh_mem_page_aug           tdh_mem_page_add
                       tdh_mem_page_remove
                       tdh_mem_range_block
                       tdh_mem_track
                       tdh_mem_range_unblock
                       tdh_phymem_page_reclaim
------------------------------------------------------------------------
(2) KOT                tdh_phymem_cache_wb        tdh_mng_create
                                                  tdh_mng_vpflushdone
                                                  tdh_mng_key_freeid
------------------------------------------------------------------------
(3) TDCS               tdh_mng_rdwr
                       tdh_vp_create
                       tdh_vp_addcx
                       tdh_vp_init
                       tdh_vp_init_apicid
                       tdh_vp_enter 
                       tdh_vp_rd_wr
                       tdh_mem_sept_add
                       tdh_mem_sept_remove
                       tdh_mem_page_aug
                       tdh_mem_page_remove
                       tdh_mem_range_block
                       tdh_mem_track
                       tdh_mem_range_unblock
------------------------------------------------------------------------
(4) TDVPR              tdh_vp_rd_wr                tdh_vp_create
                                                   tdh_vp_addcx
                                                   tdh_vp_init
                                                   tdh_vp_init_apicid
                                                   tdh_vp_enter 
                                                   tdh_vp_flush 
------------------------------------------------------------------------
(5) TDCS epoch         tdh_vp_enter                tdh_mem_track
------------------------------------------------------------------------
(6) secure_ept_lock    tdh_mem_sept_add            tdh_vp_enter
                       tdh_mem_page_aug            tdh_mem_sept_remove
                       tdh_mem_page_remove         tdh_mem_range_block
                                                   tdh_mem_range_unblock
------------------------------------------------------------------------
(7) SEPT entry                                     tdh_mem_sept_add
                                                   tdh_mem_sept_remove
                                                   tdh_mem_page_aug
                                                   tdh_mem_page_remove
                                                   tdh_mem_range_block
                                                   tdh_mem_range_unblock
                                                   tdg_mem_page_accept

Current KVM interested SEAMCALLs:
------------------------------------------------------------------------
  SEAMCALL                Lock Name        Lock Type        Resource       
tdh_mng_create          sharex_hp_lock     EXCLUSIVE        TDR
                        sharex_lock        EXCLUSIVE        KOT

tdh_mng_add_cx          sharex_hp_lock     EXCLUSIVE        TDR
                        sharex_hp_lock     EXCLUSIVE        page to add

tdh_mng_init            sharex_hp_lock     EXCLUSIVE        TDR
                        sharex_hp_lock     NO_LOCK          TDCS

tdh_mng_vpflushdone     sharex_hp_lock     EXCLUSIVE        TDR
                        sharex_lock        EXCLUSIVE        KOT

tdh_mng_key_config      sharex_hp_lock     EXCLUSIVE        TDR

tdh_mng_key_freeid      sharex_hp_lock     EXCLUSIVE        TDR
                        sharex_lock        EXCLUSIVE        KOT

tdh_mng_rdwr            sharex_hp_lock     SHARED           TDR
                        sharex_hp_lock     SHARED           TDCS

tdh_mr_extend           sharex_hp_lock     EXCLUSIVE        TDR
                        sharex_hp_lock     NO_LOCK          TDCS

tdh_mr_finalize         sharex_hp_lock     EXCLUSIVE        TDR
                        sharex_hp_lock     NO_LOCK          TDCS

tdh_vp_create           sharex_hp_lock     SHARED           TDR
                        sharex_hp_lock     SHARED           TDCS
                        sharex_hp_lock     EXCLUSIVE        TDVPR

tdh_vp_addcx            sharex_hp_lock     EXCLUSIVE        TDVPR
                        sharex_hp_lock     SHARED           TDR
                        sharex_hp_lock     SHARED           TDCS
                        sharex_hp_lock     EXCLUSIVE        page to add

tdh_vp_init             sharex_hp_lock     EXCLUSIVE        TDVPR
                        sharex_hp_lock     SHARED           TDR
                        sharex_hp_lock     SHARED           TDCS

tdh_vp_init_apicid      sharex_hp_lock     EXCLUSIVE        TDVPR
                        sharex_hp_lock     EXCLUSIVE        TDR
                        sharex_hp_lock     SHARED           TDCS

tdh_vp_enter(*)         sharex_hp_lock     EXCLUSIVE        TDVPR
                        sharex_hp_lock     SHARED           TDR
                        sharex_hp_lock     SHARED           TDCS
                        sharex_lock        SHARED           TDCS epoch_lock
                        sharex_lock        EXCLUSIVE        TDCS secure_ept_lock

tdh_vp_flush            sharex_hp_lock     EXCLUSIVE        TDVPR
                        sharex_hp_lock     SHARED           TDR

tdh_vp_rd_wr            sharex_hp_lock     SHARED           TDVPR
                        sharex_hp_lock     SHARED           TDR
                        sharex_hp_lock     SHARED           TDCS

tdh_mem_sept_add        sharex_hp_lock     SHARED           TDR
                        sharex_hp_lock     SHARED           TDCS
                        sharex_lock        SHARED           TDCS secure_ept_lock
                        sept entry lock    HOST,EXCLUSIVE   SEPT entry to modify
                        sharex_hp_lock     EXCLUSIVE        page to add

tdh_mem_sept_remove     sharex_hp_lock     SHARED           TDR
                        sharex_hp_lock     SHARED           TDCS
                        sharex_lock        EXCLUSIVE        TDCS secure_ept_lock
                        sept entry lock    HOST,EXCLUSIVE   SEPT entry to modify
                        sharex_hp_lock     EXCLUSIVE        page to remove 

tdh_mem_page_add        sharex_hp_lock     EXCLUSIVE        TDR
                        sharex_hp_lock     NO_LOCK          TDCS
                        sharex_lock        NO_LOCK          TDCS secure_ept_lock
                        sharex_hp_lock     EXCLUSIVE        page to add

tdh_mem_page_aug        sharex_hp_lock     SHARED           TDR 
                        sharex_hp_lock     SHARED           TDCS
                        sharex_lock        SHARED           TDCS secure_ept_lock 
                        sept entry lock    HOST,EXCLUSIVE   SEPT entry to modify
                        sharex_hp_lock     EXCLUSIVE        page to aug

tdh_mem_page_remove     sharex_hp_lock     SHARED           TDR
                        sharex_hp_lock     SHARED           TDCS
                        sharex_lock        SHARED           TDCS secure_ept_lock
                        sept entry lock    HOST,EXCLUSIVE   SEPT entry to modify
                        sharex_hp_lock     EXCLUSIVE        page to remove

tdh_mem_range_block     sharex_hp_lock     SHARED           TDR
                        sharex_hp_lock     SHARED           TDCS
                        sharex_lock        EXCLUSIVE        TDCS secure_ept_lock
                        sept entry lock    HOST,EXCLUSIVE   SEPT entry to modify

tdh_mem_track           sharex_hp_lock     SHARED           TDR
                        sharex_hp_lock     SHARED           TDCS
                        sharex_lock        EXCLUSIVE        TDCS epoch_lock

tdh_mem_range_unblock   sharex_hp_lock     SHARED           TDR
                        sharex_hp_lock     SHARED           TDCS
                        sharex_lock        EXCLUSIVE        TDCS secure_ept_lock
                        sept entry lock    HOST,EXCLUSIVE   SEPT entry to modify

tdh_phymem_page_reclaim sharex_hp_lock     EXCLUSIVE        page to reclaim
                        sharex_hp_lock     SHARED           TDR

tdh_phymem_cache_wb     mutex_lock                       per package wbt_entries 
                        sharex_lock        SHARED           KOT

tdh_phymem_page_wbinvd  sharex_hp_lock     SHARED           page to be wbinvd


Current KVM interested TDCALLs:
------------------------------------------------------------------------
tdg_mem_page_accept     sept entry lock    GUEST            SEPT entry to modify

TDCALLs like tdg_mr_rtmr_extend(), tdg_servtd_rd_wr(), tdg_mem_page_attr_wr()
tdg_mem_page_attr_rd() are not included.

*:(a) tdh_vp_enter() holds shared TDR lock and exclusive TDVPR lock, the two
      locks are released when exiting to VMM.
  (b) tdh_vp_enter() holds shared TDCS lock and shared TDCS epoch_lock lock,
      releases them before entering non-root mode.
  (c) tdh_vp_enter() holds shared epoch lock, contending with tdh_mem_track(). 
  (d) tdh_vp_enter() only holds EXCLUSIVE secure_ept_lock when 0-stepping is
      suspected, i.e. when last_epf_gpa_list is not empty.
      When a EPT violation happens, TDX module checks if the guest RIP equals
      to the guest RIP of last TD entry. Only when this is true for 6 continuous
      times, the gpa will be recorded in last_epf_gpa_list. The list will be
      reset once guest RIP of a EPT violation and last TD enter RIP are unequal.


=== Summary ===
For the 8 kinds of common resources protected in TDX module:

(1) TDR:
    There are only shared accesses to TDR during runtime (i.e. after TD is
    finalized and before TD tearing down), if we don't need to support calling
    tdh_vp_init_apicid() at runtime (e.g. for vCPU hotplug).
    tdh_vp_enter() holds shared TDR lock until exiting to VMM.
    TDCALLs do not acquire the TDR lock.

(2) KOT (Key Ownership Table)
    Current KVM code should have avoided contention to this resource.

(3) TDCS:
    Shared accessed or access with no lock when TDR is exclusively locked.
    Seamcalls in runtime (after TD finalized and before TD tearing down) do not
    contend with each other on TDCS.
    tdh_vp_enter() holds shared TDCS lock and releases it before entering
    non-root mode.
    Current TDCALLs for basic TDX do not acquire this lock.

(4) TDVPR:
    Per-vCPU exclusive accessed except for tdh_vp_rd_wr().
    tdh_vp_enter() holds exclusive TDVPR lock until exiting to VMM.
    TDCALLs do not acquire the TDVPR lock.

(5) TDCS epoch:
    tdh_mem_track() requests exclusive access, and tdh_vp_enter() requests
    shared access.
    tdh_mem_track() can contend with tdh_vp_enter().

(6) SEPT tree:
    Protected by secure_ept_lock (sharex_lock).
    tdh_mem_sept_add()/tdh_mem_page_aug()/tdh_mem_page_remove() holds shared
    lock; tdh_mem_sept_remove()/tdh_mem_range_block()/tdh_mem_range_unblock()
    holds exclusive lock.
    tdh_vp_enter() requests exclusive access when 0-stepping is suspected,
    contending with all other tdh_mem*().
    Guest does not acquire this lock.

    So,
    kvm mmu_lock has prevented contentions between
    tdh_mem_sept_add()/tdh_mem_page_aug()/tdh_mem_page_remove() and
    tdh_mem_sept_remove()/tdh_mem_range_block().
    Though tdh_mem_sept_add()/tdh_mem_page_aug() races with tdh_vp_enter(),
    returning -EAGAIN directly is fine for them.
    The remaining issue is the contention between tdh_vp_enter() and
    tdh_mem_page_remove()/tdh_mem_sept_remove()/tdh_mem_range_block().

(7) SEPT entry:
    All exclusive access.
    tdg_mem_page_accept() may contend with other tdh_mem*() on a specific SEPT
    entry.

(8) PAMT entry for target pages (e.g. page to add/aug/remove/reclaim/wbinvd):
    Though they are all exclusively locked, no race should be met as long as
    they belong to different pamt entries.

Conclusion:
Current KVM code should have avoided contentions of resources (1)-(4),(8), while
(5),(6),(7) are still possible to meet contention.
- tdh_mem_track() can contend with tdh_vp_enter() for (5)
- tdh_vp_enter() contends with tdh_mem*() for (6) when 0-stepping is suspected.
- tdg_mem_page_accept() can contend with other tdh_mem*() for (7).

