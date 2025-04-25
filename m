Return-Path: <kvm+bounces-44287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BEF3A9C4E0
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 12:12:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7578C1BC20A0
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 10:12:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9C1223BD1F;
	Fri, 25 Apr 2025 10:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aglAW4z1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2078.outbound.protection.outlook.com [40.107.100.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E91B23D2A2
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 10:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745575923; cv=fail; b=YV/xYZ2kIVBH/GEtAfPB17ktunwzRbLVKLFViKdIAnk5Dyffw2YBU0hnPqLBHUYsMf82okOcF3ilz79iFpg3Q2iW/BENpgAq0BB2PGJrUtwOv2SjJgdpO8hA8nB++qxqy4sOUcMUQvxVBbzwVFZbqvN0j3WXXVAiDWTy96sk1Jo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745575923; c=relaxed/simple;
	bh=I+HfqPtRznvPcmfUAF+FrWwd9eTX+t4UftJ8Z2N+Tyc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hRlgqE1MH9vq93wmKBGT8k4dJ9j5uNUvuxunJN4lUU4dkn7cugRk65iwqSjZbOsJ/hN3RlXAC6KvMJL92T5bPCBJ8H8xbV/3XTUqRzLBKoasCzXu/1S3A2XF99wXOn2I94YrSkRL6kWl9sLoFLJExOU4JhiW1gGiaahkvccxGmo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=aglAW4z1; arc=fail smtp.client-ip=40.107.100.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yu89biubvqWFBb+DFlM13nIq7+/RzAFf50RCOz/akQcTE7+mEC9aOlZYTFPTrkkws7QLRdSTyvOWzOoMMwR7gK2eewNizRqjIcyVUZgLuUNYJwiLbYcW/wl9n3dwk5Fx2RqRbO8mWrQ0gbAmDco3I2KZEraB6z9YokdyjjtW89H2MNSZJraNT9Kb04Xk5lBjz2DrpLSrgINe+ZsJskvfc7aj4SVeni4Mgl6VxRJwIAza/mbNLrQA8koo3l61quzPSFwag7ddzsv3n9Dc3PVSMYnakw9ImneNZohXlujGJo50JUsmv+4VR7fruBSjfmcLGTvSEtSVghjRNeov0e6QnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8JZzkTTnUL+5Gml7zyoVZ5ze+OGRpqRc9p5c+E69QO0=;
 b=XDmmI7ci85wIviouLtHEhnRxhxB5b1sKFfaieHByMbTBoMmiCMjJH1IsLZhzCzOAhDApDdqzZQ+C1VitMmjRVwOgb8vZth+0QKoKDUN+jz/KzGjXOIwj/6/IcFqPU+ZxJBFgYJGKUrD83P8afumM7DMtLVFgNMgAfWv2ieFdq+kyqO8lqrSw/aaIUfFVThNZolikJb1gVn1ZK9iLUBXA3s6EUAin7g2OQhe9mFTErdqDjgBPebnD72wF8VSOjBZvXsZsSdpX7sa7FolVsxpQKKA+4AaY3uQIytLxR8pqnJUFiCxlw8ueBhoCxm59UjyxDjSTcHg8uvA3vFEkQeZqzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8JZzkTTnUL+5Gml7zyoVZ5ze+OGRpqRc9p5c+E69QO0=;
 b=aglAW4z13SVz6N2jttrCx21LgjAaTy5kIJwfSHaXLZBSCoipjNaszjNqM+Y+4nWupe2NMVd4Rdm7VpvpCuUcuobmmpY0mXz1W8GRNIwr8ZfS85BcixTUhtCwc9LezfGtcHWAXD3xy/7W9ve3chznji/VqoVa+bFko9Jlgnpsus4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by IA1PR12MB8520.namprd12.prod.outlook.com (2603:10b6:208:44d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.27; Fri, 25 Apr
 2025 10:11:58 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291%6]) with mapi id 15.20.8678.025; Fri, 25 Apr 2025
 10:11:58 +0000
