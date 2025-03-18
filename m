Return-Path: <kvm+bounces-41446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2163A67E02
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 21:29:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BD6F3B6918
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 20:29:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C22B212B09;
	Tue, 18 Mar 2025 20:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DVO5C1v8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2071.outbound.protection.outlook.com [40.107.243.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968FC1DE4FE;
	Tue, 18 Mar 2025 20:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742329780; cv=fail; b=MgcTrijfLcf+ji7Oalc5hdpLGb0WjS0SWd0SOF3Sq4Y/LHZ3ppvTca5UtVvGz/Q3hpr48OfdSyaDYvt7U8XjFBYtH/VpCBgRcY8zb1CD8bXksLs7vhxscpsr8nb96qN2XMiyBt7XTfvkAE6qNXklwWsYpV1wHVn8Jg6hpIs2qKE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742329780; c=relaxed/simple;
	bh=avraeXy79bqHAeGh9U2P73jRVIAxyCgwtqaiIPLOBTg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NkG5/4qGX5HJwwRdCkiPsMOehUeU+qlA+7qbuE0QwlH/QaK/3fI1+fQEAfe8FJCSi2nBINMpfj7cvN4j+n7KWWGfmEJUsYsDBEeJxeCwdtIQuG4gt+KzgdsHlgjfVQ+zFTpLQG2n/MHZC7HCRhwMWHphdiN/legvSJ4yEkBkHiQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DVO5C1v8; arc=fail smtp.client-ip=40.107.243.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ybIJLIW3NVttYrGY2RUJq56wXeKbhHi19rSCKxD15JShupe5MDm+P+/b9to1GKLp+taQ8t6bVofEh2Cl3o5SggmLHc1qAwglH/UKs4JgsFjI4DUW7CeMwO9j3hgeJs7UctNNootJ1F/TIU8wGxTH2Oo/43wEBTWNltx3e0js3F1ysX4V2NpxvGUIlL3p6gKKQ+XyVc8Nko/Tlj62FrQlAn6bAL97r6q06VYKarYMUJMb7tnJ++EvEoiSajtl4IOXt4Khzd+UBn3F3a+7ap9lYblzRMFH3Yjiu0SkNfYpirHn9zXM8xJGaINbc88/49tYdBaPs/xDFVzshPuOTD37Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GFkfEycJg/5vlpyQxxl6UoV7M61/KUwUyOf40eO5ONQ=;
 b=lwSWtDeWLpQ2n01jdXzEK1aXbCW6KNJ446C9TZypCxKRhvYPe8OfVBd1gT+4qhL/0upr//F97OWfnxBQ8yPqnu9q9yoIFbisbGI+f8uFCHjFNxqJa+wJuLvNLT+EZKR2BOyv2cMN4KcDQsAg9brj+AQm7a1UeASIWbZ3+VfN3PcTgOGBkzs63qzfATIPSq4/qAvGoVRigYUwyx6m09I7k1WF38HKRAXvcm7/55aOIvSNdpDZ5A/t8yeQqB0qD7gkuA/eoar51CT/0nXUtrOzAOyBmmLVRi1x+aY6tmyNcRZ5RLxyjCGG74XSUjTqvGmGzzHlTDA0WLuwej/3GQ3lxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GFkfEycJg/5vlpyQxxl6UoV7M61/KUwUyOf40eO5ONQ=;
 b=DVO5C1v8/f945eVthFFlvx9AiqcJLIMvT8sOzegTmjh1WUYDlbkNK9Q2PHASbVb94t6iVZiKwLaOQJyOLcsD5x7lXDSpU1IgeMRxNtEXS7u2UPFSYD61MxkF0isvELlEJZ5VSRve1F5yCSIt2KRKIxpvFO3C5dVk8eYp1s6aPjY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SJ2PR12MB9008.namprd12.prod.outlook.com (2603:10b6:a03:543::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Tue, 18 Mar
 2025 20:29:34 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%4]) with mapi id 15.20.8534.031; Tue, 18 Mar 2025
 20:29:34 +0000
