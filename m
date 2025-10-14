Return-Path: <kvm+bounces-59999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D3DEBD7CA0
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 09:01:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7429218A2364
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 06:59:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36ABF30E0E6;
	Tue, 14 Oct 2025 06:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GYy/9Lsy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B452405FD;
	Tue, 14 Oct 2025 06:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760425078; cv=fail; b=Fs8UiQYp9XiPqdvBQJ7f8+XLoN1PTVLkJ7urFc//noo2o/8NDptU32n2Lc4B+C97+QlIq7NU/Nn/ju/G0Dm/HJHr+ukUdXYamuhRISUrB3c3QPBf+l7YxHmMSgDAqIORr8nDUMbt9Hhorn89qDEZFObmk4l0a7aVk443OxZeKQY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760425078; c=relaxed/simple;
	bh=BL25zfKoTZBAZbL5BIj0lBv5wA1Ykx/vCubsXG14Jlo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RdSfh8aWG79OL1HSTmUKi8+sDHfy+A2NSq8rcJ8Zy8yUSMPjyN9FEykT2Ffhjt9q4BSFPaqyd6QtSe/ENOxwOadFMfwWOhyG0hFKlKS/4lBiV+HjTuWX31dEV4F2YEIvtqYxCt3GZOUEgZSPC0qaPMb7tVpnBaNCiDJCS2D9u6s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GYy/9Lsy; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760425077; x=1791961077;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=BL25zfKoTZBAZbL5BIj0lBv5wA1Ykx/vCubsXG14Jlo=;
  b=GYy/9LsykEAZzaBgOaXUaPdgteQMklGEsXylZUQka93zOLtmd2kO4Kxs
   SsxSo6xM0Hw/dHd4fLwItOY+bjFo0ejYneXQRoOI9y72aBo1fm9zjMyFt
   WwVRVeWrwv26kdKa1FEZZjQugF5TJzDt01MhbyikgMHN38L9MbbGqSsNX
   lBDWE54L7oIrRXBo0BgmKmUpH3P3WxiSlzaJrQl9m+KDStURTcFkRzW1N
   /0yu2gvFxqVjAORAKCy5TJ/OsU2Bo2F3QRPuqGL0GRgvb+X1ai/RVrbWB
   i8eyzYTOIwQoXo9vQdAQFv6I0lcvT1P0L4oDsHAMrL115fZC9/o+gUxgZ
   w==;
X-CSE-ConnectionGUID: Y9Vix65dReyZXE/XdCNLuw==
X-CSE-MsgGUID: EkfxOoLpSrWiOMolpwYKwg==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="66429999"
X-IronPort-AV: E=Sophos;i="6.19,227,1754982000"; 
   d="scan'208";a="66429999"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 23:57:55 -0700
X-CSE-ConnectionGUID: xkCYjYyzT3ySn6U2AAx5BA==
X-CSE-MsgGUID: yqz3XVIdRtWJCmKc1kSSrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,227,1754982000"; 
   d="scan'208";a="181820849"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 23:57:55 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 13 Oct 2025 23:57:54 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 13 Oct 2025 23:57:54 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.0) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 13 Oct 2025 23:57:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=THpJAzVfVg+Zyf3ABVrbscEk84ZXcPErbWH8wGyBFTkqjfc/VMR/OhKXpZQuql+ZKbYwisv8dScjYHfJrpZI7gRG7jyDcqwH8a4fyxNqh7Q4l/IWovD+MsxnDMYL+8lx38eB6O3Tvhx8qokyACo1sX70ZWyeUZvVTggt9GC2mDoiB1y+GrjGIY4Yq5rXwL3AhKJXNCpmN8qB7/jEAvd+KQIYnBvee/pwAGQs1EEWATOTCC26Wiif9cbspagsuCjLqWllDdMKtvK2dkNokCujQ2PqOUuuUxHMFzK1RMGjTcsSVizKeFSQxiA94KE2I3utTe4E6TGeCaLrfHr9VP/s+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LJgxOfTf5ZUcSgGu8oiYxSU8J9LqPpJdpUFS1PMNR8U=;
 b=s9kGu3cXSk9DFhQZ3hlxo59VHWlT+V98VyxBjKkX5i8L1m4odohr4r0HVHTDZnsEy2sfwgSLmaco3+ljbP55xyQPhX99MeZIkEa2e7UH9PZaIOQLThKl9WCXUBiXZeV9goNr7mFGYCK+qsx9eWmiqIPFE+vnFahIZdRDe0c8BdJmnK4joAGU7bMdHQqumlVcbYng2RBtzXemgQr6dB++Q6NENMsXOehoRogxgGCHzJg/+4YO4jhvg3trCa2Db9QHfwM4kt9ufi6vugeTd44fHeN3shZENJsbTFYcqcSNJ/EH3WTlA+2QT1IvrL0Ich+LOlvXFfwpMZ0frmwEh4vM8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ2PR11MB8565.namprd11.prod.outlook.com (2603:10b6:a03:56b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.9; Tue, 14 Oct
 2025 06:57:47 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%7]) with mapi id 15.20.9203.009; Tue, 14 Oct 2025
 06:57:46 +0000
