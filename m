Return-Path: <kvm+bounces-25672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 146D19685B9
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 13:07:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B90E7284D12
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 11:07:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0A69185924;
	Mon,  2 Sep 2024 11:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IiNybRkV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2067.outbound.protection.outlook.com [40.107.93.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD3117C7C3;
	Mon,  2 Sep 2024 11:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725275149; cv=fail; b=MGhE1mJMqwLDVLds/g5pNJ908IHC6AniUg9/7SlX3Nq7cxF5m4Jj7oYWJ+35+BIufYmG0QMeirdXoDzos++tN1V+MkkZmW4mFIyuJpD3fko7hFJYXlNIW+jWt+n1BAE9v7llIK9rlE58Mw4uz0JhTJIuJrLMO9+WMU4vXtw8mbc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725275149; c=relaxed/simple;
	bh=ejwtHaYePj9zV9ehmFp7pCCN2Z1UvoXsnMpZe0Hy7/w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WrzQcVkKHf7mgEslAmNbhH5MZoPPDV2ckLC5QycduPTpKjQDTH40aBa0dbO53oCFfRXMJhA5Qvh34SxgsnFTQUPi6oZEsqSEjRvfNHosHNVuHXmR2axBtjJGrLG1si7RDzD8OIl9l6+IzHkI9n6ljey1nAYUkHjb6IMrouy2LKA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IiNybRkV; arc=fail smtp.client-ip=40.107.93.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ixvW/SHcEn97qqNtzNyqnCQ2JOGPwPBrWo4Nj0c2cvqvl3mNTOV6qXqhaAP/lNTj8jz7ILre/6/9iKp6MRbcj2iHIDCmZ8PZPcq5ay3SoGNN1i5LVIWWeES2g7IkX8OtfqeJ8zr29YLbMsLFxRWSpZyOc7UofItNSshQ89RFO2UMPk1f7BLWlnpJq64UlBoWxK9u+9DF3hO8gt+1Eh2DAfNaASkHCcEHwlhG0sqVBj8QQFzn9inPFjX31pxijYYJZYE/jHFNOl8wpjn6/nHetrNegKsq8d1B6X0n6lirKR1DW4UtLiTmteAgW2GE0Acvsw7bOm9piJLkKAXGLfV3VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0+VeEZ3goeiO6rm3vx3SxjF2O0rxNVhmsenXX680hjw=;
 b=sukqZvapLX2J3DrlZzJrVb9+tbzEZQuq4N3aHRgmcfjA021IVtBRCkk2IRq4dPF6Xu+H/0/7CYVXf37RjDH+qZQUJiio84NZDZ06zuvrpdaVVNyWYJ1M7B6OFsvatvajUA2anTJyU7smXB/h5AsCasLkSr+u536G1040dNHAtRug04ETSafsAqxFQ+wA2Pn6ULtdHm2h5hah7AVwjOM/Xh04+ap8I8ZurwUnYJxrUXLcDxRetyfDGvZNwmOsmt5qnADCyViG2jVoIAXb6Rn+r/llNHmIlzV78aSmxVGlX8gbaOGnak321tx6gIU10+n+av/GSZ/Hg9nt3WXzeEexLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0+VeEZ3goeiO6rm3vx3SxjF2O0rxNVhmsenXX680hjw=;
 b=IiNybRkVk/cC/NoKcc3BX+v95XoOTXUpf54gp2/7lBzHNuvD9uAVTRfuQR8AhmxxLjEhgLqX4G9r6we/YxzThXP6lugPgTXyT0P8axZgX0jRxauDJD5mtyJHBRpSkqgr/RE+OWY9UsuMdWec8LXpNazdY+NF0HlQoQC+K2AS5kgVFmiHP6hPh7nhM7uEuCBI2OGZ3DtLRqd89NHTlL3s7SkB9VqpV1p3KVGgz8qT2EOmhzyRXIDZTXWtxzJD4M8zXjcFlnqLVFi9LMphuoPZwpDnuBeKz2BlDTSh4ScJehQCRF9A8o9EBZX0DpIQgFAnJ/5GLv7RsXPdc+f6iNrBSw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY8PR12MB8297.namprd12.prod.outlook.com (2603:10b6:930:79::18)
 by IA1PR12MB6409.namprd12.prod.outlook.com (2603:10b6:208:38b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Mon, 2 Sep
 2024 11:05:44 +0000
Received: from CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4]) by CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4%5]) with mapi id 15.20.7918.024; Mon, 2 Sep 2024
 11:05:44 +0000
