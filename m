Return-Path: <kvm+bounces-29123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 45BAE9A32EC
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 04:33:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A3B01C21A56
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 02:33:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6F6A1509AF;
	Fri, 18 Oct 2024 02:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="yEyy3mxU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2077.outbound.protection.outlook.com [40.107.220.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E1C3D96D;
	Fri, 18 Oct 2024 02:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729218818; cv=fail; b=Q2+CXFJNg76lnzdSrKh8hkDCe6vYyWqt7KOfCPcjfyQhytMsmmKu02znrz9rd7RVsDgyUNT8A/SJyqVL+I62KY8fGpQSjtzbGdl9L45ZOQN+qQpr3311a5S+zZfo1mCxtQ7j2GT9plQadplCQFV8tuSSs4axGTdBexnIpanf6PM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729218818; c=relaxed/simple;
	bh=mJ4GXumWk/Ri5ynD+UfdwP0sNqHZ8KMLShBYa+I12J4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CScEAR3JeXgsKF+zi5IgB69wDthq+SYk7g9F84f5toXWBaTPg0qiKIkCnZ+YDPSr2zuID27+Yf1y3dBtFN4KNrUjtQWg8k+AV89LRLX7XlAK9d2b5WXZXXbuYuIIV6mGC1KnX9qMOyX5KmzIaRzj5QlmE31f/DSpKgmpdKv5X3k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=yEyy3mxU; arc=fail smtp.client-ip=40.107.220.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CY3ecGVFwImwEB8HNX3ruteLlaadYOirOuLLfLLvw6OvIpzt+YliqeR8B+sufOYsCJOqxsvBg5xrkVWYzxUXRxHxHP3JD0f1sl4t2Rsr+rzpgGa7othB5rhuCteG+3y664QsYK9q8iGOOYb/e23XwZ28iwgc/SxWd9Bui9+xC3JEgbe+E8mRDnQjIaEHL0s7S5eA8Ym2THPiQfU1vHwt1xXTQU9TcpGebftaGFmv5in7I4hgDqd7mOHcoH5dRhuQWpIqVJJM5ziRv4Me1dwgykcCJF2Bg+5O2JFm3edp1FJlamap0oJO+0SCT5Sau031Xx0piW/5V+7hks7o8V0iYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G4rUxW3QMvcFwlhIo/iKwIs7zcSKZmK+42oVRCpltYo=;
 b=CMiP3UAt05TMI3wTPjDeCwppEcYY8EbFtsoAdubNnOV/pCCJagwgzZCdD+5iC/wxrVP/RPc1g8zOly+apmy2qsIJuEeKkv0citDNyfouggKzHhwVAFiZdeNITEz21vBklgLo/5pHcRZlZLjudXeKY2w5ClF/HrjXWY2nUBVs6d/GDTNwAwbHl1DHBoZNcV7ixJQvqxKXEyxbwKIbrtzja4fgp7c4iX27ZzKuSbT4mcE+Sjbfcqu0koulHoopnRgFZnWEIre40z7hA8vwnNB3ABTukBzmjcAcpzlf5hOBAbj1T5hD0dcIFMNiliwqJxHbl4ZsJR22LJtNJ2sZI4+g2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G4rUxW3QMvcFwlhIo/iKwIs7zcSKZmK+42oVRCpltYo=;
 b=yEyy3mxUthz1nWRu8bIk0BARRZDl1QhrIiy8udC1lHc2gXL8cKin81DGUlxrtF/wpvmq52cZYB751fbybIpOWiNMHxam70zcAGZ98KWmlqdT2HUtRpDwrmHNXwyNmkxAFpBpduoF/lRt0vnJ0JtAtk+4z6cXYDLNOnNAjv9o2eY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 MN0PR12MB6344.namprd12.prod.outlook.com (2603:10b6:208:3d3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.19; Fri, 18 Oct
 2024 02:33:32 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%3]) with mapi id 15.20.8069.019; Fri, 18 Oct 2024
 02:33:32 +0000
