Return-Path: <kvm+bounces-73323-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GNdCI/PormlRKAIAu9opvQ
	(envelope-from <kvm+bounces-73323-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 16:36:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E5D4C23BCA7
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 16:36:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 50DDB32385AB
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 15:26:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E81E3DA7D8;
	Mon,  9 Mar 2026 15:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RJEOMpeX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B3B3D9054
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 15:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773069922; cv=fail; b=sX2y1GLnLNuqVyLDm+N5vDHTaiiOE42xXEAcpiVCLKQMBuox7BZCcdsuGFpimrMCvZCC23XHP+Oszb3gzqditrkTwxqspXqa7ALT9Zj92FDejdTTqxBG6REE7o58HrjniiOzZLJ44XGbRnJ3AGmvZlexyiFW8oosuSv5JirCaCU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773069922; c=relaxed/simple;
	bh=CWplGHU2tMu6IIF2lo98n7P0M9yTAA5N9kmzjtOTFWI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QrqA0gDEl+rH/ZtfdJj+ovPzG6l59Y/VoOWJfPHIfvqjoCXDwnv4Xe5FmuPppG4mIDzC1eNPsqzNRr3q48fk+hHyOkNkKm+Ow3VcLbtgLhvjbpeGFoz1VZ/owNI/d3gtdct/TzKBX3G/LXghUqL5jpq5KtfSpK/gJLd1YM/WDps=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RJEOMpeX; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773069921; x=1804605921;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=CWplGHU2tMu6IIF2lo98n7P0M9yTAA5N9kmzjtOTFWI=;
  b=RJEOMpeX5fUohwW2H35/w9x/LSgUpFHTVEH9NTIz1hPPBrW1MjLh+I6x
   YFP/kLTSWpMO1HS63SH6r1vwHJ3p9lmi/E8F35zGX7eTXiMr9fGLugcGI
   PN+wzkNd3uxvWEOVblY9YuMVGqUFAEfdcFQuP/maPN4NWb4mbUM2BSHst
   6VO+Ifgd2c9PKzvpmpIUzEoglh1nD83ktWaLIKCnNSBaeNkUhjZXgj9hB
   u7BUe243F141oF8khAUoey4nvidApxFFqOEdExSljgXDD5jb4ELYBe/3D
   CuuE5TX1I1ddn3fp4Lm65BaxGAtep1/Sl3ab+0VWncgjxmOnNXmcgxS/y
   w==;
X-CSE-ConnectionGUID: qaQXEhQrQB2cQNRfeee/Sg==
X-CSE-MsgGUID: XuYy33EyQZW3A34EE2ve8Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11723"; a="91669245"
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="91669245"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2026 08:25:21 -0700
X-CSE-ConnectionGUID: 202uJod/QBGGvNcTimvnhg==
X-CSE-MsgGUID: J3xJqZa/Ty2OI8m57FDvkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="224484984"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2026 08:25:20 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 9 Mar 2026 08:25:19 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 9 Mar 2026 08:25:19 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.42) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 9 Mar 2026 08:25:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gOCRedZHlr/f0+5yAyMBwql933O4FVosA7FfRsvewmg+Wif3ucnP5UUoMi4lbHuyC2NoHOuGNIpdPVxrX3T9fPiZA1qOvs+NmFMqPFhkrDYWeCZxyflhhL5XrpoS70N/FNf2OB3El4aA4Z/t7Lj1iAm7F+Dw7dT/l+ANtgENSRcOhk2e2rm+iLwnkmfQdQZGO539hMXdgh75EgO3al+vai7QqMh7yh9s8CUewfFpUpXgytIiNvht7aoHg4wWqJKMDjFwUhlXoW3k+NhwG6P1KVsCQRu5bVZmQ3fwzce0IWEKpOqFFvVZAHuH6e7vNBAC4UwEzvwDmIlCz2n/aEGjCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ptLbHFZPErk2BKYs2EUOB4+DGSMR1tyMnHDVaqRuGBU=;
 b=bJJ9Z8LO+8ErMqdkBKN4/RNNHWDkaiE8AiF59eU2gTGGcv+RfXPT2IBwX8fk+RMx0Dwb0oQV+/7nC9ZyKdO8RApeMIEZ9HKVwOEkHbLT6zvPBhL2zowBCVQRRs78giWyIJoRfTDBr/rV0jYdwZHbaA8iF3fAOPwii33WtvLPTumOjWMgvWOxLOLGqyCXuNFTlx3zh2pxUfnUaRh/SQw0OH3+ZXFUO2ilErPsp4nnlYoj9dJUq8l9GWuID0DXE49OEXYT/Zmgx0HC4qxeYg98N7aITJoiuodt55f2TZap/iLu2ecO4nlYJdaA9UdPMjsf8a3wfh07eOdD3HDLHxc9Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB6135.namprd11.prod.outlook.com (2603:10b6:208:3c9::9)
 by IA4PR11MB9060.namprd11.prod.outlook.com (2603:10b6:208:56d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Mon, 9 Mar
 2026 15:25:16 +0000
Received: from MN0PR11MB6135.namprd11.prod.outlook.com
 ([fe80::efd5:501b:c890:26b0]) by MN0PR11MB6135.namprd11.prod.outlook.com
 ([fe80::efd5:501b:c890:26b0%6]) with mapi id 15.20.9700.009; Mon, 9 Mar 2026
 15:25:16 +0000
From: =?UTF-8?q?Pi=C3=B3rkowski=2C=20Piotr?= <piotr.piorkowski@intel.com>
To: <intel-xe@lists.freedesktop.org>, <kvm@vger.kernel.org>
CC: =?UTF-8?q?Piotr=20Pi=C3=B3rkowski?= <piotr.piorkowski@intel.com>,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>
Subject: [PATCH v2 2/2] vfio/xe: Notify PF about VF FLR in reset_prepare
Date: Mon, 9 Mar 2026 16:24:49 +0100
Message-ID: <20260309152449.910636-3-piotr.piorkowski@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260309152449.910636-1-piotr.piorkowski@intel.com>
References: <20260309152449.910636-1-piotr.piorkowski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL2P290CA0001.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::19) To MN0PR11MB6135.namprd11.prod.outlook.com
 (2603:10b6:208:3c9::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB6135:EE_|IA4PR11MB9060:EE_
X-MS-Office365-Filtering-Correlation-Id: 58635ee4-32fb-4692-0d30-08de7df010d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: uemQqZbR9UWX954aL0HocOVhZPZjxJPy45rVvLppz3INv+La0+iWeMxZo+lHLxm+7aqPm5G39Cd2PFzK5ArAOVZsKF11PXijhfh+LSMWrt5VGH7YD6zBlxp2sGmtOJdFTjUU8IEdIxgKcQqc6G/Ew75ZQ7CZt6ivgwmVYBKixQ7vLQAHcGw5Pv14wsNzRf8eYT0EEgt++db7N2AxaMKgosAhX/mI4OZbXEuo42N50aSovvT9mYIp4F2JnEJ/nozZ8thrs0ewDtLJiL7Ma7gcnimKgir1r99WGwZiDVCRCH1M8AuPCIQpoDeB+xx019gjSmd+BtYV9sTdmNi0rcDhFO0v/GYbq0JhzwhOzrOOCN2MIL6ZNKQPOEXhv68jjWDA0MERI5qEQ/IYJKLZ2eNsQQNf4yquedDGlmjPqtmkJgFSZxMctpaHhqPVpDLdlyf0326M0IfTl0Sv3LGs2AaOAaMRdxMHOYF07jJTHko9KJSw3etcg31WRw+c0/x2cGg5VaF9m/wiromNVsqllfRQnJrfS9jNHOX1mP1sZ8r2RU+a0T3LzYQ4YlpZKrc97WKwp1GkSSuxyxNqRIsiSr88DhPv+loydjZThTj1+81qcpVTcv86tD3O+6heHZ4YpMjmedq3NtCGWqTES9Nm//6levqzBJV7ILXakFo3qaMpJ67TxO9530Jt0o9Pcjbqx7NFiPeZ5HFeVzkADOCAF0UqjhP9OQ3bCqJCbzH71j4hOFg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6135.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UUJkaG9BYUIvVjN3N1F4U3NjZW5PNkVNWE81OG1xTkpFQzlFS2lEY09OMmRU?=
 =?utf-8?B?RjJpSHVpcmg4TzQ5TUVzWi9FeUFkUVhnZnZJSnowVmFOaFVXQnkwdG82Kzd2?=
 =?utf-8?B?SFdXMFMxOGxiQlJPV1lwaWZFWTdyd2VHL2FxYStPWnRkcjcrcWI2K2RuV2JH?=
 =?utf-8?B?TVlqTzNCK2pod21vVGxDcHlLYUZkZDd4QnBQTlZlSmUyb3FXVjZtWXI3NDFq?=
 =?utf-8?B?S2JLNkFqcUlWVVkzS2ZVRXp3VDh5YzBwanU5ZWt2eHVLcUJQNThRSzEvakZm?=
 =?utf-8?B?SnhZNlQ4UkhOL056Zk50K05hU0syRXZMcVhReHdiSnJJNHdzenh5b0U5WTBB?=
 =?utf-8?B?N1Nnd2JhTWhTVGJEZ1NvTmcvU2hSSW1OdUtJMUZhdEdHcFErK2RsOXIvd2FU?=
 =?utf-8?B?dFJrL3BTNXU4a3ZmUUhVSEFCOUpYV1FkWnVraTNoTThQL2pGN3EwSnVlRlhx?=
 =?utf-8?B?MlJkRjhOWWFXcnUwN3p4cGViTmZPTEZiT1F3Ti8va2FqNVoyUmVKME5pekJR?=
 =?utf-8?B?Nlh4TGs2U2lVRTg3OU5ITDhVcHhGTUVTTEpSTXBKY3lGVXpBb0tVNEdiT1hB?=
 =?utf-8?B?WEcyWm1PUGdCUXJ0TnB5TU8vZCtUT1RhMjR3WkpydXpTR085a1JrTEh0dVF3?=
 =?utf-8?B?U25HTHlrWitxYVFsNDAwZGVYRGFqQisrZmdyL1hYUTJKTzdzbUdmcTdDMno1?=
 =?utf-8?B?clllSHhnak1URExGU3dwMXZVVjFUakpmZUV0YXMxY3RkajIrU2VLVzd4Ky92?=
 =?utf-8?B?UEhUUDZhT1NuT2owRjFmYy9QOHoyRHJGWVJSL3hJN3Y2T2FVU2d5c2Nxa2xU?=
 =?utf-8?B?K3Q0NmxESWx1dzQxTEVraVR5RFdSSGJzVUlSRFRmV2ZEOG1HR3R5aFZrZkUv?=
 =?utf-8?B?cmdkWnorek05cFlHMzV4dWRwejZhcG81NzFWODdqUWRKenBPVTVnWEV5cWFw?=
 =?utf-8?B?NzRiVW1KQ2wzWWVCR2V2Y2dyVllVMVh4Yk84TVdxa0U3V094K2FiaFVkSlFO?=
 =?utf-8?B?Vk1EKzFlSGJ5ZENGcjNBcjkvYmlla3M4NHc3UGtyVHpESzNBcEtlVndWZWpN?=
 =?utf-8?B?QVNKajJPcEF1M216ajVCRkRta3VRZG90VXRyOFlHdFlqWnFKOVlxb0FNWkY3?=
 =?utf-8?B?Uit2ajBZYXhwN1UwcHJHUVU3ZC94MnJOTFowb2VBcmV1bkExRmhtVGZHd1c3?=
 =?utf-8?B?RlRWNjRiK3JjUmVQTkcwT2VmSTNCWHpXbWxaaDEyWnI2V0hSR3ByTGNCN3N5?=
 =?utf-8?B?UDVTYmZwMWtjZ214ZkZyUDc5dGNBNlowL1UvU1QrbjVXOFRjUktMSFd6aGFm?=
 =?utf-8?B?YzNtQW5sMTFtVjQ3VkVUYTNWVEE4cXY2YmgzNDNWakpDekZNRGVCajBOamsv?=
 =?utf-8?B?NXpuT0N0M0g5dWg5ekppNkQwdWFSb3VpcHVINmdiSTc5cGpyaVhOa1dUamdP?=
 =?utf-8?B?ZUxicXo4YzBXcXVhWXUxR0pLNklpY1FGd3g2V2pjTFNBTmM2NEJiMGpIMzNZ?=
 =?utf-8?B?N3pQempHNHVGWHFFTldyRzgxWi9TYWNzTEVUNHVNSDdLTmdzSzR6SDl5aUZT?=
 =?utf-8?B?NEdoMHRsNTBTSnVJVmZMWEpQTE5Zd1RjMDNpS2lIU3piTVYyVkFIZjQ2Rmdz?=
 =?utf-8?B?NEVGUGN4WTl4OThScU9UY1NNcHhENVViSTNrdEVvSlRnRXQrc1NjZm8zRzJW?=
 =?utf-8?B?MEUzNExyQXVpeWJGYStZT2dkSk43Z1BpMjUvWEkwWWpLbGdMMmhGUm5jYVo5?=
 =?utf-8?B?S0VEc0lrT2JPQk5YRjZySU5uU2k4YjZCTlA5c0x1SWxZa2RYL01lUHk0UWtE?=
 =?utf-8?B?T0U3S3U4MmpJZUxXdzczUVNEb2duUWN2UlFVamJFR3BxbFBzMEN1OVZnNWpW?=
 =?utf-8?B?M21sdEF3OC9QMXAvQXVjUEU1RUZHY0I2L2l6N2NRQVJ4VTlEd25vNERDamdC?=
 =?utf-8?B?ZWNvZlBabGlQakYwcjhLMWNnZVVTR084Tndoc3BNR0h2Z25vWjZDdFB3Tkhn?=
 =?utf-8?B?U1ZabDlkMUVWWjgxTE9KNExOTktRcURyV0VBRWVOWTlITy9BcWtReC9yZ3hq?=
 =?utf-8?B?V1VxZ083ZnBtSlI2MDRWNmtFSW14VEU0TlBSZXl0Q3FuS05COGpIalF4bFpp?=
 =?utf-8?B?alc0MmphTlV5T2Q3S2NXZWJZWkZjLzdaZ2lVZjNxYjVoMktmUHZVZ20rL0My?=
 =?utf-8?B?MVZPRFQyajlTTUIwaStGWGZBcXRVRC9rS1RERWlSOFdsdkhxOHdMVFhLVmJj?=
 =?utf-8?B?MVJYNTEwTEJ6NW9kK0M0SFF0ejBwYXhEZnYybmdJdjFjcWdYcmRCVmFHRUNh?=
 =?utf-8?B?TWFndWU3SGc1L1JuRFpxL2hmR0FSNUs1cU1qL3FjZXB3YXplcldBWmtjdTRC?=
 =?utf-8?Q?B2bcq2XSZrG+zn14=3D?=
X-Exchange-RoutingPolicyChecked: MhpueOiTJr2TpVa7KZEKD0zmfxgqDd4UtQVFMDoAAJvkshI/Y2vwTkR6uRiwcNOIenT5lgbFqpYjDyUaPejJK+L1B6gamW3oByBrozuBBjZmxe28t2DpNL30dtutS12JMynDxBxiWknmhCJah+NTAD+g0rFUM2pPcRY4ry7ERkh1mHEirOlzQJdHBIfngWCpnSNThYGZuEcPNerShJguJN69+zp+vuC3OyTpXQwISqN3HJoheFomkiHPjPscnMkzMnas5s5Fd1uhiK6kXumTdvztcagmVba0Wr/c9m3gsAyF4ERXszcmMMgiqnQA3apv2uY1LBi/vRs0HFV7+KvdwQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 58635ee4-32fb-4692-0d30-08de7df010d3
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6135.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2026 15:25:16.3627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mDj1DDbhFMl/DvvLHoR3gcCMTcc2WYYNEZoKrKWc0o4TypdwmaHtPf6RkPHduYc1nNzuwdsU1NHbIrnPsTsEjdhB4BvUS8Pl9U7q+gK+RM4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9060
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: E5D4C23BCA7
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73323-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,intel.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[piotr.piorkowski@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.966];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

From: Piotr Piórkowski <piotr.piorkowski@intel.com>

Hook into the PCI error handler reset_prepare() callback to notify
the PF about an upcoming VF FLR before reset_done() is executed.
This enables early FLR_PREPARE signaling and ensures that the PF is
aware of the reset before the completion wait begins.

Signed-off-by: Piotr Piórkowski <piotr.piorkowski@intel.com>
Cc: Michał Winiarski <michal.winiarski@intel.com>
---
 drivers/vfio/pci/xe/main.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/vfio/pci/xe/main.c b/drivers/vfio/pci/xe/main.c
index fff95b2d5dde..88acfcf840fc 100644
--- a/drivers/vfio/pci/xe/main.c
+++ b/drivers/vfio/pci/xe/main.c
@@ -85,6 +85,19 @@ static void xe_vfio_pci_state_mutex_unlock(struct xe_vfio_pci_core_device *xe_vd
 	spin_unlock(&xe_vdev->reset_lock);
 }
 
+static void xe_vfio_pci_reset_prepare(struct pci_dev *pdev)
+{
+	struct xe_vfio_pci_core_device *xe_vdev = pci_get_drvdata(pdev);
+	int ret;
+
+	if (!pdev->is_virtfn)
+		return;
+
+	ret = xe_sriov_vfio_flr_prepare(xe_vdev->xe, xe_vdev->vfid);
+	if (ret)
+		dev_err(&pdev->dev, "Failed to prepare FLR: %d\n", ret);
+}
+
 static void xe_vfio_pci_reset_done(struct pci_dev *pdev)
 {
 	struct xe_vfio_pci_core_device *xe_vdev = pci_get_drvdata(pdev);
@@ -127,6 +140,7 @@ static void xe_vfio_pci_reset_done(struct pci_dev *pdev)
 }
 
 static const struct pci_error_handlers xe_vfio_pci_err_handlers = {
+	.reset_prepare = xe_vfio_pci_reset_prepare,
 	.reset_done = xe_vfio_pci_reset_done,
 	.error_detected = vfio_pci_core_aer_err_detected,
 };
-- 
2.34.1


