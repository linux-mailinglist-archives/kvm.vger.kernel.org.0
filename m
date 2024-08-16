Return-Path: <kvm+bounces-24339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D0EC4953FEF
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 05:02:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 31A34B218E9
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 03:02:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6D28535D4;
	Fri, 16 Aug 2024 03:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FVJyq1OP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEFA726AC3
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 03:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723777359; cv=fail; b=iW8M4gz+AlxKbLqS9Dai0fFX15pLGrr44i/yLZPXUZJJ7v2RZVQXTwdhKhSlILl4OC+I6hpN7Xcv+KLeB9RP4PfZANXzNK1ddp1lHJYod567CNK1HCcyj4CqoLWe5uEKoqdkijZlAEEGOLl3CW8Z8bq/5kKeaYsMh8C6osUbaNY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723777359; c=relaxed/simple;
	bh=l8uTmJOXzDw3oV1xSPyFYjOj72ucwVc1xvN5c0I8p5M=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MiJUIBwb5vylkmTX1M6C0HsRQyKocj0+zVyzD8S9scSoT2qXPTuOhV0+59T+siW7CEu8AK/6fMcoKP9SHppA5Nn2NOpAHUici4tjVxPIVHQ6uHsEhjECqklIyOk0be3mDnFck9bt9NGB3SWu36MDQNKns8qI0I5UUPVnAeJdlR4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FVJyq1OP; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723777358; x=1755313358;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=l8uTmJOXzDw3oV1xSPyFYjOj72ucwVc1xvN5c0I8p5M=;
  b=FVJyq1OPibOvAaaLkKOy4pSe3chwzuvyhyTe8BU1+KpI+l2UX3xzGuTv
   E6rGUOXWssuPTbtbgQ5OqslwUWucxLPi7CUljyc4XCigdA/CY/esFuUmq
   PCGqKgLyHDq5pfVbPzAiVXpMkx/foU8KuEFf1XNKsVGY+Ccp0PT6I/Ue6
   oP+03IM+tBk6g1fa8QTxOcdbotjDp6yVhups4bnwvCjgvPbYgwJFR+fTt
   iGXT1kb5024C+lEDLiiSlNj57QtYNIcaZyGyDHpy1aQHgS4Y3KoFl6LrW
   RRxTgVFJXumuoMR6w00Y7FqiJJrFklOl9FG3FXyNxcdEtj+6HmuBGEm4E
   Q==;
X-CSE-ConnectionGUID: ESx5uU8pQBmsfpjaAoffXg==
X-CSE-MsgGUID: KGQmXkVzR2OA4TkqK9mtBg==
X-IronPort-AV: E=McAfee;i="6700,10204,11165"; a="21879706"
X-IronPort-AV: E=Sophos;i="6.10,150,1719903600"; 
   d="scan'208";a="21879706"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2024 20:02:37 -0700
X-CSE-ConnectionGUID: KI+25wW6TxK+/xgGaRJJNw==
X-CSE-MsgGUID: 4BnAE7Y7Rl+PjZUCyP6caQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,150,1719903600"; 
   d="scan'208";a="59500321"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Aug 2024 20:02:37 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 15 Aug 2024 20:02:36 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 15 Aug 2024 20:02:36 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 15 Aug 2024 20:02:36 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 15 Aug 2024 20:02:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CHoKSiET+m6y+Jcr2YXbcmlWEeiTM4VtU+pCLd6Tses5HVR+qHYlpGhZsubZU2EWrIqpCutVARa9I1LXrGSYe4F3CkZFQF0W1yMnqZFZMmCyWB+60vzb/MWyFX+hi78mNhfOJXlJ/qBZwEPyg/I+omZGP1wN+ezUibCmQ8DbHIgfEyTUJJjkkk8MlZStNOyrExAZK3pm9hJMsTUUejvWnHA0JFunzf5oofsmoas71Bg14RyKevE+a+qb1JwaMDcAWDXZOMIMDVO5xbs+Hv9PH1T5O5f/hK4wUGnhRnVGdUcWHnAwUJtKjVNAUVXs7lNeX0rRzamxJ/hv9u9e27zPiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TYXRQKXj4MXXiofuaR3Rgcxhy/My7lloy+jB89oMNag=;
 b=r8JfIbJYQ4MatcKAbKfLydSG00OCgKCIELXgvP66KVN8C5gmUf3iOoBzmknp8K42DJMrHwYAOnDGrl9Iv4OEVRgc/wYxStmhCVh7edNdGD+VurAItcMV9bnlgJMUzcVRyEfpygsfgwsHKjgRACHIyBRKa/YF2TvcUaGJq7VYmA6b3t+ZNqHV2UXqmPNFXrGA7SNpGsq3ZD4PHIDbkCKzJOZLyJXTmZqJ2p7NWaEXAuSU/uGeqAADpEW1lzBIZt+yaSmYS6oOE6jOoGoPjtg8HXv6UxLmjf9Y5UZNEpqTJdgG7sD3xTw+0jluCVCo6YJ9e2R/5wPU3uILvqN61yK16g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 CY5PR11MB6234.namprd11.prod.outlook.com (2603:10b6:930:25::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7875.17; Fri, 16 Aug 2024 03:02:34 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%3]) with mapi id 15.20.7875.016; Fri, 16 Aug 2024
 03:02:34 +0000
