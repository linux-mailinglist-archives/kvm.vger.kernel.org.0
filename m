Return-Path: <kvm+bounces-25641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6661967D5B
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 03:29:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5A236B2142B
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 01:29:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FB88208A7;
	Mon,  2 Sep 2024 01:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wDK4lQcy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2066.outbound.protection.outlook.com [40.107.244.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623F71388;
	Mon,  2 Sep 2024 01:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725240555; cv=fail; b=WDerHmknxX6h6oqQr/TXWm9A3cXLP43NBgDW4HexqVx6wz9TbdSLkuYhmr95XNAyRep/V5hKYfGH52NZXl0b0hpBwPyE0xFjAk0VUd0qvIKWUF/OxU82t4CJJRBjxs0P3Xu6elG4pZWKb8UsaWCZVDkUNAyMh6jYcjVsI85ci0Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725240555; c=relaxed/simple;
	bh=y/O6wr1Gyr6YPrdvn8Ty9dnH8sVHCY3UxFndqj6IraE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I3D3RUYdV5cpIVPOU4J4lLHjleBy7nT9Q6ys/Il+fGWFS3lAXVPopitHtX8gaKJ/zbykQun5B/wrt1CkVFt9qUcmH4TP86m+whJ9qZcR8iaGMmMKaYVg+5KpZU2+LmjR8NeGeQpo3hG8g5Igr/eC3mjhUwZhBNv9WWRBJhMI3Gk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wDK4lQcy; arc=fail smtp.client-ip=40.107.244.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k2DsDaidMj+ObPEBW+Uz0hMBlVMteEPGiyuFi6yZooFHqnYzW6pssQF+tWBfbgG4NG3IuXGgH/RE80dmWPuvDB74p4XSXGSAz6cC3jUD0KAS/mh6PFmOQosOB8ceFKlBUUp9RqmxJ6hokPIqXPAvW5aso3sv5DS65Tcsxb49U8s3FJ3YzOemBWlBu47UyPU1TgAiKNF4GvuOjiYrPgyNIKLVcRVVX/DnIm/tAoT0BtXA+LVZ/P5mSnyRimOUX7115wK5SOyBDRCQXSQQZBzqUb04L72SlxPZD/96SZbdp2UmwkLPHAfrwgRAA019clUf0abYska2o1MPdfJG182dVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ctoYZA/oRSh9/Z24WggfxCUPkvytiTu2Zu60wbma9Ec=;
 b=jbBDnP5eFkX220rAyQKCWdKA0GmHZBFNHnnL/7VU6ejReZ3c2KGwM8Gx1Ji2emfszCADj/rxbgFX3TkAoT9iofMI/7fjxQGdB4OfZTRl0spM94dH1RQ30ZE5OFr8UT1ezZsMaS12dM7Udw5+acpMoQiAzUPgFX2loFbC0568hbXnRTobMgvJ1wv0VuX9FBwg+v6Oa87GE0Va/w9YJtdWhvvwb2LSOf3PlvH5LLA/VwR2+sZtkCVEd3/R+Xc8V5RhxIehyNaWW3rrh/tSIowSiPnuusxSWsaEYve/8TMfnbkCghNqfvr4BFWiyrm6a4yvlpRoRGnKe71/Zh8E6IEFnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ctoYZA/oRSh9/Z24WggfxCUPkvytiTu2Zu60wbma9Ec=;
 b=wDK4lQcy/Heq+7E88UIzFiQMtEYSqKfCylD47pVPVhU/ffCyA9uE49fhx39fIhDgdHqJtp4APfGe/J025tBsu0auNg54sqx0nxee9VrUUMYe4t2d8s4OBWurwfHT9czm5V4o0uDHmqWC8O0dEELws0+hrnNLMRtriL2PFjQpu7A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by CH3PR12MB9021.namprd12.prod.outlook.com (2603:10b6:610:173::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24; Mon, 2 Sep
 2024 01:29:12 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%6]) with mapi id 15.20.7918.024; Mon, 2 Sep 2024
 01:29:12 +0000
Message-ID: <f1d86e88-bff4-424b-8ea4-8457b2cfa258@amd.com>
Date: Mon, 2 Sep 2024 11:29:03 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [RFC PATCH 01/21] tsm-report: Rename module to reflect what it
 does
