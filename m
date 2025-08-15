Return-Path: <kvm+bounces-54787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D96E3B2807C
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 15:19:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79C2A3A58F4
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 13:17:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A51A301499;
	Fri, 15 Aug 2025 13:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Sv2HJ/YY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2F427F16A;
	Fri, 15 Aug 2025 13:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755263835; cv=fail; b=PpTnRyIzK9IG/OpdzvG6/saDrBxC6Mrbnsa8G9SfAGJdeLGP1FRAXRjD2nWEtdXp2QvSgHeu4l90XFTULd/ukIg2EbEUboOKAMh2CWTH/ItAVsKz7PDEWIB6xCLhUD3KiSXKxLaNdNgzCRNxHKb+FKDSASghAnIhTEdl+JYkQfk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755263835; c=relaxed/simple;
	bh=1JeA350nvWrW5v7ALY1fIV6wpMhtFM34V3EUTaiveIQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=s/xvu541mKa8PuM9e5Yf8B6z8CNv7ArRqot8XmHazQHYGdRLlPEkrUkH3LSyg5QCyLzlVihR+OD9SKkYwuT0WD+bSBCfB7R92lN/Cur/PZ3fjscsAMtCu/oeu1AR1ARA6bQIaTkkyvstEff6guKBuSZNfIrEzMQzM7UX+eHVzHc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Sv2HJ/YY; arc=fail smtp.client-ip=40.107.223.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hmwRtVPrjOuV1lhyvYdP6Ttx7oEcvilgC59fbj8gtM4tpUaHurW8eus+w7uVkVEbW5poC4LysC/ctJKmkkj2tUh8mJuoviIhCNj/qa8nE+cMz8aK+1sDRPfpAWuteT+PTR++O2wygEfUNfXaYHQTgkAbK6aKbuV3tnglN53mSRgDHL2I6ku5UzTckb5e8MPHqyXNWXrvlDQRCIyUwlyBrB0gIfwNeiZaGWmnR8LipsDvIXuDRKoOapblvuAsKMgHdwneOXyTjW7iaR42Y2PVkJDanD8CZtZNnx00qTXq/W0yhS8293FV1+rUevMTPRQ8txjeEydYakuOY3G0aWllfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CBCW0yIFMmZLDN+sfEUoovTRj5wuBx/Da9Q6gBCWcsE=;
 b=oPx8uNlTYMlYHIxG1AAqvN2mc42BF9a19xnkmGcrYO0Tu6y6gFXUF40YkL0BoLtnQPApJfDG+piw19QlDgWCgljle9iUje6uPcNCAwuarCx48nNvrNFysSseIycdhcKUTZQynQF0kq8kPM1Zhwjr8PRlzE/VUSNvimYpQ3r+u9LD5yOsLAwvhSPJ3sq8aEZgmUnaFbZkg1jE6OuPxQdGM22YEVud3rMUsPdMqujjW3cQvPCQOXc3/LswVLVkEYkFQ1E+8q40F1Qw3YWx77R0SEPqa+UipnSs/ZjiNVJI2Om3dl41S404M0GL5ITfN7LlDRqlScblHMHMT7ALSx8jug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CBCW0yIFMmZLDN+sfEUoovTRj5wuBx/Da9Q6gBCWcsE=;
 b=Sv2HJ/YYozqD7ZkqWP3VoiW6KG5lzkSesN4Ry15GcAYhSGynE3PlXAWOLJ2DPEJ+LooskYV9h72SJCc7h5Lx1/141sfzk8MuWbtvmGi+Nrv9cEfzrdAOzpmcjWzvciJoQgjuAkL6VuKuQQmhBbEUENb10fIGNUdmNQDGrpxHxAc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 SA5PPFE3F7EF2AE.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8e6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.20; Fri, 15 Aug
 2025 13:17:08 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%5]) with mapi id 15.20.9009.018; Fri, 15 Aug 2025
 13:17:07 +0000
Message-ID: <7395fc42-5af1-4e26-9e39-8e7213ac5f7b@amd.com>
Date: Fri, 15 Aug 2025 18:46:55 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 02/18] x86/apic: Initialize Secure AVIC APIC backing
 page
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com,
 Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
 David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com,
 francescolavra.fl@gmail.com, tiala@microsoft.com
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
 <20250811094444.203161-3-Neeraj.Upadhyay@amd.com>
 <20250815102537.GCaJ8LIZodp1yY39QA@fat_crate.local>
