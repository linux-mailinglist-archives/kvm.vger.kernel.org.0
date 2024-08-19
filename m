Return-Path: <kvm+bounces-24534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03B53956E97
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 17:20:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 531EEB26A25
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 15:20:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 071D539FC1;
	Mon, 19 Aug 2024 15:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UUK+vnvZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="I7RhWfgW"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8311429D0C;
	Mon, 19 Aug 2024 15:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724080809; cv=fail; b=cqyo9lNyMNvRB8ZnyJnkirXVCqbN4nnHhcSt8/JcoVJaxlcpB7DE40TR/l1jq6l+XGPTGZb8xlIhXn7Ed7lAAGn1L8FaiqGj4yYVOvKAe48gZlTpD9Sr3L7kUrgmPK2K4HQ7Umnp8Wu3zgcOr2OJimc9imIwncP+SriDsAu/D5k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724080809; c=relaxed/simple;
	bh=XUYjgLohhme3Dd8f0pBhbrn1gokh1y4tCoKTPua2tXY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Pt8y4nMPkSAB/mhY3sxXYki+DSTPa8igT3V+5aTAIZimz2VBWtSR3K3Zn6R51+cOLk2vq6WDdADW4KZqXBfYJFE5hCxzV+i3a4swjsBYq0+NCKPxvm8N9juS3JmeO6tnJLDt/fYj5KLbMYdF88xW5NTlz0ORKB71UlWzFwG+GbU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UUK+vnvZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=I7RhWfgW; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47JD6q3t025727;
	Mon, 19 Aug 2024 15:19:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=960IBQiwmTU4b5YsJsP3hPox/4Cw/tAD4ANt05LI3LE=; b=
	UUK+vnvZmVyHyVh6R7ILyRz1hN74kETObfWR52WRnBICT8hfrTyGM0P3VpwkLZHn
	MsF+6L8yaSIvjadGO9wOuAjGGf/hQhGlnsh7Gq0pypHpNXChtqZ5JDh1Nnl2w+JS
	5b4RjTAg68+1sJ9NbXBo1+P4ifRBXVHylhKLNBphIt9tuxYrty/vvqtnEwSSEApJ
	5Lho2iF+c3+0w1TrRKuLYZXd4kwT7cX1thqvsMzcFTIsokTw9PLhqwsGVfOlPDUz
	ZQmFoXTatDqMRzXJsiQJpDkZU5nU9QmmPPv443jm2k/nD4quU/CpBDIv/lPlwCfh
	NNfldAj30JbynU+cTTxIpg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 412m45avg0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Aug 2024 15:19:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47JEbHQe030738;
	Mon, 19 Aug 2024 15:19:49 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 413h9bfrve-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Aug 2024 15:19:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n4JLGp9kcvBVdZcxF0ielQ9BmhVp/lYrrbe6o/VuAiT5/d6wKp/GNN0XTx4fpxKlvEd4RnTGGKBRHWpzMAv4db/1d7PhgdxNPGrFjPGU51cYCcaPaULlshHIk1KYUo5dTZb7KCMUDnKV716EhZYV3asISE2q8sAd6YvFiH24JPOHMplNs+ycIKaBa57eWju8MxIF0s3i0Cmb+xuw6I7kPxI+GsUcG49j+v/aKD9wJoC+wwZYZLc4BdwlNQH7q9Bvz2Z5ou2JgrnSBpuKw29p17AdsjKnJaDyyQh/Mbq843ZIw+bEtMD9pxc9blp2g33SHwWhrua/Cwi+b+1IfHNFOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=960IBQiwmTU4b5YsJsP3hPox/4Cw/tAD4ANt05LI3LE=;
 b=rjTzPJQAX0dXD9ZfKoaAyBKthN1k42egHeYlGTbC2B3ccWp1GCBC0jCiygir/D0ag5u4xWXRC32QiobRXl+mTtuvzjyt+2RRoAjAKxp4go4kStAmKJfhWc+Ck1C39exjv4RtHsFDk33jtt40IQ8wX7NIUdx+0xbSvsutvK5+K/goHi9ZTD3qcR1gb4f/Wq6GDzsTQ0R3we4qDF7hlLw5+Z1bU2ToIvSYPdhcez0Ifsuok1umBSpqKfK3+nPjxeXzwNuNEsJU4Ryl83gdAc0tYpFBxvuRjylNMEqBwTUy1UTUXSK+vBhYhld0pKU05SavpK1+YH2eVqw3SJYINVUOdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=960IBQiwmTU4b5YsJsP3hPox/4Cw/tAD4ANt05LI3LE=;
 b=I7RhWfgWP0kc0/FVHQJltz73L4ZoPuF1+8zcXoJ7Timqfx0YDhP+TOxFNcB/as5GKX7aKSjhF5iWMYxnCOzJjDURGBRiXq5ZtDyyESIRRijp+GaRNX1EvMWYUyoPSK6ZkWmpiejH71+isiR4k+XGyftmdC5Sin/A3DFCJIKfSyg=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by BLAPR10MB5172.namprd10.prod.outlook.com (2603:10b6:208:30f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.13; Mon, 19 Aug
 2024 15:19:46 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.7897.010; Mon, 19 Aug 2024
 15:19:46 +0000
Message-ID: <02862261-b7cf-44c1-8437-5e128cfd1201@oracle.com>
Date: Mon, 19 Aug 2024 10:19:44 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [kvm?] [net?] [virt?] INFO: task hung in
 __vhost_worker_flush
To: "Michael S. Tsirkin" <mst@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc: syzbot <syzbot+7f3bbe59e8dd2328a990@syzkaller.appspotmail.com>,
        eperezma@redhat.com, jasowang@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, virtualization@lists.linux.dev,
        oleg@redhat.com, ebiederm@xmission.com, sgarzare@redhat.com,
        stefanha@redhat.com, brauner@kernel.org
References: <Zr-VGSRrn0PDafoF@google.com>
 <000000000000fd6343061fd0d012@google.com> <Zr-WGJtLd3eAJTTW@google.com>
 <20240816141505-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20240816141505-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH5P221CA0006.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:1f2::19) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|BLAPR10MB5172:EE_
