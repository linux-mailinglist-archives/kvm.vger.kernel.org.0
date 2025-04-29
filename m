Return-Path: <kvm+bounces-44785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FA1DAA0ECD
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 16:30:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A09B3A8A6D
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 14:30:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59BF521420E;
	Tue, 29 Apr 2025 14:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="TNVEwTmP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2110.outbound.protection.outlook.com [40.107.95.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27ACC5383
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 14:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.110
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745937020; cv=fail; b=d0okjlYTZQ8+R03/NOoqvwTqCQyDc44tLpniPE//OcyRnH2vGCRTZuODyrrxPZMiqd1wIdKPSBB6qUVIp1/er3HRNP6hAXn/CMiXoZE/puugUNqjh3JqNKxA11qWUPw8JuSr2y7CeeZPpN60VCPpd/mf4jlaCo7MfpYC9P3CZP0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745937020; c=relaxed/simple;
	bh=nZJN8I26fA07ttPefaH2JFFNFA7CvQc0RV1W+MkmC+M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FMWzIfPPLLmSpQ5C8Zy8kvKT8hgmmUXC1DjaVQ+/NRVtHrzm+Njr8+2cSSlx5GN5zxJBv4mHg4DxG+FEJfTRUo15p2g/ldERSfj1jtBHik2II+ykatk7e8bvADSPx3PaiOrPmwtn+Kk+OvdemwDlBWZ0LLmiwc/CNPvaM0wj9Xc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=TNVEwTmP; arc=fail smtp.client-ip=40.107.95.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ENzCRajRsQrNKadLBlZVMkViX2OOHxWC7mb1cVGU8N3AFbJ8noW5v4DAheQ4FceR3znu4wNRUjy+IgjC7uNgy0wzzL46jS55D6PaGil1zY7fBlSc2tZfgll/ES6Ex/Mi0MiTsArmG9CU8whLOtbllvQwSCYLgB2ptunJBcKFX/VFdrzojyJgmA9eOtAHdAdQzTvhaVnOH4gl8pMSrebRI5f94YRis4EJPzgwUt6lRIB7TTvW9u51mG3kx8r21WbR9do5E8AhhUUESm37jVKOUax6m9nPlwzak1HkdVDYMWQkH/P/ZTtnuWEopw6XBAuw+CFNkzMQC9sRhVbzLd5sWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TEOzNs2WPc+dS3ub2TLoWZ6zU55yYhX/vJB3S42Ij+I=;
 b=aYB63QTfskAQBPndxAHlNDt+Lul/Z83J9jiYVJz56jVUuyAeHV6TSSpdxUXUxFKa/C0hBLq4kW5rCfmCAzDLNkT9PzNxV2ajpcy9sPnHClcllnVDImhKAwdfqXQIjCrw4bQi1el5TqYEWG1/VrlGO9Ll/C+UkKHEJbLBNs9qulkkI1FYj71bjIcleBhEPTOd8dLjHa6qkYwLS5Q96Q0GEBUr1tBrN6cmWbH08ovS8en1qAHctLa6pjSXlmIU7zzfjqY1Zql4BWv0dpL1mj94+c5xQB2/leX1i6q+uVXYCzPzXu9KYWB44gizdtFnj/sgQdcPa0/RJGEYWuZ20IIXcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TEOzNs2WPc+dS3ub2TLoWZ6zU55yYhX/vJB3S42Ij+I=;
 b=TNVEwTmP0qHnQg29d6bSEUSXAY4A78WxTyJ7MN7t9ci8XSz+htCD8dFBDvqJJwDbM9xO4uyY1d554mvXnseM+Ae4CKu8yja38EOSD1HRzETTfX6vwL40L0MbGzK99p1HhCu6DTgAF1HB8infcchm+e+nYc4GHOgLdeRLNHtHWLg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 PH0PR01MB6327.prod.exchangelabs.com (2603:10b6:510:8::20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8678.34; Tue, 29 Apr 2025 14:30:13 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9%3]) with mapi id 15.20.8678.028; Tue, 29 Apr 2025
 14:30:13 +0000
Message-ID: <5096b86f-f766-46e1-b1d1-729d45a6bc4c@os.amperecomputing.com>
Date: Tue, 29 Apr 2025 20:00:04 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/42] KVM: arm64: Revamp Fine Grained Trap handling
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>
References: <20250426122836.3341523-1-maz@kernel.org>
 <4e63a13f-c5dc-4f97-879a-26b5548da07f@os.amperecomputing.com>
 <87msbzxvye.wl-maz@kernel.org>
