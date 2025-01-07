Return-Path: <kvm+bounces-34664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F107BA0382E
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 07:54:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D8E21164B30
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 06:54:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAF67199FAF;
	Tue,  7 Jan 2025 06:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PIoIy5gJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7924A4879B;
	Tue,  7 Jan 2025 06:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736232861; cv=fail; b=nHOPdmj/lvPKO2Y0NcJ/zLoYIo894BcfdTURHgmGrIZn/VbwZLHYP5QOS5HIRmHmrkZRisZFygth/oUspgoP10TaeXuXPOzP63IzQeLv59j9MPok4cZ+2+seQFp2G9tV16kUVyHMHrdwnl/vlDXNQvkpTXGEXjaghlWfWp6NCuY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736232861; c=relaxed/simple;
	bh=5azw5fgOLz9kzB1t8/6zn7ph0J/JEyT+Sg1Zecwz21g=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=am26wByVgDV92SHTQiKKiH+OqywjlN3XWFWgVLIId9L4m/R6TWNJUXPvrU7JeT7MmFAWfxQIy7AyjtMH3b6zPzkwZH3Rr0KvCJwBWZQmRi+GyHXW1HLmNfbUMTKyUfaOoMA9izCd1Evg4yfm+ARBRzKXDJe3BWV7UtZ5tvsjch8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PIoIy5gJ; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736232859; x=1767768859;
  h=date:from:to:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=5azw5fgOLz9kzB1t8/6zn7ph0J/JEyT+Sg1Zecwz21g=;
  b=PIoIy5gJvFUZDmbmlsTj4AkP1qmZa2GqAMpxn+99BDeCQgb9zc/G3Cx/
   QjLapb1M9sBa90/b1fKwXPPuy74Psih1EgOYL3c3rDu2kxXAlwtUu5pmY
   6h8cfamCKE9TLR9356MOws217cA4cW+omOue0aUGsXQCvuhhV/7rPsNcW
   YFxDsfWBpHoI9eqeYh5oimDN8YtSfc1Xy0twFTlIOi+ramo72KTX+PsNe
   xR8jX7gIBL6/bAxXxVq5Jqy5yHTeQev/5GoBN2fjd/HPupbfbEXzyOEJz
   cQ0b7M44yLZgL5oeWax956g1jfaSPHMPknGr0UNiwwRqaAFXHmz7bwDFp
   g==;
X-CSE-ConnectionGUID: 3+LnDlmvTD6cxNQQsrptdw==
X-CSE-MsgGUID: QCGe8UvjTxiesnZyP8fL9g==
X-IronPort-AV: E=McAfee;i="6700,10204,11307"; a="36514542"
X-IronPort-AV: E=Sophos;i="6.12,294,1728975600"; 
   d="scan'208";a="36514542"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2025 22:54:18 -0800