Message-ID: <b7197241-7826-49b7-8dfc-04ffecb8a54b@intel.com>
Date: Fri, 16 Aug 2024 11:02:23 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/6] Enable shared device assignment
To: Paolo Bonzini <pbonzini@redhat.com>, David Hildenbrand <david@redhat.com>,
	Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Edgecombe Rick P <rick.p.edgecombe@intel.com>,
	Wang Wei W <wei.w.wang@intel.com>, Peng Chao P <chao.p.peng@intel.com>, "Gao
 Chao" <chao.gao@intel.com>, Wu Hao <hao.wu@intel.com>, Xu Yilun
	<yilun.xu@intel.com>
References: <20240725072118.358923-1-chenyi.qiang@intel.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <20240725072118.358923-1-chenyi.qiang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0027.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::22) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|CY5PR11MB6234:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fd9b26e-2c09-4db8-28bf-08dcbd9fe00e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bTFTS2N1MnJaQ2FRZS9pS05VVkNua0VKUkpaUDBMSzU4akJmd1BKTUl6YU52?=
 =?utf-8?B?MThZcmR0UklCOE5WZ016bmdtZlg4SjMxMTZOZGlTbEE2a2NlNlNyaGdVWjgr?=
 =?utf-8?B?cmFtUkJGS2FYYjhoTUF5V2I1NkZSdHBhMDVVZ0tCRHJFL2FpcmkwUk54ZnZH?=
 =?utf-8?B?dlhxS2NpZDBVSDVHRXNHK1JLMFkvVHJ1ZWFrTUZZTTRIWmp3L2JxQ3lNUTZI?=
 =?utf-8?B?NUlhTjVwNCtjSVYrYWZrK2x1dEl5OFJpMUVWQW9BaHg3Nnkwcnp4L1hFa2VC?=
 =?utf-8?B?S3FJN1JpditiU083ckJkME1MWmFkYUxzdXhQekpLbDQ0U1h6N2lUYk5FQVpT?=
 =?utf-8?B?YmoyR0tXSTRNdElPL2dZWUt2N2pwWG9LbVJoV3ZYNHZsOUphejlCcEMxQTVr?=
 =?utf-8?B?SVJoV0ZRUUp1a1YrOHlacHRwVmhBckxYLzllNWprR2FidmVha0l5ZHBHOHc0?=
 =?utf-8?B?dFdrRWZHOE1jenp5eUtDNm1GMU9ZT1d5dHl3bmcvL25Mak1CVU1QNW95bnV2?=
 =?utf-8?B?U0h4bkhldS9Ma1c5SjJtS1BBSzJoclVnWnRTR2NweHNEUlR5aFJDUnVEMHd1?=
 =?utf-8?B?S0w5RG1raDM1bklTdDVRY1RHMDBEekNaTCtUOVFvclJDOFZLT3RodWVwT2Uw?=
 =?utf-8?B?WStvQnJDS1NTOXNubW5Ed1JhVHArUW0yb1FpTTdHcjNJUHFhczZsUjU1UC9J?=
 =?utf-8?B?ejZUMmtNMGs3eTJnOEV0RDZ2aGdncWZ6UU5HcXJJZHF5dVVBVlBwbFZoQTVV?=
 =?utf-8?B?alZsSnQ1b0RnNDQySFFzRk53RjFCRXpRcUNFR3N1SDU3Nnc5MzNsUVVCQmZY?=
 =?utf-8?B?bUVIOUVKaHJvR3pTTURuKzlmazV4cDY2Z0hud1dsOWpDVzFnNDJkdUdGOFpi?=
 =?utf-8?B?OERyZ1NWdUtGMTFSMC91MHVEc0NJK0hLcXFxR0QzV3R0RFd4NW9OWnJYbHI2?=
 =?utf-8?B?UHY0NDlXeldQbSt2cjNIemdJbkpZcDJsWWRmdkRmVVZMcTBRazdyUFhMMklI?=
 =?utf-8?B?azNBUEdBNm1JWGNBbE0wMy9VNFpMWnorL0wwSEdPRVZZUStEcTd0K2Y4Z05I?=
 =?utf-8?B?dmNtc2xqMnk4bEU1VVY4U2t2V1NyK3JBQjdDZmVDY0p3WGhMYXRYOEVMN1l1?=
 =?utf-8?B?bml5ZThQbGJZU0ZXSEFaWUtwcFZXc05JZGlhNGtVcFRIcDNFZWQybzQ3YkY4?=
 =?utf-8?B?VHBRZm9hNWVCckN2a1JIMEtDWlJFdWFONXlSRmJsN01yLytOMnBIQXVRMkto?=
 =?utf-8?B?RExONHBuY1o1a0pVSnhnYURNTDhZTTlIMGU4a2UxV0Z0d1F2MjdhNStleXVh?=
 =?utf-8?B?SlZSOFNITTI3eG4weEtLNnVkNDZKZnB6REtEMzZlUmlHUkRaQ2E4eUlSZ29U?=
 =?utf-8?B?YlF3YzlVUzlLYll6SWI4N1k3bFpQOHBPRG5SM2RIQ1JKZENwb3dIdElqTkxs?=
 =?utf-8?B?ZGVrRWF2SENBUEdlYU1yNXNwK1lmTzdpK1hwd0QwRUhyUjJWVWFqUlo0L0pO?=
 =?utf-8?B?UDhZYUJxUWpWbDI3d1A5bnFLSFR3NTBVOGdLeVlYaGd4MHFCYU56a1FER1Qr?=
 =?utf-8?B?dXlKLzJKUEVSOEU2SDZjaXZHTFRETUZVWTVGZTFkekEyV1pETFFydGc0NGl2?=
 =?utf-8?B?VVBVaFdzQkxETk9iWFY2bTArYWJPYVdvZWZ0bXhNQlJXY096UDh3ZHRtaVgw?=
 =?utf-8?B?M3pLRnI4ZlBvdVZ2WlhjWm9DdHBBaG1zNU14cVY5MlcwaEtpbDVULzJMY04w?=
 =?utf-8?Q?ZcG+tIx4gTFQnN30TNFlJRyQOyt5HlbNtVCd8Yx?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Qm5OQnd3OXZ5TzQ3dGdNMnhNVEJhSjF3RmlQWFV0ajNmOFpRMldwa0ZRb1M3?=
 =?utf-8?B?NzBQUWNxVTVSVXRRcEJDaXU3UTZXMW5PQ3RFZGk4R1RxNVViYWo5SSt4dnE0?=
 =?utf-8?B?YkxIVytEdUVxem0xdEowUzBtUGVxdndEV2JtL01sOXVubnRkQUVpcDY0eUx4?=
 =?utf-8?B?OWlJaTBudFNLZ1drRnRxM3kyR0J3SURuSHNacktnR3k0WGxwSUpod3hMN2Vh?=
 =?utf-8?B?ZHpKV0swR09LaFN4NmtzeDY1VUVlRkpEdU5oQ1E2Qm8zK3FveUNhcUlCVFFo?=
 =?utf-8?B?NkdmTHpybFJTeGxzU01ZYVhCVUw3cUlDekNoVGtNRHd4MjZmSUFnN3lWcHdt?=
 =?utf-8?B?bUNoNXBYRm1WaHp1TjN1bzVTMVM0b0NuZHphV3pXcmsxMjd0TFpYYzZ1dFZO?=
 =?utf-8?B?R3BkL0lmR0pVTWVibm5WdjgwK1NLMlpWUXgxSUhaUGZTdmhXUG9QazZzTXIz?=
 =?utf-8?B?UkpZVkFXb1R2eExEVG1kVHBNdWZJTW1kWWNWekpkbXNVV3IxNjZUOUJXTU1G?=
 =?utf-8?B?MWNybFNyajBncUczY1hzcmMzMzcwZHhNM1NFVDc0QkQ2SmNGUms4YXdiS2RK?=
 =?utf-8?B?dk41OXI2K3daSCtQWFhIZkxoN1BDSWhDcE5RMTRDNjY4akxTRVROZUt5eWwz?=
 =?utf-8?B?bHVVa1MxZXZmYVY5UTNldEw2OG56N2JYZHByd3pnT2lua2lubFlBcC9qYXBZ?=
 =?utf-8?B?RWtaSUhrQjJpNWcrb0tPZDc0MFlyVkVQbENrVVNOdXRSWnIwNkdSVGtrUllO?=
 =?utf-8?B?YWZmNzZFd0FETjgxaUVGaWQ1UFI1SUhLWEp6VDRldFJQbDlCZ05ZUG12eUxH?=
 =?utf-8?B?K0pVV1lKbDkrZDhRbTZKSVpjbkRsM3poZEtOalpNOGxqaWZZNGRDcmFCSC85?=
 =?utf-8?B?TysyVGl2NnNCVWc1dEt0RlZpa25iZXhBaTNMbm1nblJ4NnhEeE5zMWh1cGpq?=
 =?utf-8?B?ZjlkcDFESXVuTE55TnhnenJOOTdYRldHaVhDbm0wL252U20vdWwzRmZNVVV4?=
 =?utf-8?B?d0xUSTR2eGF6b0ZmUnRxRDlQdUl2aVRsaTJ2WWQ4Zlh5ZWpJSkJpYmQ2bjl2?=
 =?utf-8?B?M0dHRVRTRFVDUFVudFRIZ0s0QlJ2eVlXZ09GUTFHeHV5OUFlRWxVKzRBOCs0?=
 =?utf-8?B?ekNhd1hyQyt2UVpGZXZHN2REY1E4VG9uRjd6SEx3OTg1aURTVGpHcllhMjFi?=
 =?utf-8?B?bXd0Z3BqVUJ1MVgrNFVLTmdVQzJVZklGSlg0OSsvanNqalRiQXBGYUNadlJL?=
 =?utf-8?B?Ym9TWVA0WTl2QkNzWnp2VkRBSDNGSWxjNHhXcWtPZGdMMklxS3YyQVlqTE5D?=
 =?utf-8?B?WnRBekRXNGxWc0hKem0yb2J1RHdoVlFpUUk4aTgvMVhUUlNOR3RzTzJaYmNJ?=
 =?utf-8?B?Y2dBSHJTL2phQ1ZkNTZpVW1nVG16azZKcDFDOVFjOGlsdFFKOHRCaFRVYzNY?=
 =?utf-8?B?Q0cyNmlyMGlxQ0daTWY0TlRSdWlZVjRLQkh4OVUwbkdiRzlzVzJNV2w5MXBO?=
 =?utf-8?B?MCtYdDVEMnlKc25FN21odTlUSHZKcXU4UXkwdzNxaFZobnpxRm16RHp6SGhl?=
 =?utf-8?B?QWZzRTR3ZmI2d3l6eXBsSUV4Lytzck5xZTdqeWdVZUpILzcrNnNSVHJNeTQ5?=
 =?utf-8?B?ZTc4Zi9hZnBMbmlxeE1rTml4eGpJd09RREtIWXQ0dlpVMmFkclpYMCtsS2hN?=
 =?utf-8?B?dkswVW45R0dDTUVTMHFyeHNsVjU0MW1SWlk4d3lvb1RXM0NsNkw0QS9UNW1x?=
 =?utf-8?B?WFVNK0w1emo2ZElOZ0plT2Z4VE1CZjJEbG5kaG93TjNZMGprSmt1d2Z6QlBl?=
 =?utf-8?B?dHVUdVRsVG9OOE14VXR4TTZheGxRa01EclhYQ3B4N3RKOUwxdEsxbTNITFVI?=
 =?utf-8?B?YUkwMGlmZVJQQWNGSlFrS1RPZUxtbytNaml4ZEJhNTV5R0U5S05mM1hYd3ds?=
 =?utf-8?B?SEUycFoyMHVuLzRnUnBwd05adFY2Zk40Qm1mc2k3c1VjNHlMRjhPcGhDOGUv?=
 =?utf-8?B?YUt6ZU5HYzF4VC9BY21TTThFV283Wmwya1M4Nys5SGpJc1NZbnJtUFVDS2xo?=
 =?utf-8?B?VVh6cVlZZ2Qra0orQVNrVzFXRjZpYktmVGt4VEVhalZwelZBL1EvQ2xYaW5l?=
 =?utf-8?Q?2dxrJAXhFFEHR5Mshs3CYqXgf?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fd9b26e-2c09-4db8-28bf-08dcbd9fe00e
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2024 03:02:33.9445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hy1PxFKt874tEGZgUmSfH+bkLNggeGgv2VIMTWwcsOz5v8Y9HpyNyD0w+CTDMwP0P0aKRcbxCnPiiFmBpoT5rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6234
X-OriginatorOrg: intel.com

