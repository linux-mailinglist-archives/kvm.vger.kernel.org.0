Return-Path: <kvm+bounces-67178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BEFE9CFAF90
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 21:42:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CB2A53098DF6
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 20:40:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0095345CDF;
	Tue,  6 Jan 2026 20:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="yaEeMddW"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011015.outbound.protection.outlook.com [40.93.194.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FD072621;
	Tue,  6 Jan 2026 20:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767732036; cv=fail; b=Jyq19YHi7nETgraDvzKCFq7yUCXutgvhnfUqFiRHs0a/5G8egd6bWZrOW33gmh9jiGpRh7RgHlXhrqIV+SoJJIzSjGN9ANxZ5Mk8sgUBEukFq3KlJJWR4gnSD8omPVVPmeDM1ZhCRhQt2OSmvqi05mcKX2ryPnF7mR98jtGdAQI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767732036; c=relaxed/simple;
	bh=02rHx4kYzT3Eyz28XIUYjhkMKSAEMwGLwqA+iEXcbxg=;
	h=Message-ID:Date:Cc:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eRkMZWYJWHQRoEIM5RDcJOy2JPKncd8ahaW9AXsstno+HvM3AnAu51dr4v2UwlKszbIDFg8Bdh5ZYPRWzsNfk52HQuTvcyZzAIrZyspDgduRToatasSbOtd+p73UPx4uWL0JyOL9ItClCLLXuHoFq+b2oJP9pikNRsD4rjTIPLc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=citrix.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=yaEeMddW; arc=fail smtp.client-ip=40.93.194.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=citrix.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wNiNj0hNSv88y/kDsab+45oDtyfnkw7suHuczu6ONtLUEHsPwaXfIcFr/y9eKna0rXlDVc7I5K+O4m2wP+Id0K/TNNgV2tRCkK9EkToCXtG1vSxB58sWfZ/TCDlIae0AncGbSLOM4tPmL8EGM6/LwH2nz5Ud7O55Uq+bao9mxpVqpJpYLjN4fDVCTmww2jelxu5yYC3lf6ZuwYcZ9tL2oYayiEPNO3dmEAgX2Jxja1CPMcBaQv3Hp+VisPWzUXTOc2LPwxIQZCCDeQl2IDuQiJnuDu5PMZ4b6qHhXEdXt4qgSjtTPW75Hyz3GXZTaxKsFAUVK2v8I81Zsqo+MEzg4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oNt8TAGnz+Tz+KrkJ45zE4QcJf9FSwm6ohXxtncmZHs=;
 b=Hb+Wg4seHMtzSWeT7S0LwuGJvipnLzcnfBrIDXe5qjeiixTrO8IGDpJcev3ncVn5BGKgSH5LtITi4EjUTZOVtNV5ChUf7RamFYimN8Ry1epFkNWwhJ7ATOQqjYrtQhJ22mCbKDJRTPe+IEzUWriRoEt8ctzeosoGjJYnS8wOyub5z15VFlEU65DLF8WeL40+Sep+3LLyIHQY2bkXIzPQRqSSoOkgyQn+vmy95S7SOh7RqEASYSbRi/m2GD005S/g/0prpp7wZyTWLDlsq/q3xqHh6Lv6UuSWLS/yOi39ilqb315sf+lTVsvJgydVfymFukSlFDCUJwUjbA5OHBmcoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=citrix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oNt8TAGnz+Tz+KrkJ45zE4QcJf9FSwm6ohXxtncmZHs=;
 b=yaEeMddWgrbtCM5/KWoxZCEQEqg6ET0jNhgzSEXmYydxI24KSpGSejHpznHPhoI8GMKaXb5I4SWRTvWx4dKHF2YlcaxKWrvWYGuPqSxeF0pzZ69LxHAcdg1EahDxu54+56bwTOUApYeh69IWj5agl1Rwt/m84UMSfY66bDEDYqo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
Received: from CH8PR03MB8275.namprd03.prod.outlook.com (2603:10b6:610:2b9::7)
 by DS1PR03MB7967.namprd03.prod.outlook.com (2603:10b6:8:21a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 6 Jan
 2026 20:40:30 +0000
Received: from CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::a70d:dc32:bba8:ce37]) by CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::a70d:dc32:bba8:ce37%4]) with mapi id 15.20.9478.005; Tue, 6 Jan 2026
 20:40:30 +0000
