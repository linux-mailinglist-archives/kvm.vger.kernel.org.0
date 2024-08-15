Return-Path: <kvm+bounces-24302-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 485839537B6
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 17:58:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E916D287953
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:58:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B5EA1B29B7;
	Thu, 15 Aug 2024 15:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="B3HPFsHV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2043.outbound.protection.outlook.com [40.107.92.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91551AD9CE;
	Thu, 15 Aug 2024 15:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723737505; cv=fail; b=Fm4K+fk2ay+3EzQzKWeaWLvrlub6XgfNDEtwZearLylKRGHEWQ7yMCwP5MzNIVG1AqoCGVjcl/77MB1qtNs9MNYTpw44pl3WWHqNc7NzSARK7PsJMFw31cpf8zzah37UNl35U71DBnKpYeLW4nIao+l4tbP1WAXqvW2EkWxyBlk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723737505; c=relaxed/simple;
	bh=U1041CDAyDMjAkAjI1mZEkwa0M39EUdNxVZzq7IEqkE=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=cti/+UADTuzcHsIbEIi+Gi2R3qn2JXELmG6YLmlpj+8pWbJP2RXIYT8GkJrOuPLGRd8phI4WpPODOjFJbmaZpAYyK0pAeZacju5HONH8WjXLbAyiKKzoessFChlKTXxwSmhX3XOFtDtmKYT+2IM/agWZiXfa6h/i0ZsCZpAqtEY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=B3HPFsHV; arc=fail smtp.client-ip=40.107.92.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bngATXD+1DEOA/JNeKkLjPN6kOgjUQRdf6gPep8XyWYKNCpU+RKl205CTOuW9LDfIrQsNeWtX4aL76quW0lwedl9MPFMdV88W2yEHM5aXjB+6gW+LiuoSJkuHv/cxEYobSWXVDXI0LEGHn2JVEDxaCK69/PqyxK/BLSFS2pzFVM3AKg/vC5vQ3QgLE9oMlO6x86OoMrSKi6pxFcWoPW56H+5yTFj1rg4flryddfyLopMDh+/4C+r3BCGaWDU1z6+377BfRE0pYeWcV0XqXd0M5HJz5W8QeUBsiT7ZyRuRuYmaaSLEkcWPS6r8nXBwrOcDAWRf5v6+p8zHSfj0PzH7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ZiY/Yo2D6JoX+PrUnbDUut8tHo1+W4e9bOWMUVAvqI=;
 b=hhj391Dy8yqACjvzsU48hcYmuakpf58ElnSw7L5Ce7Bxx9XQ4AxXL+x87BLwLvdaBFg5fbKMtAV3qoAnwwqok5CEy0ocn3HBAcIGMJjvQrZaOXNIlHWyEOp59X+HLRl0cVX034a6YM6CqXSsa68Vqgy4eAAW4/ykohNNV3aGurfrLGkSzP8GZ56RSLz175J+arieAh/7xHxMU7UPNFUV3hqnykciy18iCNDapXet/4pSoA7GO3sMCPySgnssbT+0n/2dMRObQYfTBJ0APPTmhPkxu8HC9cOxDq7VUQfWi+N9AHCCziPBu2t/ERQa8/B8ufxSYRxX9P6Kw6eVsIFWHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ZiY/Yo2D6JoX+PrUnbDUut8tHo1+W4e9bOWMUVAvqI=;
 b=B3HPFsHVDvBxjmOwyDaZ8F/2mQJfYREP7ScUco2nSha0SQqooW7tsIhpFutCfdJcGOjKwvEWaH0I9xGIgvNvjgwA28+FUumdGNv0yzd3uRYQaIMvMkT+s1WiybgMltYcukDzL4xLVY4PLsFktP/2mvB4wod+yodbQiStShL1ewQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS0PR12MB9060.namprd12.prod.outlook.com (2603:10b6:8:c4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.23; Thu, 15 Aug
 2024 15:58:17 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.7875.016; Thu, 15 Aug 2024
 15:58:17 +0000
Message-ID: <afafee48-4a74-85a0-8455-640eb2d59948@amd.com>
Date: Thu, 15 Aug 2024 10:58:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au
Cc: x86@kernel.org, john.allen@amd.com, davem@davemloft.net,
 michael.roth@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <cover.1723490152.git.ashish.kalra@amd.com>
 <b05c6de0c3cd47f804fd77be60ca2d90a6d28f8d.1723490152.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 3/3] x86/sev: Add SEV-SNP CipherTextHiding support