X-MS-Office365-Filtering-Correlation-Id: 145e9e39-657f-4683-353c-08dcc0625c12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TFgrUjc0dWJod01aaVNidW8wZmRPazBQUDNLdE9yTEpWMmxzOXJENTk2a1lT?=
 =?utf-8?B?NzBnZDhZeWh6bjRXNXhORDVMVmd1blV5L2t1T1RrQ2ZVQ2IyelYxZGU0aWpL?=
 =?utf-8?B?Mkg2ZGtaMzRJNEVOTHd4Y2UrVmo5YkZWTFlHQ3B5Rk9KZ3hzVVFoQlhuQ0tO?=
 =?utf-8?B?WUVxb0F1Zjk0YUw2M2RpODlqNmthelJXbTVmWEQ0RzVSWkNWYWUxTGFPeTBO?=
 =?utf-8?B?anpFTDdXa1JLM1Q3NUY0VkJQMXIvTUNLMlE0YlQvd3gxWFRoQjRnRXlpOTln?=
 =?utf-8?B?N3NVbFlaTEY5TmNLWVlOVTBVd0xyaXhSM1R6Y2M0ajhsSDRaYlBFUXpRRXh3?=
 =?utf-8?B?ZzcyY0VNL1IxeUZ5UmJqL1VRWk16cm9HS2VYS3N4SnRTSFJyaUc4dm1PSERN?=
 =?utf-8?B?c2w2M2w2Sy8vQk9MZENQUUk5eHJxdjA5UmJJU0V6alBYZ2dudUFXa0pCSmxM?=
 =?utf-8?B?ckpUbmU1MzhXWnB1aDNyNUpFanJ6bFkvVHlKZ1RmS1oyTTN1TFgrNVpMWGJ2?=
 =?utf-8?B?TDNRRzRpRkl0RXV3empud3JjN3dSd3Q3Nlg3YVZhbjVpVGFQNUREczVwTW10?=
 =?utf-8?B?SUIrZjF5QUZ0RVFBV2luWVducjVZeE9nOXNyelZmdU9xSXM4YlJuMEYxbFdv?=
 =?utf-8?B?Qm1OaG91TEFOdWM5MmNxRXpZamZrOFJLWFdGMXZQdXVId0lPK1RKUEZmckFC?=
 =?utf-8?B?eHVtSW5QU0d2bnRSZWhyR2ticTdKV0RzRFdRNW9pWGZFRjNIWmVCMHkrVGpn?=
 =?utf-8?B?c1REUWt0QVFYWTNTOHBWV0hMaDh4S05qOTdjWFJqdUI1cHVZWGVLVk1mR2xG?=
 =?utf-8?B?UWo2VkFTbEZBMWdJZjdsR05oQUthY2Z0UU44UUVUSE9QbGhEUWwydmlqZERP?=
 =?utf-8?B?c0NqNU5FcE8yRVN2d2orWUowMWthcmg0NUkxdG1wLzFpS2JHY3NUSGdjaGg4?=
 =?utf-8?B?MjgvVzIybnJGZjhZeW9LbHpPeWJlQ212cEZ5eGNNb3EyazU5cTdUSUh5Y2VF?=
 =?utf-8?B?MFlTTlpraVYxS2FET2JZb1d0dGd5TitnNVFuTU9jVnVXc3hEK2J2MzZsOUFu?=
 =?utf-8?B?TDFqMm9Jdm02Wk9ONk4wclltaHJ1OGNWUXNFZmRTRk9qU3NSamJZcnVFT3pR?=
 =?utf-8?B?eFQrWUZEOXlHeUh6eEZGM0Z6YzlxeUxQeit4R1VvVUt3bmN1dUExaDVUcmg1?=
 =?utf-8?B?YVVxYzNqN05JdERzZ2l2UTRVSFNsd09jYXdFalh3ZGQ2aDM2S3dlQ0xQUER1?=
 =?utf-8?B?bHpPVkwzbG93WWFaK3kxMTB2YUxXTDA4MWdERTNXeHFZakxicFJ3b3Z6elBQ?=
 =?utf-8?B?dG9acGgvUFhGYk9VNnc2QzZJMDQrU2lCdUJ1aGg1ZWx3TVpoSkRsZnBHZk5G?=
 =?utf-8?B?bXR1cUc2T1U1akwvQkpHdjZHdUdSdHZpdlUxU3Q3Z3VMQmtxckV1Mkpha3or?=
 =?utf-8?B?RndyelFmT3A3aWF4d3ZWbUFlMVN1akxoRXU1MHpMc25RU1pqSVFHTmpVaWQ4?=
 =?utf-8?B?cGpDWTJLL0QyWDJwdCtZR0Vqano3Sm5VdVQ1eWVkaUhaOHd2YWl6WEFpRW9T?=
 =?utf-8?B?TUE0aHV4TFFRRTAwL2FiTWt4VHlWemEvWXZEUWhyYlF6OC93alE2NXNZYmZI?=
 =?utf-8?B?dW5XeVVQNkIxQi9XNFRBWVNtK2RpUEpmdWc5UU5JNmRnSmt5Tk1qUG80R1d2?=
 =?utf-8?B?VGhtWjVOTktmYzB1bUc3UXIrY2lDTFFoR2hwUXFIM0FtMFFuVGZ3Rmo4TUNX?=
 =?utf-8?Q?oF64SnKytK86WlgjhQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NnlnazFPSnpkemF6TWpFT1QrVXdRMENTVTRMUXBzQk4rNjA4RnB0dTIrRlp1?=
 =?utf-8?B?WG9LVmJBS3lmTWt5ZXBjRDNtQWNoZ2MxdVljZDNQNUZiNFdka1FkZnZaRHBs?=
 =?utf-8?B?VTZZY2dGTkFManBmSjQ5VzA2NnRHY0RTVXJObnZ1eXRYeEJyNGgvR01XOFhU?=
 =?utf-8?B?Yk9yZ05Ea2dVdUtRTkZmYVNscHh2N0dmOWlIRjNrdmtaRlJXUk8vT2l3dXV4?=
 =?utf-8?B?UHA1K0dzdG5hVElialJaUEpDazBhb1pveStuYXBpVURtMGN3c2JLdUVObnZR?=
 =?utf-8?B?YzhiSU1BakZXMVIxSVVESnZGMG9RVWVsUnlvYmxycmV3MHpraDZMNXZuckRR?=
 =?utf-8?B?emhTYnY4YTBaT2hxQ1R4VTBuaVpBYUs1a3kxZVhMRlV0OVgrMEpSYTczaHd5?=
 =?utf-8?B?WGhMZHM2NkNOY2VUZWFXTlUyZUZ6aTZpRXYzREdCUVRCQmEyWVFubllNdmpU?=
 =?utf-8?B?MktVWEF2Z25RZnVlSVM4azF3SWxCM3doTGFETmJOTVZoRElNWWkrT1liMzcx?=
 =?utf-8?B?Y2JPVjJ0UHJZWW11TVEvS253NEVTSTY5VXAzMGxiYy9Xa3JkWkE0ZFN1NFlE?=
 =?utf-8?B?VFIxdEN2cHJ6U0k0WXdmR3FyOXN1VjJtakpIOFlyM1liWUpGYmFmYmVWbTRJ?=
 =?utf-8?B?eGowNlBRVVV1SEZVeTcyUW9KMit4STJ6dm1iSXFURW5HalYrQ0RVZ2YvZHYy?=
 =?utf-8?B?OWxUelIwLy9qUnRNZnNjU09pUlFKc2lzMmp3MmUvY1pySVYyRjNXNU5ic2Fz?=
 =?utf-8?B?WjR6TkhCT2VkZUNpVTJHUk5GbVAzNWozMEliYndSUjByRm0vTmdodXlMeVRh?=
 =?utf-8?B?bVkrWGljR21BajhsY25yOUxsQjdodUNJaHNHSXBHUVFuSmx5Szg0RXVnWnlM?=
 =?utf-8?B?TkxZTG9ESTk5OTRJZzFqa1REWkUyWHRERGpnNFMybisyOXdHdmlCMVdZVUt0?=
 =?utf-8?B?R2RFd0xSbzcrRzBGTGZIcVdoVjNlUVBvU3YvV0RqV3lTV2dYamwva1Z4aG5E?=
 =?utf-8?B?WVF0WWl5VW94MzYvYWtlMnlCcDl2YVJSbVpZNTRhQjF2ZzFMcmhmTWdRVTh4?=
 =?utf-8?B?SDFpT29kU080RGlzMFF1WWVXVzZVMGR4b1VYTmNSdzNWczBKdXpBajZLYStB?=
 =?utf-8?B?UnMzN01FRENmaTY3dDNKL04xb0ZobWN5clFhWlRsWHplbUNydmtUVitNbWVV?=
 =?utf-8?B?dnl6YnlYVWZmKzJINVkyalI2S1c0aFJDT2NSTmk1UURHM3pWMllPejhCZlRl?=
 =?utf-8?B?bzI0Z1FuWGI2N0pJZlhMUzcxYUthK2VCNHBXWTZMYWhsVCsvTjBzNDdoQWZG?=
 =?utf-8?B?clF1WGFLTzZNY0RqQUhvN3lTWmFmUEZvSnlCaDl0aGc2SkFWSDJ3Skp2YTdP?=
 =?utf-8?B?SmpVb3JWV3dwMStYS0tkTW5IN2gwa0Rpa3BNUitvY0JkTWdaNFhqQTYxQTJy?=
 =?utf-8?B?ekpUMERFRFNRV0FwRE85M0pndWtSTEtiK3NRcWplZU5kN25qTGcvOXpDRzha?=
 =?utf-8?B?WURGMy8xZUE1NFlTNjRoVVZPSzJGbFpBTVBxY3BMNnpVeEk4MVlhdXVSWDNX?=
 =?utf-8?B?eE5FMDJtdjFTcENKWElzZkJqdjdYb2xRS1VlYWl2MDJNWmR5TVF6QXVXaHBK?=
 =?utf-8?B?WlBiOTlxaVZUb1I3T3ZTeERLVDJMRUlycFE1aHpvWFZ0MUI0aEs5MGRzTUR5?=
 =?utf-8?B?R1FDWUdqenZCYmh3S2ZFUkpta0Fva0lhKzY2ZHNTRjR6VzRhM29xVzRJMURW?=
 =?utf-8?B?d3Q5eERLdWhlYWp5cHl5dW5DSVZNcTlFQ1J1Kzh1cXhkYnR6Tk1iLzhYSlk2?=
 =?utf-8?B?d0FHVkpXOHZVUmhhR1IyckgyZmhLYTE0clFpV08vcHpuanl0UnYyNUdad2U5?=
 =?utf-8?B?UWFsWmtWaHRYZVM3cGRlMkpvRk1IS0N6VWUxL0JYSGg2UW5Lb0luaXJscHNC?=
 =?utf-8?B?SXkzdGhISHhRdERwTnA4ZUtqbEhQNXpmdXFBV3BoRk5sM2w0Q3Ftanc4Q1dh?=
 =?utf-8?B?ODhZR3dOb2J6Lzk1Kyt6SEVOYjdKd3BoQy9ndE1uYkRGMUxaMjdDTlNSU2F0?=
 =?utf-8?B?ekRWTzA0Y0FZRXk4YlEyRUJNVnVFbmUxS3oxcmZoUnFVejdmVm1kR2xPZk80?=
 =?utf-8?B?QXdLWllNa3lOYUptcGl1RG9vcUw0OUtlWmphSWwzUkNaTy8vdVR6K2hFVjJD?=
 =?utf-8?B?VWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aTf/f4oQPpM7P+HbJglLbcuW252IsbKhC9Ok7ImAwID6Eh1uTwkNN3N2gBeIzt53DZVUs4P/F8apNrJ7OXMU6kPbXSOQop3l/OsPAjCgVa0FbiaSgEINQzyYIyVEYzRymDRftLsu6QZi7UaggWdvA4UFckaCtv+bmBc/Y1EIrJ84Sx682F7kDh3elj6rIhJVQjHW0iXxWVC/JASaT4JZ7FVhfJlT7ofl7sn74FcsUKRI9XQ18QS1WnWAMuhU+RuZss3jcd6bnrp9FIIOYSr+5PXDpjb4pwudUmJQMbHgkAieo49kjkJrWAFrorcPXnMTCmzxZO1O7AFy626EaiF5UFk6d326lHn+ctP1aTem/qzSdRuX0acNmN7MwbW+OvDJYyvK+OOpnY9kpEg65VRUdu+xXdQxibECHrBbYKIKhaywBjvwBgXcFr6DEqEuv2pc4ohOSa5wMlG6NSaZZo1BFrQtAlLQG8ZkCo3098uhXn04j1iRs1smH6gVVPMbE11BApBSxCAzUrrUvhuO+6IOUCp/GR7zOcnbfdZGICNBIA2fETF0nfXbK/iK3U0++vtWat/qp62EcVDbQlJdFMCm1vsUHUCMELR7Nkd7LjB1U94=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 145e9e39-657f-4683-353c-08dcc0625c12
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2024 15:19:46.6187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9E0Psbpr/i1X1TMNpwt+04i6J9MeTIs+NnCrVepS6l5uvgXjT1DZzbuZusa1yykQhtcO6//sgYEncIy19i6lxWd1kBCLKDjASX/TUxQutbg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5172
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-19_13,2024-08-19_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408190102
X-Proofpoint-ORIG-GUID: f5YEbHQu7v8aKozVxshHTDnnjeTYk0Ue
X-Proofpoint-GUID: f5YEbHQu7v8aKozVxshHTDnnjeTYk0Ue

