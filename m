Return-Path: <kvm+bounces-72432-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WKyDNrcZpmmeKQAAu9opvQ
	(envelope-from <kvm+bounces-72432-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 00:13:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BF2A1E668E
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 00:13:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A6BCB302B456
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 22:55:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D50D6309F19;
	Mon,  2 Mar 2026 22:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Pt70tw8o"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010060.outbound.protection.outlook.com [52.101.61.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7A82DF137;
	Mon,  2 Mar 2026 22:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772492138; cv=fail; b=OZVChGeV4FldpYbas5mryu34uoCAKBc/Oge+iR5Za8YtUbWov5QEprDVs0eLCdTFBBzs+5pbFoUbpwWnGR9f2nsDcxDbOUHvURWJ3QRZr8XxTqQkMD6DCNESuT3EWVetnZHqKdW8+HkkHyey3hGSmPzV3J6GtV2Vz7Iq6+XcyG0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772492138; c=relaxed/simple;
	bh=IYJy3Nk5fDD/QYzgtjq6nN0mrzkvnLE96foBhqq98jc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=B7a2fRPaAY2KjWz+AkGWXXoLs8Vk6OIwdaAdyI6B3WaGyWg2T4aE/iEkzhsurRL+aQhSTmWLX7rBtYXSxj8AK10Hm3u1nZPdCZQwT8qoE2raFzpkwVhOR+6Dm9I4McT6Rd/82r1CZOz25+Hgt+HJBSCsUmMnxxAQYVi+UbdFSLA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Pt70tw8o; arc=fail smtp.client-ip=52.101.61.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y+4IAVsRjHMuxlNXbPzok7zDnLCFw2wMqgOfsg7YJ0sMY+FzK2fQqua6+2/ZnponmwDG01FQBX3Va0VokbaYaB+y/NlJQt2G9RzhmdIL6ANF9aa4qG9obJ7Ft8okLECL386xsH06iwzdnO0zyEeX+PVPiQZVnGWWJZ5h4b0a++cvlinO3yYeDYLwDfmzbD80x0lK2FnLEPxNXoqRIpZ3KMaRlgl6u7MLwgfHUUHP7YQHkC/vpGrV9tjxUy8bePaUv1GUnn0dreADNqIqGQP7y3RiGNGu7mZoH4QbTdM4q5YCkwNMs6gOl4cCvErS1XHfOIq9ZECqtwO2ulBbpPHnGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t09ApiFgWtBty+iEDiRnQhQ6FwwWtqDBN9xJCjxZnlY=;
 b=cmzntRyoBRBZ+f7qvoK0LOHxPTW7C7ThScExOYzPC1gaKh51/fBNfKadVVro993dvd7gxEb5tbylNt4rbJx2wAnB02aBjTyRXXy5EeROk/Kmc2EMOI9feZrL6sjQ593vxTppgtuXIhSrc7mvYU2Y1SBVHTVpfvJy9CGoGvwZa5LQ8srIykMuCmqtVXEyHThaiDhx0Q8YNGOxf0iETA31WIzkMXwTPETUekwimCj1qWvpgW7AjvgxCH7uYKjoYubhGUHFHI5tv4XCuYcSrETtEJ/cKgj4HPkOM5JDGzJtm9rnbZicss4XwKkLuGAJQutxfWjV3WxDVJino5zPJtAs0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t09ApiFgWtBty+iEDiRnQhQ6FwwWtqDBN9xJCjxZnlY=;
 b=Pt70tw8oHGhEh3G6KQ5Ups/jq1xpShcgW9tvxaLUP6Le5H1bXowkcZ2/h/chMgHwgxhHXUGdjs63/8EZdVuy/QSG0liEP/6M43jLXmKeoOKYTg4bfyXTSfKgoamCyZ9OwrDzeQvV5wk27m0Aas+Nflyx8HJ+MknxD+PfAJYCtQQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5)
 by DS7PR12MB5768.namprd12.prod.outlook.com (2603:10b6:8:77::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.18; Mon, 2 Mar
 2026 22:55:31 +0000
Received: from PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356]) by PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356%5]) with mapi id 15.20.9654.020; Mon, 2 Mar 2026
 22:55:31 +0000
