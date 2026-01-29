Return-Path: <kvm+bounces-69601-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +MydC/K6e2l0IAIAu9opvQ
	(envelope-from <kvm+bounces-69601-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 20:54:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E6E4B41AD
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 20:54:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 018623033F90
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 19:54:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0576E328B79;
	Thu, 29 Jan 2026 19:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XZV8y8gm"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012024.outbound.protection.outlook.com [40.93.195.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E56328B76;
	Thu, 29 Jan 2026 19:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769716440; cv=fail; b=OHQ/6J88E7tKY7XAZ9FHjnnfqKxebYKASA3FX0O5T6rmWoLsnugUnqzNWyi8gzOKncE4iTsF2PvjsF/lugdIpO0ZT4cUQwEcenuG8dpIsXimduVnPin7HqJ2rCcCUFYlR1/W9yCh/OaxyyF3Bemf+TVCTvgcohLsVSeQuCQrW7o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769716440; c=relaxed/simple;
	bh=ulAwVmhhcQu/B4gyh/1QayTz3Ev9YBM/KY21YTBecpg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ry3vRNBHU6OBibEEd0ZDG9pS3RTG5BX4AsrDGhQJCJISSuiqAt1AWq/Cim7R7Ey/CBvzCp73+Y/eeUZCFNlA5Ru9ZkghKH7QThF940AmO9uomknMsa8UvcGhpmG8S1Ay7kGx2HOUP83oEp66tcDpdmSZNGj9M5ciIyFKPDSI+58=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XZV8y8gm; arc=fail smtp.client-ip=40.93.195.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H2OGK/4XQYvB07TJ6b9/Mc3LGJEBgFoNIxdf3TdyKhfOahxG4/2ZzZDVDLKcWjph9zcRM8MMeVqyxqI1BsaSmLm3AM99H1QquVk35Mcc2DEGxdwmz8OmEqOLaxeoBur2LLkWOARvgJWrC1sE/m0TRklYVCSwv2H8i/VkIDcOgrpHY5HHUKtwG/EG/iXdMKmW3JExWFaZtO6g87+C6JE1tOWPmhbo5rgK3HksoiqD+E3cPoNZoNgs7ECgAl8fzmVtdQj0GHzZl9kkIRlCI5Yxn2Axq4GRboHw/a6ccDpKR4EWEVUiSMOqbp08nzKfqFjGFnshQRBb+UWqlG8evT6sFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1YK0HX4kPLV30OKidvSVO0gZLDTrM/Rh5D7iSpZ9N7s=;
 b=sdbAZnyLEnu2zChK7sHvalZ2mW0yxbiGMNiyq4DnucEhzHnzUzOLSFN57yYG/WMFCnIjJdGIskPaU/KGPwEott5Oz04ITBS82Z5fA/KaMkVQ4lSmaSX7yt6fBVvrsm0v7Pz7tgPwhAX8DRYkwdnwiNoBn1fExyaTYYohwULdX9/6jlDICjF6Jf8aJCvZcn6OcVqPBrTaRjus2fgUEuu1LjaBTtMiqGRt1iOf894UvLa150TRPzXgPFkSWogcO0B/LeDElQMev0wZHMIZnOiUJEEnusJfeW8kiQHWydmibmeMAuRVBZN5Qcx9yfiKYiFY7SHvdfsqbsDwPguggzQjeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1YK0HX4kPLV30OKidvSVO0gZLDTrM/Rh5D7iSpZ9N7s=;
 b=XZV8y8gmSfNW2YboH8t43zcntOOeVCw/FTR0swFcprb14il4XwsQq0pRBDEevU5BncbWbfRyT+w9fk3Bqubtis7EHcDHrlHqhZnAL+tB1VKbFGT5pWoLZL0UWffXICtTcmU6qx/s+2goOEJGIpPTP1kIAj3D3OdEnCfk7rhw4ag=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by PH7PR12MB9104.namprd12.prod.outlook.com
 (2603:10b6:510:2f3::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Thu, 29 Jan
 2026 19:53:53 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0%3]) with mapi id 15.20.9542.015; Thu, 29 Jan 2026
 19:53:53 +0000
Message-ID: <b5741094-fbb9-4dc0-b3a4-bb66073344ae@amd.com>
Date: Thu, 29 Jan 2026 13:53:49 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 14/19] x86,fs/resctrl: Add the functionality to
 configure PLZA
