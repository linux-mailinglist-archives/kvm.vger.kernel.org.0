Return-Path: <kvm+bounces-49367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C3EFAD81BE
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 05:32:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 40F05189A872
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 03:32:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8B8C1DF742;
	Fri, 13 Jun 2025 03:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RrL3UKLN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5C81E87B;
	Fri, 13 Jun 2025 03:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749785532; cv=fail; b=nMaix5N8ko6QFZR3q9UxEjqo5ADItTZuMe7a9qrre/s0Gt55Nza0PgxWgygnwe+oI6XCs5lEWfGnTrhDf31UV19DR6mSQ7Q0uUbash7+SPJRmoWO8+Lm6L7YeJWF2ex7+5wxn0vDgZ443opdlOwe2kIT0no2JIlvY05+N3sksIs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749785532; c=relaxed/simple;
	bh=qwYV6Y9wWmWxBbsfWC7y36o0ykCax1f1Fz0Hed/jK+o=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MrYP7RdnoW0MMFIAplc8AdrCv7iUvkz7w4TE+dOw1TiPA3p4rArrvTDT/ol6du/FNiaY0kvuc9y2zp9VJoV7cibwtxaSoyfjxCMhckuMG/v8K//OEexAjr+Ct3yFTN6PmvJHUjwW2gu9n0MpCIT1ssP7OfJG14eLWdsmzSCxPmA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RrL3UKLN; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749785531; x=1781321531;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=qwYV6Y9wWmWxBbsfWC7y36o0ykCax1f1Fz0Hed/jK+o=;
  b=RrL3UKLNWvJlYR0bDOoRlK9/1ohWs0bGzoOB2YGMENFiPwvRelwsdvIR
   CdWK0EPKw2ZHcuk3H+O0pyMk375KPxWxu4Rq3nYBqgv4qyeJxUzgh/psp
   rYDsze3/LqX/e9PIZnLx3fCr0jSR+nIJT7QsLSuvQSvSmmAKHngCMoX7G
   64l+aNZdjtsHcc46yBg0skQ9y9CbNHZ6ijdPSN4A0aL4xOoM/Pc7xy75k
   d5un6xdIIoITLs0e+ORxCPc35xCcksbnmqp4XmpSHQ/fTR+kuvPID0cUW
   EVPShy6taVWuTm0m3aL9SpDpO41bxPdgHfUO55+N6FgbMB8vWzYQsn4Fc
   w==;
X-CSE-ConnectionGUID: 0fiYHykZR7+phMO1SForbg==
X-CSE-MsgGUID: ueAXHAaqRoqLvSMQNLVg6w==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="51905794"
X-IronPort-AV: E=Sophos;i="6.16,232,1744095600"; 
   d="scan'208";a="51905794"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 20:32:10 -0700
