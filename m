Return-Path: <kvm+bounces-26180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE439972699
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 03:29:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F3F4CB22BBC
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 01:29:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1313C137932;
	Tue, 10 Sep 2024 01:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="r0ftJUVx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2047.outbound.protection.outlook.com [40.107.220.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785141CD2A;
	Tue, 10 Sep 2024 01:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725931751; cv=fail; b=nzXgR/DfvmFWcRJjRabw/coDUSzeg300spCCtEnvnL3tGKwHoLB9wP/TFyzIFeqseX38OMadCxHkSouS52W6y2EWlgtaw8PkC8NzwdItW3i29D8GNaNIdnIH0iwgv6dPW+Pbm8kb9JAOfaY12POdJLms3N6n0+UkAjQiNMjkLgQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725931751; c=relaxed/simple;
	bh=Cg/TZDAfsmehX0/CEOPN0E0t9DWHjH32j6xeYslQYXQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aYwHn48VrpxAQY0LXw0WZmIUYRyGodC9T6c9TwFmem2kEiDgvjxodG+j8DvL3H5zAq6rBIYGZvfrp7LKTghLet6JCxdKGj+uNYo3s/o+neHwV/SwkXzLCB3FenmmZhMQAcK9K/8bNeV4GUQYXRryNCJXF0qCioPKqHnT9I7nBw4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=r0ftJUVx; arc=fail smtp.client-ip=40.107.220.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tcCJ91uSxNsSHWGWIvdKoR5MxR6WDMG854Q+QtmIANlWtp4M2l/+uYmj5sXWrLU2kc7/yshAKS6WHy9jY1ycR0xi8bU/uqBzxT0TcaqgHdJdAai4vEkFe5ubWgUnoZSbdLmhObVRMJIg1m1lGPS6WCd090Lbz/5zuU/r2RrE/F8qebqIx1JA7zElJCmH0sj3BClOqlkIV+HD3DoSo8DW/kkHRhm3rmAA0ArOKkrDrqMHGE2ywe07gXCDnYuj5FlVoDt61umDlSe0FBqtXnoyP/WUhKHTYHYzeFQEr56IEsCTurh6oYRb8BGE18zs13/T7YTEXZXApjFTN5+H6I6CnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uVOBvfgNNkDTnaQHaEXVk8dmg3Dbd4+qFIBsX3H2q74=;
 b=ZbjDWhvnqZpZd2GE4YWdJQbgSmVeiSI8+8KnY/hd1+SSD6sgXRXfDjymITd1kWsqw4e69bDLdGHux5xZi68pB5YINOInnwWlg46pokD185pBkGGndrma1IUpr07W2sAJ9WPx6MI4XW6jXacBvMTTqHdY/KkhSTeFVEFo/UuJxXUCWuwCtwStfFMujwl1oAfnfy0cUgNsiDycX8i/XHkDQqrjhNla8719PNUXoDijmgIfTMgUFPtBywr3hSM5J6Yr6WZqysybRsq8H1cLJWve6KgCm6kOdBvthu3WUi+m5amWyXC+RmuD5oy9OC3oIXw+V2vhyCDBaODyvlUxp9WRzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uVOBvfgNNkDTnaQHaEXVk8dmg3Dbd4+qFIBsX3H2q74=;
 b=r0ftJUVxfYaYk9y3U0guMPU6F8RxkBXrMkY6Wl3UYnnfjqisbEA0/3OKEvIGf3LfhM22rDjyIc7s5yWIl/miYv/XPNhviW0kWYbnFHORQUV2TPzanXcFZ0Pukyysz2FpfUVe8Z3MNCvzWKA9YtNznM5Po3dQnQ5lC/I4cczafSE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by PH7PR12MB6953.namprd12.prod.outlook.com (2603:10b6:510:1ac::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Tue, 10 Sep
 2024 01:29:06 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%6]) with mapi id 15.20.7918.024; Tue, 10 Sep 2024
 01:29:06 +0000
