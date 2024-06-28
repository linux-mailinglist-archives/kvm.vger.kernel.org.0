Return-Path: <kvm+bounces-20629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 697FB91B5B3
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 06:25:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 099C4283DF7
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 04:25:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D95BA2261D;
	Fri, 28 Jun 2024 04:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oUlCiXGu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2080.outbound.protection.outlook.com [40.107.100.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA851C20;
	Fri, 28 Jun 2024 04:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719548743; cv=fail; b=MjPBqNGvp6RFjBAXk/+QoEyJEubJgR+C8mVytfwBSQ42WXtci216rLB0/ZHqBrqTj7pBNRNSg7QOLhRY4kE3cknmHpoEWdT42l1mExNwAZ7wCGnkp/tzLTSaN8BpbLSiAzyaNAAw2xm/i0U4l9yerNlUJTBFjUHeLbnYufLxfJ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719548743; c=relaxed/simple;
	bh=NG2uFlJ8XsN24VckrAWOAb/3EhCcmQC8bIeWAesE4fY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=o00XVa9vwnrCM2BjwxOmpvBSTmzKgxPoWzsJoIO2+6C4tZMxm9m5v8wRecUR1cYgqgmQt+f2Tv8nXAwNsmuAMIKm2EUshUxKdR3jdQy/NHeKZGXjfiKDqKlCWNjqCCgIrdBISGMb/P998qqCL0By/aJ6lv9fnax8LzEWtry7GLs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oUlCiXGu; arc=fail smtp.client-ip=40.107.100.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JYyrFct0jTbjky39IE0lMP52vlc+PhBzBs+oYLV+E6pMT1FdBZeCM8nY0a/c0ZSs4fvP4sQDsJJauf6oiAbTmV8TwtaEGSX5M10Xo3r5lZkvdXGW1OaJQtjGE6hTFkIe0bcrY9ksyaqP2bAD6Vgsh/BLyUDEaNsw2jW362XPLyeRtzno8Qx9aTUIqszOz6bV0l/NPlzwGoYyyW1iUWfjCcUwVLXnWDUSLcNVgIzMdybYHrNopzWPHGCYZtNFB9KMVxedlutig+ALYOmHle9rxe+X6c4UnpYigJNYy0gJseeJfcFcVl3hqkrMmXCPurnjTH4bJpgXgYl0pzXirnhnbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TG55GfOV4h88hr5n461q7taqSLAKvjo6xzhstBD2qtA=;
 b=T8W3vt2VECh4w0i3eqJb+t2NehZGEXysdOgHZiYtF3PdZg5P0X/qzz3QULg7/D6EylKHxay6DBkcsVc5BnWiZ+79uUdjdlinKJPpI0GPZGZRdCyZSPqWgCCbGK+4AU4/APHqkcXwTtxFOQ8tcHMMhlVo9xjkvw7YRIaZpzvZsdoN3liDeQj9xmzTIDumBM5BDwkHKCNQJhF/0WcgicoaTy90yrhGRQLR/I7kNR7FLrGBuJjRj95nQDPhS3W42J+oS1D1Ce4TdkRHvLx1bivEPUS5XrcpXxRijEeLN6NOzk7veEIrkydygrO0DUd07xPySvNKZVYS7doHdiWnXG9/1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TG55GfOV4h88hr5n461q7taqSLAKvjo6xzhstBD2qtA=;
 b=oUlCiXGuStV9JRlrCis/oUjH2mFS/YKNDT0ZC6RVv9ClRYo6kkM3yJcKrLGeuCQRyAkXYXQ8Y1jSDF39jPxGeUoxc1Xs9AhbK8WEHwt9WrhYQWlG5P/TpGByftcioWpL7Ep1hEm84jtgfX1dVxxanV/zMD3PO73emdN+mQNuk6g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 DM4PR12MB7621.namprd12.prod.outlook.com (2603:10b6:8:10a::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7719.26; Fri, 28 Jun 2024 04:25:38 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.7719.022; Fri, 28 Jun 2024
 04:25:38 +0000
Message-ID: <97f596b5-5ced-867f-5246-03345d06bed6@amd.com>
Date: Fri, 28 Jun 2024 09:55:28 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH v10 06/24] virt: sev-guest: Simplify VMPCK and sequence
 number assignments
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20240621123903.2411843-1-nikunj@amd.com>
 <20240621123903.2411843-7-nikunj@amd.com>
 <20240625170450.GMZnr4surYmBPd94lC@fat_crate.local>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20240625170450.GMZnr4surYmBPd94lC@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR01CA0179.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:d::22) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|DM4PR12MB7621:EE_