X-CSE-ConnectionGUID: kIga4dF3QSuETeCv1pUqnw==
X-CSE-MsgGUID: s3ajMPd6SHec+LVeZ348Kg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,294,1728975600"; 
   d="scan'208";a="107548979"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Jan 2025 22:54:18 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 6 Jan 2025 22:54:17 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 6 Jan 2025 22:54:17 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 6 Jan 2025 22:54:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AKBmxCEOfsrTn9/55FrTJmttH4eYV2uu/u16d4PhNvDb5Sc1x1Y407q1QnoM27mfASGEdfXHIzTvk+6/Q7Pkgui3+kDiRFTvmEaVo4PRvTxzn+GwFr9rrkvjQidTCQdPu1owh2OB22lhcS2pQtGQ7oybkO5RO27SYcOh7w3rHE+10abNqlTyKV46OfS1ingYSJeDJeeOvBMBPJuc9mtaYwzRTg1f743bNQYXKiHjhd2i5Yzt1wPUJEcfdj2c+bMIhJdckGyLNIhfgdSdcKUzlwCNDEB0YewdOXcEsOuTR7PPauNttp6nIz/tjvw2Mb9tPOuXKW6lmnxAOw//5vdoog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HXBm2kHw+7yp5cyU0CLuCKFVBSQOpXGm/3fSMt4eVBM=;
 b=U58L9PODaYz7WN8RYZoKLdGcN8DOpkefB/isk1hUQmLnFdu9ZuUwJj+I+qx9fRI0Kd9sQs6hBONU4J4YZyc3dy2ucMJabCl6wWzByb+9QMnC/F4C38GxPmPSb97XAs0wSXWPMYfUfClRQIN6FPoov6cmZ8owtaUBW3yroLcnHQpn9zg61y89bMHMQGT9Vg3WZuMC5+W2EvIOjfI541MP93YmOtNqfvD7ssml71/CSD5UIAmrnJvMEA6RzvwsG7YpbylmOpQjaLWW12mQWeF+7Nf9ZTPU9szTX6Zw6v29AosRxsRAwS50aFgDinEoDt8x4rQTFcpJ4h2OcnMln84eHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB5964.namprd11.prod.outlook.com (2603:10b6:208:373::17)
 by MW3PR11MB4715.namprd11.prod.outlook.com (2603:10b6:303:57::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.18; Tue, 7 Jan
 2025 06:53:51 +0000
Received: from MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::7a0e:21e8:dce9:dbee]) by MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::7a0e:21e8:dce9:dbee%6]) with mapi id 15.20.8314.018; Tue, 7 Jan 2025
 06:53:51 +0000
Date: Tue, 7 Jan 2025 14:52:56 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>, "Huang,
 Kai" <kai.huang@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 10/13] x86/virt/tdx: Add SEAMCALL wrappers to remove a TD
 private page
