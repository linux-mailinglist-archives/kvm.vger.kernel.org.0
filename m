Return-Path: <kvm+bounces-56239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AEC2DB3B105
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 04:32:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B3C8582BCF
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 02:32:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 906891EF39F;
	Fri, 29 Aug 2025 02:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bXB1nIjn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386376FC5;
	Fri, 29 Aug 2025 02:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756434747; cv=fail; b=gIkb9e12uBGV2oKO18Va8zuLjWWqeHgSNZbcCTJICHN1MGRCNq54Vaoz5jrJTC3t7dgpCqi5GbAhCFOzgY5kosSg4MCqYTLnsqV5tXkU8LbmmEkm9lrL3kCcfIHxnWjSqWyOL/3Y7/DaK7NaaK+NN/kvKqu2M6OsYKBzfYk4Kqs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756434747; c=relaxed/simple;
	bh=12Q5lXwm8RSrfF8KxN41yHFLwJMhOAIamW9yELMbius=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MH/kyzNCfZvVyUAQbMED6VoitaD9goZIUx1A/DpcACtgEfhgRTA5o/O3ZqhzrxW1fkrryLZZMTQGk/WfQOL5rKhYKpGjKUnCkRS76XS+Z5V/T3Fm/XHF16nruE4PsvfjRftcN2gtgAC4htcK8r1852T+Hfq1ZR77deu3H1HU+9E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bXB1nIjn; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756434745; x=1787970745;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=12Q5lXwm8RSrfF8KxN41yHFLwJMhOAIamW9yELMbius=;
  b=bXB1nIjnzLO29D2QuoH0One60yy3l40ujZbSZv/N/lqRi7MP/hpdXiQc
   D1ydRbyk/VZmZpRLY3ZPxuiwHCk54La1OZzoRegwri/bl+qp4kA7GF9JG
   313RDH4IWl5LXZtGKA74D3frkZpwVCD4D3luu4yZIexVdYLs4a+WaAFrG
   oLMOfvXC/1ngpaZp+BGbHOZ5HmRYOqRzqwfLtmEW8Y3tlTu7MhHA6J3Hi
   8kjv7wU4OFlK5Vwt6h9GyG/9JFvOjY4X++Va0XDDXE1DdqK5z0FeqrgOK
   vMtXiC1W036g8c8lO7GlzlyJfN3NROHidXO7isJketWr4vIg271Ii8/yG
   w==;
