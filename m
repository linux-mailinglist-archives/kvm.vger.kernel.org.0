Return-Path: <kvm+bounces-33454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 654949EBC1D
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 22:52:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53B83280E19
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 21:52:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DADDE2397A7;
	Tue, 10 Dec 2024 21:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XViU0/xK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2083.outbound.protection.outlook.com [40.107.94.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9894B23ED78;
	Tue, 10 Dec 2024 21:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733867562; cv=fail; b=poPquxm874D9EN/u3i/UvT3Yoj6cfQlk8AZp5t9vekO2yEzqTweEv10IOAUWTDsmhsSu2xsVOKm5td5UqLDqkXlCY6zTrvTF6X1iaUpfj6eHu4EfPivsaUrg9Tbf0yP8mHVwr2x33a6QExYaUYX+sKzJMHVeC0bBK6Q8TiBkJ+Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733867562; c=relaxed/simple;
	bh=FymipXGk5r8GSxychb/JlA99vMYIC2UKMYLgTIxhrXY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Asi4/f+0ekxxtepXcT7UypxsBEobfPbx8VOAwsj65NSmjoIGJsgqlY6P9SVDZJyUVLKZ+A6ORcJ16e3NwiJxxcCK6ZEVS3FBEMScVzBeRd/pstqB38S+DyrHcQhvLpyoNVkDMfCoUK3ya+ors5aR/O4mzOEo2LjBaSt3vPrCzLg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XViU0/xK; arc=fail smtp.client-ip=40.107.94.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T7V3k8yMd0DxbQkJiQloB7xt2nR8mXzZM5chlZLdqjgPxGNHmrswcMmLOZkXaQo3Yp1j4liDtm38owKjUv1wNwSs5e+SatOrZS+mIqxsACEckeG6qaUsmhuCqNaG0M0Qa2nP3utq5GVfae7zjDsJGWYIzzfTUzd3QwRRnZ/q7aVvSVEcBGh5GGCdvdBIjolYBDkUwYw4Xx/UkB3RzLWzhQ6mteAJPrRax5ArVovX/NCtumiZj3mP+8ODisGT6yOm84ChHh4PVRjYFElH6xmciX2LuWLyH2w/wyz/yz6DNJj4qQ5DNvgQWuipdMScHYow1n8ChVBqihwy92gg0pPGPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6VwSEVQcrILqt2eiASm2b7SX11OpC2rVOg2RM/6NQAo=;
 b=J1Xfzi+GEJo8HswpigIE84fgV2DgF4FbSi3F8egb91S561gu2KXc+Qb3ITTpHpulDop7g9/0wlfMI3YsTprxHlnNsAKYK0GK8eM8/V78XEXDR7huD7NIaEboIJmxRFMi+p9/+30Jix6JqurFd5m8L6V26dKSMSlRUxeafyQADktpsVcFoogiyOI8ZF1teHRK+c1X9dR/TeRC7cgdxOQp0RsK910revXQd0tOixb928M/9hDyTUfVTQ29BgikY12az8ISgeC0FoL6PG4wyRBmfGUVgokUHZ83eGHWM1eZJJ3+sPJWN5bBi71K9DUtHlQxaqlmLQW0INuAwV4daFGGjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6VwSEVQcrILqt2eiASm2b7SX11OpC2rVOg2RM/6NQAo=;
 b=XViU0/xKgTogk1fuT615fxwXpt/vYwvvFBc2CiqkTp+7y5B2a1/UjBhpYdVzNNnUE7+SK+q5y2ivgx2WUZBWkjq84lAO9I57hcZz6YdFUc7cNsLGZYG+AHWKx1Z2JWPx/NBWTmjca7jet3zrwt1IhrYKsFo0gQhJcfz0PMR28eM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS7PR12MB6118.namprd12.prod.outlook.com (2603:10b6:8:9a::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8230.18; Tue, 10 Dec 2024 21:52:37 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8230.010; Tue, 10 Dec 2024
 21:52:37 +0000
Message-ID: <89815665-4ff8-9eac-8b75-78c50f866a6e@amd.com>
Date: Tue, 10 Dec 2024 15:52:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 3/7] crypto: ccp: Reset TMR size at SNP Shutdown
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net
Cc: michael.roth@amd.com, dionnaglaze@google.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-coco@lists.linux.dev
References: <cover.1733785468.git.ashish.kalra@amd.com>
 <38fd273759f9dc3d8703634cd921b08296997494.1733785468.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <38fd273759f9dc3d8703634cd921b08296997494.1733785468.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0165.namprd13.prod.outlook.com
 (2603:10b6:806:28::20) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS7PR12MB6118:EE_
X-MS-Office365-Filtering-Correlation-Id: dc2acb85-8248-467d-9ddd-08dd1964f62b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VTFOd1ZuaithUmVWaXozbGJsS3MvUjliTk5Na0RNMklaK3VMVTVvYWl5R29G?=
 =?utf-8?B?Wm1neEFNMVE4bXU3OVgzK0g1b3MwV1k2UmxwSFNtQmh2dFE4N0NuRlpFSlVT?=
 =?utf-8?B?UXZueWphams1QS9QbmV3S000djBXeEIrV1FLSk1JaDR6dnJpUjNNeDhMTG9m?=
 =?utf-8?B?eW91dHhPMEpkUFRrbjQwMjdSSlozYkJRdEU5c0pqVzBhbkU1Q2pzVERSdkQ0?=
 =?utf-8?B?VnZnZlkxNXl4T2F0UG9VVG1GT1ZkNWhNcHpWTXpqZDJqVXUvVW5WV3pZMy9n?=
 =?utf-8?B?alhHOGlNWjBKcWhjQTR2T0svSlZ1alVRUXZPNFlyM2kySjBxanRmbnJwMlNU?=
 =?utf-8?B?T3dVbFFpVStnWjRESTJPQVBaYXZBa2JWckpyazNIQkQvOGZqaldUMWxNdk03?=
 =?utf-8?B?N0R4OGJhQ2VsZS9lRk9oWnJRelAraDZNdUdSbkJpN0lmN1dWSDQwMUxxWTdZ?=
 =?utf-8?B?T2dZZENHK0hwR2xIdkpIUzNsZTU2NU8wYlp6d1R1TjdXYWE2ZVd1WThkT1Qz?=
 =?utf-8?B?ZFJCaE1ZenQzNWh4d0pxeFcxcTN5Q3hhK2VRcFowaE5xSjZBaUtwdlhQTlZw?=
 =?utf-8?B?WmJFZ3JudkxNM1kySFQwZXNZaEFobCtnSjZpT09zVHVHMFpHRkl3bTBWaTBM?=
 =?utf-8?B?NHVGV1VYMFUzWitTTzJEdk9pdlBvMlVscUl5VzJuRnNRa3FNK09UczMrNlU0?=
 =?utf-8?B?SW85eUhFRWMxMk1VK2JrSThGMHhra2puY2RkWTNXUVV0Wm4vZEJOSDdmcUVa?=
 =?utf-8?B?RzFCT0pER0lwMkFrUzZ6Zm1UU1diNnJmRHNmRlIwTTE0d09mUnM1dUpQSVI2?=
 =?utf-8?B?UGVXeEF2Y2xzT3FBcGVsWDBYRmgwY09kWUptcnQxU053Vko4bzFieENoWjlC?=
 =?utf-8?B?NkFiMlhmSndjWElYeWpvOUxjcUdTc2ZkQTVmUXBiTnM1NDBTeVVIOC9DRkNG?=
 =?utf-8?B?c0ZURndMR0JkOXlGNWhSRVhOaitzV2JUVXVMWUY2Smoyb1BVbURLKzI5Nk1a?=
 =?utf-8?B?Ymh5SzRBNXNjSWVCQUFqV1UydE9RcW53Q0ZxRUUvWmNkYmJnQm9aTmFBc1Y0?=
 =?utf-8?B?RVVjRUZ2TnJnV0Q1THpuZitsejNJanhTNXhZQWkvZEI0a3BJSW5hbVhmb0Z0?=
 =?utf-8?B?OUJnUDdOdW4wSUdGRjV6alAySExhQllTeXFZdFVnMUtiZHJ6bklvem9VeEE3?=
 =?utf-8?B?R2pjRGhxN2RBUldsQVVOaXY0bXBOTDExZG1PeG9hUUFtT3NFMzhMYUpqOXlu?=
 =?utf-8?B?aC9yNmlyKzI2N3dTajY0eXA1SG9FM1pQYjFyMGU4cGxLdGxtM09Rd1lXc3VO?=
 =?utf-8?B?bFJ1eDJIL21NWGZGWlZGZDg4N1NLbVZvTjI5NXJxM1Q4ZDJWaGZBODYzOUNX?=
 =?utf-8?B?bSsrWXZ1Mk96bjJQOFR5MW8vZkh1VVYzTktOWVU2NGNnY1pKemMyZStjUlBo?=
 =?utf-8?B?RXEwaHJ2UGNLeDZ3U2JVdXhkcGhzNzhLRGw1Szh0NEVvRmFKaUxoQ3JnYkJC?=
 =?utf-8?B?ZGxNQy80N2hNN0RGNWpOYSs0M2hIRWhhRGcwUjBIOE0vcWY4aE9LWm1uQkow?=
 =?utf-8?B?QTJUOE5QdEV4V3B5L09WQklsc2tSYjhyc0FTcmtqbzRZQ2lFK0RrNmkrUlcx?=
 =?utf-8?B?WkxxSkh3eW5tcEVJK1pIQWRMbkFtQzBqRUU0UlUycEhMN3lHeDdPNGVpbjA0?=
 =?utf-8?B?RXFZQWtXbmxCdG8vU2JzSldYUlFKaWFYazg5ZE1SbXNlUDVtUzFUS1ZONjF3?=
 =?utf-8?B?aEJpVXJvdXpDTjNYNkRHNlZ4Q3VPLzVNYnlJcjcyNUJPNWNFbEcwZ1V4UW05?=
 =?utf-8?B?bC9ZZHByMVFkVllSZXNFR3FzS3JvdFBBVitvVXJ5dHdHSEJ1eWpEMlprTlo3?=
 =?utf-8?B?ckJOdjBYa0w0U3M0MVFrTDdRaVRqZ1NtTDY0WkM3cFdJaWc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WWNRL0xJd0hmSjFsVlBGNTZnRENVR20xcTlmQWZQbjlBZnJ3UHlXOFplRnJE?=
 =?utf-8?B?YVJpaGdvU21YK2NSNEZyZUljaEpOUkpDUWtDZDJ5cUxkdndiTDhIQS9IOTlO?=
 =?utf-8?B?TERGZXUwMjFTY1FsakxKcFF4RndiVzJxQUphTkJwaHZFQXdmYlhZOWRVS2RM?=
 =?utf-8?B?Tk9PTFY1R2JFNk11VTA0SW9qcGpUZmlNQ1M3RUdVanRDZXh0UVhuSXYzOHBk?=
 =?utf-8?B?aXd2NzFHYXVZZHh5b0s2QThMRENnZzhaT0t5WHBaL0JsdHBGaVkyV2lFQUJJ?=
 =?utf-8?B?dzU1b3dTbFJSdGY2WFRXbkZMR0RmSTFXZW5xQTJIa1JidWgxU2c2R2F3b3d4?=
 =?utf-8?B?U3ErL05aajg1d2U4SjNlbDJlWC94SjNXZHdnNTVzbG5oV2RpM3NGRGVLSy9R?=
 =?utf-8?B?SkJJUXJuTkk2MDJ4Qlc2ZW94MVdQV1U5RmhUZEtxVTNlNnI1Q3lFSy9Cb1Jy?=
 =?utf-8?B?c29ZV0YxRHdlVDlxVDVZUHZUZmtMWFdkZDJidXlDTTBGYUFjOGFQYi9yaHNt?=
 =?utf-8?B?U3NhY1RmNmkrZjBtcUdXcmc3dXBVS01jMVJuQm9ISngrUm5UOWFSKy9jN3BT?=
 =?utf-8?B?bDY0Z21jU1c2Z0o3dmsxdXVpMkhxdVdvV2ZCOGRjMm9vbC9wTGt1T05YY3N5?=
 =?utf-8?B?ZFpRbGNYOENka2pjU2VMY2dIWjNDbVdGRWdTcVRZc2Y2emJIUUN2R0pTWERS?=
 =?utf-8?B?LzVtaHc4S1VxNmhGQmhTdWZnNXdsYmFuTm5GS0V3ajZPM3ZZSzhiUDRNY1FC?=
 =?utf-8?B?YWg4MC9zNDVISG1LSXJmOU1KN05CaCtneGo3bHVQUWVWTEZ4TzBwT1YxWk5T?=
 =?utf-8?B?VWNQd1FIbFR2dFdSdkF1T25md1FoYVZkcThadWNBeDNFcE93Qy8yd0h2Yy9j?=
 =?utf-8?B?alZjM1BXWGJwSm8xbG52YU55dFVoOTdOczJTS2Nnbm1saVFYazRoMkhvNDF3?=
 =?utf-8?B?ampCbjJ2bXVhWTlUMVNQSEVsWWxyaHRpbndKR3dMdUtpcDY4OWl6NHYvNUZv?=
 =?utf-8?B?MXFCWlNDSjcxVmdUaTFVSk1Yeld5Vlk3YWxrTDVlRUMxdVBCa21MWnpNWnI2?=
 =?utf-8?B?aWd6cVM1M1ZmcW5WU1Jva1RjYjRrN0QwSDY2bTFHWlNQdlM4NGFXbXJkZGJ6?=
 =?utf-8?B?YnVXSDNmU3poTEFGSFFndGdXTi8wSHpERFBuS2lPUmhabkpPY1llV1AxVHZI?=
 =?utf-8?B?WCtYQXlJVHRlN3RJWG1kWHdYcUphUnppL3V5bUplSGFhTlZxMTIvYnBiYVNt?=
 =?utf-8?B?enpUSzBweEpkVEdleUJxQ1VnSXpnRXdud0cwbDAyVGxvNmpLckJTVVFva0ZL?=
 =?utf-8?B?ZXh4Q1FoTEVERUpHNVl5ZU02VEpPZFNFS0VPL0N5TmhTeWlmZzREMVBsSUJa?=
 =?utf-8?B?K0piSERQbHd0U0tTUGtIU1YyVHR5ZGtlU0JTZFNxUlp0NVlKTXpJdmwrSmVs?=
 =?utf-8?B?WkFFeUpSR1ZTajlGNXo4RG10eTBqRGVPVVU3Sm1peDJ2QkZQMzl5VDhvU0hW?=
 =?utf-8?B?TDEwY2o0blNTSElpZ2FWc0lJdGd4bXRkbnNpL2NtL2R0cE1sSzIwbTdoTG5J?=
 =?utf-8?B?elZUejJiVHl1TGw3bGFrUkM4WDh1YVdGVm1uWlFrQlNkZDhmMHo3VC9jWHBn?=
 =?utf-8?B?VEE4aFNYb2lDeWhmRUEvODdCZTBob3IwVXc4dHhOd0JNaldyckR2Y0Rsb3pa?=
 =?utf-8?B?eGp3VktSbWYrOGM5U3NseGUvNUxDTXgydEJkRGJGRHNXS3NidmxINkZRT0hK?=
 =?utf-8?B?VThOdVROczZWZGlJZXR2czR0dVRIWU9LVUtSbE02VVY5YjYxYjBhcERrL0RD?=
 =?utf-8?B?Uzh1Y3NOSkJrV25DeTZ4OHprYU5maFhTV3VPbWZkRnBJWGwwVjNtNU5YdDdP?=
 =?utf-8?B?b3A4NDB4T2pNK1gxd0FpYnE5bWFYMW5xclJKNWpXYnlqeTFobzVjR1BoWFlj?=
 =?utf-8?B?Q3NSTWNtclY2NzE0N1lERTNFMjhXdWxLS01pUSt4S0JIdnoreUNWK3B3TWFw?=
 =?utf-8?B?dExXbzZSNWplbVZuT25EUE0zK2ZBVzBwNGFQTnNpaDJPdGEvdzQxMHlnN3N6?=
 =?utf-8?B?azgxSzN0bWtweHhvWWhtSnNwbmZVNHNNV25hcXhPb3JER2pQVGdjbSs5SWN6?=
 =?utf-8?Q?jC2DpMPR1tMuVd+14esql03P6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc2acb85-8248-467d-9ddd-08dd1964f62b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2024 21:52:37.5709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: STF6Z2P30TXfJ10o16u8l4TvZDf1dh1XhTX0DcrbULD5lOj/hFbpOE1VIn0UxOjmhkRA2QYHhhkUDyzuABYUeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6118

On 12/9/24 17:25, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> When SEV-SNP is enabled the TMR needs to be 2MB aligned and 2MB sized,
> ensure that TMR size is reset back to default when SNP is shutdown.

I think a bit more info here about why this is (now) needed would be good.

Thanks,
Tom

> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index d8673d8836f1..bc121ad9ec26 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1750,6 +1750,9 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
>  	sev->snp_initialized = false;
>  	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
>  
> +	/* Reset TMR size back to default */
> +	sev_es_tmr_size = SEV_TMR_SIZE;
> +
>  	return ret;
>  }
>  