Content-Language: en-US
To: Dan Williams <dan.j.williams@intel.com>, kvm@vger.kernel.org
Cc: iommu@lists.linux.dev, linux-coco@lists.linux.dev,
 linux-pci@vger.kernel.org,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Alex Williamson <alex.williamson@redhat.com>, pratikrajesh.sampat@amd.com,
 michael.day@amd.com, david.kaplan@amd.com, dhaval.giani@amd.com,
 Santosh Shukla <santosh.shukla@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>,
 Alexander Graf <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>,
 Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-2-aik@amd.com>
 <66d10ea4d5fce_31daf29416@dwillia2-xfh.jf.intel.com.notmuch>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <66d10ea4d5fce_31daf29416@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY6PR01CA0023.ausprd01.prod.outlook.com
 (2603:10c6:10:eb::10) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|CH3PR12MB9021:EE_
X-MS-Office365-Filtering-Correlation-Id: f71d207b-791e-4003-e8a3-08dccaeea628
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WDJPdGNxQ1h2eGpvSEExN2ZlV0x6ZW4zcjZsRXAvTlV4ZVRBejVLNGJqNE5H?=
 =?utf-8?B?ZFMyK21Ua0t1YThSOW9BeC8wVG9LNEtHMVpISjBZZW1kaTVWdml1TUlmQkJB?=
 =?utf-8?B?Z2pXYUcra3ZHc2tGcnZrdVA2c093bE45TU8wMzM5R0JlUCsyWGFLeVJxcnpp?=
 =?utf-8?B?VDY3ejZLVlNPcG1nQmkxYXlybGVLY0NGTGRUdXcydmxUUmJVOURGM0lYbWlj?=
 =?utf-8?B?aTdUZGU1d2U1bFJ5aTZ5ZUZjd1RsZW5TSVZzWFloNXRVSXB6SE1GZGtvWEVa?=
 =?utf-8?B?M0FNTjdpTG5UbGZFNjBHL2FacnY4Mm14ODM5UFg2KzhZYWFXUnhSQzh3V2or?=
 =?utf-8?B?UExuTHZrV2lwS0VETTh4SlRWUld5c0tWQ3VLdjU3Wmx3U3BoWXdCTzBrd1Qr?=
 =?utf-8?B?dVg4dmtRYVFEOU96eE1VTWtGNXNtQ0tWSzdqcWpZamN3RGRZaTdMNDFLRUFF?=
 =?utf-8?B?dG9rSmpFLzhYR1Z3ZXFQWi9IQXNPT244aVJYSFFSTDExcUhZOEt1TGZsUWk0?=
 =?utf-8?B?bmIzTzdFeXk5YWlwbVVlM2c4QStIYmJjbG9waDYxdFQ0TXdwVmFHRmlmS2Yz?=
 =?utf-8?B?RUdQemxQeWFKanNvbWxRU00vVjhCbjVjdE5DWWsvSE1BS0liRlhkcjlBeVM3?=
 =?utf-8?B?SUt6aW9BbEg2OXhnNEQwSXJVRnNkb3ZwSnM3ZU4yWnJSbWFqVktHbStLSVZG?=
 =?utf-8?B?NUxWWk85c3pBajNlZ3NMMnlJTUhycXBBOSt3eEVBWmZwVWVmSmxMdEJNOWQr?=
 =?utf-8?B?ZWFGVk8va3RXL05jSVM1VlRVRElBRitFS2JCa0k0aHpGeXd4bmJMbTJhUThp?=
 =?utf-8?B?cjZBQktDZE00R29EK0JsbG1pdTIvNXpmY0JKWVgvbzYwOEV2QU1IZEt0SVF6?=
 =?utf-8?B?TmV3UTBhcFFHMXRPcDg5RkVqVjZReGZDYiswMGFQbkFrSERPNDlpQU9yQ0Nx?=
 =?utf-8?B?ZHpYb1NCYzIvQmxjWmdHKzFWQjlvYmlPcC9FbVU5MGxBNnZaKzZsdmJGa0dG?=
 =?utf-8?B?SnprdkVxdU1NM2piY05waFZibkZBaTQzR21QUlFIYzBodGl5VkNwZGhyVUVE?=
 =?utf-8?B?OEtQVWgwOGJ3eHhBQ3UzK1doNmJGcHY0Q1F0SzA5ZkpWTnJac1hoSW5GMWFF?=
 =?utf-8?B?QVR6THF3b0ROcU8rQnl1WlNMS0pQZUZvYjdtc3ZIMkRsL1MvSTFmdUl5S3ZE?=
 =?utf-8?B?cmYzRnI4UWFYelBxbmd3VHlkV0RTSE9zNGhlNFgwTVIxK3BjamRLblRtS0hJ?=
 =?utf-8?B?eWV0cmZQMlVNdjRYRmVYYUs2REk5L0ZKMHJHbWVzTFpadEY2c0lXanV4bTho?=
 =?utf-8?B?WGVZRTZrOGJpaHdhbFhzWVgyM3Z6Q0ZxdU5DQVJNYkROaDFVTzJTWWphUDJ3?=
 =?utf-8?B?am5ZQXg4KzFzRllsN2VnUElNbXliOE9aZmdJbmxWOExGQkVFSWNwUnNUVUhT?=
 =?utf-8?B?amMzb3ZzWWc4NzEyOWxGSUdueXMzVXJxMzVMWm5Fb2p5WWp3K1U4Nk1rQ2Vn?=
 =?utf-8?B?dWc2SDB4L1AzNUJ0djBjY2hNK3EwUkpNZVYxOVEvWUljNXZEWnZYR2U0Ymtl?=
 =?utf-8?B?MTdIRGZlQjRvUFZZWVl2c2JQVDhTNHFnOWRkSUMwM0JoTnBrUUpGRjJXTjR2?=
 =?utf-8?B?eFVTN2JibzZPVnB4dldjd2tSM1hkUXFaZnpINm90V2xxMDZOMTZOYVJhUnZ6?=
 =?utf-8?B?OWljWUlKV05ud1FmWncxNzhmdzJBeHQvUWFXNWxZL0FLQnFGRXJLVXdWOWVm?=
 =?utf-8?B?OXM5UnVDK1ZIQjRKQWdpRmVMODdZcFdQTnp0VEVUWE1sTXpyTHVuZ1JYYTY2?=
 =?utf-8?Q?p1+H1I4YFadEqj4jcpYWqUra7rcU0rJ+rrruU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NXZLb1JIYUVxVm1XcmZDeEg3U1M5K3Y0WTFXTDREcmNUdWh1NlNTZUY4Wm1F?=
 =?utf-8?B?aFBiYitXUWlLSkloalRMRVFrOG4wTnlZQWNPcDNoVzR6d3BZUE4wZGlEVk9h?=
 =?utf-8?B?QzZ2RlVHTnJGRFZkOXZJTkFLUlQ3dndpMGRxS3dkaWU5SS9MdVdXLzAvSjNQ?=
 =?utf-8?B?ejVtZ2hEUTJvNW1VcjRScXVZb2tGQlB1b0pUVHdsRkFNRTNJb1ZsZjVaamV0?=
 =?utf-8?B?TDZnK2xZbnNoUnBQN1ZnOE12QnpBK0FvRkI0OW1kcGFIRVZrbko5VVNjeWZI?=
 =?utf-8?B?UjQ2TW0wYXpMUnV2aWszN2ltNUd0alZmTFg3bXRlY1BjcFJYVllHdFNyUld1?=
 =?utf-8?B?Nitsc0hBZlhyQ21ldjBNSXNHd3RtTDhZVEtub2Vob1VVZ1M2c2hLa1FIdDNp?=
 =?utf-8?B?aWVsSEFXZThFeHcyd2JUaHpaaE9mbVpCT3d2dGtmTVkxdkk4S2YyTGZXdlVn?=
 =?utf-8?B?RHlrL3BWRmJ3MXZXVGsySUtSSUVWZkpSRUJPZXFuZVEyN2VpZjlwanpaN3Br?=
 =?utf-8?B?cTJOTmtaOFFtdkFFZisyUThNd3pxRUpYQ1ZydG1rdnFVNTc1M1loTjl0MlRI?=
 =?utf-8?B?OTNEZnBySS9RbWNFODBMZzZvWGkwOFVkSVo1cUJuVVV3QXN0SVJZUmY2aWI3?=
 =?utf-8?B?emNqZ3RmbnJoYTFQOXJUZUwrZnQxUlNVMGFudUFQQll2Mzk1N2dHYkhVYThK?=
 =?utf-8?B?dTJZeU1YNEczOTUxUmRYY2pyRUhQYnZSRmhQYkg1Q2thQ2RSSWh2VWV6TzVZ?=
 =?utf-8?B?dzVMNUxHUlVqTTVub1JOQUpzQXU4MVduVDM4T09YZUlhN3VtTWtEdCtTVUlx?=
 =?utf-8?B?Zi9JTHhyNU1nV1pydDRWNE9RTEk3NWZnc3d3YzZBSFBQVVFUcUFKblZTb1ZH?=
 =?utf-8?B?UlhLL2RkNkRmU1JGMjh5VkU0WWdaS2hSNy9nSWNDWVVJSnNBZjkvdG5rYkls?=
 =?utf-8?B?UVdJK2t5OWZWQVhvTjRIdFNkRDR1MXF3YmNLUENudjZKb2xMa2RYWXUzQXJr?=
 =?utf-8?B?TXVUa2pBOXFScEZDUFdSdXdFdGhHNHowK2hhQ3BRZkNVOTQ3WFJUZ1lNVkY1?=
 =?utf-8?B?RnlDbUVTRnBJaldTKzIwSGlXQyt1OG9UdFFVYk1HZTBaUFlTeU0vYXVyU1M2?=
 =?utf-8?B?UVJxMXc2ZWFUMS81dUFJanJGaFJqclhCMnpwNzBYMUJZYzI5ZmlKT0VKOTJm?=
 =?utf-8?B?a0loRXRqSWtMZitGQ1ZpQ2YvZ2JPSE1QWUhMK1BLdXdtcklVd2lrbVAzNVRG?=
 =?utf-8?B?ZHNacFVsT3o3VXIvemJQcHQxb0R5SmJEeXpBQkE0Nkk2VGZ4QWwxVmpvbjdR?=
 =?utf-8?B?ZXpkMHlaYXV1cXR0MFRHNUpjdG1sdVVYdWlVemc3MUViNmJOZmpXQUt0eUM5?=
 =?utf-8?B?NVhGUXBKSE9hR2VXeFkrempzaHU4dkR6U2laRmdMbVdyckJnZVB2SmFiRklT?=
 =?utf-8?B?TnBGR01JZFNZVEVuYkdua2k5YUc3K3VpNTFJUTVnQWVzTzBNSklTYW83RDd1?=
 =?utf-8?B?bGxaQUJjYkc4R3BoQm1iN0RESzY4Y3pQVC8xVEdlVkdBckpDZCtaa1RtT3R3?=
 =?utf-8?B?NEVTcjhJSkZNWGs1YU9pUWJ2SW1RbTdTZHZkQktNcURCUHduYndUMVl1cExN?=
 =?utf-8?B?LzU5Q1ljRE1sZytUdUJrTGhXLzN5WXBjSzRYMUJZcXhRT28xQ01zSVJKcm1i?=
 =?utf-8?B?WkNkTFpTQVlYdTg5ZDVpL05BaXZOMlNWeGlKNDN3bkRRbk1yNVREd2s2Mktx?=
 =?utf-8?B?a2loK3NsSFdaVEpoVWVIWFgzM25sZjV1WmxDMTdpT2xtSUtqWmJGRjNYR1hy?=
 =?utf-8?B?dTB3MWRHYVJ2WFBtak1wdGluQUQ1TjdyRVFBZHBxaVZlaWJpdi85ZnZldU4z?=
 =?utf-8?B?L1E2SGRUb2V5WEYwaHVXNm1JWldibkxiWVI4bTNBekZvdnVIbHhIQmZhckE2?=
 =?utf-8?B?d3RtSU1Bb3N3MHIzRFBGYW54ZkhkRGFxY1JtN2R2NWJUTmc2OFdUYlNldkN5?=
 =?utf-8?B?R1FIRVhmYkhKcEVQOVBaK0c4N2JUUnFHVG5tbGIrTGdzWW45ajcrYnplL0hH?=
 =?utf-8?B?Sk9ubVJXSVZVYUVwVTJhN0FZV3UxcTdueDRZcGF6SEJjSTlraW80bm1Xc29M?=
 =?utf-8?Q?GbPQN4pUsUoowvxk1rUc4fNGr?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f71d207b-791e-4003-e8a3-08dccaeea628
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2024 01:29:12.1539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +uySi9TbifcDQj/L/6OeONAb1fXl+7eyuPR9xxi0ZzAJhZzWRVmNnXj8C/YsT/vXX+V4DeDKFFWIyXB7Ua0H6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9021



On 30/8/24 10:13, Dan Williams wrote:
> Alexey Kardashevskiy wrote:
>> And release the name for TSM to be used for TDISP-associated code.
> 
> I had a more comprehensive rename in mind so that grepping is a bit more
> reliable between tsm_report_ and tsm_ symbol names. I am still looking
> to send that series out, but for now here is that rename commit:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/djbw/linux.git/commit/?id=5174e044d64f
> 
> ...and here is an additional fixup to prep for drivers/virt/coco/
> containing both host and guest common code:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/djbw/linux.git/commit/?id=68fb296b36f2

I am happy to use what you have in your queue and drop mine. I also 
suspect that my TSM will be no more soon, DEV_* bits will go to ide.ko 
and TDI_* will go to a new tdisp.ko and we won't have a tsm.ko vs 
tsm-report.ko problem after all. Thanks,


-- 
Alexey