Content-Language: en-US
From: "Upadhyay, Neeraj" <neeraj.upadhyay@amd.com>
In-Reply-To: <20250815102537.GCaJ8LIZodp1yY39QA@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0104.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:9b::6) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|SA5PPFE3F7EF2AE:EE_
X-MS-Office365-Filtering-Correlation-Id: d0b31839-eea4-4816-7abc-08dddbfe08c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?amlkNHJmY0xqVGowYVJwakRqdU1PZUowcEVacmh0YVE3aGtZTHNETUJIMGJZ?=
 =?utf-8?B?OHhXZUJOMXRTTG5tRWFXTGIrVEFtQTc4aWp1ZnBybkE5cXMzZkpheTdjd1po?=
 =?utf-8?B?M0JNVWIzc0l1Tmw2TUpMejh0ZHcyRUg2b0NYWGkvMkRaMGJNS0lPQTNka2Jz?=
 =?utf-8?B?MlowMnVMQzhiVnV0dG1hTGlZMnh1cGhTeFYydGhjeW15eW13YlhvRFRORVNy?=
 =?utf-8?B?Z1ovOHk0SGVMR1Fna21LQi9TL0xNMmI3bC9rMVdkRU53SkJPV2c1b2x2TGN0?=
 =?utf-8?B?RDhKM0MxaHVrV0YwZVMxOVBld3RRUzVvcFpPOGh3b2RNYi9pK3BrTU5aK0ZH?=
 =?utf-8?B?RCtpZXg3a1BBYWhydjBMZEVkWkJHSHhxQUdkTGNYZjQ3Y2NrbythYUJwM3hC?=
 =?utf-8?B?SDNEVnU4TXc1Ris3Y1gwWnVtSG1DY1RMampsRXZHM1NOYkxEcG4yY3ZUVUhu?=
 =?utf-8?B?dGRyQkFBMjR2WkN5RUptWW5ZZ2Q4WWQyUHFqYkpBM0svK0c3S0llemUyNG9N?=
 =?utf-8?B?cXo5QlFnRHVhQytVWkV5RmhvTDNkbnJQdUFPblhLQWxxWHl4MVl4cVJ5Mk5y?=
 =?utf-8?B?NjZpaGJrQ3VTa25pakxwQ1F2ajVKR3QrWng0YkhhUnhvRTNvTlA3cElJekxY?=
 =?utf-8?B?M2dHTHpockVwc0JoTFlNZmFBbjVjWUFzTHYwN0ttWHRaSmd3Rk94SjFSS0xl?=
 =?utf-8?B?cWZSZDFOSzNXS1JkY2I0Rk53RHRlVGVjUFM5RWpJSHdQSmpJcS9vTlNxWHJG?=
 =?utf-8?B?b3J3aEN6TU50SEEwOGlHVEc5ZW9TYzN0bkRESkFOTGRqTUF5Y04wdEVhNFBJ?=
 =?utf-8?B?b0lHNXRtazBnZXVpOE5XdFdnSWhhWUYxcUpURENyTlBvenM1byt6UGpqbUZ3?=
 =?utf-8?B?bTlHcEJwTjMwSjFQcmdKRStpeGtOUGhNQmorOFRucXlzOXRabE54Rk0rYklu?=
 =?utf-8?B?REZwUGxBbDMrQnFQUWhuZUZOSjZUR1RUNkgxZHVFeXkrMk0zRDFYZWtYeEF6?=
 =?utf-8?B?Q1plWlMrbVZTcGNicDdrYnYxRWVwOXZQam0ycHhMbzFHOE1LNkNTbUlJNDJJ?=
 =?utf-8?B?Q1ZrOFpoS0piMC9BRXh2R24wWWcwRkJ6SWNFalZxZjhyK0h1aW1TZ2F3Vldp?=
 =?utf-8?B?VjdkdmZwVGphNFlXYVQ5cm1zQlcxdGxZWFFwOEEzTzQxMGl0UzVEN0ZuT1hq?=
 =?utf-8?B?eXR1QUtheVFzcS9XY0lsR0dPMGdaWTBPY0tBMEprTG5Yc1paQ1laRDZHSnow?=
 =?utf-8?B?R0xNNWd2aHdTSFV4eE1VNE1LTUNwYVNrVmpMbXphZVMxUytpd2N6Z0lRcXEv?=
 =?utf-8?B?d0JwenNHOHFNKzVEMzdXaVVlNFVjQWIwSC9UWE53NlJ1K0RrVTlKSSt2amhv?=
 =?utf-8?B?ak1PdHdZNCtYek1jVy9uUGZJSXZhRHlSUDlPTUJ5N2haaHZDSnpwdVpSVXY0?=
 =?utf-8?B?VE1RVjhsZmVRSnF5L2ZZU0ZZSlIvdjBHL2lXZ2xhYmJ5QzlVUTFybGJNQmx6?=
 =?utf-8?B?TGNESFNDRk91Y1pxZ1NWUkRrUlRXelVWY2Z2Y1VnZzh1NFJhM3ErcGFJMzVD?=
 =?utf-8?B?VnhXbE1HdWJmaHpTYzBOVGtUMFFmS3k5RXRFcm5TL3MxdFVyYVRHTU5LMHc2?=
 =?utf-8?B?ZENBNTlYZFRjdmdWbDJBblRzMTFRRy80QVJPMmdWVU1VVkV3bnRWM2FTaHp1?=
 =?utf-8?B?UUgybTlsaUx0eEhJWk5wWkFDb3lUWHE0SkREMXp5TlJaaVMvcHRVWmZ0TnBB?=
 =?utf-8?B?TnQ2M0RqdVpLTTRoU2U5VmRyTTBMQmFVL0hqcEVqeFppSHNyLzduTGE0MWdM?=
 =?utf-8?B?bUxyYmR6aDl5TlFQZm96N05USkhVSkdpck1FbncwYTk4dmcyc3BxTmNKYW1Z?=
 =?utf-8?B?U0phVktkWjBBN21LZVlBWmloWXVremhMUlBmTkd3bkFKeFFqVXZkNHR5UmdU?=
 =?utf-8?Q?faTHri/row0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R0tlME55VlppSkg5VjBkeTZwWjM0NGVMcFN1d0lMZEJDczF0US9KazFtMDZ1?=
 =?utf-8?B?cEp3S212VS9mUndlZDU3ZzhremFoRVBFaHJadG1MSE96L3BRcC8ybjF3M0RK?=
 =?utf-8?B?SW5YZ3l6YnJscEdGZnJoMWxZKzA4Q29EQ2lqdk56Y2tOMUpDR2J3SWdjbTZ1?=
 =?utf-8?B?dnJNUlZubnFQSHJRS2VuTmFMZWZkaEdiZktKR0JBUVRWUk9HRzhMN2tjb2xi?=
 =?utf-8?B?ekJacUFKVTlpWjVmaXhpdkpVbUJ6M3RRRytaNWJpam9rT1FGWUU4WGhKQmF2?=
 =?utf-8?B?T04vZVM4NjBMZ1BPU1dlaUd5QUVteUZBWGV2Z2FXZzNodVhwd1dCdzhVVjJI?=
 =?utf-8?B?dXhHbWlOSVBZODdLSFN3SUJEdURDUnQ0S2pyeVhHakNHZmZSWnhtNmFhTmQ3?=
 =?utf-8?B?TnFHc2xKdk5BNUdDa0NzeFVFZUU4TFk4aHlQQTkydjBCdndHaUNvMTRBVkE2?=
 =?utf-8?B?Ly9jSnRFZ3d1VEpWWkxIK2NveGhVSmtyQ0xVZnQyOFBFdldQRzVYRVYvaXpj?=
 =?utf-8?B?MjJ3UU41ZzBIaEZFTnlONzVneHdNOEx3M3FGOFM5MVdWd1gwYTJQSTJhU05C?=
 =?utf-8?B?QisvWm92dGh1ODFHNGFPOHRjVW1kMzNOTkZ1OC9RSnFwYXFqblBWbDlyUkhW?=
 =?utf-8?B?MUtocDlCS3VEYlRubFUzdHNObFlwalZSRzBnS2Uyam8yNEdoclVoejQ4WDZN?=
 =?utf-8?B?OW9LUXd4bGxXb0YzdldUemVTOUJ0VFlkRzJkZWF3d1lpQzBHeWZBTE13M2FD?=
 =?utf-8?B?Z0hUcW5nRFhtY3g4RE1ZcU9DMjdYb3Q4VURQUGxySGp6ZHBzVmVmbUF4MHJF?=
 =?utf-8?B?aXNheitkNU1ERHJkMDZHYkZoZG8xNjEwTGREQjgzWE9Zd3VMRHZJTHhqQnh6?=
 =?utf-8?B?MWtmZWU0ZkJOdG0wOTV5bnk5bjJDTDRoQUdvZVp0V1ExZTd6aGNIbTF5WUFs?=
 =?utf-8?B?QXVvZWh5MyswNWJlR3JERWFXcUVraTBiZ1JZQllBeXZSbXlEcFNjbUE0SytB?=
 =?utf-8?B?NUdDR2w3dGR4dlk5SXNPTUFqQlduM0s3bERnYVpzcjlKVUZGVkEzY0pMZDZ3?=
 =?utf-8?B?bHJGaThaZEpNU0lnUkVpejByRGdZaVpuRWI5ZktLdGFvdEgrdU9OTXkvc1dZ?=
 =?utf-8?B?V01SdFZyUWR2bUZZRy9VdDZsc0Y2K21KMjNEc2FrUEEvT2xwaVBMUWpNUnlG?=
 =?utf-8?B?cXpPT2tqdmxYcldtRHdUWVdrbGlTYzY1dVJBdVVnQzd4WHNtZTFxVVJjeXZm?=
 =?utf-8?B?b2pxbFFCSDU5T2R2UGx1OCtDWnIwNklqcnVONkt0MFhUWVVqT0dLcnRLWEp3?=
 =?utf-8?B?emh1ZzR0cFpoZG9RNW1MNEpCUnhiY3NPR2FORzhDTkhPelRNRzZ6R0FMVjJy?=
 =?utf-8?B?NU9zYUJ5UVRFaUZUT2ttL1pVM0tZWkRxakdzM0lxN1hwZW1kVmFhS3pseVFS?=
 =?utf-8?B?Rnl6NzMwbkxIeC9YbXhERlhObnBBdlU3OE0xOGVGeFMxby9ndUV3c1ZQUU1w?=
 =?utf-8?B?aDF6eG0zck9YTnozaGYydVZOQkMxTHBRYWN2SmZjUUVpR3loRXFZcWlaakJ6?=
 =?utf-8?B?Y250Y2VGZElFWkpsL2I5S3V6cjZBelh0UkdneE01RzlyLzh6cVBRQUNuYnJF?=
 =?utf-8?B?QWlGSUpFbVgvclErMFJtU0F1NFRZTmlXWVZLUXJuZGZTcWlCYmQ2aDdoa0dr?=
 =?utf-8?B?VzdDRThBMzcyTS9TaWxuZnk5NitTczV5RzFJamIyNitMd1lvcG1jczZWdkhE?=
 =?utf-8?B?ajFPSTNUeUdzVEo4WThGa3VvOVJ4SmZ0UnlPejd4MCs4K1VsejNGZ3k1UlNx?=
 =?utf-8?B?TzEraDYxZUNPcjJsVXFPbWxwcUpVMTMyOUYwSm8rWlZvZ3hHUTVCWWlJb29z?=
 =?utf-8?B?cHNGY2VuQWtuanZpYkt3ZGlQY0RYZGF5VitrOWIrdGVFQ1BlZ1R5dlJXcXRu?=
 =?utf-8?B?eDU5Q3YyR0JGVjVralcwZTdIZ3YrM0diR3JlTmdodjBXZWRNNU8zL3FyQURO?=
 =?utf-8?B?TmFndlI0MTdEVVhULzNucnUvZ1JTeVFZajB1VEN3Y1dWcFY5WThETkxSTVJt?=
 =?utf-8?B?TGFQYjE2d1ArTHZMMzI1d3BMTURpYStuRXpudjdKcGdyQ3JaZmRCKzFzWnU5?=
 =?utf-8?Q?4gucf3tWVhHfVpYSb8ksiIr7w?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0b31839-eea4-4816-7abc-08dddbfe08c1
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 13:17:07.7237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JmB7Q8Xp4Wf/GI4YcSov2C/Zg4emhvJs1CgQaRzk4fgm3RmgpjVrqVX9K8W/lXmqFwnC/3VmWnLPVnWcgUpuOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPFE3F7EF2AE



