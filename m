Return-Path: <kvm+bounces-26568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1ADB975904
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 19:06:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 867BA288B1B
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 17:06:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE15D1B29B5;
	Wed, 11 Sep 2024 17:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hkGJjsYN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E44619E987;
	Wed, 11 Sep 2024 17:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726074365; cv=fail; b=iAG6ku8mZbtOioOlwUn3RKouOzN1v3V6zfnj8jxQTErXlRN10I8SPkYe38MU3rNPaPaI/TSAuVosYZvyaYWgafpWtKUpbH/7pMYYE5mC4BSUiURtfaI0HWGy41nWPZ4/5AZR/Hy0SQMbjc3JlmdsWvwuPCsgbJVqN8J/Jrftk14=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726074365; c=relaxed/simple;
	bh=tmKPWtNpc0jxpZ8DmAoCmMQc5YKajZQ6mopOUxDwSNQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=j9pU/HGmrh38IxXZi4AQ6OygBD8CMEnVc7QwAJvXc7DHYOwNB4ZfXqYxsd5amYaDdXRuHJZRPBNo5bPnMz5F5zobbOnOTlHRxSdbKJAFgEbVfJVquTrwo9D6EcxDsGt5I9net+jCyMkZqpylkyi+13ylf8PWBxdyza09WdA/+Cw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hkGJjsYN; arc=fail smtp.client-ip=40.107.94.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fjq7iRJ+MF8sQQnpMRrZw3lJgM9M/F436vkkaqbgSe2+LTQbuvm2b/hg+NEOLx+s+vnjIiPMSCiHPaVinXRJtv9tF9QrE9bpoJCFvt043r4WTY75Pok7E+p42lqmLYj5s6PEUkjYJaWmLrT1CvgwWzSAv16P3SSkVfTSNXnNOG/bWHPG7W0wJUr5LHWso1WOH3lcdudD963bt5az9JMqahWtLFe5noTWMW6vWHUxyxdhqpzp5+gulGZLhJfqxsNZz9fT/uSZol10qzNjU7Y9dX8g3xPjIfNcIx6IXwbQNFE2uDr9u9LYirq15Q2DIJgYsaSnAGY6ID63hD/t1aGdRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dcN7YsaQP2WK+zlzzy8GZb1DVFOilH3CBzfoXvituns=;
 b=b3cE+6M1tK05jfi83CDyMXXcFNWzlTfgQ/FEODgaWCja/QtWKX9qw3TE5Ph3j86nfk+o+q6+ZUcKFBB1U5PWa6gaXr4D8dluvBJztVXvGaJ2i9/aEW+7CN6ibHqTxSBsinO8EO8YKYZxXulA12TN3JtzXuAXpUiumypZKpQbtHf7LGsjUUJjcL5oqy2ray4q3I1FjDuCbJuw/BOY/9etxZeaHgeGEBH9liRmt8MXUglO5IVSLWbumo4+TVEorUjzs3X9KLOnT2jcH/m9y1vDpQs9X8jFQxYweOO61Ov80YrHTy7os0O7HVpBe4L1/4MtqUe0J9C8qwiTNN0s3UUzMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dcN7YsaQP2WK+zlzzy8GZb1DVFOilH3CBzfoXvituns=;
 b=hkGJjsYN2vYDilGsaUObnZDqiC7sKmBJTGEgQ7hSNkA23yzONgq69hP3PV5Tebr1t6fDTkSWBSpgqAyBHteDQzvRmJnenmcn4/+nZt4I72ri+Sg6lRarvZSPJe7IjxUuJLInPeEyX05zkuPifuM1EJCZqJ7mMotKKqGolcpxFuvrWN+PejveoomxVtrayHZ3tqmzen18krPwIod9dU7EonKsTQmJ0CW2C0CcnJIhIec7lIQco8UW8wxSnlrTm1D03EyB4XRh9xcUcH2Cr50ptDSILVA5U/rDdL4amtw02SV7m5R/tCyJD97q4kbt7pUrPJhg6rLNZD5VhI5RGXRB5w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY8PR12MB8297.namprd12.prod.outlook.com (2603:10b6:930:79::18)
 by PH7PR12MB6762.namprd12.prod.outlook.com (2603:10b6:510:1ac::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.18; Wed, 11 Sep
 2024 17:05:57 +0000
Received: from CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4]) by CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4%5]) with mapi id 15.20.7939.022; Wed, 11 Sep 2024
 17:05:57 +0000
