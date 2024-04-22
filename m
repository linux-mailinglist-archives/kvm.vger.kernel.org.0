Return-Path: <kvm+bounces-15451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 941F18AC315
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 05:35:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C5771C209B3
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 03:35:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7899EFBEA;
	Mon, 22 Apr 2024 03:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OY880Cb+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7804C97;
	Mon, 22 Apr 2024 03:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713756899; cv=fail; b=teKONVbMhfr/v+wTZ/kBPAgJcYigwojvJpRxkyJsy5BFW55hkvQsv8TFVgnu5arwnwV0AW3TjDz+SCcoykCdr05V723I7B/5s0rAI1fcXPQkzeF5pDdC9dU/SrmxOlFqwy/F6dqFknZTpep8D7x+StRIXdmjEfB8FghcU8V6hxA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713756899; c=relaxed/simple;
	bh=zq5GWBiedCO8+HZp9QPXJGopyfrkSnvsX3q1HbU2YtU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=izlpx5/j9oIm63bfZR/RaOkWJZoT7zHy5IEIZWxUsrgs2td1UY7WmewWOskLz3t2T/OLSWLe2tX18bfWafciWgtlIjOOw+aN5GSFxVlag/urn5BR1TgxV4mZ3QCjF3YSoakxPLRkPg7iI5/Tq2+zQWqYMCP49WNyImjMwvn92NI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OY880Cb+; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713756898; x=1745292898;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=zq5GWBiedCO8+HZp9QPXJGopyfrkSnvsX3q1HbU2YtU=;
  b=OY880Cb+h6CJMADxCmOzAb/DVLY7Y7iI21SpbWESiumn17xdM6uKmmrx
   s0hEwQdO4Jj6iM6O7nKWR03Anc5UQRVB765wKifDIe0Jxc9E/hJWiZVYd
   XIsVTMY2Jbtv/3GlUWDp94vUWadZLe8EfCTS9n4tNLDUAPbVF7mqOVWD+
   N2371zTjONYpYUgnXR4H62WdRpfqeuCYitlUZyuJv+/ui+B2o5105vq3p
   AHqbuCJADHnMVlWnoU7/jKNOUMwFQZiYmurormYTAfh0NMjzd955oegxc
   AtE05XjKcj8vprd07hixNv4VpITY+VDD8LbfoQD2gTld/FOv6a0eCJIFg
   A==;
X-CSE-ConnectionGUID: gIif89HOQGah31ac3rMsNQ==
X-CSE-MsgGUID: eVGjjmSyQsWDmIlVHIm0dg==
X-IronPort-AV: E=McAfee;i="6600,9927,11051"; a="13053720"
X-IronPort-AV: E=Sophos;i="6.07,219,1708416000"; 
   d="scan'208";a="13053720"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2024 20:34:57 -0700
X-CSE-ConnectionGUID: jkiIql6HRK+mLWPAvha0xg==
X-CSE-MsgGUID: LVQNWj+ORRWLoLulijxB8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,219,1708416000"; 
   d="scan'208";a="47177889"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Apr 2024 20:34:56 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 21 Apr 2024 20:34:55 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sun, 21 Apr 2024 20:34:55 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sun, 21 Apr 2024 20:34:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GDw2++LjtplAmZUlFGzfW2xdtMuHBoqdtdK1RqoQkG3k/EKqsZ8MYic0DeoXO4McRJnPa852DKGSHbOQC7eNWOJOx1469j18PGJZtFlf80E/HiOftSaOgyNfaiLHCjofwfPlcgZuhc9/3LlY1wNk6KqXR7TejgQ2iOhSgqmuxKWcq3m20PRaRCrXnPPOt048pYPzviiGlKJEfjzSelYxi6u9VinxEDmu9kPq8YxeKXyLkWXf7DSNG9XgspMPk/Kqz5MfCm/Hb/rsdusdwuP/DvoqVKJZgRbUGoJgCdvNwSltKROEm0eyWxzBRiw1C55VwClTCJn7U6WcAPlgz+U8CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sbMj5fgZx43+lwB9xuVMJrmpKjIEYHk1LDBZMM1DoqY=;
 b=ipELJCbtjttzfoIEz/CYt+fd0JWDmPB/KTWEYHzcq0hGtefCKf/Qduk2TM6OX+mWgeH96eW3DHswmd7nJ2cOMfhRGLd4MHUrkjND5ehqjZsxBkZJkFqtGhQudfrEkF2Qx7/vSFm8GjdKGuiUOddG1CayNlofwESVjNSDArX5MZrw14Y4t6fhe7i9cjthygXw2yb9rVcoukEzVnQUL4G58oC2n8nL6vVQo17ABLTNAV2CKSE6x2Fs3/aV7ZRlpoAZgKzYO9P1zNcxA60fqwnfdnBtqa4bclPiinxSHkaehN1etiIKcDXgUrgh273OhNzq8rVuD2Tw6q3oxD8DiwjsHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CO1PR11MB4929.namprd11.prod.outlook.com (2603:10b6:303:6d::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7519.20; Mon, 22 Apr 2024 03:34:52 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::f62c:98e2:37af:8073]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::f62c:98e2:37af:8073%7]) with mapi id 15.20.7519.018; Mon, 22 Apr 2024
 03:34:52 +0000