In-Reply-To: <b05c6de0c3cd47f804fd77be60ca2d90a6d28f8d.1723490152.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR04CA0079.namprd04.prod.outlook.com
 (2603:10b6:805:f2::20) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS0PR12MB9060:EE_
X-MS-Office365-Filtering-Correlation-Id: 6db41f59-478c-4447-bc56-08dcbd431399
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bXVBa3lsTVp1NHk5Uko0a3Ivc0hIdnJ6bGVSdlpISmRod0J3aS9jQXJid2Fa?=
 =?utf-8?B?dndPa1RDcTRNM002TE5iZWdSeWpSYmNnK21tb2o2M2gzRmx4K2l5N2dtWFkv?=
 =?utf-8?B?R0VIRVAySjBOb0dkdDRmTmhoNEhXSHBuU2FzUEdLNy8rcndFNysrYU4xYzQv?=
 =?utf-8?B?R2dCb1lhT3c1aDdDZ3hEUXd6b0FDSXJMMWtwVVVOb1JMUk1tVjFra3oyVjZK?=
 =?utf-8?B?bFA0RDI5UHduOEhTSEIveGRVZVFJRUFQV1hSR2xJdG1VTURrVHI2WjZuZTNK?=
 =?utf-8?B?YUdvM0xDK2lLRXNMaUM4enE0VWZZYUZ0VkplZnBoZ1hLQWNSQlZYMFIvNHFr?=
 =?utf-8?B?UllKMUxtWnA5NHB2Y25BUzZTSWtZQ3p5SEx1QTZmWFNyZ000TVZjS3gydnVF?=
 =?utf-8?B?dUs0OGxjaldsRkFNZXgyQ3U4bFFJT1l2SnFLZGhlcUhUbmVlYW5GNWpCNzcx?=
 =?utf-8?B?a3JoaExoeGVxN3FBdXM4cjc4SlkzK0R3NXp0UjZ3Z00xVFZhd2lqdGxSVzdx?=
 =?utf-8?B?ZU9xMU5PQncvVkJEV25LZnVoOXhCT0RYM1BiL1IyK1g0K1VNQ1Q5NnBJREF4?=
 =?utf-8?B?alBQU3hraWhZbS90OEU3KzRTTk9pZlJ2VmRReldLdUtGQk5nNDJNNHAxYVEz?=
 =?utf-8?B?RFpEKzEzS0FoUTJyWkVtOFQrdDl4NDdnTDZvWDgrK1NxMGVLbGdVQ093VmZK?=
 =?utf-8?B?Vnd0N0M4YVkvd1VWUXMvOWh2c2l5YmtYR1M4NDhzTThGYkc0VDhsY0VTTUpV?=
 =?utf-8?B?Sk5vVTFKRnRqOHRhR2dWQm9tdm1kZFNnSGszN1NGK29ucWlyQjRucjRKckZx?=
 =?utf-8?B?WEM5d0twd3o1dFJmaVZaNnYzNkNYODRHWVFFWCtSSEloY1NOZjZ1dEJKSzBO?=
 =?utf-8?B?bnJLcjNna0F6YkgwWVltcHB0Z3VBS1k1SG5jbmFkRzNxcmJxSXBiYnRBb2Z5?=
 =?utf-8?B?ZjhiNStyaWhqS2xFMUxBODdVUXFoSkRmaHphQUE0MzF6TjdxNnJJTkxsYmhH?=
 =?utf-8?B?ZHhHZVliMHFWRXdQcDE5RnJDam9jUkJaaVlBVGhKYVU0RHdaSzVqdFU2dmNT?=
 =?utf-8?B?R21waUk3QXFEaW53ZFJMdkZFbTNYclh5UllGUGZ2cDg0alhnOXk3QWJUeXRm?=
 =?utf-8?B?VjNENWpkY1Jnem9mTEpWb2JySC9wSkxFUVRNY29XbW1YaHBTNE93am4vTjh4?=
 =?utf-8?B?K2JaOXhSdFZXM1J0dzNjNTZBY3ZySExIYTVWeTRTSHZWdTZaYzJsWHZwZmVC?=
 =?utf-8?B?eHdyQXZzOG9iZk5FVEVwQklVd3VhS21jeDFPdStCdTIwNWNCVkw4UUhJbGpV?=
 =?utf-8?B?cTVtVDdwdXpxblBYQnNXUDhLQkNrOFJ5WCsxd1gyYWNHYWdYV0lDdkZrOWtC?=
 =?utf-8?B?ZTY2eXQ5NzdQem9HQ2VPUFgyalhpeDhrQUo3emcwS1VOaE5kallwTXRONHdo?=
 =?utf-8?B?eHdENkdLc251RmtzYzlDa1pHTURwcWxvZHZZcmF5NGcxRHZOZEdJMENxS0Iy?=
 =?utf-8?B?eitucUd6dHA1UmZGeGI3bzM5UDRmV3RjUGdQWW84cmIydjhDQ3hSK0Z1cEJt?=
 =?utf-8?B?ZkYzYkVibEpwVThzQVVPc3R4M1Qrb1doUUEvOHUzeDE0N0s5ZXBkTkJiUXlo?=
 =?utf-8?B?ZlBhL2Y1VCs0ODFuV25KaFpTZVRXQ01JY1g2WWJvOVBnKzdoWVRpSithN29j?=
 =?utf-8?B?SUhZRzc5ekR4S3FFQWdPaGdreW9xTmhIcUgrUm94d1htaVBYSklCblBTamt2?=
 =?utf-8?B?VTBTVWUrdHc2aDZucU50KzF1UjV1RCtUQXd0Zi9uZHdqK2w1R2NVeThlTkQw?=
 =?utf-8?B?M01aekdCUTR5bEcwSzZyUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZERzNmlBWmQrTmtvQ0JnMDZWb3pVbUthandJSXFMbldNWSs5ZnV4dFVFUllq?=
 =?utf-8?B?TFdXTjlWdTlZS01qMytIcm9UYU1BMC90V2NmZGlMRkluREx0L1BudHdlMW53?=
 =?utf-8?B?cFNPSEJKaCthZDROckIzNnBjYnptR3R5eW5SVGwxSnpVSlVtYnhLWkFKUGZX?=
 =?utf-8?B?VlJ0TTkvWGJKWVBpaTR2Z2k0bGlaQzhUR0JUKzQ0Y0l1OVk5UnNqTUU2bW5J?=
 =?utf-8?B?dmY0R2FHK2o3S2ZDQW4zTnprUFR5cTcrN0d6VzN2UlhZNW5NMTJENHhSQ1Z4?=
 =?utf-8?B?UTdWQ3ZNbTg0VGM4alExMXFpU0tPQVhoUzdNV1BkZklFQUdHN0tNRFo2N1p6?=
 =?utf-8?B?bWlQS1RpaWsrRUpJSDVqNHB3K0kvMVlWYWxLRTBVQ091TUhTNzBzZ1praUwx?=
 =?utf-8?B?cEtlcTZtQXFpM1d4eVZLTDNEMlZUZzEwT2hBeFROQVVDdXZWY0sxNWVwMW9C?=
 =?utf-8?B?ajBWOUtEODRlQmc3RVdvbEUxSldSaFRVaVUvNTVRaFVQbFB5K0F0cmhVdmJ3?=
 =?utf-8?B?Y2NZL0g5V1piRHVyTXJxOFVYOUtXUjFtTjd6OEN4QkhlcEFIdVZoamw3VkZa?=
 =?utf-8?B?UG4rKzc5b1dHK2xjemZrSFdnc2lCK1JYa3hOcm1PZzJZaWtyZEpMRmNTT0RN?=
 =?utf-8?B?RzlTUmRxTXJBRk0yUTM0ZnRQckZvdFNJaklmd3J5WmVYRDBJR1ZGVmtNenEz?=
 =?utf-8?B?TnRoakt4VUlQdzVjaGNBNEppZm9hR0tJUmc0UjF4SCtoR1h5OFVvekxPd1Vh?=
 =?utf-8?B?US9kVHhZUUd1dStSd0NIUVlyVFVNbVhuMFZVUHV6WjlXcmpVaDBTWnlMUGxy?=
 =?utf-8?B?YkVRUVFFczVtaUl1VUNtY3B6VC91VTQzQXRCelRlM1NYck8yeGVOM0NuRXFv?=
 =?utf-8?B?VmdIL1h6V2szTlJ1L080bGRYcDBCZVhwVVRvSXhsK1FVRVRXTlBYaklCMWcv?=
 =?utf-8?B?RFlIbHBoQVF2bFd5UkxtLzUzMGRrcjFneUUwQmIxdytvSEVOZTBqanFDbmRS?=
 =?utf-8?B?ZWcrZHJNUlRzbldKcnFxS3o4UncwUHFadlVDNnZSdi83TFU3WW9Gd1N2a01V?=
 =?utf-8?B?WEZTbkhyaWpseVpac3l3Tk1ERjR3eG5LcGlVOFdQS1BNaWV2VUpkblZhVXRa?=
 =?utf-8?B?WXBoUC9nV1hPWSsvTXhPcmgxaGxxcUtCOWR2QXdzM2k3elBNZ2RKYVNEVlQ3?=
 =?utf-8?B?dStVWnNmVlJ6eGRkZ01BWVNrU2plcnBXSWxRbEVzVlZYNm5DenpZejNRekV5?=
 =?utf-8?B?WVNVeGpCZmlCZVRVUjNqUENZSzhpT1lxc3l6SkE5eGpQdFJBangvb05LTXJZ?=
 =?utf-8?B?TDVsUHhPQ1NXNjJWaUxEbVdNOWQwTEdMcTlNbWlVRWtaKzJLSDdFS1BDSndz?=
 =?utf-8?B?SDFjdUh4Q3RWSE55R3VMaU12OHZYWHIvU1pCQjlsbXRWS3ZxVm9SS1pEaDFQ?=
 =?utf-8?B?M0VTcGt0Sngzb3NZVTlQRC9BN2tXNzhZbFUySkJGSnpZVDVEOWtvZHdRMmo4?=
 =?utf-8?B?elBhaFlQZi9JN3NnY05GOGxuQzJhNjlGR1FCOVViWSt5Qm40UktzbVQwK3d5?=
 =?utf-8?B?N0N6akw0aE92ZUdxd20yRi83d2EwYW9WZ1JzbWxqa2t2SERMZmVoZEtTYXp3?=
 =?utf-8?B?aEZ2MmlEUVhyYjkrdTQ5dHZGOFh0SlAyTXlEdG5PbjJnYlJkanBIYXBPMFRy?=
 =?utf-8?B?L0xST1JxbDlTVzZTL2Q1R2hiVUlrczRlcWVHRzFhL2J5dkdDSS9QZXhiRVQ1?=
 =?utf-8?B?VkxvUURPMkxVWW5ieFRaMVprK2FudnVNVm5qYWdENUJTZXdEWGIyU0xWdisr?=
 =?utf-8?B?djRzcERNNG96TDVTaytIVW9COTFoWStMUGJwRURjUG5mME5FdGN4RnNIVk03?=
 =?utf-8?B?K0NIeEFGczNBTFdRSzRleU1HWUllQ1U4b0FVeEgxY3JpTXJhS3dEdFFSSSta?=
 =?utf-8?B?VlVPaVBMQ0xBS0hmc0JNOFZiWmZDMDFaSSt3aFFZNjd6K1E4RGtzcDRuYkFw?=
 =?utf-8?B?aTJRV1g3TVBUcHVRQ25vQUNQS0hlTE9qSHJkZ2dURWI4ekc5MUUrU0RYaFJq?=
 =?utf-8?B?Vi9ydmZaQU1WaHRIK2YvbkZGd0hDYURZNHRFUXhWTlBuK2d0Mm0zcm1wMTc0?=
 =?utf-8?Q?2Bz4Ugmx8wVKVVwSCz1QYJWGB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6db41f59-478c-4447-bc56-08dcbd431399
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2024 15:58:17.0210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +QD7lo71Jl84B0BBaahwGpetHTafsuNcZgsVMv0auAaL0hv+DAwyJDAJo5koCmRtx0IS56Lya7R8cHGlf1PsEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9060