To: "Luck, Tony" <tony.luck@intel.com>, Babu Moger <babu.moger@amd.com>
Cc: corbet@lwn.net, reinette.chatre@intel.com, Dave.Martin@arm.com,
 james.morse@arm.com, tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org,
 dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
 mgorman@suse.de, vschneid@redhat.com, akpm@linux-foundation.org,
 pawan.kumar.gupta@linux.intel.com, pmladek@suse.com,
 feng.tang@linux.alibaba.com, kees@kernel.org, arnd@arndb.de,
 fvdl@google.com, lirongqing@baidu.com, bhelgaas@google.com,
 seanjc@google.com, xin@zytor.com, manali.shukla@amd.com,
 dapeng1.mi@linux.intel.com, chang.seok.bae@intel.com,
 mario.limonciello@amd.com, naveen@kernel.org, elena.reshetova@intel.com,
 thomas.lendacky@amd.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, peternewman@google.com,
 eranian@google.com, gautham.shenoy@amd.com
References: <cover.1769029977.git.babu.moger@amd.com>
 <84b6ec2a2b41647f44d6138bc5e13ceab3aa3589.1769029977.git.babu.moger@amd.com>
 <aXuxVSbk1GR2ttzF@agluck-desk3>
Content-Language: en-US
From: Babu Moger <bmoger@amd.com>
In-Reply-To: <aXuxVSbk1GR2ttzF@agluck-desk3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR13CA0131.namprd13.prod.outlook.com
 (2603:10b6:806:27::16) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|PH7PR12MB9104:EE_
