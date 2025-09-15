Return-Path: <kvm+bounces-57613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B1C4B584CB
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 20:41:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D32F94C184D
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 18:41:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A390C2FE582;
	Mon, 15 Sep 2025 18:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2MsJWcKB"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013040.outbound.protection.outlook.com [40.93.201.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057CE2BDC2B;
	Mon, 15 Sep 2025 18:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757961668; cv=fail; b=p4+26lf6bFBYPxe8p2OmCgAMgZEpOLMkj2P6PChnxrS/P2nwQLqrO9z4vClSuE+gcHD7pxpWZYaJ6UgGBCXOsW9AUpI9Zq5m4cLm+zVIzMVZYS0tNxzDfkj1V6KyYc18LnCdHDv+5pXPxlCbRrAXsRb/L8Rv96nWGARd4yXAgdU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757961668; c=relaxed/simple;
	bh=LdALItSk30UBA9vIyj6B0AClY1huUVVZ/rrHL7ec8Lo=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=h3/VqzHfTYHCVNmuP+xrcCISZ59VD9uZ9fROrjBdRSLrc3Kmf8UHWFURPa0Y028nJPmML83WNXsMAc8tFnN+Lxk0ObdJJWR7JYCpzUJMv6jVMbtHwbkQPGFM0F/SFXsQl6MMX/9Vxftr0pa2m6NDafKGN64P2luow2T31m6PbVw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2MsJWcKB; arc=fail smtp.client-ip=40.93.201.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DwxBWpWpvCeq7xlxC/duQlyquWqxLQ78rGFHmw/OD2/3T7YNCC2Pczx9uW056kEHEQtvneeBnwhiLZ2SDJp4H2Sb/5sXkYMfcqp8kKytZd+VyN7XQeTqnZqk+cCz7b0DQePI8jzdPgL9axWlGQPrR/T+WxXmtdeQwoq8wGuIMTucQ3kf0yzhiU31LNPCaPuHY6KgBSqzbgvGDvSlqmrzGACzCmqkjipkqVGbaRB41F0MTBK+h5Hq0xCx4Jb51FHGtSzJNt/j2934FCP8vTX1JCt+Dvz1O8Ni/O0HiTn++CkWinLK9CnJlIi5SmErttHBfgNvZrU4aRkv4gMhU9xNeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pPnE2f5NTHVF/Ssl/oYVYCtvsx7c9VcOKaUbKQCF8X8=;
 b=XXv+JlRpzwhatksRhocbXA8Gj95qXTHjzIAfKXuDN/v9sjNaHbG2RXEG7jHoekEU8kV92poPRtPzW1LZD+2Q36ja7C5vsMau0vojFUMN6Od0jEbnomsylZgmW+wdYuuF4XjJuZHoX4LggFbgYBDRvU2Y8ntpQR/FhAuRDvhPvK8g91knWi034mUo+48xMQU+KXWKqLS1DkyAhdJv8Kf3gyA4e4wl2iugewpBEg9UWjAFNtaoA7VzKJaUQ+giFbvRPxPBHcIh+Zj83BhQsKh/zpFtjuHmcfJ3Wg84AP6LdOZqp3+tnHIGHu+k7skDVKByruICtlgM6YUc/UXc2i5vDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pPnE2f5NTHVF/Ssl/oYVYCtvsx7c9VcOKaUbKQCF8X8=;
 b=2MsJWcKBTCKbgr2GEeQhGmWWEn3qYEu6gchrR9a+L/rhkOAb0drW3rvGc3JiF9gDA2Ru7ku4iTG03Rc4FdjGMN8pQsGJfPNAXnjtBsd2M0q97IiSi1yMVd+hcZZapkYfXIcDKFNj2m2/etOsODgsLnrBR+/K/z7dJ1uHkpZCuHE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS7PR12MB9526.namprd12.prod.outlook.com (2603:10b6:8:251::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Mon, 15 Sep
 2025 18:41:03 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 18:41:03 +0000
Message-ID: <c30dff3a-838d-93df-d106-25acb7cb0513@amd.com>
Date: Mon, 15 Sep 2025 13:41:00 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-4-seanjc@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v15 03/41] KVM: SEV: Validate XCR0 provided by guest in
 GHCB
