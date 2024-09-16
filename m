Return-Path: <kvm+bounces-27020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BFE4C97A90F
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 00:06:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CA051C219ED
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 22:06:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE995145FEB;
	Mon, 16 Sep 2024 22:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BBodgfDG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2052.outbound.protection.outlook.com [40.107.94.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8FC713E41D;
	Mon, 16 Sep 2024 22:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726524385; cv=fail; b=dvfoeCYEwQslX2oPl/v/q3XYAsa9tcbExignUXhgfVIYI47xOWWcQfC8iPQs3RzUIgTiPRQzhWguU05wP0IHTkwwnGELOckg6MEiIvy7R3NS+zb4xPo7HCz3d56Ahsc/Gva5BqHqaHijSdYXEuOPTTgqKrFGeQAzGU2N5x0yaeA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726524385; c=relaxed/simple;
	bh=r8FPMz5Q+wQ/mm6qX7n3X1e64B/s4GzcK+7q9B0lcvQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GXS2kgNAbmlrALfm+ktUYGGNE/AA0zoJ7iH8EMKtwrmypYO8hvOU/nMTlrJKQULx+xA30SsD3RbLVzK9437Uld0K4sdvrOATGYnXtM5r1HVEnMXTN/rBwmTzscdgQsCtPzhihDUePdFnmDnYSNx4OES/5onQdFQFvrJKGxPYvig=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BBodgfDG; arc=fail smtp.client-ip=40.107.94.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aftdpSVzNzJEJHTYMkl0rIxpuFJhUYlUJGYPFgTjv+fBQOkByXwLMpvxzFZ36KCP/ki9g4l1A062wZs9AB0VU5wSEeXKMHMTwEya6No3wD0NDFaI8TYMq0afNRUgpsyMAy663DiE2dGQE0f+qbDUlRK1CkkB3RZ26TEZt+v5M66iF/i5DaBafqbOlOqNF3/qTPra399fw6RzavMXzkMaZTIB7dX/E75+8b8d6eu/eJO8/cNnPqo3/4YBHz6uEksDrVy/CU/a1mHn75THEA9TnRRnakY6p6SxV5o+ungFYIqtZqwliNwyKeqQbZtOL+o67Np4wCctAZTkjS72tKszlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L8vdM5egNrtkI6d2s9PZKSWp+OMUvhKii2FaSSeb5mY=;
 b=RYMkY4irmAp3mptTd1O0lODDf7/z7yNHnNnUA+NqbsKw6W2YkeeW9W2u1x6EdXdygIEETooFNSu9xvxfuVl4VBBPmEwnC5X8XTXo80CutvmRLZGxsRG/VJTqe08Ewrnq+CDHxc4PJPkFFQ0oto+ox6z94rS87zyZr/OTJv1r10iZ25P+fjkqKn5Q5i78InkcoJhw8uWA0XOcOg5XhkyaPNJKsRu/pSvqKk+C5C25Ns8rrZ7Y02DYJAp9hhGkirBwgMKOmsm9/uIfI78vBW0WvG47I04toPW30ybzHZjX4s3/+D0OhfcWc+Vy4FzZCPjVPr98ZXTH2yb/EWD4Ey4vvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L8vdM5egNrtkI6d2s9PZKSWp+OMUvhKii2FaSSeb5mY=;
 b=BBodgfDGhPFHj3IMmVmwKy3okD8iN1HywwP7THtH1xuYlVNHWsz7Qq3EiakfsS2yYI1fDx6eEhXLsfUeYxgH4KdN3lZXaAQFiqhd0iu7zsX+8ITktLTDqw6L0XdqAh28Sa9poKrdnhEUpU7SKm3ms8bCDkuMR7Lc9kmslXKheDCCS8CnzW+trtUj00bgNSbp6IWSoC8Xa59eH13yrijl9aFHmkDjcncPbSlYSNLuSQXw9HFSrx5ddtvcyY1DD/obZ/QEz94ov82fBjcQ8HefrNNZ6CJh2gnGcNWd+dvfTQf1LtdZSjRwCtBzxdr6YMQPq7DPrpuqkyBK2cS0ARaiNQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6369.namprd12.prod.outlook.com (2603:10b6:930:21::10)
 by MN2PR12MB4063.namprd12.prod.outlook.com (2603:10b6:208:1dc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.23; Mon, 16 Sep
 2024 22:06:20 +0000
Received: from CY5PR12MB6369.namprd12.prod.outlook.com
 ([fe80::d4c1:1fcc:3bff:eea6]) by CY5PR12MB6369.namprd12.prod.outlook.com
 ([fe80::d4c1:1fcc:3bff:eea6%4]) with mapi id 15.20.7962.022; Mon, 16 Sep 2024
 22:06:20 +0000
Message-ID: <b2408b1b-67e7-4935-83b4-1a2850e07374@nvidia.com>
Date: Tue, 17 Sep 2024 01:06:07 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] virtio_blk: implement init_hctx MQ operation
To: Marek Szyprowski <m.szyprowski@samsung.com>, stefanha@redhat.com,
 virtualization@lists.linux.dev, mst@redhat.com, axboe@kernel.dk
Cc: kvm@vger.kernel.org, linux-block@vger.kernel.org, oren@nvidia.com
References: <20240807224129.34237-1-mgurtovoy@nvidia.com>
 <CGME20240912064617eucas1p1c3191629f76e04111d4b39b15fea350a@eucas1p1.samsung.com>
 <fb28ea61-4e94-498e-9caa-c8b7786d437a@samsung.com>
Content-Language: en-US
From: Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <fb28ea61-4e94-498e-9caa-c8b7786d437a@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P123CA0104.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:139::19) To CY5PR12MB6369.namprd12.prod.outlook.com
 (2603:10b6:930:21::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6369:EE_|MN2PR12MB4063:EE_
X-MS-Office365-Filtering-Correlation-Id: ea78bbc1-63a0-4336-585b-08dcd69bcb66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R2lYN0NpclErc2NpV0JCTzFCcmFyb0JZRk5TM0wzMmxaNnRoaXlhWEZMUFV2?=
 =?utf-8?B?TjVqY1ZJOTNhNTd2eU9GR2VnZlRNeFVQaUJmWlppa0U1dGhKTWF2QkFWcHI3?=
 =?utf-8?B?cGQ4WTh3eUJCb2NyaHJHc2htUnIrbkZmWklaUzJmS3dTaHlnV3MvSENqMk8w?=
 =?utf-8?B?eElnMFZteFZWcWQ0ODZVQzZjUzBBM3RzRWpDeGhBU1U1dUtYSlloWjdtZCtE?=
 =?utf-8?B?NThZQndnc1hwQ1NvanFrQ2VkaUpIV1lLc3Rkbnk4NDJYc1Nhd2hlcVQrR2U3?=
 =?utf-8?B?VWRycFZJVmlVVWcvcEhUZUZNcjZSYkNiZDNUWGFibmxRRzRIb0x5eW94eHFX?=
 =?utf-8?B?ZG5Sb0Fra0FtU1VXeEl3cFZKODExRjNneHpVQUNWeWxwMG9id3RoSW5tMzV0?=
 =?utf-8?B?OXRGQXpSVlZvdTFZampuQUg5eFcyT1VVMU9LWFJGOWpRRE1WelJNMUhtaEtk?=
 =?utf-8?B?NmQxNXVGMU1FQ05VM3FRZTdLazdiMTZaRzd6SnV3WStCL3hIMGtMQXZDUFpy?=
 =?utf-8?B?OVN2NEpjcnJGVVhvTG45bGRpc1I2QVBXbkp2d3hkUzlic2haUkdCa0dzd1dt?=
 =?utf-8?B?alpOQnl4a3NJN000bVg5UlpwR0h5R3FmYityOWx0ek1CMklRNm8xTXFFOXFk?=
 =?utf-8?B?V2MzajVITlVNMHYzQ003TUZzbU9CZ1lhVDFkNVl5NzJZenBNRGh0ZVNyV0kx?=
 =?utf-8?B?V0I0OVIyeFpCQWgvSXJrcmdTWDhkVVBHQkRkaEVnQmppclVXdVpKK3YwSXVE?=
 =?utf-8?B?cjRHUHdaTUUxQ05neDZhM1BsdzUwNU9lRXZoVGl5a0c2ekp4TmhQSi95WTdw?=
 =?utf-8?B?UDVpeDlMbTdTQi92VmlmakRlcWJ1NGp4SmowZXpoQzJZbkJSUUpnUTB0QWFB?=
 =?utf-8?B?akhEaTZMS0ZsOEE4VEpJbW1ZK0pzU2UrakZoTmNJVVVJQ2U0NFhOVTB3SEtF?=
 =?utf-8?B?NmpGWmRGcjhxNEVKZ0J3R3ZJaFArNHBreGZBT0ZOa0VxY1MyeEpXV0QvaTEv?=
 =?utf-8?B?L2VON0JsRlI2RW05N2QyNld6NUZPMGpvMkliUmZIZ01KSCtIMWg5bVpqRjMv?=
 =?utf-8?B?czJHZ2FWdFFkajNUTmRRTGlPRHBnUG1hZU9QTzcxblE0WUJFMG5XaUJZeXow?=
 =?utf-8?B?QTY0R0lEenlyTkNUTER0NlBrNXBVY1VhSEJITURWRCtORnVGd3Baa2paaStJ?=
 =?utf-8?B?QSs4YVUwWmorRWJjK2lkTVF5QXByazAxSTlFUlY3QytDRDl5TWd1L1Bqd3ZT?=
 =?utf-8?B?UnNMT2ltWXE2Y0c5SCsvMG1qODY1eUNSY3Q1VXBQVUtYMldxVzlVRFd0dVpU?=
 =?utf-8?B?d0IzaHNVR3Bza1QrZTk0bU1QQUQrN3d2TVlIZzBIYXBWL1Q5a0dUbngxNGNI?=
 =?utf-8?B?L3E4NEJ4Ym5UZ1o4eTRZcE93OUxORzNZT29ZVE9SM2tHVVhkVGJ4OVFBOU8x?=
 =?utf-8?B?R3dGbVpCUWp1OGR3RnVuajlYWVFOaVYzV0hrNWZPQXdIOU9LZGNTVVhmTUho?=
 =?utf-8?B?WC9aM1hBVGhvY2NrZVJ5ZjhIR0xMb05XUlFqd1M2UVVwbGRMZFF3L0RtK2Ir?=
 =?utf-8?B?ZTYwMDVWZVM1MnB6Y0dqWUVoa0xoZmRSZWNvOXdubGZ3K0VsaEEzT3Bjelpa?=
 =?utf-8?B?Zk9oY2FtTll1V3I5czlPUjIyNXFDWnlOVFFqZ0ZMZEFsUXJ4RjRWWU9Jc01O?=
 =?utf-8?B?T2pVVHlQaDl4cnJZTEtMU0RnMG8vZnRXN0lmcGthZFFTMDRiUzR6UHNEbUlM?=
 =?utf-8?B?WU9DWkNNemUxWld1aFA3NUJlK1ExUGJxRWJ6S2R5RjhJOEx5ZGEvTDVFNmRu?=
 =?utf-8?B?U0JBc0x3U3A5RCtwWkVuZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6369.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q2VXUWdJWUwvNHB1QkxjbnF4eUMvYVhnTXB6Q1VGeTBpQjhnbjBtd3VSdlZl?=
 =?utf-8?B?UlNBTW9JTjFOeHRydnBlSXRpcS9MalFxNWE5YXJVcUU0QldVcnRITUdJRUdW?=
 =?utf-8?B?bks3TitGOFF5bWNNdkUvTi9KUENGL0c5cFR3L2RJQzZGVEUyTW5QeDZtTUgz?=
 =?utf-8?B?RSt6R21HYm5zcll2WUZxczFtckh6MDVDWVlDSEFCNFIxWS90bkkyKzhMU2ZJ?=
 =?utf-8?B?U0R3VjRGY2ttRE4wVWFkSlRQeTZaK1RKbFFTaGZZU1l1SU0xUjdsUmpmNXp5?=
 =?utf-8?B?blBTWE9mTFlRSzVGa0JBTWNkQ0FqQ2dPdEtndXJUSVZ2VlZRYTJPWHRUelJw?=
 =?utf-8?B?aXZvalBNT1poOXBpakhCU2lOeEphTFB6U1BiVDNtQUpOcDhXbjVjdDA3UnRi?=
 =?utf-8?B?YlY2UWgwWXRtelpKc3VaWWt4alFLRnRDcXVNVlNTNXByMng2cmhucFRJdHRj?=
 =?utf-8?B?RHFkRmdDeURIL2E0ZFRWZzFSaHhNSjZucm5Jc1E0aE9XZGFveU1QT09VSkNw?=
 =?utf-8?B?NGkydDNVdFRZSVFRRlFkKzlYM1U2VENOcVJtUmhpSS9NUUNhWFpVZ0pjZzBr?=
 =?utf-8?B?MTZUTEhIQ0pQaUZodlE1WGFWc0dwNURoTGQvaHJpUlFqVUtjZUVpZDJ3K1d6?=
 =?utf-8?B?bG1YUFdhK2U2cTdTQ2NsOFE0NkF3V0dxSTk0TnYvUFJ2T2NNeDZIWFByUmE5?=
 =?utf-8?B?RUFNb0ZlaUVFVU80dlNPTTlKSk02VnA1K3dyVEhkU0MvUC9VUzBDQ2I1MHYr?=
 =?utf-8?B?WGxaRlo5dmxUTUpBMi9seVpqNkdpbDZYNjNWMHA3MVFqV3FSREZsSnlRUjhR?=
 =?utf-8?B?RlF6eDVGRkZjOGdibUV1Q1c3VHFBWHd4ZzlnNG43R1FVOHNTWGM3WjBaTzJD?=
 =?utf-8?B?djVlTldKRXh4U3ZSaTl4a3lHUlBMZ0E0TmN1QVpoV3c5aWxzcXg4cnh2aFRl?=
 =?utf-8?B?ZVVGOEpIN2lMM2VmM3VpOUNFK3JuOE9QdjJ6V2xsbHkrU0hIZHc2c2hMM2li?=
 =?utf-8?B?Nk5GL2QrSHNZc3lPaWd0Z0U5c2ZMcExtK2xEUUtMb043WTZRSlFHTkhzZ0Nj?=
 =?utf-8?B?V2dGWE0zblhCOWI4eDRhQTY5VEQzVlZ0c0x1SEswSzNEOWtVMUNVMnNNT21z?=
 =?utf-8?B?aFoxa1BQa2IyaFdTa0dYV3dFRi9yQXlLZWpwWkVwQWswK3NrQ2Z0QVJpeHpZ?=
 =?utf-8?B?QWNKL1RxK2hWNThTVVJNb1BLNTFCTEtObzFwUDVOckxoejdNWVBYd2RwRGNh?=
 =?utf-8?B?ZGlITE5ienhybjJqTzZCNm5RTUtRRTIvWm81OW5TbW5XTzV1VTFUVDVFNzlT?=
 =?utf-8?B?ZVNvcksyU3V6elQrS1h0TG1MTFkvRTV4NkNxUWlNUXVhNkxsVk9jUHZkNEUz?=
 =?utf-8?B?cXI3S0tmYTBFcXZpYUQ3S1RiWjRBK2Fyc01rV3ZpNnBZUitTV0I1N2VSYmll?=
 =?utf-8?B?eEZyd01ZblVScFdDNCtPS2FUdUtFdERJdVdqaFJIbmYyYU5pMTluSTBqaHk0?=
 =?utf-8?B?UEIwdXlYV0l4UVk1aUc1T3FUZzlXcE1HRHgvazFWZ2VZY0xYdzFDalMwdENs?=
 =?utf-8?B?TXVVZ295Z1ZPQkR5MEx0UkIrTm41eUQwQ2F5anBCMWxBM1AzWkNFK0pwYWlz?=
 =?utf-8?B?YUp4L2pvL0FxcTVCL05aL09PT3VBbzQvek45SkNwV0xPRWg3eGRvVjBFMDhG?=
 =?utf-8?B?ZE55VGxjeGZUa3JYOEt6SWRLVjNQNE1uT1ZCU0R3cEEzeXpMMEVac3E1TFFL?=
 =?utf-8?B?THdvdUU0WUc1blhoUVJDaWZsNWxPcmRuQ0xNWVhuVkZQeTN2Ujl2bCtTRVhv?=
 =?utf-8?B?NDMxUitFQXFrTzhtK1BFaFBSOUFsRzVhV1R5bTUva3B3WFR4Y216TUFHWVFx?=
 =?utf-8?B?TG5UZUpRdDR3QzNGUUJEWjl0YU1ickxKWVQzSHZGOVQ1cFVIYzlEMWxvdG9H?=
 =?utf-8?B?RXlscDd2aWxZd2t0a0g1YWtGUG1CQk8wN2drN2pjcGxOZi9keUxKNmxyOTZk?=
 =?utf-8?B?WGp5bDhiV3hMSWRtZEZEeUxZZEVoVWxsZnd4LzdEYW5qZ0cwRnVTNmxXeVRH?=
 =?utf-8?B?bjBucllIMExVYk9IZ1hoVUw0MXIwalpXd1V2L0xrUEVmaUFqYVVGcTdwaE5y?=
 =?utf-8?Q?u4vVZFsjbS3y/f8hbM5FhxCdD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea78bbc1-63a0-4336-585b-08dcd69bcb66
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6369.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2024 22:06:20.3154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nqIauU5q5RO3gFT9Tz2SCwx5Orsx6c79P+U6emrvNmDMzrnDAROeDQNLLUNwxoao103dy8xIr1Oka6FCrmKG6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4063

Hi Marek,

On 12/09/2024 9:46, Marek Szyprowski wrote:
> Dear All,
>
> On 08.08.2024 00:41, Max Gurtovoy wrote:
>> Set the driver data of the hardware context (hctx) to point directly to
>> the virtio block queue. This cleanup improves code readability and
>> reduces the number of dereferences in the fast path.
>>
>> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>> ---
>>    drivers/block/virtio_blk.c | 42 ++++++++++++++++++++------------------
>>    1 file changed, 22 insertions(+), 20 deletions(-)
> This patch landed in recent linux-next as commit 8d04556131c1
> ("virtio_blk: implement init_hctx MQ operation"). In my tests I found
> that it introduces a regression in system suspend/resume operation. From
> time to time system crashes during suspend/resume cycle. Reverting this
> patch on top of next-20240911 fixes this problem.

Could you please provide a detailed explanation of the system 
suspend/resume operation and the specific testing methodology employed?

The occurrence of a kernel panic from this commit is unexpected, given 
that it primarily involves pointer reassignment without altering the 
lifecycle of vblk/vqs.

In the virtqueue_add_split function, which pointer is becoming null and 
causing the issue? A detailed analysis would be helpful.

The report indicates that the crash occurs sporadically rather than 
consistently.

is it possible that this is a race condition introduced by a different 
commit? How can we rule out this possibility?

Prior to applying this commit, what were the test results? Specifically, 
out of 100 test runs, how many passed successfully?

After applying this commit, what are the updated test results? Again, 
out of 100 test runs, how many passed successfully?


>
> I've even managed to catch a kernel panic log of this problem on QEMU's
> ARM64 'virt' machine:
>
> root@target:~# time rtcwake -s10 -mmem
> rtcwake: wakeup from "mem" using /dev/rtc0 at Thu Sep 12 07:11:52 2024
> Unable to handle kernel NULL pointer dereference at virtual address
> 0000000000000090
> Mem abort info:
>     ESR = 0x0000000096000046
>     EC = 0x25: DABT (current EL), IL = 32 bits
>     SET = 0, FnV = 0
>     EA = 0, S1PTW = 0
>     FSC = 0x06: level 2 translation fault
> Data abort info:
>     ISV = 0, ISS = 0x00000046, ISS2 = 0x00000000
>     CM = 0, WnR = 1, TnD = 0, TagAccess = 0
>     GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
> user pgtable: 4k pages, 48-bit VAs, pgdp=0000000046bbb000
> ...
> Internal error: Oops: 0000000096000046 [#1] PREEMPT SMP
> Modules linked in: bluetooth ecdh_generic ecc rfkill ipv6
> CPU: 0 UID: 0 PID: 9 Comm: kworker/0:0H Not tainted 6.11.0-rc6+ #9024
> Hardware name: linux,dummy-virt (DT)
> Workqueue: kblockd blk_mq_requeue_work
> pstate: 800000c5 (Nzcv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : virtqueue_add_split+0x458/0x63c
> lr : virtqueue_add_split+0x1d0/0x63c
> ...
> Call trace:
>    virtqueue_add_split+0x458/0x63c
>    virtqueue_add_sgs+0xc4/0xec
>    virtblk_add_req+0x8c/0xf4
>    virtio_queue_rq+0x6c/0x1bc
>    blk_mq_dispatch_rq_list+0x21c/0x714
>    __blk_mq_sched_dispatch_requests+0xb4/0x58c
>    blk_mq_sched_dispatch_requests+0x30/0x6c
>    blk_mq_run_hw_queue+0x14c/0x40c
>    blk_mq_run_hw_queues+0x64/0x124
>    blk_mq_requeue_work+0x188/0x1bc
>    process_one_work+0x20c/0x608
>    worker_thread+0x238/0x370
>    kthread+0x124/0x128
>    ret_from_fork+0x10/0x20
> Code: f9404282 79401c21 b9004a81 f94047e1 (f8206841)
> ---[ end trace 0000000000000000 ]---
> note: kworker/0:0H[9] exited with irqs disabled
> note: kworker/0:0H[9] exited with preempt_count 1
>
>
>> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>> index 2351f411fa46..35a7a586f6f5 100644
>> --- a/drivers/block/virtio_blk.c
>> +++ b/drivers/block/virtio_blk.c
>> @@ -129,14 +129,6 @@ static inline blk_status_t virtblk_result(u8 status)
>>    	}
>>    }
>>    
>> -static inline struct virtio_blk_vq *get_virtio_blk_vq(struct blk_mq_hw_ctx *hctx)
>> -{
>> -	struct virtio_blk *vblk = hctx->queue->queuedata;
>> -	struct virtio_blk_vq *vq = &vblk->vqs[hctx->queue_num];
>> -
>> -	return vq;
>> -}
>> -
>>    static int virtblk_add_req(struct virtqueue *vq, struct virtblk_req *vbr)
>>    {
>>    	struct scatterlist out_hdr, in_hdr, *sgs[3];
>> @@ -377,8 +369,7 @@ static void virtblk_done(struct virtqueue *vq)
>>    
>>    static void virtio_commit_rqs(struct blk_mq_hw_ctx *hctx)
>>    {
>> -	struct virtio_blk *vblk = hctx->queue->queuedata;
>> -	struct virtio_blk_vq *vq = &vblk->vqs[hctx->queue_num];
>> +	struct virtio_blk_vq *vq = hctx->driver_data;
>>    	bool kick;
>>    
>>    	spin_lock_irq(&vq->lock);
>> @@ -428,10 +419,10 @@ static blk_status_t virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
>>    			   const struct blk_mq_queue_data *bd)
>>    {
>>    	struct virtio_blk *vblk = hctx->queue->queuedata;
>> +	struct virtio_blk_vq *vq = hctx->driver_data;
>>    	struct request *req = bd->rq;
>>    	struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
>>    	unsigned long flags;
>> -	int qid = hctx->queue_num;
>>    	bool notify = false;
>>    	blk_status_t status;
>>    	int err;
>> @@ -440,26 +431,26 @@ static blk_status_t virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
>>    	if (unlikely(status))
>>    		return status;
>>    
>> -	spin_lock_irqsave(&vblk->vqs[qid].lock, flags);
>> -	err = virtblk_add_req(vblk->vqs[qid].vq, vbr);
>> +	spin_lock_irqsave(&vq->lock, flags);
>> +	err = virtblk_add_req(vq->vq, vbr);
>>    	if (err) {
>> -		virtqueue_kick(vblk->vqs[qid].vq);
>> +		virtqueue_kick(vq->vq);
>>    		/* Don't stop the queue if -ENOMEM: we may have failed to
>>    		 * bounce the buffer due to global resource outage.
>>    		 */
>>    		if (err == -ENOSPC)
>>    			blk_mq_stop_hw_queue(hctx);
>> -		spin_unlock_irqrestore(&vblk->vqs[qid].lock, flags);
>> +		spin_unlock_irqrestore(&vq->lock, flags);
>>    		virtblk_unmap_data(req, vbr);
>>    		return virtblk_fail_to_queue(req, err);
>>    	}
>>    
>> -	if (bd->last && virtqueue_kick_prepare(vblk->vqs[qid].vq))
>> +	if (bd->last && virtqueue_kick_prepare(vq->vq))
>>    		notify = true;
>> -	spin_unlock_irqrestore(&vblk->vqs[qid].lock, flags);
>> +	spin_unlock_irqrestore(&vq->lock, flags);
>>    
>>    	if (notify)
>> -		virtqueue_notify(vblk->vqs[qid].vq);
>> +		virtqueue_notify(vq->vq);
>>    	return BLK_STS_OK;
>>    }
>>    
>> @@ -504,7 +495,7 @@ static void virtio_queue_rqs(struct request **rqlist)
>>    	struct request *requeue_list = NULL;
>>    
>>    	rq_list_for_each_safe(rqlist, req, next) {
>> -		struct virtio_blk_vq *vq = get_virtio_blk_vq(req->mq_hctx);
>> +		struct virtio_blk_vq *vq = req->mq_hctx->driver_data;
>>    		bool kick;
>>    
>>    		if (!virtblk_prep_rq_batch(req)) {
>> @@ -1164,6 +1155,16 @@ static const struct attribute_group *virtblk_attr_groups[] = {
>>    	NULL,
>>    };
>>    
>> +static int virtblk_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
>> +		unsigned int hctx_idx)
>> +{
>> +	struct virtio_blk *vblk = data;
>> +	struct virtio_blk_vq *vq = &vblk->vqs[hctx_idx];
>> +
>> +	hctx->driver_data = vq;
>> +	return 0;
>> +}
>> +
>>    static void virtblk_map_queues(struct blk_mq_tag_set *set)
>>    {
>>    	struct virtio_blk *vblk = set->driver_data;
>> @@ -1205,7 +1206,7 @@ static void virtblk_complete_batch(struct io_comp_batch *iob)
>>    static int virtblk_poll(struct blk_mq_hw_ctx *hctx, struct io_comp_batch *iob)
>>    {
>>    	struct virtio_blk *vblk = hctx->queue->queuedata;
>> -	struct virtio_blk_vq *vq = get_virtio_blk_vq(hctx);
>> +	struct virtio_blk_vq *vq = hctx->driver_data;
>>    	struct virtblk_req *vbr;
>>    	unsigned long flags;
>>    	unsigned int len;
>> @@ -1236,6 +1237,7 @@ static const struct blk_mq_ops virtio_mq_ops = {
>>    	.queue_rqs	= virtio_queue_rqs,
>>    	.commit_rqs	= virtio_commit_rqs,
>>    	.complete	= virtblk_request_done,
>> +	.init_hctx	= virtblk_init_hctx,
>>    	.map_queues	= virtblk_map_queues,
>>    	.poll		= virtblk_poll,
>>    };
> Best regards

