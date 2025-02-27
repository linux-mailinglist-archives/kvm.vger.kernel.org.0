Return-Path: <kvm+bounces-39576-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8874EA48009
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 14:54:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B1423AC3FD
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 13:53:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50270230993;
	Thu, 27 Feb 2025 13:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MZ9B4p1Y"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2066.outbound.protection.outlook.com [40.107.243.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52D242C0B;
	Thu, 27 Feb 2025 13:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740664423; cv=fail; b=TCO71i/zP1jScEAkxX18YuoNmUtA7swsfahPtvkeMzAoyITi6nHOngQyDzucfFELn3+vpGrhTsZ90vIbovGIhLlyqpnZ6TvjWo22lHNxetQn5ysZs7NEoriYtzv6vQXVvvbwlm7aviObNChWAN3oZHi5rQGWftEODpDXx4KFg/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740664423; c=relaxed/simple;
	bh=AZiz1hAI855MDJC9CWK41C0DSMn3qagpxeoPFaWuAo0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PoPxeN//4I1obI6wvlF6XcRB7qH9OlLs7LFohFu3oeN+VpC4sOXtW18jiN/r2WOdCocmLj+/dF0ZsHpDC2UE5ktkkGPrA7eGmgKn6at9E1CLMzophxWS3Pl5UdhkH13iCI8BTl5y1AdWMG/JmnHHEr4HEhLN+kFuQIHE1qxT7OA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MZ9B4p1Y; arc=fail smtp.client-ip=40.107.243.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A+IhWJxrh0q/82WqBhA/i7/5/ilJ5fab0x3X5fzqkyrKvzY14wiXCoubx61KOxVFr0hA8X6jHzDIabqgf6GfKrg428zuXlGElI5gM6wF360JrlIFvMzAkoHAcfIhF5VF73TfFUpRkGKDxVWoZmVaMT1iA153zZmRinoLwfSzezZif36P8DblKLPPViKOK/ZvMl3suduuNLSWOyTlLA4FsUhkCIp/kkChYq3NFvTBUdJYkVGar/H0LUl1oyzKdBtxl0PyvbCaPIwD0g2TIr/9vam9Hux72VP1sld5aBdct4LfjRhotEqrJych0K+pBsPN1MVAI9AIgfAldeXLY+dRxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BPnTLLrEs9FFBkQUkMLCrLimEzkDGK2CMM7DfHlRgR0=;
 b=PnvPZgxUADwHvzW8HutWpQtkXmDQBmtYnZdKZwGk9VwY/uGfcm4Y7Rm4kO90DnirR8i5DglhpgEpl8mJPMgYm0GpSJd0FY5Q6KK6LWzwoqLFekHDsiXmA7m4uNP9WKucTEaRu5se2fInt2d4hLBDsgblmZfry4SvAOHK06wpERA5RlRxDP/pHwZN60dQ6iDlco4tWFhKWmA6MDogtE+cOJxNsXR1t+e1DUKXb9jtOnn+83v5w5IqgHJGyg2O7C6b8vlnglJkyfSmk04BXbSvDmApkUirszvs7nUA1lAU8VhYxijv7wujIEcw1rLnIzXHgaEj2YZJuFFdSvBt9W5TBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BPnTLLrEs9FFBkQUkMLCrLimEzkDGK2CMM7DfHlRgR0=;
 b=MZ9B4p1Ycx+8REhHPwIZhWhWt2JevFdR+mbuTFfWTbaKIEJiFn70hpB42EE7Ibddss88YmroBy9FyMStOw/rvhBlE16KneCbxm+rygEFjKRjjHt6u9LGVjveYxCn0GKErTKeiuAf41mQIbmubvbIUflAqpSuN+A91Zo+GoILOwe+NhPDj2Cjb897Kj3b+Am7wF0Vmy7bNT/g/zmQxlFtqFPzf25JD86IVlWaIDN2dOaRlibsLQsppT/NuxKrvMmNVnwdtNTYeRv2fh4KD5PrbdBu0kC8gM2LvzawDlKQ6m5q+lspTdyc86Nm0reAsBhRmYOcYomGWbxs4wfphTfAgw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6369.namprd12.prod.outlook.com (2603:10b6:930:21::10)
 by IA0PR12MB8206.namprd12.prod.outlook.com (2603:10b6:208:403::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.22; Thu, 27 Feb
 2025 13:53:38 +0000
Received: from CY5PR12MB6369.namprd12.prod.outlook.com
 ([fe80::d4c1:1fcc:3bff:eea6]) by CY5PR12MB6369.namprd12.prod.outlook.com
 ([fe80::d4c1:1fcc:3bff:eea6%6]) with mapi id 15.20.8489.021; Thu, 27 Feb 2025
 13:53:38 +0000
Message-ID: <2d2dafdc-7a7d-44f1-8814-20eedbe220ec@nvidia.com>
Date: Thu, 27 Feb 2025 15:53:31 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/2] virtio: Add length checks for device writable
 portions