Message-ID: <93e7bd21-b41f-8d78-f9d1-1868e944efc6@amd.com>
Date: Tue, 18 Mar 2025 15:29:32 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2] crypto: ccp: Abort doing SEV INIT if SNP INIT fails
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, bp@alien8.de, john.allen@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net
Cc: michael.roth@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
References: <20250318200738.5268-1-Ashish.Kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250318200738.5268-1-Ashish.Kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0109.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c5::26) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SJ2PR12MB9008:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a879b60-fc8b-4508-f37e-08dd665b9878
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QnRla0NUaWRZa3dwNFlwUGdObWN6UDBsM0M1Z09pV3R0VlNZSk4wNXFsdkkv?=
 =?utf-8?B?MHdGRENFZVNPRS81ZXVacXdPZFVDZStRdnVOVWNZWXFNcVg5Vm10aWJlN3Fs?=
 =?utf-8?B?WU5tMU9kamFjNWRlRktIS3YvSTZaUk93bGIrVGVsTGdYYTYvNUE3TGRGRzZH?=
 =?utf-8?B?Z2xsQkMrRnkyZnFKWEVPSW41ZHVnai9Ea09PYzd6d0thNFVrTnE5TW1IOUxP?=
 =?utf-8?B?eGhhaGNEYmtyeksrZDRoTTIvR1NpYTlsK0w5OFF4S3BOR3Z0UkdJV2Vwd05q?=
 =?utf-8?B?VVNxcjlTbFNTeGY4Z1REblN6aXF1Q204RG1XZStlSVZ4TWR0RmJ3T1VhSHJt?=
 =?utf-8?B?YTIwODdZNUlBWDJGRmNmK2NHR3hsdThJNyt2Q2NUdEpEeGUrUThzOWlmQm1Q?=
 =?utf-8?B?dTQ1RjhTVjNTei8vZEowSEZoL2lNS3UxRFJkeGkxYmhkT0FFemoyN1BqSG1B?=
 =?utf-8?B?SFFxMnVvY01JeHZNMWYxTGlsd1JhV0pydW45YmdzSGp0ZEMzYWZCc1gvdm94?=
 =?utf-8?B?ZTFJYnlZdEkxNjlFOElWUitUT2ZIZjJjSzJFeW96S2xrd093SFFCSHhQZkU0?=
 =?utf-8?B?S0wyZGZoSWpnYlhxdWsxTHg4MzRFWktZcEMzN3JXaUJvamNJWWhRbDJWMjR6?=
 =?utf-8?B?SzNUVmxLeW1lK0h6eHEyYVpuL2ZxM1ZYQ0d3STMxNC9NQ2lFQ3RiUFRxdjNG?=
 =?utf-8?B?NzlCNDdQNDR1L1RvZnd0Y2dHS1NRT1ptMDJkc1puaE9QcThrQVAwdStzVHY0?=
 =?utf-8?B?QTRjdUVIT01Xd1ZRWW9mQThObzFVK1YzWnh4WHdqd3l3TzhqM3N5bjFCMHhj?=
 =?utf-8?B?a3R4bFYwOEZIUVE4d2F2NWRyY0JuVTJPQkdmbk1xTWlyOWRzWTJOWUVneWFS?=
 =?utf-8?B?emVjVGVFN1hXemtiV0tKTTFvK2lKT0xOd3VjNXhYL1ZQa2x6QUJsL2M4L3ds?=
 =?utf-8?B?eCtUSEs5bTgvOTlrZ3JOM2RiMXFEMUlUR2kvb25xamNJeFhvTSt0cWlPcmVY?=
 =?utf-8?B?djB6Z0MwS3hTTksraytYdjZidk80eWFqWG1UWHpRb29zMFc0S1duWml6SFp6?=
 =?utf-8?B?elhaa0hUeDJ3WFZielQyOUxDZ1ZJUU9nRGV3ZnBSQUlwVGNlK0hIMmVMdkRZ?=
 =?utf-8?B?RDBwNnZINVpuVjAvSXNZZ3Y0R3BHN2tJTWpMYWdTaGlWNFZ6V2JOMkllR2cz?=
 =?utf-8?B?dkNuMjZ3ZFlzbUNqL1IrV2ZiZ3dVVWdXR1U2anJoeW84UmNGSjBoRXkzZEd6?=
 =?utf-8?B?Sk4zbkh0TzQzYm9paHJoS1J1K0dBWlJzb1VqcW1hVVErRjByMkJ0SnFmcDV2?=
 =?utf-8?B?NGNHWkY4R0JvRUlpSlFzRkN1L2ZxTGEzejZpY2tEWmxtanZENUZpd1h4YWwv?=
 =?utf-8?B?dTRjSFJEQ3pyMVF4SUZaUzV0NTRmdllCVkxib2Z4cEg1ZXJtRDZZUEVtKzRk?=
 =?utf-8?B?TTBwY1YrMHVxNFZXaUU4ZTVJNGhaWWJsbXVzeWowVm9mNXEwRDZMcFFQc2ZP?=
 =?utf-8?B?Tytmb2VQbFVaQWtmQi9lMStKNXlJWEhmYnEzOUM0WFpmaVliRGdlWXZuL0ZK?=
 =?utf-8?B?NFh3Z29mZjRZQ0RuQXhFeXE2VVd5eWJFbWNiWEo3czhDTG1uU05xMGU1SE5m?=
 =?utf-8?B?RTQ0SC9udkcySjdlbzNWeXVoTFZrQXJKM0Q4WTA4ZXN4bmJUckF5YU1RWGRa?=
 =?utf-8?B?cktFbWZIUTFVSUk5ZHBIMUhiWUJyZitzbFJnc1NTSHNjTDJWZ3VHM29aS1BB?=
 =?utf-8?B?MnVNT0M5eTUzL3I2N3paa1kxc2k3eTRORm9jQkhDWVVIUVJKdmtVaHhWUmtk?=
 =?utf-8?B?VGJuaVdYKzJqejU4QkFMT0hpN0dKT2V2MDd4aTVtb1FwWFZyQVRRc3NtbW8w?=
 =?utf-8?Q?mX+41abdeyQoC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WHlMS2dBUm5xdUQ0dGx6WXNuYTBjU2cvRGdPT2E0V2I4aEdGVDFFUjU2bEEw?=
 =?utf-8?B?SWF1OCt2WWtGTEFWYUZvT2t5T256M1ZZdFBiSjd5T0ZuYjJ1alEvZGsvTW9F?=
 =?utf-8?B?VkhZNlBkalhxWjZpTUNaSVFHQzFYVE9HbkUwS1dod1NaNW81ai9maG8wYVVs?=
 =?utf-8?B?N2pJSDQ1RDJvWWhiRmdmUXcweVpORlpnNThSQlFQdlZwMldIUkpqcFVKU01O?=
 =?utf-8?B?bS9rUFoxUEFBRGg2Wlp1Wmg3RXdPWUozc2hlM0F4VFMrR1M0ZHJNeVFXeTFl?=
 =?utf-8?B?NUU3WW83VXZlWVFkbWZWTnc1eTVtMkJUdkZBTkNWSnhwTURJbTlSQWRnT0N0?=
 =?utf-8?B?UXdVQW5oTnc3VkgzRldhTkszQTJTaFV0YmRUSERrL3MvNnFsOHBBNkp3OEtN?=
 =?utf-8?B?S3NKa1BGeno5TWtDaWJ2aXg5TWtPSDNHVTJjR3c1SFNraVloRjlLTm1xaGxE?=
 =?utf-8?B?aisxVmU5SStaZGJWSnRaK09icXY4MHB5V3dYbGF4TDNEODlLS2RRVFJRTU5W?=
 =?utf-8?B?R245aTNDRS9CVEJpaWE4Z2d6bG9aQTJySitFaG9nTWpMTUF3Y0xoL2h3b1NC?=
 =?utf-8?B?OGFiZUVuQjRIRTlYUHZ2bmdjcUF3UnhIMjRULy9maC9McWp1L3JrS3dlUW1O?=
 =?utf-8?B?VlFJU0hxZFZqbG83ekI3WFJWUlBTQThhdzEzTUoycGhJbjc2cUJqcXhhQ2gv?=
 =?utf-8?B?aWZTb2lHT2xQU2pJMFM0MUE3NWlpaC9CV1hsYldvWHhvSlVPNXk5elJSY1Vj?=
 =?utf-8?B?WHJ2Zk5XdkRnT0gveUlpeFpnMlhhdkhqSFR6S3VJVmFLR0tUdmR2eFVMRG5p?=
 =?utf-8?B?dmdSdEFNL3lrd0V0MjNEVC9hNW9uY0RmVW1qcERqVWtCc0xaWXJaZWhJaWZh?=
 =?utf-8?B?dUdaNWJ6amZianZjVzAvTklkcmxNOGhWeFdKNDc1Yk5yMWNsWm1FZno3UmtZ?=
 =?utf-8?B?YjErRVJFWmZsTi9IYWdDVnd4aG11emVjeGUvaUx3am5sYU1YdldlUmxYZllJ?=
 =?utf-8?B?djZXZnJlWXNQbUVWclFiL3ZUTUFBUU03NVJTZ3ppWllsYTlGbllOWTR1YnNC?=
 =?utf-8?B?S2w5Sk1CZWxFRXA1LzVKeUwrRjV6TGphbjM3RTBueEF3Q1NERDBsTWdIRkNB?=
 =?utf-8?B?WEZxTE1jbWlCU1gwZ1ZnZXlOUHJOMko3OTUrbko2ZmRBQ1IrK0Q4cVpTWkY1?=
 =?utf-8?B?RGR4MzVDckFGalJkYmF5VmpzaU5VM2I3TTlpQjZGeS9vVE9HeElRMVpUV29k?=
 =?utf-8?B?MVNINm9ydC84SEhTVWtXM1lJbnhwclE4UEVYTmFEbTB0WmRzczRIb3ZpTHVD?=
 =?utf-8?B?TDUyOUo3Vkt6RDdJWDBtblp4VlhoNzZWelpmQlNtK1VudkVwK1Vucmo3UGth?=
 =?utf-8?B?Zzc0VFdLNXlXNFB3U0ZhZy80RHBlWmZWT2JpamZWRWhLcGViZEZxSWpXbHl5?=
 =?utf-8?B?S1dtNEY5MjM2Wm9QVXd2c0dJVUlJcU4yTlhYNXRka1VnYjlIWkVCMEp2Um9a?=
 =?utf-8?B?bzhISXNYYXBseDZiMlZoMGtSUDdZWXRGNm5CYUEzY05HU1NjTkMxM3AzdGV1?=
 =?utf-8?B?T0NFblEycXNIUkxvVlU0aEpodjdSbmphKzdmUE5MS0dCamFqUUM5THRXNGtW?=
 =?utf-8?B?N0VxUDliSEVXKzBwMzl2d0IrSEJjU3UvSGM2OEJXRHA5WDZmbDR1TlhHelha?=
 =?utf-8?B?cnB0MVZXcDJsdjk4cWtvTS9hcFZ6N0lmRUxXVWhQNFV1MTJ4YnFOMi9CNDlU?=
 =?utf-8?B?bGtCcXVaaE5Xc1crQUJYR1NHazVpYkJVSmJ1WlUwa253MEhkS2hlazdwREVW?=
 =?utf-8?B?Q0l6a3B2TUJtSzArRXd1cTdqZjcvSzRhbGZ3Rk9QYXhoQ3ZKS3ZOUjFMMlN5?=
 =?utf-8?B?TkxCL09rODFWTlNkcWN3bk8rdmwvU2Z0VEtFUFhRNU1qeFdxVkVnNXR6Mkg3?=
 =?utf-8?B?ZGhpbGtQYVNrbGwzYTdVay95RTRsb2E0UURodW9MZWhjL3Q0UmJZaUJjTlBV?=
 =?utf-8?B?Qzh5ZVJtNDlsd2EwaThCT3BOdmVlTUdqZXhtWDR3Q3BoMXFyaFZvcENGNTVy?=
 =?utf-8?B?bmxpWDh3Ym4wR2V3MVJlMWR3SXd6a1gvRy9JSTMwWXpUdnFWM2FzSTBoekUw?=
 =?utf-8?Q?5tbneYEQ5z+NmVDUbbqtzs0NI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a879b60-fc8b-4508-f37e-08dd665b9878
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2025 20:29:34.4391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gd9mljXGVcIjgVcD2cHjqq0n7wRcS9DSaMy/rfTvJ2yc7eWld6pnzra7jvrXuBeD37KXH1k+pE0dW2XsqYLo8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9008

