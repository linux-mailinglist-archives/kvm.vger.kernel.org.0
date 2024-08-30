Return-Path: <kvm+bounces-25434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F292D9655DE
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 05:48:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 237A41C209F6
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 03:48:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AE9F142624;
	Fri, 30 Aug 2024 03:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VcNVowNV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2059.outbound.protection.outlook.com [40.107.93.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C531369AE;
	Fri, 30 Aug 2024 03:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724989675; cv=fail; b=fVTg4MQi+3N1k17bSPF+hSlxNJnd2nLVK48T6kDgSctmucqkfdltgcpLNFOZeV4YZFICZmnqKcBVqTCL3REkgzHNRPoiCbqbf26GcJ3NRKrUXGfS7mur6xcQAsJ9ozjmn9iV9r6UJlGjuG8pIEszKHu3vbfy0BeThdM9uyfc6Nc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724989675; c=relaxed/simple;
	bh=uAXT0BPeVc0UlrlS81V9fyb0GrdioBPRUJItckOcVQs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Td63PhKRAS3XPjc4fQnWmW5wdOuKe9ZM0hKJwZWK7+rH4atEggoIjWu+wMADxfAe3ajqS5wVbwxXmPe41io52WOoCoZjACulJ8XlyUx8zZiWnxQcDnygUW7uFrSSo22aUTOSirT3ip1w62JYBOniXBqR+SdwVoN8OusOZ/GPeds=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VcNVowNV; arc=fail smtp.client-ip=40.107.93.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MS/EKW4SHTaPBJq+zc7ZG9iUQ44ay+GyKYuB3HH3gGxVm+eFmgShV61pZfbCR5YCjnGsmtg1dUIpqOjsGflaTrtl3ix0PuVDE12s0JYtIS87qp6+dZ4aQe9lJxzAJwTDbiBWrr04PWMg1RlXlWoIm9Kbz20B7jZnPDsoroX0Wz9FMS1wCUirwovz5Lc5zmF7YsH9e+4w+uI6+hvE4L8AMrMeZ4RjTv/hPh647gcZEfEe8uzLui8Oce0ihTNtbhNNFh/mnd8ZYBGUC2l4TcdxWAAd9dSeaDDLYPi+x2B5uYvkJOR5k/rdNkL8VKGRfY+vPxCP4W3uP99rfxejWprRsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Vvx8IzqlKBDKm1i5lg9MNWljxApnsYRi4onhI1CNd8=;
 b=inSzNSlsmz3j2hkmvZYf5FtedGxSEcix/ruv2vGbWljvhs1PXcm2vpwroAhpM/NwMRlktnPrEW5OnWGPjI7ERCjN+4oE6EE1+6tz5izzg/5il1Q/ay/KQooi2WM7SJk9XqjjsWd18GefESNFPOw8LfEhKsoJnr8LWwqoSmVT+OzNdnG5gufGUTQLyAeJVtCFqr1N9evgG39Ugou9kaIs6dGtZQNlIJLlSitTjwsrlZpU+hJ/d8sg1uJTjk+uJHQLYa12ckclc2plYOAHY4E9uXzHSLsYlWU9YpGPhbMTf0HYujSfGQ70IeyfvaNbk26gnSzjLkta/FYEu/EsAAoItQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Vvx8IzqlKBDKm1i5lg9MNWljxApnsYRi4onhI1CNd8=;
 b=VcNVowNVynmFCId/0w0tAwFJ8RQKwMVoVF9KJVXB0KYFgmIatrQr5ax85fNgiwXmDwvebBoYxrYDONj9DIWhVEtVgpXIAMR3P15Kpj105FvqbCVzjxfZjuzWXefIejuihAy15h5qGwTnoxlXvIMCdCLz2QFERIjHBXOBUSCp948=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by BY5PR12MB4226.namprd12.prod.outlook.com (2603:10b6:a03:203::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Fri, 30 Aug
 2024 03:47:51 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%6]) with mapi id 15.20.7897.021; Fri, 30 Aug 2024
 03:47:50 +0000
