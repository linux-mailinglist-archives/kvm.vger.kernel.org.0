Return-Path: <kvm+bounces-52102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DF4FB016C7
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 10:49:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3ACF67A7D49
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 08:47:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3884820C461;
	Fri, 11 Jul 2025 08:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="212TbKaR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2080.outbound.protection.outlook.com [40.107.96.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC6918D;
	Fri, 11 Jul 2025 08:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752223737; cv=fail; b=qoyQrfYO6t+BEkf39IIBN+4ZVNscP+jh/gYMsv9fva+PuMpEyZWV/IFeIdXmghq6+X1nAS4yCYPSDkuo9h2/J5zWGMAZZ+uHXFvbUDGfI1xTj/rO+sPemT7R1B9A913S080RPDd9tqxUU+S3zZGrxbl+n+hzav+ABt0W8uTe6JU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752223737; c=relaxed/simple;
	bh=HiAUSDpmmWpl8z/kgHMC6TD2s77DTpBK/p8xXo6YSTA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=N2bOXRfesJS4xgDUQQJCQ/DLS6A3esKKLh4nwZQL81yJdTFc9FX4lcU4eOp41uZ72+qqF3D6FKSpi6o/dw+xNbPDkR4fwku9KO95lBHBbtVZ5Ma6TOLHm1QmRPOw0FSNCY7F0G3vDNUAJZbFvzlnmGP5D9QRaLd5yQ0U3UwS/pE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=212TbKaR; arc=fail smtp.client-ip=40.107.96.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tnbo4W1+bcDmOy6eEPxStrfY2ZfJ9mo6yeeI851Qhkl6jdIbFNGw7hPJUUGUgne+YwBj8YfjS11gUANkWqSmOx8Oc9sE16osB8Lu/3S+sCoTWkbHdn+3UbIA+aSpa4w3n7IBStaEG5tgsuio/bEDqQfXyVDsx/TJsCldF8lwI/YzbXzqYM9wjNv2wj++2invcNzeL94Oox9WgdTqPFKkFnbxOLyjQ8j3u4wwdPnf33UEf4p8WMz7Ni5ddrzpvgYS2KwlHnaqRQo3K5mf4LXRaDgKmrRgmhrwDNTeqK4xDkL7ATJzidH70JoXBAkfZbS0AgCUVmJqJREdEwo9+H4hwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K9MMFZQUwfuBVw9OL0tXKjD9ed1WxvtpRBCF3fCu5zo=;
 b=WBITUcpHYmcR57DSbKtcFPw/xojKsuGxVsS7FC7QTDu97sQxnbWPmny8Qi5IS8P3IeBXunjKjAnPgiJBq+tHhLn6V9Ke9yFkIDf1T/q9cAHD8PhWkd9WULcSJzLC2v0HpULlGhyonhTCMmY/5TzoXVhtTBZeuQrTbrX0+U+SXsjrRnh8NoEKQxa9Dy4aot4W8AZzxISKKS4YPZ/Tf7MLRFmAtjVDX6Z90JgYss5rSb7r+R/Xe790vm/A1RMpKPyu8EL8t0QMamP+yrxgOMCQOqzMYBPMOGOsk3a2ztIcndrzOJz1uXzQwdjlVc+2z1I76e1wLRDLgs88NQvS5HRNHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K9MMFZQUwfuBVw9OL0tXKjD9ed1WxvtpRBCF3fCu5zo=;
 b=212TbKaR2oa3pxcaeVBtze3NL6O399aGF8Iiec0OO3P2I074B5NFxwPdFHPepvQ0UHzHVeIRd5wnA4etdmmGdxoRHC2w8/CXuzrOyX8FWqSZt3JzRGd11J1EAOmnYBT9+m7Prok3PVltp6EYro9lVilFlj3fQlclXyCaoI/pQaY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SJ5PPFF6E64BC2C.namprd12.prod.outlook.com
 (2603:10b6:a0f:fc02::9aa) by SJ2PR12MB7920.namprd12.prod.outlook.com
 (2603:10b6:a03:4c6::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Fri, 11 Jul
 2025 08:48:52 +0000
Received: from SJ5PPFF6E64BC2C.namprd12.prod.outlook.com
 ([fe80::40bb:ae48:4c30:c3bf]) by SJ5PPFF6E64BC2C.namprd12.prod.outlook.com
 ([fe80::40bb:ae48:4c30:c3bf%8]) with mapi id 15.20.8722.031; Fri, 11 Jul 2025
 08:48:52 +0000
Message-ID: <bd261513-bd19-4c3b-a729-56b9e280a0bc@amd.com>
Date: Fri, 11 Jul 2025 14:18:31 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 18/20] KVM: Introduce the KVM capability
 KVM_CAP_GMEM_MMAP
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev
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
References: <20250709105946.4009897-1-tabba@google.com>
 <20250709105946.4009897-19-tabba@google.com>
