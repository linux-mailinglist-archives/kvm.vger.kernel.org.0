Return-Path: <kvm+bounces-37731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 267F0A2FAD7
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 21:41:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C7CC188456B
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 20:41:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 443B926460D;
	Mon, 10 Feb 2025 20:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UE9S8NZB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2081.outbound.protection.outlook.com [40.107.243.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB267264602
	for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 20:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739220093; cv=fail; b=OU3SToNsl1xC2jobWbTfkQEazxFfGxbm8MVMcXMAuqxvsDBb+OtMt1eTZN6EmaO2crNz0B7wymq6rPK7/FT8YHa/yflBaOKd28OxKNmokWU5dT5iITqnSCdwRTpYVz2e9z+89TuZk+gid0l1u8duj3JMIVz62Nd9q/EnYeyTy10=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739220093; c=relaxed/simple;
	bh=vbu9+HlbycLDYdnpAW+419zkq29RwAlPklphADUxjbM=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=m2MejSjfDLrj2sxpCxpP9NT/8v46qiMSY+mkhQhdRivsp5PRjIkORKqnRJWLPtF6UAOtn2CLSRzSD0fPyKsOmrp/hfFtbMuYqCXE0th1CwGbXv2unbmDjVwDfPcLD8kOVnftIyTKaA4z26Mf5LKX353ZlHBLFhr331n+u0MKNcs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UE9S8NZB; arc=fail smtp.client-ip=40.107.243.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xmx7KsGaOnCWcNSNOM2tuEicMM6gNiWUU9z+Ip4fX/YHtOX7pzHr0m8yOfo0C+as02fJ6krW5YdKFBs2M7icGgqCia9Y9ZTkIt7WsTdvu2AhraNUREf4VcWBAft35+5mqA1QNbLe/F+5CRdzX6ihFLFIQeERthUquBrVJKHNEcBCJMWv8atAREosF9Xg7D41MecIuvzMveU36N1CbXg1ra+vQeOnu9UZJGGXv79B6OXS+BZ6fwCbPMBAYOTsmCo2A0/YiZEIG1mbzfnZKbSVOrWyPFTG04iE6R10U6/syfU1aOiO77D3YXcvYHQIdZ/gegKZSc0FEwF2MOc/T/i8AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xZtijXF3xVIO61scyuDrqsiVriJZEJo8CVgL7UXn+y8=;
 b=rQ1apFkVEUePV01cxtQMYQF5q4zKJk0cktjl1FuVtfJGJ846/2H0HLIgsE5Q7X6ZigHgv1VbNBc+liinJSlADwkosQp1hfFpXtO64B6lOivXFAyf5m7uAahNMQiflEkw47jR3VSj+1D7F5otnRkKiHouvGxY+tdGEnlovOufQPqPrqSpqHgcvIbFsYLCxRVoRqKYcWYV7nzZCnHkJe8j75Yk2LGCS29bgsjMU+IUsAScwFZdakNUZLBxz4LXqNEr/9I6FWv5bFAEvHOZXxuDqVSXau/HVRZdsGcTv+nWhD7VgQGzv9XkqYVsU6rLY6YHfWxQrtmfA48SF1Zg3C2AoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZtijXF3xVIO61scyuDrqsiVriJZEJo8CVgL7UXn+y8=;
 b=UE9S8NZBo4lZYbDBiV6Yhvr7bxSbiBUSmhnVNlr/1S8KH3CXXmL6RfjhzpnLv0gji0F8SjVXuvdvU9IGlmQNHKExdl1ztp0k5rg9D4/YN7tFn7PFzoZPDcyUIatM2fkfzJS/wlpFqPjH0lYQpXP06xyxmErfr5rWRkwHpYpbB4E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CY8PR12MB7195.namprd12.prod.outlook.com (2603:10b6:930:59::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.19; Mon, 10 Feb
 2025 20:41:29 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8422.015; Mon, 10 Feb 2025
 20:41:29 +0000
Message-ID: <03146f82-61b2-3415-c63a-2d5ae582e452@amd.com>
Date: Mon, 10 Feb 2025 14:41:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: santosh.shukla@amd.com, bp@alien8.de, ketanch@iitk.ac.in,
 isaku.yamahata@intel.com
References: <20250210092230.151034-1-nikunj@amd.com>
 <20250210092230.151034-5-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 4/4] KVM: SVM: Enable Secure TSC for SNP guests
In-Reply-To: <20250210092230.151034-5-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0069.namprd11.prod.outlook.com
 (2603:10b6:806:d2::14) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CY8PR12MB7195:EE_
X-MS-Office365-Filtering-Correlation-Id: a316142e-d031-440f-5252-08dd4a134b7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UllqYjJOOGw1aVlwSGUxZUxIUEJzSXBzY1pKaWlYZ25vazdWbWxJaGY3eThU?=
 =?utf-8?B?bzllaUMrYURvYzRjWHc1TmE1UVlmQU1IU3pFNDlnNVRrZWZ6OHl6aW4xWWRV?=
 =?utf-8?B?dHRVVXpmaDdpRXpwUFpndmZJTVMxRE1mRElmbmlmQ25wVURVSkZacjBULzVD?=
 =?utf-8?B?K1BvMEROcmJaT2R5bmhiTFFHRUdVMEtveVluZFVQOEFrakZ0U3dPUkRjazlm?=
 =?utf-8?B?NmVnRjZZU3RmZjc1Z3puM1F2dElnRnZvWUZ6cDd6c1RlVFBaa0tqLzI5dnBE?=
 =?utf-8?B?THVvNG1kcmdWekRVNkg0N0k2YVJyK0crY1dwN2cvOTlNQ0UzMzhLa2paOUxz?=
 =?utf-8?B?Z2l5a0pTR0JFZ0JVUDY0Y0J4bzlxeG1ua0RmMDBPK01JeU5ieHhzTVoxei9x?=
 =?utf-8?B?L05TL2FNV05wSmJxblFKQXE0eXh6RFU5a1dkRHZhR1diWm4vc1ptNG5oL2I3?=
 =?utf-8?B?aXM5MDl1NEh6MFVta1NQYjlxc2VuS09pbGpLQk9XT3o2MWRkME9Ta0FlS2hh?=
 =?utf-8?B?V2ZCQnlwdTRpVWpRVjBMNmNqMDh3Z3NJckNSUlBQcU4vRGVkM3pUT05JNWNs?=
 =?utf-8?B?TkYwZmovOTI2RnNUekYrR0MrOG1VWTNDUG9BeEpEdWw4dDZycExUMnZYZzBL?=
 =?utf-8?B?bTN5eG1FQmhGTUNXeXUzZXFqL25jWFJqblk5YTNBRlBtb1pOaUpseEpyZFVq?=
 =?utf-8?B?aE5ZRDJLQTczdXBsS1F2TUl3bytBYVZOMFB0QmkwOW9ta3ZTMWpMNk5uSnA1?=
 =?utf-8?B?SXdXdlVjc1lvaUlHTnBwTnZYcEZrUnZQZy8vcXUvYkVoL2FhWGM5ZUNDNFhy?=
 =?utf-8?B?YlRVR3FUUkRMcHRYek1GSmJ6bDFaaW1zbGY0a1dJOXVjUkZUalJNN1dMdmxa?=
 =?utf-8?B?dEpxVXE2TnpCRk44SmlzMlNBVkJiTFc3YWJIK3ZjVnhybldnZXJyTlZ1akFK?=
 =?utf-8?B?bTNlbCtLbGI2MCs5MVVaaWJNc010a0FtTzNTT01NNXZMeVBpbjl6QTROK0hB?=
 =?utf-8?B?aTc1dVp2bG1lVUplSDNoVXhDMWt3bHVMWjBvbkJGZkVIeHNFSTBybUVwckJ6?=
 =?utf-8?B?VUMzRmF5RUNBOTVpSUZVV2tvUmNUWk90RFpEOUNvMTY0cFhoNW5uL2Q4U081?=
 =?utf-8?B?VjBZS3ZvTTJGUnI4THNzU0RUb3p2NGtwOUxUVGRKZndKbk9QN2lhNTc1Y2hP?=
 =?utf-8?B?eU1Vd29YNDZJMEtKbVhQS2tJN2NKWGVISjF5cG1Bc1NuOEEvdURmb21kdU9O?=
 =?utf-8?B?MW41Z2g2aXJkUVl1U0ptRjRzQzdCOUxVNlU2WEdxLzJPeTFiVkZsTGpNdHpN?=
 =?utf-8?B?VVE3bHl6ZDdMS3Nna2UzT1JFU0R0RVEvcjQwM1JyZ1JjMkJHcWVlQXF0eXZh?=
 =?utf-8?B?T2w1RnJVZTV2YjRialc5YlBLNGRDZzFYYWlHQ0tSRTlVZDM0NC9qUmt3cm42?=
 =?utf-8?B?bHZ1dGlZeWo0SEY0VFBrM3lPc3QrWG5wS01ReFo3blVzTFRQWFlwenI1amxv?=
 =?utf-8?B?OUk5RHZKSVgzRzdlcjFvQ0xBS05CbmdkU1JVS0RLdm9lb1JUNFMxK0NTTnNz?=
 =?utf-8?B?ZStwK1lWQ0JjNkRJTWhOdVhXbHJ0OEQzR2VoN1FDbWJ3Nzd3K2Z2UEdqN1Zu?=
 =?utf-8?B?QkR5dDhSU0hDUk0vNU9sMksrSkJpZDkycTZSWFRIQzZCRXVkUXNYMjhmcTBS?=
 =?utf-8?B?N3hRMnF5T2hldkJpVEk5N2crM2xmUjdJWm1CeTlJcVJoK0EyYXFOczY5dWg2?=
 =?utf-8?B?Y3R1aUVNT3VMRUJQcVFzSVFPMVRBMTlCeU5odnRyaitrbDNLQTlOWGtXMmpk?=
 =?utf-8?B?NG1EbkpyRmlHeEExZnRWRGNwZGZhak5vV0tpRUw3bHhCTjArMnI1RXBQK2RW?=
 =?utf-8?Q?RQk22aIksEQBE?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SEd6ekJHdTk5aitDNWV5dDRJTHpiQmJqT05XSjl6QktKR3BjSCtRT01NNWts?=
 =?utf-8?B?UGlZOHkxU3hFUE1jcUtmWTZJSXU5RFVtUmFrUThhQkxGanA3Nk43MjRiaDFt?=
 =?utf-8?B?QkRuSlhEZ0ZuTS8rczdSNVlxYTBiMDQwcUJ5RVB0a1FJdjBhMlZaTmVqODlp?=
 =?utf-8?B?NUhpYnNHUGIrUy9YYmRvU0JaTUVPOGRHUHRQNTRvRjA1TnZ3UHFrN3ZidWE0?=
 =?utf-8?B?QldjWGxHWjFBUTRZbnFNWUQxZHRmWnFkYjhKNWl6dGtJdlBWdTAwTTM1VFFN?=
 =?utf-8?B?cm8xaU1hU0JvcEdmS1daUlZlODFma080OHE2S0w5OGw2UVZZVHhMUEd3MkVV?=
 =?utf-8?B?NDhQNzc5aWpGazgwRkdRNklhZVZPcUJjZmpCMnJNUVY1NG5FY21hOFhoSTFm?=
 =?utf-8?B?UDJzSzBHOEh4TVc2eEhqNXc4THNkeDAwQmM2Sk1PV2pUNmcwMTR3ajNqU1NN?=
 =?utf-8?B?QVhFR0dxZTNPVFJvaVVHd0RVWFVaMXZFVFpCMEhHTlZUaU9uNTlKTVQ0aHl6?=
 =?utf-8?B?QWtobG1OY1lXZXQvQ3RNUW5WVEhIRmFONExvTTJOeGF0bDBUM0RVamRDQngz?=
 =?utf-8?B?SHJFblNPL202QWttcVBuMy9kMlNkSCt4djdrRzRDSTRGSVozRGJFSkFuczVU?=
 =?utf-8?B?dXdHV2VnazVEQzd0U3FWbWJHaHYxN1AxbUlocW1adTFDM29mSmhYbjAxUkJH?=
 =?utf-8?B?bGpYdHI5N1VBK3hqNGZvajV5WVFMZ3ZLQlhCbFEzajZUSjNCWCtwU045VEIv?=
 =?utf-8?B?ZC9ORmJUdTZ5Tkx3ejdiemdzN0I0OE84c2FiY1QrVlpiL2dYUWw2NWZMMXhh?=
 =?utf-8?B?bTRpMnpzRXdVRkI1MGxjenBhZEc0di9Vd3JkME9VSWRpVEVwVEFmOVB1aTN6?=
 =?utf-8?B?bmtPZGltVkcyd0VaT21ydTMrTS84aXBZVGphcXAvQ0w5WVBFbkxQWTFTUG9C?=
 =?utf-8?B?R2l4K1poT3pVZ24vbEJnR0JYamVNemw3OW9QRmorRVhCSEtNUlFqWXR1bEFo?=
 =?utf-8?B?dXRzeDA0WTRUZHJwSDdEVmwrRzkzL1ZCNmx0UWVWaXZvRlJYaGVybG4yYmwr?=
 =?utf-8?B?aG9uNGVHYmppQzk1VkdiVXpNQnlSY1UxSFJjNTVSWXpodEp0UnVVZFJ1dmpE?=
 =?utf-8?B?MDdicnZocHZiSlV3My92UzFSUzZ0MTFJejlZZmNhaVNDSksyanRoQ3RlaFdQ?=
 =?utf-8?B?cHduOEo5VU43Z1F5ZmFGYkRFcUk4RllSbXFzbTBSUDJUaEZOOHNsZE1TMGdQ?=
 =?utf-8?B?NGRTYmFtL3FZQnlDNjFtUkFSVWM2WjhtbmtaWlI5aks0WW94eTBzcnlQb1Rr?=
 =?utf-8?B?Y1hCVWwrcEExcytCVjE4a0EraFZJU3pSYXBERE91YythdW96dTNBdTdrbi95?=
 =?utf-8?B?NEI3VjRkd1dsSS9PYU44VGU5WDVjNm9nMzhDTVhpbW9PMktLWitDYzlHeFVJ?=
 =?utf-8?B?MXB6ZE45RUZ6WGZKWXJTYWVxYnFqckdHVnNqSkVISnRMNjFhTFBUOVRFbVFW?=
 =?utf-8?B?VmhvRU5FRjY2L3VrQUVoc0FmT1dCMU9BU3lxbnZ5MFdtbW1Wa2dRbTFyZkk2?=
 =?utf-8?B?UVkrSDZtK3hzc1JJcDVDakRtV0I2MTdYNHFXamxlRWZVeUtrQnNHd0RWYkI4?=
 =?utf-8?B?THNZWStlemRNenNXRDJrbkZCTUN1eTFNM3ltR3VjVXBveWdpZS9BKzd1VHR4?=
 =?utf-8?B?OGlUWU5ybUNTUjhDcTV3bmFmWXJ2d1dwUEcvaXdTaDZRQTdUZjA2ME1lMGVY?=
 =?utf-8?B?WTNkNGpJcVZ5cXUwbmdSSG00ZGJjaEhHNjY5L2J4dVpqdUFvVFRqelVVWjVn?=
 =?utf-8?B?ZnF5TUxISnFJNm5YV2dXdjVkNDBiQXF5TlVubEppL3Ftc3NKSkdkSnVJbmhh?=
 =?utf-8?B?OXpUQWZFOWsxN3V3UFI2MDRUYTdYcTF6Q3Rud1pKbUUwa1lraS9xVnVWeEpZ?=
 =?utf-8?B?cDBWV0xxbEcvNWU5cnJLamUrMmJVVUpEU2NwRUVyN1daSkdpQWU4bHc5MXdX?=
 =?utf-8?B?WkxlTDAzZTVERTFXTHlWR0ZsY0VEd1duOW5LSWdINEZJUXpZeDE4OTlDTy9s?=
 =?utf-8?B?TVpIZEFGOTdsWG40OTVKU2EyR2FzUjNFaHJQcEZvK0dHb09KWW5DU0lkQlZu?=
 =?utf-8?Q?7TBc74ZMBj4po7t8TavuUnir6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a316142e-d031-440f-5252-08dd4a134b7d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2025 20:41:28.9363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IgE4IZNWwjDinVarhmwpZqcTcqPvUG8tySI1RNZSl+pmGTgGIbGTm1rQT5xsYe4BRYYVCtpBGXI41+fJqYR/hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7195

On 2/10/25 03:22, Nikunj A Dadhania wrote:
> From: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
> 
> Add support for Secure TSC, allowing userspace to configure the Secure TSC
> feature for SNP guests. Use the SNP specification's desired TSC frequency
> parameter during the SNP_LAUNCH_START command to set the mean TSC
> frequency in KHz for Secure TSC enabled guests. If the frequency is not
> specified by the VMM, default to tsc_khz.
> 
> Signed-off-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
> Co-developed-by: Nikunj A Dadhania <nikunj@amd.com>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  arch/x86/include/uapi/asm/kvm.h |  3 ++-
>  arch/x86/kvm/svm/sev.c          | 20 ++++++++++++++++++++
>  include/linux/psp-sev.h         |  2 ++
>  3 files changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 9e75da97bce0..8e090cab9aa0 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -836,7 +836,8 @@ struct kvm_sev_snp_launch_start {
>  	__u64 policy;
>  	__u8 gosvw[16];
>  	__u16 flags;
> -	__u8 pad0[6];
> +	__u32 desired_tsc_khz;

This will put the __u32 field misaligned in the struct. You should
probably move the now 2-byte pad0 field to before the desired_tsc_khz field.

> +	__u8 pad0[2];
>  	__u64 pad1[4];
>  };
>  
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 0a1fd5c034e2..0edd473749f7 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2228,6 +2228,20 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  
>  	start.gctx_paddr = __psp_pa(sev->snp_context);
>  	start.policy = params.policy;
> +
> +	if (snp_secure_tsc_enabled(kvm)) {
> +		u32 user_tsc_khz = params.desired_tsc_khz;
> +
> +		/* Use tsc_khz if the VMM has not provided the TSC frequency */
> +		if (!user_tsc_khz)
> +			user_tsc_khz = tsc_khz;
> +
> +		start.desired_tsc_khz = user_tsc_khz;
> +
> +		/* Set the arch default TSC for the VM*/
> +		kvm->arch.default_tsc_khz = user_tsc_khz;
> +	}
> +
>  	memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
>  	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_START, &start, &argp->error);
>  	if (rc) {
> @@ -2949,6 +2963,9 @@ void __init sev_set_cpu_caps(void)
>  	if (sev_snp_enabled) {
>  		kvm_cpu_cap_set(X86_FEATURE_SEV_SNP);
>  		kvm_caps.supported_vm_types |= BIT(KVM_X86_SNP_VM);
> +
> +		if (cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
> +			kvm_cpu_cap_set(X86_FEATURE_SNP_SECURE_TSC);
>  	}
>  }
>  
> @@ -3071,6 +3088,9 @@ void __init sev_hardware_setup(void)
>  	sev_supported_vmsa_features = 0;
>  	if (sev_es_debug_swap_enabled)
>  		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
> +
> +	if (sev_snp_enabled && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
> +		sev_supported_vmsa_features |= SVM_SEV_FEAT_SECURE_TSC;
>  }
>  
>  void sev_hardware_unsetup(void)
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 903ddfea8585..613a8209bed2 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -594,6 +594,7 @@ struct sev_data_snp_addr {
>   * @imi_en: launch flow is launching an IMI (Incoming Migration Image) for the
>   *          purpose of guest-assisted migration.
>   * @rsvd: reserved
> + * @desired_tsc_khz: hypervisor desired mean TSC freq in kHz of the guest
>   * @gosvw: guest OS-visible workarounds, as defined by hypervisor
>   */
>  struct sev_data_snp_launch_start {
> @@ -603,6 +604,7 @@ struct sev_data_snp_launch_start {
>  	u32 ma_en:1;				/* In */
>  	u32 imi_en:1;				/* In */
>  	u32 rsvd:30;
> +	u32 desired_tsc_khz;			/* In */

Shouldn't there be a separate fix for this before this patch? The
desired_tsc_freq should have been here all along, so before this patch,
the gosvw field is off by 4 bytes with sev_data_snp_launch_start not
being large enough compared to what the firmware is accessing, right?

Thanks,
Tom

>  	u8 gosvw[16];				/* In */
>  } __packed;
>  

