Return-Path: <kvm+bounces-60294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C387BE8047
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 12:18:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7A7DD4F929A
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 10:13:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FB6F311C1F;
	Fri, 17 Oct 2025 10:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0VvNHl8q"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012068.outbound.protection.outlook.com [40.107.209.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAEED192D68;
	Fri, 17 Oct 2025 10:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760695994; cv=fail; b=kDzkmxVEQO+BxIXfdh8cmgzehISpFbUZxu7UcZ36g0TeqQ61PG9QUK2vdHpfUqjZEVTltic1gjVc2KDN0POWhXvOvzn8RQPWlLe6Hskt4swGafEWDSiSAAOEbnurOiyQl0lhcnD0JqqtiByApMXJjgAqXLHXMZy2NLFpO3nsaak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760695994; c=relaxed/simple;
	bh=642Pw71/pxdBSzBnrt1Wx7h4Azu94gFn70K6f6QT66M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=d9fxxBGiU2w0O5i/8bP+h5WF82Icbg8pZbLiOLuZVnCGr9ILCLJ7Ej28X1ObYIIXqKCb0IC1sfQtexaqrgA9rmU2OideBCsvvx9ahoNkDMGUFk7cBd1WkaKAs8XunoCKbRldChwOUAslQbpghyPmmXc+rVn9T78ws3ASpq08SMg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0VvNHl8q; arc=fail smtp.client-ip=40.107.209.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E2X2bPoYYs3gpuFPFGA3vw4W25xQx4dWrAN6/JfVnoxrIerZngvi8HP8+3wVnEggKBsh4ctfjK8ZQchL4bq85Sjxcxc5XTqV5jUxEQVxAiTTLHRa9WtPXy8zZdSwFhSPC7hrpjO90+ZO1/TKhHuQ8StKWz15Jy0ZnqnG9IeWFAp94k2eEkvQ+QPEAIB2ZEfGMWHPg/5a8/VBMqEr9x5Ei5+mYnFifDH9qF+N16nTBz9VpVV5wLAnEeLyOAZGZzZQqiokgF1EQfdZDx/XJpo8pBgXoxLrZdn2jTZg2HNTQpdHfYlfrZmReWP9ao6tyJ+sCLAcAJbPLidCcB3TYIs9sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D11SX6Hue3vLXwHdCvNY3Gxcc+ppD5t96Cb4M1aMVFo=;
 b=btU0XdGAEDRny8VfKuSXHOdqlyVZ9ayY76dGj43QCto2nY3q7ZEzrdY8nTaQUpi4+LzWH9g4nHesd2sJPIH5NBKf0teNT8+V0wEdEotB8abRqLEsHaN2M/LpyfkXGuW9rX1YCoxW7dATi/QczN1yGbweRWUwAtamYIaXekNEqMsvobFQVch5mldvcR7YjzOnLbjujqzF5SQws2FkmMzAIa3bTijmF7eXgINzwySXmXVHcUh70jGk1ZkFRlRrwGw/ZJUgnfrDGRDqmpCJYPmft5SJiqNxconhX9HjqVu/JJLpXR2DlnZ3e1qZlUAG/AAbgwkgpzCClkf2pl2gGEdZGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D11SX6Hue3vLXwHdCvNY3Gxcc+ppD5t96Cb4M1aMVFo=;
 b=0VvNHl8qTbpDUVr41BzOOzhKbQYfCsICaf6sKAxb/RV0btxMtRqf9kknO8dAhT6w/T0rQ6wjWcx2SV9BYGkeR+rtrVD9HKo28FKKwEoI814rqkhq8rcCHbseI8EG8b/BxXLuXlmqXjrQtkt6/CY5/mCLfOqH+R7fTt10ayV4340=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PR12MB8301.namprd12.prod.outlook.com (2603:10b6:208:40b::13)
 by SJ0PR12MB6901.namprd12.prod.outlook.com (2603:10b6:a03:47e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.13; Fri, 17 Oct
 2025 10:13:08 +0000
Received: from IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823]) by IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823%4]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 10:13:07 +0000
Message-ID: <12e97af8-d2c1-43ac-aa7f-a5416ee48201@amd.com>
Date: Fri, 17 Oct 2025 15:42:58 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 08/12] KVM: selftests: Add additional equivalents to
 libnuma APIs in KVM's numaif.h
