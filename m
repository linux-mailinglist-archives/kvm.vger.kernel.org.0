Return-Path: <kvm+bounces-33714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D7129F0809
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 10:38:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B9F9168A15
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 09:38:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C401C1B21BA;
	Fri, 13 Dec 2024 09:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="U5gCXpq/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2046.outbound.protection.outlook.com [40.107.96.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9C91AD403;
	Fri, 13 Dec 2024 09:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734082680; cv=fail; b=U02HEYFNJwE5iwMcuTQ7RnqY17yehqBgWvHFely+76PAGOhd8LhJJ36N1hG4Ah0tV03DU8lsebVz5loZHee5kvAHeFLbR3IGKJTZAIf8svhH2jyNTPo2pV880Ec2IL8rt5Yo61ccG+u2Gade/zqJ4mOs7YzuAjKUdFteXG/tiwY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734082680; c=relaxed/simple;
	bh=+07WrP7OHgo8NxONLumzOJYj32vhKZyCfaK6uG9c5tY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dRZPe0lyoOgStDOYE0S7LSQEvFt/e53bKX3v5qUa/4oRmAfXlomJ7AS5v757/lyBPtu3Yy4tD2eN7lyY3kM0YaKZRVy67x6bQDKuB1+oITLw1fuDF54vyINbsk/FsoJC68gt92CoV0kMm0l8kZJf/N2khpA6VaTWDvp5ZPNKDlM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=U5gCXpq/; arc=fail smtp.client-ip=40.107.96.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w89AY4in3nfEFLDdAn7wAVGizYcBUEq4nu5mrqkSOjhHK1eE4wV4WVsC4o3diz/BgdwLwPoz2Pw6yNi2m8uMfe/vkdvJviAYxTi+9QJLN1oAPfTMgPQWa3Bb+dr3FWHrNdKMnI1h8Z0jdOZL8VONOuIFNQcRqwHfs+JeVLIrBMaaTBTsCn/O/wQ+q3CrYPaMFy0NDLsmpY7a9LvGHQta/Nh3wLjEJqb6/1pv3D6imIb9eYf2s2GZxHZXVpIeRHJAcr6CIYX7fCFYw19ET70X46syaNaecPDfBP9ip5FX54UgPbM/7aE6MtpscAh2SKKFvRVVczfnCseJujfH8AfNwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yyROM9vxSdKkdR+5OvYkSlaGb6gKKR3V4Eae5l7BQ2g=;
 b=v4G0D02ypyNPM4xw9mwx8DGXS7+N4XcA1cPrLq+mT+xFlx1ikMAtsT8e6+bGTqU/iVZkCSn2sqSBDgUuyvV1/Fd2450d6WoS/ADERpF+mfERhCbqxXpTC6ehHx+s6IW02vxZ8T9uqSEXjDBiwvRrvlbjy+u2QGNmr10CTAA12qYRv+bQZVUCJHdZxkyy0LtbNkf3Za5Nla+Qx7lgBZUTMN/coOV8dlbM45TEc2kO+RhYfK3hHTnK0Pfbwog1WOLRFvXh7H+RjykiBtB2Miv3qyy4LsMjaV9hA1dGOk7LBBWTONSCM6MqyEBTLr6UnQU/YWPMhIu6PZTGSVRoEL/yDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yyROM9vxSdKkdR+5OvYkSlaGb6gKKR3V4Eae5l7BQ2g=;
 b=U5gCXpq//B3wYN8G3yaU8jwGBhBxpW0p7QEI1YbthYBv35kAfl/hMX+Dk4ePvQaIGQGXnx7iZH6maIHQUDmOpI4MZSEOAOIEMYGbyC45q+Iu0zNZQ+4mnJ3N8DbKbo0pxr89v51Rw4ApC2IyzVW8iIapYeZTWcgy/qu74I6b8DM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by MN2PR12MB4238.namprd12.prod.outlook.com (2603:10b6:208:199::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Fri, 13 Dec
 2024 09:37:55 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291%6]) with mapi id 15.20.8251.015; Fri, 13 Dec 2024
 09:37:55 +0000
Message-ID: <399bf978-31e9-42f3-a02c-85ec06960cc0@amd.com>
Date: Fri, 13 Dec 2024 15:07:38 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 09/58] perf: Add a EVENT_GUEST flag
To: Mingwei Zhang <mizhang@google.com>, Kan Liang <kan.liang@intel.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>, Zhenyu Wang
 <zhenyuw@linux.intel.com>, Manali Shukla <manali.shukla@amd.com>,
 Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-10-mizhang@google.com>
