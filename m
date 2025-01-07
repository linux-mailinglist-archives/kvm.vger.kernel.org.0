Return-Path: <kvm+bounces-34650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 94D2FA0359F
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 04:00:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EDC761883E30
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 03:00:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98F4D1607B7;
	Tue,  7 Jan 2025 02:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="U1EBuZTS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2069.outbound.protection.outlook.com [40.107.101.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB2678F36;
	Tue,  7 Jan 2025 02:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736218797; cv=fail; b=P+6W7/3SY4Zu7FUJx7hvsbOl6VMqy4G5Nfg+IGZVja3xh9zHfxCmQ7ouDJtfiI4LpSVgreVnhJiAG1Jg4A7qr6GjA0stclPhgmj149TOoSSAxus6YY2KjMOoTLl+voJkh2ynGN91INhcnK9X5OKxAvZVBg9eJRoXOaIACTHqh2o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736218797; c=relaxed/simple;
	bh=tWPwubctAkdMHJRF8h+FZM9QlDZoD5RJo2Z4jLcBd7Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Y1aLSkWWxPDHue94W4pXO78309r2nA2CapWog006h7fW/hMnFr3FdAe+uZF7KX38sBAYbJmt100Q7gffFBTXIc1WlJoNsIql8DCecIVApPlg2aV3hhfYW1768LG2pr+OpHZreAk2kuRwjGaBgLV7EULVafoJlEWMjNl2eCHFDsg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=U1EBuZTS; arc=fail smtp.client-ip=40.107.101.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GsYS1bmVb+iTiCtqxibgFDhzDCH7p951055TRSjc9mERu0wVcc9MDq8wYM/8RCzIoaPz6yAiOFhjNNENRZn/1ZFB4XYoLAyNITFM2bD4nFdcnbvht6LZ7F14Nborpx1+sTbwGZhsOzrytsS+kXyd3acjvsKpqyfWi8/cu5ZQbu00o+IU1AGzVbp5iZqQnwtB9rKRugtl96ud9NY3PzHd0/2hppznI/wnjR+4SChZE6jjmVEeYaXAPNBgTABc+94TGyzHXDW4yPV8PkSDlj3uRThzLru+ExonzF05POKsv5n5lb/aDWs/2k15b0Ekv2vfa2I4w2A1Cv9Dm63A4SaaIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ll9FnLY4l2HN8WaNUzK0/qtTJkl4UoTe+Rv9pWwjeW0=;
 b=ob2J1UPzhtixkPb/8VK/XqpQ+ku3bRtswYfZYKASdFW7Tb5UtorwSUXaviG9fUKGMN8zYsidVsl+wNGgFH5pvpo8pRqbrvZB5yngDkH4Crroi9gXG7x/NbHh/0HYEpFue1tAuG2qYyZIgZT0cpgPtKhDPKR7mGULoiubFOFhsKEEiSwDk/o0UDXraFp5nuMQZzYtURkDDqHsukrW3ScaGpGYAEyR1cd580i5gCSKHTjFozeJ3SP2THPn53U1uU/qx+enqiZGWBPv//xJa219pKuGEZc52YdllZIK8SP9RXWcpmQnJJtqy5Hfk9gh+ZJRkzxg7TMedqp2fxpQPUp1/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ll9FnLY4l2HN8WaNUzK0/qtTJkl4UoTe+Rv9pWwjeW0=;
 b=U1EBuZTS0dYPU/iKheKvsTHtwZPI3w8t7ZglpC+jYjJENi/26f5aTDidmYtMbbkB80zjVJLfdcLhwx007p3dBi09cp3X1YCR4l7PAZfbJfqkFczRdua01mjGfQH8rOGpEoz1tVHMMuiWXq2usFWXdNjS9Yd+8AMkwIFaWMzd6JY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by MN0PR12MB6271.namprd12.prod.outlook.com (2603:10b6:208:3c1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.18; Tue, 7 Jan
 2025 02:59:45 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8314.015; Tue, 7 Jan 2025
 02:59:45 +0000
Message-ID: <b073e961-4faf-40b0-8c7a-6525748ec971@amd.com>
Date: Tue, 7 Jan 2025 13:59:35 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v2 3/9] crypto: ccp: Reset TMR size at SNP Shutdown
Content-Language: en-US
To: Tom Lendacky <thomas.lendacky@amd.com>,
 Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com, pbonzini@redhat.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net