Content-Language: en-US
From: Shivank Garg <shivankg@amd.com>
In-Reply-To: <20250709105946.4009897-19-tabba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0042.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:271::12) To SJ5PPFF6E64BC2C.namprd12.prod.outlook.com
 (2603:10b6:a0f:fc02::9aa)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PPFF6E64BC2C:EE_|SJ2PR12MB7920:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bdf94fa-526e-4610-5361-08ddc057c2f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MmlKRUtIV3kxVnU0UFNVYVNERjBRcXZPekxVS3NqS1pxL1NVTForSVlVMVFh?=
 =?utf-8?B?NXprNmE1cWk3cTdBbEpDMzg0SVlWcEV3WGRnZS9nbUJHamo0eVVNUzBRbFBF?=
 =?utf-8?B?Tm8xZldQQ1gwN0JZdFZiZHRWcWNtcDEyYzFpZk5BTDQxWkxsdmEwZllsQ3di?=
 =?utf-8?B?RnJmMTRDOUZ6dzQ2MEdrWHhzbDFYaWovUFFEV3ZlMWpzaVQ1QXgvTTJINWND?=
 =?utf-8?B?Q3ovK2RNUXFPQlIzQkprempWREdLZHNZcmV1bUtrMjU5eVBvVUdub0lxL3FK?=
 =?utf-8?B?QytjMlBabzlPL0FRUkUyRHdwM1ErYWRjZi9pSkR6eXRSOHhRSlk1REtXdS80?=
 =?utf-8?B?YnprZHdBU1hQS3AwZnRZMkdNTnh0dklvSFY5bnRKWkhJQ2tPVksrdTZhWENa?=
 =?utf-8?B?aWxpSHRxWjI5Yi9GQlJqbU5OMUVqdG1DbTFJN0lNZ0N1SUwvMmh4aURnU2Jh?=
 =?utf-8?B?MUpZd2FlSUNNWjhlVkNXTXVCU04vZ0pISFFablFXc21PcmZCVWwyVktYTHhx?=
 =?utf-8?B?ZTRGYThybDlEQVZtWG1TWUJsN2o5QmdwbWZoeFJ1T3Q2U04vVXhKN2N1REww?=
 =?utf-8?B?Zm9kMlZOYzVBK2FYNTVMaTV4V3lSMy9KSFFtUUNoeWdSODFWZG02TGtXcWlG?=
 =?utf-8?B?b3FnaE5ObzJ4Q2J1Z2lPeTVQOE8wYm5nZUs4Q2xyUUdHcFZ2cGpEcHgxaXN5?=
 =?utf-8?B?eDRuUGJjRjNBNHhEczZOUHNLVU1Za3ducXQ1UEFWZEVCcGUrMlM2OVR2KzRk?=
 =?utf-8?B?Qmx5bThZaC9FaGV1a29aWHBaNmRXK2RvNjhLUVVpV2NvK3VQbkE5RkF6OG1l?=
 =?utf-8?B?aFNhQjVpL3M4Nm9xck9ZQ1FuNlpWZ3BLVnV1cnJJSUw4SWpsZGdVS2h1bW9i?=
 =?utf-8?B?YzFtdmlwOUNCM0dlNGhQVVJtWDdSNisrMnRoWDRXTXRiMHNpRkg3QWh6UWNv?=
 =?utf-8?B?UlEvKzREd255bHE3QXNyYzg3ZkJ6dWR2OXpnTmx2ZEhsR0pJa3BJek9LQjVB?=
 =?utf-8?B?QkY4cHFKcW1ZZmF0aE16YW1VRGZ5TnlmMkNORHhNVGt5RGJBVk1rSEErVnps?=
 =?utf-8?B?V0huQVF0UnJqbHJmbFdCMHhnWTV1ZS8yZFkvSU1BN01uK0JTVU4zMmIyWVdT?=
 =?utf-8?B?aGpBTkpTNUxuZmFMNDdoY2ROMWw0WitzbjRSWTF6aTdocXpaTEZRYllQeEl3?=
 =?utf-8?B?Z0xwTmVZUUliU2JaS244Z1JheEdOV3VramY4OTN1K3NTeGRFRk01QzNSRWw0?=
 =?utf-8?B?S3gzZ3JIWlpLRzZQS29MandxdUlJeG4zcWwzM25HUXB1VjM0SWJmTlU2OGg0?=
 =?utf-8?B?YUMveWJSTVl4eGw0RWZObzFuQS9LUGdiVzduSnNOV296Nkg0WTVPRU9TNFZX?=
 =?utf-8?B?di9wOVRCaG00L3BHbDE4VjljTUZXOFhzVDNWZTh2ZXVZMXluRXh6ZVI2KzFE?=
 =?utf-8?B?aGF4cDFMK3RqaFlQd2t2ZHc2eDhUcFpudTVXdEJFWUJHSmYzSW4xa3NMM0k5?=
 =?utf-8?B?dHN5YVNHYmp5UGxVMllPbnh1T0lQZ3hMSVZjZmpTM0Fpd284aUtMaHJlOTlm?=
 =?utf-8?B?L041VDNkd2M2T0ZCaTZhYVR2TVBmSEpSUGNYS1JqT3RwV0RqL1V6RUVHdmR5?=
 =?utf-8?B?OVhLM3R3cTRJNHc5QlZXeG50dzhXM21vY1pjbXh5L2hMWCt6eTRPRUdqSENR?=
 =?utf-8?B?U2tQYS9DM3g3TzhJMmczYUk3UEVRS3RVTE9WRkRrU1BKZHluWXFzUkpnOEpG?=
 =?utf-8?B?STh6Sm1TcHFpWUVGbU1BMmxkY2pnakdIaVBvZ3lFSy9SK2orRTM4R1phYmZP?=
 =?utf-8?B?ZUtKRXdTajZLVDZ3cjI0MzRualZGYjB0YTZVK1dWa1V6M0REWWo2VGNvNGJL?=
 =?utf-8?B?dTFHQnRHWDlIWUdGQTRhVjJnSzJxajdkR0Ixc0lkK1hLdEs4Q2oxRStkamFV?=
 =?utf-8?Q?9/mxo7rw6Is=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ5PPFF6E64BC2C.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cHlFajhJMEQ3K0J6bXRmZ2VWeDEvc0FyVXJGQnd5WE1oVnJFMzcwc3c2Q3Rp?=
 =?utf-8?B?TmJEbWh3RnVpOHRadVRkcmlOOVVxRVowcnkwS3dRbDd2dVdSWEZjSEwxSDdR?=
 =?utf-8?B?ZWE5Z3pDMmNFRC9pOFBDNGNvdnNmRE1rRlVCVytoaDd1SFJORlRNeW13RlFt?=
 =?utf-8?B?aXIyZGEzTjJ5a1F3cEgzeGc4aDhjSDE3dnhrQ2lxL1NXRDk0WmI2WkZaZVcv?=
 =?utf-8?B?MlpaMXBjejVvMms5UDRQWFlPTUNPanNqTjZlWFk3aXFHSmwrOGc3N0swc0dE?=
 =?utf-8?B?U3RRMU8wdmlacmkxMWg2YUhyT1JORjJIcjhMSG9YWjRSQURIdkZpTHdGOWN6?=
 =?utf-8?B?dzlDWDlOSUlSTWdLWGR0ekxISUVMaWlLS3FXUk03OVBaT2tMWjVzczJ5WFhz?=
 =?utf-8?B?QzQxaXgxQk5lbzVvZ3BiVnhhT0IzM2IveUE4Q29EYVM0dHJtR2x1ZExZS1dj?=
 =?utf-8?B?YWxkRHp1SFZrUVV0QUdCWmwzV0ZTUU1WVTlWYXFwUzBiMjRlQ0tMQVMrOENr?=
 =?utf-8?B?NkhoZmNFQTUwTnZDdEZSalZVYkRYNzI3N29BZDRZbnFuaW1xS3M4RGwyeUJV?=
 =?utf-8?B?WTloM1R4NVNiVW9BWlh1Tk9KVTJoY1cxVVR2Vm11a2lIZkoxSmFkcFhmV3Jy?=
 =?utf-8?B?STZaMU9sRTVHL0dmZW5jQVFQVERRQWNqNldyaEhNb3FNWWZ1dlJkVUxUaGFy?=
 =?utf-8?B?Z0VacERaTkNrb2MvRzF5dU16c0dTRFFIcXBUTHExbXIvbkpaVjFZQm1PdDU3?=
 =?utf-8?B?VWFiUWVWTitvZjJIbnZUOFh2Nit5NW9RcTFDbUtSVnNaOCtiL3Q1Q0w1NHFN?=
 =?utf-8?B?eGcxWTd2ZENselozTXVFeEh3bUdWem9xS21pNDlDbEpjeGRqU0lxaTZ3LzBP?=
 =?utf-8?B?cnU0ODRqQ2RIRjdmeWRDNVJDZGdBU1E5b29hUUZWQ2ZLdHpScVIzM0xkSzJr?=
 =?utf-8?B?aWxWOUtYZXZMRGI5OXA5dE16WG50VEdRTnIzajRWcFNEVTcvQWxDTTJObFlC?=
 =?utf-8?B?bHc2N1cyYm9qRC9rWG5CLzhJTnNQU2Z4ZTE3ZTNuY1IwemRtM1RaTk11eWhh?=
 =?utf-8?B?TStYYzZkZnk5QXkxdklERkJjcmRNZmpsVjNZUjJ5cWxjSWFmUXJFQ3gxTi95?=
 =?utf-8?B?RTZEVUxLK0JrU29tYTBybTR5azBIdTcrMkxtWGV3SkZIL0wzUFc4NUtSaXdS?=
 =?utf-8?B?L1BXb0NZU21TRC9XRnVmWGdIajk5S3h2STY0Vlc4TmFUek8wWmlMVUZMd0pT?=
 =?utf-8?B?R3hsa2NsbENxdjZrTzBaRFIwS2ZOOTR4aWNnZSt1Uk5DZUdnbXdPRytIVkRr?=
 =?utf-8?B?b3FlS01nTDJYYUw3WWVZWFIwVUc3MUhaRWhSdFhWeTlzRVA0MmZHR1REUTMw?=
 =?utf-8?B?eEZBb05wblpsSGxwRkR2d1ExQXdoRlUxTitqcG9JdjFqdStmTWtaTnQ1b1Fs?=
 =?utf-8?B?eGxrVytCdkJyUVhYWFRtUnpVREtKYTlXbVNHMkhMVFpSdm1vQTFrWWJ6N2lj?=
 =?utf-8?B?YXlCdDZZaVRUempMUDZVeTZwaldRdTl6MzdvMFNuOEdrTmM2LzM3aVJVK1gx?=
 =?utf-8?B?TVV5OEhBNmNMOVFXdzd4UElqbmpqTktrR1NFanNyTnFnVE1PTjRKVldBWmlL?=
 =?utf-8?B?U1kxbVJkZGpML3ViY3c5OGljMHpmTW51ZFBLS2hLU2pKbGxtWG1jV0RWUm1Q?=
 =?utf-8?B?Q1JKUmRxRWlrNUo3M0FaUVZKbmZGODZRYVZWZU96ek9ER24rZm9lSDZ6SUcr?=
 =?utf-8?B?N0IwQkRGdllWVDBMdTdiYTU3MDBZTm1JdElneDVEQy9VcUx5ZzdWVytCekxv?=
 =?utf-8?B?SHZEVGJaZzI0Y3drZTVzRGpnRHNqWkNiMTVmQTFia2tQMms4YVN5bDRJNnR6?=
 =?utf-8?B?S2NDS3Q4Z205b1QxQUUyZ3BGaC9wRUI4R0lBSjRiQTVSckN4RG5YMUtHQjlr?=
 =?utf-8?B?bCtoQ3M1R25yazNxblVkem9iRkxMdWNsYzhoMTVqVS81NnFxQ2lTa2tBWkV5?=
 =?utf-8?B?Nzdad1dqUTV5YTFVc2J0RnBuM3FZcFdFMGhXZDRySzE0b1hZdmloaVRudTZ0?=
 =?utf-8?B?UEwvZHJQMmFMUmkrMzVqc0ErSS9GaHNnZk1UanZ3cVZXNUVaN2JLaHBzSEdh?=
 =?utf-8?Q?tMurWmB7OK+JPtwmzaiMpcYXn?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bdf94fa-526e-4610-5361-08ddc057c2f6
