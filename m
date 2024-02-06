Return-Path: <kvm+bounces-8088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A457884AFA9
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 09:11:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C9C301C22264
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 08:11:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 039FE12B143;
	Tue,  6 Feb 2024 08:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J77d6ioq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GkM/zA2E"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA16512AAD2;
	Tue,  6 Feb 2024 08:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707207050; cv=fail; b=UP5dU2d78SD2828jb1kBqjG2WqlhkypcbB/vldY8ldi64NV91wJ/mRf8MglW5AIG6k6qWlB8brRkHIg5JhHCSgP4SGpgOnwoH9SuElvJ+qB2F/sgWlpcHgTqaQSoNz2716dqUj3vgZWtjX96UYi3+ZZQgJbI5E/y3c4w740z15Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707207050; c=relaxed/simple;
	bh=IaoUz2AlyBJtNy2mir/MqHBWYXhowEgQW48ePKyA/fc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eUijZ1qd0ZPxaBT6AYAu4qVUfyLToat7Y7wziVU87iaSHW52/99BoTKSSYLvr2H85zHYEgGmy573Dr3Q6j9en1mdVh2hKnUS+w9jmWbGT4/lWBcm1hJYzpBP1rKz2iNibrSBiYtautzul12KXkRBPIZWfxVqOkJrRligyCH9Lpk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=J77d6ioq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GkM/zA2E; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4161ExiE025516;
	Tue, 6 Feb 2024 08:10:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=BAn9Y7vXRQckNFbtUqGlF0tBBQFLw67dJANz7uipV3k=;
 b=J77d6ioqsCAxCx8f3Ps0XR7GpFMhpzay6pf309ztUCeVqT2tJrWHKZl+7lgzkyotG6Hw
 OZ9JiZYb3ZuMeK8/WYVeH4MDnUnY6kFeXb5y8ZaGoHBKZbHSKicLaT8JIaT1EYFetlv/
 bdm3j4NEtS6UBtF5iNZLYpgcFSW0CCE3IbnRjpPL3vycM48rbd4EXz5HNCztr9mJfBnI
 yL7onSs4/x1q7jQ01qw82zvW1l9iKD1vq/0iOzOKVXHrnG4pFBE8iZMgSTBGB5/wTiyV
 wC3pkd9OfpK5V9xeXF/VYR1XBqcWjtIAWWA7Q7w9pgVDCu51LAZ3zBaMmt7cp9YLwWj6 YA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1e1v605s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Feb 2024 08:10:41 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4166Q9tF019958;
	Tue, 6 Feb 2024 08:10:39 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bxd7bwu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Feb 2024 08:10:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LOlgMd9beCLEaQXGDmnw79TaDDF8q17h7synvXhlGcDzd1jrZsvVVqupkc/q7+6lo/8uAQYRcbcvwA3VRMP7eC7hVqDT6uPxpMayJFMulkANHo2U+v6Tlw/FUpfw0ApnuGVPnUfru0y1dYjtpGqskXYQohdVm4uZczv7Ys4hbgGyJC5Vxqeun4Gkgq9Pe6d/bLiFqc+m60isxnWlbaHRWrbxkgzqo/0I/4FiC6DYNi1ECu8MgvSfBApYZTyEpHi0DWY1u46rl47jUzmkgvgedaO+ZmYzVkwN3Qdo9K15F5oCMbTX78l1ucrNEQmwPOe1fZublVQckQfOq9N6qwVSCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BAn9Y7vXRQckNFbtUqGlF0tBBQFLw67dJANz7uipV3k=;
 b=bfk0xbzIToX67yVYkEBRHtdF7/eNuQpagrFScxbyioNB+CxHbJUZk2nE5se3NovlSMytBVusl9sWb8h3UFrDLddOQCVFYTEIFqUc7Bve3/zPaskl+ALJ3skbs8rhkH/jeQG6IKSsgyhQWPz8yVVA5rRwCe/rCsETznB0fG3NHc/vjC0X5lvKfPpAWtmWHdziFcUztAth7l5bKBfa4XDw3dd+JrPhRkxp94jDjsvlqUI4KrINI0v03xivZSRo+vdk1pTTPvyzEvJwhbhDOI8KktJP5SjyEevDobTL7Mh5nXBs8qO3Lg2+ZwK7IQDcSTj/DrbBXxtuBAcdrMDprNNWAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BAn9Y7vXRQckNFbtUqGlF0tBBQFLw67dJANz7uipV3k=;
 b=GkM/zA2EqoOxIcTtRBpdVrTguP46UwIla/3PXBIlqQQ3P39hx5vFP7OkIZ2TZ3vV6D/rRc4fvjLHxWKu1eyaTE0h8nu4yFWt4IruZ4dNz7lJsktP1EdsHTBo1kZgB2Y1OExigOyTysbcqCBtCS79ieWZ8U7BOYqmGrpa4o8uQkA=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by BLAPR10MB4867.namprd10.prod.outlook.com (2603:10b6:208:321::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36; Tue, 6 Feb
 2024 08:10:37 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a1c5:b1ad:2955:e7a6]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a1c5:b1ad:2955:e7a6%5]) with mapi id 15.20.7249.035; Tue, 6 Feb 2024
 08:10:36 +0000