X-CSE-ConnectionGUID: EaF/DjgDRhqertlYs8MZXA==
X-CSE-MsgGUID: xJlkr1dqTwCQNrZMWUO62w==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="76169698"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="76169698"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 19:32:25 -0700
X-CSE-ConnectionGUID: 830ZooiESXetVRvXgdH0eQ==
X-CSE-MsgGUID: AyfL0exiQHao1KdQ2vw02Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="207409595"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 19:32:25 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 19:32:23 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 19:32:23 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.50) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 19:32:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HX1GwvGIJxiKLstSLSewihDNh/wZgN7LA/LTpzBOi4dvPNmcK7AvRV6IRiaxpEH4CBVnCmNwzohycUQGkp158iQtwSwudFP+DK0ZLFalw8Qiv37RM9lGvOcbbvBdk2EzvC93tIMgpraDgdnZtVsgHSHYD7ruzuGOq1fgIYv4LyP2Ms5V5+QtmtoQ/o/hqi7WVCGc3Akx9zt5h2MN9EWxfFNIosuqYiKVnczMABwVz0sK27qvA/yKOU1hjYrV90jbsS11s7k6mHfuz6L6xOpacHgn86cOzVdcJqxeyNQOUUAKRa1iDo71VUGFFP1ALeW8kVVX9ZMilmGoougNIhuCIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AlB4fHa6QBYGUH3DSziMFSb2rlg/zWPF/rSxiAJBSNY=;
 b=WLyP8sTMJ0p+WdiZR31UOKSdAsPYTtYT5fAgWQGvP32nxR3/YPdSxGeD/ydveNomeYuTrvPpbh+8Cnsl0zc3QtKiqNbxJO46cuiI1bdDy5fqr+75VG/z7WKUMUOMMSs585QJO/fIoQsyJEkcrAjwCqY8EbdGDW76qt0y2Ja5M8K4yjmTZCZCD4xs9YuqUh5EXcULhZvS/xHAnRKF26DKZfHvpYJZExejN0ERnTFdPlhSqeHoq/+/PFMFS7KeWS/Yv0MobbvGEyBOcc5HVVCsaN0TlJjKKfxudKglNcOffbQIBkWydsfNqD8nxQutopjfRvcX2pAcUaQthCT3M+QLZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH3PR11MB7204.namprd11.prod.outlook.com (2603:10b6:610:146::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.15; Fri, 29 Aug
 2025 02:32:19 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9052.013; Fri, 29 Aug 2025
 02:32:18 +0000
Date: Fri, 29 Aug 2025 10:31:29 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Michael Roth <michael.roth@amd.com>, "Ira
 Weiny" <ira.weiny@intel.com>, Vishal Annapurve <vannapurve@google.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>
Subject: Re: [RFC PATCH 09/12] KVM: TDX: Fold
 tdx_mem_page_record_premap_cnt() into its sole caller
Message-ID: <aLERAeUmk2J2UG2o@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
 <20250827000522.4022426-10-seanjc@google.com>
 <aK7Ji3kAoDaEYn3h@yzhao56-desk.sh.intel.com>
 <aK9Xqy0W1ghonWUL@google.com>
 <aK/sdr2OQqYv9DBZ@yzhao56-desk.sh.intel.com>
 <aLCJ0UfuuvedxCcU@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aLCJ0UfuuvedxCcU@google.com>
X-ClientProxiedBy: SI2P153CA0024.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::13) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH3PR11MB7204:EE_
X-MS-Office365-Filtering-Correlation-Id: 798b05ce-399d-43be-587c-08dde6a4465b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?aYPRYNOyjEzB5/dZgOCGkmApOXJ/286eIjCp8vjbLPn//XHHpIotAayK/0t/?=
 =?us-ascii?Q?n+1aFpiqz0qm5c5vt/DAaA1IV0wsJ1haJyo06ME78Q/QlE4Me5k+XuHDFWqU?=
 =?us-ascii?Q?GCJnIR7rpdjCy9Q/GupRUvsJ2UPN4+zyejC8S1T0Kww8iGb1lRF8x5hfuMfB?=
 =?us-ascii?Q?kNiv4q2WBcJTch9+y9njVdxlzFzEbyehwR1Qe4q1ezWqnxmG6yH1JpWbwfuA?=
 =?us-ascii?Q?ca/hsZtRmGPNn1Wns3mE5PF04ijcwaGxx0brHMyfyf885otaz7DjYfVnzYVB?=
 =?us-ascii?Q?9m6yWZg91Agm+lKIbU6ddwLd+Srm3xZ/au7/jDg737h/rhabJj184cDz38cx?=
 =?us-ascii?Q?N1Lz4Q+215o5Bq7/ADMEJcGWTdARsds5PSrn5EKA6WO9+f4GgWI6w8+AuyXN?=
 =?us-ascii?Q?HrOnPZClrTlQJBuKMyCwutSAQYrM3Mc3WU9amprIQ/pDxvzQLJ0LubxPmcN0?=
 =?us-ascii?Q?QpkJoX1l81K6ntvf0iGZSZpGDEUqlO/3GbWWG7KRHSQxkwzQIdpiPzrSxf8i?=
 =?us-ascii?Q?PuTwBCbsEhyv8jaady1aEX+22gopcsbk4hRhi7drixcp2Kk04nnSpsQInreB?=
 =?us-ascii?Q?Z0zRl5wVsGk7UZYCBEDlD7rQAgb+ln/uNvLSCrkcvGl2X+0A9QbO9sekAOH3?=
 =?us-ascii?Q?RvRxJ2EZacipoLL9a4Inj4OW1hdgUI+chVvli9DNydxi32H2GEcjs6JAR3oe?=
 =?us-ascii?Q?/TjmLvADV+V6CbpQXLXmMntN2Uo5I9Xe77g3fw5kpACZh2rk2Fikl7K4bICX?=
 =?us-ascii?Q?xxhvFGHC/HvWbE78xRAOnPx22e90VKAriLvFDd7GhflbMyq1CgPYIJuFnR99?=
 =?us-ascii?Q?VR02T1uVR0Vn78KDBn7v1fom+Z1V7uAChCwELBMLZTsEcTFY43rczZ1UkJo4?=
 =?us-ascii?Q?YBPx5OxigfcAigSaFXR5absCylc9SJoUhJW7E1FypafYwBPndTo7YjTPPnFG?=
 =?us-ascii?Q?CyBK4TL4EAJR2965sEtALGNUta6oHOFs4b8Qu2XDQKXis5LxhRbuywCFIHwN?=
 =?us-ascii?Q?huxnRf+/aUqTnaYdeDrAolH41+KYIJOi13e2jjl0mPFln6Y46qAPKjJkcn8U?=
 =?us-ascii?Q?olXbMNVT9+CwzR4p2KtXCUrcjIAwf8AEDeOBtXVJvvFXBXeyYAKM+46ebUmi?=
 =?us-ascii?Q?J8aSlhoFFH7qAZEQ0P8L1AklDY2n/XgAYyapghMqEsgy8Tlwlk8OQcHvXnxp?=
 =?us-ascii?Q?zUWuelEswl03ULWo/3mr4HRMqkdLhUBtaxVikx9xz6r0WYTs92GVBQ/YctRB?=
 =?us-ascii?Q?iAq+rsxH57xbfrJJo5sGrDsaJJq6jhFPtPgpAVtTCrZ1v1hXaqBVLr7uK+dV?=
 =?us-ascii?Q?1XUQwwR0xlL2tN89cYVG69MmPO4oE8l9hRjcQe2UYzC2exBiPEl1Izbu6A+J?=
 =?us-ascii?Q?36Pseh3rAYbLNtVNsZimNFcqU6WHVFmxOaCFWcNiWzi7DDiW1Uyc5L/NHJRC?=
 =?us-ascii?Q?LhEO7nZsNJI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?feQ7heWbIBztJ7mR9S2+NfR5nn4DaZ5cT5U/iPSy+Qu8pc+VdY77ABetLYIn?=
 =?us-ascii?Q?S11o/WwoU+MYIsnls+Z1kgCwO+EB8sOMx//LU2JEYG+bAUjfkviLBBVesFbf?=
 =?us-ascii?Q?MLlGZxHEFMKPc+B3LcwN4fIIWKjl1m+Q5cmK6RUwp4O/7y8hAUCt+kd2o0Zz?=
 =?us-ascii?Q?gpCFtjxcJgVVa8pKPasNBHx4sDeZAqc22xlUOG9GDcQfVsHSMtAlp0+hPtaO?=
 =?us-ascii?Q?elpL7CJ9H9Q0Du1M7IJxtzdppoiEEapg7OS+oLEYF4g7zSbztXwn9CLLyV46?=
 =?us-ascii?Q?gkFy+Mbl28HpYURb3YetI1G0bUTnLwx7OartF14BX6jPbiaI8ALDpVQyKRDt?=
 =?us-ascii?Q?X3+jIfR1Aprio/TlzouvjUL6NUNbXE0oESDg0nCc2trc/7ZGEd6jAZQjHKo4?=
 =?us-ascii?Q?6CA3hWHhTIJGTBtXSs9lrs2jLLR8wSGJ/4a9lTbXMT+a0+YjaKN23PpwF+rJ?=
 =?us-ascii?Q?opl0Fx/LMog8WRGOyNleFzMAO6r9c114EWqVC7Lp0zVFNSJWEWDbrBkcFcLl?=
 =?us-ascii?Q?DB/GrbmjTLLP7dVAVLwBHGvUTtRrszqnYaK/RZpSdyZHdxRgMY7QCfNEAnRa?=
 =?us-ascii?Q?rKfmj4nR5UKvDVOpgoMKvC5YyKgbxLuarZJOupXYnlnd20Eu3c2AEL/OQ7A9?=
 =?us-ascii?Q?D+IbKSCiMeYYNHv8cPcJchJYLKHxnECFP9k5jQr3X0BAYGZWYWm5frVRWtV4?=
 =?us-ascii?Q?IbcioxNmmXmB/Kvtfi7F+tHx+vwxaEy+wn48UrJdS3aHp8PY9rYfuJfmVVuM?=
 =?us-ascii?Q?zn39cqcBtv8dVttEUJgRjSKwWNxFiQAgoEitOPIE1oF7Aa+muXjgVesb1rST?=
 =?us-ascii?Q?SwZrEeAsjpITROUzZDu0l2865YktnPKrzM/8SETuHCUVf7hFwvSQE/VzebiH?=
 =?us-ascii?Q?JMOhWgbezGiS1uWuk1XKvCdHHKXbgci6vnlNKgLT614DlfzK7gi8P2eJGuz6?=
 =?us-ascii?Q?6iWuNxGjWueUA03oSZJKsjsFMzo1Noaacu1ccSH0fXfG6l5kD3mU7cJ7JZox?=
 =?us-ascii?Q?Um+MNssXyZKYQs8KpvYIrEPLDNi5l5O9Fw51u+KlqXJQaDHyUQYTMJucpvyc?=
 =?us-ascii?Q?U3cEhDEU1ZVflf42in7KtcZT+Wq1K6aiuWgJ/87n+M50kl9HaZljASojJwXP?=
 =?us-ascii?Q?I89SIPi1ig90W1F1l6CUov9pYKe0+6l2Q9+w6dq+49ocS9zaQ0JQiO0LvbSt?=
 =?us-ascii?Q?VnwkrJ6Fv2Z3Ev+53cUvLXErGFyK2jsJHy7nsqe6b2+VUjKE93uxWUd/T+nO?=
 =?us-ascii?Q?TowzPgujEvgfIz1511wiRbzz/OnApkm9gSjwJuORzg2W1Y2cpt2RC0zhCnnB?=
 =?us-ascii?Q?j+uHLeHaRI00knkiLkbHLY/ycts+ZSYPQe6fNgJMD1/9dHLHEyeNr2I2hj8i?=
 =?us-ascii?Q?IXgln8bdqZeqURpPV/sZncQRv4bcbFtzyGr9Y5nfVkQ1+it33oiV8Do90qWI?=
 =?us-ascii?Q?qAQA5/YZxLFf8rcE/vjJBQPPB8Vigd7F8FVD2fZsbzGtCZdclMIHR7ZqY7qZ?=
 =?us-ascii?Q?cN9jOSz/M/4M034Qhk6PzYNdpBv64adu4uM3WR6pCkweFsBlCLW6qIYKzh1I?=
 =?us-ascii?Q?srGhko6UEoxI/6kvVSH5SbFdh3oasRlOA3bzeNYv?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 798b05ce-399d-43be-587c-08dde6a4465b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 02:32:18.8449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YmO2dHEbOdz1x3XHDk7r+MbT/Mhtkw47ujT2Jlb/KXt26N6q+eIvlvLy3Wfz8CLkLGEKlsw1TlJVsd1RY4Kbag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7204