In-Reply-To: <20250912232319.429659-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0113.namprd11.prod.outlook.com
 (2603:10b6:806:d1::28) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS7PR12MB9526:EE_
X-MS-Office365-Filtering-Correlation-Id: 7183c13d-d85a-403c-1aa0-08ddf4876c24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ajdSWkNqdWhaSnFONGxZZGxWYXR2bkVCNEo2RW5ScHhZSGNjbDBxNWNHSW1a?=
 =?utf-8?B?TGxjK3VLbE4vLzkxN2h3T1BaQm5ONmdJUE82WUlSZFd5dnk3bTcyeHZtWkhz?=
 =?utf-8?B?WFY2aGo0NmpFalJjQUY4aWdFQk1OeDdxRlR6OVJoWHRHa1czWU95MWg5WlFS?=
 =?utf-8?B?Qjg0ZmNjcmY2dHJPK1dpNjU3YUN4UUtCL3g0Z0ZIWStvaWwxUXBuYTRoTmls?=
 =?utf-8?B?NEFycW5oZ2NHMEpxTWhjREtmTWJmZitOa3NHbUdFV2xNVmFLLytrckVPQ25v?=
 =?utf-8?B?cUpyOHVNbTVjR1pENmxhN0FUZTBIRHBKdlROZ28rTG40SVR4QVlUTDRld2xM?=
 =?utf-8?B?dkpDdFU1M1h0am1kTDd0bnBGZDIwczhKc1V4ZGRyaHhQcGhXTUxobG0rNENx?=
 =?utf-8?B?d3U5Q3UwWkI3N3M2eGtoY2lteE9oSFpFVHI4R3FGWWxJU2lPdWw2a0o0d1F6?=
 =?utf-8?B?TlBxQ0JPcWF3WEJJOTFSS3hzQXZmTm9qUDFheUZHRUJFOU5kSi9HM0dlOUlQ?=
 =?utf-8?B?MG9mN1JUTnlqRFMwczRFLzR1TmNjZE1WMExmaG5weXZucEx3anYrQVp1UkY4?=
 =?utf-8?B?dURWUTZPMlltNzY5eCtnSUV2WlQ3cE9QMWRGR3psNHBlNWxoUVRrcldodGEw?=
 =?utf-8?B?bnd6OW0zUTc5M2h5aS9HdHV0Y2pWUDdDOEsxZkhhSkJqZzM4ZWZkNm5VaEEz?=
 =?utf-8?B?L2dNMm9jQS96R3lLYTAvSEM0N1VYQTUyUGNBY3Q1RXpXMFp2Ylh5YUNhM1Jt?=
 =?utf-8?B?TzdVa29DbGVtUm9OT1RNZWFZUnRXS2VXNk5FSnBTcjdVN20zdk1WT2c3eG8x?=
 =?utf-8?B?eURSWXNkQlVGREdHV2pqRHdmLzVvcXlWeDkrelZCYVlDd3NaU28wOHFMMUQv?=
 =?utf-8?B?WlFkemd6aFFqVTlTWHl1Y3kvK2dJdng4ZDAzMUpRZkpFb2hLZ2RYeFBUVkpv?=
 =?utf-8?B?OUcvN0o0bUVXOURUemJsR1RqZlZFMm9hREc4NUZRM3NFbCtRNXg4RkIvRG9p?=
 =?utf-8?B?M2xnVExKY21LaWVCWk9nd0F3elpZWkNUV29GQ0lCN0JMeG9EeWVQTG5yZ1NO?=
 =?utf-8?B?ZHNmbzQvWHoybWFEbStqUkVrVm9ld1dyblBCQlJwWDFkaGJkcndOdEpIaXpj?=
 =?utf-8?B?ZDlWM0pPQlN3K24wUHhmeVFFVGZjVEtRQkVKMzkwK1BXRm9LdmVLSXRldWNW?=
 =?utf-8?B?Ym45WkppSVpqYjhzQlhYdVlQTGkvN3VTQ0orOU96RFBEZFRKQ1QrTy96TGVa?=
 =?utf-8?B?czVVT0JOV1RZMUhSb1NTQ0s4emlWNzZZeEh4eHNrdWFQU1FCc0F0cHFRNXYz?=
 =?utf-8?B?YTA4SDVPSHpONzNZMVQ5djdkSGNjSmhtZDJRS0dWVi9GekF5eVZjbE5OdXVl?=
 =?utf-8?B?MVZDaVYrQ0VkMUtaUnZOd1NIQ0FQZEhpQzFURmI2WjJmbXVhOUhCSzQzczB4?=
 =?utf-8?B?bmtTK0czQnNBM29zZ0xsVzVHMSt1aWh0NXJBWE1Md1plNnVrKzBjNWNSUVN5?=
 =?utf-8?B?Y2hwQ1ExMi8ycjNzTHZMVmFGRWFvak9kTE1mM3g4aEdkaHBndlhGclhLQm1Y?=
 =?utf-8?B?R3VrUXp5K0RUa09UdkozR29CeElnNWlHbWc5MzdDQXZhelJ0dzk0S1B2cDJQ?=
 =?utf-8?B?RlVHcVJhOXJQeG40MFlPWnF3dDJ5QUl3SHlLRnhrMlJoTHpJY1V1M0VVcG9M?=
 =?utf-8?B?ZG54UVpXa2hXZ2dXM0xqMWR6WjBYTS83NlRiRnFPeklUUjV0emdVbGhlYTVR?=
 =?utf-8?B?YVpOVGE5dFB0WWRiOTB5V3o3NU5WYTRvMVpmZVhrK2diQmtEUU42QU5vM29j?=
 =?utf-8?B?MDhIcTJmL1F6ZWpkRGg0VEpBYXliM3hsdW52aWF3Zmc0YmM5R0piVnRFUHdW?=
 =?utf-8?B?YTcvR2laRmhQa3JMT0ljQWQxaSt5VHUrS05pdlJTeEZHaVQ1bzZvRUlWYWJs?=
 =?utf-8?Q?EVC/ekAyRAM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VGY1VVZwQVRLUlR5cUpualcveWcrQWdQZi83Y1RwS092OGZocFJCaWtxVllp?=
 =?utf-8?B?MHdUekpvWklobVU1R0cyR3hXUk1saFROQ3FzMzVqU3A5Uk8zKzlZTHFiOUlQ?=
 =?utf-8?B?T0FzZmpuR0wyL0Y4Y0E0ZVN1SnBjaWVaNEpnaDRhdlRNTlBPbGtGLzAzN2Ry?=
 =?utf-8?B?cER1NVhVTmFwK2dTMTBvd0Y4TEpHWGk0YXMvbVFsbUh0c1Njc0x5T3RzbnhD?=
 =?utf-8?B?bWNGbitlaENzMURRM3gzVjNJdzNnN2NzSHhNeVNYRjFEOEZONTVLc3Y4NU5s?=
 =?utf-8?B?NzVzSHhGTHpKbFJ4amZIamt1UWZwTEJpZjBJVTdjMVY1ckdFQU1RSzZyZUVm?=
 =?utf-8?B?WE9tK2h2ZU92T3lhUnVCeWU1d3BRaEZuWEtIRTdNakh5ZVY1VkNCUkZvUEVL?=
 =?utf-8?B?a2tjVXgvcUlKanFaQ1NlaGhmbEt5TzNKeEhaZmF5VmdxbFFGeWdWMlpjbnZy?=
 =?utf-8?B?VWE1MitaL3loZ3NIU29oVUg3aDVaUnYzYzFmMGVLdUxmV3FmRW5LWWZmOGNn?=
 =?utf-8?B?b2hjWVB0U2VnTTJQUDZ1V0tabWdFd0gyM2FwTzc0QjN1NjYzY3FWNGhVdEVn?=
 =?utf-8?B?bXVqdXNvby94NDdwZHV2eGJkR3FFaTNCSnZFZ2NpNU5wRXVvNGpKUm1mMHdY?=
 =?utf-8?B?ZnhORzNZVnlJOG5jSWpCTjFKSkVkS3pEV2NNMFVQWEFYQTEzd04xTDVoUDI1?=
 =?utf-8?B?NnU0a3MvTlltWDcwSDBqb1hDREt3SFhRcXl4Zi9nTWNRWFEwK0hmcFl0WWoz?=
 =?utf-8?B?TkpRR0d0bkdwbmVFWGt4QkUxODNEVzV5VmtOUjRRa3dtcVZsM1V4WE43VHIz?=
 =?utf-8?B?dzdMTXFxVU1XNEIxeVB4WVNCZFd3ZDZFajRQelM4UWRmaWFmd0dqTDhtN2pJ?=
 =?utf-8?B?UjNXNzBIZDkzWjNaZkl2bUxOY2NmMGVaSUlFSFU4dkJYNjRmLyszckVucUxj?=
 =?utf-8?B?bm9LQzFRNDUwUHhiYzA5bElxRHp0ZXFKSXR0MSt0TmdPdE91WG4reHRQMFlL?=
 =?utf-8?B?cnBhM1U0akNMZWJaRys3dWJpcGh3SnpZTGlzOTdXUUNkRDZybDhUdnc2U1VF?=
 =?utf-8?B?K2Ivb244NW5CWHJxRzNoWmRsQWdzdGRQMFd0UUsyNDJSUlliTVpoUjlrdjVV?=
 =?utf-8?B?bkUzWGh2Y1ZoTkdPekpLaFBtQTZiMUIrSFgycU1vZzdteEJDWlVPK3ZKdm5o?=
 =?utf-8?B?T0l6MEdXcEpNaEtXQ04rQjByalJJZlRxcWNQWHp1WG1Rc0ZoQkFhcnp4MUhM?=
 =?utf-8?B?OWxRWTgyYWhoMkF2NFpqZ3V0MHcxeDlaMUcvTnZPNG9HL042L05sL3pkdER1?=
 =?utf-8?B?Ym5JNFFXcXlvYllFWXp1czlQYmpJNE5ENERMQzJ3SWRKTGRucllhUlFtdVQ4?=
 =?utf-8?B?K0dWR1lTMlNsanZYTEhmbkdTSndSdm1YWHRzQXkzcFhXanNKTGVXc3NiLzNm?=
 =?utf-8?B?NzVJVjI1Zm9Nb24vVHFjUkxvV1ViWWw1YTYzRTd6cC9OZkE3S3ZnLy93c2FF?=
 =?utf-8?B?VndNOFBOeFF1aWNzQi9CNE93blZVQitVK1REOGIxeW1sZGgzVEJDWitKZWZr?=
 =?utf-8?B?WWFpaFIvRS9pdlJ5MkNWMjNHQXhpNW5PUVJlUjZXSlNaLytncUtqVEM4ZmJV?=
 =?utf-8?B?VFBrQXM1VGFYME5JR2N4UHBmSHlhUXV5YTNqdmtVOVhtSURJcTRoQ0lYRFlP?=
 =?utf-8?B?UDF6c0ZqejF5bWdZOFJIb2ExVWR3ZEhlVnk5QkNlNXVSbmxua01YU0hrY2Qv?=
 =?utf-8?B?cHNRMWdXcUlmRHNoTVlEeEdwMGY2b211bm5sSS9Cb0l1eE9ZNFBnWEtRbk5S?=
 =?utf-8?B?VTlmQU5UelhIYU55VU1BM2M2ejBrSjNmdDNOd2dVWmxRRXE0ek5weGdHRFFV?=
 =?utf-8?B?UVJUMjlGck9HMDdoREtudnRaL2M5amZhQjhpNEdmZGp5SEc0S2gxc2ttMzdV?=
 =?utf-8?B?Ym9WbFNHaC9qejFKRXlCRThZeE9kOUFOMEhGMXdHaExwcEFHb0IyNzVIYmt0?=
 =?utf-8?B?WGVnSHNvMXplbXdtRGdTSy9TUVZxV2x1L0ltRXJUSENaUnVlQkVicGl3Ulcr?=
 =?utf-8?B?c3FzL1NNSXArcWhhS3ZHdXVLTDhJVjZGNEVnbFA1Q0dFN0ttSjJDdEgydG5R?=
 =?utf-8?Q?/xZp7/DXs8k1lCqMogj5PGtNs?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7183c13d-d85a-403c-1aa0-08ddf4876c24
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 18:41:03.0410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cCFqBXEh4L6WHUl7sYQmtuuhqpHZV79RrggrfVFzKPjPl3L5X9dOH1ubpdvjEB6N3nPEpFubTiImj53qeRltaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB9526

