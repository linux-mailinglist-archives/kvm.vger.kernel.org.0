Return-Path: <kvm+bounces-25437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EA3D965613
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 06:00:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F6C31F244D1
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 04:00:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C72214A0B6;
	Fri, 30 Aug 2024 04:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CB0xzDIG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2070.outbound.protection.outlook.com [40.107.94.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9DAE13777E;
	Fri, 30 Aug 2024 04:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724990444; cv=fail; b=DtRfh5ldbiqyQ40Cr7WVZGBaV1osZlknwVtz71sP/lEezs6tqcl0xQzm5fhBfOkRBYUguqi6euIS+NqWnnfEvNztPPz9/D7GJfGs1+BA3cfEJKb156IjCKZxRplnjV+lWTy3NZ9LKe6+R5T+Inxrq2riaGcjIH0r/L2u5qscDPY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724990444; c=relaxed/simple;
	bh=642ktz8PlbsyB/ti1q98vMXrijk+CvcoQTQ/dceJXMg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=krayDWDSiPeXX6F/sMJewPq6tq5tqi46MdkTbcqMpOaLgtYSoZsuLb9KF1teU7as74w6do/4WxOer9pZQbPxAftg4/1ukCT8TFwm0FOxXfgaHQrQ3Fl8TdCLqVec4bXjbBD2n9/GWwfX34YnA/ycXcsgNbUcISZYrof5GyV0Us8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CB0xzDIG; arc=fail smtp.client-ip=40.107.94.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jxlDb0cT/a4nTX811kslMVz9m+ug+c1NAPQ6EA8f4U4VBsLVTE6vTFdiimTXBkl7NLAnEDquLK/XrG7iS1qVWoewfbjJjzWUH2/PBW06umJDpUvnx5njzUTINu2LTGU/d0bMoSjoOR0xqQZCOHLsBwWUiC0eJ1PKAtd/J4OMOLY7DT6KfFAzCLh0M2HmVoPzODcfTO0u9xClzsPxVMhnqEb8pxzzbfcUpT7+rjnDlwa0/NXF3frGhNG+GaoV+IHvPytZqQkuQf2/ljuaUYK1D5u5VuDytEKGLpW2Zs6g2t4UWHsA0zfCYld4AaMNnxQXkDjw2YA5J4TY74nSRUmjAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ODjLMF5j1a1ZITJgKRLtbJtErpwx7XfM6MQOFemb2Xg=;
 b=aDecR37NibfJJ9ex8i+ij0zH/taW2iC6iEAGBOZOpSc3aMej1VKUNiaAECimoLt+LLr33rp9fgukzp4ASIxcqtCfUTx7521c8/Kgb/sqAcn3lTWg58A0ECWhQYc1DcjxFpiaOfm8pp9uoQzW2/N5KvZKbcETXHUCFhn35VrWlqs9nsaJsDJlChtPSvHrinn0Jucz1juwpL1O2bQhowHTqiX0T0s5Kv83ZvzXc2J1ko95DQmLluumtJlQ6NiezHzXWUIwSkN4Pwx6MeYBP2Bk08eIHZlSqdA7u4ZtaGaCLhUL73oklE97TLjL5/nG75FlEdzSqYU7pelrKtB+XhDq+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ODjLMF5j1a1ZITJgKRLtbJtErpwx7XfM6MQOFemb2Xg=;
 b=CB0xzDIGNheKgevply1soKmyjooxrg+QiYFmncVkWH4RWr0ggXQR0VwBGr3et72I3/dX8cJTAnKR1jjwsbCJjW1ugaQrlx76Izqqu4du7EsdaaIYKfd/844zlL6zDraX1nYAE+J7jK1SeTo8UHUC96uslBmNOmKQK0yasD8lrh8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by MN2PR12MB4359.namprd12.prod.outlook.com (2603:10b6:208:265::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Fri, 30 Aug
 2024 04:00:40 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%6]) with mapi id 15.20.7897.021; Fri, 30 Aug 2024
 04:00:40 +0000
