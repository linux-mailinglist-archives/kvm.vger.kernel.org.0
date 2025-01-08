Return-Path: <kvm+bounces-34757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 41F5FA0558B
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 09:37:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA8231887F21
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 08:37:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6BD41E9B2A;
	Wed,  8 Jan 2025 08:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DyZEMO5t"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2040.outbound.protection.outlook.com [40.107.244.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DDC1E0E14;
	Wed,  8 Jan 2025 08:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736325441; cv=fail; b=JnmMEyc/2BUC0V8ZnR5fIMA4PEu1YQ5rVDw+Omj3VJGvksZnFMCIyMt8k5EaQgjZjJf92qStFU3KQD3T3apZnStIZnPg+k+o/4gu9YzNTyJuIt6BJrdNdUqLjUAB+yZyGMIYpKU8z7jyD/nlHwvL9xs3eZjNTcWt+jL6GehCpYE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736325441; c=relaxed/simple;
	bh=YeX30aiPC6d+YKzFhtVq8lhgLAt7k9dIzOx4+XBOwc0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cfXmI7RzQ/2DD7eQFaQYCsRNDdWI22hWUChuL0F6TniTJJs/jd96ByPumh2Rq4n4CnzvkN7L3RUu8nlKOfrjrxQry2bOMaB1fZVSRUoLwTQWZ2MWnchRTRRG2MIVkOSo/2kR616fAp9bhuNh+TPCJM1wL8DZfc66DHAB0zksTso=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DyZEMO5t; arc=fail smtp.client-ip=40.107.244.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aaUe/KrvnB5SO/7vNGDen+GO5NcKzS9o0Gdz81Straqumbz3FUfBe48eVhinQEb/0P+4cYkvz2KF2C1oGRZS5KgJJw7YI2r7sBMnTvpIT2rB5oN+r1wtCTXPJLfzXFBCMtF9nBkN4QR7lNuYW2wYxbbMIx0z5N23auqm+slgb7xbjPy+V7lKHlSLNrhCeZu8uHgFDnOzKpLqdatWLjDWBajibxVMS0/jd4ovOIAF+4z2sgM7KyQRjrKWuWffG+w0c+YkfBnO5JR5JeDiOaQy0oK6LauA3cRtu69FAk/pwihL03evw2CmKcocqz4pCjpYkSQEZnB5pT8xGHp1YYVHow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lBfh3Hfb6yrHCyzUuObbEdDdztvyV8vlEzwSPRARXrs=;
 b=AZhj/ZgZUp26iErinnhC12tAAgRLVvTHJ7+S2rPlytjxStj11VIgFOWDFRueerooitUtsmOQHJD5crtbCD9hezStGE0Uc96Iy9tzvR9BEsJbaytXAaA5AXmOJgWRcXqs1BSFBT4wa2O4dMH/+NemDCVbsYA8ola928B84Qh21umjEz13F/Z2UkqWcmwQBIabjPosQFfYd0Q4ocA0bTok7Xhs4vgv8AuI/5qNCxhNOLZmYXEfjo1z3uH6G2pELFXvZIZJZNy3to+rDwQWaEbjFTOnkB2QP3dK0sbYXvvG3wnb9tyJvLIyyLXYXFFAeaHQehOA49a0iThMnJHhXLJG+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lBfh3Hfb6yrHCyzUuObbEdDdztvyV8vlEzwSPRARXrs=;
 b=DyZEMO5t0goPMmTS390ig6KVsy2ceRHTPOsfxcy45MKj4Ohe4cDHrvMbN9UAPnXCmCJdumoZOtYq0SVIqwyTpuxIZMPhgkTiP6qBpaZxpmt7S1+9DiWxcKUxgvPwT9tP90jZMZcY3q/Tlax5WqtMwIILKDmcLPsG8hphS2CGiME=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 CH2PR12MB4086.namprd12.prod.outlook.com (2603:10b6:610:7c::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.10; Wed, 8 Jan 2025 08:37:18 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8335.011; Wed, 8 Jan 2025
 08:37:18 +0000
Message-ID: <f1c97e8a-1a35-42c9-9ff9-e056d48c80d6@amd.com>
Date: Wed, 8 Jan 2025 14:07:07 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 05/13] x86/sev: Add Secure TSC support for SNP guests
To: Borislav Petkov <bp@alien8.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com, francescolavra.fl@gmail.com
References: <20250106124633.1418972-1-nikunj@amd.com>
 <20250106124633.1418972-6-nikunj@amd.com>
 <20250107104227.GEZ30FE1kUWP2ArRkD@fat_crate.local>
 <465c5636-d535-453b-b1ea-4610a0227715@amd.com>
 <20250107123711.GEZ30f9_OzOcJSF10o@fat_crate.local>
 <32359d64-357b-2104-59e8-4d3339a2197c@amd.com>
 <20250107191817.GFZ319-V7lsrjBU8Tj@fat_crate.local>
 <c7165d80-ab7f-425b-8323-3f759e1e41a6@amd.com>
 <20250108080515.GAZ34xuwMjbrSYFcHN@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20250108080515.GAZ34xuwMjbrSYFcHN@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0029.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:25::34) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|CH2PR12MB4086:EE_