Message-ID: <29ea5ead-1ee3-4ecd-ad4a-63fd99a7f67f@citrix.com>
Date: Tue, 6 Jan 2026 20:40:27 +0000
User-Agent: Mozilla Thunderbird
Cc: Andrew Cooper <andrew.cooper3@citrix.com>, chengkev@google.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com,
 yosry.ahmed@linux.dev
Subject: Re: [PATCH 2/2] KVM: SVM: Raise #UD if VMMCALL instruction is not
 intercepted
To: Sean Christopherson <seanjc@google.com>
References: <aV1UpwppcDbOim_K@google.com>
 <4c45344f-a462-4d18-810d-8a76a4695a6b@citrix.com>
 <aV1bC3Wk-LbP1hUZ@google.com>
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
In-Reply-To: <aV1bC3Wk-LbP1hUZ@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0333.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::14) To CH8PR03MB8275.namprd03.prod.outlook.com
 (2603:10b6:610:2b9::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR03MB8275:EE_|DS1PR03MB7967:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b23fbe0-1a9f-4e24-74fc-08de4d63d517
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?elVpZVhpc2JPNlpFYlVDVXJjcE1sOGFQU1p2RGR5U3pBeVpqNWdENEVnTFNH?=
 =?utf-8?B?dWlMZjFSUWNLd1dNRmp4cEIvU3dndnV2Mk5SWXVWV3plYll2cy9jaHZjeUVx?=
 =?utf-8?B?TGphSnNpd2lYZVcvTFA3ZWdreHVPaVAxTmJ5NmtlZEF2UWl3WTRIK2pGTWRU?=
 =?utf-8?B?VzZVZS9uSlY1OGRIRXlkOTBza0hLa1N6b1BhSXNGVlVleko5dWlYS1pnZkkz?=
 =?utf-8?B?bDIyQ290cXJGUXVuUmFYUmtIQ2hjbXQ2YjFBMUxGVVhwcmhSalJLZDlNQzB4?=
 =?utf-8?B?UUZna3BhMkdCSlR4M0syWHZ1MUtHQm9GRUJheTFXNm51MTMzZFo5SEZnWndC?=
 =?utf-8?B?b0ZMNFlJRzV0SjF4Qk9IVEpWOCtjN2d1TDJMVkt4N2xaN1F1NG5id3FSeFJJ?=
 =?utf-8?B?d09KSnBXVk9wMWRwdWIwYUJZdkJtWC9XQXdDTUIwN2Y5c2NnN0xleGV3N3Zt?=
 =?utf-8?B?N05SM2JwNFBWc01jT0FQVGpXSzBaQ05GYU82Q2F5em1oSjIyRUQveHRDaDI0?=
 =?utf-8?B?RXJFNzM5YUI3eG9YT0pzcS9XbmpRalBaMVZKeE1xclowTmQwNzFzaFIzdHQ2?=
 =?utf-8?B?T2dJWXpFRWJ0a0NTaHB5d3NLajdaL2pkMmFaenZPdUZnODF4aVVjMXJmN1U2?=
 =?utf-8?B?WC8ydmlCNWQ5TytYZTBBWSswdEtaSnVNQlVFdC9lY08yaTNuNS9hdEc3V2Vq?=
 =?utf-8?B?OHpKdi9uaTgvdWVtblc2ZEtlN2o0M2wvTy9OUFpGRVAwaXRHU011YUVBZGZ6?=
 =?utf-8?B?R1FpMXkvbGhFbHQ3Vk9hdEc2RHM3bEQwQUhjeWUzc3FVMkxoNHA4c0dma3Bk?=
 =?utf-8?B?VFBYMjlibC9KRHpEM3BDRldSWnFhZTZUZGFSV2M1MnA0YjcxckV3Yng5U3M4?=
 =?utf-8?B?a1RwZUoya1RCODVaOGh0Y1N6TTNVNmt5eS9HYkZmVTA5UERUcndrZmZJU2ti?=
 =?utf-8?B?MmlML3pxMVZOMkxIeXJHUGN5LzNZZ1ZXUzIybjVEekp1M3lFRE90emlGRVBl?=
 =?utf-8?B?bkpZS1JQYjEvKzN4WGtiT3VEdS8xWDdNZyt3VTJpU1lDR3RJOVNqUGpMYVY1?=
 =?utf-8?B?VkF2V1VoN2hTbzA5aCt6Z2cxS0hHcFJEa1ZqOHJTWWRDRExWU0drS2hTakRZ?=
 =?utf-8?B?ckl1QjdTYlFMZ3FIQUwzUTNrKzBJeko0elBNcWMwNXBMbEJzVTYvSEZHR0li?=
 =?utf-8?B?eGtmajJBTmNKT09KM3hmY3grNTJZMWp0Tm5lbXFzWTc5Q0k0d3BMQlNNOTBB?=
 =?utf-8?B?bng4cWdLdnphdEE1ZW10V28zZEZhMWpDWlRkeldZNW4zL3g2T044NTRlVmhz?=
 =?utf-8?B?TWZEUmE3Z2lYeUtPb0IyZ0E5Zzdyd21DTHpBckx3dE43QU1XZ2lXREpoTks2?=
 =?utf-8?B?ZXJRbTcxWEFMQVIyL2FabEQ0ZHI5OFc2RzdPc1NlL2RtM2UxVFhMMEF6THlR?=
 =?utf-8?B?L2VscTB0UXBndmgwYnp4M1RCdGNwb21XblJUcndFSUJWSUhIbU1pYTlON05O?=
 =?utf-8?B?V1h6bXhLTEFhelRZbytleUNidjRPZENnQWdZYjlqMDBRRFA2NGhqR0s2VVZX?=
 =?utf-8?B?cUxhbUpoMHMyeUt0OUVsaUo1c1ZtQzNlVDZVNU5CZkd2Yy9OV0RLeHNJaFkx?=
 =?utf-8?B?WVdzSHNBUmpKd01WSzlaTlMrV2NzdzFEUDZVb1c2ZDVIV0VwV1FUb3kvNzIv?=
 =?utf-8?B?dUZPWC85UkRJcFR1cWVNdXJlM0ZaVnl0NzZYdVc4SjB0dkNTZS96c1dHdlBq?=
 =?utf-8?B?UTV6T0lrQ3F4Y3E3L3gra1lNTzRtUkVuOEpyK09EdzFRbmFwYitKejBEM0hB?=
 =?utf-8?B?VlVMemlkYWZyM3dzMHFpcVpWeGoyamp1aWt0ckcrQklyVW1LMllTTkhrR3V2?=
 =?utf-8?B?akROYW9uQ2FiUVA3dVBNRmdZRUp2bC9SSnNzQzFOUjdwR0Q5M0tLNTN5VUpV?=
 =?utf-8?Q?Wyz9K9uVbZefc2GJOMxgrpub68yflwIr?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR03MB8275.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MFE3WXFPc3RpZzZUSXhBTTBiRkEzUVF5bUdPRk9Cbjkyd0Vya056aG1GSklK?=
 =?utf-8?B?V0IzeUlpNmFCeVRMQkVZM2VPMkdqRkdVcTVrNzJIWkdsL0Mrb0gxUmZYY2ZQ?=
 =?utf-8?B?cnBMSkZOQ2hWRTZKOTdGaVJaVlFsam03RmJzSTROQVZSZ0R1bmVmVDBkcUJl?=
 =?utf-8?B?M3FGTXlYTnFXOGxtb2hEd3hpZ2RvV3htK2RvR2xZZU4rOGhzSllIV1F3VUdh?=
 =?utf-8?B?MEJBM09uVzhKa3hMeEVmclZSZTZQc3Z3bmJwUC92TWExS29TdTJUQTNteGpD?=
 =?utf-8?B?eTUrR2ZyRk52UnVXU0tIYnkxMS9iZVQ3a0hlZ1p1Nk5FOWV1UkcvODRtaDRM?=
 =?utf-8?B?WU1na0l5QytHMklubHlabkpFakI2VWkxMkhKVWl1ZUZkTFBSTytMZFJQc0hk?=
 =?utf-8?B?VnZTVFNpWkdacmpIaEdYdDd2TlBBUE5EdG1YRWl2QVV4YlRkT3QvK3lKQWM2?=
 =?utf-8?B?T0Y0STVYVkFjWU5TWk5ndkJrWm1JdExUZVhXS1IxaHF4MVI5S25pdy9VdW5n?=
 =?utf-8?B?QjlPQVBKTzBLTDhrS0VNd2l3V0lrVGZTRWsybWY3YmhSbWg2WG9PZ3RPQm51?=
 =?utf-8?B?UEFydk9SK1lEelRRZERqZWJUVm5acmJ4N1JWRmhPdlVsL1djSUUzKzVYTkVJ?=
 =?utf-8?B?MTVTeEkyZ0gvQUcvV3Z5YWE0ZjJHUWgxcXFEMTR0dE5La3VtZVJZVzVnaHJh?=
 =?utf-8?B?WGFQN0V3QnNiWnYzUVp6RWJVMHIzRVNNMSs4THFHWVpOOVFvbVVhcHp6eUF2?=
 =?utf-8?B?enlpbWduRTVxdDdheVhJWFZSMHp4MExMb3pZaVlIY3FjcnZ3U2ZURlQza09s?=
 =?utf-8?B?a3lCT1haRHVGMy9nc1gzdmU0L0k2aEViUE8wMWpDcU9OMGVGNVhpMUlGa1RD?=
 =?utf-8?B?b2p1VnE3SDR1UXFUeW9xcVliZHVXUjA4N2hmOHR5MVVXcGk5YmpJRXpDbFF4?=
 =?utf-8?B?KzVzak1zTW5WSi9PanJjVDFXNXBwc3VPZlRDcjJiT3A2UFQwNVlla1c1ZVlP?=
 =?utf-8?B?WE9ZQzlMV3pZRnZKcDdFT3JMUkttejBNYm5lcTBRRjduT2xwVGhBaXEvSnJJ?=
 =?utf-8?B?RWdvbkx5QlhzZHVmWjM4Y3A0eHJXYnErc2tLK1oxR3ZzMFJNd2FkUzlncEFl?=
 =?utf-8?B?aVEwWVpWWndKQXY4bCt3bUp4UEhrVCtWT0hTRXRFNXhKVEg5dVFkSWNlY1dh?=
 =?utf-8?B?VmROMElRWHVicElxUWhJdlRVamY2SS9naGFiNjF1VkhlTS8rK0l5TVNJdTY0?=
 =?utf-8?B?RzlWNjg0MHhzNFBEdEgvdUlWUUR2ZzFnRVE3V2s0NjZoN3FIZjFNZTE3Rlc4?=
 =?utf-8?B?RGZWcFRzdlNENEo4RHM2ek1XNTlIQmxUeElDWDhQdFEvTmFnTXMyTWZSTnhj?=
 =?utf-8?B?SHVrU053ZUtBcE1nOE4wVUt5TFJJUHJMYW5TUzVqYWpmdVVqMHJwZDBmbVZ3?=
 =?utf-8?B?MHJITEtOaG1ETFJsOVIzdk9FQjZwbUVEYjBic3J3Sm50RjNCaitXYUNsVjBB?=
 =?utf-8?B?aCs1WEd1TGQyR1ZIMk5FUDhXUi96RlFxZFJLSFhZdXNudEwweXJoVTlzNng1?=
 =?utf-8?B?bnVFbUlkcGhIUHhGM2ZmNkU5S3FKMHYyaFFiNW56dEkydC9GeVUzeWt4NEJ0?=
 =?utf-8?B?VXdDSnZmcU1EdWxhQmgvMUFEWHN5eGUvZnJzcE1USUxnektWSWhmWGEwOVBT?=
 =?utf-8?B?eTV0MHFtcmVjaEk0cXRjclZnVzhOc1RTL2p2QW1xKzVtcGFCOW1uWEFGc0pz?=
 =?utf-8?B?aWtVNHhaVVdZc3hwMmg2Ymg3SndNSlZXeVFRaVlTblhOSmxLTVlkWk5lQmxa?=
 =?utf-8?B?YVJMNGhMdEQ4N0NhWkZVTUc3RElXd3pUd0E3N1l2TmVBc2p2VVFqNzhNQ0pN?=
 =?utf-8?B?cThocEh1b084YXNhMTd0TmZUa2cza0JpM1RDQnp5K3JYYkJQUXlDeVZVaEt5?=
 =?utf-8?B?ckFyNEFlTzduYVFjb3d2dnEwd2pUWFhrZ2pLSzRoTjVRczE5YkQ3WS9iNlpN?=
 =?utf-8?B?dVdlamg0aEg4UWxwVkVXUklydVJTRURHRjZ2blFadXpIZkloMFgvMkF0YURD?=
 =?utf-8?B?Rko0dDhhQUpZQlhkRUM3RTVlNjhIeFRtajNNNnlBSlgySW9VOWhrWTZqb09W?=
 =?utf-8?B?ckZjaUNNUjdZVVc1Q3p6Y3BMQVdBSlhrQU1QaHM1Qit4RUpFRWFuemF2VERV?=
 =?utf-8?B?dlkzV1FOMVpiSGhFY0ZIUUhrNmRaWFhhb3FEK1RzaXZJdkJiOVY1SVpiSWJS?=
 =?utf-8?B?MGMrMG5pc3J3SVZVSTE3VlNHUkVMOEYvclR4cjFrd2lXblRnMEFaNDgvM1I0?=
 =?utf-8?B?QWpqcVU2Qm42WGh0QzBPcmVlRG5xci9QRUwzR2Jrd3dJRmQ1QlpBczVkMStl?=
 =?utf-8?Q?52JSy9VL3jS3bIek=3D?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b23fbe0-1a9f-4e24-74fc-08de4d63d517
X-MS-Exchange-CrossTenant-AuthSource: CH8PR03MB8275.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 20:40:30.5940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1i+/7x9UAd/PPCpxPMXy3a8AaQKhc6q2boN81AJW9TDdyf9vsNAVo8TS+5aRK5CAr7RV4IXhSuZVgOZBup9vOspFYjA4gYgjcdCKkkcLV1I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR03MB7967

On 06/01/2026 6:57 pm, Sean Christopherson wrote:
> On Tue, Jan 06, 2026, Andrew Cooper wrote:
>>> Mentioning L2 and L1 is confusing.  It reads like arbitrary KVM behavior.  And
>>> IMO the most notable thing is what's missing: an intercept check.  _That_ is
>>> worth commenting, e.g.
>>>
>>> 	/*
>>> 	 * VMMCALL #UDs if it's not intercepted, and KVM reaches this point if
>>> 	 * and only if the VMCALL intercept is not set in vmcb12.
>>> 	 */
>> Not intercepting VMMCALL is stated to be an unconditional VMRUN
>> failure.  APM Vol3 15.5 Canonicalization and Consistency Checks.
> Hrm, I can't find that.  I see:
>
>   The VMRUN intercept bit is clear.
>
> but I don't see anything about VMMCALL being a mandatory intercept.

Gah.  I even double checked before sending, but I'm apparently
completely blind to the difference between VMRUN and VMMCALL.

Sorry for the noise.

~Andrew