Message-ID: <378fb9dd-dfb9-48aa-9304-18367a60af58@amd.com>
Date: Fri, 18 Oct 2024 08:03:20 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 00/14] AMD: Add Secure AVIC Guest Support
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com,
 Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
 bp@alien8.de, David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com,
 peterz@infradead.org, seanjc@google.com, pbonzini@redhat.com,
 kvm@vger.kernel.org
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <vo2oavwp2p4gbenistkq2demqtorisv24zjq2jgotuw6i5i7oy@uq5k2wcg3j5z>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <vo2oavwp2p4gbenistkq2demqtorisv24zjq2jgotuw6i5i7oy@uq5k2wcg3j5z>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0195.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:be::23) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|MN0PR12MB6344:EE_
X-MS-Office365-Filtering-Correlation-Id: ed786a8c-8d18-4309-4375-08dcef1d4203
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VWd3SVQvQVp0ZWV3ZzFyc2xneEw0YzlFSEtlREd5VGJua3IwbUJ1cTZ4bzNn?=
 =?utf-8?B?WkJQaG13R3pudG8rS2VVRjhBcVJPMVJPd0RERjB2QVg5M3o1V0NOZVRZclp4?=
 =?utf-8?B?WnlqZHIrclYybi90VzdNZkRXUE1NK09GSGowMmd1MTBSamNNNENBZnEvMXlB?=
 =?utf-8?B?M2F2RDhsemsyb3orVXNMS2E2akk0VDRTQmp5SWtjVkxNQVh3UkRlTC8rOTRS?=
 =?utf-8?B?ZUJtUUNqNWIwNU1QTFNYN3pvdS9WYXJMSndGWUdKVGlwcERTVVNpeVlKd3pM?=
 =?utf-8?B?UnNNYTZqdTI2OGJhZ2kxZktDMEdXaDFuNlhGVWdIcXd6cHJRbks1UWtnOEN2?=
 =?utf-8?B?UUNGUkZqL1R5L3lUNHNDbGtmdjlKL1FqaVJuRWIwNWZRdkIra3FqbWo3K3R5?=
 =?utf-8?B?VjJSWlF2R0NNMUVNVHlndkhrN2tyaG9vTE81bDU4bE9PRUZrM21QNTNOV25S?=
 =?utf-8?B?VjdtTGVIaFdpdEFERU1ZQXpaZ2hwc1Yva25aOHJGbWs5Zm0rbmRXMDM1eHkr?=
 =?utf-8?B?SGgzSEJIWUU2aVYxWXlqcGs2M3VyY1ZtRThVTlkvSndEU2swRXY1ODdnYjND?=
 =?utf-8?B?M25UT0ZWMG9Ma1JUTTM5SzNoVFFvcXlIYS80OU9tS2UxRFJrSjhXNGc1dTBN?=
 =?utf-8?B?Q3cvMHdMaHdHbE1ib1A0SHFNcnN3YWY1S3JiaTJTWEZEbFF2SWo5TTBHQXdC?=
 =?utf-8?B?QmJ3NFpyZk1lN1VVSUIydWpOc2NhaDNVVytWYmZ6eGxJQUFWTTBWN0FLWXJW?=
 =?utf-8?B?ZlV6RUFLejVHbDdUcnQvbVB5WWpiTnNiME9PR3JQc2N0bXlEZk81N09QL3dl?=
 =?utf-8?B?ajFzV0k1MnFRMkt5WUtDLzBwN3NrbVBpelN0OW5wZmt1SXYwemtHQ0pjNlY4?=
 =?utf-8?B?UWM3Y3V3aFRQOWhMVlNWY2p4T0s4Z01lQ0o1TlBmc1VndzZWOE0xUWd1N0tP?=
 =?utf-8?B?OEVseGVSYXhHeDQweHUxRFJtd29wRExCdHloRlFQeUdqY2xjUExOMlJvSFFS?=
 =?utf-8?B?WC9XdS9NZzJXSnJySkpJcHMvK2xaZG5wVy9jSG1WWUV1OFdCbzMxNTB4SGRt?=
 =?utf-8?B?TjJwLy8wbEpkVGpQaVNrWE1sYktJa2U4MER6L2VYM1FId1ozR3ZmL0I4VUJu?=
 =?utf-8?B?QWlURmpGaWxXRTgwTWQxb3plVXV5dGliZ3hyMVNBaThpSlhQb2cxdHVUOFJI?=
 =?utf-8?B?akl6VVNkSEJETVNqRVVIN0FhUHB5blVOaHFDcjZqUG1mdnBwL0VxNzlmaGdY?=
 =?utf-8?B?bUQ0a3lNaVBMUzVDSC9oQTNRSU94ZTk4L0Y1WXByQ1h2OWwxODltbnVkL0do?=
 =?utf-8?B?RGM3SUJhU2RsTUswMWJ2N0Z3akNydmxxcCtTZGFLUFpXcUJSU0xkOC9GTVpE?=
 =?utf-8?B?VzdscE1Cb3BLb2RPVlNDNnViRm52NE02WHJjbWVrTHkwSUkxRjJlRGMxSzhD?=
 =?utf-8?B?a3NGTXV4VHJjelZqN1BmTlFoWDlOWUoxZlJTMUEzL3EwSFRaR3NLbTkwVUJu?=
 =?utf-8?B?blMvTEsyRW5FYUx4OEJueEx2enpkYjIwN1d6RnFvTHNGSkt6djBXZldDUHY0?=
 =?utf-8?B?aDgzUHZvaGRkWEUyVGoySzhvRVgwVWtMZkgvdEhaT0hKNHhmZDRxaS9LbTQ2?=
 =?utf-8?B?dEpPNzR0RGJsYnNzbGpoUnZGcS9FL2FIZGxQYTZMYmZ6TStFSHNGOHBOdHl1?=
 =?utf-8?B?bXN3WmU1M3BUUUc0RHAxM0djTVc0RWJDWDh0Lyt3OUtiRC9NMUlkMlhCUDR0?=
 =?utf-8?Q?qfNwmRwdyGB10uxuVVfkP0EgeGYzpXxGgD2Yqy/?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZE9DcHhuVmNaa1FOYlhwSitwdkc4TTJ6ZmdhRnpkOEF4Tnh1VTFjTGdhcEt1?=
 =?utf-8?B?bUwwT2laTEV4a0R6YUFrMmljNy83dVpsMUE2WGs3ZDVVUXBpZW0vZENNbTJY?=
 =?utf-8?B?MGNqcmpBWWEyenZncXd4QW81WU9UWEUxSUtnSkxyRTU2WHRtZ1RwbGM4UTEy?=
 =?utf-8?B?WFBXdDY1OGYzWWZ1MERIUXRBV0t5SUxPa0RhYnNiYlk5NTNXZ1A1cldXbnIv?=
 =?utf-8?B?TEJlMkFtd1dIRFdYR010Q3JPYlVHSi83V2Ria21qQmFGNXQ4eDdXV2tFMjZO?=
 =?utf-8?B?V2UrTk0vcmF0cm9XNU9NQmJrMmJNTzhqdS9nNGNxTWRDUHovZ0lySU9NSkFi?=
 =?utf-8?B?SjM3d0Q2aE9NcVRabEZ5U3BJdWhmSHlaV2gvd1NoajdDWnpwd1E0ZlA4RFZy?=
 =?utf-8?B?K2txb0NCVG9rbTRBdmVpVkxuZEtEaUsyenE4UEM3Zy90VzN6ZDNvMEhNTnZC?=
 =?utf-8?B?MGR1ZStMVXFxY09xZFRFWXV1M3RFcitYVG5HWEFQZXNsYVlvd25hN0FZSXo2?=
 =?utf-8?B?YTN0ZjBDZWZHZE16UjJvVnhrTmVTZ3dHVkhILzkxNjY2bkNBamxHRUtNN2Vj?=
 =?utf-8?B?blJUS0s2T3FMVW1OaC9sRHZmbGd6d3VKanRucjBwQ25RYTVVWndTN3MwdXpl?=
 =?utf-8?B?UVlqczFXbTJZVFBHdytlWkFGT1J3OU1QcTFtYSt0a2tDZngwTm05cHdNT2R5?=
 =?utf-8?B?WEhOT3o5T1NjaWliSHlqc2dJSWVJbVhvRXI5SU44dDAzNG1pOUpGWk1JcUpH?=
 =?utf-8?B?bU92cWFCQWl2cW12Wmx1a244SEhTK1lEVDM3Y3EraERyMUxmUk5HZU9yYWov?=
 =?utf-8?B?Y0MrSU9Jdm5JMk80TUwvS1FwbWdtYXFOWkhjcDc5aFQycUpQRjZjeGFwRDMr?=
 =?utf-8?B?elpVTXY2Y1FwSkw2bndEK1RBOUtvSkowdjlYc050K25DS0pnMjNqdmR1NFo1?=
 =?utf-8?B?aFhmRHVCa2VOdUNPVVgxbzdMUW1IM2FRVFJyOGVad01QZmthQVpvSDJnS2pZ?=
 =?utf-8?B?cGsvTVN3b0M5ZUVVOU42S1dBU09MN2lUbFlPSE9ielRsSlFMd1M4eWRBM2s3?=
 =?utf-8?B?YWwwY3IxZGpkbzRRSVo2c3ZTaDhRZU9rSmNVUU1HM2ltSUlwQjNxSkwybU9T?=
 =?utf-8?B?UHo4SzMrajRsQnd6ZHpDbEwzYmxySHZDaktqSVJ2Wk5DbEhwdllHcTF3TUFX?=
 =?utf-8?B?RzRTY3E1NVcybHNMbFMxL3BSWlFBMFRrbXBHYnQ1NHlyRGQ1c2VjOHg1RTNt?=
 =?utf-8?B?WmdLUkExK2kzU1VjOVl0NVZYaHNMeXlrcFFTUElaTDhiMTRRSVVWd2ZsbHcr?=
 =?utf-8?B?WWhvYmRlelBuTUxabFBSMVhXL3EvSnJHcFA0M0ZtQTNWa29oUEpJc2tra0d5?=
 =?utf-8?B?Yy82aHl2SHhLOTExTGNucnBDMnE3WGNzR1lGUlYzdFhrZFlGV09CWlR5SlNH?=
 =?utf-8?B?Wms1M1c1OVZrYk9waXBJcU5UNzMwVUpPTWE3K0ZJNEUrK2UzUkx1enQvbWV2?=
 =?utf-8?B?U3F2b1BHbHZYQ1BjaVR1Mkpwbi9GODg2RUJWU3J2YXdrQmRpbWNLZXhDSTN6?=
 =?utf-8?B?NGRPVDdPSi9JWWZMR2lTVWNVcnQxNG1PYnp4c29iQzN3bXAzTlJJdFJGYWZJ?=
 =?utf-8?B?cXBCTllKbVg2T3RNejRZSE9kT2d1UUlwczdRSUdLeHdWejhKR2Z4d0N4eXRN?=
 =?utf-8?B?RzZ5cHZhdW8wNkFIVjl2bGRrV0lLdVhpOUNLaGt0NU1xWTcydUYwVFJrM0xV?=
 =?utf-8?B?WDlQaGMrOU8yZnkzMzNxS0R4bTc1NXBrbmY1TXNmeEpsZkp0K0pFdE4rVU1l?=
 =?utf-8?B?MFhIVUhBUURqSmtBSnlQeVpORm9yWnNmSmtSN01ncEF1M3dSenFyYmcrd3V3?=
 =?utf-8?B?eVJoNmhOU0d5RDlDa2FLK0RVclU0dmgvZ0xGSzNRRThSVXZOb0lkRlpNSEZz?=
 =?utf-8?B?M0VkZ1BDcjdiTmNCbGlCNjBML1dxZFZIUWhvRjdBcnZFdTQ3dzlvZXJBeUpV?=
 =?utf-8?B?QmJrZ05TaHV5NmhwdkRKd0JBMWxpSG8yRlgyU05yUFYybG01UHpqcW5tV2cv?=
 =?utf-8?B?YTZaZ2Vvd2RTWnEwOUhRRTlQUHhqekRacnNnSTZab3d2M2VGWkZWdkNRaHNE?=
 =?utf-8?Q?2xtzvlmC+U+CSFw/8O0Skcbn3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed786a8c-8d18-4309-4375-08dcef1d4203
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2024 02:33:32.4084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jaQHOg4mJ9kAPl4xzpGZKrnx9++v49FFZfKkPuFUO/vH7FMbSbbEt5UaAOt42fWNUpHi3qeHZTew/Y09N+L9pA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6344

