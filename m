Return-Path: <kvm+bounces-67672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id DDD36D0F862
	for <lists+kvm@lfdr.de>; Sun, 11 Jan 2026 18:39:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5945830024CC
	for <lists+kvm@lfdr.de>; Sun, 11 Jan 2026 17:39:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B124E34D38E;
	Sun, 11 Jan 2026 17:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="y2eOpp+Z"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010060.outbound.protection.outlook.com [52.101.85.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D9934D3AD;
	Sun, 11 Jan 2026 17:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768153195; cv=fail; b=H2qzoS4iB3+ys3DeVFsmdNaJWAlWbmQZ/8RKfdgyN2IJtv5lgHeHaz8JEjUI8dF8Sy/Y81qjfGwQ3SvKulaKWtQliAC4ZtYkJaMcOvrQuGlCNWVwo7JgpHFJ4vsok/3imRMBwwusr1VBoAVc9PUUw2heE5JC2wkEp8uyPD+BkO4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768153195; c=relaxed/simple;
	bh=+noijyRzKF07VQGBQs3tpt1BqDH1qUCcsEkK42a6JL8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SB96UjeH3VLa8SHpwEkY/Mr/R1cHUDYkW26lVnOtHcgk8Rl1RWK3uIBYdJjdrVPNlQ+EGH5ry0bPjy0n0z2ktbb4Awgakc8xm1VZyPTy22/3l+Vgvx3l5IpijKnWSVU4Nc57FHBD9trFu3Ur9Nm+11Bocf4NNdXqIs9NtNV8yN8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=y2eOpp+Z; arc=fail smtp.client-ip=52.101.85.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rk3zFHSmcUbkA8NQmq4CpwzOp7H4fjqOg0kfzPQIjWe3gEB2YruSmUuqy1YgvHVh3E3uJbK89vEn+3cHvaleTH1m5y4OohfOkizKnpyata30i/c3XfyUZ8d1GzdJMVIJ7sWnRLlRllLf4TBf0spkIVLwXbaVRcgBHcj+5YdiwhoeLTQmBj4PmGKZXEiXEmtH7t9Y2HlfR8oT/hG3FiS8lhUMlfJYUj4Yu9ioMN0gZqH2Hsv9XsR4cOey0FDyAhBI9GAmrjvsqX0EyfRWGEgYx657uM8XjDGd5OdhW8kC1k7Cfvc5/xUt5KodM7oD67vLNR6reMO8JRwqqAHMK+53VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vI/z/lJi6dUo8JUZFaVpsVEynnbKUas+CA6LmkQGnQs=;
 b=dhoXQ+r/3NMmwmbzLiFXlrZA02x3AfykRHwOVXlpvld5B6nDesXPDgCfR5smidqUBsw9E6wicPEMk2STwwWLeujTpNyi0SLPWRIcUrzQw3wyGulWNJ/asVz46mcyb4Pu6jLirp7WqdAw6f47VMdaF3EGM4zfZu+0UmYyQ8McgEZfL3ihJHOZmtCNZKLwRHxcz0qomqp+m+u6fsM04LBGyTnTmh2ZIuQPnMYKiq2YnsyuKgly/GDUyOMxvcXgGnJfB3JnGvFsmRafK2L6efeafQZoTPUuAUkeIm1E6CbBnt0CPKv1kglm7dP/dcP6ndJcIqkZoAspjq15nH+uOQ998w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vI/z/lJi6dUo8JUZFaVpsVEynnbKUas+CA6LmkQGnQs=;
 b=y2eOpp+Ze3ndqEOvlr93XsGEQ946N/86vtl2qJFtKttY353pX0DcLkkXmh/xiEdJQAejS5N+KFRTSakspHiOHzTc5Oz1qQdWKN0ghv2GYufmj7KLOy1tLTNHEnyVszcUjKFV1CMPOTJHQI0l7npeng4uk2I2qHz11B5haBQ+baA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH1PPF934D73F2C.namprd12.prod.outlook.com (2603:10b6:61f:fc00::61a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Sun, 11 Jan
 2026 17:39:49 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9499.005; Sun, 11 Jan 2026
 17:39:49 +0000
Message-ID: <a1b05197-0e0d-4f3c-9b49-a2236df6a0f7@amd.com>
Date: Sun, 11 Jan 2026 11:39:47 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: SVM: Drop the module param to control SEV-ES
 DebugSwap
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260109033101.1005769-1-seanjc@google.com>
 <20260109033101.1005769-2-seanjc@google.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260109033101.1005769-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:806:2d3::7) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH1PPF934D73F2C:EE_
X-MS-Office365-Filtering-Correlation-Id: 39242a1e-9f6f-4722-f5ee-08de51386afc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dlZBYVc5RWF5ZFFSMkYvKzErMVA4TTc4Y3ZLdGdUQjN3b0Ztd1Rma1lGRnR0?=
 =?utf-8?B?M1FRUDRqYUFGeHB2RU5nYjhPVElMSnhWL2NmNlVObDlnclBwV2dxdkpkbkxJ?=
 =?utf-8?B?VHpzUGZ1MUNvaGpmYmhxdHRKQ3BDMXErSXQ2aUtQcHVLSTFFMzc0bXIrMFVk?=
 =?utf-8?B?cE9yTklKWExWSGdyODFxOXpvMDRTT3l2eUlYVGJSNFlRSys5WHFhUTQ5czZ3?=
 =?utf-8?B?Z29xLzVCVm5KZjhtQ2ppTTM1MW00cHMyVWk5RVBHZnA1RXJ3c1daWVhGVkw5?=
 =?utf-8?B?MDZobVlDRGNzSk8wb1BKc291T05KZ2l4R2Q1MHF0Z3k4UHFmVVhJaFZTbVVF?=
 =?utf-8?B?eW5RMVp2U3daVzVqS3ZVMmNscm1WSGU3RTZvSVRoMzVjZnhMVHB4QU9HZjlk?=
 =?utf-8?B?c2R5UUFDdGVqNkZMa0Jadk96eWxqc2ZITmtuVzJhMFBzbVIvdjMzOG1RbFdT?=
 =?utf-8?B?NUx4c3RCMUVGbnFwS2NFM2hNWWZkSThkbjJaQ3VPUlhvK2xNdHFQSVFhdGZB?=
 =?utf-8?B?azNwbTJFTHZ2TURwQWVEYWJqVmVFanMxMXU0ZXd2NHp4L1BvOVBUbkREaFRC?=
 =?utf-8?B?b3JJbXBXOVpiWFgwa2dBRjJuRjB0VzVCZGtybHR3dnF5eGtuZWpkdjJJdUNJ?=
 =?utf-8?B?SFZYZG5XSHN4bnZ2SVpIK0NsREk3UnFMa0IvSWJkbS9JbndTb2pEQkNOazB4?=
 =?utf-8?B?elNxY0QrWWJQdzh2aWtLVnlaM0RPQ21lZWpveTVHNDRSTElWdVBPWUxvaS9U?=
 =?utf-8?B?NnZPRzFQK0VCdThKUk9ucUUyck1rdkRhM2p1S2hOMWk5cjd2UWRSWG10Vy95?=
 =?utf-8?B?UDR0elVjTWJub3IyZkpCTmswbXRFbkFhMW1jZFZ5U09uZkpkWmU5a2szUU5C?=
 =?utf-8?B?cGgxcmpxLzJvZGNjSTJqS2xZZlR1VVhUSks2U1laU0tEeWFZazNzaFloZTFT?=
 =?utf-8?B?Z0h3YmdRRzdjMm9YZEVNTnJ6N2hUMGg5RlVyN2dDbTkzdVBWdU9wVnJlMTFN?=
 =?utf-8?B?WnphQm0wQnhmcTROazBIVnZNOGJLN0NqOThJRC9XU0lCWktiaTkzNE9IMWJj?=
 =?utf-8?B?Y09mNXBrUTIxbUNLb2l0MWVrR3lQbW5FM0hQdEhFeVM2eFhFb3ZXRi9hSmFG?=
 =?utf-8?B?NXZzSXNzWE52Tnk5OVY4Yjc2U3BDK3gxejI3dlpiaWphd0ZOV1JkTTgvODNV?=
 =?utf-8?B?OXBWOExNd0FTajBvWjgxMjJvd2dGZnlyVk9iMlBucDAwNys0UEE0WUFvK093?=
 =?utf-8?B?cHA5VTFoZE1PR3dVaXpKMkZmVlR2bUdkM3pTRkZoeXRkeXBRR1pIYyswSG9S?=
 =?utf-8?B?R2p3VmxZVGkvMStUa3hPdnZtRE5WZ0dlay9pd0NGTUJnR1BISm9qZDZrajRQ?=
 =?utf-8?B?d0RaMzZQd0tEaXdTTVl0SFUrSzc0bVJSczhTYWtjMXljOGh3MUhQUU5USWE5?=
 =?utf-8?B?MFZpelErOE9NREg4bTc0YmE4MVV4YnUxZGd2T29RdFhia1lzeWFNc0cyWGVP?=
 =?utf-8?B?Tk5VWlh0Y281YjZyWFZWSU1EaDdUazhlcFBmTzJielFkdFg3d2xHeXFKbFlP?=
 =?utf-8?B?VHl1UnY4Q0s1NVV4V0xVcURyczd2TzE0NVRBT2NiNFd4RlB4OENDeGcybDBk?=
 =?utf-8?B?NlYyRmJKOFB3RjhicG9FSnBseEFSZXB1alVrUjQ4dFpZMThTM2ZNNGI1VVZ2?=
 =?utf-8?B?Y2U4a2o0UEhkajU0OVNOVUtzdVlDK3dNTTlCbzlwZFFmcXliQ25EbTU5bHNB?=
 =?utf-8?B?eFQzK3RJdlJQWVhySWJaL1VMaE1NNEVwWER0YnNwTWVDQmNiYndvVnhJMnY1?=
 =?utf-8?B?MDZGWDh1TTNmdVdBak9Od29VT09hdU9RS2czaXcwR1p2TlBvcnlqb01WL3R6?=
 =?utf-8?B?N1pCTHZrZ1c5ZjQzSWxUYWpOOWtLK2NVMjhYMERFRU9VRjlWalB2VE0xaHI1?=
 =?utf-8?Q?4Ov4HV0zBB3Ne7zRU/WH0GiQ/8Vw3/H+?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bmVoYmVOcUd0c2EzK01UN0JIbzExUnBhNEVwR2ZXa3g4eEo1R2RzcXZ2V2Q0?=
 =?utf-8?B?c2JBQzFmNklIckdobnViN0I1M1JXOEpwQytDZW9MOXp1ajNhakZyYmEycnBH?=
 =?utf-8?B?SndFb0d1ZzRkUWJOTEI1TmVUV1FCenpueUZDd0UwRVlxVjk4aHI0RWRhd3FT?=
 =?utf-8?B?YnNDRHhFM2ROVzlJdDlyYncycGVjMmRWUEM2ajU5Q1RHL3ErL2xaU29WV2RS?=
 =?utf-8?B?ZlBjc05lTHBDYjJXdXhCSDBhbVhXR2M5WXlycHN5Q3NyVVFXbXJVWis4Tll0?=
 =?utf-8?B?SmJTS3JsNzI1QThsNWlybUZaMCt0cXY2M2ZpeURUaXhPZW5aNGZIelEwdHRp?=
 =?utf-8?B?cUdhZGFnWk9BbXZRUzEvdHBDK3JjUVVtSHk3QklMa3lCU1hjMHlnQ2N3KzVl?=
 =?utf-8?B?cC92N2UveXdkOHplUFo2VWYyU0NnVVBUMitDSm1ONDJjNWR3aGVXWFNmb3FG?=
 =?utf-8?B?WUY4WTFvNmJHV2svMlo3SUJ6YU01ZkVxRldMcDZPVE45Rk8zdk5MdG4rc0tM?=
 =?utf-8?B?T3dDb3ozUUpkbDIzQnZRN2NyVnFIdDk3M0YwSWxJZno1cUI3U0thS3NvWFN4?=
 =?utf-8?B?ZjFWWkZWZTZkSmdCZWVUSWxqZjNmK01uc09YY1RmUXl4dkZhOFdXU0VQYlV0?=
 =?utf-8?B?RFlNK0YxNU1ZQm4zMTlWeVRod2VKSjRrWnlxYy8zaUE1b08yYlZDVUU2Sm0z?=
 =?utf-8?B?bFZta2xhWTBrL1pRcDFaQjRlVGpPL2FzZzZJQnB1ZzJNM2t4M0JBNkpGYnVV?=
 =?utf-8?B?R25EZ0x3QTRLQ0dGVkNRN2tNN0hEcnhiRVk2QVk2RER5Z1Y4UHFkQ3h0TG56?=
 =?utf-8?B?ZjJsaEpGY0tjN2FNaDRNQVovbnNhaEpucVZFOGF0QkYwRWdmdDJ6eC9vZ3ZL?=
 =?utf-8?B?Z0dVWHpDb0Y5c2Y3ck5zdEYrcmI1TmlSNGtOVWxvSUxObzRTK001MUVBdERO?=
 =?utf-8?B?QnZlUVVFRlJ0RWVQTzA3Q1BKNm5PRmtrTmhDV2tWRVdOTFNlMnVtMS9kZkxQ?=
 =?utf-8?B?LzlPSnJIc01KWExwcnVsdGlRTFI2cDZnbnRFSEJLcmppemdhMlFxL211QmJa?=
 =?utf-8?B?Q2g3NXJTKzNiZTQyTVAvYXRlcHJTL2lKc2dOOHNoZTVsOHR5dW5ZME4yMEVL?=
 =?utf-8?B?YWtHc0ZLY1AraXVoUkdhc3gwK0R2WmZkNDBxb0owdWJPMm14NzIxVEhZbVFK?=
 =?utf-8?B?ZzhVcU82QmpGaXdla29zY1VUc3A2SnFJeDl4a1kzUEdJZUdVVVZmejVDUjFV?=
 =?utf-8?B?ZzQyYU5laGpZQlNsWkdodUJnWi9rR24rVUY1ZTJrdzRJVnQrbEZIaGYvV2F3?=
 =?utf-8?B?dmZqcUtTM1RHK2kreDNyVHpZWmxubFp1Zm80NFJyVkRsR1MyTDMyRGdoaWJR?=
 =?utf-8?B?UUlwTE1SQkdxRFhCVU13OHMzTWg1N3RvSXlYV0RkMTFlYkFhL25yOXJnWk9H?=
 =?utf-8?B?MGt4MDZVTzlWbUN0eE1aR1IwdEJrVElzanhxMmhSZEJqaXF5eGJ2WVM3UXRz?=
 =?utf-8?B?WmhkUGZJdmpaSWNqenVpdGpMN3lXOGxldHQ4M1gxVzZuMjVsSndrb0hvNFhK?=
 =?utf-8?B?dWpvTU9LU0kxRG5DZExMZUFEM3dHYS96TEs5VnEyTmNNNjlpcVlrdWR4WGtC?=
 =?utf-8?B?N05wM25aZ0dOU2xEK1pkd01MMUpnaElycGtsc2kxdGhXTVBPVDJQVExPTEpu?=
 =?utf-8?B?UGRRNjlCNCt2OUxUMUNhRUNvSzVuVUk4dXlKbGwrYVlOK3V4SG8rVGZrWVJr?=
 =?utf-8?B?Z002UkVTcWZ4YVArMnNLYkwvTDcvbUlTMENqWG5CRUZqOUpwaDZvUk9ZbzV4?=
 =?utf-8?B?WXQwSkR1d0VZNStTK0syb0dyNkloNk9RT0NQVXRJWHl4MnQ4bXJ3RTdQRndV?=
 =?utf-8?B?NSsxWmM2a2owMlY4c1hYSUdTY21WU1NRakVJSlk5a3NRSHFqZ1VvRFdJYlp5?=
 =?utf-8?B?QjE4MHQycTdpVk02VXFVYmVDS0JZV0wzdmZKUlhueTdBWDVGZGttUGFCVFpY?=
 =?utf-8?B?aG9DcXhSSE8wQ0NXUldGWHBjdkg1Rkxac3grMUVxbmJ6SHpoaU5NWnM0ZHdW?=
 =?utf-8?B?YVhvdFk5ZHJ5SUhkdWwrbmFLQy93TzNISGVxV2MyVWZvU3MvWnNYanFibElH?=
 =?utf-8?B?R0dWSG9ibHRuRjdwQnZsSHpKeEE5bGE5dkRlcnpUdnpkNE0xL2VxTXRuVytG?=
 =?utf-8?B?ZngwNWJsN2VYUSs3Y1lCUi9zbDdBV0pjVGQ4UlU1Y1VNbTBuNktNSDBpMVNi?=
 =?utf-8?B?OUcyamFwbTU0all3OVlPS2hYMVZWUnZ5YVE4YldrNDlKTmNBeER3RThuaDFl?=
 =?utf-8?Q?wEodKrVjQQcJtGFvRu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39242a1e-9f6f-4722-f5ee-08de51386afc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2026 17:39:49.0454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o99mYn0aCZ9s8beqonFCLHsgWH9AbXNKAEhUB+trcIC10q8KqISbtXwwxc3NkFY3HJGKclrRkAFEv5kh2chZ8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF934D73F2C

On 1/8/26 21:31, Sean Christopherson wrote:
> Rip out the DebugSwap module param, as the sequence of events that led to
> its inclusion was one big mistake, the param no longer serves any purpose.
> 
> Commit d1f85fbe836e ("KVM: SEV: Enable data breakpoints in SEV-ES") goofed
> by not adding a way for the userspace VMM to control the feature.
> Functionally, that was fine, but it broke attestation signatures because
> SEV_FEATURES are included in the signature.
> 
> Commit 5abf6dceb066 ("SEV: disable SEV-ES DebugSwap by default") fixed that
> issue, but the underlying flaw of userspace not having a way to control
> SEV_FEATURES was still there.
> 
> That flaw was addressed by commit 4f5defae7089 ("KVM: SEV: introduce
> KVM_SEV_INIT2 operation"), and so then 4dd5ecacb9a4 ("KVM: SEV: allow
> SEV-ES DebugSwap again") re-enabled DebugSwap by default.
> 
> Now that the dust has settled, the module param doesn't serve any
> meaningful purpose.
> 
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/kvm/svm/sev.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index f59c65abe3cf..9b92f0cccfe6 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -53,9 +53,6 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
>  static bool sev_snp_enabled = true;
>  module_param_named(sev_snp, sev_snp_enabled, bool, 0444);
>  
> -/* enable/disable SEV-ES DebugSwap support */
> -static bool sev_es_debug_swap_enabled = true;
> -module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
>  static u64 sev_supported_vmsa_features;
>  
>  static unsigned int nr_ciphertext_hiding_asids;
> @@ -3150,12 +3147,10 @@ void __init sev_hardware_setup(void)
>  	sev_es_enabled = sev_es_supported;
>  	sev_snp_enabled = sev_snp_supported;
>  
> -	if (!sev_es_enabled || !cpu_feature_enabled(X86_FEATURE_DEBUG_SWAP) ||
> -	    !cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
> -		sev_es_debug_swap_enabled = false;
> -
>  	sev_supported_vmsa_features = 0;
> -	if (sev_es_debug_swap_enabled)
> +
> +	if (sev_es_enabled && cpu_feature_enabled(X86_FEATURE_DEBUG_SWAP) &&
> +	    cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
>  		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
>  
>  	if (sev_snp_enabled && tsc_khz && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))