On 8/12/24 14:42, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Ciphertext hiding prevents host accesses from reading the ciphertext of
> SNP guest private memory. Instead of reading ciphertext, the host reads
> will see constant default values (0xff).
> 
> Ciphertext hiding separates the ASID space into SNP guest ASIDs and host
> ASIDs. All SNP active guests must have an ASID less than or equal to
> MAX_SNP_ASID provided to the SNP_INIT_EX command. All SEV-legacy guests
> (SEV and SEV-ES) must be greater than MAX_SNP_ASID.
> 
> This patch-set adds a new module parameter to the CCP driver defined as
> psp_max_snp_asid which is a user configurable MAX_SNP_ASID to define the
> system-wide maximum SNP ASID value. If this value is not set, then the
> ASID space is equally divided between SEV-SNP and SEV-ES guests.

Add something here to talk about how cipher text hiding needs to be
enabled on SNP_INIT_EX and so the module parameters are part of the CCP
driver.

Not sure if having KVM invoke the CCP, at KVM module load time, to
perform the SNP_INIT_EX would make sense or not. That would allow all
the cipher text hiding support parameters to be in KVM. Lets see what
others think.

> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c       | 24 ++++++++++++++---
>  drivers/crypto/ccp/sev-dev.c | 50 ++++++++++++++++++++++++++++++++++++
>  include/linux/psp-sev.h      | 10 ++++++--
>  3 files changed, 79 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 532df12b43c5..954ef99a1aa8 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -173,6 +173,9 @@ static void sev_misc_cg_uncharge(struct kvm_sev_info *sev)
>  
>  static int sev_asid_new(struct kvm_sev_info *sev)
>  {
> +	struct kvm_svm *svm = container_of(sev, struct kvm_svm, sev_info);
> +	struct kvm *kvm = &svm->kvm;

Why not just add the vm-type to the input parameters?

> +
>  	/*
>  	 * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
>  	 * SEV-ES-enabled guest can use from 1 to min_sev_asid - 1.
> @@ -199,6 +202,18 @@ static int sev_asid_new(struct kvm_sev_info *sev)
>  
>  	mutex_lock(&sev_bitmap_lock);
>  
> +	/*
> +	 * When CipherTextHiding is enabled, all SNP guests must have an
> +	 * ASID less than or equal to MAX_SNP_ASID provided on the
> +	 * SNP_INIT_EX command and all the SEV-ES guests must have
> +	 * an ASID greater than MAX_SNP_ASID.
> +	 */
> +	if (snp_cipher_text_hiding_en && sev->es_active) {
> +		if (kvm->arch.vm_type == KVM_X86_SNP_VM)
> +			max_asid = max_snp_asid;
> +		else
> +			min_asid = max_snp_asid + 1;
> +	}
>  again:
>  	asid = find_next_zero_bit(sev_asid_bitmap, max_asid + 1, min_asid);
>  	if (asid > max_asid) {
> @@ -3058,14 +3073,17 @@ void __init sev_hardware_setup(void)
>  								       "unusable" :
>  								       "disabled",
>  			min_sev_asid, max_sev_asid);
> -	if (boot_cpu_has(X86_FEATURE_SEV_ES))
> +	if (boot_cpu_has(X86_FEATURE_SEV_ES)) {
> +		if (max_snp_asid >= (min_sev_asid - 1))
> +			sev_es_supported = false;
>  		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
>  			sev_es_supported ? "enabled" : "disabled",
> -			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
> +			min_sev_asid > 1 ? max_snp_asid ? max_snp_asid + 1 : 1 : 0, min_sev_asid - 1);

Maybe put the last parameter on a separate line to make this a little
easier to read?

> +	}
>  	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
>  		pr_info("SEV-SNP %s (ASIDs %u - %u)\n",
>  			sev_snp_supported ? "enabled" : "disabled",
> -			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
> +			min_sev_asid > 1 ? 1 : 0, max_snp_asid ? : min_sev_asid - 1);
>  
>  	sev_enabled = sev_supported;
>  	sev_es_enabled = sev_es_supported;
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index eefb481db5af..9ee81a6defc5 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -73,11 +73,27 @@ static bool psp_init_on_probe = true;
>  module_param(psp_init_on_probe, bool, 0444);
>  MODULE_PARM_DESC(psp_init_on_probe, "  if true, the PSP will be initialized on module init. Else the PSP will be initialized on the first command requiring it");
>  
> +static bool psp_cth_enabled = true;

