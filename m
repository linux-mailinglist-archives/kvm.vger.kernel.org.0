Return-Path: <kvm+bounces-58847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04DBEBA284E
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 08:20:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AEE754C80D2
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 06:20:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D142727B331;
	Fri, 26 Sep 2025 06:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="H4z0T3wK"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013069.outbound.protection.outlook.com [40.93.196.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507622AE8D;
	Fri, 26 Sep 2025 06:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758867645; cv=fail; b=ZkIkRWPnrIJEd8g2CKgc7G0Tl36wrHe+3My7go7Uvgujdo/IdW7FNHKejmk11tnDLuC2x+BdHujmw9QjtD9fIqtMn+SN9R77a2zGGTG2lxcJhGqNvaWJ8+dvZx9/HApW5Iccw6UjaMy8hMhApAaXMgyYT+nHu+xsWytrBqvHAoI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758867645; c=relaxed/simple;
	bh=L3DjZV9Fgfuof2Kgm6T2LC8pM+tE09T0YtPupJYaaAU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=u3EmzIvc18pap1LVFa+gQvrfXQ6w1uPUjP4Rau60HgKq25HCOcC1ZsbhCtg8gKXNAteC2aMz2SnR/+9rDZJKQg0iMPMVknqpbuNDOd6yfQz2mimLShlJxzEex7uM7e+k+1RY2ybOiTEJF9ryfMaZV8gZhNLQXuEkob2WItITyOY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=H4z0T3wK; arc=fail smtp.client-ip=40.93.196.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qcLjLkbp00nSln1szeTJ/F6o/mcwsBqeUQuomU/9aGC27/JljVMtxCCTsFFXSTrG5IcJWnwyjIStJyT7xNtkWEZDKsGwRsgVGJz2TMpL+glpiLQKa8SV8liwvmlhrsNPQrSTJdWse8Q0IOcGaZIXjRD5ub0UcYcJxMmniPHa6QquWUYNaU5VVx3KRG7znswf//uqDx4ThUxI7ZdRSZUVXTql/kbfc8nzRujRDopXfCfknccU1RDfzTjodnVboMIJWC5TAxiA26EHCxOEXNEaqC4Y0iqLjBGJYsyDAoJ8vgFWzkF9R5i4auqvxxU3gNVFch3rzckiCUwQJVbU/Zjn9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TlQzOR6+aaPTYUZB+onwoj9eG7WFZRIEZEW64IAl/nM=;
 b=fZxWOnHwJcRN1OMRIGik0TgFezYFd07YC7B/fWjEXjYy/cWSwC6j/uzK3sY2A+zAnsTEZN0L6TeulNSpwCXJR3+Axk2Ve3zPK3165f+bN7tHV2LHbX3M9NwXpmwTfbWGiAMXNWCrm4XG/JOMq2WTNHRioryOsRgbuptYiE3sY7vnLoPE1sICVAsHiFr0cjq4MtoGmzBNJrMCN86AAih2RqLDsQ7IvLJ6FK7rCaKRivV97eYcySn31hiPp9xwCnRquiNDa9sGmI9YBOTtXzczB7OP1LX/R/Byy5FtmwetD5h1oMK2oNiv+RKnRu6zrvz0y4m1Td250UhIYamK25tEMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TlQzOR6+aaPTYUZB+onwoj9eG7WFZRIEZEW64IAl/nM=;
 b=H4z0T3wKkpKb0eSJtQ6ub4JV8usSbItCBZXzjcYD8dO/ZnNyJuX7n/BgfnItafRNVJd2bMRRRh1awF1ufLZUZxJOJzwPHY6ewH91OISxh/j2CDjPvKrMYdi6zBIdWKBSY4TdzW8YUJ6WDdwb5u4FIDROuhpmjZn51gfTktoc3Vc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PR12MB8301.namprd12.prod.outlook.com (2603:10b6:208:40b::13)
 by SN7PR12MB6910.namprd12.prod.outlook.com (2603:10b6:806:262::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.10; Fri, 26 Sep
 2025 06:20:38 +0000
Received: from IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823]) by IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823%4]) with mapi id 15.20.9160.008; Fri, 26 Sep 2025
 06:20:37 +0000
