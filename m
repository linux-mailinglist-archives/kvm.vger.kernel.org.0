Return-Path: <kvm+bounces-25319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 18928963991
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 06:58:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8CC7F1F231C9
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 04:58:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1C501487F1;
	Thu, 29 Aug 2024 04:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JXE5LhRB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2071.outbound.protection.outlook.com [40.107.244.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141F2632;
	Thu, 29 Aug 2024 04:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724907468; cv=fail; b=V3XV3EqpDv3q+CQivePG02tapkZiSRc2hEL+Kv/taQ+L1eyktdcwq5AXlcrJP6gdnDSWqv5cXo3voCiWrHPMSr08vXtc+HDg0S+IXx62T67DJUMXQWS3zaMWAyT2g+K2GysaKEqwxqBxtnQ1wBIaVn8TQykq4hZYW2txKzfIYzg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724907468; c=relaxed/simple;
	bh=Wta/AvWgaEneClM4QT97Us9vqSruW9KNpLLA2u/jwuY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ECEhszJrdGIjHpa6ZevJfxdqXK+IlEMESvMAb4cSQheXcThucUmK9MMsKVpJyrPyqychbMEUuuo2VSnunXrKijWwTAG2Ggvw8Qn8dMxjoytbd2cSNFCbLQKqz/7v+fveGLpqCgGxoXbScaU0XWl6x3TP18e87/VHNrlvjcIKWW0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JXE5LhRB; arc=fail smtp.client-ip=40.107.244.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Et4MgPLnsTfrOIzEJLkbC9k1hPa/IV7MuaLxKLu3vQLk1QyFu9bQYOKm8PtUsWhDEtQQHD1geij2qYjdVDZallC6XqNwKqG7XvBac/YQRQjTgr38BMH9CGYJKTUQUlR4zLsw4cM9QtfwJrwxEOXN79rUdBswHcQIBgyu71bJdlMhW2t/velSOCMCYaaSQMexhoGcrOopNE3hH7CywLQLwrV1/F/H4qOjpUPJ9ffpr3uFCGZsqpcq1zJCE2vsAbGH/w3Og/Ems4kgXgCdRQFPONqHKr89TZcZ2jzSjCEMfBWT2ME3/j9oh/5ZgUiixMkAKCk9Dwq+yI0+chggAph7VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N6sgTZpfIqWIWkvBkZWdQ85Kh862WuL7OvgqmUKqyPA=;
 b=DFp5aP7YzJmgXiC4TkPqPezXekJfHpYYceKytfo3xHH3y9pLBBLo3RamBin/wGXSU+occg3roVRtavGEsxsB2tA0oViIuabGoASsr/2BKhp2nFw1OtH4e41g1XEoJKXfoQUCbleXWCkC9rrmPCqC074FzSUW23UvuMHrSAsEyHEivRzzAldcK3vtvOKVzYKmyqb+s8Xv0vfLjp3LBLu3Zm7VxkIkqUsAFv795VvnzABSXUBMYXbd0daV2f95wFnPoHEvqh0pQNiC4YexDEooQ2Qqq4ckVAPShHgQhcxbkl/3UIciHGPqqRJ6c5xYuaMBH5oRb/fMNWB2HeZFvPFZVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N6sgTZpfIqWIWkvBkZWdQ85Kh862WuL7OvgqmUKqyPA=;
 b=JXE5LhRBNR6LVqRQ4NvDzDVpIUkHiSlMsPpSgRN13DJcG8MpjWWvrfQTt6KTPlY3+30/L4mBzl+qLskULZo+RSE6dB1+X8xqbn4yJ6t2oeKBpEl72bK+H9up7GV0D2bsyfUVYJGc8eC2Sp+tLPVqEMrWrbR4me2U8GCN3lMe+08=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by MN2PR12MB4253.namprd12.prod.outlook.com (2603:10b6:208:1de::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.27; Thu, 29 Aug
 2024 04:57:44 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%6]) with mapi id 15.20.7897.021; Thu, 29 Aug 2024
 04:57:44 +0000