Content-Language: en-US
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <87msbzxvye.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0015.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::15) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|PH0PR01MB6327:EE_
X-MS-Office365-Filtering-Correlation-Id: c3a0ff83-30c8-45bd-e351-08dd872a5a44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R0oyTVFSejVwRWt1dFBzbGwvZGlYV3UzVmh2c3lUQXFtK0k3cEQwMzBZcFhp?=
 =?utf-8?B?NnkvSGg1OUZsM3FqRkYrUEhrK1dadHo0blFmNXBuUnJMNG5adFE1NTdPYXBB?=
 =?utf-8?B?WHRERzNldE9ta1JvUXdKR0IwejN2SVNWQjVFVkFMbFBQLzZ2YXIweXUrRXBi?=
 =?utf-8?B?SzRoWDNKdURqK25FWW1jYzF1dWh5WTVmcmFXNGFoWkw5bTZpOHowcjRrSlV2?=
 =?utf-8?B?Z0dOL0g4OEMvWG82ekNtUWZsU3hPOE1Jcy9GdUJFcXp5d3A3NHdjVWtnMEdF?=
 =?utf-8?B?VzFjbGNIRHpkRTNKK3ZjV3NQZHRMSVd4cnpHLzlYVkRiclRqa1lpQWxCVUtD?=
 =?utf-8?B?UzlQV0FQUUlSL3ZHZllqNFBPTHhNL1lUUURqWVZvbUVscC9UcEVWeCtEandX?=
 =?utf-8?B?V241ejhhcWFVSGpYUGpBOHIvUEVVRDhBYjdmNy9vcjVZSXhKRE54a055Ymxn?=
 =?utf-8?B?Y0I0dVJmQ1NJU3pxTzI2a004RTZRdDVtWEFCb1NDQkJvSFFkNHo3OVhRNjVq?=
 =?utf-8?B?RG9hUFIzQ1FNVS84OVlQblJqaGhZRUZPZXhlOG9pN2ZxMkxMRGw4a1hQWHJs?=
 =?utf-8?B?QUtJR2t5RTRDbzhRaWR2UmdRTXJ3Z09aTXRndVVZNnNqZTBINjNYQ1NRTjZm?=
 =?utf-8?B?Q3MxbEpCL2RDZ3dHK0RaTi9kYmZxRCszR0hncnNnaWJVRStTckIzSkc1ekow?=
 =?utf-8?B?YmNhaFZseWVVUDMyTUMwd2NyN3RNUHdkL2xDelVxNy9jVzJsbUp6azdXT3Mv?=
 =?utf-8?B?L2JaWnU0a1F1WWp4QTBIUDJOM25USDUvdXl2N1crUnF3eUpPWnZZekdXYk9z?=
 =?utf-8?B?NEJGSDVRMGRZdjdVaWtPTjZnd1M5UHJsT0ZIaUMrbXhVTFFVdWRzU0pvUy9V?=
 =?utf-8?B?dXZ2R3dsT1dUd2JXd1IzRFB5ZFVaS2JzQmdSZU1UZDJFUG4vRkdSWE9jSjhI?=
 =?utf-8?B?ZWNqN0R5c2doTDN6a3QveXpoZGRKZE1HWDVBZEZPbUlwY2dacUFlQm5ZZnRF?=
 =?utf-8?B?KzhSeVQ0ZTRjVGtUaTREc3JyY3FndStxdG1ETHpTbXlQdEpPb0VjelVtLzg2?=
 =?utf-8?B?RUtva002QWZMckpEVEx4TEJZK2pnMXE2d0hYMm9MS0MvRzVvT2JjQTczd3hm?=
 =?utf-8?B?Ukhic0Fyb0FGWGE4VUFvWGtucHBnSDNrbVp3a1BCSFpFeEpnKzB0cHBmcjk4?=
 =?utf-8?B?NkEzYXpsWVdzcHJOS2lWVlZxcEtCMnJXNXJJWHFmdzk4aE9wRzl3MFpPSkhN?=
 =?utf-8?B?aDU2MUo2dFJZbGduYWdzZDNKOE5KeDBCbUc1WWc1cHB5SWpSRDNqUjM4cm9P?=
 =?utf-8?B?VFpmZFBBKzVYaDUvWExXQVZSQUoyVG16aXV6R0lBemNyNXNhZHI1UVVuRWJG?=
 =?utf-8?B?bDVvQWc2ODBRZTZxZ2JBekxZNGVEZHlkQ3hjdVRkVGNVM0k5ejYwQlNVd3VU?=
 =?utf-8?B?Zkl6UUFoWGpRZ1Z0VzFqb3R1Sy8vTnRINlcvaklCa2Q5TUtCTm5sTktpZEVS?=
 =?utf-8?B?NU1pY3JUU1Uwanh0MEN6L3I0YTludFN3YTlFNmlVdDFueFVJL1c0SnZMRTZY?=
 =?utf-8?B?amFkM01yaGJFZmU0WmVPem9DTitDbDBJcWNFMUNHU3VqWkNrb3czQmtmWXVH?=
 =?utf-8?B?NkhSSlRZbVBObURJUVhtbFFyWS9RdzUzN3dMK0VwMjF4S1MvZjBFQmR2cFBH?=
 =?utf-8?B?bTlBNk9wVjdWTDVCK2ZZOU1xRWd1V0lrZDROY3FKbnIxUG9KclkwTjhpRG85?=
 =?utf-8?B?TjRkSkhaVkwrK1ZuUkc2RGRNaTJ5NnFFSFNOOGVRaFZnbXFYSG15QjFySVMz?=
 =?utf-8?B?WGVsbnY0ODIzSHFsblRHT281Y3lia0M0TW0rUXAzS3BLOVJadDkxdWhOQ1lW?=
 =?utf-8?B?NDZGNE5MT2Y5MHc3WjhNSDJaYVdEdGJrK0I0bGhiV2NlUTJFMVhjYitFREhL?=
 =?utf-8?Q?GkzmH936hSQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Uk85b2NYVjNXa1o2ajducWhrTFo0YStqVU9PWWdqRERFaU0wSExVTit2VlJV?=
 =?utf-8?B?MGM3aWYvU2JuaWdYZEdINUNkQk1mNFhPdEE1SnVkZ01GcXVlYWhxcUN4M0pQ?=
 =?utf-8?B?ZUo0K0p2eEt5Y0ZjK2IrajNRSGpkckQ4NnQzTklLZkNRdG9aRTRyS3lvTGZW?=
 =?utf-8?B?djUzdC8ySHQ3K3VhS3RrYklXWmY0Q1dTL01GOWhSdkZMSjBBODBBbGhQWHRj?=
 =?utf-8?B?VlZoRkphMHZKN0RXL1Y4eXhrNE5Qd1crcFc5a3ZVaUpYc0tNenEycjNyQjM5?=
 =?utf-8?B?YnFPV2dOZWpOOWU3dUFISExJQ1NNcllLUlUvYVltV2pYcHNRREh5b2NMR1N0?=
 =?utf-8?B?Sk5FMWpvZml5b3BTL0pZbnhVWHdyK2t5UEdHT0lLTUpWcG1sMnloMHgvd2tH?=
 =?utf-8?B?VWdRZ2lKcDFTcy9qSHZPWU1jZVpsV01zMTJWVE9aQkhSYlRjYkMrU09CU3NB?=
 =?utf-8?B?cmFBYXpCcWJSSVo1TjlZZEdmNXdZRVY5UExSYVhrWnovcENrYUZMZU8wS0tG?=
 =?utf-8?B?dmgyelRWTmhidTRIMzdicGxYZ1RhU3RBY3pYelpkS2FTdzlucVNUZFVQMzNv?=
 =?utf-8?B?MkFQU3NIaHc3TCtCblU0OWpJWE85Qnl1WFkxbzNYTHV3WVJqbHZQdjROWC9B?=
 =?utf-8?B?cDJ2NFRqNG5SY2tGVTM1Q29zYTFMeWwreXhvZkZaVVJoUWFTRzB5TStJaEFF?=
 =?utf-8?B?Rm5PL1g3S1YvTkh0VEhVL2EvMnZGK0g4dTFyZDQwWXlKZ3ZhczRYNHArSWNN?=
 =?utf-8?B?Y0ZZbzFHVjJzeW9xTGJXNGVwMXUxOU1uYUg1ZExxMnpFVHU2YXpCMmpmVVU4?=
 =?utf-8?B?NGU1SDRtclBKRG42S3ZnUkg2Y2JFeEV0MEhYdXhLZHhINUtIQ1JleDFaTWFX?=
 =?utf-8?B?U2luY01XNkEzUTJQREpubmFNeThQb1ZVQTQyblhTSVRKRVpySlVSUVN3OXRF?=
 =?utf-8?B?QURqOC9qRVA0TFp1bkdocmxwQ05hd1pOZEpweFBVR2V3dDN4bW9XeWxybllS?=
 =?utf-8?B?eUJqWW1JQ3dZYlJSLzl1S3dKWmpEc1RLcW9kRmJlMVJnOFBZdEYwaVp2aGhL?=
 =?utf-8?B?NlkwaVA1aE5NcVFkYlRPbEFVVE1CN0lHSHNJL2lQZUFHeVVSejlmbU9qcWFT?=
 =?utf-8?B?RVJ1dlJuK01JTlZjelY4czhIWnZ2MkpsaEpLc1ZhNlZaTHdka05MSkdacGcy?=
 =?utf-8?B?dzFsTDNlUFNwWFVTZ01INHFHTkxLUjhyakVxWWtJMG9XbExmZElzS1diRERK?=
 =?utf-8?B?Q0FtS2RMSFpNd1hzUjBtbFEwNzM0ekppTjdreWNVMzdLSTdEZ2Npenp1WWxI?=
 =?utf-8?B?Ymtqdkd2d3dQSTVsNXoyOCtYd3IyWnQ1d1V5ejJYZVJyalZrelBZNlE2M1A0?=
 =?utf-8?B?OEJTRDlhMjZ3U0cvUjVIKzQ1NGpvcHNjMDdHL0k4ZThaQ3YycU42aS9RaldK?=
 =?utf-8?B?STZIdHlCMElON0NMMzV1M2VtcEY5UWtnQUt3SjFqZ1ZtdGlSS2lZelZ0K1hz?=
 =?utf-8?B?enlKQlZVbDE4aFIyRTNWZWFnclUzTTE4Q2p1cThKYTZUdW5DMG9QcW1FZmZk?=
 =?utf-8?B?b1BubHI2UkN1emxrWk51SWdFSWxwdC9uWGp6OXVZcHhuKzZnbDdUMlZrTHk2?=
 =?utf-8?B?YXQ5cHBRTFZ5WHVDRVlsdUI5RzVhV01kYnpGWTRBUUhCbG8zbWlwQWdyVUsx?=
 =?utf-8?B?TlFtSWJOaklCK0hDUXJCM1VIcFFDdlJDVGlTd3ljMHljaWV4bHIvUk5USG9l?=
 =?utf-8?B?clZIb2lIUHJSbzUxRXowN2UxWU1LNDhXU3B1a0JTT3ZodmJESUpWYjZhRks0?=
 =?utf-8?B?eVppUWNCSEdlNjhOTGhjZ0FWNHUwTHFVaEZXZUZaZ3lDakNkckZGVFpTYXNK?=
 =?utf-8?B?aDR4QVgzM1dRam8wRmJ3c0RvK01TcXBZNEhGOUswdmpFUEtjWG1PYWxkUlBF?=
 =?utf-8?B?WDVUckhWbjIzQVhKakR0YlRXemNhMkFlVE1lUzB4NGJjdHo3VXNMb2d6SERk?=
 =?utf-8?B?TFRHWmJHNGI3bkFhYlF3TS9RdmRvNDEyc3BkWCtyYVY4UStpekNGdTdoUzFt?=
 =?utf-8?B?YjV1RXFxNy9pcTdzZ2NDUVdobHhDT2s3QmpmUmhCOW1OSGZaekJqS1VybWxq?=
 =?utf-8?B?WVZMUVdaNnovS0JGVm81MmxpUjEvRk1mdjFvTjJiZ2docCtiYThWdU5YNElH?=
 =?utf-8?Q?EXmeVvMR0YBgHYkZkOt48DcSH+JRuRWBfTTRaur1or4z?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3a0ff83-30c8-45bd-e351-08dd872a5a44
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 14:30:13.0863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: knywcNkHWACyJ7zcO6BgXnuMz2CDqloTTrSt0TiEBpRTne+/rMOMuYVlVqJz0/q44wLaIBZV1F0Ln1YrCLaWJ32JhC7QVq7LWiH2xbldXC30IznAC1vRpJQnjWkYxxxN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB6327

