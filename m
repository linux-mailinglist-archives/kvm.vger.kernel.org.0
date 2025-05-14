Return-Path: <kvm+bounces-46427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CAEF0AB63E6
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:15:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B0F40462F14
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:14:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BD7B20A5DD;
	Wed, 14 May 2025 07:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IW94RySe"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2087.outbound.protection.outlook.com [40.107.94.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76471E1A3D;
	Wed, 14 May 2025 07:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747206861; cv=fail; b=hybD4nbCZIUdVurKhcNz0QIn0b/zNW0NNSjrhOxN94+3HC/xnrdKaQROGaPXoVfNJtgVYY8KIYCJY7+POjUIPj023EPd+SQVezgE9nEDCcQtmpVHJpHP8s0j/JDESPGGC0t2gFt9NBC9/kllr4wcH0sF6bDjiDQmMzjG5kstEkk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747206861; c=relaxed/simple;
	bh=Gu4MFDdFtUNuBsmuWjUjzHejDRJ/Ps6j/ZB/cnsj/84=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=k9UjCvhTj+hscms60jDfj/pqWqUk/rh1O+FChqMQnjCUWWpvdZ73aUiC9V4hdvlijWXNoJFZBmcg1UylAcs2lEIw4cAkOwRZe5Qx+fFM807KcoWHQINzkRz9wJfNbUyhk/ZczZxWULJX6bcg1rHnRslm8RmOqZ9e9FrJinNuaco=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IW94RySe; arc=fail smtp.client-ip=40.107.94.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rm4CwMV+QIN+lGPOc6X00NCI7Bh+1ycY74gSqF1s2akQ27AfOmNzi3G5/cRwImP5HMs7nwNo+Gx1sRwtiFeeLHCroAHJq0L9Ljv/861Bqehw3Hj8DUdmao5SvHynKEH+qbVUPbChA1CdsjNl1a3GMxIXwdlnOUrOq/+PaknE0C+PIlmH8scvLBwatC0xX1E38S+qKlTAdxVROA7OYc+FM9rSOYJPmscdHpCcwpC4usvSNT7kOc8DvHSFZUFHbWMk8qSW4ob2mfA2lc+ieMRAl5AVKAtIp5gylMZzMSxNHN2PQGyIacbIKWOr+kly20WlreKe4nHVT35VXBQPbiYBEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IoBoDQwlAfPEtwha5n8UisNA9D9/If5K7NKo1qFS7WM=;
 b=BwWIWnm5lPnioeKKeI9jDUNnmMFpp+3tGXtGGHUlz0dhFfuCARILv82DYCQPg4iMaLQE7t+UYDl7iFjY9XrmSaPxm6y3cCDkPpu9pg5RBKdPfhZXfDxn5oJzzQS/wIP5XnQJykKdv3NsrK7JCY6Q3DQnmwOarDILANJZ7Q0yc0P4+kItwX7ZJ31tlqSL6zWv2zZ9d/iNuL5KJYlnJxn1reIiiClQ6gAJiXBis/Bd01c3b1gqiQeZhnAknp0N9JRmThCQ19P1VUsAAYmoRstvAugq0P0J1pmNt+0vJrjkDEJGN4/0lncktkOF6xbv632sXSCpv2BC4/ltf/juGwvloQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IoBoDQwlAfPEtwha5n8UisNA9D9/If5K7NKo1qFS7WM=;
 b=IW94RySepIMwDQt1tDKbUEoik/PMCVSGpJn3CesmNPxITUlEfOkHxmUoXbv9JHTfy/vhFH7VwfSkjCc9A2+f8Zg/9JTEhaFvYvbWoUuTrUX20/ifE10V3LE3qjeC6D7jQoxY5kiezz7YPXE89XCQSIz4Xbdo3HOLJPrC08QSDz0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4262.namprd12.prod.outlook.com (2603:10b6:610:af::8)
 by DS0PR12MB7927.namprd12.prod.outlook.com (2603:10b6:8:147::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.31; Wed, 14 May
 2025 07:14:17 +0000
Received: from CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870]) by CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870%5]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 07:14:16 +0000
Message-ID: <55215c60-f071-474b-a0d5-06f27bc97d32@amd.com>
Date: Wed, 14 May 2025 12:43:49 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 10/17] KVM: x86: Compute max_mapping_level with input
 from guest_memfd
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250513163438.3942405-1-tabba@google.com>
 <20250513163438.3942405-11-tabba@google.com>