Message-ID: <6a50d050-f602-43fd-a44a-cecedd9823eb@amd.com>
Date: Mon, 2 Mar 2026 16:55:25 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/7] x86/sev: add support for enabling RMPOPT
To: Dave Hansen <dave.hansen@intel.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 jackyli@google.com, pgonda@google.com, rientjes@google.com,
 jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
 babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com,
 darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1772486459.git.ashish.kalra@amd.com>
 <85aec55af41957678d214e9629eb6249b064fa87.1772486459.git.ashish.kalra@amd.com>
 <b5a44f79-8f99-4e61-aaa2-e8aec6f0cf69@intel.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <b5a44f79-8f99-4e61-aaa2-e8aec6f0cf69@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR05CA0002.namprd05.prod.outlook.com (2603:10b6:610::15)
 To PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB9066:EE_|DS7PR12MB5768:EE_
X-MS-Office365-Filtering-Correlation-Id: aaa17e80-bb1b-4654-3c20-08de78aecdf9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	FnJSJdhEuztyjhuINiC6VnhSysZgvUPcSuUUma32t9MRHfYtX+TyAfJJgx/e4aScJbIcX0T5TijOEcUs84DpMs2P8qL7Tp6ApEqfxA1ZnkihREW/nMmafi1dWXmaO0/y4BaBuXp4F30Rlp3Ghtt5QGH2HeIaqFobds4ehZsRLUX39A6DzHdEXjQ72gmzQfV3L4E7rxCQ9vKbjYCB4tgdlJGxol8uoPJgjMu05qUTX7U22QFfkkPcCwGEZWvzSN+pf+LVjNv8skcK0cFNHI/zROdBK+mBUjUp1jEpKoypeZIRzmgyLXZrtyRK9ZkLSNrWiNfyJ18Y4dlq/SVT7zOYsa+qLNk94407WnaG+chRbTbJ+z44pxNEj4t3tU5UU1uojONDtM7HMn90P0WeycP6dapubfW1ahzKGEV6s6vSifTXQnhpa6g3U36EDP8ZOQAm+F2FK07okSS+dpIdab4MyrycXzsZK2lYGTeqZffXBqft+dxOXk0vj3T+0ULxVZhtk6PVv37GT2df09PnYxO32QU997HZJCa4Au7eyyMYgyUaExF0mOF3i24ZHqJj8Xzjm5W677raix1krYV4/D07CHSfZX1SW2Pbff9FqtG8/+CF7ntrESUz4aqOISOtkFTo39ZWFadwVvrjGLLFv3e4uwIAyBREMkIfKgspArjwOvF+0X4QU6H0ILJGQcGOIa1eDpueR2L5FQKVDPQdqEBQ8oevkHXBIwHs+4eIR2RTPL90PB2etIRqfRa2CjNC+y1Fx01uDHCxbiTnlW4nW/3eNg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB9066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VHo2VTJrTytYcWFGdDQ4ekR5SmxETVB4Vm9IQTcvRE1rcnArTTBKamVkUnp4?=
 =?utf-8?B?RXNtK0djOXFQTUorMm9FK2JDM0FUeTc0aVVjQWhhaXFNajg5RkhITGNERDlV?=
 =?utf-8?B?U0V3cmZMT3JFS2ZlbkxnazNGcFBiQmwzL1V5M0dlVHdFVlZhc0xxK0hLM2Zq?=
 =?utf-8?B?V2VWOVlFYlVKR3M5TGRBbkF5TmFBVCtoenlhV0h0TDd2TG1NV2FGdzBYeDds?=
 =?utf-8?B?OVYzVTkvUWRxeEo5cFA4SHNDV21yYXd3WEJCb1B6SUsrdTk5c2o4ak5pVnZF?=
 =?utf-8?B?dTJDMmJQMzVWb1RHUzZHVmFjayttZE1qMXBtRmtQbEtjc3M0SXlyYTdjQ3R0?=
 =?utf-8?B?VEdBS3hhQnNqQnZOWm9iWE5MWXVRYy9TSGFXTC9DTXJiUDBFSTlTNHZjcUdv?=
 =?utf-8?B?QU4xRGJnbi9yUmJSdEllWktxRFpwR0Y5dVQyVThURkdQQnpnQzdQbzdqdmE1?=
 =?utf-8?B?SFRwOFBxVXJzeVpXYmhBM2ZUdHNlSU81K0VVbUgyODdaQmNxUFlRZzNkSlhi?=
 =?utf-8?B?aFZHeTNMQnR5bEF5dTkzSUxmMnhCY01nZDd6TTJ2ckhlV0g0YUhQTkVjd3hW?=
 =?utf-8?B?c1U0b2FPRTVhektrQVlPbTQ4b3hlbUd0K2d5T1RxaTFWb2liQjdrbmhaaWpv?=
 =?utf-8?B?Ymw1Y1RQelN0eWNjM0RpL0d1bWxyclM0RDZ1WjFUQTVCd2kwUGwzYjdlT2dN?=
 =?utf-8?B?VWs1Zy9IQkczOWVoTFFSRlJGNS9aa3c0cGFmR2JXTys5aC9yc2N3endNSXpJ?=
 =?utf-8?B?Qkx1Y0RtNkRCbFFNWVYxTUJoWWVOYU9MemtwdTFyalNOUVBNWkI5blc5SU90?=
 =?utf-8?B?K0N0eDdWMGlTTVVHNzNxVU15YzNYd1RxWTllOEIzT1JNSWFOWXkzM0hOWm90?=
 =?utf-8?B?NGpBbE9UZzNhay8rejErMnpET0JmeWtxSVVSR3orSHhsMmJ2cFZNTG1YL2dC?=
 =?utf-8?B?REZBNklndTdEaHRYY1FFdk12ZzlnSFNPTzdWKzU4Q2pFRkh0MUs5REovQ2g3?=
 =?utf-8?B?WkYybS8vSy9sYVd1Q2oyeG5nTXJoSWNXcnAwWCtrM0JvOUg2Rk5FWHhUUjIw?=
 =?utf-8?B?SUw3Yi9xbXdEcUVPTzY3Q0F5cFUxVWp0RGhMTlM5emF0Wm51UUlFUXBsRk5K?=
 =?utf-8?B?Z0taakdqeUsxTndJQWZmQjQ3WS9ZLzdvcWJIVE4zK09SV3ZOdUU3ck42aDlK?=
 =?utf-8?B?ZHp5YWFkU3VROXM1eVZybmhZV2ErbzRWUlNMNStQNE9uTVNTaTFZY0dDbTJZ?=
 =?utf-8?B?SWJkVy9acXVlMTNhK2pncjlvSGNZMDNxR0R2Z0lTbHdhZUoyaHk4NVc3ZWRl?=
 =?utf-8?B?MXBaYThxVnBjYmZBMk9BRFgyVDBoYW9EOXNqK1dLR3Z3VHc3eVd6M3JUbkJo?=
 =?utf-8?B?SVZSZ1dtU0ZLaW45cXBhcHBKcGVuLzlTcithWHNFa0RxSjMyRllnMm9nMExE?=
 =?utf-8?B?RDZNYlB5RGpEcE1wZmpJMVhrSFBvSFQ2SjJER3J6b2llWEFueGtuU0dEU1I0?=
 =?utf-8?B?NFFYbzh0S0djbnZLcFJFaXdnSGRUSTFnaXNVYWZQbkt1Sjk0eExkSkR1WVpv?=
 =?utf-8?B?QzJzc09TbndZR2tab2F3aURJRHVucXUxTG5hYmEvQzFxZVNzRWNUWUxUdDVY?=
 =?utf-8?B?cFhOWmVPeXpyZHdGL05ua1BEbndNd0hMWDhjN1dqYWVMZEl1QnBmLzJpRTla?=
 =?utf-8?B?WVBUZmVXOGhZWFZ5R3VoUFZ0bXhUb29CbHVsOGpQSWNRNVVST0YrbllmdFBW?=
 =?utf-8?B?cGxjWG5samRnS0JDeC9RWDh0Tll6cVJIZ2JXSFg3b29GNTJYVjgrck9FbW9o?=
 =?utf-8?B?bmFKeUQveitITEJhUGhiTnlzODRMZFZ3eHBvZUQyTVNXNkxOS3JHK3pMTm1O?=
 =?utf-8?B?Uk1kZldtZEJpVUZ1SlVqNzVQaXBsaE5vSVkwazJQU3dERWl0cWdoV3FjaUxh?=
 =?utf-8?B?RHRKNThGclI2amdFMzFEcWNReUk3OFZLZVY0T0drQUVVYTlRV3lwVE90VnRy?=
 =?utf-8?B?U28xdmo0N3VIU3lLWm9OQUtVZjlQNjFBTHF6NnZad2t1NjhBeDc2Y0ZDalZG?=
 =?utf-8?B?dml1L25WR3g2alhzUXFFM2hTb1VsMmFmREYreDZZd0ovTTZoQ1BCK2FxWkdE?=
 =?utf-8?B?dUFhODBWYmRWS0ZNTC91VVE1a2EydE5hYlRDZmJJN3pqdFI2OGltbWl2K2N5?=
 =?utf-8?B?YW5LMTNjbTVpdkMyREloTnd5b2ppeW9sSHllTnZ0Nm1WZmRVc3BzQ3JFZGw3?=
 =?utf-8?B?bTMrTUpFUkp4dGE0aldKbC81K0g1RXVFN1lCSmNMQU84ZnN6Z3J6TXBDUU9v?=
 =?utf-8?B?YjhoYS9OVE1ZVHk1bW5hRjdleGFad0FjY1Q2dnFhQ3VLdXpJb3FVQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaa17e80-bb1b-4654-3c20-08de78aecdf9
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB9066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 22:55:31.0131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L0Tzk7c8eeJYbDl9mYCmJBFrBCxXFwEwl9FBzVETcsTSc5F4vXd10GRHevlbqUcyerUMe/iRfB3vpe7vhxsYhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5768
X-Rspamd-Queue-Id: 0BF2A1E668E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72432-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[34];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ashish.kalra@amd.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:dkim,amd.com:mid,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