Message-ID: <523fc716-51ae-4fb0-9e7c-5d49bbd33e22@amd.com>
Date: Tue, 10 Sep 2024 11:28:56 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [RFC PATCH 13/21] KVM: X86: Handle private MMIO as shared
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
 <20240823132137.336874-14-aik@amd.com>
 <ZtH55q0Ho1DLm5ka@yilunxu-OptiPlex-7050>
 <49226b61-e7d3-477f-980b-30567eb4d069@amd.com>
 <Ztaa3TpDLKrEY0Ys@yilunxu-OptiPlex-7050>
 <262bee4e-7e60-45e6-8920-ec6b8dd0a526@amd.com>
 <Zt7I51r6dqkwkPAz@yilunxu-OptiPlex-7050>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <Zt7I51r6dqkwkPAz@yilunxu-OptiPlex-7050>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5PR01CA0054.ausprd01.prod.outlook.com
 (2603:10c6:10:1fc::20) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|PH7PR12MB6953:EE_
X-MS-Office365-Filtering-Correlation-Id: a0b101d7-eaab-4a74-f2b4-08dcd137f60b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZnpFUWdhbStnaDJHekthNlJseXBlK3FHd3hyVmtMVGRNY1NkYmRRUkZqQ0Vh?=
 =?utf-8?B?eVF1enZ6VFl2dkRYT2JoQkw5MVpHS2w5QVFWaGFjRW5CT2d3L1ZSZ09aVkg1?=
 =?utf-8?B?SEdkTmhDTjd6dmpjcHVpWG9GVDcwVkdpY1psYVhmQkthdnByMDBrMXRjV2E4?=
 =?utf-8?B?TFI5SUdBdC9Pb0I3T1RKWWlwQkdjbFpGaGlDbGwrakhhb2ZpWjZNcGYxYUxa?=
 =?utf-8?B?aVBJaUNJN05MZjdZUzlDczRjc2ltQzZTakxtSWRWRSs2bUxtS2l6RkQra0h6?=
 =?utf-8?B?RldVTEQyRlVTWVFyMEVqMndoSDhFTGh1L0VIc1ZFd0RCbHFTeGc5ZzFMSUo3?=
 =?utf-8?B?bFBEQ3g4M3p0cXNpN1kwVnU2OVlsN2dmb0g2MHdGdUQ1azRFWlZscnRQbXpv?=
 =?utf-8?B?OW1odlJCdUVySko3dEFXa0hEdWJsRUZ0UE9RS2JWWXRyVnBGVFFURzltWFlE?=
 =?utf-8?B?WGJ1eldFYlk0NlhDVE9uUWd6RE03RTFXKzRRWnQvQWNkUW10UVh2N0lzdTRL?=
 =?utf-8?B?RGZRWXFqeGFDM2RNQS90WDREMVp6V256Z1A2L3JBenZHSGFrSndvMlNVZTZR?=
 =?utf-8?B?dHdDUG1aQ0FCWXVrQVFaVkhidWhmcW0vQi80WnFXd25Ca3FEd3VDemc1UmJs?=
 =?utf-8?B?YXdtdHV5M2xFc1prdjZkczRHRkJvSXFBeUw4SGxjTFp1MFlEaXNkM0NCMHVn?=
 =?utf-8?B?Y2VHZFVFMXZLQkxQSm8wWFRqUjdGOWdGYk95QzRsd3dnazl6anRJN2xVcVRR?=
 =?utf-8?B?SVNPVkdNcFJYMGlFMFF3RmFFeG1NVWZVb0J2WWNoU1VCNy9GaE9IQW1IL1Ew?=
 =?utf-8?B?ekRPVWFjQUE4eUg3aXZIdjNYT1RrNVhNU29IVkZ1ZXJEaEE3MkpCR1M4bFZ5?=
 =?utf-8?B?Y1lBQjdpMytKbE9hS244YnBXRzZXRlJqQmJYYUZxaHo2dlhIL0RpLy9UUzdX?=
 =?utf-8?B?N3V5aGJyalJ0TUtOenF5a1RkZkFyY1Z4c0IzbGRYRG9HQ29xeWRZaWU5b2RG?=
 =?utf-8?B?YmU0U3AxOHI1OGpYZTdrd0Qrc2VOV2prV29kQWdPUFpvSnoxSXlRZWZZQTdE?=
 =?utf-8?B?eFhCcElJa2FtcWJaVnZyNCswY2NhVEF3cEJEaDJZQ1BsL3hiUnZoVTFaT2w0?=
 =?utf-8?B?UmFjNG5DZlk0QThtcGxLNUplWnROVXFCeWFzSTM4U0poZVZDQUpBcm1ET0dT?=
 =?utf-8?B?RXBDY0dTR1dib1VIcitrbFhVTFkrSFhTWngwNDB0NERmT2lHK2pPOWpDbVEr?=
 =?utf-8?B?OC81K3hIK3dRWUt0RWQzaVpWQzVZY2JpeEY5MzJURXVSeXMrSXQ5YTd5K1pp?=
 =?utf-8?B?cHJTUUpYZi9BM0lKMzdHWGQ2OWZTOS9kUlZUKzV6OU9HdGttYWZIU1BLUUhK?=
 =?utf-8?B?WGI1eEE3YzFWUU5Ybjg5TzJyWUhjY0pPdkRhanBlbUFYc0JDU3ZERUhuVElk?=
 =?utf-8?B?SXZZS0hQendNcHR1bnFHdHNWRXJVdEZ2TTFGZEpweHRJN2FUOCtCNWhJNnhu?=
 =?utf-8?B?VnpFV3BCSDJDbGVCMmdxYWpyWlUxQ2h6OWUwV2ZTQ2RuUWNndTgwcXYyWkE0?=
 =?utf-8?B?dU9lRFYwdXVOMUdaUGhmOUJmMjkzTzBwcXlYYTVZcWprVzlKWFo4VlNxYkNM?=
 =?utf-8?B?VmN3RFloejU5SUlJZkRZMUJES1grc1ltZUhza01kcEFJbGRqcEdwUURFdWdO?=
 =?utf-8?B?SWdTN1NYT3lablZSRjQ3eThCR0RvZEJGdHE2N0s2Z2JqMWJHVSsxeEZiUnM4?=
 =?utf-8?B?M1N0UGRVVFM4Sk1Kc1dmbEVWSHp3L0NCNmVrSll5aC9jb3dtOFduTXQ3S245?=
 =?utf-8?B?K0Y0THAxeHFxQWdWU2NSZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TmZtci9ZM2NTZFlwdk55WXQ3bmtuQUk4Y2luTmRKei9JV0FuZXI3RGw1NzFT?=
 =?utf-8?B?VURleWlQbXM1TDViajV5ZzJyRUNWcWVHUjd5UmNOSjVWRElDNkRhakVydTBv?=
 =?utf-8?B?V3g1RXlxU0xJajUwOUdMdGdVRUhsQzJnWTRqVi9paG9FNysyeTgvdElST3pm?=
 =?utf-8?B?eCtrbzJ3ZGlpODBlYTE3VHhqMHdIT1owMUo4L1Jwa3NTalJETlZZTmgvSHZn?=
 =?utf-8?B?RnpXSGdZeS9wMkU4aGprZGQxTVlFUHZiOUU4d0crYlBvOXM5RWJTMWwvaFFy?=
 =?utf-8?B?elJzMXBONVJFQTI5cE4rUVkzWlBWb0VXNXNIcXRqaGlpak1CVi9WWkpIajNL?=
 =?utf-8?B?a0dNekNpako4TU5PVUc0U1lWdVJQQTFTYjFoNEYyaEpYWFdaanJHRHBnRFNY?=
 =?utf-8?B?S25PdER3WGNLaVp3TEFTUGhPZmtYck1aU2x3NlIwYUNjaG5lRnc0cVhzRXpI?=
 =?utf-8?B?K1VMOEREc25xSSsybHVoMEZ1Q3QwR0duRUZQNnlmV05wUEZrZldXYlM2VGx2?=
 =?utf-8?B?SjFCa3YvdXByQmN4QnRBbnB1MEZmUmM3dDhGNXphK2VsdnFhd0pRaUZ2MWJG?=
 =?utf-8?B?TWs3T29HSnVBSkpLaklNcFkrSFpVWVJHa2c4M01rZlpRdXY3VGVibzBvWEZW?=
 =?utf-8?B?K2FxamVIZW13TVlBN2VnVWpjZTgzenlLWU1ZWXBVVVVpWUI2aGNVV05EaHVh?=
 =?utf-8?B?d2JrUllleW12Zk81Q2xDK2R3VjV0MjlUaW0vbnZXODcwNzlVaVZ2aDZqVkI0?=
 =?utf-8?B?QUZSaVlLVVpua3BLR2tuMmhIOHEvUlJ5S0haWVJCeFlpMjJtamhZSWRDeExo?=
 =?utf-8?B?VnpLTGVYUDZwZGpHbDBvelBmYktmcThVeVYvOExXSStyd1N3MEpjQWJoR0h4?=
 =?utf-8?B?aFg3TEZzWG1HbmFRWTBiQ1hVc2djd0RRSGd1ZE9LVXhMRUlsMlpZeFpoK3ZG?=
 =?utf-8?B?QTBXS2ZMeHNPc3lOdlQzQlcwVFV5SmU2ODFOOEt5bU9IYUJlZ3VhTGFHSDRx?=
 =?utf-8?B?dFN3WWZMVFVFY0RMTVhXSFlOYTBLVTRsMmhrdDJvbktidTJrYmtZTytWcGZO?=
 =?utf-8?B?Q0p3UzZXTDdGQlRsMTR5aS9UNWVBQzVHT2tsU3gxOHZwWTZLbTlJSDlMRzF5?=
 =?utf-8?B?TUM3dm1TMHEvTVFOQTcwNVNLRmNBdmdwZzNzRmo0Z3hlaThLK25tc3NGMDV5?=
 =?utf-8?B?Z2cvWXF2RFd0OVpIT2M5M2NxbHlqeklzcWNNT2JCQ0NGUDlqTS80WHdpRDRX?=
 =?utf-8?B?eXZqYWJ3WDlLcG1ob3FRTld0eVlmK2ZEcmJXM3ZBQXFWQUJHak1KQkpZR1lI?=
 =?utf-8?B?TlNGS2l4TXQvWjdsNXhkR0VHWU1jYWlqN0FjZGUrVzNTd09SSVBETTVBTG1m?=
 =?utf-8?B?REtsSU40eFhKUFJKcWJVaitSc01aeGpuTVBJdkJNSTRIZjRQbWxvTExuOXFJ?=
 =?utf-8?B?MFdCT1N3QkxoQTZrQUR6Z25QOWdXTTcxUlRpZUQrQzZiWGUyTW9iNkNybG5a?=
 =?utf-8?B?aGV5aTh5R0xpb2w4MTJRdU1TeWtvOTJnSjNXcDYrajZlRk9XMnZEY3U1NnVM?=
 =?utf-8?B?WVpKdE8xcFhJS0N1ZlkyL1RORlF2TGE4N0kwU0pyTWV3dVJReU5FQm5SS21J?=
 =?utf-8?B?bm0vTnNpa3JabzM2bnk4TDBoQkVscEF0VldRZVdGQWdheWlNSVlsTE5pQVpC?=
 =?utf-8?B?SFFSODlEc3kzRk9iSjFMajRsTzVJSnZwOEZZM2hXeUN4RGVaVEtwZCt6c3JP?=
 =?utf-8?B?UGt4bGdVSDFqRXlnUGlRQWFvN1pSTGpkRnJEc1dCaXZ6WEpuWHBES1NZdmNz?=
 =?utf-8?B?aWNZMHc2clB6OCs2MExLYTFYQ0RyRFZCVTdRdlczVTVYRWMvSHFPeCtnVy93?=
 =?utf-8?B?bFBYamxKdjkwTUFBbnlVS3gxaENEWm1PbHJBR2E3dE5kcEwyVTc0SFhrUXZQ?=
 =?utf-8?B?RG5hRkptdXMvZUtQQWlRTTRRZ3RPODIwaWYvSWIxZDF5VG5kUW11aStMZmZo?=
 =?utf-8?B?M2NDSGxzMEhQd3dUdGFHbXBaeUs3N3FXLy81WW1YTEx0ZVg5aHN4cDZsVW9K?=
 =?utf-8?B?M2Z5ck5KYkhNZG9QRkZYT253SmcwK1ZSbU1QdVQwOFFMN0g4MHdKS01keHk5?=
 =?utf-8?Q?ULIWwO1uBJZDG61pif8cJ1Quz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0b101d7-eaab-4a74-f2b4-08dcd137f60b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2024 01:29:06.4567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7mE9rGtJ278qqcgC3gyebeoutg5XcmtiaULCcg1EUBOs1fqroUyw2LZO8MHCTBbX8AW8A07EcwYhIu3pfvCa0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6953



