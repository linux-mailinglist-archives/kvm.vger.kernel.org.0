Return-Path: <kvm+bounces-42118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B73BCA73239
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 13:30:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8871F3B6861
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 12:30:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C68AF2135B7;
	Thu, 27 Mar 2025 12:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="i+/J5QQ4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2043.outbound.protection.outlook.com [40.107.101.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580EE322B;
	Thu, 27 Mar 2025 12:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743078646; cv=fail; b=XBS6LwKRERlzJhLjRT9hx+cqtPJGShnmdAHuJwUDWo00S0QMg+69+nISytl5b74m/vdRQbIYgnZOOkWy6SfV4tiyPwMtEhnyksV8ktcdjI6hhS3aaZTyGI7WWN3zppDtLcykPBuuQQIfnUxahQ+uwrnZPzhogCboPN0tQchgJuk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743078646; c=relaxed/simple;
	bh=eo0GCNyZ7XDhhelBXuYx6XyJ4yTMnoGq5hORCklKydI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WaQI0iYZkdOjcYKS+JIBmXT5AdR4Yf+qTma07IWEVMjZtTsnb0It73/8RnsI2dQoOFUvpVd0HBO3Dt96Fd0kvd+3gN0rdMx9giRnRTlEHWopEJ84q7B9qYMtIikA5r5sxMc1C3yLKt0Xb7jZmL3GklBmZoRld7HnfxZ4I3KffTQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=i+/J5QQ4; arc=fail smtp.client-ip=40.107.101.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TbXGRb7zu3X0WDq2otu226gS00qM3R1YK1jh8lqhTMhIEOn9A5Arq2M7wt49jRv8RyipITpEak0adQd5mF6p0yUcwVkNlO5/RgWPfGfGvNfldGU/N+OQdMcrFMa0zNUaUQ/V0FojuKTFNz2ysXzl2KJwA5O4RY0p9Jbr/CFwihkyb1gv0CQNnMTS1C/k4pePjVMbtNTMXPOImQDMi+FUuQy30/75qYGslryDC+dYcmabkleDZGZuflW7cw6GgtKU8kjFB/tfhH7yc645rhUlCIsoqmb2oP6Gha66qJUIOpsdpuCfmGvsjoVEnJVe9qh+eE6cA+3K+FXTqcPf0iGCqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=irFukZJWdKAZO1/VKPgAkS5kOCDUgnGLP0HD84MTXmY=;
 b=iJF00F/m+GexCopAg0Y/J2HK/nBr1m9mDn2Ks3tW4YIPxEBnVNn63MxgVGrdF4N5ze1lc3jmYQ3QPcrjQ8Z4PL9zhaN+cCr7b4Dx/U5+tr8e1q6MS+2X5F8XiXW/GqPvM8jC/Hw6BfCmXiClOSdWkfggVV/3McnU/L5DWDEDo8JDEFUTgW6jJ4wCmYXtbHTBKhJsKYxhrvMxwhnP05izLoU9ed/yAMeqFZ9JXj7PvnN9F7fzlRjIZ2yUGo4FVuGxaAZPsBjIiNPDLHRoQ8xeXXwCIPCUoOU5S+/uMJYNhQHqnEERPzEi4ec99TZn3riGca2zS7PMfKU3yGuZuC45ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=irFukZJWdKAZO1/VKPgAkS5kOCDUgnGLP0HD84MTXmY=;
 b=i+/J5QQ4VLwBiEh4nUrlaQt6x0tx9R1KFGOGaDpCggBTFWjxOV81BTU6r+VKRb7YXqiWiZ4rfylXYMJI20LmRkR1+EL1IdHLzWDbgP9N0qJxkwb4S5lKtHVe0349uoz9mrK5SCZH+pWhS/4C443FaXjdyUGZRY493KjrWQbvXlE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 DS7PR12MB6192.namprd12.prod.outlook.com (2603:10b6:8:97::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.44; Thu, 27 Mar 2025 12:30:42 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%4]) with mapi id 15.20.8534.043; Thu, 27 Mar 2025
 12:30:42 +0000
Message-ID: <2f698346-879f-46c3-b054-c5cc8984b36d@amd.com>
Date: Thu, 27 Mar 2025 18:00:30 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 05/17] x86/apic: Add update_vector callback for Secure
 AVIC
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-6-Neeraj.Upadhyay@amd.com> <87jz8i31dv.ffs@tglx>
 <ecc20053-42ae-43ba-b1b3-748abe9d5b3b@amd.com>
 <e86f71ec-94f7-46be-87fe-79ca26fa91d7@amd.com> <871puizs2p.ffs@tglx>
 <fb4fb08d-1ea5-4888-8cfa-9e605e6dac34@amd.com> <87pli2y8e3.ffs@tglx>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <87pli2y8e3.ffs@tglx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXP287CA0023.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:2c::36) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|DS7PR12MB6192:EE_