Hello Dave,

On 3/2/2026 4:32 PM, Dave Hansen wrote:

>> +static __init void configure_and_enable_rmpopt(void)
>> +{
>> +	phys_addr_t pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), PUD_SIZE);
>> +
>> +	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT)) {
>> +		pr_debug("RMPOPT not supported on this platform\n");
>> +		return;
>> +	}
>> +
>> +	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP)) {
>> +		pr_debug("RMPOPT optimizations not enabled as SNP support is not enabled\n");
>> +		return;
>> +	}
> 
> To be honest, I think those two are just plain noise ^^.

They are basically pr_debug's, so won't really cause noise generally.

> 
>> +	if (!(rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED)) {
>> +		pr_info("RMPOPT optimizations not enabled, segmented RMP required\n");
>> +		return;
>> +	}
>> +
>> +	/*
>> +	 * Per-CPU RMPOPT tables support at most 2 TB of addressable memory for RMP optimizations.
>> +	 *
>> +	 * Set per-core RMPOPT base to min_low_pfn to enable RMP optimization for
>> +	 * up to 2TB of system RAM on all CPUs.
>> +	 */
> 
> Please at least be consistent with your comments. This is both over 80
> columns *and* not even consistent in the two sentences.

Sure.

> 
>> +	on_each_cpu_mask(cpu_online_mask, __configure_rmpopt, (void *)pa_start, true);
>> +}
> 
> What's wrong with:
> 
> 	u64 rmpopt_base = pa_start | MSR_AMD64_RMPOPT_ENABLE;
> 	...
> 	for_each_online_cpu(cpu)
> 		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
> 
> Then there's at least no ugly casting.
> 

RMOPT_BASE MSRs don't need to be set serially, therefore, by
using the cpu_online_mask and on_each_cpu_mask(), we can setup the MSRs
concurrently and in parallel. Using for_each_online_cpu() will be slower than
doing on_each_cpu_mask() as it doesn't send IPIs in parallel, right.

Thanks,
Ashish

