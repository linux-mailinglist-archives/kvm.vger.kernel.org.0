Return-Path: <kvm+bounces-27191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FF4897D0D5
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 07:10:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B8A611C215E0
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 05:10:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12AFB36AEC;
	Fri, 20 Sep 2024 05:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PbYFC4iC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772B52746B;
	Fri, 20 Sep 2024 05:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726808994; cv=fail; b=TC8lkQCT46Vbv7M0Vh5JKT3GGvgdGyg5QCSJMlHev0wemxoT2Plj9A0jgorv1d4BFBNuQe/L8Np5FpKyruOb7AMWcj35CpIl54TsmJlzwkSC5/xss6qKjan4B0tF0SSTKQfVIj7cBEbvsZVmUVZTE+ll83Wj9UIxeoN8iO5VfQk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726808994; c=relaxed/simple;
	bh=ARfx9bUrergpvHb9w0y0mH1sw/Mbu5Gb/OlRrmq6wdc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Eejv234zFFNKD6IfPJ+BJIpK/6gOLcOPF+kvMq5zRhs2r7ZaZrvHRK/fdXzik1aB9xTDMRv7UBRbOsitWOrWoROuILYyOjg78gs6ZhE/mrszE2LWAdNvX8YQFI/jG/wbiSjBW3wpnbmKSJPRc4nuErHG2EMMBi65AsukIQEV70Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PbYFC4iC; arc=fail smtp.client-ip=40.107.220.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SWtvxf5SePIqSbPkl2pUudrfKunDdPwLW6syGNxMhejLylinAl20RxZtcoNPBt7xnbZNCVvSMGGDheG1nT4nkFFHZch/6asXBcl50/3KulH6LOMBkV+hHHg1vxp+Q/BS8tkMOVkvBWf/OjPrhijnClwJfombIN7+AZnafFoKw4uFXN7krHcDw+r1aCqnpFOTswhJbRdYkixmULuPscJG0fnkPaxrU8XxzI/htDkovHZyyYafvL47/J6fqRA6XOfWyhtvmWry2pzK7iLOp5h9X2CdckrKoIhcuMjTAa9n8H8gnoFxdmsGz8WPUlrdw3FZiRZcmhpiTbKrdoKCac1d3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=POfGYyZOvwPZEYlkkITDB3o0AD3PK8+eyY5l1QQNzOM=;
 b=Fsp+nqm5j5MR/NDTKJHbER86+rc7xEeSiEfQvYC4DqFSd4yL94pz6EqjQrGyAE3uiKP7vZg+g9wWO5zokmY634DJOVrLyNHliHBvvEW3eNa1imd4RJwwokK+lAsziMBjDFp5w2IakJ8aP7qbQv3uhx2oSe0xzzTdO9TvCH+yNn6er/W3L3Nao6PIXMFjmXH9U8MWjHF6Lsh0tsZn/XzSLZjghEOeZVc36wun2pwVqDTCbLrTWIYlqQ2F8hDzzBfW63ew98MdO1qD5Y5OuvB7Zs28XDEet4Irup7vFsulDqLdSKx/QR2zKxqRVpdr1+38UGmNmXNTc9FGzEg6pBA/OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=POfGYyZOvwPZEYlkkITDB3o0AD3PK8+eyY5l1QQNzOM=;
 b=PbYFC4iCJd0U23V4Y1MigphGpMWdxdy0QsUbAgaCZGIPFiMAkz0ZFJEQ9ikLr00QQPeSh8Er7otjR+n3suMDWQxpu6ZJd8O6t+/cGxRCtGWw0xCGJlgmAS6HHzdE/S+HAl3+z1Xt07omP8WdhbZ3cfzO9Nx+W+ACGinvEYLJGFw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6214.namprd12.prod.outlook.com (2603:10b6:8:96::13) by
 CYYPR12MB8731.namprd12.prod.outlook.com (2603:10b6:930:ba::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7982.22; Fri, 20 Sep 2024 05:09:49 +0000
Received: from DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::17e6:16c7:6bc1:26fb]) by DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::17e6:16c7:6bc1:26fb%5]) with mapi id 15.20.7982.016; Fri, 20 Sep 2024
 05:09:48 +0000
