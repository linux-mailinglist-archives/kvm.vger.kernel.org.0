Return-Path: <kvm+bounces-18517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C55A8D5E10
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 11:20:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ADCD71F27309
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 09:20:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35095770EE;
	Fri, 31 May 2024 09:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VX5iQX6S"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2071.outbound.protection.outlook.com [40.107.94.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBAB17C6EB;
	Fri, 31 May 2024 09:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717147201; cv=fail; b=bHHEPhZRV5FPuH3PyHPaX89LarlTMONSL+JE+boZjUfhf7XTVxpQYSA/7N8uM9G4ZrLFYkJubOyFeb7nRKA8BtafBhY96EzAXmWnVSLRfBsuG+yCDEQbVUUcgjrd1fXQKUXi7v/aKHQLd+xuYM+/lD8h6Y9y63YyeEeXaObIAwI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717147201; c=relaxed/simple;
	bh=FA7Cz3HJUKKNUgBgoL5o+WY0AvMUuZ8DbstZHgQi/lg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UZybspnZNY6yL+mf/2UDnAibVxe+R00+LNcsw9qiEamBQBDHmNjIKZ5+G3zzSZZEAg++FxJq/QRw6fhV4nwRRJwySFbzmQe0xxfZVR4th0qZaZzwpyX4LACPRyQ5HApgrIP3nDZkgPD4M4eBcS250hCaJiVA6TgnaRCg4bdKWPs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VX5iQX6S; arc=fail smtp.client-ip=40.107.94.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AxdC/ZnpaFmeT+lpZ2lPlRP31rBKGjSRtKj9T568X8CZ6s3w98fFleanpJdojcFdF8u83fHX4TN9fzza+PYMrQsmxV9+/7WCQ4BJzA/cscZUiPTYCYgJydBVv+/58D8hSzLeceTv1t59+cLKeWjUOkeLhwt8KniMvwvnq5BETnA5TO/MZhU1MGBkjCiOy95owgAc6wy2mLwqwVLIaTZ5afID3PEqWwCc/fIwNtLktZGH/L2CxKryaB3KnZM82es+uF76PDM37IyIEMTIElP4gkaH6HkIrLTKVWT4XSRvpS/eg/g0XsBMx+wRiHZZT/RboU6P3LROzWTVBK96MbSyfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k6BSNVY7eYr7f2bbC4F9sCb8xhUVJnHHl0hOFY4zweA=;
 b=UtGuMe6O3MnXklUAwci/ictyy+h/9uXnBmks7yKOa2Xi/G51Gz/MGoplRrFpwp7MJwXb6ckGqZyhBfE/Q+BlXhze7FEC9flY+EsGndnHMDWcSi8XNxWMkyb5z9SSDdFJ3XLsbThlNbLiKEoZC1VG3OF0LTiYpgl+PXWOClYVF7+cYINCeFmo4qYwU/6trz7CWxr2BN0tDBZu1xFMg0RG2Qts42rRa8UmYNeO1rpGYc1hHFxhMwmbxcuomTLE58O8/zNQ2Z7L9+e0rFVQBKC9GgRxYapkdWdfbzIltzOGOoTwAG3l7Xf4XwxdDdZZii2BeyyQGIKwPfhHcYFDQjn8sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k6BSNVY7eYr7f2bbC4F9sCb8xhUVJnHHl0hOFY4zweA=;
 b=VX5iQX6ST1XHt2cfvGQoprUqXHr+mfNn9AKh6t2J3CnwsEEJN/RFz84mT4eYlK0cqh7L9lpms3oZ2pwJATJI8fIHRXLz9b93aRiIdixoT6nMpl7yRs8ofnAL/0bVRu24OOl5rF1PRD+dQF9yhqn2dUAeFonSNel4o7t+8w6YdnI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 DS0PR12MB8341.namprd12.prod.outlook.com (2603:10b6:8:f8::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.22; Fri, 31 May 2024 09:19:57 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%6]) with mapi id 15.20.7633.018; Fri, 31 May 2024
 09:19:57 +0000
