Return-Path: <kvm+bounces-36719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F0492A20321
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 03:03:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 15B931885A0C
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 02:03:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6962B13F43A;
	Tue, 28 Jan 2025 02:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tSudkl68"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2077.outbound.protection.outlook.com [40.107.223.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE22ABE40;
	Tue, 28 Jan 2025 02:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738029821; cv=fail; b=ooaxTqZi3QJW8aiB++DhngyW75GTur1jurV6K4iyl8sO2qxDPwCum0NNdwGjCRztopF55WxYfkZkhq8KSM+6lNkBT/YbCUP/5ntk8i1AZbZup7Zaa8F6LhTaLvTUeG0Q0s8GyU30hI4uJ1RU0fPPyP+UBNaLwuT6lhCUOJ5qMe4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738029821; c=relaxed/simple;
	bh=APi45BwXIclLvOLFgun56yZUiSDZP8hO1ErDiJsPK0Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RnhatnVjiQAGeJkfZH5aVJjI9byfm50pG4rpE6G3zHHfe3jSSgxKg7LhJ4dbJ7KJhd4FywQvCBk9K5XZjSMusx9EpSOyGw230IqWrBRkV9avjY4Y+K/pL+Ilw17OjnNbQHjmfoCXqnVBRtRYV6RJUgKJp/GMuUozRt7ngxZWXSQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tSudkl68; arc=fail smtp.client-ip=40.107.223.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y0BdaqOe1dISDT5tROIA2FCqRoDZUlQSbckGfRKL3ToU3U3/v+OLYzDuOKy1kxrR6sVLPe6Kgz3NmBeJ16ydV6JIQnkmvUAIHdw2Zs56Kk1nZHmzo4Pwp4M4AqoPGQYbsdf6nIZpIGVePTguCfpNJg9znypffb9QKmZAzcnV23+CN4uKw1p+3K/q8/aV/PMNfD8NOyApKfMBMpTLkk8It9HMb6EOYkJhjJKFADX7Si7LoigAaImkCzv9m7xiScM8fQKQxzpC/9c3K4c9OSOzitD5i0Sv1qir2OjtXe1r6seQnapMB5f/Ip1Hv55vAHfkdO+ruIK1Ux3OMCo3VQFLZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=APi45BwXIclLvOLFgun56yZUiSDZP8hO1ErDiJsPK0Y=;
 b=vjmri9vNPcxI4UVtt3TCuyn+Ks2akys91u2acAzmLu5VGPMx+3YeTMfRgcQ8Y1rSDjC/gFfTIRD+MRaE5oIt3Rgyz9V/Ok7oJsjhVtODY9eJ4F7volqjztSyczVWikdULe2qJhNsKZvJ2n8ocCs+NOcp1jFMlhWSPLwkes+9IIVYlp03R7PKiI79IpJqD9+/4UpA7C2YiD6IegvPYfg1+IT0WMP2An9uBqmz+GN3yCNJdoMXLRY7UhLyRjA0lHy1WaFmJUZTy8BW0TxEOB1qOZt9qs38G2ryHW25IdX6mXeVA/2FNySVnL9rt/onsLeOCpJOs1U7ah9hAq5rV+vfpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=APi45BwXIclLvOLFgun56yZUiSDZP8hO1ErDiJsPK0Y=;
 b=tSudkl682Oe8CTQVuF0Qm9d/IlCw7wQJYOV7qSGK8S47BkpngMGOUvBf0/RPOx0DPBhCVlqFF7lqjNdCWoJCdghnVhgxpXQRB3GU1JFF9lqqYMOrCjhWAMNW01wi4MMOHtMFBy0Ssam18d0EqKYZxQYR6d5wLB8cz/h3Gcn8ncnUNGTYBBdUa3IeYKihssd8zUTC9HBCzkKJWQW/nkTvTogBoe6LCOEH5PGbSJxOsXkQggwQDHHN/Y6WT2MZOvtQxvTLsv4a6c+QB5r0KfqceSqnuU2T/IX+7ZCtdqeNwI9yOl9wQmDJn5Dm45lRrP/wJ1bPMOCjVibbRwIdqlRg0g==
