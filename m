Return-Path: <kvm+bounces-34653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D97CEA035DA
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 04:30:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD8F9163A67
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 03:30:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E62017E00E;
	Tue,  7 Jan 2025 03:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="J3Qb67Bq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2088.outbound.protection.outlook.com [40.107.237.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC77A13C8E8;
	Tue,  7 Jan 2025 03:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736220613; cv=fail; b=Xpx+Af7pB1gLIPDTsjJTU7ilsQ2zMHjHV7obqutsLJxJi4NUu/T3SoxCw8zD3fZ4B2QFXrw4rSO6/J6F1lUEXdEiy1PGShzHKFaVH12cdiA4lYBks0+77nd9NS9tnhEoWf37HSP+/YVKswHCEXV8AGX6H3jXx8MTm/Y+JXWOeU8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736220613; c=relaxed/simple;
	bh=m4Xc9WXqFRcNAWYWCq1vrTdL79+Lo+BybKSxT+Y8efM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Y5H9lxFTHBX6oPN9GJUXVlenKhlQ1+l89mAJ2Gje75k7rXbAnKFjSSGeYsGZZasZm9evVlCml18fl/bZDu6shdbfaPLg3hVH4KA9L8/y0Yom3tuGwZBszSsMS8gZK7rq2eUz2cp5oUHaGB0GMCxUJAzAUSwvB5LLoSVobWEapnU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=J3Qb67Bq; arc=fail smtp.client-ip=40.107.237.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uC/2XtSugN9Y6hwIOQzQmEap88FZsVgpDBTi/Wie7zkZLqy/kWEbvfSGV0m1W1MqcubPOvBCELCZYmY35du09Axv1cWoQb1FixWbB3xj6n+00toECxN0oPMeriRABjt+wB/2I+eDanqk7GfgEwsXdv2GhHXRRFPsEmcAnsRSAHSy7LTitl4Iw81ANhTKFw53cwFaUyBnsXI7k2F1TDJ77B4ZSgxYlDUq1PDjFLCkSYNq8Ic4CDErQ3Vu5K7oJ7GXmzERWgPoJTzQvk99pU07vpoZz5pwp4UEnfVi4o+ATOsiDP+hVHQP4H8o3+Ikdco4RzB1pfiGLK0q1CGGxsy/+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DDYL1v+ZSXPggY/MhVrspcuqUzCtf0DZa/H1nVdb6dQ=;
 b=ACR5RKdPw3RWlhpe2p9xcQdT2QZnKk7yg7JgavaALafFsNahkG8aQYIYdXNkhw6PW+HTu1+IVKWpOKyrC0iOe1bE45vXaVIxP0C6J6XhjM9DAEwizYBdrtWIdtJQ5sl04Cr1qgh1nq28OKDl34c6BSxXmfuVdxqKXciSG0u/ZSKwJ1wZ7o4UxZHsMvuq6/F6LZEfYb7p81dWIQYl3adBov/05H7pJBv3o/Yjf+Iop1Csl4WhlbFqSVkBNQp/v5ioRa1sAz5ek7lEahLkUWJ7D/VK9mAW6M5/dMC4ScDX799G3stlaG5eKjR5svPE9LUft+q3WMDxxIumKU46I23MUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DDYL1v+ZSXPggY/MhVrspcuqUzCtf0DZa/H1nVdb6dQ=;
 b=J3Qb67BqWRQL+B31cvykyDv39GrrhIiYQjlKCK4zjKP9GAQPgTWBxFFfi8P5vVaxoLiu5DPS7eppZRQYjDlpT3fk0MaZ4z3YjX487/nAdMi5V/qAcpMPeqttokVdhFY0TtyGTkQgO6qCaZmeaD9YHUst8Yl1GYER1MA08CtAUFg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by PH8PR12MB6817.namprd12.prod.outlook.com (2603:10b6:510:1c8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.12; Tue, 7 Jan
 2025 03:30:03 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8314.015; Tue, 7 Jan 2025
 03:30:03 +0000
Message-ID: <a6cfdfe5-37b5-4d86-9a97-ac75720ad424@amd.com>
Date: Tue, 7 Jan 2025 14:29:53 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v3 2/7] crypto: ccp: Fix implicit SEV/SNP init and
 shutdown in ioctls
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au,
 davem@davemloft.net
