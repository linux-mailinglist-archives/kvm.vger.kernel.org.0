Return-Path: <kvm+bounces-19660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D10B49086B7
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 10:49:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5941A1F22CD8
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 08:49:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CB8119149C;
	Fri, 14 Jun 2024 08:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HcgCCHyc"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2063.outbound.protection.outlook.com [40.107.102.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB24191495
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 08:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718354953; cv=fail; b=uUDdn+gb1YDqTybcdiC6q1mZNIZCMoKGKmsCmd1PbC9qG9YISIdioyr26E1XM26HUlNY4/5bEPE7LVz06TbMANA+5Y6O+Q7m1Kd+aElT3OS/Dk68b5Myy6J/G348D5mZry7O44OUlJHiF8+o2OFWz00KFB532KhT3qJiRGB0qrM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718354953; c=relaxed/simple;
	bh=UDwhD2fFxyPNhe5S0Ks2WZHesamDLZoGM6rroyMz/sA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PSKAqnjaDU2Av1bf4fZhIgOamM22JM50apnLsha0Sd39RLGjjmdsZFSOnNLGg4Qn8bgVLpbuHvaQna1fRZiE+3xYPKjFubT+UOdBcy/rvVazOZhtXvi+k6xTEzkkiupBwsJvolNr8B/MRa4VSxkoA2kesec4UEkf52yG9S0U3N8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HcgCCHyc; arc=fail smtp.client-ip=40.107.102.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BXEbuyoZ5taqv8uLASIG1OdHkIvMyCC8MR3GSV4A0im72GUTAk5FszVQY4ogL8gYnYrcdz8xIeoj7J/B1pn3v1KtX/RUuklqNVbSSptn39U/mPH3qYsOd1Ea/SdqpGB9Wm1Go/qJa5/ZYpCob8LOwhHzI9zqNwxEdLv/zWPAsJUff31uW7uUsGCGko4/tBCvPf9eYmj4nyfKKf73tbaqcjEYMHLOICc01hQS0f9bpxN2D95vPgM6JOd5LxdZ2Hu8Qg/3wuhpWB3aFmJBs2ZR2F7Y9U+++jEkLcf1vsyZFbFeKAeBFoGc/6HG84Vw77q13bJkgfSKmj+1XfqXXY66yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zITrZMFTD19sHUWQyfjufNDpD0BOyM9v+fd9/UVOcLc=;
 b=iRppNc/Hat/yVkkGURqL7eAx9d5yNRwOpOa36J5m6RGq1w+jN/VZoke0E5ykrQJdErff24YC0bk1NA/+qKrVRi8gvlRIG8mZ3mogfBwX1/70mgYONKPBQ11TiD6MB8UjmlGxy3fAlNmBRI/bVjFnnmMj0p7305UVDwl3dLig1QB+BGc6qgbyncvDBpBzlirvnMmPX5dUv3ob18Ye0jis7KUXWSYVBRmZRS++G8PHNSGKryfDm2Za+miLvh1Ztv2IX0gzq1HqCrgflpmsXEaESIiicJcp7yVZxhSF7K1EB2sIeu52+AdxKGOi50cmAmDZWZlVF3cI64RthecxWa8wAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zITrZMFTD19sHUWQyfjufNDpD0BOyM9v+fd9/UVOcLc=;
 b=HcgCCHycpAbaFtY2dR253OKLojIStXjnw//WADElzwFMhT4u+9hB7DtKc7dAztzWCF8K8nScZwwW5vrRY25BJeUtDw56E+Fb86butMH56IFz03gDP3zYH5dvM+jK+W8Yf6O2SaHcsX4bMHIw0zBqkDygqjM7YWujPOge4ZEXWsw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by IA1PR12MB6259.namprd12.prod.outlook.com (2603:10b6:208:3e5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.20; Fri, 14 Jun
 2024 08:49:09 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%5]) with mapi id 15.20.7677.019; Fri, 14 Jun 2024
 08:49:09 +0000
Message-ID: <a93b94b7-078e-0785-7fb5-e1fc85832aaa@amd.com>
Date: Fri, 14 Jun 2024 10:48:57 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v4 28/31] hw/i386: Add support for loading BIOS using
 guest_memfd
