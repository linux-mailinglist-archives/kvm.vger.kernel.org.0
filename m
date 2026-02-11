Return-Path: <kvm+bounces-70895-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qDmJDTLyjGmqvwAAu9opvQ
	(envelope-from <kvm+bounces-70895-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 22:18:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A2A08127B0E
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 22:18:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DBD8E3021D28
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 21:18:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4192353EDB;
	Wed, 11 Feb 2026 21:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LpgcagL+"
X-Original-To: kvm@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011016.outbound.protection.outlook.com [40.107.208.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6164E34DCDF;
	Wed, 11 Feb 2026 21:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770844704; cv=fail; b=otLSgbsWeKPrmfc0L5EL13/av9efDTQ13CUK6erKLu6qrCoiLD5AUM1ocUrHq+s1qIoY8aTUMbPkOPSiv4dXy3QZoxeo7pyeNXYe6ywDbJ2EUoLRemWd7/XfovqZiHjaUDZL38shMIYF6W7mggBhxaSqdzW2582ti87hxslIdco=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770844704; c=relaxed/simple;
	bh=8DymKr0obV05swBw5WiUQj3o9JXQqP3IAoOGWOc6hnI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lexMBr9C92igBH4jcZLrk23aGoXT2S19XGnhxdZi+AvUI6jHJeBljjmbYx92wx2O+p34bJpW52XyDqTzpC/rKsDO539qLhduCrljP+sdJN50vkkz3ijAUL3P4VCfuOW3fVScGF4Q1eLtBCuFE7Y69dKJSz/Mh1tBG3ePiBthzqg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LpgcagL+; arc=fail smtp.client-ip=40.107.208.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kR6pSl8ERsXXTnu6MJH2mABtgxzk8trdAVBM2N4pSSjHPA9Lq/bXB7coLYXdFurUNYNfSvnjH0MJuIjFQtjY3y9ZF6QLc77ULpNe/yNORsyIotLm7qLPEbswPkZXmbwXWlJFUVG8TmXGlSNpefFb5t2KvuC8DE3gZRmVn/oY3VwdVPl0ayA+h13oelEwL+lEDfmFvhSQEWARhAtmYvCT2Hc9qITDqhPlwRH6TvASA7M8maeAAG6mBilxqbF8Gd/fjNaOl8wCSes7JkqqUp09pC3H+FfsFMksgGREijoDejcgXTNKtjvDtOl+zzEBRwVRJ6AVscKoOYPJWAY9A0S5nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CvOosqBkjIoWuVU1JPdXQu1Kn7j800NWoePdNLZZlCE=;
 b=ERHlJ76hez2LmkZ5H5v+P5RFew7WUfh2NOW8xvlgNmO624sxTsnA1yMAnvIByDU6soe1z2JxdhNr+fMUEw8Hi9w5te/nvLRq5jTCJjMINCidTZLanDeg/MK6QDtYA5tpsSl0vqToxW2uJj/5pPZ+Y+evhAadT9oMFwGt/WIamtrL+YkCb2o48ljWUBV4RH4CyZSZLzFv3Y0I9+SfTnoYJI5KY2kaNoWlCLy2EbUa+8qEXxiCAD1/vjZuvpPsgSkkPWExpeRapFJPJvfNsYr1McXSINQZs0pkIetnziEMrxMI4F/9G7oZrizmHY9c5RtwrEyIkaOHrn4VhyzZcC3FQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CvOosqBkjIoWuVU1JPdXQu1Kn7j800NWoePdNLZZlCE=;
 b=LpgcagL+eZPWxwF6qrvey1m3gRSvKQPNJ4fSzcQJv6g4WeRtMflZm468p5yOHXSHKeJAUNKCs8HxONuIqK6+kmRb7n4GiVG54JcfVgERpFGZX2tyiq1af//mcP+N1MLCMWCRIb+THhA1g8KhFXK26NvxmLxwDl/59MwzawpyBo4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by MW4PR12MB7029.namprd12.prod.outlook.com
 (2603:10b6:303:1eb::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.14; Wed, 11 Feb
 2026 21:18:18 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0%3]) with mapi id 15.20.9611.008; Wed, 11 Feb 2026
 21:18:18 +0000
Message-ID: <3a7c17c0-bb51-4aad-a705-d8d1853ea68a@amd.com>
Date: Wed, 11 Feb 2026 15:18:14 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 01/19] x86,fs/resctrl: Add support for Global
 Bandwidth Enforcement (GLBE)
