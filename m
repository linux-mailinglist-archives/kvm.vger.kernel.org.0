Return-Path: <kvm+bounces-31604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C7399C5199
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 10:13:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2DBB41F22746
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 09:13:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13FA1206042;
	Tue, 12 Nov 2024 09:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="djNhM/dR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704CE20A5C7
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 09:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731402816; cv=fail; b=gyH8zkK7xXqHc7cK6bBr6cIZw+DxJzOhQpli/SuPYSSyYJDMgUk8pz16K9akdVuis8uSd697nb4f2vP/fG59eBj+CF6VvIuE78gxRDm0N+KF8b8ldWUbNSEhyajRAFZ7r33VM3Kud6x9VcHkTGJzF0vu88I7+up4Z6PrvkYkUZU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731402816; c=relaxed/simple;
	bh=mrF/erF3meVu8OjRUT2pgP6OhJhYhMritOacwvizTyo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=juyKu0L5WG8LUQEJ+1eKUAjBJi7ZI4ewuBCS3gy9Ikl1YH0HbRfj+MqMYWxlT+ST+qFP7z9ZJ1zp59klEczslQ5w9hSotzQ4wrzsJqry16YmPj9HeGTZ5fLhZac/QFBVC0hMP+vG74xvVVS4d8lKYuvP1LU5k9XuNkHnWkNNnmY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=djNhM/dR; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731402814; x=1762938814;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mrF/erF3meVu8OjRUT2pgP6OhJhYhMritOacwvizTyo=;
  b=djNhM/dRK0Nksj5SjaWi9bvU4YXXk7p8h7SKDBWU97x8gzVkTkvjgEit
   t7v7hmHxV28mRh4y/kHjJ0nv7Y+LHeK7GPoTe33yoc0p9GlSrcHDXXDsZ
   tZIZWPxjGaBYksTx0ZdNwztOZ2Hrvd8xsmYsnOf2+t/x3Vf6Sl2jdlQxz
   L6KV3M2ZB2Rq490I0BOOlHHO+4TNvCjmVmPh2J/G+HvPF/xIhzZwHzynd
   mOsz2tVYDNAN3Cfv9BuXGaL5IG7qgjlzZPMESzOy0Z9OkiF8L+/ROS8Px
   hmseLLglf35a1+gMGI56sqnlHh2jsQB+bDkJudPtk6xm4Za4wcBMsPUac
   Q==;