Message-ID: <790e8baf-eb41-424c-accb-3d3ffbc60c71@nvidia.com>
Date: Wed, 11 Sep 2024 19:05:51 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH vhost v2 0/7] vdpa/mlx5: Optimze MKEY operations
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Si-Wei Liu <si-wei.liu@oracle.com>, virtualization@lists.linux.dev,
 Gal Pressman <gal@nvidia.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>
References: <20240830105838.2666587-2-dtatulea@nvidia.com>
 <fb6b1d3d-c200-479a-941e-1b994757b049@nvidia.com>
 <CAJaqyWfVfOe7X-2Ku3VhuzPMdF6TGM63D5squ6Naw=6iUQdgDg@mail.gmail.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <CAJaqyWfVfOe7X-2Ku3VhuzPMdF6TGM63D5squ6Naw=6iUQdgDg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MI2P293CA0007.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:45::7) To CY8PR12MB8297.namprd12.prod.outlook.com
 (2603:10b6:930:79::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB8297:EE_|PH7PR12MB6762:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ce999ef-9818-4448-4cc1-08dcd28400cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bzUvWTlTZHd0cEVZazRPWUdNTm9hbFBGWjhZYWMwRXczUkw3WjVHYnZBVVM3?=
 =?utf-8?B?UHlwSW5OZWtqMmdqVVpJRlgrOXdwckgzODI4YndjTmNPWk93TVYveWlyMjJt?=
 =?utf-8?B?OEpvL0RZZTFlc0djYTdMWEwyZ1ptdVBWQ2ZSUTBuSGxTejhvc0tKSGZvclls?=
 =?utf-8?B?NHJpVHNOUVJEUEpuanFGbUxTUHo4ZmVRZ1gxL3h4WDM4emFJSkNQQnhvSmc3?=
 =?utf-8?B?K2ZxQk1LajU1RlFYcUo0ZUc1Y2FiSWNaay9pNnQ0WVhRelpsb0tHSUcrTSt3?=
 =?utf-8?B?YnRrUklJWjZNVFowa01kdXk4WEtNRTZraWI2S0hQVWdjSkRySjZNcVZ0SFdj?=
 =?utf-8?B?cVpqMGRqL2VlM2RPaWVnNlIrMzBSS0IybzJaT1hSN0g0Y1ZwRTlTWXE5MGp3?=
 =?utf-8?B?YUg3WFRNbHduSWp5N2N5Y2FLckczMVdlcXhKV1Z4ODluUjJoQ2lYZGJDUWZu?=
 =?utf-8?B?ZkxQK2Z2UkVqeHpsaEdTSDRjVTZZUDRlWGNoTVo2WENCU2NmTnNaMlBTU0N0?=
 =?utf-8?B?Ykc5SUpFcjZmSUJkL1Q5M0hsZ2ZnYUljOWpTOVR0N1RsWiszTFlTZGVjRDRD?=
 =?utf-8?B?ODBUUlBTVHhIQ0RjL3hXN1NkV2svWUs4OE81VGhhMUFUdlF3VXlTLytlbTdW?=
 =?utf-8?B?Z2hMOU9SMU93QWxqOGxUalNUQUJ4UHEwSzJ6bFBFUnp5VHFabDYwRjl6RFI3?=
 =?utf-8?B?cUJpT0dkcmNFQjZXNVUzV3ZNN0xqeWhOTXJoSmlmV0hjSzZHR01LTER5Q1o5?=
 =?utf-8?B?cHNwdzFZTHNhdzNyN1NKK1cxTHlrUm0zdGZOSDZGMkgwZmF2QmptTmtSVVNB?=
 =?utf-8?B?WlRGSVRGUVJ0aWlLZGtoUXdIRUtMSVEyS09jQmhlSldpbmJoY1RuTUZXVUNG?=
 =?utf-8?B?MmJUbEc1cVUwdDBnQXZEeEZlQWMzYzM4dVhWTkpnbWc2WlduWXFmdlltejRZ?=
 =?utf-8?B?T1V1YW5mT1NDWFlqU1pRS1REaXRSOTlGNUtGSGhDNlN2b2VSNTlaWVVHdWE2?=
 =?utf-8?B?RDNtckhELzMyeXo1Mm9FR0NEWnVwbERsL2NBd3ljc0l0OHFrbUFjZWhXbHpV?=
 =?utf-8?B?dTNNSHBmU3lFak9VU3lPQ2h2R3ZGdUhza0VMbGpMVG5wSVh2c0NPd0tqWTl3?=
 =?utf-8?B?My95ZU9kTzk0YUxsUlRwMW9wTk1VbFV3VXoxNE1nMzB5OElKUnZkUVMzd2hE?=
 =?utf-8?B?UTdKQVV5eERUN24xQndSaCtvRVZNc3A2K28wWlE4T1E3bi9qcUZUQlJZNVVZ?=
 =?utf-8?B?cjAvSjRGZWNTZWJoRWplS0o5STVWcm1FcENISmI3dU9BUTVyUCtFejZ5eHBz?=
 =?utf-8?B?UG0vYnV2R0RXUFkzT3pQcFZZa2IxRk5CUTdQKy9CcTVVeHZ0U1MvK0gzMnR5?=
 =?utf-8?B?OS96SHJCQjAwd2JJMWNhWGJaSjlZRytxcTA3S2RadEdkaEVRQTlhOVY4dElG?=
 =?utf-8?B?V3hraEtTeVdCMm1ySGxDdGNVRmwzWWJ0aGowUHcwT3U0YkFRaDJZWjI5Tkhh?=
 =?utf-8?B?cFErcG1WYU5GMUFzV2IyZXlQWXNkRDdZdmZsdHZ4TU9TS1B0ZXc5Q2crS2J6?=
 =?utf-8?B?ZmJydEZLYW94TGxFRHE2MjIwZTQwSlI0ZzlNbjhteW40OXpKUnZWVjlBSGxF?=
 =?utf-8?B?R05BN2pFS3g3dUVrQ2ZWbTNDano3d2I4L3FZb0p6RVh5ZmRUbWNnOHc2Mitq?=
 =?utf-8?B?VldDbXR5cGRRa1BPdFF1Vlk1cUFPY1JIVUluajVWaVhDS1NvMVlYYUx1RDBW?=
 =?utf-8?B?enVZcGdaZ3lnMlNLVVl2MnNVVDVrY0NkcWRDbnZWb1hScFU3a1BGNURaZG8x?=
 =?utf-8?Q?QQqOkV0ksc9WQnWMWW32bdnJ8tuFPSnloqawk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB8297.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WkxaQlJrdi9udHYvbHBSVllvZUNwN1MzcWVnQ0h4ZFcybGV6SDI0UlYzbVh2?=
 =?utf-8?B?NFovcmRITXRtTW5jRFhlYmFxZVZ3NzdCdnJ5UnZBRE0xQVoweC9pdjRGN0ZF?=
 =?utf-8?B?a1hEeVZHaDl3U21BOHdYVFJGMGYwc1VNYi9ENHFHaHhSc2dJaGF2U3FDaXhu?=
 =?utf-8?B?YU1zZGhwSDlCN2MvWFpoRXNUem00Z3RJQlg0aUgyTGppeVJNNStndkFwaW42?=
 =?utf-8?B?OTFZYnp0V3BBSkR2NmVDdjd6dkswL2gwY2FpWThhZ1lsSlBGUisxT0thSHEz?=
 =?utf-8?B?OVVBR09VdFdvNzMzOFVmL00yTVFRUVRnL0w3VnVOdm8zWWtjZVdQWWJsa0s3?=
 =?utf-8?B?eDVQc2lyZXdrUDZ0V1hoWUVFencwR1gwOEtjbUJmR0NUZ1pUQ3RyL1lyb1li?=
 =?utf-8?B?M0VBOEVKek9NUjd0N3pPTjJSY2gxNlRqOUNVbWlwZWR2b1BLNEJXOGRoRSsr?=
 =?utf-8?B?THRER1piMkEwVlRYbHEvendMK0s3WnFSajlsdzhhbzEvaXV0WnhDNytzK2U0?=
 =?utf-8?B?ckZHMkhLMWhSemt4czZKd3l5WXdtcFpuT25MU0pjZE9iOGlaVDRwQW5jSzZy?=
 =?utf-8?B?UGk2enZITWRUY051MEJtMjFFTjJUN09QOFVMSXZOclF3ZVI4aW9jMzZhUHJG?=
 =?utf-8?B?TStUM3k5dENpL0RGUW0ybnRReGhValJ1OTR2VGJOWS9GYlBDbzQ2SUY1Z2Vi?=
 =?utf-8?B?UmxSNFRrWXAvTzFtTCtXKzN1TU1HbTF4aXJKTEtzWXlZbVlrRDR4OGtTZ3Vu?=
 =?utf-8?B?ZENzZGdGblBtU3NnNElPdHhzRGg4Umg4SFNRS0xGQ2M2MGplRkpMTDNzUlRT?=
 =?utf-8?B?OU1JYXQxeWVEcnJZOHptaFFJQXkwdmZmUGZTNkJHSUR2NmlOMmwzQ2tKajdY?=
 =?utf-8?B?OU5zOHlvSjd6akRpdWZWMnlSMFNXaWhhMjVIMVZRbG5KSUVHenJDL3htbmdz?=
 =?utf-8?B?cVJ2ak1wQ1ZXdnI3Wlc2ekZ1b2czaFVqZElNd0hJckhQRzNGTGxNS1BxNFFT?=
 =?utf-8?B?eGVZU2gyN0JKdnBodytHSzdmZzg3ekxxaWVaNVJEUVF5cStvdUEvdkxHc1RF?=
 =?utf-8?B?UGdhNjN0QitqODRpc0k0TUNHeWRSVE9rY2N1U3pwU0taNTArWnVOMm5nL0lw?=
 =?utf-8?B?QnVaQmNaQm1MZEFkNjZnZFp3ck8xVExzUHUvYXlBRkkyMG5ZSUtrMXJRL3Z0?=
 =?utf-8?B?TS9JbTZ6UU9CakIyaG0zU0xURlk4Mk4zQUxMK0F6MW1yM2xBdEVza2NGMTdq?=
 =?utf-8?B?QXJZckNXekRvd0ZzcDV4dnRHUU9XMzBmbjZ4TlBJWWxReFRwMXMzbVRRRFFu?=
 =?utf-8?B?MHpDWmREeHp5N1AwQkJxSklmZVBJR2tpdEgrYXJRczNKUDZ1YTJzNTlkOW40?=
 =?utf-8?B?UlpjcktYLy9Ubi9LMDZiSTdlWEE4TUlCZWRnL3hQQUQyck1OSFVCenErSGpw?=
 =?utf-8?B?cmM4Q01qWlpQKzRoSTM0VE82NVU5V2xoV2ovWEZFRkFSd0hZSWE4SXg0UFg2?=
 =?utf-8?B?MDYzSngrTUdvMTU4WlMyVTFQRDVDaHJTbk1vanlhc09QMVcrSW5WQS9VSG40?=
 =?utf-8?B?YzRzZ1RxOHZaZW0xQ04rVUhaSlR0eS81VEZyM2ZsU09Qa285RFIxRHhheXg0?=
 =?utf-8?B?RDErMHIxL2FSbDRQRWpmMDFUL2lyQWlUbGJEbFk4SVZxN3RJbCtncTI2VTB4?=
 =?utf-8?B?Q0lTeDJhbmxPWDdIYlFzNllUVUVJWGkvcEZyaVpOS0huVDA5TGpmaHZQc1Zj?=
 =?utf-8?B?cEUzTDBDMzFhS2tGVkNQWEdvd3VNc2gzYU5lT3ZtQk1ud0RybFdOWkVBSTdE?=
 =?utf-8?B?Zk4vaVNIN1l1TEJUVzFuOXF2VHo5cFg3b1Bqc0d4QmdQc3EzQ1RFYTN6THFI?=
 =?utf-8?B?QmRuNE1lb2J3YXVIMGNWMForRzAyZC9kSHZPZmMzV2gxYWM5R09YaGUxOEw2?=
 =?utf-8?B?ZndrbGJjZUp2YzY2MVNlSmppcysxOGhZUmJUQytDZ2xTR1NLaTVpZXRyakY5?=
 =?utf-8?B?MFpuRldZYUdUcWVobW9pWTk2T29EYUFhRld4bVdPdXpLYzRaZVVxcEo5MjZF?=
 =?utf-8?B?QWpEdkhzWjB4cnFjSEthQWZmWlRPVWZ0Qm1yZkpmcFI5QWlYOVdVa1dmMENJ?=
 =?utf-8?Q?ax6kKOsfbHml+akgo6qYluGhj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ce999ef-9818-4448-4cc1-08dcd28400cb
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB8297.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2024 17:05:57.2942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: plFiVcmSTqo4Z6ysYoB+FXnAOVjh4JQKD70pXRE3b4tK4A6B66DCQSIss9jehpyrGeXcpcsNKb4MOwSqKEgN4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6762



On 11.09.24 10:02, Eugenio Perez Martin wrote:
> On Mon, Sep 9, 2024 at 11:30 AM Dragos Tatulea <dtatulea@nvidia.com> wrote:
>>
>>
>>
>> On 30.08.24 12:58, Dragos Tatulea wrote:
>>> This series improves the time of .set_map() operations by parallelizing
>>> the MKEY creation and deletion for direct MKEYs. Looking at the top
>>> level MKEY creation/deletion functions, the following improvement can be
>>> seen:
>>>
>>> |-------------------+-------------|
>>> | operation         | improvement |
>>> |-------------------+-------------|
>>> | create_user_mr()  | 3-5x        |
>>> | destroy_user_mr() | 8x          |
>>> |-------------------+-------------|
>>>
>>> The last part of the series introduces lazy MKEY deletion which
>>> postpones the MKEY deletion to a later point in a workqueue.
>>>
>>> As this series and the previous ones were targeting live migration,
>>> we can also observe improvements on this front:
>>>
>>> |-------------------+------------------+------------------|
>>> | Stage             | Downtime #1 (ms) | Downtime #2 (ms) |
>>> |-------------------+------------------+------------------|
>>> | Baseline          | 3140             | 3630             |
>>> | Parallel MKEY ops | 1200             | 2000             |
>>> | Deferred deletion | 1014             | 1253             |
>>> |-------------------+------------------+------------------|
>>>
>>> Test configuration: 256 GB VM, 32 CPUs x 2 threads per core, 4 x mlx5
>>> vDPA devices x 32 VQs (16 VQPs)
>>>
>>> This series must be applied on top of the parallel VQ suspend/resume
>>> series [0].
>>>
>>> [0] https://lore.kernel.org/all/20240816090159.1967650-1-dtatulea@nvidia.com/
>>>
>>> ---
>>> v2:
>>> - Swapped flex array usage for plain zero length array in first patch.
>>> - Updated code to use Scope-Based Cleanup Helpers where appropriate
>>>   (only second patch).
>>> - Added macro define for MTT alignment in first patch.
>>> - Improved commit messages/comments based on review comments.
>>> - Removed extra newlines.
>> Gentle ping for the remaining patches in v2.
>>
> 
> Same here, this series is already in MST's branch:
> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/commit/?h=vhost&id=d424b079e243128383e88bee79f143ff30b4ec62
> 
Ack. Thanks!