To: Reinette Chatre <reinette.chatre@intel.com>, "Moger, Babu"
 <bmoger@amd.com>, corbet@lwn.net, tony.luck@intel.com, Dave.Martin@arm.com,
 james.morse@arm.com, tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
 rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
 vschneid@redhat.com, akpm@linux-foundation.org,
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
 <aba70a013c12383d53104de0b19cfbf87690c0c3.1769029977.git.babu.moger@amd.com>
 <eb4b7b12-7674-4a1e-925d-2cec8c3f43d2@intel.com>
 <f0f2e3eb-0fdb-4498-9eb8-73111b1c5a84@amd.com>
 <9b02dfc6-b97c-4695-b765-8cb34a617efb@intel.com>
Content-Language: en-US
From: Babu Moger <babu.moger@amd.com>
In-Reply-To: <9b02dfc6-b97c-4695-b765-8cb34a617efb@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0239.namprd04.prod.outlook.com
 (2603:10b6:806:127::34) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|MW4PR12MB7029:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e55b345-31f6-4c68-178e-08de69b3135f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZUZRYjd6eGtrTnAwWk9nZVdZOFA5eStoWXM3RXZqKzYzKzlMN0pmU3FmNkNq?=
 =?utf-8?B?cGxXV0hmQ1JBdUpXS0s2YkVNSGFOenVUQ0owVTBtUFNFQWpHTFhkZHR3YUZ2?=
 =?utf-8?B?amFIUVErQXlyeGM5ekp3MngvcEwzTXJpK0hjdXlCRktjZ0tVMlBoQ0N3RVc5?=
 =?utf-8?B?K1FqQVZndjkzUlRnR0NxanJzS2s5aWE1UVZEZ1lLUjFWYVE1cWhMank1emUv?=
 =?utf-8?B?dXNzYjhHMFVNSDc2Q21kV2dBcm1nU3J5Y05rQTVtNlQyVFRLK2h6ZEVMRjZ5?=
 =?utf-8?B?M2ZVNWV2M3JEakdNa3Q2RHg0M1FjbVhDdkxnQmhuSm83TGo1S3NZWjA0RTg5?=
 =?utf-8?B?SmUzVXZtTkVyMGQ2bGxvTC81OUNMV2ZEejNvY21OZDV5MFM1cThVZ0hMR1dQ?=
 =?utf-8?B?MS9Pc1JtYmtTbTdEQW56N3prbVQ1N0JBRHJVWlRpQTVsSXo1a0Q5K2x1RzN1?=
 =?utf-8?B?MXdSK0FTUDljbFBFVXZra0srWnVOTTVKOERycnUrQ201VDVsYVN5bWNtMTdH?=
 =?utf-8?B?Sm52NWc2eWdRbWkzblFBRXJ0R0FFM2J4OWlacjE5d21QUDlsU1pUSFNxN0lk?=
 =?utf-8?B?cGJEbFU4RzQ1ejF0WVMxYzZBQUIrcDNlQ0lNZXlxbTkvUm91eUxqNlFXZndJ?=
 =?utf-8?B?N2NxbUtvMWk3WmE2bmpYM1lIUDVCdzRwSEdLaGwvc2hwZkxXMEtaR0F6eGRq?=
 =?utf-8?B?TmR4bytiMFpaNUNMSmlKNXZrVm43bmRQMVhqQ3pVMHp6ZDhRYlJXQVE4ZCtD?=
 =?utf-8?B?RE5rclVBYUc3ejgzSjh2a1M0Z1YzM3k1ZlVLUVMybEJvR2psOFpxRlhqdjd1?=
 =?utf-8?B?eXlITXA3K24wL3cyTnFub2RvRXpKWWV0OXBmWEx2WXdsRUxMWFR4QkZLRzNI?=
 =?utf-8?B?Y1llMjRMRC8raHJsL3hJckMyUWZUbmtNWkhDNXdvYnQrRm9vajhOMkFSQVNs?=
 =?utf-8?B?QTlUZjhjL1hJV1NJQlRPak56eFIrWEpmUm11MS9Takl1Mk44ZW1wWWRZbzhn?=
 =?utf-8?B?RkJWRXMyNzNIU0dKNnl5bHFWTTlybklHeUx0b0JYSWp5Z0p3UWV2cEo3dE1B?=
 =?utf-8?B?dC9XTExuQ1oyNjhHQU90cVhqOGtNTjJDSGw4WkhUT05WRURHNW9xekVHaDFZ?=
 =?utf-8?B?UlZ0Tm91MW0vYXlpUS9qOCswMi92Mkp2aVV0S2RVSktiR0ZJME9LeXNEcDlm?=
 =?utf-8?B?bVIxdFFTL1BUdVdXMVdiSExqZVFjd2NZeGo2Zk5ndm5WZWpWd3VhOFNaRCs1?=
 =?utf-8?B?UGtrb1JtWnl2Lzk2cjEwamZSNmJ2c3d3SnJFTlcxMXA1Sm9mK2hqNTZ4UkFB?=
 =?utf-8?B?OGRBbUw4WjljeGd5dWowcXRpOG5lT0liWlhPdExONWdhNnhMYUJGbHVzcGVK?=
 =?utf-8?B?RjhYNlJkNGVYSFlNVytoOW9TQjBMNUMrSE5vQVIyZDlmV2d1NURhQTRPYWY3?=
 =?utf-8?B?MnliRlV4TlZLbEFUN2s0Z0hybkJqMTVOSk5lSk5heTFzL3RDemNoN0tCSzJG?=
 =?utf-8?B?cnR0dWw4Sk9NVTMyZ1haQUYwTW5ORWR3RkZGbzduMmFMcE84aFFrSkkwazJF?=
 =?utf-8?B?dGpGOWZ6K0VaWGludWVaNndMMVJDV3lyYng4Lzk4WGMreS9WS3dwMHpiSGRE?=
 =?utf-8?B?WDlXcm9SS05WQ1pNc1F2dGV0b1BMRDc5ZFkxaGVsMExsaG9TWnRWUkpFcXhD?=
 =?utf-8?B?NzFSaCtLc3IyVXF3WUJKT1dIVXJBMnVhNkJJaHZpTTZFKzl0RUtyMk1OZ3N3?=
 =?utf-8?B?L3Z0UEZMVFhUaDlFeEdQQi9xUERKZnErSnpNclZlT2FXU3lwZlFvQ2dnREp3?=
 =?utf-8?B?aXFFMW9jd2M5OG9BemQzS3JDMSs1eWZIWVhzWG14Ym4zWjArZlZVOHBWcis2?=
 =?utf-8?B?V2pkVFlvYmNqdWp5Q2FKZDg1NmJYSXltYWJaL2oySjEyeU9CckRPZEhBM295?=
 =?utf-8?B?cDVhRDR1Z0RWWXdadEhGVndmRGRMbXRCRXljTXcrc3FaMVV2c1VNbGxLU2Vv?=
 =?utf-8?B?VWVOd0cxdkFsNU9LNEpneWRKU2hyN1pwSDlqNERrc3phZE5SY1J1OCtpSnV2?=
 =?utf-8?B?bHpJbFROdHlJbUlEbHFwb2pWYlc5L3JtYnVrS05YTjJCcTFXb24wNjdydUIr?=
 =?utf-8?Q?0KNKl8CHEk8DztWVEim9NJRml?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M3RLSU54S0toZWFkbURrOW1ZbU1acTBWcGZpYkxDbmk5M1liK2tUUnhDM2Vl?=
 =?utf-8?B?WGlsYkdONTd6OGhuZS8rOWdNS1hNQ2NScFgvamNxbmNqSlFsQi9Bb3BqZmJj?=
 =?utf-8?B?akFMOEdyWmV2YytUQ2RZMGx5c1ZDMWRJZU04cldPbTBpYS9FREdKVVFvZ2ht?=
 =?utf-8?B?K201THpLanpwaENEVnNsU1lxOGNkMWdoRmlvVUZIQ1VQcGJheGZ0QVNTaEhU?=
 =?utf-8?B?L1dkdS93QmJOQytNeDZtTnRtUUU3NjR2blFMcjJwU1hudmt4Z3hSOFVPM25a?=
 =?utf-8?B?KzFXVFhHYzZKWnViQXRZQVlzNitqRVNITGxMYzBielI3a3ByU2RORk9uNDdY?=
 =?utf-8?B?Zll5VHJ5ZGoxUWl2emxIL1g0dUpYU29Wais1WFJ6c2NZTW9nT3ZLZlU3ZXhO?=
 =?utf-8?B?L0w0eWR0QzZveHdKa3BHb0VTY0xIblpaMmt6QUFFTTdiTVlmcUhjWUZqdHE3?=
 =?utf-8?B?QzZYbmZCT2g5aEdhL25kOEVmU0JTSWgrbFZ2R3JXMFpMbm1NQ1ZzVkpGYVJL?=
 =?utf-8?B?eWd1OVRlVXdZU1VMQnNWSWpHbm1WMHBleWU2UzVkeXBqOVhWcmVPdWxOYW5y?=
 =?utf-8?B?eHFUeHh2SjBrVnAyLzJhTkcvZmJQQjV1L3dLMXdGaVFZUUNZdmVDSUlXTi9l?=
 =?utf-8?B?QUZYbkl1dlZQalhjVkMyUnBsTEc1MUxZUS9yNG9xeHh6cGRGdDE2endaQTVT?=
 =?utf-8?B?WU1yNmtodWNxcDFvMzdsZXNERWprck9zeVR5QXlDcmtMZldpai9OcVhjOW9X?=
 =?utf-8?B?TDRndjBjZWp0QUR6WHMxTnJzVHdvSld3Y0srV2MwcUZ1ZVFIUnJGekNqNHph?=
 =?utf-8?B?RVQvM3d4eHQ5NHQvVzFUOFFreTYwdFNvMzNNSm9yc3NiYXdHRUhwZ0x2SjV0?=
 =?utf-8?B?WlJ3bXluakxCS2ZVRzY1NE5SbDZSUVlZWXJFZGZMUTlRLytTNW9VSHNOUS95?=
 =?utf-8?B?dld6b3lBam1jZFk2UFFpR3hmS3NHYVdUTlZTRVNDNWkwVzdTMDlGSnR6TFV3?=
 =?utf-8?B?bWdqemQzUGovZWRkYkVuS3pYV3RFMHhqL0ovWC8xZ2RXUnJBZExtUHUvKzlo?=
 =?utf-8?B?TExOZmFFREpwUnEvTUxEdEl3VE5vMnhpUWJHSzUrQVZYUzdHN1k5dVl5aDVI?=
 =?utf-8?B?RDh5UERUZDZwdlJUaHlRZE9WYTkvSXUwV2NKd2Q5YVVPU0dYbm1HTXRBU1VO?=
 =?utf-8?B?UkgrMFJHdERIZ3JpMWEzY1k5WTc4Z3Q2K2ZtRmIzM0E5NkdCVkh6SWZZZEV5?=
 =?utf-8?B?aU5BSk9vQ2phNlJoZFZ1VTMyL1hjTnRZbzF0c3pFa3g4ekZKcVZMblFKUEFz?=
 =?utf-8?B?eFFrbGp0SW9zRUZwZDR2TzBmVDhKTmJaN2EwZG5jbUZJOVkzdG01ditUSUow?=
 =?utf-8?B?QkJ2UG0wUDVSaENzVFhhSHU1R0VSZDg0Z3ovNFAzcXR5b0N6bXJCTytoVnRl?=
 =?utf-8?B?dkxzWEt5YVR0MGxVeklsWXlTSzUyQWJ4TVlBNXhURU1HeEQ4Z3lORVc0NUZE?=
 =?utf-8?B?azROQlg1YlNaWGFjSWNWRUplditpVmN0UHljeUVXRmpBYUFMVnZtZGlNbjJV?=
 =?utf-8?B?S1pnaDJma0RuRzllWEt2cHl1ZTdpcSswVGQ1dkZUUjJoWkM1QWlQVG1CeUp6?=
 =?utf-8?B?Y2FGWjY2NWdVWTdBVTE2UTZHWVY0N0dURFJxWXd1QzZ4K1pJQzhYSk9oOUNN?=
 =?utf-8?B?b3lldFhnTStmWk1MVmRKTGpwMEpNbHVKUlMwZTA4dGU0UXowRk1NU25zeDdi?=
 =?utf-8?B?TXV3bEpEWlNQaG5KVmlFM0FlS1UzcmsxRlpwd2pFRFVkNXZXTmhFd3k5V1kr?=
 =?utf-8?B?Ty9XSUh0eEE1R0o0RDZGM0R0MCtYUDQzbXoxc2dDWm5kVzF3SEtSWW1CMzhW?=
 =?utf-8?B?Ky85bUJJUHNmRTVxK0RLdXJDYjdGd2w1VVYrVDV3MUFkczhHVHdvOHc1RTc5?=
 =?utf-8?B?ZEk2NVFEVmxwY3FiVUVLK05nNXVVejIwMjhnUjVBc2pxZlo5SWRMVk9GTEtH?=
 =?utf-8?B?YjNjbFdwMmhacmwvQ084d3V3SE1tNGhLak00N29VWCtlUkFnSG5jUE0vMkxR?=
 =?utf-8?B?Skx2QzVteXFVaEJ0RkZBUzdKd0hBYXRhNlgvT1YxVEhSNEsrYkVmak56SUdY?=
 =?utf-8?B?dEV0VVhQUDM0VUhORjc1eHRUYm1CUEpMNFNkT1NDaWtzdlIxczMvbkV0R0xs?=
 =?utf-8?B?SWlYNEkwNWlSZDg3dWlEcVBnR0Y2WnJrNGxFWWJ3R0NNUXFiczRkWm95cjhB?=
 =?utf-8?B?cGd6cWw3Q01PdkNadDgzWmlEZUh3VkJKQUdTN21QdEdaU3FSYXIxdGZxazdm?=
 =?utf-8?Q?4lUKdHDEECvb1qcHBx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e55b345-31f6-4c68-178e-08de69b3135f
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2026 21:18:17.9901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zak0JgZVtKLa5w91o/DOQ1y2eQw7Wx9tHJlc3oyJNzGBahnT8et+6PKAgseMo5NS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7029
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_TWELVE(0.00)[44];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[babu.moger@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-70895-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[amd.com:+]
X-Rspamd-Queue-Id: A2A08127B0E
X-Rspamd-Action: no action

Hi Reinette,

On 2/11/26 10:54, Reinette Chatre wrote:
> Hi Babu,
>
> On 2/10/26 5:07 PM, Moger, Babu wrote:
>> Hi Reinette,
>>
>>
>> On 2/9/2026 12:44 PM, Reinette Chatre wrote:
>>> Hi Babu,
>>>
>>> On 1/21/26 1:12 PM, Babu Moger wrote:
>>>> On AMD systems, the existing MBA feature allows the user to set a bandwidth
>>>> limit for each QOS domain. However, multiple QOS domains share system
>>>> memory bandwidth as a resource. In order to ensure that system memory
>>>> bandwidth is not over-utilized, user must statically partition the
>>>> available system bandwidth between the active QOS domains. This typically
>>> How do you define "active" QoS Domain?
>> Some domains may not have any CPUs associated with that CLOSID. Active meant, I'm referring to domains that have CPUs assigned to the CLOSID.
> To confirm, is this then specific to assigning CPUs to resource groups via
> the cpus/cpus_list files? This refers to how a user needs to partition
> available bandwidth so I am still trying to understand the message here since
> users still need to do this even when CPUs are not assigned to resource
> groups.
>
It is not specific to CPU assignment. It applies to task assignment also.
  
For example:  We have 4 domains;

# cat schemata
   MB:0=8192;1=8192;2=8192;3=8192

If this group has the CPUs assigned to only first two domains. Then the 
group has only two active domains. Then we will only update the first 
two domains. The MB values in other domains does not matter.

#echo "MB:0=8;1=8" > schemata

# cat schemata
   MB:0=8;1=8;2=8192;3=8192

The combined bandwidth can go up to 16(8+8) units. Each unit is 1/8 GB.

With GMBA, we can set the combined limit higher level and total 
bandwidth will not exceed GMBA limit.

>>>> results in system memory being under-utilized since not all QOS domains are
>>>> using their full bandwidth Allocation.
>>>>
>>>> AMD PQoS Global Bandwidth Enforcement(GLBE) provides a mechanism
>>>> for software to specify bandwidth limits for groups of threads that span
>>>> multiple QoS Domains. This collection of QOS domains is referred to as GLBE
>>>> control domain. The GLBE ceiling sets a maximum limit on a memory bandwidth
>>>> in GLBE control domain. Bandwidth is shared by all threads in a Class of
>>>> Service(COS) across every QoS domain managed by the GLBE control domain.
>>> How does this bandwidth allocation limit impact existing MBA? For example, if a
>>> system has two domains (A and B) that user space separately sets MBA
>>> allocations for while also placing both domains within a "GLBE control domain"
>>> with a different allocation, does the individual MBA allocations still matter?
>> Yes. Both ceilings are enforced at their respective levels.
>> The MBA ceiling is applied at the QoS domain level.
>> The GLBE ceiling is applied at the GLBE control  domain level.
>> If the MBA ceiling exceeds the GLBE ceiling, the effective MBA limit will be capped by the GLBE ceiling.
> It sounds as though MBA and GMBA/GLBE operates within the same parameters wrt
> the limits but in examples in this series they have different limits. For example,
> in the documentation patch [1] there is this:
>
>   # cat schemata
>      GMB:0=2048;1=2048;2=2048;3=2048
>      MB:0=4096;1=4096;2=4096;3=4096
>      L3:0=ffff;1=ffff;2=ffff;3=ffff
>
> followed up with what it will look like in new generation [2]:
>
>     GMB:0=4096;1=4096;2=4096;3=4096
>      MB:0=8192;1=8192;2=8192;3=8192
>       L3:0=ffff;1=ffff;2=ffff;3=ffff
>
> In both examples the per-domain MB ceiling is higher than the global GMB ceiling. With
> above showing defaults and you state "If the MBA ceiling exceeds the GLBE ceiling,
> the effective MBA limit will be capped by the GLBE ceiling." - does this mean that
> MB ceiling can never be higher than GMB ceiling as shown in the examples?

That is correct.  There is one more information here.   The MB unit is 
in 1/8 GB and GMB unit is 1GB.  I have added that in documentation in 
patch 4.

The GMB limit defaults to max value 4096 (bit 12 set) when the new group 
is created.  Meaning GMB limit does not apply by default.

When setting the limits, it should be set to same value in all the 
domains in GMB control domain.  Having different value in each domain 
results in unexpected behavior.

>
> Another question, when setting aside possible differences between MB and GMB.
>
> I am trying to understand how user may expect to interact with these interfaces ...
>
> Consider the starting state example as below where the MB and GMB ceilings are the
> same:
>
>    # cat schemata
>    GMB:0=2048;1=2048;2=2048;3=2048
>    MB:0=2048;1=2048;2=2048;3=2048
>
> Would something like below be accurate? Specifically, showing how the GMB limit impacts the
> MB limit:
>    
>    # echo "GMB:0=8;2=8" > schemata
>    # cat schemata
>    GMB:0=8;1=2048;2=8;3=2048
>    MB:0=8;1=2048;2=8;3=2048

Yes. That is correct.  It will cap the MB setting to  8.   Note that we 
are talking about unit differences to make it simple.


> ... and then when user space resets GMB the MB can reset like ...
>
>    # echo "GMB:0=2048;2=2048" > schemata
>    # cat schemata
>    GMB:0=2048;1=2048;2=2048;3=2048
>    MB:0=2048;1=2048;2=2048;3=2048
>
> if I understand correctly this will only apply if the MB limit was never set so
> another scenario may be to keep a previous MB setting after a GMB change:
>
>    # cat schemata
>    GMB:0=2048;1=2048;2=2048;3=2048
>    MB:0=8;1=2048;2=8;3=2048
>
>    # echo "GMB:0=8;2=8" > schemata
>    # cat schemata
>    GMB:0=8;1=2048;2=8;3=2048
>    MB:0=8;1=2048;2=8;3=2048
>
>    # echo "GMB:0=2048;2=2048" > schemata
>    # cat schemata
>    GMB:0=2048;1=2048;2=2048;3=2048
>    MB:0=8;1=2048;2=8;3=2048
>
> What would be most intuitive way for user to interact with the interfaces?

I see that you are trying to display the effective behaviors above.

Please keep in mind that MB and GMB units differ. I recommend showing 
only the values the user has explicitly configured, rather than the 
effective settings, as displaying both may cause confusion.

We also need to track the previous settings so we can revert to the 
earlier value when needed. The best approach is to document this 
behavior clearly.

>
>>>>  From the description it sounds as though there is a new "memory bandwidth
>>> ceiling/limit" that seems to imply that MBA allocations are limited by
>>> GMBA allocations while the proposed user interface present them as independent.
>>>
>>> If there is indeed some dependency here ... while MBA and GMBA CLOSID are
>>> enumerated separately, under which scenario will GMBA and MBA support different
>>> CLOSID? As I mentioned in [1] from user space perspective "memory bandwidth"
>> I can see the following scenarios where MBA and GMBA can operate independently:
>> 1. If the GMBA limit is set to ‘unlimited’, then MBA functions as an independent CLOS.
>> 2. If the MBA limit is set to ‘unlimited’, then GMBA functions as an independent CLOS.
>> I hope this clarifies your question.
> No. When enumerating the features the number of CLOSID supported by each is
> enumerated separately. That means GMBA and MBA may support different number of CLOSID.
> My question is: "under which scenario will GMBA and MBA support different CLOSID?"
No. There is not such scenario.
>
> Because of a possible difference in number of CLOSIDs it seems the feature supports possible
> scenarios where some resource groups can support global AND per-domain limits while other
> resource groups can just support global or just support per-domain limits. Is this correct?

System can support up to 16 CLOSIDs. All of them support all the 
features LLC, MB, GMB, SMBA.   Yes. We have separate enumeration for  
each feature.  Are you suggesting to change it ?

>   
>>> can be seen as a single "resource" that can be allocated differently based on
>>> the various schemata associated with that resource. This currently has a
>>> dependency on the various schemata supporting the same number of CLOSID which
>>> may be something that we can reconsider?
>> After reviewing the new proposal again, I’m still unsure how all the pieces will fit together. MBA and GMBA share the same scope and have inter-dependencies. Without the full implementation details, it’s difficult for me to provide meaningful feedback on new approach.
> The new approach is not final so please provide feedback to help improve it so
> that the features you are enabling can be supported well.

Yes, I am trying. I noticed that the proposal appears to affect how the 
schemata information is displayed(in info directory). It seems to 
introduce additional resource information. I don't see any harm in 
displaying it if it benefits certain architecture.

Thanks

Babu


>
> Reinette
>
> [1] https://lore.kernel.org/lkml/d58f70592a4ce89e744e7378e49d5a36be3fd05e.1769029977.git.babu.moger@amd.com/
> [2] https://lore.kernel.org/lkml/e0c79c53-489d-47bf-89b9-f1bb709316c6@amd.com/
>

