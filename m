Return-Path: <kvm+bounces-65578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CDE4CB0C47
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 18:46:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C282730ED372
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 17:45:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D2B632A3FD;
	Tue,  9 Dec 2025 17:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="N3OnVgE6"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012035.outbound.protection.outlook.com [40.93.195.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649A822756A
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 17:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765302331; cv=fail; b=KynLhHkkw3YnJJMaoKoziqExBblvcVR1Vk1KvWN3FCu5UJK2jFxNgwfrYVKYIn2C9LRW0rpcjKnQUbodpqkoiuqnDtFlSijke69S/eoktN8FjAF9WYnk9mwa1K1WCF36e6dAkMFL+79bkfD3wXLtYmT0GGms9fCtPzJqgTHrU+s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765302331; c=relaxed/simple;
	bh=UaU3rasIvLH0B+59u23Ffs6uKibiF8XgE7UKfEIHJRA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JYT0k3egbQH3k/P5xuW1pF07+Mp5djfje/5jmWM+1ERNY1cWOoGZaockKSRm9edniTFPLLIeXP1L0VFIFOGnSomNU2Rk+TTMufVaQgl93+YuCIUFQFcA3hH3+elG+N36lOx4bMtkj2Gkfmtat9lllmyVg0MNprz1I6aeukvAoro=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=N3OnVgE6; arc=fail smtp.client-ip=40.93.195.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JzGoyiCsS4XpkdJsUHPsoGgI3WL9noG2DeeZtTg6V8JOsACPk0UEFygVQoaZJevcTGWou4GR9taF6GtCH9orbtDbM3GwyOrU8d9O0cd6piTm/f88p2xZOyHuIKtlbH0jCmMl/MJAF1ZnawWHoS43dYAwEIJ6lbMEHcRzTfd8+vYVD6OJm7482PUgsJ6kKKuiZye73AzRCtSgFqn1/B6Hxr7bOXoejE9JU7TjTJupRIl81jZiuvyNq2MBcCvuP+C0zIRPoa1tDvNYgnPR78qTPQ5VZxykjT6fuPSWlk6Yl9FsWkkOJR2ci2SrGsbcXVeNsMCafpvnuZqw6y+cmyzBiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fWGmFo4dBb/w7DY1QcqUU0XKiyeFdswojZkReWopCUY=;
 b=ge5QikKwYfoQlCA5uxBkEYhSWdLAniywjcZW65vS19OFVk1iu0BGsDX3Hf0lqcWkbbFtrMJxcOTM2mRXHGUsmemWjCzks6hAo8s0NNSj+lRuiBKY6/WXgi3U/mfXn4tpCJOpaCPM7mTYYXB3ON/R2LNWWg+PNmMoijjQCC+FcXaMzV2c5pBa+RuhyimoWNOCONJmghFodE65lNQ66xlQ7dRf6+GmdKQJkAybmAmXdt2MwzdXflbIT2Eq4+HyAQqwVaeuhHisk56rPWwWKWF3xFdRWEMNQbTMMtpivHWpAm+p9CCHYl3R8UCfGyULh9jbdXm+0gvwNSNFl2TPldrYyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fWGmFo4dBb/w7DY1QcqUU0XKiyeFdswojZkReWopCUY=;
 b=N3OnVgE6LULbt68MML7jvNK/lNYJFa/QEPLPYa/TQf6/166Qqnq8Pxo6NH2oMccSOPTQKBecerYaKq+uHBLBC8NQtBZyNvHS53XwzXCQlGy7stX/QrFtkrwq8Ee5knxTHF95+UjmSqNC2VZcR+WcxuLwZ69FOgyihVVAIw942swc5PC4bgf68wY9Ilee3glGR5Z562wP30KoVQIMU5KqSCgkG91BZCdTocpSV6F6375ZrrgbkvA0X89X68lMg4R7T2pgmDaPR99lbz0nZ/ETBQiIlF8175okygZloOae/BKvj9JzhsuYPbx84EqtkGGA78REJf03nXxh3ZzOD8JXcw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6369.namprd12.prod.outlook.com (2603:10b6:930:21::10)
 by DS0PR12MB7777.namprd12.prod.outlook.com (2603:10b6:8:153::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.6; Tue, 9 Dec
 2025 17:45:25 +0000
Received: from CY5PR12MB6369.namprd12.prod.outlook.com
 ([fe80::d4c1:1fcc:3bff:eea6]) by CY5PR12MB6369.namprd12.prod.outlook.com
 ([fe80::d4c1:1fcc:3bff:eea6%4]) with mapi id 15.20.9412.005; Tue, 9 Dec 2025
 17:45:25 +0000
Message-ID: <49a3aabb-eb28-4149-b845-1bc5afffb985@nvidia.com>
Date: Tue, 9 Dec 2025 19:45:19 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] virtio: add driver_override support
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: stefanha@redhat.com, sgarzare@redhat.com,
 virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
 oren@nvidia.com, aevdaev@nvidia.com, aaptel@nvidia.com
References: <20251208220908.9250-1-mgurtovoy@nvidia.com>
 <20251209113306-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <20251209113306-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0005.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::15) To CY5PR12MB6369.namprd12.prod.outlook.com
 (2603:10b6:930:21::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6369:EE_|DS0PR12MB7777:EE_
X-MS-Office365-Filtering-Correlation-Id: d8d40586-e6d1-41d0-cea3-08de374abb88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aWlra0xkYTlEVm9tNEcyTEk5N0J3MGRVS2YyV0ZpelZlMmIwZlZTTEZ0STlL?=
 =?utf-8?B?ekhSdjdGcUdWRlhsNU9yRmpLU3ZWQkd2bkpDNG5QQzVuczNXc1ZDUUpJajE2?=
 =?utf-8?B?ZmRGdXFhTHFscm1Ed2ZGa3lxNzVLSkZUZk5ndjU0OG4zY1ZKeDA0V0tWS0sw?=
 =?utf-8?B?Q2t5Z3hBbGxQanowZVFqUC9kcXNxdUtYZUNwVTJHNGorUE1IQ0FVU3lCMGRs?=
 =?utf-8?B?UElKM1N4UHdEY2tvZ3NQeEtsODM2TjF3Z3lrUkk2eVpLRUl3VWRiNDlaOWdH?=
 =?utf-8?B?YlVmbkJteWZDOVJaRjZvUysvRFV3OEtkZEFVR1owQ2ZsOHF6cC95N3Z2RmE3?=
 =?utf-8?B?ckNjS1g3eGlHOThGUUpTazNXeXJ4Tno4YVpEbVRDUTBIajkzcGVNbjBtVUtD?=
 =?utf-8?B?a1J4Wm1PUzZsMlhkZmVkV0U0VGpNK1VFK2dhYVZQTlpSd2hmbFRhNXk0WTMy?=
 =?utf-8?B?dFl3WUpJVy9KbkdwWkQ5L0JBbFJBUVhRaXRJRVpnRWE5S09sWXMwN0M3MjJC?=
 =?utf-8?B?YlFQOEF5NEIrS1pTRlplVlh5enhPU3BLeVNXZFRVTGhPdVJuc2NWSk8vY2ZQ?=
 =?utf-8?B?aGZxMjB1UEt4SVgxUnY2UFE5RjlvSzVJc21XU1h6MGNJT01Hb0tKeWt4L1E2?=
 =?utf-8?B?YWQ3Skk1ZEhqRVNLODlsa2pEdm5Ndm9XK2VqKzhoM0tXM1JqSDJFNFV3amto?=
 =?utf-8?B?MGVkUXR6a3RFaWRDUkJIVDM3dkd3Q1dSclFVUlpKWDloT216bUE5Q2dCNHpw?=
 =?utf-8?B?UUVsQzVyd2V5UFQ0SlBRRjdTRW5NMEJjSmhZWjhZRlBpNnY4b2dxWXB2V095?=
 =?utf-8?B?ZVhweGJaQzNlczBpbG8xUkVRK21KclRLemxmQXY5UWpHcTkzNHpTSVFWN2dX?=
 =?utf-8?B?eFZHVWJwQ3ZOTUcyaVo1YWdPc24yTFVoN3IvYS9jZXJ0eXk2SFNPd2Z5Tzkz?=
 =?utf-8?B?eWZEZFEwdkJ4SWZ4Nk5UNk0wYzdsVmswWGhRL09ORzNCVlpQRk94YUdrVnEy?=
 =?utf-8?B?aGNZdXg4LzJaY05SZVIrcFJ4aFRzaDh5Y1U3aG5WT1VZNEcwOEk3TmdibURJ?=
 =?utf-8?B?bktJVXllTFVtMFJNRk9oZ2x1VzFqamxzb0dLd1c0c2N6a0ZsMlkzNzh1YWd3?=
 =?utf-8?B?dXp3Vm9iaWZhNE94N3BqdGp4dVFhWFU0MFBqUDlwQmFqTGpwSm9XZjlwbEsr?=
 =?utf-8?B?akFrdTJ3c2p2UXZnZnd0NXYwbWs4TDU5RHhLY0Q2SlAydnJaREU4UGFvK2tZ?=
 =?utf-8?B?TG0vcjZldHRKdDIxajFyNnhCTXY3ZmNvaTZ6VTdMek1BRlBVNThVQlpaZzRj?=
 =?utf-8?B?d0dyTnQ2SU1TUnFvbTludERDL0ViNDRFaktBNXl1QndRSFc4cFVCWFBhQVJV?=
 =?utf-8?B?N1lPZVZaaStlVTMwZHZ1T2o1UHJ4YjBiV1U1ZEFQZlA1VUlERTNRRDdBVEU1?=
 =?utf-8?B?ZUJLeHVqZ0Q1NW5FVkdKakpTa3dKWEhKeGh1U1dtTmYvck9EQStuWmk3SzBL?=
 =?utf-8?B?ampENXh1am9MSkk2K2VOTkswcUllVkM3ejVtVWxMdGNOZmNhRGYzUG5WQ1ha?=
 =?utf-8?B?ZlRTT1VDcDZJU0UwTERuaWRKeU1MTW0rSkFwNElQZ2pDMmpxRXNyK3lCRnhP?=
 =?utf-8?B?U1g1dUFnbmtpbm9wNHhFTjdrcTJwV29KVWtLZnJpNDc2Ung4bGZIQTl6Mnp2?=
 =?utf-8?B?TmtCQnB6c1E0WlN2NGtpZkJ3VUxna1lza3hiK01HNHdyTk5uNFdxaXlERVI4?=
 =?utf-8?B?dG1Pa1BBQnpvdHRSOUxweTV0RDIrY2w3eXZlTGtLdmp4WTVkMDdXUm9CVW1R?=
 =?utf-8?B?NDV2U1ZnY2NMUzJpNWZhWjJFVXJtTnlvNm5KY2F5ekpob09lSTl0OFBZZEcv?=
 =?utf-8?B?U0puRlgrYnF5SCtiQjJRWTg4UTZsMkc0WW9wWWp4NFlsNkc1VlQ5aVhBU295?=
 =?utf-8?Q?UOMj7cfgvItuM4nlreoCtKAYHWXjU1ws?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6369.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WWpSU0QzQnV5eFhVZHJCdUQ4SkhDcXptVHd1clNMNC90OGhFamw1OFlOTnU2?=
 =?utf-8?B?L0ZkTnoxTlU5QnNwUkszYUd4WFQwam1uYnZiOTRBajR6ckZ1SUZ1eG1PVnFq?=
 =?utf-8?B?clZLcGNpTko1aG52Qko1QzZOVnhEOCtsd1dtb2Z5VEduNmV0RE1YN3ZDTFhy?=
 =?utf-8?B?KzRTemtPZEtJK3hsdEhybzR4d2JtOVpGaHhFdi9jalFEN2dBUzdSeVRvQmFT?=
 =?utf-8?B?dG5mNW1GaFpZT2xNay9Tai8zRW5TMHI3U09SUzd6aGdFQ1l0RTRNYWM2QTJp?=
 =?utf-8?B?SUh0a2VvLzNEeS82aXFYRGQ1eGNlQXJseGtCb2hNYjk2dUpod01lU0hxRnFl?=
 =?utf-8?B?OHM5WkJQYTRQWUoxUEluY2RZd2lhem9GcFpGY2pabTRobURMRnhXMWVJR1lq?=
 =?utf-8?B?V05FWm1qY29KU0ZuZ1FkeEx0Sk52S1RoVmJWY0RXUm4zbWJhY24wYUpOUlp1?=
 =?utf-8?B?V3ZXQ29wVVBvQ1ZLaHFJWUFRZmVsR01vWUtlSXpQMUQydFdHRVB5bVpsYWZV?=
 =?utf-8?B?L2pQcXQ0V1lDNVFPWWpuUVJFWXlSeWIzekZOc3Z1bHlwMEpqVXQxd0I0eHBI?=
 =?utf-8?B?R3Y3enJWdU1FMU9lLzBBN1VidStmK0dJeEttZnF5QXFBNUw4TlYvLy9zL2JH?=
 =?utf-8?B?VThoL3drNnhsYndpTC9hV0F3ZDdMQVZBMkFHZDNqZFU3RkRpYXN1VUpSdW43?=
 =?utf-8?B?ZWxISVVlZHByRnBXdGpMNTNWMjNMNnpNeVd5Mll3UGF5cDV5a0Y2OVhncjE2?=
 =?utf-8?B?V05DZGp3eTIvbGhMd0UzTEN2bW4rdmpZTXFWQkpjRkREM0hrM0lld2pueTQy?=
 =?utf-8?B?STBUOW9jaWhvTUhFTlZRUmt2SXpJajl0ZkFKeGtiSTBzSU9VcHYzRjdSSTJu?=
 =?utf-8?B?Q3A5THVtUmZ5V0lRWDg1bER6cUZneE5KUmR5NUEwL1VKT3VMYjJIUVF3TGVn?=
 =?utf-8?B?MUY5dEtKUlZRK3ViaC81UERhOFJ5aGV0cEZyQkJjMkxXT1A3c1czbElCR2xp?=
 =?utf-8?B?UURucVpjVVVUUCt1ODRRQkJxdm1jaHB2SmtwamEvWndUYllDemJiOHlESmN3?=
 =?utf-8?B?WXlibFh5SW5DYmJxRm5OYnNSbEJPZTl5U3VHbk9yclI3emRCUmNtSUI0U29T?=
 =?utf-8?B?Rzl1THF2cmx4NjU0SjZrNW5ZRjlYbEhGZ0tDZUo2UXRMRnlKZzNPS3dyMFNO?=
 =?utf-8?B?Q3l4MlJ3MjVENFFCWnAyVDIxcmdLaSthUjdYLzd1Y0NyQW9sVGVsZFF6U3lh?=
 =?utf-8?B?Z1A5d3hzbWFiWUxiTWQ4bUhXbllseDdRT0J0MDhkNnNjVnVXbXM1TVVqSFEx?=
 =?utf-8?B?RjMyUmFRTm12dzRJNDcvT1QrZTlZUEdvMTlqdW5ZK2lPb1J1dGxkL1BOQUpV?=
 =?utf-8?B?eW9DN3BWQW5vazNqajBkU1FoRmU5bmFhaW1lNG54VDMrNXpWak1qc24vVmpP?=
 =?utf-8?B?alV6ZENJcHVpNGowcUVaNnFxRUhWV2wyWTJMNVB2TVl2cjZtN0NvWVMzbWRw?=
 =?utf-8?B?TUVqVUtVQVdPNHIray9HcE9KbFhNb0VjTjBpZ25nQzJlQkloT0FyNXVoNmMy?=
 =?utf-8?B?Z1BpcWRxcEthY3ZLeUxBZWNxcWxhZ0xrUHFVNXN0WGN0L2tkQmVKV1ovelo5?=
 =?utf-8?B?WmZKOXU5MDFqMS82NXdicHZXRjZvMkhNc1NMYlpWQ09HUUJkUjg2YnpQSjRH?=
 =?utf-8?B?K1RMbCtVZDhMdUw1Rkp1Y3VJUmRBOVFyT3NZL1pNcWYyTVBhQ01WSDlkdU1q?=
 =?utf-8?B?WEw3STlyVEp0L1FBVlhheGVqdlEyMkJ6a2FITkduM2lLUnBnMGkrRGVWTHZB?=
 =?utf-8?B?b3dkYTI3WkQ0L2ZOalJ1aE10eWdTWU1QR1k5U1JpeFd3WnlQd3NxNXlQUVB0?=
 =?utf-8?B?WTZ5RzJFUkZxNlBGTXJRLzNNUVZ3KzlCWkw2MGxBM3RVdnd2VUhUa0VGMjZw?=
 =?utf-8?B?eGNLazNIS1kyTUp2OXptTjdRRitUTHFmd3FMNEJGd3pNOTZBWmFsdGZJOVBG?=
 =?utf-8?B?ZUdXcGptMnZuSVNTSVIwalYrc2dPbmdqcWdzd2tjVjRQRGpzWXQ2cjJOSEJ1?=
 =?utf-8?B?T0FrTjJuZzM4d0ZFQkJXeWExbDllYVE3blVteHNCNERHUC9oSGRhWUdudHMy?=
 =?utf-8?Q?Y7UudO8k2DGaXD+fiBpOWryHE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8d40586-e6d1-41d0-cea3-08de374abb88
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6369.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 17:45:24.9849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F4V7a1/OddDdmywrTkZWm2u8hvsJE2+s/SnaimTSlwFWfZlbKhqWdyFqxCktyGznUvgj5lCueG8MaIhal6Rldg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7777


On 09/12/2025 18:34, Michael S. Tsirkin wrote:
> On Tue, Dec 09, 2025 at 12:09:08AM +0200, Max Gurtovoy wrote:
>> Add support for the 'driver_override' attribute to Virtio devices. This
>> allows users to control which Virtio bus driver binds to a given Virtio
>> device.
>>
>> If 'driver_override' is not set, the existing behavior is preserved and
>> devices will continue to auto-bind to the first matching Virtio bus
>> driver.
> oh, it's a device driver not the bus driver, actually.

Yes. I'll fix the commit message.


>
>> Tested with virtio blk device (virtio core and pci drivers are loaded):
>>
>>    $ modprobe my_virtio_blk
>>
>>    # automatically unbind from virtio_blk driver and override + bind to
>>    # my_virtio_blk driver.
>>    $ driverctl -v -b virtio set-override virtio0 my_virtio_blk
>>
>> In addition, driverctl saves the configuration persistently under
>> /etc/driverctl.d/.
> what is this "mydriver" though? what are valid examples that
> we want to support?

This is an example for a custom virtio block driver.

It can be any custom virtio-XX driver (XX=FS/NET/..).

>> Signed-off-by: Avraham Evdaev <aevdaev@nvidia.com>
>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>> ---
>>
>> changes from v1:
>>   - use !strcmp() to compare strings (MST)
>>   - extend commit msg with example (MST)
>>
>> ---
>>   drivers/virtio/virtio.c | 34 ++++++++++++++++++++++++++++++++++
>>   include/linux/virtio.h  |  4 ++++
>>   2 files changed, 38 insertions(+)
>>
>> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
>> index a09eb4d62f82..993dc928be49 100644
>> --- a/drivers/virtio/virtio.c
>> +++ b/drivers/virtio/virtio.c
>> @@ -61,12 +61,41 @@ static ssize_t features_show(struct device *_d,
>>   }
>>   static DEVICE_ATTR_RO(features);
>>   
>> +static ssize_t driver_override_store(struct device *_d,
>> +				     struct device_attribute *attr,
>> +				     const char *buf, size_t count)
>> +{
>> +	struct virtio_device *dev = dev_to_virtio(_d);
>> +	int ret;
>> +
>> +	ret = driver_set_override(_d, &dev->driver_override, buf, count);
>> +	if (ret)
>> +		return ret;
>> +
>> +	return count;
>> +}
>> +
>> +static ssize_t driver_override_show(struct device *_d,
>> +				    struct device_attribute *attr, char *buf)
>> +{
>> +	struct virtio_device *dev = dev_to_virtio(_d);
>> +	ssize_t len;
>> +
>> +	device_lock(_d);
>> +	len = sysfs_emit(buf, "%s\n", dev->driver_override);
>> +	device_unlock(_d);
>> +
>> +	return len;
>> +}
>> +static DEVICE_ATTR_RW(driver_override);
>> +
>>   static struct attribute *virtio_dev_attrs[] = {
>>   	&dev_attr_device.attr,
>>   	&dev_attr_vendor.attr,
>>   	&dev_attr_status.attr,
>>   	&dev_attr_modalias.attr,
>>   	&dev_attr_features.attr,
>> +	&dev_attr_driver_override.attr,
>>   	NULL,
>>   };
>>   ATTRIBUTE_GROUPS(virtio_dev);
>> @@ -88,6 +117,10 @@ static int virtio_dev_match(struct device *_dv, const struct device_driver *_dr)
>>   	struct virtio_device *dev = dev_to_virtio(_dv);
>>   	const struct virtio_device_id *ids;
>>   
>> +	/* Check override first, and if set, only use the named driver */
>> +	if (dev->driver_override)
>> +		return !strcmp(dev->driver_override, _dr->name);
>> +
>>   	ids = drv_to_virtio(_dr)->id_table;
>>   	for (i = 0; ids[i].device; i++)
>>   		if (virtio_id_match(dev, &ids[i]))
>> @@ -582,6 +615,7 @@ void unregister_virtio_device(struct virtio_device *dev)
>>   {
>>   	int index = dev->index; /* save for after device release */
>>   
>> +	kfree(dev->driver_override);
>>   	device_unregister(&dev->dev);
>>   	virtio_debug_device_exit(dev);
>>   	ida_free(&virtio_index_ida, index);
>> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
>> index db31fc6f4f1f..418bb490bdc6 100644
>> --- a/include/linux/virtio.h
>> +++ b/include/linux/virtio.h
>> @@ -138,6 +138,9 @@ struct virtio_admin_cmd {
>>    * @config_lock: protects configuration change reporting
>>    * @vqs_list_lock: protects @vqs.
>>    * @dev: underlying device.
>> + * @driver_override: driver name to force a match; do not set directly,
>> + *                   because core frees it; use driver_set_override() to
>> + *                   set or clear it.
>>    * @id: the device type identification (used to match it with a driver).
>>    * @config: the configuration ops for this device.
>>    * @vringh_config: configuration ops for host vrings.
>> @@ -158,6 +161,7 @@ struct virtio_device {
>>   	spinlock_t config_lock;
>>   	spinlock_t vqs_list_lock;
>>   	struct device dev;
>> +	const char *driver_override;
>>   	struct virtio_device_id id;
>>   	const struct virtio_config_ops *config;
>>   	const struct vringh_config_ops *vringh_config;
>> -- 
>> 2.18.1

