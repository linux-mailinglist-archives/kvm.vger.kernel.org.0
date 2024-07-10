Return-Path: <kvm+bounces-21281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2106D92CD3D
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 10:39:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9A4E2286D85
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 08:39:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2BC7143737;
	Wed, 10 Jul 2024 08:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="a5eKKS3h"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2074.outbound.protection.outlook.com [40.107.243.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B86C12BF23;
	Wed, 10 Jul 2024 08:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720600656; cv=fail; b=DyOMF4MuhAMgZe0h1BmwqJmYOQzi69zmPTOgK4xvkQVVHNCzMmd5bB9He6NGyGC4NEyok3yRg9McFhFNlKyEOpLFKXBmw26Ys0lcmJf2+T/TIqtN5h3ogtROEEOjfN7BtCn0gIjbFmoLNQWir/glanygetn7NJPCwk0fZ3DmOdM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720600656; c=relaxed/simple;
	bh=fCwuEVomkqd6fxFLvV2KXY4KFLQ3xTY0n4XIF+gX5j8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TvX5Z3W/YGtqbKIXe77EFN1eqfm+YmEUe2emMU5F8cdwCjUwNWy4mlmAu+gCf7CH3DNexVrv99btoWgmu0HsscRwyS+zGY7ksBMsSPf7JN6TEUrNsvvCU3lcqyeOx1pnLDFBLnDZ1AAfnupQ2+pS+/raWhAHBTP1Y9QC8aRHPwk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=a5eKKS3h; arc=fail smtp.client-ip=40.107.243.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f93zjiHjJrOLdhqXUKH/hrAziavxW+y/phCnnxiR4yxMV1PgEDq86jdaR9G0e2UfApUPvsvew8MiqjwMLK8AE+OKvOQZa4m2dXT77O++IhP2GDC8iRY7k6JEj9GoZQ3RPjRwndAomU3XEggqFBLlI9SeIqUM8m0Cs/AL4LyVouE0wWTDVxBKXuamHt8HYXV3o/IQLqR87SaexRS21v/9F6jb3FL1RCv69Spk0SR0/KW4jDIVt4eNm0j1/RWLCc01sfRCpLDVE0zn+ib+hWyl0XITtjsO+rismIjNdfWNFPOZlNBBggqx0F2dT+JbOw2iyaK0f1Ukj5zcmF+7SFg7QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nDzqdggFgufh2aF23cKP3MlHuf+XSIxUEQdQGvyYAuo=;
 b=c9c5Ubkzthuwg4vwLih/9vvKDKfOMJUOIpF6d7/krQaMmDm1VB84HPkRO7yh22dFFfmogM9C4tRhMbu8kccWVeQL7n4ouYJdm0mhHHHwL0pBjh3js26o9cHd1PwJyw+mSGEx28gcw6sbFRY5Fd6Ukm9g0CK26r20lJJv20kPtKJpGM3Rho7S+fRrE4QpQ5sk4G9Q4fWIhnem0l6N/fcBjglLi7a8ffgmaF+a7z1azQiRKdT9BAla/QR9xu0ODB9G/o2+UkLSm4xye4IoMfMrGemiPi2sbPPvWTv26HSwqIspDFQrSvaJ9ZsdMulnCmfTVw+XvI876eAuo3/PDrHhHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nDzqdggFgufh2aF23cKP3MlHuf+XSIxUEQdQGvyYAuo=;
 b=a5eKKS3h5l5sIMDbux+7QSyTc/3l8d2TmxcWNJ+xfJKQ5hK8GmsPir90zAkI4MVxzGfEYdcKtbXNgIuGwMshAi6Oijn83OPrJ7vmuqZOhDrBgrQJRatiBbye+ahCif06K5+JS911hp+yOqWM20lAeLjPBTh1JrxFjlCNbYj301A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB5713.namprd12.prod.outlook.com (2603:10b6:208:370::18)
 by CH2PR12MB4214.namprd12.prod.outlook.com (2603:10b6:610:aa::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.35; Wed, 10 Jul
 2024 08:37:32 +0000
Received: from MN0PR12MB5713.namprd12.prod.outlook.com
 ([fe80::bbe0:a58f:b02c:1427]) by MN0PR12MB5713.namprd12.prod.outlook.com
 ([fe80::bbe0:a58f:b02c:1427%5]) with mapi id 15.20.7741.030; Wed, 10 Jul 2024
 08:37:32 +0000
Message-ID: <18ff4f7d-3258-4fbb-8033-8edbf3fed236@amd.com>
Date: Wed, 10 Jul 2024 14:07:17 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 36/54] KVM: x86/pmu: Switch PMI handler at KVM context
 switch boundary
To: Mingwei Zhang <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>
Cc: Jim Mattson <jmattson@google.com>, Ian Rogers <irogers@google.com>,
 Stephane Eranian <eranian@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 maobibo <maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org, Manali Shukla <manali.shukla@amd.com>
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-37-mizhang@google.com>
Content-Language: en-US
From: Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <20240506053020.3911940-37-mizhang@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGXP274CA0007.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::19)
 To MN0PR12MB5713.namprd12.prod.outlook.com (2603:10b6:208:370::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB5713:EE_|CH2PR12MB4214:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b844498-d44a-43eb-603f-08dca0bb8a87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZDJ2V2NpM1BHRTNHYUVKM045SVZjNlFCN29UazRrOXFUeHBFcFlGQ3hDVkJW?=
 =?utf-8?B?V3ErbTBTSkhEeFNNMTJOd2tDMDdBZ2lVNTF1Y3o2d2UzRHpiWmpHQk9nVHA3?=
 =?utf-8?B?M21USStkYWxvc0RRcW9sRkFKVHcyL2h6Uy9ZVS9DckYrSU5LZndXZGs1dkx2?=
 =?utf-8?B?U3F3MVNTS3pvZTQwUFNxd3dmQlA2OUduc3RZc0dwNTNFd0hTNTdPTEd3NkZE?=
 =?utf-8?B?WUtLV3QwQWhkZFBMNWFpN1dwTXVYWGlrbGYyWnhOT1psMFJtQ3lBbytQSUdp?=
 =?utf-8?B?eVRFVFNPQ3B1L0h0cFZFeDc1ejJodEVDMmlvRzEya1dKd0JOM2NkYWdhMVM4?=
 =?utf-8?B?aVYzYkJKanpPdGVKOWE2SnZTVFhqZjJtOUtLaEFhK3N6VHc3NzM1ZlRacC9p?=
 =?utf-8?B?K0dUSlJJZGFYQjk0MmRCUGNueVVVUDgxRkRLWFlIUWQzbExNMFFEbW1yMzdx?=
 =?utf-8?B?RTVhT0s5OXRTdHUyQzArZ3dhcTV2V0ZWSzBJejZnQitBU3BVQVR5UHc1N25w?=
 =?utf-8?B?RVVtdHN5OUFrZ2JQL2tzVVBPUW9wYkJ0ZjVaYlFhRTdMNVhxdktyeEg5eEdN?=
 =?utf-8?B?WDluTE14dkV4bSs3ZGFFR3VOSFI0K3FIWVN6V3FSbmlTb0lKRVpFM1gyVHpV?=
 =?utf-8?B?VW4ydkEzb1g3cUx1ZkR6UWwvblhlYUR2QTF0Nk1lZlV0T1pySEdOVDhiTFN4?=
 =?utf-8?B?SGJSd3Jmdm9hZzY1VXVqYitmRUwyT1lzT1V3bDNYN3FSWmJwWDkyU05xN2ZO?=
 =?utf-8?B?ZWRpa3ZKSXJsMzJUVTFDRFBVUDVtS24xUzRZR2NEdnJkN1Eva0pFc0RsWHUr?=
 =?utf-8?B?K0h1Zkx4dGxWVlFYRkdQYnBNbEJUeXZXdlRCK21JaFlXSndHNU5yVWFNMVlT?=
 =?utf-8?B?UzNuT2xtbm1RczdpNEwzYUhTbEhSQWFzRDFiaDh0bDlhZVpIdlBOSHVPVGJ0?=
 =?utf-8?B?NlUyWU9Ia1lzY3RzUTZyL3ZMWW9oSXptTU9DOXk5SWFVdGhNSEg3T0hsZU9t?=
 =?utf-8?B?Z0FVU2Z5ZkEwdWUzWlBneFpNcmdYRmc3WS9nb3puQjlWdnoydm1xQ2pyVExQ?=
 =?utf-8?B?cWVyaUJHTkZSVlZvSzM4Mkl3S25hSzVOOVYrL0k5dW1VL3BBYkpNSUlsNThP?=
 =?utf-8?B?eG5jcTFYTXNuVkRYZFBpRGh6WHppaHUyQXBRdGExUnZoSWpidmpHS2U3d29M?=
 =?utf-8?B?YzJSMVJvbU1VL1RBclAyVTc1cytxeVlmT2hKeEVSeU5tZk11bnBDcXdBZ2Fv?=
 =?utf-8?B?NnJkY3NaWG4vejlIaHBDZE9qT0szNDg5YmVEUXR0SFE5YXNZZXhRSDhaUG5P?=
 =?utf-8?B?VmtBamZ4ZkdCQ0JPL0drT3FLMlFQUnh6ZnhrTXROYWNFUnN3QVNOSE12cFRN?=
 =?utf-8?B?UjFpSTQ3QU9iem84bTV3aGRVcFd6NnBSR05zUldTenZHMnpXL2hCbG1YYWlt?=
 =?utf-8?B?TXBoNStBcmVwbUcxR0lHUHgvMFppODJuaFRkUjlQa3RGYVgwRTdKdkJuKzVz?=
 =?utf-8?B?OXJGMzduN1VncTJEREVRVkg0YzJpc1RRS1l1bmRwL3JpUEU3ak90SzRNZ3ox?=
 =?utf-8?B?S1FnNmZRQjVTeFlxRnpaSkVqL1VESWdJa0t4VVU0d3pmOEJ3eGd6bWJxbWNs?=
 =?utf-8?B?b0UwSngwRnlZMWIzSTJxL3VpYm00T0NCSFdSM0tmVGw0VnRFbTJGbUdIck9y?=
 =?utf-8?B?cExSV25tYy9udWZEc2VZVFQwQVduMUZsWXB1YnlYTmVYdHRsMTMxbFFHOHRr?=
 =?utf-8?Q?IHFZ0Dfi6VYPcucJR8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5713.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bDA1SndBMktPNnVkOUxqdkFDd3laZXhsZ0VUR3NpOEw3cGl3SUNRN3NZRUdh?=
 =?utf-8?B?MGxWNFZxT2pXYWVSK0pkS29STnUxSGpDWVNRSmlYVlI1dnVtQ2dqRCtyVDZr?=
 =?utf-8?B?RDIzaFFSdUliNGRITjlySkEvK01HT1FNVXJUckI3ZnZybXViNlRDS2hDaXhz?=
 =?utf-8?B?WVQyMjZMYmNZZ0Z6K1FqRFo2SzlHRGFKSDd1TkRacWhmM2ZpRGtwTFRxSlVi?=
 =?utf-8?B?bUdWamQyeUdsNU5KM1NYc2tIT05QRmo3NDhYTjc0a0VxUGtFekg1Nk5VWi9W?=
 =?utf-8?B?dkJGcHRzZHg3SjhWd1M1V0Zaa2RCY3BQQmlCL20yVEt4V1hnTUovWXIyVVU0?=
 =?utf-8?B?ajcxeVRXNEFieGN4Nys1emdtTWQzdjRVRlBVRUMrRTNma3BtcFFCc09zWnh0?=
 =?utf-8?B?a1ZuRU04VjRSeVhXU0FyM1U3aEdZeWN1aDlhSjBMREp4cGlGMFBWeGxCZ05u?=
 =?utf-8?B?UVpSSEFkbS9ITE1kaElvdWJ4clR0NCtLTkZpTy9DeThJaUFVTi9yWGpERVhO?=
 =?utf-8?B?OENRRVJOSHp5YmVHa1pLSWpRNGUvRllnVWtMQ2x0bXlkUDlCZUt2UjhHWlNh?=
 =?utf-8?B?WmR5MWM1Tm9qUnh2eUdKT0IwYnVrVC9OZ3JrTXFDRVBJaUJFaEZuUWlLMjFp?=
 =?utf-8?B?NVZSTk9EaW1uZ3FKMGRqRmxudmFJNDBpUjR3RDdaM0tzSGM0bFNmUGs5M1k2?=
 =?utf-8?B?aC9GeENKem9PRTJ5Nms5ZWh1bjFwSGx6TTJhcTB6blJQek5WeERMNHNIUHA0?=
 =?utf-8?B?Z3lxVnI0eXc3Vjlkd1ZYdGtrYVFQRGV6b2VTUnRKUElJOXcwSnJ5NVRCZGJJ?=
 =?utf-8?B?MXJXV2NhSG44bEdobEw2dS9sanVEQnpEenRZQ2xTYnBlNVN1c0lNV1Z4V21n?=
 =?utf-8?B?YS9EVnViUmNvMFhqOVk3Z2ZIQllTdWZ6a0ZHcWNnOEtxenpMWXVkN1YvNmpR?=
 =?utf-8?B?RFF2enZaR3NjcFhpbGNyVDZMTGFrY2ZqVjhPYm4xRVJHb3RpbmcxYk5VVHJs?=
 =?utf-8?B?YjJhdURqRnBjVXZnOGpFdnZmWWF3bURoN2c4TkFuWnlpRGo4b1JMWGFEMzBy?=
 =?utf-8?B?SndteHduRTVWSFdBSlNpVjF6eDFwdEJVeXdGd0p4QmYzYjM4UDRjZC9vZFNp?=
 =?utf-8?B?blhycjZLZUV5NUE1Q3pkT3ZxcU5XVlo4WVZHSjhNeVFTajV4bnVIK2k1ZG96?=
 =?utf-8?B?QWllSG9wYmFyYnpMVW9vMUtGUGE2eWVIWTYyN2xUK0EwVjdLYllGTWpqN2lh?=
 =?utf-8?B?NGlObEVnTzNnd0Vmbjk5NFAwWmQ3eitQRmlPaGRzOThndUJHblhPQVBuQldM?=
 =?utf-8?B?OVd2VGJ1SmFhNHlmM3JhNmx2b1ZxWlVqMjRzV0RVcXB5SEhWSzBWV0NFaFlJ?=
 =?utf-8?B?d05JMHNuSElYWVlhcjlRcldFVndrRVFvNGxrK2dDZmRlenM1RlNiQmhSNlhq?=
 =?utf-8?B?TlRKV0Q0M0V4UkFNVlJEa0RMT0xjVG1PejVxTXp2dk4vZnJwWnJzTmtsWTBQ?=
 =?utf-8?B?YkdZcmsxMlo0c0JIdngwbzBVbFhTajlnejZCUWJJYm5pazJoeS9vV1Z3T3hY?=
 =?utf-8?B?UHowbm9CN0did0JnbXRDR29peHdWZFcxZWgwbjRHSGFMRThTcHNKbTdFK0gz?=
 =?utf-8?B?L3R3Q25OUTYrb3BQRis1ajhlb05GNXYxL3ZFL1UrZTJBS1duT3lLc1JUWmtx?=
 =?utf-8?B?UVk4Rk1pb3dvbE14c0FwSlJiYnJWMmtqNTlTeTM2enRqN1lIVnFSYmVwNVRP?=
 =?utf-8?B?OUNmeXB3eE8wT1ZmWHUvbTFsMVhSdU1LcEdpZGpaaERGQlhWa01XdlN3TVZi?=
 =?utf-8?B?RldyY0tINE9DTFgvMlczekRjeWVFRnNlT2VFNUdxc2JMZXl3SmtaZW54cTQ3?=
 =?utf-8?B?U0U2OENqdkc2VEdUejZyb0Rqcm9MUjdib1NOS0w4MWx6VStXRGN5cEw0VXZW?=
 =?utf-8?B?Y2F3MHN5cm15Q3FKNmtUMTJDZWdVZHZRc051eVNHbFkvUkQ3UzNyNjBxSnhj?=
 =?utf-8?B?bFRyQlVHWlFSWjJTQ1JEa1FwT3drdUQxdVdjQVUzR2hSRUJtZUhxQmt0OUUr?=
 =?utf-8?B?MUFNbXRaMkhkZVhJMGwvREN2bkVDRTkrOXFVVy9zZFRTWnRTWTBKNHFyTGJ2?=
 =?utf-8?Q?HNwMDBLDg1uIxRXD9RqtFjoie?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b844498-d44a-43eb-603f-08dca0bb8a87
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5713.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2024 08:37:32.6666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 51fFdsLDe5ZS/+zpcr81m9PhZE21Ko+rrX+S7/Qsqjj6WWY+y/o5WzYhF72HYUxtYXKu0dkocMnzXEKD0AhR5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4214

On 5/6/2024 11:00 AM, Mingwei Zhang wrote:
> From: Xiong Zhang <xiong.y.zhang@linux.intel.com>
> 
> Switch PMI handler at KVM context switch boundary because KVM uses a
> separate maskable interrupt vector other than the NMI handler for the host
> PMU to process its own PMIs.  So invoke the perf API that allows
> registration of the PMI handler.
> 
> Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> ---
>  arch/x86/kvm/pmu.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 2ad71020a2c0..a12012a00c11 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -1097,6 +1097,8 @@ void kvm_pmu_save_pmu_context(struct kvm_vcpu *vcpu)
>  		if (pmc->counter)
>  			wrmsrl(pmc->msr_counter, 0);
>  	}
> +
> +	x86_perf_guest_exit();
>  }
>  
>  void kvm_pmu_restore_pmu_context(struct kvm_vcpu *vcpu)
> @@ -1107,6 +1109,8 @@ void kvm_pmu_restore_pmu_context(struct kvm_vcpu *vcpu)
>  
>  	lockdep_assert_irqs_disabled();
>  
> +	x86_perf_guest_enter(kvm_lapic_get_reg(vcpu->arch.apic, APIC_LVTPC));
> +

Reading the LVTPC for a vCPU that does not have a struct kvm_lapic allocated
leads to a NULL pointer dereference. I noticed this while trying to run a
minimalistic guest like https://github.com/dpw/kvm-hello-world

Does this require a kvm_lapic_enabled() or similar check?

>  	static_call_cond(kvm_x86_pmu_restore_pmu_context)(vcpu);
>  
>  	/*