X-CSE-ConnectionGUID: sh5r8wMjRkiAx72Y+VvM8g==
X-CSE-MsgGUID: WbvoZzizS4iO2ri/ZgJ56w==
X-IronPort-AV: E=McAfee;i="6700,10204,11253"; a="18838298"
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="18838298"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2024 01:13:33 -0800
X-CSE-ConnectionGUID: gjOwM0A1TMGjjZs9pWLgjw==
X-CSE-MsgGUID: YLxvSe+zTFexZrS/yO3pLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="87769556"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Nov 2024 01:13:32 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 12 Nov 2024 01:13:32 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 12 Nov 2024 01:13:32 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.45) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 12 Nov 2024 01:13:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ho4cNbtTHnTFil3iOHj5sZgKbNDUq+UBXhvj8UfBqcnC4HykcyaMWaZR58HLgK1x9yfupJKTzLgpKtX0Ag6DeTtH5+PV4COgvdKUeVI8XHe7CehrfiBS6dmg2/gqktZAY+DTg1/+ClcR1jlpWhOBHR5Ie0XtNLKWPE2RQYUitfkPJwUDf3ULUWzL7PEP2qn/7+hr4jOyrtX4VsGYmH7qU8X+OE2uSoEBSY+kjy4ohMgurhHDQIJ+gAIv35J1Wxp6IBKE2HLqTlLSGdXQswVpQArYZX2liSkF9z7kp9hb+1AQavLWtJcQxjuCagaL5zltSIG3fQE2wQDkpi4ZTOfHTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zVxMyQl+E/DxI2PdmrHisbCtlnXLJTBnocUTTqwYTRA=;
 b=po8ulzbBL+2PjJViF+hvQ3WJzw1zxavOmXWuB1qMXbdE5n3EmTLzXoIwwVMbSRHYUHKYu5tAz9HpFvEnQIt13vGqDt/l8LgucfL66sZRZCDPG0kD+ZKrsfvQG4uEQNy8bUbTcI3LpkgwgODsGd/VB8ntGJ0GnWQaHHgFZf6ZZgfybtraLGvwYX74I7rOvYQdQ9eILser3k0IoEPe6oHAhvePasSB8g7oozfCWwUwaFCigV0SwKuJ2HTejWco++IA3/aI+Ct6wFJ2klrTXBgZD7RzlQZBFgOk221wwz6GMeCBR5v2GY18kueB+gLMjMxD0I/66gZYZhA4ARcyCpbeVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7540.namprd11.prod.outlook.com (2603:10b6:806:340::7)
 by PH0PR11MB5029.namprd11.prod.outlook.com (2603:10b6:510:30::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Tue, 12 Nov
 2024 09:13:30 +0000
Received: from SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::399f:ff7c:adb2:8d29]) by SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::399f:ff7c:adb2:8d29%3]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 09:13:23 +0000
Message-ID: <9d88a9b9-eeb5-49e5-9c59-e3b82336f3a6@intel.com>
Date: Tue, 12 Nov 2024 17:18:02 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/5] vfio: Add vfio_copy_user_data()
To: Alex Williamson <alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <kevin.tian@intel.com>, <baolu.lu@linux.intel.com>,
	<joro@8bytes.org>, <eric.auger@redhat.com>, <nicolinc@nvidia.com>,
	<kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<iommu@lists.linux.dev>, <zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>,
	<will@kernel.org>