To: "Michael S. Tsirkin" <mst@redhat.com>,
 Stefan Hajnoczi <stefanha@redhat.com>
Cc: israelr@nvidia.com, virtualization@lists.linux.dev,
 linux-block@vger.kernel.org, oren@nvidia.com, nitzanc@nvidia.com,
 dbenbasat@nvidia.com, smalin@nvidia.com, larora@nvidia.com,
 izach@nvidia.com, aaptel@nvidia.com, parav@nvidia.com, kvm@vger.kernel.org
References: <20250224233106.8519-1-mgurtovoy@nvidia.com>
 <20250227081747.GE85709@fedora>
 <20250227034434-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <20250227034434-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0099.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::20) To CY5PR12MB6369.namprd12.prod.outlook.com
 (2603:10b6:930:21::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6369:EE_|IA0PR12MB8206:EE_
X-MS-Office365-Filtering-Correlation-Id: e2d83a86-d5a8-41be-ea0a-08dd5736229c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T0IyYVY2Qmx2eGVhSmovVFgxY1ZMeUZ5dmFDc0ZvTUk2R0I4Q1hJam4ra2Q2?=
 =?utf-8?B?YkpBUEU3YVFOVWhTS3NlT3Q2UTZrOElROEFJTDZ3SUtYU2NZV0dLOUI4OGhL?=
 =?utf-8?B?SGdHa1hwTWdUQ28yVDRZZUdCL1RYbWdlaThZWlRBMXMrcTdubWFIeUtETjF4?=
 =?utf-8?B?ODVWVmt6VWk3ZXNsUmQwOG5WOUxHMENpQncxM3F3VzRTMTJLajNaWnVlV0t2?=
 =?utf-8?B?RnFpTVkwNnVMMW1WbFBUeFFTb0Fydmk2QjFVeVJmMTQ1WVVjSUJGU0NZcHAw?=
 =?utf-8?B?ZTk2UDYyNlI0UDFLb0R4NGsrQTRXU2V5Z01JU000T1pETW9IRnV3cEhXK1hV?=
 =?utf-8?B?SXdUbU9QeGFWV0lhQXFsRFZMYmk0ZkJ6YmQ1eTZZUTJ2ZFRVTUd6M3lJbklT?=
 =?utf-8?B?YzcyME1qWW9rMElwajl4dllqMVQ5U3JVLzYwS2lyMzdrbkx4eG52andKUkZS?=
 =?utf-8?B?TVpFRlBsQ0liYzdCckdrejJHNFFMcTcvZVJCNTJ1SEFaRWdWV1VORzZDZ1ow?=
 =?utf-8?B?T283WlkwWjRSY01wMUY2dGZPbldrTW43eUFtNTN3SGUvVEZMa2ZQVVhwZzli?=
 =?utf-8?B?LzVxM2szMkFYM2x5cUxjcXVzU0V1NTdjS0JPRXRSZTNJMHYvMzA3RVBPZEc1?=
 =?utf-8?B?MDVaOWJ0eW5mdmNNZm51cW9wRU9DNko3U1BtSWMyQlNwb3VMZnlYYUIxVjAx?=
 =?utf-8?B?SEhGQWdGRGZSNU9teVlwN3VPWnhHb3VncFFOT1BMU3V0dVlSbWZldnVYdlQv?=
 =?utf-8?B?QUxpMnQ5eWxwWUo1QmQ4c2xSeUtoclRXSE1zbjNUNnBMRnJ0eG1qSUVrcW55?=
 =?utf-8?B?NjBuV2Q2QnBWallJTGlBMWhQWlF4bHI0M0YxWWV1UDEwclZvZ2xXVTZhRjFT?=
 =?utf-8?B?M1FQMEltNHdoWEladkVpODZrUUpGZ3NuZkV4ZzhJcndmYWRHZVZ0YkJMbktz?=
 =?utf-8?B?Mkp3UmZxS0lpOXh6SUNRamgyNm5BQ3FBRmZ0MXZITHRwbklVWFdBZXdjQmlH?=
 =?utf-8?B?SVRzYnVZcmRnT01xK3RQYUptcVhJNTNFUjJuaGNYMXNndFlUaFA2amFCVlJR?=
 =?utf-8?B?b05iZHByYVRxMlNya014SFFnTzFTK3FOZUxDYXg1aHVDRGRSY1NtOUJQWnJM?=
 =?utf-8?B?dy9kQ3BnU0V4UVIrWVdBWTFXZ3ExeS9wQVJjWGUxQlJYTFhYSzV4ZldLTnZ6?=
 =?utf-8?B?eWZRTEt0TlVoWkFLbXdEK1N3cjNvUkl2WmNpVzVOU09RdjFCaEpUdFdCcmc4?=
 =?utf-8?B?NTBuZTNoa3BncmpVY3JkcDJMMGRwRmhCMi8yUUdJVGlmWFR0SDhJQkVpSUdv?=
 =?utf-8?B?cks3ZXdLNmluRFhIUXUvZ09ENFBuSGNkdDk3YzcwS3pXbXduMEdiOWw4OFZQ?=
 =?utf-8?B?TExXcnhyd2hjdEtaY05Kb3pLd2tUU1ltVURPQ3d5VDFTUjRVelVKK0VMNGwz?=
 =?utf-8?B?emxDMko0d3J0WUlIU0wzTnJlSE5DWnlxYzRuT3FPeDBJVGYvSEl6MjZZc1px?=
 =?utf-8?B?S2R1ZXl6Vm53MzVqVGxwbFZxcDVuRitzNG9DUTMzbVMrMDRaUGloZFo1dFU3?=
 =?utf-8?B?ZUcwL0lzdjNHeDZDMkkwa2hvWjFSbGpyNlBMSVZCN3BVZHRQMi82RmxHV0xm?=
 =?utf-8?B?NlBBSlRmSklocEZTSXJPdzJ3TWgvSStra2tEYUVkQW9rTE9Ydzl5Q3ZoUFRP?=
 =?utf-8?B?RUdHc2lsa2NJQk5OZUJaYi9LZUJDR29DUlE2UERyckFuVzBZYUUyelZmaWhV?=
 =?utf-8?B?ZFhUWkcyZW9ETVk1UktpVi9tTVJqM1dCYlB5OW5IcWJWbm9rNVhsUUJQV1Fz?=
 =?utf-8?B?eVBIYkZOUHNMUXRGd2xtMWVwaFUzOXVlSUtHY3Z4dFlQTFAxWm03REtPYjEz?=
 =?utf-8?Q?Xg8pisyW+BRbM?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6369.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TDN3bEpTbG5raGQxYy9yTC9QWlNTNm5NejZxbk80Z2ZKcEhzQko2TkN0dSs5?=
 =?utf-8?B?dFVlbDEwR2hmQmk2bC9zYjk0UzErTVlDVkFYVDgzV1ZNK2hnRmFkZlRJdlJZ?=
 =?utf-8?B?RlRqamdRZklXWDdMYUNFTEtHbGRKNHZpOFNxZWtaNEo2aVBtVGVZcUkyTExp?=
 =?utf-8?B?NHBrRFQzM2dmaW5BZlA1d2c3Y2p3MDRnK2NSaWgzcVRwWFowTFdkVHpLaCt4?=
 =?utf-8?B?dVNrV2lFNS83WVlEUktEcnpFTjdSZjNJUVUyZldxZmVNUzRKRlpCYjNBWnJa?=
 =?utf-8?B?VHdiNElNbHBlc3NQQ3FFM1VjMEJVWndUOGxVaU4rKzZRdWk5MzB0Rk41T2VF?=
 =?utf-8?B?ejg4TFpwY3B4OEV5ajdYZXVPeFMyUVdMZGxkV1ltUWtTb2ljWlY4aWsxMDAv?=
 =?utf-8?B?bGVabEU1YzFiODNqNzQyMWpzWHFFc2c0bWpQMzlnczZFeUdxVEVHaDBNY0JZ?=
 =?utf-8?B?d05MejBJbUVGQzVaZGdqUHQ1Z24wK0l0MDNjazQzYjJKSy9KUXgxOUxubHZN?=
 =?utf-8?B?OGNia2hRWWU0NFE4WUUxSnJZWHc3cmQ5cGxvZFdUR2dJd21KdHpWeFMvRDN4?=
 =?utf-8?B?SVdoZk5wa0VhMTFyZlQrTjAzQWlMZGNGdVNFU1ZSTXRrNUV6ZWEzbXA0a0dG?=
 =?utf-8?B?SjQrTTR0OXUvNGZlSVYwaFNXV1ZoMTlwbk9kenpWQUh6ZE0yZGRTSC9RNFpB?=
 =?utf-8?B?UUFuMGpxR1RDSmtLSlUvVHRNb3AwOG9FSEpIUk1Fdi9hdUpCWEtVeUZ2TFky?=
 =?utf-8?B?SEkvSkN5eXJobDB5cXQwT1IzMWhLY2cwU1JzbXMwMVgvQU5meTJvOFVrd2t1?=
 =?utf-8?B?ZWoxdjhkUkI5eWs0UHFCYVdNTC9ZODA3VGFwcFdMUkpReU9ZcVVUNnd2dTdh?=
 =?utf-8?B?Q3FraG1NUERhZ2cxbmVjZW1GY1dkdHZaRVNFRkRaYnJYeG1aeVhIaEJnaG9h?=
 =?utf-8?B?eTUvQWpVU0h4ZWhTR3VmRGF0Z0J5c2NHQU1pNnU1cXVyNllLL2lJakpnQVZz?=
 =?utf-8?B?ZE1SRURLa2gwbm9QTVp5bnFrUXZlbmVIUWtaUk9waFYyYmt4ak9aQm5JQ1Az?=
 =?utf-8?B?V2ZJeVB4eGo5RUMyMlJCMmIwVm9KYTNicUJ5c0xZNXhKWnd2Z012dk9sSHVZ?=
 =?utf-8?B?bmJ5NW45VEk2RjRCR1NNc2pacW1UczFGaHFEMVZKVG5sdjdvOTBMWEZ0R1dZ?=
 =?utf-8?B?V0V4OGdUeEJmZWYyMlByRjhBNXBJazZROVNMWDlZZmZKZld0dHJKL1hEeEk4?=
 =?utf-8?B?V0ZHSE85QUdRaEZ1MXZOdlFYVWlraHRWNWdaV0VaMjA5ZXA3TFk0bS9qN2pF?=
 =?utf-8?B?a2hsbXpSR0J2TGRiZC8weE5yakJ0dTA4Q2JhbmhoOXdoWW1TR25yRVI5S0gz?=
 =?utf-8?B?QUNqVFB1Y29xZUhEOVI0ckFLZVhHdmFleHRIV1ZXM1NDVmxyOWpjSmhpUDRs?=
 =?utf-8?B?WnNzRS9aKzFMdDNuZUJXbkZNRFFKdTZGd2pJalhKcyswK05KNnJsc3lWak9C?=
 =?utf-8?B?QzdYMElKVHk2VFpWbGxuK3QyNDlaYis5VmVyRERpcm14TUMvTjVSZFdqQ1FN?=
 =?utf-8?B?MDZoVmxjaE1jV2xpSnJtRzZZVDlWS1ppa2NrMHNlQ2h5NEVqRGQzdjNUZGk4?=
 =?utf-8?B?V2NRWmFXQ1p0eTNqd2Fnb21XaURsUWorV040T2s1Wk1CMFdWaFBuOEhKZ3Vp?=
 =?utf-8?B?UVZ1L1kzN1hNRC9YQzRmcTgzeDZEZzZEY0Zpb003dUxYRGt0WHEzUkZ0Skhy?=
 =?utf-8?B?aGdsTjdwVG1RMGpaWm1ITjBJazc1U3UzdmJweXNRNTEzMUNiZWZFL2NjazdU?=
 =?utf-8?B?bkwrN3FlWGFESzdiUURSaS8yU05XNlBCcGFzOTZEWU5NcTNQQUNPYS9IYTZn?=
 =?utf-8?B?c0xaRFN5UnlKYXNUTFphYUp1M2pLYkozbFpYbHBSUURNU3g3c0JudzZtTlUv?=
 =?utf-8?B?bXMzT2lCbDV6WGJtOTFEbzYyckNPM1UyUy9lcTB0OERUQ290R0xHdjYzWGRR?=
 =?utf-8?B?MDRZNkZNT3pnVHFIZWFRUEFmMTVDY2FZSDdkQXdLN283ZCtKMUVnOExCRnJY?=
 =?utf-8?B?WEMzZkpJV0xCNzBpRGh2YU12Sk1jN2ZPMDdZTzhXNmZHV2NrY3h2M1ZPMDFi?=
 =?utf-8?B?aG10MTZkbFRlVVFPZHA3cXZaRVBXRWExb0pYOTRUK2RrNDVkK2lid3cwUDF4?=
 =?utf-8?B?M0E9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2d83a86-d5a8-41be-ea0a-08dd5736229c
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6369.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2025 13:53:37.9826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TvHiMioEDjKNCyWyJOPXMkdNJr8oePh4fbDEgESQ8h2nsZjZ66IFpY+fQ6EZVF/pHJabIrD3YV++bum9M3FeAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8206


On 27/02/2025 10:53, Michael S. Tsirkin wrote:
> On Thu, Feb 27, 2025 at 04:17:47PM +0800, Stefan Hajnoczi wrote:
>> On Tue, Feb 25, 2025 at 01:31:04AM +0200, Max Gurtovoy wrote:
>>> Hi,
>>>
>>> This patch series introduces safety checks in virtio-blk and virtio-fs
>>> drivers to ensure proper handling of device-writable buffer lengths as
>>> specified by the virtio specification.
>>>
>>> The virtio specification states:
>>> "The driver MUST NOT make assumptions about data in device-writable
>>> buffers beyond the first len bytes, and SHOULD ignore this data."
>>>
>>> To align with this requirement, we introduce checks in both drivers to
>>> verify that the length of data written by the device is at least as
>>> large as the expected/needed payload.
>>>
>>> If this condition is not met, we set an I/O error status to prevent
>>> processing of potentially invalid or incomplete data.
>>>
>>> These changes improve the robustness of the drivers and ensure better
>>> compliance with the virtio specification.
>>>
>>> Max Gurtovoy (2):
>>>    virtio_blk: add length check for device writable portion
>>>    virtio_fs: add length check for device writable portion
>>>
>>>   drivers/block/virtio_blk.c | 20 ++++++++++++++++++++
>>>   fs/fuse/virtio_fs.c        |  9 +++++++++
>>>   2 files changed, 29 insertions(+)
>>>
>>> -- 
>>> 2.18.1
>>>
>> There are 3 cases:
>> 1. The device reports len correctly.
>> 2. The device reports len incorrectly, but the in buffers contain valid
>>     data.
>> 3. The device reports len incorrectly and the in buffers contain invalid
>>     data.
>>
>> Case 1 does not change behavior.
>>
>> Case 3 never worked in the first place. This patch might produce an
>> error now where garbage was returned in the past.
>>
>> It's case 2 that I'm worried about: users won't be happy if the driver
>> stops working with a device that previously worked.
>>
>> Should we really risk breakage for little benefit?
>>
>> I remember there were cases of invalid len values reported by devices in
>> the past. Michael might have thoughts about this.
>>
>> Stefan
>
> Indeed, there were. This is where Jason's efforts to validate
> length stalled.
>
> See message id 20230526063041.18359-1-jasowang@redhat.com
>
> I am not sure I get the motivation for this patch. And yes, seems to
> risky especially for blk. If it's to help device validation, I suggest a
> Kconfig option.

The primary motivation for this patch is to improve spec compliance and 
enhance driver robustness.
You're right that there are different cases to consider:

     1. For correctly behaving devices (Case 1) and fully incorrectly 
behaving devices (Case 3), there's no change in behavior (Case 3 never 
worked anyway).
     2. For devices reporting incorrect lengths but with valid data 
(Case 2), I understand the concern about breaking existing setups.

To address the concerns about Case 2 while still moving towards better 
spec compliance,we can make them configurable, as Michael suggested.
Some configuration options:

     1. Via a Kconfig
     2. Via module param
     3. Via adding quirks for known non-compliant devices (identified by 
subsystem dev/vendor ids) that are otherwise functional.
     4. Via virtio_has_feature(vdev, VIRTIO_F_VERSION_1)


>

