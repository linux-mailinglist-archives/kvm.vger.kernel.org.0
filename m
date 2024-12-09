Return-Path: <kvm+bounces-33335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE10A9E9F5A
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 20:22:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6FE7D282516
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 19:22:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75376194C6A;
	Mon,  9 Dec 2024 19:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="03nAUCXf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2046.outbound.protection.outlook.com [40.107.237.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D7F140E5F;
	Mon,  9 Dec 2024 19:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733772155; cv=fail; b=rSGDSQ81N/fDNKbSYf3thg8pQM7bg/z06kIa5Ei4H2mEkuQtAzzoGFpXTVGZRcJ98rvu0lXIdPnYx/43c1fzR04F4FUvbrmfSDz3ulHPIdUIHc8o5m6hs8vXhIM9XgWtcMyKs/TKVTOnKndH6UNoKlsAKzfm7CZP7fwew23a+7A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733772155; c=relaxed/simple;
	bh=vbmkBh9kb3Kfq/Zwf9svMeB4tUk4SVgZT/QdCK5G2v4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nbooE9r/HF7vzd+aq8kCYZOxjrepKNg7JWZVqbjSvDIulrW545me3FOyzKGsVf1KacO45w58nXOHXyozdAvmzMrxRy5bAsWCCZtLg7hbf9X4e8MAv4HqljaiuJ9LPqIauNG9TCSjUHWjwIz41E+HhbHifcxFgrJeK0PAAdf+giM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=03nAUCXf; arc=fail smtp.client-ip=40.107.237.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YI6PpyUHj/h4RWUA0m60Z9wABhKXp/GOyGMjLUCwFLHpzZkG53LQDuqXtJVMroUlYgObWcDiabumdeupxCSm/eVtOsYEyxTquytuVfmSivVcY9N6Hg0bB0TSsvW+/FsJZa27FPyqmNIfYQdadUfTtiZseX3GyXelRqNQmgecKhZJGxukxxxH4gPcqO8cbwcMAEnVTRrh9Z4TVdzqN2Vk1VczWLQDVihtwJDDkoGc4sG/an+B7j/TsYfJpv449sbovbJVBJg3RI0TP52ACV+02RJlMjsAIeGPu97FJk/SLPElF/89dZP8Llb+Isg0Y5l2NdDu3v6n1Vk681REc1BVcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ThCdyJvL7GIF/l2t7+kXWJP7axwTKUvIKHCDKNNzifE=;
 b=yMxDdDAArMgtvx2d7fW5SITK/ciPP4EwLSnr7IYRRjw9LXg6FAG55/fIHf3Rz/IBXZJgdjeCmJJAwTRkDtL0vhl9Zg6H2oCWot+kXF0gMlYOv/cyOPYzBYh4kbYk/4Ln60Jyzd4xyiDa7oy9NjmVwMUZZt2ykkFvh2p4NY6mjGzmVQRfqNj+qzRE1jNMno53MaLx0lP2IrDIy6gvLd0E5CNaQx73/gmqZApwvAQukgyWK57M/jOwv2T25+s/FOJUuNIuE/OhURQp0ZDPya11OGDZIklPau2HgAYIIKQAyCOwDYY1QKZDC/2UjC9bPqHbf7PFdA8Fy8GyrCNYD8GcSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ThCdyJvL7GIF/l2t7+kXWJP7axwTKUvIKHCDKNNzifE=;
 b=03nAUCXfMpLova2ReEsexGWGWu3OmLeaBy1GZ7jwlyXA3drSa9UEgub55LMYbDeqR79XZ3rsFp6sLfp010NF7ZvWd/lKOEyOS+DmcnX6n++p1K/PwwJYaQcKKOyVkZeGaeYPxCON1Cw+modXo2NqgcuC7MT8Me8oBX+OvH9LXeU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Mon, 9 Dec
 2024 19:22:31 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87%5]) with mapi id 15.20.8230.016; Mon, 9 Dec 2024
 19:22:31 +0000
Message-ID: <51541100-d98a-482a-96aa-20790b23df28@amd.com>
Date: Mon, 9 Dec 2024 13:22:28 -0600
User-Agent: Mozilla Thunderbird
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v3 1/2] x86: KVM: Advertise FSRS and FSRC on AMD to
 userspace
