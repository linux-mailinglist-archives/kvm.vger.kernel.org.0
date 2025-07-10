Return-Path: <kvm+bounces-52013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CD37AFF7AC
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 05:43:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0656E1898CB4
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 03:43:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E06228314A;
	Thu, 10 Jul 2025 03:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DFq5P/oz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2056.outbound.protection.outlook.com [40.107.100.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2657A748F;
	Thu, 10 Jul 2025 03:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752119005; cv=fail; b=eGK+PcxC1SG0FEuyInmLzj38ywg0gNWe2zi5D8iuuQaGotJ0GUNjeyCuDLSnSm78NWNLVPssjO7GKFDuGiIfUlVHZ+E0Uxxo5ISCG5G1Tvu/UWkdSpW/AhFAszGHVZ2zB1Ss074NYPVkAKxHdzqSa+eCvqzHEDswkh6meItgBow=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752119005; c=relaxed/simple;
	bh=Y/AmYOgFQ98nakP0xgulArW6JNOCMWzaxRIv0DPOMR4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XkSsU5b5Lyot5Nen59JJ7jEvJ0lLhCxHjQyLgbJhT9LSciX3vMyVqWjUBEOBbVlvnIzezl+C6nrJISc3+g+fMOotnl1hrFHmUPJhvtRUSexUENOdT6Ac03p1YxqZzAmUZb+SyX7c5A8mSDh1BcWlUEWUr099jlNEDDyLeDluro4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DFq5P/oz; arc=fail smtp.client-ip=40.107.100.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vdg2Vi2zHZj2CVCT1CDEzTnyhlXfP3LPYwBmGC0vUlaWAdnV14bm88ypA1nsScppUuaixhbUmkOCiB5OAUV3t7ry5HMBH32xj4GhkxY7htmjDCjfiBMRrwraVh6r0S6Uttk68gQ8HM3yvGr0FKKQZ6YTgDHI4vorsY/KY3C8ViS8LLOvYjiC0j+6J8HMuYEUciSJ8X2kNcd2/c/f2xlypPcZEOxuABUK818Iks0tvMlt7JiiV+XnUfCMQy5qnF/dDvnZ0cBHz4oP5VPfmNZMiz7Dc+5wlfa+wbd+iVexCRGUoacEKC+7fq8pm3yJC7nMFFDPAjw7UcFkGhjyN8JvSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hne0hOI4rcgb0sIgsp9ND4vHjaBppywlBu0EpKcLBts=;
 b=ZMH7cqIE3EqOsJOnKlhjgxrZgOvFX084aPEaWdb3cPVcHAWrvpK05YGmmn9pTNgBJhxjdQ+yE38/x7X2QSPaIoYQk7gWaShQ4/GakcovprF/PmaZ/qhc4qfEM7+t0c4APk2uwWsVkSRJDYHQ1i3hlKjJxLuZjrbbjROCpLDMdBpKjjPaWqbW+81Vq1tPmIZjelrzYqt3OLHk5sk6e1n/T7DKUZxMsoxU3rYz0r3DJw5a4TiuL0+eW3BxoXgkyTB8RCLqI43xd1Rh1V/BdiSE5Ts1idmkGTxzg0uot3KvsgqzzqMMLL+u2qzKbFbD0mTiJEEB6qh+dseKPoc2dZkhGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hne0hOI4rcgb0sIgsp9ND4vHjaBppywlBu0EpKcLBts=;
 b=DFq5P/ozlRplHLdqe7wTiP3E0/nE6/FZDQvtcH7nzbJLzYka6CNJ2DTWFt10k6Czgw4JdnmJJn1XTxPxZZZDmA7CeXzMHcXBsMbd/x1iryG9oSbk/NnlHdYG6A2nuGRYHJ5kt27nE26TzPM94v8oQZu7h3141tObPMuiW3Tf8TQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 IA1PR12MB7542.namprd12.prod.outlook.com (2603:10b6:208:42e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Thu, 10 Jul
 2025 03:43:21 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%7]) with mapi id 15.20.8901.024; Thu, 10 Jul 2025
 03:43:21 +0000
Message-ID: <be596f16-3a03-4ad0-b3d0-c6737174534a@amd.com>
Date: Thu, 10 Jul 2025 09:13:11 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v8 15/35] x86/apic: Unionize apic regs for 32bit/64bit
 access w/o type casting
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de, tglx@linutronix.de,
 mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
 nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
 Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
 hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com,
 kvm@vger.kernel.org, kirill.shutemov@linux.intel.com, huibo.wang@amd.com,
 naveen.rao@amd.com, kai.huang@intel.com
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
 <20250709033242.267892-16-Neeraj.Upadhyay@amd.com>
 <aG59lcEc3ZBq8aHZ@google.com>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <aG59lcEc3ZBq8aHZ@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0025.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:97::9) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|IA1PR12MB7542:EE_