References: <20241108121742.18889-1-yi.l.liu@intel.com>
 <20241108121742.18889-5-yi.l.liu@intel.com>
 <20241111170308.0a14160f.alex.williamson@redhat.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20241111170308.0a14160f.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0053.apcprd02.prod.outlook.com
 (2603:1096:4:196::16) To SN7PR11MB7540.namprd11.prod.outlook.com
 (2603:10b6:806:340::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7540:EE_|PH0PR11MB5029:EE_
X-MS-Office365-Filtering-Correlation-Id: c1d1bd8b-f430-4029-a907-08dd02fa427f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SW9QMVdxTWlwdEkzVVdHZGNFa1BKakhCMEdtTWpaaTk1M2tPZ2gva05EK21H?=
 =?utf-8?B?cGdlV29XYlE1aUM0czhMZHBqZmVhR09NUEFQY0NFUFNwYm1ESEhkU280b1Ey?=
 =?utf-8?B?dEFYRUlBbDR1RTVKSFdBWEs5d0xrZ0NhVmp2cW15c3ovWmh0U1krWlNvaFVQ?=
 =?utf-8?B?cFk0NXRkdFZGNUNjekRjQnJCelRBN0o0a09lYXhJbXlVcGhYanBlazJ5VHpM?=
 =?utf-8?B?dSt6SkYxNG83YkxvREE1R2diaDE2SXAwWnRmdFhMalZ4QWV6WStlZGdoTDhE?=
 =?utf-8?B?VFMyc2c3MktYeW1sZU5vM2MyQjNyWG5PQ1FxSFhsRnZZT0padEFKbHk2endU?=
 =?utf-8?B?UjZWMTRUa2t3MElUNFlqYnB6cGRuVzdmZitUNjF0M2c3NFRLZmVZM0lRS1Zu?=
 =?utf-8?B?T2pwSUNQMHNxamxLUk1DeXpUcnUyRTJLSHUwbmkwaVozZW5zQnUxUzFzOUFY?=
 =?utf-8?B?cXpaUkRJZjFXOENQUWlZYkE4TWYxcnJHUzVWdWlRQnNwbnQxNjlOaWZZUzlM?=
 =?utf-8?B?aEZtSDZ3NGRyYVJHRXZ2VXpRdUJsQmlwUXQxQmRWMk1YVjBDdFkyS0ZRNzRC?=
 =?utf-8?B?TmNwUFJLUFRTdDhjNUdFSHRQK2JJQXVydzhXeTcyM0xqdHl4ZWJabnlldTcz?=
 =?utf-8?B?M3Zpd2tSNnBnNnRPZm1CMk1QY1laRWMyc0ZVaGdURC9rbmljQTdLdWRwQzh3?=
 =?utf-8?B?SGFYRkNHeFh3V0pPb1RXMk1VeEliQW1OOUZ4VFc0VnJNVlFPOEhRKzFvcjJD?=
 =?utf-8?B?ZXZHaDNvM3p1VFRqVnYvck5XdTJ3NXY2enNZMUtBUnJ6NVUyUXhSSEpNTFpO?=
 =?utf-8?B?OXF5aUVyclJIOHN0SHh1bVZiYUcyT0xuOThsdy8xQ1BudzJsUkU2MFR4NGY1?=
 =?utf-8?B?aDEwM3BIcW5Dak5MakxpeXJuSlI1TVk4V28wK3lpaVlaTGp0WHc5VmszUDNM?=
 =?utf-8?B?bkxlL3NJTFdNRW1DdERkY2hzdUlQRkF0bUdBVWRvaDRMelJPcUNZVTh0ZGFt?=
 =?utf-8?B?M0trTlNZY2hhQ1p6aVllQVdRNEwxOTBOblJsVjR1L1pYc2l3UCsyVzE1T3NI?=
 =?utf-8?B?ODZ0SFllYzQ4SUtVdDFLKzVqdS9ZUmJtd1l4OXJXV1dtMUhFUytHTWxSNWVZ?=
 =?utf-8?B?M1Z4S0lLVXJDOTM4M1JjUENIT0lMTyt3Znl0R2I1K1NtaW5KM0NzVDhLTCt4?=
 =?utf-8?B?c0NpVDhLS0VTYVluL0kyRFlxUzQwaTNiUW1rNVBFckFZMUI3NjBIMXhGaVRk?=
 =?utf-8?B?Y2pPMng1YmMvNmRZNUo4NDIzZE5WVzlvSm5UeVdjMnQwZGU2WTNQMnh3ZnI0?=
 =?utf-8?B?UVhSTFFNMTR4YVYxNmd6L1JGcEt2YVdrd2FpQU1RRnN0bG9kZ3dsZ2tNRlRm?=
 =?utf-8?B?YkwrR05FcFFGbUMzQUNkWDJvVzVXSjdtMmlkN0Z6SmpKRVlVeksvUmJpT2k4?=
 =?utf-8?B?SDhUeW9QdTdBakltOXVVQ0hCOWNZMzZqUzFSSjd5Y2E2Rk1EaFdNM1lhZkpL?=
 =?utf-8?B?YUUwZ2diWll2MHk3dFRuYnB5eU1ZRWdaZXZENGtRWU5UTnFlREJNNmhNNEhv?=
 =?utf-8?B?ZlZWb2NMK3F4RlBNUjU1TlR5Uk16SkxmeXg1Z2pIaWx0SWc3L0ZXVnJRK3k4?=
 =?utf-8?B?MXhLdU9FOGVWazFIYVpiSEFJQ09VQ0d5TE5QdHc5ZXBOZ0ZtckU1TjUwWno1?=
 =?utf-8?B?b0lMQTc0NXl2UEx5bTRYTG00RmFCbjIzdmJvdno3dlVIZU9YZGhhNjBWUjJH?=
 =?utf-8?Q?/U+GJCmeG+9zlhPsb4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7540.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?azZKTUNScitKTDFBWTFVL2R6cWdHd0FZQUV4TEh0T09VTFlvV1FTVDJaTHlq?=
 =?utf-8?B?SStqbXEvcURWa3kzcHNMc2VGR3l2akluV0tzamFVVGFmUS9oUTlISGlBdlBJ?=
 =?utf-8?B?SWFITVBlZVNnWXFEQzlTTW1pTElJL3hodXIyRFNkWHRJUldYNGtFWWxCK0hS?=
 =?utf-8?B?a3Q5Q1VjK0h4Zm80ei82cXBQNW9rTnlSY0tvbncwNzJMbUpHWUZrK3ptL0lv?=
 =?utf-8?B?ZEQ1UjBFWm1jRi9CKzV1TStRd0hRRzBkUVZ2Y1BuSnRIRlhIOVBuVng4UE5B?=
 =?utf-8?B?dVZRY1hmOHNnTEErYldOZkRPZVVnbFpYV0FiWWRYcllIamVWVFBaUmplcHRD?=
 =?utf-8?B?V2pFWjZlRkpFdlJWdU5FTG0wVStQY3dJV2pjM1N3YWhXbU5MZlFadWF0WVIr?=
 =?utf-8?B?bDFndUVZZU5ra3VqMDQxMWhpSGVYYXBObXJOTDdmOWJETzFlbW5GTWJrUjZ0?=
 =?utf-8?B?L25USWcwRExtZytueHVsZnBVTHYva1lnOFdyVm55dmZDeC9XRkpITVNQb0NJ?=
 =?utf-8?B?L0d3T1FaR25sOFJzL3pQQ1pBc0VZSkVFbGlxL3VWd0RDdVFkbzRvUmR4SjRt?=
 =?utf-8?B?MFViSGVxZTdkdFMwd2dtdUs4clBzZGdwQUxoV3ladmoxU2prOUpIaEVUT0hP?=
 =?utf-8?B?cmtIU2ZKRm9OVnQ3NkNSdk9NVENxcDZXQVZsby9xV1FlVmZ0ZURtRWMvd2ZM?=
 =?utf-8?B?MGlyQXFnNmdubnNOdmpxNk4vcmZvZDVKTC96SVV2dzlKem54anR1UllDaXBG?=
 =?utf-8?B?cWNDZjR2Y2dGRFBOYjlKYjRJUElVZSttZEwyT3d4bVRKTEJpNnM5UCtOMllW?=
 =?utf-8?B?TjVtdHk5ZkpvUHVYUG5jNmQ0UlJmQ0liY3NjbGw4emxrL25RaTZkVlF3bkMv?=
 =?utf-8?B?NWFFb3VXQnN5UHZtTnNDcTc1RjdMZ2JaZXNNYVlMdjUxd3BaaG9XdHNPLyty?=
 =?utf-8?B?dWxrMWg2K1BxaWhkYXNyV2IrV0NQZ2xOQm5vamxVZFhqWWJQdmdSS0NZNHlI?=
 =?utf-8?B?NG1WMTNzUnUxaUtKckxCalNFNkpWUjgzT1NkQWVOVHZQUXhqUzBZS1dtZlkv?=
 =?utf-8?B?YmNHczNjSmpSMmh4ODVZK241N2o5S2JoZDArRHEwT0cwNFlkeW1rNVM3RzR2?=
 =?utf-8?B?dkpPK2lQVG1STFJJcHhhblNxdXlYR3p4Y1dXNW5IMlk1NjhIbTBxZ0NKais2?=
 =?utf-8?B?YVdHUitwTyt1VGlHTXJPMEJ5Q09FWkg1eEh6ZW5LVFlodmNJQmwrL2tSUzJI?=
 =?utf-8?B?dU9rMGpMNjhaditHaXNJRkE1WTJtKzZNUmQrZHZJVm8yVFdwOEZBZUx3NHJV?=
 =?utf-8?B?QnNrZGxRQVEvZ1ZtbkYvY3RZZ1AwR2czWE5rdXlmRmQvZzc2TE5FS0E1QUg0?=
 =?utf-8?B?ZkVpOStuTVZKRUdqclM0R2Vjblcxc2k1Y1ZXckxNNVlqcUpKSmRzQVNYQkpI?=
 =?utf-8?B?Znp6a2tHSkdUeEJWNm9KOTllSkRKTTVtbExzRVBxNUhWOUdEWjhIaTkwZGZF?=
 =?utf-8?B?NGxNVUVRWldSQi8yc3VIaHA2YzRZN1RNVW5ra05oSS9RaS9iZlVVQ0RBTmxr?=
 =?utf-8?B?cWNqc0F4MHRheG1qdmcyNUtMMVRSWWRuVTRMNnlVMElDc2R6b2NsR1JGOGVx?=
 =?utf-8?B?bEhUY1dERUdhTWl6cVgreHJWdU1EVXhDZktxRTBRWFFobzRadFI3QzMzVjVy?=
 =?utf-8?B?aW1YVTlld1pibDNKZ3hEVmlVUnpKTERWd25rdjFObkw3aldLeVlacFVwbDlr?=
 =?utf-8?B?ZXdVRHg5WFlPU252ZjlzMkUyNjZZdnlYTTFvL0NXdXlyQUwxUDFtdFhrV3l2?=
 =?utf-8?B?RkdRdm5ndnpEbWF2U2NTM3cvVUhDYm9KUFNXTWk2aWFUbkk4R1Y1bytaYzZF?=
 =?utf-8?B?aUtzVTM1SmFibWR1a0toZERMM0Zwa1U5V1lGdHJ1TlJQUDNVVWRwbm9pUHZZ?=
 =?utf-8?B?VWxMV3I1dTA4aG1QNi83R1VuSXZjR3JFTmJEWC9hZ1lXcU5nTTF5cG9wdXVM?=
 =?utf-8?B?OE80L05sTzh2eHVzMERaWlpyMjB2ZjBZN0VYNWxtOEN1WGJUc0gvNHNnL05U?=
 =?utf-8?B?MTM2WjJUeEVmWnI3OUxKbnlNUVBmUTZleEhOSjNIc2gwcFVuUFB4T0MydjJV?=
 =?utf-8?Q?RyZynqQL4xZwcLqNCMueXvx66?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c1d1bd8b-f430-4029-a907-08dd02fa427f
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7540.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 09:13:23.8417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ahgTM5KIfwUKm8TcAeqvTLFupgTBKrQnaJY1pk0vG1k/EiGUa8XYHJgUMF4Wb7o1fKOSHiGcpQL6DOo1KClRyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5029
X-OriginatorOrg: intel.com

On 2024/11/12 08:03, Alex Williamson wrote:
> On Fri,  8 Nov 2024 04:17:41 -0800
> Yi Liu <yi.l.liu@intel.com> wrote:
> 
>> This generalizes the logic of copying user data when the user struct
>> Have new fields introduced. The helpers can be used by the vfio uapis
>> that have the argsz and flags fields in the beginning 8 bytes.
>>
>> As an example, the vfio_device_{at|de}tach_iommufd_pt paths are updated
>> to use the helpers.
>>
>> The flags may be defined to mark a new field in the structure, reuse
>> reserved fields, or special handling of an existing field. The extended
>> size would differ for different flags. Each user API that wants to use
>> the generalized helpers should define an array to store the corresponding
>> extended sizes for each defined flag.
>>
>> For example, we start out with the below, minsz is 12.
>>
>>    struct vfio_foo_struct {
>>    	__u32   argsz;
>>    	__u32   flags;
>>    	__u32   pt_id;
>>    };
>>
>> And then here it becomes:
>>
>>    struct vfio_foo_struct {
>>    	__u32   argsz;
>>    	__u32   flags;
>>    #define VFIO_FOO_STRUCT_PASID   (1 << 0)
>>    	__u32   pt_id;
>>    	__u32   pasid;
>>    };
>>
>> The array is { 16 }.
>>
>> If the next flag is simply related to the processing of @pt_id and
>> doesn't require @pasid, then the extended size of the new flag is
>> 12. The array become { 16, 12 }
>>
>>    struct vfio_foo_struct {
>>    	__u32   argsz;
>>    	__u32   flags;
>>    #define VFIO_FOO_STRUCT_PASID   (1 << 0)
>>    #define VFIO_FOO_STRUCT_SPECICAL_PTID   (1 << 1)
>>    	__u32   pt_id;
>>    	__u32   pasid;
>>    };
>>
>> Similarly, rather than adding new field, we might have reused a previously
>> reserved field, for instance what if we already expanded the structure
>> as the below, array is already { 24 }.
>>
>>    struct vfio_foo_struct {
>>    	__u32   argsz;
>>    	__u32   flags;
>>    #define VFIO_FOO_STRUCT_XXX     (1 << 0)
>>    	__u32   pt_id;
>>    	__u32   reserved;
>>    	__u64   xxx;
>>    };
>>
>> If we then want to add @pasid, we might really prefer to take advantage
>> of that reserved field and the array becomes { 24, 16 }.
>>
>>    struct vfio_foo_struct {
>>    	__u32   argsz;
>>    	__u32   flags;
>>    #define VFIO_FOO_STRUCT_XXX     (1 << 0)
>>    #define VFIO_FOO_STRUCT_PASID   (1 << 1)
>>    	__u32   pt_id;
>>    	__u32   reserved;
> 
> I think this was supposed to be s/reserved/pasid/

you are right.

>>    	__u64   xxx;
>>    };
>>
>> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>> ---
>>   drivers/vfio/device_cdev.c | 81 +++++++++++++-------------------------
>>   drivers/vfio/vfio.h        | 18 +++++++++
>>   drivers/vfio/vfio_main.c   | 55 ++++++++++++++++++++++++++
>>   3 files changed, 100 insertions(+), 54 deletions(-)
>>
>> diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
>> index 4519f482e212..35c7664b9a97 100644
>> --- a/drivers/vfio/device_cdev.c
>> +++ b/drivers/vfio/device_cdev.c
>> @@ -159,40 +159,33 @@ void vfio_df_unbind_iommufd(struct vfio_device_file *df)
>>   	vfio_device_unblock_group(device);
>>   }
>>   
>> +#define VFIO_ATTACH_FLAGS_MASK VFIO_DEVICE_ATTACH_PASID
>> +static unsigned long
>> +vfio_attach_xends[ilog2(VFIO_ATTACH_FLAGS_MASK) + 1] = {
>> +	XEND_SIZE(VFIO_DEVICE_ATTACH_PASID,
>> +		  struct vfio_device_attach_iommufd_pt, pasid),
>> +};
>> +
>> +#define VFIO_DETACH_FLAGS_MASK VFIO_DEVICE_DETACH_PASID
>> +static unsigned long
>> +vfio_detach_xends[ilog2(VFIO_DETACH_FLAGS_MASK) + 1] = {
>> +	XEND_SIZE(VFIO_DEVICE_DETACH_PASID,
>> +		  struct vfio_device_detach_iommufd_pt, pasid),
>> +};
>> +
>>   int vfio_df_ioctl_attach_pt(struct vfio_device_file *df,
>>   			    struct vfio_device_attach_iommufd_pt __user *arg)
>>   {
>>   	struct vfio_device_attach_iommufd_pt attach;
>>   	struct vfio_device *device = df->device;
>> -	unsigned long minsz, xend = 0;
>>   	int ret;
>>   
>> -	minsz = offsetofend(struct vfio_device_attach_iommufd_pt, pt_id);
>> -
>> -	if (copy_from_user(&attach, arg, minsz))
>> -		return -EFAULT;
>> -
>> -	if (attach.argsz < minsz)
>> -		return -EINVAL;
>> -
>> -	if (attach.flags & (~VFIO_DEVICE_ATTACH_PASID))
>> -		return -EINVAL;
>> -
>> -	if (attach.flags & VFIO_DEVICE_ATTACH_PASID)
>> -		xend = offsetofend(struct vfio_device_attach_iommufd_pt, pasid);
>> -
>> -	/*
>> -	 * xend may be equal to minsz if a flag is defined for reusing a
>> -	 * reserved field or a special usage of an existing field.
>> -	 */
>> -	if (xend > minsz) {
>> -		if (attach.argsz < xend)
>> -			return -EINVAL;
>> -
>> -		if (copy_from_user((void *)&attach + minsz,
>> -				   (void __user *)arg + minsz, xend - minsz))
>> -			return -EFAULT;
>> -	}
>> +	ret = vfio_copy_user_data((void __user *)arg, &attach,
>> +				  struct vfio_device_attach_iommufd_pt,
>> +				  pt_id, VFIO_ATTACH_FLAGS_MASK,
>> +				  vfio_attach_xends);
>> +	if (ret)
>> +		return ret;
>>   
>>   	if ((attach.flags & VFIO_DEVICE_ATTACH_PASID) &&
>>   	    !device->ops->pasid_attach_ioas)
>> @@ -227,34 +220,14 @@ int vfio_df_ioctl_detach_pt(struct vfio_device_file *df,
>>   {
>>   	struct vfio_device_detach_iommufd_pt detach;
>>   	struct vfio_device *device = df->device;
>> -	unsigned long minsz, xend = 0;
>> -
>> -	minsz = offsetofend(struct vfio_device_detach_iommufd_pt, flags);
>> -
>> -	if (copy_from_user(&detach, arg, minsz))
>> -		return -EFAULT;
>> -
>> -	if (detach.argsz < minsz)
>> -		return -EINVAL;
>> -
>> -	if (detach.flags & (~VFIO_DEVICE_DETACH_PASID))
>> -		return -EINVAL;
>> -
>> -	if (detach.flags & VFIO_DEVICE_DETACH_PASID)
>> -		xend = offsetofend(struct vfio_device_detach_iommufd_pt, pasid);
>> -
>> -	/*
>> -	 * xend may be equal to minsz if a flag is defined for reusing a
>> -	 * reserved field or a special usage of an existing field.
>> -	 */
>> -	if (xend > minsz) {
>> -		if (detach.argsz < xend)
>> -			return -EINVAL;
>> +	int ret;
>>   
>> -		if (copy_from_user((void *)&detach + minsz,
>> -				   (void __user *)arg + minsz, xend - minsz))
>> -			return -EFAULT;
>> -	}
>> +	ret = vfio_copy_user_data((void __user *)arg, &detach,
>> +				  struct vfio_device_detach_iommufd_pt,
>> +				  flags, VFIO_DETACH_FLAGS_MASK,
>> +				  vfio_detach_xends);
>> +	if (ret)
>> +		return ret;
>>   
>>   	if ((detach.flags & VFIO_DEVICE_DETACH_PASID) &&
>>   	    !device->ops->pasid_detach_ioas)
>> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
>> index 50128da18bca..87bed550c46e 100644
>> --- a/drivers/vfio/vfio.h
>> +++ b/drivers/vfio/vfio.h
>> @@ -34,6 +34,24 @@ void vfio_df_close(struct vfio_device_file *df);
>>   struct vfio_device_file *
>>   vfio_allocate_device_file(struct vfio_device *device);
>>   
>> +int vfio_copy_from_user(void *buffer, void __user *arg,
>> +			unsigned long minsz, u32 flags_mask,
>> +			unsigned long *xend_array);
>> +
>> +#define vfio_copy_user_data(_arg, _local_buffer, _struct, _min_last,          \
>> +			    _flags_mask, _xend_array)                         \
>> +	vfio_copy_from_user(_local_buffer, _arg,                              \
>> +			    offsetofend(_struct, _min_last) +                \
>> +			    BUILD_BUG_ON_ZERO(offsetof(_struct, argsz) !=     \
>> +					      0) +                            \
>> +			    BUILD_BUG_ON_ZERO(offsetof(_struct, flags) !=     \
>> +					      sizeof(u32)),                   \
>> +			    _flags_mask, _xend_array)
>> +
>> +#define XEND_SIZE(_flag, _struct, _xlast)                                    \
>> +	[ilog2(_flag)] = offsetofend(_struct, _xlast) +                      \
>> +			 BUILD_BUG_ON_ZERO(_flag == 0)                       \
>> +
>>   extern const struct file_operations vfio_device_fops;
>>   
>>   #ifdef CONFIG_VFIO_NOIOMMU
>> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
>> index a5a62d9d963f..c61336ea5123 100644
>> --- a/drivers/vfio/vfio_main.c
>> +++ b/drivers/vfio/vfio_main.c
>> @@ -1694,6 +1694,61 @@ int vfio_dma_rw(struct vfio_device *device, dma_addr_t iova, void *data,
>>   }
>>   EXPORT_SYMBOL(vfio_dma_rw);
>>   
>> +/**
>> + * vfio_copy_from_user - Copy the user struct that may have extended fields
>> + *
>> + * @buffer: The local buffer to store the data copied from user
>> + * @arg: The user buffer pointer
>> + * @minsz: The minimum size of the user struct
>> + * @flags_mask: The combination of all the falgs defined
>> + * @xend_array: The array that stores the xend size for set flags.
>> + *
>> + * This helper requires the user struct put the argsz and flags fields in
>> + * the first 8 bytes.
>> + *
>> + * Return 0 for success, otherwise -errno
>> + */
>> +int vfio_copy_from_user(void *buffer, void __user *arg,
> 
> This should probably be prefixed with an underscore and note that
> callers should use the wrapper function to impose the parameter
> checking.

got it.

> 
>> +			unsigned long minsz, u32 flags_mask,
>> +			unsigned long *xend_array)
>> +{
>> +	unsigned long xend = minsz;
>> +	struct user_header {
>> +		u32 argsz;
>> +		u32 flags;
>> +	} *header;
>> +	unsigned long flags;
>> +	u32 flag;
>> +
>> +	if (copy_from_user(buffer, arg, minsz))
>> +		return -EFAULT;
>> +
>> +	header = (struct user_header *)buffer;
>> +	if (header->argsz < minsz)
>> +		return -EINVAL;
>> +
>> +	if (header->flags & ~flags_mask)
>> +		return -EINVAL;
> 
> I'm already wrestling with whether this is an over engineered solution
> to remove a couple dozen lines of mostly duplicate logic between attach
> and detach, but a couple points that could make it more versatile:
> 
> (1) Test xend_array here:
> 
> 	if (!xend_array)
> 		return 0;

Perhaps we should return error if the header->flags has any bit set. Such
cases require a valid xend_array.

> 
> (2) Return ssize_t/-errno for the caller to know the resulting copy
> size.
> 
>> +
>> +	/* Loop each set flag to decide the xend */
>> +	flags = header->flags;
>> +	for_each_set_bit(flag, &flags, BITS_PER_TYPE(u32)) {
>> +		if (xend_array[flag] > xend)
>> +			xend = xend_array[flag];
> 
> Can we craft a BUILD_BUG in the wrapper to test that xend_array is at
> least long enough to match the highest bit in flags?  Thanks,

yes. I would add a BUILD_BUG like the below.

BUILD_BUG_ON(ARRAY_SIZE(_xend_array) < ilog2(_flags_mask));

-- 
Regards,
Yi Liu