To: Maksim Davydov <davydov-max@yandex-team.ru>, "Moger, Babu"
 <bmoger@amd.com>, Jim Mattson <jmattson@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 seanjc@google.com, mingo@redhat.com, bp@alien8.de, tglx@linutronix.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, pbonzini@redhat.com
References: <20241204134345.189041-1-davydov-max@yandex-team.ru>
 <20241204134345.189041-2-davydov-max@yandex-team.ru>
 <CALMp9eRa3yJ=-azTVtsapHsfCFTo74mTMQXPkguxD3P8upYchg@mail.gmail.com>
 <69fa0014-a5bd-4e1f-94b6-f22e9688ab71@amd.com>
 <c05ea1c3-28ae-4c31-b204-05db59b626d6@yandex-team.ru>
Content-Language: en-US
From: "Moger, Babu" <babu.moger@amd.com>
In-Reply-To: <c05ea1c3-28ae-4c31-b204-05db59b626d6@yandex-team.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0188.namprd04.prod.outlook.com
 (2603:10b6:806:126::13) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|DS7PR12MB9473:EE_
X-MS-Office365-Filtering-Correlation-Id: 56f74340-6d24-4fe3-131f-08dd1886d390
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NnZlUGNhMW9nQlRFMjF4dlhJMnFMN25mWThlNUZjUU9ONXI3R1lKNkhKSzZm?=
 =?utf-8?B?L0ZXNGp3aTg4Rm9QRWhZY2ZLb1JEaWZlZVNRZk1DWDc3WmJMS3BGWmtET0l1?=
 =?utf-8?B?RmZFbGMraUluRFR2OWpOUVhUaktsaFA1MlRwa2RWTmY1czJ0TE5SM0hZWWU2?=
 =?utf-8?B?WXlxYjZJL2lETmF0eEhyYitaZ3VSMXRHWTNSWkV0ekg0TitqYjF2ZTZhcXRS?=
 =?utf-8?B?MFpYeDREYTltTS80OXZMV1c1M0VtODhrU294dzA4R0t4ZzNUbVgrN05Sbzhk?=
 =?utf-8?B?a0FhSmt3UWU5MkZEMVFXRjh0MUpzY2c4ZXpZU3diUDVBa3pxb0pOWE5pNWhX?=
 =?utf-8?B?elI1K1k0YnFaeG5ZcE51d0w5S0s4K1E4bGtuOHdPTzhJdWxtalZOM0tDTXRh?=
 =?utf-8?B?eWt3ZzBITjZPdnhSOFJqWFNGL3FYKzhidVBrMlY2UEhvYmJCaUtHM2NaVzh1?=
 =?utf-8?B?eWphVmljR3lrNVpMbThKMGxJVjY3c2JPVnR4VkJNRU14SkMxOTZnejNobWRS?=
 =?utf-8?B?K3h6UHhpQlFqWFVCU3pzMm9xbXlIU3lSbEl4RGVlTDdPa2M3RXc1aTlHUmMv?=
 =?utf-8?B?V05oSUFjcVVoZkFOc0JpOURpR2FuRVlKSWNMM2xFeUhycUx0dFFNVTlqU2tv?=
 =?utf-8?B?R21EeU0xRU5CYnFRRUtwZlZKZ0FBN21VWjY1aDYxdVVKT0VvekNXdmFOU254?=
 =?utf-8?B?TXk1UWVTY3phV1JGaGE3R1NVbmd2WmoyaTZENXJnRTlNZTl6NEwvY3lYMHJC?=
 =?utf-8?B?a3QwWEhIZFh1Qm1XSExydDRhRWkyQjR6aVloYzZ6aVphVXFLaGlJV1pnVEVs?=
 =?utf-8?B?UXhvT0hOVDcvTVg4dFlUdlU5a0lESjhTTlZsRElrYWZ4cFdNM0U1bldLZVFh?=
 =?utf-8?B?cUZ4Q1VwaDU5RXBuREQySXJzS0E3NloxRlVxMDNTNngvTjMwWGk0UVpKZzdl?=
 =?utf-8?B?MHpOR2VlbkM2VWxFOTMrS0hUZXdYU3Jrb29NUTl2dVhwNkJ6NDVtYVg0cnZx?=
 =?utf-8?B?eUQyWVJSUDVKTlFuZFJvKzZxYTFhc3hEZGtucmhtYlZZSXdIajlnSEZBQkxq?=
 =?utf-8?B?VVdwT0FVT0U0ZkJjZlpqa0g5YkRBLzRsSnpMYlNQaVMxUk5vQjM1VGFuYTlr?=
 =?utf-8?B?Ym5aZ1QyNlZOalFqcU9xblQ0NHBkMm5ERUtXdDlXdGhiMGdtejk2bGhoWVl0?=
 =?utf-8?B?Ykp3aFJ2dnk1OTJBTG5kRWZOekNzNHZ5TFJ1dHFqSmZwTHNLbW04M0dWZGl1?=
 =?utf-8?B?dkJsTWw0bmh4a2ZDOE1IdFljaEhuMUowdkRObGdCTXVOMUtxT0VRN0hPc3V5?=
 =?utf-8?B?dEMzTmp6Vy83cTBCKzlDVUZIMTJRTFFzOG9XdXR4NnUzVzBWQ0p1MzRIWGRH?=
 =?utf-8?B?UEhidzNoQVFyUysxTFlWRXYzRFVkTHFaNDlqUU1nNEQ5all6TXBLeC9zNnBy?=
 =?utf-8?B?VlRkdktGNHRKV1Y3dVIvUDN3QnluWlZXeXhWQzhFOCs2NDVhSGRaWGhjSDBN?=
 =?utf-8?B?ZDcxT0ZGSEtXdTA0dDdVdk5weFp1M25Qb1dwRjMwK2lmK08yNHAveExZOXA1?=
 =?utf-8?B?MGJpNGo2MGxyOU85MmI2ZHdTUHR4NncwWFUwQzRYR292eTJ4eE5WbC9yaVJE?=
 =?utf-8?B?cklJQ3BRY0FYRXJuWWEvL3NJOU9PbUZNYVBFT0RpcDRFcnRxTXBKNytMLzcv?=
 =?utf-8?B?eG5XTkx1cVpZM3N5NW1IT3hNWmZrczEvUisyUTZsSjdqWW5xaEUrVWplZlYy?=
 =?utf-8?B?emw5ZVJ3bFFEUVZ3TTRidzJINVFmVU1oRjBLSnovNWl1dk40UGwzTGZBdzFO?=
 =?utf-8?B?VXl5YWRIVkJyVHBkZE1pQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cElid01JUVBOY1M5WXZCcGo0NEF1SlN3S0NsQmpNVkVUNUxMR0Z4WkNRSHdF?=
 =?utf-8?B?Y3BUSnlBdTk1R2tiaWIrVkxxd1B1WTZ5bTdXQ2xKUVBEQnMwY0VXVnMxZEdT?=
 =?utf-8?B?bEMwVzk5Y2J4N0p3d1owWUxxdFlscFNiZThoVzNucVBUaHNURU50WWNmYkFU?=
 =?utf-8?B?SktFTURFaEdCak9MUnByMUc4UlNNQ3IzdGd1b21NK1JYSjBCc3NtOUdZaUlp?=
 =?utf-8?B?bm10MldRQXdwUGk3eEtHNUVQTThnYzhOL2FxTVd2UDRodTBZck9OaGNFaU43?=
 =?utf-8?B?UWxGM2RWNVRyRUJNaGZVMG05bGlTczZvOEJxOFRVWDhMcTBnQ3dERVhaZmRm?=
 =?utf-8?B?cGZTc3lTak14eTY3WGVuT283czlPbWtGTW92VzhORy9xU2ljbjJsU2QxOGJV?=
 =?utf-8?B?UHpnUDRYZGxMOFpNd093elI4TjVvTVVuaHhjZUg2WTdGd2lVaElBZEpXUjBk?=
 =?utf-8?B?cFhwa1owajZvcUw3dnl5WVRiVmFaSFBkZlA2Q3hKeFhNb0p6UElmS2Roa0hE?=
 =?utf-8?B?bUZhZzVmTjhteXVRcFdScHh4YWdXcEQ4QWVtVWFmb05sWTlrTnlOb2ZoYlFh?=
 =?utf-8?B?ZmprNjA3N1hCOElJMWgrU0UvaytMcHV6QjA5cjlEckRGQk9yZUxBM3dFZ3pG?=
 =?utf-8?B?NktpdEFCV200ckwxQnFFbVB5L0tMa3laS0xSOWF1STJqK1ZuamNXQTliRkRt?=
 =?utf-8?B?dElNL1ZhdUthZjYzNTEvdmFza3NzRDAvbnVkWVRNSVBlU2lIUWNKWjJYL0Nm?=
 =?utf-8?B?Yld6RFdLamE4QjkvMm41emNQNHJvYmNvSWlqaE1kUlh2akU1clVqekpQVkh5?=
 =?utf-8?B?MHp5NUJMSlJIVWhCWG1GS0Z5dEl0YWkxemsxNHhZbUZhdFVzUnpjMExlVmlC?=
 =?utf-8?B?NXZoNnhnbjV2RFRKNGtBU3VBVUVhU1Y1L1JtbDAxNStlODhBbEVOM1I1TnUv?=
 =?utf-8?B?dHB3R0tQdE1EM1VsOW9KMmd3eW1lRVcyYkxhUFZPU2tMWDdINzV2eThGSWZh?=
 =?utf-8?B?bXU4M0VvZkZRRUlGRWh1dDdRY0NWU3gzdVVpZStucFFWY21DeXJrSXRmbFFO?=
 =?utf-8?B?N2hOQm9MMnNCUi9LVk5vRnQwSjN4NTY3aHpTajhscGM2TGhUYlJjcFpUVzh0?=
 =?utf-8?B?MTBTWjRnL0Q5UjFqNHNObUgvVnQ3QnBGbUtyUDR3ODE3bmkrdFNKQTQvWmtI?=
 =?utf-8?B?TE1CNFR3QUlqSGdrQkVPdTdDa2JzWE1Nb3ZVN2NBT0JINkQ0akUyWU93aFFU?=
 =?utf-8?B?Mm5OaExGSVVkb1h6TUttbWpPT0xVMU90bGpEN2RlbjhJT0dTNHBWcVJpZ1gw?=
 =?utf-8?B?a0NFYXJTOWEvZFN2WHNGM25VbG82dDFZRDA5NkprRmJ1OWxSOGdOa3RKZEhq?=
 =?utf-8?B?dzZZSDBUeStMNHNZcHBoWWN4cHZVeE45NlJHQ0hOd2h4bVhCTXVQbFhybjl3?=
 =?utf-8?B?OWdFUy9uVWxNYU1JU1FQUEIwOGxDSm5JbWZqYnpNSFBZaXpUU2YwR1hhNm9k?=
 =?utf-8?B?TUJZL0E2ZFJZd0VHdkQ2SUtVTDJPU0hhNWQ4cDc4TXlWNXY2aWQ5L1VQZGRa?=
 =?utf-8?B?YUhnZTRXbm5HaVhTVjR4ZElUSkxwejBPNkYwU3dvZytiOS80R29Wa3ZFLzl1?=
 =?utf-8?B?WGFpelVRSEdCb3k5ZjF0TkdEby9QdWZ6M3Z1RlNPNFNoQ0p4R3ZhQnJpSFJq?=
 =?utf-8?B?a3N5c0ttdDVBcnVMZ2czQll2V3o5Ulp2QW8zc3hJSmRtbWhaZ0N0MXMyV2Fx?=
 =?utf-8?B?TTFSM2ZnTWVWRmcxU2hwNmdsZ1BVMm5hYVpxS1gwR3o0dWRHREdTOEJHNTUx?=
 =?utf-8?B?b1JWY3lCSmJpOUZYVUVXUnlDd3pUT1I0djY0SzJ2dURBYzAyNVVTdS9hUWxD?=
 =?utf-8?B?YUNtRXBZTUxIVzBaWndaZzh5ZFJQZE9UQmlwV2thWDc1Z3RaTFU3clJMOXg0?=
 =?utf-8?B?WFdVQUZRSnU2djdMaVhFdW5saXdZY3JCdG5Md0pqZ0xxdEIwMStBbHZNQnhF?=
 =?utf-8?B?M2lQUTl4RDVza2ljNWFTdHo2aGFVL09vdzJxUVlPZGkwZmVzMnJKNHZkN3VQ?=
 =?utf-8?B?bVg1S3R1azl2NzhoaXp6VVdJb0o5SUp3eDFlTzVlYS9CN2NOOWdSaXFyQWRD?=
 =?utf-8?Q?+sJ0=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56f74340-6d24-4fe3-131f-08dd1886d390
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 19:22:31.2173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2rAUK/eFP4e33mB5BZhkWWzMFMKQcFmf4GpDf1BU5gKSRarWeU8lGkQGbvHEdvRu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB9473