Message-ID: <d9bd104b-e1a0-4619-977c-02a27fc2e5b0@amd.com>
Date: Thu, 29 Aug 2024 14:57:34 +1000
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
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20240828234240.GR3468552@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY0PR01CA0005.ausprd01.prod.outlook.com
 (2603:10c6:10:1bb::16) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|MN2PR12MB4253:EE_
X-MS-Office365-Filtering-Correlation-Id: 0031e811-e25b-46c4-bcca-08dcc7e71e5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?alk1TG1pY2trYzU5blg4am9QaEpLSDNHcHpVY2VrbFA5aC9uWEpYbVI4cHlH?=
 =?utf-8?B?dHN1UUQ4alAySDA4TWxsM2I4Y3NYazhLL2xUZlFpaGt0RkhUVHF3amdKQ2Zh?=
 =?utf-8?B?TitTdFNyaXVmajNlandTTnlnRnA2MnFOYzRTaHdLOVJhakxXQmFNaFZ3dFFt?=
 =?utf-8?B?VWpUcUxPdG14TVlZSkRGN2tMaVZIclB5N3NyRldNSFlSMjFxUmJFL3l3OWdG?=
 =?utf-8?B?UnhPa1NWRVJ3TFVpYXhsVFhwYmlCVEtVMWkzNVNhS2l4WENRaHZkUGVnRnFq?=
 =?utf-8?B?NXZXREpscHl5UlMwTUpqUmJrUmozSHBsZkFISzRzR3JRSzlBY0VlYmhNKzBt?=
 =?utf-8?B?T2tJdDFOWWUyVXlmSHdKR2ZPVVRMUFNudHNPaWY0SG45dThkR2VuOVY1dkRj?=
 =?utf-8?B?K1dnbXY5V3BESjNSU0wxbG1Wc21hSWNwYmY0aENqQW95OVRYOUJiSWp3Y3lT?=
 =?utf-8?B?NWxDVFVNV21iZG4vNkkxQlA4TElVOEF0TUhLeWFYNzdmRVQvcTFtNXJuTk0w?=
 =?utf-8?B?OHlvNzVQRXJQZHkyU3VkQldIclBjM0RLWWpFcEx4WnIxby9wV3B1NWZZWGFj?=
 =?utf-8?B?KzNQQ3hXUnowS3Z4OVpsMEdHUGtYZkpRaVZVdDN6ZS9XLzBJT000STFNdUU4?=
 =?utf-8?B?VUZpbElQOFpNNWtZcHk2WkFvMm1xVXZWbDBTRUxmM0I2RWhYWFRFbzgxUFdZ?=
 =?utf-8?B?Y0F2TjBPZ01zWFJWNGthRitIeEZNdTNUVEVQcDF4NGtqa0JhMVU4SzYxNldW?=
 =?utf-8?B?SEdYcmZCSTJIQ0hPU2QwQ1VlTUR6Rmg2YXQ0ZWJIWWVmcE03dDFaRkRqNnVU?=
 =?utf-8?B?R1VHdW5DNk4zc05meFBUclZVR0JoS2wyR29hbGZBWUxXNVBscUc3U283ZUZZ?=
 =?utf-8?B?M05vbmQyWUp2RTdMRnp4SHBnQ0tSMFNoRU5XRXM2bE1PMGd2dVNReERPZHFk?=
 =?utf-8?B?V1lpUDBZaXJ0V1ZsK3hSRFBLbFJObVYyZWVZVWcxZ1RlbkZZdWlWRE95Z2Qy?=
 =?utf-8?B?aElWdGlrbmJJdG5ENlBCWENTaEVQOXAvVFhVRDRhOUF2TDlyb1lSZTR2UGwz?=
 =?utf-8?B?WElhOWhwRnRGcU5qTTNzNmd6YjZ6OTdPQWRJUU8rQnNMRHRJV000VXpkMmta?=
 =?utf-8?B?ZWxJSmxJVWVoUTFOelBaVkh3QjJudlJONVFBVVpQWThKL1hPdUJnTWZUZ3Ji?=
 =?utf-8?B?VUlsNkRaSzBOdis2amNXUXM3RFBGS3M1UHFiVGZxUmxUbTdydTE0M3RIc0Fw?=
 =?utf-8?B?N2JqZXdwL2E4RW1DOExqQ2pVZDJWMitwRlQ4QTM3OWQxY1ZTZ1hubFcvc1da?=
 =?utf-8?B?VGdWeERBTklEREJpRVVXTmhkYkdmQWZxNzQwa2dDQ2JQUWZ6clBwUXZBZU9E?=
 =?utf-8?B?bWZzQnF2SFhwRjRxMEFMVlYySnN5S3FJSEFwNHdpNHU5cExZTUk5V0FTamZx?=
 =?utf-8?B?RDVWaktZMnZHZkl6Y0wwMWZwK09rMWUrSGw0ZVB3OVVlTzQzRHBuNVVyRjJI?=
 =?utf-8?B?c3pYdTY1cjZZb0c3eDd0ZFBFL2V4aDlOTHl5NnVOQTFNNnVIbk5tMzhNSGx6?=
 =?utf-8?B?elEyM1Q3c2JmMWF2ZmtYMHpDZ01icFhDTlZDcGtZbTRWM2w5dU9WRzNYYkRv?=
 =?utf-8?B?WWpGVW5ZQUtJNjJuTldpRi9sZnlWMDhEREwxeTR0a1U5cng2a3U3bkFuS2VO?=
 =?utf-8?B?MHNFbEJkZFJQSTNEYm5WUXVoSW1uWXY1MDZLNEoraTFpdG90bTF2SzBvT1Bv?=
 =?utf-8?B?RFZ0TU9GeGx4bHVhQ1pPTVRveXlhbk4xaEhvSy96c3Yrd1dVK0kzcWM0UFpO?=
 =?utf-8?B?OFhTRW42M200TnRwS2FYUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QjRISVU1dWRiUWpnYjhvSlNwMk9qVXVEVURxVFRlYzd5WnErMVRmQ242RDJU?=
 =?utf-8?B?b2YzeXB5MXBxdGdjMFpKSVNkRW55R3BDWDNQaXVRZU9xVExhelJCcFVpVi9i?=
 =?utf-8?B?SjBWL004SDJrTWpJY0tUem1kS05haWdmd0VXY3grZUxsVkhiaGtpYzU1TFA3?=
 =?utf-8?B?dFd6VS9LN3Q1MnEvNUpJU3hWZnhEa0pBaGJ4c3oxM1V4VVRWMFF6R25JVjln?=
 =?utf-8?B?T0RKTHVtbTJPcnBodHZneXI2Vi9VU1JwTUwrWXl6dk14Y1BUTlQraDY1ZHVa?=
 =?utf-8?B?cUc0c2syMVdMMUFOQ01PSlNONXVNbmVleU8ySkZ2RUxNZzFZaHRpV1dvcmVR?=
 =?utf-8?B?bVhQZXdXVlFDWWRnZUd6dEtiSDVJb1VWMEVYMko1ekVJbnZzQzNMUkZOU3Qw?=
 =?utf-8?B?TzRXb20xRy93eFNFTnhtSWdLWGxUMmtPRW01ZVQ4WWtsUlpxcUQyaUlkZ3NM?=
 =?utf-8?B?WDBVMC9XSFZqM2VnMTdzVENvRElUYWhVWGZ0Vllxc3paeEtkQjY0K3ZXMWFZ?=
 =?utf-8?B?Lzkwa1ZWVTQ5QXFVWjlKbU5GVnZTUi9hc3R1MGdwUCtNNGhVaGtPalpUSzUr?=
 =?utf-8?B?Y2hDb3pLaXRHVkpTbDJINWpPN0dNc1lJNGFlUThrbmFOTUJSNURPZk9kdzFw?=
 =?utf-8?B?Wkthcllaa0dUVHB3NmpGTjMvazlpb1E3aUlpbVl4NGoxQUQ1aHI1WWJsOTJP?=
 =?utf-8?B?ckMvekVudGRJRzEza1dZeUMzTjBDdUJpTUVJTTM5WWtGdUtaN0hneUhNVCtk?=
 =?utf-8?B?RXVhWExmVzM5NklMTUNHUzQwUjFqVFVkTHNNT0pjV3RyVC9aNmdYa3dqVnI5?=
 =?utf-8?B?SHNHMkJPRHZDdW9ETC95OGVSR2R3cmw5YXlJS0ZLcEZpZFg5UFMvcGdvVDZ5?=
 =?utf-8?B?OUFJbVlqUmo3MHVtdlI4VmlMakpkaDdZKzJFTG5JUW16d2hUQ0ZHRExlTGkr?=
 =?utf-8?B?NWJkS3BJanBXaVN0ZlZod0RGdFNGNE14aFRGN3c4NWZ2RWpMc2IyeE1pQjBs?=
 =?utf-8?B?YnE1YWROWjllUDFpalJYaWhsZ2VDbUdkbURPS2FHbTBZZEJ0cHo2VE9VdFpQ?=
 =?utf-8?B?NGNndnYxcUxWdVpHcHF5eEJYMCs2NmxaanY4N0xCSmRVVVl0Ty9DMnQ1UDJZ?=
 =?utf-8?B?U1A3YklUTjc1N1FhaDhHSHhBaHo5U3l1QklRWUl4a05xYjJXbUtkVkZzZFFH?=
 =?utf-8?B?b2xqV0VENUxnM0F2YmwvcnNmUGIzOEJzNHZoZ1p6bHVJYVp0QmQ0TVFUUG9E?=
 =?utf-8?B?ZnpDRFV6ZkF6S3R0ZEpKMjJkTWd3K3pjOGFRdTJqUWF6cjlEOUk4NGgxMnIz?=
 =?utf-8?B?RHNOL21JbTc0VHc5SXl6a2NiYWFFbk5jb0l6cmtsMUNDd3NWTlVqYWtDZ1JO?=
 =?utf-8?B?WkIrcmZWQTZxcll3ZDFmNTFzQjN0eG1VSnltaTlZNUE0VjhxQnZ5WHl2TjVD?=
 =?utf-8?B?aEdtNmtoYzBSYzJwdVZreXdhdDgxeUowb0MzWkdad1lRRk1Qd291ZGpVTTIz?=
 =?utf-8?B?N3MwcklKYlhaZm9EM3lZekVYaDlYbFV5eVpLNUlmMnhsSGhLWDdFU25weXcv?=
 =?utf-8?B?ZUEvbHlkaUF3UEk1SHQ0R3A3aE9BZ1htRDVPcHBVVWRiTGtQMmZqSWpWc1U4?=
 =?utf-8?B?bE1ydG13U1dwOTN2Ym9hTDZXR0tOMEhmOEE0TGx4RDlTU0ZGTjFCOUVzWUN6?=
 =?utf-8?B?UHAwL3JYM2pQc3cwclU2Rll6Q2NzSUpUVFBwdldrVGdjc0NVUm9OSEkxdlNJ?=
 =?utf-8?B?b0Q0Vmt2c3cwRVd6a0lBQ2krK2xyamVVMlZhbWh2ZXhsbHJrMVR3cFJjcE5J?=
 =?utf-8?B?eTl2SkhoQUVTZ3IvV0h5Z013UC8yVTVLMnU5N0R3bUlOa3V4aUp4b0wwdVRE?=
 =?utf-8?B?bkhrWHpQQkpsVUtDS09rVld1NlZSR0htajdmTk45YkR0VlhSaEF5cWJFOFR4?=
 =?utf-8?B?WE52NXN0WVZEb2hSTVJrbXpoUi82eFN3elRlZE1ZNzZ3RHRLSXl1M1N0UXY2?=
 =?utf-8?B?MjFrVmFHdjV0WjM1bkJhdk1WbTNIRUlrNzNDTnlxeVlSd3BrNVJ2dENFa0M4?=
 =?utf-8?B?dTVXTi9adWVRMlU4Z3VPdnc2Q013VW4zLzlJeTREaEJwZit2T29FNW0yTHpw?=
 =?utf-8?Q?E9OknYZ1VgAh6zd0gsdi1j0FK?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0031e811-e25b-46c4-bcca-08dcc7e71e5b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 04:57:44.1722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aJ6Qk/t6yDetL6roI752bNu+SPecUtws/LwWksACSh6my2QSY95zDyiQ7i4kwXkXlBZaiaPyZyjyERO6T6OAlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4253