On 9/12/25 18:22, Sean Christopherson wrote:
> Use __kvm_set_xcr() to propagate XCR0 changes from the GHCB to KVM's
> software model in order to validate the new XCR0 against KVM's view of
> the supported XCR0.  Allowing garbage is thankfully mostly benign, as
> kvm_load_{guest,host}_xsave_state() bail early for vCPUs with protected
> state, xstate_required_size() will simply provide garbage back to the
> guest, and attempting to save/restore the bad value via KVM_{G,S}ET_XCRS
> will only harm the guest (setting XCR0 will fail).
> 
> However, allowing the guest to put junk into a field that KVM assumes is
> valid is a CVE waiting to happen.  And as a bonus, using the proper API
> eliminates the ugly open coding of setting arch.cpuid_dynamic_bits_dirty.
> 
> Simply ignore bad values, as either the guest managed to get an
> unsupported value into hardware, or the guest is misbehaving and providing
> pure garbage.  In either case, KVM can't fix the broken guest.
> 
> Note, using __kvm_set_xcr() also avoids recomputing dynamic CPUID bits
> if XCR0 isn't actually changing (relatively to KVM's previous snapshot).
> 
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Fixes: 291bd20d5d88 ("KVM: SVM: Add initial support for a VMGEXIT VMEXIT")
> Signed-off-by: Sean Christopherson <seanjc@google.com>