Message-ID: <c4156489-f26b-498c-941d-e077ce777ff4@amd.com>
Date: Fri, 30 Aug 2024 13:47:40 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>, Xu Yilun <yilun.xu@linux.intel.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 "Williams, Dan J" <dan.j.williams@intel.com>,
 "pratikrajesh.sampat@amd.com" <pratikrajesh.sampat@amd.com>,
 "michael.day@amd.com" <michael.day@amd.com>,
 "david.kaplan@amd.com" <david.kaplan@amd.com>,
 "dhaval.giani@amd.com" <dhaval.giani@amd.com>,
 Santosh Shukla <santosh.shukla@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>,
 Alexander Graf <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>,
 Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>,
 "david@redhat.com" <david@redhat.com>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-13-aik@amd.com>
 <BN9PR11MB5276D14D4E3F9CB26FBDE36C8C8B2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240826123024.GF3773488@nvidia.com>
 <ZtBAvKyWWiF5mYqc@yilunxu-OptiPlex-7050>
 <20240829121549.GF3773488@nvidia.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20240829121549.GF3773488@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY8P282CA0024.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:29b::13) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|BY5PR12MB4226:EE_
X-MS-Office365-Filtering-Correlation-Id: 01326445-da09-48b8-9db2-08dcc8a68511
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WEhJdTgrM1QzRVd3NXFSUzNSYkdTdC9COHJpbldGUS9mRG9HYTVrTDd2eVJp?=
 =?utf-8?B?ZVZZVVdKbUQ3RUJTL2U0bG1JUUFkU2dQMkZDTE5ib2toL3QzdS9wSS8vdGVI?=
 =?utf-8?B?Qmw3dU5XS2lrNSt3L3JwdjgwLzNKSi8vN0VhSnRmVHdKZXQrRkRzUDN3QWg5?=
 =?utf-8?B?Y2VuYVRsUWI2RHY5dDQ5bHJoT3Jhcm5JOS91WnhYd3Y1cXNoeGY3R1JVczBS?=
 =?utf-8?B?QWt4TlROdnl6VDFrcGd6WjNBTGpodUFIaWo2N2dNRzduWXFzeDdkcEFCQ0Vz?=
 =?utf-8?B?d1hZQzBnUm1kTTFleWwrM3NFblFpTFBhWDVmNWcvUUcxQ0JORmlQM1I0ODBi?=
 =?utf-8?B?Z3FSSW9Cek1YejgvMzZCa2tzVVlwV2tLUkxOTlJGV3lsTE1Ka0RWZ3krL2Jp?=
 =?utf-8?B?VWFYbFdXay9sWXNJa05CUG0raDFKVWd4WWlnd3dnbXdlZ2hJRUZyTHpWSk5S?=
 =?utf-8?B?U3Y2K2hGcG83ZlY3MUh3d2E2SjBOeHdSL25ENk13WElwWE1pN2RtQXM0MURI?=
 =?utf-8?B?OW1tWUtJV1ZGVkVlUGVhM1lqVUhEazFVRjZmZyttOXd5ajcvUU1WRlp5c0dO?=
 =?utf-8?B?UUkzSzE2cU9OdUwxa1IzeXI0dW5TNjNEc3k1OEE1RUcrR1lIdHlpNXUvQVVz?=
 =?utf-8?B?YmNHTWFnV2dCWUNKRWhTSDBCaTFoMXdIN2ZvRm9nUDlFYVMzNVJhNEliZ1dR?=
 =?utf-8?B?RFlnRkJqZWZTVHpoSFJJQU8zZW5nbHRoajQxUWo3Tyt0b0xrTkJNVi9PV1ZW?=
 =?utf-8?B?MkFUemQ4dlFGT2JFQ2F1aTM5Mm81WTZGWFFvR0xRNG40dVd6dHovZjZ2QVZo?=
 =?utf-8?B?bjlFTzNrUDgrT1BoVklJT3lCWXpjQlBjR1dYcDBuZnVIb296cVdpZ3k0L2R1?=
 =?utf-8?B?MHBDcThDK2t1TlNoa3JpUHM1U1I2QUJnY2plWElYU21wd3A4cnBraGc4UWZX?=
 =?utf-8?B?QjhlYys4Ui9VQ0lKYXJDeFFRUFVrTW80MDRhQWFuT0NySDZiT3BSV3VLRFlM?=
 =?utf-8?B?RmxzbUlrOUdRTGFvU21RWlZVSTFBR1VBUTNVb0JFVytCTmZJSHJiN0F4a2hy?=
 =?utf-8?B?RzJldHdSbXRJbU94NFdVWlRCbDZEYmlHKzVFY0RBUHhmSVB4cyswUVZRNGFV?=
 =?utf-8?B?MC95ZlMxK1g3RWt2eE1FbUt1ejJrM05MRDZneG1KcGNSdEpnWkN3cENrTVYv?=
 =?utf-8?B?a3BMRG4ydzNmNjh3YnlxSVZOSkI5b1BHL2t0VjZBMkhSTG13VDZvZE5WSDBJ?=
 =?utf-8?B?UmFEeDZZeG84OE1MUUVRQUc0M1VCWnIxQ1E3bDYySlN3RnFNYnNyekV5cVRo?=
 =?utf-8?B?d0Rtd3BJTnZHS0ZRYnVzRTc3a1VTcGlZTjJtSmRsbFFCTXRXeWJ5K0daN3la?=
 =?utf-8?B?WEZIM1RwcFdONUVlQzdXclRwbGR5WVQycnJmR2hSNlhEY0ZhbThhS3p5a2ZD?=
 =?utf-8?B?Z0tBQ1ZTejRXMzIrMHlTYVVmeThCRHhzOVpBbDVTRVNjbXBuaENzclhpRGpD?=
 =?utf-8?B?Q0ExcWs0b2I5N09FaCtOWWt1a1NpQ0FHM1c5UDI4QWFFWCtBZ0ovcGZRSS9W?=
 =?utf-8?B?UnBteUk1cUppR2NaZ0ZhV3lXVkRBS1lsWWgrLy9ublplcm9rTHVlZy9tMHhE?=
 =?utf-8?B?YkM3ODJlLzBRS1ZaVGo0dHZDN1BvNGYxQi9iSUdJUUZYVVp1Q2kzWEpoZTZR?=
 =?utf-8?B?S3EzcWtVbDhpV1drNjJyY1lOYXF0amJxcVNjNGRvQUk0NjIrbnZsekZpYlRo?=
 =?utf-8?B?T1J3eUpuZGZ0cVBCSUF3MWJQOUl2RjBZQkRYSHhndHZMTU5EY2p6MHZTanVX?=
 =?utf-8?B?WXhvOXUwY1BabGRrczJoZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a2c0UEJseUFuV3c5STAzUTZiVEpxbndMNDhONHc0bGNiZTVZTTZBdHlPMWI1?=
 =?utf-8?B?Ymh6YnQ3UGlSNWhKa3dwdURvVE1kMmswRnp3cFkwSEYyMkRkeGFUUEFMaVUw?=
 =?utf-8?B?UXBlai96T0IrSW0rVUtoSnoyQWhsc1E1M1ZrK2ZHaVo4NFliQVZoNUd0Z2NB?=
 =?utf-8?B?bEM2QkVhdjhvNW8wOXUyL0F0c0tBamdsRkpQZkdjazl0bEFUbmFOV0ViVmdM?=
 =?utf-8?B?SGZ2d0VmditOYmE4TWJvRFQ4Qlp3bGdWS1VWemxIcXpYOTFTeFFlL3BGK1Bl?=
 =?utf-8?B?eVJOTjFhdlNjWXk3cVFxSFU5bHFacjNCUXlmb215Q1FCSHBjdllLdEpqZGcy?=
 =?utf-8?B?MkdJNExONUxUMUdlU0o4N0pqak8zZW9RU2p1a3ZxWTdZMDhER0kzTjMybVN4?=
 =?utf-8?B?clB6ZzJmUHFySzBkcHQvcTJCWHNNQW9ZRjJITGF4UHdvY1lVeFUwbEV1bzFY?=
 =?utf-8?B?R2ZQVDgxejhoM3N4WlV1RE50U2UwUEhxZzFETjRFMnljQjE4QzAzUFIweXlM?=
 =?utf-8?B?Mmd6eUFhVGNzMkRBRkh4M1g4VHlpT25RaXRJY1p2QXc5SGcwZVhEMnR5eFVJ?=
 =?utf-8?B?VzBVS1pIbkJqQlk0cnZCaGVCZDhyVmJiVlR2bXVibnFTSGZ6U3QrMWhwRTE3?=
 =?utf-8?B?QzFhSFMzSUpsa2RjQ3BtMk5jRUtiWkhPeGpzLzZaWGkxU0ZiWjMrMXpEZGhO?=
 =?utf-8?B?dU93ejBrOEJuaG5IYzBmMGxxb29UVEhkaGUvZ3BHOW1QOGUzS0E2SlRQd0Jk?=
 =?utf-8?B?QlBaeGs5SFBqTW5ITEtyNUZCOUVvV3VQbjZXUGp6dDBXSnYrMFFOZ2VINkQ3?=
 =?utf-8?B?NnZPNk0wNmZFeVgySGpCNm5takhUWEk1SWhqSVRaTENENnBuYldnSlUrV2ln?=
 =?utf-8?B?dFB5d29JMmZpUzJUajZhSmtrWHdjc3MvWVAxWkZHbDBJWFNlNDlMZzdGZlVX?=
 =?utf-8?B?ZlJxcDJPYnZyRy9WdU5VT1VKSjQzTzVKSWJmNnJUQVZsYlk0SlpNOFN6Y2VJ?=
 =?utf-8?B?eG1LeVlsVGc5dHNqSFlvRWpCcTVnbU43QzV2WTF0eHJML3E5WUIvUjBZTVlh?=
 =?utf-8?B?YVc4ZVpSOUtqU00yMWNLdkxKMlJqeWtFZXdvN24rN3JsUXF3VEs4dWNUbmN0?=
 =?utf-8?B?OGhxN3A5akpESVlOcjVmNU43b2RnTXJmaGtPTzdPTFJPckdQRTZWWVZVd2lJ?=
 =?utf-8?B?dzcwSVh2cG9WdXNFWkdYV3lYZ2xPUW9qR0NROHVVdW5YYWRBMFpLTXFLb0Rp?=
 =?utf-8?B?cWVrSkhIU3FFMGtUMDFWdzFXNnhoQ2crd2cwWVBHZ1Zqei9Md1c0UE9EL3Jx?=
 =?utf-8?B?SmxJSGpRWG5iNEhYSjJycW1RYmlwcWE1U0YyemFjVHhablF4NnFFY3FOYUFF?=
 =?utf-8?B?aE10Z2pOSUdBdTd0aE9ZVGNxODBxM3NRVW9ieUNSOGdNTC9ZWExiUTZhTUhy?=
 =?utf-8?B?YVpDQ0VvZ1FsYXphVHplYlJqV0R3TTZIZWc2VS9lN1RXVVhaWTcrZURYTGdo?=
 =?utf-8?B?ZlZuTkRWekEzbjJtY0xQY05VTEc0b0ZDWmhEcmNoTVNKMFdmL2c1cXpqREJF?=
 =?utf-8?B?dGJOakFJcXc1L3Zod3NINXdOUWt2THkxc3ZTZjdJN3hqNSs1dHdrK2tNM1Uw?=
 =?utf-8?B?Q1RaYnRvcGZIZE1wdEVvejVyL2FObDVEbmR1U1hNRGltWTZOenlRL0c3N3c5?=
 =?utf-8?B?UkgvUmNqUWR5SjQ5ZWlmc3Z2YTA0MjB1RjE3UjlkTWF4SExmMnNKQ004MjYw?=
 =?utf-8?B?cjl0NTNBWEhUOXBxbktzTmtuRzJrcHZZRjRWeXcyaENNR3pQOFVhay9zNDFr?=
 =?utf-8?B?WVJCTXlJMEM2SzZGT3drdFpac0Y5aUlMc2YwRjZJOUtOTWtiYnA0WHgyayt6?=
 =?utf-8?B?cWRETWtNbzZlZDVwcTVuanptano5L2lXdGxSVGhBbHA4c1k5SjBRdEJVYVRE?=
 =?utf-8?B?V3BmYXB5dDh6R2FZSzFybDFKd2tpUkx5eTQvdmZKM1ZneWNjZDI3ZjhMS3JM?=
 =?utf-8?B?TDY3Ykx6OGthdDREblRuc3BrZ29Zb1hONmZFT0U1TjlHSU9CUCtveE9DdmFY?=
 =?utf-8?B?NU15QnZNck5NQnVOeFF3bmZTcFNKSEhmUWJETXpINnNERVZIekJIdVY4ejZi?=
 =?utf-8?Q?qHQVNQjHSZcvBGPln/ijmCHKn?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01326445-da09-48b8-9db2-08dcc8a68511
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 03:47:50.5472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q5rt0pw7pyGyHUJh4cslyBKzZFJqmtqwYm2nRTd9g/C68xrXaeiY2sWYqpfeGVo4yLkFKNC9JiE1nH7r3lmh4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4226