On 4/29/2025 1:04 PM, Marc Zyngier wrote:

>>
>> I am trying nv-next branch and I believe these FGT related changes are
>> merged. With this, selftest arm64/set_id_regs is failing. From initial
>> debug it seems, the register access of SYS_CTR_EL0, SYS_MIDR_EL1,
>> SYS_REVIDR_EL1 and SYS_AIDR_EL1 from guest_code is resulting in trap
>> to EL2 (HCR_ID1,ID2 are set) and is getting forwarded back to EL1,
>> since EL1 sync handler is not installed in the test code, resulting in
>> hang(endless guest_exit/entry).
> 
> Let's start by calling bullshit on the test itself:
> 
> root@semi-fraudulent:/home/maz# grep AA64PFR0 /sys/kernel/debug/kvm/2008-4/idregs
>   SYS_ID_AA64PFR0_EL1:	0000000020110000
> 
> It basically disable anything 64bit at EL{0,1,2,3]. Frankly, all these
> tests are pure garbage. I'm baffled that anyone expects this crap to
> give any meaningful result.
> 
>> It is due to function "triage_sysreg_trap" is returning true.
>>
>> When guest_code is in EL1 (default case) it is due to return in below if.
>>
>>   if (tc.fgt != __NO_FGT_GROUP__ &&
>>              (vcpu->kvm->arch.fgu[tc.fgt] & BIT(tc.bit))) {
>>                  kvm_inject_undefined(vcpu);
>>                  return true;
>>          }
> 
> That explains why we end-up here. The 64bit ISA is "disabled", a bunch
> of trap bits are advertised as depending on it, so the corresponding
> FGU bits are set to "emulate" the requested behaviour.
> 

