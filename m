Return-Path: <kvm+bounces-35967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE25FA16AAA
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 11:23:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C34463A1F28
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 10:23:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A01471B414F;
	Mon, 20 Jan 2025 10:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RNWPs+xg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2081.outbound.protection.outlook.com [40.107.212.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC39188938
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 10:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737368597; cv=fail; b=Dr59EFSB6e7f922+BtptcgY7IdCkX0xKf0lMApXxTotTIB1AAFIWW3nBU6lS9lfR/tGPccqjJeLudqqk4uSMWrRVA5J+WPfZ9LMcw5BmGQHO1VlUBu7ty160Gf+FG3nX+37/zp6vJDMWl2man3O7YpE/gZ2xxE93bGEewv7Oifc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737368597; c=relaxed/simple;
	bh=rsq6m91+zMNyWkt9MarffbIexHwMAbYLwBZIf7CWgRw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PhAM6Maf5L4apIdmziRv0NfUhAoKB5F+Vzfr3zp0ELo91bt853KC6BwHNLf+5Up2tFvazpbYa81JoFQaR9VdA8RJUbZNZfol0r0R7uIeKXiv8ecRe+UcUNkdnjiupXuAuvubhEknMjaEX62A27cYHZtC/ddyYjz7bar9WNQnohg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RNWPs+xg; arc=fail smtp.client-ip=40.107.212.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gin1jpkPrcoJMx0tZVgOd6/UArSjjIW6UgRzN2fZAxBDgJA5fx6nW+a6KHmu2kCKPojtv5fkYYATDuljNGmuXNkWza6AtMcgenw8zXyEYsIvouG7nZCnH031zGk9uf37loHucBu/hRU2lzVb2lqWZ5BJjDZPrTjD9M+hoeI4fDSnUQku7O5PRVPUuefXoT36W/B/k3liWOhdoVFTKod2nNxQABpq8p1O3u+CjKj4bpYzZiTQp3jbqgruZgqSJ4/mI2jTBV6h0qMQCKJ/gcd4YEH5xh+h6Pk4DBVDvtlfiXSYU9oywQJG1vWkwVMTUdYcgR3ui8b8jK5u8zR7b+optA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hUxUEXasK7QYLXpQiPin12mHL//6BHgE7+rAApt8rAQ=;
 b=V8iBo5DXIKA9WmyfODJzuTOkTC6W7GGOC1yq1E0acnvPSu+DDL14ELH6K8M6tQrq+kkiBmClcE7dK9b3d+0kNAgoWunqcaMt7JIs0tBskxmTzSi/wIsXgErh2s2KANFbGJMRGLbfAI2dLih+jEimmr0CRK3niYHosafCMiQwe0ljtPEoYTB6JJcFQYnGz/nAALGLScpY3utceUcuMoxoySNuIruxCA57R854QyfLyLQcMECzFw6UDiNARMN02Ky8JfwZ42QBbHHM7an1k+W4+5WjcbhYfaukD1uFjDIl968kVKQ186e4HpJCgxT3z4+USzqVhmQRzvXDPUiNL/JHkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hUxUEXasK7QYLXpQiPin12mHL//6BHgE7+rAApt8rAQ=;
 b=RNWPs+xgMQM7CYbacRGDttcXVwy5of5iRbhGPudXP4pJLVii1QA6HmwDaFKXKimSWJe4IIL/cPRcA/m0r2EHk1JEgmMq1mwV4RSsNSvdiYG12WpUmhS5lo4YdnMgLdZVPy2EX4uY43PgUus4bd7D/EaQ3dg2h79vBctn6tkSQ4U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from LV3PR12MB9213.namprd12.prod.outlook.com (2603:10b6:408:1a6::20)
 by DM4PR12MB6184.namprd12.prod.outlook.com (2603:10b6:8:a6::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8356.21; Mon, 20 Jan 2025 10:23:12 +0000
Received: from LV3PR12MB9213.namprd12.prod.outlook.com
 ([fe80::dcd3:4b39:8a3a:869a]) by LV3PR12MB9213.namprd12.prod.outlook.com
 ([fe80::dcd3:4b39:8a3a:869a%5]) with mapi id 15.20.8356.010; Mon, 20 Jan 2025
 10:23:12 +0000
Message-ID: <2b2730f3-6e1a-4def-b126-078cf6249759@amd.com>
Date: Mon, 20 Jan 2025 21:22:50 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
Content-Language: en-US
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-3-chenyi.qiang@intel.com>
 <d0b30448-5061-4e35-97ba-2d360d77f150@amd.com>
 <80ac1338-a116-48f5-9874-72d42b5b65b4@intel.com>
 <219a4a7a-7c96-4746-9aba-ed06a1a00f3e@amd.com>
 <58b96b74-bf9c-45d3-8c2e-459ec2206fc8@intel.com>
 <8c8e024d-03dc-4201-8038-9e9e60467fad@amd.com>
 <ca9bc239-d59b-4c53-9f14-aa212d543db9@intel.com>
 <4d22d3ce-a5a1-49f2-a578-8e0fe7d26893@amd.com>
 <2b799426-deaa-4644-aa17-6ef31899113b@intel.com>
 <2400268e-d26a-4933-80df-cfe44b38ae40@amd.com>
 <590432e1-4a26-4ae8-822f-ccfbac352e6b@intel.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <590432e1-4a26-4ae8-822f-ccfbac352e6b@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MEWPR01CA0214.ausprd01.prod.outlook.com
 (2603:10c6:220:1eb::7) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9213:EE_|DM4PR12MB6184:EE_
X-MS-Office365-Filtering-Correlation-Id: f9153255-f053-451b-3e19-08dd393c69ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZmcwY0tDaTFPaStucGRsQk5tSUpXb1dneGMyUnpJOEVrQ05oS3FnaU9pZXFL?=
 =?utf-8?B?U29wZ3dDamlIeXBrY1JzOE03RWpRQzFRR2hPNnppMTBQR2VqbUFmWWpRdERy?=
 =?utf-8?B?TkdvNjVVRXp2alRremM5ZGQzNHMwdE8ydUpndzQyQkY0cHE4QkhvQ0pHZ1RZ?=
 =?utf-8?B?eG91UWtQME9ZUFpueVA4V3VxOXhVNUg0cXhJWjRjZG5sTGRCK1k5aU9HbUU1?=
 =?utf-8?B?MEhBZGRFaGJzZk9TemtvNURCYW9WRkdsVXZXR1dIb1dVWDJqT3ZKMkcvYmtK?=
 =?utf-8?B?cmtoTzVBQ2dneDFzTUlZWmFFZVFJeDZ1SHZmZzlCZHI5eXI3amNnRkRSMFVr?=
 =?utf-8?B?Y3dGMnpnVEM1L0dPRVg0ZWJtd1hwWXFvQStCcFdUWWpzcytadWJYNExmaXVB?=
 =?utf-8?B?Y3lXZnNWZXdEMTVnQW1MaVlTNXNKOUtYRkNhV3dJU21FelY5TFhKTWNhSWJp?=
 =?utf-8?B?Q001b3c5dzNpV01xSCs3Z1IvNkVlOWRGQkRiVTJKMC8wcGxGWkJwOG0rUWFz?=
 =?utf-8?B?eFJHVGZpempNMnJ1TTY4Y0lRNkZ5OVk1aS91RGpaZVhCV0R4UGNZaHhzaVE5?=
 =?utf-8?B?OHlkMVJZZFJhbWU0NXZMSitDQmdrWHpEeXBkVHJXcVBSU2NmWkZFaXppKytX?=
 =?utf-8?B?K21mSVN5ZGZRNU5GVEQvVUh0VFFYZ3JxeFZNZ0lZUEQ0eW9RdmJUWWpDMUhG?=
 =?utf-8?B?dnpQeG41QzZueERnMWpaREJNOUpCM2tnU0VycDRjc1dpZURYZTJyUkhINHpR?=
 =?utf-8?B?ZUZTajNvYzdORG1XVzk2NEZmVFFRYzV5YlVPWW1hc05za0czYUZqRHM3bExP?=
 =?utf-8?B?S3dhU3FGc21VZ3dzcTRsLy91Q1NMT1JmT1YremsvMExrZHpXemMvTXRIYlBJ?=
 =?utf-8?B?d3MzelpCY3puMHpoVTg0cGtEbEp6VldXZjgrSmdHVUhyeHVhVDFiYUZhSlY5?=
 =?utf-8?B?cU41cXl4NGJJZzEwUWVqeHVMVWlVZmJQTS9zdUVER0QzQ2s4Mkc2RTFpSVZt?=
 =?utf-8?B?Y0c4Zno3MTl2b3RFdTg5TENUbWx5L29Ta3VlaDBwWk0zVXJZZ21YUHFMWWtj?=
 =?utf-8?B?eUYwUnlFam5lZFNBTlRKenhjT3ZFM3M3Zm5Pd25KaDZhRHBjTmJmSnllVkNH?=
 =?utf-8?B?ZjBEcmlLT0NBTDFWejl2WFl6UWdRS1ZwVURENkg1eGYrQU5IaWZGbHlJeHZR?=
 =?utf-8?B?OGNUQXdmRk00OTRoU3ZTWWcwTURmL0JEejdkdjVsVVV0WXR1UjQxTVAydkxW?=
 =?utf-8?B?RTIwQnplSUpMUlVYUXBEQXF2dDJyZE1iOGxNV2t2ZUJqUlZVTnRwemtCS0Rz?=
 =?utf-8?B?OGNHRU1PTFMvcW9NNS9NS21MVTlmN0swcUx6Y1ZQbVgrRzZ6cmdHNllIU3J1?=
 =?utf-8?B?eGwxV25KQThuYXNiTGVPN3doSFBnUVdqQnVuTUdMMU5ZMXBVcG1pbnF3My9T?=
 =?utf-8?B?SmVsdWZNbWtsOXlvdENqSGcrcmNWQXh1U1djVUp2VGdwQlRhenpkTTFrZUI2?=
 =?utf-8?B?RFg5dTFOZzc1TTU4R0xhdFh5Z0Y0VmoxS0J0WGh2cFZGdzM2TnN5UXFxRWxX?=
 =?utf-8?B?MDc5Q01XVjZib0RldXpQOW5FZEVNOS9nOS8yREtlVVkvS3ljTG5JbmZCbytp?=
 =?utf-8?B?dDBJRGxoZ3JJZkkzK2xqeXU3Z3YrNWtrbnl6bGNiZjVTWTF3bzFkSnB4cDdO?=
 =?utf-8?B?Sm12K2RLSldZWTc0dEtIUXhCdTdxcGVlT0w1SEprbzk4MkNYemlvQ1dzYlA2?=
 =?utf-8?B?YVUwMCtwQXllVjhrWXVsR0JxV0pUV2VMbjBQVWsrZ25ndkhmcWFoaXM4N1JH?=
 =?utf-8?B?QzJ4T1d0TUFnOW9rMWJ6d2tKRTJBZXZqLy9zbjhtNUxmanN5R1dzRFNJcUMx?=
 =?utf-8?B?TFl0bjgra3NFbWdEYlBCYXBnZnI1bWxqT0loL0lEcW15aEE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9213.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YXl5ekZnZlFUcUlCQ09zendUVFNzTTRGNFhYU1pDRXFHMEV5OHMvdzdCbkpI?=
 =?utf-8?B?UmtTeC96VDZyU2g1NysrcXViZ1pjWkhFU3BBKy9XWnk1RDR6a29sU2lURGFs?=
 =?utf-8?B?WmV4alRkT3R2aTZaWndvU3pIbUdGL2VjNUJwZWgvcVFvTXpVR3Uzc2s4c0xK?=
 =?utf-8?B?VWhJdlpiTzJ6NC9iT2ZsVyt3SGlkbkJ4NjNwTTBzSkszdnZLc09xZ21ubFBR?=
 =?utf-8?B?MDh3VzJQekpadi9VcmttNXo5emFNcytMZ1RZaHlJVVBybXFMVWUrNzMrbU9Q?=
 =?utf-8?B?aUh4VHA1eFZ2dnJQeG1IZlM0UnVHRkQwcHoySk55c29kY1pSb1ZQR3I5SVla?=
 =?utf-8?B?bUZhMk92a2YyUCtiWkIweFYzT29BWndKOXZFdWtQcG5ubjVlNWVsZUVWWTJh?=
 =?utf-8?B?VVpOcS93eFpUcVZaaVlxdjlEdmlmclF6UFZ6M0RuNmk2dFZ2RktZVHdxUGI1?=
 =?utf-8?B?Y2hwMDhYVTUxY1FOZDZybzJxOFo1YUNGNE90amZPVU5EaGMvZDBIN3FEN0p0?=
 =?utf-8?B?WVhvbkNFTHZya2RNVEhYWjRXa3VvaWo1eWs5NjhjZG1QNUozbHBYMXA2TDFQ?=
 =?utf-8?B?NlRlTTFDcFJteFp3M2IzQ1p4eURCT0ZCR3NRSHRCUHlYSXNwVklpR3pNY25F?=
 =?utf-8?B?YXJVQTNlcEEyU1J6RW9Yak9lT3V2cHVEZnlab1REWjE2T1RjWmNqWHlmVVVk?=
 =?utf-8?B?M3RjR3VMRExLYXNlWm5IVUltbzBzQUxLd2NqZjlmalZvNlZ3S2xVVHpCSnVC?=
 =?utf-8?B?Wk9ldFp1U2dkQ3dYTjRUYlUrN2Z1ZmNSSUJzdFJGYXN4VUU0VnVvRzg0bDJU?=
 =?utf-8?B?SGxzczljd012d0RKdkVJRE5LaWJBYTFKSHBhcE5pemw4TVNxVUI0WS9udHo0?=
 =?utf-8?B?d1Z1WU1YUXJNbVFVbXhOVmVOYTZzMk5QRDhLbktSdVlzUytZYzZNK1ZCMmlD?=
 =?utf-8?B?VjVFTUxQZ1VBemV3YytZZGdxdjhScXF6cHBsNVBnb3BTdmUvYU05TWtpbm9Q?=
 =?utf-8?B?NDJrdmVMV1hIV2RxNHBBNStiOFdBOEEweEpnSlBZSUhlNWdwQWpSN0hTODNs?=
 =?utf-8?B?V1Z1eFV2bXREb1lvblNnTkNCVzlSelJPbTVtcWU3ZVR0ZGxySnhwUnI0cUUv?=
 =?utf-8?B?NFlOdHM0V0t4STJ5TEMwWFJWeGRoWUR6MUE2eUphTlY0TzlBbHRFNG4xcm1o?=
 =?utf-8?B?OXlEdGlSd1dwd1IxVm95YzJHMGZxd21tNHFpTXdpMVU1VUtjRGZzbVpBdUYy?=
 =?utf-8?B?WVM2bXJhNEJMS2JPOFZaNUVwSUFVRGRNaC9KeUtoTVRtd0krUDY5SW5nQ2w4?=
 =?utf-8?B?WHo3NWxVSFZPMUxUZUlHeWJueTRJci9GZU4yWWVFQWREWUQ1aFNzM0w1R2FG?=
 =?utf-8?B?WFFVV2UwcGtsb3lCcUdseEdtZW9zL21NNm5aRVFnVGdZUFpBZlFsOWRzY1R1?=
 =?utf-8?B?M3lTNThIWUlaS2hpY1didW91Q0U0M1Bpd0ZLQTA0MHQ4NXRCOXduTkx6UkNo?=
 =?utf-8?B?VXB6Y1pBWldtdDFLOUFRSGJWUmlGdWNSTXZSVmVHRkw0UWRmUE9HTi9RcGJt?=
 =?utf-8?B?RW04K1R0UjNkNm83eEtiVml1UHpHMS9wa3FRbG16RDRPQnNpRkRwemIxSldC?=
 =?utf-8?B?Y2RlL0oyMWhkc2pkL1RleVRrSmFrNnJPVElYNklUY3dVNnk1MktXWXI1UEt3?=
 =?utf-8?B?dWNZbTFZTXZoRjY1emxuY0F1WENKekVuYngrc2ticVMwMnRUWTNQd3hDSVRE?=
 =?utf-8?B?ZUtNb2lQNVhoNHlBQ2UyMlE1QkNLRzUrZW5RdldHbTdFaUNMaGpGQlRIdVNi?=
 =?utf-8?B?dUJ2cm5KV1Z5eWVkeEsyanNwK1Z4RXIreW1aRWd2YTRZclhVQ3V0OEs1VkNz?=
 =?utf-8?B?N09ER3gzbTA4VDlQbzRCdFZvMGZnY3RpOW9ubGFYYlVpQ2tDVlBwSDkzQjM5?=
 =?utf-8?B?UjRpTEdsUkF6ZXdBZnQ5cVZGN2hvQks3eFJKSytVbHh4MXZteHdlN1FTb1Y1?=
 =?utf-8?B?RGZhNy8vb3ppV1BzdzFmcXo5VnYwLzgzaEgxSjFJUEtJMDNPK1Q5UmRoM2JI?=
 =?utf-8?B?QmNrdUU2V0tRbXZRSE8vYmVlcnFWRGU3VVg5TXFuelBNUVlKMCsvR2ZwdS9B?=
 =?utf-8?Q?7v01tHYZC10IwpzGpc7PxkgEp?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9153255-f053-451b-3e19-08dd393c69ec
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2025 10:23:12.8407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l3KeDzntJbDlnyeD8ZgZh3rbBAIPoJZtjf9wb2yMXutv401c/XSv2tUatR4BFU4FIA7yzvtkWp0hE+9Z0RNv5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6184



On 15/1/25 17:15, Chenyi Qiang wrote:
> 
> 
> On 1/15/2025 12:06 PM, Alexey Kardashevskiy wrote:
>> On 10/1/25 17:38, Chenyi Qiang wrote:
>>>
>>>
>>> On 1/10/2025 8:58 AM, Alexey Kardashevskiy wrote:
>>>>
>>>>
>>>> On 9/1/25 15:29, Chenyi Qiang wrote:
>>>>>
>>>>>
>>>>> On 1/9/2025 10:55 AM, Alexey Kardashevskiy wrote:
>>>>>>
>>>>>>
>>>>>> On 9/1/25 13:11, Chenyi Qiang wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 1/8/2025 7:20 PM, Alexey Kardashevskiy wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> On 8/1/25 21:56, Chenyi Qiang wrote:
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> On 1/8/2025 12:48 PM, Alexey Kardashevskiy wrote:
>>>>>>>>>> On 13/12/24 18:08, Chenyi Qiang wrote:
>>>>>>>>>>> As the commit 852f0048f3 ("RAMBlock: make guest_memfd require
>>>>>>>>>>> uncoordinated discard") highlighted, some subsystems like VFIO
>>>>>>>>>>> might
>>>>>>>>>>> disable ram block discard. However, guest_memfd relies on the
>>>>>>>>>>> discard
>>>>>>>>>>> operation to perform page conversion between private and shared
>>>>>>>>>>> memory.
>>>>>>>>>>> This can lead to stale IOMMU mapping issue when assigning a
>>>>>>>>>>> hardware
>>>>>>>>>>> device to a confidential VM via shared memory (unprotected memory
>>>>>>>>>>> pages). Blocking shared page discard can solve this problem,
>>>>>>>>>>> but it
>>>>>>>>>>> could cause guests to consume twice the memory with VFIO,
>>>>>>>>>>> which is
>>>>>>>>>>> not
>>>>>>>>>>> acceptable in some cases. An alternative solution is to convey
>>>>>>>>>>> other
>>>>>>>>>>> systems like VFIO to refresh its outdated IOMMU mappings.
>>>>>>>>>>>
>>>>>>>>>>> RamDiscardManager is an existing concept (used by virtio-mem) to
>>>>>>>>>>> adjust
>>>>>>>>>>> VFIO mappings in relation to VM page assignment. Effectively page
>>>>>>>>>>> conversion is similar to hot-removing a page in one mode and
>>>>>>>>>>> adding it
>>>>>>>>>>> back in the other, so the similar work that needs to happen in
>>>>>>>>>>> response
>>>>>>>>>>> to virtio-mem changes needs to happen for page conversion events.
>>>>>>>>>>> Introduce the RamDiscardManager to guest_memfd to achieve it.
>>>>>>>>>>>
>>>>>>>>>>> However, guest_memfd is not an object so it cannot directly
>>>>>>>>>>> implement
>>>>>>>>>>> the RamDiscardManager interface.
>>>>>>>>>>>
>>>>>>>>>>> One solution is to implement the interface in HostMemoryBackend.
>>>>>>>>>>> Any
>>>>>>>>>>
>>>>>>>>>> This sounds about right.
>>>>
>>>> btw I am using this for ages:
>>>>
>>>> https://github.com/aik/qemu/
>>>> commit/3663f889883d4aebbeb0e4422f7be5e357e2ee46
>>>>
>>>> but I am not sure if this ever saw the light of the day, did not it?
>>>> (ironically I am using it as a base for encrypted DMA :) )
>>>
>>> Yeah, we are doing the same work. I saw a solution from Michael long
>>> time ago (when there was still
>>> a dedicated hostmem-memfd-private backend for restrictedmem/gmem)
>>> (https://github.com/AMDESE/qemu/
>>> commit/3bf5255fc48d648724d66410485081ace41d8ee6)
>>>
>>> For your patch, it only implement the interface for
>>> HostMemoryBackendMemfd. Maybe it is more appropriate to implement it for
>>> the parent object HostMemoryBackend, because besides the
>>> MEMORY_BACKEND_MEMFD, other backend types like MEMORY_BACKEND_RAM and
>>> MEMORY_BACKEND_FILE can also be guest_memfd-backed.
>>>
>>> Think more about where to implement this interface. It is still
>>> uncertain to me. As I mentioned in another mail, maybe ram device memory
>>> region would be backed by guest_memfd if we support TEE IO iommufd MMIO
>>> in future. Then a specific object is more appropriate. What's your
>>> opinion?
>>
>> I do not know about this. Unlike RAM, MMIO can only do "in-place
>> conversion" and the interface to do so is not straight forward and VFIO
>> owns MMIO anyway so the uAPI will be in iommufd, here is a gist of it:
>>
>> https://github.com/aik/linux/
>> commit/89e45c0404fa5006b2a4de33a4d582adf1ba9831
>>
>> "guest request" is a communication channel from the VM to the secure FW
>> (AMD's "PSP") to make MMIO allow encrypted access.
> 
> It is still uncertain how to implement the private MMIO. Our assumption
> is the private MMIO would also create a memory region with
> guest_memfd-like backend. Its mr->ram is true and should be managed by
> RamdDiscardManager which can skip doing DMA_MAP in VFIO's region_add
> listener.

My current working approach is to leave it as is in QEMU and VFIO. And 
then avoid page state changes in KVM when private MMIO fault happens, 
and treat it just like normal MMIO.

And iommufd does not allow mapping VFIO MMIO anyway, I am getting:

qemu-system-x86_64: warning: IOMMU_IOAS_MAP failed: Bad address, PCI BAR?

I am really hoping for in-place memory conversion to become available 
sooner than later :)

>>
>>
>>>>
>>>>>>>>>>
>>>>>>>>>>> guest_memfd-backed host memory backend can register itself in the
>>>>>>>>>>> target
>>>>>>>>>>> MemoryRegion. However, this solution doesn't cover the scenario
>>>>>>>>>>> where a
>>>>>>>>>>> guest_memfd MemoryRegion doesn't belong to the HostMemoryBackend,
>>>>>>>>>>> e.g.
>>>>>>>>>>> the virtual BIOS MemoryRegion.
>>>>>>>>>>
>>>>>>>>>> What is this virtual BIOS MemoryRegion exactly? What does it look
>>>>>>>>>> like
>>>>>>>>>> in "info mtree -f"? Do we really want this memory to be DMAable?
>>>>>>>>>
>>>>>>>>> virtual BIOS shows in a separate region:
>>>>>>>>>
>>>>>>>>>       Root memory region: system
>>>>>>>>>        0000000000000000-000000007fffffff (prio 0, ram): pc.ram KVM
>>>>>>>>>        ...
>>>>>>>>>        00000000ffc00000-00000000ffffffff (prio 0, ram): pc.bios KVM
>>>>>>>>
>>>>>>>> Looks like a normal MR which can be backed by guest_memfd.
>>>>>>>
>>>>>>> Yes, virtual BIOS memory region is initialized by
>>>>>>> memory_region_init_ram_guest_memfd() which will be backed by a
>>>>>>> guest_memfd.
>>>>>>>
>>>>>>> The tricky thing is, for Intel TDX (not sure about AMD SEV), the
>>>>>>> virtual
>>>>>>> BIOS image will be loaded and then copied to private region.
>>>>>>> After that,
>>>>>>> the loaded image will be discarded and this region become useless.
>>>>>>
>>>>>> I'd think it is loaded as "struct Rom" and then copied to the MR-
>>>>>> ram_guest_memfd() which does not leave MR useless - we still see
>>>>>> "pc.bios" in the list so it is not discarded. What piece of code
>>>>>> are you
>>>>>> referring to exactly?
>>>>>
>>>>> Sorry for confusion, maybe it is different between TDX and SEV-SNP for
>>>>> the vBIOS handling.
>>>>>
>>>>> In x86_bios_rom_init(), it initializes a guest_memfd-backed MR and
>>>>> loads
>>>>> the vBIOS image to the shared part of the guest_memfd MR.
>>>>> For TDX, it
>>>>> will copy the image to private region (not the vBIOS guest_memfd MR
>>>>> private part) and discard the shared part. So, although the memory
>>>>> region still exists, it seems useless.
>>>>> It is different for SEV-SNP, correct? Does SEV-SNP manage the vBIOS in
>>>>> vBIOS guest_memfd private memory?
>>>>
>>>> This is what it looks like on my SNP VM (which, I suspect, is the same
>>>> as yours as hw/i386/pc.c does not distinguish Intel/AMD for this
>>>> matter):
>>>
>>> Yes, the memory region object is created on both TDX and SEV-SNP.
>>>
>>>>
>>>>    Root memory region: system
>>>>     0000000000000000-00000000000bffff (prio 0, ram): ram1 KVM gmemfd=20
>>>>     00000000000c0000-00000000000dffff (prio 1, ram): pc.rom KVM gmemfd=27
>>>>     00000000000e0000-000000001fffffff (prio 0, ram): ram1
>>>> @00000000000e0000 KVM gmemfd=20
>>>> ...
>>>>     00000000ffc00000-00000000ffffffff (prio 0, ram): pc.bios KVM
>>>> gmemfd=26
>>>>
>>>> So the pc.bios MR exists and in use (hence its appearance in "info mtree
>>>> -f").
>>>>
>>>>
>>>> I added the gmemfd dumping:
>>>>
>>>> --- a/system/memory.c
>>>> +++ b/system/memory.c
>>>> @@ -3446,6 +3446,9 @@ static void mtree_print_flatview(gpointer key,
>>>> gpointer value,
>>>>                    }
>>>>                }
>>>>            }
>>>> +        if (mr->ram_block && mr->ram_block->guest_memfd >= 0) {
>>>> +            qemu_printf(" gmemfd=%d", mr->ram_block->guest_memfd);
>>>> +        }
>>>>
>>>
>>> Then I think the virtual BIOS is another case not belonging to
>>> HostMemoryBackend which convince us to implement the interface in a
>>> specific object, no?
>>
>> TBH I have no idea why pc.rom and pc.bios are separate memory regions
>> but in any case why do these 2 areas need to be treated any different
>> than the rest of RAM? Thanks,
> 
> I think no difference. That's why I suggest implementing the RDM
> interface in a specific object to cover both instead of the only
> HostMemoryBackend.

I am still confused. Sounds like nothing prevents doing it either way, 
just a matter of taste, is that right? Thanks,


-- 
Alexey