Message-ID: <3dd7e187-9fbe-4748-9be5-638c8816116e@amd.com>
Date: Fri, 20 Sep 2024 10:39:36 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 14/58] perf: Add switch_interrupt() interface
To: "Liang, Kan" <kan.liang@linux.intel.com>,
 Mingwei Zhang <mizhang@google.com>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org, Manali Shukla <manali.shukla@amd.com>
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-15-mizhang@google.com>
 <9bf5ba7d-d65e-4f2c-96fb-1a1ca0193732@amd.com>
 <1db598cd-328e-4b4d-a147-7030eb697ece@linux.intel.com>
Content-Language: en-US
From: Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <1db598cd-328e-4b4d-a147-7030eb697ece@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0103.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:27::18) To DS7PR12MB6214.namprd12.prod.outlook.com
 (2603:10b6:8:96::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6214:EE_|CYYPR12MB8731:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f6a3773-7a80-48a9-2c91-08dcd9327332
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MU1kK0tQVjU3RU53TzJ0N0gwYU1NR25YdlYvajVDMFRlLzVYWk82TW9FaVFw?=
 =?utf-8?B?WFRIUnBXOXpybytZWlNHaDZxQ1YwcytZSjljWW1wZEw3d1JNVGV0NGo3Qkwy?=
 =?utf-8?B?K2U2MXZPVjgvd3dsV1BlajNaVHgvaDlLU2gzUmx3TEl4M2EwTVUvT3JGakJw?=
 =?utf-8?B?V3Y2bzVnWGVtVk1nK3BWQXc4c3gwQmVlazB5RkVsUEFXaUkvQllQL1VQUzh1?=
 =?utf-8?B?TEpETU9tK2lVcFZxZWdNd1RVTHpmVWxJSGMzU2RmTTVVMUxqWUhpRWFvaGJE?=
 =?utf-8?B?ODBlTE95ODFvMm10dS9mM0VTK29DcVhHWnZZeVJ3WW9kbjlTUVJtNDRDRkk1?=
 =?utf-8?B?cmF4akQ2L0JWQm1pN2NxMjdUTHE1aTd6NUNQME44K2tRdE1sWTNISWRQaFpM?=
 =?utf-8?B?SVZFaDBJZldrNnNaeDVvWmFhVHdwQklrcVhRVmUxY0NaR2VIa1FxV09qQWxP?=
 =?utf-8?B?TGxWd1RHc3BWM0UranJPanJJWFJKc2daYzNUSVloK2NPVFoySXM2VGF3NHc1?=
 =?utf-8?B?TElpbko4LytOWGFOMDVnV1FFQnVXd1YxZ2xucER1ejR5TDRvbjlXWnZwMFhB?=
 =?utf-8?B?b2JDbzcxWkpvVXNMY1QwWHkyMENTK3VQU1JuRUdxdUhEcUVENHhWbnVod3hL?=
 =?utf-8?B?YWVSUWdoTldwbmN1eWtFVmswemUwc2JKUzRBanoxRStpTVd5ZlVSQlRUVXRj?=
 =?utf-8?B?ZEQ2TWd4WmhycmJ3d05mby9VMzIweEYzUVlib1BMR2xBRGVMbzlLZ0oxanhB?=
 =?utf-8?B?UWM1Z08yZlpaMGFWTGk3ektGOUlUZFNCSXloNnZNMHlacGlsMFF5VXc5cm1V?=
 =?utf-8?B?ZXE0UHRPbUNXd21qZUxPaE9IbWYzVlNhSWNTUlVUbzZTb3kzSk01azV6N0ZS?=
 =?utf-8?B?aWM0ZXpnYnZxcjk4L0NHRkNKUktURzVSellaTXRKaDhxUDk4NVpLaEVMWEVo?=
 =?utf-8?B?VWZiRCtzYTk1bUpEazZVTmtaeUZGTWNBMWZOMURwVzNaKytJWlpzQkwrcjBB?=
 =?utf-8?B?dlp4dW5pd2F6b2dsKzAxeFMvY0MwTU1pYm1SMnNvL1gwQU9iWXR6ZHVERmlO?=
 =?utf-8?B?RURjV3RuZDc3TktjRWtHbzhhSjVsQmNWK3NWWDlobmN6cnRTUzBPUDg1QStp?=
 =?utf-8?B?WThPZmpobnpkeDcvM0lNdk53K0ZEMnllMjZaaldoejA0ejM3aDNVVVMxL0Yw?=
 =?utf-8?B?dXdrWTFtWE40bUlUSENFOWErVUdVODhVTmkxeDNsK3NBU2poVU9ldFU4OFFZ?=
 =?utf-8?B?anlBd2lLNGgxYlJBbEFqTkNLb3FGbkJaOTBOamJSemlQVXlUZFRlZkxaeVA5?=
 =?utf-8?B?MC9GNHBhRkRRMDExSEozRGVnY2QrblhlTWV2dmNZOHljOHVzVDU4bFczYmxp?=
 =?utf-8?B?T2pkaExDSnBwdnM4ZGFwTGIwblpSNmZVUStXS3lBUWJFcFpDZ1pBWnBmbTgy?=
 =?utf-8?B?Zm5qUkUrWG8wbm1yOHhibEMxaU9nM3FodWxNKytKZzhmZXUzZUtWWjdmUHVU?=
 =?utf-8?B?eTBNckd2Mk83SmsrZXVOdmptRkdTRDZuQzFXNXRHQ0dKZzBGTGRBYTlObXhv?=
 =?utf-8?B?TXgydnFoL3dVdFVYbmgxVW83bHNZdjdsUnFvbGRkdVhybVBNTE1RTVVCcnhy?=
 =?utf-8?B?VXJsd2VtWENLekdPdm9tdHNUKzhMMWZsdU1iK1NTMTRvT0xiN252YkFUaWVE?=
 =?utf-8?B?akFYUUczMkI4QTUzYmlhbWYrQmtiVE1TZU9zTlhGTlB5dURPMGczc0ZhSHdS?=
 =?utf-8?B?MlFXWStPTWs3OWsvcVpKb0hLbUd2SGt6Wm1Qb2ZJU3NDb1pCcEVSd0c0MFlI?=
 =?utf-8?B?eWNiK29iRE1BdWtQR3NRTWpUcTBUcjlFdE4yVVVJcjI1STNKN3dVQitSYzZB?=
 =?utf-8?Q?OKxg7J9dO55Zw?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6214.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZzVXei81bjIwZ0FnNE9MaXFpRFVyTytqZ1UvdjJBRFhJdkhLdnhvdjhnL0xR?=
 =?utf-8?B?TnF1T2xZSWk4YzgvSVFWSGc2YlNFVENrcmNITWlRSXBoRWc2dXdzV0U1Ym1C?=
 =?utf-8?B?OGlha1NnbTZybmFwOWNzWGFFMXlzZ3RWUjkwSjZxU0s2VEg1aFpKMnZvU0tt?=
 =?utf-8?B?T2xnc2kyNlAyL08wY0ZiR1JoNWI3U1hrYzAxeEpYOEtBVStGYXZSWCtaZ2Mx?=
 =?utf-8?B?WVZnYjJ5UjcwZWNjTHVIanRWWHM0T0FoenlRYzlpWWlKSEMraUtoOWdTUGdB?=
 =?utf-8?B?amlRVTk0Sk5zVFBRemt0KzlTY0VOa1FqQU9ncDRYQysrNE9rVURCK0N3TGNP?=
 =?utf-8?B?Rk9mc2FCYlNSZWhKTUNlQW5GbzR2UUd5RUhhSnJTS1BZY2lTcThnTVJGcTNU?=
 =?utf-8?B?ZkxIbTV6MVNLOFdSNk1uRXRTajVpd2tRd2o3eGhpb2p3UWordWF6U2srekdV?=
 =?utf-8?B?WlRzdTBFMnlCRG45ZGx4YmJLSFdTaFpsVEdSdVJoaUhUUDVVQXIvUTNWZWgw?=
 =?utf-8?B?VWlVRnI2MzNCblVlWitoSTJ5dmtqdjdOaFU5bGU1c0p4OVNYQ0VQVEVxRWU3?=
 =?utf-8?B?ZDVobC9kY3pvb241Y2NuanlsTzN1N0kzbVMxZm1yOE1JR1ZITHJNR3BMTFlT?=
 =?utf-8?B?eEJjOVl4WG1KeVFjS2IwamVtR0NCTkNudGt2ckY2NHlpZVdTbnA2VlUyMDhh?=
 =?utf-8?B?SUhTcDVFbll6UHJvSzlXWVBmZmVDL0tsMm5vMG5VZFZBejVqWFpZMG9vbzdl?=
 =?utf-8?B?OHc4L2YycUdlekt3NEtOSnI1T2VlaWQxTHFac25jeGxRcVROSjRvM2xtUkdM?=
 =?utf-8?B?OWp4K1l3TndXcjI4ZjBzQkRHTmJRVWpVRG9nRThMVlRndGdvd3IwY2lJa1g1?=
 =?utf-8?B?SVEyOEsxS09xci9YTE5ES3pvbmdMZUNIWVExeEtRczlWUjJKaFovRE9pUkZz?=
 =?utf-8?B?U2plQTN6OVlXdGxEcXhsVEd0QnAwUVdOdG1CK252Qy8rS3NyN1NBRUEwSzJO?=
 =?utf-8?B?NE1paUU0enl0RHRtdFV5aWwwRjVrRjdCNGkxVDc2Y3EyeGNjZ2tvMTJQZEJu?=
 =?utf-8?B?TERLMmJ3UmN3dEFHU1ZreThjZ0hkL2s4VTdzbStEMkUwQWdvRnl4dU9nMmtV?=
 =?utf-8?B?d3dVMkVPcDVxczlhRnFKUHl5NUtOeTNpMm0yT2luTmEzQ3Vuak5ESEQrMGN3?=
 =?utf-8?B?ckduN3RzdXc1S3lWU3BPam1TUEJyNE9TWTZtbGt4WHNYakhqOCs1bUVYYjcz?=
 =?utf-8?B?amdLOHpzaVhrTjVMQkp0UzY1NGIra3gvODBReFpxK0xpeGxwbDRtenpEWHBw?=
 =?utf-8?B?RGRTZVV2QWgwZmczSHNXYXdpZ0dJVlZ1VXJreUVnNGJ6SHhlczZ2L1pYTENB?=
 =?utf-8?B?MXJUWXRVcm02RW1PZzIzTlQwbFdjdWx3UktGcE9aZ0xsTkRvSEtNcG1NcTU0?=
 =?utf-8?B?bGx2N3ZWYlNrUVd3NFhwNXRIYTZ4dk1PVTFZZEtJTDRHRUR1K25UVEV0bEtR?=
 =?utf-8?B?UGlBaGtrTDluNWZtMklJOUVBZkRwOWwrQytMMklPN1hXSzFwSGIzY2dKV3hQ?=
 =?utf-8?B?ZHI4TXdYUkN5MGw4SG93STQ1NENmNllZdHFPNkxERWJ6T3grdEUyYkV6TGN3?=
 =?utf-8?B?a2RHQ3F0VUl3cldOdUFXTUIyS2ZYTlR5TUVrM1FiUzJKRllJZjVJVHEyQXEv?=
 =?utf-8?B?cC9YOGtDUU40cjZTVVpteFJPa3NkZEZNdG10SGFjOWF6a0MvYmw0TElWczFS?=
 =?utf-8?B?d1RwR0oyNFAySktWdXc2WWx0eWhKbDhINzVyZU1mODFBY04vYVFHNGVKSnhH?=
 =?utf-8?B?cmFsUTNIbHcvRE1Cbk9GeUhkUlV5cVA3MVcycndrUlovZThBQ3VrcHg4SkVL?=
 =?utf-8?B?dWxjZ2EvSWxBRUdvVEJYSy9wRFpZNC9BRjdBWDJKZVd0WUNmUXJGKzAwV295?=
 =?utf-8?B?UG1WZC9HSm1yUnAwSllQendJenc3clZwbTJOSjJaajVVNkljQUZrLzVETXZo?=
 =?utf-8?B?ZWhpMlNsNmFsY1pmVllnK2FJNnpDUExOVUlIRCt2M0xhUGJkNjlmSlVJRHRn?=
 =?utf-8?B?L2ZxNGlQanBRZjFPK2VvNW43cXppYlpvakY0dmJQR3RjWm9VcC9uNkRBRzdu?=
 =?utf-8?Q?H4LkK906ax4fNG2ZTT7PlTSpH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f6a3773-7a80-48a9-2c91-08dcd9327332
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6214.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2024 05:09:48.7475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D0tRriJ5Iy8u+/5AHGfWJtTlH6XCg0i210InHiEIhyX3xowtFzP7DlRQ8ok8OyxtZ8rSdv8UtTB6Rn7k/IJEjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8731

On 9/19/2024 6:30 PM, Liang, Kan wrote:
> 
> 
> On 2024-09-19 2:02 a.m., Manali Shukla wrote:
>> On 8/1/2024 10:28 AM, Mingwei Zhang wrote:
>>> From: Kan Liang <kan.liang@linux.intel.com>
>>>
>>> There will be a dedicated interrupt vector for guests on some platforms,
>>> e.g., Intel. Add an interface to switch the interrupt vector while
>>> entering/exiting a guest.
>>>
>>> When PMI switch into a new guest vector, guest_lvtpc value need to be
>>> reflected onto HW, e,g., guest clear PMI mask bit, the HW PMI mask
>>> bit should be cleared also, then PMI can be generated continuously
>>> for guest. So guest_lvtpc parameter is added into perf_guest_enter()
>>> and switch_interrupt().
>>>
>>> At switch_interrupt(), the target pmu with PASSTHROUGH cap should
>>> be found. Since only one passthrough pmu is supported, we keep the
>>> implementation simply by tracking the pmu as a global variable.
>>>
>>> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
>>>
>>> [Simplify the commit with removal of srcu lock/unlock since only one pmu is
>>> supported.]
>>>
>>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>>> ---
>>>  include/linux/perf_event.h |  9 +++++++--
>>>  kernel/events/core.c       | 36 ++++++++++++++++++++++++++++++++++--
>>>  2 files changed, 41 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
>>> index 75773f9890cc..aeb08f78f539 100644
>>> --- a/include/linux/perf_event.h
>>> +++ b/include/linux/perf_event.h
>>> @@ -541,6 +541,11 @@ struct pmu {
>>>  	 * Check period value for PERF_EVENT_IOC_PERIOD ioctl.
>>>  	 */
>>>  	int (*check_period)		(struct perf_event *event, u64 value); /* optional */
>>> +
>>> +	/*
>>> +	 * Switch the interrupt vectors, e.g., guest enter/exit.
>>> +	 */
>>> +	void (*switch_interrupt)	(bool enter, u32 guest_lvtpc); /* optional */
>>>  };
>>>  
>>>  enum perf_addr_filter_action_t {
>>> @@ -1738,7 +1743,7 @@ extern int perf_event_period(struct perf_event *event, u64 value);
>>>  extern u64 perf_event_pause(struct perf_event *event, bool reset);
>>>  int perf_get_mediated_pmu(void);
>>>  void perf_put_mediated_pmu(void);
>>> -void perf_guest_enter(void);
>>> +void perf_guest_enter(u32 guest_lvtpc);
>>>  void perf_guest_exit(void);
>>>  #else /* !CONFIG_PERF_EVENTS: */
>>>  static inline void *
>>> @@ -1833,7 +1838,7 @@ static inline int perf_get_mediated_pmu(void)
>>>  }
>>>  
>>>  static inline void perf_put_mediated_pmu(void)			{ }
>>> -static inline void perf_guest_enter(void)			{ }
>>> +static inline void perf_guest_enter(u32 guest_lvtpc)		{ }
>>>  static inline void perf_guest_exit(void)			{ }
>>>  #endif
>>>  
>>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>>> index 57ff737b922b..047ca5748ee2 100644
>>> --- a/kernel/events/core.c
>>> +++ b/kernel/events/core.c
>>> @@ -422,6 +422,7 @@ static inline bool is_include_guest_event(struct perf_event *event)
>>>  
>>>  static LIST_HEAD(pmus);
>>>  static DEFINE_MUTEX(pmus_lock);
>>> +static struct pmu *passthru_pmu;
>>>  static struct srcu_struct pmus_srcu;
>>>  static cpumask_var_t perf_online_mask;
>>>  static struct kmem_cache *perf_event_cache;
>>> @@ -5941,8 +5942,21 @@ void perf_put_mediated_pmu(void)
>>>  }
>>>  EXPORT_SYMBOL_GPL(perf_put_mediated_pmu);
>>>  
>>> +static void perf_switch_interrupt(bool enter, u32 guest_lvtpc)
>>> +{
>>> +	/* Mediated passthrough PMU should have PASSTHROUGH_VPMU cap. */
>>> +	if (!passthru_pmu)
>>> +		return;
>>> +
>>> +	if (passthru_pmu->switch_interrupt &&
>>> +	    try_module_get(passthru_pmu->module)) {
>>> +		passthru_pmu->switch_interrupt(enter, guest_lvtpc);
>>> +		module_put(passthru_pmu->module);
>>> +	}
>>> +}
>>> +
>>>  /* When entering a guest, schedule out all exclude_guest events. */
>>> -void perf_guest_enter(void)
>>> +void perf_guest_enter(u32 guest_lvtpc)
>>>  {
>>>  	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
>>>  
>>> @@ -5962,6 +5976,8 @@ void perf_guest_enter(void)
>>>  		perf_ctx_enable(cpuctx->task_ctx, EVENT_GUEST);
>>>  	}
>>>  
>>> +	perf_switch_interrupt(true, guest_lvtpc);
>>> +
>>>  	__this_cpu_write(perf_in_guest, true);
>>>  
>>>  unlock:
>>> @@ -5980,6 +5996,8 @@ void perf_guest_exit(void)
>>>  	if (WARN_ON_ONCE(!__this_cpu_read(perf_in_guest)))
>>>  		goto unlock;
>>>  
>>> +	perf_switch_interrupt(false, 0);
>>> +
>>>  	perf_ctx_disable(&cpuctx->ctx, EVENT_GUEST);
>>>  	ctx_sched_in(&cpuctx->ctx, EVENT_GUEST);
>>>  	perf_ctx_enable(&cpuctx->ctx, EVENT_GUEST);
>>> @@ -11842,7 +11860,21 @@ int perf_pmu_register(struct pmu *pmu, const char *name, int type)
>>>  	if (!pmu->event_idx)
>>>  		pmu->event_idx = perf_event_idx_default;
>>>  
>>> -	list_add_rcu(&pmu->entry, &pmus);
>>> +	/*
>>> +	 * Initialize passthru_pmu with the core pmu that has
>>> +	 * PERF_PMU_CAP_PASSTHROUGH_VPMU capability.
>>> +	 */
>>> +	if (pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU) {
>>> +		if (!passthru_pmu)
>>> +			passthru_pmu = pmu;
>>> +
>>> +		if (WARN_ONCE(passthru_pmu != pmu, "Only one passthrough PMU is supported\n")) {
>>> +			ret = -EINVAL;
>>> +			goto free_dev;
>>> +		}
>>> +	}
>>
>>
>> Our intention is to virtualize IBS PMUs (Op and Fetch) using the same framework. However, 
>> if IBS PMUs are also using the PERF_PMU_CAP_PASSTHROUGH_VPMU capability, IBS PMU registration
>> fails at this point because the Core PMU is already registered with PERF_PMU_CAP_PASSTHROUGH_VPMU.
>>
> 
> The original implementation doesn't limit the number of PMUs with
> PERF_PMU_CAP_PASSTHROUGH_VPMU. But at that time, we could not find a
> case of more than one PMU with the flag. After several debates, the
> patch was simplified only to support one PMU with the flag.
> It should not be hard to change it back.
> 
> Thanks,
> Kan
> 

Yes, we have a use case to use mediated passthrough vPMU framework for IBS virtualization.
So, we will need it.

- Manali

>>> +
>>> +	list_add_tail_rcu(&pmu->entry, &pmus);
>>>  	atomic_set(&pmu->exclusive_cnt, 0);
>>>  	ret = 0;
>>>  unlock:
>>
>>