X-MS-Office365-Filtering-Correlation-Id: 7809dc01-1d89-49d9-89d9-08ddbf63ea5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WXgyeFBtbElFU3RVeEk0cTI5Zm1tRWZieG9ZbEVNZHBvWWdTeDBnTFBtVm1R?=
 =?utf-8?B?dnNIb3ZvY0lGK29iazlJQ2N0UXZNb3dqUWlPNk1pVEhpbGdqRWxGZE1nS3N2?=
 =?utf-8?B?Mm9NRUNiM3lzYVVYYXJMOSt4cjhGamxMSTdQdlZlVHc2OVZCSmNHc0ZNQjVZ?=
 =?utf-8?B?QWs3ZndTN1FydFpLSkVPNlFYdVdQRHQrUnBGam1hamdwS3lOWk9iTzF1MXZF?=
 =?utf-8?B?LzJEYVhzaU41RFhIbnBPL1JJTmxuL0hhekphclVTMzdhQVdTWU5vMytxaGxX?=
 =?utf-8?B?dW9rcFc4VWNOVmVNWk9xd2JIYzNYaG1zL3dURDNya2lCdHFXKzU3ZGYxWFZN?=
 =?utf-8?B?OE4xYXhCbS9jMTY1bXVlVUhNUy9hakxPUmJGMER3b2FVaElnSURyNnhjLzg2?=
 =?utf-8?B?QjIyWVlEZ0lzd1RoTytTOGkwS1VWZUJPSlpNWHpMYmtEQkJHT0JXcUgwcWpF?=
 =?utf-8?B?bVl5SkJLVmRSWUhzODlaNjlRRTVDbXk5RFZiWkJIR0ZtWmZWOUdacUR6U01H?=
 =?utf-8?B?NHJQakNENTR6MENsWS9YRm1ERkFNQjBjZHN1ZTIwbXFTUGI0NFVaU3hMMlBQ?=
 =?utf-8?B?TzZvMk5aYm9DdFFSZzZqbE5ZNURYMVZsN2FWbGxZMmNRRmdFdlRWUndDMmhI?=
 =?utf-8?B?RUJObGxGVHpaZE5rd1NFbU8zdmRlWDUwR3ZxOFUzMzduYVRudCtOSzJyY014?=
 =?utf-8?B?VmdQUXZyaXlKOTRMd2NaR3JmTStwSnZXc1B3WUFMeHU3MytoSUJqeWZ2VVRG?=
 =?utf-8?B?dVY2VGdQMmMvZDFvTGhZczdJdlFLL1UxS29vUm5MUUhPY004bm9Wa1FiUGc0?=
 =?utf-8?B?eXRBNUdFT2VuMmpjNEZJRWFUc0gyK3M1Yi93OHh6TlVLYnNjd09FbjE3bVJG?=
 =?utf-8?B?YUhBWXliRjltaVFob0p1V2JHYUtqQ050NHl2UktIb1dweDdGR2tUNzg0amNr?=
 =?utf-8?B?bDNqTmkzdjBpK1dwWlI0ZmpRR1FTeTNCaVN3ZXRJcWVqODdBbThsVUZLRC8y?=
 =?utf-8?B?TGdiOS8xWUdPZHQwY1Q4bHhTRGVhcy96dXdOTkdINmZUWVNjZnM4SktrQTJQ?=
 =?utf-8?B?Q2V1T0d5SVcrMjVUTWxDRHpnK1paMmt6dzBKTENtY1hmRysvZzBLekY3dVJ1?=
 =?utf-8?B?ZVdaOGQ4cTYyK3FWTW5zVGp1dHdlN0ljMTc3T0E4WGhoWkpKRFpKQnpXTjQz?=
 =?utf-8?B?UmZxMUczcmNMYXk3bDlWcGNGZkp0SXJZY3ZVM0J5Mm43cjk4Mjc3SUFrUU1Y?=
 =?utf-8?B?TTNWNy9PMnBzdHUxVVlITVZRU0g3bHU3QXdRYmxqZ2padDFQMTdyUElYUkxq?=
 =?utf-8?B?MDZDR2l1RWFtTytiZVp2UTNXckViZEN6SjVSbHIrWTAxYkY4aWNCR0x5VUU2?=
 =?utf-8?B?WFRQSVhCOTlQT0grMHQ1UHI2c2hKblZ5RC9FTlgvSE5KUFNUMW1BS2x0NFNz?=
 =?utf-8?B?Q2xybGlvVUIxbGh3VDk5aEFFQWtGanpqMUlnb1IvdFlwcDFwTFdINzlmM1M5?=
 =?utf-8?B?cm53aVdVQWxNVWRWWW1DSTZZZWJXL29iWFk2NUN2WkFCWTBDOTlxZmhJaVZX?=
 =?utf-8?B?ajRkSjBvbVJNbWdQaEs5V2RZRWRSTDZ3c3J3cGVPN0J5OW85TEt5bjlvdENF?=
 =?utf-8?B?blpWTmRKdnRBeHBmSUlYSm9mNjU5ZGpBYWRDcmQ0Smw1RmNMT2NscHRsamVt?=
 =?utf-8?B?MXJPcVN0SjU3TU9mdng1cDNpTHJFQTZXNlljWExYVUdwdWhIUUFUZkdvaUt6?=
 =?utf-8?B?U3NtREVxQWdMOW9jNWJrRkZLRzA1MmxHSFpxYk5jYWNGNDFLOUQ0bTlPa2tW?=
 =?utf-8?B?TkRleXJjWE4yc3UvRUxwMXU4bVduelJBNjlZZXU2aU8wM3FReUxFdEkvYVdY?=
 =?utf-8?B?VUhYekl3M1pMUEc0eURWaldNOTF3WDJRcnNMbXdOSVVGV1JoOURVVGs2QThK?=
 =?utf-8?Q?xZu6DcLPTR4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a1NJVGhHN29LTFdVODJYUWFqSWh2a25HaGVKS2Y3bHRjQmluM3pWNExJMzAx?=
 =?utf-8?B?azE3cTRLZytadEZuOWxBRkJoRnNVQTJiYXhEUm1qQllIaDFyOXNXWUtWcko4?=
 =?utf-8?B?SXF2RVNvNlI4OEJiTzlKTEZTK2xaL1B4VERja3l3ZngwdW1iQVI1TmZ0TFNH?=
 =?utf-8?B?dHdDeCsxTDA2MXY0OFFvQ1ZkbXdhS0JNWkd3eTRQaTlQeDZlMGFheHI0cUsr?=
 =?utf-8?B?b2p3TWIxWkYxOW92Sjd6VkFZeXVqejYwZUdGVjd0NlVEOFBoYk9YYVYrc28x?=
 =?utf-8?B?ZzhPWGZRdjBmSDU3Y3NjbkFFb1NKd3lxRWVabURvWkVZS0lCcFpRNmh2RVJP?=
 =?utf-8?B?MFVFcUpvZXl4MUdHYUx2ZzUxRkpzZkMyeTNjY1VnZ0pBVktaWTBoQ2w1T1FC?=
 =?utf-8?B?U0pCT2I2OXNJVDdYdVRmblVYeDk2Tllta2VhNXo1Z3paaTRPKzllQlZ1L3Az?=
 =?utf-8?B?Uzdtd1pYQzM5MndFbk5XaVhFVElzSm5rSTk3NGsydFl5enh5bGEyMVRUVzhF?=
 =?utf-8?B?SW95d2VYTXc3VkVRR3JlbWFsWVZYY1ZqNkpEcFFnL014MzZTQ1Y2aDhhU1V3?=
 =?utf-8?B?a2ZHY3kybnBsQVFmOGk1SGtOcTdXeUowbUwrMUxGOUhGUy91STFqUFlLY2tZ?=
 =?utf-8?B?SktRdUZiaTFKWWNjRmREc2tkZTF5dk9Xb0tmcmI3WlFHUzJmU2tuSnIrZzlr?=
 =?utf-8?B?VjhxUmc1ZmxqVlRMY2pwd3Jndm05WGFmTWRCbHAyWDhVa3dtOGRPRGpIckVw?=
 =?utf-8?B?eE92bDRiL25NOEhnL2xCVlNHaEVZMk94Y1lIeVY3TWNOODU1VmNnV1B3a29t?=
 =?utf-8?B?alJNTFNGakJaVklHMGt6ZGZwTURMSk95WFgzenlIWXpZeHBQcm9tQUd3STZj?=
 =?utf-8?B?dk0vVGlvaXpZbnBkUStKTGJWeThNTnhmemdRNzV1RkZuUUJURXY5bmFMdjdh?=
 =?utf-8?B?anBHMkZJQldacWljR1FmZG1ieXFrWmdXYUdmQ09jbE8xR2NlbHpHVVY1L3F6?=
 =?utf-8?B?UEEwMWo3NG4xTnJMdGpHUWVVWUQraUYxYS9qc1NQQklmcXk2UkRrUUNTcmZV?=
 =?utf-8?B?L2FIeDh5eTJyalRSMWYwRmNGSmpHRFJPeERUb1VQaktnRmlGcUlLcDB3eVEv?=
 =?utf-8?B?eDJ0YWhaYWFTdUQrMS8rRVo1Mi9rcmpMdFdnVW9Nc2R2Y0g0MWVlT2xrQ0tl?=
 =?utf-8?B?YkFYTDlvKzh5K3BrZmVzNGFRS0laMEZFQStLN3VTYVQ1UkM1aTNHWGVDd0o3?=
 =?utf-8?B?cFV1VXFVcVNJaHdnSnVRWTRhVDB1SkxSa3NqZW5oelJrNE8zTTZwM21zV2dQ?=
 =?utf-8?B?c3VCd1JGMXBLNmVLdGhNUlVycHczWFZsdE1WSW9hVE5CbDNmVHk4VDZnYmpi?=
 =?utf-8?B?OEJzanU0R3ZMb2JlVkZsQ2M5ckFKdkozaVU3anNnZGlWQzFNMFNwTktwT1hm?=
 =?utf-8?B?emZ6eVZSMnFldFFpTEFieXByMmF6MjdUa1NnR3FCTFVTQ0ROVHI4aW4yZzh2?=
 =?utf-8?B?cEk0aXRqbFFUSWt5Mnp2c1h1VlZKNEVsVE5tM3dROUJWalM1SGM2a1dmSitH?=
 =?utf-8?B?dzlvdmNWK0laMUF1bHlsc0dYLzk2WGV6dlZZNWUxc05UVlRaWGhrbW5BRFZK?=
 =?utf-8?B?Tk1tL1hHTlJ5N01UK3liRzM4d0Z6OFd1dlJrK3lWY1ZHTFplM1JqREh5MHdL?=
 =?utf-8?B?ME56S3hmeTd4MGNIL0RLUWk4T09XVUxUZU91YjFrdjYreGg4c0JCVlM3Y1VG?=
 =?utf-8?B?Q0NPdy9oQzdIYTRid2FOZlRHeVhsOHh1NDNwNzVOdTd0SUYrNDIwQUU3VEla?=
 =?utf-8?B?eG9QNXgxT3loKzM2Y3Z0SFdTY2djY1MveHhNNXZDcTNycWF1Ly9pa2QzSkZz?=
 =?utf-8?B?eFJXYXFnSzc5ek5zUU1BZXBwdkNEeUFXVkpQeXJIazc1c3IrRFhJNitySE9L?=
 =?utf-8?B?aEFyTVVnZnY2TzkyclRPemN3c2FVekN5VE9vdTRnZjh0KzVDSWxOWjlJMkNN?=
 =?utf-8?B?RFVpcitUcERoQ1JVRzlGZjl3VjZwajlXdElhc2N0Y1YvUGxkTTM1dytjd0cv?=
 =?utf-8?B?WkxocEhyVW82MXJPNWlVT3J3dlZiSzZ4WXkxaENsZjcrOXRlWldXRTlpdXRP?=
 =?utf-8?Q?rGToy1RA8ghWvQB25BWnmhy7x?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7809dc01-1d89-49d9-89d9-08ddbf63ea5f
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2025 03:43:21.4828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wzp5hDaQOuO89Q7Aq9B0CRGQU6DZ2t76iS9tB4quC6t9jEuW7tRKMD/tHI8nfXmurgoJpy7oBTavVIlV8ta6Fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7542


