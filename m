Return-Path: <kvm+bounces-36468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B28FCA1B027
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 06:57:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EFFA61676DF
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 05:57:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 041271D88D0;
	Fri, 24 Jan 2025 05:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QJx1qRdP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2046.outbound.protection.outlook.com [40.107.223.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C66258A
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 05:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737698226; cv=fail; b=q+6ZhQIhwub39/C7yqTZV6AJYRAVdQgQrxk+EBIrySZ71/YZUBXwYjxUodjnaCTuGSHWs1zLXtQ9UbByeNFp0IFnsw1wGMA6Y/GYcQDwz9RzBiBcml1M+NAuFfsdiKhP4d+HkK0JlAAXErtJnlZiW1oB6AUmoBHgZ3liNTeSJDE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737698226; c=relaxed/simple;
	bh=B2m+gnrkVVDZFWarCi00ei/2XRJ9M2HE1Vib7xPD8MY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YDwdbj+hzY2ZyYYs1D/CL4vX5Q9dPI/8FdlKisNbvsk0N5JvAlxAodxIVyZw6Ogjid43lXLewknP+UxdgpQnNp1wy/PMwFSGVQX4VI3EeuKbvEZ5Y3YRDzCeg96vblrBPqp/h5Tr+qnL0+8q7hRyLU9FADWsov7PutQUtrSP5k4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QJx1qRdP; arc=fail smtp.client-ip=40.107.223.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OFAWh0QTWqXO+YsWG7HC9atQHF3mKMev0M9A+FXsucUI5ElcSK8wBtxmdf0EbJ995Y5X6V9hWXpdML1aM64ljmdnjlLvv9xe7lXOxRA7oht3WHn59W7Do08UtfxvL5WuOeoyE6zXb3++F437PBB7JlhGVFwVTuVwhERB6uV9f59JCX7t/ZdrK/TnjgOpBY/TJEa5jyo1txCzMykEh//1tgHITqlBUbEPmgSXc5ycyqtljsOVFAS29qHwNyJlDpsJPqQuDsMG5bgPs8dRXjrlYOtgTk0t7kg4XCnGgWjw8HQ4E8fQHZw7eLykuEer5wmXTTvCTcvIXcntQHbDsfpemw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fVrDHKvihb4QEuw4fbmYt4YQKwl+598z1pCpBsaVUno=;
 b=YHrKKWtxnw5JCjxV+ITTuSAagA+HGaAhfNqkLLiVGBy9VeO/zoq7DfmUGyv4ucG4L1OKZXLuPFAdEWYEGv0jpVJTAkhq7ZCOx2BJ5gdxzfQ7VgyovD1JTgqBEZCtie6I5S1qrsuZw3B2gJUIhGGxBnRZCoQipuPt8cB4qMhBOfY9JP8QNdEPBGl9RtjMBowVgZTb1N2LxKUI4cfL7e4Lwm9ocoLBYPNZLBZPekhwaBrRLfBb8pFBlrlSe/MAHZ7pwD0ng7wsnBwwTLQfHYRrlGUM3ssfxh8qIe1Ca9F+AZb7AD+GzOT+xLmLfBGs5sJndd5jt8fmkdinXUspSw9pIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fVrDHKvihb4QEuw4fbmYt4YQKwl+598z1pCpBsaVUno=;
 b=QJx1qRdPq78AyTMNFUoH+QsYFfwpdJXk7z12GWX2gz479RgQcp81TZGSUV2Xeaff9RxUsvFID7AmPswGZStn0NNaLT0ybKr9DF7TUM8q3OKoCq9fWLcs8yhf/Q4zCkzLUhoyu8xAqTnpzm5A9e8+937+BkAYVrh4QMSxjirSiuc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by CH3PR12MB9393.namprd12.prod.outlook.com (2603:10b6:610:1c5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Fri, 24 Jan
 2025 05:57:01 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8356.020; Fri, 24 Jan 2025
 05:57:01 +0000
Message-ID: <2115c769-144c-4254-94b0-6b38b7afc6fc@amd.com>
Date: Fri, 24 Jan 2025 16:56:50 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
Content-Language: en-US
To: Chenyi Qiang <chenyi.qiang@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Michael Roth <michael.roth@amd.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-3-chenyi.qiang@intel.com>
 <d0b30448-5061-4e35-97ba-2d360d77f150@amd.com>
 <80ac1338-a116-48f5-9874-72d42b5b65b4@intel.com>
 <9dfde186-e3af-40e3-b79f-ad4c71a4b911@redhat.com>
 <c1723a70-68d8-4211-85f1-d4538ef2d7f7@amd.com>
 <f3aaffe7-7045-4288-8675-349115a867ce@redhat.com> <Z46GIsAcXJTPQ8yN@x1n>
 <7e60d2d8-9ee9-4e97-8a45-bd35a3b7b2a2@redhat.com> <Z46W7Ltk-CWjmCEj@x1n>
 <8e144c26-b1f4-4156-b959-93dc19ab2984@intel.com> <Z4_MvGSq2B4zptGB@x1n>
 <c5148428-9ebe-4659-953c-6c9d0eea1051@intel.com>
 <9d4df308-2dfd-4fa0-a19b-ccbbce13a2fc@intel.com>
 <b11f240d-ff8c-4c83-9b33-5e556cde0bce@amd.com>
 <d54f6f53-3d11-477e-8849-cc3d28a201db@intel.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <d54f6f53-3d11-477e-8849-cc3d28a201db@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SY0PR01CA0010.ausprd01.prod.outlook.com
 (2603:10c6:10:1bb::14) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|CH3PR12MB9393:EE_
X-MS-Office365-Filtering-Correlation-Id: f52bda7a-c588-4f86-bab5-08dd3c3beb87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bkJKVWZXb1VVVWhiemZkd1FRQXlUanVNOGhrZ3V3dHdYS0RjeTlFUHBJcnRk?=
 =?utf-8?B?R0w5ZnpCeklYemlTbmlxd2hmSGc5YXFVWGVWTXdTVGZTR3JQNlRCOXdCRVRm?=
 =?utf-8?B?NHA2WEJ4cHdEcU04WHBlQ0VqbzJINENWdkJEc0NTcHFEVjdxU2w0cnNqSjgv?=
 =?utf-8?B?bVkwbkJMK3p2bi9FeUFiRnBRRjk2dlM1djdOWE5TeUNnMGNyQTZqUTRXUGpv?=
 =?utf-8?B?aGc1OUZlV3hzMzkvZlBGSk1nSUVqbFRxejFVV0hnc1poN2hNOUhsMllhcGhj?=
 =?utf-8?B?d280SFBOcjlpVzdlVng5UVlFQW03c0k0bCs2enVTcE5uRFRqSzFwTGlxWjdV?=
 =?utf-8?B?Rks5ejMyRmdIOVRPVlVyS3pUejlBZmdnWUVMTWFpalRhMS91NWIwNkhEbDA1?=
 =?utf-8?B?UnN0S0ZTM2tJNnREUHIvY2tBNk1NSGdKU3lTcC9pQWhFbFE0V1ROWFNjSS9M?=
 =?utf-8?B?bVNQT0pwc0tpMFpHRFUzSGRkb2VlNWI2VkU1aFhrZXJPaTFUY2VONURRUDlE?=
 =?utf-8?B?cjRCNHQ1MDlpSnRLcnFYamUrS29MZDVHcU9jNDkyWkxmWmNwWXhqQXVtRXly?=
 =?utf-8?B?RU0wSzM3MWF3cmhPYXJXdjZrbHVNZnBFcG1vQ1Y4UVN3b2l6Tm9iU1dJMU8y?=
 =?utf-8?B?OTNPQ2p4K0NMN2hXK0ErZ0M4WTBKNkJKZEdNclFWdFFOKzdCQ3dmbTFLQVhy?=
 =?utf-8?B?STBwTXBvekRhczc2WEt0ZVphUER4cUZMSkkyUGl0WkpTbGx5OEJ6VjZQZkpH?=
 =?utf-8?B?WXVueTZ1ZVhZNy8vOTVTcTJLNGxzbTJ4ZXV5bThpYVRnNEpLQjV4aWhyYkp6?=
 =?utf-8?B?RjJ2dHdUcmlDcEgreGUwUGdEbDEzcTJaN0xuZFB1Yy8vR2FOMzRRMDU4Rk5z?=
 =?utf-8?B?cGlOb04rK3hSaVpCUnEyT2Z5YzhUOWVHUHVxUkFLc2JVbDN3amwrOHpCUnEv?=
 =?utf-8?B?YmFpd2ZyT0ZYekQ2NTdFOU5NZVZQdGN6R3pJQndBcVZ4dlp2WTJNOHVSaTBY?=
 =?utf-8?B?N1FENU5tTEcrcStOaTZRSVR5NXhFTUlOT3A0dUgxaVVhZm05ZnhmZjB4N3Jq?=
 =?utf-8?B?aUd2Qlp5dm8yNnNuRkhKS09ncTdzUmpXQ1dOaFVvV1c2VTZ5WjZpMmRxMmJp?=
 =?utf-8?B?eU5ZYXpCRDhlUmN3ZE5vR3RBWUYrWGc0QlBpNmZmUzA4ajJIWkQ5a1VyalZt?=
 =?utf-8?B?MTQzejA2VUhXZnYxUmxNcFY4MG5ZWkh0WVdCaVlWeCtEZHkzZm04c0kvc0JF?=
 =?utf-8?B?QkpwQUw1cEFCTmFNK1BFWmkyS3NXYUxtMWpia3JmbHdKTkptUDlVWndnaCt4?=
 =?utf-8?B?dlZtemg2YnVJOHhCaG01N1lhemFZekJLL2RjK2ZMRlo0QnVjK2xYbUhBMTVl?=
 =?utf-8?B?NkhNTi9BR29RWkN0elZHeW9RSjBuSG9OeFJOR05Ob29TWUI2MDAzbEp3UHZF?=
 =?utf-8?B?VkUyRE9WbGNmT2tLK2hsazA5M1YveUdOTW5nL0ZKOWdGTzQ4ZW1iQ1lYbk9n?=
 =?utf-8?B?ZTRvb1h5ZE9LWTdvV1BuZVNRK0RXaEpCc2lGLytBUHdDSERMaWp3aCt5R0ZZ?=
 =?utf-8?B?UnhuU1o4ZVYxMXFUV3VxUUNDbDQyNWhRWk1LZWd6OU1YUEhBSURQS2liai9q?=
 =?utf-8?B?b2RwTGlBbzV5NDJMTm44bHBNdXppK3BkSGFZMCtaS21yZHdKQzNNNE9VZWxC?=
 =?utf-8?B?NXJQK08rK25WN3hQY01OYyt4YzZQbGIwWURGVGxuamFBQ1VmejlJS3VzUStS?=
 =?utf-8?B?K0ZUMXliZXRnSTl6U2pkZThtSmdybjZndzRqM0FrN3NDWlIrRTlJUmRvNHZQ?=
 =?utf-8?B?NDhJSVNzVXNNRVhsZlJjdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aXFHbmpjKzJvbG1FU3hBdjZHYVVmLzByeTI2eFh0ZndDYlJ1Q1U2M1k4M2V2?=
 =?utf-8?B?dmpnNTdhY1pOdisrRHdIZHNQcTZic2Z4UjNOR2RQVE9PdVI0V1FUTUU2aHgz?=
 =?utf-8?B?R1Z4dWpuMisweGplRzJMcWxvY3VmSXNCcnNwN1htK0dYaTdmSHJZMzlEb0hR?=
 =?utf-8?B?NTh1WXVibDE2NXhDNE9iaDFtY2U1R2NYTzBQTnhZWDFSbTVLeVJ1NUZueGU3?=
 =?utf-8?B?djk4MXZmTmtFa0dVMUlhNlkzNkwxblAzLzJINHNlM3lsd25oSFFUKytaNlpx?=
 =?utf-8?B?U0VrZU9McFVqVFQweG9qdnd2U0pIRWtFaDdtaHYxYTdQWkhsSS9rR2w3amY5?=
 =?utf-8?B?cmJTVHZQa1FmUmNMWmpsMHZnMStETEsydUY1UkZudCtzREx2L0lpVnYxQjBP?=
 =?utf-8?B?ZGx1Ry93R21kMXZiVG5scS9kdjFBVW5CZHJBOSsza1JKZzVndXhYVWtyaSs4?=
 =?utf-8?B?UWNkaEtMOE8wK3hHMm1UengzTGJnd1BZbVVZZ0czM0o1N0lLcVVkTkxzU0ha?=
 =?utf-8?B?bTQ4dU11UnVhR1g4cU1wMkN5VTNDTzhKdkNqTUdYTmgwRERNVlgzVmttckxG?=
 =?utf-8?B?cThBVDdZdTVMK0JLaDNJTGUzc2xKTVAzK2FhWDV0UC9QZTJQV01ab0ViZDJQ?=
 =?utf-8?B?Y0RGWCtTdWF6LytFSFI5Mnkza1BFSVVYc2J4eE4zVkk4MWx6YWJlL21HV3dR?=
 =?utf-8?B?TnVOejZJSTJwbFpCUTZ4ZDJWWExjL2ZRTjVJZ0FCWkpqZG9RcE1rNUVGUTB3?=
 =?utf-8?B?ZGd0UlIwNUc3VkpsRVVEMTY5S29EeHVRZnc1SHVPU0NvYmE5dXRYbkhYVDNP?=
 =?utf-8?B?aDRIc3pnaHJOK2lzRmVlbmVaMVZsY3gvaDhIMkNhUEo4RlR2dXJ5YTcvUGdP?=
 =?utf-8?B?YkR1U0FtY1krblF2aG8vampOSVU5a0ZDRi9ITEZhWGFMMENxUXFoTjNab3Jw?=
 =?utf-8?B?WW56dU5uNmpGMUtyQ3dSVllWaEtRWExGaEg4OG9sWi9YUzRDSy9rM3k0M0hX?=
 =?utf-8?B?MU53R3d2R0hKREp2dkovYnFuREN6U0VTVmJwb2E2b2k3VXhQSUNrZnduV3Fx?=
 =?utf-8?B?aTBmR3gwTzRRSHBIZ0daWEhuaGcwUEZZdTU4RUI4U2xGWnJMOG5RY0hrODVh?=
 =?utf-8?B?L2d5dHdxSk5GaHlrT0Zzb0JHdDRCT3IrQk41dlRENkYwK2MzWWpQNzMybDdM?=
 =?utf-8?B?QU5YTXhHbmt4N2VDdmgvbCtOczRpL2c5ZEVRc2c3MG1ISHFwSUlPdnJlbVM0?=
 =?utf-8?B?RDZkaWFjUnIrQ0R5L1FmVUlhaGNSOUxUSEtVOWVVaWNOK3FteXR3djZsWEV1?=
 =?utf-8?B?OGpLSEl1R3VSQi9lenJ3bC9KNmtudExoMmxxdURNc3R4bWxvVGNFQzhFSW1W?=
 =?utf-8?B?L1J5eURMR3BWZ1NFb0VLb1E0MGpveDNXdUpzdmQ1OWpMVEVGdmg2NDJVbzlq?=
 =?utf-8?B?S0kvYStBYjZwVmNVd2djOWJFNkw5ZzI2bjl3ZjI1S281S0QrMDVGcXQ5VXo0?=
 =?utf-8?B?eGNYVnF1OFpOSXNkY3hTbXlpMTlydXhaNUI2eFNESkU5WWxlaFZDT3B3MkF5?=
 =?utf-8?B?VVYrWVI0OVlZWGVwUTU5VW1uOFJqcUFJVkdjM0JPWWNmNHpKVTFnWTNGbWJy?=
 =?utf-8?B?a3E1R256K3B3UDJSV1lEV2c4bkZXSE1pVzBhTDNHc1VvdUY4ZE5yRFNNdmNU?=
 =?utf-8?B?N1RmczV4RkpqZUJjTFpQMVFkTTdCL2g0Nnc3aXpjSkZTRUowajRPL3ZwZWFG?=
 =?utf-8?B?bW04QnpIbnIzTlp6ZmJBTXhSRFZlMEVjc2FaL2UwZTF6UzNyazFoMElmYjJF?=
 =?utf-8?B?V1lIVTFkSFByWWVwYTQ0NlZkYTRESldENys2SmZjT05vN1NsemhDSzYvRU05?=
 =?utf-8?B?SkwySEVzKzBGaTNuUnJZUSs0R0trMXhsN3RIRFVKTitNK29kRmlwT0RqYngz?=
 =?utf-8?B?QVBiTlcrK2ZHeGhleEVNakFMcE5JMnBtQWI1cTZNbGg4SHVWZWpTNmhsc2dN?=
 =?utf-8?B?aGZkMVE5dTBzZ2lGMG9tVGs1RW9IcmN5WGNZU3FJSWhZR3BBWWdJUnp6OElw?=
 =?utf-8?B?WjVZNVdUWDlpQWdMTU9rb3pGNmVqL2M2SXc1cVJZTlBJa1RkM3ZnellPZXV1?=
 =?utf-8?Q?eE9eD/yjfHCsJ8e9t/2G+pPsV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f52bda7a-c588-4f86-bab5-08dd3c3beb87
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2025 05:57:01.0136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jNxfu5Gy8VK2oA+Aa1Mkpwg3OWq1AEmbqy5cwYqYLECeEHxP/72FLRYIQyvqXxAPQTfxatRLAksKyG+cuO0IQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9393



On 24/1/25 14:09, Chenyi Qiang wrote:
> 
> 
> On 1/24/2025 8:15 AM, Alexey Kardashevskiy wrote:
>>
>>
>> On 22/1/25 16:38, Xiaoyao Li wrote:
>>> On 1/22/2025 11:28 AM, Chenyi Qiang wrote:
>>>>
>>>>
>>>> On 1/22/2025 12:35 AM, Peter Xu wrote:
>>>>> On Tue, Jan 21, 2025 at 09:35:26AM +0800, Chenyi Qiang wrote:
>>>>>>
>>>>>>
>>>>>> On 1/21/2025 2:33 AM, Peter Xu wrote:
>>>>>>> On Mon, Jan 20, 2025 at 06:54:14PM +0100, David Hildenbrand wrote:
>>>>>>>> On 20.01.25 18:21, Peter Xu wrote:
>>>>>>>>> On Mon, Jan 20, 2025 at 11:48:39AM +0100, David Hildenbrand wrote:
>>>>>>>>>> Sorry, I was traveling end of last week. I wrote a mail on the
>>>>>>>>>> train and
>>>>>>>>>> apparently it was swallowed somehow ...
>>>>>>>>>>
>>>>>>>>>>>> Not sure that's the right place. Isn't it the (cc) machine
>>>>>>>>>>>> that controls
>>>>>>>>>>>> the state?
>>>>>>>>>>>
>>>>>>>>>>> KVM does, via MemoryRegion->RAMBlock->guest_memfd.
>>>>>>>>>>
>>>>>>>>>> Right; I consider KVM part of the machine.
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>> It's not really the memory backend, that's just the memory
>>>>>>>>>>>> provider.
>>>>>>>>>>>
>>>>>>>>>>> Sorry but is not "providing memory" the purpose of "memory
>>>>>>>>>>> backend"? :)
>>>>>>>>>>
>>>>>>>>>> Hehe, what I wanted to say is that a memory backend is just
>>>>>>>>>> something to
>>>>>>>>>> create a RAMBlock. There are different ways to create a
>>>>>>>>>> RAMBlock, even
>>>>>>>>>> guest_memfd ones.
>>>>>>>>>>
>>>>>>>>>> guest_memfd is stored per RAMBlock. I assume the state should
>>>>>>>>>> be stored per
>>>>>>>>>> RAMBlock as well, maybe as part of a "guest_memfd state" thing.
>>>>>>>>>>
>>>>>>>>>> Now, the question is, who is the manager?
>>>>>>>>>>
>>>>>>>>>> 1) The machine. KVM requests the machine to perform the
>>>>>>>>>> transition, and the
>>>>>>>>>> machine takes care of updating the guest_memfd state and
>>>>>>>>>> notifying any
>>>>>>>>>> listeners.
>>>>>>>>>>
>>>>>>>>>> 2) The RAMBlock. Then we need some other Object to trigger
>>>>>>>>>> that. Maybe
>>>>>>>>>> RAMBlock would have to become an object, or we allocate
>>>>>>>>>> separate objects.
>>>>>>>>>>
>>>>>>>>>> I'm leaning towards 1), but I might be missing something.
>>>>>>>>>
>>>>>>>>> A pure question: how do we process the bios gmemfds?  I assume
>>>>>>>>> they're
>>>>>>>>> shared when VM starts if QEMU needs to load the bios into it,
>>>>>>>>> but are they
>>>>>>>>> always shared, or can they be converted to private later?
>>>>>>>>
>>>>>>>> You're probably looking for memory_region_init_ram_guest_memfd().
>>>>>>>
>>>>>>> Yes, but I didn't see whether such gmemfd needs conversions
>>>>>>> there.  I saw
>>>>>>> an answer though from Chenyi in another email:
>>>>>>>
>>>>>>> https://lore.kernel.org/all/fc7194ee-ed21-4f6b-
>>>>>>> bf87-147a47f5f074@intel.com/
>>>>>>>
>>>>>>> So I suppose the BIOS region must support private / share
>>>>>>> conversions too,
>>>>>>> just like the rest part.
>>>>>>
>>>>>> Yes, the BIOS region can support conversion as well. I think
>>>>>> guest_memfd
>>>>>> backed memory regions all follow the same sequence during setup time:
>>>>>>
>>>>>> guest_memfd is shared when the guest_memfd fd is created by
>>>>>> kvm_create_guest_memfd() in ram_block_add(), But it will sooner be
>>>>>> converted to private just after kvm_set_user_memory_region() in
>>>>>> kvm_set_phys_mem(). So at the boot time of cc VM, the default
>>>>>> attribute
>>>>>> is private. During runtime, the vBIOS can also do the conversion if it
>>>>>> wants.
>>>>>
>>>>> I see.
>>>>>
>>>>>>
>>>>>>>
>>>>>>> Though in that case, I'm not 100% sure whether that could also be
>>>>>>> done by
>>>>>>> reusing the major guest memfd with some specific offset regions.
>>>>>>
>>>>>> Not sure if I understand you clearly. guest_memfd is per-Ramblock. It
>>>>>> will have its own slot. So the vBIOS can use its own guest_memfd to
>>>>>> get
>>>>>> the specific offset regions.
>>>>>
>>>>> Sorry to be confusing, please feel free to ignore my previous comment.
>>>>> That came from a very limited mindset that maybe one confidential VM
>>>>> should
>>>>> only have one gmemfd..
>>>>>
>>>>> Now I see it looks like it's by design open to multiple gmemfds for
>>>>> each
>>>>> VM, then it's definitely ok that bios has its own.
>>>>>
>>>>> Do you know why the bios needs to be convertable?  I wonder whether
>>>>> the VM
>>>>> can copy it over to a private region and do whatever it wants, e.g.
>>>>> attest
>>>>> the bios being valid.  However this is also more of a pure
>>>>> question.. and
>>>>> it can be offtopic to this series, so feel free to ignore.
>>>>
>>>> AFAIK, the vBIOS won't do conversion after it is set as private at the
>>>> beginning. But in theory, the VM can do the conversion at runtime with
>>>> current implementation. As for why make the vBIOS convertable, I'm also
>>>> uncertain about it. Maybe convenient for managing the private/shared
>>>> status by guest_memfd as it's also converted once at the beginning.
>>>
>>> The reason is just that we are too lazy to implement a variant of
>>> guest memfd for vBIOS that is disallowed to be converted from private
>>> to shared.
>>
>> What is the point in disallowing such conversion in QEMU? On AMD, a
>> malicious HV can try converting at any time and if the guest did not ask
>> for it, it will continue accessing those pages as private and trigger an
>> RMP fault. But if the guest asked for conversion, then it should be no
>> problem to convert to shared. What do I miss about TDX here? Thanks,
> 
> Re-read Peter's question, maybe I misunderstood it a little bit.
> 
> I thought Peter asked why the vBIOS need to do page conversion since it
> would keep private and no need to convert to shared at runtime. So it is

I suspect there is no need to convert vBIOS but also there is no need to 
assume that some memory is never convertable.

> not necessary to manage the vBIOS with guest_memfd-backed memory region
> as it only converts to private once during setup stage. Xiaoyao
> mentioned no need to implement a variant of guest_memfd to convert from
> private to shared. As you said, allowing such conversion won't bring
> security issues.
> 
> Now, I assume Peter's real question is, if we can copy the vBIOS to a
> private region and no need to create a specific guest_memfd-backed
> memory region for it?

I guess we can copy it but we have pc.bios and pc.rom in own memory 
regions for some reason even for legacy non-secure VMs, for ages, so it 
has little or nothing to do with whether vBIOS is in private or shared 
memory. Thanks,


> 
>>
>>
>>>
>>>>>
>>>>> Thanks,
>>>>>
>>>>
>>>
>>
> 

-- 
Alexey