X-MS-Office365-Filtering-Correlation-Id: ff087454-b1ab-4403-4fac-08dd2fbfa912
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a21pYzlhNFhNQU9vWlZpOTl3c21lMjR3S1dZaTUvWStmamRNOGk5QXhWdG02?=
 =?utf-8?B?TzRQMVVPeTljbW9DSnl6cWl4UHN5Qmg3V3BudjB4WENBQkF2VjMydVl5Y3hp?=
 =?utf-8?B?bi9na3BTUUl4cTFUaTRTUU5MMXV5TnFJME15M1BpNnNITlhYMzFYazgvT3JZ?=
 =?utf-8?B?MjZvWEdPTzMvU0w0M2FGQVlqMFFjZkFOWWxXSzlkZGdlR3BIZnVRcjRvZVl4?=
 =?utf-8?B?ZFFZN0J2bHl2QWlFa1dMWWRxYk4wVXNYK2J2SFh3UnEyUStBUG9HclE1ajhw?=
 =?utf-8?B?RWdzTjBraTNkMnhvblpFZUc3K0xVU04xL3J0eGxiOGhUa0xuVjhKOFhvZmIx?=
 =?utf-8?B?MnBJT3pYOGwzaXB1RllOZTcvZkNIUSt6WVdXMEZxd3pzdVVHd0c0YVhaMFpI?=
 =?utf-8?B?MW5FSmRlWk9xcUVrNXRyZ3pIaUZUNzVjRGNaSnhSVVZ6YlRLYnRrTGs2SENa?=
 =?utf-8?B?am05TEx2Y05qOVVUT3YzempCNCtBVGxQWWxETmR6cVZBbzNzcEFadWVDMDM5?=
 =?utf-8?B?RjcxeVl2aGNPS2RKbWVZVUpVbEQ4RTNKaHlsSGlySUlWWlVqVk1JUTFLekIw?=
 =?utf-8?B?azNsRHNHbVc3ZFdOQ0lJMVlSMFFuRXJ3c20xRG9XNDVGWTZ1MUUyT0ZIT1Q2?=
 =?utf-8?B?T3U0RnltVGJLajlDdkJ1UVVYTnBPdnhHcVVrS3ZSTHE2cHQ4VnJsSUFYSXo2?=
 =?utf-8?B?TXZ1RTdzdmZOZjk1eUZ6L0hLc3FuMDkxTDRJVFBORzA0QlBRVFRRK1BWamVW?=
 =?utf-8?B?RXpieEQwUXBJTDY4UWNMNEV6THlpT0UwK3MxYVMzSmpSN0puZFNPdnBmb2pq?=
 =?utf-8?B?eHI0RVVEbk5rb0YxSlhsOHA1aHMyUHRhYlNaN1lTejVQRFRJcFZvWUIzN0dC?=
 =?utf-8?B?dkY0Nm1PNkYvaktHRy9CdnZvS0RpZWZJaHdZNGpPdXBzdHVaMSt0RnJUN1Yr?=
 =?utf-8?B?UTNNbE96UVBVT2o2VnhYL05vQlpPN2RtMVYvcnJjMlNYV3YrVG1iZDRIYjN1?=
 =?utf-8?B?SkhzSnFFb3MxU2tURGxmNmxyUE1PTVIzV2dMMmwrZnU4QktWekxhL3p5bU5S?=
 =?utf-8?B?YzBubVorRnBQZXVCTzdCVTlUL1RFck4xcWRPWUdDeFFGZGtEUE9sQ2xqVEQ2?=
 =?utf-8?B?UlVFeDBDc3JqbWJuR2FIWExvanpTS0Z1Y3RMeE5rMXVWZXpJY0NpZk9RZ1l1?=
 =?utf-8?B?R2FGZm1YbEE0MEtxcjVmK3REQUMvMXlPWUxWaWs0ZmtKYm1zaTRBNWx5bGRa?=
 =?utf-8?B?bW1qOTIxQ29VYlJTdTBTOTd5aFdFRnN5Zkt4a2tKZkxtVFhTVGxSZlFPOFJh?=
 =?utf-8?B?NWFBdmN4VnVoTzV6c1RjdHk5eFJtK29qZjlpbDBGYlN0NUhXRlZDaHJXODg4?=
 =?utf-8?B?T1MvZGdGNTRoRGN2UmhSUlRjaWNlMitRM3RyTi9PYWtYd3ZuWGw1VU92cUEz?=
 =?utf-8?B?L3BaZVdmdzBBM1NjbWRtNXpBMWxUQlhQQlJnNmljcHFKRjk1TTB6VkRZekFZ?=
 =?utf-8?B?TVJuOVpUTWo5dEFxSVNxemRYUGFmMHU2R0xwVGltemxaNnY3NHVsMnFScGNQ?=
 =?utf-8?B?WDNMNHc1NVVvY3kzM25qZ3ZrSE1rdm9JNFhvQWtXb0wvdEY2SjNhbTRPZWlz?=
 =?utf-8?B?MWZpQlVhUlIzK0tFT1BMN0M0UkIwZHlMQzk4MUhvV0dlb2tZcU5hazVuZW1l?=
 =?utf-8?B?YXlVanJjUFpuTnJMZ01YblNxVnk1V3JibVVSejVyMzYvSkNPSzluVTBHc3du?=
 =?utf-8?B?WWpCcERoVHV6WUNwSGdscWNUVmdvUzB1dFpYYjNTZzJlTVFjZzUzVFVab0ZX?=
 =?utf-8?B?akdVbnd5VHhyd2lreGMrS3pyeXVVdnBMT0d2TDZtRWlZaWlQd0NHTEhIZ1Fo?=
 =?utf-8?Q?rBClCVJtl1a4A?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SUwrMmJMMEhPRWY2ZUw3eXNsaU84YU0wODFkWHozWnpFbGtjSFFuYnBZa2tr?=
 =?utf-8?B?QnFKS21BdDhYaGR1U1dOZGxGZmhGYTN0cVlCNm5xck9pcGEwUi96RWRoTCt2?=
 =?utf-8?B?SDNlM0JGWkRNOFVaOHU3czN4RjZoMzV3QVhUWDQ2eGZBYk12WkxxZzgvRS9m?=
 =?utf-8?B?ZVZGcjc0dXRxNHhjby9tYkpaMjZSNFdHYldZUU9tMFVjcE1WVWhMZERaZWE5?=
 =?utf-8?B?ekttaFhROVJxaCs5dS9xY25QM05hRGR3UDRxcFo3YU5uWjZGTk9YeGk4NDh3?=
 =?utf-8?B?VUhiUTZqSjF1cVVoVFNSU29MQ3ZmYkNQNnJLVTZNQ0YrQTNzRURlNm9OQnhL?=
 =?utf-8?B?c1FvRklTdHpBeG03VGZlbkpoMGVmTHkzdzRkT3pNMXBSYmdwUmdzczh1VzV2?=
 =?utf-8?B?RTNjajd1dVByak95Vm1RZDZTa2FTaEZjRlNDYmQ0MDEwTElQVjBwbTZUb281?=
 =?utf-8?B?eitkeXdFNTZLKzIva0tHRDk3RThERG10S1pXYzRBcUtURktmTUJwTjRRTVBV?=
 =?utf-8?B?Z25YTDV2L2cxRVBkWmcyVnFaYUY0cjZVaUxBaDBWSldvZ1Y4UlkxVTVzTThT?=
 =?utf-8?B?eUUyN2NOSlpDcVhUNUNWeDM1MTBXQnVwbVI1N0ZkT24rcmVOSzJVVHVYSjlP?=
 =?utf-8?B?QW9PbERmTm96bUlhamdqT1FIUFpWVXd1THc1NXVJdUdERVE0V0QweG8wRWtL?=
 =?utf-8?B?V29qZzRoUHZGbVB0VkNaRXFINmw4ejljTk5tdWlUN2Q5RERPTU1rNXJPVXdo?=
 =?utf-8?B?RnkzcUVKTkp6djZqeW1VQXBGM0k5UjJhK2EzbGRWVlppY3ZaZytYcTY2QzBU?=
 =?utf-8?B?ZXp5T013TldVYTJWMHl3VjBQRGxYa2ozZ3JHL1ZFSllPTHUydHc1akUvNXNH?=
 =?utf-8?B?V01YNHVHQ2psNFkxelJ5WmpmcU9KOHNYL1ZLdUJJaG54elVlYWNLUWlpUTM3?=
 =?utf-8?B?amd4bGFBb2JrOEF0ZVhRMkg4clQ5TEV3SWIvWnlqMU9LcVRrTzl3WFZiUEsx?=
 =?utf-8?B?b3JBVHovNEIvVFFwdGFSS3Q0NTJDazVuMTVXNHBqNkQyOS8vS3N1bXNEQjZE?=
 =?utf-8?B?eHVPY1Fhck9DTS80YkdsQXdxb3VTMU9wVk14UEd1bTVyMS9MUERoenhuNEF1?=
 =?utf-8?B?bWZLNTlVbXl2dHFMREV4VTFZaFVoVUFQUExkcU94OFZFVDRoSTQ2bmJjT3Jp?=
 =?utf-8?B?TjFTc0svR2JCZ3ZMeENOdjMxZmUxMnVIR1krbmN6djFQQ3h4eUpxUmRnbE5p?=
 =?utf-8?B?RzFIenZIR0RNajBjekxQTjUzTFpCVmw5TDRHbE9aMk1mQ3IxblMrR0QzYWVE?=
 =?utf-8?B?N0pWQ25SYUl2TCtqUzRCZ04zbEd2K3NqQndJUTJFMS9iU0tsK0dXQmVyUzR2?=
 =?utf-8?B?TGpBaEZlTlRteUVvSzRVUElScndmMHhOdi9iQjN0VmN0Q25sQ3BwV3NiYVlr?=
 =?utf-8?B?NUtEdFhiK0VueHdOR20zY2J6cmtldU1oRzNFeUFzZWplNm95MHQwVndjVHdr?=
 =?utf-8?B?RU5xdWRyWldqaVk4YVo4TDIxSm1rQTZmOXlBay95bE5NQWZsdGd4eUw5QmtI?=
 =?utf-8?B?YTBxeHRuTmZDRktUTTJzV1BDNjlaMkNkMHdWRFBRNjdNZmRFa3ZpZzdPekZO?=
 =?utf-8?B?RW5CN2ZjbUZsT0xPd1JmbjFVemdkUGRnTTlMaEIxLzhHcjBVM0VaZ3BNQ3Ro?=
 =?utf-8?B?QndwenRFMngybENab0lwVEd5TFU0K2hVc1QrUWcvVEQ0RkIyYkZEcGNCNnBW?=
 =?utf-8?B?UnBxMGNrZlBKVGdlMVY1aXQ4L0NlaHJJa0FONm91WnpmT29UempBUzM4QnA5?=
 =?utf-8?B?YjRlZzVOd3ZGSnVtYWVQL2lzMXltTHFzZDV2S2wvQWgrckMyUnhWQXVoMVh2?=
 =?utf-8?B?d2IzWW11MHNMUUNBVEtEMk5hV1RCM1hsYWc0Tmxjc0Z4dHAyTEVIWE1SZ01N?=
 =?utf-8?B?M0pTaE1mUmFrWEhIV1JESGxBOEh5VlRIMnArTjIzNUE1S1lDTVBJSnR4UmMz?=
 =?utf-8?B?MFlkT3lJN2FzeGxRTGczRTJwVUxvOUtKTmN2eVE3ckNOaUFtelFqL2Q5OHRX?=
 =?utf-8?B?cFpsWWl4amJWYnRHVTBDWE11NS9DTjVPNElxVGFycEVObThxSmtJWll6cUo2?=
 =?utf-8?Q?SgbS5wCz9FNNK2Ir3iT35Jphj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff087454-b1ab-4403-4fac-08dd2fbfa912
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2025 08:37:18.1731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KjF/VLNtTduMiG8T7OCcpTGs7wpJ1R5ztyXQ199MKfajeg7DzMqRr2AmSZvd0+tWwLladJyGqdDwygABROpm1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4086