X-MS-Office365-Filtering-Correlation-Id: a01d7c66-daa6-4b05-4659-08dc972a5c83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VVU1aFlTNGppMk1KY2pOUHRSaVVmcHFsWGJjRXJyTkNmWDVtbXZrOWVBZlkz?=
 =?utf-8?B?QUZCcnJINEF1bURJWFNyVHN3MHpnOG5tRytGWExrdnAvUU95ZlVIc2pna1l4?=
 =?utf-8?B?Q2xZQkgvQTUrWUZyYjEwLzYveXlyZm0yTG9RdnRMWmpnQjRMU01wbVZrSmNP?=
 =?utf-8?B?VThtRVdOWklvQmVHL1VPbW5IL1NxOUJPRnlRRXZoSU04VlU5dWVkZUNuNUFn?=
 =?utf-8?B?K1ZFR0FpY01PdGtkV1VFSEo3Q0FycytrSFI4U1RwcUZ5OVd3aGZIUjYwR2w5?=
 =?utf-8?B?djR0MDNJY0FlVzhzNHkwK3NQL3BJU0twb1BuL09iODYxbXUzRFVXenJEQTQv?=
 =?utf-8?B?TFpNb0RzN0E5SlViKzVsN1R5b0lkR1JhdXVRM3Z1WFNiYVJaMElCTlVpdW15?=
 =?utf-8?B?YnFMdUxOMXZlQlJmS1BmYnhMb0FTcDhBaWFObzh2dkl2L0UxcUZxQjZzdjlP?=
 =?utf-8?B?U3N6QkEwREd0Z0cwWGl5VzA2R3pINjcrWlZrVkVnTGlCdnlXbmJZWXNDaGU0?=
 =?utf-8?B?aVgzcDg2K1hZc3lzeDZhRk9wSVhicmtNZHYyNHdJNURWM1EvajNzdkJkcFF5?=
 =?utf-8?B?YkNHNjhnekQvdXEyMlJlSnE2MitRWGhwWThONWkzdnNXdXFqUFhvOGhMbUlL?=
 =?utf-8?B?WjJBeHR3djM2dmgvWWlFNGNlMm1LMXJWUzhsTUFLSndYN0NSOEFnNDV6YXZD?=
 =?utf-8?B?OTN5RVJ4RWdyS2RMN3EvT3YyQlFlZk1uUEcxQnIvWXE2UDZRTXh0dkNaN1Za?=
 =?utf-8?B?Rkt4UU9xRlVxZjgrNkRvT0hJSEIrVkhScldQYjQxQVNUbm9nOG1TVjVYWHBk?=
 =?utf-8?B?dElHd3BrRm9OeVJJUm96R1pXbkRtQlQ0ZUVGSTYzSk1zeHpvaGxoZlEvSlJM?=
 =?utf-8?B?WUt1b1JGdm4xUmtYZFRUY1B0dUl1QkpYT3FGd1BpM2g4bzR2dytwVzBTN0dP?=
 =?utf-8?B?ekl2Um1hckN3YkowYVpKRXdRRS92SDZ5TGd2ekhRTkxXNlUzanU2QmRKVHNC?=
 =?utf-8?B?RzRHNVA1cWl5cU1TQ2FmUE9CeGU4bXdpT2JKY2UzN1VIQjlRZWwrYkM3UFlL?=
 =?utf-8?B?K0tOa2ZGWmtwZy9EdFg2VlFaRm54cDB6SjZjWnl6Y2FNVmVCbkdZQ3BWTzhM?=
 =?utf-8?B?Q1l3WEpwbGdqWnBOZTBjTXZyK3Uxek51YzZnNlBzMStKMkRldzJ2Rk40bDFR?=
 =?utf-8?B?dkpZdmt6cGR2bWwrb0xMV3N6TXE3dTV1eDFoSWJhcUgrQkpIL3U3VjFhWXl4?=
 =?utf-8?B?b1g2SnowaEtYclZ4Z1ltVVBYT2V4bGdaaHd6aEllelk5ck9oejB1bmlOK2ZB?=
 =?utf-8?B?QWJwRU5PT3Z6bWpEWG03c3pCb1AxZHp6NUNvRWZOeGVnRm5xTXovOUlSeUh2?=
 =?utf-8?B?bS9SR2oxamVpTVhPNW54NjJsRGlWTWpzQXByaU9PZDhJZGNzaDFNTnVzMWxS?=
 =?utf-8?B?ZGU5Zk9OMUdWbmFwT1NoenFndmFkcGRsaTIrbUZ1ajNiYVhQNlRkRWtyZFlU?=
 =?utf-8?B?NWtPZktlTSswenhyV0o0VzVnNFo5Q001djRkUVZPNy9RME51aU0raWJQd2ds?=
 =?utf-8?B?MytIaW9HSTQ0UzJOMGxrUmhiWTBTeFl6QkFSS2ZDSzVJblhQWm50YlM3QUNx?=
 =?utf-8?B?UUVlakNiUWM3dlF6VDZhd0hQei9hZGllS1FLTmxMRkFrallHYlp0WHNYNVBO?=
 =?utf-8?B?ZTlqR0UyQkNwcVdFSTdobWlnbG44WEtzQjc4V2lFdWkzbk1ncHhMR2xiTnRy?=
 =?utf-8?B?dWVjcG82Z2hFRkpRQlR2WWJpdzhVSmxYUVE5ZXYvU3pjQ0hPaVZiYWZtR0Z3?=
 =?utf-8?B?cE03VDNqejhpT25DTFF3UT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dE1oZHFtRERWVGRvR21YWmdnK3dqTG5FbXBRUE1IM2FVd0MzeUMzOXZob0Zi?=
 =?utf-8?B?QWhJVkNkVUtBd05VOG5RcDkvSDN6Nk9TcFlPU05Nay9ZbVJ5NnQxOFBrazVw?=
 =?utf-8?B?Vm5wK0E3bDY0WXNDQk0vSkFkOTdrdy9DcUZjRG5iV1ZoK2JlSmxiMzJIVk95?=
 =?utf-8?B?ZXVXeXdmekdRd1RxOXBUNHBZY1V1VXRuOHpsbmFZdkw1SE11VGxLZDR5eS8z?=
 =?utf-8?B?dmRwTk9UYkF3R0ZSdmJpV3RKa1FzU3ZJNk91MnJ4ZDY3d2dZNXpOY0RlcXJs?=
 =?utf-8?B?QXVRVE0veGxkVi9mOFVRcHEvMFNGL2dxZUtJbW92WXNmL2xDZkg0ZWoybUx1?=
 =?utf-8?B?WXlrTDNBVW5JT2wxb3oyUHMyMi9YRFE3QXhvSTBSNzU0Y2xEWUNYQjcxQjJy?=
 =?utf-8?B?M081enJNNG9KLys2YVIxWnJhbWFyc1N0Q1J1Qno4RFBXRHoxWDVyUTJYc1hD?=
 =?utf-8?B?TEtLVkQrOUJOYUxWbUg2Q0VEWnFKakM0czh3Ym9jWm9zRTRieitpNVdFRlRh?=
 =?utf-8?B?bzI5ZGFQaEFxN1pWZ0ZOUWtHS0JVUXJJWFNVenM0SDhKRVdvSFdlWElST2RJ?=
 =?utf-8?B?RjlqMmQyWU82aXZlemFtTTFlRjZsM2VUT3RIN3gyeWFMUEt4Y1VrNmk0WUV5?=
 =?utf-8?B?VG1aNUFvOGtVUi9WMnk2a3JlbC96Z0ovWUc3R2I4ZHE2RDVtMEd0NUZCcXdp?=
 =?utf-8?B?aDZKaWliWTcyR2c5c3djZkNPTDRzeEFYR1Q1NitxMEpaZDFnZUxZMEtrdXVz?=
 =?utf-8?B?Q3YyUVprWTRERFVlcStxai9td0xjRDdwZE9tUVhQSjNSL2FHMlpFaEVwVGZo?=
 =?utf-8?B?M0doSUVZVnZLY3g3bXdFOWUwaEhZK2VtdGw0VENXV0pISVpSYkZrVVhrVUt0?=
 =?utf-8?B?VXR0MGJZZ3E2MzVBUjdSOGRobngwUi83S0RqeGt5VVhlS2tnamlnRnp1RUJ1?=
 =?utf-8?B?RFliME9zMDE0ZkFtSDlxY3FQSlRFYnN0cFZvUEpZK3JWd1RwazdXQk1xd0JB?=
 =?utf-8?B?NHBLVE1aOWM3MDlSZ3YzMDB3b3ZwSmdZV25HTzh3SzVlUDgvR0tFR3VPc3Zl?=
 =?utf-8?B?WC85eW9Ob2pXYk9lWFZudzVZWXhIcDgybWFuQWI0VTFFckcwKzhSWEdCSmZX?=
 =?utf-8?B?cExJRklBckJNWDIxczIrd3N6cVV1WTZUZENGdnl1OFQvRFhFb1pkTDBGbkZo?=
 =?utf-8?B?Q2g4MTVTMkx1Q253cWE3RVNSWk9pTmcxKzNFamJsMG1lazF6WENQd2cwYjNJ?=
 =?utf-8?B?ZzZaZlJLVUIweXd1VUgrUlJHRVJaQXhsdGc4dXRlOHM3R0hIS2YyV09SU3RY?=
 =?utf-8?B?MkxldVJZUXMwRVd5YWl6M2t1ZkpnRjhkckdBY1F0dTZZc0Zaa243M25MV0cw?=
 =?utf-8?B?d21KZ0M1NFN5Umh6UFFLUUs4SncrSnBlQWtkSENMZGpDV0tJSkhPZWNMOEp2?=
 =?utf-8?B?bll3VkZCQmV2MW1JSkhmZFR2dG9rZDliNHdtbENTbnYzeCtzRkZaQlNUVXUx?=
 =?utf-8?B?UlpsZWdMNTEvWUNlckJsWHFRNE9uUUphQ0lsK0UrNmVkZHlJVUk0UFZTU1pN?=
 =?utf-8?B?cXg3dDBGU0I0aUlzbzRydmRiakxBZDN6SW9ZYWtORGNBcVZrTXlhby9mK3l2?=
 =?utf-8?B?dWMvRFBzTzlvSkVQaElLSDNvTi82TzEwN3djaWRMQVlQcUc0Z3dPL2NOSGN3?=
 =?utf-8?B?Y0FKdzR0TGx0L2ZnckUxNE5DaHVnejNKTjNkSXBXbGpHeW54bSs0RTc5K3VO?=
 =?utf-8?B?VGtNNmdkV2xaNFFYMjdoZVpGcWRqd3laZTlQZjJveHFRTXRRSFR2U3Zaa0tI?=
 =?utf-8?B?QnBNbkJ3eUpheDZSSkR0UG5vMUY5Unk4TGtaT0RhWS9RZmZMTStWUmszbHJV?=
 =?utf-8?B?UWN5TVZOSWJ4Uk9IazdyNDkwR2JtS2JNQTFtK3VHZzZRQ3JLOXlzcEQyS3lM?=
 =?utf-8?B?OEdaV3hNRDZNN2E0Y2Nia3lGVzI0ZXRETUxaSExqZThFblNSa1FXTnJOZU5h?=
 =?utf-8?B?OE5xRm9Rd0JHOWZYc1ZtSXUveXFpMWtxU0NTQkNsSWtsL0p0TmRQbzg5bWlS?=
 =?utf-8?B?QWpCWjlmNGNMRWNsOUhYUktWOUZPeWx1YVh6RVU0NkpKaWtENFkrQlZ0U2p1?=
 =?utf-8?Q?s/stohVKJMi6cVRohV8I315Hg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a01d7c66-daa6-4b05-4659-08dc972a5c83
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2024 04:25:37.9565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FuGg43268bn36SjOzzHTFWrU1lquAcM/DiNlQ56LSUDjTXK3L2BrY6+21CDWIqf7yX/wg5fkY1s/M4y2k6J0cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7621