Message-ID: <Z3zPSPrFtxM7l5cD@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250101074959.412696-1-pbonzini@redhat.com>
 <20250101074959.412696-11-pbonzini@redhat.com>
 <f35eff4bf646adad3463b655382e249007a3ff7c.camel@intel.com>
 <Z3zM//APB8Md0G9C@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z3zM//APB8Md0G9C@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: SG2PR06CA0240.apcprd06.prod.outlook.com
 (2603:1096:4:ac::24) To MN0PR11MB5964.namprd11.prod.outlook.com
 (2603:10b6:208:373::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB5964:EE_|MW3PR11MB4715:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fa75caf-d291-4ad4-bdc0-08dd2ee80b89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?qEkN7gMEcGlucSeBCDGy1moXEbhAnhe8zlVYh3GNaegCamOdfl0ziV8MECMd?=
 =?us-ascii?Q?nU4ObijZXCZU1nUMsfNDDcCcOj5frfjUWI1JWsQF11YuvOP4AsmKFRV9sfBw?=
 =?us-ascii?Q?QJ31rYgs//1Epz2gNvFval8iL3x9zCiv1ZkCV8Z7eSAnxmgtI8FyzAvfvqVA?=
 =?us-ascii?Q?ss0a2ai8qPONOBgA3OvbkmuqGzBAoC9DiQ/reQsKZSY6nkGdOyh2TGzgIWp0?=
 =?us-ascii?Q?Wx+qmi4/IhbDMOt3/OwyZJpGcfXKBjzOX3HvEd7TXLjGCkyGzlZgkBRKzaQ9?=
 =?us-ascii?Q?o4lBDPEOX45oKvIwqizje8WPmOD1HY05odFHOfhh/TjUyHQAdXWfa7nAl+Pp?=
 =?us-ascii?Q?Bn/9l9Q1ccweiT4RVqWrEAu7WEQrSm6/o2Z06kbQc9KQKTpUw/gTldyUntC7?=
 =?us-ascii?Q?6SETnzQAn+mU6uwRSD9uzFSAghR8ujncqCaP5rKMBmKa3rZrtJMGl1MLeUD5?=
 =?us-ascii?Q?pzWKzowIRWj3bF6fTo5XS7Lbjqyhnf+grWO48X5Ct4UBQE439EfJ3YOt870V?=
 =?us-ascii?Q?KTSoENfONYGi/8bDtCUKv2Cm6ltMhlSE2p5+qxd4LK2JJgiMHqTRqQSHNw34?=
 =?us-ascii?Q?jiUz4XgXBsDp+e3jPGcXovExD/jPnZStZnP3OtL9o3raVE2GDANm7ANqHA3L?=
 =?us-ascii?Q?sDPQXDKmJDUH8aSXtEaM+F2cXS183EfBU7IpD9JoWgdZovEDGHulfPk7kJWe?=
 =?us-ascii?Q?pekmRKs5sgRUEb0No8XhCEH2k8vJCO/FTDd6hpirent2w6OTeqQess5FB3xe?=
 =?us-ascii?Q?7tyAc5QclCh4zDaNJgF1kY4d0fFW9mGdq5GCrpsFFSnAwlk5G9e9XztJ7inX?=
 =?us-ascii?Q?AIx6PU1N5VdTiydzfRKjpQy0BxVVJ9et1iyLWQI+VAXMjYuXQD0XD91eVJ2C?=
 =?us-ascii?Q?/V1Y6aQgHZBk0n9Z1CmlRLnXG1JbWrEC9Z7JzmShWp/wh8c2Y+Wt0c4s+8UR?=
 =?us-ascii?Q?e1ZT8jA6f5KW7H/F+1CRWjDPgVkikSsOVI+kteRY60vUQgr6aWT1E270QOaG?=
 =?us-ascii?Q?2tjnjb0o78JiusgGB23THW2dgB7WpBX7runsnbUqa3ePM6ZO81UEqJsKyjXy?=
 =?us-ascii?Q?VF3LrOh5veNlAkeFGjix2ETJLNpw7aQZ8abxxidv6sbTlnf/cEGKStgGmw60?=
 =?us-ascii?Q?6AJshIfWS+mNDWb6s2MfcEAKC2FmrVx6f642MexS/TR0bIobCPfNBaX45rBS?=
 =?us-ascii?Q?ysvnvnLH7Lde5SHvs9qDKbe9/wSeLWuGgHPiIw6glKJ1JQY7klNAV7ltD8Pw?=
 =?us-ascii?Q?Aj7l3+Uwyq3nYLzuplxSMk58t0s01mHbHnq5U8CDckkoFL9OnUyNc7DWptEk?=
 =?us-ascii?Q?RjMQEIbE8c1KBlmAo1s7PZfldiukZYStNDTUYYv2KEUFCGE2BRRfenFzlQhR?=
 =?us-ascii?Q?bNdYc3tI2BwP6khhjaqv3l7RGziWopXy07EMBbD2ZfcnOR1FjIpckTHeHkZ8?=
 =?us-ascii?Q?xiPEj4flR+9cCFYp6Lz8hUQ1tSUnh/DB?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5964.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hWMWpDIhHMzebAStFFmymu9tJGXuH7j7bu60Ebb0eU7kMtQeMkaMhgLM8yiH?=
 =?us-ascii?Q?l3gWLfyZQLzD7C5vJMXU0/zflbOh5YjWsCg/Wig4FZMtZSDOiaku2Es5awu1?=
 =?us-ascii?Q?CI62fCQOER9WFYzwhBNlZXJv9CaSV696etxISDOxbjWBtGJS9TQBkwqV4q+E?=
 =?us-ascii?Q?pH2y5MaEJmVPyNsultzTh0pc23hwQRWlRR+cXpOmY6si62Epnh4kntmAL+Xy?=
 =?us-ascii?Q?y1AuKgUs16U4wiOs3WPmVTV9Vf5EH4eil1gYV/AdHhmM2VuFIffEVDijQfOA?=
 =?us-ascii?Q?qTScRGQzx9w1DOT5TG5olvVCmRZRpUMvcutbQZ/2yc/fUzhcy18PGRMOgwx7?=
 =?us-ascii?Q?+732FFt5x8RsUKl+APF4iX70GgNDy216kL9H/jrMIsGTzR0mH/FeE4jZ1w6Z?=
 =?us-ascii?Q?P4aLX2Fz+eW3FyA2MvL9uAIr8gv3soF4BLdLWPlv4+iZfMzNZMZATkTPSCZm?=
 =?us-ascii?Q?Hy+Ax3++wpeJwuZAGghz2fwuOETIJO1quVVUvq9oSX0DVerKdWRM4jImIHqy?=
 =?us-ascii?Q?N6ypQQPS9NPwcOqTHe8jH67rZe6qvBijR6YoI4UHajWpO2N3ex3zEDwQPpDg?=
 =?us-ascii?Q?cn5RXMtnis+tn2OjCqDT9tlCecjuOel3VQvxwG8yX30Kooc6JlAWeLGEWqGz?=
 =?us-ascii?Q?3HqtfVWWrTwIz0vnXL1H5Lj3i+dgh2vC0/GqpcYHdzuHs/UgKr3KZSc8mJxQ?=
 =?us-ascii?Q?Z1QTXAr/dbrpkO007HPI6EiZvfzXRh6fGLWxMJvG3NQwxSoayqdVi6rfSH5V?=
 =?us-ascii?Q?mcr9jQpzSBU1WljfZZQQPFEzHm85MISlkECfNeac8SZNtRsuCRwk1YAVrkOs?=
 =?us-ascii?Q?TyoJXC7WADrI5pctu6deJgRNvAoAv3CsmvGnPNqwxXADXBPmhlPSXf4YqhK9?=
 =?us-ascii?Q?mnD6C2Uey5rfipdK6iAt1dSihOq6oZYCf4cQ7tHxnBBZf7FdZPBznQII5np5?=
 =?us-ascii?Q?ZjokwGA4OrA8rXkIZXFWkGfCDBzkQ8JW+kDvYlYtfjqgzOggPGxH4xtcT6L8?=
 =?us-ascii?Q?gC566aTNT2vtOC2kiIyqNg7ZRgQ2mhiTcYsUtCVX7HQ4N6KzesRu8Z21JdEY?=
 =?us-ascii?Q?UypvjU+yzGhNYWR/0VNJR1dAsxdWvxt7fpCfnLA83VpQ03QnowQOCL1VX9cC?=
 =?us-ascii?Q?1th6Aw9fHdsO43csomEaQEVBmTLfabc+HAbMuD7Lee1x6FTxB6ZHiWsYqxhb?=
 =?us-ascii?Q?kPXYiejiEYjeTcVmIjZvhEAOxSgy/r97yTgqeYKcGE+d/+kE4iYH/3goIRKK?=
 =?us-ascii?Q?HAtCoUVlKTEL7k+OWsPR1W0MrBkXtmkzhea7veo5EgC6jb/e/IhmI5b2QBnH?=
 =?us-ascii?Q?eU9+JdeIikj3QwdGKGNODuJWcJaxF5hR/9tqDcIG+BCsQj2aHAX6TQYyuvNR?=
 =?us-ascii?Q?ht+goeAf3Tn0rJuA/S3MQWDuOAu+7sXhz2nIJ7Xo47mnOlO5nE1UfmZheODO?=
 =?us-ascii?Q?uK/1U7uH+d6sz0QGBOWanFyYBzgMgNuA6T3c2ru+F+6J7733PPcVme7LRWm/?=
 =?us-ascii?Q?pPrGPQqloHlLguoWDmYUMSeS/mvDbTMFoIP3XyeiQaWOYkVnRqOklEXs7R0Y?=
 =?us-ascii?Q?QypZNCyfWqBTljSmRRfAN3nibKihTe2ID8zQuhv/4nGPKrJyi7UF/9Gw8Yh9?=
 =?us-ascii?Q?Mg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fa75caf-d291-4ad4-bdc0-08dd2ee80b89
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5964.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 06:53:51.8415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fHrPnaVfBfFYMUp3bqljcWjPWEi4vgd7B6b178XhH3ojqRmzz77ltK9bS3J5BvH7IEb7y7ElBiy4PfqpntOkUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4715
X-OriginatorOrg: intel.com

On Tue, Jan 07, 2025 at 02:43:11PM +0800, Yan Zhao wrote:
...  
> +u64 tdh_phymem_page_wbinvd_hkid(struct page *page, u16 hkid)
> +{
> +       struct tdx_module_args args = {};
> +
> +       args.rcx = page_to_phys(page) | ((hpa_t)hkid << boot_cpu_data.x86_phys_bits);
> +
> +       return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
> +}
For type of hkid is changed from u64 to u16.

Here's a fixup patch to further have tdh_phymem_page_wbinvd_tdr() in [1] and
the tdh_phymem_page_wbinvd_hkid() in this patch to use the common helper
set_hkid_to_hpa().
[1] https://lore.kernel.org/kvm/20250101074959.412696-11-pbonzini@redhat.com/

commit 41f66e12a400516c6a851f0755f8abbe4dacb39b
Author: Yan Zhao <yan.y.zhao@intel.com>
Date:   Wed Dec 11 18:11:24 2024 +0800

    x86/virt/tdx: Move set_hkid_to_hpa() to x86 common header and use it

    Move set_hkid_to_hpa() from KVM TDX to x86 common header and have
    tdh_phymem_page_wbinvd_tdr() and tdh_phymem_page_wbinvd_hkid() to use it.

    Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 5420d07ee81c..5f3931e62c06 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -144,7 +144,13 @@ struct tdx_vp {
        struct page **tdcx_pages;
 };

+static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
+{
+       return pa | ((hpa_t)hkid << boot_cpu_data.x86_phys_bits);
+}
+
 /* SEAMCALL wrappers for creating/destroying/running TDX guests */
+u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page);
 u64 tdh_vp_enter(u64 tdvpr, struct tdx_module_args *args);
 u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page);
 u64 tdh_mem_page_add(struct tdx_td *td, gfn_t gfn, struct page *private_page,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index c3a84eb4694a..d86bfcbd6873 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -222,11 +222,6 @@ static inline int pg_level_to_tdx_sept_level(enum pg_level level)
  */
 static DEFINE_PER_CPU(struct list_head, associated_tdvcpus);

-static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
-{
-       return pa | ((hpa_t)hkid << boot_cpu_data.x86_phys_bits);
-}
-
 static __always_inline union vmx_exit_reason tdexit_exit_reason(struct kvm_vcpu *vcpu)
 {
        return (union vmx_exit_reason)(u32)(to_tdx(vcpu)->vp_enter_ret);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 6f002e36e421..0d7a0a27bd3e 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1930,7 +1930,7 @@ u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td)
 {
        struct tdx_module_args args = {};

-       args.rcx = tdx_tdr_pa(td) | ((u64)tdx_global_keyid << boot_cpu_data.x86_phys_bits);
+       args.rcx = set_hkid_to_hpa(tdx_tdr_pa(td), tdx_global_keyid);

        return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
 }
@@ -1940,7 +1940,7 @@ u64 tdh_phymem_page_wbinvd_hkid(struct page *page, u16 hkid)
 {
        struct tdx_module_args args = {};

-       args.rcx = page_to_phys(page) | ((hpa_t)hkid << boot_cpu_data.x86_phys_bits);
+       args.rcx = set_hkid_to_hpa(page_to_phys(page), hkid);

        return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
 }