A question below, but otherwise:

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

(successfully booted and ran some quick tests against the first 3
patches without any issues on both an SEV-ES and SEV-SNP guest).

> ---
>  arch/x86/include/asm/kvm_host.h | 1 +
>  arch/x86/kvm/svm/sev.c          | 6 ++----
>  arch/x86/kvm/x86.c              | 3 ++-
>  3 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index cb86f3cca3e9..2762554cbb7b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2209,6 +2209,7 @@ int kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val);
>  unsigned long kvm_get_dr(struct kvm_vcpu *vcpu, int dr);
>  unsigned long kvm_get_cr8(struct kvm_vcpu *vcpu);
>  void kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long msw);
> +int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr);
>  int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu);
>  
>  int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr);
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 37abbda28685..0cd77a87dd84 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3303,10 +3303,8 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
>  
>  	svm->vmcb->save.cpl = kvm_ghcb_get_cpl_if_valid(svm, ghcb);
>  
> -	if (kvm_ghcb_xcr0_is_valid(svm)) {
> -		vcpu->arch.xcr0 = kvm_ghcb_get_xcr0(ghcb);
> -		vcpu->arch.cpuid_dynamic_bits_dirty = true;
> -	}
> +	if (kvm_ghcb_xcr0_is_valid(svm))
> +		__kvm_set_xcr(vcpu, 0, kvm_ghcb_get_xcr0(ghcb));

Would a vcpu_unimpl() be approprite here if __kvm_set_xcr() returns
something other than 0? It might help with debugging if the guest is
doing something it shouldn't.

Thanks,
Tom

>  
>  	/* Copy the GHCB exit information into the VMCB fields */
>  	exit_code = kvm_ghcb_get_sw_exit_code(ghcb);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6d85fbafc679..ba4915456615 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1235,7 +1235,7 @@ static inline u64 kvm_guest_supported_xfd(struct kvm_vcpu *vcpu)
>  }
>  #endif
>  
> -static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
> +int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
>  {
>  	u64 xcr0 = xcr;
>  	u64 old_xcr0 = vcpu->arch.xcr0;
> @@ -1279,6 +1279,7 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
>  		vcpu->arch.cpuid_dynamic_bits_dirty = true;
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(__kvm_set_xcr);
>  
>  int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu)
>  {

