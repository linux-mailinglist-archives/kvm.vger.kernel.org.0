Return-Path: <kvm+bounces-23171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B20D5946ABE
	for <lists+kvm@lfdr.de>; Sat,  3 Aug 2024 19:55:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3DCC41F213BC
	for <lists+kvm@lfdr.de>; Sat,  3 Aug 2024 17:55:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32D281B94F;
	Sat,  3 Aug 2024 17:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tFSiFehH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2049.outbound.protection.outlook.com [40.107.243.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76AC3182DB;
	Sat,  3 Aug 2024 17:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722707705; cv=fail; b=Jf9peNj7kI7upo/jt67nzVIlcw+KJGpiLPaN3aAvj8ctjkw1wubLOvlBhajNKYTKzk3kSI5STpLwn6g6oA3nloEd215LsRbuWD7wYNLlVuV7XP22vcomVTy66nRyNYQtM6zzkBnA57tLhG2TgdT4JSHIiWceCRPDamChiy4N9q4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722707705; c=relaxed/simple;
	bh=S19p6EP2rSV3HwJxoSall0DsP3lqBQi9l5ZBmUVk2PQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kz0LKWcW3oVAnwISTt/BuTxJOSPqEajH38LI+8WwgHJUxTrbmnTB3rIYPctp9DhzxyzcfXEuZeXyeDo8B8HGazwupqrzURJrBAS0Nr6PBMKudcKhIeD+l6yNM9Hkw3iC2DGwBYFCxbA+L3oXe+V4krd+ekDd4KhXcLGAd14a4YE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tFSiFehH; arc=fail smtp.client-ip=40.107.243.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ViMeejENfRZi9a9QjaT16UYJ0/6BHL5IB/Zt5uPYTyuRRDE3N0SIlKEuHkXRfZ3hxAAPiPJIfchhpWzYO2vE12y9As5LiUc6h6vgyvZFGr2U5/m3FDCUR9BhHMp2Nwxrp9iPFg/0qvc+xnDUi3nsmxqnke8CSe3UKfbUgbw9lY6ULci3zNsnEMOno5seMx1xPEMFTVfn1zISj2baUMQC0rHTbqVHFljH6Vp4dHz+wguQdZ2A2d2ERu6lbPmUoHiYqR0E3dRCm7Q8XXEqf5qxRVl2MjzWPaV2Rvzyg7M9lf8ItstLbpSuTigpNyzYbc+U0teAZ1qlGqVD6lz21pxSlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S19p6EP2rSV3HwJxoSall0DsP3lqBQi9l5ZBmUVk2PQ=;
 b=JqUb1UBaWDdXtd8V/6A0U3UxYx0OeZ44Metmbp6KClsKWxlQ4hRQPxrB4AJB0qhdKUsJDUzwc63zdpY+XCTvsYyrAqsWEI8pZXeSvaLWkA9HnfNNp6N4B7j63RsLPTsWf5oj64BQr46vC0oRVlt3i7A6BABQZRh86m9lvYis5+AslOEC1MSEm0RKgOZGjrqs43yZW2BWgeAUOdOx8ptqo79zIG3xqXuZLHx7La8etUszOdIWCc+q3OlNHKqGHk1YrEqjD5L80P/3Y2j9d0zZqBKSgof4GpFf0bXeXnDVMnoNvAPWH/2TK4t4iQbm6RBBficNWaMI5ujsbHxgqbJELA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S19p6EP2rSV3HwJxoSall0DsP3lqBQi9l5ZBmUVk2PQ=;
 b=tFSiFehHYk7y+7BRB4NXEyQafuxCw4mKQawMl6pBRKpL0SMGpv3XBpUXn+gekSr2EmMhz6rVXAJwb+Z9P1LR0idgDnbIzbtbvtWYlDB3cuRfXySHf/hzpcfkS2L7W3/mBOecW+w63wy+FsvxNbUrqMWmZOgpro5x8HPwme6BtvHcZ3rgTGnR9WxMNiY0OgJPuR855j/L4EeMHsgqHdsJpJlbfRZ3JuvYMUv1YsxduZV+cNysvHYoAfxsB9qgxMRv3d07Z1sTpLRpl3HP9FQWyPNgJLkqgTTnQ/as4oplYp3ERN9Wt11YK7/c2KcGF98FyIQbF0ImGPl0BWckpeckWQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6369.namprd12.prod.outlook.com (2603:10b6:930:21::10)
 by CY5PR12MB6574.namprd12.prod.outlook.com (2603:10b6:930:42::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.23; Sat, 3 Aug
 2024 17:54:59 +0000
Received: from CY5PR12MB6369.namprd12.prod.outlook.com
 ([fe80::d4c1:1fcc:3bff:eea6]) by CY5PR12MB6369.namprd12.prod.outlook.com
 ([fe80::d4c1:1fcc:3bff:eea6%4]) with mapi id 15.20.7828.024; Sat, 3 Aug 2024
 17:54:59 +0000
Message-ID: <7022d183-f98e-40b4-b3cb-00eb43c1ff06@nvidia.com>
Date: Sat, 3 Aug 2024 20:54:45 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] virtio_blk: implement init_hctx MQ operation
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, virtualization@lists.linux.dev,
 axboe@kernel.dk, kvm@vger.kernel.org, linux-block@vger.kernel.org,
 oren@nvidia.com
References: <20240801151137.14430-1-mgurtovoy@nvidia.com>
 <20240801111337-mutt-send-email-mst@kernel.org>
 <0888da3b-3283-405b-b1a8-a315e2623289@nvidia.com>
 <20240801112843-mutt-send-email-mst@kernel.org>
 <9400fb28-47c2-4629-af17-df2a95f2d3d8@nvidia.com>
 <20240801114205-mutt-send-email-mst@kernel.org>
 <6a8f0c72-ba77-42c3-8d85-6bb23a23f025@nvidia.com>
 <20240801175617.GA1133773@fedora.redhat.com>
 <a10e97ce-792a-410f-b68e-d00292987b3a@nvidia.com>
 <20240803083824-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <20240803083824-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0191.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:311::19) To CY5PR12MB6369.namprd12.prod.outlook.com
 (2603:10b6:930:21::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6369:EE_|CY5PR12MB6574:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d37f082-486c-4b7b-1417-08dcb3e56417
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NXY0ODFrSnM1UGxISnMveE5tc1hOa09TMzJuc2lHT2hrVzdRU3pYZithMDVt?=
 =?utf-8?B?S29ncHNOK1VUMjFHVGwxS2VqZFJ3N253dTh0M0NHTnNaWklwRjBEbWlGaWJ2?=
 =?utf-8?B?WVFwYUkvUWFKaWpmdmw1T1R3Ym1QcWUyV0VibEtxUEdBeSt6dEZHUnd1WnZ6?=
 =?utf-8?B?NW9KNG9oK2U5TDBnZjQ3dzFJZ3NOaitqbTg5OHB0Nm1GbENEZmEyaFd1cHZz?=
 =?utf-8?B?MlliSFR3Z01KVEFxT1BDUGMvcDBYd2JKaHY1V1l3d1B4bVJTb01XOTdEcjZX?=
 =?utf-8?B?bERCUHVDMVlMNjZhelBoWkE0TjgzZGdpekh0cVlkU3RuQ1pVT3ppMnZ5d011?=
 =?utf-8?B?c3V1ZmcvSW5Rc1FQK1JUWVVwanZaTkRCZmNrY2FCVStBT2ZDazkzZFJyUmJU?=
 =?utf-8?B?TWM0TVlmZEZ5U2FpbnV4ZkE3dnV0SmQzUEJTT0U5c2FzQjhJYWJsMm9oU0RB?=
 =?utf-8?B?U1JOZEFpMkdCNU5oQ3Nza0pBVFFYRXM3SDUwTExtS2pyVm1LbjBUamNYZlZy?=
 =?utf-8?B?MkhyenJ5YlV6WnY3bi9vMWpyd0FYamVjcm5Rd0dIbHI1ZlZHL1c3OW1WSU9j?=
 =?utf-8?B?ZW1SRnlpdjlIVFJWRTFlaXRlQ05DVzlXYlJ2QldPRE9HVXpGSlloOEZzRmpB?=
 =?utf-8?B?TUhZb3FQbnlZOUVITHVEUGdVdWQxdHhwam9WaDlYajVETFNyMDBJbmdhTDkz?=
 =?utf-8?B?amMvTVVDQ0U1MDBhQjk4Q2pPeFRIUVZpZU0yUkhoeVZYeC9PcmFzRkNlaVlI?=
 =?utf-8?B?TldtZmo4Q0I2UENBbFl0SUZNaGZWOWg3VGFpczgzVzcxYmY4aktZQzg0blZr?=
 =?utf-8?B?UXhENURjdnZ2OUtxZVA2bGNqMTR4VDI1aWFFZmEzT3Nla0NScDY3UDdjOGYr?=
 =?utf-8?B?ak5wNGRrMDR2ZllMV21rN1FBcng3aHNZSlBrelljb3ByNnhYbThkUDVPRElP?=
 =?utf-8?B?TjRZRm5PcENCTGxCY0JIY2tNSVByVktna0dRN2dTYXI2azVVMitid1lNemV5?=
 =?utf-8?B?OFFNQ0xacXFEUGFwVGg2Y0ZLUUxhWlJ2YmdZaSt2NVdxOVcybEhUUi9RZ1ZN?=
 =?utf-8?B?WXNORUJ3SHFBMzFYdXBaSEhoc3NERGRPZGtWTXNMN0gyajlpM2FzcUpPUzZo?=
 =?utf-8?B?aXNFR0pyT21zTVFvbnlyMjEwVzc0YXpydWx2VGY4ekZ6c0RQbU95Z1Nad2lZ?=
 =?utf-8?B?dG5JSmZ4ZWZ0ZTJnalpWbDJ2azVlYk1UTnBYcm5VZFJnNlZvNmxzVlIxS3Vq?=
 =?utf-8?B?eDNHTTJ1NmcxYmtKMDhkbXVwUkUzdWVUV1F3TnRDekEwSXo3R24yd3dJc3pU?=
 =?utf-8?B?em9SYUxEckF6emoyU3NOSFhNNXM1NEhnYmhIb3dMT0hQTnc5Z3BQVEFSUzhC?=
 =?utf-8?B?cUYvT1plbjR5bGcrakJEV2M1WGZHdnZ3dE02RGRUWkYwOHVIU1JOZlNWVGkx?=
 =?utf-8?B?SlQ0NUIveTVYekZhb00xeGExWlZTSndiWkR0REVTeWh4R0J0aHRSSDEvdG5X?=
 =?utf-8?B?K05JUEZuaEtDSGkrLzI3b0dkb3U0WXFsMjYxWHp6c1dXZmRqTlN1MEJvLzl0?=
 =?utf-8?B?ckZ5c3BORjJlMXF6cjBPUDd2ejZhWG5hYUZqZzJoOTJ6bWtKc001Z2tnbGIv?=
 =?utf-8?B?S1puTSt0U1RvZ1BCdm13Y1RKRkFZNFRZTGJ4NDhSOGhHTG9ES1VBdVhtZkkr?=
 =?utf-8?B?R2pOUUVnREdDK2ZSZzlKWWovNnVBSXR5eHlOVjV0OHE3VEZKcFZ3QlRxSk5i?=
 =?utf-8?B?RytjY3lUYU8zYlQvRzVWNy9yU1JCaFdLaXlrUFBFZFNQaE55Z1ZNUGtaYmU3?=
 =?utf-8?B?L3NValkvR2hpNzFwZE9uQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6369.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RFNnTHhWSDhzalpDd0dtZXFSNk9pcHlQMXZ0eXZ5K1JnZ2RFN0JyaHZvcWNC?=
 =?utf-8?B?R3ErL2x6ZnBQM0N0TVdFb0FjRzBtZ0pkN09Sakt2Z0tIdlc0M04rQk9FNjRM?=
 =?utf-8?B?UDZTN0wzMCtRR2NzL1NDZ1BBSy92TkZXQ2J3bzdqRjN0aENxMVpRVU43akpX?=
 =?utf-8?B?MUR2SlJSb2hXamUydGtLVXM0TEUvb0NsYVpiYkNIWHpvWGVqeG0wb1BmMHB2?=
 =?utf-8?B?dC9qaUtGTjMybUxUdGtWczhvTzR1QUUrYllGOFBrOEVYdGM2b0RLMlVWOURu?=
 =?utf-8?B?WlFpZDR2Q0FCMFpoRVJ6OHIrSldPa3dJaTNPWDZoaDNXTDJTTTZPTU1ObzdH?=
 =?utf-8?B?UmloRnIyS3Q4L1pkMDh2QjhCS0hxZnRiY04zRFdoOE9sR3JlRnhxZmdHL00x?=
 =?utf-8?B?YSt6NFR4eHhlU2lYZU42ZjB0QU1xZDZDMzBpZC9MSjlGM0tIbGlvd0lURitx?=
 =?utf-8?B?TkNpUDhZMmNBaXRFNEhvakgycnZRdERUR3Qyd1Z3UitQQVcyY2pPYTRpWmlz?=
 =?utf-8?B?Vk9ObzYzR3ZYQ0MyVFQrcGJ2SDI3a25UbVVBTXJ4bkJ2REFiR3NJRC9FeExH?=
 =?utf-8?B?U3lsbThCM1lobFA2bXhQeFJZZlU2Z01lRFl4YkJZajNCdjMvdDE0dWgzcVhV?=
 =?utf-8?B?Zk5TTmNLMThSWUR1RmE0WTU2YjJUZWRERWJtV3hYRUpaSklTYmE1NFNQNVlY?=
 =?utf-8?B?UE9HejNUVks3bnhJZlp2L2x5QW43YXI1SlI0SWwrL0JMODIwS1ZSQW5EUDdj?=
 =?utf-8?B?VEl0Vkp2Uzk0Q1dqTmVBcm8vK2t0NStqaEpEZ200L2dyTlYxNlZCQmRSL1gy?=
 =?utf-8?B?RjU3R1pqVTZqR0lxUEhDdWJpZXliM21GOTFCRkVjcmtERUNyRFQraHIvcnJX?=
 =?utf-8?B?cDhkOUxUTWJKNEJTaitrYkZaMDZHTGhIdXc3djZpbnFtSlJoV0JnalRVWUpN?=
 =?utf-8?B?MllCaTRKRU1HZFhSckF5VnVvUDY1L1NFcTJvRU9QNVQrUFdtOUZwajRySVhn?=
 =?utf-8?B?eUVSNTBPUDVvUldFQ0Y0S1hrK0d1MHJoQ1dlUGdrRmc0Y0owamlORDl1czF4?=
 =?utf-8?B?ODdVb3FyVm5jWU5zT1FxY3kwYTlvdFczYnpNWUdNNnI5VmtrK0NpdVVXQVVX?=
 =?utf-8?B?ZGdpek1qTWRLamRqT1c5OG9majg4d3NUNjBKcFRibk4yUy9DN1dPS2NCTWUr?=
 =?utf-8?B?VVM5a2ZYVm1kbVhYOXpuV2RXYjhpMVFKYm1KNUR6eDlWREN6eWUvejAzTHU5?=
 =?utf-8?B?SkhHcTlhdUpEOTY5bTVpQjVMTXpJcFByaGRNV3UvbUs3bWE3aXlMeTlXNDdn?=
 =?utf-8?B?UVltZ0w3Ykp5WTh2WFZVSHJrdnJXR0hJbzVRejl2RlhJN09YSFZWOGxXZTFv?=
 =?utf-8?B?dDhRcFMxNGVsWHdPd0hWcTBUMVI1UWg1R1ovb3FtZGpUNVNKcWhwWFBIckE1?=
 =?utf-8?B?YWR6ZmtSaG0rR3pxK21tbTlqQ2NSUnRRU1pEcTF6ZG9xaHorMWdNWFhhNmo4?=
 =?utf-8?B?c3BLalh5N2dISXdlbmR3dXJLNXQwYlVCRWpVQnVQVlFDZXF3TGVTTnlkWlVu?=
 =?utf-8?B?b0Fva3NKWllWQ29PU2tRMkpKQWlISU1lWjBKUERpUGJGR3cyRGhVNHJkR095?=
 =?utf-8?B?dzU4cmNJUytXQWRvZDhYeCtxeW5JK3p5QklSV3BTYnIwRXJxcC91QVU0MXhr?=
 =?utf-8?B?NUFpMVBicXZ0STJoc1llQUFtZjNKcHlkbG1TSXY3TlhXNXpOR0xQSy9IUERz?=
 =?utf-8?B?QkxKaVE2NXhmSHh0WEo2S0kyMTdRbEsydERiZElvQmZGcnA1eml1bzVIMFgx?=
 =?utf-8?B?OVlvaGhUMFFJYWFRbllobjM2Kzk2anFVQ2FxS0RLdzl6ZEV2MzFBL3Q4alE5?=
 =?utf-8?B?SFE3b1hUSlRpaHppTVFWM0dPQnJHdnNDY0dFeWZicGoxT3BjZk9xUTZobmJL?=
 =?utf-8?B?Z0hpZ0NId0hZcmhQQWRpV1FQdU1qNGtsbUIyc01EMFJCR096a09sUThLazBn?=
 =?utf-8?B?WXpINktMNVVjdTV3WCtyaTFCSy9DVGlrMFBzaFNJRWxwUENUZ0ozTDE5RW9v?=
 =?utf-8?B?QVNUVE5samhaRUN2NkFFNGIwNHJxZTVhZnB3a2NBeUhJSUdhR2hkczhadHhV?=
 =?utf-8?Q?8ml5ucFNOOrlwcbIPSuqa2AHD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d37f082-486c-4b7b-1417-08dcb3e56417
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6369.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2024 17:54:59.0073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y3g9xNuZW6CGGI80V0oxEv7zBx4VEwLN5SPKo63KrBpubQHCZwV1x73IReuRDywg6QfcXuY8sRtyDs3v2OcQBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6574


On 03/08/2024 15:39, Michael S. Tsirkin wrote:
> On Sat, Aug 03, 2024 at 01:07:27AM +0300, Max Gurtovoy wrote:
>> On 01/08/2024 20:56, Stefan Hajnoczi wrote:
>>> On Thu, Aug 01, 2024 at 06:56:44PM +0300, Max Gurtovoy wrote:
>>>> On 01/08/2024 18:43, Michael S. Tsirkin wrote:
>>>>> On Thu, Aug 01, 2024 at 06:39:16PM +0300, Max Gurtovoy wrote:
>>>>>> On 01/08/2024 18:29, Michael S. Tsirkin wrote:
>>>>>>> On Thu, Aug 01, 2024 at 06:17:21PM +0300, Max Gurtovoy wrote:
>>>>>>>> On 01/08/2024 18:13, Michael S. Tsirkin wrote:
>>>>>>>>> On Thu, Aug 01, 2024 at 06:11:37PM +0300, Max Gurtovoy wrote:
>>>>>>>>>> In this operation set the driver data of the hctx to point to the virtio
>>>>>>>>>> block queue. By doing so, we can use this reference in the and reduce
>>>>>>>>> in the .... ?
>>>>>>>> sorry for the type.
>>>>>>>>
>>>>>>>> should be :
>>>>>>>>
>>>>>>>> "By doing so, we can use this reference and reduce the number of operations in the fast path."
>>>>>>> ok. what kind of benefit do you see with this patch?
>>>>>> As mentioned. This is a micro optimization that reduce the number of
>>>>>> instructions/dereferences in the fast path.
>>>>> By how much? How random code tweaks affect object code is unpredictable.
>>>>> Pls show results of objdump to prove it does anything
>>>>> useful.
>>>> This is the way all modern block drivers such as NVMe PCI/RDMA/TCP use the
>>>> driver_data.
>>>>
>>>> These drivers don't have driver specific mechanisms to find the queue from
>>>> the hctx->queue->queuedata like vblk driver has for some unknown reason.
>>>>
>>>> It is pretty easy to review this patch and see its benefits, isn't it ?
>>>>
>>>> It is not expected to provide extreme perf improvement.
>>>>
>>>> It is introduced for aligning the driver to use common MQ mechanisms and
>>>> reduce dereferences.
>>>>
>>>> This is not "random code tweaks".
>>> If you cannot observe a performance change, then adjusting the commit
>>> description to explain this as a code cleanup to reduce dereferences and
>>> local variables, improving code readability seems fine to me. I think
>>> it's a nice cleanup when presented as such rather than a performance
>>> optimization.
>>>
>>> Stefan
>> Sure. Please check the bellow adjustment:
>>
>> virtio_blk: implement init_hctx MQ operation
>>
>> Set the driver data of the hardware context (hctx) to point directly to
>> the virtio block queue. This cleanup improves code readability, reduces
>> the number of dereferences, and minimizes local variables in the fast
>> path.
> I'd drop the local variables part, it is not at all clear why is that
> a win.

We can drop it:

virtio_blk: implement init_hctx MQ operation

Set the driver data of the hardware context (hctx) to point directly to
the virtio block queue. This cleanup improves code readability and reduces
the number of dereferences in the fast path.