Message-ID: <acf43b57-497c-436e-8c8d-2af50616d9b2@amd.com>
Date: Fri, 26 Sep 2025 11:50:30 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvm-next V11 4/7] KVM: guest_memfd: Use guest mem inodes
 instead of anonymous inodes
To: Sean Christopherson <seanjc@google.com>,
 David Hildenbrand <david@redhat.com>
Cc: Ackerley Tng <ackerleytng@google.com>, pbonzini@redhat.com,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20250827175247.83322-2-shivankg@amd.com>
 <20250827175247.83322-7-shivankg@amd.com> <diqztt1sbd2v.fsf@google.com>
 <aNSt9QT8dmpDK1eE@google.com> <dc6eb85f-87b6-43a1-b1f7-4727c0b834cc@amd.com>
 <b67dd7cd-2c1c-4566-badf-32082d8cd952@redhat.com>
 <aNVFrZDAkHmgNNci@google.com>
 <3a82a197-495f-40c3-ae1b-500453e3d1ec@redhat.com>
 <aNVahJkpJVVTVEkK@google.com> <aNXMDgeFqhWJPArm@google.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <aNXMDgeFqhWJPArm@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0074.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:23::19) To IA0PR12MB8301.namprd12.prod.outlook.com
 (2603:10b6:208:40b::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8301:EE_|SN7PR12MB6910:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f26483f-d454-4b02-5bdc-08ddfcc4ced0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UE84VVNMekxkRzJ6djgyQStrZ2RsdGwxd0lNcnVKSTIrK3dpT0VSVDNjUFJG?=
 =?utf-8?B?SnM1VkYza2EzMXkwM09QQXZxbys3WDROMkJVY2F0dnZlS3I2Z0tESGpNMkxm?=
 =?utf-8?B?RXZCSmFMN2l3QlVmVituTGxPM25ocDUyeXFCQi9DNU4wNnErdlZuZUEzSVl3?=
 =?utf-8?B?MUptQWpxWUJqK0thaTE5U1lGeExIUzVIL0dWVTNaYi9rdUxWQjIwaGJUZHdI?=
 =?utf-8?B?Z3BjRDUvenEwcGV2NjhjWFI0bUpXYU02MnRsOVF0OFBKd3poUEJJZDBaSGVo?=
 =?utf-8?B?VHJ5K1d0NGJjZVY2ZXN3M3A4bGdwUldHakhEcGs3emZIL2YxNFNzd3NBMFFO?=
 =?utf-8?B?NW5wMTBtN3BtVU9JUXdybVk0QXJySTZoRmNKeG1ReGk4Z01HM2tmTlkrY2pS?=
 =?utf-8?B?bTNYOGlRNDBjQ0t5ckQ1aEU2d3hlRUwrMDVZNVlNY1gvMWNHUlVPeitQNFdJ?=
 =?utf-8?B?TVdydnZpLy82eWpQWjJBQ05DcjNLa3JVUnVwYWFBRFZXMGRldnR6L3NFWFpy?=
 =?utf-8?B?UUhGNzF5TzBIZ0JxMjhDaitEUkRHekkydk5tUjVhQkJmOFZSM216WmxSSVQ3?=
 =?utf-8?B?anh6bi9IT3dhTWVOSzVhVXNDaWtmS09lUjJVWmxPOWx5N1AvUytaVk9ENnJ6?=
 =?utf-8?B?V2xRMGI1N1JaL3VXV1ZWRFM3VXpVVXRlSTBvdXBOek12THdBbkVlbWdLeFhE?=
 =?utf-8?B?RWdJNElHQXE0aGdkdnJzTytPM2Y3VVhYaGJWZjF3djNxaGhmaVdxUk1QM2ZV?=
 =?utf-8?B?ZCs1YkRKQ3NFbnpVNWhDSEpkdVgrWGJOUFE0STBiOGRrWkZBWjdyR2poK21I?=
 =?utf-8?B?RHQwYkw0VFZXdzdnajlqeSs5bWxDTDlDTExlbHJrbnZ5d3lQSjdvRlR0cXEy?=
 =?utf-8?B?L28rbFQ4TUtEQ1NoK1hXSG94YkhqQ0dWRGRqUWxuVzhQV1pKa1QzQ2Y0VjRP?=
 =?utf-8?B?bVJTRE1ibnYwa0Fvam5zUFBPTDZFK0NZODIyNU0rMExHN3VXbG9VU1A5ZVBB?=
 =?utf-8?B?OEZaaHEydW0rTk52UFdGWjI0Q1Fkc2NzcVZrSWMxZDRDN1N1Ny9TZ1RrWDR5?=
 =?utf-8?B?alhjM3dHRHpWaWJHYU5EZmNKYTIyM0gxOHdjK2t2S0t2OERldGhyQm9DTVRp?=
 =?utf-8?B?Ui9RWDc1cUxJV01Odlk5bTd6WG9haXd5Z21VNm1GTnhEVnAwZkllNmdsQ0FT?=
 =?utf-8?B?Z3NLeW51Vm0zZTE3YWlOWENsTzNkNDFQZnZuV3MvdURnYVRzNnYwdUlQbS9u?=
 =?utf-8?B?djR3cnp4UFE3Z0hCVk9yT1FXcHNsZ2NMc1UxTGVNQXd6Qno2SFJRVE84Ym9V?=
 =?utf-8?B?R1RnUmlUeUJBTDk4NFE5VXRHbUVtVnFjRmxmMlN1WnZDVVVpUWJyN01nQVI4?=
 =?utf-8?B?aWc0ZXViUUpOYnl2QXRvK2NTRlcwcTJUR3A5SGNDV0pZRTFLa2Y2MWRvSURz?=
 =?utf-8?B?Z2ZSck5vdSs1RU1rckxEbTh0aUExMFE1d1dJamc5NmxlblZvaTV4eTVXSVA0?=
 =?utf-8?B?RVB1RWRuOG13ZzMzajYxcURmVlB2WlFTRDg5ZlBSMTZXYU00UU4yemtmeWhH?=
 =?utf-8?B?bTRwSzJEVEw4cnRwQnp5Uy9IMVR0Y21ZemY0SlBLMkRCUzRFMzJ5dTc0ZVcv?=
 =?utf-8?B?QzNGQ0tTZzhHSDV6U0JsekJvcWFxeXEyZDJ0RmVUaUFpQ3liZnpycVRZOUh5?=
 =?utf-8?B?V0VteHB3Q2VoTjNJZ2d2bHo3OXZRTGJkMEZVNGlJdG9Ea0hReEdUZ1JMYmda?=
 =?utf-8?B?MFI0Z04vTUVaZFBjU0RjUTkyWFZQcFRHZVowK1ZJTkphNHpQN1hROHVHS3R3?=
 =?utf-8?B?OW9TWWIzSXZROWpZUmMyejR1ckgrRzFPM2FBVjFzVUlpbFptZEl5c292MDZy?=
 =?utf-8?B?NWtmT2VROWNzc1lVcjIvd1N1OEw2Njd3Tjc2QnpuZGRZcUw0Tmh6R3RlTzhW?=
 =?utf-8?Q?iqCPfCA3pVk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8301.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cnA0cEk0OWlXUGYzbkp3a3FwZ2dDN2VQMGs1MzF4NjFtZkdvTVNPOGxaZk1W?=
 =?utf-8?B?d2c3RGpBWm5FTm9kVFJTcitxUHQ4Nm9xWmNBd1VlZUNyLzRmVC83OXNydUFD?=
 =?utf-8?B?ZSs4a09IYUxYVC9SRFFCR2wwMExkSGpabEF1K3JRS1NtZU1QMW1QM2xQTmo5?=
 =?utf-8?B?M25xMXVxc3VMZW5rUXluL0NCMEFPc1cxZHhWeWhWVGxiTnptTm0xdXU3MTJ1?=
 =?utf-8?B?S0gzZW04V1hHZkpCeDNSWlduZWxsdFh3Q213L2VvdTF3bFhCUDErZkN6K1ds?=
 =?utf-8?B?U2NkaVJlYUJGUkQ1SldBeGgvVXlPTFF1MmxHdldQc2daK2dUOEdPNlcwdG44?=
 =?utf-8?B?K1ZMVXZUYWRhOUk0aUR0dDZkdkQ1VWEydkY0WGI4R3NyL2Q3TFQrem5XVVMw?=
 =?utf-8?B?amNPYmZQeXNJd1BqVTEzM00xMFNWZ0czRnZwV1VmZXQ2QUprRVN2bTNZdUlk?=
 =?utf-8?B?UXZuSE9BeW5MSTdiTWpkYmVOM25qKzZyczdHTlNSOTZwaGRaTGNsM2RodnZT?=
 =?utf-8?B?cXRiY28zaWJHaVZCcW9vYllORGNtSlhES3E2M0ErdFFMMDhleDhkZUVkMHY5?=
 =?utf-8?B?UnJyeHBYMFd0Y2YvSUcrclRjc0d5TEFvNlV4MG8vUUh5UXhlS2tqMGFGV3VI?=
 =?utf-8?B?V2h0UkpzQ0lZR1prbFNmcFpPeXdTTHlVWmtIcERnUk1lc0FTYTBxZ0pROHVQ?=
 =?utf-8?B?Mll5M2hvUkF2RitnbEZxRmVVUDJPMXMwNkxYNUI5L3NKWnd1VU14c0I4Wmw1?=
 =?utf-8?B?ZkwxTHd5RTR0anRoS1A4RW96M2NBWE9UZW1jMlEreU1QcDlxbml1UUVVWXg2?=
 =?utf-8?B?MktYMDJBbnVSWC9mRHNNUjhwSS9taGFQZmdXeTF1RlBBQ1lJUmF0eGlDL3Mr?=
 =?utf-8?B?L01Hd01BSEhlTDkyNEJ0THBNMFJpdnJYVmFseWZ0SEQySU43d29seTNZRVFD?=
 =?utf-8?B?Y3ZheElMdTM4ZkFMUENBTC9IWG5RRm55WE5tVWlUODZGanlrU1lMdWNyM0cx?=
 =?utf-8?B?Z1JVSkxjZVVHNlJzKzYxY0ZqN2V6aFM4ajhZcjE2QkJieWMyT29SdHphR2Ix?=
 =?utf-8?B?ajE1Zm13a3dhVTlxS242MmZNZVpoUzY5eTRDTUp5a1B3R3ZwOFRjcUhsRTBQ?=
 =?utf-8?B?S0dRVnlBWFB0RDlJODNHaVJWMHc1Vk1CaFQ5a3EwRTkwYzM2NTdtWmYxNFRh?=
 =?utf-8?B?RzFNekdmMUY3KzcvMThUUmFmeko2d1NNMW1mQnM3amhPSW0yQlFGbXdNNkg1?=
 =?utf-8?B?aHpwb1M0dWpmcnZkUkhPUDB0YzduUFJJQXJjUG8vdGFHV2V3dlNrSUd1b1F4?=
 =?utf-8?B?Q3hyY2t6QXlaVHFVUStPQk1sMnZUT0xoVXNhRFZpNkRiQndOSmVkZXlxVXZ1?=
 =?utf-8?B?RncxTXNYY2VtcnhBaHU1Z05zbVdORVFvVDdWSEg2b09ZbmZBVENJL0dsb0Nl?=
 =?utf-8?B?bFBkbS9wTDF3NWw4TGl4YStpWDlmTzgxa2krNmtMbk5xaUNxVlJhYnVmVzFG?=
 =?utf-8?B?VkxDWlNlQW5sMkFnVFFySEhIQmhoMWk5QVRHK2gwbk0yek1IVk8yMm5ENm5o?=
 =?utf-8?B?Mi8rWGlnKzNFNjVoM2oraWlZS1lRaHRVMUtnb3Fmd2JSZVk2Y0FWZkJKRi9Y?=
 =?utf-8?B?Tjl6Z3RRRHE3RTYxUWJxdGsvOG9TcndVVWZXZFRtaWFxTGRNdDBQNnI5eEpu?=
 =?utf-8?B?RHdTMzhpUjJEbkN5d2xaNUhBeklGaDdkREtvZ0ROR3draUxiOHZxQWtEaE5D?=
 =?utf-8?B?V3lwNDJuMnlHVGhkMHNsWHRjbFV3cXhDU1N6ejI2Y3I4UTZnUFcwcEFsdTZN?=
 =?utf-8?B?K0NoL09tenNpMTZpSVkwbFQwMEFVSDZxWnV2cVNuSTRCMVhOMlhHUXF1RitE?=
 =?utf-8?B?MW9icGhuaFFoeGNuTVlOSThSVGtvSzhHV09kK1RDUU1ackRLMFRjV1pVQWJl?=
 =?utf-8?B?YmpiSkJSaVZpZGluTldPcmUvQUhaVFhDczFLcW9JZmJsREx0OS9UM0JxK3l2?=
 =?utf-8?B?KzRqRENJSlRtb3NQVzdhN2FVQ0dlQklPdXNLM2ExYklGWk9sbTdVMFpIUUU2?=
 =?utf-8?B?OGhUOGtIU0FvYklKTWxXTElVelg3WnJxWGkvWGZXTXBvM2NHY2VNY1JsSGhK?=
 =?utf-8?Q?nkg9fywNl5aQMjSelpnZIZyve?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f26483f-d454-4b02-5bdc-08ddfcc4ced0
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8301.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2025 06:20:37.5777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dOHA4WeQBb2dzRay1uQKzcTy2X9cNiyx/EpPEpvE/wN9V9INrYSKoW0vmfnV29Ghtl2EJXF31JJ4886mA0P86A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6910



On 9/26/2025 4:41 AM, Sean Christopherson wrote:
> Trimmed the Cc substantially.
> 
> On Thu, Sep 25, 2025, Sean Christopherson wrote:
>> On Thu, Sep 25, 2025, David Hildenbrand wrote:
>>> On 25.09.25 15:41, Sean Christopherson wrote:
>>>> Regarding timing, how much do people care about getting this into 6.18 in
>>>> particular?
>>>
>>> I think it will be beneficial if we start getting stuff upstream. But
>>> waiting a bit longer probably doesn't hurt.
>>>
>>>> AFAICT, this hasn't gotten any coverage in -next, which makes me a
>>>> little nervous.
>>>
>>> Right.
>>>
>>> If we agree, then Shivank can just respin a new version after the merge
>>> window.
>>
>> Actually, if Shivank is ok with it, I'd be happy to post the next version(s).
>> I'll be focusing on the in-place conversion support for the next 1-2 weeks, and
>> have some (half-baked) refactoring changes to better leverage the inode support
>> from this series.
> 
> Shivank, unless you really, really, _really_ want to post the next version, I'll
> post v12.  I've accumulated a bunch of changes (almost entirely just code movement,
> naming tweaks, and adding comments) to better prepare for reusing the inode support
> for in-place conversion.  The in-place conversion stuff is much further out, but
> I'm hoping to get a refreshed RFC out (with Ackerley's help) in the near future,
> and shuffling things around in this series should help avoid too much churn.
> 
> P.S. Thanks a ton for hammering this out!  I'm especially grateful y'all took
> on the inode stuff.  It took me several hours to wrap my head around things, and
> that was with your code to look at. :-)

Thanks for the update, Sean!

Since this is my first feature merge, I would have really liked to get the end-to-end
experience of posting the patch series and seeing it through to completion.
But as you said, it can help reduce iteration and expedite merging, so please feel free
to go ahead and post v12.
I'm happy to assist however I can. Please just let me know if there's anything you'd
like me to review, test, or help coordinate.

Thanks,
Shivank


