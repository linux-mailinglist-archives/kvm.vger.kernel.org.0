Return-Path: <kvm+bounces-25637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDE62967D16
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 02:52:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0BF881C20A5D
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 00:52:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D81BDB660;
	Mon,  2 Sep 2024 00:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cm3Y3Ggx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2072.outbound.protection.outlook.com [40.107.223.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819A279C0;
	Mon,  2 Sep 2024 00:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725238365; cv=fail; b=YCjVN9E1360S04leWgXSsaK32m+NOBP7kzAy+p+/X6mbCwaFYwVU2qywht5z2s1ZJplQIYFrU5JHI/+dzXN1GFV30imwjqXHE0Cf4zHfQ2zAwUM9CqQ/GP0kqqhF0dFDQGnCGmjBVZe/ZiQnL1XA5JrTBzz0JutHOW42wsLqQao=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725238365; c=relaxed/simple;
	bh=/DBxamzE7nmK/QPX87oHKRn8dvzz1Q03NPix2PhwxgQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=igHiHRoshhHOKsKU2mSo2dkggzdNrAy3tLp3HlXEP3YnuikExelEs2WM/L+S34BdCM9DYwBE+4Rbvu/41bfCcGX9Gxewa4W+FnUIaJQKAJ5WZjnsVnF7sAAPmZczV8vWO67nSahvRk8ksP91zNH5kbUTwPq69r7UJT0qBiCiXCw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cm3Y3Ggx; arc=fail smtp.client-ip=40.107.223.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rphv2vdYQizdnMpnY/ycY/x5Dcf+hltRKuwy8m6Rx4M65ddoLWBl9My6xw8ZFVvy6/OQekTzGL1FAoXap27GQMBwfVYxgVG4V/ZcmWUkddu4lhMhBLLa75T2LpjsmNLjEMWFOcVO2Ygn240vB5vUDb/bW6NbBVBPWiWoWDdfsqqxS8EkU8THbSA0yFpnnYQHViwbuLtxMFnuNY30mqDae4TkBNzRJ4/UbUBevc+Pb7mlqAmwjn6FwsB51T0i9gBX/YrnJ15s6EpxvvNUQa8p0o3Da52LWgPUbQkW7+C681sbDSRRFkzXPPut7nZLZclf2MUHRGFF4Clq62lGtBqG4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HRXeBmMRQXUXvS3WouGylHT/E2qnlIeV8pb4K4bIfLQ=;
 b=OtVVJPw+u19i20xbiOSLOYTBeCkpOGcG0vOzKa1RdKYA8EzszNKxq7Rm0fDHbgMCkWij+Ec4fPxn7TVQEASAUlVbRkCSfHU8sv/o3g5PZnHdPPQCQrpZvJt20p9DVMcQWp5hnVsx8EAegmVumbsU+ms5qsfDApHLFaZ/yRBQVkBPm/AMNDwJPJGU6/LukIkvei9sV6ponbDdHOTbZGo7nIspgvBnIsmiXsKQ/lMXAAQ5QtyhNfe7V+VmTeJuTPUPt0hKKwxVu8LxpEGS3FPQBVMaLPM5ce8bGeabCS5SvU8IBoiIliH7/6AQJd1JCCBMEOMr1XSb3HHyZR/n/IOjzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HRXeBmMRQXUXvS3WouGylHT/E2qnlIeV8pb4K4bIfLQ=;
 b=cm3Y3Ggxnudi99G6q1VV6moGRHJpzZrObjXM5P573YDQn5GUIfmA8zTM3rLRoFTNO3tFx8mhraqCNdLAFkTitAL7ijpOtad5C0wu8kQZgfIZJw4Ftf662abpf2nWhz9PDh58RbQzM6W/HfXBCt1nBJGawkRx/iacfUJr7XN3mP4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by CYYPR12MB8752.namprd12.prod.outlook.com (2603:10b6:930:b9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24; Mon, 2 Sep
 2024 00:52:34 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%6]) with mapi id 15.20.7918.024; Mon, 2 Sep 2024
 00:52:34 +0000
Message-ID: <d30ea566-4add-4b3a-b37b-79272fc1ddf3@amd.com>
Date: Mon, 2 Sep 2024 10:52:25 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [RFC PATCH 07/21] pci/tdisp: Introduce tsm module
Content-Language: en-US
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-coco@lists.linux.dev,
 linux-pci@vger.kernel.org,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Dan Williams <dan.j.williams@intel.com>, pratikrajesh.sampat@amd.com,
 michael.day@amd.com, david.kaplan@amd.com, dhaval.giani@amd.com,
 Santosh Shukla <santosh.shukla@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>,
 Alexander Graf <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>,
 Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-8-aik@amd.com> <20240827123242.GM3468552@ziepe.ca>
 <6e9e4945-8508-4f48-874e-9150fd2e38f3@amd.com>
 <20240828234240.GR3468552@ziepe.ca>
 <d9bd104b-e1a0-4619-977c-02a27fc2e5b0@amd.com>
 <20240829120753.GU3468552@ziepe.ca>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20240829120753.GU3468552@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5P282CA0154.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:24a::24) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|CYYPR12MB8752:EE_