Received: from MW6PR12MB8897.namprd12.prod.outlook.com (2603:10b6:303:24a::19)
 by DS0PR12MB9273.namprd12.prod.outlook.com (2603:10b6:8:193::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.21; Tue, 28 Jan
 2025 02:03:37 +0000
Received: from MW6PR12MB8897.namprd12.prod.outlook.com
 ([fe80::7c55:5a45:be80:e971]) by MW6PR12MB8897.namprd12.prod.outlook.com
 ([fe80::7c55:5a45:be80:e971%3]) with mapi id 15.20.8377.021; Tue, 28 Jan 2025
 02:03:37 +0000
From: Matt Ochs <mochs@nvidia.com>
To: Ankit Agrawal <ankita@nvidia.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, Alex Williamson
	<alex.williamson@redhat.com>, Yishai Hadas <yishaih@nvidia.com>, Shameerali
 Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Kevin Tian
	<kevin.tian@intel.com>, Zhi Wang <zhiw@nvidia.com>, Aniket Agashe
	<aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, Vikram
 Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>, Alistair Popple
	<apopple@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Dan Williams
	<danw@nvidia.com>, Krishnakant Jaju <kjaju@nvidia.com>, Uday Dhoke
	<udhoke@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>, Nandini De
	<nandinid@nvidia.com>, "Anuj Aggarwal (SW-GPU)" <anuaggarwal@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 0/4] vfio/nvgrace-gpu: Enable grace blackwell boards