Cc: michael.roth@amd.com, dionnaglaze@google.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-coco@lists.linux.dev
References: <cover.1735931639.git.ashish.kalra@amd.com>
 <be4d4068477c374ca6aa5b173dc1ee46ca5af44d.1735931639.git.ashish.kalra@amd.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <be4d4068477c374ca6aa5b173dc1ee46ca5af44d.1735931639.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: OS0P286CA0022.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:9d::9) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|PH8PR12MB6817:EE_
X-MS-Office365-Filtering-Correlation-Id: 9eab9ef6-a7cd-4d2d-d3a6-08dd2ecb92d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RFE1aDZka21ZRGg1aFYrKytqL2Zaa1MyVStIVzVabXJaTitpWjFVU2wwc2M0?=
 =?utf-8?B?MGt3N0pXOFBjVUZJWmVRM3E4Nkt0VDVDTFFBYnYxLzI1c1N3clNWd2xMUWFO?=
 =?utf-8?B?VVl4d1Njcll5Q3VNTDc0RS9Hdk5qQUVIUTJ3bThCeC9XMCtYUlNxdUpEWm1K?=
 =?utf-8?B?d29vb0o1aXdQYTFyVFRZSVFvaVhZVXV5RGIxUzA1Q0Z2VExqM0dPTURqWVNv?=
 =?utf-8?B?aFA4VG04VTNNYTF5Q3lrb3dOUUxnTWVEKzAwQ2FIN3Z4bzFhazg2d29sZGZJ?=
 =?utf-8?B?MlpyRmRoclUwK0R1NE4yM1AveExPQVhoMWhRUG9pL0UrV2tiSFNFU0ZIcXI2?=
 =?utf-8?B?dGVBRTJIczRCaVQ0RGEwQ21WRjZWT2V4Qm9DTEZubGJzNTRlMGtLdGJSbmNO?=
 =?utf-8?B?Z0tKNk1nMDVEalUzQ1VZQTQ1UWFIMFZ2aTB3TTVLZ2Y1TnE2M0h3bVhjQ01M?=
 =?utf-8?B?Z3Z5VGd5OVBXRDJ0V1JUZng3RE9CaFVVT0hXOTNGRUlpQ0ViNlBGSUw5Qm10?=
 =?utf-8?B?QTRiYmFjMlF5bGtPSnUwMmRDUVI2SXdyR01MVksrWkNqaEI2c3JGZ2JkYTQ2?=
 =?utf-8?B?YUlJd3BGUUlzWW9qSk55ZFdpa2ZtZHczRjI1SlRXOE5jenBaN0pBZ1RNazhs?=
 =?utf-8?B?VjdJOTVsWkt0V3dmL0lENWlCOFpqRytqbFNZeVV6dGhRK0tmazFhZE1NcXlo?=
 =?utf-8?B?VWVUUzAyVlVGZGJDRjQ3T3FUSk96cUFJVFhrRlk3UmMweE9scXZsdHNOdmd4?=
 =?utf-8?B?ZUZyUWExVXFJMFh6aVcvT29aNGdjL2ZocHllSUZweWF3Wkpaak4ybkViUXdM?=
 =?utf-8?B?eVZjZ2RzWnkrdUIweHJTczFWUWVjczZ3TFJ0RGpnTnpXSTREUTE3dnNDeXRX?=
 =?utf-8?B?SjdYTlp6ajBndDlnUDVrVEdmSFdBK3IyOWZCb1ZVUStDVG5WOUd6N1dPMVRF?=
 =?utf-8?B?MHV5dnFZQnVZNlkxcG93RStJMVNQQmU5YUN5MllMc3VKUWtPT1hRUTBkbHNP?=
 =?utf-8?B?MHNiR29Za0U0SzI2aVNiSTA5ZjJTQ0djVlpoM2JpMDZBd1lnQ3dsS3V6TnIw?=
 =?utf-8?B?YlQyOTNpUWNYOFgvcDVaL2NXQXFJdWxQdVcvdDRXT1I3cWltMEV4VnBWQmt4?=
 =?utf-8?B?L0ZiTVY3MklnV3FHYmtscTAzQVFXRDVUSlBpbUhicFliZ2ZuUmZjUUxTRENm?=
 =?utf-8?B?c1ZINDhMbDZvclhLOEZZUHp1ZEZ5aW1QVkRZeWpwdm1lOWpxZzZqWklreDNQ?=
 =?utf-8?B?NXIzYlNkNnNsaHJxbnM3TllQMTNNOTRXQlVhUVBGMTRQRFBGcW81T2dCNUF4?=
 =?utf-8?B?ZXo4cHRydlI5SWFhSk43VFljbEFsalBiSUFKWlFVaWt5RUhVei9Xd01jdkJD?=
 =?utf-8?B?OUJwbWpmRUZrN3E2Z2RocEZyYW52ZlFVWjNoazNSZS9WNHVBOSs3MXhLNWpC?=
 =?utf-8?B?MkY3WTJMdk1JVnVDa0RRTkNHZWxuRzlmWnN1YTFKSElhNkxJRzJwVDBlb01F?=
 =?utf-8?B?Mk9hQjdiK1VaTHFXa2dUNkRRbzJJVjZONDRNbWJLOEd1WlZPN0I2K3FJeWRv?=
 =?utf-8?B?eU9xZVdXbW1uUjlxSHp6aXJIelMyN2pjUEtUMFd3NktQS3N4OFJUQ09XOTR1?=
 =?utf-8?B?NkVmZUg3UU80SURnQ3JqQVdJWlZ3bkkzQXY5ZlUwOGZQclFnbmZjTnhFSVdW?=
 =?utf-8?B?ZVJtOFJzVjNXSEpYUG8wS2c1RFVUM05yYlltM0dSa2hYZzc0MEdrcmNhZG9q?=
 =?utf-8?B?WFB5MXRHMy93bjZDTXZIdGRJUDdEZDJYaUd0UFR0MjdOWFQ3NnhSWTVPUy9U?=
 =?utf-8?B?RjBEcElxWTV4aTZsYmJzekpnanpPSzlZUGh2bmorYTZJaldnODQ2ajVXTk92?=
 =?utf-8?B?U0I0TGZqekh5SDJPQVZLQkU3bFl2bFdFSnpPemNkYnIzbERHakdVMVpEVWds?=
 =?utf-8?Q?pE4hAVpFxv4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZTEwVkZzVzIvclRLbHQ1MTBSaFJiT0FSVkhjWThXRFlNaFJMU1JybzMwMzVa?=
 =?utf-8?B?WDNEcENSSGhtWVA0NW4wUHl2RTZ3UDB1K0RsZmdjbWs4TkZiODVaZzFUelFo?=
 =?utf-8?B?ZU4va0w3aGdxcVFIVmZOdW8wV3VNZ1RnY2F4aWcvWXNEMHBrM2Y3WFhyeDNq?=
 =?utf-8?B?SWhsRkRURlJiaSs5OXBkaGxGc2tmaGhKL1pWdmVxZ0FFajA5SFZzNEplWnpE?=
 =?utf-8?B?WFpzZFI3aHgvMFB0ZXdwcXlSd0NJNHhVSU9rTk1SVmtZZy8zY3hkMFFsajd2?=
 =?utf-8?B?MHJ0dENacExiK2pPbzBtYXBXUVh5N3JGeExqbTFOWjN5YWNTNlBEQk1vdXV0?=
 =?utf-8?B?SlREcGtMNjBSVG1sdkJRbTMrQXE1WVlpZEMvdTJnNWlxZ1d6MWhmWFF4NVpl?=
 =?utf-8?B?a000bk8va2JMa28wcko3a0hnS3hQUkw1Nk0wUEpzL0FMblRUOEhTYUJhSmhO?=
 =?utf-8?B?UVo2TU1aSkFLOEpRMUc4SFcvMHREKzFUY1lDekU4bTg1UlVCd2J4MktuM2JL?=
 =?utf-8?B?aUVrOHJ4L0dIS2pURHBQMC9sbDA1amQxK2dmNk9zQXJyenZWVm5jZ2RiaE42?=
 =?utf-8?B?VmNUV3hCd3pTU3ZjSFpib0hzTDVTYUZPcThPZjhFT05YdHBMS0RUWU5pOUlj?=
 =?utf-8?B?RnNJQWpDY20yVGltSVV1VUhtRTJnVzV1a3RlMzFwY2Y1anpEQUJEYXZtekRz?=
 =?utf-8?B?eEtCVGhMWXkyT0FGYm1Ea0w4ci9NVkltSnhCN3VnUW9yek5DOFZ0V3dZNXVC?=
 =?utf-8?B?L2s4V3lkTlF1Y0lteWVoMXRsTDlMVDZRQTlFekRTM1phTnNWcXN0V0dMQnRJ?=
 =?utf-8?B?Y0RDdFo0cTVjTktvcUFpUXpZeWpNOFp4TXJqQ1dBdGNDTVFJRUZsK0NHdFk3?=
 =?utf-8?B?UkxnSmx6TWpCbzRFMkx3dHdENUQzWGdXQVpKbStMdmluZ2xwUzI0ZHBEWnhT?=
 =?utf-8?B?OFAyUVdzMC9BbHhhQmV3VHY4QWZ1bHVNMnFkUW5lYmRQWFRFc1Z0cmlXRVVW?=
 =?utf-8?B?RkFGZVFtaXl2Znlram9CRFpmUTRQN2hmQnFxdnJ3YSswQXlWZFNXa2xJa2tj?=
 =?utf-8?B?RHcvVmMvZDQ4VWdScVVhczJuT3ZiSE1FSDdydmtKVEVsQ0ZhUmhOemZwaG9o?=
 =?utf-8?B?ZWthdnhvVzhrM1ZaSUIvSzY5Yzd2NFA0OWtuQ0R1QmZFSjhMeDF5MkFvYUNh?=
 =?utf-8?B?L1puY3YxR3lWOUtNTHFOY1NuZnc2b2RiSGZHTEpaR1pmaVdJWGhTdFV6QXg4?=
 =?utf-8?B?ZkJpTTZLV3RYZmZYK3Qya1dFSXJTSUx6V0JVdFp4Qjh4a3hBdjQyQ2FNOGJH?=
 =?utf-8?B?RGNrdnJKZWorMXYzVmYyaUFheFh4OUtSNmxucUx4dmsyeUtRN3M0VXRxMG5k?=
 =?utf-8?B?QXBIQVlhb3BmZXdFdVBsMGQ5WXQ2RG02dnVtR3JCNlBOUG5KbXhYYldCZGpl?=
 =?utf-8?B?TlBXd2M1bjNSYlEwM3R4Ujd2MnVuL3BLclZXNUNDd0hyOGV0TzZMMzB2cjk5?=
 =?utf-8?B?RzZKSVVWanRGSjJBUFJwUFdjTFpyQXpjSk9ydWgxYnhuazJKZFVDa3UvZDdI?=
 =?utf-8?B?U0tiaW05SHlSNDFsVTJxS1FBN2tqMlJoaFM5VThDWi9tVFVnVEw0OTZnSFpn?=
 =?utf-8?B?S2pJSTc3M0dLNlNRSmN6R3RxcnM3dVU3SVNlbTJEcjFQejlMN2M5SjRtbUhp?=
 =?utf-8?B?UENpOG4wbDhaMWtnd0RseC92bkg3QlJKZU80eWM4MGZDUmRrdXRKeUVUVFd3?=
 =?utf-8?B?RWtJTEhEZjZRdTJLVktWdU9kZEZCYzg0QWkveXlNQnVJN2d6MllybkluTklp?=
 =?utf-8?B?VnpMT3ZPNllFMlZwZWFLcmlSRGJWZTZjdjJtQmlnbmgwck13Yk1vYUo2eU14?=
 =?utf-8?B?czF5b2c3NUVuRW1QdTQyMG5XS0txMXp0d2NiV2pSYjJzUEFBby9GWGtOYTF1?=
 =?utf-8?B?V2o2T1U2T21ZWCtjUjh0MjZyTmpFbC9zRTNOSFljMHJPa0ZWd2xQTmdnUmh1?=
 =?utf-8?B?dWp2cDZoQ2xiOXpoSTZUamRnT1ZuYzVKRjR4M0pWVDlnUUVNMTE1QlE4WFRC?=
 =?utf-8?B?YndRV0hFQVA2ZTF5cU82eUIwU1RwTjQrUjFnTmVKR2R3aDZlbmI3bUdmYjMy?=
 =?utf-8?Q?0gktp/o3D3e65wBN1sMAJFv/X?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eab9ef6-a7cd-4d2d-d3a6-08dd2ecb92d4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 03:30:03.6396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K2/Q7WQBnPQ01j0EQOj3inyyjg+MCPGTNU7PFvetUUGfi67b5qUoYrtdED1eMp6h6vKWbB1gMsVKqiDEUVMvcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6817