On 1/8/2025 1:35 PM, Borislav Petkov wrote:
> On Wed, Jan 08, 2025 at 01:17:11PM +0530, Nikunj A. Dadhania wrote:
>> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
>> index 00a0ac3baab7..763cfeb65b2f 100644
>> --- a/arch/x86/coco/sev/core.c
>> +++ b/arch/x86/coco/sev/core.c
>> @@ -3218,7 +3218,8 @@ static int __init snp_get_tsc_info(void)
>>  
>>  void __init snp_secure_tsc_prepare(void)
>>  {
>> -	if (!cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
>> +	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP) ||
>> +	    !cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
> 
> So how is moving the CC_ATTR_GUEST_SEV_SNP check here make any sense?

In the comment that you gave here[1], I understood that this check has 
to be pushed to snp_secure_tsc_prepare().

diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 996ca27f0b72..95bae74fdab2 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -94,9 +94,7 @@ void __init mem_encrypt_init(void)
 	/* Call into SWIOTLB to update the SWIOTLB DMA buffers */
 	swiotlb_update_mem_attributes();
 
-	/* Initialize SNP Secure TSC */
-	if (cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
-		snp_secure_tsc_prepare();
+	snp_secure_tsc_prepare();
 
 	print_mem_encrypt_feature_info();
 }
 
> I simply zapped the MSR_AMD64_SEV_SNP_ENABLED check above locally.

For SEV and SEV-ES this SecureTSC bit should not be set, I think we should be 
fine without MSR_AMD64_SEV_SNP_ENABLED check.

Regards
Nikunj

1. https://lore.kernel.org/kvm/20241111103434.GAZzHduouKi4LBwbg8@fat_crate.local/


