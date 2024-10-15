Return-Path: <kvm+bounces-28902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EEC4299F0C6
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 17:14:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E1211C20CBB
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 15:14:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E5C01CBA14;
	Tue, 15 Oct 2024 15:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CpRtINyq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2088.outbound.protection.outlook.com [40.107.223.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918641CBA09
	for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 15:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729005248; cv=fail; b=OvWWb1xSlbpe/YdvbtZUeJiNKDer3Xktp8b4BAZyu4YnnuYCkJR0YdztOxnaTcQw6x21X6RiyDXrj7vEcZfQejiXtdJwL6qF1dooSv1TI37f6ExFYPxOd1dPdoZphQXY79pZ0hm7gk+1M+5acCvtpIIsZ84trDotnumiys/5Fyw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729005248; c=relaxed/simple;
	bh=1x4Y8eAgEyQeHsymDP8/O4fUbDkjcoZ2P4qg+hlhHXk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iNqMdbJ5HMRpOpd4+fKfnxZp0RKncAj2a4ZGW+3uQk2lFRcrZQ540oJ7oM7ljkYrXVBmC9FDfK8T+swP0QQzQPTILgTnev467wn9W+KWul+8QtP8MGjGmvUSl+FNEOQ+vfiJptjjzcbQbL12RAE7G0g0GqiQwW5ygutRRnnOFdQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CpRtINyq; arc=fail smtp.client-ip=40.107.223.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MD38NVQfhSAGb7vbCNn1OlB5/SOGWiinJKdDM6vaNcw89u2jc66M1n1WiwHsyIDekPTK6TV0dNnAFNE4Zwysv3YnZwDo4Fg5AzrLA7TC0zGbLOXm0KvkfZ1hDJYAefCvFSmOnj6tZ3mKF8GQOOYmvqWVNbbmBvjkXHS2QbmkkevzIuZetVlT9211+QE7M6ok7F25BtUGwHv/ZLyo100nL3C630duR24khLDc9cAX2+1U9cBdmty6xEHjBBENwghtjad+j4Ymr/pFW7qsQu/ubg1AiZQ9V8OMoGhdAnzBw5UiBSUl+y2XS8/0+oV3m7OIDs5vm5Pb1uJPsL7mICLVkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1x4Y8eAgEyQeHsymDP8/O4fUbDkjcoZ2P4qg+hlhHXk=;
 b=ED19knlk16OAZhec2K8nzNycBV0OoVcpAGdqTQMr3oeCUnybf7qqI4nc7ikfJGdf3W0lOPJwoH1qUHSDkDUU6h4bYiA2FKRyk647bpZZfWpvj8weqsPeBsGBIJOFkncKJFMslwgHKWQ3Fg3c5s6qaBjom6s5lFTu6zqoClxbK1ZKAn7to4ucKPXhE3rd5if2YcZ1kZNCUNXUsObqCJy3PfKsoIBaNifajlyDmd0s55KHVc+yZezknthhZuucEL6NUVLN/K17J8VpOKK34zlMl29QUjKAxRjRZ9K7Lg/oIYBHCDiJySInnSAH/eznh25qKgXUHEhUyEE/n/4B8S+z0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1x4Y8eAgEyQeHsymDP8/O4fUbDkjcoZ2P4qg+hlhHXk=;
 b=CpRtINyqSo85xcVEGZWq/j1ZVy56ziLaxThIYEcjSyuRuzEIuNyMO2gppRo/IZQGPiD4WeoQb5q8AGbw5uSuH8BXwuCLiX/DYYpDj75p+BWxB8aWQIDIAAFhpdxc/qyhGdwDRp1NmMH0FoklVZJ0kGKumy3f1bO+6H9y3EEDSNFs60JrCrMxtrvdawIYV+hEH6CXTIOMIi2Gzc0OEx3IB2labKsXnyqlKkjvA+Py1k1tKJ8tWkpr/D5uq/0NVuSg69/oMgkZwM8zjQXReKvWkFCcV2UiXq9pHCNbHJgoChtfbtANpPUwrpKUtNowHyCJ+cAYHGqaXsCR5VIhXw5/EQ==
Received: from SA1PR12MB6870.namprd12.prod.outlook.com (2603:10b6:806:25e::22)
 by MN0PR12MB6367.namprd12.prod.outlook.com (2603:10b6:208:3d3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Tue, 15 Oct
 2024 15:14:01 +0000
Received: from SA1PR12MB6870.namprd12.prod.outlook.com
 ([fe80::8e11:7d4b:f9ae:911a]) by SA1PR12MB6870.namprd12.prod.outlook.com
 ([fe80::8e11:7d4b:f9ae:911a%4]) with mapi id 15.20.8048.017; Tue, 15 Oct 2024
 15:14:00 +0000
From: Zhi Wang <zhiw@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>, "airlied@gmail.com"
	<airlied@gmail.com>, "daniel@ffwll.ch" <daniel@ffwll.ch>, Andy Currid
	<ACurrid@nvidia.com>, Neo Jia <cjia@nvidia.com>, Surath Mitra
	<smitra@nvidia.com>, Ankit Agrawal <ankita@nvidia.com>, Aniket Agashe
	<aniketa@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, "zhiwang@kernel.org" <zhiwang@kernel.org>
Subject: Re: [RFC 18/29] nvkm/vgpu: introduce pci_driver.sriov_configure() in
 nvkm
Thread-Topic: [RFC 18/29] nvkm/vgpu: introduce pci_driver.sriov_configure() in
 nvkm
Thread-Index: AQHbDO4P31Y+kUihTU61ZqQfAXOF0bJqtLIAgBtYiICAAdQ/AIAALmWA
Date: Tue, 15 Oct 2024 15:14:00 +0000
Message-ID: <4cd741c3-4b4d-48ff-bf1b-f472f570c782@nvidia.com>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <20240922124951.1946072-19-zhiw@nvidia.com>
 <20240926225610.GW9417@nvidia.com>
 <d46ff67d-92f2-4e84-b1a7-1576b422b6a6@nvidia.com>
 <20241015122758.GJ3394334@nvidia.com>
In-Reply-To: <20241015122758.GJ3394334@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6870:EE_|MN0PR12MB6367:EE_
x-ms-office365-filtering-correlation-id: e764cef7-ca73-41f8-ee57-08dced2bffac
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?aXlRZzRFamFJQXZlWHZkMG01N28vYWIzNy9EZ2tLclBDc1hiaDJqNzBGc2RG?=
 =?utf-8?B?aDZVSVFhSmJRZlA5ekdpOUYrKzZoQ3BzejcyRytEUS9lajFmaDkzMzY5Lzhm?=
 =?utf-8?B?KzlNOFBvTGc5ZWh2emhaQ2JUVmdiaGNheUtNRkE4TndSWXhKRlBFWmZLQi9B?=
 =?utf-8?B?QXU2WEpQWk12bW5LanJPY0UzRnU0VEI4Z1VlWlFPaEpNQVY3M3J1eDV6UVZS?=
 =?utf-8?B?cWNiQlVZaXROMEVDTlV4RXU0YmkvY2FOdVBOYzdndi9kR3A3a0VPRjlURzhs?=
 =?utf-8?B?THZONDFycDRkUzdab2ZzSHp0SXd5NXNlT0pUL1BYdm8rY2VpL3JtUWdxR1ow?=
 =?utf-8?B?VFdzYmFTU3pYMElYRnpJUHUrc3Nub1htMHoySTE0a0w5K3RvQi9jZWpEck8r?=
 =?utf-8?B?TkVBYmhPZkFJS1NHRnB6aFc1Q1JTSFRvaC91cjNaUEtBNzBkT1Jtc0x0NkR6?=
 =?utf-8?B?bDdtOTdOUVBlSG5qZ2N1Z2h3c0YwR2xHdktEMzMxQlNHZnFDZUowVDBZRnRN?=
 =?utf-8?B?VGZGMmdUakI3bjkzZHB0TkJsNTdkRHAwdmwrRENEVGRGZmx3MVhoRmZVQ1VE?=
 =?utf-8?B?aU5nVzUzY1RsdXUzMWt3Qyt0RkVVT29OT1BNWUs5cWhPMXYzeldTL1dGYnhs?=
 =?utf-8?B?QjRqQUNIQ0t2TS9wT3V0SEZFYkVPSC9iQnlIRlFsTzRWM25TVGJkRUVqN1hs?=
 =?utf-8?B?SEVpNlY0RzJ1dllLWnlWVW9kdkg2RnVPcXVEaFFtc3BkUkxnTUxtNm9kVjh6?=
 =?utf-8?B?QUJETHZTR3NtNnZSN2M1YlpaZ01Gelo5d2k4QUtRdCtLZ3REa0pYRzNodFB1?=
 =?utf-8?B?dHMxNml0OTNPYW51TDNsVzZnYVppVjZ1ZzNIYmltSnpkUXJWV0VYMjRJSEs1?=
 =?utf-8?B?UEY1bGVBS0lQS1Q4U0x5VjdKV1ZQZGJwRG14T2JIV294c1RjRDNaLzVDcHlE?=
 =?utf-8?B?QUNBK3hOaERRVHEya0x0eHN6Sm1MVzZ5RkhWMUp4akdaalduODFZTXM0V1E5?=
 =?utf-8?B?aXhJcE5mMWRKKzhaYktOU3owc280MTkzM3pDa0MvYTlicmVPQjlRYjNIM2x3?=
 =?utf-8?B?MmRzRVQ2M29yQnFvMFpla1lGa25XaUFnelhJdEZsTFRaVjdnN3FwbWxIMmpq?=
 =?utf-8?B?R2JlcmRJME9TUnNLU1NIKytaZ3dvWThKTTZMT3pVYThJaHZ1L2M1U0hoL0FP?=
 =?utf-8?B?dEgyakwxSVZ5TEYvZGFNSklaN2lxSFRFeXgydjRNRzZuTHFLLzRJbUxaWlZy?=
 =?utf-8?B?WUJlM1F6NE5VNElrYnZGREZndGlhU1NNeHB6TmJlNFJiK216VzU2Q0dDSTVI?=
 =?utf-8?B?T1NrWkFhVnJOQ1NmUjZJOHBLd2Y4Z1F0cDJyWmNFY2RvZTZCSUlzQzRDMm90?=
 =?utf-8?B?Y2xRd01lZjhZTW53QXgzek9sZFVrSWIzdjFGTkxNZ01tekxTbnc1dURHTlZy?=
 =?utf-8?B?em1mZXV0YUZDb1dMdzhrY0Nod1lxd1hsU3IvcEdUelpaSUh3K3YwaTFmZ1Nk?=
 =?utf-8?B?Vk1EeFV0b1AxVUxJM2hwc2ZPRjA3L05WV0hxZ1JrUllJQ0M4OUlBNnYrc1p5?=
 =?utf-8?B?elE3UDEyRXdBTnk4N1hoT1ZTbDVUVVZnOWg2aGxHWTM1cnBOREtjUmJObjAw?=
 =?utf-8?B?cHI3c2VsZlYrSm9mdkJXOXI5OHFmcUJ6TDhFOCtONHJ2dU5tT3ZqTm5DWXF5?=
 =?utf-8?B?cC9xcURuR3l1L1RVaWxCbExyUXZsWkpTS3pwWmU4WHp0V0twWXJ4S1BNOVNk?=
 =?utf-8?B?WnBReVkrc2srZEc1aFdOTnRGSTB2dlRudEpsbmlkZ1czL1RNUDRvVXhtL05y?=
 =?utf-8?B?NlhUK0F4d1diL1NCaFZOZz09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6870.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dTR6TTdOOFFsWU9UampUM2ZRSHJRaGF4d2taZERRL3dkK1R4ZVl0V1BDUG03?=
 =?utf-8?B?cCswWi9wcVVsTTlOWWdpc0hBWmNEVUZKRklUZ3F6RFVrdnMwV29UVU15azNh?=
 =?utf-8?B?bnc3RmxJZnViQXdQT1VOU211NC9BeDlieWFxNGw2RUoyRGxqZXl4UkkzVXRU?=
 =?utf-8?B?NGo4ZTRUdE12U0JBbGpPRzc4YzdhN2kyMDBaSU5UcmRwUnRpYklVQUR4citL?=
 =?utf-8?B?dGoyZ3FQODdjdVM1ekJ4VHc4d2pZYkNtSk9YTDBEVXpIc0hxNlQ2QXdJODV5?=
 =?utf-8?B?RDRwRUpLU3FZSEEvYjF1NnVOVnlmbkhsTVN3Zlo1OXR3TU9LNkh2Q2RsTWpi?=
 =?utf-8?B?VFFkUXV4dlp6ZUoyeDdEb1ZzUTZFTGFUR2Nab1pWREY1RlpnNXRqTFZ0ZGZF?=
 =?utf-8?B?YlIvS25rZVcyRUwwMUNuTTNIYXJadm9vbzFMc3pCSVRWd1lURnZ3cVA3aTAr?=
 =?utf-8?B?cjhMQTRSU0ZWSHY0amZaUHlXd0Q5VlBaMnVjWjVLYzVZOVplS1JWekhkRVBl?=
 =?utf-8?B?QmE0dXRBU2V4bTUyY0FhWlQxVUI5VzZCN21VekxXKzBIOTlISlhWOCsvM3la?=
 =?utf-8?B?bkUzNXp5YnhoUmZtaGdYMkVVbkQ2UzdjeUZhdS9ZRCtKYkJhZERsSFk2QzNQ?=
 =?utf-8?B?ekdCVis5VlhFdVZ0NjYvdktIb0hNTFdZVHdjc3RkOFZOSHFMSVhrbElpZTl1?=
 =?utf-8?B?RlUwUUlUeTFyZDg5NkI5OTJLaFo1TnpuL0pqMmdic2NMQTZyci9SU1grZVox?=
 =?utf-8?B?WDN0SnlXMnJnQXM5ZVczbXEzblJldHNjbnlLbGVsYjRMOVNDd3FFdFdsU2FX?=
 =?utf-8?B?Y2d1MW1UYWxVcGF6dnJIdWd5QWRmMnorMllMem5IVVhUT2RFWUFYd3puaUxK?=
 =?utf-8?B?d2o5MFhvdjdXQmFLUFF1dXNaMmNDSXE1Y3ArTlpCSlptamFPK0J5UW5Nczlp?=
 =?utf-8?B?Nk9ScS9OM3NmOTh6bFdWVU5FL3FpNmN5dVVBOHFFMjBWQ2JVVlpDOXBYQ1FC?=
 =?utf-8?B?bkorcUtJa3loL1o4Y3hvK1laYnZaQzdQbzJrNURneUhaU2QzejBTaktMb0FB?=
 =?utf-8?B?ZDN6UWk3SklYZkJHN1NGYWNhNUFwK3ZNUjU0KzE2TUU4R21QbmVRYlFDNGxn?=
 =?utf-8?B?WU5VcURLN2VzR09CTnk2cFlDWTNHb0RzWGF3V1lPSnkrbzVET0FGZjdubEp1?=
 =?utf-8?B?ZFpsM2cvT1BjNHBUQlZSSGdtdlhNdjArRUFwam5LNWJOVGhia3lYUk1ZY0Zn?=
 =?utf-8?B?eEhLM3N1U0JvK0NYVjFJQmZTNzZxVUhTNWNROEthVUdURUtpRmZuUnlkdHNi?=
 =?utf-8?B?NDZ6UG9NbEpobitlTDkya3N5MHJ1MWxtNXlVNmhmUVJxZWFnejg4Q0VZTm1B?=
 =?utf-8?B?S3VSTVZaOVcvTHRhK2FIb3oyeHlNTXljVzRaYXAxRnVqRnZsZkIzNmw0TUJ0?=
 =?utf-8?B?cW5qQTgvZXg4aWErcHM2aEMwQ1drSE4rSndWOXpzSUpJYWxrNE8zNExRMnJG?=
 =?utf-8?B?SytRclU0cC9DRUtsc0x3NmhpVm5QNmNXM01tTTZVZ1U3QjN6SldwTkFzZ1hV?=
 =?utf-8?B?cC9vaU9sTUpydFRaTmJmWCtMUlFTclhXM2NtYmVoV2hiTkFaSHozSzZBTVB4?=
 =?utf-8?B?RHB4R1lIdjA3UEYrUkZ5cUI4MTA4ZWtYU29zRXJQZDZJSG0xNzIwMzkzdE13?=
 =?utf-8?B?YVE0NER3RWoycUgrdFdiNTYyRW5rY2xsY1BMdWt3bWx2aWoxdUovR09mM1pt?=
 =?utf-8?B?aUZMOEs4dkRRcy9JbHdYNXNvcVltNEhZeGs5cVZWVlNHMXpLYmo1WHhkOWhZ?=
 =?utf-8?B?SXo3NmoyaUtVcktsVDhBemQxS3B1NmRFNExkdVZDeEhHMDhBd3pWZ1YyTjRx?=
 =?utf-8?B?SUpIcjdwdGM1eUlkdStwTFovcWMzMzI1ZXpiQlRaVEhBczlQRFBscGxSeEMv?=
 =?utf-8?B?Zy9TNUxDYlRnMVZDZ3ExWmhkS25RbzNSSGtaU25EYnZ0eHRxSFZjUmcvU0N3?=
 =?utf-8?B?S3o2M3hpdHFUOE9kNzU5WDNFQW5ra3k1eUFtNGcyWFZGbks5L3F5aEhJajVC?=
 =?utf-8?B?M1FYcmhTVnVhdGw2NnJ3WXhwMkNIWUs4Y0hhTlh1cmtIbWVPWGM4RHBrWjRm?=
 =?utf-8?Q?knlc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <917925B19286E9458C4398FE04F78195@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB6870.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e764cef7-ca73-41f8-ee57-08dced2bffac
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2024 15:14:00.8112
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1jxR9RFXs4HzV3JMIEsKrAilPyREzFJ2NYGxVktzSQ3IBrc11ilxEX4DoKqUrVXK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6367

T24gMTUvMTAvMjAyNCAxNS4yNywgSmFzb24gR3VudGhvcnBlIHdyb3RlOg0KPiBPbiBNb24sIE9j
dCAxNCwgMjAyNCBhdCAwODozMjowM0FNICswMDAwLCBaaGkgV2FuZyB3cm90ZToNCj4gDQo+PiBU
dXJuaW5nIG9uIHRoZSBTUklPViBmZWF0dXJlIGlzIGp1c3QgYSBwYXJ0IG9mIHRoZSBwcm9jZXNz
IGVuYWJsaW5nIGENCj4+IHZHUFUuIFRoZSBWRiBpcyBub3QgaW5zdGFudGx5IHVzYWJsZSBiZWZv
cmUgYSB2R1BVIHR5cGUgaXMgY2hvc2VuIHZpYQ0KPj4gYW5vdGhlciB1c2Vyc3BhY2UgaW50ZXJm
YWNlIChlLmcuIGZ3Y3RsKS4NCj4gDQo+IFRoYXQncyBPSywgdGhhdCBoYXMgYmVjb21lIHByZXR0
eSBub3JtYWwgbm93IHRoYXQgVkZzIGFyZSBqdXN0IGVtcHR5DQo+IGhhbmRsZXMgd2hlbiB0aGV5
IGFyZSBjcmVhdGVkIHVudGlsIHRoZXkgYXJlIHByb3Blcmx5IHByb2ZpbGVkLg0KPiANCj4+IEJl
c2lkZXMsIGFkbWluIGhhcyB0byBlbmFibGUgdGhlIHZHUFUgc3VwcG9ydCBieSBzb21lIG1lYW5z
IChlLmcuIGENCj4+IGtlcm5lbCBwYXJhbWV0ZXIgaXMganVzdCBvbmUgY2FuZGlkYXRlKSBhbmQg
R1NQIGZpcm13YXJlIG5lZWRzIHRvIGJlDQo+PiBjb25maWd1cmVkIGFjY29yZGluZ2x5IHdoZW4g
YmVpbmcgbG9hZGVkLg0KPiANCj4gRGVmaW5pdGVseSBub3QgYSBrZXJuZWwgcGFyYW1ldGVyLi4N
Cj4gDQo+PiBBcyB0aGlzIGlzIHJlbGF0ZWQgdG8gdXNlciBzcGFjZSBpbnRlcmZhY2UsIEkgYW0g
bGVhbmluZyB0b3dhcmRzIHB1dHRpbmcNCj4+IHNvbWUgcmVzdHJpY3Rpb24vY2hlY2tzIGZvciB0
aGUgcHJlLWNvbmRpdGlvbiBpbiB0aGUNCj4+IGRyaXZlci5zcmlvdl9jb25maWd1cmUoKSwgc28g
YWRtaW4gd291bGQga25vdyB0aGVyZSBpcyBzb21ldGhpbmcgd3JvbmcNCj4+IGluIGhpcyBjb25m
aWd1cmF0aW9uIGFzIGVhcmx5IGFzIHBvc3NpYmxlLCBpbnN0ZWFkIG9mIGhlIGZhaWxlZCB0bw0K
Pj4gY3JlYXRpbmcgdkdQVXMgYWdhaW4gYW5kIGFnYWluLCB0aGVuIGhlIGZvdW5kIGhlIGZvcmdv
dCB0byBlbmFibGUgdGhlDQo+PiB2R1BVIHN1cHBvcnQuDQo+IA0KPiBXZWxsLCBhcyBJJ3ZlIHNh
aWQsIHRoaXMgaXMgcG9vciwgeW91IHNob3VsZG4ndCBoYXZlIGEgRlcgU1JJT1YgZW5hYmxlDQo+
IGJpdCBhdCBhbGwsIG9yIGF0IGxlYXN0IGl0IHNob3VsZG4ndCBiZSB1c2VyIGNvbmZpZ3VyYWJs
ZS4NCj4gDQo+IElmIHRoZSBQQ0kgZnVuY3Rpb24gc3VwcG9ydHMgU1JJT1YgdGhlbiBpdCBzaG91
bGQgd29yayB0byB0dXJuIGl0IG9uLg0KPiANCj4gSmFzb24NCg0KTWFrZXMgc2Vuc2UuIFRoZW4g
d2UgZG9uJ3QgbmVlZCBhIHVzZXItY29uZmlndXJhYmxlIG9wdGlvbiBmb3IgDQplbmFibGluZy9k
aXNhYmxlIFNSSU9WIGF0IGxlYXN0IHNvIGZhci4gV2UganVzdCBlbmFibGUgaXQgd2hlbiB3ZSBz
ZWUgDQp0aGUgSFcgc3VwcG9ydHMgU1JJT1YuDQo=