Content-Language: en-US
From: Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <20240801045907.4010984-10-mizhang@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0239.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:eb::18) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5712:EE_|MN2PR12MB4238:EE_
X-MS-Office365-Filtering-Correlation-Id: 32a8b0db-c990-493d-2b46-08dd1b59d1d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WUo1a0RXc3dvS3NpMlI5VllZbStKRzROOUdGelZ2VmhRYi90OGRBd290eHV3?=
 =?utf-8?B?WkxBM2doVUdlSTREYVpJUFdRa0lKcjJ6d3JkL0NDQlBiRmRXYi9TY1pzblN3?=
 =?utf-8?B?dTRqeXJSUUE4c0w5SndFTUgrTzJINVdlZmRkU3Y5eG5lVDJmRGUvNVh1dUVk?=
 =?utf-8?B?VXd5eXZLckE5VzZXeFJRR1lCVkc5MGRUM2pzN05JOUJ1WlZVTzhBVnNHNXhD?=
 =?utf-8?B?aGU4Ylh6bXN0a0dqVmFyazFWTGRRcDh2M29CMHk4aVZxckVuNWFuS0c1K082?=
 =?utf-8?B?aFNJeStmMWFKWHg2VW1oSG5LNVNNaWhJMjJkQ1hvRkpJMm1hZUs2cXJRME51?=
 =?utf-8?B?ZExOZXhibFoyYzVxVTRPeWs4TEtJaEw5OHhidTdSVmNVdlE5Vlk0aFZNSlo3?=
 =?utf-8?B?bU9oSHl6SjZ6THRrVlBWcmMzemlYMDRnVkQ1Mk5POUVPb2JROG1GZCtoZEVG?=
 =?utf-8?B?T0FSaWxwMTY3ZHVyOUdITzR5OGU2MUFOSGIrcW1WVlhuN0hHV3I2eGEzMFJE?=
 =?utf-8?B?MzhobTBrYlY3YzFaT28xa0tiUDZYYXVCNjhsRmRvdFM3T014aUY5ZlFNOWlx?=
 =?utf-8?B?SHRybFRJL2ROb2tKQlR6UVk0TkFMcHlLckxnenNsZytVaEZwNU9NSkM3QzNu?=
 =?utf-8?B?cDN3cXNhUmoza1pNb2NQVmxQc282VmlQbHV4dGlzUk1DeXl2VjFobVpaZ3lB?=
 =?utf-8?B?MFhYeDQ3SUlXTG8rRDFZS1MwUHVXTFVnRXIwSnRkcVBhR0RHSHN5OEVXekRX?=
 =?utf-8?B?aEc0cHFRaCsrdmVpOWdtdERlZFU2S1BGSTRhUTBCeW5HMVJUSUM0U2JrM2NF?=
 =?utf-8?B?Nm10WFhScS9NSU5oVWxOUUJqQlhZT21lQ1VIRVZxUU1NRzFpSlpERmNmOC9K?=
 =?utf-8?B?ZkpBOVBySlczeWo5b3AyRDFYS0x0Tm9MbU5HUGF3WG1LaWpjSi9JQ1U2RS95?=
 =?utf-8?B?K3JISFdhdkE4K0lURmpiYWcyMFJKRWNOWENpRkNsTjA1RFpKNGk2RS9GYkUy?=
 =?utf-8?B?eVd5L2pTWTVwTVVncXpSNWlEbUd1cHN0YTYrYWl1Z1llRVdLd2JwdWp1bG5G?=
 =?utf-8?B?ZEppSi9CdmdUckpnbjc5MUlFY25vbHBZYkpHSUxab0puZEZIMDJvWDRmazZh?=
 =?utf-8?B?VmpselZYdkZ2TnpTRm94Nk1jQWV4SWxld0R1dnQxSW1CZFhCaFpDWnpubkR3?=
 =?utf-8?B?NFZTcW1VWHZkSGNEOExZREdBQklhRkxJc3llYmZVclp6TjBtNzBDOUNwaVBl?=
 =?utf-8?B?NWU0aW5hMHduSCtadUc4V3ozL0Nxc2Q2eGZYQVc4UFhnZUJQRnRoWTl5VDlR?=
 =?utf-8?B?ZlROdlBqZktKTWdLc1l6SnBTMzBGc1NDZGZkMnNNWEtacXhvZGI0UEErWWVo?=
 =?utf-8?B?M2J0aU5vL0VpRlVuYVJiWFpPcWhiYllEdS9PYlpYZUNabTRXVmRPR3FrYzlq?=
 =?utf-8?B?eVpsLzhiaWZFSTE2aWlRTjBDZ29xNzF3UFZiRWRubUkxSTlxKzdFenRVSG5T?=
 =?utf-8?B?S1U1Z2RBbklqOUFKcTBqYWx2OEFVZWE3RDhzUXJZbmpON2xGUEIwSUF6b1dF?=
 =?utf-8?B?VVhpdG0vMkVOOVZTUFRWalFRZFdIZGJpOFcwRDBydkZLWFN3ZDh1Y3FJYnBj?=
 =?utf-8?B?UFJzd3MwZFdlaGxSVldmNndkZUxKNjhGQ1RTbTNEOWhtamV2b0VCaWkxOXg0?=
 =?utf-8?B?eFVIZEhLRzV1TUVZd25vdlpabFBNdEFpM2pXaXY1YnRUL01PM21leXg2TjBq?=
 =?utf-8?B?WlJjVmZoUFV5QURCOTRrbWw0SDVRdGE5S1dTZk5wQUdFOXNPaVQwcmlzaVMx?=
 =?utf-8?B?NDR2SXVncTI2U1JnZjFrbmhocGQ0bjFtYXpSRTRGWUQzQmMxVnlUT0pOdFRu?=
 =?utf-8?Q?fQ2Pv6rGCy9Wo?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aUFyRVhmMUIzRWZGYkpqZnFuN0g4MkZIWTRUbUhONzgrOEtGR3NBcUp2MzVS?=
 =?utf-8?B?UjhuMG9aY2NUVis5WmR3Y055OVMwdUVQYVAyY1hKTlJNNEJhMHNPNm5BMHNH?=
 =?utf-8?B?MDVjL2NEcVh3VEFoZUxZc3FUWjRmcFRtKzkwbHVtdU1ZdEhBaE5UK3YrTVhW?=
 =?utf-8?B?MEh1OTNtbUY4RWhxWXZ1aTJXWVZ2dGdtckMwYUh6bFdwWVByandmYUtRdG9p?=
 =?utf-8?B?Z29LUnJOYXoxWTVma0o0bTh6akZBQndOZndIem1pL3dXZVVXNm1VNG15d1BS?=
 =?utf-8?B?TUtGbjF3cUZlcVpuelplamZBMVBFcDJad0k2bFBqaUppSTYrV1cvZE9oOXk0?=
 =?utf-8?B?N3p5Z0FCMUZ0T0U5M2V0QUJXVEo1Q1JzTytFTlkrYlZJQjVCMU5Mci9oZWZ2?=
 =?utf-8?B?eENmWDczVGkyTnJ5dm54czQ1RXNEdUUreWJlMEJnSFl2ODdySjNvRVlsNlRm?=
 =?utf-8?B?ZTAvaVd6NDlDd2NmZzJsdG9TdlY3SEFvaWViMXAwZU8zZ3BSczc5ZjY2VUVy?=
 =?utf-8?B?M0FtVmhVTXUwWFUwaVByL3RyRVJ4VGl6M3ZRc1o5ZmpyNG53Q3M4ODZBQ285?=
 =?utf-8?B?SXFpQUw5bFdBbC9SQkNmV3ZEN1BuZm9BWVhLWmk5aFQxU044c1FJRFAyUDZp?=
 =?utf-8?B?V3QrZDFrQWphSzIxRHBjRkcxVkM0RHhpTStCKzkvYXVNRUNZUEdrZmVWblBh?=
 =?utf-8?B?VmszanV1SENJK3c1YXd3bHROOVpSS3gvSnhmaTkveDJCOWMrdTRCNncvTXdS?=
 =?utf-8?B?YnVWS3k3eDkxQXdDMkxHQUJ5NUlHdS9venFJLy9SeU9QWVJMWHRDN3ovdTVW?=
 =?utf-8?B?UUdmRjhTRzVlZXk4M0hCR0JMMDB5SkFEaXhTV2djM1BYcVM1anVxYWo1V3cx?=
 =?utf-8?B?dG95UnVjZ0J6eU0vcFRpWTMyeGFpT0x0enFTNXlEaENDMXlzdkVWQk96bHhQ?=
 =?utf-8?B?dnl6cmd3MmpyTWVUcmpjQ3E2cG1KaUZKSGNFYXZCei9pOVBrT2l5NmpSZStR?=
 =?utf-8?B?d2hnUElGYVE3N2pFZXlETnlrWDRrUDRydngwdHZyWHFiRk1pbVFLN2JxWjFo?=
 =?utf-8?B?U0dBR3RyZUhyRUV6QVpTNlpQMHF2b1ArbE55OFEzYnlPeVF6T0VlcUtvZWNa?=
 =?utf-8?B?blRSeEFTcVZneUVWeXBrbjRCazlZaFcxRDJiby9MV2NrbzBBRnRPR3I5Q3ph?=
 =?utf-8?B?SVdtV1hRUDdMODRZd0VyQkZKVm56VVM2TVF2TjhZVjlwYVh0TlVBRFlPdGhV?=
 =?utf-8?B?elpBcGJJdkx1QmZ4bHNEZzMzUVdxamFkU043UUROTFoycnZPTDJnVVdNZUdT?=
 =?utf-8?B?ZFhuZ0g5eWtOT2IzK2JPWWg3WWczQ2ViaWEzNTNhd2R6QmZ5SERiZVErZWFL?=
 =?utf-8?B?NXl1UkREY1p0REFsa1UwWGxPNGdPbjRYdkYyYUJ6K0Z2eCtReHRtRi84bDZ4?=
 =?utf-8?B?Yko3U1Vmazc4cDZmUCtvM3kwa1pRV3RZNThpSFBmL0VVK2hMOS9yREh3UUdj?=
 =?utf-8?B?bEwranl1KzN3YXV0Q3NKYkZKTzFsTXVUaldQOXNyT21MNEdYNUhhZUV6VkFC?=
 =?utf-8?B?UkVIY3FlYzEwNGRNUUVFZ2xVMHJYQnA4b2cyYkdHQWdMdE9LYzEvQjhOVWxE?=
 =?utf-8?B?OExIakZSb3VZWTNXU1RVeDN0TDA0MG1XeUgzd2s5V080SUkvVXNjL09nYTVD?=
 =?utf-8?B?S2hIQWoxQlhzT2F2dlQxQUVoeTcrMVRVdmVpbDUzRW1TMzBkNjVpK3NLOXFi?=
 =?utf-8?B?TXBIMktVZXlrTXlpOHcxOWs4U20xSzB6bzEzd25ZWThQWU9mYnkwbU5vSVBP?=
 =?utf-8?B?aWVPb0NwTEJ3dzdLUHdSM0I1RGtMcDMvNWxzZkZ1L0IyM3g4Z29mdDhXR0lP?=
 =?utf-8?B?RGdPRFVrUFVtdWJseFppWGpJUVZaL3ltdTljd2xKVjN0UkswWjdWSjRjc2Qw?=
 =?utf-8?B?SDhPeW5tNS91RC9MSityZnhWUmlBV1l6L2EzQ2NHZHYwa2YwMG1kVHFpTjVy?=
 =?utf-8?B?MkZBcmQ1OFFnNkY5Z0RlRGxCVjNDVER5U0hKVVFqODA4Q0lUOGsxYjhpSGR6?=
 =?utf-8?B?VEtEbXRBWnFBMGFGRG9QQ2l1UXlqQzM4Sng4RnF0ZmV1QmZYWmlmTE95eVVM?=
 =?utf-8?Q?SmfzGPIlEmx45D36J36a5d8n6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32a8b0db-c990-493d-2b46-08dd1b59d1d9
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2024 09:37:54.8732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PSdiToPSyiR2W75tfgfL0x9WT/qjyZ5rgBCzRdEqDX7GhxHy/P9RiWUa1wlo8vkpRQRB53c81rjvSR97pay1IA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4238