On 6/25/2024 10:34 PM, Borislav Petkov wrote:
> On Fri, Jun 21, 2024 at 06:08:45PM +0530, Nikunj A Dadhania wrote:
>> Preparatory patch to remove direct usage of VMPCK and message sequence
> 
> "Prepare the code for removing... "
> 
> From Documentation/process/submitting-patches.rst:
> 
> "Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
> instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
> to do frotz", as if you are giving orders to the codebase to change
> its behaviour."
> 
>> number in the SEV guest driver.
> 
> remove, because...?

SNP guest driver currently is accessing os_area and VMPCK of secrets page.
Prepare the code for removing direct usage of these and later provide clean
accessor API to SEV guest driver.

> 
>> Use arrays for the VM platform communication key and message sequence number
>> to simplify the function and usage.
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
>>  arch/x86/include/asm/sev.h              | 12 ++++-------
>>  drivers/virt/coco/sev-guest/sev-guest.c | 27 ++++---------------------
>>  2 files changed, 8 insertions(+), 31 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
>> index 2ac899adcbf6..473760208764 100644
>> --- a/arch/x86/include/asm/sev.h
>> +++ b/arch/x86/include/asm/sev.h
>> @@ -118,6 +118,8 @@ struct sev_guest_platform_data {
>>  	u64 secrets_gpa;
>>  };
>>  
>> +#define VMPCK_MAX_NUM		4
>> +
>>  /*
>>   * The secrets page contains 96-bytes of reserved field that can be used by
>>   * the guest OS. The guest OS uses the area to save the message sequence
>> @@ -126,10 +128,7 @@ struct sev_guest_platform_data {
>>   * See the GHCB spec section Secret page layout for the format for this area.
>>   */
>>  struct secrets_os_area {
>> -	u32 msg_seqno_0;
>> -	u32 msg_seqno_1;
>> -	u32 msg_seqno_2;
>> -	u32 msg_seqno_3;
>> +	u32 msg_seqno[VMPCK_MAX_NUM];
>>  	u64 ap_jump_table_pa;
>>  	u8 rsvd[40];
>>  	u8 guest_usage[32];
>> @@ -214,10 +213,7 @@ struct snp_secrets_page {
>>  	u32 fms;
>>  	u32 rsvd2;
>>  	u8 gosvw[16];
>> -	u8 vmpck0[VMPCK_KEY_LEN];
>> -	u8 vmpck1[VMPCK_KEY_LEN];
>> -	u8 vmpck2[VMPCK_KEY_LEN];
>> -	u8 vmpck3[VMPCK_KEY_LEN];
>> +	u8 vmpck[VMPCK_MAX_NUM][VMPCK_KEY_LEN];
>>  	struct secrets_os_area os_area;
>>  
>>  	u8 vmsa_tweak_bitmap[64];
>> diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
>> index 61e190ecfa3a..a5602c84769f 100644
>> --- a/drivers/virt/coco/sev-guest/sev-guest.c
>> +++ b/drivers/virt/coco/sev-guest/sev-guest.c
>> @@ -678,30 +678,11 @@ static const struct file_operations snp_guest_fops = {
>>  
>>  static u8 *get_vmpck(int id, struct snp_secrets_page *secrets, u32 **seqno)
> 
> Why is this a separate function when it is used only once?

This will later be moved and an API provided, will be used from SEV guest driver 
and Secure TSC code. I had that as a single patch, you had suggested to split the
a separate patch.

> 
>>  {
>> -	u8 *key = NULL;
>> -
>> -	switch (id) {
>> -	case 0:
>> -		*seqno = &secrets->os_area.msg_seqno_0;
>> -		key = secrets->vmpck0;
>> -		break;
>> -	case 1:
>> -		*seqno = &secrets->os_area.msg_seqno_1;
>> -		key = secrets->vmpck1;
>> -		break;
>> -	case 2:
>> -		*seqno = &secrets->os_area.msg_seqno_2;
>> -		key = secrets->vmpck2;
>> -		break;
>> -	case 3:
>> -		*seqno = &secrets->os_area.msg_seqno_3;
>> -		key = secrets->vmpck3;
>> -		break;
>> -	default:
>> -		break;
>> -	}
>> +	if (!(id < VMPCK_MAX_NUM))
>> +		return NULL;
> 
> Or
> 
> 	if (id >= VMPCK_MAX_NUM)
> 		return NULL;
> 
> ?

Sure

> 
> Also that id needs to be unsigned as it is an array index.
> 

Yes, changed in following patch 07/24. Do you want me to pull those changes to this patch ?

Regards,
Nikunj