To: Sean Christopherson <seanjc@google.com>, Miguel Ojeda <ojeda@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ackerley Tng <ackerleytng@google.com>, David Hildenbrand <david@redhat.com>,
 Fuad Tabba <tabba@google.com>, Ashish Kalra <ashish.kalra@amd.com>,
 Vlastimil Babka <vbabka@suse.cz>
References: <20251016172853.52451-1-seanjc@google.com>
 <20251016172853.52451-9-seanjc@google.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <20251016172853.52451-9-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1PR01CA0153.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:68::23) To IA0PR12MB8301.namprd12.prod.outlook.com
 (2603:10b6:208:40b::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8301:EE_|SJ0PR12MB6901:EE_
X-MS-Office365-Filtering-Correlation-Id: bb15aee8-54a4-453f-fa93-08de0d65c487
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VGFvNGszS3RtSTlmMFhxY3NpeHQvTmcxV2xhMFhPbE9lYWRnQlBUSlVOV0lM?=
 =?utf-8?B?REVidUxJUkliZXNHWnIrOFdzYmxJZjNzSER1ZFE3bUNCUkhCaGs2SGRJalRH?=
 =?utf-8?B?ZnB2aDMxZnlwMUN0T25sU1ZxT2JmVXBiSHVCL0xST3J4WnRwSXk5RVNkNFp6?=
 =?utf-8?B?bUdlVElPemVJTGRNTG5RaytPVVdnWWNWcjlIbEVEcjh3QWRxdEUvcFN6NnJF?=
 =?utf-8?B?NGU0VmM1WFRoTVE0WGY1WkRBeFV6Z3Zja2FxSEs2NlRmdHkrSjcxT2d6c0Zk?=
 =?utf-8?B?ZlozUEJLT3FqU3hkN0UzSWtUTE5TR2xoL1g2bml4WkRVaEhYNjFQZldxblJr?=
 =?utf-8?B?cUs1U3JFcEpxN0FqNVRheHlXUTlPYTFRRllucUlZMlVsUlhNZmFzUVkvYmlK?=
 =?utf-8?B?djFmY0c4WUsyNTJPbFY1NENQay9xMFI0UGZjRWdoNGtBSnRRejZ0T3JhVW9y?=
 =?utf-8?B?V1k0cW5DTUhSYW0xL1VjWTRVVVN4RzgrV0RUWWFkSkR3NXFUVEFmT0lRaGtE?=
 =?utf-8?B?SXE3c1RUU3hONFkxQVloMlpuTnNSVXNlWXNsNGFuUCtNNXU2THlNa2Y3Qnlj?=
 =?utf-8?B?NzNTdlllMWg1V0tCMG03V0QwQ3h0OXlkbnQwSmVKVDhlMnljTlM5M0Q5VXpQ?=
 =?utf-8?B?enBoVEppNSt0ck85Q2syWElFT0pnZ253dHZEVENHKzFuSE80YzkwQnpTK0RQ?=
 =?utf-8?B?ZDFrN3Bvc2R1R1pHM082YlprR3YvM2FrSkFuQW5LMEFuaHgwS3N2QTdCdk5n?=
 =?utf-8?B?Tk5ITU9jTkJqRFU1MEV6ZlFGQzZJQklsOWw0MVAvaUNoTGRhV0NkTi8vTW8x?=
 =?utf-8?B?bjJPdUwrL2hOeGhUWFFIdlFrZHdSY0JxdDgySWFjYlNqVUsxbU1IeENzSk44?=
 =?utf-8?B?RWg3dDN2YVlYQTlnamJSUGtTMFlpaEtPWDJQMGRjLzI2QXM5M0hHOG9aSHF6?=
 =?utf-8?B?MnU2OUNWd3dPUVlsNE0zV0FhQm8zL2R1SzlsMlRldTVMbCswcVNjRzB5dTM3?=
 =?utf-8?B?LzRPdjF5OStrd0JEZXR0eVRLZmpaNGJYc0Z5UWJ4Nkx4Rnp3QjNtVXcvSGRj?=
 =?utf-8?B?MWs0Um9kOEgzK1N3VHVUMmdTQ0VSdEJ0MzVQOEx2K3BlL3hzeXRiQW01VnlN?=
 =?utf-8?B?S2pVZmo3V0ltZ1hiZ2lLaFE2clNQZUVTbCtjK0ZBVG1CV2lMd3VqM2FwUGk4?=
 =?utf-8?B?UnpvNjV4S2M2OE95ZDdJNUxNVlhMT25DUGZ5alBmUk9ONFFTRWttT2Q5UW45?=
 =?utf-8?B?NWwxZ0ZxUTVPSTl0SFVJcXA3Qk41VzZIN2I3MjhncmVuOEpFRUhjR1FKNzRr?=
 =?utf-8?B?akxwODQ5cHRpRFpBQjNHZ013MGQ2d3ZDNWE1RENlb01aUloxeStuUnJ4OW5h?=
 =?utf-8?B?bGN1RkJYQjhuK1pMV3FWSjRUQ3UxbEdlWDd0dEVMVHBCNlg3bDJtZHg3SDJ1?=
 =?utf-8?B?MlZsWVh2UGdGZVQ3Ym9QVlJjRytxNHNLYmxBSEFROHhpWEJHWFlNTHg4OEJX?=
 =?utf-8?B?c0tzeC84b3BTYkcySWVLRy9BaVRGbDhkR0IwUWVtbzhQRGFTNmRZZ1J0b05Q?=
 =?utf-8?B?QjFrYkFuNTloRjI5SjY1Mm9DRVM0WE5TeGtLZmkvdWM1dXU3aS90eXRKbXV1?=
 =?utf-8?B?bzhqUkV5STJpbTltRXc4aG52eUdibW5nWWVUZ1haajNRckZFWXZDbUFzRVNj?=
 =?utf-8?B?Q0huWGpwZ1dUcDNUQnF2Zm9uMXJRTHZnME9VaU80dUtSUVVjZkErVXR5djdV?=
 =?utf-8?B?Z283a2hYOWg0RWl4RjJoZTJsdjNMOUtDdkhMN2ZUSHpMWU1qWm1SVkt2NDdU?=
 =?utf-8?B?RFo5ZmlMNmFZUUNLcHN3QjdRTHcvbHRhUloxSFFpQ0lTbFprOTJlQ3dhNU5w?=
 =?utf-8?B?a0hObUYyQ2tueXNRMzBPdGxRcGQrNm9CRlVNVWVWbmkyek9zZGYwV3FjOTU5?=
 =?utf-8?Q?yHKF/hd8yrgds63mLM0sB1eAp0daruiQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8301.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MlloYWxIaUpzck9aWWlPU1lFTytiYldjMWRWd0RxNGxLbjlJT0R0bW5nb21u?=
 =?utf-8?B?VERFY3FSY3l6c0FWZFZ4SHBKdHVUR0NGL2FYbnhRb3Z0dzByWmJ6MzFoc0dJ?=
 =?utf-8?B?Z0w0UWFKWlB1YmJPeXltYVN0QXJQK3R2blVEWGpSTWljcVptZlc2eVg5VkNC?=
 =?utf-8?B?S3ZmU2dBVnNsZVd1WU9Td1kwbmtKMG1kUWJTVzZnSHd1bTM0MURrTGZLUGh2?=
 =?utf-8?B?cE9wclJ5Y0J1UGlLQkZJbVU2R2UrbFk2Z0oyRzBMNWZVSUw3Qm1iNWtjM2Rk?=
 =?utf-8?B?ek9YZk9aY1VnZWxieXNTejJLaVRKbTdoQzFPUnBlL2pJU1FjeGdwZUJ3bUV4?=
 =?utf-8?B?SnJvN0lEYW11cEFrK2UvNDRZMEp4NUJ6OEJCREg5ZW91WS9YT01ORyt3T1Zw?=
 =?utf-8?B?eUp0TXJVNi9NSFlqejNMVTBJUTdiWWpXTGJEZEQxSE5sZnhTd0Z1VzEyQStz?=
 =?utf-8?B?aXNTLzB5dHZObHdrc3BCR2dXcVhnZWJFUVYwUzhUa0hLOVZoOXRSNkphM2x0?=
 =?utf-8?B?UmFKQjNJYlB3RkpZR2ovU054bmRvU2xkaGpaS0JWdEdIYURsRnBIQVdCMFJN?=
 =?utf-8?B?Y2lQUmlWMmU2cVFrOUJMbmZZc3JDNDdvdEtpd0Y0ajZiVk9lb1psN3k5TFhU?=
 =?utf-8?B?OVA5RUV4RGVsRVQrdXhFY2tiQkx2bk1YZlpBT1crMXZuOHU3WE4zNi9zRnpN?=
 =?utf-8?B?c1MwOGVMamE5VGEwYTBUOTNlamVvM3N1bUFBL0RCNVlvaW5HZTVKNkhETU9Z?=
 =?utf-8?B?aFBZWUh1ZmNxTGdXSnhZaEZ5WDlVdmlwSkxXTCtOMjZQaHRTR0lPd0MwcFE0?=
 =?utf-8?B?c1NRWUVxRU5GanV1MCtWRnZaYVo1REV4MWJkSmVHR0tOMGF5c3E5dFdnTS9P?=
 =?utf-8?B?YUFhR2pLZXNOQVRpZ1Z1ckd6MVpQczZ1bHo0MGRPa2duT0dFd0xzNnZDV0V3?=
 =?utf-8?B?aWN1NkFOVkt0VTN4WWxZTlppaXRXMjA1SytGZkliQldjSzk2MVJOeWx6VThk?=
 =?utf-8?B?Tm9YckVGUzNlb1JRcmlTYzcwNG5sUTVrRnVsVzdqUnVYUjAxNkxUYXVZYStQ?=
 =?utf-8?B?VjNLZDVEUktuNVVna1VEUTdpWnZ1QTVZS0hHTUFUQkozUVhxKzZhdmNtdjB6?=
 =?utf-8?B?UGRwa1JpQkxYTUF4OGlJMHF3M2swRzFwSkQxdDRwWGRFYkpMUXpzRjhTWE1Z?=
 =?utf-8?B?YmdsS3dvZlUwcEV2VXRYOVhCRTQ4aWNkL3pzREdKWnZpN3BsTjQvdE9xbThz?=
 =?utf-8?B?eFcrdURKTllzRzlGQk5iMjc2VkZuT3R0aE1Mbms3Y3FYckpDMHAzV0ZqUFhL?=
 =?utf-8?B?VnI4bGVqeGhjUnYraUdLMTdzN21XWlBySG43amkyY29YMkZLcHlXcTV4azRD?=
 =?utf-8?B?QVd3TVpXQ3B3MmJRc01hazRMRDRvZzM2Q2NyNWFyQ0VEVEM1ZVRwYVBBWDgy?=
 =?utf-8?B?NWxFSkVGNEIwMllDTTg2bmNCUFdTdUptSi9ZdGw2eXNSSmg4SUxFRjBTQlhy?=
 =?utf-8?B?cDFiMGtZSGFwUUM5QzBwTlZjV0wra1N6Tnd5SUtGSzljSGZ3RXFPSWhTUlhP?=
 =?utf-8?B?b3pTOE40V0RQYzlRODZ2SHF6QkE4VVdQL0V0MVBQSHQzVWo3dnlUU211ZDBp?=
 =?utf-8?B?NnBLeEk4UThrY1VJNTVMQTBjVFJwZFRlSjc0emp1dHR4TVA2Ri8wTTBkbjdW?=
 =?utf-8?B?d0VpeXZ2R3pCSkxlRHQ2WERlb2lCZkgrZUlTeTRUOEVFZGh1ZEZFdGJ4akFU?=
 =?utf-8?B?UW9OZCtXdFFHUHVwWnJ0M2NYbXM1NCtWaUlnb21VWmg0ajVQYVd2bm5PT3Rx?=
 =?utf-8?B?ejd3Mnd4aTlUWUliS3hEMkhqR0s2QUYxVVdkZFJvREM3TXRiOEpDdmNMNVdw?=
 =?utf-8?B?WkJZNUtFRTRtWnZqaVZnK08wVncrQU1paHJ5bkhrd1pqVnpacUxDOGx1c2FW?=
 =?utf-8?B?ZktPSUozcUJxRTNEZ0drZmljTnNhU0ErMnhLeGxyd3lRdFZIdFpIbjh5WHdh?=
 =?utf-8?B?UzdFakVKQWtqTHpieXlIOEJ0c3daa2ppaHJQNTR3eU1laHVJSUpQaHZtbTVi?=
 =?utf-8?B?bEJkazZFZWxJRUY3RGNUVzdlcGthUGdvNVR5UHZLejZoQzhJMWg0dDhyNlIw?=
 =?utf-8?Q?h2yX9B+xI+3NHui31iiXlGJUo?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb15aee8-54a4-453f-fa93-08de0d65c487
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8301.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 10:13:07.7471
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eMv9a8ZHHOYr10W7SHFsRWAHT23XHOshx4BPo+NuTFIcEtzcI1MfRW6DLlVdTtrVIaCy5U1N0Gk9j8wuDtYZPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6901



On 10/16/2025 10:58 PM, Sean Christopherson wrote:
> Add APIs for all syscalls defined in the kernel's mm/mempolicy.c to match
> those that would be provided by linking to libnuma.  Opportunistically use
> the recently inroduced KVM_SYSCALL_DEFINE() builders to take care of the
> boilerplate, and to fix a flaw where the two existing wrappers would
> generate multiple symbols if numaif.h were to be included multiple times.
> 
> Reviewed-by: Ackerley Tng <ackerleytng@google.com>
> Tested-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/include/numaif.h  | 36 +++++++++++--------
>  .../selftests/kvm/x86/xapic_ipi_test.c        |  5 ++-
>  2 files changed, 23 insertions(+), 18 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/numaif.h b/tools/testing/selftests/kvm/include/numaif.h
> index b020547403fd..aaa4ac174890 100644
> --- a/tools/testing/selftests/kvm/include/numaif.h
> +++ b/tools/testing/selftests/kvm/include/numaif.h
> @@ -13,23 +13,29 @@
>  #ifndef SELFTEST_KVM_NUMAIF_H
>  #define SELFTEST_KVM_NUMAIF_H
>  
> -#define __NR_get_mempolicy 239
> -#define __NR_migrate_pages 256
> +#include <linux/mempolicy.h>
>  
> -/* System calls */
> -long get_mempolicy(int *policy, const unsigned long *nmask,
> -		   unsigned long maxnode, void *addr, int flags)
> -{
> -	return syscall(__NR_get_mempolicy, policy, nmask,
> -		       maxnode, addr, flags);
> -}
> +#include "kvm_syscalls.h"
>  
> -long migrate_pages(int pid, unsigned long maxnode,
> -		   const unsigned long *frommask,
> -		   const unsigned long *tomask)
> -{
> -	return syscall(__NR_migrate_pages, pid, maxnode, frommask, tomask);
> -}
> +KVM_SYSCALL_DEFINE(get_mempolicy, 5, int *, policy, const unsigned long *, nmask,
> +		   unsigned long, maxnode, void *, addr, int, flags);
> +
> +KVM_SYSCALL_DEFINE(set_mempolicy, 3, int, mode, const unsigned long *, nmask,
> +		   unsigned long, maxnode);
> +
> +KVM_SYSCALL_DEFINE(set_mempolicy_home_node, 4, unsigned long, start,
> +		   unsigned long, len, unsigned long, home_node,
> +		   unsigned long, flags);

set_mempolicy_home_node() has no user in this series,
but adding it for API completeness (or future use) looks reasonable to me.

Reviewed-by: Shivank Garg <shivankg@amd.com>
Tested-by: Shivank Garg <shivankg@amd.com>

> +
> +KVM_SYSCALL_DEFINE(migrate_pages, 4, int, pid, unsigned long, maxnode,
> +		   const unsigned long *, frommask, const unsigned long *, tomask);
> +
> +KVM_SYSCALL_DEFINE(move_pages, 6, int, pid, unsigned long, count, void *, pages,
> +		   const int *, nodes, int *, status, int, flags);
> +
> +KVM_SYSCALL_DEFINE(mbind, 6, void *, addr, unsigned long, size, int, mode,
> +		   const unsigned long *, nodemask, unsigned long, maxnode,
> +		   unsigned int, flags);
>  
>  /* Policies */
>  #define MPOL_DEFAULT	 0
> diff --git a/tools/testing/selftests/kvm/x86/xapic_ipi_test.c b/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
> index 35cb9de54a82..ae4a4b6c05ca 100644
> --- a/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
> +++ b/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
> @@ -256,7 +256,7 @@ void do_migrations(struct test_data_page *data, int run_secs, int delay_usecs,
>  	int nodes = 0;
>  	time_t start_time, last_update, now;
>  	time_t interval_secs = 1;
> -	int i, r;
> +	int i;
>  	int from, to;
>  	unsigned long bit;
>  	uint64_t hlt_count;
> @@ -267,9 +267,8 @@ void do_migrations(struct test_data_page *data, int run_secs, int delay_usecs,
>  		delay_usecs);
>  
>  	/* Get set of first 64 numa nodes available */
> -	r = get_mempolicy(NULL, &nodemask, sizeof(nodemask) * 8,
> +	kvm_get_mempolicy(NULL, &nodemask, sizeof(nodemask) * 8,
>  			  0, MPOL_F_MEMS_ALLOWED);
> -	TEST_ASSERT(r == 0, "get_mempolicy failed errno=%d", errno);
>  
>  	fprintf(stderr, "Numa nodes found amongst first %lu possible nodes "
>  		"(each 1-bit indicates node is present): %#lx\n",