X-MS-Office365-Filtering-Correlation-Id: 50e8d287-72e3-49fc-1e47-08dccae98809
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M3dsSU54ajRRQ3FHdlRseXgxREpMWVBDcGl2VHlPUnJLSk9panU4OTZoSEJ6?=
 =?utf-8?B?Y0ZsbW9uR1M1Sm9FY1VQMUIrVGdFRUtDRVpseHVnd3RFM2l2by9CcDVvVDVq?=
 =?utf-8?B?WDJmWVpNY0tWelQ0TDNEbUJyVkdPR2RGSzZ2NkUwekpkeUtIR3JjQzlsamdE?=
 =?utf-8?B?QUNFQkJKNW5OYmUxTUxxVkwrclo1aERJYzNIZHB6cDg0Y1NvLzhzZEtUNUNB?=
 =?utf-8?B?NlpqRDJqR1dDM1ozZjhOWUNDaXFoR0tsT0dWVDNIaXVhWUsyTkdDWDVpK0k3?=
 =?utf-8?B?YnEyNnFEZHM5WnZWaDRIU0RqeTNmNG93RW0wRkFlL2tRcFZ6bmhtcExrdU1K?=
 =?utf-8?B?RGZvNVg4eXJyRGR3ampqK3dGMHBXYVZ0Q2grZ3JKRDlvS2grYnVxR2RoYW9O?=
 =?utf-8?B?WGRlUkQvRjBoTUQ3ZzBCMWVmL1NsMEczMy9HNTBNOEEwQ2lIVjM4N2R6ZVZK?=
 =?utf-8?B?UVJkcVY1ZDk1aU9qMFFuZUlKZmI1UW93UEdkMktHSUpCaDdOWEhHZldPSWFQ?=
 =?utf-8?B?enYxenU2b21WclZaWDNhZEJVRDc4NGpyYndjZWh6OGpQQWpaMVFseEtrdFRT?=
 =?utf-8?B?WUd6ODE1WnhwOGFiMXBPMnZTWXpqN3VkT1UrT2lCMXdtR1oycGtacVUvK2ZH?=
 =?utf-8?B?eDhIQmNxM01qTXlzY1AvLzNEOGJNWFhMZDdoMmR0YkdwZThqZndOWWN5VGZt?=
 =?utf-8?B?YkM5bXVPekJzcEs3dm8zQVlBR0xtZUcvRkQvc25WMFVVaU9WOGw1cXhzRndD?=
 =?utf-8?B?OW0wcW9oWGhJWGRyN3ZUa2l4WVgwR203ank2dkRaQ3FsRWp6aDVURlpsTHVM?=
 =?utf-8?B?MkJVSHRPMXZPNFE0U0RyQmZ4OVhCSlBtQUVUajB4SktQVXZNSmk1OE41NTRN?=
 =?utf-8?B?c0U5VlVCaEpPaWhleGorUHVJeHRkb0hwbDBZNy9mYTUxTW9JWTRLdXhmYS9x?=
 =?utf-8?B?Y3ZpajhKb0o0OThKL2dnRTQyL2VmK0x5N3p0SlBFR1lqM3RKTStETEFkQkxm?=
 =?utf-8?B?WkN3akJIZUhiTjVzYThqWklxdzdKeUVFS1JBYVpSc1hNN3Urb1cyMWRkaUt5?=
 =?utf-8?B?KzFEdXFXQUJKT0hibUtHblI3SzQxd1hJVjVPbGxkUkxQVmZOVW1wNGY3NFcz?=
 =?utf-8?B?UE05Q0YrdkYyeVdEMVRDc3M0VWFxRkt2eG9QRWtac0FWQmtSZUxkVDFtNjJ5?=
 =?utf-8?B?blkwUmJMSmIyTmdYVm15V3lFcDQ0a0pXNzdPdWtBbExaeTNCUU5jK2NqU3gv?=
 =?utf-8?B?emwrc3E1NG9MVkR5V2l4eWlqMWNYRTJSbnd3MVdtMnIyREtOL2RrWk5DVHVO?=
 =?utf-8?B?aGRwUk1qeTd3KzZmYVF0bjJMekI4Q0JBTnlCYVRFNmVVN01mTk9tcFJQczlS?=
 =?utf-8?B?MGJnRGhzK1RsUWF6eVZLQjN5UTBQUzl1LzV0NnlycytJa0N6WnF6S0lITHJr?=
 =?utf-8?B?ZnJ2b09Jc0l2QlQ3STN0dzEzMlNaellVdXAwbUxBUjBZVFJVOVkva0ZlZnl1?=
 =?utf-8?B?dG1vUHB0SkowL2I5NkxJcUkrYUVjaHNseGRVRGFGNEZFWHhSNDI3UlBZeVNr?=
 =?utf-8?B?bFVRWGM4ZDhsdDZVOEtIbC81THFBZmV2ZjROajladUlDNXFuMWpaSlpmUlFt?=
 =?utf-8?B?UlhjaURrSVpCK2lYZEF5S1NnZGVkeEs4bDk5RThFWlB1eDRmVWxwcitMazRK?=
 =?utf-8?B?Wkl0RDl5akE4Q0QyL1FJS2pReDVJWkNFVFphU3l3Mjl0emY4T3lNNzFXQS9U?=
 =?utf-8?B?dUNCaFgyR2VTalZFdlpqQ1A3UW16c2cvOXR0Y1Vrb0o0ZVhQcjlWWDVOQWRT?=
 =?utf-8?B?NmxXNWduKzVkMWlXbC9EUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TUVEb1pLVGtRcXZtaVlYUXlXcW1UTnZ6SlVPeHIvcEd4R2RsS091bS9qOUtI?=
 =?utf-8?B?eVp3a0pqZkdPK1pnS3B0YkdJN2hNVmpoK1hZK0FFeUVpWWZNUEorcEhGdjli?=
 =?utf-8?B?VnJFV2dGc21UTGpaZENQemhyRHBpMndRNUZhMjZFdkxRV1BnOUQ5dnVvTjhl?=
 =?utf-8?B?YTdycXdGVkJGRHFReGlGMjJsaGVnMjVPaHBZNnYzVXozSlNmS1RUcm9jTG5U?=
 =?utf-8?B?eHNyaVFrUkg5T2llb3pNYmlGVVo3ZWk0MGFBRThJMUlOZUpkOVQ5TDVDSjla?=
 =?utf-8?B?ZnZteGR1RytlbXdmLytQWUdrVG5CWnZTaTNnNnI4ZzRTSGVsSS9PcEUwdDNB?=
 =?utf-8?B?R3lpYXYyc1NKK0hKZ3N1UHlCSGxDT2JGZUJHbGUxK2ZkczBGcUVyckRWdWVP?=
 =?utf-8?B?WmdGMlhOd1N6Y2VOL01JTWs5SGVIaVNqdjVVRmJ0ZEY4OENHTXhlT1NaL1dy?=
 =?utf-8?B?cE93eEQrVnR6VGwybTZyNXJxbTdtLzFONTVIcEc0V01YUWNCa3hJeWZxK1U5?=
 =?utf-8?B?RXdIeExhNVFPWjdnTC9rUjN1d0hDQzBYT3ZpUEx2NVJESU40SFJ1MW5VTU1H?=
 =?utf-8?B?V3J5dE1iL1dhd2NxZUJibVFjNm8yd2s3bjdHSkZLU1FZd1pKWWVUbE83SjNN?=
 =?utf-8?B?amF0TWhQU3Vic0QwT2ZTOThETGJjanJrV3NQVGV1TTdKSmNoempwWlk1ZFpX?=
 =?utf-8?B?MHhqdy9Eb2FsMkxnTFhaN3ZydlZabE1vT0w5VGVEb0JKOHdObU4zbW85ZGh4?=
 =?utf-8?B?TnFVUXBJTjUxVGYyVXd3OUt0V1cySGgwZG8raGhwQWxuYnNmMGFnUWcrZzB3?=
 =?utf-8?B?Zy9lTEJxYVpmZmh0NWIzT0V0djJkYXlVSW1HSHg2emxrOVB1MHNjNFpsRjl5?=
 =?utf-8?B?VXNGcG1sQnVNcFU2djFNUGRxOUVMNENxa0w1RHlteXVSdmxBbTkrczl1Qnl2?=
 =?utf-8?B?K3lpUVl6czhWZDFITmNrejc3UndaeEllWmRGKzRFODFQUFJNODBwMzJoV1dR?=
 =?utf-8?B?bU1ydTBkSWl1Z1JEYkVXazZNTy9tWmJES2V0NmRSbk5UYXNxRms0eGhiT05Y?=
 =?utf-8?B?cUE5b1lkaTB4cWYwR0xvMkN5OHpiaS9hOUhPT1RDRjVtcmxXSGVwUDFJWjJL?=
 =?utf-8?B?cTIyUzZXWnVWYXRJVEZqcjRnM0lFeUMrTTZ4V0daRmZFNENFQUpCaVJ3disx?=
 =?utf-8?B?YVlONXB5VjhnK0JlSjdGZGZON3VkRmlYdGNrMHh4dTFWYXIxTjBDUDlmNS9x?=
 =?utf-8?B?V2FoTmdKNnZ6ZXFxUWpiMTl3NkJ6TnUvSVl4M3JvcWZES09NdjZlOFlONjkv?=
 =?utf-8?B?UExYdnJUNEIrY1JiTkVJTXdVL2lNNkJ5VjdPcWFEU1BMaCt5b0hUdC8xeHZa?=
 =?utf-8?B?cUJSQmkwaSswSTJZcTR2ZVVRZEQvTW1GYlE0SEZDUitaNEliQ1U5L01jM1Fq?=
 =?utf-8?B?ZDJHbVRaRHNsRlJCUCtDdlRRZXdXblJEU0R5cGh5YUJkM1FMdFhHNXJDY2NW?=
 =?utf-8?B?S2Frc0dHUUozazFGWDJKY3NnTTVjd1IySnE4Q2dCc05jS3dtbkc2RDRzdGVo?=
 =?utf-8?B?T0E1eksvb0xrSTd1YWRlQkE5NEhxMjY2OXU3d0lCUTZhOTcrN0dLMERLKzFk?=
 =?utf-8?B?ZjZ4c1NUQVlZak1RREJ1eFlyak5ZT0Rac2pmV25kY0FJd0Nkc05reUlialIw?=
 =?utf-8?B?T2pDVEw4Q3EyNVhDZEp2MWYrUEdZd1o2UWRsbHdYMzIxUGd2eTdtREdJNWV6?=
 =?utf-8?B?WFBRUHNaZWZKQW9sS2FxeUhuT2xMdWpPK0dzeVdPNjY4WXlKSUxVbFhIVWwz?=
 =?utf-8?B?TEpvNk01dTY0VWtsazBSSE5zcGU5K3BSVGJtWEgremZVdW9IZTAyQ3BSVWpY?=
 =?utf-8?B?WWZReTNQNFE5Q21UV1JZcmNTelRLUVNxUHlnNHNZRVpPYS96T1lEdGNwSGM1?=
 =?utf-8?B?R1hnelV5aHFZMGtBWEV3ZjVuU2dFMDd2anArZFViRmRURDlSQUxBRFJSSEtZ?=
 =?utf-8?B?M0tJTHlnL1BwNzNCVFBKcndnK05jdlZpaVRWZTN6QXlGMVBnMzlmeEUyZWV4?=
 =?utf-8?B?ZjBqSTA1NytqMktkSzErNDRZc253VXVsVTRDdmt0dkFUTTJyRlcxOWg1VVpV?=
 =?utf-8?Q?ArPPYXySnKX8jKHz7YXTH6/Ob?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50e8d287-72e3-49fc-1e47-08dccae98809
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2024 00:52:33.9625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nbi4vLq9zo74aU1SAkcmGmuZ2XuQXp+ebkgC68qnfN9zMbXTWvHEVkRQhmztq0jwG3XFc6Yw/RS+dvzzhxQ2iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8752



