Return-Path: <kvm+bounces-15499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 942428ACD8C
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 14:56:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E9F22B20CD5
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 12:56:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6958C14F13A;
	Mon, 22 Apr 2024 12:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3M96B7S4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2079.outbound.protection.outlook.com [40.107.243.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892612AD19;
	Mon, 22 Apr 2024 12:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713790291; cv=fail; b=gcwgvjg6uOxpm19PZ6BhWBYUehXvJWCEUgb0KcCTdmspxNR7JO2mJb8s7Ei5cWHfpicR3pG9WL1mdvlIN6vZa/b6BlSPNVIqc2FsvvwvQ0G1MPRxW9KnkR38irYstQCSl2bkVagdHqsK83i6t/xFobxOR4l64bh+2U3QlIF5hBQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713790291; c=relaxed/simple;
	bh=0Y25s64d28u8ghE2/Yf1R6ngS8U7gUFsCE0K95qS17s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pjf+9IlUJCepQsF1LdE0uLzs/0OdJO8NYmEzXlU8LscnTCjWl79inyiN3zDWMWtVzemmOcf962hgvyMZIrcFSq2S5/Bf6pbtZhgqpsML815h/Dkv299y0XC0yWzZiQaoy3LcXjVpeVRzuD9oiTSMCu4yQYmhGRpDe67I3a2MqDc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3M96B7S4; arc=fail smtp.client-ip=40.107.243.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KP0UtciSD+WKowoQmmJV0nFZsxxIAcWkv+qvhuZ9HyzoszLVOW5zH9JsU9brYILxW6Vvc24riaEo5fQyxezL16b2CzmE4V7cdlndSowp9ELZ8N6VhVDAXJvtdzpX6R93A/Tj/Ue2Uxg+AXYBOss3TVybVKkzMb48cj1HRI3pVwCxZpQfSDSJQAtMwe0VEFVHZ4g3Mvn0OSJRGjbkJ7PStpUAsWBcPqTITEJ8rcQ3fFjLdHMwUjdLWsLzzIpHmaqxnwdSkRNZ0JNVDRc1kmQqaqlk9g5jx21UAT38L71U0AhLYeAoEF5gkS19As9YqsYTVTpIystFQlYuIi6RrryQzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W3opLHSKX4V6IZiUK9EObOewuZmOrIeKhPOEYVJYAjk=;
 b=VZrQCm+vjggGdWVQY9drNBGucC0INpPN1/ZuNwQnzk9eXSAMEhuoWDAjnCUdmt1zllwLi2aAaIYuuIXPUUdrh4T+hNmzA4oFaLybw1dUypUjCXHaG+XnlPzqhCtYumrwXux5ccwHKV53tLrYtVEQsCrdhYreIsu/OFlBjredl7yRuxfAezP1QYEk96nqMYEddRLg467UVNPeQKolkZyjqvu2yj50Vw6Dmp0CSWScEPU2DgZU/M1l1KWdPPG6p9lFjqwsc0JV5mcOKWzSn+6BTucrePPxT6MUeP3leouz4BtU5Rwd1Mme15II1iyEAlNdAVGLRPzu8zOJUp+U+sPEsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W3opLHSKX4V6IZiUK9EObOewuZmOrIeKhPOEYVJYAjk=;
 b=3M96B7S4bU3NgpCQ9bOgpvqZQuwNr1xaKca9rJo8bEqI2bij7UAt6uwJnbuFjyD0lGuDScOqpr6TizM2sRCMy7A6ZjXxu2zcgt63nqECz7Jd5cHi/MhBTQBY10jfdJ4x0YooeXb/WbuAG2BMzfdMgAOCyVIC57nzUKsoJIEN4Dk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9193.namprd12.prod.outlook.com (2603:10b6:610:195::14)
 by SJ1PR12MB6025.namprd12.prod.outlook.com (2603:10b6:a03:48c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Mon, 22 Apr
 2024 12:51:24 +0000
Received: from CH3PR12MB9193.namprd12.prod.outlook.com
 ([fe80::7818:d337:2640:e6c7]) by CH3PR12MB9193.namprd12.prod.outlook.com
 ([fe80::7818:d337:2640:e6c7%5]) with mapi id 15.20.7472.044; Mon, 22 Apr 2024
 12:51:24 +0000
Message-ID: <4ffb4f53-a7a7-4ef7-88cc-e2042e953f87@amd.com>
Date: Mon, 22 Apr 2024 18:21:11 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/2] vfio/cdx: add interrupt support
To: Alex Williamson <alex.williamson@redhat.com>
Cc: tglx@linutronix.de, gregkh@linuxfoundation.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, maz@kernel.org,
 git@amd.com, harpreet.anand@amd.com, pieter.jansen-van-vuuren@amd.com,
 nikhil.agarwal@amd.com, michal.simek@amd.com, abhijit.gangurde@amd.com,
 srivatsa@csail.mit.edu
References: <20240326040804.640860-1-nipun.gupta@amd.com>
 <20240326040804.640860-2-nipun.gupta@amd.com>
 <20240419163138.5284fc57.alex.williamson@redhat.com>
Content-Language: en-US
From: "Gupta, Nipun" <nipun.gupta@amd.com>
In-Reply-To: <20240419163138.5284fc57.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0249.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:21a::9) To CH3PR12MB9193.namprd12.prod.outlook.com
 (2603:10b6:610:195::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9193:EE_|SJ1PR12MB6025:EE_
X-MS-Office365-Filtering-Correlation-Id: 55bb1490-2a96-4155-f024-08dc62caea9a
X-LD-Processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eXRVM2ZIUGlLZXBuQlA2OU9IckJKSk1yMXdsT2dUazQ0SUJGT3VGV0VQTWVw?=
 =?utf-8?B?bGF3Q1FXK0dxdnlZZHJmcVA1YzZaN0xMUUZZUUtVY0pyNkRIeXVFQ0NMMTdi?=
 =?utf-8?B?UlFKRUI4SnFWWFNKSXhZNTZNZkFrNW5LRlpqUUpCSE4xOFFrMlBjcFIzS1Z6?=
 =?utf-8?B?ZjJYU24zbGt5N3FKK3czd3ZTVWlyWTNhbVVBaXcxZWFIMVlQQWRTc0VVZTNa?=
 =?utf-8?B?ZUFjQk14MGhzNThQbG5icFUvZE5Vc3pHOTlFcC9YdEJLaXpXbmowdDlOZW5n?=
 =?utf-8?B?NnkyNy9ycHNNMmZwb1RLVXk5UDB5NEZMYnpXNmNqMlFucXBoaDVmb2pNN05V?=
 =?utf-8?B?K2tpVjhnTEUvQWwrampxRGROQ2k0bUhuVFE1U3hHTG15L1poamwvYlYvcnM3?=
 =?utf-8?B?Q0Q3MEJMYXFGL2plMG1TSFFSRFhwQlpBT0wxY0JJeXVFaGZXQVdLN3FTSjZE?=
 =?utf-8?B?MXNzVWd0Y2ZLNUJmdVZTVlpVVGc4WWtvUnQyU0wramp2dTZXeWJSQ2FqZEpx?=
 =?utf-8?B?ZnNWZXNrZGJsc2UzVUovOGIzUEthaUtzSWIwTUpXQlZ5V3hOSVE4WUkxWjRa?=
 =?utf-8?B?N1R5UW5mdTgrMXg3WUc1TzBKUGVJMkJZN0xIK0xPZUtvbFVycC8vZmt1VVdT?=
 =?utf-8?B?Q3M2eWJjclBHV0hpcEdNT2hHaDhrenpRSk9EV1IyL0hGSUsyb2NHQ0hCVUZC?=
 =?utf-8?B?UFpRQlBERWYyKyswQ0drM2tsS1duUi9RVCsrbjRLVUE2bzJDZUUvb1l5dE5E?=
 =?utf-8?B?MWZlR1l4SW45RjBvUktwRkRGZWN0akxBOXdwWFBURU9jWVBPSFZlNlEwRk80?=
 =?utf-8?B?WG1ieGY5WnFiTkhSMG5VWGpLOGk4TVQ5Rmttb0xRZ0FxV055Q3NDbTRPWTBs?=
 =?utf-8?B?NSs5SU1XNW9NdzFCeTZNS3JNaktpZ1NUR2xQSEU5andyellnV0NmempzYjhU?=
 =?utf-8?B?R3VtNU5nY2tZN3duMTZOTktUMkFlbE1haWczcmo1OEJkZko5Vk5kVElPOFlt?=
 =?utf-8?B?TU1lZ3lSNnJrYUdPa1h1STBKSUVZYlZETzZidUJmVnVzQjB5bkUwSzdMZEpv?=
 =?utf-8?B?YmxSRlBBQlY2VWkxTEtza3BEaDF0QVMwa2QyRndlQys1Q3dXSUJMTXVqTFhC?=
 =?utf-8?B?ckgrZ0x5NCtrb1A0THI3eDJNTmJ2MUowU0svelJVQU83YWpvWDBncHJFWjB2?=
 =?utf-8?B?T1lZL28vcFFLTVJOOTR6ZXpnNnRVTFVuSmx5UGZ6eERCaUIrSm9kYlFJdFZU?=
 =?utf-8?B?djhGenp2VjYxdGR1Ry9jcDhlck95MEcyNlVXU0tvaExtblgwNy9CZUVDWEFP?=
 =?utf-8?B?S2tNcDR3a05nbEdDRVJ5d1RGeElUQTFtSGxBN3YwQ0VxVSt3RFBsOXVONWlQ?=
 =?utf-8?B?RXFkQjAvcGxIbzVyT3RBa042bVErVFVJeW5EU2RwMFdvYmpvYU5SdXZqTnpQ?=
 =?utf-8?B?VWFIYjk0THdiM0VSelJyUW9ZRzRKNEhuQUwyL2JhSWRuTW5mV0oxdFFLY1k1?=
 =?utf-8?B?L0JYbXF5NW9XV2dpWCtEZXRDMkYzNlBndmUyMjJtbDI0eUNzVVBQNjlRVjM3?=
 =?utf-8?B?VE85UGdiMFo3U2NYWFZDdHY5alhrbHhFR0FYT2ROaEM5c3lTUitoN3RvYW9m?=
 =?utf-8?B?MWYwRk1FeXlkRjFGMWY3Y01ndENwaHpzUTB2OENHaEpESnJRNUhyNUo1N0ov?=
 =?utf-8?B?SjVCT3VpdlM0WDRHTzkzTFl1MnJJZTgxblFmYmkyQkhtZzQ5SVp3L2FnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9193.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SjZMdGhZV0U0TUZaT1hhUHQxUFA0UTRFSFZjRkVueGhDODVTSXB2VENON2Yr?=
 =?utf-8?B?WVg1U0cwZzg2UkxzU0ZRQ2RQbXF0QWM4WHFVK3VIQ1BhR053bE1TRUxQVjRB?=
 =?utf-8?B?N2k2TGZHQW10bnR1bU8rVGdkYnZtellPYjY5bnBLZFpHUWI1OXluY2sxdnF2?=
 =?utf-8?B?YkFPYkpWTXhzY3pDc2VGYlBWVzhzT2R5c09FbmlFODhieWhMTEdFd2pQSkYx?=
 =?utf-8?B?Tmo5U3Y5MDNJSW5xaUw4WnVENzk5YlVnVWNqdm1Zby9CUFBpZVljSkJXTWxI?=
 =?utf-8?B?NXdqN05LUHdUQkVranFSUWRHQnZxd29OV1U0SVo5bDVQT1pnRlBSNk5ydWRt?=
 =?utf-8?B?Y0JwRVh6YnhBcFJEQzF5R2I1TnIzTDVqQ3pJSkJoK0k0akRwOUdhaTlXdWpl?=
 =?utf-8?B?bFU2T0tmS3hRcFN4Sk50ZjRzNXE5UnFURERNRGl6aU9qeW0zcFFLTzVMYWhR?=
 =?utf-8?B?NXZidDkzVTlUcXpZZlBnVllpeDhBSFRVMzQvcGpYaHpLRWc2elllY0dmNXNJ?=
 =?utf-8?B?czlkRTQveURGZ29xVTJGdklJcWJ5TTVKODBFMzRKNGRqbkRGVStYSGkwbmxF?=
 =?utf-8?B?RHROdFN3R3prbCsvdXJLTC8yZmxsZUFjRE9SMU9RY2hCMHkzRnk1MHBwcU91?=
 =?utf-8?B?em9YZ3hsZ2lFYlE3dEhjc2ZPOHNRR2lLeTNqWUdaeDV3Y3pPT3N0eUFlRDhW?=
 =?utf-8?B?UFlrQ1FKV2lscGhFYnhhOG9zdHlEMUVPelE0ZjgxbmxBb1hrd0Mra0RFcW5z?=
 =?utf-8?B?UlBCbmlHY1U3NzJPcFJBcXJpdlpKNFVnU2p2dzRwVlYybDBEcXNvVGhPMWhl?=
 =?utf-8?B?MXFSKzE5UUNQUzRyQnV2MEwzRjNLMmhZVmlKRXNkdjcwNC9CcmlWZUxIcGo2?=
 =?utf-8?B?d1l6dGhudmV2aTJZUHVIT1RpcUdrcHFVbFVZdmZQdzlCZ1VQenNHSGRCWHFH?=
 =?utf-8?B?aERWOXQzMW9mVjk4a2hNd0pqcDRYTEJBMUlOWVFYWEVBSGRieU9SNWpjWUhT?=
 =?utf-8?B?VENKNWJtY0VNUEtxQkFtaGhvT2s1eXBYQmNPb3ZFYU9BQlNQOGJHajdZNHhP?=
 =?utf-8?B?TmN1MTJrN1pkeWRwS2FtdEV4cW9KU2FoejBEek5HMFF5NWg5VlZmOEF0bEN4?=
 =?utf-8?B?UjFEeWFOVU1Ndm1JK3RELzZmRWVxM1ZzMUpKUlNDeDRuMUxEY3NTM1RMZElm?=
 =?utf-8?B?alJ6ZXBxbVR0V0puQnltempDOFBmN1pJeDByOW9ONkFFTjIrMnNDdUhmVTVj?=
 =?utf-8?B?bXlnbVVrdjQrMS9OZFkvWmVHUE1sRmZSeXp2NndYSlZnYVlBNWFBYk9RNEFQ?=
 =?utf-8?B?T2ZwaytVQ1BsNG9uTUdieEVuQVRCZG9HT01rQjVOY0RyZTB2WWg2UDl6ckRM?=
 =?utf-8?B?Y0c4VVJkOHlFYWt0ZGQvQnBOeStYcjByUloyYTZjVGtoYjJqWHZ5cEhuSDJE?=
 =?utf-8?B?RTVuY0tkSE16dnd5WlpPTUdFZUhxNExtMUFmM2JHUGZpZlkrZHBrTWljSTU1?=
 =?utf-8?B?Rmh4Rnp4aXRGZ2N6U3g5UHNDaGQ2R0FuRVgyVGxrUmdUOElQSmE2OFlhZHdV?=
 =?utf-8?B?dlIzbUtBak5selN5SGZ4VDFNNEF3WVg4UTJNZGF4ZkhBOCtNelZ6bEx3azRz?=
 =?utf-8?B?VDJ4MFNnVUlIdXJnbXhZa3RaZnZTaWtQZzFUcW9OdGI1M1hhVlhCZVZvbThH?=
 =?utf-8?B?ZHI1SllaVXJpbVRmZ3lYYmZ4b2dkRmJBWkgxMU9jR1lGUFk4YlpQK2NTRjBC?=
 =?utf-8?B?SVlXZjV3b2x0aGx5c1RlUEhMT3k2cUhXL2NxSXZIWEo1dWdrSGIrUWpXOXBo?=
 =?utf-8?B?cUd4UkM4S0NLNXNDU3NuS01iNkxwMWJlUEtOV3dETE5oNCs1dEJDK05Qdjdl?=
 =?utf-8?B?c1d6TGRFOERzTDkzbXpSNi9jZ2hyQzBPLzBMZTRGWW95cWxHWmYzT00vd2Y1?=
 =?utf-8?B?RHIwVGRiZjNMR1JOOTQrNEhuWWFpOXhUdTBKMCtMZUFrL2xuSVlXMHpsSXl4?=
 =?utf-8?B?K3JrRWl4N0FyRzR1UlBYK2FHb29OWXV3bWtOKzVrYXp5SUcrQm94WW9qQTAx?=
 =?utf-8?B?VzRPYnpQZUFicThFZ2dKNWRmbWVldXI5UVRHZlpyR1R2eDJCcjV6VmJGMU1t?=
 =?utf-8?Q?N7P2nvSBxiPmHRAVxCyG6f0Hi?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55bb1490-2a96-4155-f024-08dc62caea9a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9193.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2024 12:51:24.3448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vdZF9Qr6sOVYbLdKsg0vfclgoah/ka6/D1Pizyt4zUdl0e7uF8xglKSm9MIm5NKm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6025



On 4/20/2024 4:01 AM, Alex Williamson wrote:
> On Tue, 26 Mar 2024 09:38:04 +0530
> Nipun Gupta <nipun.gupta@amd.com> wrote:
> 
>> Support the following ioctls for CDX devices:
>> - VFIO_DEVICE_GET_IRQ_INFO
>> - VFIO_DEVICE_SET_IRQS
>>
>> This allows user to set an eventfd for cdx device interrupts and
>> trigger this interrupt eventfd from userspace.
>> All CDX device interrupts are MSIs. The MSIs are allocated from the
>> CDX-MSI domain.
>>
>> Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
>> Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
>> ---
>>
>> Changes v4->v5:
>> - Rebased on 6.9-rc1

<snip>

>> +
>> +	for (i = start; i < start + count; i++) {
>> +		if (!vdev->cdx_irqs[i].trigger)
>> +			continue;
>> +		if (flags & VFIO_IRQ_SET_DATA_NONE)
>> +			eventfd_signal(vdev->cdx_irqs[i].trigger);
> 
> Typically DATA_BOOL support is also added here.

Sure. will add it.

> 
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +int vfio_cdx_set_irqs_ioctl(struct vfio_cdx_device *vdev,
>> +			    u32 flags, unsigned int index,
>> +			    unsigned int start, unsigned int count,
>> +			    void *data)
>> +{
>> +	if (flags & VFIO_IRQ_SET_ACTION_TRIGGER)
>> +		return vfio_cdx_set_msi_trigger(vdev, index, start,
>> +			  count, flags, data);
>> +	else
>> +		return -EINVAL;
>> +}
>> +
>> +/* Free All IRQs for the given device */
>> +void vfio_cdx_irqs_cleanup(struct vfio_cdx_device *vdev)
>> +{
>> +	/*
>> +	 * Device does not support any interrupt or the interrupts
>> +	 * were not configured
>> +	 */
>> +	if (!vdev->cdx_irqs)
>> +		return;
>> +
>> +	vfio_cdx_set_msi_trigger(vdev, 1, 0, 0, VFIO_IRQ_SET_DATA_NONE, NULL);
> 
> @index is passed as 1 here.  AFAICT only index zero is supported.  The
> SET_IRQS ioctl path catches this in
> vfio_set_irqs_validate_and_prepare() but it might cause some strange
> behavior here if another index were ever added.

Agree, index should be passed as 0 here.

> 
>> +}
>> diff --git a/drivers/vfio/cdx/main.c b/drivers/vfio/cdx/main.c
>> index 9cff8d75789e..f0861a38ae10 100644
>> --- a/drivers/vfio/cdx/main.c
>> +++ b/drivers/vfio/cdx/main.c
>> @@ -61,6 +61,7 @@ static void vfio_cdx_close_device(struct vfio_device *core_vdev)
>>   
>>   	kfree(vdev->regions);
>>   	cdx_dev_reset(core_vdev->dev);
>> +	vfio_cdx_irqs_cleanup(vdev);
>>   }
>>   
>>   static int vfio_cdx_bm_ctrl(struct vfio_device *core_vdev, u32 flags,
>> @@ -123,7 +124,7 @@ static int vfio_cdx_ioctl_get_info(struct vfio_cdx_device *vdev,
>>   	info.flags |= VFIO_DEVICE_FLAGS_RESET;
>>   
>>   	info.num_regions = cdx_dev->res_count;
>> -	info.num_irqs = 0;
>> +	info.num_irqs = cdx_dev->num_msi ? 1 : 0;
>>   
>>   	return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
>>   }
>> @@ -152,6 +153,59 @@ static int vfio_cdx_ioctl_get_region_info(struct vfio_cdx_device *vdev,
>>   	return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
>>   }
>>   
>> +static int vfio_cdx_ioctl_get_irq_info(struct vfio_cdx_device *vdev,
>> +				       struct vfio_irq_info __user *arg)
>> +{
>> +	unsigned long minsz = offsetofend(struct vfio_irq_info, count);
>> +	struct cdx_device *cdx_dev = to_cdx_device(vdev->vdev.dev);
>> +	struct vfio_irq_info info;
>> +
>> +	if (copy_from_user(&info, arg, minsz))
>> +		return -EFAULT;
>> +
>> +	if (info.argsz < minsz)
>> +		return -EINVAL;
>> +
>> +	if (info.index >= 1)
>> +		return -EINVAL;
>> +
>> +	info.flags = VFIO_IRQ_INFO_EVENTFD | VFIO_IRQ_INFO_NORESIZE;
>> +	info.count = cdx_dev->num_msi;
> 
> This should return -EINVAL if cdx_dev->num_msi is zero.

Agree. Will add this check.

> 
>> +
>> +	return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
>> +}
>> +
>> +static int vfio_cdx_ioctl_set_irqs(struct vfio_cdx_device *vdev,
>> +				   struct vfio_irq_set __user *arg)
>> +{
>> +	unsigned long minsz = offsetofend(struct vfio_irq_set, count);
>> +	struct cdx_device *cdx_dev = to_cdx_device(vdev->vdev.dev);
>> +	struct vfio_irq_set hdr;
>> +	size_t data_size = 0;
>> +	u8 *data = NULL;
>> +	int ret = 0;
>> +
>> +	if (copy_from_user(&hdr, arg, minsz))
>> +		return -EFAULT;
>> +
>> +	ret = vfio_set_irqs_validate_and_prepare(&hdr, cdx_dev->num_msi,
>> +						 1, &data_size);
>> +	if (ret)
>> +		return ret;
>> +
>> +	if (data_size) {
>> +		data = memdup_user(arg->data, data_size);
>> +		if (IS_ERR(data))
>> +			return PTR_ERR(data);
>> +	}
>> +
>> +	ret = vfio_cdx_set_irqs_ioctl(vdev, hdr.flags, hdr.index,
>> +				      hdr.start, hdr.count, data);
>> +	kfree(data);
>> +
>> +	return ret;
>> +}
>> +
>>   static long vfio_cdx_ioctl(struct vfio_device *core_vdev,
>>   			   unsigned int cmd, unsigned long arg)
>>   {
>> @@ -164,6 +218,10 @@ static long vfio_cdx_ioctl(struct vfio_device *core_vdev,
>>   		return vfio_cdx_ioctl_get_info(vdev, uarg);
>>   	case VFIO_DEVICE_GET_REGION_INFO:
>>   		return vfio_cdx_ioctl_get_region_info(vdev, uarg);
>> +	case VFIO_DEVICE_GET_IRQ_INFO:
>> +		return vfio_cdx_ioctl_get_irq_info(vdev, uarg);
>> +	case VFIO_DEVICE_SET_IRQS:
>> +		return vfio_cdx_ioctl_set_irqs(vdev, uarg);
>>   	case VFIO_DEVICE_RESET:
>>   		return cdx_dev_reset(core_vdev->dev);
>>   	default:
>> diff --git a/drivers/vfio/cdx/private.h b/drivers/vfio/cdx/private.h
>> index 8e9d25913728..7a8477ae4652 100644
>> --- a/drivers/vfio/cdx/private.h
>> +++ b/drivers/vfio/cdx/private.h
>> @@ -13,6 +13,14 @@ static inline u64 vfio_cdx_index_to_offset(u32 index)
>>   	return ((u64)(index) << VFIO_CDX_OFFSET_SHIFT);
>>   }
>>   
>> +struct vfio_cdx_irq {
>> +	u32			flags;
>> +	u32			count;
>> +	int			irq_no;
>> +	struct eventfd_ctx	*trigger;
>> +	char			*name;
>> +};
>> +
>>   struct vfio_cdx_region {
>>   	u32			flags;
>>   	u32			type;
>> @@ -25,6 +33,16 @@ struct vfio_cdx_device {
>>   	struct vfio_cdx_region	*regions;
>>   	u32			flags;
>>   #define BME_SUPPORT BIT(0)
>> +	struct vfio_cdx_irq	*cdx_irqs;
>> +	u32			irq_count;
>> +	u32			config_msi;
>>   };
> 
> You might want to reorder these to avoid holes in the data structures.
> vfio_cdx_irq will have a 4byte hole in the middle, vfio_cdx_device will
> have a 4byte hole after flags.  config_msi is used as a bool, I'm not
> sure why it's defined as a u32.  irq_count also holds a value up to 1,
> so a u32 might be oversized.
> 
> There's clearly latent support here for devices with multiple MSI
> vectors, is this just copying vfio-pci-core or will CDX devices have
> multiple MSIs?  Thanks,

Will reorder structure fields to avoid holes. CDX support multiple MSIs 
and 'irq_count' is actually number of MSIs which can be more than 1. We 
can replace irq_count to msi_count to avoid confusion.

Thanks,
Nipun

> 
> Alex