Thread-Topic: [PATCH v6 0/4] vfio/nvgrace-gpu: Enable grace blackwell boards
Thread-Index: AQHbbo41siVgEeNBAEGHPuQOPME6lrMrdISA
Date: Tue, 28 Jan 2025 02:03:36 +0000
Message-ID: <2AF42909-144F-4864-BC87-64905AA0FA04@nvidia.com>
References: <20250124183102.3976-1-ankita@nvidia.com>
In-Reply-To: <20250124183102.3976-1-ankita@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW6PR12MB8897:EE_|DS0PR12MB9273:EE_
x-ms-office365-filtering-correlation-id: c3c4e6c9-8a55-4d02-ce47-08dd3f3ffa3d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?aFVpUnZOTTkwaWpaM2R3TW9mUURTczZkT1owckNnck5SU0FEYjJ1a3Z5ZDBE?=
 =?utf-8?B?RXk4NERPMUxEdWlMaldzaXg0YzRsR09iSUFldUhuZzBlOG0yMDEyL1lldjF6?=
 =?utf-8?B?QUhLTGl4ak1TUkNpdG4veWVWUWE3SWo4T3l4QXhDZkY4TTYvTmgxWUNSOEkv?=
 =?utf-8?B?cGdTVGRNalczNVVpTDd6aE9wd0NXTjV6dFR6ZW5DcG1CdHhBRXdoN3Q4dElq?=
 =?utf-8?B?MThhMXhMWHdydkNBK1FaN0gzSVdlS3JZZWZyR0FOVnNNYzV3Z1ZkWkVPVWFu?=
 =?utf-8?B?RVFSN29peWI1SW5JNm1tRkhIdSt2RFhwb29yZ0VER0xLLzdSeFhKMHVBZXlX?=
 =?utf-8?B?VTV3Mm44R21WZGNUU3FwU2hIcHIxL2lWcmQ0Y05ENTVseG5XdU9DNVhPRGNX?=
 =?utf-8?B?N0x3Zk5wcmVwVjEwbmxzNjZXMVBJK2JzUWJjOEh5OFh4TFRDRGNQOGhzbUlY?=
 =?utf-8?B?VE9SYU9MTGF0Y0RjV00zdGFFT0VlaGQ2TThCN25aa1pWdzRra1NkdDh1RWwr?=
 =?utf-8?B?Tmp0Mjl6UUcwMHFCRkZtdXY3TWRKcEZjVXZVZUo1Y2gvYnlFVHdjL1Rxbm1p?=
 =?utf-8?B?YkdPeDM4V0pMeEFsQUZrN3d6NHE0bEpPY04zVzVMY25rN09SeTRDMlJIaDR1?=
 =?utf-8?B?cTliMzRKSGs5SnlqU29Udy9wSGFMclUvOTMyRjlNbE8vbXIwYnB6eVBRanFC?=
 =?utf-8?B?cFExUXFJbnlWVThJWnV4OWxKRUNxZHg5end2K0ZmQkRJMGhHU0pRQlVicXU2?=
 =?utf-8?B?dC9XVzRMSDA3Z1hXTFZvKzI1ZG8vS0t5ZTZTMUdsQUdRemZkOVNSdnduZkh3?=
 =?utf-8?B?R2czaWF4RTN2UWozMndqS3RDK0I0dHBmZWc4NmliblpaV0p5K1hEYzZZbHpR?=
 =?utf-8?B?MkdxNElpTUNqMkNycVJjZ0lCdlVlOEFNMVFZcU1VdDEvVjEyNHVWUzFYSEx0?=
 =?utf-8?B?ZjlIRjJ0V0RYYWowVVhtaDlkTUx2ZWxJMmU4TVZ0Y0duVTc5SjFCSzR0Z2pP?=
 =?utf-8?B?TW5UUkVXNUxEYTViZURMN29DV3NFek1obm01Q1U1WTBzR1VNSTAxK21Wdlo5?=
 =?utf-8?B?Ujh1T2c5ckZNYzZHZnh2MjZodzE4aHd5UHVScjRqLzU3cXBKejVCS0lIM1hh?=
 =?utf-8?B?Uko0NGZmZHRMVFFUSTlVejRwbnBNdzBteVd4V25UVldGRit3bDVSQ3pIUnIv?=
 =?utf-8?B?ZWZMZnJTRGptZHZzYmNqUHZDeVJkaG9nYzVMVUttb2lRUFlLMktsRGczcW1j?=
 =?utf-8?B?eE5kM21NMHNibFprWVMzSXV4a2tjdzlYT3pNbHhqOHRLYk1VMWhET3FsZXh4?=
 =?utf-8?B?aWNrbDRtTWlnWnpmWk4xM1FaVmlpNlAwN09nTE5INUxBL0pvdDZNSGtGV2NR?=
 =?utf-8?B?QnMvYlpRSGNyelRLVDJZRFN0SDdCYkh0bFhlZkFkb3FCYVJxS29Mejl6UFhM?=
 =?utf-8?B?QUdqVWs3WWZuRkx6RmtPVUNPZUhVblZuUFAwek9lLzgvd1RMZ3htZnRYdWc2?=
 =?utf-8?B?bUM4YzRoRWpTT0hGR1BmOFhIc0Z0Q1Jhc0dtRjRkRnhUcXphekJlZ1dWaDlu?=
 =?utf-8?B?bFRvZ1lxSVgya2xiNnlCK2tjT0NkZTFxVFd1elRocU8zdFRZTlovRE1YVTJl?=
 =?utf-8?B?bXF3c1hlVFRpOGU3Y05YZnVFT3JkUlU0NkdWNThXbEhnRDVXOTRQeFo3QXNk?=
 =?utf-8?B?VER5TEkxMUx5bVdDN1dWK21vYk1tM3R0K21qcHNQRjhNNiszeXI5MlgzWmxy?=
 =?utf-8?B?UVJBelRHVERVVnplV2NMM0lMbk56UXQrVTdHNkpGdWN3RXVBRS9pRndDQXhz?=
 =?utf-8?B?MURSZkJsSjZ3VzlBb0VYcDBteGlLOWZuYzd4N2lpeW1wNWhER1VKMVYyK1Zn?=
 =?utf-8?B?N0VaOVpKRHF2YzJqdVZmeElWTHAra3dFMWVoZnhBYkZlNzNnOExaOTBSVTR3?=
 =?utf-8?Q?YCkzvSachRhpYIsayB8pfO6mrM/GMkix?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB8897.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MFhsc05aVXF0ZzRaZDd5RlVyVkE2enhPRUNLVGZGZVQ1YTJUdFdGNXk4WStH?=
 =?utf-8?B?OGdlZnJhN21iazZkZ3lLODlpdmdTZmZSbFBPWXJFZFQ1MUl1NWpxWDAwbitU?=
 =?utf-8?B?bVc3NzNVS1dsVm5PdmpGS2t3Y3I1elk5OUNvM0RzTzJWMGcvVXM2K0wvUmcr?=
 =?utf-8?B?VnRZdWVIYmFuOW9zcnJXY0RlVExqc0hoQ1ZtU2RucGhYejAzeXZheGhvSks3?=
 =?utf-8?B?dEpGbTVleHhTbmt1UldXajlTYjZ6UUpFMVJTZnQ3UGNUNkVMc29OUGhlbWQ5?=
 =?utf-8?B?ZXY4dDRXa09qTzlGdFRMVzBPUTlQZ21Mdk5uSkltelc1M2psMGU2M3ZGU1BM?=
 =?utf-8?B?WHYzbkFzWkMwemFSbjdVb3BYcGlPU2YraFFqa2IzNDJQeTE2d2wweDVBUncw?=
 =?utf-8?B?UUQ5VmRpMnhuZENRTXVqTXBUUi9wazZBcVIxTUFTNTIxZGJ4ZUIwMEdYRk5r?=
 =?utf-8?B?MmxySVBySFloaVRWWWY0ek9jbGNzTXU5dG9qSFdZZVBuYUkyTURSUE9KV3lm?=
 =?utf-8?B?Um1aaXVocnY4bHFQeS9wL3VpZlFNSU1aMWsrOVBuL3FHVUdpdDczNnZObVh6?=
 =?utf-8?B?OGtVS2E5QWdONDJsd0RNWTdvVkZ4L1lpVnErdWVmMXRMRWtqVEtXREZJYUow?=
 =?utf-8?B?cURRSTZLQnd2MncycEJpWkswbGZtQXZ2dUFiUmp4Rm9QS09jWU5MUHYwWlZO?=
 =?utf-8?B?SlRNT2duaDVJaGFLRWMxQW4rUUtTbm44TFZkMU50ZTNNV2JRYVVKcG9odnpi?=
 =?utf-8?B?K1Brb0JEVmhvV3JSVVVNdE82VEVyYTVlOWxpdUJ0QS8xTzVjT0dpbGsyR2NC?=
 =?utf-8?B?Wjl4ajIzM2hveVE0N1NPcEVsS3Q3VkF5a0pqY1VTSklDQnFwK2lBVG9zanp0?=
 =?utf-8?B?bXR1N2RUNnRhMHJJeWRaVVV2dWNNcWt1bjFZaVgzbHR0QXlnT1JOL01jQjFr?=
 =?utf-8?B?bk9nUmtjY216bkc2cVRYVmdMMjl4RUpCbVAzeFpheWh5VkpVZXloZXphYUE4?=
 =?utf-8?B?WkMrM0MxZkNRZ3pKcG5VbjJVbkJsbkljem9qOWZwdWdyMjVsQWdxbTZZV1FW?=
 =?utf-8?B?MlVMTzJFakdOaFZQRW5YSzArN1dZbEFjTnJqYU1mRFhIWk5kOHEzQ0w3RW1l?=
 =?utf-8?B?bDZtU0NOTEwrVWE3eG9sbVJpdDdNVmxDaUk2endyR3ZERnZ1aklZRGRwOVVr?=
 =?utf-8?B?MG8yRkMwZDEra2U3SmtUS0Q1UGtuaE10eWxiV1pOcWs2eW9XSmxNMDJ3QXB0?=
 =?utf-8?B?Nmc3UllibWpKSmtyVXZ0OTV4U3JLc2RieDZOQjNpSzJDejhWV2xXN2NsS21u?=
 =?utf-8?B?dXQ0aEp4VDhXM3o1bDNUVmtodkhmZ0o5Z1puRFg3OU43SEdMSTVoWWxFMFNJ?=
 =?utf-8?B?WlUwRWZTS0F6bGR0bVVyOWtMNiszRHk0bXFSeU91K0h0VGV0S1REWGY2dHNp?=
 =?utf-8?B?YWZYQXk4MThKVzV3ZFRDTHVSS2VDK2pFdk93a1NBTm9iN2x5Z3dHT09VeUsz?=
 =?utf-8?B?aU44cDBpdFlnQzBMRHFzNGRSVG91T0R4MTgvOFJrL3gwL1RaTVlicVdqUHhv?=
 =?utf-8?B?clFXamR5S0ErM1o5TjM2cEhWa2d6Qmx1R29MYjlXeEVkYmtORWVWL1FZRXNF?=
 =?utf-8?B?NkFpeDBzbTl2MWo5NGlWaUhTcXNGQUNURkFCdGNkamNYL3hzWEp6MC8rZFVC?=
 =?utf-8?B?aFRsUEhMcW1Wa2RKUmU4QnBvQ2FEVFN1SEI0UVpvOE0vWE5WbTdrYTRKQ1hz?=
 =?utf-8?B?bTZJNCt6OGJKVWh1eE5WTXRPQUVPQ1VwZDBaeGdUQVJpN3d1K2c1cG5jWU5q?=
 =?utf-8?B?cmIycWFPVzlSSWNhZWdHTFFMZW0xWUxwY3l2WnEzOHJ1c1h3UUgyOWh1UTJG?=
 =?utf-8?B?aFJPaTNQdFpWSkh6cGozVkJOc0k2T0w4MjkrR2JWMVdHSzlTMGVZeWwzOUQ1?=
 =?utf-8?B?czAzRmJ0YkVQTjFueE80Tmp4aFN0Zk1ydGpySEVQUDg4OG1RN1VWMFYvY2NO?=
 =?utf-8?B?TGV5d2g2UGZEL2owU3Jwdk16VExkelFMa2pPZUNrK0R4RkR1SjVoTVNXVkhR?=
 =?utf-8?B?Y0hCQUtwUkhiQVN0TjVaK1NHZWRaclFJZkpvWXVlV0c0eVVoWHZjRXpVbHY2?=
 =?utf-8?Q?Sq/T6iz8eWvhQhbBwEQJYtIp4?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1158C68A45D8ED44835970FFF82ADA79@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW6PR12MB8897.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3c4e6c9-8a55-4d02-ce47-08dd3f3ffa3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2025 02:03:36.9801
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FgMWFLaXwLjqjSZZaj+CEo7Rt5OF4zciWkohrpAlTzq2aVOUrpAGn/Qa3R/nuMfQsReoX00FhihsWgJw0M4m5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9273