Message-ID: <ee3d218f-d90b-46f7-877d-4057ac84bb1b@amd.com>
Date: Fri, 31 May 2024 14:49:48 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] Export APICv-related state via binary stats interface
To: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
 suravee.suthikulpanit@amd.com, vashegde@amd.com, mlevitsk@redhat.com,
 joao.m.martins@oracle.com, boris.ostrovsky@oracle.com, mark.kanda@oracle.com
References: <20240429155738.990025-1-alejandro.j.jimenez@oracle.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <20240429155738.990025-1-alejandro.j.jimenez@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0022.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:97::23) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|DS0PR12MB8341:EE_
X-MS-Office365-Filtering-Correlation-Id: 669a92fd-fd3b-4291-7d9f-08dc8152d6fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZTNHMzVjOHhKTXdTRWZoMUxjVkJqWDZ1ZHl6Rm1yWTRKeWZrZ09UQmd4UFpm?=
 =?utf-8?B?VS9uZkpxS1BibHZQbGttcmVhODVqaXQ4bEJpVzJZZVZYQXU5WVVWSmQ4S2t1?=
 =?utf-8?B?Z3IrUHNYc3orSmF4UTFoUHljSXBFWG9DbDdxWWJnMXdyKzI5cDlTV0dqejd1?=
 =?utf-8?B?U2tvVHU5RG1nbW50eEg2bDNYTGZyK3hxUW5EWTBZQU9wU3BjbU9JWFFoaUw2?=
 =?utf-8?B?UXoxWjlOcHVQb09PNW1FWHdsd0NMUVdTdjM2R3I5aFJmUlN6di91MjBYVFF6?=
 =?utf-8?B?cStZRE81QXV6UVFBK25nVlRTZHFmYjE2clBlaFpGbVMxUXBQSUhtTnRMSU5x?=
 =?utf-8?B?NE0yajBzWUVaeDdjUHhPSk5Rb2lvYlpTbnJ2MjdMRnhEMnR5YWxYZXVYYkh0?=
 =?utf-8?B?TXU2aGZ2NnpTYmlSNzRneis2aldDWHZyS210UzdvOUFtcUtteXEzamVPS29w?=
 =?utf-8?B?R3ZuSGViYmhTSjhSUjhpRXBpYzN3OGpaa21TQW41NXRaamFwd3VRZEJ0akY3?=
 =?utf-8?B?bUhUWmQyMUVIcm5YQjNvVU1oWG5hYmlCT3U4OGVRN1NHS2d3S3FXY3Y4Ky8v?=
 =?utf-8?B?UXRpakxrRjI0T1dJVXZpREFzVGtLcHJvaFJZaG9XbjNZemdLQmpjVlE4ZmFa?=
 =?utf-8?B?dUlSbXgydTNrVkdlNXRVZ0h3azJqbHNIa25TaEZDdUF6ZU81NzhjblZtMFdY?=
 =?utf-8?B?OENRVUw2MVZ0WjdISWFwY1FPT0VZbUNHeWtOak0veGM5ZE0rS1hPc3hFTE9r?=
 =?utf-8?B?NDZUU2FOUUNMcjJ1MU5BQWhOYjJvWi9yaGVtM0xMUVBTdTNlZ3p2RVRXaUpU?=
 =?utf-8?B?cVBraVFLQjJIcFpLSmdoaEhVZ1hkSmtGT2dpSDRQbTVZUmlkVWJwMnJUQjJu?=
 =?utf-8?B?a2E2eSs1UW5mb2pqdURvUVFZUGVPNVhyRmRkUE1MdDRJRFZXQUp5ZEFEclpI?=
 =?utf-8?B?c3N4QS9jN2lhamR2NGV1VDJ4VVQxS0NZdGdFMjVSeFBESE5KZVNNT0V4RGg1?=
 =?utf-8?B?Vi85RUVPNXg4NWdReE5tRnlobkliN0oySFUxeUN0ZWVuTGhKQTJNWnRzdk9u?=
 =?utf-8?B?LzJDSWpkeHVZRlQ5Y21IdmVJc0ZTQmpTYjkvV29zMDFFSm9iOWZ6RXo0Q0dV?=
 =?utf-8?B?U2JyakdHc0VEZVVsanc5aXB5Y1VmVGxpZVNNc2FLdDRFUDNlMk5vbCt0U0Vi?=
 =?utf-8?B?ZUJHTG8rY1VBTHEwdHo1ZVJrcUtMZUdJUDA3a3N3MWxCUDdkaEo5M3NJWG1G?=
 =?utf-8?B?Q2VWZE4rUWNmLzU4NXMrMGNibGwxeGg4cDl6dUg2MVpteEZQcDBnanpOQ01m?=
 =?utf-8?B?Wk5qalh2dDZUNEJFV3ZhTUtnK1R3QjJvYkdhOVVNYzQzcnIzOHBwdnFTbFdQ?=
 =?utf-8?B?NHJnOWF1UmJRZFZla0xJUXBxZGZpU051ODZOSmhvZDRsbFArZTNzY2FXVWpW?=
 =?utf-8?B?cVJZdHA5RTcvSjhicVRET3VFRUNCYldZempVTjFFSVlISWxKZW03dVJaZ0pV?=
 =?utf-8?B?U05KQ01JYXlMckx5ZUNtVkk0UkZZSmpOcXVOajB2WWJsa3hWVzAxOGFtSzli?=
 =?utf-8?B?WXpab2tjdElvclZTRmtMWlM1UCtCd2N2UmU3NmdJaHByQk96S2hMeDU2Y2RI?=
 =?utf-8?Q?21xQ6zD3B1WVIISTFRbMYsOSkx2YSdM0gHn4thNLdvf8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MXNraFdzNmZiZEhleWRXRGI3YmNRd1IrWktWMTZlWU9GS3RuS0k4VUJWUlEy?=
 =?utf-8?B?YWdqQzFjTTJnd2UvS1FHdFFUUEpMQURTQmVvOGl6Q2FTUWVNQW9SNG5lK08x?=
 =?utf-8?B?ZW8xZnNKd1RzbzlzK054bkFkQ2UzQ2hOV3lSRW8zYm13MndITFRxMnZxMlQv?=
 =?utf-8?B?bi9rc2t0Vm4yM1BxVC9EMVBKbkhTQmozOUhvQ2QrTncyWjFReWxsWjhWZ1Bu?=
 =?utf-8?B?NWtndTRUVXhOaVJWNDJ3ZlJFWEJCRFlDOTRMb2pseTN5VVdtWjljMjd6QUYv?=
 =?utf-8?B?Rm8xcEZ4enZ2OE1Sc2N6TEdsNnRaeGp5aGFLemcxa1FwVDlSMjNkLzVvUnQ1?=
 =?utf-8?B?ZHBPbXprZzBaZndRMEQ2M3hvRFR6RGJDNzhVQllXUlVtNGwzaEpuRXc4Rk9T?=
 =?utf-8?B?cHZCYnp2Q2hIRFZhaGU2S1pmZTk5VXBlOEJmNjMwdDMybE1TWjkxT290Zktx?=
 =?utf-8?B?dGplOGdhUkRLajRsRXR2V3U4dHJHZEVGRm5tdW83MGlhcWJ1dzhCUlh0WGRG?=
 =?utf-8?B?UnFYSmdrRTNxQUQxaEJoWVhvVThsb054Q0FzZmxCZmI1YTg1eXYyT0VrdzQz?=
 =?utf-8?B?Tkt5dWZDY2wvcEZFQURFN1ZEWXNRaXFBeUsvZ3BYT2RHVE1GZ0Vyd3piWFQ1?=
 =?utf-8?B?Q091akc2eTVIRU1DZWFDRG1LeE1PZUJSWEEzQW9DcE9iOUxXZGZVc2puUVJr?=
 =?utf-8?B?QmVjZkFqVDZsRjFEeVNpQXN2VFcza1UyN0FVUUZoODZKb3BLNVRmdXlCOGtF?=
 =?utf-8?B?S3VpL3ZVTlZLanZjUkJMQnhtTDZnZitjQXlrdytpdjRBcUgycHoyZ0RBQlBy?=
 =?utf-8?B?MndVdGxHN2tEcVFMMVJ0K2lwZENkUWU3cUR5Qk9kTmJzSmxWSFA0cEViVitn?=
 =?utf-8?B?RDRrVEJOQ2pEaEVZeG9STXFaUUF1Uk5XeVl5c1AwQnZ6d1BwdUJ1QWJzbS9l?=
 =?utf-8?B?SW9KSWtSZlNqcGh5QjU3eHNJekFWVWRNWUdWUE9GU3NkbXVJZlVwQ0JSNmVr?=
 =?utf-8?B?bndaLy9UcEtPclNmdG9BdDZYeUVqcTRjS3dCNDZ6MjVQSzdhYUJPU2I2NVAv?=
 =?utf-8?B?N3RZbEhrMTIyTnBSMXFqS1dKYTdGZkR1YzZsSUhhYlhzUWVWeEN0eWc3THNM?=
 =?utf-8?B?UkQ2T0djN081ZUxNQTNsRU5Bd2FIdUNpZmZSOC9KWFFUWm5GV2dIRSsrWXkx?=
 =?utf-8?B?WDY0YUw0OWM5ckhTdGMvblBGZGlRY050TVZFOTA1WTRBMmI1Wm1RRjJEZFl4?=
 =?utf-8?B?ZXR0N09pRk4vbUROZjBpeTg5YkEwK2pZVlcvOVI3OW9jSEJCQWdmQWlDTUN6?=
 =?utf-8?B?VllOWk95d0ZtdURXNmpmcVBOSnVvRzlId2RqYzJKLzA4M3M1ZjRXVlZZYWRU?=
 =?utf-8?B?R2R2TmRKYm5EZEZXbjZlWUsxOXB6MFg4NVF3UXJKUW9MSFBFU1ZXMkEwajJZ?=
 =?utf-8?B?eEJDVTB4dVFwVzN4bDVwcUJYNWYvYjhkR1N4T00zTnZVL1dMc2NRb2ZnNjFi?=
 =?utf-8?B?eTU5K0x0YXJhNmhGaVlyaGRmZGsvR2RuR0VJNFdWTjNBb2EzaXFSK3E2dUFV?=
 =?utf-8?B?dHpTYThrQ1ZwZnNZVWVUZkIzbC8wUUJBT29EcDdIN1NzRFFHY0F4R1ZMMmRE?=
 =?utf-8?B?TEZFUjE3Sk0rVW9MYnovNFZZZExLcnoyOWJPeE9LVHcvbFhNU2pNWWZJSEUy?=
 =?utf-8?B?aGp6Y0hTQWx4VkE4dURqUlRXVkxUWUdNczdLUzdZejJDMXVFa0l2Q3lKMElN?=
 =?utf-8?B?Q1lkTTcxeWRza1FZY2NqeDZVeU8xQ0pjc3ZObVNzd29rMHk5MEN5NGdTNU50?=
 =?utf-8?B?UzZzMW1UT2pNWUJSdjhxSXNjRjBxQmgyK2lYdW11UFA4a1lHOFVMcXpHWUlw?=
 =?utf-8?B?QS9EY0hHcXl1TmMwTS9OUk55bTJ4Vi9BTmFsUmFWRkRzUmQyUU12YTU0MHlo?=
 =?utf-8?B?cFpnQVR0SG5oWVRIL3FRZnpRYTk3MEc1bnlhZG45U3ErL201UW0rOThYWGg1?=
 =?utf-8?B?S011cmN1VERGTlc1MjNRSVE3bU5kaHNmTEJUOWU2djYvVmtsY2NPaVRMcEpX?=
 =?utf-8?B?R05meUlVL2pzZWNvNG0zQVpEeHlJcldKZ0ZBOXp5MzRtSFN3cElWOXBpckZV?=
 =?utf-8?Q?SUbBDd4/gclzuwNzDCIo4o3FY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 669a92fd-fd3b-4291-7d9f-08dc8152d6fd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 09:19:57.7571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IX0j1LNzsTWsrWajASdhZbvnf/MArgaSVLU1l3yipcJyDQC5kpif0bMu69T3jl6wJ23f1uRqDFwBfw3Vl5RQNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8341