On 8/15/2025 3:55 PM, Borislav Petkov wrote:
> On Mon, Aug 11, 2025 at 03:14:28PM +0530, Neeraj Upadhyay wrote:
>> With Secure AVIC, the APIC backing page is owned and managed by guest.
> 
> Please use articles: "...and managed by the guest."
> 
> Check all your text pls.
> 

Ok

>> +enum es_result savic_register_gpa(u64 gpa)
>> +{
>> +	struct ghcb_state state;
>> +	struct es_em_ctxt ctxt;
>> +	enum es_result res;
>> +	struct ghcb *ghcb;
>> +
>> +	guard(irqsave)();
>> +
>> +	ghcb = __sev_get_ghcb(&state);
>> +	vc_ghcb_invalidate(ghcb);
>> +
>> +	ghcb_set_rax(ghcb, SVM_VMGEXIT_SAVIC_SELF_GPA);
>> +	ghcb_set_rbx(ghcb, gpa);
>> +	res = sev_es_ghcb_hv_call(ghcb, &ctxt, SVM_VMGEXIT_SAVIC,
>> +				  SVM_VMGEXIT_SAVIC_REGISTER_GPA, 0);
>> +
>> +	__sev_put_ghcb(&state);
>> +
>> +	return res;
>> +}
> 
> I was gonna say put this into a new arch/x86/coco/sev/savic.c but ok, you're
> adding only two functions.
> 

There are four new functions. So, do I need to put them in new 
arch/x86/coco/sev/savic.c file?

savic_register_gpa()
savic_unregister_gpa()
savic_ghcb_msr_read()
savic_ghcb_msr_write()


>> +struct secure_avic_page {
>> +	u8 regs[PAGE_SIZE];
>> +} __aligned(PAGE_SIZE);
>> +
>> +static struct secure_avic_page __percpu *secure_avic_page __ro_after_init;
> 
> 
> static struct secure_avic_page __percpu *savic_page __ro_after_init;
> 

Ok


- Neeraj