On 9/9/24 20:07, Xu Yilun wrote:
> On Fri, Sep 06, 2024 at 01:31:48PM +1000, Alexey Kardashevskiy wrote:
>>
>>
>> On 3/9/24 15:13, Xu Yilun wrote:
>>> On Mon, Sep 02, 2024 at 12:22:56PM +1000, Alexey Kardashevskiy wrote:
>>>>
>>>>
>>>> On 31/8/24 02:57, Xu Yilun wrote:
>>>>> On Fri, Aug 23, 2024 at 11:21:27PM +1000, Alexey Kardashevskiy wrote:
>>>>>> Currently private MMIO nested page faults are not expected so when such
>>>>>> fault occurs, KVM tries moving the faulted page from private to shared
>>>>>> which is not going to work as private MMIO is not backed by memfd.
>>>>>>
>>>>>> Handle private MMIO as shared: skip page state change and memfd
>>>>>
>>>>> This means host keeps the mapping for private MMIO, which is different
>>>>> from private memory. Not sure if it is expected, and I want to get
>>>>> some directions here.
>>>>
>>>> There is no other translation table on AMD though, the same NPT. The
>>>
>>> Sorry for not being clear, when I say "host mapping" I mean host
>>> userspace mapping (host CR3 mapping). By using guest_memfd, there is no
>>> host CR3 mapping for private memory. I'm wondering if we could keep host
>>> CR3 mapping for private MMIO.
>>>>> security is enforced by the RMP table. A device says "bar#x is
>> private" so
>>>> the host + firmware ensure the each corresponding RMP entry is "assigned" +
>>>> "validated" and has a correct IDE stream ID and ASID, and the VM's kernel
>>>> maps it with the Cbit set.
>>>>
>>>>>    From HW perspective, private MMIO is not intended to be accessed by
>>>>> host, but the consequence may varies. According to TDISP spec 11.2,
>>>>> my understanding is private device (known as TDI) should reject the
>>>>> TLP and transition to TDISP ERROR state. But no further error
>>>>> reporting or logging is mandated. So the impact to the host system
>>>>> is specific to each device. In my test environment, an AER
>>>>> NonFatalErr is reported and nothing more, much better than host
>>>>> accessing private memory.
>>>>
>>>> afair I get an non-fatal RMP fault so the device does not even notice.
>>>>
>>>>> On SW side, my concern is how to deal with mmu_notifier. In theory, if
>>>>> we get pfn from hva we should follow the userspace mapping change. But
>>>>> that makes no sense. Especially for TDX TEE-IO, private MMIO mapping
>>>>> in SEPT cannot be changed or invalidated as long as TDI is running.
>>>>
>>>>> Another concern may be specific for TDX TEE-IO. Allowing both userspace
>>>>> mapping and SEPT mapping may be safe for private MMIO, but on
>>>>> KVM_SET_USER_MEMORY_REGION2,  KVM cannot actually tell if a userspace
>>>>> addr is really for private MMIO. I.e. user could provide shared memory
>>>>> addr to KVM but declare it is for private MMIO. The shared memory then
>>>>> could be mapped in SEPT and cause problem.
>>>>
>>>> I am missing lots of context here. When you are starting a guest with a
>>>> passed through device, until the TDISP machinery transitions the TDI into
>>>> RUN, this TDI's MMIO is shared and mapped everywhere. And after
>>>
>>> Yes, that's the situation nowadays. I think if we need to eliminate
>>> host CR3 mapping for private MMIO, a simple way is we don't allow host
>>> CR3 mapping at the first place, even for shared pass through. It is
>>> doable cause:
>>>
>>>    1. IIUC, host CR3 mapping for assigned MMIO is only used for pfn
>>>       finding, i.e. host doesn't really (or shouldn't?) access them.
>>
>> Well, the host userspace might also want to access MMIO via mmap'ed region
>> if it is, say, DPDK.
> 
> Yes for DPDK. But I mean for virtualization cases, host doesn't access
> assigned MMIO.
> 
> I'm not suggesting we remove the entire mmap functionality in VFIO, but
> may have a user-optional no-mmap mode for private capable device.
 >
