Return-Path: <kvm+bounces-34859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 21222A06BB4
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 03:55:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C7FE3A643F
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 02:55:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 590A943ABC;
	Thu,  9 Jan 2025 02:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3nlMNW8S"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2067.outbound.protection.outlook.com [40.107.212.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28BCEBE5E
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 02:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736391343; cv=fail; b=GM1K3HAhrjKOe+yYyuybv/WJxGdYJYWwZ+95tF2tkckepj1gCWhg8+lCPs/LanPga3LV+iI3LbWwHIF6AqZL40hVaAi1sQCqbQycwn7jDOBkW7/F02Ho6i07+8zdeEgefa1h104+QlTWOD7f09u1vmxohGEFZabVQ1ZCVLGG094=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736391343; c=relaxed/simple;
	bh=vLfiiD0uwrVDRlb661BwWf4oFhU9fUY2TmSLuFtBZiQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UqkuKABEKdqQCWrcYzxH0NCqj7it/RaTMaGiXzqmWz5TmjFB+r2lsAbAkXUIIXMV6RN8XPaP4qHUQjAgNlYmA4AiGX227NFMgaLWTDWWvYzjapjqZQAdYPtZIwSIuE95FizC/ut5bG1bpJaUPCH7pPhr7kMKsStDLkYwhRcF6wE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3nlMNW8S; arc=fail smtp.client-ip=40.107.212.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xvumNc1lVqv6fYaa6khqkk0KBPM9MddribSdxU3WWQF7Jso8qa52OKRoPCPbcRyz7Fq3Lry6vEiM5XkTKjQsnajNenF3qhUz+tcCWkiLb0UE8EJwuM0Q5PsTbHMKZQ40UsmL8KT+g/QcYhn7hxdKsY2em69yZ0RFio4Kplsf39CcDaOdjo0K5sjTFSIgI3hOncQeQlsQuYTSz4RL33UZt4efF64g4mBMxahYoQNgtfNhOVUUuZYpiY326SVHCJkV02xCerJL2F2i7hU/QzacbT6XnT6TwEDswB708Qd2+c+5CPbzn5sVWN/RB0OamnHBRHWSzUJRV5wltba8bAnzcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kkg/Qwmp/oUrenKBqRyP8kauzDVrHED3hvt+UOCMzDM=;
 b=lSEkKklj/ZJB00q9lsc/LVWcmJB7+EqrFhDVBrlS1Xyp5JxQDG32VympPi09J7SputWUudIVyuZ25O4U/GEi3FxuRoXN1oFAtz4rcsyALtGtt5Cu+6dAnF4JXHe1um47S60Jhk77ojfI5E9Xyz/ceuNq/d6lGyTX6izmReyb2uwfoxDhYP54Jhv1yFRH0Sr633GkFwRW8rrevlvlJDZnqw3Jqn05IewfXh8V3AV79unnacGjaCOrOBUinF4CcJ6ESD6QYqmUGn2xHj9xOosTlp4FnlFMj6Wa3TVcdOp6XHK2+j3b9tHLL3sT77dQR3wcMjl0c4dvYJntgx5A6Fk6Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kkg/Qwmp/oUrenKBqRyP8kauzDVrHED3hvt+UOCMzDM=;
 b=3nlMNW8SLgL44B38AS6678dD0ZLfAaFdMHn0f3A8H/QrsBf+f/eGKmWTiX3zZIYRNiZFMJWUpI8Mp99u0M5TPwUjtn5jXsXNk6QDjJokBoBV9BzlKIuENg7xJR/dsSelf6ylGDQtrOvTs85JoZVRM6ARF8CORfldq+XtOGLISOw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by CH3PR12MB7500.namprd12.prod.outlook.com (2603:10b6:610:148::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Thu, 9 Jan
 2025 02:55:37 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8335.011; Thu, 9 Jan 2025
 02:55:37 +0000
Message-ID: <8c8e024d-03dc-4201-8038-9e9e60467fad@amd.com>
Date: Thu, 9 Jan 2025 13:55:28 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
Content-Language: en-US
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-3-chenyi.qiang@intel.com>
 <d0b30448-5061-4e35-97ba-2d360d77f150@amd.com>
 <80ac1338-a116-48f5-9874-72d42b5b65b4@intel.com>
 <219a4a7a-7c96-4746-9aba-ed06a1a00f3e@amd.com>
 <58b96b74-bf9c-45d3-8c2e-459ec2206fc8@intel.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <58b96b74-bf9c-45d3-8c2e-459ec2206fc8@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MEVPR01CA0075.ausprd01.prod.outlook.com
 (2603:10c6:220:201::11) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|CH3PR12MB7500:EE_
X-MS-Office365-Filtering-Correlation-Id: 12ce79aa-405c-4c82-fec0-08dd305917fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WmJVTkY4akZuR0VBa1dIQ0RwOHhPbzlPQ0JrZjJINHhHemNYRlNKWkE0UlRH?=
 =?utf-8?B?UzJGQ0tzV0NiWjFYRGRBZVlVSE0xNVFjZW9ObnduSzIrd2N1M1hXWlUrUkRT?=
 =?utf-8?B?bnBNQ2xKSnRRcGV1UXhHa0ZiNCtQWmN2ZUd1WFZzcUVCSlREVTEvME5teFNs?=
 =?utf-8?B?N0NKT2VWcG5ZYk1UbFRCRUhlc2hkcDNBNjlNNTB2QmJaWUlDZmtaSnZsMkY0?=
 =?utf-8?B?MFVqZjZ2NGx6Y1JNSHpkdjA2V0VBeE5sTGxVU01iS0g2c0pnQkFLVXZpYVF3?=
 =?utf-8?B?by9nbnphS1lIK1Y2cUdUR3M2Q3B3aDd3UkpaRzVFREI0K2JaL0F3TkpZMzBw?=
 =?utf-8?B?SkdYZWlkRjhpd0ZDZVZveTdlYldseFJ5Zm9WY1E3bzdCU3VLV0ZKdk9yS2VB?=
 =?utf-8?B?bDJSUkNjNlVKZkhkZVgvS25BQTRVMzBhdk5DUTFLTE5DcEpOa0hrcFdpOWx6?=
 =?utf-8?B?djRtdlB2aTFTOU9QWjRpUFkrOXl5TGdXazVYaDBJb2ltZ2pLZHdvTklUN1NY?=
 =?utf-8?B?YjZubHNKZlBOdXBubEVRZTNzajNEU3hMMVI0UFBIMURKRjFJTHczRmtjOEFa?=
 =?utf-8?B?REhKdnFrcXczbmxyMHE3K0xHQkVHeXg2bU8wenYwZXBya0Mwa2duRmp5U3p3?=
 =?utf-8?B?ZzQ1TWgyOHFlRllyQUNScGlvdnpoZWZObC8xdGZtUVZqanVQckNGaTlOREsw?=
 =?utf-8?B?VHRhcVdBcUc4ZzlkUmk3V29CZ0VmUUdHbUJyd2JqRlZ2M1pidmsxSktVbnF0?=
 =?utf-8?B?dmIwR3Q1MDRLQ3RIYjN0Nmx6ZFpueXIwQzJEYzVDOTBWWklhejZNUUx3VS9U?=
 =?utf-8?B?V1VKbkhxL0htS0N4UWNDSE1QZERFVlowSHV6ZG9WZ1hOUGI0Z0k2SFhDMDh0?=
 =?utf-8?B?SDRwV2J5Yy9HSHpQeXhtQWFOSXBucmRLNm9vV0FPZ0QrLzVmUVZ6TG15Undi?=
 =?utf-8?B?WU9oMEwyeUxNU3NnYzZsbXhKWmh0UnUyRkVxNW9OWGlMVWx2akNVU1JmMmVN?=
 =?utf-8?B?WnpFUHh6MXNGVG8xTGpPOS9JTEtaZ3g3U2FrVkdaTVBRd2lnTnlJa0wyWE5l?=
 =?utf-8?B?SE5QbmplNmRBTTlFOEVtelhxdzVybW5MVENvTzZnNmRqa0dBSnE0Q2sySTdC?=
 =?utf-8?B?R1VLMUFrTnVqVkRHcjI0Y2tWNU5zRG41VDFsSzZSZ29TVnFMTVZEcXJMcm84?=
 =?utf-8?B?SWxuclJzUkNpb0dXOEQxR2xTMW5LLzRzUTE1eEVVMnhnNmE5NUR4TkYzRFlN?=
 =?utf-8?B?bnBSdTN1aUErbGRUWE1xTWlmTnFyY2YyZDRiWGQyS0tvUFZNbnFtUVpqM24v?=
 =?utf-8?B?QjR0Z0JEVFZ4VnlVbTI4dFROUFJaRFJMa00xK2JZLzBSYWdSOW5tZW4yS2x5?=
 =?utf-8?B?RTBzTU9qajNINWxMejV3R3ltTUwyenZVQ2pjR2NCQ2RHQXArLytyOVNmZ1N5?=
 =?utf-8?B?eTErQVZVamMyQVJJbG1UYno0N0kvSkl3YWhLcDMwd3lqNVJGTTdOb3M5eWFv?=
 =?utf-8?B?TWRtaGtpUVIrK2J6aFNtOWNDNHZlRXJlbGtnTEVmUDlOQWJrbE1uZUVmYzBu?=
 =?utf-8?B?Y2MwVG5zeTV1UFcxQTNNQytaSmpxOU12OHZOOVhWSjJLSkY4cHJtYng2OTJO?=
 =?utf-8?B?eDkyUXlCd1hUSXVLUmtqalI4Ni9ITEtIcHVyMDY4YUQ4L2FjTUV1VzNBcnVo?=
 =?utf-8?B?cTVFOFZKWDZ3QjZncUpHNzNiU2tQQW1ZaTNuNE9MMUJDOEpsZWJYYW9FS1Np?=
 =?utf-8?B?SWw0ck5uaUNWb29UWFVhUlA4L2xvMGU4Tmk5WkhRNHY2czl2VXlVeEI4QlBO?=
 =?utf-8?B?SDRZVUU2NFRONmE2eVhaYUg3TWpmKzFycGpFa1ZVK0tYNnVQUVlXMmQ1L0I5?=
 =?utf-8?Q?ZJO4iNIRr0Sx2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N29RcWtTMXBnTTA4dzYxNFVDQTVqVjB0NDNqSVE2bnFydnlDamdaVWg5UlV0?=
 =?utf-8?B?NER2S3J1ZVNGRWI0SzdadVlOSWREUnA2ZmJXekM4L0R3N1p1dTlWMWliNXN4?=
 =?utf-8?B?djVhZnVyVE02RWppS0E4L2R2T2dGTDhCQlNnTDloelVRWStGTlVaZnpGSFNI?=
 =?utf-8?B?cWEwZmVEaUJhNHptYlVKN0lSYlBBYlhCYlVBbnRPeUJLVHdhbmRmNGpJTXVN?=
 =?utf-8?B?MWoyQjRGTEZjUkZKQXZhd2ZJK1MzQ1hCQm13YzhxSlZrcXlHN2VmU0lCOVIy?=
 =?utf-8?B?VHl2TFNVUnFpWTdkZWkwVGJwSUNkTVMrVnk3MFZqVWh3SGE2ZTdndjEweTFY?=
 =?utf-8?B?UFd0UVZ3eGlFOWwvWlpUZ01BMVVTRFpOSVdOWERVdDVnU1d1bnNsR0lYMTYw?=
 =?utf-8?B?Njh6TlZWWjVVZ3FQRDFJMDk2d2FZSUU0TVd1S2JXUGNEOWh4UmkwTHoxaG5l?=
 =?utf-8?B?b0hLaDRmTHlnTlJhUnNvazNSWFlVYnVWdjl4Rk5iWVU4RS9iY3VQTk9EKzdG?=
 =?utf-8?B?SDhlNGFMY01makk2dCtwUWtleWlCMitsWU9GaDJ4Z05WakN1OW4zTEVUTmZh?=
 =?utf-8?B?ZUg0b2p2K21oT2pXa3pTaXQrdEczc0tlVG1sNytDTWVWcFVsaWhmY05uRkI3?=
 =?utf-8?B?OUx0cnZURGgrOXlyZG1JTkRXUmRkSE02UkZIdkJVTXVJSnR4bDQwSHQyVGcy?=
 =?utf-8?B?VFhNNWNxVE1qeStEZlYvNms1M1hCVk55NWxaRW9Qb05mRGYxWDZJSEErL29h?=
 =?utf-8?B?eTlSY2dyWHprR0tKWEtMZ3lXdkxTcExJVjU2clFEWWxjdW42dlZCM09RekQw?=
 =?utf-8?B?Z2E2QU5qTXdBcXVDd0x6YWsrV3MzaWIyc2k2L0d1cWU3c09ydlVQV2Q5OFJy?=
 =?utf-8?B?cUQrZnpreE5NbTFsbmQ1K1dnNm53L1R6RW1iLzJRWFYyVnVmWkVweHBRbjBE?=
 =?utf-8?B?Z1g3SFZ0VThhcmRGZGtDb2lKTlR0WlJQRDl0U0dEc3lXc1lLNUlpMTRZdUkr?=
 =?utf-8?B?dFhvQUlSemJDRnJUbGI1K3hOK2c0R2xTMS95WjZVN2Z4MWI4UWxva05abVdI?=
 =?utf-8?B?MGw2T21RL1J6WnpmOGVROExHcHBYOHJCWnlKNmNhZzYydzRSSjRmS1JUVG5p?=
 =?utf-8?B?UDlBQUM3a3lqY3dZSldiMDdJdUh1dGd4N29vZGh0bnYxYkwvNnhCTzRkbXl4?=
 =?utf-8?B?V3NyVFFDaGhGQURBTFJSN2RyQ0F0MS9GRVl2M1dNVjFVSzNZSEtqaWFzQUtB?=
 =?utf-8?B?aC9wV3R0dEY0YjlvTnVPUHRjT3VqUlJiSG16UG9idGhBMXhjU1VGQkhtYnNO?=
 =?utf-8?B?QTZrYVA4RVJTenlwWDFXbW1IUHZNU0pUOVcvR2JlRlJwUWhHd0N1Tm5nSlo3?=
 =?utf-8?B?Z1ZwQitkZ0t2Z2NnMW1wdEtpSkJuREUveUpRaTJ5R282S1UzREJDd1BrUGJl?=
 =?utf-8?B?TkZiazUzMFFYNXZsZlZXMjA1dG1raVVTRjJYYURqRmhXQ1ZTU00xUXhOZ0tS?=
 =?utf-8?B?VzRrTG43TE02NG9SUjJJUFErZ1RnUGtYemJtTGV2bGh5ZHZkVWZES0ovazIv?=
 =?utf-8?B?K1hpYTlJRGxOWHNuZzdXc202MEhZL1VhQ296VUt3ZDhzVnVKRkk0K2h2RFlB?=
 =?utf-8?B?cTRDMmN2cnZUR2IweTZMTjI2VTdLTzZYR3V0bTI4QUEyL0Q2TG5XZXJ3clRZ?=
 =?utf-8?B?VVIwRURSdzJYamdHd0FCalNyS2NlS3lBWThwWno4eWJyZTlyY2xzWTZ0SktE?=
 =?utf-8?B?MGdkYWNPNGpIZFB4TzY3dmpQb2pzUzdWZnB1ZG5ERjBqT01pRWNob2IyNXVM?=
 =?utf-8?B?TGVmdW1IY3I1WW1QUWdUZ0lqLzc0TmNRbkR2SUJWWEdOR1EzRERoemZhWUZF?=
 =?utf-8?B?MSthVmtKUzA2a1NvekpwcmxvSmdOc1NEWUN3NjhoRVdCZWlzQmZldUhKcndy?=
 =?utf-8?B?c1dJUFNuV0FLemVyeFNPWE9lMFI0T2dYVVkzalZWdlJ2WlNGbXVsRlFGbFhs?=
 =?utf-8?B?ckswbi9lekw1cVNqVVNyaGdZUDdqcFQyRnRTdU5aa0hwOENvUm5LSHUrMnpp?=
 =?utf-8?B?NGNWSEJCSUg0czhGN2djYm5ybHhmcGZhaDFwcVFnWGZmdGFxUCtSaDdOR09y?=
 =?utf-8?Q?hqWAHTQOe2SJHJ4Cm/xiS/LNv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12ce79aa-405c-4c82-fec0-08dd305917fc
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2025 02:55:37.0525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NjxII7CcXS7/e9RuZBAGUYDAHk3i1Hec2rgPvsoOspIwiLFRc0ili7ziIDcBI8WpymeeXyRlDr1wj4zIv26XSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7500



On 9/1/25 13:11, Chenyi Qiang wrote:
> 
> 
> On 1/8/2025 7:20 PM, Alexey Kardashevskiy wrote:
>>
>>
>> On 8/1/25 21:56, Chenyi Qiang wrote:
>>>
>>>
>>> On 1/8/2025 12:48 PM, Alexey Kardashevskiy wrote:
>>>> On 13/12/24 18:08, Chenyi Qiang wrote:
>>>>> As the commit 852f0048f3 ("RAMBlock: make guest_memfd require
>>>>> uncoordinated discard") highlighted, some subsystems like VFIO might
>>>>> disable ram block discard. However, guest_memfd relies on the discard
>>>>> operation to perform page conversion between private and shared memory.
>>>>> This can lead to stale IOMMU mapping issue when assigning a hardware
>>>>> device to a confidential VM via shared memory (unprotected memory
>>>>> pages). Blocking shared page discard can solve this problem, but it
>>>>> could cause guests to consume twice the memory with VFIO, which is not
>>>>> acceptable in some cases. An alternative solution is to convey other
>>>>> systems like VFIO to refresh its outdated IOMMU mappings.
>>>>>
>>>>> RamDiscardManager is an existing concept (used by virtio-mem) to adjust
>>>>> VFIO mappings in relation to VM page assignment. Effectively page
>>>>> conversion is similar to hot-removing a page in one mode and adding it
>>>>> back in the other, so the similar work that needs to happen in response
>>>>> to virtio-mem changes needs to happen for page conversion events.
>>>>> Introduce the RamDiscardManager to guest_memfd to achieve it.
>>>>>
>>>>> However, guest_memfd is not an object so it cannot directly implement
>>>>> the RamDiscardManager interface.
>>>>>
>>>>> One solution is to implement the interface in HostMemoryBackend. Any
>>>>
>>>> This sounds about right.
>>>>
>>>>> guest_memfd-backed host memory backend can register itself in the
>>>>> target
>>>>> MemoryRegion. However, this solution doesn't cover the scenario where a
>>>>> guest_memfd MemoryRegion doesn't belong to the HostMemoryBackend, e.g.
>>>>> the virtual BIOS MemoryRegion.
>>>>
>>>> What is this virtual BIOS MemoryRegion exactly? What does it look like
>>>> in "info mtree -f"? Do we really want this memory to be DMAable?
>>>
>>> virtual BIOS shows in a separate region:
>>>
>>>    Root memory region: system
>>>     0000000000000000-000000007fffffff (prio 0, ram): pc.ram KVM
>>>     ...
>>>     00000000ffc00000-00000000ffffffff (prio 0, ram): pc.bios KVM
>>
>> Looks like a normal MR which can be backed by guest_memfd.
> 
> Yes, virtual BIOS memory region is initialized by
> memory_region_init_ram_guest_memfd() which will be backed by a guest_memfd.
> 
> The tricky thing is, for Intel TDX (not sure about AMD SEV), the virtual
> BIOS image will be loaded and then copied to private region.
> After that,
> the loaded image will be discarded and this region become useless.

I'd think it is loaded as "struct Rom" and then copied to the 
MR-ram_guest_memfd() which does not leave MR useless - we still see 
"pc.bios" in the list so it is not discarded. What piece of code are you 
referring to exactly?


> So I
> feel like this virtual BIOS should not be backed by guest_memfd?

 From the above it sounds like the opposite, i.e. it should :)

>>
>>>     0000000100000000-000000017fffffff (prio 0, ram): pc.ram
>>> @0000000080000000 KVM
>>
>> Anyway if there is no guest_memfd backing it and
>> memory_region_has_ram_discard_manager() returns false, then the MR is
>> just going to be mapped for VFIO as usual which seems... alright, right?
> 
> Correct. As the vBIOS is backed by guest_memfd and we implement the RDM
> for guest_memfd_manager, the vBIOS MR won't be mapped by VFIO.
> 
> If we go with the HostMemoryBackend instead of guest_memfd_manager, this
> MR would be mapped by VFIO. Maybe need to avoid such vBIOS mapping, or
> just ignore it since the MR is useless (but looks not so good).

Sorry I am missing necessary details here, let's figure out the above.

> 
>>
>>
>>> We also consider to implement the interface in HostMemoryBackend, but
>>> maybe implement with guest_memfd region is more general. We don't know
>>> if any DMAable memory would belong to HostMemoryBackend although at
>>> present it is.
>>>
>>> If it is more appropriate to implement it with HostMemoryBackend, I can
>>> change to this way.
>>
>> Seems cleaner imho.
> 
> I can go this way.
> 
>>
>>>>
>>>>
>>>>> Thus, choose the second option, i.e. define an object type named
>>>>> guest_memfd_manager with RamDiscardManager interface. Upon creation of
>>>>> guest_memfd, a new guest_memfd_manager object can be instantiated and
>>>>> registered to the managed guest_memfd MemoryRegion to handle the page
>>>>> conversion events.
>>>>>
>>>>> In the context of guest_memfd, the discarded state signifies that the
>>>>> page is private, while the populated state indicated that the page is
>>>>> shared. The state of the memory is tracked at the granularity of the
>>>>> host page size (i.e. block_size), as the minimum conversion size can be
>>>>> one page per request.
>>>>>
>>>>> In addition, VFIO expects the DMA mapping for a specific iova to be
>>>>> mapped and unmapped with the same granularity. However, the
>>>>> confidential
>>>>> VMs may do partial conversion, e.g. conversion happens on a small
>>>>> region
>>>>> within a large region. To prevent such invalid cases and before any
>>>>> potential optimization comes out, all operations are performed with 4K
>>>>> granularity.
>>>>>
>>>>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>>>> ---
>>>>>     include/sysemu/guest-memfd-manager.h |  46 +++++
>>>>>     system/guest-memfd-manager.c         | 250 ++++++++++++++++++++++
>>>>> +++++
>>>>>     system/meson.build                   |   1 +
>>>>>     3 files changed, 297 insertions(+)
>>>>>     create mode 100644 include/sysemu/guest-memfd-manager.h
>>>>>     create mode 100644 system/guest-memfd-manager.c
>>>>>
>>>>> diff --git a/include/sysemu/guest-memfd-manager.h b/include/sysemu/
>>>>> guest-memfd-manager.h
>>>>> new file mode 100644
>>>>> index 0000000000..ba4a99b614
>>>>> --- /dev/null
>>>>> +++ b/include/sysemu/guest-memfd-manager.h
>>>>> @@ -0,0 +1,46 @@
>>>>> +/*
>>>>> + * QEMU guest memfd manager
>>>>> + *
>>>>> + * Copyright Intel
>>>>> + *
>>>>> + * Author:
>>>>> + *      Chenyi Qiang <chenyi.qiang@intel.com>
>>>>> + *
>>>>> + * This work is licensed under the terms of the GNU GPL, version 2 or
>>>>> later.
>>>>> + * See the COPYING file in the top-level directory
>>>>> + *
>>>>> + */
>>>>> +
>>>>> +#ifndef SYSEMU_GUEST_MEMFD_MANAGER_H
>>>>> +#define SYSEMU_GUEST_MEMFD_MANAGER_H
>>>>> +
>>>>> +#include "sysemu/hostmem.h"
>>>>> +
>>>>> +#define TYPE_GUEST_MEMFD_MANAGER "guest-memfd-manager"
>>>>> +
>>>>> +OBJECT_DECLARE_TYPE(GuestMemfdManager, GuestMemfdManagerClass,
>>>>> GUEST_MEMFD_MANAGER)
>>>>> +
>>>>> +struct GuestMemfdManager {
>>>>> +    Object parent;
>>>>> +
>>>>> +    /* Managed memory region. */
>>>>
>>>> Do not need this comment. And the period.
>>>
>>> [...]
>>>
>>>>
>>>>> +    MemoryRegion *mr;
>>>>> +
>>>>> +    /*
>>>>> +     * 1-setting of the bit represents the memory is populated
>>>>> (shared).
>>>>> +     */
>>>
>>> Will fix it.
>>>
>>>>
>>>> Could be 1 line comment.
>>>>
>>>>> +    int32_t bitmap_size;
>>>>
>>>> int or unsigned
>>>>
>>>>> +    unsigned long *bitmap;
>>>>> +
>>>>> +    /* block size and alignment */
>>>>> +    uint64_t block_size;
>>>>
>>>> unsigned?
>>>>
>>>> (u)int(32|64)_t make sense for migrations which is not the case (yet?).
>>>> Thanks,
>>>
>>> I think these fields would be helpful for future migration support.
>>> Maybe defining as this way is more straightforward.
>>>
>>>>
>>>>> +
>>>>> +    /* listeners to notify on populate/discard activity. */
>>>>
>>>> Do not really need this comment either imho.
>>>>
>>>
>>> I prefer to provide the comment for each field as virtio-mem do. If it
>>> is not necessary, I would remove those obvious ones.
>>
>> [bikeshedding on] But the "RamDiscardListener" word says that already,
>> why repeating? :) It should add information, not duplicate. Like the
>> block_size comment which mentions "alignment" [bikeshedding off]
> 
> Got it. Thanks!
> 
>>
>>>>> +    QLIST_HEAD(, RamDiscardListener) rdl_list;
>>>>> +};
>>>>> +
>>>>> +struct GuestMemfdManagerClass {
>>>>> +    ObjectClass parent_class;
>>>>> +};
>>>>> +
>>>>> +#endif
>>>
>>> [...]
>>>
>>>              void *arg,
>>>>> +
>>>>> guest_memfd_section_cb cb)
>>>>> +{
>>>>> +    unsigned long first_one_bit, last_one_bit;
>>>>> +    uint64_t offset, size;
>>>>> +    int ret = 0;
>>>>> +
>>>>> +    first_one_bit = section->offset_within_region / gmm->block_size;
>>>>> +    first_one_bit = find_next_bit(gmm->bitmap, gmm->bitmap_size,
>>>>> first_one_bit);
>>>>> +
>>>>> +    while (first_one_bit < gmm->bitmap_size) {
>>>>> +        MemoryRegionSection tmp = *section;
>>>>> +
>>>>> +        offset = first_one_bit * gmm->block_size;
>>>>> +        last_one_bit = find_next_zero_bit(gmm->bitmap, gmm-
>>>>>> bitmap_size,
>>>>> +                                          first_one_bit + 1) - 1;
>>>>> +        size = (last_one_bit - first_one_bit + 1) * gmm->block_size;
>>>>
>>>> This tries calling cb() on bigger chunks even though we say from the
>>>> beginning that only page size is supported?
>>>>
>>>> May be simplify this for now and extend if/when VFIO learns to split
>>>> mappings,  or  just drop it when we get in-place page state convertion
>>>> (which will make this all irrelevant)?
>>>
>>> The cb() will call with big chunks but actually it do the split with the
>>> granularity of block_size in the cb(). See the
>>> vfio_ram_discard_notify_populate(), which do the DMA_MAP with
>>> granularity size.
>>
>>
>> Right, and this all happens inside QEMU - first the code finds bigger
>> chunks and then it splits them anyway to call the VFIO driver. Seems
>> pointless to bother about bigger chunks here.
>>
>>>
>>>>
>>>>
>>>>> +
>>>>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>>>>> size)) {
>>>>> +            break;
>>>>> +        }
>>>>> +
>>>>> +        ret = cb(&tmp, arg);
>>>>> +        if (ret) {
>>>>> +            break;
>>>>> +        }
>>>>> +
>>>>> +        first_one_bit = find_next_bit(gmm->bitmap, gmm->bitmap_size,
>>>>> +                                      last_one_bit + 2);
>>>>> +    }
>>>>> +
>>>>> +    return ret;
>>>>> +}
>>>>> +
>>>>> +static int guest_memfd_for_each_discarded_section(const
>>>>> GuestMemfdManager *gmm,
>>>>> +                                                  MemoryRegionSection
>>>>> *section,
>>>>> +                                                  void *arg,
>>>>> +
>>>>> guest_memfd_section_cb cb)
>>>>> +{
>>>>> +    unsigned long first_zero_bit, last_zero_bit;
>>>>> +    uint64_t offset, size;
>>>>> +    int ret = 0;
>>>>> +
>>>>> +    first_zero_bit = section->offset_within_region / gmm->block_size;
>>>>> +    first_zero_bit = find_next_zero_bit(gmm->bitmap, gmm->bitmap_size,
>>>>> +                                        first_zero_bit);
>>>>> +
>>>>> +    while (first_zero_bit < gmm->bitmap_size) {
>>>>> +        MemoryRegionSection tmp = *section;
>>>>> +
>>>>> +        offset = first_zero_bit * gmm->block_size;
>>>>> +        last_zero_bit = find_next_bit(gmm->bitmap, gmm->bitmap_size,
>>>>> +                                      first_zero_bit + 1) - 1;
>>>>> +        size = (last_zero_bit - first_zero_bit + 1) * gmm->block_size;
>>>>> +
>>>>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>>>>> size)) {
>>>>> +            break;
>>>>> +        }
>>>>> +
>>>>> +        ret = cb(&tmp, arg);
>>>>> +        if (ret) {
>>>>> +            break;
>>>>> +        }
>>>>> +
>>>>> +        first_zero_bit = find_next_zero_bit(gmm->bitmap, gmm-
>>>>>> bitmap_size,
>>>>> +                                            last_zero_bit + 2);
>>>>> +    }
>>>>> +
>>>>> +    return ret;
>>>>> +}
>>>>> +
>>>>> +static uint64_t guest_memfd_rdm_get_min_granularity(const
>>>>> RamDiscardManager *rdm,
>>>>> +                                                    const
>>>>> MemoryRegion *mr)
>>>>> +{
>>>>> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
>>>>> +
>>>>> +    g_assert(mr == gmm->mr);
>>>>> +    return gmm->block_size;
>>>>> +}
>>>>> +
>>>>> +static void guest_memfd_rdm_register_listener(RamDiscardManager *rdm,
>>>>> +                                              RamDiscardListener *rdl,
>>>>> +                                              MemoryRegionSection
>>>>> *section)
>>>>> +{
>>>>> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
>>>>> +    int ret;
>>>>> +
>>>>> +    g_assert(section->mr == gmm->mr);
>>>>> +    rdl->section = memory_region_section_new_copy(section);
>>>>> +
>>>>> +    QLIST_INSERT_HEAD(&gmm->rdl_list, rdl, next);
>>>>> +
>>>>> +    ret = guest_memfd_for_each_populated_section(gmm, section, rdl,
>>>>> +
>>>>> guest_memfd_notify_populate_cb);
>>>>> +    if (ret) {
>>>>> +        error_report("%s: Failed to register RAM discard listener:
>>>>> %s", __func__,
>>>>> +                     strerror(-ret));
>>>>> +    }
>>>>> +}
>>>>> +
>>>>> +static void guest_memfd_rdm_unregister_listener(RamDiscardManager
>>>>> *rdm,
>>>>> +                                                RamDiscardListener
>>>>> *rdl)
>>>>> +{
>>>>> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
>>>>> +    int ret;
>>>>> +
>>>>> +    g_assert(rdl->section);
>>>>> +    g_assert(rdl->section->mr == gmm->mr);
>>>>> +
>>>>> +    ret = guest_memfd_for_each_populated_section(gmm, rdl->section,
>>>>> rdl,
>>>>> +
>>>>> guest_memfd_notify_discard_cb);
>>>>> +    if (ret) {
>>>>> +        error_report("%s: Failed to unregister RAM discard listener:
>>>>> %s", __func__,
>>>>> +                     strerror(-ret));
>>>>> +    }
>>>>> +
>>>>> +    memory_region_section_free_copy(rdl->section);
>>>>> +    rdl->section = NULL;
>>>>> +    QLIST_REMOVE(rdl, next);
>>>>> +
>>>>> +}
>>>>> +
>>>>> +typedef struct GuestMemfdReplayData {
>>>>> +    void *fn;
>>>>
>>>> s/void */ReplayRamPopulate/
>>>
>>> [...]
>>>
>>>>
>>>>> +    void *opaque;
>>>>> +} GuestMemfdReplayData;
>>>>> +
>>>>> +static int guest_memfd_rdm_replay_populated_cb(MemoryRegionSection
>>>>> *section, void *arg)
>>>>> +{
>>>>> +    struct GuestMemfdReplayData *data = arg;
>>>>
>>>> Drop "struct" here and below.
>>>
>>> Fixed. Thanks!
>>>
>>>>
>>>>> +    ReplayRamPopulate replay_fn = data->fn;
>>>>> +
>>>>> +    return replay_fn(section, data->opaque);
>>>>> +}
>>>>> +
>>>>> +static int guest_memfd_rdm_replay_populated(const RamDiscardManager
>>>>> *rdm,
>>>>> +                                            MemoryRegionSection
>>>>> *section,
>>>>> +                                            ReplayRamPopulate
>>>>> replay_fn,
>>>>> +                                            void *opaque)
>>>>> +{
>>>>> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
>>>>> +    struct GuestMemfdReplayData data = { .fn = replay_fn, .opaque =
>>>>> opaque };
>>>>> +
>>>>> +    g_assert(section->mr == gmm->mr);
>>>>> +    return guest_memfd_for_each_populated_section(gmm, section, &data,
>>>>> +
>>>>> guest_memfd_rdm_replay_populated_cb);
>>>>> +}
>>>>> +
>>>>> +static int guest_memfd_rdm_replay_discarded_cb(MemoryRegionSection
>>>>> *section, void *arg)
>>>>> +{
>>>>> +    struct GuestMemfdReplayData *data = arg;
>>>>> +    ReplayRamDiscard replay_fn = data->fn;
>>>>> +
>>>>> +    replay_fn(section, data->opaque);
>>>>
>>>>
>>>> guest_memfd_rdm_replay_populated_cb() checks for errors though.
>>>
>>> It follows current definiton of ReplayRamDiscard() and
>>> ReplayRamPopulate() where replay_discard() doesn't return errors and
>>> replay_populate() returns errors.
>>
>> A trace would be appropriate imho. Thanks,
> 
> Sorry, can't catch you. What kind of info to be traced? The errors
> returned by replay_populate()?

Yeah. imho these are useful as we expect this part to work in general 
too, right? Thanks,

> 
>>
>>>>
>>>>> +
>>>>> +    return 0;
>>>>> +}
>>>>> +
>>>>> +static void guest_memfd_rdm_replay_discarded(const RamDiscardManager
>>>>> *rdm,
>>>>> +                                             MemoryRegionSection
>>>>> *section,
>>>>> +                                             ReplayRamDiscard
>>>>> replay_fn,
>>>>> +                                             void *opaque)
>>>>> +{
>>>>> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
>>>>> +    struct GuestMemfdReplayData data = { .fn = replay_fn, .opaque =
>>>>> opaque };
>>>>> +
>>>>> +    g_assert(section->mr == gmm->mr);
>>>>> +    guest_memfd_for_each_discarded_section(gmm, section, &data,
>>>>> +
>>>>> guest_memfd_rdm_replay_discarded_cb);
>>>>> +}
>>>>> +
>>>>> +static void guest_memfd_manager_init(Object *obj)
>>>>> +{
>>>>> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(obj);
>>>>> +
>>>>> +    QLIST_INIT(&gmm->rdl_list);
>>>>> +}
>>>>> +
>>>>> +static void guest_memfd_manager_finalize(Object *obj)
>>>>> +{
>>>>> +    g_free(GUEST_MEMFD_MANAGER(obj)->bitmap);
>>>>
>>>>
>>>> bitmap is not allocated though. And 5/7 removes this anyway. Thanks,
>>>
>>> Will remove it. Thanks.
>>>
>>>>
>>>>
>>>>> +}
>>>>> +
>>>>> +static void guest_memfd_manager_class_init(ObjectClass *oc, void
>>>>> *data)
>>>>> +{
>>>>> +    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(oc);
>>>>> +
>>>>> +    rdmc->get_min_granularity = guest_memfd_rdm_get_min_granularity;
>>>>> +    rdmc->register_listener = guest_memfd_rdm_register_listener;
>>>>> +    rdmc->unregister_listener = guest_memfd_rdm_unregister_listener;
>>>>> +    rdmc->is_populated = guest_memfd_rdm_is_populated;
>>>>> +    rdmc->replay_populated = guest_memfd_rdm_replay_populated;
>>>>> +    rdmc->replay_discarded = guest_memfd_rdm_replay_discarded;
>>>>> +}
>>>>> diff --git a/system/meson.build b/system/meson.build
>>>>> index 4952f4b2c7..ed4e1137bd 100644
>>>>> --- a/system/meson.build
>>>>> +++ b/system/meson.build
>>>>> @@ -15,6 +15,7 @@ system_ss.add(files(
>>>>>       'dirtylimit.c',
>>>>>       'dma-helpers.c',
>>>>>       'globals.c',
>>>>> +  'guest-memfd-manager.c',
>>>>>       'memory_mapping.c',
>>>>>       'qdev-monitor.c',
>>>>>       'qtest.c',
>>>>
>>>
>>
> 

-- 
Alexey


