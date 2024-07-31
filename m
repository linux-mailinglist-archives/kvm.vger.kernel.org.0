Return-Path: <kvm+bounces-22724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 22A1A942613
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 07:59:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDCD2284A0C
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 05:59:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03F8954757;
	Wed, 31 Jul 2024 05:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rJOaRts6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2058.outbound.protection.outlook.com [40.107.244.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DEE619478
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 05:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722405592; cv=fail; b=kjHr4rU5gmhGJYLA4B18RgF2HcVcoAvVJn5YcTacGHvPPpePzYOteepf9/6P3ZDLaO2np9Vq5znoJOHe+N/NP2gs5KvrZaqfM7lNfo20OhUJUJzTPKRfjXQz8LBTOPCwCGe2nmKPJdxxf6+lxYBQg43exmkZrVfKc3EtDDnxWLA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722405592; c=relaxed/simple;
	bh=gVot12BHrnr+9aQPeqtFFWJnMWgYNDfcwWHZmKG7kZ8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=s0XVg3P8ABep09HxAUOR10ec22ckKORaiKs+33GE4ZuVnIx4Rn/2SVhp3o8rJt10kKygbc5sxbcKp7ehKZooYPSdQehXQaItE/ID8MpX7YYux8Ldn5jp//P2WdJQX9eBUDtqvcMQaNynQNTI0e6LYt4ZTrOGEZVJEK+Dfu/zbhk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rJOaRts6; arc=fail smtp.client-ip=40.107.244.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E+qrSmMw4qPkTDgDGy4YIsa6YNcwvwgcYkALKTJ6h5llazFy8b+CLtQ6R5PNkYoDMfjZrziKlzAFxDBy//XS8bfhABvZskJbKJ7T/6Ee5T7/rH/vBdp3pdakpr4hClhe9EjenfeoQVhz2NW/vCI1MeTWabsZIGa/imYJFmOz23YyRTtbSzrvjotJqnKku5UY+2aVAF/hnPYGTEMtULc1TXs85NLCdriZcLMDGVRJgixKBdW5PTNCxDzYDTh4pTH+MqykuFFZevHru3PuIrzY81TpfuLRe4Jl5wKmgzrKgeN/9Tv1XAuxLHDSfxCE7Hez7pijAQzGWHNzr7Gj9R8/Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9C0aFY27Nh6ZCQNtvWPO92VTpdsIz5+jJEfFksYlTEo=;
 b=qUWGGXGcb4JbRK2XWAIePYL1AEojIzD3nXdtY9wM1uxhjP8oZH4AKkI9iiyOrOE5HEKlm+FmmBaYVfzn6bwa+LiB+T3I6I6Vl0FeTQRFobBU4j01qaT4SCv8ldpoTjsHuSWRjjwqGV/IqvDbfV1fOwmnGeGgIks9kl02THgDrH5iQR58C/1eUFi9vzkfBh1j2LF7r1ocaUav/9wbZb45J0rYvcZzVqAkXZGT5WglfeH3YkRUnH9wn0zPZ0h3JP8a82xqUEIKs3UpUmjahwZKqDZhuRq2mLWfN9E8Xhbpdvd/wRIPJgY6Ux34A+A6Ec0b4VQBOUBoiplYWvNDnK+rmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9C0aFY27Nh6ZCQNtvWPO92VTpdsIz5+jJEfFksYlTEo=;
 b=rJOaRts6BYhrF3a32C0TuuiXkhfPg5kzXihEfacD6D5SPo2qj1O+5LB7ZQFm9ahuFY/Wz4uBn8QiWN04/6Av9BOWmlWj2rjC/bXyVGTKFhxqRlIi2SsGLZ1Eovs6p8RcSOjfmBeS5lZDUHKjt9QorhzxSZYnyqNcFgds4c2Ycc5nTiks4ePUpa54vjbbuCT1k4OIz1lQOsLiscnzgxra243MGcy/Nbllae7mJpjBsaBicZx9UuMdcZAXrFa5Rw29poPKbu0VhL0pmPzM4/0ZUA+VRwuzqnfO4eGLhSQlIp+sK2eNxUZEaZUR2+YKbLQbjxNXdWgbCi9r2+voXpSBWQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB5549.namprd12.prod.outlook.com (2603:10b6:5:209::13)
 by PH0PR12MB7792.namprd12.prod.outlook.com (2603:10b6:510:281::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.20; Wed, 31 Jul
 2024 05:59:44 +0000
Received: from DM6PR12MB5549.namprd12.prod.outlook.com
 ([fe80::e2a0:b00b:806b:dc91]) by DM6PR12MB5549.namprd12.prod.outlook.com
 ([fe80::e2a0:b00b:806b:dc91%6]) with mapi id 15.20.7828.016; Wed, 31 Jul 2024
 05:59:44 +0000
Message-ID: <462d7540-f9ad-4380-8056-232e69f161e9@nvidia.com>
Date: Wed, 31 Jul 2024 08:59:28 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/18] qapi: Smarter camel_to_upper() to reduce need for
 'prefix'
To: Markus Armbruster <armbru@redhat.com>
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 qemu-devel@nongnu.org, alex.williamson@redhat.com,
 andrew@codeconstruct.com.au, andrew@daynix.com, arei.gonglei@huawei.com,
 berto@igalia.com, borntraeger@linux.ibm.com, clg@kaod.org, david@redhat.com,
 den@openvz.org, eblake@redhat.com, eduardo@habkost.net,
 farman@linux.ibm.com, farosas@suse.de, hreitz@redhat.com,
 idryomov@gmail.com, iii@linux.ibm.com, jamin_lin@aspeedtech.com,
 jasowang@redhat.com, joel@jms.id.au, jsnow@redhat.com, kwolf@redhat.com,
 leetroy@gmail.com, marcandre.lureau@redhat.com, marcel.apfelbaum@gmail.com,
 michael.roth@amd.com, mst@redhat.com, mtosatti@redhat.com,
 nsg@linux.ibm.com, pasic@linux.ibm.com, pbonzini@redhat.com,
 peter.maydell@linaro.org, peterx@redhat.com, philmd@linaro.org,
 pizhenwei@bytedance.com, pl@dlhnet.de, richard.henderson@linaro.org,
 stefanha@redhat.com, steven_lee@aspeedtech.com, thuth@redhat.com,
 vsementsov@yandex-team.ru, wangyanan55@huawei.com,
 yuri.benditovich@daynix.com, zhao1.liu@intel.com, qemu-block@nongnu.org,
 qemu-arm@nongnu.org, qemu-s390x@nongnu.org, kvm@vger.kernel.org,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
References: <20240730081032.1246748-1-armbru@redhat.com>
 <20240730081032.1246748-2-armbru@redhat.com> <ZqiutRoQuAsrllfj@redhat.com>
 <87mslzgjde.fsf@pond.sub.org>
 <9b147a34-4641-4b4c-a050-51ceb3ea6a67@nvidia.com>
 <87jzh2kuux.fsf@pond.sub.org>
Content-Language: en-US
From: Avihai Horon <avihaih@nvidia.com>
In-Reply-To: <87jzh2kuux.fsf@pond.sub.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0069.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::33) To DM6PR12MB5549.namprd12.prod.outlook.com
 (2603:10b6:5:209::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB5549:EE_|PH0PR12MB7792:EE_
X-MS-Office365-Filtering-Correlation-Id: e416e816-f88b-4dd2-e85a-08dcb125f9a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NHVFajVQd1FTMGJjcThzTXFYSEVabVgxdVM4UlpnVklUVjduY2FtMS9jMVFV?=
 =?utf-8?B?Q2Q4dEJ1czlhQWUxSW9yeWRRN0kwN0dEdHhjQU01NG4zYnB6VTBlWjJubW9h?=
 =?utf-8?B?VzBjdkdyYi8xZXhaeWpGL0RETGNEUjBtUWtDVDkzeS9OcnVJR0h3WlpYR3dP?=
 =?utf-8?B?dU12NTNxaUhKQXJQWmZxOVN4TWp4emVRZ2ZiQVF1RHB3N2Z5cFlLaUZtTXAz?=
 =?utf-8?B?THRORjlqQWF4L0hucTlvZGZiRTBIYnY4eVN3MExCdGRUUzBPc1JQYmVsQVVP?=
 =?utf-8?B?bnhUbEpudGQ0eG1EdHlJVzBzMXVxNnJGT0t0YUQxVVNkSkYzYWJ1eVZROUoz?=
 =?utf-8?B?RW85Ry81eHFKdElVQ1pVVTVxUW9NMnh6WWdwVmF3YVFHaUF6dGhSWXpUSjRF?=
 =?utf-8?B?bExrTExVS0kyT3VZakoreks2cVZTUElQNUJvc1hkQjRKOURMSEJ2TmR0enRr?=
 =?utf-8?B?NVJ6TEVBbWdEejdMRHpYRnBweUkrQTJ1REF2UFB4aHN4WlJuUEhBU2N3SFBB?=
 =?utf-8?B?YndFWmdwYVNGdnpZN05JNzQvaDNodER3ZzFOY3N5NFVXQmdnQXJzZjNnbXcw?=
 =?utf-8?B?dTNqQjFTVjkzYStsOXpQNE1XZ2ZnV3VBK0ZZekxhMVFjSU1ZTFgrT1F0YmVo?=
 =?utf-8?B?b00yMVN0Q0tsM0N0cW9YOFp2T1BZUFVxbW85NENqQjduSFdBUnloSCthOVhJ?=
 =?utf-8?B?S2wybUtQazlnOUdVZ3hZY0o5VjRPTXcyamdCNmwxeGwwVHRGQXRLemVwc0F3?=
 =?utf-8?B?WXhkMnl6a2pYTnJ4ak94VnI3Nm1vb3A2UzNkZ3J5WThnaHZzcnBscUptQVBj?=
 =?utf-8?B?dWRnUmpYK0tGWUpWYWtiMHN5emd4Ky9PNGV6U2NNK081Y2FjMCtQNHF0bHAx?=
 =?utf-8?B?Y09XbE1hUitxRnJ5YXZmRWFyMm9OcTZNMnQ1bHRiQjg5TGVUWjFoU0hZMW9V?=
 =?utf-8?B?Y2krSzBFMDZ0NXdpU3BxQVNxWjUwRGpTWWo4QnB4d3VxWW1zaDJjS3Zsc1pa?=
 =?utf-8?B?L3RHclVTRmwwZDgxODdNWHplZndVK05NbHRNSlQ3d1MxNXZzQzMwVGhVWDVR?=
 =?utf-8?B?M1VvWnZ3N2wwdWcrdW5FUXNSd2JrSlYybWNKeE0rL3FCWjRSdEhKcXFMckxq?=
 =?utf-8?B?YXZjUXFnS29ubWVuMUtpSkQ3eGV6RzlTYVBSdVhZL3MyZDlkMFdId0t0N0Nn?=
 =?utf-8?B?RldJWDVtakN1TERiVENmdHg0VjV0eGtaeHczY0ZEb2hUUVQ1TDczd3NxeTNT?=
 =?utf-8?B?ZlEwK05zSlBVcHQwRk9yMStBRE5FQVBScXpwVTdaaUxtb2JwMFFlOVdTUG43?=
 =?utf-8?B?SURoNFgyYityMkxTKzRmUXVhUHBwU3k0M1o5b0tta09RMUFSazdQbExuUWho?=
 =?utf-8?B?bkdqYU9tbFArR1VWLzJSYVZBRUVMNng0cjR6S2EzZXAxL0NYeVYwOGdxQm9m?=
 =?utf-8?B?K3F2ZktCUVNBQUFkNXFrVmx2V0J5TDNyTXlCSVdvVU9YTFBkbEJaMmo3UmdR?=
 =?utf-8?B?OFdwS3lyYmI4aDVGaC9lcEJaWUFjK0I3Zm5rZDcrVS80U3dJWWdaSEw0Vys2?=
 =?utf-8?B?VFNDZ0g4dkxHeG9vbVJwYThFMmRrMjRaeWVzK3lkMFNTdTd1d1l4ZFBIbGVF?=
 =?utf-8?B?UXhIUjB4UkxCRUJrNTRLMDNRNkxXcmVqT00zZjgxYzRLQjErTEh4VjJsQUJO?=
 =?utf-8?B?SUwzazFDVHVnWXo4Q2JlN011dFJOWDVpVWNYRjlBWDVaRHp4RmdyNlIxSXJo?=
 =?utf-8?B?VUg2aEFBK01UbzZ6eDVYWHFIRGpCMHNCOTJRdTJ0S1QwUktHZ1lxdTd3bWRa?=
 =?utf-8?B?ZEVEaWtCS0g5R05hS1Y5UT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5549.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L3JJcE4zMlNHNlpPM3JGTHhvS1pqaXpjZDFYdXNQdy9xMUt1bmN5ekxxeDIy?=
 =?utf-8?B?aG1NenBQRHhUK2NtcFVneW82cDFiYWdIdlVVTXNHRGw1RUgwZHIzT3I5R1p4?=
 =?utf-8?B?VTRUMFlhQUFMcFZEbkZ0SXJUbXIzSmlZd3B4cUlYdmk3clhZVTlSblhaK1pY?=
 =?utf-8?B?UktJenBIMW1pSTYwcTVYRFlVODBud0g3UzJRWmlyalVaRU5ZSDQwL3BxNktv?=
 =?utf-8?B?ZXZrVlMwMnEyRVZENFNRK01vVFpjK2dVcW9QN2ZsTmlubFVJMDZsdDNGMGEz?=
 =?utf-8?B?RGJ4UERlY3VZRkN4NjlPNkNlNTBXejIzUWFHcnFURHdsbkRNaTlVUHZjRnRQ?=
 =?utf-8?B?c3prZG1JNlF5NTVYTC9FUlkrdnp3eXZUYzVBb254eDk4TXRYZE9xVkR1TUFu?=
 =?utf-8?B?MTFYb1Z4N2NpNVVrbEdTdFBoZzQ5bXFFY3p5b0hjRStGc3duZGVWeEc2bHlG?=
 =?utf-8?B?ZEszL2hoZlVQZlFwMURiSWtNNDFvZ21lRyt6WCtTbXViNEZ6OHFPQ0ZLaW9X?=
 =?utf-8?B?Y1BxL0lzTmdDa09Nak4yMTZCUWRETDB6Qm9EaVl4MTd5YmR1dEhnMWNscWNJ?=
 =?utf-8?B?V1orMEhXQm9FbFhUelhnRTVDUmFlTjk5SXdQYWQ4TmhZTi9uUS9ueWVRSnVR?=
 =?utf-8?B?NG52RFp1WlR4ZnJpYjJiSk5uQTBzcDgyNC9IMDZUZFQxTkVRcThPd0lRQ0N6?=
 =?utf-8?B?ZGNWMjk3NXYwSFJUeXg2UXZiQXloWm1QdTFrdzZRR3ZuSFVPMFhkeXZBUjN1?=
 =?utf-8?B?RXEzMFd6YmNySzVmSGJpaUJWVklzQTBJNHE4K21tN2dzWHVtTFRneHp1VHcw?=
 =?utf-8?B?czBMWGErQzVZMHMxa2x4eWI4OG5EUW1mOFhneW5ZcG83M1pUTjVqelFXZGti?=
 =?utf-8?B?QnVWNXEvSzEwd0x2Yituam42dmdCRWNZayt1c0t1eDkzaGE5WDZXT3VpM1ZX?=
 =?utf-8?B?dm5LU3hCdTZ0YjBHOXUrY1k5MjZjZE4rRncvRmVZdjF5L045U0dpY3VUOWlP?=
 =?utf-8?B?NDA5My9lOGVJK3YrY005Mi8yN0VGWi9uWi9CV0tGK3RPUDJDWFNJVmJhbVZ4?=
 =?utf-8?B?SVBQV01YSHRaQjd1ZEd6SkllT2ZNWWJId1U4RFNmYUlzNU9pbndTdnZvck4z?=
 =?utf-8?B?MzhDTHNVTE5xempGNlhSNEVSclk4MlBDazdHVmRnREpESWNJTkxuOG9pUUhK?=
 =?utf-8?B?dC94SUU0YmVvWnIxRkR3QTRSQVowaVZrT0cycHdicTk0OEFBY0ZzSkNvMjZZ?=
 =?utf-8?B?NkNsWFFMSTNHQXpzRXY5T3ZUTXlSZDhiVnNYS3FRczU1NmVud1cyMis5SUhw?=
 =?utf-8?B?akJVU1hHZUF0QXZvYS9McVdqYUprTjdGUkFDTUNTM1U0VEFiNnFwcG5CajQ0?=
 =?utf-8?B?UERKUmYvb3BNbXRoQTVtb3YvN1ZPOUdJZGdsMnBhSWZJeXRjOENCR1pWV01W?=
 =?utf-8?B?eWZQVWUxSFBpQmgwSytQZWlCeEN5dllVRkpwQmNEamlqMUFpRjhpNTM0TXZk?=
 =?utf-8?B?MmFXeVN5MytxdDd4STJjd1duRGZkcy82K0huNmc1ODhWZWp1MWMvZ09KVjRy?=
 =?utf-8?B?YWRMdndVbmZjQkh5TThLK0xSNWw2TlhoWTR6cllIZWc5bkRYTFRuQUVZdE4r?=
 =?utf-8?B?YmZITVVINXNEditXVjlyV0dJTXVRSmNxYUJ1b1dlbjVteXlyV1JFWFhNQWZE?=
 =?utf-8?B?ek1UQXYzQXFrSlZJOUhGWnl2NUZIY3RsL2ZZa2VZam9EYTV4MWh3Ynl0UXVO?=
 =?utf-8?B?bXQ1SExkOHZxcmphNW1aTzhMRzRXMGZQSVM5cklDMStjNnkrcy9HSEo1WUtj?=
 =?utf-8?B?L09TODV3UTdzZVhWcEpNY1hJMnlxUERzQnRlV1Q0U3h0M2RZQytCOWQwMkxW?=
 =?utf-8?B?NmdIcVU0Z2VEVnNRN1FLeU11T2huSFlMbFhGN2Q5TVlvN1JFZm9aVFdiMjFN?=
 =?utf-8?B?TzJjV1ZDdFMwbXhkdzRQN0NxUDVUOWpOTmlWcVcwam4yVjQ4dG9FeTU1L1Js?=
 =?utf-8?B?Nmh0dlg4ZmMvQVJycnc2ZUhvVVEvdXM3NDZnb2xxR1dlSDNOU1hOeEZobTNm?=
 =?utf-8?B?QndNcUN2a3VySE54dU1ZTWxMWjluVTlSeU1aS2E0ZVN1OTdzbzZ1ZVBReVZI?=
 =?utf-8?Q?OF8aAQQzxWIsZO3M5GlBVhi9C?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e416e816-f88b-4dd2-e85a-08dcb125f9a2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5549.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2024 05:59:44.4048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A9/lNE5eBLGkG78liDaC6I0j0HSmVj/tskNrjfRYERlkTKgFCLeJrKStiCXBspfQxRBIBY4mvTszc55A4++E5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7792


On 31/07/2024 8:12, Markus Armbruster wrote:
> External email: Use caution opening links or attachments
>
>
> Avihai Horon <avihaih@nvidia.com> writes:
>
>> On 30/07/2024 15:22, Markus Armbruster wrote:
>>> Avihai, there's a question for you on VfioMigrationState.
>>>
>>> Daniel P. Berrangé <berrange@redhat.com> writes:
>>>
>>>> On Tue, Jul 30, 2024 at 10:10:15AM +0200, Markus Armbruster wrote:
> [...]
>
>>> * VfioMigrationState
>>>
>>>     Can't see why this one has a prefix.  Avihai, can you enlighten me?
>> linux-headers/linux/vfio.h defines enum vfio_device_mig_state with values VFIO_DEVICE_STATE_STOP etc.
> It does not define any VFIO_DEVICE_STATE_*, though.
>
>> I used the QAPI prefix to emphasize this is a QAPI entity rather than a VFIO entity.
> We define about two dozen symbols starting with VFIO_, and several
> hundreds starting with vfio_.  What makes this enumeration type
> different so its members need emphasis?

Right. I thought it would be clearer with the QAPI prefix because 
VFIO_DEVICE_STATE_* and VFIO_MIGRATION_STATE_* have similar values.

But it's not a must. If you want to reduce prefix usage, go ahead, I 
don't have a strong opinion about it.

>
> [...]
>