Message-ID: <db05ceb5-d38b-45b8-81c9-c84c0d8fbd96@amd.com>
Date: Fri, 30 Aug 2024 14:00:30 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [RFC PATCH 11/21] KVM: SEV: Add TIO VMGEXIT and bind TDI
Content-Language: en-US
To: Xu Yilun <yilun.xu@linux.intel.com>
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
 <20240823132137.336874-12-aik@amd.com>
 <ZtBIr5IrnZF4z3cp@yilunxu-OptiPlex-7050>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <ZtBIr5IrnZF4z3cp@yilunxu-OptiPlex-7050>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY6PR01CA0022.ausprd01.prod.outlook.com
 (2603:10c6:10:eb::9) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|MN2PR12MB4359:EE_
X-MS-Office365-Filtering-Correlation-Id: 884426c6-4e3f-4ce1-da49-08dcc8a84fdd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M1NGbWkwNEF2TnYrSnJWNzFpZmxWTytuaktzbk1Ob3MrTlB6SENDb2swdmpH?=
 =?utf-8?B?MXhKQWVKNTM3dkx6MVMxanlidFczK2lMbnE5T253bndzeVYvYkNQV0d4bTA3?=
 =?utf-8?B?UHZQQ2ZELzRObFBuN2g3SXBPL2laK29rVUhXUmtuYUNPWThuWnNYVGxzUG5x?=
 =?utf-8?B?bkQ1ZkVFWml3eGw1cklzNS9aYjd4WnYra2ZDNk51dytCUGlkZ3c4RjFpaWpu?=
 =?utf-8?B?Znp3VnE2bmtqNDd3VWc3d2dEdlpMVHNxdTV1N3ZvSUVMMGJNYURRSkdKV2t4?=
 =?utf-8?B?TWc5Q255Z3N1ZVQ0WWxVcmNHeURFSGIyY1JOaUpyTTdQRkZyK0FqVW5OQlU1?=
 =?utf-8?B?OTVkV1JnellKZnNIL3R1Qis1dHFxWm5vdk9RWXNxeit6anF6ekp3cmhvS3lW?=
 =?utf-8?B?bWo0dXlIZVV3RjRkVGtZZmxzUXV4WUZxcGRvUm00MlNZZFJLY0FjUlN3R3Fr?=
 =?utf-8?B?OVhiSnAxNklNNldaczBmOHRidG9jVWpONCt2S3ZkVnZ0bWEyT2Z0YWtUYWZH?=
 =?utf-8?B?NzBGd0QwV2RrZXdhNkZvcHh2VWpDelljR2pWU0lxaWc4VEI3WVZmeEFXMG9z?=
 =?utf-8?B?OXZqOVQ3eks3T1ZZOFRpTVE4RzMvY3ZtNEVrcDU2NC91WUZvSGVuczhrOWQ3?=
 =?utf-8?B?ajZsaS9qY252RDBkeXEvR1dTVFRqZHR3UDUyaGU0SHJoZVppdzBwWnRoUWxT?=
 =?utf-8?B?cm4vbGs4UURESW9KQmJSQjJoYUlpTzV4TjZ0ZHpCNWk3UjU4QkpPNllxb00z?=
 =?utf-8?B?OUVnMU9FaXpEM3M3UHlieXE4Y2hCMlNheWQyV2FHNzN1M3FlaTNHRm5CbTAx?=
 =?utf-8?B?YUJYUnFWK3BzdEVkZEYvNENWdGZ2NC9Sb2ljZVhnQ05rbnl1THFoeUh5c0hq?=
 =?utf-8?B?cFlHMEY1eDRxOUp5MlZNbFJoUTRPbWF1WEN5eWdxYW11bTRKTktPdDhJS1Y5?=
 =?utf-8?B?V0tpY0NYZkR6WnJXQ3d2eEhrSldvRHB3cFhTMlFmaU5NeEg0cnpsL3hyY3A4?=
 =?utf-8?B?SHpuVnY3QTBjL0p6OEdlUWFlNHBraU1pY01HQmRpTytGNWl6S01iREdWazcw?=
 =?utf-8?B?T0xjNXRFb1FDU1RtNXRrUkNWZnZoZjlMb3RQM3daNDgzU0ordExWRFc2WGla?=
 =?utf-8?B?U3g3T2RFOVJBdzhJVVdUajBCQmdNM1E1RThSYkcxbE9rUDY0eExGMXpyYXIz?=
 =?utf-8?B?S2ZDUTVkVkdBQVkxMFl3NGdtaVlNbitubjVzOGgxTVc5aUFPV3RhaFdYN2xQ?=
 =?utf-8?B?UFBmcEU2T0xiQ0drOGN1YnZvbmFzeENTekt5QlJlNERNZTdjeGVnUTRLT2p2?=
 =?utf-8?B?RWQ2S21ZTHNwRFVLS3FYS3NFc3pITFgzeldLQVZKdmIxNTRpTC8veFY0L0sv?=
 =?utf-8?B?dktMd2d3YjE3Vy9tNG4rNVlwQlRnZzIwbGs5U0dkR1llSmtNOHBaTlQ1RmdQ?=
 =?utf-8?B?SEQ1algyNGVja08xVG1laWEzYk42Q29jZVVNcU5UYW9vVUl2NVY5MGVUVkR0?=
 =?utf-8?B?SU1Mb3RaMk5CTXRvczllVFVhdjd6bHozcm9hd3c5ZEdZYVhqQ2kzV3JQYk84?=
 =?utf-8?B?SDNwQlNpZHcvRG8ycGhPYlJuQWpRU0laa0Q2Qlc1Z0NZSTk1VVVqV2Uzd3Vy?=
 =?utf-8?B?TlhkaU9XYVZaUG9XTkh2QWJEanE5OEJuOGJsN1V1SFlaZ2RZbGJEZjllQ3I3?=
 =?utf-8?B?N2F3TVIwTVF4eWwyOFdNSWh3RlJTZWFOdHh5T24yWHRoMkhSMEF1cXZ2UTBn?=
 =?utf-8?B?d3QwOVRmcjAybVBwcjNhZFRtRzcyMVNaN0doeWcvOWgzQThYaHVISUJGN2pJ?=
 =?utf-8?B?Q3JObTNCOTdwd0RoRnh2Zz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VkdXK0hKUThyU1JhTWJNbUFQZk1iWHRWdnBweUZpN3E3blg3TDIvVURSNHJD?=
 =?utf-8?B?ZWN0WWxYMytzRGgvaVZ5RWxOTklKS2pyOUgvVnBIMHNiaUhmUFVnUHRCYkJX?=
 =?utf-8?B?WlhZU0RsNmFhd1gyMzF1MGpYMXlBZFkvSVdqWUEwK25JaGEweE1IOHV4TFpK?=
 =?utf-8?B?eXUzUU9oeVV3N0dMNDNwOFh4M3B0TCttM0lVVUR2MGxvanp6OFRZWms4cTIw?=
 =?utf-8?B?MU1EZENKM2o5cXhHbEhvazVtUmJmYlpVMkpGWEVLbW5VQmRlemxUZmhCYUd2?=
 =?utf-8?B?UEVBNHN1TzNaZWZwd2ZxdWxDMUJERmNPZnY5c24xeFdzemtZOEFPdmVHa1Na?=
 =?utf-8?B?V241ZXRmWURHZEx1R1ZqUGdSUXJFMnRsOGR0aXBqRTd3WWN0ZWgwbitqK2VQ?=
 =?utf-8?B?VnZIMXRhV2tzQmFraldOWUlpUzhTZERIeTh2VVN5c3RjZ084SFBoMTVUSWo4?=
 =?utf-8?B?Z3ZENE9hVTJSUlE5cnNyZ09oZjJLWWp6aEI4cHNZVjNXUDR3aFZ4TGhxZXNn?=
 =?utf-8?B?OXdra3pDK2xRYnpQckZzc0laUDZKTllOV1BvMDhXWHBSNVJtV01ieWM2VUhy?=
 =?utf-8?B?YjdyTDhOc0xPa0duTnZXU0d1RThoRFlMRFRQanFoSGhwaERxZ08zNHpTTTJC?=
 =?utf-8?B?YmRFWlE2TU9CNUVWcGdDUjg5d09HOU1wdmZCSDFiaVVFM0JrWnZRU0d1Vitr?=
 =?utf-8?B?SHNqY20vMUhkSTdQUzY5ZVM1M1Z6ZkZDZnNURTlhdzB0Y1dsR0NjWjZRM3F6?=
 =?utf-8?B?YkRVTGQwdkFTMy9Eak50cEtXaFJBcmF3bnk4ZUZQL3E0TVNkUnhRcjdHOUdD?=
 =?utf-8?B?YTF0Q0JzRE5mdDBFSzR5U0xNYzJPZ1pYTC9qV1crSy94T0ZocGh2SGZneUZ4?=
 =?utf-8?B?RmdBUmpRanlGTDNwcDIyeUU3bEtCS0FQVUphRWl6eDBiVWhlR2E3c1FPcjVO?=
 =?utf-8?B?ME4xQ1lrTjZ3Z3VnNC9sN2tER3VLNjhVMG1kU1hDcGNUQ216MFJHKzR1anF3?=
 =?utf-8?B?TFNNeExTYXpoWjlXZkp4T0ZuYm5XdWNqWDJvTDF5cU5oOFFkSmJPRTRrQ1ly?=
 =?utf-8?B?RVc4QXNhS2lGWThFY2YyVVlRU2oxdGNQRHJ6NUFYOU96STZmdzNoVFZhUXlR?=
 =?utf-8?B?M3FWVm1FWVVwR1RxaU9nbG5rRm1zd1UwTXVHTy81RWszQ1pCM3dGakNIc093?=
 =?utf-8?B?N2V3VjdDdTg4ZStHTENYMVZZMXgxSHdKZkRnMXdTQ3U3b2FvbGF1YXlXZXBU?=
 =?utf-8?B?b0FSeC9Id2wvYllsZzIwN1k3NXVEQWdlS2MxS1JhbnpDWXgwNWgvTEtDZG5i?=
 =?utf-8?B?T29yUloyTUw1WjBmSlBSeEd0S1NoN1VxSVlkNjZVaW5rbi83VUp4MUtPM3Y1?=
 =?utf-8?B?aXZjWXZvcHBkR0NUS2g0Tk1ZbSthTUtEYW1uUlVSMkhvWmNBbGpZS21zdTJk?=
 =?utf-8?B?WERvNzdENW9MUkdqSGdvS243K3JnR1FnT3l6VXUyZWRESmxmZm1SVDhjQVBw?=
 =?utf-8?B?YW01YzRBWFRxcjEyVWtnZURRUWgzSXNZekt3Qmxwa0REeTNsQzZLd1NNOTRY?=
 =?utf-8?B?aGMva0RpNkxOQ1BabXA2Vk00US9ibHZBUUJrdWU2VjlqRUdQeSszc3FYejJV?=
 =?utf-8?B?YVV3enZzR2pnTlVWalFHY29SSWhvbkFicE9NcU9YKytKVkc3dzA3SHVyV3l5?=
 =?utf-8?B?eEE4c1BiN05lWGV5VElwSUl4VklTK2VnVGd0UStkMDJ2UDNNZ1Y3SEZCQnBl?=
 =?utf-8?B?K0w3cUh5bzh0cjZVK1BvdVM3eHJEKzFjTWx4aFNRbTE5d2JoUThlZDFvWG90?=
 =?utf-8?B?WWI0TzFqc3ZtY3REWXlaUjdCVVlyU2V1aTVDZ0V0YlJFdU0xclhCRzBZSGdm?=
 =?utf-8?B?enpaTVp0ZW81UEJHd2hhdlZGaDNPVFdFNUpoYkNPbW9VRTRkSnFyc0hVLzRv?=
 =?utf-8?B?Y29keThiU0h2bFpDQ2YyODJpa0pjR3dxcWZnNXpJaE8wWDZEZHdDYURBVzZR?=
 =?utf-8?B?dStRUDNSdDZDRmNXZjlvTnI3TTZrWFNrVGZrMkVtSisyMU5qcG03a25wc3dF?=
 =?utf-8?B?bnVGN0phbDdnSmI5bzBpdmJHbGs4VUxEREdheXF6alFMYjJmancvVy9SenYy?=
 =?utf-8?Q?TiW5SCNRZvEPbXmQPJwUQm9vI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 884426c6-4e3f-4ce1-da49-08dcc8a84fdd
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 04:00:40.0919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nt5RYJb7Vvk6ARPqBu0KOP1bwzHoHHAGkMg0L6rnHEzVW7LNaUCdT6LfudPV9M4cSpmkT0MIFjO39MCaSmS7Xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4359



