Return-Path: <kvm+bounces-21645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EB4D93177C
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 17:19:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9774282999
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 15:19:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 078E218F2C0;
	Mon, 15 Jul 2024 15:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0zDNv57m"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2062.outbound.protection.outlook.com [40.107.244.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B531918EA8;
	Mon, 15 Jul 2024 15:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721056756; cv=fail; b=ZOzazBPXRB1PeV7lhiWeqJQOCS+I1d66S0P/bBRU5GGg5JBxyVcYogkPniVYtmfETTQSCstrjvNUldua+Nno8QQXyCs1cfgHaQa4ivqKRCDiWt9gtL5m6yDrkwtC9zInP2Yw//E1Zts3s2IJEYSL9BGEKoMMc/Y59y/DaqSjucY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721056756; c=relaxed/simple;
	bh=kZNjFvbjrJMYUa/qQ9+T2j6sUY0bAyqQkXd+fHOK/Pk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rbVqWN9ZY1B6CY55vIzN6dplHC3VYezJ4sJMEl6NGpwL+DQfOWI+1JLI5AsLDQgYCOrPtYPt3Vjn0JKgAtakMQbny0gcE+meEi6UIKbgmg5lVgjCarXLDBeIywlRFoUmTGHf1OaFqp7YIvn72I40bgDvB5l/HgWzQI8gJQMgf0c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0zDNv57m; arc=fail smtp.client-ip=40.107.244.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kFxGQ+JwcmRr81VeLeY7lKxr0iuC/j0f3gyFy4nwcg0GMWYZm/3t4eZoSF70m7opx9muM4rAJUAdIKhmTJSKKtOsQ7SiBIjzid4JxdvJdlgXXs7LWvgyRi2XP/xvDyXXUMSq6a0B9h1s72jBp4kbk/fNWOQNwBLnwz1u2Xhsk/3UG+N+vPoys462wz7VLBrnC/buxnZEs4EfuphtjdJDizdlJn/ZpZvWU1pr33aUD17VfO9i8Fyx6FrU9tjyLz0rtdZznYsa3GnpVpT3pLZZ2mB6K8iS8as4TeS63bh/GWFoiBobQfCEKDkuZEz/MMmX/WrUS+Xks0QfMc6+s/Eepw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZJQ66hAuNVEvQmY2rnCZ7jyjKUtGoI8g1Vh4keyH+w8=;
 b=VCTqkFkTpskuIefowZeEh8V27SOlMstdr1eBU6FFvKwfJ0TOcbfgCyxKXL8fZMmWNJFJOeG6FsL4V2r8QeglgwFjh4eqWE672T7eWMN+vDHIIct3l76oZum/47Z+ll3tCLNJgyVuq3I8QN8eYMbOd+cn52+sIygNQXCST6ry5xHpEZAB1lffmhBHCy8lOKpZoW5tZYLOswLW/jzdg6WDwSRmNlHftuRBVoQorYxdoCY84X+fN5AEKObC9b8BW8ScBF8mB2Z4D/SKwxeGb/w251ltH6o3CB15hcRyCMY1+KWSIu58OsZPdDBjFZbMvD9iPP35an7UAMgI3TZbyWn29Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZJQ66hAuNVEvQmY2rnCZ7jyjKUtGoI8g1Vh4keyH+w8=;
 b=0zDNv57mlUZfyMqqBg9pjVP6MTKCjb+AMw9ZyE+BZ6rOp/9IwVz+WdIMvCeLvOqw+xY34Xx54MkEveqlyBFRtV5J4YCPDBWRsUtUf88dZzKz4b0HKCmNSzgxlLeVX1xT7SS1MIs+IzgNYJa8kcKzlDk4vaecIEO773qN3wU/WA0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10)
 by MN2PR12MB4485.namprd12.prod.outlook.com (2603:10b6:208:269::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29; Mon, 15 Jul
 2024 15:19:10 +0000
Received: from PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39]) by PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39%4]) with mapi id 15.20.7762.027; Mon, 15 Jul 2024
 15:19:09 +0000
Message-ID: <3308dd7c-fc74-440a-875a-6568f57e8b89@amd.com>
Date: Mon, 15 Jul 2024 20:48:55 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] x86/cpu: Add Bus Lock Detect support for AMD
To: Tom Lendacky <thomas.lendacky@amd.com>, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 seanjc@google.com, pbonzini@redhat.com
Cc: hpa@zytor.com, rmk+kernel@armlinux.org.uk, peterz@infradead.org,
 james.morse@arm.com, lukas.bulwahn@gmail.com, arjan@linux.intel.com,
 j.granados@samsung.com, sibs@chinatelecom.cn, nik.borisov@suse.com,
 michael.roth@amd.com, nikunj.dadhania@amd.com, babu.moger@amd.com,
 x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 santosh.shukla@amd.com, ananth.narayan@amd.com, sandipan.das@amd.com,
 manali.shukla@amd.com, jmattson@google.com,
 Ravi Bangoria <ravi.bangoria@amd.com>