Message-ID: <0fd10a67-2f62-4665-b744-ddc385c100ea@amd.com>
Date: Fri, 25 Apr 2025 15:41:38 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/11] target/i386: disable PERFCORE when "-pmu" is
 configured
To: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, qemu-arm@nongnu.org, qemu-ppc@nongnu.org,
 qemu-riscv@nongnu.org, qemu-s390x@nongnu.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
 babu.moger@amd.com, likexu@tencent.com, like.xu.linux@gmail.com,
 groug@kaod.org, khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
 den@virtuozzo.com, davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
 dapeng1.mi@linux.intel.com, joe.jin@oracle.com, peter.maydell@linaro.org,
 gaosong@loongson.cn, chenhuacai@kernel.org, philmd@linaro.org,
 aurelien@aurel32.net, jiaxun.yang@flygoat.com, arikalo@gmail.com,
 npiggin@gmail.com, danielhb413@gmail.com, palmer@dabbelt.com,
 alistair.francis@wdc.com, liwei1518@gmail.com, zhiwei_liu@linux.alibaba.com,
 pasic@linux.ibm.com, borntraeger@linux.ibm.com,
 richard.henderson@linaro.org, david@redhat.com, iii@linux.ibm.com,
 thuth@redhat.com, flavra@baylibre.com, ewanhai-oc@zhaoxin.com,
 ewanhai@zhaoxin.com, cobechen@zhaoxin.com, louisqi@zhaoxin.com,
 liamni@zhaoxin.com, frankzhu@zhaoxin.com, silviazhao@zhaoxin.com,
 kraxel@redhat.com, berrange@redhat.com
References: <20250416215306.32426-1-dongli.zhang@oracle.com>
 <20250416215306.32426-4-dongli.zhang@oracle.com>