OK, was comparing fgu for this test case and VM boot.
For this test, all HFGRTR bits were set in fgu.
thanks, I did not notice that guest was disabled for AArch64.

> Works as intended, and this proves once more that what we call testing
> is just horseshit.
> 
> In retrospect, we should do a few things:
> 
> - Prevent writes to ID_AA64PFR0_EL1 disabling the 64bit ISA, breaking
>    this stupid test for good.
> 
> - Flag all the FGT bits depending on FEAT_AA64EL1 as NEVER_FGU,
>    because that shouldn't happen, by construction (there is no
>    architecture revision where these sysregs are UNDEFined).
> 

Yes we should.

> - Mark all these test as unmaintained and deprecated, recognising that
>    they are utterly pointless (optional).
> 

Just wondering, should I continue to modify this test to run in vEL2?

> Full patch below.
> 
> 	M.
> 
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index d4e1218b004dd..666070d4ccd7f 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -295,34 +295,34 @@ static const struct reg_bits_to_feat_map hfgrtr_feat_map[] = {
>   		   HFGRTR_EL2_APDBKey		|
>   		   HFGRTR_EL2_APDAKey,
>   		   feat_pauth),
> -	NEEDS_FEAT(HFGRTR_EL2_VBAR_EL1		|
> -		   HFGRTR_EL2_TTBR1_EL1		|
> -		   HFGRTR_EL2_TTBR0_EL1		|
> -		   HFGRTR_EL2_TPIDR_EL0		|
> -		   HFGRTR_EL2_TPIDRRO_EL0	|
> -		   HFGRTR_EL2_TPIDR_EL1		|
> -		   HFGRTR_EL2_TCR_EL1		|
> -		   HFGRTR_EL2_SCTLR_EL1		|
> -		   HFGRTR_EL2_REVIDR_EL1	|
> -		   HFGRTR_EL2_PAR_EL1		|
> -		   HFGRTR_EL2_MPIDR_EL1		|
> -		   HFGRTR_EL2_MIDR_EL1		|
> -		   HFGRTR_EL2_MAIR_EL1		|
> -		   HFGRTR_EL2_ISR_EL1		|
> -		   HFGRTR_EL2_FAR_EL1		|
> -		   HFGRTR_EL2_ESR_EL1		|
> -		   HFGRTR_EL2_DCZID_EL0		|
> -		   HFGRTR_EL2_CTR_EL0		|
> -		   HFGRTR_EL2_CSSELR_EL1	|
> -		   HFGRTR_EL2_CPACR_EL1		|
> -		   HFGRTR_EL2_CONTEXTIDR_EL1	|
> -		   HFGRTR_EL2_CLIDR_EL1		|
> -		   HFGRTR_EL2_CCSIDR_EL1	|
> -		   HFGRTR_EL2_AMAIR_EL1		|
> -		   HFGRTR_EL2_AIDR_EL1		|
> -		   HFGRTR_EL2_AFSR1_EL1		|
> -		   HFGRTR_EL2_AFSR0_EL1,
> -		   FEAT_AA64EL1),
> +	NEEDS_FEAT_FLAG(HFGRTR_EL2_VBAR_EL1	|
> +			HFGRTR_EL2_TTBR1_EL1	|
> +			HFGRTR_EL2_TTBR0_EL1	|
> +			HFGRTR_EL2_TPIDR_EL0	|
> +			HFGRTR_EL2_TPIDRRO_EL0	|
> +			HFGRTR_EL2_TPIDR_EL1	|
> +			HFGRTR_EL2_TCR_EL1	|
> +			HFGRTR_EL2_SCTLR_EL1	|
> +			HFGRTR_EL2_REVIDR_EL1	|
> +			HFGRTR_EL2_PAR_EL1	|
> +			HFGRTR_EL2_MPIDR_EL1	|
> +			HFGRTR_EL2_MIDR_EL1	|
> +			HFGRTR_EL2_MAIR_EL1	|
> +			HFGRTR_EL2_ISR_EL1	|
> +			HFGRTR_EL2_FAR_EL1	|
> +			HFGRTR_EL2_ESR_EL1	|
> +			HFGRTR_EL2_DCZID_EL0	|
> +			HFGRTR_EL2_CTR_EL0	|
> +			HFGRTR_EL2_CSSELR_EL1	|
> +			HFGRTR_EL2_CPACR_EL1	|
> +			HFGRTR_EL2_CONTEXTIDR_EL1|
> +			HFGRTR_EL2_CLIDR_EL1	|
> +			HFGRTR_EL2_CCSIDR_EL1	|
> +			HFGRTR_EL2_AMAIR_EL1	|
> +			HFGRTR_EL2_AIDR_EL1	|
> +			HFGRTR_EL2_AFSR1_EL1	|
> +			HFGRTR_EL2_AFSR0_EL1,
> +			NEVER_FGU, FEAT_AA64EL1),
>   };
>   
>   static const struct reg_bits_to_feat_map hfgwtr_feat_map[] = {
> @@ -368,25 +368,25 @@ static const struct reg_bits_to_feat_map hfgwtr_feat_map[] = {
>   		   HFGWTR_EL2_APDBKey		|
>   		   HFGWTR_EL2_APDAKey,
>   		   feat_pauth),
> -	NEEDS_FEAT(HFGWTR_EL2_VBAR_EL1		|
> -		   HFGWTR_EL2_TTBR1_EL1		|
> -		   HFGWTR_EL2_TTBR0_EL1		|
> -		   HFGWTR_EL2_TPIDR_EL0		|
> -		   HFGWTR_EL2_TPIDRRO_EL0	|
> -		   HFGWTR_EL2_TPIDR_EL1		|
> -		   HFGWTR_EL2_TCR_EL1		|
> -		   HFGWTR_EL2_SCTLR_EL1		|
> -		   HFGWTR_EL2_PAR_EL1		|
> -		   HFGWTR_EL2_MAIR_EL1		|
> -		   HFGWTR_EL2_FAR_EL1		|
> -		   HFGWTR_EL2_ESR_EL1		|
> -		   HFGWTR_EL2_CSSELR_EL1	|
> -		   HFGWTR_EL2_CPACR_EL1		|
> -		   HFGWTR_EL2_CONTEXTIDR_EL1	|
> -		   HFGWTR_EL2_AMAIR_EL1		|
> -		   HFGWTR_EL2_AFSR1_EL1		|
> -		   HFGWTR_EL2_AFSR0_EL1,
> -		   FEAT_AA64EL1),
> +	NEEDS_FEAT_FLAG(HFGWTR_EL2_VBAR_EL1	|
> +			HFGWTR_EL2_TTBR1_EL1	|
> +			HFGWTR_EL2_TTBR0_EL1	|
> +			HFGWTR_EL2_TPIDR_EL0	|
> +			HFGWTR_EL2_TPIDRRO_EL0	|
> +			HFGWTR_EL2_TPIDR_EL1	|
> +			HFGWTR_EL2_TCR_EL1	|
> +			HFGWTR_EL2_SCTLR_EL1	|
> +			HFGWTR_EL2_PAR_EL1	|
> +			HFGWTR_EL2_MAIR_EL1	|
> +			HFGWTR_EL2_FAR_EL1	|
> +			HFGWTR_EL2_ESR_EL1	|
> +			HFGWTR_EL2_CSSELR_EL1	|
> +			HFGWTR_EL2_CPACR_EL1	|
> +			HFGWTR_EL2_CONTEXTIDR_EL1|
> +			HFGWTR_EL2_AMAIR_EL1	|
> +			HFGWTR_EL2_AFSR1_EL1	|
> +			HFGWTR_EL2_AFSR0_EL1,
> +			NEVER_FGU, FEAT_AA64EL1),
>   };
>   
>   static const struct reg_bits_to_feat_map hdfgrtr_feat_map[] = {
> @@ -443,17 +443,17 @@ static const struct reg_bits_to_feat_map hdfgrtr_feat_map[] = {
>   		   FEAT_TRBE),
>   	NEEDS_FEAT_FLAG(HDFGRTR_EL2_OSDLR_EL1, NEVER_FGU,
>   			FEAT_DoubleLock),
> -	NEEDS_FEAT(HDFGRTR_EL2_OSECCR_EL1	|
> -		   HDFGRTR_EL2_OSLSR_EL1	|
> -		   HDFGRTR_EL2_DBGPRCR_EL1	|
> -		   HDFGRTR_EL2_DBGAUTHSTATUS_EL1|
> -		   HDFGRTR_EL2_DBGCLAIM		|
> -		   HDFGRTR_EL2_MDSCR_EL1	|
> -		   HDFGRTR_EL2_DBGWVRn_EL1	|
> -		   HDFGRTR_EL2_DBGWCRn_EL1	|
> -		   HDFGRTR_EL2_DBGBVRn_EL1	|
> -		   HDFGRTR_EL2_DBGBCRn_EL1,
> -		   FEAT_AA64EL1)
> +	NEEDS_FEAT_FLAG(HDFGRTR_EL2_OSECCR_EL1	|
> +			HDFGRTR_EL2_OSLSR_EL1	|
> +			HDFGRTR_EL2_DBGPRCR_EL1	|
> +			HDFGRTR_EL2_DBGAUTHSTATUS_EL1|
> +			HDFGRTR_EL2_DBGCLAIM	|
> +			HDFGRTR_EL2_MDSCR_EL1	|
> +			HDFGRTR_EL2_DBGWVRn_EL1	|
> +			HDFGRTR_EL2_DBGWCRn_EL1	|
> +			HDFGRTR_EL2_DBGBVRn_EL1	|
> +			HDFGRTR_EL2_DBGBCRn_EL1,
> +			NEVER_FGU, FEAT_AA64EL1)
>   };
>   
>   static const struct reg_bits_to_feat_map hdfgwtr_feat_map[] = {
> @@ -503,16 +503,16 @@ static const struct reg_bits_to_feat_map hdfgwtr_feat_map[] = {
>   		   FEAT_TRBE),
>   	NEEDS_FEAT_FLAG(HDFGWTR_EL2_OSDLR_EL1,
>   			NEVER_FGU, FEAT_DoubleLock),
> -	NEEDS_FEAT(HDFGWTR_EL2_OSECCR_EL1	|
> -		   HDFGWTR_EL2_OSLAR_EL1	|
> -		   HDFGWTR_EL2_DBGPRCR_EL1	|
> -		   HDFGWTR_EL2_DBGCLAIM		|
> -		   HDFGWTR_EL2_MDSCR_EL1	|
> -		   HDFGWTR_EL2_DBGWVRn_EL1	|
> -		   HDFGWTR_EL2_DBGWCRn_EL1	|
> -		   HDFGWTR_EL2_DBGBVRn_EL1	|
> -		   HDFGWTR_EL2_DBGBCRn_EL1,
> -		   FEAT_AA64EL1),
> +	NEEDS_FEAT_FLAG(HDFGWTR_EL2_OSECCR_EL1	|
> +			HDFGWTR_EL2_OSLAR_EL1	|
> +			HDFGWTR_EL2_DBGPRCR_EL1	|
> +			HDFGWTR_EL2_DBGCLAIM	|
> +			HDFGWTR_EL2_MDSCR_EL1	|
> +			HDFGWTR_EL2_DBGWVRn_EL1	|
> +			HDFGWTR_EL2_DBGWCRn_EL1	|
> +			HDFGWTR_EL2_DBGBVRn_EL1	|
> +			HDFGWTR_EL2_DBGBCRn_EL1,
> +			NEVER_FGU, FEAT_AA64EL1),
>   	NEEDS_FEAT(HDFGWTR_EL2_TRFCR_EL1, FEAT_TRF),
>   };
>   
> @@ -556,38 +556,38 @@ static const struct reg_bits_to_feat_map hfgitr_feat_map[] = {
>   		   HFGITR_EL2_ATS1E1RP,
>   		   FEAT_PAN2),
>   	NEEDS_FEAT(HFGITR_EL2_DCCVADP, FEAT_DPB2),
> -	NEEDS_FEAT(HFGITR_EL2_DCCVAC		|
> -		   HFGITR_EL2_SVC_EL1		|
> -		   HFGITR_EL2_SVC_EL0		|
> -		   HFGITR_EL2_ERET		|
> -		   HFGITR_EL2_TLBIVAALE1	|
> -		   HFGITR_EL2_TLBIVALE1		|
> -		   HFGITR_EL2_TLBIVAAE1		|
> -		   HFGITR_EL2_TLBIASIDE1	|
> -		   HFGITR_EL2_TLBIVAE1		|
> -		   HFGITR_EL2_TLBIVMALLE1	|
> -		   HFGITR_EL2_TLBIVAALE1IS	|
> -		   HFGITR_EL2_TLBIVALE1IS	|
> -		   HFGITR_EL2_TLBIVAAE1IS	|
> -		   HFGITR_EL2_TLBIASIDE1IS	|
> -		   HFGITR_EL2_TLBIVAE1IS	|
> -		   HFGITR_EL2_TLBIVMALLE1IS	|
> -		   HFGITR_EL2_ATS1E0W		|
> -		   HFGITR_EL2_ATS1E0R		|
> -		   HFGITR_EL2_ATS1E1W		|
> -		   HFGITR_EL2_ATS1E1R		|
> -		   HFGITR_EL2_DCZVA		|
> -		   HFGITR_EL2_DCCIVAC		|
> -		   HFGITR_EL2_DCCVAP		|
> -		   HFGITR_EL2_DCCVAU		|
> -		   HFGITR_EL2_DCCISW		|
> -		   HFGITR_EL2_DCCSW		|
> -		   HFGITR_EL2_DCISW		|
> -		   HFGITR_EL2_DCIVAC		|
> -		   HFGITR_EL2_ICIVAU		|
> -		   HFGITR_EL2_ICIALLU		|
> -		   HFGITR_EL2_ICIALLUIS,
> -		   FEAT_AA64EL1),
> +	NEEDS_FEAT_FLAG(HFGITR_EL2_DCCVAC	|
> +			HFGITR_EL2_SVC_EL1	|
> +			HFGITR_EL2_SVC_EL0	|
> +			HFGITR_EL2_ERET		|
> +			HFGITR_EL2_TLBIVAALE1	|
> +			HFGITR_EL2_TLBIVALE1	|
> +			HFGITR_EL2_TLBIVAAE1	|
> +			HFGITR_EL2_TLBIASIDE1	|
> +			HFGITR_EL2_TLBIVAE1	|
> +			HFGITR_EL2_TLBIVMALLE1	|
> +			HFGITR_EL2_TLBIVAALE1IS	|
> +			HFGITR_EL2_TLBIVALE1IS	|
> +			HFGITR_EL2_TLBIVAAE1IS	|
> +			HFGITR_EL2_TLBIASIDE1IS	|
> +			HFGITR_EL2_TLBIVAE1IS	|
> +			HFGITR_EL2_TLBIVMALLE1IS|
> +			HFGITR_EL2_ATS1E0W	|
> +			HFGITR_EL2_ATS1E0R	|
> +			HFGITR_EL2_ATS1E1W	|
> +			HFGITR_EL2_ATS1E1R	|
> +			HFGITR_EL2_DCZVA	|
> +			HFGITR_EL2_DCCIVAC	|
> +			HFGITR_EL2_DCCVAP	|
> +			HFGITR_EL2_DCCVAU	|
> +			HFGITR_EL2_DCCISW	|
> +			HFGITR_EL2_DCCSW	|
> +			HFGITR_EL2_DCISW	|
> +			HFGITR_EL2_DCIVAC	|
> +			HFGITR_EL2_ICIVAU	|
> +			HFGITR_EL2_ICIALLU	|
> +			HFGITR_EL2_ICIALLUIS,
> +			NEVER_FGU, FEAT_AA64EL1),
>   };
>   
>   static const struct reg_bits_to_feat_map hafgrtr_feat_map[] = {
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 157de0ace6e7e..28dc778d0d9bb 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1946,6 +1946,12 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>   	if ((hw_val & mpam_mask) == (user_val & mpam_mask))
>   		user_val &= ~ID_AA64PFR0_EL1_MPAM_MASK;
>   
> +	/* Fail the guest's request to disable the AA64 ISA at EL{0,1,2} */
> +	if (!FIELD_GET(ID_AA64PFR0_EL1_EL0, user_val) ||
> +	    !FIELD_GET(ID_AA64PFR0_EL1_EL1, user_val) ||
> +	    (vcpu_has_nv(vcpu) && !FIELD_GET(ID_AA64PFR0_EL1_EL2, user_val)))
> +		return -EINVAL;
> +
>   	return set_id_reg(vcpu, rd, user_val);
>   }
>   
> diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
> index 322b9d3b01255..57708de2075df 100644
> --- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
> +++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
> @@ -129,10 +129,10 @@ static const struct reg_ftr_bits ftr_id_aa64pfr0_el1[] = {
>   	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_EL1, DIT, 0),
>   	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_EL1, SEL2, 0),
>   	REG_FTR_BITS(FTR_EXACT, ID_AA64PFR0_EL1, GIC, 0),
> -	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_EL1, EL3, 0),
> -	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_EL1, EL2, 0),
> -	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_EL1, EL1, 0),
> -	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_EL1, EL0, 0),
> +	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_EL1, EL3, 1),
> +	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_EL1, EL2, 1),
> +	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_EL1, EL1, 1),
> +	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_EL1, EL0, 1),
>   	REG_FTR_END,
>   };
>   
> 
This diff fixes the hang seen while running this test(test ran gracefully).
Tried to run this test in vEL2 and it passing for majority of the registers and failing for the few, looking in to it.

-- 
Thanks,
Gk