On 12/9/24 06:11, Maksim Davydov wrote:
> 
> 
> On 12/6/24 21:11, Moger, Babu wrote:
>>
>> On 12/4/2024 10:57 AM, Jim Mattson wrote:
>>> On Wed, Dec 4, 2024 at 5:43 AM Maksim Davydov
>>> <davydov-max@yandex-team.ru>  wrote:
>>>> Fast short REP STOSB and fast short CMPSB support on AMD processors are
>>>> provided in other CPUID function in comparison with Intel processors:
>>>> * FSRS: 10 bit in 0x80000021_EAX
>>>> * FSRC: 11 bit in 0x80000021_EAX
>>> I have to wonder why these bits aren't documented in the APM. I assume
>>> you pulled them out of some PPR? I would be hesitant to include CPUID
>>> bit definitions that may be microarchitecture-specific rather than
>>> architectural.
>>>
>>> Perhaps someone from AMD should at least ACK this change?
>>
>> APM updates are in progress right now, but haven’t been able to get an ETA.
>>
>> Will confirm once APM is released.
>>
> 
> Thanks a lot!
> It means that this series should be sent as 2 independent parts:
> 1. FSRS and FSRC will wait for updated APM

Yes. We can wait on this. APM is being updated right now. We can add FSRS
and FSRC support when APM is publicly available.