Cc: michael.roth@amd.com, dionnaglaze@google.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-coco@lists.linux.dev
References: <cover.1734392473.git.ashish.kalra@amd.com>
 <3169b517645a1dea2926f71bcd1ad6ad447531af.1734392473.git.ashish.kalra@amd.com>
 <433dc629-a84b-470a-8c2f-9bb531a23185@amd.com>
 <63af2db5-9787-5165-ee5e-9bb825752f6a@amd.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <63af2db5-9787-5165-ee5e-9bb825752f6a@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MEWPR01CA0067.ausprd01.prod.outlook.com
 (2603:10c6:220:1de::12) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|MN0PR12MB6271:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fb34a4d-855a-4207-2f95-08dd2ec756c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L0x0YWpWTGtSYzhjQ1RYVFdORTFoc29uejVKRlllWUFFUnFQVU5uNk9FRlA4?=
 =?utf-8?B?UXYzSHpzZHpyQ3JJOVZObjlUUkJVcVpDaG9XOHBUVnJSZjJqQldlV0J3ZmRa?=
 =?utf-8?B?VU9wWXRrNFN4NHR4aThLNStDUWZPQUp1YnBtNzhIWDFLNG9BaTdhdURnMktL?=
 =?utf-8?B?TjlCdnlTUm0yTWs5eThHaC9hTk9lWFRjSU1xUlFySnM1UDJBeFJKQzhpTUFK?=
 =?utf-8?B?UGpIVkkxVVJDcG94WDFwRzFYczJCRjl0NXIyb3ptUXo1YkFCaGxpdS9mOVV1?=
 =?utf-8?B?Z1VUa05ZcWYxNGdscktLMnd0amtJTW13dTduTURpUElFTkdZSDlOY25nT01U?=
 =?utf-8?B?dG03S3dyb1duTERlanFCZHYxODZwUTY1T1FlSzhsa3NrREU3cnlzWmlEeVZO?=
 =?utf-8?B?UFZzOG5tVU51cE5peEFIRG9ZdWlSM2g2WU5CK2h1Sit1R3pqNzVsOTM2dUZn?=
 =?utf-8?B?OXhZbGlxNG4wczFZaFNaZ08yWVFEdU5OakMzYmdKRHo1N3laU2dWVVZ0T1Vw?=
 =?utf-8?B?ai8reGIvZ0lzTCtML3V2M3l5UVI1OEk3K3FPVlc5b25BNDVac3RnMlc0aDgv?=
 =?utf-8?B?Mkk2VUUzTFJCNGk1cGs2Q2FsNno2ZWZMdjZ4c1ZsaFZERWZUQUtLcFYrK2la?=
 =?utf-8?B?RVdlWFd6NXcyWkFCak1zT0xmTDBFVmRkUENUaXY5V3FqRlg3VDRiVGtXSHZj?=
 =?utf-8?B?d1ZjRWlGZWlyZm96YU03VUU0OVByUUxzbjV0dXRkd2lOT3d2YjF6NTJXL2F5?=
 =?utf-8?B?QjQ3VngrVzlTbmx5a0tCUXczaE94UUlFN25HUmllbzMraVQ4YkFya0NUMmNs?=
 =?utf-8?B?bkM5bjg5OHo2TmVEdUFmY1BRdWJsNzNvNU9qQzc2Q2xSSzBSOXI5NEZUZEIy?=
 =?utf-8?B?Qi9xYWZaNzdnZE05Um9yQnowVFZWOXd1MzVtMFRJK2pIWTdnajdpSEp1V0lL?=
 =?utf-8?B?S0ozMnFNWmx4ZlAydytwdXBtcTJiaE9yQnRyRTZXbGltK0ZZdnJLcGpZZFlJ?=
 =?utf-8?B?dzUwQ2paTlRrUUIra21tSTV5VTJaZUlNOExjQlo2OXN5K0RLTWVzeG9JU1Yw?=
 =?utf-8?B?QkRGZFhIZ1lCSUVHZXFRWUd2SHEwemx1NE9tbGUzcFltUklJaVBYYlluMDZW?=
 =?utf-8?B?WnNabHhJRmRwSEdNUmo4SjJGclpsUTZ3R2krQWoySXQ1c05Bc3llTjB2Wkp2?=
 =?utf-8?B?aHJKN1EwUEJKM3hJSC9YRzA3VGYzTW5OOVEvWlUydEFVWGRBdzc0cFNjN1p2?=
 =?utf-8?B?aW1ycTdua01Hb0FxVEZjaUliVDVrZmNaK3dySU1rZFJVaHZ5bmRodTJIcEFN?=
 =?utf-8?B?WXRDd2p2SVBCQjhENU52RG9xL1BkampEQklVTHMwdTdPV2M5S3ZLY2JUU1lX?=
 =?utf-8?B?VnNhSG0reGdseU5uck9sMFFiRlc0dEdraU5pcmorQnd5alI4VHg0T29CMUJQ?=
 =?utf-8?B?cndZaFVzWTNDcWIxZHJNLzlWc1pvSDhuR3NHV3ZnU2IyU25sazZFelNLVHdi?=
 =?utf-8?B?MmNwR1I2REdDY254Tjd4R1V3QURPell4ODJnM3RwQ1FuN1dCT1hiSnRkT3pj?=
 =?utf-8?B?bTR6cW1oL21TeEhzMmhDZnJaUG94WDNjRGoyTUx1d29nU3lOQmVJV2U1VEk4?=
 =?utf-8?B?MTkyZW5vVWJKYlJDK2RoTk9wTGwwaDlLQzRaLzIwN3Y1RCtPR3B5Zy9WVUhX?=
 =?utf-8?B?S3hjR04vZlNpWEtkTWZTZTVmeFdkcU55QlFldkJtT2o3SmJ0RzMxUXJBbXEv?=
 =?utf-8?B?UDNkOGk3akljRFBzOGJyMXFHWlJ0WnJXd3JLbUYvYzNZYzlFTnNhTzFrTXhJ?=
 =?utf-8?B?dUNaSEtvZkxXd3llWk9Kd1I4SllOVEtTSTF0czgybUVYbDJTamJFd0lubEVh?=
 =?utf-8?B?bG9XVVVZOWJpQTJWeGNOazhtcWtMdWo4QTBKT2tiM21ZUG1PN3gxWGpnWTl3?=
 =?utf-8?Q?5V/TKg3mFC4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aDY0WjB2Q083eUlvTFZOWHp5azBYQnVCbFJ3TWwxWWlLQlRTZklIZzdNRkM0?=
 =?utf-8?B?eHJwa09Ub1A5ekhKcEluSUFYZ3NKMHhXQ1NUYWJWODhsMGl0YmJqZTVuMHR3?=
 =?utf-8?B?RXBoQUxWYmk4WWZ1Rm5FSmNxV1FDOGJOcm5SeFp6UjJZb0QyTHNZNWtUSTEv?=
 =?utf-8?B?Y3BGNHlxYTVCSTZaOGlUZjhKUHkvS09xWFh1V3JyRXh2Q041aHRkK3dFUHVW?=
 =?utf-8?B?ZDRoNVk2VVJFMytEZFd5bnc5YkdLYmNWV25ZY0J3czQ4MG1sTFR0U09RTU5n?=
 =?utf-8?B?ZDNoRFJHdGNYZEpjNGg5ZGh0K0JCMENGV0VVb1UvbU9kSkZNS3ZkRUVJWUgr?=
 =?utf-8?B?SFpDb1M1QktjSEgvL2g3VEpOQnMzK09nRUpFL0lLMTBHSlp0dkRJRjVDZXhr?=
 =?utf-8?B?RXR0NnFVa0hwZkIrMzgybEtXMnBtdEc4enM0MVZ6R0ROVUpONmVxZmV6WHhi?=
 =?utf-8?B?L2ZCMFhLeHRpWnV4UGdnNTBXYkMvQVE0Rk0vU1RleG5laUxJUlBZd0hMVVAw?=
 =?utf-8?B?YTlFTWhJZy9HU2h4WHdiZTZNZU14OTR6ODBmL2VaenN6YTIrUEJKUjlTdHNj?=
 =?utf-8?B?Z1ZCaUFOc2paUitFbHJEV1hyV0xlWWJwSExHYW5BYWdBcXg1Skx3ZTh3WEN1?=
 =?utf-8?B?UzhTVE03RSsranE4dFVkZG5hMGVnb3Q3NmVyNUwvbGVlMzVQT3JGQ0FydVc1?=
 =?utf-8?B?N3BtaDloWVdoaWorVDJ1UkhVR1FoaVlsVElFcVEzUVF4YWR0L1RCck1taS9w?=
 =?utf-8?B?L1JwQzVDUk5UM2RJTGNBMDlOM2daWncyR1lyMXZ6OXMxQjNibndxcW15L1Ix?=
 =?utf-8?B?QUk5T1JoUDN4OVpEM08ya21jQWI2Y0VNc0prMWo3V3oweU1qWmlKUjgvME8z?=
 =?utf-8?B?ODBVeHdKUVFYb2sxdkg4UEsraXZJVER2U2hvZXpNeUp0d2pqb1ZURGplaDhT?=
 =?utf-8?B?UjRTK0pzeFlsbkFuc2R6VFAzWVg0alprTmIxekMzdU9Na0tBZDFiRHpmMHRh?=
 =?utf-8?B?bEhCZlYvZ05aaUJta0FLSmtCb1d3YjRRbGxSL3kwOEFDSVZ2cldLdGNPemwy?=
 =?utf-8?B?TzFnYkdvZG1ycUV2eFdldkxjd1ZxTDNTbTMwQlpweE1lOFM3RjNaQlpIZzdZ?=
 =?utf-8?B?eElyWC9teTI0TkMrRzlWUk9DOGZKNlpqbld5N0ZIVDNnUGFCODdzUmJ3cHhv?=
 =?utf-8?B?OHpNNmNwc2lsNTgzN3owakY1bVZDaHhRcmlBMWR4M21nWENxRHJuYzJWVWRs?=
 =?utf-8?B?V3lvVnMveVpDbk5uZTBINHRJS0Fja3BBTnM3WXkyRWtBRk1CSUY4Q052cjBC?=
 =?utf-8?B?MFBRSGZzdWM0dVNvTm56MFY1L0x3ak9IQk9MYnI3WlFWYWd6VjFVcUVEc3ZT?=
 =?utf-8?B?YzJGWEFvZSthU3NYaTUza2VybjV2Q2EwMFE5V2lMcUh2OHRCOWdNdUlOK2pW?=
 =?utf-8?B?SmhvMC82MmJ5VXJLNVRLWkZ2enNXOE9CUW56NUo5OFJ1WnUwNGVFVXRFVWt6?=
 =?utf-8?B?S1FmbCtpcUwwK005a3VsRTZJWGlpeERONkxoYTZzVGhvTVROdTdhb2dsbnlS?=
 =?utf-8?B?ZU1PcE5mdHd2SDRUYUpSaWVvMnlTNmJXRElhMGpoRGQ3QnNhMUQwZG1EVXhK?=
 =?utf-8?B?dVJTMWlncU9ubkNzdklSNnhFS1BnOHdWaE40bVFxU0NjOG1EbVNaaDQzL0Rt?=
 =?utf-8?B?c2RPRE4yL21aZDRPR01La3I1Tk5WelF2VzZxSFJtbi9IQ1RUUHdoNFB4NFpV?=
 =?utf-8?B?cXVaRndwSTJkTGo3SkN3ak04K1NtQ29EMzM2WVgyK1dXOHdBdHJqWXNzdHow?=
 =?utf-8?B?KzdrdVovak5iZHVZZisvSGVIVU13UU9xc0J6SWpQVkwrbDZjS2tEWklmWU8y?=
 =?utf-8?B?Y2pWS1JVMEZ3Q2dpeUZIN2dNREFCbGtjQ2NtdVZwZWJnOXFpQmgwTnljK1Av?=
 =?utf-8?B?NkN1QS9pYTAvb1IyUldPa0dHUXl3eE1YQlB3MGtkdlZ4MXBSK21qM2dQR1ox?=
 =?utf-8?B?OUlzS2pTRGxVcDNXczRieFdFRVRBS0NJcjZXYm1yS1ZuWVZySW8zUjhLMHEr?=
 =?utf-8?B?ckRqZGNORHBkTVM0OG9pNDVsN2ZIWkt6azl2Zkl6eVlBdFE3UngyTHQxSG1M?=
 =?utf-8?Q?g0pyQNSzdCo7UwR0Dd6dcQcsU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fb34a4d-855a-4207-2f95-08dd2ec756c6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 02:59:44.9053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YW2reseGL4HwgkWVokrOfnZeejjUvpLtmg9lJTLG7wSxNk9uIT1Re6NIzW0cDOTduET2L+eB9bJeGitx5IWNNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6271