On 29/8/24 22:07, Jason Gunthorpe wrote:
> On Thu, Aug 29, 2024 at 02:57:34PM +1000, Alexey Kardashevskiy wrote:
> 
>>>> Is "extend the MAP_DMA uAPI to accept {gmemfd, offset}" enough for the VFIO
>>>> context, or there is more and I am missing it?
>>>
>>> No, you need to have all the virtual PCI device creation stuff linked
>>> to a VFIO cdev to prove you have rights to do things to the physical
>>> device.
>>
>> The VM-to-VFIOdevice binding is already in the KVM VFIO device, the rest is
>> the same old VFIO.
> 
> Frankly, I'd rather not add any more VFIO stuff to KVM. Today KVM has
> no idea of a VFIO on most platforms.
> > Given you already have an issue with iommu driver synchronization this
> looks like it might be a poor choice anyhow..
> >> I wonder if there is enough value to try keeping the TIO_DEV_* and 
TIO_TDI_*
>> API together or having TIO_DEV_* in some PCI module and TIO_TDI_* in KVM is
>> a non-confusing way to proceed with this. Adding things to the PCI's sysfs
>> from more places bothers me more than this frankenmodule. Thanks,
> 
> I wouldn't mix them up, they are very different. Just because they are
> RPCs to the same bit of FW doesn't really mean they should be together
> in the same interfaces or ops structures.

Both DEV_* and TDI_* use the same SecureSPDM channel (on top of the 
PF#0's PCIe DOE cap) for IDE_KM (for DEV_*) and TDISP (for TDI_*) so 
there is some common ground. Thanks,


-- 
Alexey