> 2. Speculation control bits will be sent as a separate patch

Sure.
> 
>>>> AMD bit numbers differ from existing definition of FSRC and
>>>> FSRS. So, the new appropriate values have to be added with new names.
>>>>
>>>> It's safe to advertise these features to userspace because they are a
>>>> part
>>>> of CPU model definition and they can't be disabled (as existing Intel
>>>> features).
>>>>
>>>> Fixes: 2a4209d6a9cb ("KVM: x86: Advertise fast REP string features
>>>> inherent to the CPU")
>>>> Signed-off-by: Maksim Davydov<davydov-max@yandex-team.ru>
>>>> ---
>>>>   arch/x86/include/asm/cpufeatures.h | 2 ++
>>>>   arch/x86/kvm/cpuid.c               | 4 ++--
>>>>   2 files changed, 4 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/arch/x86/include/asm/cpufeatures.h
>>>> b/arch/x86/include/asm/cpufeatures.h
>>>> index 17b6590748c0..45f87a026bba 100644
>>>> --- a/arch/x86/include/asm/cpufeatures.h
>>>> +++ b/arch/x86/include/asm/cpufeatures.h
>>>> @@ -460,6 +460,8 @@
>>>>   #define X86_FEATURE_NULL_SEL_CLR_BASE  (20*32+ 6) /* Null Selector
>>>> Clears Base */
>>>>   #define X86_FEATURE_AUTOIBRS           (20*32+ 8) /* Automatic IBRS */
>>>>   #define X86_FEATURE_NO_SMM_CTL_MSR     (20*32+ 9) /* SMM_CTL MSR is
>>>> not present */
>>>> +#define X86_FEATURE_AMD_FSRS           (20*32+10) /* AMD Fast short
>>>> REP STOSB supported */
>>>> +#define X86_FEATURE_AMD_FSRC           (20*32+11) /* AMD Fast short
>>>> REP CMPSB supported */
>>>>
>>>>   #define X86_FEATURE_SBPB               (20*32+27) /* Selective
>>>> Branch Prediction Barrier */
>>>>   #define X86_FEATURE_IBPB_BRTYPE                (20*32+28) /*
>>>> MSR_PRED_CMD[IBPB] flushes all branch type predictions */
>>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>>>> index 097bdc022d0f..7bc095add8ee 100644
>>>> --- a/arch/x86/kvm/cpuid.c
>>>> +++ b/arch/x86/kvm/cpuid.c
>>>> @@ -799,8 +799,8 @@ void kvm_set_cpu_caps(void)
>>>>
>>>>          kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
>>>>                  F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | 0 /*
>>>> SmmPgCfgLock */ |
>>>> -               F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | 0 /*
>>>> PrefetchCtlMsr */ |
>>>> -               F(WRMSR_XX_BASE_NS)
>>>> +               F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | F(AMD_FSRS) |
>>>> +               F(AMD_FSRC) | 0 /* PrefetchCtlMsr */ |
>>>> F(WRMSR_XX_BASE_NS)
>>>>          );
>>>>
>>>>          kvm_cpu_cap_check_and_set(X86_FEATURE_SBPB);
>>>> -- 
>>>> 2.34.1
>>>>
> 

-- 
Thanks
Babu Moger

