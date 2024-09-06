Return-Path: <kvm+bounces-26025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C4A3096FBAA
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 20:59:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 509CC1F2B747
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 18:59:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 169F91D1732;
	Fri,  6 Sep 2024 18:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="G+cuLWDu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2068.outbound.protection.outlook.com [40.107.244.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E5E13D2B8;
	Fri,  6 Sep 2024 18:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725649123; cv=fail; b=gfh464C65tXZcAOj8uYg9WzwDXUI4/xBFrKbdkWJp24YF1+oWXdVKkoFs3nnKGduqQKHFQD1oFBJlZIxQCtxWpwFXHpWODZ36gLEiJ3JY+oX4Y1kv+aLuJbwolmWUt2cJiKYLuoYUNtz+Lq0Z79jPgcqMOhoxV1mGqgiWPcba5E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725649123; c=relaxed/simple;
	bh=SdZAnNIwYPbGj7rMtiS7IZayNQc9tCD0XAqetdzoQPs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dLhD5KOpHR+ChGJoNlmpB9aFaUibD/agP7oOvQ1xOc9ML62ONstfXWwGWjeq2Np42DC8t7U2ok8m8hHgx+ZdZydCBcHi5ks96BfoIq7nVrlPOchYVIZ+gsc99tjHtxaHiQuEaTP20rwJednx3VVEJ+Ut4IUg5seY+Lgr/EXkR6M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=G+cuLWDu; arc=fail smtp.client-ip=40.107.244.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UxISUllzlr6LTUpcOWU6cHGNz+Ftg4VchDHc4v1Dni08pE8LHA3ERMi4B4BMqkrS8wX8p3uBeF+9Z8I8a/XQtDCZBsuQym11kaWr0uaMMZwT0lWljaABdtG/MrJuVLvrRXVVaTx2/wGnUiBn+u8k0mcdCJozJG7u74xaJifKrQIIvCQ1oDaaJGYrzKXcuMtB5+yhpHIddmgLsaYKat9LYoPyJ7OBSLtZs0PSCqPjMTyKV7IlCfSq/HCTMc18FUBqVZYpbaMWdzBaNg78aSsXR9gxT+N0ui6Y7f61L3ih1fvyZtxzoTB/y8Zp49GONTFXpwWiJzynqQXc8a9crAU0Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=plWktybNHgWPOQxiFBrYkaX9MYfFJUa8ZJDpOyBX7ns=;
 b=n/gJ1bCt5AvGRejJi4rcLwfvcGUtFiEvCTRtwUSLVTGGbF7+Puq0yHydK43W7WwD4kuXT5f/pvF+iLPhABS7EHaioPX/dR8e8b7OFphMRHTy3W5t8XNvJyJ4PR03qi4wL9xTOcnN/+kPCSb6D4IOw5dOMw/DX9gBI2xHId9ZPh0MuSBdqmnBOZKPgogY5U5tDpOmIaLRM78oiDbh1bXt+mXvBoP6IciNhdnxecWzoY7LZKzl9WmbHvLV4L1boRRpElE8jySwN11sAmsQP3J3+rfvbdg7OqMSVN9VNLCX1kv47TgM7TKsU8mOkFhZD1BVwRlIbrvahjAf5wFugcSE3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=plWktybNHgWPOQxiFBrYkaX9MYfFJUa8ZJDpOyBX7ns=;
 b=G+cuLWDuJUaHRb5XFrGhHCablkIzXep5m94eBKVdK/JTzoxQHIUKhKQ5DPvSNawxqy5rzmZparf5m0rdC6wkuvWGB2aIv2jam2IAAuKYCvKiqFMgSTi9xbkia4JEMTD2mGI6nPun1iBhlpnynYM7p0gup3xn+zi5Yks+zMP+VBGSvSS6bWUU6jdBADCaIian8ifOxXexUDc/PHGxw6/4jIbu8OZfluG8puZtcmcmkg3dBbRgLnwT7LO0jOyFLC4MjvqT1iqyVQt5NhzlahQqaAzpCHB3QPaTR5+CWYC0P5UnPKnkTc2qipoOY24hZDWsjmsNgyX47KOtiK9Suv866Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY8PR12MB8194.namprd12.prod.outlook.com (2603:10b6:930:76::5)
 by SJ2PR12MB8061.namprd12.prod.outlook.com (2603:10b6:a03:4cb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.17; Fri, 6 Sep
 2024 18:58:35 +0000
Received: from CY8PR12MB8194.namprd12.prod.outlook.com
 ([fe80::82b9:9338:947f:fc9]) by CY8PR12MB8194.namprd12.prod.outlook.com
 ([fe80::82b9:9338:947f:fc9%6]) with mapi id 15.20.7918.024; Fri, 6 Sep 2024
 18:58:35 +0000
Message-ID: <c3b0424d-8f04-4d16-a56d-e22784d2ed4d@nvidia.com>
Date: Fri, 6 Sep 2024 13:58:31 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/19] arm64: Detect if in a realm and set RIPAS RAM
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Alper Gun <alpergun@google.com>,
 Vikram Sethi <vsethi@nvidia.com>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-6-steven.price@arm.com>