References: <20240712093943.1288-1-ravi.bangoria@amd.com>
 <7d4531d9-3a61-ecf2-5a43-2cc03f013a62@amd.com>
Content-Language: en-US
From: Ravi Bangoria <ravi.bangoria@amd.com>
In-Reply-To: <7d4531d9-3a61-ecf2-5a43-2cc03f013a62@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0098.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:27::13) To PH7PR12MB6588.namprd12.prod.outlook.com
 (2603:10b6:510:210::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB6588:EE_|MN2PR12MB4485:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d6020cd-b322-41dd-78eb-08dca4e179c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NTNOS3kxQVg4VXVLcVN1bytKQ2JOZ3Fwd1JkZWFONlJUVzc5K2tmbDJRZDhr?=
 =?utf-8?B?OHptQnIzbFo2MHBCT1hBVFZ1Q0orNHpiTDBLZFlSYitmL3Vxc2JNVEp3S24w?=
 =?utf-8?B?bGExaXZDK0xOcnF6ek1BdVhEL2RJUll3NlQ5a1l1Nlk5dzZDRDRBMitzNkFI?=
 =?utf-8?B?b3Y4bWY2MUhoYlhVd1Q1UEhtc3ZCbmVPdmJsTHhETWhObDUrbTZvSGQ5eHM1?=
 =?utf-8?B?VGFpdkhaQ1BzYlB2aTFQeEhJY2dTZWFxdEhMaHZod3ZlK0RxdjNpY1hDYjBM?=
 =?utf-8?B?Y0I4RFluV3BvbmJOdWt0c09GcjR4UURlL2RSQ01veG85WFk0L1ZoOVByanN2?=
 =?utf-8?B?b3dQVzkwVWVBemVISXdtZHFENWYrem5TZ0Y2WTZjc2NOYnA2UmxWR0psQ1Ji?=
 =?utf-8?B?bXpVMkh6bEpaeGYrMVRBZG5uQ1RRZ3YrUjUxbEhuUmpGT2hMOG8wb3ZYTjZm?=
 =?utf-8?B?UEd0ck9za0ZubjFORkZ1VGhmSTExTVBtdzNONEEweUQ0bWlaVmZrU3hKcGht?=
 =?utf-8?B?RmVWQ3RpTEJaWFVzWHNTbHZkV2RQWEJDbmhENGVPUFdvckVSTTBvcDBSMFYr?=
 =?utf-8?B?K1dWRVlvTmZFN0hNYjFDdnUrZDU0aHpnaDh0RDVrMUsxSzMrYVR0aUlwWllJ?=
 =?utf-8?B?REJUOWYySVBWOXg5M0JGN3JHbW5xZ01nUlFKSmM0ZjlhNUNxNUZudldOcGE4?=
 =?utf-8?B?dDF4elBUNUN0UURESnpUblhTWW1TeFZOQmNrRHJvQUd3ak1TZDcrSklJVWNX?=
 =?utf-8?B?Umc0cnhVdENGeDlRMTZuM1Y1Y0trUHZWRGRHSXdBWXd4SDlWeXVsb2Vtc3ZO?=
 =?utf-8?B?eUpQeSs1a3hYNDN0MFpTaEMxT2xWNTR2Y1JrV0cweDc0Y3FzYkV5aEkzQWpr?=
 =?utf-8?B?U3RQTjliUzNZMzNmbFVoalNyRDZPeS9RZlg4MEY4Qmh1WXNtVERpUjJOaEdp?=
 =?utf-8?B?WkN5NDBDcVFscW5nSk5QVWFSa2M3SnVwQ2xMSDdHVUtRU1Z3eVM5UTN5dTd6?=
 =?utf-8?B?RzFnRDRIbzNqbHpJcnhNajVSa3JEOVVrZDhocUh4dDN1WTB5WmFUV2J3Y1pI?=
 =?utf-8?B?R0RLYXExSGo4WnhQeDQrazROckJGdUE1NTlIbEErMmpweGRwOGtoR2lLWVlQ?=
 =?utf-8?B?SFNSWURvZ05RMXFDL0ZzSE5lUWtpU1NNRmJlbnpnVENjTkxkMzZqNkhmandD?=
 =?utf-8?B?UGp0Y0V0dlFjRmhFSTc2MHYrZXIxWVl4NjEvZ0FEK1pXVXRZaDVYZFAwU2dV?=
 =?utf-8?B?bzFXdkQyamZpRy9SNjZSQ1FsS3U4RkUyMU8valZ4YW9KcVV3UmhoSS85N2ho?=
 =?utf-8?B?bHFGVHF6UXg2aTJJekhtRHArY2xSS3pCY1dnNExURHYzM2lKem0zS042VmRj?=
 =?utf-8?B?U2VHekJVa2gva3BJRDc3STFrSFFUS0JVMkUxNGtaeW9STFAwaWcrOHZrUGFN?=
 =?utf-8?B?eTRIVjIrRWE2Q0dZam0wZEh2S1V4emdQbU9qdHFKdlZ0UnE1NXdpUUMwZStS?=
 =?utf-8?B?LzNNa3N3WkRKRFdVaXhGSEZDbkZrazl3cTNjZ3k0UXRBTGFSek15U0J6ZDQv?=
 =?utf-8?B?dTZFMXZVUEVESlJVTmVrSkZ2bGJPVE4ybmMyUE9SUnNjdy9tNVVabnAzcUdT?=
 =?utf-8?B?NGJKQ0lncmp6NWZYc1lneXVNZWFqZmtFS1lpWmdGQnFBclRCNnN3dXBjWHhi?=
 =?utf-8?B?QkFlWXhyOXN4c3ZtWXVDUDFDWmwydkk0NHNMbHlTYzZnQ0Rocnd6eHlJYjBD?=
 =?utf-8?B?WW1HRXNXZmw2NnJDREg0R0JOVTQxOE0vRkpQZlBJUHVtVmNJY09JcU5KYWdW?=
 =?utf-8?B?a0VLaytNczlRSUpNWVE3Zz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB6588.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cnpneFhxa2tJUnFKbkdMQ2xlUCtBWUxtcE80MW8ybXdVRis3MWwwakZ3bFQy?=
 =?utf-8?B?VEk4bVpHZU9RczBhTUVtYVFTenkwY2FZSTc3RFJqSWtOODBVSUx6SjdrNWlk?=
 =?utf-8?B?L3RNR2VwTDcrK2NKYmdqcEs0Y0tvNE5rdTRoNkVyeVFIMmVhMUJpangvVWND?=
 =?utf-8?B?MmpYbFNxZmU5Y3REdzlGWjV1K1FqMC9iUmdEdGZiNTZDTHlVc3pId3VYVU9O?=
 =?utf-8?B?Zno3VDluQUd1dHdhSUc2T25lKyt6QVBzRk9Ud3BQU2lTSERsMFhHbTFCQ2h0?=
 =?utf-8?B?enRpZnNvQlNZak1sUVpscFQwRkYrQ0VMWGVnTk1ybmJXOWN1YzNmODFTc0NQ?=
 =?utf-8?B?VllsNzRGZFBWWE02MzFsTW5CR0RZc3RIK3lrSVVOSXFZVXMxa05pUlArT3I2?=
 =?utf-8?B?Z1B0VGM2a3BlYUZxL1o0aWpicmtTOW1KZFJ2N0I3clRCYzZBbGpLMm40eU1T?=
 =?utf-8?B?WHp1dFd3MnFveEpzSC9sNjdIaFdPQlpKbmxVRmgvR1IzejA1S0lOZ24veTBC?=
 =?utf-8?B?TmNQc0dsYktYSHpmWVozM2lnUHFOZXhjYUNWdUF2REVRQmRYRmJ3RTMrRW5Z?=
 =?utf-8?B?SXJsMTIrMHJETGZaNWgzWk51am93cU04ajF3UzhLS1kxQXA2blIrM0Vmajh2?=
 =?utf-8?B?QjcrdzZlUGc2WTFtMEZhZTcvWVBoUUFuZm9YL3I3Rnp4VGhsckJMa280M3pk?=
 =?utf-8?B?VTFlUTlTU0VTRU1FS1M1TmtUTDY3bWhBcE5RMjFoUFlaUGNBZGM1cXhtaEVT?=
 =?utf-8?B?Y0NqNzE1MzM5Y0NqZ21GK2trdENxbHpGcmpmQ0QwWjlDQjRPQTQyYUtoMVEr?=
 =?utf-8?B?d2dIdzdiUTVLQ2x4UkpjWEZVb1pDeUdDWWdTNWVuZzI4bkVWZ0FuYVhnSlhJ?=
 =?utf-8?B?ZWdqWEZ1WG1udnUxR2MxcEFTT2VqNmNhclR5ZWYzcW5zd1p2cDduN3ZvRDZM?=
 =?utf-8?B?aXlSaG9GSG9HbVVEck90K2NsaGR6cXM4U2ZZZ0xDZ1BBQnBiWW5aWlJiSm8v?=
 =?utf-8?B?dDVsT0hyUFFZQm5BZ3BMQjJmREt1UzRmSE5aSzl0aFNvVVo1cFRaM3E3cGpz?=
 =?utf-8?B?ZGlZcWF0REw0KzVsc04wcjFnSVJlRnVMY25RZDlyNkNYK1VNSVc1SmJicG5a?=
 =?utf-8?B?SUZEbm4rS1Fyek5ybE0rRUMrcHJ5QWdHY3ZOTlpUSTlUaVBwd21MSExTWk0v?=
 =?utf-8?B?YmdlamJwK2Q3a2FGa2NGQkRUekkrTjBtOGFCQXk4dXBsTDBRc3QyLzBUMkFk?=
 =?utf-8?B?MnlONy9RNVFFMlBEdzFJSCtmZWxZaElQN1V0eXpTQXFKTExIUUJlRzJFKzl2?=
 =?utf-8?B?dGVkazArZEM4dzd0YmFOOXhDWU9yTXhUVWJUMWZzdWYrRGt4aXdtMDhmV3Bi?=
 =?utf-8?B?OHVYcU9qSjY0eVNiUVZjZ3IxaWNaeFl0WlhmTE9BNUpYcDRFMlUzQlhncHMv?=
 =?utf-8?B?VklYZHI0MStjMjYyZTVsMHk5amM0Ni9TTnc5VzVEUG5VYUxvcW5wVjhyREY4?=
 =?utf-8?B?b25rQldKbEp2eHRSWTh6d29JVHZsNUJldzd3bEhvalRGdWRjcVNoY05qM21T?=
 =?utf-8?B?bEtPb0NETkpYTUZxbHZkYWZmRC9XY09yWnZncHZlNmxwS3BWbkxwb09xT28w?=
 =?utf-8?B?L2JienZzMkZoSkNVbkw3VXdBYzhJbzlzYWdJNjlEUU5hTDZoSTJZN245Tndp?=
 =?utf-8?B?NU1XWUt1NTRKdVFzQXdlQ09MNjY1aUpoRStDRFFLSGVsOUIxWVU1K1l5UnFo?=
 =?utf-8?B?U1RGcGxHcWxKS3Z0NFRnUHhWZVJpc3FyUmZCa3piUnJOdlpEUlJDMDBHa2gw?=
 =?utf-8?B?YjVrSzBFZnorMy9WeldGRjIrZnRMWEQ5Y1M2a3NXTXlGb1pDZnVEdmY1WkhZ?=
 =?utf-8?B?SVcxU2huSWk2dlpVQ2U3VEtMRnBLbnNNZXR3bmpRUURGZEhXelZNVitYMy96?=
 =?utf-8?B?VDJqalpJbjJJN0dVcXVnazlUNGRMVHRkZXQySUswWkdWTmZ1RU8rUW1mRVF1?=
 =?utf-8?B?MmVXQVo3eUczenRxYWNMQXdTdjhQVjFhdFFwYWJaTW1RNjlUeG84WmtxU2JY?=
 =?utf-8?B?SnZNdCs1VmtTZzhzTUdQVE5ZdlBHRkE5Nnp2SnI2UWpHVy9EYjRZT0o0ekcz?=
 =?utf-8?Q?75oHVtYFWzvpDY0bjA317UOAf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d6020cd-b322-41dd-78eb-08dca4e179c4
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB6588.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2024 15:19:09.8698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 44bZry+8GlGRcRZXU+2Swo066cFMSYBmQrQJ+79GDEDgOZcXXnJ24eBruUjdLiHXyPrRXE9soG5gt6g7SimqPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4485

On 15-Jul-24 8:41 PM, Tom Lendacky wrote:
> On 7/12/24 04:39, Ravi Bangoria wrote:
>> Upcoming AMD uarch will support Bus Lock Detect (called Bus Lock Trap
> 
> Saying "Upcoming AMD uarch" is ok in the cover letter, but in a commit
> message it doesn't mean a lot when viewed a few years from now. I would
> just word it as, depending on the context, something like "AMD
> processors that support Bus Lock Detect ..." or "AMD processors support
> Bus Lock Detect ...".
> 
> Since it looks like a v2 will be needed to address the kernel test robot
> issues, maybe re-work your commit messages.

Makes sense. Will reword it in v3.

Thanks,
Ravi