Content-Language: en-US
From: Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <20250416215306.32426-4-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0164.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:de::6) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5712:EE_|IA1PR12MB8520:EE_
X-MS-Office365-Filtering-Correlation-Id: 1276b4ef-9f1f-49fc-1ad3-08dd83e19cc7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SkR0UGFjamxSTE5tTCtraTZoY2pPSmczbFNHQTUxRm5xdTNadThFMW4wVEFo?=
 =?utf-8?B?MVo2UXRKekpvdm5JT2lxekNDK05mOC9Lb0k3TkxpdXNzbjNKOGV1QXozSDkz?=
 =?utf-8?B?RlFsRjdHYzg2aFJ2L2daNjlmcHc0VTRWVFo2ZGQ1RWJSMEFxUzBPdkJYRnJP?=
 =?utf-8?B?QWxlME9iWUlWWGszUlFsZk5UTjNOYnV3SkdQeWVBaFh0eHVQT3k3em9LT1JH?=
 =?utf-8?B?QUVJbHZIRkhJdTRFNVozclYyMWFKVHpvSFpXY08vREhwSkkycmxQUzgrbVFl?=
 =?utf-8?B?VEdGbnJPNXBpaVhTRnJIV2ovTTRiWlZNZTNTbXMvSWd0WlNkYnA1Mk05ajVo?=
 =?utf-8?B?Rk43M0tCRnh1TmJISWlKYkFoa21JbkNBTms5TUszZVp3VnVLNkFxRXhYaVA5?=
 =?utf-8?B?SmhUNHlUMmRaL3NsOWZPNXpHQTRqVnRkTDgyUDVMZjZDUVFvTjVobFhBVzZm?=
 =?utf-8?B?ejl6emNTd0ZuMHB4eXg5RUtZcWFKbXF0VmdJWkhSZzhwU3lxZlozNmxrQTZp?=
 =?utf-8?B?S1JxMkk0UEtWNUhKN050WHJWWktXVWZNbU1PY0N5QWNtd1BFVk1jZmcwWlhi?=
 =?utf-8?B?NyticTRGdDZmdDkzcU1xeldIVlBEemNRYkNhWlJoOGRNbWxCTGlsTFU4bDYx?=
 =?utf-8?B?M042c21vdFJKRHlJbE1XMlJHWml1TDN4dThFOERDRVc1YzRtVFJiaHljc0hN?=
 =?utf-8?B?aWlsTGI3Sk1vczk1alZHZWVlTGlwWU85K0JlTVNrQzIwM3ViRjd2UXRMQmpw?=
 =?utf-8?B?RU5wNWZmdGh5WFVEUUNvR0lvVTd2K09oZVU3OWpQMmZ5VW1HN3RIUFRSa0pV?=
 =?utf-8?B?Y09xWVlYSi9FMkFDS1hVU0s3amhaTHlkNFNnbjc2VzQ0eHhTKzdqTjRybmFp?=
 =?utf-8?B?OEhINjJVM2ppMjhPa0x5UHNDNzFyUVBMajIvWjQ0SXMrVGpsbEFGWmxQZzJx?=
 =?utf-8?B?dHZuZHJJRlJjdm96dkxrREN3cjRPaExOSFNoc25IRXZvOER1YmFMVnZuQTNC?=
 =?utf-8?B?cy96WG9Hd2hnZEhnd1QyZkxTMDhGTHlLTk1BMWdQOTlCeXY1TjlnN0hUQXhP?=
 =?utf-8?B?RWlXQWZNbXNEQ0Q0d0t6a1ZsWmIxUzd5WTBJcFBhT2ZlQmI5cTQ1ZTFpaU9D?=
 =?utf-8?B?Z2ZpdmVUOVhlMldFa0JBeUlSS0taeVNKY3o1RC9RdFgvS2x2NnlmclpPTU9C?=
 =?utf-8?B?WXFhL2pWNGZnVXFiaWhHNmY0TVZ2bWlYdGQ0aXpGZmhGQU5XRGkvdzROZTJs?=
 =?utf-8?B?YURiMFloSnM0VmJSZElId3d3ZzVlWlpNT0xvNFFjSFVIenNweVlDQ0pzbGZu?=
 =?utf-8?B?QWtBZllodnBlcldCT1M1bVp6QzNwK2s5RE5NV2ZnWmtoR283dVBVdG1mZndv?=
 =?utf-8?B?bUVERklOamRyeGNpZHRXTFAvaTlNRnlrK3BTQk53N2pjT2I1L0lKdStrNTRv?=
 =?utf-8?B?ZlVkdEc0RmhBREZGM2ljRVBZNWtnMWNDT2FxMksrYzk2bDVhNzNmNEV5QWFr?=
 =?utf-8?B?cHZVZU9mS3p3dzFZK0Iyblk5RXN3L09GSlo2UHdQVVhvUlJDRjhuRm5QSG1Y?=
 =?utf-8?B?RGlLVElxTWM2R3lVbWh5MlUvK0c1cjFubkQ3cGkrSlJUZ1QxdWYwamVLOVEz?=
 =?utf-8?B?bXNSaFdaaUwwZzFJUDgrMWhKaTBTaVlialFNZVdxSnVNcFFJdnJ5QlBqQ2I4?=
 =?utf-8?B?aEJQTEE0OXBrNU1JUzJNOWtCRnVzdk5Cdm5Vb1ZBclV1OEpvcjNZWTQzM25y?=
 =?utf-8?B?QWE5b21GUzFGTUh0RGIyOFlETHpHblRXWTA5RXdlTy9mc0o4UnAwY1B5T1BM?=
 =?utf-8?B?aW4yN25ISDI4VUJ6eTJSMzU0NUh3cEhoNy8yaEkyS3BYRHVycW1IU0hGcERK?=
 =?utf-8?B?MjNGSXp5NW12VXFVWUEwTE1CYVo4RzE3eklFdFhZbEpOa3ltVXNSeW1VeFQ3?=
 =?utf-8?Q?cTVrX5oLQyg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ako0bWY1UGR4cmtVRjIxdFVBUE1iaXFSTnpBeVlTTEJXUStxdmM3QXRSVmo0?=
 =?utf-8?B?bW9GWmwyQ3ZpZkpTQW9wblBKMTlhZ2FIV09nZWlKcVJHSXd3VElKYk4yeHV5?=
 =?utf-8?B?cWpHTytyUFk3N0FsckZ6MUswdTNRN0tET3hlTllHV3NsL0Y3dDZVV1IyZ3VB?=
 =?utf-8?B?YVdJR2RlMlNvSFlJVytjbUZTdW1DcHFxZGxZckhURnp2RUlyMmR4aVdFSUZ1?=
 =?utf-8?B?M1dxWVY0QjlFVHZ3QUIxZjAwNjJYM3F3ZHhKU3Y2cVlmYjN0OFNpZEgyc1g3?=
 =?utf-8?B?anVSWEh4VDhSdm5GZGN5emh0bHpmT1hzb0RzNDhWQ01hWTc3K1FGV1kyVitI?=
 =?utf-8?B?MkxFSGo5WTBRcnlzRWdad3ZnR3cwS29Zck1LWUo1amtJR09XbFA3VDVUcG1k?=
 =?utf-8?B?OS9LNHppWWlVZzJXV08xcVhmcjF1eDlxYkt0SDBZSjl6VjFsYndMKzg4NkRi?=
 =?utf-8?B?akxKaERhUXVucXVYbTF4eVN4dStGbWNYSVlFVE1qbFpNQjQ3bVpxanVYTHdq?=
 =?utf-8?B?anJiTUhVSkZPTWUvNXBqdEdTblU3ZFRzYjE5bWhsSlRSN2dxeXV4dGh1dW9L?=
 =?utf-8?B?bzVjNFVjNnlIb0FrdEJPZEFHdU1nSEViWFBaSXowQUF1dmxrK0JIbHdtMFI3?=
 =?utf-8?B?QzRyU1Zxai9xb2lQS3lvM1NwK2tBOTkrM1MxTTlyQTFLMStwcFVXVmZlR0l4?=
 =?utf-8?B?dVNsTVRQbjRyTTAyZ1NBZEM0ekhpUzhmTTBobkJoOU5SYlNGOStBS0l3Z2pJ?=
 =?utf-8?B?amZDVWpRU01kWUYwa0p6dlpIT3FySjNORkhGdnBiZ3RqcWVOQWx6WC9MeVYx?=
 =?utf-8?B?eWVaU3ozSW81Zjdzd1FRMGplQUNtUTc3UnAvRVdRbVhhZVBkbzVEOXpRUExN?=
 =?utf-8?B?YU52ems0SytwVWRUYjF1aW8zZkFOYkcydHY1L25aWml1Y2tLcTFVbFh6dDc0?=
 =?utf-8?B?bzRiTE9rUWJXYWZRbDJKZW1CYU95bDFMWE01TlozRXFGQ1RUbzRRb0JPcmRa?=
 =?utf-8?B?aGJ1Y2dEM2dZN3prNHNCaEd3bjdnbjJ1Q0lPYVVoUFMzcnhwM1NDdk5DcVdC?=
 =?utf-8?B?LzY3d2VFSXZ4Y2lVYmppUXVvazNvVzdEYW44WkZadFI5blFMclVWUEg3TnhL?=
 =?utf-8?B?MzdZQkdsTzVPSnR0Q3NHQjF1aHIrWWhCM2JvaFBtbmw3blEyWXJ6WFFpVmFO?=
 =?utf-8?B?R0s3QzBYem93c04xamxyME0vRnlWbGkrdnJabmtrSnkra2gwU24zR2dEeHZE?=
 =?utf-8?B?U090R2doRlc0SnNCbE9TTGRaRkRKdm9JbFJwMW9JTGdJWUpOdk1LbWM4cU1D?=
 =?utf-8?B?ZVVQZmVYRlllNzNjL2E4WHVHNnQwL2FNWnZkMm9JN2lyZWx0aWVBNmY2R2t4?=
 =?utf-8?B?TTJqa1VUeXNQTFVoeldsWFQwRUg5aXVqcCtzd2tRK0VRWXlnNkg0WUZZRkwx?=
 =?utf-8?B?NVZNYUFtdkVKUXFqRzBxMHNrUndnejgwdWtGcnpMcVZkWUU3QkdYZ2M2cmJO?=
 =?utf-8?B?WExRWFl5TUFkbEZJSTlaZExRT3BZemRhakt3NVltQ3ZmYk45dW02U04yMTZ0?=
 =?utf-8?B?QjkwWlh5ck9uVCtvQTdpYThpeHMvd0RoSVhVRVZVRFNRRUdxREVjVjBUdDVJ?=
 =?utf-8?B?UlV6bWFBUjNKWVlHZjRBQ1JjckMvT3NhV2M4cy91MDF6OWNtNkJuN0YxM1U4?=
 =?utf-8?B?N0Q4NkdZb2VXalcvb3p4RStPMHpxcnVTaUhZWkpkVS9oYXRVQ3oyQ0NTaVJV?=
 =?utf-8?B?a1JwUzBOYU9mNjQxRDZrMVA1TWFoSTJlUUM1OGkxMU1mMC9odnhhMnhGdXBn?=
 =?utf-8?B?SmlHc3ZvVVpCTXgzVVMvY3BCS0dYTjFJbXBxakROa3F5Rm83czBkWXdHSnBx?=
 =?utf-8?B?MTN2dFllcFhTb3l4WDdoRk45ckNFbUVUendyQnMzNkhPSittWVZnVStPOGUw?=
 =?utf-8?B?THpwYzNEeEFrSnFHQm5CaWNrSW1sMFFxc1BFSnVKWlhKcW1EclhkWVR2d1gv?=
 =?utf-8?B?ME40eHlEcEJxYjA4WHR5b0M0bmVScjdjYTJiY2hmemwrOUVvRExJREF3MEtS?=
 =?utf-8?B?R1dKNGR5RVBjR2hoeHladnZ4eTRibk5admRvaGkxZXBDVmlDbmU2UnVmV0Jk?=
 =?utf-8?Q?B/M87IHVUa833MD8ryFXDTgFD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1276b4ef-9f1f-49fc-1ad3-08dd83e19cc7
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2025 10:11:58.0273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zSNT7nvQs5QZaK3I9ikQwSjSn5S5r5tA+R9HvNDbMb1jkLD3vNhp3z+HqsWuwnJnd7Fcy/HIEOwKHeJADhuCjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8520

On 4/17/2025 3:22 AM, Dongli Zhang wrote:
> Currently, AMD PMU support isn't determined based on CPUID, that is, the
> "-pmu" option does not fully disable KVM AMD PMU virtualization.
> 
> To minimize AMD PMU features, remove PERFCORE when "-pmu" is configured.
> 
> To completely disable AMD PMU virtualization will be implemented via
> KVM_CAP_PMU_CAPABILITY in upcoming patches.
> 
> As a reminder, neither CPUID_EXT3_PERFCORE nor
> CPUID_8000_0022_EAX_PERFMON_V2 is removed from env->features[] when "-pmu"
> is configured. Developers should query whether they are supported via
> cpu_x86_cpuid() rather than relying on env->features[] in future patches.
> 
> Suggested-by: Zhao Liu <zhao1.liu@intel.com>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> ---
> Changed since v2:
>   - No need to check "kvm_enabled() && IS_AMD_CPU(env)".
> 
>  target/i386/cpu.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 

Reviewed-by: Sandipan Das <sandipan.das@amd.com>