Hi Kirill,

On 10/17/2024 1:53 PM, Kirill A. Shutemov wrote:
> On Fri, Sep 13, 2024 at 05:06:51PM +0530, Neeraj Upadhyay wrote:
>> Introduction
>> ------------
>>
>> Secure AVIC is a new hardware feature in the AMD64 architecture to
>> allow SEV-SNP guests to prevent hypervisor from generating unexpected
>> interrupts to a vCPU or otherwise violate architectural assumptions
>> around APIC behavior.
>>
>> One of the significant differences from AVIC or emulated x2APIC is that
>> Secure AVIC uses a guest-owned and managed APIC backing page. It also
>> introduces additional fields in both the VMCB and the Secure AVIC backing
>> page to aid the guest in limiting which interrupt vectors can be injected
>> into the guest.
>>
>> Guest APIC Backing Page
>> -----------------------
>> Each vCPU has a guest-allocated APIC backing page of size 4K, which
>> maintains APIC state for that vCPU. The x2APIC MSRs are mapped at
>> their corresposing x2APIC MMIO offset within the guest APIC backing
>> page. All x2APIC accesses by guest or Secure AVIC hardware operate
>> on this backing page. The backing page should be pinned and NPT entry
>> for it should be always mapped while the corresponding vCPU is running.
>>
>>
>> MSR Accesses
>> ------------
>> Secure AVIC only supports x2APIC MSR accesses. xAPIC MMIO offset based
>> accesses are not supported.
>>
>> Some of the MSR accesses such as ICR writes (with shorthand equal to
>> self), SELF_IPI, EOI, TPR writes are accelerated by Secure AVIC
>> hardware. Other MSR accesses generate a #VC exception. The #VC
>> exception handler reads/writes to the guest APIC backing page.
>> As guest APIC backing page is accessible to the guest, the Secure
>> AVIC driver code optimizes APIC register access by directly
>> reading/writing to the guest APIC backing page (instead of taking
>> the #VC exception route).
>>
>> In addition to the architected MSRs, following new fields are added to
>> the guest APIC backing page which can be modified directly by the
>> guest:
>>
>> a. ALLOWED_IRR
>>
>> ALLOWED_IRR vector indicates the interrupt vectors which the guest
>> allows the hypervisor to send. The combination of host-controlled
>> REQUESTED_IRR vectors (part of VMCB) and ALLOWED_IRR is used by
>> hardware to update the IRR vectors of the Guest APIC backing page.
>>
>> #Offset        #bits        Description
>> 204h           31:0         Guest allowed vectors 0-31
>> 214h           31:0         Guest allowed vectors 32-63
>> ...
>> 274h           31:0         Guest allowed vectors 224-255
>>
>> ALLOWED_IRR is meant to be used specifically for vectors that the
>> hypervisor is allowed to inject, such as device interrupts.  Interrupt
>> vectors used exclusively by the guest itself (like IPI vectors) should
>> not be allowed to be injected into the guest for security reasons.
>>
>> b. NMI Request
>>  
>> #Offset        #bits        Description
>> 278h           0            Set by Guest to request Virtual NMI
>>
>>
>> LAPIC Timer Support
>> -------------------
>> LAPIC timer is emulated by hypervisor. So, APIC_LVTT, APIC_TMICT and
>> APIC_TDCR, APIC_TMCCT APIC registers are not read/written to the guest
>> APIC backing page and are communicated to the hypervisor using SVM_EXIT_MSR
>> VMGEXIT. 
>>
>> IPI Support
>> -----------
>> Only SELF_IPI is accelerated by Secure AVIC hardware. Other IPIs require
>> writing (from the Secure AVIC driver) to the IRR vector of the target CPU
>> backing page and then issuing VMGEXIT for the hypervisor to notify the
>> target vCPU.
>>
>> Driver Implementation Open Points
>> ---------------------------------
>>
>> The Secure AVIC driver only supports physical destination mode. If
>> logical destination mode need to be supported, then a separate x2apic
>> driver would be required for supporting logical destination mode.
>>
>> Setting of ALLOWED_IRR vectors is done from vector.c for IOAPIC and MSI
>> interrupts. ALLOWED_IRR vector is not cleared when an interrupt vector
>> migrates to different CPU. Using a cleaner approach to manage and
>> configure allowed vectors needs more work.
>>
>>
>> Testing
>> -------
>>
>> This series is based on top of commit 196145c606d0 "Merge
>> tag 'clk-fixes-for-linus' of
>> git://git.kernel.org/pub/scm/linux/kernel/git/clk/linux."
>>
>> Host Secure AVIC support patch series is at [1].
>>
>> Following tests are done:
>>
>> 1) Boot to Prompt using initramfs and ubuntu fs.
>> 2) Verified timer and IPI as part of the guest bootup.
>> 3) Verified long run SCF TORTURE IPI test.
>> 4) Verified FIO test with NVME passthrough.
> 
> One case that is missing is kexec.
> 
> If the first kernel set ALLOWED_IRR, but the target kernel doesn't know
> anything about Secure AVIC, there are going to be a problem I assume.
> 
> I think we need ->setup() counterpart (->teardown() ?) to get
> configuration back to the boot state. And get it called from kexec path.
> 

Agree, I haven't fully investigated the changes required to support kexec.
Yes, teardown step might be required to disable Secure AVIC in control msr
and possibly resetting other Secure AVIC configuration.

Thanks for pointing it out! I will update the details with kexec support
being missing in this series.


- Neeraj


