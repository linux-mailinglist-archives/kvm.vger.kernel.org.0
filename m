Return-Path: <kvm+bounces-33412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FA759EB1C6
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 14:23:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9222828463D
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 13:22:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4F8A1A7253;
	Tue, 10 Dec 2024 13:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zlz6jY0k"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4571219DF99;
	Tue, 10 Dec 2024 13:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733836966; cv=fail; b=t+k5maPgFHfEI28BsEosJUQnbC7VAo5mVd/Wk1XZcJhqZq4/yq0rekNj9LqBgBD4Ci7pFM/96uLNWyVKW+JVvrJiNb6A04FlRsdeg1CrtGGaOvwiZq/8yFWiMbg9G+nmCnhJj/UFpnK5bs/4oHYpBfJyv1Vj0SUhzZ0zs6cnjqc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733836966; c=relaxed/simple;
	bh=JLY5XGDhxUZ7JQCmiD3m2fgXKdz+EzxrYNfAUQlzBU0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gjGfSjhOzN5CPRyXTMVerUORs0YscrzRtApajSJdGpgwPeHdyCxoUwQyo+NxulzpwX94+7xbmNMifaVUSIF1CwCETo0KdG23Ua3vzdB5URWgg7VKyNWfSBn+/jobjMogXfZWI3hYrNRKxhln/8nhGLrb+axfCaGbdbjGH0Bhu1Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zlz6jY0k; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733836964; x=1765372964;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JLY5XGDhxUZ7JQCmiD3m2fgXKdz+EzxrYNfAUQlzBU0=;
  b=Zlz6jY0kdBHp9bMdZ7e49U2bB/+EVSq8ri9239amj42vxw6wqpo5sNep
   IoTkABKA+Zfvqum8TSJ72RvKya3uf1FLWyELM+LLHALo0TH8ErEVh7Gwd
   27sfTT1nOcTTQ57nz6+iu7392M8AeuAmaIBq7nrBtrrXYkeldYueB1fV+
   e6CYiqeExGe1K3/sjVImfEU+MFklt8E9nZCNmNcisTPvBJuozP27A0gRr
   PjugC8N7LMrFDAE0ZMhZMB9aIOn23uwA1gJPHSlQfrHwL1FizXfHCq5RG
   CVs/V4hamcaVa3r26Xt5a5lLqyV7xFn2DB5LHjapLq6uQ62R8bZ8LyP5M
   g==;
X-CSE-ConnectionGUID: xMYpyPK9T3iVqdTnqIw5yg==
X-CSE-MsgGUID: wP5gVcXIR7CX6MQQGKWLXw==
X-IronPort-AV: E=McAfee;i="6700,10204,11282"; a="34232029"
X-IronPort-AV: E=Sophos;i="6.12,222,1728975600"; 
   d="scan'208";a="34232029"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 05:22:43 -0800