This is a static, so how about just calling this cipher_text_hiding.

> +module_param(psp_cth_enabled, bool, 0444);
> +MODULE_PARM_DESC(psp_cth_enabled, "  if true, the PSP will enable Cipher Text Hiding");
> +
> +static int psp_max_snp_asid;

Also a static, so just call this max_snp_asid.

> +module_param(psp_max_snp_asid, int, 0444);
> +MODULE_PARM_DESC(psp_max_snp_asid, "  override MAX_SNP_ASID for Cipher Text Hiding");
> +
>  MODULE_FIRMWARE("amd/amd_sev_fam17h_model0xh.sbin"); /* 1st gen EPYC */
>  MODULE_FIRMWARE("amd/amd_sev_fam17h_model3xh.sbin"); /* 2nd gen EPYC */
>  MODULE_FIRMWARE("amd/amd_sev_fam19h_model0xh.sbin"); /* 3rd gen EPYC */
>  MODULE_FIRMWARE("amd/amd_sev_fam19h_model1xh.sbin"); /* 4th gen EPYC */
>  
> +/* Cipher Text Hiding Enabled */
> +bool snp_cipher_text_hiding_en;
> +EXPORT_SYMBOL(snp_cipher_text_hiding_en);

I think you drop the "_en" and just have snp_cipher_text_hiding.