X-CSE-ConnectionGUID: f44BpYftT66e2kfBhObKHA==
X-CSE-MsgGUID: ok9IJvjzQhOA7S4zH8wLkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,232,1744095600"; 
   d="scan'208";a="152865123"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 20:32:10 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 20:32:09 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 12 Jun 2025 20:32:09 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.73)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 20:32:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qVZCzAnTMYuqxQtWDsMdu92xBpyZCc113r9r/hIft4zk5WhySzAjqE5yMs6FbE2R6SG1F+fFZVZujZ15bQS4BowouYHbq2vljLS2IibcIzdoneSTr7DjipMnibdy/uAZDmTemQm3Yyo7JGaDckZLth/svz6z7vWXviK5KqjB5/zABTfgc+STLr0paxTHV3Yzqg56TTAaGG2tNdK0DVmaoLko/4yfDF9feH1/nJDgIRBwSAy+Ld/NbATgPhs05lqa4l0dXxPwrtKyVw0lDbbeJ7qr/RSvLvcEl4728O0YVzvXG1NCl62v8InWD1BTyN4JYL9AXSFLTrBq6b8DzPwWqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vvrt8h27CiuR59l+X0JTnJLCPU+3Vq3ANTC/wEjU8Pg=;
 b=T9QcUKWBUZXA1Gy4Lz2gaasYULcTicNy4pAbj7ebqTMgKpF5nYO6yvk7zCfjYTQiHxd+nw3RE08SWZU5wP6ZCeInHv/0+aIv+40ulpsNCUb/mAzXOuDqnP5qaEPHQe2brcOVnSehxVfNJJh+snI/yaI9kikyXOXSGTJaff5jRRUcoKlF67Pp4vRrwPDiYs0PvQBZSK5nkYEzBDgGuVGHDYNIRKc+NvxMGBznMXbOrTS8RRtbTUQn6l2w9ouXc3NVp6ULO5kpJpd2V7pgAY+TNpiG519z+3Seu0YlINQYkIOz/Z9K72omUUhP9VLfExLp3DYtvkT/UypQzZcRJ4/V4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MW5PR11MB5930.namprd11.prod.outlook.com (2603:10b6:303:1a1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.32; Fri, 13 Jun
 2025 03:32:06 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8835.018; Fri, 13 Jun 2025
 03:32:06 +0000
Date: Fri, 13 Jun 2025 11:29:39 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
CC: Sean Christopherson <seanjc@google.com>, Kai Huang <kai.huang@intel.com>,
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, Kirill Shutemov
	<kirill.shutemov@intel.com>, Fan Du <fan.du@intel.com>, Dave Hansen
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>, Zhiquan Li
	<zhiquan1.li@intel.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"tabba@google.com" <tabba@google.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, Isaku Yamahata <isaku.yamahata@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, Chao P Peng <chao.p.peng@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Vishal Annapurve
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, Jun Miao
	<jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Message-ID: <aEubI/6HkEw/IkUr@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <dc20a7338f615d34966757321a27de10ddcbeae6.camel@intel.com>
 <c19b4f450d8d079131088a045c0821eeb6fcae52.camel@intel.com>
 <aCcIrjw9B2h0YjuV@yzhao56-desk.sh.intel.com>
 <c98cbbd0d2a164df162a3637154cf754130b3a3d.camel@intel.com>
 <aCrsi1k4y8mGdfv7@yzhao56-desk.sh.intel.com>
 <f9a2354f8265efb9ed99beb871e471f92adf133f.camel@intel.com>
 <aCxMtjuvYHk2oWbc@yzhao56-desk.sh.intel.com>
 <119e40ecb68a55bdf210377d98021683b7bda8e3.camel@intel.com>
 <aEmVa0YjUIRKvyNy@google.com>
 <3a7e883a-440f-4bec-a592-ac3af4cb1677@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3a7e883a-440f-4bec-a592-ac3af4cb1677@intel.com>
X-ClientProxiedBy: SI2PR02CA0032.apcprd02.prod.outlook.com
 (2603:1096:4:195::12) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MW5PR11MB5930:EE_
X-MS-Office365-Filtering-Correlation-Id: 77abd13d-6a61-427f-0a08-08ddaa2adf13
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?mbLONMkQA2aLWg3VDQfkQLMrDqMthroit8NrL6sP02oOhUrfVeyriSqqklPP?=
 =?us-ascii?Q?VqXymPhPTjwbsoOOxXW0x05Hj/7ePR3j2RAV/FylO3Z8r7R8houQmEmwuF4P?=
 =?us-ascii?Q?obeHwkZBL5kdIQewKiQPMSogCIyR6xYVH77kRZQ1urPp+RD7aCKqFHdOGQk9?=
 =?us-ascii?Q?EqeH5FmsgEdduaRbXbxEb68aRlidrHsIH06dS7UqP/tLnVEHF41Xebn9qJ24?=
 =?us-ascii?Q?ErwJ3PR6YoA1lPuBCjcWufP1Kpkr0HptNxIekjk0lxcFZlY/Jdz0zuLqRsll?=
 =?us-ascii?Q?WAKLKFexxNcdl7zJFjNWH7kncYYKkfr2jNl+W6jICTqtN2sQ2LEjpIGLDNuR?=
 =?us-ascii?Q?bFRtfGZgYCXtHaOsFcFeNUKifzRUipNWGSC+o+IFslZ+Yb0D0ZMiIfmnKVjZ?=
 =?us-ascii?Q?6avUegVjmby2tdzAM7/Vg7N6d92XNz6kNcABE+R3gcakXo4xq7rQm1+yjAtC?=
 =?us-ascii?Q?oXWqvfmd2JNt9THx4z56KMb7Gfp3sPa94NUV4OIhC4nkq81Te+M1AunzbSuw?=
 =?us-ascii?Q?Ceodd4QT8LF1zlGHTl5AZYc5CSIQBerK16aNKMxzp0PT0EdSF5+0oGxOmoql?=
 =?us-ascii?Q?N15LmN+8ioi2yKwa/fkLupeTFCsNhY+XfyMQ3TaV4gQXv2TNglsOwSPh9up0?=
 =?us-ascii?Q?A9ArAzgF3/c1jepoE6d2azgVfYrapZOSW44uFyQe6Hq03hxu7skCNkNsWRfj?=
 =?us-ascii?Q?AE2k6rt5lurG1BlIjR8EZ6T0b3uxHNdYR4+ZfNgCF/CcZYvONKiZAFK3y/jy?=
 =?us-ascii?Q?HiJOchQ+PdVhYJQCZfFPw7OZ6QYBGVmVxWR55vyLctx5WC1ImFOyx/ZH8alF?=
 =?us-ascii?Q?6pBfV2NFpk1lg2svkavNExRgtWeOTl1syenO2hNbev8sXmogJPaZpBJ+v7zN?=
 =?us-ascii?Q?Vb7JjHtxJDvU9C8Gp/xJeyzK80+WAT3A7Z5KNhJnQv34jz0a449gjLr4EraK?=
 =?us-ascii?Q?D9tfACD9yKujYETkaHiCbOCVqJu4SChtegjg1fjL+80h89ZHrayMpz0lGIoE?=
 =?us-ascii?Q?wxKqZ0G+IZUMg8a/qiLS/14V81g5OQiSIjY2iwmj8hy+uWm+gpxD1ST1b+dc?=
 =?us-ascii?Q?6od+xW2yDiomKO3on2Nx3gjyBDuA9zJJnpxNDVmQ4fPTsxN+rTw8FeVEfZbH?=
 =?us-ascii?Q?ii+AtCikq1YXZnVfl05/fN+irFCTDvlvhqbPLzgm5MxgPdEGFUDouVNYHP9I?=
 =?us-ascii?Q?9hBKS25dxJB6juWcdby3U6NxZ5PV97xh4JRipqAj1UH4ybFk9taCwwssKoO/?=
 =?us-ascii?Q?jhZujYy6JcgyKYXxHYutc3o6wQ0nqUnRZogJSe+SGaKY0CzYrW7toZg6FqLu?=
 =?us-ascii?Q?fUaLTLcr9/3OfQZfcu93TOQyuUgcTJ7jYUcwnMamLwalRCXvMP9JsbAgtSWn?=
 =?us-ascii?Q?o/i04yKWgPqulIV3bhS1cRMCDrZ4d0jBFemiWjXm1e2TfHtOCYaeZ/a2e+8/?=
 =?us-ascii?Q?daGbBBWA0xI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hZtOhxB0nltPjLbrXLmEpcayMPinEyFWAyCcbgug+83OsAd3lKaPG/BHjwsa?=
 =?us-ascii?Q?oZ9Gp2EfFNf5e/og4+XxYH4H0JLVdaQ3feU1fw9RCtyw8FtkcLk9k73+Hglz?=
 =?us-ascii?Q?JbJnUz5OdorOmocZUwvYcBCUlT6U2wMLqc/6I525uK8BtW1F8dLHiR+s2zar?=
 =?us-ascii?Q?h2YyZQZiPY1y3WnvQGx9pODpG6+NVScbcVHDfy5rNqUKje3BGkv6iwKNmlgu?=
 =?us-ascii?Q?g6JtwRPfLBv5Pv9rSM4skxz49e7VjVlEV/6oB3RTbrblMC+il32BKKm2uDYI?=
 =?us-ascii?Q?IkbJy1pIF/8ERi9SfLSPZZ35bYvK1wTq/LOZmi7+CpVbauLMc0/aH55u7U26?=
 =?us-ascii?Q?10UsEj1nsPsMM36IUzur0WprqYmQXCuO1bjGNPO4nwxfe2FYZoPBVWm25Sx7?=
 =?us-ascii?Q?Ia8c9jU8rROBnWH09cZsMHXO4yetC5p0HJCV4CEaYhLRgiHXWMB91yX9W18c?=
 =?us-ascii?Q?sI15jgyLX2ZQVvLgv9Ytl/yNf9LZclp8kkaGUX4X3hgRTak7o3e2e4UhFvnj?=
 =?us-ascii?Q?B/HM7fBNsWQTKaDnZJ+5DL/Ce+HG1IsXmcO/9kes/+j2C4O1w0dvIWHMh6f0?=
 =?us-ascii?Q?YPthZeyg6BPWU/CjpAHAnTwt9rUF7ohzF+Su3yDUcwIr1CgYIRwxzbiqxg8A?=
 =?us-ascii?Q?Xe0rhayCKONU94bT6g9NyZnScdrG1AimVJF/swCjcofoTxgfzfiAcq4uLfTL?=
 =?us-ascii?Q?QUZIL9sxPdB3SRCZ0okNyvOXExFO+Ofo01Gg7FGBzrRQZe8rJVNemLUbt/Ny?=
 =?us-ascii?Q?mN9XvB3eJ7l5rRC7K6RjPT6aJuDt67uBF6GsnWl3jmB+7cBGNQlUZzAwVTkr?=
 =?us-ascii?Q?DEjHuEiIR4yh0sCj9BxspFs8JpC/ipNdgdt4QkXNP8pQH+vLp7U+cT3Iyl98?=
 =?us-ascii?Q?BpDXxikvmK+qA25E84sRPsyrqviTgI/7nX8xRVj4zSxEHDYtF7RZ+WMHzg5R?=
 =?us-ascii?Q?ssN2Q2f4KomS1zcwpjOvuDBX35hfXySAQH/Nc0QyDogGf26D9DVDRUJlTw9E?=
 =?us-ascii?Q?tLp3xLC4EmAhnAi8QlprUVpTXP7rzs62loXjGQHXlKUwU44pf2fpBE8tkjdg?=
 =?us-ascii?Q?6XoJyb1/jzp5WPkLm8BnpCroe2ZvHSPU2xJ3ZvGP7WB5KrqZc/2tLNMQ6ZU+?=
 =?us-ascii?Q?CoSzipsS4txigDsJHiKVCQkBYGvjDrPdUSY/DdlLW+Rdtn34Th0xXdLOiDKl?=
 =?us-ascii?Q?MYih0PoTHPrXLU+bw90WZfdeUwfLCfQw7cA7AKuZAuy7qn8ZtyD5GTsVF8Uo?=
 =?us-ascii?Q?FNt3NAeb9xA3d+0+tMJSkvoIQk3U/VICw1IQc7EH0eLLfvNqdknXOOKZwaA0?=
 =?us-ascii?Q?B6QCpKxNJIVVHJ0VXHSbWUZbRpnlLbFQoZuPhYtFx/KtY4tfmKXezRtsnVHt?=
 =?us-ascii?Q?1AEEWyyDzKOe/HaXFoTd3a/xzG/lFA3YukmZRYfWfBO9d8Z1JUTQ8fQxaIld?=
 =?us-ascii?Q?Xd/tWFBOLZxEVsrxstFyn0XCE8ESeDocQBj/DuTeVt8VeMagXBnNMK778iqx?=
 =?us-ascii?Q?HU1SFACOtahlk/Rzru9lHT1OderaoIpDw/pMWA4MN1lPTOnTCr8NIMLL/5S5?=
 =?us-ascii?Q?+m87QR2noWQEJ7bbkQ5DXIJ+139SWmFYUedSqHFALn0K4SKqx2/g3hEFL6XW?=
 =?us-ascii?Q?0w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 77abd13d-6a61-427f-0a08-08ddaa2adf13
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 03:32:06.5484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +wRwEUO82q3vpsA5YSZ/hvxMYmz59ORC89A8xOXmUBe2qC96zKOzUs7YrOpBZ67dgYSz7xkeQGf8pH/raIFiiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5930
X-OriginatorOrg: intel.com

On Fri, Jun 13, 2025 at 10:41:21AM +0800, Xiaoyao Li wrote:
> On 6/11/2025 10:42 PM, Sean Christopherson wrote:
> > On Tue, May 20, 2025, Kai Huang wrote:
> > > On Tue, 2025-05-20 at 17:34 +0800, Zhao, Yan Y wrote:
> > > > On Tue, May 20, 2025 at 12:53:33AM +0800, Edgecombe, Rick P wrote:
> > > > > On Mon, 2025-05-19 at 16:32 +0800, Yan Zhao wrote:
> > > > > > > On the opposite, if other non-Linux TDs don't follow 1G->2M->4K
> > > > > > > accept order, e.g., they always accept 4K, there could be *endless
> > > > > > > EPT violation* if I understand your words correctly.
> > > > > > > 
> > > > > > > Isn't this yet-another reason we should choose to return PG_LEVEL_4K
> > > > > > > instead of 2M if no accept level is provided in the fault?
> > > > > > As I said, returning PG_LEVEL_4K would disallow huge pages for non-Linux TDs.
> > > > > > TD's accept operations at size > 4KB will get TDACCEPT_SIZE_MISMATCH.
> > > > > 
> > > > > TDX_PAGE_SIZE_MISMATCH is a valid error code that the guest should handle. The
> > > > > docs say the VMM needs to demote *if* the mapping is large and the accept size
> > > > > is small.
> > 
> > No thanks, fix the spec and the TDX Module.  Punting an error to the VMM is
> > inconsistent, convoluted, and inefficient.
> > 
> > Per "Table 8.2: TDG.MEM.PAGE.ACCEPT SEPT Walk Cases":
> > 
> >    S-EPT state         ACCEPT vs. Mapping Size         Behavior
> >    Leaf SEPT_PRESENT   Smaller                         TDACCEPT_SIZE_MISMATCH
> >    Leaf !SEPT_PRESENT  Smaller                         EPT Violation <=========================|
> >    Leaf DONT_CARE      Same                            Success                                 | => THESE TWO SHOULD MATCH!!!
> >    !Leaf SEPT_FREE     Larger                          EPT Violation, BECAUSE THERE'S NO PAGE  |
> >    !Leaf SEPT_FREE     Larger                          TDACCEPT_SIZE_MISMATCH <================|
> > 
> > 
> > If ACCEPT is "too small", an EPT violation occurs.  But if ACCEPT is "too big",
> > a TDACCEPT_SIZE_MISMATCH error occurs.  That's asinine.
> > 
> > The only reason that comes to mind for punting the "too small" case to the VMM
> > is to try and keep the guest alive if the VMM is mapping more memory than has
> > been enumerated to the guest.  E.g. if the guest suspects the VMM is malicious
> > or buggy.  IMO, that's a terrible reason to push this much complexity into the
> > host.  It also risks godawful boot times, e.g. if the guest kernel is buggy and
> > accepts everything at 4KiB granularity.
> > 
> > The TDX Module should return TDACCEPT_SIZE_MISMATCH and force the guest to take
> > action, not force the hypervisor to limp along in a degraded state.  If the guest
> > doesn't want to ACCEPT at a larger granularity, e.g. because it doesn't think the
> > entire 2MiB/1GiB region is available, then the guest can either log a warning and
> > "poison" the page(s), or terminate and refuse to boot.
> > 
> > If for some reason the guest _can't_ ACCEPT at larger granularity, i.e. if the
> > guest _knows_ that 2MiB or 1GiB is available/usable but refuses to ACCEPT at the
> > appropriate granularity, then IMO that's firmly a guest bug.
> 
> It might just be guest doesn't want to accept a larger level instead of
> can't. Use case see below.
> 
> > If there's a *legitimate* use case where the guest wants to ACCEPT a subset of
> > memory, then there should be an explicit TDCALL to request that the unwanted
> > regions of memory be unmapped.  Smushing everything into implicit behavior has
> > obvioulsy created a giant mess.
> 
> Isn't the ACCEPT with a specific level explicit? Note that ACCEPT is not
> only for the case that VMM has already mapped page and guest only needs to
> accept it to make it available, it also works for the case that guest
> requests VMM to map the page for a gpa (at specific level) then guest
> accepts it.
> 
> Even for the former case, it is understandable for behaving differently for
> the "too small" and "too big" case. If the requested accept level is "too
> small", VMM can handle it by demoting the page to satisfy guest. But when
> the level is "too big", usually the VMM cannot map the page at a higher
> level so that ept violation cannot help. I admit that it leads to the
> requirement that VMM should always try to map the page at the highest
> available level, if the EPT violation is not caused by ACCEPT which contains
> a desired mapping level.
> 
> As for the scenario, the one I can think of is, guest is trying to convert a
> 4K sized page between private and shared constantly, for testing purpose.
> Guest knows that if accepting the gpa at higher level, it takes more time.
> And when convert it to shared, it triggers DEMOTE and more time. So for
> better performance, guest just calls ACCEPT with 4KB page. However, VMM
Hmm, ACCEPT at 4KB level at the first time triggers DEMOTE already.
So, I don't see how ACCEPT at 4KB helps performance.

Support VMM has mapped a page at 4MB,

         Scenario 1                           Effort
  (1) Guest ACCEPT at 2MB                   ACCEPT 2MB         
  (2) converts a 4KB page to shared         DEMOTE
  (3) convert it back to private            ACCEPT 4KB


         Scenario 2                           Effort
  (1) Guest ACCEPT at 4MB                   DEMOTE, ACCEPT 4MB         
  (2) converts a 4KB page to shared
  (3) convert it back to private            ACCEPT 4KB


In step (3) of "Scenario 1", VMM will not map the page at 2MB according to the
current implementation because PROMOTION requires uniform ACCEPT status across
all 512 4KB pages to be succeed.

> returns PAGE_SIZE_MATCH and enforces guest to accept a bigger size. what a
> stupid VMM.
I agree with Sean that if guest doesn't want to accept at a bigger size for
certain reasons (e.g. it thinks it's unsafe or consider it as an attack),
invoking an explicit TDVMCALL may be a better approach.

> Anyway, I'm just expressing how I understand the current design and I think
> it's reasonable. And I don't object the idea to return ACCEPT_SIZE_MISMATCH
> for "too small" case, but it's needs to be guest opt-in, i.e., let guest
> itself chooses the behavior.