On 3/18/25 15:07, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> If SNP host support (SYSCFG.SNPEn) is set, then the RMP table must
> be initialized before calling SEV INIT.
> 
> In other words, if SNP_INIT(_EX) is not issued or fails then
> SEV INIT will fail if SNP host support (SYSCFG.SNPEn) is enabled.
> 
> Fixes: 1ca5614b84eed ("crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP")

Just wondering if this really needs a Fixes: tag. Either way SNP and SEV
won't be initialized, you're just returning earlier with an error code
rather than attempting the SEV_INIT(_EX) and getting back a failing
error code.

Thanks,
Tom

> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> 
> v2:
> - Fix commit logs.
> ---
>  drivers/crypto/ccp/sev-dev.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 2e87ca0e292a..a0e3de94704e 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1112,7 +1112,7 @@ static int __sev_snp_init_locked(int *error)
>  	if (!sev_version_greater_or_equal(SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR)) {
>  		dev_dbg(sev->dev, "SEV-SNP support requires firmware version >= %d:%d\n",
>  			SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR);
> -		return 0;
> +		return -EOPNOTSUPP;
>  	}
>  
>  	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
> @@ -1325,12 +1325,9 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
>  	 */
>  	rc = __sev_snp_init_locked(&args->error);
>  	if (rc && rc != -ENODEV) {
> -		/*
> -		 * Don't abort the probe if SNP INIT failed,
> -		 * continue to initialize the legacy SEV firmware.
> -		 */
>  		dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n",
>  			rc, args->error);
> +		return rc;
>  	}
>  
>  	/* Defer legacy SEV/SEV-ES support if allowed by caller/module. */