Date: Tue, 14 Oct 2025 14:57:35 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Xin Li (Intel)" <xin@zytor.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>,
	<hch@infradead.org>
Subject: Re: [PATCH v8 18/21] KVM: nVMX: Add FRED VMCS fields to nested VMX
 context handling
Message-ID: <aO30XxyprRrs3pT2@intel.com>
References: <20251014010950.1568389-1-xin@zytor.com>
 <20251014010950.1568389-19-xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251014010950.1568389-19-xin@zytor.com>
X-ClientProxiedBy: SI1PR02CA0031.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::11) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ2PR11MB8565:EE_
X-MS-Office365-Filtering-Correlation-Id: b55fc742-bbcd-4980-c1bf-08de0aeefb32
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?8jAYMxPmNNqlbm3LU2k0TylgIFNHn8A+H++DVlWI9ELW7swbV3rlXKiY8MN4?=
 =?us-ascii?Q?IIxGUmE32I7S7ewWTk32uqmicyNwDQ/L6AE/b3cfthvzFudoB0V2GYvfuofx?=
 =?us-ascii?Q?hrILYtMObnYi40XYJNRU/+dQXKkAjREc9GkFPpFVuCIOnpHWxRP3glyJhCoq?=
 =?us-ascii?Q?65wnw7ANJQAkczl2TUgsgynJFG5/NzswPQBpHwrB9stuLOff5skGLDwCw8WK?=
 =?us-ascii?Q?BYX7p8lNrKrBcF47rQrkZr7nOwtNAsGlcllj5M4gVjsqq18zR2OUrtk6fZDu?=
 =?us-ascii?Q?0K885sw1h9+UNL+XXfQitVJlHu20xhDthfagKO52caFIvtCTZMIlVc2Ec2pX?=
 =?us-ascii?Q?fyh3EYu2VePqvKaJyhVG3Qdt86/AN/Gdk8YV2/b3FNN5e7bV5bowjgFXPD8K?=
 =?us-ascii?Q?2LcXf/X06EhltzDDy8gW0/L2u1SLdekpvL8pLIWsAg7GM5bI7YX86n02E6aj?=
 =?us-ascii?Q?0oeY5kevD+3zXJ8uYZlql6P1Dk8Oadez2xSDJVim8bEVJFERDHCum6ZEzdVs?=
 =?us-ascii?Q?669L3ZI+KRX4dJ2dVuwg4kK29Zi9IfDcfto4krxMCnEYafx4bB2tTHcVrt11?=
 =?us-ascii?Q?mckpwACqlObQ5TXP9A52SNkfhviEzEng76TvNr3cTx6CzQiYP5pNfR+tOkjt?=
 =?us-ascii?Q?fp4gHNIueQAjKaI/TogLFtUWPiBAztd0VigTxMSTtGQVZPbXRURyEk6kM4D+?=
 =?us-ascii?Q?PWm10gh3sEDvjb1t4nWIE5cEp4LNN/GbWQsKUu6WSVJA1P6Kl/d5UAECAAWX?=
 =?us-ascii?Q?8JnZdMZXsOPc9A6n2XNVF1mjQBnt4cgdDv5IOAWy4+1M98lOHVe8E2WrlYHH?=
 =?us-ascii?Q?UPBFc51dQipdI2JrneJgS9fn/E9/4udC5eqHVBf+kV85fTK2hqWynMrtAJOJ?=
 =?us-ascii?Q?gx5B4mHOXu+NQT6i76YrPDadfaHfLhImrY1r38wRa/+n45iPgNoGKujjqSxw?=
 =?us-ascii?Q?D49OzfqhQmYjXMn5FosYa5e2YlvS6w/b5sTCtsHy/9eJgGT4EKH3qNeAgzJC?=
 =?us-ascii?Q?IAXrWwkz6fSCMuFUuH2vxa9ShKPxd7YWakKFeiCIb4VgT5DnbnyI5Rq6T0Z/?=
 =?us-ascii?Q?L2aWmpsoBr5p5GoiYyW9WWJWqV4DxXYKlUaPF3fyzFA6eztyuKkUj/T1x8a6?=
 =?us-ascii?Q?e2GxT6s4gGh2FEYFbHzy19Oiln6IOgeq2bPUGhOjZhzw3/2p7imOoJI/6ilZ?=
 =?us-ascii?Q?LP7DrsKcNHCRvQk/Ku9TB+BhEQNpSQVQBjvDpRljHyHHE766E67KEX2q+mtW?=
 =?us-ascii?Q?jlU7jd4llhgrSDfhkSG6Jbpd5jK/gXOhQmGuAi6vskaLZ5NC7y8Es/rfH9Ms?=
 =?us-ascii?Q?FXpOOFj1KK9Bnka4GcXlp5qlNpZFBsOn6ePaEACbcSA3lx6bCB/GuDSg80hZ?=
 =?us-ascii?Q?GUIhbVAgw8p4QMPEDa6K2RxnklHr1N3HkpXTdL6ABOi0MkvMJFaDDbv+B6nh?=
 =?us-ascii?Q?3fy4I/1iC/NXIxtCUe+/Xz8YDA+kMszT?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uNkW5v76GHEhL2DyuK73SmEVfDw4n7QadrotnVCZP9rYkwGiu5H822CnIPX7?=
 =?us-ascii?Q?a0nK5FBXGlBSwy+Gurwpscw+2WBBxsTNikjo71lSa0J0EWsvJnhJsdE1BS+w?=
 =?us-ascii?Q?+KiVzFLSfzRHTJsuMIME3hTlgX/sONUlX1BNXctyeFNbCjRcRVL2Sl06LuBo?=
 =?us-ascii?Q?hxlA71RwK/+0wifJtTnYObgMGQLpceu79OjJKFLULtgAG0FzGRTPAzMLvgSc?=
 =?us-ascii?Q?eDIloMcC9IIOZL653P4KyX82kBzCp2yY2Nco/WJlIu2+8CTL6MtDwPw/5WSc?=
 =?us-ascii?Q?h9YaaU0DrpGY4QFgxxnATmwFbA3cA7WE8xLaiowziQsPrV1u5PhS67OA1NSh?=
 =?us-ascii?Q?R462wrM87UnJio5dHze1V8IqQ2M+3oGcO02FQrn2AA475ZYjOY8Uks7XbSdm?=
 =?us-ascii?Q?z/EmeOjYhofKFY3TaFw68187fIzj3aQ6YkFdHNRdfeol+9OzJR7Y/rEJqy5Y?=
 =?us-ascii?Q?Eka+qbaT6eGi5DyfPQQW+BasHnYD/69MGaeuyTrEeZSgtrM9wteEpM0PVVNZ?=
 =?us-ascii?Q?74PNum+7IwyFy0iphsmBasoSi+8f1gUgEOazS0pfVPSjr0CUGYb4oa0ZrP6+?=
 =?us-ascii?Q?1oChPknlCGcXeqi8AAO+Ci+NWCIJbgklxL5KMkk6hoFBdS9ilCI99ENzmCGR?=
 =?us-ascii?Q?brVvJocpEgXiGgN2I/yAZMu8IBJKGOnGhoIAx3CUTImmpMqosZweNbGhgrtk?=
 =?us-ascii?Q?vgIdOuEK89mss7DH7V5YynZL6Y3LTPZXPPq+QFVLK/smpENd9kPbn+c29onO?=
 =?us-ascii?Q?+Elky/MTLxT92FiwcCF7z1E+u/FBSToPVe5SqSodTe2TVJOFobRPwRnvKdBa?=
 =?us-ascii?Q?V/chVy5VCatzFhIgxDc7+8c869yGEQYdkH2HjUftyjFPMd3NZwVOb6PJgIoH?=
 =?us-ascii?Q?i+eR6XngS/92Ph61Zk3lJQMcDdzqm5LDD94jHsWiWAQ3hFoxI7523pkhYtzR?=
 =?us-ascii?Q?T0/Cnh6Nr0zYz9b0/BJDc7MwMSDFMwc9RPgPUu5NIJIyegrsfZeR83zRZKuZ?=
 =?us-ascii?Q?mnlVYV727VmrofyHMWZFXchTawtqUNf3K8CNTxL9pTrqbnzjKiI9dmVb6qf4?=
 =?us-ascii?Q?qkTuk2fi3DXnb+eyBv2uGZv1GJzEmf+EcuKmmPp9VTcg7hTSPn1Iqfc5fia2?=
 =?us-ascii?Q?AOgPlHqmFYP3YPfBRrhBDlyGoR9DHOT2ptnjKSK8dD8Q5ARoeeRdh8qHkRji?=
 =?us-ascii?Q?MphorXobzw2jxUQdfvSg7YiUgwUGotgzLc+LwEESiLJl+uGwZnaM7QUo+lXd?=
 =?us-ascii?Q?YVzAy1hW3xcP7GOlK7GS1ZS9uFF1zJqhrH74Su8W2AHAd52/qFe42Xacs0vi?=
 =?us-ascii?Q?ElIS0422uZSCIxp9aXg0P1dPEer75XJdvqDhy6UKxHcSKtSKueMzWj1kv7xR?=
 =?us-ascii?Q?dO7/tRvPQBzFGXg+NM0jPSmb6n1JXyB0O0YDwgJfYvxgfW3iIS6j2e7l2jgb?=
 =?us-ascii?Q?5IWmThLa0pcsZhseTG0aXm+STXZ4lHUUThV2q6KmNHcGXEiC8ajqDOtIlN4g?=
 =?us-ascii?Q?P8iIxr5xAIecEln1N0h+hva0Dqmt8ezEvAFECuKPs7PpqDisq92slk44HOMD?=
 =?us-ascii?Q?ANSgAbvP8MVh2gljdWEi031G3G3UNQJq9/o2EkFE?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b55fc742-bbcd-4980-c1bf-08de0aeefb32
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 06:57:46.7847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gWKjnGJiN6kPFddPyy1LvcOV9SI7/KwH8XfkaH+RImH29pt2y30tlJioLw4p23JmXqMjqbPQOloT8WbEVgFykw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8565
X-OriginatorOrg: intel.com