Content-Language: en-US
From: Shivank Garg <shivankg@amd.com>
In-Reply-To: <20250513163438.3942405-11-tabba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0229.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:eb::11) To CH2PR12MB4262.namprd12.prod.outlook.com
 (2603:10b6:610:af::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB4262:EE_|DS0PR12MB7927:EE_
X-MS-Office365-Filtering-Correlation-Id: 087f1803-9d0a-421d-a1cd-08dd92b6efbe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QmhkMEFTK3djVFVTSG1LMXp6cXpiaDJYOUZuc1JJeWc0bThSSi9MeUdlUVBx?=
 =?utf-8?B?cjlBaWg3L2ltUmx4RHVDdVp6aWF3SG1pcVRqZzgvNWV2MjVYcytrSVg1bjdh?=
 =?utf-8?B?bFdXdy8zV3dHZ1NSSXVrSUlkWHcyWThFdVo5ZzlNaWYwaW1Na0tXUkhJNUQ3?=
 =?utf-8?B?REN0MGE5b2lmajJZZ1hMZFRrTTBYRENyNFp0UTc1R0NXckY4L2VrNUpxR0Ur?=
 =?utf-8?B?U1VsZ0llYVZqYS93UGZXcSt5a1pTd1lJMzk1eTU0RjQ4cE5IWHhXakE4T29Y?=
 =?utf-8?B?ZFlzUmZVN29ZcDhyLzJscTc0c2Viek9xVWY2SU0rWXF6OXN6dTl3QUtPT1Bw?=
 =?utf-8?B?THduN0ZDSUdFVUtJb21vWVFDcXd4M2lROVRhc0JFLzUyamtrUHBaU2dKc2x6?=
 =?utf-8?B?a1EwK21jc0x0d2FkYk9JVVRORzF2bVhQV1g4bXJzSEVIS20wbFlWcWlqQ011?=
 =?utf-8?B?eW9oeTdmMFg3emNtQWdkY0xaOHFYMkViWHdaT29jU2J4WDFmaTZYTE5MdzJQ?=
 =?utf-8?B?SnV0RmdrMFBqemVBaWVaYkdzMHVuak9PQ3lldVN1NU9qRHlkcXI2d3NNcnd5?=
 =?utf-8?B?RjNHc0tvYm1pN0huNkF1d0RUNUFOZkRaOE9EcHVsaXBkclRoTkJ1MkZzVG9q?=
 =?utf-8?B?aUlwV0VNbDVXQlBSVjdtSVRaS0twREtuNE1WckRIVm9ZZm5jWmJWMG1oOGVS?=
 =?utf-8?B?OHBhdUl5MGNrUGZIWDY4U3dBcFNEZEc0WWxvaUNnVW9IT3RlK0hYMFV3YUJK?=
 =?utf-8?B?MGRtSHZnRWJUUVdQa3JObmtMT3RncFJxbkRyeGlGL05nMGVOS0xnRCtWN3Iw?=
 =?utf-8?B?YlNNS1Q4YmhlSEFDZk9VSzJ0WTBzSFdpRElxUjhhalM4cUFaeE8zWTA0S3hu?=
 =?utf-8?B?ZlJqSFVSbk5PaldmQW84Q21FYXEzVzNWQmgwMUJQWDlPRU5UMldTSnJmS3pz?=
 =?utf-8?B?UUpNSjRhdTR3NllydHVGOGRWZmFYYWxsMTcxalc1T0lLQWpGandIQlRPQ3oz?=
 =?utf-8?B?WlgwVUlSVnNFL2lhRXBVZHpwZnVoZjQ3bDljQ3piZjVzeXZUMmlJQ3dyYXhw?=
 =?utf-8?B?KzZKeE9PQS8rY0R1b2JWelNaTHZZNmdZbjl6UW9KWEUzRFpaWS92TGFoenpl?=
 =?utf-8?B?Unp1Yno2emR1YXQya05iQjBMQ21KMFRyTUFEUWxvUXVkN3JJdTQ5RVBGWGpS?=
 =?utf-8?B?WmZJRjBPN3F0OEg3REUzWHh4ZEc2Y3dEcWdvTkpVSFd3ajhIQmg1VDQ0cmh2?=
 =?utf-8?B?dUZUaVZoeDJDT2M4bjhOSGhYZkV3Z2k2djVOdDl2eml1bURrOURaUWVBSnQy?=
 =?utf-8?B?ZTNJWlRWZytjaCt1OVhWR1RWckNMdmYxWE5Hd2lKZW80SldYNzM4TXRDSnBZ?=
 =?utf-8?B?YVhRQjZOVHZpYkdQS1gwaThQWjhVTC92eWxmYjZsOVJmSFJLakxOTHRFTEtP?=
 =?utf-8?B?OXVWbEVGOVVOQUNyN2FGT3hFZEdyRkYyblJMRUFwVnRpWnQ3ZkNIMXVXVGoy?=
 =?utf-8?B?UmRheHFXRUx3eDFpQnFqU2ZkaVI2cmhLT2VadjNzNVlXaHlQYzVWRFNXcjQ5?=
 =?utf-8?B?NGdpblN6TUtZK2J3dE1McXRFa2dhVUowSithdEhET2h6NFF4d3RlMEsxUTds?=
 =?utf-8?B?dURvNnFSNWcrbjJhTE80K2Noa2NkOFdJUzV2Q2gxV2pBeEJxL1o0NzVJT2NN?=
 =?utf-8?B?cEJSVGlUejBQSXdnRk9EU0l3ZGVUSVVsNjY3WkRpY2lYTDNZYzJpTXpkQno3?=
 =?utf-8?B?M3ZwbW9hcTBKSEVLVFB6TXVSL1RyM0R2OGFWZXV0clNqQ25QWFlXRmpIZVht?=
 =?utf-8?B?NXA5d1dabit4Tjh1TzJadVBXdFJ0RWhsVTVWWU9Hc3VqVThQWk04aUVyeGdr?=
 =?utf-8?B?UFozaEtqb2prM2FTL1ZJY0VnbTZXcHdjUi9kbmQvK0JuNWhUYkZURjEzN0M1?=
 =?utf-8?Q?gktI6fLHdGQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4262.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bHhESm0rL3RmT29RYzRySGEwdkxCMi9sTmY4SkNvUkJBdG1Ob2RmR0ZRQ1pu?=
 =?utf-8?B?ZERhQlJubHNqdmxGeWs5dHpjanppTDdPajYxVHEvNi9OeEU4QmZHbGYxT3JQ?=
 =?utf-8?B?dWZZa2loR01Ba3oxTE5WMkRHdFVRdmdHQ3d0NnlCUVJQcDNBQUtPWks3THor?=
 =?utf-8?B?QWt3aEhCVUNWYTdpc3daRzI2UjA1blloRUdGOFkvaGRiQ3puUWF3WnljVHdw?=
 =?utf-8?B?TzVPVTBselRKcUlxVnQyc2ZXck9VNlFFRzFEa2FGVE1SeWlGa0xTaytLaHRo?=
 =?utf-8?B?cjhIOExwSjgyWEhXdFh0cjdoSGlocVN4UlJtQlpRUEUxMEU1Qmh5ZzdCalJK?=
 =?utf-8?B?QkhOZGx6VDBkZUZNdjlyY2F0akVhRlF1ejUyM2x1TzQyaVZmaS9QY1JoaWo3?=
 =?utf-8?B?aTF0MDVjNm5SR3Z6MXRZNFhuancvRCtQZ3oxR2pqTUd6RVM1M3hGTHE2N1BM?=
 =?utf-8?B?b3hKUkJ3UEJnOHpqaGlFcHFPNEk2NTFFd0NHb2k2bFhhc0xwQTNNRjUyek9K?=
 =?utf-8?B?NkZ0RG5hQ21qNkZqY29uM2tsU1ZLbUFjbkJ4NkViT3M3Vm1tdkNicEE2dVJk?=
 =?utf-8?B?bDFIL0VJc0ZoLzVUV3RBME1TaDVpSVJ2ek1kOTFLcUs1OFpNQlVPVkhnZnJM?=
 =?utf-8?B?dW96UjVBU24wYzlUbkxCbFhpNmNrcUl2eVZMU2h6RlN5N01Kc0hyanZjOHlK?=
 =?utf-8?B?UU9zcGFXdHAxUk9GYytWcnVZYTc3UmJRQjY1TTFuczRBdk5Fd0lIVFNoZW5L?=
 =?utf-8?B?SGdEbmFnUXdjUGE4YUF1dHRBNHlUUjljUExjMHJ5ZzNwMUJMbW9VMWw5NkxZ?=
 =?utf-8?B?S21iaDFvNFcrTGp3cFFSb05VdllWeHR3Y3I3S2tIbEdOVDZDNlVMWkVUVVdQ?=
 =?utf-8?B?dHBQajNXa2VvcHVoQ080ZWFGSndEdnJvUkhWZmtHWDhjTkVyN3dOMGxHWjJW?=
 =?utf-8?B?RUU4Rno5NHpRQ3FrckFUdHdUcjZCRkFkMERLa1ZyZk9OTDRnN2tzZ092RzZK?=
 =?utf-8?B?WTR0MVVVSURiWWJkVkVFTS8zbUdSSFdNVmgybXJQRldkRGhCTFhzUlFtUDNX?=
 =?utf-8?B?M1B3ZGVaUHJ0THM0YUd6R2tmUklsTW5zUVNvdVlnSXVaWTBXeVB1VlQrWkts?=
 =?utf-8?B?K1Jjd2d2RmFuSTNoWUdOdklHc0QzZTNDSU5hSk9sYjVxMTVqR0V3enp6d1V6?=
 =?utf-8?B?N01wdDFQZVBzZGtSM3BkY1FzQUYySzhqaGpqV1BaMlVEclZKUWkrU0ZqOG1W?=
 =?utf-8?B?ZUFhLzJ1Y01DZXlHQURwWXVoa1lDNG11dHRoYU8zQ1ZxWmdsdnJ2ekNhSnZx?=
 =?utf-8?B?RzBJTG1BWWhEM1M0WWExQ0ZITjRiU1ppYVJ4Rkl0K21WSTZuNVlLWEl3SWlq?=
 =?utf-8?B?czlXMUh2MEVHdnJ1aHcyUUViU3J3eE9JVkdxcSt2ekhkM09tSm5ROFM2N0JQ?=
 =?utf-8?B?SmZUd2xvbVQxQThVVW83NTY5ZVRYM29lb0dxdHlmWW00QlVPeDJEYm5pTnZU?=
 =?utf-8?B?N1ZnZTBEb2JXR3pLeGUwSWxpSWNxMG9vcHp0REtlV3FvQXZDdThDTWJqYVJ1?=
 =?utf-8?B?TU9wck41M1RDMW5HZGNSUVQ4Z0VwQ084bWxTWHBqQjJOQ3ZDN2tid1lRaDdw?=
 =?utf-8?B?eExxZHJmSHphR054RFhPVDJmK05MS1pRNW9tN1JHV0Y3RWx5dEoyU21TMHVk?=
 =?utf-8?B?NDVZTmRyam1rU2lvUWsyazBtMG1xTUVIeEV3cXBhK0RXSjBQc043TjQ1VFBG?=
 =?utf-8?B?MnhOZUZSaXJjWG5SV3pVNGtpVFc0OG1RQVRyODg3VkRkUm5QRy95TEkvd3hR?=
 =?utf-8?B?OE1xL2Z6MWc5dDBxN2o1ZnBPU2RYbVBBM0pJdjFia05lc2RSazJRVm9VOUJu?=
 =?utf-8?B?VmovMVpraWFrMW80QVZKRXppVlpQT0phekRGU0hSWHNjSnlBQjNya2NrZW9m?=
 =?utf-8?B?RmpkSUY5QndIUGc3NU45czZqbUpkUFhkNXowWG14YzBqRklrcTBINHV3RDdK?=
 =?utf-8?B?OGJaQ05HSlJkUGZoUWlBR2NJWEJQN3NpU2lHd1JOQmVYTHk3S3FNSjkwWTZ6?=
 =?utf-8?B?VjZBeGo5VENHWnlSVW9lcnRmQ1ZFQmJFV040djM3dEVZSGNPZ1U1YkxUSHNQ?=
 =?utf-8?Q?OzvGxZ2B90BJJT3jqYKwcbbBw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 087f1803-9d0a-421d-a1cd-08dd92b6efbe
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4262.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 07:14:16.3982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E6WsPHCQHmkT5rWgaFOqnpx87rgsB+ss7MdCjSq95G+Eh4FLUlA+jx/Xe+KD+7zIFE2TaMYi7J8TfcqXW/2UYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7927

On 5/13/2025 10:04 PM, Fuad Tabba wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> This patch adds kvm_gmem_max_mapping_level(), which always returns
> PG_LEVEL_4K since guest_memfd only supports 4K pages for now.
> 
> When guest_memfd supports shared memory, max_mapping_level (especially
> when recovering huge pages - see call to __kvm_mmu_max_mapping_level()
> from recover_huge_pages_range()) should take input from
> guest_memfd.
> 
> Input from guest_memfd should be taken in these cases:
> 
> + if the memslot supports shared memory (guest_memfd is used for
>   shared memory, or in future both shared and private memory) or
> + if the memslot is only used for private memory and that gfn is
>   private.
> 
> If the memslot doesn't use guest_memfd, figure out the
> max_mapping_level using the host page tables like before.
> 
> This patch also refactors and inlines the other call to
> __kvm_mmu_max_mapping_level().
> 
> In kvm_mmu_hugepage_adjust(), guest_memfd's input is already
> provided (if applicable) in fault->max_level. Hence, there is no need
> to query guest_memfd.
> 
> lpage_info is queried like before, and then if the fault is not from
> guest_memfd, adjust fault->req_level based on input from host page
> tables.
> 
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c   | 92 ++++++++++++++++++++++++++--------------
>  include/linux/kvm_host.h |  7 +++
>  virt/kvm/guest_memfd.c   | 12 ++++++
>  3 files changed, 79 insertions(+), 32 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index cfbb471f7c70..9e0bc8114859 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3256,12 +3256,11 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
>  	return level;
>  }
>  
> -static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
> -				       const struct kvm_memory_slot *slot,
> -				       gfn_t gfn, int max_level, bool is_private)
> +static int kvm_lpage_info_max_mapping_level(struct kvm *kvm,
> +					    const struct kvm_memory_slot *slot,
> +					    gfn_t gfn, int max_level)
>  {
>  	struct kvm_lpage_info *linfo;
> -	int host_level;
>  
>  	max_level = min(max_level, max_huge_page_level);
>  	for ( ; max_level > PG_LEVEL_4K; max_level--) {
> @@ -3270,23 +3269,61 @@ static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
>  			break;
>  	}
>  
> -	if (is_private)
> -		return max_level;
> +	return max_level;
> +}
> +
> +static inline u8 kvm_max_level_for_order(int order)
> +{
> +	BUILD_BUG_ON(KVM_MAX_HUGEPAGE_LEVEL > PG_LEVEL_1G);
> +
> +	KVM_MMU_WARN_ON(order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G) &&
> +			order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M) &&
> +			order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_4K));
> +
> +	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G))
> +		return PG_LEVEL_1G;
> +
> +	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M))
> +		return PG_LEVEL_2M;
> +
> +	return PG_LEVEL_4K;
> +}
> +
> +static inline int kvm_gmem_max_mapping_level(const struct kvm_memory_slot *slot,
> +					     gfn_t gfn, int max_level)
> +{
> +	int max_order;
>  
>  	if (max_level == PG_LEVEL_4K)
>  		return PG_LEVEL_4K;
>  
> -	host_level = host_pfn_mapping_level(kvm, gfn, slot);
> -	return min(host_level, max_level);
> +	max_order = kvm_gmem_mapping_order(slot, gfn);
> +	return min(max_level, kvm_max_level_for_order(max_order));
>  }
>  
>  int kvm_mmu_max_mapping_level(struct kvm *kvm,
>  			      const struct kvm_memory_slot *slot, gfn_t gfn)
>  {
> -	bool is_private = kvm_slot_has_gmem(slot) &&
> -			  kvm_mem_is_private(kvm, gfn);
> +	int max_level;
> +
> +	max_level = kvm_lpage_info_max_mapping_level(kvm, slot, gfn, PG_LEVEL_NUM);
> +	if (max_level == PG_LEVEL_4K)
> +		return PG_LEVEL_4K;
>  
> -	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, PG_LEVEL_NUM, is_private);
> +	if (kvm_slot_has_gmem(slot) &&
> +	    (kvm_gmem_memslot_supports_shared(slot) ||
> +	     kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
> +		return kvm_gmem_max_mapping_level(slot, gfn, max_level);
> +	}
> +
> +	return min(max_level, host_pfn_mapping_level(kvm, gfn, slot));
> +}
> +
> +static inline bool fault_from_gmem(struct kvm_page_fault *fault)
> +{
> +	return fault->is_private ||
> +	       (kvm_slot_has_gmem(fault->slot) &&
> +		kvm_gmem_memslot_supports_shared(fault->slot));
>  }
>  
>  void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> @@ -3309,12 +3346,20 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  	 * Enforce the iTLB multihit workaround after capturing the requested
>  	 * level, which will be used to do precise, accurate accounting.
>  	 */
> -	fault->req_level = __kvm_mmu_max_mapping_level(vcpu->kvm, slot,
> -						       fault->gfn, fault->max_level,
> -						       fault->is_private);
> +	fault->req_level = kvm_lpage_info_max_mapping_level(vcpu->kvm, slot,
> +							    fault->gfn, fault->max_level);
>  	if (fault->req_level == PG_LEVEL_4K || fault->huge_page_disallowed)
>  		return;
>  
> +	if (!fault_from_gmem(fault)) {
> +		int host_level;
> +
> +		host_level = host_pfn_mapping_level(vcpu->kvm, fault->gfn, slot);
> +		fault->req_level = min(fault->req_level, host_level);
> +		if (fault->req_level == PG_LEVEL_4K)
> +			return;
> +	}
> +
>  	/*
>  	 * mmu_invalidate_retry() was successful and mmu_lock is held, so
>  	 * the pmd can't be split from under us.
> @@ -4448,23 +4493,6 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  		vcpu->stat.pf_fixed++;
>  }
>  
> -static inline u8 kvm_max_level_for_order(int order)
> -{
> -	BUILD_BUG_ON(KVM_MAX_HUGEPAGE_LEVEL > PG_LEVEL_1G);
> -
> -	KVM_MMU_WARN_ON(order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G) &&
> -			order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M) &&
> -			order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_4K));
> -
> -	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G))
> -		return PG_LEVEL_1G;
> -
> -	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M))
> -		return PG_LEVEL_2M;
> -
> -	return PG_LEVEL_4K;
> -}
> -
>  static u8 kvm_max_level_for_fault_and_order(struct kvm *kvm,
>  					    struct kvm_page_fault *fault,
>  					    int order)
> @@ -4523,7 +4551,7 @@ static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
>  {
>  	unsigned int foll = fault->write ? FOLL_WRITE : 0;
>  
> -	if (fault->is_private || kvm_gmem_memslot_supports_shared(fault->slot))
> +	if (fault_from_gmem(fault))
>  		return kvm_mmu_faultin_pfn_gmem(vcpu, fault);
>  
>  	foll |= FOLL_NOWAIT;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index de7b46ee1762..f9bb025327c3 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2560,6 +2560,7 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>  int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
>  		     int *max_order);
> +int kvm_gmem_mapping_order(const struct kvm_memory_slot *slot, gfn_t gfn);
>  #else
>  static inline int kvm_gmem_get_pfn(struct kvm *kvm,
>  				   struct kvm_memory_slot *slot, gfn_t gfn,
> @@ -2569,6 +2570,12 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
>  	KVM_BUG_ON(1, kvm);
>  	return -EIO;
>  }
> +static inline int kvm_gmem_mapping_order(const struct kvm_memory_slot *slot,
> +					 gfn_t gfn)
> +{
> +	BUG();
> +	return 0;
> +}
>  #endif /* CONFIG_KVM_GMEM */
>  
>  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index fe0245335c96..b8e247063b20 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -774,6 +774,18 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  }
>  EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
>  
> +/**
> + * Returns the mapping order for this @gfn in @slot.
> + *
> + * This is equal to max_order that would be returned if kvm_gmem_get_pfn() were
> + * called now.
> + */
make W=1 ./ -s generates following warnings-

warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Returns the mapping order for this @gfn in @slot

This will fix it.

Subject: [PATCH] tmp

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 virt/kvm/guest_memfd.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index b8e247063b20..d880b9098cc0 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -775,10 +775,12 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
 
 /**
- * Returns the mapping order for this @gfn in @slot.
+ * kvm_gmem_mapping_order - Get the mapping order for a GFN.
+ * @slot: The KVM memory slot containing the @gfn.
+ * @gfn: The guest frame number to check.
  *
- * This is equal to max_order that would be returned if kvm_gmem_get_pfn() were
- * called now.
+ * Returns: The mapping order for a @gfn in @slot. This is equal to max_order
+ *          that kvm_gmem_get_pfn() would return for this @gfn.
  */
 int kvm_gmem_mapping_order(const struct kvm_memory_slot *slot, gfn_t gfn)
 {
-- 
2.34.1

Thanks,
Shivank


> +int kvm_gmem_mapping_order(const struct kvm_memory_slot *slot, gfn_t gfn)
> +{
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(kvm_gmem_mapping_order);
> +
>  #ifdef CONFIG_KVM_GENERIC_GMEM_POPULATE
>  long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
>  		       kvm_gmem_populate_cb post_populate, void *opaque)