X-MS-Exchange-CrossTenant-AuthSource: SJ5PPFF6E64BC2C.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 08:48:52.5286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n6ejpQzIo23Soluz+GxJxMTucnbyOBavrDRtTnQB1wzj0QmxcYEjwk97KYdjfoVaaIqxd+5fmgTzxImpfhkhcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7920



On 7/9/2025 4:29 PM, Fuad Tabba wrote:
> Introduce the new KVM capability KVM_CAP_GMEM_MMAP. This capability
> signals to userspace that a KVM instance supports host userspace mapping
> of guest_memfd-backed memory.
> 
> The availability of this capability is determined per architecture, and
> its enablement for a specific guest_memfd instance is controlled by the
> GUEST_MEMFD_FLAG_MMAP flag at creation time.
> 
> Update the KVM API documentation to detail the KVM_CAP_GMEM_MMAP
> capability, the associated GUEST_MEMFD_FLAG_MMAP, and provide essential
> information regarding support for mmap in guest_memfd.
> 
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 9 +++++++++
>  include/uapi/linux/kvm.h       | 1 +
>  virt/kvm/kvm_main.c            | 4 ++++
>  3 files changed, 14 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 9abf93ee5f65..70261e189162 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6407,6 +6407,15 @@ most one mapping per page, i.e. binding multiple memory regions to a single
>  guest_memfd range is not allowed (any number of memory regions can be bound to
>  a single guest_memfd file, but the bound ranges must not overlap).
>  
> +When the capability KVM_CAP_GMEM_MMAP is supported, the 'flags' field supports
> +GUEST_MEMFD_FLAG_MMAP.  Setting this flag on guest_memfd creation enables mmap()
> +and faulting of guest_memfd memory to host userspace.
> +
> +When the KVM MMU performs a PFN lookup to service a guest fault and the backing
> +guest_memfd has the GUEST_MEMFD_FLAG_MMAP set, then the fault will always be
> +consumed from guest_memfd, regardless of whether it is a shared or a private
> +fault.
> +
>  See KVM_SET_USER_MEMORY_REGION2 for additional details.
>  
>  4.143 KVM_PRE_FAULT_MEMORY
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index c71348db818f..cbf28237af79 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -956,6 +956,7 @@ struct kvm_enable_cap {
>  #define KVM_CAP_ARM_EL2 240
>  #define KVM_CAP_ARM_EL2_E2H0 241
>  #define KVM_CAP_RISCV_MP_STATE_RESET 242
> +#define KVM_CAP_GMEM_MMAP 243
>  
>  struct kvm_irq_routing_irqchip {
>  	__u32 irqchip;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 81bb18fa8655..5463e81b08b9 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4913,6 +4913,10 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>  #ifdef CONFIG_KVM_GMEM
>  	case KVM_CAP_GUEST_MEMFD:
>  		return !kvm || kvm_arch_supports_gmem(kvm);
> +#endif
> +#ifdef CONFIG_KVM_GMEM_SUPPORTS_MMAP
> +	case KVM_CAP_GMEM_MMAP:
> +		return !kvm || kvm_arch_supports_gmem_mmap(kvm);
>  #endif
>  	default:
>  		break;

Reviewed-by: Shivank Garg <shivankg@amd.com>