On 29/8/24 09:42, Jason Gunthorpe wrote:
> On Wed, Aug 28, 2024 at 01:00:46PM +1000, Alexey Kardashevskiy wrote:
>>
>>
>> On 27/8/24 22:32, Jason Gunthorpe wrote:
>>> On Fri, Aug 23, 2024 at 11:21:21PM +1000, Alexey Kardashevskiy wrote:
>>>> The module responsibilities are:
>>>> 1. detect TEE support in a device and create nodes in the device's sysfs
>>>> entry;
>>>> 2. allow binding a PCI device to a VM for passing it through in a trusted
>>>> manner;
>>>
>>> Binding devices to VMs and managing their lifecycle is the purvue of
>>> VFIO and iommufd, it should not be exposed via weird sysfs calls like
>>> this. You can't build the right security model without being inside
>>> the VFIO context.
>>
>> Is "extend the MAP_DMA uAPI to accept {gmemfd, offset}" enough for the VFIO
>> context, or there is more and I am missing it?
> 
> No, you need to have all the virtual PCI device creation stuff linked
> to a VFIO cdev to prove you have rights to do things to the physical
> device.

The VM-to-VFIOdevice binding is already in the KVM VFIO device, the rest 
is the same old VFIO.

>>> I'm not convinced this should be in some side module - it seems like
>>> this is possibly more logically integrated as part of the iommu..
>>
>> There are two things which the module's sysfs interface tries dealing with:
>>
>> 1) device authentication (by the PSP, contrary to Lukas'es host-based CMA)
>> and PCIe link encryption (PCIe IDE keys only programmable via the PSP);
> 
> So when I look at the spec I think that probably TIO_DEV_* should be
> connected to VFIO, somewhere as vfio/kvm/iommufd ioctls. This needs to
> be coordinated with everyone else because everyone has *some kind* of
> "trusted world create for me a vPCI device in the secure VM" set of
> verbs.
> 
> TIO_TDI is presumably the device authentication stuff?

Not really. In practice:
- TDI is usually a SRIOV VF (and intended for passing through to a VM);
- DEV is always PF#0 of a (possibly multifunction) physical device which 
controls physical link encryption and authentication.

> This is why I picked on tsm_dev_connect_store()..
> >> Besides sysfs, the module provides common "verbs" to be defined by the
>> platform (which is right now a reduced set of the AMD PSP operations but the
>> hope is it can be generalized); and the module also does PCIe DOE bouncing
>> (which is also not uncommon). Part of this exercise is trying to find some
>> common ground (if it is possible), hence routing everything via this module.
> 
> I think there is a seperation between how the internal stuff in the
> kernel works and how/what the uAPIs are.
> 
> General stuff like authenticate/accept/authorize a PCI device needs
> to be pretty cross platform.

So those TIO_DEV_*** are for the PCI layer and nothing there is for 
virtualization and this is what is exposed via sysfs.

TIO_TDI_*** commands are for virtualization and, say, the user cannot 
attach a TDI to a VM by using the sysfs interface (new ioctls are for 
this), the user can only read some shared info about a TDI (interface 
report, status).

> Stuff like creating vPCIs needs to be ioctls linked to KVM/VFIO
> somehow and can have more platform specific components.

Right, I am adding ioctls to the KVM VFIO device.

> I would try to split your topics up more along those lines..

Fair point, my bad. I'll start with a PF-only module and then add TDI 
stuff to it separately.

I wonder if there is enough value to try keeping the TIO_DEV_* and 
TIO_TDI_* API together or having TIO_DEV_* in some PCI module and 
TIO_TDI_* in KVM is a non-confusing way to proceed with this. Adding 
things to the PCI's sysfs from more places bothers me more than this 
frankenmodule. Thanks,


-- 
Alexey


