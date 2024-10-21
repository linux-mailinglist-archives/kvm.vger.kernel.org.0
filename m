Return-Path: <kvm+bounces-29288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CF82F9A69BF
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 15:10:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 615981F2283C
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 13:10:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D1261F470B;
	Mon, 21 Oct 2024 13:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rhp8Jh7F"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2068.outbound.protection.outlook.com [40.107.223.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2D61E884B;
	Mon, 21 Oct 2024 13:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729516236; cv=fail; b=MZ9a7Uw1RqfPteY4zqV9Kbezzpt4te718ESTZOmnmtrKpHMOCKhA7ll5mJbCnE3AGsvL7rrPOGpkstcFePToD/RCbAYqJQUigDHyI6UNhVW9SXoAxQQxKQdEuVN4qNRjKbWbab7QoOhXyzS/J+MbfKn2HEVlzBbMAROl1F2t02o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729516236; c=relaxed/simple;
	bh=hFm96K1v6DSodVEp4GYjrWC+rWULUgY3RXCnuvc6jcY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QE+PvKBKWZcQ50FNnpa8isVF+IR1nmWPVaQLqQ40ERMmFkR39vjO29f4p5BgUz2Hesmh/d7+shM+HX/4CUSiZieRtl3rCiHrcR2SAOgIyNHoD1J4wrjGluMyYkkTC3RnN45GTOIll0oBbp+eLSGBwohfpHxSnSyfnqKqEnA1rV8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rhp8Jh7F; arc=fail smtp.client-ip=40.107.223.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VgeuC81MWK2B6C5WsGLAEdqtCu+xaGUGOBvBcZCAUssjO/AUKYLrOR+fFb5CMTq6Qb4Fvu9ETqUq8JpCSQ5WbFmkLUs73uhoAsHPCUiE1uUTrReHL6gJrZmOZGDORAUJcMxLyXNTxBu1CqeSdSfQJoctI0HgPjtLwlqMU+0uwUz229aqpVhtcBCKyLQhAy050v1XmKabXhIrc8WJRzJyhQFmJly4Gxn5V26NDX2ImndE34eU15R5doJiMFct8dzPZVGZlxbmUN0XopfV5a5I+fq43dRNlJTNEjeAwPQBoeZ/7JUhxN4nvydBPRZMU+3gBjOZ+f9742AujEAyDPWvdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EiXa87in7rBAzv3uV1soGHG3lo9SBjmZjDPtG6yWv2k=;
 b=nx4gWZh3N04dYWzjohkT1qPweIhSW+inMNyEVjHw/PzKLyBBkkbKx1TNibDHPlhUa3k6tzGpynLUgFu++jtQ6HXK4URZKBp0iOq3Yi8WncHc/oEakjuLGvMc+NT5mW6U5yoqZ3FMCSoEG3q6W8CsigwvUi4BTtX18jmlRW32CQ1xMrSB2adWnwT3bmH/jSjD9UGl9iOHJ06GAxNUQgqwDXNhbu6j0lZgVGzWqH1vVwD8l0oPSKwykXy6frAf0YWRxkdgNq4bw2iYzeDSu8XTpNOv2e1KutW8H590n6j4pdHvwMsjDyqLV9CpQhaQnP7JqvcqEfT8fdtkO4jpSqXdPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EiXa87in7rBAzv3uV1soGHG3lo9SBjmZjDPtG6yWv2k=;
 b=rhp8Jh7FgJSEncWa2SRpCubXnQJGkq1uRDfJDk9f3OnzwjVeAjqg/OarVWrqhxGFEnKpUaxIR1CTjI2gklZVWnSILYMD4sx5AiYe2HDT9LE1/Daua9j+oL70ehYBcASJeEEVlXpKCp9qlw4roUroc6SGDwyxjgzpN3Yx71mD50w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by CH2PR12MB4264.namprd12.prod.outlook.com (2603:10b6:610:a4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.29; Mon, 21 Oct
 2024 13:10:29 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::f943:600c:2558:af79]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::f943:600c:2558:af79%5]) with mapi id 15.20.8069.027; Mon, 21 Oct 2024
 13:10:29 +0000
Message-ID: <896cc83c-6323-88fe-6cbd-f723246d4032@amd.com>
Date: Mon, 21 Oct 2024 14:10:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC 00/13] vfio: introduce vfio-cxl to support CXL type-2
 accelerator passthrough