X-CSE-ConnectionGUID: 6mjGy3tvQLyHwTSwcI7vdg==
X-CSE-MsgGUID: LK164+EITNayegGOX6ukDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,222,1728975600"; 
   d="scan'208";a="118656180"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Dec 2024 05:22:40 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Dec 2024 05:22:40 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 10 Dec 2024 05:22:40 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 10 Dec 2024 05:22:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lfiQM43Cg8au1niG/6K/9QfztnfKADFPB5Rk8ljonkMmOQ7TDCOAIWNv8Z/3+Pm+YL8mPYzgRWv7x//vjnsHltjCJ9Mas6Ry+CVfFV4bon4tJQqaW8QGG7MwPdix9slI/LzMqt6PxWMrrtZBsshjRhmIwaj5pZxKeEhcU/bpAn2VfUnQVFAuB3Ll0saTpkwyVyKUITk5OmqMOpqXpjlcEtzSb68irBi14uVEOtAesETl94MNYtWTIKi/8zj+6a5mVtJSHI9KXQ+vGOd8sRDxLSEYESJHzg1WVKTIHapbdZLSTez4Pwhvt6AYQSbYxqMz9IVZeeDka7qX0UKyehHClw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/F7QHp69tRg72ze2N1p/FEbxeBJ73LKbnr4atiIvSzI=;
 b=rv5Ymp937U4aQ4gW8kIU7d6EbFmwAj2u2FDe81PPZ6dkKrXu6atoWDichuYoMKNzSvd8CIwsu9qFNmAfVl8vhFA95wVc29EnaOkUtdY2DyWrQr1BsNfusiO7FsiQ7PA8jYTXPp8xH8oKqhhALZNKS5lgfp1CisArh/gJLbOpexKpjWIauA2zyJvFtCsE4nJ+ZMJIh1J9WYNaxlTx2jRulGYoqdphUmEp6ad93f6M2pn0Ng418S5F2xxTjj6h9W/Q7g59oBSuCGznqD6paeMhFdiL4G8kcs/QR9TE9okqkAXgDB1qI/75yEls2ISbG1/jh2TDZVMbsF/vQnmfMlVuyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB7918.namprd11.prod.outlook.com (2603:10b6:208:3ff::8)
 by CH0PR11MB8141.namprd11.prod.outlook.com (2603:10b6:610:18a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Tue, 10 Dec
 2024 13:22:37 +0000
Received: from IA1PR11MB7918.namprd11.prod.outlook.com
 ([fe80::5eb7:69c9:760d:97f1]) by IA1PR11MB7918.namprd11.prod.outlook.com
 ([fe80::5eb7:69c9:760d:97f1%5]) with mapi id 15.20.8251.008; Tue, 10 Dec 2024
 13:22:36 +0000
Message-ID: <7611ed37-9ea9-47df-8409-29997bd34e37@intel.com>
Date: Tue, 10 Dec 2024 05:22:33 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] vfio/pci: Remove #ifdef iowrite64 and #ifdef
 ioread64
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: <alex.williamson@redhat.com>, <schnelle@linux.ibm.com>,
	<gbayer@linux.ibm.com>, <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
	<ankita@nvidia.com>, <yishaih@nvidia.com>, <pasic@linux.ibm.com>,
	<julianr@linux.ibm.com>, <bpsegal@us.ibm.com>, <kevin.tian@intel.com>,
	<cho@microsoft.com>
References: <20241203184158.172492-1-ramesh.thomas@intel.com>
 <20241203184158.172492-3-ramesh.thomas@intel.com>
 <20241209181953.GD1888283@ziepe.ca>