X-MS-Office365-Filtering-Correlation-Id: f4b71101-6a0c-4f67-c96a-08dd6d2b305e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZnJWaDBrK201S3dTVitXdzdDeWFudEtWTVppTGlpOEJwTmNteXVydVl3bWJF?=
 =?utf-8?B?ajJSSGtpZng5RjB0bERGTHpOS3lmMEczVlZycjJzL2dJVnlpWXl5MDVrZ09E?=
 =?utf-8?B?WlB0bWFaUGRjaUErMWtGQ3U2TEh3UHBkZkRMRHo3MGhYRlFCbE9RaUFzNTUr?=
 =?utf-8?B?TDVCMFc5SzN3UXh0WTdkUU91SVdFOTVBMmlnY0Z2QWxRM3BOT21GcFVVQzNC?=
 =?utf-8?B?aFoyb3lNT1hCSUxIU2tHdEFIVjR1aUxuL1lLVm5qSGpqaVhWdGk0TEFmalZs?=
 =?utf-8?B?c05BK2tnTnVZdGZRRU5kVVlXQi9sdWtnL3FaTlFDN0JsbmYyRzhOSXNwZVZa?=
 =?utf-8?B?WVQwcFJRUGQyeU05dzZQTk9FTDh4S3JjWVBqODhhdkJlcXRmVXYxbkh0M1Jq?=
 =?utf-8?B?VlUzTFhiYnkwK0REdjcrS29yWC9mS2RWeTNiNlVpTC9TSWxzOHVTamJBd3JE?=
 =?utf-8?B?RHBJOENSQ2IvZnFQQVhIRTZvSXhpLzgza0pxNnJwRXNxZ1cxVURpUVJzbTFl?=
 =?utf-8?B?bmhrcURNWU1YWHN0czhodmpMckZuVjgyR2FxZnM2MGJGaVZYQ29Sa3ljVDRu?=
 =?utf-8?B?ajRCTXZ3REdqMDlkNE9hUm51MW5uY1NRUU5rTFlyMW1tL2QyU0lUbWdjMUha?=
 =?utf-8?B?UVpIKzJOVlNYY3JyUGZ1MUhlVVZCUjdYdU9mUldGMlo2T1FjQlA4N1drVzhI?=
 =?utf-8?B?KzJyMStNWHRybzBLdExkclFhejRtSzhPeWwyRFV3RjR5aHQ4R05HT3dEb3lx?=
 =?utf-8?B?QlBnY3I5d1VyTGdRSkd2bUlHNkhJakxmZVJDdTFtY08zMXQ5dVNxTmxyR0dD?=
 =?utf-8?B?aGJvNXF6UTlQZjZPME5vamZZSmFldEFaNjUxZ1NqZTcvdkJUOTg5Wkx1TDZ3?=
 =?utf-8?B?RGVwSCt6OHdTRUJWZXVsc0w3RHdTYVZVMFBCSmYwNGlnQStpcEJvc1FRSVY0?=
 =?utf-8?B?aFpLMjdXQThQOGhZT2NBckE3TFM3WmtSWUhBS2QvekQxUkFYUG40aGhwTDBi?=
 =?utf-8?B?RGorb2swU3kvc09ZVitmcjl4USszVnVLbzl5V1ROVUF6MEJKY1dLNHhzYzdW?=
 =?utf-8?B?WmY0ZE1oWFVVVVR6UGg3YzhUb0FBSmVtYkc4dlhaa0xIa1BPbGZLeXBXejd1?=
 =?utf-8?B?WmN0cTkrY2VmbU1RUG1qMFBNSGlaa0NUSmZHb2J0c2h3WERiRUlLYmQydGI1?=
 =?utf-8?B?Z21SeUFld1R2VlJrQ3hnWFpGc0hnRFNldmZMRTZFNXNqRW5SZXVGVE9abFJ0?=
 =?utf-8?B?SDY4aFBHUkwxMnhScHY1MXZGZ1laa2R4MTZmbUVFdXQ2ZGhYTGRPd2lIZ3Ax?=
 =?utf-8?B?bFFFdXkveUlqYjZlWElybWhWVWk1eWJ3VnlUbzBJd3IyTVl3bnZ2TXlOZHVE?=
 =?utf-8?B?b2pxai8rSEFmWXZMc0FPZnlJMWFsUFFRZEhISEpQdHpMTkNzTnNVbnZ4Rlk0?=
 =?utf-8?B?SmdHaVFkWkRzS21iL0Rzd08yUld3d0Y0NEIyOXkzRGl6V3FUelN1K1ZaQ24r?=
 =?utf-8?B?Qkkwd3NzamtsVzcrTmgrS0k2NW41MG5SSm9FbmVsUHRYby84MHZockZka2tm?=
 =?utf-8?B?aWZGYllaRklvVzdPY21McTk5NjlFMHE5Z05YUWF2VjB2Wk5hTzdJWXJFeHd4?=
 =?utf-8?B?RXA2Z0Y4cS9FQzduV2RvSlgvUmJzeDhyMFRLWExYZnJ6Q0tQNFdSbXhqVy9D?=
 =?utf-8?B?Q3ZkU2V0VkNBTkxaR2ltWFJtTVltTGpaZlFvczY3MkhnZllyeWxaUFlzaEth?=
 =?utf-8?B?SXZzZXhXdWFJNzRCakJIUHZEOVdwdTlxSXlUeEw1TlhGbkhmdFhlUTFLODB5?=
 =?utf-8?B?YmpDUkE3aFBjdDZYbDIvN3ZnMDgrQXdJVmVGSlFBU3Bxckowb1ZsV3ljYUVX?=
 =?utf-8?B?T01QNzFjcm9iZEQ2Z3JlTWsvWkR0N1JXMjZhdnJVM0FERHBkdG9LcjZicElN?=
 =?utf-8?Q?O6Y0vMo1f2Y=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YVBqUnRmT0I4SDQ4cnVpQkkvaDRVdVE3VGJRMzUxVHd0ekxLTEQ4Vjd5OTdQ?=
 =?utf-8?B?c0FKVVI4WUlIdXhVYzBzLzJNbm1VZWNLUzFoTmhGNWc5bTMzRllOUUFuQmQ2?=
 =?utf-8?B?bm96R1JzeVV2RGdPdHA5L2dSTitkQkFMUHI0SDBFaGJ0Rk93aVQwZndsS3RD?=
 =?utf-8?B?Q2t5SE1IdWFEM3I3MWM0ZlZxTk80VnNRS0M1MmtaSE0wL2hHcTNydlNGMzFY?=
 =?utf-8?B?WUxxV0ZaeDlJQUJNVVJzVm9JZWh0V0ViTStFVi9QekVJamJkN2k2eXNJRnRj?=
 =?utf-8?B?ZmNpK3ZIa0RlVlBCaStXZU4wWVlBSXJWTUdQMlhLV3hVUkJIdVVLWUdJZEJV?=
 =?utf-8?B?RXhPQ0xvTHREcTVxUTJJNkxLK3gxUDFNanFUSDhxMHFXMXIyeHNya2VaVG80?=
 =?utf-8?B?VkYrRENDK2szWFdwYmRsNmhkdTB4NC9laFB2T1ZVMVZLQmszQjB5QkZpZzJn?=
 =?utf-8?B?Y0lwNXVyWEVkZmIyeE1iVzZ6alMwWjJFL1FvN2VWU1R6NFVpMVJWcVpxTm9z?=
 =?utf-8?B?Q0VrQjRjR1dHOWl4L2NKMGpOLzBLYmRCMkJoR0ZPNzh6MC9RMndHeHlJWlVG?=
 =?utf-8?B?blQxbTBMcjZ3eGhnamdTaTVYWFpYS2RUWDlGVm1VeDhKRmc3elJNanExMFU4?=
 =?utf-8?B?Q0JuRzVzbWRBVFdnTVJyN1dMaHBTY1hBSk02ckUxdDRiYys5ZE9qZDFFUmRD?=
 =?utf-8?B?QUMrQnhJMDRhUXhMY0IzSDBCTDdCVllENE11SDR5ZkdkY0ZkcmFuMzU3aUlp?=
 =?utf-8?B?cXhMR3ljeFpvRGE0Qk9MSDZhdksxZW1FSGtOMUxFOTdtMWZUbngycGJ1eHZw?=
 =?utf-8?B?N2hydEVVUDh3eGl3aTZaOG9CbGJWS3ZLMkp5aEQ4S3lpVEFnMWhmNE9yZUlH?=
 =?utf-8?B?TFpVbkJzWTNLRldkempZWWtTTG9oV1I3OTZsZDh4clF1SC80S20xRzNubVB6?=
 =?utf-8?B?akVOM2Q5blhjRHAxQnAxSk9QNWRrZGIvN2g2cDlsVk9IQUZYNTN3eEhCdWk3?=
 =?utf-8?B?Tm5qcWxEK1JpNVpSNWxyenY2QnRxRXJTVHEvRXhWVU84T2tqSHBoVExORkJX?=
 =?utf-8?B?QTRPTHNNS29DTTR6NFhQV1RSeSt5NDR6YkU0Q0prL0s0SXE1b1gwWUV2WDJG?=
 =?utf-8?B?dFRrd2oxUTlrUkRRaDdESmpNMksxampNWVRJaXRvL0FYSmp5RFFzc0dITG9C?=
 =?utf-8?B?L2x6ZFF2bmpCSkxGU3J1KytsMTYrUWtaSWRYK0lqUDd2eEVxUGpZUU1CZEpi?=
 =?utf-8?B?amtUVGZOZTJEbTZyWTFwcGh4WWQzWnl6dkh6b1J4REpRMVl2R29vdWhERHNV?=
 =?utf-8?B?NjFjcjYxQTBiWERoOHYrRUtaSHFualZDWncwVU5obE5KYm04RGlVL1kxcXBU?=
 =?utf-8?B?U3pXb2VIbnc2RW8vWXA2U1dnMFdVYzI3WjNmeW11WnYrUGZJZEt0UWZpbm9N?=
 =?utf-8?B?YUJ4a240RmlMMlgra3Bsa3RFK0Iya3JwTXBnL21adHY0c2ltSlBROW5oME1m?=
 =?utf-8?B?aXdiZSt6dWUveHdoK25CRXorcm1UMmNxUStIS3QzelQvbUxnSmNiMGd6aVY1?=
 =?utf-8?B?NnBDVk5sMkZHekM1OGlyS1prQTVtanR2ckhEalc5d2pIbUF3L01PaTVHeGhl?=
 =?utf-8?B?ME1oeU5xZlptNXlMQjRWZFNMcExSbERnaXBpRGJFK2pDc1RRY0pBeVFmR3p1?=
 =?utf-8?B?aERJK1BkSkZMNHkyQklYNWF0aG9oenFodzVUVlNyYytRbDZyUHozdVg5dzRV?=
 =?utf-8?B?SUNobmtWczZha0ZlYjhsR3MvZmRYVW1ZVHdvMHpvM0lDNnk5QjVSUlhycnpr?=
 =?utf-8?B?OGZWV0lsMVhpY3RlNFlpeUJnUnVWcDlBZDJsZFJXV3N3UGlZcHVOOUdPcWR2?=
 =?utf-8?B?RUtxYXpZZEpRVkZCOEh1TW1Na1BmNndiWHh1cFE5TjBkZ3ppNjUwdUlZL0pt?=
 =?utf-8?B?ZFN6OVZoK2NYM1BWQkhQeTZVSmhOSnpvRFN1TGRXcDFRNDNXaW5mTitWb1pm?=
 =?utf-8?B?R3dEVnRnWmdVZURMb3kySVZNZDMvTDNvb2JweUwrbFRHb2xSYW96YUNUSk5V?=
 =?utf-8?B?cVlOQ0ZEc2hERkFiM1FMK0QyQ3lXWXRvVmZOeXQvaE13dTROczRSSnFPcU5T?=
 =?utf-8?Q?Vk1tbQrjZfI3yXbfKAoZVaYdG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4b71101-6a0c-4f67-c96a-08dd6d2b305e
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2025 12:30:42.2908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i0cYjw7YLE7siiXjIReNqiBSMcF2drhU86l1iBI2PTjV30rk79wd5R3vakR2tUOWJ8wUUu+qmOrwKTZWyLN0DA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6192



On 3/27/2025 5:48 PM, Thomas Gleixner wrote:
> On Thu, Mar 27 2025 at 16:47, Neeraj Upadhyay wrote:
>> On 3/27/2025 3:57 PM, Thomas Gleixner wrote:
>>> The relevant registers are starting at regs[SAVIC_ALLOWED_IRR]. Due to
>>> the 16-byte alignment the vector number obviously cannot be used for
>>> linear bitmap addressing.
>>>
>>> But the resulting bit number can be trivially calculated with:
>>>
>>>    bit = vector + 32 * (vector / 32);
>>>
>>
>> Somehow, this math is not working for me. I will think more on how this
>> works. From what I understand, bit number is:
>>
>> bit = vector % 32 +  (vector / 32) * 16 * 8
>>
>> So, for example, vector number 32, bit number need to be 128.
>> With you formula, it comes as 64.
> 
> Duh. I did the math for 8 byte alignment. But for 16 byte it's obviously
> exactly the same formula just with a different multiplicator:
> 
> 	bit = vector +  96 * (vector / 32);
> 
> No?
> 

Ah ok. Got it. Makes sense. 96 * (vector / 32) counts all unused space.


- Neeraj