On 4/1/25 04:00, Tom Lendacky wrote:
> On 12/27/24 03:07, Alexey Kardashevskiy wrote:
>> On 17/12/24 10:58, Ashish Kalra wrote:
>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>
>>> When SEV-SNP is enabled the TMR needs to be 2MB aligned and 2MB sized,
>>> ensure that TMR size is reset back to default when SNP is shutdown as
>>> SNP initialization and shutdown as part of some SNP ioctls may leave
>>> TMR size modified and cause subsequent SEV only initialization to fail.
>>>
>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>> ---
>>>    drivers/crypto/ccp/sev-dev.c | 3 +++
>>>    1 file changed, 3 insertions(+)
>>>
>>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>>> index 0ec2e8191583..9632a9a5c92e 100644
>>> --- a/drivers/crypto/ccp/sev-dev.c
>>> +++ b/drivers/crypto/ccp/sev-dev.c
>>> @@ -1751,6 +1751,9 @@ static int __sev_snp_shutdown_locked(int *error,
>>> bool panic)
>>>        sev->snp_initialized = false;
>>>        dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
>>>    +    /* Reset TMR size back to default */
>>> +    sev_es_tmr_size = SEV_TMR_SIZE;
>>
>>
>> It is declared as:
>>
>> static size_t sev_es_tmr_size = SEV_TMR_SIZE;
>>
>> and then re-assigned again in __sev_snp_init_locked() to the same value of
>> SNP_TMR_SIZE. When can sev_es_tmr_size become something else than
>> SEV_TMR_SIZE? I did grep 10b2c8a67c4b (kvm/next) and 85ef1ac03941
>> (AMDESE/snp-host-latest) but could not find it. Stale code may be? Thanks,
> 
> When SNP has not been initialized using SNP_INIT(_EX), the TMR size must
> be 1MB in size (SEV_TMR_SIZE), but when SNP_INIT_(EX) has been executed,
> the TMR must be 2MB (SNP_TMR_SIZE) in size. This series is working towards

ah my bad, it is SEV_ vs SNP_, I am sort of used to SEV_ vs SEV_SNP_ and 
missed the distinction. sorry for the noise. Thanks,


> removing the initialization of SNP and/or SEV from the CCP initialization
> and moving it to KVM, which means that we can have SNP init'd, then
> shutdown and then SEV init'd. In this case, the TMR size must be the
> SEV_TMR_SIZE value, so it is being reset after an SNP shutdown.
> 
> Thanks,
> Tom
> 
>>
>>
>>> +
>>>        return ret;
>>>    }
>>>    
>>

-- 
Alexey