On 29/8/24 22:15, Jason Gunthorpe wrote:
> On Thu, Aug 29, 2024 at 05:34:52PM +0800, Xu Yilun wrote:
>> On Mon, Aug 26, 2024 at 09:30:24AM -0300, Jason Gunthorpe wrote:
>>> On Mon, Aug 26, 2024 at 08:39:25AM +0000, Tian, Kevin wrote:
>>>>> IOMMUFD calls get_user_pages() for every mapping which will allocate
>>>>> shared memory instead of using private memory managed by the KVM and
>>>>> MEMFD.
>>>>>
>>>>> Add support for IOMMUFD fd to the VFIO KVM device's KVM_DEV_VFIO_FILE
>>>>> API
>>>>> similar to already existing VFIO device and VFIO group fds.
>>>>> This addition registers the KVM in IOMMUFD with a callback to get a pfn
>>>>> for guest private memory for mapping it later in the IOMMU.
>>>>> No callback for free as it is generic folio_put() for now.
>>>>>
>>>>> The aforementioned callback uses uptr to calculate the offset into
>>>>> the KVM memory slot and find private backing pfn, copies
>>>>> kvm_gmem_get_pfn() pretty much.
>>>>>
>>>>> This relies on private pages to be pinned beforehand.
>>>>>
>>>>
>>>> There was a related discussion [1] which leans toward the conclusion
>>>> that the IOMMU page table for private memory will be managed by
>>>> the secure world i.e. the KVM path.
>>>
>>> It is still effectively true, AMD's design has duplication, the RMP
>>> table has the mappings to validate GPA and that is all managed in the
>>> secure world.
>>>
>>> They just want another copy of that information in the unsecure world
>>> in the form of page tables :\
>>>
>>>> btw going down this path it's clearer to extend the MAP_DMA
>>>> uAPI to accept {gmemfd, offset} than adding a callback to KVM.
>>>
>>> Yes, we want a DMA MAP from memfd sort of API in general. So it should
>>> go directly to guest memfd with no kvm entanglement.
>>
>> A uAPI like ioctl(MAP_DMA, gmemfd, offset, iova) still means userspace
>> takes control of the IOMMU mapping in the unsecure world.
> 
> Yes, such is how it seems to work.
> 
> It doesn't actually have much control, it has to build a mapping that
> matches the RMP table exactly but still has to build it..


Sorry, I am missing the point here. IOMMU maps bus addresses (IOVAs) to 
host physical, if we skip IOMMU, then how RMP (maps host pfns to guest 
pfns) will help to map IOVA (in fact, guest pfn) to host pfn? Thanks,



-- 
Alexey