>>
>>>    2. The hint from guest_memfd shows KVM doesn't have to rely on host
>>>       CR3 mapping to find pfn.
>>
>> True.
>>
>>>> transitioning to RUN you move mappings from EPT to SEPT?
>>>
>>> Mostly correct, TDX move mapping from EPT to SEPT after LOCKED and
>>> right before RUN.
>>>
>>>>
>>>>> So personally I prefer no host mapping for private MMIO.
>>>>
>>>> Nah, cannot skip this step on AMD. Thanks,
>>>
>>> Not sure if we are on the same page.
>>
>> With the above explanation, we are.
>>
>>> I assume from HW perspective, host
>>> CR3 mapping is not necessary for NPT/RMP build?
>>
>> Yeah, the hw does not require that afaik. But the existing code continues
>> working for AMD, and I am guessing it is still true for your case too,
> 
> It works for TDX with some minor changes similar as this patch does. But
> still see some concerns on my side, E.g. mmu_notifier. Unlike SEV-SNP,
> TDX firmware controls private MMIO accessing by building private S2 page
> table. If I still follow the HVA based page fault routine, then I should
> also follow the mmu_notifier, i.e. change private S2 mapping when HVA
> mapping changes. But private MMIO accessing is part of the private dev
> configuration and enforced (by firmware) not to be changed when TDI is
> RUNning. My effort for this issue is that, don't use HVA based page
> fault routine, switch to do like guest_memfd does.

ah I see, thanks.

> I see SEV-SNP prebuilds RMP to control private MMIO accessing, S2 page
> table modification is allowed at anytime. mmu_notifier only makes
> private access dis-functional. I assume that could also be nice to
> avoid.
> 
>> right? Unless the host userspace tries accessing the private MMIO and some
>> horrible stuff happens? Thanks,
> 
> The common part for all vendors is, the private device will be
> disturbed and enter TDISP ERROR state. I'm not sure if this is OK or can
> also be nice to avoid.

For this instance, on AMD, I expect an RMP fault and no device 
disturbance, no TDISP ERROR. Thanks,


> 
> Thanks,
> Yilun

-- 
Alexey