Message-ID: <8fe554e5-e76e-9a0a-548d-bdac3b6b2b60@oracle.com>
Date: Tue, 6 Feb 2024 00:10:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] KVM: x86: make KVM_REQ_NMI request iff NMI pending for
 vcpu
To: Prasad Pandit <ppandit@redhat.com>, Prasad Pandit <pjp@fedoraproject.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
References: <20240103075343.549293-1-ppandit@redhat.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <20240103075343.549293-1-ppandit@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7PR13CA0010.namprd13.prod.outlook.com
 (2603:10b6:510:174::20) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|BLAPR10MB4867:EE_
X-MS-Office365-Filtering-Correlation-Id: 95b796da-1ce2-472b-be8c-08dc26eb1986
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Yh/dIWdL3j0mdxhLLwnM3NcH6yzaGWtDuW6I48BG1vYNIW2LmpAX3xRVPaa0ZDL23HiGef1ci4QRHLZ2IAqO/0y02RvjqpyLG5GQ3ZKDw9W51dOBekPvxo2HTinuySbA5Su8i4QqqPOechI51/d5w2W9VrbNZWQSmVGNDJF1AGSEyubLQuxiUpFPWufOsKuOWlMaaisEgVVJ7GIC9+72PjNphz0gIAR/QSp9LNetAWQNXywAZD9WwciU30+N1oO6KlEMtZ4wkHG5B0R3WAgWC9zGiSQunpa/KrxlKEmnN1IYs7+20NXW3UMvau90e92ji36noB/YnauoBtvu3qFURhKN0a0JGaY2YGvbNcMEQd1AareBkTg0MAxSh1yiUeyB4cvqlMyGmpRVYPcpMF7GzN0/KiQCRjM5YtEtoEszi2woFoAKwFWbyoAFv73hoywsdpQUGys3v/+x8Z5KFj9EbwtJT5AvGwWdLYBVw4+z+ucJaQWePG9x5fpDJSCIvU0l2b1ekYnafoqIwZlZh+yQGWr3qSUcuehJATE9QSAtD+tdumb3mEpPtW0K5hRo8fBgcwEEGZ7C34/KexdvbQSf7dngLVAxLOrUnHJ+WNIkMMX7uOGk46UnzjaGX0p3ZbACDF0K1BINnJdkLGQNMiAPFg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(366004)(136003)(376002)(396003)(230922051799003)(1800799012)(451199024)(186009)(64100799003)(41300700001)(83380400001)(66556008)(66946007)(66476007)(6486002)(110136005)(53546011)(6506007)(6512007)(36756003)(478600001)(8936002)(8676002)(4326008)(316002)(26005)(38100700002)(2616005)(86362001)(31696002)(5660300002)(44832011)(2906002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?NE5Ub0NkYlNtdUhTc2lZS3lIT0VYN1BJajF4Q0hxT3hsK2NzT1ZUMXZaZlBX?=
 =?utf-8?B?TVVuOU5XdVJQbjJpRnBMN2xVTVpqUGRhME5jMGpPZld5S1VQODR0KzVUK2ZC?=
 =?utf-8?B?NWpuWXFEUENEcWp5RTFQdFBaVTBUTDZaZWEwOGJ0WFpBTFVTLzRRdWRyTXlG?=
 =?utf-8?B?cThSUGFGVGF5ZEl2MjZqTTIyNm1oWXR5R2Z6SHZEQk9LUW8xZjNoL1hkLzgy?=
 =?utf-8?B?UDd0TERybHFHb0swOXhaZnJnQUFNa1o0M09sdzBpc2toOXhaY0xmVm9Qa002?=
 =?utf-8?B?Ri9BOCs2K3lNMVNTY3VwemI4aVhMVnhzYmYxQWtRV1RjaWJnSmtERmxIV29T?=
 =?utf-8?B?cjRJNWRBYTJGQ0ZhR012bFZuOGR1RXVTanAzdWJkb1pRRHZzdHBFbHZWTkh5?=
 =?utf-8?B?TTEyaU11SlpwcU5TRDlLYVJRNm9UMWdZVXBjeTA4Q1VYcHFKVE1waGFBUjNT?=
 =?utf-8?B?ZnV3TnJzOXJVbllVWDVJRis3dmNyODU4WFJNN3dYWnk5Mko3YWZWSVRMREJL?=
 =?utf-8?B?Q1RLM0JENlQzOVBRK3lyZ3NHMGE3aXc4WWZEaHoyWmw4cEtPMnpaTHFBUWll?=
 =?utf-8?B?RlZTT1VsYjMvQlpUdkdFb0RocVlaR3Q1dXBjZkE1Z0ZSdXZmNnNGV0U2QjJw?=
 =?utf-8?B?V0lXSUFsQUFDeU5kUEpNcUp3Wk1ReVVNa3ZzZS9YU0xROUdia2RxY0ZzUGZy?=
 =?utf-8?B?c1hoWGVCY2ZCczQ2Mm1rMnFqaUp6L2UxV3BodHNqM1pGM2ZteSsybjZqNlY3?=
 =?utf-8?B?S1VRL3BWM1JlSVZqTlR1bzVnUVlHby84NVo1SEZGaU0zOW5aamFZMGZ0SURz?=
 =?utf-8?B?bEp4QnVCdGJrSklSekNkT3A0ejBqb1Nwbm5xRFJuSU5PZTBiSXBmbzJoZzBO?=
 =?utf-8?B?aHJmL3d2VkNTbm9yUmVOZEtiVm1SNndYSmZzSHRWYjJwQnNJMnpOSERTd3Fo?=
 =?utf-8?B?ODdiY0xTNEZSTERkTjJCL0VWaFp6K3ZaT05pYVlRa1BkYk0rRisxVUxseWVn?=
 =?utf-8?B?WUh2OWh6eVBBR2RtWDhWTjNRTlkyQnRXMmFFc3lCVG5BLy9kZU45UXV3UHpj?=
 =?utf-8?B?Ky9tbG9iWUlHOFZ0N2FmLzc2ZWpYa1FnL2VOVm5heTJBYzNKYTdqRGpkT1ha?=
 =?utf-8?B?VGg3d2Y4OG5XQkxSbEZhNGdBVGRNRHJldjlyTWsxQVlaenFPcHptMWZ6bUtk?=
 =?utf-8?B?OHp5bExCV3NDb3VhelV0blUzS1A5TTd0ZkFkT1RGZFVsaXdIRDRHT3lXdnhF?=
 =?utf-8?B?MThkT3BYeHZYbWlyM2hsTkEyTGRVY3FEY0g4eUJ4L1gvVk9XYlZCajVrNENP?=
 =?utf-8?B?VXJEWW9PMlVKV0VnRjhuZUtZSUZXa3ZudG1XeFVEYU4rcEZ2eGIxYXVhUEc4?=
 =?utf-8?B?YnI5M1ZNUFgrbmlKSmtmbjd5QlJiSG9QTitiMWxMZFJpOVdXdm5RS1VpY0tK?=
 =?utf-8?B?Ly95azVGTWtWR1JDNXRValk0TEhabXZsZTFwdVVkd1BaMllqN2ZwWm5ZQ0dU?=
 =?utf-8?B?UmpybHlkbFRLSXJiTFpoV3N2enlYN2p5NFp4VHRPQWpNejcvOTkzS2k5SWVU?=
 =?utf-8?B?djRlRzlYNmlkdFRUYkhobEpnZmRYbDJ3T1NlcEwvWmszOGtkZ1Bhak5xNzdo?=
 =?utf-8?B?ejFqb3J2U2NtRG9BbUtHdDZ4TU4rTHdzcHN6UnN0SytteDB0QmFWL3NkNktP?=
 =?utf-8?B?b3RlOTJvRG9mSlJZQWEvTllrRzcycU1PV1FBYkRnN3NFY2RxTks1dG4rNzFo?=
 =?utf-8?B?VStOSHVTSHRKd2x5dENzdmxmUEJOdTZKeU51NEppZjhVQmZ1ZmRPWDU2TW9j?=
 =?utf-8?B?QW5veFI2R0w5MVBsSUxNeEpqeFdOc1hVRmpjYXJ0cnpGTnZDS2VzbVBoRVFm?=
 =?utf-8?B?T0VUeWM0R1JUanVsRHpkQkxHZ0EwWmlrRGh3YUVCMU4ybGF2UXUyT0ZoZEhR?=
 =?utf-8?B?eWJxazdKSVI3K3NWL2FMVlRtVWI5RlBBaWJBQnhEZWhUZ3FaTzhTZTB1dUtT?=
 =?utf-8?B?OVJIUmRtZ0xpejY2OFZuUEl1QlltRjBLSE8zUm9MZG1zZ1lBZ0JUSWJkRG5D?=
 =?utf-8?B?VHdYbWVhZWg0VFcxcytRbHlrWExRakZWcEdNUDhpM2Z5QnFyc2c3b2dDZWc1?=
 =?utf-8?Q?WaKDt7ENgaQTvvIv7QJC5XJZk?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	T8nEFcuD/a1D8XHyWb64ECMlVteCanc3NL5Rp03YBrqtgOE0J1OkW37L1NbjDX0DvDUCXrFC2V0sz8YuolWwx6KxQkiaiaQB/C9r6aQhXKJN4LN8ixRrWHOT5MHCGEDuOUm5cx02D0EuRaa1kqe437CaAYGMLhaUNLqdeK830/g4Wdu0gJN+/XjnUa2Jwz6p/ER/Rkp+ThlOO2QYfZvI510yjAiRaNo1xspWV4tT3XSnTkckMsoutfXP1NGb3AfQOU628usXl+L8s/L9EmuU62W/daHmkZ8K8qgl4eMoba0VOR6oGpt8yeXk6QwXHoNphRm/qnmg2w/bptjpZuH+mW0Uy4koC74iT7XE1b9zoaXPawNh0FhCUNvG7pnAXSV30d42VekPd5HFHt0YbAFwdtGZQuInUm62ZSN5p4AAHH4Lh9hp1Th8k/a5eMfRUh2IRRKLG2p8OsaSz6rXnXqSJuzvF94/sOCgEEyx5Rm/ZgTf+E/ENl2H4mJjIe/2SMi34/9o0js8peZ3zaOS6IIMrTMe6sCDu7y/v2ZzW8wrcR7I9KEQm2HPpBdMJZYyc+Gvrk6q1u9l1PZUREkO89kZTLmZ8fCIvg5qIqqoiD09Hwk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95b796da-1ce2-472b-be8c-08dc26eb1986
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2024 08:10:36.8234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ojhG9eWXVOr8zZ3CLwACi0lIGWhRIOMST0NHtIGdHPvCVrLVZbXxNwRvmo4EXe0G7d6rEw3HCOwcpfYKyBQtbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4867
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-06_02,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 adultscore=0 spamscore=0 malwarescore=0 mlxlogscore=987 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402060056
X-Proofpoint-GUID: 0xoH5ymd3FMfTs2BVYHo8dHYDXgr8mRr
X-Proofpoint-ORIG-GUID: 0xoH5ymd3FMfTs2BVYHo8dHYDXgr8mRr

Hi Prasad,

On 1/2/24 23:53, Prasad Pandit wrote:
> From: Prasad Pandit <pjp@fedoraproject.org>
> 
> kvm_vcpu_ioctl_x86_set_vcpu_events() routine makes 'KVM_REQ_NMI'
> request for a vcpu even when its 'events->nmi.pending' is zero.
> Ex:
>     qemu_thread_start
>      kvm_vcpu_thread_fn
>       qemu_wait_io_event
>        qemu_wait_io_event_common
>         process_queued_cpu_work
>          do_kvm_cpu_synchronize_post_init/_reset
>           kvm_arch_put_registers
>            kvm_put_vcpu_events (cpu, level=[2|3])
> 
> This leads vCPU threads in QEMU to constantly acquire & release the
> global mutex lock, delaying the guest boot due to lock contention.

Would you mind sharing where and how the lock contention is at QEMU space? That
is, how the QEMU mutex lock is impacted by KVM KVM_REQ_NMI?

Or you meant line 3031 at QEMU side?

2858 int kvm_cpu_exec(CPUState *cpu)
2859 {
2860     struct kvm_run *run = cpu->kvm_run;
2861     int ret, run_ret;
... ...
3023         default:
3024             DPRINTF("kvm_arch_handle_exit\n");
3025             ret = kvm_arch_handle_exit(cpu, run);
3026             break;
3027         }
3028     } while (ret == 0);
3029
3030     cpu_exec_end(cpu);
3031     qemu_mutex_lock_iothread();
3032
3033     if (ret < 0) {
3034         cpu_dump_state(cpu, stderr, CPU_DUMP_CODE);
3035         vm_stop(RUN_STATE_INTERNAL_ERROR);
3036     }
3037
3038     qatomic_set(&cpu->exit_request, 0);
3039     return ret;
3040 }

Thank you very much!

Dongli Zhang

> Add check to make KVM_REQ_NMI request only if vcpu has NMI pending.
> 
> Fixes: bdedff263132 ("KVM: x86: Route pending NMIs from userspace through process_nmi()")
> Signed-off-by: Prasad Pandit <pjp@fedoraproject.org>
> ---
>  arch/x86/kvm/x86.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1a3aaa7dafae..468870450b8b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5405,7 +5405,8 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
>  	if (events->flags & KVM_VCPUEVENT_VALID_NMI_PENDING) {
>  		vcpu->arch.nmi_pending = 0;
>  		atomic_set(&vcpu->arch.nmi_queued, events->nmi.pending);
> -		kvm_make_request(KVM_REQ_NMI, vcpu);
> +		if (events->nmi.pending)
> +			kvm_make_request(KVM_REQ_NMI, vcpu);
>  	}
>  	static_call(kvm_x86_set_nmi_mask)(vcpu, events->nmi.masked);
> 
> --
> 2.43.0
> 
> 