> 
> NAK.
> 
> I really, *really* don't like this patch.  IMO, the casting code is more "obvious"
> and thus easier to follow.  And there is still casting going on, i.e. to a
> "struct apic_page".
> 
> _If_ we want to go this route, then all of the open coded literals need to be
> replaced with sizeof().  But I'd still very strongly prefer we not do this in
> the first place.
> 
> Jumping ahead a bit, I also recommend the secure AVIC stuff name its global
> varaible "secure_apic_page", because just "apic_page" could result in avoidable
> collisions.
> 
> There are also a number of extraneous local variables in x2apic_savic.c, some of
> which are actively dangerous.  E.g. using a local "bitmap" in savic_eoi() makes
> it possible to reuse a pointer and access the wrong bitmap.
> 

Thanks for the reviews, inputs and suggested cleanups! I have addressed them for v9 at

https://github.com/AMDESE/linux-kvm/commits/savic-guest-latest

I have changed

    struct secure_apic_page {
	u8 *regs[PAGE_SIZE];
    } __aligned(PAGE_SIZE);


to

    struct secure_apic_page {
	u8 regs[PAGE_SIZE];
    } __aligned(PAGE_SIZE);


... and changed 

    struct secure_apic_page *ap = this_cpu_ptr(secure_apic_page);

to 

    void *ap = this_cpu_ptr(secure_apic_page);

in savic_write(), savic_setup()


- Neeraj