X-MS-Office365-Filtering-Correlation-Id: 8802cdbf-b38e-472f-fe2f-08de5f70211a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R0ZSMDkvbDkyV0owOHdRSk9tMUxzcytYdmt3ZGVGVzR0cGQwSFlJdHZkdnJB?=
 =?utf-8?B?Z0ZrZVRtWmlWRy8wSlB0djBtcFp3cjVLUXNmNDVDY2RlMnVDeklzOHFJVlFO?=
 =?utf-8?B?REN1dm1kczlPdGllY0hQM2U0S0NpbngyUTdoNjExOUpuYmwxNE1JZ0hLSVQ1?=
 =?utf-8?B?R2dnWHVVcW03M3owOSsyUFdSYUNIeHo2Q1Y5SzZGNmZZSUFUSXBweDdkZEhU?=
 =?utf-8?B?UFptUE5BdndwdUR6MmN0ZkZQWVJLRkdwYnp0a3JCenNoQTAvZEFJNDNwU0Ft?=
 =?utf-8?B?MUdydDIyYkdrTk8vZDNQVms4NGJzMW1vMjl3elZDdlVRb3Qvd0VEMHpsWjFK?=
 =?utf-8?B?UjU5UC9lSVBnaXhRellQeXhSUGNuaHp1cE9UR1IrUTVGN0E3azVrcWhTcXVO?=
 =?utf-8?B?QVdQTEtsTllrRzlIdXU0NWY4bWtuMjhpd0VCaWRCR2liZ2FEMjFiNE5XTnA4?=
 =?utf-8?B?Rnlzd0pYTnNTV3cwRU51VVVVV2xvUWdZSGFSNEN5VmtNQVRja1JPaU9VbVlJ?=
 =?utf-8?B?THplTUZCOEt2RFg0ejRsakRHaktsdUhOZHdlUHZOYWlvV2s5YVNTMGJ5ajNa?=
 =?utf-8?B?ZXJSZG1mamFIV1dxZXdjS1Z6Q1lTaDBIVU9Ec0RkcmExYTJPcnJ6SWY5NWxW?=
 =?utf-8?B?NW5KZzQ4SHFSVkRPMGxCdzhCTnEyZml6UnFJeVNJbGprMiszQW5TM21Vakx6?=
 =?utf-8?B?dU1RNEJ4TGVvdGlzTHVZRThTTFRIYmk3Umd0ZmhFRFA5YW8rZkI5WUlTMCtB?=
 =?utf-8?B?bU1mN2NrODhmV0RKdVIyREV6MkpCUTRRTmN6R0lCVGZKSFZoclB1NFdYczVF?=
 =?utf-8?B?TGdVWjJHcmp1ZExlRHpLKy9iVWZVRXZ1b0lHTUN0SDRlTktCT0E4QlZiVlJa?=
 =?utf-8?B?aGVQeERFNTNTVHo3b3ZXdFNwOHUxZEV1eHFXWFZacVBiTWgzN3d5ZU8wcGNX?=
 =?utf-8?B?Yys1dlgrdHV2SUNVdHYrKzd5ZWlxWStCelR6SnQzNVU4WWxZWU5HSHdGZTNC?=
 =?utf-8?B?bGx4dSsyRENjbWN1ZG9Qdi9SK3FYcmZOL0FxWkZkVzR4bjYwRytEbm05MkpL?=
 =?utf-8?B?U2g4Yk45elFoczFLRkZoVU9tUG5tNWZCRWQ5MGRQQlBreVZ6ZTMxalNrcFRx?=
 =?utf-8?B?QzNmc1IxT25weTR4Q0NiUXFMaUI1Q0pRbytCV25YOGhQd0QzTUIrNlpQUkZz?=
 =?utf-8?B?MktHNkxOampSWFlKdHZ1VEFBYks5bFpEalV3ZCsxbDFQVUJ4akIrbkJxTWRP?=
 =?utf-8?B?OXRxY05tSFl6MlIrVVNxN1BRMjNLOEtvV0NWdlJsWXZCbUthK0R6N3hGWEkx?=
 =?utf-8?B?UDZRUFgzdGpSUGtaWEdRZElmU1pEbDJlZTMzaUp2cGpOR0pFN2N1RHhsdXVL?=
 =?utf-8?B?cWdQNzlLOSsyYW9jUU41TzJ6eEJhbFBVQ2F2ZzlVWWVaRGJ4OGxJRWlVbU1k?=
 =?utf-8?B?UzVoSUxKZjZ4VXlQRHJmT3pjU2dlR1FPM2NabE1sb1ZSZk5UcnhDVnh5ZWh1?=
 =?utf-8?B?U3JrMVdjaENrRWx1TktPOHIwbTNXdjRpRGZqT3RGQkQwdEEzN0tkNXJaVUZE?=
 =?utf-8?B?TWZ4N0ExeFZRdlhrbzRGRjhONzZ4ZUM5Y0M2SDQ5TFA0MUcwdjN3Mkt5dGYy?=
 =?utf-8?B?aW1TQWRxK3JxS05hM2haQWVZZk5jbFcweFAvTDRtb2MyRDhkYVBJM2xhZU0x?=
 =?utf-8?B?RGNZa0tyL2VHQW5UZkdMYzhYcmlwVmlWSmZrR2hLVVVqeGxMT3lnZDVsUE52?=
 =?utf-8?B?QXlhS2lGWjNQcmMvYTJ2ODZsQmhib29KeUY2NURtb2xLWTYxMjhYTUpjM0tm?=
 =?utf-8?B?WG1IYkVTVDhWQy96NWw1ZE5TT3BuSWFRVUJWcEVhYkFnRjFBalNTa0FDSG41?=
 =?utf-8?B?V3Q2VkRZQ3RXZlZBTkQxL3krSmZiL0dsbWtRWFlyUmR5WFBPZTVaeVJuYVRF?=
 =?utf-8?B?UjRidmhEeFRSejF0azhSN3d2QUk5cFlSTWlONzYxRUJpeTRVVW5xRzdLVzho?=
 =?utf-8?B?bXFXbmYxTG9EcjdpVGxsYkVNNXN6bFU5L0xKSExUUndibDRSNXZSRVlBWVVv?=
 =?utf-8?B?V2E4dTVQbjRRRjVDSlVCdjF5bG1XSzMyUEtvdm5HT2wycDBBeCs4VForendl?=
 =?utf-8?Q?5O8k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?REZMTWxQUjlYeVoxMFlqMFFDb1R1ZVdaM1VGNXM3eFd1WC9SRnZKNXJJNHNw?=
 =?utf-8?B?VVBaU2dmK2tTbEtrYmtVdlZLK1ZvaW5jOWhEbEsrSVYzeXdyLzBRN2xza1Ux?=
 =?utf-8?B?ME1WS1pESXZzZjVvc0dmS2M3TXMrdWJzcnBybzRSSGtzN2QvNlVjdkZIeXVx?=
 =?utf-8?B?aVFreERUOEc4MUhGcDNmSVREN1hjeElzMFFlVitNN2J4bWpHRnp5WFNuZTlL?=
 =?utf-8?B?OUxYcE9vMlc5cS9HSTE5ZnFBQVhDajZ2SXFJQzlsRnhvaDUxSDU0WS9zbnhP?=
 =?utf-8?B?YzRZdU01cXdsQVJBY1c4UUJhUGFRR2tQNzkyb2cxbDBsRXA5ZG15enBwZHZM?=
 =?utf-8?B?azlZUmdMZndJN0pzMk0vaEhBRVZOZ3pneWtlamsyOGRlSzZIQ0owSEVwZmZ2?=
 =?utf-8?B?TU40Z2k5OG9GUHp1eVFrcXV1TDN3K1AwODJYdEIyb3ZBK1FrWGlpN1p0WHlh?=
 =?utf-8?B?eVBrVzQyMTl6aGxoek9NMm13M2dadkhOMVYrZjUyNyt4TXVlOFFSbWovOGho?=
 =?utf-8?B?Q2tNdFpsbExYdThoMllJMW9CN2VLYmlFR3VHYy9teFQ1bkZwWjJHSTZEVkw0?=
 =?utf-8?B?RjhhT01ZYksyUjBtU1VyZkpIeFNqZWVsZjNIVUpUaldPclUxL1pBOXE1QlVm?=
 =?utf-8?B?aFRldG9QQTUvZFBydEY3bTk5bm0vQVFYOG1pUWNDSjVTOGk2VEFqbmVLaGRZ?=
 =?utf-8?B?TDE1WFhvREhScGllWXh5WWQ0YzdBQTdVcHovdTErRUlNUWxzS1lXVzV1UHBn?=
 =?utf-8?B?T1J0YjcwOE1UWmdqWDZRWWdzMFhOSTFqd3ZXVmRlT2pzR01Uc2oxbDYvTDRC?=
 =?utf-8?B?ZXNRcHlQM216TWQzb1ovTjdpa25TKzN5S2tUY29YaHVISzhMRitSa29QVlQy?=
 =?utf-8?B?cVlSRFBPMnova0RCb1Y3YllySlJqMXB4NXEyajdNNmE0NndnOFFXQWlCZWVT?=
 =?utf-8?B?a3lMZTdzT2o5V05BVXRsSHgxTkROOEwxQlkzWnlsdXZYSjBoRGFQSkJqdUZ4?=
 =?utf-8?B?WUl0WSsvKzgvcGYwcE9zZ21JOWlLSlVGUEdwSm85SlRSL1RUYjlNc1E1S09i?=
 =?utf-8?B?M2wzYk5jZXNjeGJoODhqMndsN1JRYmJTNkdRbFRXeHJvdkgzWVZGOWdVbUJz?=
 =?utf-8?B?M3UvOFFPNDZsVytGazg1NzhTZXRDbVdKVFlwZWVaUXk1NktCbTFrUU5GVzRz?=
 =?utf-8?B?c253c0l0WENzd28xbzhjUUN3ZlVCelJYQStkbjBnVUIzc3I3Y3d4VW9odTNT?=
 =?utf-8?B?TkRONE9CcDlYRnBndlJ3SjRjeXVtVWJVY2YxOU1UaUIycGJ5Z0JVUjcyQThV?=
 =?utf-8?B?bFJ0SEg5bFBYSGxFU2R6VEhDM3Z4SHEwRHhRR3VaenlFa2dIckI1SERIcEUy?=
 =?utf-8?B?TW5YcDFnYVFBbmFmRG1leDJ5Yk9yaW0zcmRQWTdleWQyL3VqZDRTUHgxNHJI?=
 =?utf-8?B?T0s2RmlycC8vM2kxMEhUSWozT2lWMFpLMC9CeGtaNW9EbEt3VWdFN2JXbjZ3?=
 =?utf-8?B?NDFKRE1TWHNreDhFU0FGcEZIcjNWOGg2VHJqVWlvRkI5MXdiRUg1MHFKbkc0?=
 =?utf-8?B?R0w2MmZDT3ZFK3o2MmhCNWxUcGdWNEdIdXI1VmtodHNpbkRhWUdFTTZzRDNv?=
 =?utf-8?B?RWVtRWdtczZCWlpwbWFjQUtRUlFEVE9PcmlVc2tKQzJ1UGxoK2dybG5GTlZu?=
 =?utf-8?B?WDJLNGtkNkN5bHFVOFRyK1ZHYlJTZnhrb2ZuMm96RnhnTURhUHFYZURkckV0?=
 =?utf-8?B?U00zMEFpQVNtUHRuZW1rNEVMUXBPa3pxZ0oyT01PMHhLTUt4Q0pKYmpLVXg5?=
 =?utf-8?B?a1hySGlSUmdZUzFXTlk3U0lZcG9ZbGh0TzlETGVVTjdrYWp1S3JtT0ZFUGJa?=
 =?utf-8?B?dEFadVl0emJIdE9JRWZ0R1M4MERJc1BTcXlnTzNoUkpYeGdscWJUcnBlc3U1?=
 =?utf-8?B?VWhjYzVva290VkJrZUNMTWZWQzEzWUJWOVl3Q2FhbTNYTy9FdWZaVjY0c0xS?=
 =?utf-8?B?WUpVRTZlYW1ReUd0Vlh5S1gzTFo5V1o4UGxURjNZZ2h1SWg0TkJOSjUvVDdM?=
 =?utf-8?B?MTUxL3hzQitVMlBXQzhVMGQvdjRsQlFmZEJ4U3RjVlZ5a3QzSWVORDc0UWVS?=
 =?utf-8?B?L2MxNVZldDZTMHBtRXM4K2ZjQ0wyQ0dBalgrcFpmOWFkOGEyd0kzK2RxV0xu?=
 =?utf-8?B?QjlEUEk0ZUtkcVIzMUZ4aHN1TEVFUzhNVUhxT0dITzBuaTlIdUo5ZnZhRTJF?=
 =?utf-8?B?dzZkei85d3UwVkZPUHRPNTJvdjVCeWVCeTRZYVQzYy9LVTE4SDBaU3QwTGM4?=
 =?utf-8?Q?3zznVHBEKk/oTX5xf0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8802cdbf-b38e-472f-fe2f-08de5f70211a
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 19:53:53.1169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4jj7BxKAM8OEFQnuwi9s5ThdKCrs9muq72jlwzxeeE2/vY6gUXhl1uE+FKKjbQG6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9104
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69601-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[44];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bmoger@amd.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7E6E4B41AD
X-Rspamd-Action: no action