> /*
>@@ -2765,6 +2783,18 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
> 		vmcs_write64(GUEST_IA32_PAT, vmx->vcpu.arch.pat);
> 	}
> 
>+	if (!vmx->nested.nested_run_pending ||
>+	    !nested_cpu_load_guest_fred_state(vmcs12)) {
>+		vmcs_write64(GUEST_IA32_FRED_CONFIG, vmx->nested.pre_vmenter_fred_config);
>+		vmcs_write64(GUEST_IA32_FRED_RSP1, vmx->nested.pre_vmenter_fred_rsp1);
>+		vmcs_write64(GUEST_IA32_FRED_RSP2, vmx->nested.pre_vmenter_fred_rsp2);
>+		vmcs_write64(GUEST_IA32_FRED_RSP3, vmx->nested.pre_vmenter_fred_rsp3);
>+		vmcs_write64(GUEST_IA32_FRED_STKLVLS, vmx->nested.pre_vmenter_fred_stklvls);
>+		vmcs_write64(GUEST_IA32_FRED_SSP1, vmx->nested.pre_vmenter_fred_ssp1);
>+		vmcs_write64(GUEST_IA32_FRED_SSP2, vmx->nested.pre_vmenter_fred_ssp2);
>+		vmcs_write64(GUEST_IA32_FRED_SSP3, vmx->nested.pre_vmenter_fred_ssp3);

...

>+	}
>+
> 	vcpu->arch.tsc_offset = kvm_calc_nested_tsc_offset(
> 			vcpu->arch.l1_tsc_offset,
> 			vmx_get_l2_tsc_offset(vcpu),
>@@ -3679,6 +3709,18 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
> 				    &vmx->nested.pre_vmenter_ssp,
> 				    &vmx->nested.pre_vmenter_ssp_tbl);
> 
>+	if (!vmx->nested.nested_run_pending ||
>+	    !nested_cpu_load_guest_fred_state(vmcs12)) {
>+		vmx->nested.pre_vmenter_fred_config = vmcs_read64(GUEST_IA32_FRED_CONFIG);
>+		vmx->nested.pre_vmenter_fred_rsp1 = vmcs_read64(GUEST_IA32_FRED_RSP1);
>+		vmx->nested.pre_vmenter_fred_rsp2 = vmcs_read64(GUEST_IA32_FRED_RSP2);
>+		vmx->nested.pre_vmenter_fred_rsp3 = vmcs_read64(GUEST_IA32_FRED_RSP3);
>+		vmx->nested.pre_vmenter_fred_stklvls = vmcs_read64(GUEST_IA32_FRED_STKLVLS);
>+		vmx->nested.pre_vmenter_fred_ssp1 = vmcs_read64(GUEST_IA32_FRED_SSP1);
>+		vmx->nested.pre_vmenter_fred_ssp2 = vmcs_read64(GUEST_IA32_FRED_SSP2);
>+		vmx->nested.pre_vmenter_fred_ssp3 = vmcs_read64(GUEST_IA32_FRED_SSP3);

FRED state save/restore is needed only when the guest has FRED support. So, the
above save/restore should be guarded by guest_cpu_cap_has(vcpu, X86_FEATURE_FRED).
Otherwise, on hardware without FRED, vmread_error() would be triggered here as
reported by syzbot.

