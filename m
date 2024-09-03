Return-Path: <kvm+bounces-25726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD4BF9696BF
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 10:17:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F28E21C23778
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 08:17:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6176205E36;
	Tue,  3 Sep 2024 08:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pkX6XLDx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061.outbound.protection.outlook.com [40.107.93.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C7C20125C;
	Tue,  3 Sep 2024 08:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725351433; cv=fail; b=tRjmVCe9iFYwdLBSS5bqRXIjWQOGta3WZI1FFtti6PzZfRok7ouebW1QG3Ndi4eBCzg4KnJPnxBZlz5bwKrmw9tj9Wswam0lpPVD/iyC/dUFl9+FSoHfnzUIMdZd7GX4FF7SuBUMuYgFz15oGy7sMUnj3RuwKQV2YFhgkxfmdus=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725351433; c=relaxed/simple;
	bh=fKXAtZPT/g9IfbkRm/Ncf9JndlxD/3b+1O+4320cVLE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=joSOgpu0eFjbfagxHQ6FfgKnNz8gbvhc+CoM2efvMLXjZEmRHsm++C9X/mGBYIvCxCJdp+xv332QeRS7Fl+9Hn4f7NcWiEjygM7ZhyQYzjC+4L35aoZGINhNBfpcZIDBsO8g+36iqSzIPqoc7IcX6tkXqbdQTeCm4FTenDUwAGs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pkX6XLDx; arc=fail smtp.client-ip=40.107.93.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PXFpkhuXp6mWSncK6a4yUEHCLhoqzcLU7300dohWdrJVrs5XdfeOw2jPFJ28OeQVatTwJAhSYWcVSWE75V6gRkIJDsMTBw1xGQ3wlEBhfr95eBih23aWQg45SUrA8zgZuOM51mtbAe1Hj/rVjBcqqnai/zeyTh1ipCw5almVQbamVItPNEiNfkziF+BkcBCLu96pN21l1lS6TzuJ2tHanaCOdmJVUNT93dHliu1GiWuQo38B0pWFWw/KhnsYqAV8LaElbfdNnC0Xd8U7MhWVPTIsoTih+yAfClm44YhAaFnzni4XKN6Qbe+W4Rw0oNxM+dPb3tfO81RktpYQXRHeCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qsSCNv2k74HRIzumT6iBf8blPI+lta0e90GEZDOq/+I=;
 b=H3MSRgelqQ1yNXnFqnr/Dfpu4+/mCh1R+JdPNpgJyDjoYSBVCKjGuGiEq2RMwvF16LemMe5I4LYq5o06pcQ2AlI1j/bqQ37MsIHW3OrLPovqSczx/3yM8DmkEh0u182SQobtcUb2P4NQm4EXMRdY1lG6LT1VRuu5LnvKGydY82mlDaPIM3kaNDcpe1pZbr4Ko0OgjYgSBasH+F4p28Z5AAW5rV5rGi1uEcswbvAoBGe7mgeP2akXx0G6h2NydhitzHKfhGC3ZFfvFf3XhGVbYe93aqo/8KhtKhUwRId0XAvnHARyLlTEnmB5raQwwPt7GtZcasVwRmsb8N5fT7ptyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qsSCNv2k74HRIzumT6iBf8blPI+lta0e90GEZDOq/+I=;
 b=pkX6XLDxEsOIxsnCVXyect1oTuKgbPOWSX334AQSCsbeuia4atbDRNYbl6chsNC4ZpRoj2zqcOfQIOrxE89gst2oD167843WdOH+9BGK4I9eImOdY7nth1W4eGR4d7n+ZWCtS4aCC1RaI8e+XWqgpJ4mlH5dxFDuRjPWewzfjZhxMFPstLbPzZcMbqO2p92bN4d07cJtu0r2Zg6VGuqmHxK918NbPpDx12d3uYEDDKhySFmQAXNmNbuNrhEpof4cQnTkR4aI6NGLEJouaqQRKdk9IoEsRXJ7fC3od7fAcLrrOc5TP4K2EdB3lolU5XgEYGG/5J+isJw6IuEaD2RPNQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS0PR12MB8295.namprd12.prod.outlook.com (2603:10b6:8:f6::21) by
 SN7PR12MB7250.namprd12.prod.outlook.com (2603:10b6:806:2aa::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Tue, 3 Sep
 2024 08:17:07 +0000
Received: from DS0PR12MB8295.namprd12.prod.outlook.com
 ([fe80::c1ec:bd68:b1e9:8549]) by DS0PR12MB8295.namprd12.prod.outlook.com
 ([fe80::c1ec:bd68:b1e9:8549%5]) with mapi id 15.20.7918.024; Tue, 3 Sep 2024
 08:17:07 +0000
Message-ID: <f0c7e66d-358e-4d03-b43e-4cd0796e495d@nvidia.com>
Date: Tue, 3 Sep 2024 10:16:59 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH vhost v2 00/10] vdpa/mlx5: Parallelize device
 suspend/resume
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: Lei Yang <leiyang@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Michael Tsirkin <mst@redhat.com>, Si-Wei Liu <si-wei.liu@oracle.com>,
 virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 kvm@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Saeed Mahameed <saeedm@nvidia.com>
References: <20240816090159.1967650-1-dtatulea@nvidia.com>
 <CAJaqyWfwkNUYcMWwG4LthhYEquUYDJPRvHeyh9C_R-ioeFYuXw@mail.gmail.com>
 <CAPpAL=xGQvpKwe8WcfHX8e59EdpZbOiohRS1qgeR4axFBDQ_+w@mail.gmail.com>
 <ea127c85-7080-4679-bff1-3a3a253f9046@nvidia.com>
 <CAPpAL=wDKacuWu-wgbwSN3MORSMapU8=RAdzp3ePgPo=6EMFbg@mail.gmail.com>
 <e08c5cc6-27e7-43b7-8337-095a42ed9698@nvidia.com>
 <CAJaqyWd-gc+BDx+DWvBLOEYP+q_Rb+L5n4txf1fcvrcbcE=_Nw@mail.gmail.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <CAJaqyWd-gc+BDx+DWvBLOEYP+q_Rb+L5n4txf1fcvrcbcE=_Nw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0075.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::23) To CY8PR12MB8297.namprd12.prod.outlook.com
 (2603:10b6:930:79::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB8295:EE_|SN7PR12MB7250:EE_
X-MS-Office365-Filtering-Correlation-Id: 3015fdfb-06d9-4da8-e8d8-08dccbf0cbf0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Vkh0b2ZZNGhOY1pETlhKRktmTFovcEI5NFV4QjVZcmZwVDJrZzRIWTFnaFBF?=
 =?utf-8?B?MkNmdlFSRlYzU0pFZ2xVV2V0MnFtVmxyR1J0OGoycG1lUWt5YUd4NmlrNlMz?=
 =?utf-8?B?TStsWXZhaDNUYkI1SVRXeW5aM0FqOGd1TGdGQ05lRWF6dEJQMnFiQVdKaWxI?=
 =?utf-8?B?UldaT3NvQy9TT1lmYVJxYlpNdXBMM0xKYlBPZDFhbEpNaklDQ013OEZURlJY?=
 =?utf-8?B?MjExV1ZpNmkxRGM5QVlNa3F1MDZoNGQ0c2syTUJCSWxjYmtsNlF1aDlVd0Uv?=
 =?utf-8?B?WXNEVEk3YlR6UndvN0MxbjBtMHhCUjREME50aVVpeXZzT3IwUllxMjFBcVFq?=
 =?utf-8?B?SU91VE9idHV2MFBERmhDSVhOb1B2eHhQeE9WWHg4UkE3RTlPWHN3bzZneEc5?=
 =?utf-8?B?VmVGczRuUGN5ZE02Mm84a3daVHV3WTA5TGlVQklJRGxMaXNEVkZXTjlwa21o?=
 =?utf-8?B?bUI5NXFrMnZRSXU5b0RORGFGRnB6QUd1amlGdTZvZUtmbEd0Skt1cnJTQzda?=
 =?utf-8?B?VFZKMGlGaDhFT2cyVjR3SmVHUC9GTVAvZU9EYlR6MndRejFKUzNvVUg2UU5j?=
 =?utf-8?B?KzdRdStXSzFnYVVBVWF0czBuelhCUHVzYjhPMHN3SXNiRlNSbzJmOE00QnZL?=
 =?utf-8?B?cW52SUJtSXl0V3pqbnBOeFRZdkFnMUlBcVZoQ01QbzQzcEdZYXQ4bDVKYm5L?=
 =?utf-8?B?WUdIWUt1N2hQbCthVnZkeGxBMzJDWFVaQWs4SDI5MFNuYVlybXV3ckxpa1Vk?=
 =?utf-8?B?aEFxT3FZVUtYTlVzc0IvQ3RaT2VuMTQ3UkR5WjQwa2w2dW95SzRJUmplR0ps?=
 =?utf-8?B?VTJPT2M5cnZZU0QzVjVacFd4aElDcUNSYUtoRW5xRXJ1aU9YNVhvek41Nmh3?=
 =?utf-8?B?UnhlRkZRNGxWTmRibGhHU01lMjBtSkpReWljanFvRTBkU0xsZTlVem84Vk9N?=
 =?utf-8?B?UFdzSnVwK3gvd2NKUzNLblpzdXNXZFhweG53S0R4VkY3aHgvdTM3VzJERTF2?=
 =?utf-8?B?ZXVKOUNXZVloeTlYWUdMQTJRWHRBNGV0NUI1VlFkZ1A3bVorYTlrWi9rZjRs?=
 =?utf-8?B?Tk8rWDhYVmV2Z2I0ZDlOcEpxZTFDYTBYdkFHKytuZGRxVWpPVGZQdlhLV0dG?=
 =?utf-8?B?VnNmWnJkVGkrS1drRmZ1cFhneUk4bnV3NzRiOXhHZWVLWDNOVTRtVmZZVDlo?=
 =?utf-8?B?bHVLaW96LzJPb21STzg0U24vR0VZOEc2UjR3S2Zham53WVYrZjFJaDE2T05C?=
 =?utf-8?B?QUtJYktxaVdIVGtqcWZnYXA1OUNUdUhjUW9TdE5uMzkwK2ZWa2tneTZSbGth?=
 =?utf-8?B?MEo4VDE1VWp0TFJqMXhKWE8xbVM5NDdWeGdFMWdtZ3IzZXg0N0xQVnJUV0hv?=
 =?utf-8?B?RHRUWklTdVZJN1ZRbDBwVGhlT1p5WmZMblJtWERJUHlvajBvUzJ3NUg3SDA4?=
 =?utf-8?B?UnNKQnl1RmdIT1BUYVppd0N6L2MrQk1BYkVrUGx5aUhjUmROSUs4QTNiMFYz?=
 =?utf-8?B?Z3FxUHhJaHo4cUhZdTZpNFFtd0l1RFJidzNTOHlTYUFWeFJYQlU3Sitka2ly?=
 =?utf-8?B?STJ5NHFZWVRmQkowR2tucURUNzFjYUZWWi9BdUhyZW9NbGFMczRXSzJteXN0?=
 =?utf-8?B?ek9VcUdzK3ZRa1RnUklUZlo3N2VoYnkyKzBYVTJVVDM1SDZIUFk1dS80TnJZ?=
 =?utf-8?B?UDB2emhHVnFWNFE5ZVM0Y0ZXVlJMMVVjcXRZTmgrL1ZnY2lac0JZcU9MYldM?=
 =?utf-8?B?eG0rNHVScmlkRDdVVWJTQ05pMS91dFlyTDJ5R3V3M21ncWNTdUFMK00vQ2N2?=
 =?utf-8?B?UlZlTDh1UGdnNTdVWTI3dz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB8295.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cy9NM3Z6WTAwZW5DTWM4cHZ1U2d1OERHblNwSGtmU1QzVURpYWtXRCs4WU5i?=
 =?utf-8?B?S1JsQ2haNlVBZERPRnEyQWlHUFpLRmtZL1BIMkxYV21IT1FCRVBqbWVpNmdy?=
 =?utf-8?B?Y0t4bWlWSGE5bjcxeUdGOTVTK0hvMTc4ZFRydXp3eWFDSCsyVGl6RmlxZ1ZN?=
 =?utf-8?B?ZTRveXRJN1IzdTFIQlRJeSt2Qys1WjY4VUJhN0x3STRpTk9NSFRFTlBoUkdN?=
 =?utf-8?B?ajg1MjJOaEVQZTRNS1NSRUYzbS9MeFkvLzVBcjl0R29reWlzQ2N6b2lrd08y?=
 =?utf-8?B?VmRCeVRHcWVlRmsvQThFLzdBZzY5Z1FNb2Zuai9heC9QaXRYeXBIQm5tak1T?=
 =?utf-8?B?TGxuWHdKdUdrcElUeXd6MmZRNEdOM0ozMi9rQVdHSFJienZ1b1VrVlgvVmZr?=
 =?utf-8?B?VlBSM1ZIcVNPS0lOL1Eyd2syZmpjV2YwRm4zWlZkWVpBcHZINnlJZk1uemRR?=
 =?utf-8?B?SWoyVjNrOVYwSHl6NUtDTjZDajV5TVo5WnZmWFEzN0pyRkEwSUpUMks4bHNo?=
 =?utf-8?B?UStvS0Z2eGlFMDVBTU1zb2g1SFJxSlk0SjFuT1hsSWI3UVVYQkU4VnFrY3Rn?=
 =?utf-8?B?KzhkUEM3WkxBNktHQ0VWR3JjellDcG53aFVwT1R4WGxlMFNEZitvM0ZXYjlQ?=
 =?utf-8?B?bGlhdGt0L2F4dm9ZbHRUSUI4NmpWNGRqcVp6Um03dWxxa3hWcXNHS2w5M0RH?=
 =?utf-8?B?SUFmVkVQTDljdVIwSS83YkRodWNZRUNHTXhLckpiYlMrTktvR0JyR1RnVmJa?=
 =?utf-8?B?T0srKzZuUWZxUmx3MGJxc3p6QWh0WlBOWHJXM2YrVmV3SXd0TXpIZkRYTzhx?=
 =?utf-8?B?MnEwT1E0Um1EdFRTdm5nQ2RrRjYrUEllQ1A3UGk5L0kwb0QrN0YranFJL0ZZ?=
 =?utf-8?B?MUw0YlMxQlFyNDdHY3paeWJTVVdCbkluQ3J4WGFsdjFpODlaS2dGY0crTXFR?=
 =?utf-8?B?bEk5OU1oK2RpM1hla2UvaVV6ZkpTelBqdGoxRFRWQ0hrbHZIcVhxRXBYc25V?=
 =?utf-8?B?dmpjajlBS2UzSEpsK1ViMUJjd2tlaVVGYnMrWUxnc29JREMraHp5dFdobmky?=
 =?utf-8?B?dEtNSmUvV2VaVURYTFU0bkMyaVRKeDk2akNUWlNKVlp3QkRCekordTdDVWI3?=
 =?utf-8?B?aTc3MGRFZjdYRDZ6VzhzVFhlWFRFWTVudjVCRGdJeDFSTVduYU5Tc0hSV0Qr?=
 =?utf-8?B?ZFJtTjhtQzZDVUhVRnFCUWFqdS9jV0ZZWkl5MnYrakprQXY4NnF1K3lic0Ey?=
 =?utf-8?B?OXRpdFc0UzA5SGFTUDBneDR1RXlTVkNHWFAxMS9pWTFJOEJPdkt2WXYvNWJR?=
 =?utf-8?B?Ymg3UXpvbzBrTHpabE93empOUHZpR09SVXZ6eWR1WFJHRzZSM1lQNFhhbG90?=
 =?utf-8?B?Sk5jY3dFWHZUMzBNWkxocHViQ1B3eE9ENmdoQXp2VW8weDFkcUt3VkZXNXVM?=
 =?utf-8?B?RCsrU25kdmw0VnErWkozSFgvQ2NaQmM0OURNSzR3ZUxqMHpZbDFaZHZCWVZU?=
 =?utf-8?B?dGxLMkN6bmFMYWhpMi93OFhjdHZQaTJwY0d3TmlPcG1HZ2JBYk5FaVVWdks3?=
 =?utf-8?B?N1lBYUc0ZFdqZFczTnhpaXYxR1lmOVdmWDlXaDR3MC9BRTNxNm1hSlBOanhv?=
 =?utf-8?B?R0RtMHc0alhudDZoeU9PY2twY1Z3VUZiOWRDMTRramk4NGhiaFczaVdpRXBL?=
 =?utf-8?B?R0dHcGtNZUVFeEdsU1RjVE41NXltTlRCd3VwTzJpVmtYTDV3a1FUVm5SbUJH?=
 =?utf-8?B?UmdGVnNCeElnaVZ6RkZIbW9JRXBxdS96NnpSd2dhN3lHZGdYSmtIQnlFVUc5?=
 =?utf-8?B?T0djT3JoMUdOd1lBdFRCbzlneTIrVjk3RWhHalRTU0lTclZ2UldhMER4a2p0?=
 =?utf-8?B?SFdhdnlNNm0vZDJSVGJPVTVjbGN4OEVYTVpnTThJeUs1SEorQnJjc1hCQ3Jt?=
 =?utf-8?B?VkwxaE5nMHFvYnhzZ01Nbzl6a280eE5mclhXOUkzT0c2Wlprd1pLZ080Z1Ux?=
 =?utf-8?B?Ujl3YUxrZVQzR045c280SVVFQytrRWNiSjUzRFZEelBjWTV6R0tFcEw3dFlp?=
 =?utf-8?B?enRnTnBXUDN0eEk5T0c1bDd4UkhLSFNZM2JXWkh5bXdLSk95ZVhady9oL2xJ?=
 =?utf-8?Q?8itlUgqbyr3uAg8CFMAbISd1S?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3015fdfb-06d9-4da8-e8d8-08dccbf0cbf0
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB8297.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 08:17:07.7815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5TwWzsPeMyiIo6XCSheIfCzJI4h9xSWf+Waftil+2Zq12lHC+pq+KibYNN369AUrUCPsJ3iUXIAsheU33CKWxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7250



On 03.09.24 10:10, Eugenio Perez Martin wrote:
> On Tue, Sep 3, 2024 at 9:48 AM Dragos Tatulea <dtatulea@nvidia.com> wrote:
>>
>>
>>
>> On 03.09.24 09:40, Lei Yang wrote:
>>> On Mon, Sep 2, 2024 at 7:05 PM Dragos Tatulea <dtatulea@nvidia.com> wrote:
>>>>
>>>> Hi Lei,
>>>>
>>>> On 02.09.24 12:03, Lei Yang wrote:
>>>>> Hi Dragos
>>>>>
>>>>> QE tested this series with mellanox nic, it failed with [1] when
>>>>> booting guest, and host dmesg also will print messages [2]. This bug
>>>>> can be reproduced boot guest with vhost-vdpa device.
>>>>>
>>>>> [1] qemu) qemu-kvm: vhost VQ 1 ring restore failed: -1: Operation not
>>>>> permitted (1)
>>>>> qemu-kvm: vhost VQ 0 ring restore failed: -1: Operation not permitted (1)
>>>>> qemu-kvm: unable to start vhost net: 5: falling back on userspace virtio
>>>>> qemu-kvm: vhost_set_features failed: Device or resource busy (16)
>>>>> qemu-kvm: unable to start vhost net: 16: falling back on userspace virtio
>>>>>
>>>>> [2] Host dmesg:
>>>>> [ 1406.187977] mlx5_core 0000:0d:00.2:
>>>>> mlx5_vdpa_compat_reset:3267:(pid 8506): performing device reset
>>>>> [ 1406.189221] mlx5_core 0000:0d:00.2:
>>>>> mlx5_vdpa_compat_reset:3267:(pid 8506): performing device reset
>>>>> [ 1406.190354] mlx5_core 0000:0d:00.2:
>>>>> mlx5_vdpa_show_mr_leaks:573:(pid 8506) warning: mkey still alive after
>>>>> resource delete: mr: 000000000c5ccca2, mkey: 0x40000000, refcount: 2
>>>>> [ 1471.538487] mlx5_core 0000:0d:00.2: cb_timeout_handler:938:(pid
>>>>> 428): cmd[13]: MODIFY_GENERAL_OBJECT(0xa01) Async, timeout. Will cause
>>>>> a leak of a command resource
>>>>> [ 1471.539486] mlx5_core 0000:0d:00.2: cb_timeout_handler:938:(pid
>>>>> 428): cmd[12]: MODIFY_GENERAL_OBJECT(0xa01) Async, timeout. Will cause
>>>>> a leak of a command resource
>>>>> [ 1471.540351] mlx5_core 0000:0d:00.2: modify_virtqueues:1617:(pid
>>>>> 8511) error: modify vq 0 failed, state: 0 -> 0, err: 0
>>>>> [ 1471.541433] mlx5_core 0000:0d:00.2: modify_virtqueues:1617:(pid
>>>>> 8511) error: modify vq 1 failed, state: 0 -> 0, err: -110
>>>>> [ 1471.542388] mlx5_core 0000:0d:00.2: mlx5_vdpa_set_status:3203:(pid
>>>>> 8511) warning: failed to resume VQs
>>>>> [ 1471.549778] mlx5_core 0000:0d:00.2:
>>>>> mlx5_vdpa_show_mr_leaks:573:(pid 8511) warning: mkey still alive after
>>>>> resource delete: mr: 000000000c5ccca2, mkey: 0x40000000, refcount: 2
>>>>> [ 1512.929854] mlx5_core 0000:0d:00.2:
>>>>> mlx5_vdpa_compat_reset:3267:(pid 8565): performing device reset
>>>>> [ 1513.100290] mlx5_core 0000:0d:00.2:
>>>>> mlx5_vdpa_show_mr_leaks:573:(pid 8565) warning: mkey still alive after
>>>>> resource delete: mr: 000000000c5ccca2, mkey: 0x40000000, refcount: 2
>>>>>
>>>
>>> Hi Dragos
>>>
>>>> Can you provide more details about the qemu version and the vdpa device
>>>> options used?
>>>>
>>>> Also, which FW version are you using? There is a relevant bug in FW
>>>> 22.41.1000 which was fixed in the latest FW (22.42.1000). Did you
>>>> encounter any FW syndromes in the host dmesg log?
>>>
>>> This problem has gone when I updated the firmware version to
>>> 22.42.1000, and I tested it with regression tests using mellanox nic,
>>> everything works well.
>>>
>>> Tested-by: Lei Yang <leiyang@redhat.com>
>> Good to hear. Thanks for the quick reaction.
>>
> 
> Is it possible to add a check so it doesn't use the async fashion in old FW?
> 
Unfortunately not, it would have been there otherwise.

Note that this affects only FW version 22.41.1000. Older versions are not
affected because VQ resume is not supported.

Thanks,
Dragos