Content-Language: en-US
To: Zhi Wang <zhiw@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Cc: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "kevin.tian@intel.com" <kevin.tian@intel.com>,
 Jason Gunthorpe <jgg@nvidia.com>,
 "alison.schofield@intel.com" <alison.schofield@intel.com>,
 "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
 "dave.jiang@intel.com" <dave.jiang@intel.com>,
 "dave@stgolabs.net" <dave@stgolabs.net>,
 "jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>,
 "ira.weiny@intel.com" <ira.weiny@intel.com>,
 "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
 Andy Currid <ACurrid@nvidia.com>, Neo Jia <cjia@nvidia.com>,
 Surath Mitra <smitra@nvidia.com>, Ankit Agrawal <ankita@nvidia.com>,
 Aniket Agashe <aniketa@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>,
 "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
 "zhiwang@kernel.org" <zhiwang@kernel.org>
References: <20240920223446.1908673-1-zhiw@nvidia.com>
 <c4c660b7-3220-4cf8-9430-a3dd7e623cef@nvidia.com>
From: Alejandro Lucero Palau <alucerop@amd.com>
In-Reply-To: <c4c660b7-3220-4cf8-9430-a3dd7e623cef@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0051.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ac::13) To DM6PR12MB4202.namprd12.prod.outlook.com
 (2603:10b6:5:219::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB4202:EE_|CH2PR12MB4264:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f1df523-9520-4e12-5a77-08dcf1d1bc1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bGRJejlQMmowNEFvRldSanE1dkxCTzQ2R3dNZUZHTlAvcTFodVZBQkdNemEw?=
 =?utf-8?B?UXZCQndKb01yR2dtZWpseHAxSmxXWE93UHlUK25saWZPRjgwUDhqRnZWM1RK?=
 =?utf-8?B?cURIMnVKRElGZWJrbDNjMnNLZmhkdFdYL2FHNi84K2ZtODdlK3JzU0dQalpl?=
 =?utf-8?B?YmEwbGxZS1lkMnhkTkIyeVJIeUZXK2NzbUNjZWNvMklsb00yUXNRc0U1Mi9t?=
 =?utf-8?B?SHlEQ2NTN29ETkRLejdReEtVSk9kei9SZXNFMktndmtzc2dkZm9TbFZRSTdi?=
 =?utf-8?B?MzVIam10ZGJNb29idU9PbmdtN1FhTHhwZUMyYWVsQWFKNDFheml4TmFob3dO?=
 =?utf-8?B?L1FWYXRxeVRRMyt0Ui8ya21Tcm91Mm5lRFJGVEZ5d0pvcTEyY054T3I5MDV0?=
 =?utf-8?B?SDBoT3crcnZxekxZRjA5U0lmeU5rM3NYTFJ3YXd0bitnaTNNMlZoVytyTFVC?=
 =?utf-8?B?ZXlsNnpOOXdoNkttL2J5OHMzd2liNVlWYW1nNEViT3grNS9qc1llQ2Q2YmFY?=
 =?utf-8?B?bTFHamsvMG5Ba2p1VFF0Z0gvbnF6ZFlHeTdxRkY0VUNYY2VDVFh1MHk4V0xh?=
 =?utf-8?B?SE9PZE5QNDdkd0xlVFNyZUJrcWN0akhEZHowZDNybnhhVkNCM3BnYVdiVjZq?=
 =?utf-8?B?UjNRaktER3hqMzg1cWVicHovRk4wdzR3bThMdDFGbHhSbXR2QVBDZVZTTWJ6?=
 =?utf-8?B?VThvaFZFeEZNdmxNOG1ZdkRhaEV1NHVKb01tSTJFZEtkT1dOMTE1bldLVDQ3?=
 =?utf-8?B?ZXdTeFJ5QUg4WmdNNmNoVW1odHlDdHZjRVNISWtQR3VZZUdLbzE0TVkwc01Q?=
 =?utf-8?B?RlJLQlNnc0tkQndZT2JORzB6bXB5eElRaVE2OVk5bHM0c2pFelVqcFNCNHI4?=
 =?utf-8?B?YlZKR1NoSktKMGh2RGxuQmZpU3ZrOXFrZkd4L21NNnVXZWtPWWszRk5JZzFo?=
 =?utf-8?B?RmJTdUNPejc5RlVJRDNhNEJVUDN4c3dBaHdBdmVIYlFkVHZyZHJPdG85ZUp0?=
 =?utf-8?B?Qm1QV1kvcE1UMktaS1JKcktKV3JYY0hTU3h5MTIrVVF6cHkzc2JvUzc2M2dV?=
 =?utf-8?B?NmJDQTdJeDZMS2tBSis2REdBVkJnbDJzTmFzN3BvMFpUN21xNnk0OWVta0pY?=
 =?utf-8?B?U09zTDM0YXllRGxuSkVQcWdxUFEvYVBzY1pSZFd1MnhwQUpBVWREL09lUUdz?=
 =?utf-8?B?L3pieU1jaVFQcDByNkh0L2YwbjkySkJFVVROYmhXa1FXS2FBZGxmM25SU1li?=
 =?utf-8?B?K0ppSTB5UkJjbEJYN3o3T2pWZHhpOGFIVDJpWDNSRXNGUjFtM0U4L2dZOWxP?=
 =?utf-8?B?dGk2SmdOS0FHYkN1dFM5YUxoSmpvcm1obEJaWXQwWW9kNmZpek1yL3dudDF3?=
 =?utf-8?B?UkhCaSs1V0Y4R3NFRitKNzZodWhncUZMYUZkOVBhbzZuaHNuOUVaeXRuOGNQ?=
 =?utf-8?B?RFFTUDg0ejI0YlhQUEh2YVREWFZiNWc4SWRlQ1UyV0dzZ3RUZnJLVlQ1SmRh?=
 =?utf-8?B?Qk5oNXZtSXBpSWF6Z1NjTkgyN0txcVB6a0J6bDAwL2xNLzJXSFRQU3UyYk9K?=
 =?utf-8?B?elZaTXVLYy9LRS81ei9ETGNrb0xFekh0alpXVDZZUngwOTlZV1RSR1hiaVFy?=
 =?utf-8?B?SElHOTJDRnJJbi9RWi9YQmJZTUUwTjY5UURsTGppYlVITXhlR1JxT3lxbDhx?=
 =?utf-8?B?TE9rdEludVRhenlhTTdRTHY5T2YrUnp3S1pNV3FxR2FtQ0JUeFZ1Q3ZnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dWRGWll2Q3dCbE4xUVVZUGlSQWNSWUVHMkhmMFFUaGxSNU5FMVVDNGRGNnUw?=
 =?utf-8?B?SmZoWUUwN05BamYvTVdkdm5DV1VaWnFoRzdaVXRmSGl5ZWl3bnEvdU1Kdzlt?=
 =?utf-8?B?UHd4RmloS2QxTmR1RTBkQ3RzVkxTaXdwNTR0Z2ozWk9RMStBSTdKamY5R0g0?=
 =?utf-8?B?UE9NaUQwRnlWRHBkdE0vWFVpaWpMSkxBQ2hyY3JQa0NJMHpwenRYTCt3cC82?=
 =?utf-8?B?OW50OGlPSzYxN0xjeDNpd3EvWDBSbnd6T08zOXRLTG82bkUwcldyd0VVajY0?=
 =?utf-8?B?bmFJTUxaMkd6TzZibm1QdkRqTE12YWtsbFAzUjBUd1kyMzhOYk5lVXdsWTc3?=
 =?utf-8?B?dXZ0S1p5VEFHbnZaTE94YnA4aVNSWi81emluMHJOaDdTQk5rOEozbUh0enJt?=
 =?utf-8?B?bnZxUy95eFRUOURNNnpObGJCUDd4SGMwQVFFNC92eTBtQ2JSU01MUWlIdmN5?=
 =?utf-8?B?eWdSMVUxTXNXQW1ZWDJWUGZLcnJab0lDOXlLTk0zdGdtTTBzUVVTNVNzTnJ3?=
 =?utf-8?B?OG5lS3BGa29raWt5UkxtZjJwNlVSUjNtUjdTVDFvVXAxMEx2MnVwSlh4U2NY?=
 =?utf-8?B?UjAyQTFZUXJyc2U4Q1JFNEZOekhJdklzdkw2SXQ5UHVLeEFvemttYUpDSzJu?=
 =?utf-8?B?ZFBoNER6Q0ZJSEZET3B1WXk0WU9PeEErcUFvOXNJM2ZkL2FFT3JWdkhyM2lM?=
 =?utf-8?B?MExwNHFVenVQc2gwV05qNDRDZ20xMzhmaDFFTWd3Vk5pcWY5K1d5QVVvNnNN?=
 =?utf-8?B?SUJwWWdvb0U0OFFPK3Q0S0E0TXBxUUtSNjRjdDZRRkpJbzdHNCt1a2FVVldx?=
 =?utf-8?B?Q1YzK2p2d0ZOaTJROFkzVzRzRVBDem5tc1NaTUlDNnhBMXMvSjFtYTR2ZU9V?=
 =?utf-8?B?VFZoY0hWRTd4K29WSTJXYkJoa1BCc3RxcHhDV29SbWRwUWZudWhENndSZFVL?=
 =?utf-8?B?NlFZMUh5RzBocDM2akdYNU9Daml5eXFkQ0UrWXplQUJlUGFob0ZLMW5GNUtu?=
 =?utf-8?B?bXFaOWtjeU8rKzA4cGczUytMeEpyTlZNalc1Mlpra0t1dkYyRGJNbDVTOGxv?=
 =?utf-8?B?dzlQMHpqQi85MmIzaVg5d0llU0llUVVXSzhNVUZjYlliSGRkZXQyTnJHYlF0?=
 =?utf-8?B?aEpKSTBIUG9vRGFXaUwxMUYzRklXQnhOWjBGZnUxbDFFNHlQSTV3cVRHdnZ0?=
 =?utf-8?B?SEVCenJXZU5lWEY0NUQ3U3hFM3hSelJwZEVpNFRRNWNKY3dCZFZmTG1lb0sx?=
 =?utf-8?B?ZUdJTnZpN0U0a2FDRWp3M1RQWjVIUlZReG9ZUS9aVDdrTS8xcXM3OU1FNENx?=
 =?utf-8?B?NENYbGFGbDVHWFNlUU14WnM4SFljMnRDekZBcXEwWnlVdENYL28wbFBxZ3lu?=
 =?utf-8?B?S0c4Zis2elNBSnkyeUVTNG00RUxRNm45MWJoUk9BOWdkOVNiQWIwc09hYU1T?=
 =?utf-8?B?eWYzcEJ3b1pIZHpWYm9BQ1N4QUpMeVQybzkxUEswMVo3MElGVTZxTUhNaUI4?=
 =?utf-8?B?a0k0T1QwRjVvQUp3eXRmWEd4Y2xVT0JmRXh1NHFqUU4zWGZMcndUNjJQQW5w?=
 =?utf-8?B?QlFpbjZWcEkwVmpXeEgydlFYTndXZUdURFgwVzBiWExoQ09GY1h0d29ROUk0?=
 =?utf-8?B?T2l4OUsrbklJVnNGOHJ6ODJkLytaaGRXekhlb2hYUHg0NCtRa2M4YXN4RVpj?=
 =?utf-8?B?WnVLVWZ4aitHU1l6UEIxa3QzdXlZMDVzT2NFUUdXVjlTUlRqWStGN3luOEF4?=
 =?utf-8?B?V2JmMk8vbWVVejhlUW15SFlHalJKVUl3WGVtTms5V09kNEVZZGpsQUdjVnVo?=
 =?utf-8?B?anVhdkVNTG5iY2s0YllYeEhXcy9mcGhudWY0Vmw1RWlRbGRDblJ0akpYRE45?=
 =?utf-8?B?ekhSTm1kbEZpZUxCeU0zd1EwK1IxVXd6RUtiUVpjd2RDckNYSFc0cWhqK0dj?=
 =?utf-8?B?aGIxTEk3VDJyNXhlODlndnVnelpQN2dtZlhIWlVzQ0lyU1pRNHVNWEhDM3hD?=
 =?utf-8?B?VWtDSk4xcGxhYUdWNGx0RUZralJvMVpjVTA1Mzd2eGRGRmkwNFNhVzluenRv?=
 =?utf-8?B?YUJGVkYxODlWWmt2M2ZPRkg1ZmQ5SURZV3FBV3dLTmdDSkJEdjFSRjFuUXQr?=
 =?utf-8?Q?i278k+DsmRkesnrcCeA/WBoLT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f1df523-9520-4e12-5a77-08dcf1d1bc1b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2024 13:10:28.8248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: olBiyO9hvE9M0JXTs+jvF8LUOAL4h0X6hovleG37N8GbqazaztE2wHaFEX1RuhCbzV/u/XywOOKT2napHw1sEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4264

Hi Zhi,


Some comments below.


On 10/21/24 11:49, Zhi Wang wrote:
> On 21/09/2024 1.34, Zhi Wang wrote:
>
> Hi folks:
>
> Thanks so much for the comments and discussions in the mail and
> collaboration meeting. Here are the update of the major opens raised and
> conclusion/next steps:
>
> 1) It is not necessary to support the multiple virtual HDM decoders for
> CXL type-2 device. (Jonathan)
>
> Was asking SW folks around about the requirement of multiple HDM
> decoders in a CXL type-2 device driver. It seems one is enough, which is
> reasonable, because the CXL region created by the type-2 device driver
> is mostly kept for its own private use.
>
> 2) Pre-created vs post-created CXL region for the guest.
> (Dan/Kevin/Alejandro)
>
> There has been a discussion about when to create CXL region for the guest.
>
> Option a: The pCXL region is pre-created before VM boots. When a guest
> creates the CXL region via its virtual HDM decoder, QEMU maps the pCXL
> region to the virtual CXL region configured by the guest. Changes and
> re-configuration of the pCXL region is not expected.
>
> Option b: The pCXL region will be (re)created when a guest creates the
> CXL region via its virtual HDM decoder. QEMU traps the HDM decoder
> commits, triggers the pCXL region creation, maps the pCXL to the virtual
> CXL region.
>
> Alejandro (option b):
> - Will write a doc to elaborate the problem of CXL.cache and why option
> b should be chosen.
>
> Kevin (option b):
> - CXL region is a SW concept, it should be controlled by the guest SW.
>
> Dan (option a):
> - Error handling when creating the pCXL region at runtime. E.g.
> Available HPA in the FWMS in the host is running out when creating the
> pCXL region