Date: Mon, 22 Apr 2024 11:34:18 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>, Binbin Wu
	<binbin.wu@linux.intel.com>
Subject: Re: [PATCH v19 058/130] KVM: x86/mmu: Add a private pointer to
 struct kvm_mmu_page
Message-ID: <ZiXautOkEweWfUL0@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <9d86b5a2787d20ffb5a58f86e43601a660521f16.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9d86b5a2787d20ffb5a58f86e43601a660521f16.1708933498.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SG2PR02CA0087.apcprd02.prod.outlook.com
 (2603:1096:4:90::27) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CO1PR11MB4929:EE_
X-MS-Office365-Filtering-Correlation-Id: 9281dbfc-6294-4ced-1a26-08dc627d2b9b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Q/GS/3+gOdFzhNhwuLsSZ7coEUZVhsLXhxRE73S6w/ohJOT5x+TGkKSFcNRe?=
 =?us-ascii?Q?WyYsLcii0Sq6NOknlOAxzo+bIPh6Qae2MqpuLQmcQ17iabpWMuJzfuT4kRHx?=
 =?us-ascii?Q?qM0/9/cvjhJm/DMSzZ5dnyxOmou/nYMlsPihREPQ8IPptVjApmphxDgZQ0QM?=
 =?us-ascii?Q?yeLiE0WmY3h0g2GmAHwefYsxE8sWv5xv9jnum+tb5+Eb0d2jkGhycTgK1LCF?=
 =?us-ascii?Q?7ne329nfQsIIXKzCo23RBIiGXXsCbmYGf2rfAnjNR54GSM3UlAc0PjTBahDv?=
 =?us-ascii?Q?OYXr+JhjMk7e/e9FmIuVFj9HwOnEi8k0o4QwnKtghsQbHiGJ4S9KGawbIPXv?=
 =?us-ascii?Q?5RqFuQm323xmtocQ1xh6E8EjfuYVHQg8iKsDd4PKX6jziJ7XBrd76XWplJno?=
 =?us-ascii?Q?dWv9JcpZAcJaDAEzdpen7aJESIoWcCAmgQL8M5rcNMyd37udvMths3mNClvC?=
 =?us-ascii?Q?yPJGszRT9UG1GGz2/6xbVDdLULOY60nTVpLh4xhZEnQlkp2b5MDx7tmqffOE?=
 =?us-ascii?Q?jT53DXinoLejHpSxZhzOtKjhO8v4eCVpaHvb86LKpip6jBWQ8c18qaclbwsx?=
 =?us-ascii?Q?gN3k6AjPDe7gQup8Q9VPKFhYj6tNd2j/lmLOyC2fsrSDxHTOMqOK9tLWHwQa?=
 =?us-ascii?Q?HRN95iATkytziTM526Sq1X/8Tew5SylSotDZTBUCMMb/VKT/H0AVE7+W5F4K?=
 =?us-ascii?Q?vwBfcxTXK6EUvYcLL7fykCR9KpqYG97BVkP2nXXtBAlSpRmJaLbs9ioLVTwv?=
 =?us-ascii?Q?K3qGZiNipgPlQ2lj0urWZiy8GqdEb9QySrLO4D4GGkO44iprIKCFvNYrWp2a?=
 =?us-ascii?Q?ixBZF5kpgWaQ36NHGx4TCTz4K/VucobKYrzXqyHiMLbcuTPdaeHj1KWwtsS/?=
 =?us-ascii?Q?YH+7gGlZA694FtAuKwa58mK0dkrsiQCS1ChjsH85G4NvEIEXyEY+MHreQbff?=
 =?us-ascii?Q?+gA3pBuJXEArY8LlJtCzzXHaghv6g7BkwjaF9IbE1k7rj2nqxAfmTJqWXlqh?=
 =?us-ascii?Q?+W1O6vlWTG9W2rE0+IxWYV61aI/Q8OmwiH6dTYM7G5bZ56wV5PRD17a+9Vht?=
 =?us-ascii?Q?HXJWnNItFkpu6ofL/I6Shtrh/BXf+KJrCMItfHe2IjjPceEbhMmCm0NLYhX4?=
 =?us-ascii?Q?NrKT9vJvWFtkWYbyxGo3As2JQ9dYntq7N5LsNF1QI4IcttcFj4KZI3qW14pS?=
 =?us-ascii?Q?1xeOq+NgewzpZvqG/ZjfFSctqIekFmgrpojIAwIk07f83avDbTlPVclo5N5V?=
 =?us-ascii?Q?Ol+Xosk+4IR2nZBoZe9jYwoElm5+TjorpjjBcE8zJQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SL9PeiRrLaI8vDvP5J7qhWXqiHl191a4Y4LZdf92OURL2xxjBwcmrwOQpbp2?=
 =?us-ascii?Q?btv53LsGUlGWYeLiIIFFKJXEiOiDWromO6OqYxjYIeVC46/dbcC2iMJd4Ywa?=
 =?us-ascii?Q?bdy7xFTTpQo3MbHah8Xkclij62BaXxvctk7tfPI0AiJO59G7qGUxT2BMQraP?=
 =?us-ascii?Q?tdJvmGzggsMol1X9vJhmn8vk9fdmzorrkEe3ljSvzbbytJHEOZFxxXL7bemF?=
 =?us-ascii?Q?3SXvMswGXDMCcIbj9u5qT1vT3ywg4fW3RX4eJdWmBpHbhnaLr+d+H8APuCAS?=
 =?us-ascii?Q?D6irEVZw2ttMx0RsOOfM781suPU7GOcghSvs5pXuVP2BXJKYc4eO0TV38scT?=
 =?us-ascii?Q?+kCI2a/si8oMO/u4FalGP0uQOA25w7+bfYo5MF8c3EuunENxhtIQUDXKZX6Z?=
 =?us-ascii?Q?Zeut0IADH7Yrea0UI1zbRpfkPUVCB2QK8XNurQeJuyliLAjqR5v8tQ3ZQD+Y?=
 =?us-ascii?Q?oHYFOUyKjM0i20JCpjESu17wkhWXzxTEcZVrSUU1IVbVTNl57WCYxgumAcWP?=
 =?us-ascii?Q?YHBo7XOzuni3C9KmUPsecAVkO9JZb34axmZ628l1XX6IVpfRl+oAiWuyBiVR?=
 =?us-ascii?Q?kmnhJyH6dZrzFSGKE+er4745IoAfkeatEgealc7TwSQwEPstxc4PptFQnrkg?=
 =?us-ascii?Q?fjFqi5b9YHl5i4qrJoqsvWZHg96lD9xA+zHGkwa0Eo1iGMYy3OfuwemKvRkT?=
 =?us-ascii?Q?mkrCbkLMCUK1d2G0IBaTx/SQ2Ivkaw5gVS20lkFG6XCnu4ckeq7rBSEf3QKv?=
 =?us-ascii?Q?6c1TJPr0g++Ay9ZbovgrnVeyImQPC//60dIl5aEWy4k/KVI6CpAhIjRio4O+?=
 =?us-ascii?Q?HL1MAHoVNUSGr9rapT1vhTOOyodgW2mslhVEomqXlPbrL/DeyiQdJsS3nGjQ?=
 =?us-ascii?Q?z5MwvQvAx5Z6oXOTIkqvonKlYKRq7lSCNSXMXkXWDsFQ7h6QeN7WojWpoi8/?=
 =?us-ascii?Q?sok3VEHSv38KxrE0TFeUky3Hmu3dCCB/rYLIZ2sjPixElKnrtWOn55dmlPZp?=
 =?us-ascii?Q?LnxPiwoVCjNfBcsqmXXnI8SSC4tY8sBK1ojeacmaTGegbYuw8+weASobpeMf?=
 =?us-ascii?Q?Ih77RRYJqx5wWfwdXSm7YR12BNXn0w+gGJD8ahgx+03oYzvcGSyCpjXy1f6u?=
 =?us-ascii?Q?PR99Y3ijTvCKOFtOvAL1uJ6bj0SY5I1ZUkPpXOnFvL8vasxSdq7TPPJJTP7g?=
 =?us-ascii?Q?SNoLwZEEA2yQb6jxfsZUTPKNrJaRaTxYIhlD9UXqchDtSehYCYgUL3IANz3k?=
 =?us-ascii?Q?crLLqtpc7qJEoDBcRgt1FzC6yuUizzWiEnzR1m0NI/hGnSbHsLn5C7OngRAE?=
 =?us-ascii?Q?LjwVXc7z6eRxNmmt4KnecxGqotTYZUmr0ZroX4SbLuS2ZOLQ5ERMvPC7XWJ+?=
 =?us-ascii?Q?9ulBZ0/G2dhCbVQSSI8O1neMrbcAWqA/+CZNl6CBs2ZseVVSFDrSowoLgdXW?=
 =?us-ascii?Q?y/5cxQOhryYswcWSfIHy08amFdD+1uzhOtf5UXHMc57Ghhpf+k7YN28a0QzS?=
 =?us-ascii?Q?p2/9qKJHbNfX77fAy2uGy/bvC6o3PsBucF302r0lzNYIvduqFvALWbjPgAsl?=
 =?us-ascii?Q?N7OcNTK03ug4Cu1tfRR05h4ae7ze+eJKltzoM0/6?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9281dbfc-6294-4ced-1a26-08dc627d2b9b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2024 03:34:52.3191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 50UMemuLAzPc7Hf6/TNM30//fJo01rfm9NOxeMyUMiaVLv0kSik+CNNBlt02ajQQz5McjB5eRwCikvyiQ3fOFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4929