> +
> +/* MAX_SNP_ASID */
> +unsigned int max_snp_asid;
> +EXPORT_SYMBOL(max_snp_asid);

This should have "snp_" to provide better namespace isolation.

> +
>  static bool psp_dead;
>  static int psp_timeout;
>  
> @@ -1053,6 +1069,36 @@ static void snp_set_hsave_pa(void *arg)
>  	wrmsrl(MSR_VM_HSAVE_PA, 0);
>  }
>  
> +static void sev_snp_enable_ciphertext_hiding(struct sev_data_snp_init_ex *data, int *error)
> +{
> +	struct psp_device *psp = psp_master;
> +	struct sev_device *sev;
> +	unsigned int edx;
> +
> +	sev = psp->sev_data;
> +
> +	/*
> +	 * Check if CipherTextHiding feature is supported and enabled
> +	 * in the Platform/BIOS.
> +	 */
> +	if (sev->feat_info.ecx & FEAT_CIPHERTEXTHIDING_SUPPORTED &&
> +	    sev->snp_plat_status.ciphertext_hiding_cap) {

I'm not sure you need both checks. Either the platform status or the
feature info check should be enough. Can you check on that?

> +		/* Retrieve SEV CPUID information */
> +		edx = cpuid_edx(0x8000001f);
> +		/* Do sanity checks on user-defined MAX_SNP_ASID */
> +		if (psp_max_snp_asid > (edx - 1)) {

How about:
		if (psp_max_snp_asid >= edx) {

> +			dev_info(sev->dev, "user-defined MAX_SNP_ASID invalid, limiting to %d\n",

max_snp_asid module parameter is not valid, limiting to %d\n

> +				 edx - 1);
> +			psp_max_snp_asid = edx - 1;
> +		}
> +		max_snp_asid = psp_max_snp_asid ? : (edx - 1) / 2;

Add a blank line here

> +		snp_cipher_text_hiding_en = 1;
> +		data->ciphertext_hiding_en = 1;
> +		data->max_snp_asid = max_snp_asid;

Ditto

Thanks,
Tom

> +		dev_dbg(sev->dev, "SEV-SNP CipherTextHiding feature support enabled\n");
> +	}
> +}
> +
>  static void sev_cache_snp_platform_status_and_discover_features(void)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
> @@ -1181,6 +1227,10 @@ static int __sev_snp_init_locked(int *error)
>  		}
>  
>  		memset(&data, 0, sizeof(data));
> +
> +		if (psp_cth_enabled)
> +			sev_snp_enable_ciphertext_hiding(&data, error);
> +
>  		data.init_rmp = 1;
>  		data.list_paddr_en = 1;
>  		data.list_paddr = __psp_pa(snp_range_list);
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index d46d73911a76..a26b43c2eab9 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -27,6 +27,9 @@ enum sev_state {
>  	SEV_STATE_MAX
>  };
>  
> +extern bool snp_cipher_text_hiding_en;
> +extern unsigned int max_snp_asid;
> +
>  /**
>   * SEV platform and guest management commands
>   */
> @@ -746,10 +749,13 @@ struct sev_data_snp_guest_request {
>  struct sev_data_snp_init_ex {
>  	u32 init_rmp:1;
>  	u32 list_paddr_en:1;
> -	u32 rsvd:30;
> +	u32 rapl_dis:1;
> +	u32 ciphertext_hiding_en:1;
> +	u32 rsvd:28;
>  	u32 rsvd1;
>  	u64 list_paddr;
> -	u8  rsvd2[48];
> +	u16 max_snp_asid;
> +	u8  rsvd2[46];
>  } __packed;
>  
>  /**