Message-ID: <ea127c85-7080-4679-bff1-3a3a253f9046@nvidia.com>
Date: Mon, 2 Sep 2024 13:05:39 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH vhost v2 00/10] vdpa/mlx5: Parallelize device
 suspend/resume
To: Lei Yang <leiyang@redhat.com>
Cc: Eugenio Perez Martin <eperezma@redhat.com>,
 Jason Wang <jasowang@redhat.com>, Michael Tsirkin <mst@redhat.com>,
 Si-Wei Liu <si-wei.liu@oracle.com>,
 virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 kvm@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Saeed Mahameed <saeedm@nvidia.com>
References: <20240816090159.1967650-1-dtatulea@nvidia.com>
 <CAJaqyWfwkNUYcMWwG4LthhYEquUYDJPRvHeyh9C_R-ioeFYuXw@mail.gmail.com>
 <CAPpAL=xGQvpKwe8WcfHX8e59EdpZbOiohRS1qgeR4axFBDQ_+w@mail.gmail.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <CAPpAL=xGQvpKwe8WcfHX8e59EdpZbOiohRS1qgeR4axFBDQ_+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0333.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ea::8) To CY8PR12MB8297.namprd12.prod.outlook.com
 (2603:10b6:930:79::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB8297:EE_|IA1PR12MB6409:EE_
X-MS-Office365-Filtering-Correlation-Id: f498d90d-928f-4814-daa9-08dccb3f30d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RTZwbW1DRkJQMUFmQUdhZURKSlUzTWpPNXZoTkc5UGtCTndvNXc4eHVxMWFY?=
 =?utf-8?B?ZVI4cXpldkxvUjRkZ3NGUFdDS1JTN1V5SWVINnl2djRoaTJkNjgvenFEbzVv?=
 =?utf-8?B?VzJrUE0zem9NeEhiaHFsOVI3aEQwL2dvejJmb2JWUXk2MU12Nnl1aWVaRXZD?=
 =?utf-8?B?b1JTOVNaRmNER1h5anQ5NUZ2NjZqTDNycTIvRkF2T3pTTFJiWVl5VTNVVzF0?=
 =?utf-8?B?QmhZbHlzNkZTS21EVlhpQVUwS3J3bTh4djc2WXZma1hQWHoxNjhaSnFtV2hP?=
 =?utf-8?B?a3VKS2RDdVA3SG9PNU42eVBGcUFQTHBmNU9LZVdNWFMyUitzaXhHRmwzSCtt?=
 =?utf-8?B?b0N3dUFjdHNPYmdsKzBVTk1nTmFHY3Q2cGJ4ZUZOSXR0SVdDZkdVRmRFb3lL?=
 =?utf-8?B?MzNUNkxLcFYweVhnZitpcXB0bmtFRnErNHFuYjEyUFFsQ0pUbDNnVHN4WFhX?=
 =?utf-8?B?Q1RNem9hZlViallXYVpJcU03YlZHR3hoYTh6aGJkaGZySlcvRmV5T1lVbW94?=
 =?utf-8?B?MVFOQjh5cHVJMjd2SlBmUzBLb3d6TGRubGxvSkU5Wmh5VWdJRW0rWW5oNWFF?=
 =?utf-8?B?WGlhRVNsOE1kQmdPbnhjRkhaS2RMK1NQRE5HcGJKcHFKL0x1T0pIRUJ2ZWMr?=
 =?utf-8?B?N1IwV1IyMVE4d2NOaG9wNG5GTjV0RGZidURvdlFSSmpKdUszd0dsajR6aTg4?=
 =?utf-8?B?alBISkp4MmJRQ1hpYmNrWUtCN1Y3YXY0ZmZIQnJDYzlVZ0h6RndnUFJzK0Ux?=
 =?utf-8?B?YVBUbGtZeG0yMkhjSm5VSm1VVmpnZTViUXh1MXViTHU2ektxYWZxZFIrTUt1?=
 =?utf-8?B?VEQ5ZWxrVWdYRU8yRjhpUTc2Uk1GdE1BSFNwZnZvV3haRjEwT0QzYW42TGgw?=
 =?utf-8?B?M1NZaHZJUS9uT2ZIZEdqckp0NzM4MSs5allMZlNkTDJxL2VDY2RMaG8wWU5v?=
 =?utf-8?B?NUNBNXZJcENEbkphV01FL1AxQ3pIOHgrTVg2cEFYQXhCQzE0Yk8xTU5PdzBZ?=
 =?utf-8?B?MFFLcW1jSXE1ZWsrWThYeHEyMXUvZkh4WWMwV3FYcFVDN0VkVzk3aVlWMHJP?=
 =?utf-8?B?eHk0S2hlbUlCSEY0dVREbEo1TDRjOEV3Y1hEbkxYcmY5NTZTQmZERG5jeTRz?=
 =?utf-8?B?UFFrUjMyRlB5eGVHdVQxWDNzNFhYRGNaZkR5OGcrUEE0a2VqR1pqa0FrYmJy?=
 =?utf-8?B?OUhMSzdsdExuWDVjbjhGS21NYnVvSDh0TW5iWGxlQW8yTnNPNi9MU24ydHhN?=
 =?utf-8?B?ZU1Fd29zWHY3TlV2bUI4R2FMUXlqdUpmK0FSS1BDM1pIdmN4c2JIekpPM1JQ?=
 =?utf-8?B?UXo4RmVqRHZDb1NKU0o5YWRFdzJBUmVDK3dmcENDVFg2OFYvZHllSEx5dkxI?=
 =?utf-8?B?TUZtTFdkLzJoRjJiTlN1cUlVVnAra2xZckM3SUx1c3QxZElCbGgxRDdJcGxQ?=
 =?utf-8?B?eXJPaUc4MGlkcXgxdWxFRUZ5SnY3NlMrTTFXdytjQ2FvQzlrV2xXcUhEL2Jh?=
 =?utf-8?B?Wm5Qd2xrRFF4UzJkamhXbGNKd0UrREdCNkNOVW0ySW1zSkdLUTVuOGlWNDBM?=
 =?utf-8?B?NHF6dVpxWXlsMVRHdDdQS0Z1Nm0zRTF1RmNlVGZUOFoxRzdVai9uK0JHMkxI?=
 =?utf-8?B?eENZQnZMcm10OERramdYMVhKUUV4dTQwdU0ySXlnRUlPZUJ1dmZxSkl1L0ZF?=
 =?utf-8?B?ejloQXhINkFNQ0UvWkRQNm9IdkpCbnA0MTMzUWdIWmR0VEU2RHcwYW5KbmZs?=
 =?utf-8?B?UXpUMWNUTmVzU1ZOT1d4NC9VVEVOSUt4ajR1eXUybk9nSW44Wlc0TWoxaGFE?=
 =?utf-8?B?ZnRKdExncWRLdjlpQW8vUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB8297.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TW42T1FBQmlJZU1QK3dqQ21CL3kvWlhSS2w1NHlNQ2szbHFBQ2NKYVFpNjRt?=
 =?utf-8?B?aHUxN2VSOG1zT1BOaDFmWUZsWHpPVkpjRS9QaDN3TG53SnNKMmhxcGlHb3k4?=
 =?utf-8?B?OUpKQzZQUy8vS1M1cWNGQm5YY2l3MFZzQmRmTDRKQWhxaUR4MnBJUHhUMERt?=
 =?utf-8?B?T0NOcFA0a250M29mSEFzTWxuZnJ0TkNPTWhSTTJxVjFGWk1EamMwTEN4U1p2?=
 =?utf-8?B?L3RjNzJSb2I2VDg1eHAraHk5bWEwdEl6eHVyVFBzYTRJdU1lSEx2bFBMbmI4?=
 =?utf-8?B?TUUzWHRFaWVrSGMrSlIyQThLTzZTcWp1ajdkRHpOZXVyRWs3Ty9obExBd3hn?=
 =?utf-8?B?bDkwWUMxaXZLMnJTdHU2MFdPYzZPTHgvOWRPUXRBNEdaUnlERWROUkVHWWVR?=
 =?utf-8?B?TTR3S0RqRERkTk95emIybHgzSi9UbjAzZDc0bDBrc2lRdWZwN2NPb2hrVkV6?=
 =?utf-8?B?UG1VbnRBRzEzVDAyV3EvZjEzSlFSSTArQldLZHh1ZnhCb2J2NVpvUis4Qko3?=
 =?utf-8?B?d1JtTHErMnlQUExJZDZuQnpLeEhESzI0UmhCTmRIeVZDdEZ6NnRNY0FHNEdq?=
 =?utf-8?B?cHlXNGRjaC9iMUE2a1B6cGpleXlub0JRdzVLbWZxbEw2OEdoMDcycWFwTUZU?=
 =?utf-8?B?amFybEhzZ0NrSmhid2lkckdWbEFDRGQrUUY1c0xsdUE4ODJ2SXNpa0ora3ZY?=
 =?utf-8?B?ckZTWWRLNkRHN2RUcnFpWVRHWkdpOE9RQWZXY3pnNWFldEUyUGlmZzd1S2R4?=
 =?utf-8?B?VjNLNG5lS25YNUFPMC9USldlS3IrWlZPQ0UvRG5KOUZiT1dZbXlrSjdFNjJ2?=
 =?utf-8?B?c0tkMHNGdnhsRzkrWVpLNmpCY3NCbTN5UXNSVmIzK1FNZkVndHdRWml2bEdM?=
 =?utf-8?B?UGw4TVBvOWNGbzcxR1VVYS9DUWZQdi8rSVRlZUZFY0FjODZCcHByVVd5VWJh?=
 =?utf-8?B?N2Y5Zmkzd0pCTFlMWklqY3pIUm0yOUNTSzF5WkxDSXhkRndadEZqZDk4cXBL?=
 =?utf-8?B?SDBGci95OXppRzcwRzUydGNDcERCZFlKeWUvNlYxcG9YSlBOVXNPRlp0UElz?=
 =?utf-8?B?aC8wV1RlRklCT3o5RUFpVDM2a1lnYVZySXRkT3p1alRZZ2pOM2xBdExXNmVU?=
 =?utf-8?B?UUx5bkdkS3BzZ2lTb012S3A3d2o4NkNFSy9NNWk2SjlGVkd0VkxJK0w0dEVH?=
 =?utf-8?B?R3pNZXd0Z2NlR2puTE5NMTRlYi9YSmRMUkRoUlF5V0ZQZGtKV1U5SStiMHla?=
 =?utf-8?B?L05EK1k2SXRLUXhjUm8yZWFnWlBmcTArSHJ4eklXRGVqWm80S2s5NGN0MWw2?=
 =?utf-8?B?NVowdXppUlkrVURHNW1mMUlJN2RudnB3ZGFrdG1MbHdlNEtheXVSTjVGUHhz?=
 =?utf-8?B?RzdVKzhjVEhoUkxtdWYrZUplTlNJQ0RlWnlNVkYvbVRjSkhBUmpnMDJ2WFll?=
 =?utf-8?B?Q2FJYUN2WHlHLzlWb3dNZ2lLNzFBY0tSTWVldllSa3ZZdnVUZWlwV3VkaWda?=
 =?utf-8?B?NUZjNXY1bWppelQwOFFkSUhaeXdtaUs2d2pYZm15WnpEWTZPVkt4RXhBYVI5?=
 =?utf-8?B?NkF5aUZFRUQwbTE2WnYwaU5IUnZQSVBac3JGSHR1K21OeEpVM0psZG5qVmlm?=
 =?utf-8?B?Q3o4M2ZxdUdEb2ZYZndRMXZSZ3ZmQkR0WS84Q3BrUmM2SFpNWW83M3ZXa2N0?=
 =?utf-8?B?TjBhd1lxdk1rZ2NzNGtuYUxQMWJWOVdZS0wzRjZLdExvYSt1NjRjVkRJbUda?=
 =?utf-8?B?UWFoSTVtY2FsdE1mamZkRXdKVFdkamRJYWZhbUFkeXpGVUVJZkZsMitIQmxP?=
 =?utf-8?B?S0Z1ZDl1U2RNcHJmeUNFa2NDMGZiWmo1dUE3aEMrUGdVeEdXL1p4Z1NIaG1D?=
 =?utf-8?B?M293a01rTmgva0lSOTVRR3gxbU50K3pCaDF4TWNHTnVHMVFsK3p3OTN6bUJV?=
 =?utf-8?B?Vzd5eVQ4QXZJaFdzMWRhMk10Y3d4T1VuWE9Sd1dSRUlZUGFTZXN0OE9naVho?=
 =?utf-8?B?cCtLbFlEZVZQVXBQUEZpQmdQNlB1Y2t0TW5oYlVmdUVid1J3UXlnY3Yyelp0?=
 =?utf-8?B?eUpwS2dSVXNTa1F3SWg4M2YyWm9mWU9yRHJtUGF0SjY3ODQxRElyODlpUkQ5?=
 =?utf-8?Q?dXC0z1+O0PS7VJDERAAZVMiRV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f498d90d-928f-4814-daa9-08dccb3f30d4
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB8297.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2024 11:05:44.5397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KPvNMzLUC8liJ3F0GnwpWUC9UzEz59zhmLQgLWPkoSF4v09ii/ad/UW9cofysPuNeJetAuBvgpGQ2X1Xrn98nQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6409

Hi Lei,

On 02.09.24 12:03, Lei Yang wrote:
> Hi Dragos
> 
> QE tested this series with mellanox nic, it failed with [1] when
> booting guest, and host dmesg also will print messages [2]. This bug
> can be reproduced boot guest with vhost-vdpa device.
> 
> [1] qemu) qemu-kvm: vhost VQ 1 ring restore failed: -1: Operation not
> permitted (1)
> qemu-kvm: vhost VQ 0 ring restore failed: -1: Operation not permitted (1)
> qemu-kvm: unable to start vhost net: 5: falling back on userspace virtio
> qemu-kvm: vhost_set_features failed: Device or resource busy (16)
> qemu-kvm: unable to start vhost net: 16: falling back on userspace virtio
> 
> [2] Host dmesg:
> [ 1406.187977] mlx5_core 0000:0d:00.2:
> mlx5_vdpa_compat_reset:3267:(pid 8506): performing device reset
> [ 1406.189221] mlx5_core 0000:0d:00.2:
> mlx5_vdpa_compat_reset:3267:(pid 8506): performing device reset
> [ 1406.190354] mlx5_core 0000:0d:00.2:
> mlx5_vdpa_show_mr_leaks:573:(pid 8506) warning: mkey still alive after
> resource delete: mr: 000000000c5ccca2, mkey: 0x40000000, refcount: 2
> [ 1471.538487] mlx5_core 0000:0d:00.2: cb_timeout_handler:938:(pid
> 428): cmd[13]: MODIFY_GENERAL_OBJECT(0xa01) Async, timeout. Will cause
> a leak of a command resource
> [ 1471.539486] mlx5_core 0000:0d:00.2: cb_timeout_handler:938:(pid
> 428): cmd[12]: MODIFY_GENERAL_OBJECT(0xa01) Async, timeout. Will cause
> a leak of a command resource
> [ 1471.540351] mlx5_core 0000:0d:00.2: modify_virtqueues:1617:(pid
> 8511) error: modify vq 0 failed, state: 0 -> 0, err: 0
> [ 1471.541433] mlx5_core 0000:0d:00.2: modify_virtqueues:1617:(pid
> 8511) error: modify vq 1 failed, state: 0 -> 0, err: -110
> [ 1471.542388] mlx5_core 0000:0d:00.2: mlx5_vdpa_set_status:3203:(pid
> 8511) warning: failed to resume VQs
> [ 1471.549778] mlx5_core 0000:0d:00.2:
> mlx5_vdpa_show_mr_leaks:573:(pid 8511) warning: mkey still alive after
> resource delete: mr: 000000000c5ccca2, mkey: 0x40000000, refcount: 2
> [ 1512.929854] mlx5_core 0000:0d:00.2:
> mlx5_vdpa_compat_reset:3267:(pid 8565): performing device reset
> [ 1513.100290] mlx5_core 0000:0d:00.2:
> mlx5_vdpa_show_mr_leaks:573:(pid 8565) warning: mkey still alive after
> resource delete: mr: 000000000c5ccca2, mkey: 0x40000000, refcount: 2
> 
Can you provide more details about the qemu version and the vdpa device
options used?

Also, which FW version are you using? There is a relevant bug in FW
22.41.1000 which was fixed in the latest FW (22.42.1000). Did you
encounter any FW syndromes in the host dmesg log?

Thanks,
Dragos