Content-Language: en-US
To: Xiaoyao Li <xiaoyao.li@intel.com>, qemu-devel@nongnu.org
Cc: brijesh.singh@amd.com, dovmurik@linux.ibm.com, armbru@redhat.com,
 michael.roth@amd.com, pbonzini@redhat.com, thomas.lendacky@amd.com,
 isaku.yamahata@intel.com, berrange@redhat.com, kvm@vger.kernel.org,
 anisinha@redhat.com
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
 <20240530111643.1091816-29-pankaj.gupta@amd.com>
 <434b5332-a7fb-44e4-88f5-4ac93de9c09b@intel.com>
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <434b5332-a7fb-44e4-88f5-4ac93de9c09b@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0136.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:95::9) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|IA1PR12MB6259:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f0d18c6-785e-48ee-f0b7-08dc8c4edad8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230035|376009|1800799019|366011;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c3kyczJmQW1WNnE5RHBHNXZCdHBxV1FVbjVsZVNudnM1ZHRyQW0wckVaUHNm?=
 =?utf-8?B?aUpzK0RNNFQrN0d5NHppRGtBeUhhempGdmhZMUNmaEQ4bHFJY1FoSDEwWkZy?=
 =?utf-8?B?eEFrVjkzNURQQzZFVkxtWTlVTGZIdHJoSWlzQllxL1krSCtvQmFMSWdLd2Ji?=
 =?utf-8?B?b2RmUVFCRzgvSWt0N3B2MUdOVllYK2JNSFptMWNuY09uWlJZVDhNV0RMR1pV?=
 =?utf-8?B?ZjNDcjJxYUh5bDdUKzVlT01VM2hkZ1RGVW9ZTFRUcHh3K0Q1ZUZXbFJRQ2Zw?=
 =?utf-8?B?cUJkM3FQZ3dybXp3MjgyNTlGeWsycUhMNXRESzJ5dGpGTXhoYzBwbzhSb254?=
 =?utf-8?B?T3lCdmpKVmRLb2VMQVpCamRHUDlVdWI0YjB6aXBKV3hubHprU0xyWWpNZTNu?=
 =?utf-8?B?djI3Wm56QmYwK0J5VzI2UkZnOVBxNm4yc0N6WE5PREpINHNaenN5dlcxRmtU?=
 =?utf-8?B?bk5oRzFCVkFXWi93OEVPR1FrazVzTVJZRWJxRXJORzYxWlZGaDBnSnNwTS85?=
 =?utf-8?B?U2RqUWFLZk9KQzduUEcvcTQxVzQyZ3c2clY1UEZUbndqMTdJd2RKMzI1eXVs?=
 =?utf-8?B?OTNLUDlzRkFzbFVUeDErTGNNMHVhS1hBSlVhL0FwRzBtaW1zL3NtU3dZelR5?=
 =?utf-8?B?cUdaK2w1eUdBckQvdXo0N0J0ejlQOERBWXA5WklCWUFFY2VnbUdCZm1OcE9P?=
 =?utf-8?B?aUVZR0s3K2p1Y21iNVpJZ1BkdjAzdXcrWURGQXBFOElTaWRPcGpYa0lsRysz?=
 =?utf-8?B?SklGV2N6alUybXNWbUR6L3draE5TWEkyUDB2SURWQy9OUG1GVGtXUHN6WXRB?=
 =?utf-8?B?VFk2ZlVyVkJBQi9tWVp1UklCMkp5aWFUUXFHMUJUbCtXTlQ4VTVaZEZNTkZI?=
 =?utf-8?B?ZXRQZ3VDeWxkZFB0bG90QUovUmdPWTRLUlpud1VvWnBpTDhDK293RmwwbENm?=
 =?utf-8?B?SGZKS0tyN3ZpVTc5YVdqM1JrTEoybUhIbEM0SmhNUk5ueXlPUWZOUWY5aEFC?=
 =?utf-8?B?RzJSdFM4dGsvMWNIcTA2MEJXZ2c0d21Gcy9BblJadkh0cXY0TXM5T09pNEZk?=
 =?utf-8?B?bldrMHBTYUJKNXZlc1FnVXczb2V6eDcxVGk3UGhTTnBzZlZNTVNOdHRrTlh6?=
 =?utf-8?B?WXVjM3dGTlZrVDlORk10YTFoUnltVjNQRDJsdCtFc0t1NjkrSkd6dGhMTWlR?=
 =?utf-8?B?OWRYQlVhUFhRS0prcGhBMjF2UnNNWFRVeVpKMlFMWGxoM3N3MVc2WXRlaGF2?=
 =?utf-8?B?Sm1NQWx2eGNqTUJmazRkTEo3b3VjOWRxN0lndGlqR0ppaFcrcVZ1NFA2RTdY?=
 =?utf-8?B?Sk5aTElMNThzaWJtdTZRZUFnM2tTZnNybTVyZExua0NXTjQyRnZCaHdWak11?=
 =?utf-8?B?REovUXhJNjNVWmV4M0Nsak5nSG5KZkNBellmRGoyRUlyOXd1WW9VcWQ3NXRL?=
 =?utf-8?B?TTFKVDBFLzBsZ3VqdWowTDcxelFidTNRa0pFbDBPeUZ5L3AwbWtKWDljMEZn?=
 =?utf-8?B?WmRYOEdTMW9XSjA5YVQ1SHFRUk4yOUhuc3ZoNGVwTDBKVnU0eW5oRFNQaC8r?=
 =?utf-8?B?eUhscThDcVh5QnM2UWh2NjBYU21qQ05hR0JlZkJsTVVxSXBKZ2hjenJuMzVo?=
 =?utf-8?B?VTd3YVpGTVVCNk5scTBmSjdkREowdmIyVWgxU0dpVm5UN0VnYTYyU1dSZGdV?=
 =?utf-8?B?R3VHN2tzS0hValA0ZmRNT3BOZHJuK1NodSsvZjlqM1BZNldBYWdsaE1MbTM0?=
 =?utf-8?Q?kypaxZ/u0nbJB1mUt3zfoskhFe5pjuyD/raBR7i?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230035)(376009)(1800799019)(366011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Njc4S0ZSNEFGa0ErdkdWNHlnVklXZ1kwR2lONFJ6N3lUZW1Cb2ZsbEZJTVVw?=
 =?utf-8?B?OGlTTWdiRU42SnF3S1lLaE1pVy9nWXVQNnJ1cXNhdDgxRnRiNU5lendaUWhz?=
 =?utf-8?B?NlJWR1EwSldncHhQdjlLWE9uUE9EajNoYU5QaFVDS0ZWSGRScTR1M3BQbHUw?=
 =?utf-8?B?dXRmS2hBNmQ2dkhJNDRvbU1zT1IyT0ErUWNpbUxQVDcvQVRheFdRcTNNVEZ1?=
 =?utf-8?B?UjFkQUFlVjZtVTQwWjFaUTBHZUhmY1dzcUZPZ2xxYlU1S1ZScStUTnZLTWdi?=
 =?utf-8?B?eHZzbHRzRFhPd1ZZd2xacW1yY3g5S0ZuUDFSMW5BaVFLaVpyeC9tQzFqWlBx?=
 =?utf-8?B?YlBIczFwRnBvNXBRemwyTmE4ZnhoSXloemM5L0l2OWdFdG01T0VSYkxRbFYv?=
 =?utf-8?B?YVFKYW9QUmNnNEcvQk1sR0VHbG13YzBsSlduTGJIMER6aDVlWmJIaUF0Unc2?=
 =?utf-8?B?aWJyQUFscEd0Zm54LzRGejNZTTd6MUhQa2VIelVuVjRiTS9WUk1XTHExNmZ6?=
 =?utf-8?B?SWFYUDB5K1RMeC9zYTE1SERDc3dBeU01emdYNXNYQnh3bmh1cXMrbFc5VGZD?=
 =?utf-8?B?UDMzaGRqUUtTcU1wT2Yyby9xNHBnRnVzRzlyaUlvaUJNVTdYSGYyeHlmMUZ1?=
 =?utf-8?B?ekcrWE4xbmNKTHBUd05rd0g3bG9BR3ZCb1FnZC9YN1lzRUZoRUxYOEFpd1Q3?=
 =?utf-8?B?aWxzR2RaTDBKLzcwZzExaGNyV0NLejhCVTVocDAzTGR0eWFZRHFGK25aZk5u?=
 =?utf-8?B?OTJBbGYrUnp0Mkp5SWVjMGI3VCtYaWczK3BlNlJIZ25jc3IrVENPbkxzWWI2?=
 =?utf-8?B?V1dGTGZkUWRZT09BS25NNU5TL2pDNFppb2pWWGFFeUx4Z3Q3Z1A3cmtGL3Bw?=
 =?utf-8?B?eGhyT0pxcXEzSzdLbjBERlczR1FSOXdsVUZ3MktXNFFObitvaHZPTWRIWXVi?=
 =?utf-8?B?NlpHRGV3SzdjWEoxSE0yZkV4SG5MT0ZrV3lzZ1BJQnJzM1VYekNiUW5PMVZ5?=
 =?utf-8?B?K0wybUQ1djNndkNoSG85YkFLbWJoaHBPNjd0LzZ6N2xHb2wwTkt1b0l5em9C?=
 =?utf-8?B?eklWcDdndll4ZCtSSXpKQ1h3S0FDS2Z1cmowa2xDOEJwSGpEWE1TNlozdTBU?=
 =?utf-8?B?WWNQa0txdGlOMWd2VHJYYTQycnJHRlhuVUYxSGxDZXF2RlFjcGJlUHpOVThU?=
 =?utf-8?B?Wk1MU0VCUXdkcWtTQzhuT3dPUGFxWnYvSDhqLzJCWnRvb0V4ZFQwY0FzYmdO?=
 =?utf-8?B?aVIxRzdtSjhpYnc1QVR5S0J0TmhSN1NmenByZlgzakxUeFJTbm9uQ3Q4Y3k5?=
 =?utf-8?B?ZDhXVFpjdmZmVWdhWWpWS1d5VWRldllLd3B4TnNqNUhYbjdzb2JhWHA5ZVZJ?=
 =?utf-8?B?Q2FaczgweGpsenpVaCt3QmtKNSsySUd2eDdZMWhJUFFaWDJuaGhCcXEyQTVQ?=
 =?utf-8?B?c0RINGtScmxldGNWMldPSEpHZUVFYzRYM2ViTWo3NllVbUcyamZDQ3Roci8y?=
 =?utf-8?B?K0FTT3pvVS8zaEVwWnFPNWJPTHk4SEJlVWZXMkpFZzBvZ0FoeWcwdjBYNWhV?=
 =?utf-8?B?ZU1tRmdlcmQ4eXhkdDY0VjRFbTlVMzRxcFFaZWxDUUJFY2FkTmpFc1ZLdytn?=
 =?utf-8?B?SzZ3SG9WbWlxRTJxTXpBY3RxMU1YQk9HbURyTHh5d1M2SzNFeWNuaXBkS3ND?=
 =?utf-8?B?djRjL1FzbnFNaUpnQUl6YVU4RTE5WU50cmFFQ2hxOGxzM3kwMDFPQ25MR1V6?=
 =?utf-8?B?bjVIbHEra21RTmRBTUpqUDZLSnBDaWgybTNmSWdjNS9TMHRUTzJXL3BSYnk1?=
 =?utf-8?B?TnU2QWZsalBpbjJxeGxVcytBTWxMWkxPNmtVOWxYN0dhRmplTk9uRGpvWVh0?=
 =?utf-8?B?Uzlwajk5MVpyM0xJWlNpMWdyOEJvYW8wRFhyVGp1ZVNIVGthczBzd3lqaDBL?=
 =?utf-8?B?MGFJL0RVQW9KWENraXZSQXQvcFBnYlRwcGJDMTNvdHdPakIyZHl6VW1sbTcx?=
 =?utf-8?B?QklKVTVNRy9ZUDBuL3V6bVpxNkJPcnI4SW4za285Z2twcURwa2pJczU0dXY3?=
 =?utf-8?B?Z1VYUVNtZzIwRFB6a3hlOHViY0ZKelJjeDdWWFlwNkFVYUV4TklhQjJwT2lr?=
 =?utf-8?Q?NPEsqe9XxX/bkj1KGXpJiUMxR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f0d18c6-785e-48ee-f0b7-08dc8c4edad8
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 08:49:08.8852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lw99KEiRsQjlm5ROEIzKDWSmLpx1R685/I7Y826zJqSMLGUHcIqLWuq4tBS71e4ksnvHgwNaE57lUOxQZfuDtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6259

On 6/14/2024 10:34 AM, Xiaoyao Li wrote:
> On 5/30/2024 7:16 PM, Pankaj Gupta wrote:
>> From: Michael Roth <michael.roth@amd.com>
>>
>> When guest_memfd is enabled, the BIOS is generally part of the initial
>> encrypted guest image and will be accessed as private guest memory. Add
>> the necessary changes to set up the associated RAM region with a
>> guest_memfd backend to allow for this.
>>
>> Current support centers around using -bios to load the BIOS data.
>> Support for loading the BIOS via pflash requires additional enablement
>> since those interfaces rely on the use of ROM memory regions which make
>> use of the KVM_MEM_READONLY memslot flag, which is not supported for
>> guest_memfd-backed memslots.
>>
>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>> Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
>> ---
>>   hw/i386/x86-common.c | 22 ++++++++++++++++------
>>   1 file changed, 16 insertions(+), 6 deletions(-)
>>
>> diff --git a/hw/i386/x86-common.c b/hw/i386/x86-common.c
>> index f41cb0a6a8..059de65f36 100644
>> --- a/hw/i386/x86-common.c
>> +++ b/hw/i386/x86-common.c
>> @@ -999,10 +999,18 @@ void x86_bios_rom_init(X86MachineState *x86ms, 
>> const char *default_firmware,
>>       }
>>       if (bios_size <= 0 ||
>>           (bios_size % 65536) != 0) {
>> -        goto bios_error;
>> +        if (!machine_require_guest_memfd(MACHINE(x86ms))) {
>> +                g_warning("%s: Unaligned BIOS size %d", __func__, 
>> bios_size);
>> +                goto bios_error;
>> +        }
>> +    }
>> +    if (machine_require_guest_memfd(MACHINE(x86ms))) {
>> +        memory_region_init_ram_guest_memfd(&x86ms->bios, NULL, 
>> "pc.bios",
>> +                                           bios_size, &error_fatal);
>> +    } else {
>> +        memory_region_init_ram(&x86ms->bios, NULL, "pc.bios",
>> +                               bios_size, &error_fatal);
>>       }
>> -    memory_region_init_ram(&x86ms->bios, NULL, "pc.bios", bios_size,
>> -                           &error_fatal);
>>       if (sev_enabled()) {
>>           /*
>>            * The concept of a "reset" simply doesn't exist for
>> @@ -1023,9 +1031,11 @@ void x86_bios_rom_init(X86MachineState *x86ms, 
>> const char *default_firmware,
>>       }
>>       g_free(filename);
>> -    /* map the last 128KB of the BIOS in ISA space */
>> -    x86_isa_bios_init(&x86ms->isa_bios, rom_memory, &x86ms->bios,
>> -                      !isapc_ram_fw);
>> +    if (!machine_require_guest_memfd(MACHINE(x86ms))) {
>> +        /* map the last 128KB of the BIOS in ISA space */
>> +        x86_isa_bios_init(&x86ms->isa_bios, rom_memory, &x86ms->bios,
>> +                          !isapc_ram_fw);
>> +    }
> 
> Could anyone explain to me why above change is related to this patch and 
> why need it?
> 
> because inside x86_isa_bios_init(), the alias isa_bios is set to 
> read_only while guest_memfd doesn't support readonly?

I could not understand your comment entirely. This condition is for non 
guest_memfd case? You expect something else?

Thanks,
Pankaj
> 
>>       /* map all the bios at the top of memory */
>>       memory_region_add_subregion(rom_memory,
> 