PiBPbiBKYW4gMjQsIDIwMjUsIGF0IDEyOjMw4oCvUE0sIEFua2l0IEFncmF3YWwgPGFua2l0YUBu
dmlkaWEuY29tPiB3cm90ZToNCj4gDQo+IHY1IC0+IHY2DQo+ICogVXBkYXRlZCB0aGUgY29kZSBi
YXNlZCBvbiBBbGV4IFdpbGxpYW1zb24ncyBzdWdnZXN0aW9uIHRvIG1vdmUgdGhlDQo+ICBkZXZp
Y2UgaWQgZW5hYmxlbWVudCB0byBhIG5ldyBwYXRjaCBhbmQgdXNpbmcgS0JVSUxEX01PRE5BTUUN
Cj4gIGluIHBsYWNlIG9mICJ2ZmlvLXBjaSINCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEFua2l0IEFn
cmF3YWwgPGFua2l0YUBudmlkaWEuY29tPg0KPiANCg0KVGVzdGVkIHNlcmllcyB3aXRoIEdyYWNl
LUJsYWNrd2VsbCBhbmQgR3JhY2UtSG9wcGVyLg0KDQpUZXN0ZWQtYnk6IE1hdHRoZXcgUi4gT2No
cyA8bW9jaHNAbnZpZGlhLmNvbT4=