X-OriginatorOrg: intel.com

On Mon, Feb 26, 2024 at 12:26:00AM -0800, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> +static inline void *kvm_mmu_private_spt(struct kvm_mmu_page *sp)
> +{
> +	return sp->private_spt;
> +}
> +
> +static inline void kvm_mmu_init_private_spt(struct kvm_mmu_page *sp, void *private_spt)
> +{
> +	sp->private_spt = private_spt;
> +}
This function is actually not used for initialization.
Instead, it's only called after failure of free_private_spt() in order to
intentionally leak the page to prevent kernel from accessing the encrypted page.

So to avoid confusion, how about renaming it to kvm_mmu_leak_private_spt() and
always resetting the pointer to NULL?

static inline void kvm_mmu_leak_private_spt(struct kvm_mmu_page *sp)
{
	sp->private_spt = NULL;
}

> +
> +static inline void kvm_mmu_alloc_private_spt(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
> +{
> +	bool is_root = vcpu->arch.root_mmu.root_role.level == sp->role.level;
> +
> +	KVM_BUG_ON(!kvm_mmu_page_role_is_private(sp->role), vcpu->kvm);
> +	if (is_root)
> +		/*
> +		 * Because TDX module assigns root Secure-EPT page and set it to
> +		 * Secure-EPTP when TD vcpu is created, secure page table for
> +		 * root isn't needed.
> +		 */
> +		sp->private_spt = NULL;
> +	else {
> +		/*
> +		 * Because the TDX module doesn't trust VMM and initializes
> +		 * the pages itself, KVM doesn't initialize them.  Allocate
> +		 * pages with garbage and give them to the TDX module.
> +		 */
> +		sp->private_spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_private_spt_cache);
> +		/*
> +		 * Because mmu_private_spt_cache is topped up before starting
> +		 * kvm page fault resolving, the allocation above shouldn't
> +		 * fail.
> +		 */
> +		WARN_ON_ONCE(!sp->private_spt);
> +	}
> +}