Content-Language: en-US
From: Shanker Donthineni <sdonthineni@nvidia.com>
In-Reply-To: <20240819131924.372366-6-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0005.namprd02.prod.outlook.com
 (2603:10b6:207:3c::18) To CY8PR12MB8194.namprd12.prod.outlook.com
 (2603:10b6:930:76::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB8194:EE_|SJ2PR12MB8061:EE_
X-MS-Office365-Filtering-Correlation-Id: 10facb15-81c4-4a98-c419-08dccea5e8ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V3V3MituNXRYUmZLR3dER0MvKzdYdTVCbGJzcFpmQy8xODRiV0tGU2QyaGRG?=
 =?utf-8?B?SWgyNHhSbTIrU3VHZ2JXaWNQL2srdUhkOVErTlc4WnV2MnZ5QTIwNnlLZ1ow?=
 =?utf-8?B?MDcvMnczTzlROHA2Ty9NQnhzT2lEemlIS0diOWdhcEFvbEs0RjFFWWFYWUZE?=
 =?utf-8?B?ek9tbWNmWHRwWVY2c2RrV1pQdmRkZlpXVUd0cUMydW5jRnBHNTUwSi85Tlpy?=
 =?utf-8?B?Y01FUlp4ZGJlamxrOTI4QWVpMmRVV0NkZUFwZEJyK1BUTkdPRDJIL1lGRUgv?=
 =?utf-8?B?RDBBbVhSTUF5dktpY25HVzFqL2g3d0JiRExZSjJEb0UzclZKdU51ZlR6YWJ6?=
 =?utf-8?B?TndyWW14UHFoYTBmRFJ4YTVWVkhFTXYxZ2M2SGZYNVNXRWYrUkx0UllPYkU2?=
 =?utf-8?B?aCtLYUpCZjNRTnVYTkxJQ0Jlb1ppckZlbk1ieUI3WHR4Rk4ybDZPTDhwQUVj?=
 =?utf-8?B?ZDMzcllyczBDR01GYTR3M3EvRnhZWC80WHRLYVZwayt0cnp3T0N6TVRLMVBm?=
 =?utf-8?B?S2dCQVFhejErSENYMiszc1pEdldKaVFKUXZWWTZtMnZVWjdyc3JLVjhaTThR?=
 =?utf-8?B?ZzFWR2V3UVJ5dUtuVkN4cHBCbUJoUUdrc042MEhVUHg0c3p1cnBKSlFmV3Vk?=
 =?utf-8?B?TUZ3elBZazhjNXBJTU1aVTNsQUVIdS9rTGYzeVVzZm92d1phQzlaWml6V09k?=
 =?utf-8?B?K1R2WHYrT2N4aXE5bjMvK0x6YVBnREF2RWl1NUoxZktnR1VTdE9lMmRlRFpN?=
 =?utf-8?B?Umw3VisvMFRwZzNWWk5KV01NTTJQZ2hmbExNakpWS0ZvWXhIYUVSbHVQb0U1?=
 =?utf-8?B?aGJsbmhGczd3eTVJZEpBcFBEYWd4T3RzOVUvbTBFSVQ3d2hLQnQ5aFVKWXRu?=
 =?utf-8?B?ZnZSNkIwYkxNUFJ0NjdrMEhyZTJCVUJxL3FRSTF6S0lPK2tFZW5jWXNZa054?=
 =?utf-8?B?TTdiWHM1eFlNV0paVGFkQU9ZVnBTRVNJZUMwZGJTelV0ZnI2KzJnWU0rN1hC?=
 =?utf-8?B?VDB3M1NaazN3Z0FWSzJBMCtFREF0cnloSkJqZm9OanhCekVNTzdmNXpSbGRj?=
 =?utf-8?B?Tk9aYzBaTkdFMFNCQnlXKy9zUURVTUE1R3hwWVRiUHJ1Qm14M3l0VitJcmxl?=
 =?utf-8?B?emtRVk56U2NYWmsxby9JNWpJRjcrd2doZ0VvdnJXZjhwLzl5dm94aWZmRHps?=
 =?utf-8?B?YXFMRHVYeVVzWmFBdDN5b3pIWDJpYWRoNTVaTC94a00wbkYxTlM4MW9ZNGhP?=
 =?utf-8?B?TUZRdE9FNlcrdXBVb0g0VksxL212ZUd3am1RUDhQdndsbEhXcFZlbjJoZGtJ?=
 =?utf-8?B?M3gyYW5MVGRta2Mwd29Vd01KRjhnVlhINmVNMEZkaHYzanlha1l3Sm5DcGsr?=
 =?utf-8?B?SFBHeTBZWFViNGZDeXRza3FXOFFzNzhvK25pRm5QYnV2d0o2cmNMVVA5dkJS?=
 =?utf-8?B?SVFLOHNpQ0JvL1ZpTlZoZHJ2SzBBQklTc3czTkRGU2NWc1hJTjlFc0k4dytN?=
 =?utf-8?B?bVFtZ1VVNXc3MjNza0FPV0toVG16dDUyM1ZCcVJiWE9NR1NhaDJlSUJYUzVI?=
 =?utf-8?B?QVcyc0NuZnkyWlFnbTY5Sm9DeXBDUzh2UXFudnU1am5BeHh1ZnNlVDdxQlA2?=
 =?utf-8?B?NmtMZVVCcEw5TnArRGpuTDhQYVhqZFcrKzl3c0VjdE80anM4NXcrci9sdW44?=
 =?utf-8?B?Z3NsaVZHKzVDdzRya3JUb1MwWVl3R0N0am0xSHBDTEdiZkNNaldiU3lEako2?=
 =?utf-8?B?SkFQaDQrY3V2REgrdGtIcHlha0VNRWlkdlk4c1ZtQi9icVQ4YWNmOEdFV0xT?=
 =?utf-8?B?MUU2QWhhRXg2TTd3VnNoQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB8194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UzBqZ2FKNWNSbEY3Q3JORHJsYnVIZXg0OVJXUVhyQm5kVlhLUXJvckwrdFQ4?=
 =?utf-8?B?WG15V3R0TGk0N1g2Rk81WkN0L1N1SENHRFZpSDNuU0d3bTBESmVldERMRkJz?=
 =?utf-8?B?eHV4ZTV3bXBKN3ZFVWV4Y0lGVDRDc3VnVEw3dWliWVV0UEVrblpkbEhLaXZq?=
 =?utf-8?B?SnIyTmkvUW1aVmtLK1hUeE9MSm5mSkYwZjFGYUlSY1ExSSs4dlQvekFDcDZw?=
 =?utf-8?B?S08rWnJSRS85NDhQT2dZbWNFYk8xNTRKTlUxWUlQSmhiRkRHaFE0Z0pNcjVn?=
 =?utf-8?B?cHhZVjJyaWIzVHpwd0lKMXA4b0pTL3Q3NHY1czVyNzRCcWFhTGM2Z0JtNEd0?=
 =?utf-8?B?ekRWQW1xeUppMGdHdHM3TU1LWitIeFA3cSthdExIY29HK1pwV05NYXhoVVFT?=
 =?utf-8?B?S29MSmdzZW1TRGZaTUZuaUFURU14ZkVKNWd4MTJZVys3Z3Vqbm5wK08wOXRi?=
 =?utf-8?B?RE5sY1o2Mk9hTkZvSnY0VDRzd0dQaG1VTkpWbTlHYW1FZFZ3aEgxR2VVT0Fp?=
 =?utf-8?B?NkdkNnh0VXhnRXdqQUhRbUcxSzBjZWtwYjZIRkdKQmxyeGY3dDgxQU5BdExj?=
 =?utf-8?B?b2ppR3FnY0lvdWdFbktEVXd1VGQ2MTM4dm5KOGRSVG95clNWYkw3WVI5dlls?=
 =?utf-8?B?L1lWZGF0V3Uvd2UyeERiN012T0U0T2xJNEhqU2FXaStTS21qYjlTS0ZJYWph?=
 =?utf-8?B?eGJxNTI2RHp4bjZ4bzluVGJmMzZuVnpSUUo4TngyQk1ueWZNT0hEQldSdnJi?=
 =?utf-8?B?RVFaMThHMmV6aFFhWWdtaEtxYUdzRjQwZFZHbnBJY0ZhS0pYVEwxdXMraG9V?=
 =?utf-8?B?RmoyaElNUGhoVGpwdW8rUXJzZkxQenZCZFRiaVI0bC9pVXdzeVZna2xUNkJt?=
 =?utf-8?B?ZGhNelF2bzQyQkJMMU5DR2hSWWhsbHUwUGVnN1U2aTFvZlVXaWFxMVNjZjVZ?=
 =?utf-8?B?K2U0Sy9OVURUZkZGalZ6YzdiYVpWUFo2cGJwektoRGxiY0FRM3ZneHJrKy9T?=
 =?utf-8?B?OXVrZE5sZFJzVUNNelVJOXhCTnBoUHQ5NzFRY2l1ZFBBQ2pMK2twMlNFY3ow?=
 =?utf-8?B?VzY2QytEaFJZNktHZy9jRWoweHhjb0FuTTNqbytQNVlCTlhMYVdvTm9wU1RM?=
 =?utf-8?B?bU9DZzB5M2I3UlVaeDBYdHlZZFg3b2x1TUVINVZXUW5aMEFIZmlDM2dSd255?=
 =?utf-8?B?TGQzZHkxU1h2K1BIanFTUjEyTGVqWjhCeXJWUStkMkxiVkQrWW54b2NvWCts?=
 =?utf-8?B?Nks5T3FUN2h3TldlUVM0ekVaTWliQlRLMHgwZkJQNmlCWkludWdXdXhPQ3B2?=
 =?utf-8?B?NWJrV2c3T3I4dUd3ZFY3bFdSOEVia0oxL0tRUVArSmZXT20vSGtjbkdEN3ND?=
 =?utf-8?B?NVRmY0tCTjArWnNEaWtEOHhqR2FENWtmS3UxUVNkUzNOS3pPam41SEZPTEZj?=
 =?utf-8?B?QlprQ0srd0d3TlJEcFlzYy9zeVhtdHhOMTMrUkIzc2hXd3RRUzNITGZMUHN2?=
 =?utf-8?B?RnI3UWpQNHlGb2prZGFyeVh5RnVWR1FwbHV6T3RxMm5sSTF0blF6WVl5ckIv?=
 =?utf-8?B?ZmtBU1JmcHNleHhXQ05VYzdjYXNpVkR3cHdLVForam5jak0wNjMrOCtZOGRH?=
 =?utf-8?B?clRLMkNiRnQ1bGJ2MVV0c2tROGRaV2Q4bVpTdC8xZWtOcFNZZFA4Y3hxV3BC?=
 =?utf-8?B?dXpXUWVjZm4vazhKSFVYWHVNMG9JaWZvTmRBODJzV21QZ1pVak05WEVGZ3px?=
 =?utf-8?B?dmJDUUFmaE5GOWxQZWdjdHpoSDRpejlPUWxIYWhJNC9ENlRWTk83SlRnNVdn?=
 =?utf-8?B?cjgyYVZzL2gvZklMeFZ4WS9ZTkRyTlhvSmVQK3BYRUdqbk5xaFJEdy9yUUF2?=
 =?utf-8?B?S2Y2U0plelN6OGxCMnU0RDh3TnhYcW51NE9nZzM3L1lVTTZueW1ibXphZXFy?=
 =?utf-8?B?eDc0b2UxcTN3Q0FWa2dGRFZSaEtuMUFWZTEyOEVDaUFTaWtGdXJCVWc3ZWg1?=
 =?utf-8?B?dmR5bysvUTBPVjFzNW4yY1BGOW96aHlRd2VjWm1sOElMbXZ5SFRjcDBhbFA5?=
 =?utf-8?B?a3dmWlhjWndQTmppT01xYzZPeEZHN3dpWW5UbDJUdU94TVlVWGZlUE8rWTJZ?=
 =?utf-8?Q?mWvmkpZGhckwquHSLjZZ37aBX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10facb15-81c4-4a98-c419-08dccea5e8ec
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB8194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 18:58:35.4316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YqdVJjCDGBjROKuXJ7aXvWdznrEfeslHSdpmbZy0pfZaaunfi8BHSFI9aPD/75kqsAIscumEX9PSPqXCQojP0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8061

Hi Steven,

On 8/19/24 08:19, Steven Price wrote:
> External email: Use caution opening links or attachments
> 
> 
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Detect that the VM is a realm guest by the presence of the RSI
> interface.
> 
> If in a realm then all memory needs to be marked as RIPAS RAM initially,
> the loader may or may not have done this for us. To be sure iterate over
> all RAM and mark it as such. Any failure is fatal as that implies the
> RAM regions passed to Linux are incorrect - which would mean failing
> later when attempting to access non-existent RAM.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Co-developed-by: Steven Price <steven.price@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v4:
>   * Minor tidy ups.
> Changes since v3:
>   * Provide safe/unsafe versions for converting memory to protected,
>     using the safer version only for the early boot.
>   * Use the new psci_early_test_conduit() function to avoid calling an
>     SMC if EL3 is not present (or not configured to handle an SMC).
> Changes since v2:
>   * Use DECLARE_STATIC_KEY_FALSE rather than "extern struct
>     static_key_false".
>   * Rename set_memory_range() to rsi_set_memory_range().
>   * Downgrade some BUG()s to WARN()s and handle the condition by
>     propagating up the stack. Comment the remaining case that ends in a
>     BUG() to explain why.
>   * Rely on the return from rsi_request_version() rather than checking
>     the version the RMM claims to support.
>   * Rename the generic sounding arm64_setup_memory() to
>     arm64_rsi_setup_memory() and move the call site to setup_arch().
> ---
>   arch/arm64/include/asm/rsi.h | 65 ++++++++++++++++++++++++++++++
>   arch/arm64/kernel/Makefile   |  3 +-
>   arch/arm64/kernel/rsi.c      | 78 ++++++++++++++++++++++++++++++++++++
>   arch/arm64/kernel/setup.c    |  8 ++++
>   4 files changed, 153 insertions(+), 1 deletion(-)
>   create mode 100644 arch/arm64/include/asm/rsi.h
>   create mode 100644 arch/arm64/kernel/rsi.c
> 
> diff --git a/arch/arm64/include/asm/rsi.h b/arch/arm64/include/asm/rsi.h
> new file mode 100644
> index 000000000000..2bc013badbc3
> --- /dev/null
> +++ b/arch/arm64/include/asm/rsi.h
> @@ -0,0 +1,65 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (C) 2024 ARM Ltd.
> + */
> +
> +#ifndef __ASM_RSI_H_
> +#define __ASM_RSI_H_
> +
> +#include <linux/jump_label.h>
> +#include <asm/rsi_cmds.h>
> +
> +DECLARE_STATIC_KEY_FALSE(rsi_present);
> +
> +void __init arm64_rsi_init(void);
> +void __init arm64_rsi_setup_memory(void);
> +static inline bool is_realm_world(void)
> +{
> +       return static_branch_unlikely(&rsi_present);
> +}
> +
> +static inline int rsi_set_memory_range(phys_addr_t start, phys_addr_t end,
> +                                      enum ripas state, unsigned long flags)
> +{
> +       unsigned long ret;
> +       phys_addr_t top;
> +
> +       while (start != end) {
> +               ret = rsi_set_addr_range_state(start, end, state, flags, &top);
> +               if (WARN_ON(ret || top < start || top > end))
> +                       return -EINVAL;
> +               start = top;
> +       }
> +
> +       return 0;
> +}
> +
> +/*
> + * Convert the specified range to RAM. Do not use this if you rely on the
> + * contents of a page that may already be in RAM state.
> + */
> +static inline int rsi_set_memory_range_protected(phys_addr_t start,
> +                                                phys_addr_t end)
> +{
> +       return rsi_set_memory_range(start, end, RSI_RIPAS_RAM,
> +                                   RSI_CHANGE_DESTROYED);
> +}
> +
> +/*
> + * Convert the specified range to RAM. Do not convert any pages that may have
> + * been DESTROYED, without our permission.
> + */
> +static inline int rsi_set_memory_range_protected_safe(phys_addr_t start,
> +                                                     phys_addr_t end)
> +{
> +       return rsi_set_memory_range(start, end, RSI_RIPAS_RAM,
> +                                   RSI_NO_CHANGE_DESTROYED);
> +}
> +
> +static inline int rsi_set_memory_range_shared(phys_addr_t start,
> +                                             phys_addr_t end)
> +{
> +       return rsi_set_memory_range(start, end, RSI_RIPAS_EMPTY,
> +                                   RSI_NO_CHANGE_DESTROYED);
> +}
> +#endif /* __ASM_RSI_H_ */
> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> index 2b112f3b7510..71c29a2a2f19 100644
> --- a/arch/arm64/kernel/Makefile
> +++ b/arch/arm64/kernel/Makefile
> @@ -33,7 +33,8 @@ obj-y                 := debug-monitors.o entry.o irq.o fpsimd.o              \
>                             return_address.o cpuinfo.o cpu_errata.o              \
>                             cpufeature.o alternative.o cacheinfo.o               \
>                             smp.o smp_spin_table.o topology.o smccc-call.o       \
> -                          syscall.o proton-pack.o idle.o patching.o pi/
> +                          syscall.o proton-pack.o idle.o patching.o pi/        \
> +                          rsi.o
> 
>   obj-$(CONFIG_COMPAT)                   += sys32.o signal32.o                   \
>                                             sys_compat.o
> diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
> new file mode 100644
> index 000000000000..128a9a05a96b
> --- /dev/null
> +++ b/arch/arm64/kernel/rsi.c
> @@ -0,0 +1,78 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2023 ARM Ltd.
> + */
> +
> +#include <linux/jump_label.h>
> +#include <linux/memblock.h>
> +#include <linux/psci.h>
> +#include <asm/rsi.h>
> +
> +DEFINE_STATIC_KEY_FALSE_RO(rsi_present);
> +EXPORT_SYMBOL(rsi_present);
> +
> +static bool rsi_version_matches(void)
> +{
> +       unsigned long ver_lower, ver_higher;
> +       unsigned long ret = rsi_request_version(RSI_ABI_VERSION,
> +                                               &ver_lower,
> +                                               &ver_higher);
> +
> +       if (ret == SMCCC_RET_NOT_SUPPORTED)
> +               return false;
> +
> +       if (ret != RSI_SUCCESS) {
> +               pr_err("RME: RMM doesn't support RSI version %lu.%lu. Supported range: %lu.%lu-%lu.%lu\n",
> +                      RSI_ABI_VERSION_MAJOR, RSI_ABI_VERSION_MINOR,
> +                      RSI_ABI_VERSION_GET_MAJOR(ver_lower),
> +                      RSI_ABI_VERSION_GET_MINOR(ver_lower),
> +                      RSI_ABI_VERSION_GET_MAJOR(ver_higher),
> +                      RSI_ABI_VERSION_GET_MINOR(ver_higher));
> +               return false;
> +       }
> +
> +       pr_info("RME: Using RSI version %lu.%lu\n",
> +               RSI_ABI_VERSION_GET_MAJOR(ver_lower),
> +               RSI_ABI_VERSION_GET_MINOR(ver_lower));
> +
> +       return true;
> +}
> +
> +void __init arm64_rsi_setup_memory(void)
> +{
> +       u64 i;
> +       phys_addr_t start, end;
> +
> +       if (!is_realm_world())
> +               return;
> +
> +       /*
> +        * Iterate over the available memory ranges and convert the state to
> +        * protected memory. We should take extra care to ensure that we DO NOT
> +        * permit any "DESTROYED" pages to be converted to "RAM".
> +        *
> +        * BUG_ON is used because if the attempt to switch the memory to
> +        * protected has failed here, then future accesses to the memory are
> +        * simply going to be reflected as a SEA (Synchronous External Abort)
> +        * which we can't handle.  Bailing out early prevents the guest limping
> +        * on and dying later.
> +        */
> +       for_each_mem_range(i, &start, &end) {
> +               BUG_ON(rsi_set_memory_range_protected_safe(start, end));
> +       }
> +}
> +
> +void __init arm64_rsi_init(void)
> +{
> +       /*
> +        * If PSCI isn't using SMC, RMM isn't present. Don't try to execute an
> +        * SMC as it could be UNDEFINED.
> +        */
> +       if (!psci_early_test_conduit(SMCCC_CONDUIT_SMC))
> +               return;
For ACPI-based kernel boot flow, control never reaches this point because the above
function does not check the PSCI conduit method when the kernel is booted via UEFI.

As a result, the boot process fails when using ACPI. It works fine with DTB based
boot.

> +       if (!rsi_version_matches())
> +               return;
> +
> +       static_branch_enable(&rsi_present);
> +}
> +
> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
> index a096e2451044..143f87615af0 100644
> --- a/arch/arm64/kernel/setup.c
> +++ b/arch/arm64/kernel/setup.c
> @@ -43,6 +43,7 @@
>   #include <asm/cpu_ops.h>
>   #include <asm/kasan.h>
>   #include <asm/numa.h>
> +#include <asm/rsi.h>
>   #include <asm/scs.h>
>   #include <asm/sections.h>
>   #include <asm/setup.h>
> @@ -293,6 +294,11 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
>           * cpufeature code and early parameters.
>           */
>          jump_label_init();
> +       /*
> +        * Init RSI before early param so that "earlycon" console uses the
> +        * shared alias when in a realm
> +        */
> +       arm64_rsi_init();
>          parse_early_param();
> 
>          dynamic_scs_init();
> @@ -328,6 +334,8 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
> 
>          arm64_memblock_init();
> 
> +       arm64_rsi_setup_memory();
> +
>          paging_init();
> 
>          acpi_table_upgrade();
> --
> 2.34.1
> 