X-OriginatorOrg: intel.com

On Thu, Aug 28, 2025 at 10:00:28AM -0700, Sean Christopherson wrote:
> On Thu, Aug 28, 2025, Yan Zhao wrote:
> > On Wed, Aug 27, 2025 at 12:08:27PM -0700, Sean Christopherson wrote:
> > > On Wed, Aug 27, 2025, Yan Zhao wrote:
> > > > On Tue, Aug 26, 2025 at 05:05:19PM -0700, Sean Christopherson wrote:
> > > > > @@ -1641,14 +1618,30 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
> > > > > +	/*
> > > > > +	 * If the TD isn't finalized/runnable, then userspace is initializing
> > > > > +	 * the VM image via KVM_TDX_INIT_MEM_REGION.  Increment the number of
> > > > > +	 * pages that need to be initialized via TDH.MEM.PAGE.ADD (PAGE.ADD
> > > > > +	 * requires a pre-existing S-EPT mapping).  KVM_TDX_FINALIZE_VM checks
> > > > > +	 * the counter to ensure all mapped pages have been added to the image,
> > > > > +	 * to prevent running the TD with uninitialized memory.
> > > > To prevent the mismatch between mirror EPT and the S-EPT?
> > > 
> > > No?  Because KVM bumps the count when installing the S-EPT and decrements it
> > > on AUG, so I don't see how nr_premapped guards against M-EPT vs. S-EPT issues?
> > Hmm, I think there must be some misunderstanding.
> 
> Yeah, I forgot that AUG and ADD create the leaf S-EPT entries.
> 
> > Before userspace invokes KVM_TDX_FINALIZE_VM,
> > =======
> > 1. the normal path (userspace invokes KVM_TDX_INIT_MEM_REGION).
> >    (1) KVM holds slot_lock and filemap lock.
> >    (2) KVM invokes kvm_tdp_map_page() (or kvm_tdp_mmu_map_private_pfn() in
> >        patch 2).
> >        KVM increases nr_premapped in tdx_sept_set_private_spte() to indicate
> >        that there's a page mapped in M-EPT, while it's not yet installed in
> >        S-EPT.
> >    (3) KVM invokes TDH.MEM.PAGE.ADD and decreases nr_premapped, indicating the
> >        page has been mapped in S-EPT too.
> >        
> >    As the name of nr_premapped indicates, the count means a page is pre-mapped
> >    in the M-EPT, before its real mapping in the S-EPT.
> >    If ADD fails in step (3), nr_premapped will not be decreased.
> > 
> >    With mere the normal path, nr_premapped should return back to 0 after all
> >    KVM_TDX_INIT_MEM_REGIONs.
> >       
> > 
> > 2. Expected zap paths (e.g. If userspace does something strange, such as
> >    removing a slot after KVM_TDX_INIT_MEM_REGION)
> >    Those zap paths could be triggered by
> >    1) userspace performs a page attribute conversion
> >    2) userspace invokes gmem punch hole
> >    3) userspace removes a slot
> >    As all those paths either hold a slot_lock or a filemap lock, they can't
> >    contend with tdx_vcpu_init_mem_region() (tdx_vcpu_init_mem_region holds both
> >    slot_lock and internally filemap lock).
> >    Consequently, those zaps must occur
> >    a) before kvm_tdp_map_page() or
> >    b) after TDH.MEM.PAGE.ADD.
> >    For a), tdx_sept_zap_private_spte() won't not be invoked as the page is not
> >            mapped in M-EPT either;
> >    For b), tdx_sept_zap_private_spte() should succeed, as the BLOCK and REMOVE
> >            SEAMCALLs are following the ADD.
> >    nr_premapped is therere unchanged, since it does not change the consistency
> >    between M-EPT and S-EPT.
> > 
> > 3. Unexpected zaps (such as kvm_zap_gfn_range()).
> 
> Side topic related to kvm_zap_gfn_range(), the KVM_BUG_ON() in vt_refresh_apicv_exec_ctrl()
> is flawed.  If kvm_recalculate_apic_map() fails to allocate an optimized map, KVM
> will mark APICv as inhibited, i.e. the associated WARN_ON_ONCE() is effectively
> user-triggerable.
> 
> Easiest thing would be to mark the vCPU as dead (though we obviously need
> "KVM: Never clear KVM_REQ_VM_DEAD from a vCPU's requests" for that to be robust).
> 
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index dbab1c15b0cd..1c0b43ff9544 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -719,7 +719,8 @@ static void vt_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
>  static void vt_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
>  {
>         if (is_td_vcpu(vcpu)) {
> -               KVM_BUG_ON(!kvm_vcpu_apicv_active(vcpu), vcpu->kvm);
> +               if (!kvm_vcpu_apicv_active(vcpu))
> +                       kvm_make_request(KVM_REQ_VM_DEAD, vcpu);
>                 return;
>         }
>  
> >    Those zaps are currently just paranoid ones. Not found in any existing paths
> >    yet. i.e.,
> >    We want to detect any future code or any missed code piecies, which invokes
> >    kvm_zap_gfn_range() (or maybe zaps under read mmu_lock).
> > 
> >    As those zaps do not necessarily hold slot_lock or filemap lock, they may
> >    ocurr after installing M-EPT and before installing S-EPT.
> >    As a result, the BLOCK fails and tdx_is_sept_zap_err_due_to_premap() returns
> >    true.
> >    Decreasing nr_premapped here to indicate the count of pages mapped in M-EPT
> >    but not in S-EPT decreases.
> > 
> >    TDH.MEM.PAGE.ADD after this zap can still succeed. If this occurs, the page
> >    will be mapped in S-EPT only. As KVM also decreases nr_premapped after a
> >    successful TDH.MEM.PAGE.ADD, the nr_premapped will be <0 in the end.
> >    So, we will be able to detect those unexpected zaps.
> >    
> > 
> > When userspace invokes KVM_TDX_FINALIZE_VM,
> > =======
> > The nr_premapped must be 0 before tdx_td_finalize() succeeds.
> > 
> > The nr_premapped could be 0 if
> > (1) userspace invokes KVM_TDX_INIT_MEM_REGIONs as in a normal way.
> > (2) userspace never triggers any KVM_TDX_INIT_MEM_REGION.
> > (3) userspace triggers KVM_TDX_INIT_MEM_REGION but zaps all initial memory
> >     regions.
> > 
> > For (2)and(3), KVM_TDX_FINALIZE_VM can still succeed.
> 
> Ya, we're in agreement on what can happen.  I think all of the confusion was due
> to me forgetting that TDH.MEM.PAGE.ADD is what actually installes the leaf S-EPT
> entry.
> 
> > So, TD can still run with uninitialized memory.
> 
> No, the TD can never run with truly uninitialized memory.  By "uninitialized", I
> mean memory that the guest can access and which has not been written to.  Again,
> my confusion was due to thinking a page was already mapped into the guest, but
> awaiting TDH.MEM.PAGE.ADD to 
>  
> > > Side topic, why does KVM tolerate tdh_mem_page_add() failure?  IIUC, playing
> > We don't. It returns -EBUSY or -EIO immediately.
> 
> But that _is_ tolerating failure, in the sense that KVM doesn't prevent further
> actions on the VM.  Tolerating failure is fine in general, but in this case it
> leaves the MMU is left in a half-baked state.  
> 
> > > nice with tdh_mem_page_add() failure necessitates both the
> > > tdx_is_sept_zap_err_due_to_premap() craziness and the check in tdx_td_finalize()
> > > that all pending pages have been consumed.
> > 
> > tdx_is_sept_zap_err_due_to_premap() detects the error of BLOCK, which is caused
> > by executing BLOCK before ADD.
> 
> We need to make this situation impossible.
Currently this situation should be impossible already.
If there're still missing ones, we can fix it (as you did above).

But this tdx_is_sept_zap_err_due_to_premap() check is just to detect if anything
is still missing.
Or maybe directly KVM_BUG_ON() on that is also ok.


> > > What reasonable use case is there for gracefully handling tdh_mem_page_add() failure?
> > If tdh_mem_page_add() fails, the KVM_TDX_INIT_MEM_REGION just fails.
> > 
> > > If there is a need to handle failure, I gotta imagine it's only for the -EBUSY
> > > case.  And if it's only for -EBUSY, why can't that be handled by retrying in
> > > tdx_vcpu_init_mem_region()?  If tdx_vcpu_init_mem_region() guarantees that all
> > I analyzed the contention status of tdh_mem_sept_add() at
> > https://lore.kernel.org/kvm/20250113021050.18828-1-yan.y.zhao@intel.com.
> > 
> > As the userspace is expected to execute KVM_TDX_INIT_MEM_REGION in only one
> > vCPU, returning -EBUSY instead of retrying looks safer and easier.
> > 
> > > pages mapped into the S-EPT are ADDed, then it can assert that there are no
> > > pending pages when it completes (even if it "fails"), and similarly
> > > tdx_td_finalize() can KVM_BUG_ON/WARN_ON the number of pending pages being
> > > non-zero.
> > tdx_td_finalize() now just returns -EINVAL in case of nr_premapped being !0.
> > KVM_BUG_ON/WARN_ON should be also ok.
> 
> Ok, so I vaguely recall that I may have pushed back on using a scratch field in
> "struct kvm_tdx" for temporary data (or maybe it was abusing vcpus[0] that I
> disliked?), but what we ended up with is far worse.
> 
> For all intents and purposes, nr_premapped _is_ a temporary scratch field, but
> with access rules that are all but impossible to understand, e.g. there's practically
> zero chance anyone could suss out complications with "Unexpected zaps", and the
> existence of that super subtle edge case necessitates using an atomic because
> KVM can't strictly guarantee that access to the field is mutually exclusive.  And
> that also means it's inherently racy, e.g. if a zap happens while tdx_td_finalize()
> is checking nr_premapped, what happens?
The tdx_td_finalize() takes slots_lock and you asserted those unexpected zaps
at https://lore.kernel.org/all/20250827000522.4022426-11-seanjc@google.com.

Expected zaps can't occur during tdx_td_finalize checking nr_premapped either.

 
> The real killer is that deferring TDH.MEM.PAGE.ADD and TDH.MR_EXTEND until after
> the map completes and mmu_lock is dropped means that failure at that point leaves
> the TDP MMU in an inconsistent state, where the M-EPT has a present page but the
> S-EPT does not.  Eww.
Eww... That's why there's nr_premapped.
And it's suggested by you, though you called it "Crazy idea"...
https://lore.kernel.org/kvm/Ze-TJh0BBOWm9spT@google.com/

> Note, in no way am I trying to blame anyone; quite the opposite, you've done an
> admirable job to get all of this landed.  And I apologize if any of my past
> feedback led y'all down this road.  I suspect my prefaulting idea really screwed
> things up; sorry :-(
It's ok :)

> Back to the code, unless I'm missing yet another complication, I think the obvious
> fix to all of this is to pass the source page and metadata flags via a scratch
> field in "struct kvm_tdx", and then do PAGE.ADD and MR.EXTEND in
> tdx_sept_set_private_spte().  Then there is no need to keep track of pending
> pages, because the M-EPT and S-EPT are always consistent.  E.g. if PAGE.ADD fails
> with -EBUSY, then KVM will naturally revert the M-EPT entry from FROZEN to !PRESENT.
> It also allows KVM to KVM_BUG_ON() MR.EXTEND failure, because it should be impossible
> for the S-EPT entry to be modified between PAGE.ADD and MR.EXTEND.
> 
> Diff on top below for feedback on the idea.  A proper series for this would simply
> replace several of the patches, e.g. asserting that slots_lock is held on
> tdx_is_sept_zap_err_due_to_premap() is wrong.
Looks it's similar to the implementation in v19?
https://lore.kernel.org/all/bbac4998cfb34da496646491038b03f501964cbd.1708933498.git.isaku.yamahata@intel.com/

> ---
>  arch/x86/kvm/vmx/tdx.c | 157 +++++++++++++++++------------------------
>  arch/x86/kvm/vmx/tdx.h |  11 +--
>  2 files changed, 70 insertions(+), 98 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index f9ac590e8ff0..5d981a061442 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1586,6 +1586,56 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
>  	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa);
>  }
>  
> +
> +struct kvm_tdx_page_add {
> +	struct page *src;
> +	unsigned long flags;
> +};
> +
> +static int tdx_mem_page_add(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> +			    kvm_pfn_t pfn)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	u64 err, entry, level_state;
> +	gpa_t gpa = gfn_to_gpa(gfn);
> +	int i;
> +
> +	lockdep_assert_held(&kvm->slots_lock);
> +
> +	if (KVM_BUG_ON(kvm->arch.pre_fault_allowed, kvm) ||
> +	    KVM_BUG_ON(!kvm_tdx->page_add, kvm))
> +		return -EIO;
> +
> +	err = tdh_mem_page_add(&kvm_tdx->td, gpa, pfn_to_page(pfn),
> +			       kvm_tdx->page_add->src, &entry, &level_state);
> +	if (unlikely(tdx_operand_busy(err)))
> +		return -EBUSY;
> +
> +	if (KVM_BUG_ON(err, kvm)) {
> +		pr_tdx_error_2(TDH_MEM_PAGE_ADD, err, entry, level_state);
> +		return -EIO;
> +	}
> +
> +	if (!(kvm_tdx->page_add->flags & KVM_TDX_MEASURE_MEMORY_REGION))
> +		return 0;
> +
> +	/*
> +	 * Extend the measurement while holding mmu_lock to ensure MR.EXTEND
> +	 * can't fail, e.g. due to the S-EPT entry being zapped after PAGE.ADD.
> +	 * Note!  If extended the measurement fails, bug the VM, but do NOT
> +	 * return an error, as mapping the page in the S-EPT succeeded and so
> +	 * needs to be tracked in KVM's mirror page tables.
> +	 */
> +	for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
> +		err = tdh_mr_extend(&kvm_tdx->td, gpa + i, &entry, &level_state);
> +		if (KVM_BUG_ON(err, kvm)) {
> +			pr_tdx_error_2(TDH_MR_EXTEND, err, entry, level_state);
> +			break;
> +		}
> +	}
> +	return 0;
> +}
> +
>  static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
>  			    enum pg_level level, kvm_pfn_t pfn)
>  {
> @@ -1627,21 +1677,11 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
>  
>  	/*
>  	 * If the TD isn't finalized/runnable, then userspace is initializing
> -	 * the VM image via KVM_TDX_INIT_MEM_REGION.  Increment the number of
> -	 * pages that need to be initialized via TDH.MEM.PAGE.ADD (PAGE.ADD
> -	 * requires a pre-existing S-EPT mapping).  KVM_TDX_FINALIZE_VM checks
> -	 * the counter to ensure all mapped pages have been added to the image,
> -	 * to prevent running the TD with uninitialized memory.
> +	 * the VM image via KVM_TDX_INIT_MEM_REGION.  Add the page to the TD,
> +	 * and optionally extend the measurement with the page contents.
>  	 */
> -	if (unlikely(kvm_tdx->state != TD_STATE_RUNNABLE)) {
> -		lockdep_assert_held(&kvm->slots_lock);
> -
> -		if (KVM_BUG_ON(kvm->arch.pre_fault_allowed, kvm))
> -			return -EIO;
> -
> -		kvm_tdx->nr_pending_tdh_mem_page_adds++;
> -		return 0;
> -	}
> +	if (unlikely(kvm_tdx->state != TD_STATE_RUNNABLE))
> +		return tdx_mem_page_add(kvm, gfn, level, pfn);
>  
>  	return tdx_mem_page_aug(kvm, gfn, level, pfn);
>  }
> @@ -1716,39 +1756,6 @@ static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
>  	return 0;
>  }
>  
> -/*
> - * Check if the error returned from a SEPT zap SEAMCALL is due to that a page is
> - * mapped by KVM_TDX_INIT_MEM_REGION without tdh_mem_page_add() being called
> - * successfully.
> - *
> - * Since tdh_mem_sept_add() must have been invoked successfully before a
> - * non-leaf entry present in the mirrored page table, the SEPT ZAP related
> - * SEAMCALLs should not encounter err TDX_EPT_WALK_FAILED. They should instead
> - * find TDX_EPT_ENTRY_STATE_INCORRECT due to an empty leaf entry found in the
> - * SEPT.
> - *
> - * Further check if the returned entry from SEPT walking is with RWX permissions
> - * to filter out anything unexpected.
> - *
> - * Note: @level is pg_level, not the tdx_level. The tdx_level extracted from
> - * level_state returned from a SEAMCALL error is the same as that passed into
> - * the SEAMCALL.
> - */
> -static int tdx_is_sept_zap_err_due_to_premap(struct kvm_tdx *kvm_tdx, u64 err,
> -					     u64 entry, int level)
> -{
> -	if (!err || kvm_tdx->state == TD_STATE_RUNNABLE)
> -		return false;
> -
> -	if (err != (TDX_EPT_ENTRY_STATE_INCORRECT | TDX_OPERAND_ID_RCX))
> -		return false;
> -
> -	if ((is_last_spte(entry, level) && (entry & VMX_EPT_RWX_MASK)))
> -		return false;
> -
> -	return true;
> -}
> -
>  static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
>  				     enum pg_level level, struct page *page)
>  {
> @@ -1768,15 +1775,6 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
>  		err = tdh_mem_range_block(&kvm_tdx->td, gpa, tdx_level, &entry, &level_state);
>  		tdx_no_vcpus_enter_stop(kvm);
>  	}
> -	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level)) {
> -		lockdep_assert_held(&kvm->slots_lock);
> -
> -		if (KVM_BUG_ON(--kvm_tdx->nr_pending_tdh_mem_page_adds < 0, kvm))
> -			return -EIO;
> -
> -		return 0;
> -	}
> -
>  	if (KVM_BUG_ON(err, kvm)) {
>  		pr_tdx_error_2(TDH_MEM_RANGE_BLOCK, err, entry, level_state);
>  		return -EIO;
> @@ -2842,12 +2840,6 @@ static int tdx_td_finalize(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
>  
>  	if (!is_hkid_assigned(kvm_tdx) || kvm_tdx->state == TD_STATE_RUNNABLE)
>  		return -EINVAL;
> -	/*
> -	 * Pages are pending for KVM_TDX_INIT_MEM_REGION to issue
> -	 * TDH.MEM.PAGE.ADD().
> -	 */
> -	if (kvm_tdx->nr_pending_tdh_mem_page_adds)
> -		return -EINVAL;
>  
>  	cmd->hw_error = tdh_mr_finalize(&kvm_tdx->td);
>  	if (tdx_operand_busy(cmd->hw_error))
> @@ -3131,50 +3123,29 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>  {
>  	struct tdx_gmem_post_populate_arg *arg = _arg;
>  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> -	u64 err, entry, level_state;
> -	gpa_t gpa = gfn_to_gpa(gfn);
> -	struct page *src_page;
> -	int ret, i;
> +	struct kvm_tdx_page_add page_add = {
> +		.flags = arg->flags,
> +	};
> +	int ret;
>  
> -	lockdep_assert_held(&kvm->slots_lock);
> +	if (KVM_BUG_ON(kvm_tdx->page_add, kvm))
> +		return -EIO;
>  
>  	/*
>  	 * Get the source page if it has been faulted in. Return failure if the
>  	 * source page has been swapped out or unmapped in primary memory.
>  	 */
> -	ret = get_user_pages_fast((unsigned long)src, 1, 0, &src_page);
> +	ret = get_user_pages_fast((unsigned long)src, 1, 0, &page_add.src);
>  	if (ret < 0)
>  		return ret;
>  	if (ret != 1)
>  		return -ENOMEM;
>  
> +	kvm_tdx->page_add = &page_add;
>  	ret = kvm_tdp_mmu_map_private_pfn(arg->vcpu, gfn, pfn);
> -	if (ret < 0)
> -		goto out;
> +	kvm_tdx->page_add = NULL;
>  
> -	ret = 0;
> -	err = tdh_mem_page_add(&kvm_tdx->td, gpa, pfn_to_page(pfn),
> -			       src_page, &entry, &level_state);
> -	if (err) {
> -		ret = unlikely(tdx_operand_busy(err)) ? -EBUSY : -EIO;
> -		goto out;
> -	}
> -
> -	KVM_BUG_ON(--kvm_tdx->nr_pending_tdh_mem_page_adds < 0, kvm);
> -
> -	if (arg->flags & KVM_TDX_MEASURE_MEMORY_REGION) {
> -		for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
> -			err = tdh_mr_extend(&kvm_tdx->td, gpa + i, &entry,
> -					    &level_state);
> -			if (err) {
> -				ret = -EIO;
> -				break;
> -			}
> -		}
> -	}
> -
> -out:
> -	put_page(src_page);
> +	put_page(page_add.src);
>  	return ret;
>  }
>  
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 45d86f9fa41c..39e0c3bcc866 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -21,6 +21,8 @@ enum kvm_tdx_state {
>  	TD_STATE_RUNNABLE,
>  };
>  
> +struct kvm_tdx_add_page;
> +
>  struct kvm_tdx {
>  	struct kvm kvm;
>  
> @@ -37,12 +39,11 @@ struct kvm_tdx {
>  	struct tdx_td td;
>  
>  	/*
> -	 * The number of pages that KVM_TDX_INIT_MEM_REGION has mapped into the
> -	 * S-EPT, but not yet initialized via TDH.MEM.PAGE_ADD.  Used to sanity
> -	 * check adding pages to the image, and to ensure that all pages have
> -	 * been initialized before finalizing the TD.
> +	 * Scratch structure used to pass the source page and metadata flags to
> +	 * tdx_mem_page_add.  Protected by slots_lock, and non-NULL only when
> +	 * mapping a private pfn via tdx_gmem_post_populate().
>  	 */
> -	unsigned long nr_pending_tdh_mem_page_adds;
> +	struct kvm_tdx_page_add *page_add;
>  
>  	/*
>  	 * Prevent vCPUs from TD entry to ensure SEPT zap related SEAMCALLs do
> 
> base-commit: 7c7a3893b102bdeb4826f7140280b7b16081b385
> --