On 8/1/2024 10:28 AM, Mingwei Zhang wrote:
> From: Kan Liang <kan.liang@linux.intel.com>
> 
> Current perf doesn't explicitly schedule out all exclude_guest events
> while the guest is running. There is no problem with the current
> emulated vPMU. Because perf owns all the PMU counters. It can mask the
> counter which is assigned to an exclude_guest event when a guest is
> running (Intel way), or set the corresponding HOSTONLY bit in evsentsel
> (AMD way). The counter doesn't count when a guest is running.
> 
> However, either way doesn't work with the introduced passthrough vPMU.
> A guest owns all the PMU counters when it's running. The host should not
> mask any counters. The counter may be used by the guest. The evsentsel
> may be overwritten.
> 
> Perf should explicitly schedule out all exclude_guest events to release
> the PMU resources when entering a guest, and resume the counting when
> exiting the guest.
> 
> It's possible that an exclude_guest event is created when a guest is
> running. The new event should not be scheduled in as well.
> 
> The ctx time is shared among different PMUs. The time cannot be stopped
> when a guest is running. It is required to calculate the time for events
> from other PMUs, e.g., uncore events. Add timeguest to track the guest
> run time. For an exclude_guest event, the elapsed time equals
> the ctx time - guest time.
> Cgroup has dedicated times. Use the same method to deduct the guest time
> from the cgroup time as well.
> 
> Co-developed-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  include/linux/perf_event.h |   6 ++
>  kernel/events/core.c       | 178 +++++++++++++++++++++++++++++++------
>  2 files changed, 155 insertions(+), 29 deletions(-)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index e22cdb6486e6..81a5f8399cb8 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -952,6 +952,11 @@ struct perf_event_context {
>  	 */
>  	struct perf_time_ctx		time;
>  
> +	/*
> +	 * Context clock, runs when in the guest mode.
> +	 */
> +	struct perf_time_ctx		timeguest;
> +
>  	/*
>  	 * These fields let us detect when two contexts have both
>  	 * been cloned (inherited) from a common ancestor.
> @@ -1044,6 +1049,7 @@ struct bpf_perf_event_data_kern {
>   */
>  struct perf_cgroup_info {
>  	struct perf_time_ctx		time;
> +	struct perf_time_ctx		timeguest;
>  	int				active;
>  };
>  
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index c25e2bf27001..57648736e43e 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -376,7 +376,8 @@ enum event_type_t {
>  	/* see ctx_resched() for details */
>  	EVENT_CPU = 0x8,
>  	EVENT_CGROUP = 0x10,
> -	EVENT_FLAGS = EVENT_CGROUP,
> +	EVENT_GUEST = 0x20,
> +	EVENT_FLAGS = EVENT_CGROUP | EVENT_GUEST,
>  	EVENT_ALL = EVENT_FLEXIBLE | EVENT_PINNED,
>  };
>  
> @@ -407,6 +408,7 @@ static atomic_t nr_include_guest_events __read_mostly;
>  
>  static atomic_t nr_mediated_pmu_vms;
>  static DEFINE_MUTEX(perf_mediated_pmu_mutex);
> +static DEFINE_PER_CPU(bool, perf_in_guest);
>  
>  /* !exclude_guest event of PMU with PERF_PMU_CAP_PASSTHROUGH_VPMU */
>  static inline bool is_include_guest_event(struct perf_event *event)
> @@ -706,6 +708,10 @@ static bool perf_skip_pmu_ctx(struct perf_event_pmu_context *pmu_ctx,
>  	if ((event_type & EVENT_CGROUP) && !pmu_ctx->nr_cgroups)
>  		return true;
>  
> +	if ((event_type & EVENT_GUEST) &&
> +	    !(pmu_ctx->pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU))
> +		return true;
> +
>  	return false;
>  }
>  
> @@ -770,12 +776,21 @@ static inline int is_cgroup_event(struct perf_event *event)
>  	return event->cgrp != NULL;
>  }
>  
> +static inline u64 __perf_event_time_ctx(struct perf_event *event,
> +					struct perf_time_ctx *time,
> +					struct perf_time_ctx *timeguest);
> +
> +static inline u64 __perf_event_time_ctx_now(struct perf_event *event,
> +					    struct perf_time_ctx *time,
> +					    struct perf_time_ctx *timeguest,
> +					    u64 now);
> +
>  static inline u64 perf_cgroup_event_time(struct perf_event *event)
>  {
>  	struct perf_cgroup_info *t;
>  
>  	t = per_cpu_ptr(event->cgrp->info, event->cpu);
> -	return t->time.time;
> +	return __perf_event_time_ctx(event, &t->time, &t->timeguest);
>  }
>  
>  static inline u64 perf_cgroup_event_time_now(struct perf_event *event, u64 now)
> @@ -784,9 +799,9 @@ static inline u64 perf_cgroup_event_time_now(struct perf_event *event, u64 now)
>  
>  	t = per_cpu_ptr(event->cgrp->info, event->cpu);
>  	if (!__load_acquire(&t->active))
> -		return t->time.time;
> -	now += READ_ONCE(t->time.offset);
> -	return now;
> +		return __perf_event_time_ctx(event, &t->time, &t->timeguest);
> +
> +	return __perf_event_time_ctx_now(event, &t->time, &t->timeguest, now);
>  }
>  
>  static inline void update_perf_time_ctx(struct perf_time_ctx *time, u64 now, bool adv);
> @@ -796,6 +811,18 @@ static inline void __update_cgrp_time(struct perf_cgroup_info *info, u64 now, bo
>  	update_perf_time_ctx(&info->time, now, adv);
>  }
>  
> +static inline void __update_cgrp_guest_time(struct perf_cgroup_info *info, u64 now, bool adv)
> +{
> +	update_perf_time_ctx(&info->timeguest, now, adv);
> +}
> +
> +static inline void update_cgrp_time(struct perf_cgroup_info *info, u64 now)
> +{
> +	__update_cgrp_time(info, now, true);
> +	if (__this_cpu_read(perf_in_guest))
> +		__update_cgrp_guest_time(info, now, true);
> +}
> +
>  static inline void update_cgrp_time_from_cpuctx(struct perf_cpu_context *cpuctx, bool final)
>  {
>  	struct perf_cgroup *cgrp = cpuctx->cgrp;
> @@ -809,7 +836,7 @@ static inline void update_cgrp_time_from_cpuctx(struct perf_cpu_context *cpuctx,
>  			cgrp = container_of(css, struct perf_cgroup, css);
>  			info = this_cpu_ptr(cgrp->info);
>  
> -			__update_cgrp_time(info, now, true);
> +			update_cgrp_time(info, now);
>  			if (final)
>  				__store_release(&info->active, 0);
>  		}
> @@ -832,11 +859,11 @@ static inline void update_cgrp_time_from_event(struct perf_event *event)
>  	 * Do not update time when cgroup is not active
>  	 */
>  	if (info->active)
> -		__update_cgrp_time(info, perf_clock(), true);
> +		update_cgrp_time(info, perf_clock());
>  }
>  
>  static inline void
> -perf_cgroup_set_timestamp(struct perf_cpu_context *cpuctx)
> +perf_cgroup_set_timestamp(struct perf_cpu_context *cpuctx, bool guest)
>  {
>  	struct perf_event_context *ctx = &cpuctx->ctx;
>  	struct perf_cgroup *cgrp = cpuctx->cgrp;
> @@ -856,8 +883,12 @@ perf_cgroup_set_timestamp(struct perf_cpu_context *cpuctx)
>  	for (css = &cgrp->css; css; css = css->parent) {
>  		cgrp = container_of(css, struct perf_cgroup, css);
>  		info = this_cpu_ptr(cgrp->info);
> -		__update_cgrp_time(info, ctx->time.stamp, false);
> -		__store_release(&info->active, 1);
> +		if (guest) {
> +			__update_cgrp_guest_time(info, ctx->time.stamp, false);
> +		} else {
> +			__update_cgrp_time(info, ctx->time.stamp, false);
> +			__store_release(&info->active, 1);
> +		}
>  	}
>  }
>  
> @@ -1061,7 +1092,7 @@ static inline int perf_cgroup_connect(pid_t pid, struct perf_event *event,
>  }
>  
>  static inline void
> -perf_cgroup_set_timestamp(struct perf_cpu_context *cpuctx)
> +perf_cgroup_set_timestamp(struct perf_cpu_context *cpuctx, bool guest)
>  {
>  }
>  
> @@ -1488,16 +1519,34 @@ static inline void update_perf_time_ctx(struct perf_time_ctx *time, u64 now, boo
>   */
>  static void __update_context_time(struct perf_event_context *ctx, bool adv)
>  {
> -	u64 now = perf_clock();
> +	lockdep_assert_held(&ctx->lock);
> +
> +	update_perf_time_ctx(&ctx->time, perf_clock(), adv);
> +}
>  
> +static void __update_context_guest_time(struct perf_event_context *ctx, bool adv)
> +{
>  	lockdep_assert_held(&ctx->lock);
>  
> -	update_perf_time_ctx(&ctx->time, now, adv);
> +	/* must be called after __update_context_time(); */
> +	update_perf_time_ctx(&ctx->timeguest, ctx->time.stamp, adv);
>  }
>  
>  static void update_context_time(struct perf_event_context *ctx)
>  {
>  	__update_context_time(ctx, true);
> +	if (__this_cpu_read(perf_in_guest))
> +		__update_context_guest_time(ctx, true);
> +}
> +
> +static inline u64 __perf_event_time_ctx(struct perf_event *event,
> +					struct perf_time_ctx *time,
> +					struct perf_time_ctx *timeguest)
> +{
> +	if (event->attr.exclude_guest)
> +		return time->time - timeguest->time;
> +	else
> +		return time->time;
>  }
>  
>  static u64 perf_event_time(struct perf_event *event)
> @@ -1510,7 +1559,26 @@ static u64 perf_event_time(struct perf_event *event)
>  	if (is_cgroup_event(event))
>  		return perf_cgroup_event_time(event);
>  
> -	return ctx->time.time;
> +	return __perf_event_time_ctx(event, &ctx->time, &ctx->timeguest);
> +}
> +
> +static inline u64 __perf_event_time_ctx_now(struct perf_event *event,
> +					    struct perf_time_ctx *time,
> +					    struct perf_time_ctx *timeguest,
> +					    u64 now)
> +{
> +	/*
> +	 * The exclude_guest event time should be calculated from
> +	 * the ctx time -  the guest time.
> +	 * The ctx time is now + READ_ONCE(time->offset).
> +	 * The guest time is now + READ_ONCE(timeguest->offset).
> +	 * So the exclude_guest time is
> +	 * READ_ONCE(time->offset) - READ_ONCE(timeguest->offset).
> +	 */
> +	if (event->attr.exclude_guest && __this_cpu_read(perf_in_guest))
> +		return READ_ONCE(time->offset) - READ_ONCE(timeguest->offset);
> +	else
> +		return now + READ_ONCE(time->offset);
>  }
>  
>  static u64 perf_event_time_now(struct perf_event *event, u64 now)
> @@ -1524,10 +1592,9 @@ static u64 perf_event_time_now(struct perf_event *event, u64 now)
>  		return perf_cgroup_event_time_now(event, now);
>  
>  	if (!(__load_acquire(&ctx->is_active) & EVENT_TIME))
> -		return ctx->time.time;
> +		return __perf_event_time_ctx(event, &ctx->time, &ctx->timeguest);
>  
> -	now += READ_ONCE(ctx->time.offset);
> -	return now;
> +	return __perf_event_time_ctx_now(event, &ctx->time, &ctx->timeguest, now);
>  }
>  
>  static enum event_type_t get_event_type(struct perf_event *event)
> @@ -3334,9 +3401,15 @@ ctx_sched_out(struct perf_event_context *ctx, enum event_type_t event_type)
>  	 * would only update time for the pinned events.
>  	 */
>  	if (is_active & EVENT_TIME) {
> +		bool stop;
> +
> +		/* vPMU should not stop time */
> +		stop = !(event_type & EVENT_GUEST) &&
> +		       ctx == &cpuctx->ctx;
> +
>  		/* update (and stop) ctx time */
>  		update_context_time(ctx);
> -		update_cgrp_time_from_cpuctx(cpuctx, ctx == &cpuctx->ctx);
> +		update_cgrp_time_from_cpuctx(cpuctx, stop);
>  		/*
>  		 * CPU-release for the below ->is_active store,
>  		 * see __load_acquire() in perf_event_time_now()
> @@ -3354,7 +3427,18 @@ ctx_sched_out(struct perf_event_context *ctx, enum event_type_t event_type)
>  			cpuctx->task_ctx = NULL;
>  	}
>  
> -	is_active ^= ctx->is_active; /* changed bits */
> +	if (event_type & EVENT_GUEST) {
> +		/*
> +		 * Schedule out all !exclude_guest events of PMU
> +		 * with PERF_PMU_CAP_PASSTHROUGH_VPMU.
> +		 */
> +		is_active = EVENT_ALL;
> +		__update_context_guest_time(ctx, false);
> +		perf_cgroup_set_timestamp(cpuctx, true);
> +		barrier();
> +	} else {
> +		is_active ^= ctx->is_active; /* changed bits */
> +	}
>  
>  	list_for_each_entry(pmu_ctx, &ctx->pmu_ctx_list, pmu_ctx_entry) {
>  		if (perf_skip_pmu_ctx(pmu_ctx, event_type))
> @@ -3853,10 +3937,15 @@ static inline void group_update_userpage(struct perf_event *group_event)
>  		event_update_userpage(event);
>  }
>  
> +struct merge_sched_data {
> +	int can_add_hw;
> +	enum event_type_t event_type;
> +};
> +
>  static int merge_sched_in(struct perf_event *event, void *data)
>  {
>  	struct perf_event_context *ctx = event->ctx;
> -	int *can_add_hw = data;
> +	struct merge_sched_data *msd = data;
>  
>  	if (event->state <= PERF_EVENT_STATE_OFF)
>  		return 0;
> @@ -3864,13 +3953,22 @@ static int merge_sched_in(struct perf_event *event, void *data)
>  	if (!event_filter_match(event))
>  		return 0;
>  
> -	if (group_can_go_on(event, *can_add_hw)) {
> +	/*
> +	 * Don't schedule in any exclude_guest events of PMU with
> +	 * PERF_PMU_CAP_PASSTHROUGH_VPMU, while a guest is running.
> +	 */
> +	if (__this_cpu_read(perf_in_guest) && event->attr.exclude_guest &&
> +	    event->pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU &&
> +	    !(msd->event_type & EVENT_GUEST))
> +		return 0;
> +

It is possible for event groups to have a mix of software and core PMU events.
If the group leader is a software event, event->pmu will point to the software
PMU but event->pmu_ctx->pmu will point to the core PMU. When perf_in_guest is
true for a CPU and the group leader is passed to merge_sched_in(), the condition
above fails as the software PMU does not have PERF_PMU_CAP_PASSTHROUGH_VPMU
capability. This can lead to group_sched_in() getting called later where all
the sibling events, which includes core PMU events that are not supposed to
be scheduled in, to be brought in. So event->pmu_ctx->pmu->capabilities needs
to be looked at instead.

> +	if (group_can_go_on(event, msd->can_add_hw)) {
>  		if (!group_sched_in(event, ctx))
>  			list_add_tail(&event->active_list, get_event_list(event));
>  	}
>  
>  	if (event->state == PERF_EVENT_STATE_INACTIVE) {
> -		*can_add_hw = 0;
> +		msd->can_add_hw = 0;
>  		if (event->attr.pinned) {
>  			perf_cgroup_event_disable(event, ctx);
>  			perf_event_set_state(event, PERF_EVENT_STATE_ERROR);
> @@ -3889,11 +3987,15 @@ static int merge_sched_in(struct perf_event *event, void *data)
>  
>  static void pmu_groups_sched_in(struct perf_event_context *ctx,
>  				struct perf_event_groups *groups,
> -				struct pmu *pmu)
> +				struct pmu *pmu,
> +				enum event_type_t event_type)
>  {
> -	int can_add_hw = 1;
> +	struct merge_sched_data msd = {
> +		.can_add_hw = 1,
> +		.event_type = event_type,
> +	};
>  	visit_groups_merge(ctx, groups, smp_processor_id(), pmu,
> -			   merge_sched_in, &can_add_hw);
> +			   merge_sched_in, &msd);
>  }
>  
>  static void ctx_groups_sched_in(struct perf_event_context *ctx,
> @@ -3905,14 +4007,14 @@ static void ctx_groups_sched_in(struct perf_event_context *ctx,
>  	list_for_each_entry(pmu_ctx, &ctx->pmu_ctx_list, pmu_ctx_entry) {
>  		if (perf_skip_pmu_ctx(pmu_ctx, event_type))
>  			continue;
> -		pmu_groups_sched_in(ctx, groups, pmu_ctx->pmu);
> +		pmu_groups_sched_in(ctx, groups, pmu_ctx->pmu, event_type);
>  	}
>  }
>  
>  static void __pmu_ctx_sched_in(struct perf_event_context *ctx,
>  			       struct pmu *pmu)
>  {
> -	pmu_groups_sched_in(ctx, &ctx->flexible_groups, pmu);
> +	pmu_groups_sched_in(ctx, &ctx->flexible_groups, pmu, 0);
>  }
>  
>  static void
> @@ -3927,9 +4029,11 @@ ctx_sched_in(struct perf_event_context *ctx, enum event_type_t event_type)
>  		return;
>  
>  	if (!(is_active & EVENT_TIME)) {
> +		/* EVENT_TIME should be active while the guest runs */
> +		WARN_ON_ONCE(event_type & EVENT_GUEST);
>  		/* start ctx time */
>  		__update_context_time(ctx, false);
> -		perf_cgroup_set_timestamp(cpuctx);
> +		perf_cgroup_set_timestamp(cpuctx, false);
>  		/*
>  		 * CPU-release for the below ->is_active store,
>  		 * see __load_acquire() in perf_event_time_now()
> @@ -3945,7 +4049,23 @@ ctx_sched_in(struct perf_event_context *ctx, enum event_type_t event_type)
>  			WARN_ON_ONCE(cpuctx->task_ctx != ctx);
>  	}
>  
> -	is_active ^= ctx->is_active; /* changed bits */
> +	if (event_type & EVENT_GUEST) {
> +		/*
> +		 * Schedule in all !exclude_guest events of PMU
> +		 * with PERF_PMU_CAP_PASSTHROUGH_VPMU.
> +		 */
> +		is_active = EVENT_ALL;
> +
> +		/*
> +		 * Update ctx time to set the new start time for
> +		 * the exclude_guest events.
> +		 */
> +		update_context_time(ctx);
> +		update_cgrp_time_from_cpuctx(cpuctx, false);
> +		barrier();
> +	} else {
> +		is_active ^= ctx->is_active; /* changed bits */
> +	}
>  
>  	/*
>  	 * First go through the list and put on any pinned groups


