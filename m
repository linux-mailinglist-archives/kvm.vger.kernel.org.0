Return-Path: <kvm+bounces-29578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E0089AD3F1
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 20:24:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E33C1285920
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 18:24:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DE991D0F77;
	Wed, 23 Oct 2024 18:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VYCtxgRR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2081.outbound.protection.outlook.com [40.107.244.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E8F1A2658;
	Wed, 23 Oct 2024 18:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729707835; cv=fail; b=D/CKmOqqLFr/jKxdU3hPutUvyKEHn13X8YLNB7743uRXsdocaVypdVeNKTPGebAyF1T6p7Gm4sI6RRbHW1VRYNt3KcZuyWoaxhVkpFmF+W/dsTsCfLBg9h9rtjdDSrrQLDQzOeM37BrFpWQaIxBTr5xXjFHKbL8AqotPsYhIDhs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729707835; c=relaxed/simple;
	bh=KgQkG4FWZ2F7t25UO9Pcb7aY2T7YO0aTU1sX0yL+u1I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gkDWhK2lgEGnrmmkYmgMe4C7dEoQQL+CdowKlPzHp6Wkq9ZkEWCPAKA0eS0yYDiRIhrV3cNLc2O11HgOV/AVRzdQBNfa2Xw+EX0Oriz+ow1v63FHuPrdMf9AsdiPR8BZRe2DL1Jtdrzlt6SbfnZvDxgfmGSPpdeYJltzCPWNbBU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VYCtxgRR; arc=fail smtp.client-ip=40.107.244.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ELZFhzHvnreRausUkoIuZY9TXrqKIsdXnyaru4wJZou2SA3rGC0gpB43x9lJTqNDk/2cvgFFzwk6bm9CZS4dTwbi4DcKanma2B5SjYDTJd2TuvhNmOIQdCqWMRlmp30597SbzngMs+b6/6b240qfjhNjJmbwX8eKvl7Pv5qg3LP7X4isnLUB63dT6/Fmi0LmWxlZ2p5tVQBtVHvDaLlhNTuYOha+WgsmrW7CO/xiYrQG7TBZFk11h2xA7AR9XVPXxrIYzF1LgQcm4/z1sq3cXph9NdScAXEtkvqe0qgXWnkqq9+eRpqwN7F41wwRn1G8NdD5a5IOnjMrfTXAq4wv+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OHqu9ybboAns18nmYwrqc4bYcPbJ5d35SQN+7hRd1bw=;
 b=Zy+awGgcwfhEJxo94Um0GXgxS5/ofT/wUZbvC+K4j2LOatE2Spl9Fm2hAiu4k55z5pSnYm4UFzgwTZL3vkZjyp79HXVjs6Dv1drvDQHzSJJy7c+0xhX0i5Lx0gx//C75rURovSeh+VylAuryO8sg80oJ2zzShGpi0L0P9sz+4hp9C6D9Zy4zqFHAqpi8XYkh/SRpz4Yiiy6maG6WDtgkrrx75oJWJF5upV0KyMqApIVGt0kZfHfrBFjb+6dt6d7CzGhRBV12LzZFhrorkeKnt2DzSq2SctXC6W5At3d92qnIspHezI3K9zohOCmEmfJ/UtVkrvTEWl/z8WQZULpg9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OHqu9ybboAns18nmYwrqc4bYcPbJ5d35SQN+7hRd1bw=;
 b=VYCtxgRRL7SQZ6FRjgQYsGmy8Ltwi4eZvivl13qnWpB3KSosTJ/CtDkIMq7yuc7ExyMV+g4GIElfi+6eB2BQz3s9UXquLOWoIxKEkOkjcSQ8onuIJe+h3YPDchsJICnaxSYcb1XD4u8/T/uv3n8wVYS1puTnMjpQBp2ZtU1yBE0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA1PR12MB5672.namprd12.prod.outlook.com (2603:10b6:806:23c::5)
 by SJ1PR12MB6340.namprd12.prod.outlook.com (2603:10b6:a03:453::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.17; Wed, 23 Oct
 2024 18:23:50 +0000
Received: from SA1PR12MB5672.namprd12.prod.outlook.com
 ([fe80::60f:5e8d:f0da:4eca]) by SA1PR12MB5672.namprd12.prod.outlook.com
 ([fe80::60f:5e8d:f0da:4eca%3]) with mapi id 15.20.8093.014; Wed, 23 Oct 2024
 18:23:50 +0000
Message-ID: <4eae43fb-28f8-4e84-afe1-812b71f890d4@amd.com>
Date: Tue, 22 Oct 2024 20:18:17 -0500
User-Agent: Mozilla Thunderbird
Reply-To: michael.day@amd.com
Subject: Re: [PATCH RFC v2 3/5] kvm: Convert to use guest_memfd library
To: Elliot Berman <quic_eberman@quicinc.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, Fuad Tabba <tabba@google.com>,
 David Hildenbrand <david@redhat.com>, Patrick Roy <roypat@amazon.co.uk>,
 qperret@google.com, Ackerley Tng <ackerleytng@google.com>,
 Mike Rapoport <rppt@kernel.org>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-arm-msm@vger.kernel.org
References: <20240829-guest-memfd-lib-v2-0-b9afc1ff3656@quicinc.com>
 <20240829-guest-memfd-lib-v2-3-b9afc1ff3656@quicinc.com>
From: Mike Day <michael.day@amd.com>
Content-Language: en-US
In-Reply-To: <20240829-guest-memfd-lib-v2-3-b9afc1ff3656@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:806:20::24) To SA1PR12MB5672.namprd12.prod.outlook.com
 (2603:10b6:806:23c::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR12MB5672:EE_|SJ1PR12MB6340:EE_
X-MS-Office365-Filtering-Correlation-Id: 178889be-7aef-43ba-18ca-08dcf38fd7b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V0doeUFnSUoyaGh5QzcwUGVTY1U3cWhEa2NWTmgwL3dvV1FoZHJNbnVxMC80?=
 =?utf-8?B?MTJ5RTNSQndzOFFOTms1cXlRQjVBNWIxd0xSMzhSVGFGL3kvQk9iVnprNjJu?=
 =?utf-8?B?UlcveHdFUEphTHFsWGtzZEd1dEJvclRKSnhoQVRIYk05bE1xeHNxVW14cEpk?=
 =?utf-8?B?RmcxMlphUHl5eGpGeW4vNSswb0RoYTJ3V2JIUzl5ZlFRNG81TWFyMENRK2g4?=
 =?utf-8?B?bGdoT3Q2SlRuMlc2TnJXbWd3V25oOCsybUViSi8yWWRneWpXNDluL3RVWGpj?=
 =?utf-8?B?TWdCeVJPNVp4aVRzOHhIcGJrK09UOFRXYm84WlVDOTNBMHdHTmljVUxySlZo?=
 =?utf-8?B?TEsrUTVrMi9sY3J1eTJ1b0xYU1NsZE1xSUlJNjFKV1M5OSt2aWd5M1Z3Zzhl?=
 =?utf-8?B?SEV4UGMxTkpYdS9YTGVBVFJSZGdnd21wTTNUNVR2Y2QrbFE3UTBZOVY4bGdM?=
 =?utf-8?B?VUFtUmxJSmc1dnBPekcwM0NBS1NCTExWbjRxSWd0YTdVSVlXTHVDcDNsNDlv?=
 =?utf-8?B?RE4vcytQUDdxQU4zc3BvS0JNc2daNWZnVlB6UmRVclNyZHFXWDIyZ2dCYUxV?=
 =?utf-8?B?bFFOSGM2M3E3SGw1NlBOSDYxN0pOaWN5QlJqOEFNSmRzWU9iSk05YmI3UXd0?=
 =?utf-8?B?VFhQRjRWcjNZa1JRRTFSVytyNW1FVEE3SVAzV2U4Q0ZxT0lSamVtOVRIMGhx?=
 =?utf-8?B?UkgvSytucHNkUi9yZ0FZcUZ5VExrWXZlclc1QzRoRGR2aFY4eTRMM0FoQjNm?=
 =?utf-8?B?OUJrMTY2SzBweTlsSktiWnJiRkVKYWpSNmV0WTlsUHpQM1JDUjJEajd5VWhM?=
 =?utf-8?B?ckxIbW14TmZYQWREVVpZdk4rQW8xYXdJQ0I1WktEQWVQRFB2UXAzM3ZHdzVG?=
 =?utf-8?B?RVhCb3pjSHVFaVJlZkVYRTE0WGg5RzZEdUlFTFhkLzZpbVhkdklPWGluKzJq?=
 =?utf-8?B?elVCV1VrTHdRWTVqTi9SL1ZLZmIya3lLcksxVTZHbk1seWlvWUYyNXIxZjd5?=
 =?utf-8?B?WXVKS1AwVzN6Q2paYnpQVE1jLzE3MTBRRkhrYVFycEV4R2tRUTZHbE5pOC9F?=
 =?utf-8?B?MGlDSldsMU5wVVZ2M3BCRDBKRUNZN2EyZjFseGhHU21Ma0ZMWFJHMjlDT2c3?=
 =?utf-8?B?WC9xQ25LVUtLbGp6dUpxUlA1YXRGZ0ZaZGhwczFWV0dqbitFZlNXcERUd2dv?=
 =?utf-8?B?dUJJV25OYUtiMUpnL3FlNTN4YVNwRjZ0cEloeVozSWhwdlhGMHhkVUFtbXlE?=
 =?utf-8?B?VE5aTTJlbVJWeGw4SDB1VDJXTzdXSTFWajV4RWtNeHF4TDhuT2crR05BQXhU?=
 =?utf-8?B?Wmt1RmJmOGhwM0hZUlozL3RUS1hVWGtPeDhCMjB2Mmo4L2RLTzhKaHFtNlhy?=
 =?utf-8?B?ZE0vQzB4cFZVMkxiMmYyM0JSMEZlOE1nb2VvTFRiT2VnY1hVY2Z4ekFMSDhM?=
 =?utf-8?B?OHVFUWFnNGlqZnIzS3BGUVBpaXEvS3paalZLaHdZMWp0WWxIYzFCSStZM1Ri?=
 =?utf-8?B?REhJeE81WjRIc0paMVkyWHdWQUVrNTJDN25SNDZ5blIvU2dkYTR1RUdqcjlE?=
 =?utf-8?B?WnNWZzAvN2pyRmdVazdDQjRGUmhRemVucGVCUDRBenUvT2dXWGJ6UlB4dWQ3?=
 =?utf-8?B?Q0pWeTR3Tm1KWEMxSWVuZk9uZXNRbVplL2RtY1pnaWF5QVNjMWhzZk94U0xy?=
 =?utf-8?B?aHQ4OEgxT1RISkR6Q0tUTmhjUFI4YjNWNnN3Y0h0RjNVNDR1RXZ3SDBtTUFL?=
 =?utf-8?B?b1JNdW5Bckw5dFFVS0FERlMwTWNpd1FpTWZCMVVrN0EyeGpXNTJtWTBrOHVj?=
 =?utf-8?Q?sUgP7f/JYNju9ApzY73+0GnZeVDBTuQ+q/d3Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB5672.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cmhMRmFvODI5TGpxdk9OZE1qTVhDUG1xNXZOZGM0TjVsS0xKOGdJZXBCSDdT?=
 =?utf-8?B?MmdnTlBaRExaRUU3ci9PVW5ONW1OaG1BdDNjd1dtd3dLZHBaN2NQOUhxUUN2?=
 =?utf-8?B?MXg3bkp2MmhkbDRsZHhkOU9ZWE82VzBVaisvZzVwb0dSZnh1UEF5dUcrWWNw?=
 =?utf-8?B?TDFyU1NwWk40YjVhQXg1ck1oVGtXaUppWFE5ZVhFN1hlSndsYkxjT0pmWEZz?=
 =?utf-8?B?SjRJcmZEdDhBeWt4U2lMUHI3RWZiWFZ2RWFMekZsdVdRSXltSEN1Y2hZYysv?=
 =?utf-8?B?TTVVaDFQa0ZCTFpVUW1iV1lZSUVoM3VrRXhqWEZKa0tsR0tmbHFkOU9oVkFB?=
 =?utf-8?B?RldHZXA1UUpNcVlxU2g4YVBVcnN6dUk3MmRuOG90TGJNZFpoL242Nys2eW1C?=
 =?utf-8?B?a3NSVVAzdGpaNW9NZUpWeGNGOFJaN1NsSUZyQUpoUU4xV2lockdtQ1JiTTlH?=
 =?utf-8?B?cktrVGNLRHFxZWROamNEdWNMeTIvNGczTEtTWEF1TkJkdmZ5MnYzT1JPRkxs?=
 =?utf-8?B?dFF5dTdBWjJSSkh3elhWOXhTcHpNQWs4RjN1czBzbXNwWW1KT0tmMFFEclhS?=
 =?utf-8?B?bkxzM0dNd3EwNzhUczg5eFhNbDVVd2VRZ2J0SzNyNjVxNmdOU2VXUHVJeTRU?=
 =?utf-8?B?aVkwSFlvNllERm5CVkY4WjBSM0g4aU5hS01iQ0d0MjJOWU1mbUZ1Z2l0U2tt?=
 =?utf-8?B?Q0pROGd3VkFFU282NnNYMm5kQ2FNSVY0MVBUQlJJMlQwaExCMjlLR0l2Sm1v?=
 =?utf-8?B?M0tOUnc4ci9JNkZpZ3ZWL1c0akVnRHRibWdsRWxqdEtGcTdGaWZ6T1BVNUYz?=
 =?utf-8?B?TEVvNWs4UmhkbzJzb01kR2lMK1RWbGNteDdVSzliNVFGQm9KOGplTWdieERZ?=
 =?utf-8?B?VHFlWi85UnQ2Y1BoL2tyS2U1SE05Zkd6SVdpTGw5dlROMnFaenI4RGZJY3lv?=
 =?utf-8?B?NGh6VGduaTZnczhETER4UFZJVGxVRDRqUXlKT0dEN05iT0lmRURTd1V4bkpX?=
 =?utf-8?B?d2NjT2RRK015cTJRSUVNK1p5RFFWOVJXU05Hb1VhaU0zL3g2T1RnMEtsUGxM?=
 =?utf-8?B?R28yV21NMmtEemxKU01Wa1pqUkRwRmdIMmJsVWxOUGd5TGVTdnFncWNabWlC?=
 =?utf-8?B?TjFPZldtS04yK25tSVBVMWtEMTl3WXQ4b05jNi85WUxsckNoYVFubExmVFZw?=
 =?utf-8?B?NzVrbi82VFk2YjA2ejAxNnhnbXVmRk02V1lFaEpFcmcxYUlhMXZQYWNobS9G?=
 =?utf-8?B?cTE2WmtuL1RCSlNrcTdlU2MyVnh3d05JQmVNM3kyeGlRMmxyZFd6VVRZWlE3?=
 =?utf-8?B?RlFWczU3TmhicG9MWGhSZjU5OURuR3BuNmNjSENaRVJKMjBqeDhOZXB6UDRF?=
 =?utf-8?B?ZkVHak00SE9vZThJWXR5RUpYNk9LTVRLRHVWL1ZENUlnSFdNME1JOUtUYTFq?=
 =?utf-8?B?SUMzVjgyWCtMUG94Z3FnOXpsNU5zejZRdTg3TVpaa3NZek5pMFNoMWhvajFJ?=
 =?utf-8?B?eU9tTGt5bXhCbFJ2eUtHOFBNWlo4RjI4OUF3c0tmeSsrSUhZdGgrbjJ0eWgr?=
 =?utf-8?B?RmdDcDJqd3ZCbjNaU0FsTXdtQUQzOFBmSklXOHUrbmd1SmtjV3Z5TlNWS1Nh?=
 =?utf-8?B?amlGais2cFBaRDZqUlRkdjNzNWYrMjNGTTFqOTJLZG80MXM0NTgwV3lSMlUy?=
 =?utf-8?B?WXlQc05LaFVETWgwNjkzVDQxc3owQnZKZEYvRmtsazZTM3dzRWFKWS9mQ08v?=
 =?utf-8?B?R2ZweDdrR3dLVVhNdDhnVjQ5SFJoMWF6QitPSU1yT2pxeFFmL3pmNnBmTjNM?=
 =?utf-8?B?bHpQUEJNR3BGQ25CTFlJYzI0TW5qbko4M1QxVzRKT0Zpa0I5ajRYK2tHMk5S?=
 =?utf-8?B?NHFPV1BrSko3RXJNUlNXQXBXVUhHcGFVZ3VpNTh5QUZqcC8yYnYybFVpTzJV?=
 =?utf-8?B?OW1ScmVxeDRBUlcvNzN0djYyNndvNW1leXdKcld3K205bHhKSS9XSC9LSlBt?=
 =?utf-8?B?TWlYYXF6SHh2eHRVQXpKUkV1K2UyNzBDenFkMytzNGpNKzY3WXRrTC91WTlj?=
 =?utf-8?B?ajlDWEVORGVNVDNjbytBTHdjclhzSjZqNTJQYzdGb1lyamVRejNZV04wdEFH?=
 =?utf-8?Q?Csynn2XT9nxG1B4lob/1NjDpp?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 178889be-7aef-43ba-18ca-08dcf38fd7b0
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB5672.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2024 18:23:50.5982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P6FjRCmIkykWeLV+g+BThi5emxHMj9Tf3fCP8e+uh6S8qnRtFRmldHPOmx1pxwmMZiZ3Ygkq1McpMw4+N6OMow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6340



On 8/29/24 17:24, Elliot Berman wrote:
> Use the recently created mm/guest_memfd implementation. No functional
> change intended.
> 
> Note: I've only compile-tested this. Appreciate some help from SEV folks
> to be able to test this.

Is there an updated patchset?

> 
> Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
> ---
>   arch/x86/kvm/svm/sev.c |   3 +-
>   virt/kvm/Kconfig       |   1 +
>   virt/kvm/guest_memfd.c | 371 ++++++++++---------------------------------------
>   virt/kvm/kvm_main.c    |   2 -
>   virt/kvm/kvm_mm.h      |   6 -
>   5 files changed, 77 insertions(+), 306 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 714c517dd4b72..f3a6857270943 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2297,8 +2297,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
>   			kunmap_local(vaddr);
>   		}
>   
> -		ret = rmp_make_private(pfn + i, gfn << PAGE_SHIFT, PG_LEVEL_4K,
> -				       sev_get_asid(kvm), true);

Need to keep rmp_make_private(), it is updating firmware reverse mapping (RMP) to assign the folio to the
guest. Would be used in combination with guest_memfd_make_inaccessible(), but that call cannot be
made from here, needs to move elsewhere.

> +static inline struct kvm_gmem *inode_to_kvm_gmem(struct inode *inode)
> +{
> +	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
> +
> +	return list_first_entry_or_null(gmem_list, struct kvm_gmem, entry);

gmem SEV-SNP guests end up creating multiple struct kvm_gmem objects per guest, each one having
different memory slots. So this will not always return the correct gmem object for an SEV-SNP guest.
> +}
> +
> -static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
> -				    pgoff_t index, struct folio *folio)
> +static int kvm_gmem_prepare_inaccessible(struct inode *inode, struct folio *folio)
>   {
>   #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
> -	kvm_pfn_t pfn = folio_file_pfn(folio, index);
> -	gfn_t gfn = slot->base_gfn + index - slot->gmem.pgoff;
> +	kvm_pfn_t pfn = folio_file_pfn(folio, 0);
> +	gfn_t gfn = slot->base_gfn + folio_index(folio) - slot->gmem.pgoff;

There is no longer a struct kvm_memory_slot * in the prototype, so this won't compile. It creates
an impedence mismatch with the way kvm gmem calls prepare_folio() on SEV-SNP.

>   	int rc = kvm_arch_gmem_prepare(kvm, gfn, pfn, folio_order(folio));
>   	if (rc) {
>   		pr_warn_ratelimited("gmem: Failed to prepare folio for index %lx GFN %llx PFN %llx error %d.\n",
> @@ -42,67 +46,7 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slo
>   	return 0;
>   }
>   
> -static inline void kvm_gmem_mark_prepared(struct folio *folio)
> -{
> -	folio_mark_uptodate(folio);
> -}
mark_prepared takes on additional meaning with SEV-SNP beyond uptodate, although this
could be separated into a different state. "preparation" includes setting the Reverse MaPping (RMP)
assigned bit - it eventually ends up in the sev code making and RMP assignment and
clearing the folio (from :/arch/x86/kvm/svm/sev.c)

	if (!folio_test_uptodate(folio)) {
		unsigned long nr_pages = level == PG_LEVEL_4K ? 1 : 512;
		int i;

		pr_debug("%s: folio not up-to-date, clearing folio pages.\n", __func__);
		for (i = 0; i < nr_pages; i++)
			clear_highpage(pfn_to_page(pfn_aligned + i));

{mark|test}_uptodate is still intertwined with the architectural code, probably should be
disentangled in favor of "prepare."

> -
> -/*
> - * Process @folio, which contains @gfn, so that the guest can use it.
> - * The folio must be locked and the gfn must be contained in @slot.
> - * On successful return the guest sees a zero page so as to avoid
> - * leaking host data and the up-to-date flag is set.
> - */
> -static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
> -				  gfn_t gfn, struct folio *folio)
> 

Is it correct that gmem->prepare_inaccessible() is the direct analogue to
kvm_gmem_prepare_folio?

> -#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
> -static void kvm_gmem_free_folio(struct folio *folio)
> -{
> -	struct page *page = folio_page(folio, 0);
> -	kvm_pfn_t pfn = page_to_pfn(page);
> -	int order = folio_order(folio);
> -
> -	kvm_arch_gmem_invalidate(pfn, pfn + (1ul << order));

kvm_arch_gmem_invalidate() is necessary for gmem SEV-SNP - it calls sev_gmem_invalidate()
which performs RMP modifications and flushes caches. When a guest page is split or released
these operations must occur.

> @@ -656,19 +444,12 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>   			break;
>   		}
>   
> -		folio = __kvm_gmem_get_pfn(file, slot, gfn, &pfn, &is_prepared, &max_order);
> +		folio = __kvm_gmem_get_pfn(file, slot, gfn, &pfn, true, &max_order);

probably need to retain a check _is_prepared() here instead of always declaring the folio prepared.

thanks,

Mike