Hi Tony,


On 1/29/26 13:13, Luck, Tony wrote:
> On Wed, Jan 21, 2026 at 03:12:52PM -0600, Babu Moger wrote:
>> Privilege Level Zero Association (PLZA) is configured by writing to
>> MSR_IA32_PQR_PLZA_ASSOC. PLZA is disabled by default on all logical
>> processors in the QOS Domain. System software must follow the following
>> sequence.
>>
>> 1. Set the closid, closid_en, rmid and rmid_en fields of
>> MSR_IA32_PQR_PLZA_ASSOC to the desired configuration on all logical
>> processors in the QOS Domain.
>>
>> 2. Set MSR_IA32_PQR_PLZA_ASSOC[PLZA_EN]=1 for
>> all logical processors in the QOS domain where PLZA should be enabled.
>>
>> MSR_IA32_PQR_PLZA_ASSOC[PLZA_EN] may have a different value on every
>> logical processor in the QOS domain. The system software should perform
>> this as a read-modify-write to avoid changing the value of closid_en,
>> closid, rmid_en, and rmid fields of MSR_IA32_PQR_PLZA_ASSOC.
> Architecturally this is true. But in the implementation for resctrl
> there is only one PLZA group. So the CLOSID and RMID fields are
> identical on every logical processor. The only changing bit is the
> PLZA_EN.
Correct.
>
> The code could be simpler if you just maintained a single global
> with the CLOSID/RMID bits initialized by resctrl_arch_plza_setup().
>
> union qos_pqr_plza_assoc plza_value; // needs a better name
>

Yea. That is a good point.   We don't have to store CLOSID/RMID in

per-CPU state. Will do those changes in my next revision.


> Change the PLZA_EN define to be
>
> #define PLZA_EN	BIT_ULL(63)
>
> and then the hook into the __resctrl_sched_in() becomes:
>
>
> 	if (static_branch_likely(&rdt_plza_enable_key)) {
> 		u32 plza = READ_ONCE(state->default_plza); // note, moved this inside the static branch
> 		tmp = READ_ONCE(tsk->plza);
> 		if (tmp)
> 			plza = tmp;
>
> 		if (plza != state->cur_plza) {
> 			state->cur_plza = plza;
> 			wrmsrq(MSR_IA32_PQR_PLZA_ASSOC,
> 			       (plza ? PLZA_EN : 0) | plza_value.full);
> 		}
> 	}
>
> [Earlier e-mail about clearing the high half of MSR_IA32_PQR_PLZA_ASSOC
> was wrong. My debug trace printed the wrong value. The argument to the
> wrmsrl() is correct].


Got it. Thanks

Babu