Content-Language: en-US
From: "Thomas, Ramesh" <ramesh.thomas@intel.com>
In-Reply-To: <20241209181953.GD1888283@ziepe.ca>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0385.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::30) To IA1PR11MB7918.namprd11.prod.outlook.com
 (2603:10b6:208:3ff::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7918:EE_|CH0PR11MB8141:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d74ca43-c385-459a-b60f-08dd191db6b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UnR1cmIxL0J4MVBXKzBEOVkrbjk4MEVuMFl1OG9YNUUzc0VpNWVaa3hDdkx6?=
 =?utf-8?B?N0hzVjJRckg4Ti9qUkZaQm41dmFDbmRFZTN2Q0tYbkFFOGE3VWo1ZkdkdzVM?=
 =?utf-8?B?ZnBuc0t3cEZtOXBpckNCMFdHSjZ2U05Oemk1RnIxMjhjV1JUb1lvV2FNVDZI?=
 =?utf-8?B?YWN0amdieW10Ym9RQVhObjI1YW51a0JoYStuRFNiSkNMT05vWVE0MXJCVFJB?=
 =?utf-8?B?N2tyZE9zY204aHVuZS9LZUpkVHl1eWFlMXpaYWg5bmxvUTY4Rld1ZmlNMC9G?=
 =?utf-8?B?ZGFTZGVaam9xL3Z4QTFLSXJOcUZEeUVrdkppWSttN0FzSGJZUUNnOG50U2hB?=
 =?utf-8?B?Tk9FVFlENTlCUUY0d3hySXB1UFF5TlllZ1JMaXpqNmpuUVQ3MCtMK1pwV0Fy?=
 =?utf-8?B?NVczNXZRMXIwdTRkaXRoQzdTSUlSdW5NbU5uZmxlekRYbGRGbWZGaCt3Rmww?=
 =?utf-8?B?bVdrUHFzbkdRY0lmUmlPUW5kTkFaSXJrZE9ZSmZLZVlUV3QwNTVvMjc4QnM1?=
 =?utf-8?B?cnhyWnRrNkRzZzJ0MHNhaHVCYnd6bzZiaERINEVtMi9LYnlsb3FvQ0JPbktP?=
 =?utf-8?B?UHlOTGljbVI1eVRwMEc1dGFnMmJWZWVZTzhtY1NpMHJTSG5kelhXL2FpNFo5?=
 =?utf-8?B?L1hsSkF3OXJROHBSUkF3aDJxSGdqYkd2U2RiL09BRlNJM29sVmZUanRZZ1pl?=
 =?utf-8?B?dFB3aTFiRG1yVkdrUjMvamFPbjFIRjlIK3lCV0l1bnAxbC95dDltbWE2SnlF?=
 =?utf-8?B?TWFnalRuZXZFbEo1bVdiWTh2K3VndW1xQWtiZngwaU5UUENBOEhRQ0lyL0Jj?=
 =?utf-8?B?N2doUFhoVElnMkNzYm0yUjRhdy9hZmdGTzNJOHpNWjBpL0ZoUk92NFZQYjN2?=
 =?utf-8?B?b200YUtIK1Bqb3daMEYybTcvN2IxTnU5RnFKWFo2RVBJeVoyYkd5RnRYeDAr?=
 =?utf-8?B?Z3ZoVUEwWFhPMlVHMkZTSFR3UHgvWGRBME5HS3pOZkpaSk5HKzFaNzFzeWo5?=
 =?utf-8?B?R0w5dkN5dzIrRlRNYUNKSWFMbTlIQlR0MGE1Vy9tU1Y4ZGVSN2h1SUVhaFBU?=
 =?utf-8?B?U1JiL1ZpU2JxZzN4T0NyRDNvRkcrbEFXY2NkeW5jU1FJWFQwSTVlQnhJVW9T?=
 =?utf-8?B?NjdodHdaL3VGZmpqa21HKzU0bGY0bHdYU0lmL1FNVExicHdlbzdxOUpadmJx?=
 =?utf-8?B?dWFBK1NxK2FRYmRNOG1oRm5tZXdFWkhncTUzTTJvRCt4RkJ5VzNicEtnS1NX?=
 =?utf-8?B?cEJldWgvTG5PMnlHTlVMa3gxQ2o2VEtQcm56TTNZaW9lREo0QVpUbDN1UUxa?=
 =?utf-8?B?ZDdyc2JFNzlXRFROZ21pc21oRE1rRnJBVkdXcnEraE80ZXNwMHNHRTVlRGY1?=
 =?utf-8?B?STJSeGk3WEx3K2Y4QnZhbmsvRXgrcE9CclB5S3NXaGtOWHNlQWwvVGJEejdO?=
 =?utf-8?B?ODM5SHR4VmFvY2VYOFpjdWJhY3lFUU80TFJydWpzMW5PcjlBY2dpUnNXWEd0?=
 =?utf-8?B?WlcxQXBycUZTOHdnU2ZuRU9LdFVwand3amNCQlhyYjJ6TnAzYzR2ZDNPSmNN?=
 =?utf-8?B?R1dDYkNZMUFlMGFqYnVZYWNaeW9KL3NGTE42UmswRWhmWkFpNDZydHVOWi9D?=
 =?utf-8?B?YXo5TDdOQXZQWDZBeEwwVkJGOEdZWFdMcEQ2d2p0ZzdsdGwxS2JzUjFJSXpI?=
 =?utf-8?B?L2l2WmFRN2szZ3VKMjF1TmtoeFgvZU4ramgySEVwa3BIK08rWk5PR28rQkgv?=
 =?utf-8?B?RG83V29YVFJFMDQvalVZYm9la0t0YlNmTTYvNWZ2NUhnNi9tbWF2S1MxKzM4?=
 =?utf-8?B?OVZzaXFHdElsejJUTGFyUT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7918.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ckx5ZkZBS0dMcVlMT2h4YWM5Q0RnRTEzZzY5Q2czek1UampCcGJpbktwQlZM?=
 =?utf-8?B?eElWT0ZuRXhJWm1DZ1g5SnY5eDVKVkx4K2szYWk4SUJJYXBsTXpaaWRLYW5U?=
 =?utf-8?B?Sjk2ckhISDhTVmdQaERjU0xRdjliVmsvZkhCVi9WdHROYy9kZ05lRXBtNXI5?=
 =?utf-8?B?dWdPV283Y1FPYjVGdVdIQzRRcFgwOTNucGFLTzdBUFBJU2I1enQzSGRkeGpJ?=
 =?utf-8?B?VEt4U3BLRSsvcUxmNVI3M1hHN1N2SnR4SmYwaUVLR2VNOEl2d1RIZWk2aElr?=
 =?utf-8?B?ZWhCMG83UWtKT0Fia2VxQjhrWlZ2L0JzSjN1RmZEak4zSFhZenVyYVR4UTlH?=
 =?utf-8?B?VU1zZC9mRkhMaXAzdHVPVzVWaE9KOWlFRzFOZWNTZjIyRmZOaS9OS2tycENV?=
 =?utf-8?B?VmprMVNjY29RVzJZdHNWaEVIVUk2aWJRbmtDbHI5Z0hIODFqOHpDWW0wYXpk?=
 =?utf-8?B?R3E4bHcxaXp4alR1SExMSkRZMFgySWc1Zm4xbjR1Z2JIYzlIaHdZSEJDT3lr?=
 =?utf-8?B?ZVNuU3R4ZGZpaVQ5ZkxBUS91ZXEyRXV6RVBUYjN2ZFViQTdoZGt3Rm0xUU5L?=
 =?utf-8?B?Wmx5UHhnMU5TSTFuako0WkVVTllWWU1IMzBoZjdubEV5U2RzZ2pTSzRkVGVN?=
 =?utf-8?B?TDRTZDM4bEI5bGsyaVJUbUlzMEFrSHI2R29waHVBQjFyQlpuNWZOemVUTG9F?=
 =?utf-8?B?S1Rwc0VRTmlKYWNyWlVnZ0JmenlHYUpQWkFESUZzcnNxejFnV3IzdHo1TEtB?=
 =?utf-8?B?NWNFWW85N0ZDakc0MHVwSEpOWGlZS0prU0FxSUJaSlpBN1VsTDlIanUvWStk?=
 =?utf-8?B?T3dJQ1psYXN6U2RpT0laTjExVEh2T2FueVpaeTRXcEFla2ZEM1QySm1tM1V5?=
 =?utf-8?B?N1VqMXQ5U3ZTblJDdGxsTk1TdU05Q3p4QmFaZnZlb28xSlFtYStRRCsyTk5S?=
 =?utf-8?B?TGtZTDYyK1VxRWhBd3dLQTZOU1Y0WExsb212aFVLdDkyc3o5N3AwT05yL0NU?=
 =?utf-8?B?S1F0ZmVSblN4QjVBOXNEeng4bGZ2S2piZndEbDNRSFNRWVdvNTFFcUV5V1l5?=
 =?utf-8?B?ZjNEaGxxdzJjMkYxSlVWVWdtYjNrWlI0YzRPeEVCa3JvVy9HbzJVZW01M0Ri?=
 =?utf-8?B?OThzZUg2TlYrQmVJL0dkMXpHMGQwb0o4eGdSSzVENnhCZnZaTi9NdWZxQXps?=
 =?utf-8?B?SXpSTitjeDNYazBqZ2JlRjBPSW9xTXBGTnkzcmtUQXZqcDRwck0vN2MwVG5Y?=
 =?utf-8?B?MkJJZWJrVHBTSzJnU2NtV0svU3lrMHhTZy9IR2hkOTVMTnNKWG4yYVBwT0dz?=
 =?utf-8?B?aXI3SjRoVW5NQlFyMW5URUpHRFhRMVcyNytFRDlqS1JWa0NJeVkveGxkeE4z?=
 =?utf-8?B?TWM5a0FUaEtGdmdYK0lwcXFqeUh0d3JlU3VlVGU4WDdPdGFNSENMb3JiYnQ1?=
 =?utf-8?B?OWw4OHhuRjRhaWdwYXhRbHc2QU5EN2o0Ri9VWEg4Qm04cldXRUw5VG1nZFRy?=
 =?utf-8?B?ZjBnZnNVRFZ1RXBKY2llRi9yL25FREVha3BKa0E0RVY5R0t0UkNkNVRRdEJ0?=
 =?utf-8?B?TjIzWitYNGxUUEMwNDV0aDE0MnhwT0NIMi81eGJTWXVnWk1OOVZlTk41UDFo?=
 =?utf-8?B?OUk5UXByUWc3OEhsR0pMSlJqWkFaUUV1Qk0xMG8zMEtPbFk2QmR2SnoxaVoz?=
 =?utf-8?B?OHdvQy9WbW5FbUk2YWgvK1lKY3dDOEFZbkpnNTVBZ05NVDlYaVVqNUxIaHFt?=
 =?utf-8?B?RkxObHZrdEVWYlFQYUJYZFF5QkRnR2NuWnhkZ1JqdldneFZoeFREc1AvcGdI?=
 =?utf-8?B?QXVCbEowNmJtTGhuc3ZTcmQyUHZ4YXNLOCtRQmlXUTVxeGJ6V1V0ckRod3ZU?=
 =?utf-8?B?cjhvWUtWY2EwKzNZOENkSGpwWmNFczhHbENua2dKQ0UzcU9WcWdBVzhIOG9l?=
 =?utf-8?B?STcrMjBRV2xVSlg4bDNSWElkam1tMU41dHZNdEhxL0lnVUxLb0RVM1FWbGJT?=
 =?utf-8?B?SjcwbXF0eWo4SG5QUzdUU3NuTkJIS3Awalh6Slp2ZUl4VEF6MEc4KzRDNVZ5?=
 =?utf-8?B?UTFWMWc0dElab1JJWTVOZ08zaVpSYmJxaTRPVE5KejdlSTRWWnk4dW9RZDJ1?=
 =?utf-8?Q?i8F9q+IzShNBoTeXTJ/pvc+qZ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d74ca43-c385-459a-b60f-08dd191db6b2
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7918.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2024 13:22:36.8406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bahRCItLCxNKco78xJ44StpZgBuTCtDj6RCps0Pvg/oLx2hIPlSdB36/A6r+ketzn0pyfOAuhOnMTSsugVeAww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8141
X-OriginatorOrg: intel.com


On 12/9/2024 10:19 AM, Jason Gunthorpe wrote:
> On Tue, Dec 03, 2024 at 10:41:58AM -0800, Ramesh Thomas wrote:
>> Remove the #ifdef iowrite64 and #ifdef ioread64 checks around calls to
>> 64 bit IO access. Since default implementations have been enabled, the
>> checks are not required. Such checks can hide potential bugs as well.
>> Instead check for CONFIG_64BIT to make the 64 bit IO calls only when 64
>> bit support is enabled.
> Why?
>
> The whole point of the emulation header to to avoid this?
>
> I think you would just include the header and then remove the ifdef
> entirely. Instead of vfio doing memcpy with 32 bit it will do memcpy
> internally to the io accessors?
>
> There is nothing about this that has to be atomic or something.

Ok, I will send a new patch series that only removes the check for 
ioread64 and iowrite64.

Thanks,

Ramesh