Hi Paolo,

Hope to draw your attention. As TEE I/O would depend on shared device
assignment and we introduce this RDM solution in QEMU. Now, Observe the
in-place private/shared conversion option mentioned by David, do you
think we should continue to add pass-thru support for this in-qemu page
conversion method? Or wait for the option discussion to see if it will
change to in-kernel conversion.

Thanks
Chenyi

On 7/25/2024 3:21 PM, Chenyi Qiang wrote:
> Commit 852f0048f3 ("RAMBlock: make guest_memfd require uncoordinated
> discard") effectively disables device assignment with guest_memfd.
> guest_memfd is required for confidential guests, so device assignment to
> confidential guests is disabled. A supporting assumption for disabling
> device-assignment was that TEE I/O (SEV-TIO, TDX Connect, COVE-IO
> etc...) solves the confidential-guest device-assignment problem [1].
> That turns out not to be the case because TEE I/O depends on being able
> to operate devices against "shared"/untrusted memory for device
> initialization and error recovery scenarios.
> 
> This series utilizes an existing framework named RamDiscardManager to
> notify VFIO of page conversions. However, there's still one concern
> related to the semantics of RamDiscardManager which is used to manage
> the memory plug/unplug state. This is a little different from the memory
> shared/private in our requirement. See the "Open" section below for more
> details.
> 
> Background
> ==========
> Confidential VMs have two classes of memory: shared and private memory.
> Shared memory is accessible from the host/VMM while private memory is
> not. Confidential VMs can decide which memory is shared/private and
> convert memory between shared/private at runtime.
> 
> "guest_memfd" is a new kind of fd whose primary goal is to serve guest
> private memory. The key differences between guest_memfd and normal memfd
> are that guest_memfd is spawned by a KVM ioctl, bound to its owner VM and
> cannot be mapped, read or written by userspace.
> 
> In QEMU's implementation, shared memory is allocated with normal methods
> (e.g. mmap or fallocate) while private memory is allocated from
> guest_memfd. When a VM performs memory conversions, QEMU frees pages via
> madvise() or via PUNCH_HOLE on memfd or guest_memfd from one side and
> allocates new pages from the other side.
> 
> Problem
> =======
> Device assignment in QEMU is implemented via VFIO system. In the normal
> VM, VM memory is pinned at the beginning of time by VFIO. In the
> confidential VM, the VM can convert memory and when that happens
> nothing currently tells VFIO that its mappings are stale. This means
> that page conversion leaks memory and leaves stale IOMMU mappings. For
> example, sequence like the following can result in stale IOMMU mappings:
> 
> 1. allocate shared page
> 2. convert page shared->private
> 3. discard shared page
> 4. convert page private->shared
> 5. allocate shared page
> 6. issue DMA operations against that shared page
> 
> After step 3, VFIO is still pinning the page. However, DMA operations in
> step 6 will hit the old mapping that was allocated in step 1, which
> causes the device to access the invalid data.
> 
> Currently, the commit 852f0048f3 ("RAMBlock: make guest_memfd require
> uncoordinated discard") has blocked the device assignment with
> guest_memfd to avoid this problem.
> 
> Solution
> ========
> The key to enable shared device assignment is to solve the stale IOMMU
> mappings problem.
> 
> Given the constraints and assumptions here is a solution that satisfied
> the use cases. RamDiscardManager, an existing interface currently
> utilized by virtio-mem, offers a means to modify IOMMU mappings in
> accordance with VM page assignment. Page conversion is similar to
> hot-removing a page in one mode and adding it back in the other.
> 
> This series implements a RamDiscardManager for confidential VMs and
> utilizes its infrastructure to notify VFIO of page conversions.
> 
> Another possible attempt [2] was to not discard shared pages in step 3
> above. This was an incomplete band-aid because guests would consume
> twice the memory since shared pages wouldn't be freed even after they
> were converted to private.
> 
> Open
> ====
> Implementing a RamDiscardManager to notify VFIO of page conversions
> causes changes in semantics: private memory is treated as discarded (or
> hot-removed) memory. This isn't aligned with the expectation of current
> RamDiscardManager users (e.g. VFIO or live migration) who really
> expect that discarded memory is hot-removed and thus can be skipped when
> the users are processing guest memory. Treating private memory as
> discarded won't work in future if VFIO or live migration needs to handle
> private memory. e.g. VFIO may need to map private memory to support
> Trusted IO and live migration for confidential VMs need to migrate
> private memory.
> 
> There are two possible ways to mitigate the semantics changes.
> 1. Develop a new mechanism to notify the page conversions between
> private and shared. For example, utilize the notifier_list in QEMU. VFIO
> registers its own handler and gets notified upon page conversions. This
> is a clean approach which only touches the notifier workflow. A
> challenge is that for device hotplug, existing shared memory should be
> mapped in IOMMU. This will need additional changes.
> 
> 2. Extend the existing RamDiscardManager interface to manage not only
> the discarded/populated status of guest memory but also the
> shared/private status. RamDiscardManager users like VFIO will be
> notified with one more argument indicating what change is happening and
> can take action accordingly. It also has challenges e.g. QEMU allows
> only one RamDiscardManager, how to support virtio-mem for confidential
> VMs would be a problem. And some APIs like .is_populated() exposed by
> RamDiscardManager are meaningless to shared/private memory. So they may
> need some adjustments.
> 
> Testing
> =======
> This patch series is tested based on the internal TDX KVM/QEMU tree.
> 
> To facilitate shared device assignment with the NIC, employ the legacy
> type1 VFIO with the QEMU command:
> 
> qemu-system-x86_64 [...]
>     -device vfio-pci,host=XX:XX.X
> 
> The parameter of dma_entry_limit needs to be adjusted. For example, a
> 16GB guest needs to adjust the parameter like
> vfio_iommu_type1.dma_entry_limit=4194304.
> 
> If use the iommufd-backed VFIO with the qemu command:
> 
> qemu-system-x86_64 [...]
>     -object iommufd,id=iommufd0 \
>     -device vfio-pci,host=XX:XX.X,iommufd=iommufd0
> 
> No additional adjustment required.
> 
> Following the bootup of the TD guest, the guest's IP address becomes
> visible, and iperf is able to successfully send and receive data.
> 
> Related link
> ============
> [1] https://lore.kernel.org/all/d6acfbef-96a1-42bc-8866-c12a4de8c57c@redhat.com/
> [2] https://lore.kernel.org/all/20240320083945.991426-20-michael.roth@amd.com/
> 
> Chenyi Qiang (6):
>   guest_memfd: Introduce an object to manage the guest-memfd with
>     RamDiscardManager
>   guest_memfd: Introduce a helper to notify the shared/private state
>     change
>   KVM: Notify the state change via RamDiscardManager helper during
>     shared/private conversion
>   memory: Register the RamDiscardManager instance upon guest_memfd
>     creation
>   guest-memfd: Default to discarded (private) in guest_memfd_manager
>   RAMBlock: make guest_memfd require coordinate discard
> 
>  accel/kvm/kvm-all.c                  |   7 +
>  include/sysemu/guest-memfd-manager.h |  49 +++
>  system/guest-memfd-manager.c         | 425 +++++++++++++++++++++++++++
>  system/meson.build                   |   1 +
>  system/physmem.c                     |  11 +-
>  5 files changed, 492 insertions(+), 1 deletion(-)
>  create mode 100644 include/sysemu/guest-memfd-manager.h
>  create mode 100644 system/guest-memfd-manager.c
> 
> 
> base-commit: 900536d3e97aed7fdd9cb4dadd3bf7023360e819