On 4/1/25 07:00, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Modify the behavior of implicit SEV initialization in some of the
> SEV ioctls to do both SEV initialization and shutdown and adds
> implicit SNP initialization and shutdown to some of the SNP ioctls
> so that the change of SEV/SNP platform initialization not being
> done during PSP driver probe time does not break userspace tools
> such as sevtool, etc.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>   drivers/crypto/ccp/sev-dev.c | 149 +++++++++++++++++++++++++++++------
>   1 file changed, 125 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 1c1c33d3ed9a..0ec2e8191583 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1454,7 +1454,8 @@ static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
>   static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool writable)
>   {
>   	struct sev_device *sev = psp_master->sev_data;
> -	int rc;
> +	bool shutdown_required = false;
> +	int rc, ret, error;
>   
>   	if (!writable)
>   		return -EPERM;
> @@ -1463,19 +1464,30 @@ static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool wr
>   		rc = __sev_platform_init_locked(&argp->error);
>   		if (rc)
>   			return rc;
> +		shutdown_required = true;
> +	}
> +
> +	rc = __sev_do_cmd_locked(cmd, NULL, &argp->error);
> +
> +	if (shutdown_required) {
> +		ret = __sev_platform_shutdown_locked(&error);
> +		if (ret)
> +			dev_err(sev->dev, "SEV: failed to SHUTDOWN error %#x, rc %d\n",
> +				error, ret);
>   	}
>   
> -	return __sev_do_cmd_locked(cmd, NULL, &argp->error);
> +	return rc;
>   }
>   
>   static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>   {
>   	struct sev_device *sev = psp_master->sev_data;
>   	struct sev_user_data_pek_csr input;
> +	bool shutdown_required = false;
>   	struct sev_data_pek_csr data;
>   	void __user *input_address;
> +	int ret, rc, error;
>   	void *blob = NULL;
> -	int ret;
>   
>   	if (!writable)
>   		return -EPERM;
> @@ -1506,6 +1518,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>   		ret = __sev_platform_init_locked(&argp->error);
>   		if (ret)
>   			goto e_free_blob;
> +		shutdown_required = true;
>   	}
>   
>   	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CSR, &data, &argp->error);
> @@ -1524,6 +1537,13 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>   	}
>   
>   e_free_blob:
> +	if (shutdown_required) {
> +		rc = __sev_platform_shutdown_locked(&error);
> +		if (rc)
> +			dev_err(sev->dev, "SEV: failed to SHUTDOWN error %#x, rc %d\n",
> +				error, rc);
> +	}
> +
>   	kfree(blob);
>   	return ret;
>   }
> @@ -1739,8 +1759,9 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
>   	struct sev_device *sev = psp_master->sev_data;
>   	struct sev_user_data_pek_cert_import input;
>   	struct sev_data_pek_cert_import data;
> +	bool shutdown_required = false;
>   	void *pek_blob, *oca_blob;
> -	int ret;
> +	int ret, rc, error;
>   
>   	if (!writable)
>   		return -EPERM;
> @@ -1772,11 +1793,19 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
>   		ret = __sev_platform_init_locked(&argp->error);
>   		if (ret)
>   			goto e_free_oca;
> +		shutdown_required = true;
>   	}
>   
>   	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, &data, &argp->error);
>   
>   e_free_oca:
> +	if (shutdown_required) {
> +		rc = __sev_platform_shutdown_locked(&error);
> +		if (rc)
> +			dev_err(sev->dev, "SEV: failed to SHUTDOWN error %#x, rc %d\n",
> +				error, rc);
> +	}
> +
>   	kfree(oca_blob);
>   e_free_pek:
>   	kfree(pek_blob);
> @@ -1893,17 +1922,8 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>   	struct sev_data_pdh_cert_export data;
>   	void __user *input_cert_chain_address;
>   	void __user *input_pdh_cert_address;
> -	int ret;
> -
> -	/* If platform is not in INIT state then transition it to INIT. */
> -	if (sev->state != SEV_STATE_INIT) {
> -		if (!writable)
> -			return -EPERM;
> -
> -		ret = __sev_platform_init_locked(&argp->error);
> -		if (ret)
> -			return ret;
> -	}
> +	bool shutdown_required = false;
> +	int ret, rc, error;
>   
>   	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
>   		return -EFAULT;
> @@ -1944,6 +1964,16 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>   	data.cert_chain_len = input.cert_chain_len;
>   
>   cmd:
> +	/* If platform is not in INIT state then transition it to INIT. */
> +	if (sev->state != SEV_STATE_INIT) {
> +		if (!writable)
> +			return -EPERM;

same comment as in v2:

goto e_free_cert, not return, otherwise leaks memory.



> +		ret = __sev_platform_init_locked(&argp->error);
> +		if (ret)
> +			goto e_free_cert;
> +		shutdown_required = true;
> +	}
> +
>   	ret = __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, &data, &argp->error);
>   
>   	/* If we query the length, FW responded with expected data. */
> @@ -1970,6 +2000,13 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>   	}
>   
>   e_free_cert:
> +	if (shutdown_required) {
> +		rc = __sev_platform_shutdown_locked(&error);
> +		if (rc)
> +			dev_err(sev->dev, "SEV: failed to SHUTDOWN error %#x, rc %d\n",
> +				error, rc);
> +	}
> +
>   	kfree(cert_blob);
>   e_free_pdh:
>   	kfree(pdh_blob);
> @@ -1979,12 +2016,13 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>   static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
>   {
>   	struct sev_device *sev = psp_master->sev_data;
> +	bool shutdown_required = false;
>   	struct sev_data_snp_addr buf;
>   	struct page *status_page;
> +	int ret, rc, error;
>   	void *data;
> -	int ret;
>   
> -	if (!sev->snp_initialized || !argp->data)
> +	if (!argp->data)
>   		return -EINVAL;
>   
>   	status_page = alloc_page(GFP_KERNEL_ACCOUNT);
> @@ -1993,6 +2031,13 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
>   
>   	data = page_address(status_page);
>   
> +	if (!sev->snp_initialized) {
> +		ret = __sev_snp_init_locked(&argp->error);
> +		if (ret)
> +			goto cleanup;
> +		shutdown_required = true;
> +	}
> +
>   	/*
>   	 * Firmware expects status page to be in firmware-owned state, otherwise
>   	 * it will report firmware error code INVALID_PAGE_STATE (0x1A).
> @@ -2021,6 +2066,13 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
>   		ret = -EFAULT;
>   
>   cleanup:
> +	if (shutdown_required) {
> +		rc = __sev_snp_shutdown_locked(&error, false);
> +		if (rc)
> +			dev_err(sev->dev, "SEV-SNP: failed to SHUTDOWN error %#x, rc %d\n",
> +				error, rc);
> +	}
> +
>   	__free_pages(status_page, 0);
>   	return ret;
>   }
> @@ -2029,21 +2081,38 @@ static int sev_ioctl_do_snp_commit(struct sev_issue_cmd *argp)
>   {
>   	struct sev_device *sev = psp_master->sev_data;
>   	struct sev_data_snp_commit buf;
> +	bool shutdown_required = false;
> +	int ret, rc, error;
>   
> -	if (!sev->snp_initialized)
> -		return -EINVAL;
> +	if (!sev->snp_initialized) {
> +		ret = __sev_snp_init_locked(&argp->error);
> +		if (ret)
> +			return ret;
> +		shutdown_required = true;
> +	}
>   
>   	buf.len = sizeof(buf);
>   
> -	return __sev_do_cmd_locked(SEV_CMD_SNP_COMMIT, &buf, &argp->error);
> +	ret = __sev_do_cmd_locked(SEV_CMD_SNP_COMMIT, &buf, &argp->error);
> +
> +	if (shutdown_required) {
> +		rc = __sev_snp_shutdown_locked(&error, false);
> +		if (rc)
> +			dev_err(sev->dev, "SEV-SNP: failed to SHUTDOWN error %#x, rc %d\n",
> +				error, rc);
> +	}
> +
> +	return ret;
>   }
>   
>   static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable)
>   {
>   	struct sev_device *sev = psp_master->sev_data;
>   	struct sev_user_data_snp_config config;
> +	bool shutdown_required = false;
> +	int ret, rc, error;
>   
> -	if (!sev->snp_initialized || !argp->data)
> +	if (!argp->data)
>   		return -EINVAL;
>   
>   	if (!writable)
> @@ -2052,17 +2121,34 @@ static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable
>   	if (copy_from_user(&config, (void __user *)argp->data, sizeof(config)))
>   		return -EFAULT;
>   
> -	return __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
> +	if (!sev->snp_initialized) {
> +		ret = __sev_snp_init_locked(&argp->error);
> +		if (ret)
> +			return ret;
> +		shutdown_required = true;
> +	}
> +
> +	ret = __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
> +
> +	if (shutdown_required) {
> +		rc = __sev_snp_shutdown_locked(&error, false);
> +		if (rc)
> +			dev_err(sev->dev, "SEV-SNP: failed to SHUTDOWN error %#x, rc %d\n",
> +				error, rc);
> +	}
> +
> +	return ret;
>   }
>   
>   static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
>   {
>   	struct sev_device *sev = psp_master->sev_data;
>   	struct sev_user_data_snp_vlek_load input;
> +	bool shutdown_required = false;
> +	int ret, rc, error;
>   	void *blob;
> -	int ret;
>   
> -	if (!sev->snp_initialized || !argp->data)
> +	if (!argp->data)
>   		return -EINVAL;
>   
>   	if (!writable)
> @@ -2081,8 +2167,23 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
>   
>   	input.vlek_wrapped_address = __psp_pa(blob);
>   
> +	if (!sev->snp_initialized) {
> +		ret = __sev_snp_init_locked(&argp->error);
> +		if (ret)
> +			goto cleanup;
> +		shutdown_required = true;
> +	}
> +
>   	ret = __sev_do_cmd_locked(SEV_CMD_SNP_VLEK_LOAD, &input, &argp->error);
>   
> +	if (shutdown_required) {
> +		rc = __sev_snp_shutdown_locked(&error, false);
> +		if (rc)
> +			dev_err(sev->dev, "SEV-SNP: failed to SHUTDOWN error %#x, rc %d\n",
> +				error, rc);
> +	}
> +

same comment as in v2:


It is the same template 8 (?) times, I'd declare rc and error inside the 
"if (shutdown_required)" scope or even drop them and error messages as 
__sev_snp_shutdown_locked() prints dev_err() anyway.

if (shutdown_required)
     __sev_snp_shutdown_locked(&error, false);

and that's it. Thanks,

> +cleanup:
>   	kfree(blob);
>   
>   	return ret;

-- 
Alexey