On 29/8/24 20:08, Xu Yilun wrote:
>> diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
>> index 76b7f6085dcd..a4e9db212adc 100644
>> --- a/virt/kvm/vfio.c
>> +++ b/virt/kvm/vfio.c
>> @@ -15,6 +15,7 @@
>>   #include <linux/slab.h>
>>   #include <linux/uaccess.h>
>>   #include <linux/vfio.h>
>> +#include <linux/tsm.h>
>>   #include "vfio.h"
>>   
>>   #ifdef CONFIG_SPAPR_TCE_IOMMU
>> @@ -29,8 +30,14 @@ struct kvm_vfio_file {
>>   #endif
>>   };
>>   
>> +struct kvm_vfio_tdi {
>> +	struct list_head node;
>> +	struct vfio_device *vdev;
>> +};
>> +
>>   struct kvm_vfio {
>>   	struct list_head file_list;
>> +	struct list_head tdi_list;
>>   	struct mutex lock;
>>   	bool noncoherent;
>>   };
>> @@ -80,6 +87,22 @@ static bool kvm_vfio_file_is_valid(struct file *file)
>>   	return ret;
>>   }
>>   
>> +static struct vfio_device *kvm_vfio_file_device(struct file *file)
>> +{
>> +	struct vfio_device *(*fn)(struct file *file);
>> +	struct vfio_device *ret;
>> +
>> +	fn = symbol_get(vfio_file_device);
>> +	if (!fn)
>> +		return NULL;
>> +
>> +	ret = fn(file);
>> +
>> +	symbol_put(vfio_file_device);
>> +
>> +	return ret;
>> +}
>> +
>>   #ifdef CONFIG_SPAPR_TCE_IOMMU
>>   static struct iommu_group *kvm_vfio_file_iommu_group(struct file *file)
>>   {
>> @@ -297,6 +320,103 @@ static int kvm_vfio_set_file(struct kvm_device *dev, long attr,
>>   	return -ENXIO;
>>   }
>>   
>> +static int kvm_dev_tsm_bind(struct kvm_device *dev, void __user *arg)
>> +{
>> +	struct kvm_vfio *kv = dev->private;
>> +	struct kvm_vfio_tsm_bind tb;
>> +	struct kvm_vfio_tdi *ktdi;
>> +	struct vfio_device *vdev;
>> +	struct fd fdev;
>> +	int ret;
>> +
>> +	if (copy_from_user(&tb, arg, sizeof(tb)))
>> +		return -EFAULT;
>> +
>> +	ktdi = kzalloc(sizeof(*ktdi), GFP_KERNEL_ACCOUNT);
>> +	if (!ktdi)
>> +		return -ENOMEM;
>> +
>> +	fdev = fdget(tb.devfd);
>> +	if (!fdev.file)
>> +		return -EBADF;
>> +
>> +	ret = -ENOENT;
>> +
>> +	mutex_lock(&kv->lock);
>> +
>> +	vdev = kvm_vfio_file_device(fdev.file);
>> +	if (vdev) {
>> +		ret = kvm_arch_tsm_bind(dev->kvm, vdev->dev, tb.guest_rid);
>> +		if (!ret) {
>> +			ktdi->vdev = vdev;
>> +			list_add_tail(&ktdi->node, &kv->tdi_list);
>> +		} else {
>> +			vfio_put_device(vdev);
>> +		}
>> +	}
>> +
>> +	fdput(fdev);
>> +	mutex_unlock(&kv->lock);
>> +	if (ret)
>> +		kfree(ktdi);
>> +
>> +	return ret;
>> +}
>> +
>> +static int kvm_dev_tsm_unbind(struct kvm_device *dev, void __user *arg)
>> +{
>> +	struct kvm_vfio *kv = dev->private;
>> +	struct kvm_vfio_tsm_bind tb;
>> +	struct kvm_vfio_tdi *ktdi;
>> +	struct vfio_device *vdev;
>> +	struct fd fdev;
>> +	int ret;
>> +
>> +	if (copy_from_user(&tb, arg, sizeof(tb)))
>> +		return -EFAULT;
>> +
>> +	fdev = fdget(tb.devfd);
>> +	if (!fdev.file)
>> +		return -EBADF;
>> +
>> +	ret = -ENOENT;
>> +
>> +	mutex_lock(&kv->lock);
>> +
>> +	vdev = kvm_vfio_file_device(fdev.file);
>> +	if (vdev) {
>> +		list_for_each_entry(ktdi, &kv->tdi_list, node) {
>> +			if (ktdi->vdev != vdev)
>> +				continue;
>> +
>> +			kvm_arch_tsm_unbind(dev->kvm, vdev->dev);
>> +			list_del(&ktdi->node);
>> +			kfree(ktdi);
>> +			vfio_put_device(vdev);
>> +			ret = 0;
>> +			break;
>> +		}
>> +		vfio_put_device(vdev);
>> +	}
>> +
>> +	fdput(fdev);
>> +	mutex_unlock(&kv->lock);
>> +	return ret;
>> +}
>> +
>> +static int kvm_vfio_set_device(struct kvm_device *dev, long attr,
>> +			       void __user *arg)
>> +{
>> +	switch (attr) {
>> +	case KVM_DEV_VFIO_DEVICE_TDI_BIND:
>> +		return kvm_dev_tsm_bind(dev, arg);
> 
> I think the TDI bind operation should be under the control of the device
> owner (i.e. VFIO driver), rather than in this bridge driver.

This is a valid point, although this means teaching VFIO about the KVM 
lifetime (and KVM already holds references to VFIO groups) and guest 
BDFns (which have no meaning for VFIO in the host kernel).

> The TDI bind
> means TDI would be transitioned to CONFIG_LOCKED state, and a bunch of
> device configurations breaks the state (TDISP spec 11.4.5/8/9). So the
> VFIO driver should be fully aware of the TDI bind and manage unwanted
> breakage.

VFIO has no control over TDI any way, cannot even know what state it is 
in without talking to the firmware. When TDI goes into ERROR, this needs 
to be propagated to the VM. At the moment (afaik) it does not tell the 
userspace/guest about IOMMU errors and it probably should but the 
existing mechanism should be able to do so. Thanks,


> 
> Thanks,
> Yilun

-- 
Alexey