I think there is nothing option b can not do including any error 
handling. Available HPA can change, but this is not different to this 
being handled for host devices trying to get an HPA range concurrently.


> - CXL.cache might need extra handling which cannot be done at runtime.
> (Need to check Alejandro's doc)
>
> Next step:
>
> - Will check with Alejandro and start from his doc about CXL.cache concerns.


Working on it. Hopefully a first draft next week.


> 3) Is this exclusively a type2 extension or how do you envision type1/3
> devices with vfio? (Alex)
>
> For type-3 device passthrough, due to its nature of memory expander, CXL
> folks have decided to use either virtio-mem or another stub driver in
> QEMU to manage/map the memory to the guest.
>
> For type-1 device, I am not aware of any type-1 device in the market.
> Dan commented in the CXL discord group:
>
> "my understanding is that some of the CXL FPGA kits offer Type-1 flows,
> but those are for custom solutions not open-market. I am aware of some
> private deployments of such hardware, but nothing with an upstream driver."
>
> My take is that we don't need to consider support type-1 device
> passthrough so far.


I can not see a difference between Type1 and Type2 regarding CXL.cache 
support. Once we have a solution for Type2, that should be fine for Type1.

Thanks,

Alejandro


>
> Z.
>
>> Hi folks:
>>
>> As promised in the LPC, here are all you need (patches, repos, guiding
>> video, kernel config) to build a environment to test the vfio-cxl-core.
>>
>> Thanks so much for the discussions! Enjoy and see you in the next one.
>>
>> Background
>> ==========
>>
>> Compute Express Link (CXL) is an open standard interconnect built upon
>> industrial PCI layers to enhance the performance and efficiency of data
>> centers by enabling high-speed, low-latency communication between CPUs
>> and various types of devices such as accelerators, memory.
>>
>> It supports three key protocols: CXL.io as the control protocol, CXL.cache
>> as the cache-coherent host-device data transfer protocol, and CXL.mem as
>> memory expansion protocol. CXL Type 2 devices leverage the three protocols
>> to seamlessly integrate with host CPUs, providing a unified and efficient
>> interface for high-speed data transfer and memory sharing. This integration
>> is crucial for heterogeneous computing environments where accelerators,
>> such as GPUs, and other specialized processors, are used to handle
>> intensive workloads.
>>
>> Goal
>> ====
>>
>> Although CXL is built upon the PCI layers, passing a CXL type-2 device can
>> be different than PCI devices according to CXL specification[1]:
>>
>> - CXL type-2 device initialization. CXL type-2 device requires an
>> additional initialization sequence besides the PCI device initialization.
>> CXL type-2 device initialization can be pretty complicated due to its
>> hierarchy of register interfaces. Thus, a standard CXL type-2 driver
>> initialization sequence provided by the kernel CXL core is used.
>>
>> - Create a CXL region and map it to the VM. A mapping between HPA and DPA
>> (Device PA) needs to be created to access the device memory directly. HDM
>> decoders in the CXL topology need to be configured level by level to
>> manage the mapping. After the region is created, it needs to be mapped to
>> GPA in the virtual HDM decoders configured by the VM.
>>
>> - CXL reset. The CXL device reset is different from the PCI device reset.
>> A CXL reset sequence is introduced by the CXL spec.
>>
>> - Emulating CXL DVSECs. CXL spec defines a set of DVSECs registers in the
>> configuration for device enumeration and device control. (E.g. if a device
>> is capable of CXL.mem CXL.cache, enable/disable capability) They are owned
>> by the kernel CXL core, and the VM can not modify them.
>>
>> - Emulate CXL MMIO registers. CXL spec defines a set of CXL MMIO registers
>> that can sit in a PCI BAR. The location of register groups sit in the PCI
>> BAR is indicated by the register locator in the CXL DVSECs. They are also
>> owned by the kernel CXL core. Some of them need to be emulated.
>>
>> Design
>> ======
>>
>> To achieve the purpose above, the vfio-cxl-core is introduced to host the
>> common routines that variant driver requires for device passthrough.
>> Similar with the vfio-pci-core, the vfio-cxl-core provides common
>> routines of vfio_device_ops for the variant driver to hook and perform the
>> CXL routines behind it.
>>
>> Besides, several extra APIs are introduced for the variant driver to
>> provide the necessary information the kernel CXL core to initialize
>> the CXL device. E.g., Device DPA.
>>
>> CXL is built upon the PCI layers but with differences. Thus, the
>> vfio-pci-core is aimed to be re-used as much as possible with the
>> awareness of operating on a CXL device.
>>
>> A new VFIO device region is introduced to expose the CXL region to the
>> userspace. A new CXL VFIO device cap has also been introduced to convey
>> the necessary CXL device information to the userspace.
>>
>> Patches
>> =======
>>
>> The patches are based on the cxl-type2 support RFCv2 patchset[2]. Will
>> rebase them to V3 once the cxl-type2 support v3 patch review is done.
>>
>> PATCH 1-3: Expose the necessary routines required by vfio-cxl.
>>
>> PATCH 4: Introduce the preludes of vfio-cxl, including CXL device
>> initialization, CXL region creation.
>>
>> PATCH 5: Expose the CXL region to the userspace.
>>
>> PATCH 6-7: Prepare to emulate the HDM decoder registers.
>>
>> PATCH 8: Emulate the HDM decoder registers.
>>
>> PATCH 9: Tweak vfio-cxl to be aware of working on a CXL device.
>>
>> PATCH 10: Tell vfio-pci-core to emulate CXL DVSECs.
>>
>> PATCH 11: Expose the CXL device information that userspace needs.
>>
>> PATCH 12: An example variant driver to demonstrate the usage of
>> vfio-cxl-core from the perspective of the VFIO variant driver.
>>
>> PATCH 13: A workaround needs suggestions.
>>
>> Test
>> ====
>>
>> To test the patches and hack around, a virtual passthrough with nested
>> virtualization approach is used.
>>
>> The host QEMU emulates a CXL type-2 accel device based on Ira's patches
>> with the changes to emulate HDM decoders.
>>
>> While running the vfio-cxl in the L1 guest, an example VFIO variant
>> driver is used to attach with the QEMU CXL access device.
>>
>> The L2 guest can be booted via the QEMU with the vfio-cxl support in the
>> VFIOStub.
>>
>> In the L2 guest, a dummy CXL device driver is provided to attach to the
>> virtual pass-thru device.
>>
>> The dummy CXL type-2 device driver can successfully be loaded with the
>> kernel cxl core type2 support, create CXL region by requesting the CXL
>> core to allocate HPA and DPA and configure the HDM decoders.
>>
>> To make sure everyone can test the patches, the kernel config of L1 and
>> L2 are provided in the repos, the required kernel command params and
>> qemu command line can be found from the demostration video.[5]
>>
>> Repos
>> =====
>>
>> QEMU host: https://github.com/zhiwang-nvidia/qemu/tree/zhi/vfio-cxl-qemu-host
>> L1 Kernel: https://github.com/zhiwang-nvidia/linux/tree/zhi/vfio-cxl-l1-kernel-rfc
>> L1 QEMU: https://github.com/zhiwang-nvidia/qemu/tree/zhi/vfio-cxl-qemu-l1-rfc
>> L2 Kernel: https://github.com/zhiwang-nvidia/linux/tree/zhi/vfio-cxl-l2
>>
>> [1] https://computeexpresslink.org/cxl-specification/
>> [2] https://lore.kernel.org/netdev/20240715172835.24757-1-alejandro.lucero-palau@amd.com/T/
>> [3] https://patchew.org/QEMU/20230517-rfc-type2-dev-v1-0-6eb2e470981b@intel.com/
>> [4] https://youtu.be/zlk_ecX9bxs?si=hc8P58AdhGXff3Q7
>>
>> Feedback expected
>> =================
>>
>> - Archtiecture level between vfio-pci-core and vfio-cxl-core.
>> - Variant driver requirements from more hardware vendors.
>> - vfio-cxl-core UABI to QEMU.
>>
>> Moving foward
>> =============
>>
>> - Rebase the patches on top of Alejandro's PATCH v3.
>> - Get Ira's type-2 emulated device patch into upstream as CXL folks and RH
>>     folks both came to talk and expect this. I had a chat with Ira and he
>>     expected me to take it over. Will start a discussion in the CXL discord
>>     group for the desgin of V1.
>> - Sparse map in vfio-cxl-core.
>>
>> Known issues
>> ============
>>
>> - Teardown path. Missing teardown paths have been implements in Alejandor's
>>     PATCH v3. It should be solved after the rebase.
>>
>> - Powerdown L1 guest instead of reboot it. The QEMU reset handler is missing
>>     in the Ira's patch. When rebooting L1, many CXL registers are not reset.
>>     This will be addressed in the formal review of emulated CXL type-2 device
>>     support.
>>
>> Zhi Wang (13):
>>     cxl: allow a type-2 device not to have memory device registers
>>     cxl: introduce cxl_get_hdm_info()
>>     cxl: introduce cxl_find_comp_reglock_offset()
>>     vfio: introduce vfio-cxl core preludes
>>     vfio/cxl: expose CXL region to the usersapce via a new VFIO device
>>       region
>>     vfio/pci: expose vfio_pci_rw()
>>     vfio/cxl: introduce vfio_cxl_core_{read, write}()
>>     vfio/cxl: emulate HDM decoder registers
>>     vfio/pci: introduce CXL device awareness
>>     vfio/pci: emulate CXL DVSEC registers in the configuration space
>>     vfio/cxl: introduce VFIO CXL device cap
>>     vfio/cxl: VFIO variant driver for QEMU CXL accel device
>>     vfio/cxl: workaround: don't take resource region when cxl is enabled.
>>
>>    drivers/cxl/core/pci.c              |  28 ++
>>    drivers/cxl/core/regs.c             |  22 +
>>    drivers/cxl/cxl.h                   |   1 +
>>    drivers/cxl/cxlpci.h                |   3 +
>>    drivers/cxl/pci.c                   |  14 +-
>>    drivers/vfio/pci/Kconfig            |   6 +
>>    drivers/vfio/pci/Makefile           |   5 +
>>    drivers/vfio/pci/cxl-accel/Kconfig  |   6 +
>>    drivers/vfio/pci/cxl-accel/Makefile |   3 +
>>    drivers/vfio/pci/cxl-accel/main.c   | 116 +++++
>>    drivers/vfio/pci/vfio_cxl_core.c    | 647 ++++++++++++++++++++++++++++
>>    drivers/vfio/pci/vfio_pci_config.c  |  10 +
>>    drivers/vfio/pci/vfio_pci_core.c    |  79 +++-
>>    drivers/vfio/pci/vfio_pci_rdwr.c    |   8 +-
>>    include/linux/cxl_accel_mem.h       |   3 +
>>    include/linux/cxl_accel_pci.h       |   6 +
>>    include/linux/vfio_pci_core.h       |  53 +++
>>    include/uapi/linux/vfio.h           |  14 +
>>    18 files changed, 992 insertions(+), 32 deletions(-)
>>    create mode 100644 drivers/vfio/pci/cxl-accel/Kconfig
>>    create mode 100644 drivers/vfio/pci/cxl-accel/Makefile
>>    create mode 100644 drivers/vfio/pci/cxl-accel/main.c
>>    create mode 100644 drivers/vfio/pci/vfio_cxl_core.c
>>