Hi,



On 4/29/2024 9:27 PM, Alejandro Jimenez wrote:
> After discussion in the RFC thread[0], the following items were identified as
> desirable to expose via the stats interface:
> 
> - APICv status: (apicv_enabled, boolean, per-vCPU)
> 
> - Guest using SynIC's AutoEOI: (synic_auto_eoi_used, boolean, per-VM)
> 
> - KVM PIT in reinject mode inhibits AVIC: (pit_reinject_mode, boolean, per-VM)
> 
> - APICv unaccelerated injections causing a vmexit (i.e. AVIC_INCOMPLETE_IPI,
>   AVIC_UNACCELERATED_ACCESS, APIC_WRITE): (apicv_unaccelerated_inj, counter,
>   per-vCPU)
> 
> Example retrieving the newly introduced stats for guest running on AMD Genoa
> host, with AVIC enabled:


I have reviewed generic and AMD driver related code. Also tested this series on
AMD systems and its working fine.

Tested-by: Vasant Hegde <vasant.hegde@amd.com>

-Vasant


> 
> (QEMU) query-stats target=vcpu vcpus=['/machine/unattached/device[0]'] providers=[{'provider':'kvm','names':['apicv_unaccelerated_inj','apicv_active']}]
> {
>     "return": [
>         {
>             "provider": "kvm",
>             "qom-path": "/machine/unattached/device[0]",
>             "stats": [
>                 {
>                     "name": "apicv_unaccelerated_inj",
>                     "value": 2561
>                 },
>                 {
>                     "name": "apicv_active",
>                     "value": true
>                 }
>             ]
>         }
>     ]
> }
> (QEMU) query-stats target=vm providers=[{'provider':'kvm','names':['pit_reinject_mode','synic_auto_eoi_used']}]
> {
>     "return": [
>         {
>             "provider": "kvm",
>             "stats": [
>                 {
>                     "name": "pit_reinject_mode",
>                     "value": false
>                 },
>                 {
>                     "name": "synic_auto_eoi_used",
>                     "value": false
>                 }
>             ]
>         }
>     ]
> }
> 
> Changes were also sanity tested on Intel Sapphire Rapids platform, with/without
> IPI virtualization.
> 
> Regards,
> Alejandro
> 
> [0] https://lore.kernel.org/all/20240215160136.1256084-1-alejandro.j.jimenez@oracle.com/
> 
> Alejandro Jimenez (4):
>   KVM: x86: Expose per-vCPU APICv status
>   KVM: x86: Add a VM stat exposing when SynIC AutoEOI is in use
>   KVM: x86: Add a VM stat exposing when KVM PIT is set to reinject mode
>   KVM: x86: Add vCPU stat for APICv interrupt injections causing #VMEXIT
> 
>  arch/x86/include/asm/kvm_host.h | 4 ++++
>  arch/x86/kvm/hyperv.c           | 2 ++
>  arch/x86/kvm/i8254.c            | 2 ++
>  arch/x86/kvm/lapic.c            | 1 +
>  arch/x86/kvm/svm/avic.c         | 7 +++++++
>  arch/x86/kvm/vmx/vmx.c          | 2 ++
>  arch/x86/kvm/x86.c              | 7 ++++++-
>  7 files changed, 24 insertions(+), 1 deletion(-)
> 
> 
> base-commit: 7b076c6a308ec5bce9fc96e2935443ed228b9148