On 8/16/24 1:17 PM, Michael S. Tsirkin wrote:
> On Fri, Aug 16, 2024 at 11:10:32AM -0700, Sean Christopherson wrote:
>> On Fri, Aug 16, 2024, syzbot wrote:
>>>> On Wed, May 29, 2024, syzbot wrote:
>>>>> Hello,
>>>>>
>>>>> syzbot found the following issue on:
>>>>>
>>>>> HEAD commit:    9b62e02e6336 Merge tag 'mm-hotfixes-stable-2024-05-25-09-1..
>>>>> git tree:       upstream
>>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=16cb0eec980000
>>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=3e73beba72b96506
>>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=7f3bbe59e8dd2328a990
>>>>> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
>>>>>
>>>>> Unfortunately, I don't have any reproducer for this issue yet.
>>>>>
>>>>> Downloadable assets:
>>>>> disk image: https://storage.googleapis.com/syzbot-assets/61b507f6e56c/disk-9b62e02e.raw.xz
>>>>> vmlinux: https://storage.googleapis.com/syzbot-assets/6991f1313243/vmlinux-9b62e02e.xz
>>>>> kernel image: https://storage.googleapis.com/syzbot-assets/65f88b96d046/bzImage-9b62e02e.xz
>>>>>
>>>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>>>> Reported-by: syzbot+7f3bbe59e8dd2328a990@syzkaller.appspotmail.com
>>>>
>>>> #syz unset kvm
>>>
>>> The following labels did not exist: kvm
>>
>> Hrm, looks like there's no unset for a single subsytem, so:
>>
>> #syz set subsystems: net,virt
> 
> Must be this patchset:
> 
> https://lore.kernel.org/all/20240316004707.45557-1-michael.christie@oracle.com/
> 
> but I don't see anything obvious there to trigger it, and it's not
> reproducible yet...
> 

Sorry, I missed the original post from May.

I'm trying to replicate it now, but am not seeing it.

The only time I've seen something similar is when the flush is actually waiting
for a work item to complete, but I don't think the sysbot tests that for vsock.
So, I think I'm hitting a race that I'm just not seeing yet. I'm just getting
back from vacation, and will do some more testing/review this week.






