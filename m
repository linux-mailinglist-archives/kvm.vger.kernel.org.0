Return-Path: <kvm+bounces-25450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 84111965680
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 06:40:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 047DD1F244BE
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 04:40:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0C6B14A0A0;
	Fri, 30 Aug 2024 04:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Sw5Vw8H3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2055.outbound.protection.outlook.com [40.107.94.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C68D13BAF1;
	Fri, 30 Aug 2024 04:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724992710; cv=fail; b=Zd6nXYm1ys1YaP0Jt8qLXAVHJbJrfsa3iKmPAJApVfWT7SaLO+Yx1NGg/yd7vzCgkVnfZuEnFkNjcd7/S1j9YSJajLCgLcQI05CR5WPp2AfJ4hJz5hwnHe2FCsb5rLJbZ5w+M8g1537JFWzutGEIR8y36uC9hBEI72yL0KY9PI0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724992710; c=relaxed/simple;
	bh=kDbXkccymPeJaY6cKHPJGWaRPrfXpxCJxdZ49HdiDy4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Nr49m6rbVTtOFCerkL5Lds72aUzQn65t1MWeoAFXX0ovKd58ooAjsrC5dd0BP9la4NhTa/JAsAEDtMKmJRmNHICkYTZ1VK6GwtRZx3GXcGk/RLqJTiFYm7Iwr4QunkH+N6grRrsKWv175O7rNgip5KJpB+I/j/qYgBAkSzP2JF4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Sw5Vw8H3; arc=fail smtp.client-ip=40.107.94.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W6D2aXU9xcJuBy8azQv6S9ZVKYkPpZQjDYeRzUmCV+itbzvpcUfjX3jFBpMCp1vlDkeG3GB9/wOyDunk/qltiAc4WBt8QvgGIoyUoQStExFwM6rZaVXyR7eoVi3SYI3I7/8qBEH9qzwxIbSkLY2wmf0agm2WvL1HwUui/o1YOEZLWkIF1bKx/0padvDGwM3ma5yEqgPnjLgZ/Z7xD5rXvjaWqLB6UV+6punvdv6Uvxxh0sFnrZqBAogiKa7/MI5dfsdlJ5BGvLKw5RhgLfrPqc9ElIJHkdanw5z/jCvTmZmCZZCljOWTTfIxsB1bVxk4enDYSac2MxjZgTVkctcRGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zWkZc8aZTQiy00h88aiunXWOrrwAcHgffFoW9Y3g93E=;
 b=Pjz4kLQ6X06D9HTULwjuF0cmSfTYX+dWQIAcKZcWK7bHn8p59LukgUeiNkwqwX9gHzEKMogA7nEtz674/lbM/fUUTO+q0NeGVWhvQrbJDLVKYwtxLZ6QMUY8nd+icTqxmqJ845WNDrzlcvgLsNUn+CivOWHlYJ0vAouB8uoxHBl/izNJd4p034D/UmoJSlJuK9gJLLokyD++9gU3aP9QliaQH3PIqolCWJKPiSYPRPFGMkES8krw3t/z2ypZU2LZMcpjEJ9iObwX2RL0phfABqMIWasqQ8moKbP/Unp/c8uYuzy2md4yengCvXbYVNFkAxjxleoOewNdg2sImnZSvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zWkZc8aZTQiy00h88aiunXWOrrwAcHgffFoW9Y3g93E=;
 b=Sw5Vw8H3WHaO8k7yrEcJ/97ujmsVAn9XeHbRH+zmxLMr8/Ak4uxbXrbNaLaqSkrGkhrI4cR0afnP3VdH6x3rOKQktcwCHdLM4t1DW6UdmcPgHvVEX/lmacxHZPhYTEyGbhDOj1WMEhHIvFb5vXzfOJld78S5KQCAY1OcUsVCgnA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by MN0PR12MB6102.namprd12.prod.outlook.com (2603:10b6:208:3ca::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Fri, 30 Aug
 2024 04:38:26 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%6]) with mapi id 15.20.7897.021; Fri, 30 Aug 2024
 04:38:26 +0000
Message-ID: <fd8549e3-c2b3-47f7-b413-3007a60ba82b@amd.com>
Date: Fri, 30 Aug 2024 14:38:21 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [RFC PATCH 00/21] Secure VFIO, TDISP, SEV TIO
Content-Language: en-US
To: Dan Williams <dan.j.williams@intel.com>, kvm@vger.kernel.org
Cc: iommu@lists.linux.dev, linux-coco@lists.linux.dev,
 linux-pci@vger.kernel.org,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Alex Williamson <alex.williamson@redhat.com>, pratikrajesh.sampat@amd.com,
 michael.day@amd.com, david.kaplan@amd.com, dhaval.giani@amd.com,
 Santosh Shukla <santosh.shukla@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>,
 Alexander Graf <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>,
 Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
References: <20240823132137.336874-1-aik@amd.com>
 <66cf8bfdd0527_88eb2942e@dwillia2-mobl3.amr.corp.intel.com.notmuch>
 <6cd62b80-9a8d-4f01-a458-4466dac6d27f@amd.com>
 <66d1072ea0590_31daf294e8@dwillia2-xfh.jf.intel.com.notmuch>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <66d1072ea0590_31daf294e8@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5PR01CA0073.ausprd01.prod.outlook.com
 (2603:10c6:10:1f4::10) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|MN0PR12MB6102:EE_
X-MS-Office365-Filtering-Correlation-Id: cc8d0447-e028-4da5-2b41-08dcc8ad9667
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SmpQQ3NYaFFIU3QwQ1VhQUNVSG5aUjlPdThvME11bUQxTG53OGh0RTZqV0Fa?=
 =?utf-8?B?NHV4ZHhqbldxS05pclVDUUlwWXBxQ3JKNllqWVJrUFdWUThpRGJsMnVxSEtl?=
 =?utf-8?B?eHhrS0djd3p5b29LdU9ZdFloalJiSjZvcms3dFBIYzZvTXYzRjkrTGRGcjcv?=
 =?utf-8?B?dVZaRkN6RjRwNk1xSGIrQVFqaVE0bjh3MDRZVmVNaUFMVTZmZUxKSHhBSFdM?=
 =?utf-8?B?WWtOS0EyKzZSNFI1K1pGM2h5OC9CUHo5d0JTM1ljZ2JHVGdHWG5uV3NuYStM?=
 =?utf-8?B?NlZVUDdkNTJVQWdxN2JDZk1lc2UydjJtUzM1Uk5vbkJHMnA1eUd5TUNYOU9X?=
 =?utf-8?B?RXZneS9aa3FMVFFlSWE4Zy93MWppSGtPVllOaVdGWnNFZ0dmU0VoYTltWVNU?=
 =?utf-8?B?UjRSMnhZVHY1QXczcnpZV3ZoKzI0eXhvMFpqcDVGNnFzVWZPL0hFbVlFNU5y?=
 =?utf-8?B?WE91VzUxejlGcVpZbHl2VVNxYkh2YUMwQloydEdXeE51aWFxNm82VXB1OVIx?=
 =?utf-8?B?MzZDVTNiV2RKYW93VXFjUlJSUmNabXV4dUdZNUFwK3NwT2puTjJkYXljSVdt?=
 =?utf-8?B?eXFQUWx2NW93Ynpjb3ZpZC9BS1IyaTRUaTA2S1JZVzZ2SU03UHM5Qk5aRVlx?=
 =?utf-8?B?MzNOc1FPMllOL3lVc01uTTJRdXMzd0owVC82aCt4amZXd3YzWFRpc0IvQTBT?=
 =?utf-8?B?OElGY0M2T0hkeDVNUDhJYzVBeGxSWXIyOWtkeERYRkw3YlpQV1pRQnlTR1pQ?=
 =?utf-8?B?cFM2dzBwME12OEtvQkJwMHoyYnEwKzNPb2hsT2JpUEFjS0N5ZllSd2NEM2tS?=
 =?utf-8?B?ZTlNTTF2dlBjK2RUMUdBcUpKSlFjODZWNlpNaVVDRlc4eFBOMVZHUHZldjQ5?=
 =?utf-8?B?K1VJZVlLUDlBYnRqNXhrOURMYmRXNXVwanVBYmVXVUJsTGRRc1dOTUhLQlhr?=
 =?utf-8?B?ZDh2YU85TE0xOTZ3NG85RzFkMmhHeE9WMWh0U1hSV1E3aC9XM0pNNW9CTnFC?=
 =?utf-8?B?UU1BdDF1M2JzTmkrSTRRcjZRWFV1NC9oTzRJNmt1NnlFRklKNTF3dDNiRGJY?=
 =?utf-8?B?WEVVRVhTNVZhU0ppd0I0TS9uWlh5YXZRNWFDQUpGbkhGalpKYys1cTRTdGtM?=
 =?utf-8?B?ekQrWCs4UjZBTHhKMkhRQ0FtcDlUaTdxYUlFRkdiVXVTM1Q3MzBLaDA3QktG?=
 =?utf-8?B?d3ltUUxrNUxNY1BDTDl0UHY1TnhOWS83V1FFV3krWjRDZkFSdXprTGxkTkpV?=
 =?utf-8?B?NXVZdGQ0UmhYRmVEODA3cHBRNldqWjFkVTBnR2lOMSthZStCTEora1dvbjA3?=
 =?utf-8?B?STJTTXh1V21CaFFqM0cyTFlLeTFxUW4vcmVCLzRvNFdxSHpnMWhqa3E1TzJZ?=
 =?utf-8?B?UDJ6UmxDSW5keUtYTkNQejFGVEpTZE5sY3JPcTRnTzZFNitqK1pvTnRUNnAr?=
 =?utf-8?B?dHEwRjRoQzRZTGNzT3l1bnFBOGdNN2NYT2JSQUZKaHN1RW03V1RSYnNveEdE?=
 =?utf-8?B?TStHbEFFemJGSjdPM0IyWmd2d3crMnFyR0tSNXNaWGlWSGNHQW9tR05GNko0?=
 =?utf-8?B?bGRMMXQvOFVBNE1hTWt2QVEzTE5zTmRiUTMvYUpGUXdGVEpJSmR3V0w1dzlk?=
 =?utf-8?B?WklmZ1pLYU12dDNyZ0ZQb211MHplakkxNEpjanFCalFwTGRsTG05ZWxYNm1N?=
 =?utf-8?B?dUx5bjhybGQ4L09WelMwcVg1dHN0MEhLTlI5anJ1RUs2MUdCcDdMT0J4enFI?=
 =?utf-8?B?a3h5OXd5V09RMkgxQld0b0lGaHRIeXdHeVQ3WSt0M0srdHJjdlY1d0RQMzlW?=
 =?utf-8?B?WW5BRm14UDl4MmNGbFZ1dz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cTk4b2lSLzYxZk40Wkw5eGdFOGtEQjFqRjkvTzd2Zy9oQ09saVR6bXZWbERI?=
 =?utf-8?B?TlpDMi9CeDBibEZodUwwZWlSNlV1am9XWDlZTTUvcE84QTNXV2l6alpKbHE4?=
 =?utf-8?B?bTdmR2FwRTZua3Q4UGk3RkQzWno1MVRNV2h2UkVReTJxeDc0S2szZkNZZGFm?=
 =?utf-8?B?WnhpeENSUTRLVVRYZnQ5VUZjTW1TU1c2MzB3TU03WTRldFgzdGlrQXJ4VDFZ?=
 =?utf-8?B?N0pRamVtNjlSanQ0OTFjQXF6eGJGTXM2Mys4M2t3ci9jUW5zRWM2ZjMycU5V?=
 =?utf-8?B?QnA3d2pqNVVyaUN2Mmt6Vms4bS9CV0dRbkdYSEx2enVmV240c3JYYzRmcHVi?=
 =?utf-8?B?NHcvQytKTUVFK2JKbXJHTlpuSWRTNVQrbUZsdUl1dWwvSWhOakpUTmFXRjht?=
 =?utf-8?B?b3FuS2c5eDRkT3Irbml6NGVib05rYWNHY1ZEN3JCdVJQVlFiMHBwVnNWYktV?=
 =?utf-8?B?MTVWUEFZRHdraEdVaitBbnRlR3NaaTFEWVRqNWtzTTdGa28yTHBzR005Z1Y5?=
 =?utf-8?B?bmM2b3B6RnJGdDUxSm1vS1pEQTNMWksrakVVTE1EazRva3hxcWlna01yMUd3?=
 =?utf-8?B?ekg4VnpHd2k5dkVzV2Nibm9mejZETzJoRWZ5LzNZU0cwUnJobk1oWnB0MTk4?=
 =?utf-8?B?VUg4WFVmRXByb2RYQ1lZTDlFR1ptS1FwbjhqbjVqZ3h4NFVMakFLM3EwMlpm?=
 =?utf-8?B?Y3V2VkhwdFBhMkd6ZzFGTnpQVVk2TnBtSDF5Uk12UEdTUDZhRk1vajRlekU0?=
 =?utf-8?B?Q2J5TWRWd3pBdWptMVFTakxtQ240bWM2djZGalNYUDdETzdvc2dmWU5KWkFS?=
 =?utf-8?B?NDFEYXB1UktqWFZOQ2REeGZXZ0RScTlGWExjQTEzYmYxNlVCam1HZDZkUzZX?=
 =?utf-8?B?N3BqeUpLZ3BOOXlpQVp5bmgva01zVGhzdTRONnhoVGhzYjhKdHFYQ3F4ZDRp?=
 =?utf-8?B?RzlOMm5oMTlCZkk0YXd5OGRSZnVXTnV3QlIwb0sxMHcwU0k1MDZxUFZXSXlo?=
 =?utf-8?B?bUxZOC95NjM1TjhZcFdXaktaNlBMSDlhbE5hUlJMaTRFQXliRWV4YkN5VUV3?=
 =?utf-8?B?R1ZYRHoyZHNrUXJ3RVAwL1VsaHU2WUh5dTZXTGJrZ3RqVGhKVFJqYkVRcW5T?=
 =?utf-8?B?UDZNSU9qWTcxbUp5ZVZTdWpCbHg0NnpZMVNINjR6TkJUMkFTSExwQ1ZXUGxF?=
 =?utf-8?B?Zk11UzljREQwZW42bGxuZ3JoUG5TVXROUXdWRTd2VzRWM3pwSDFHYlhYeDZW?=
 =?utf-8?B?RnA2V3krSXdDcmpjVEVTOFE1Y3phSjMvbllYMDZSbmtCdUJSYklYQXgvcEFM?=
 =?utf-8?B?ZlNvU1NzVmxJcGEvdUVJb0loR3RUMUZRdzRYRmh0Y0NoWlN2NEV0aUJGNWRr?=
 =?utf-8?B?Z2JzUExYSVF1NnNXcVJJYVNYVFMwOXp0c2d0eDNuWGFRQVlpY085ckFyQVpR?=
 =?utf-8?B?QjA4TVUrYW0rM1lwS2xzQlppb3BHRlZ0bjRpNVlrSS9CTU5CeDhiOHlmcEpq?=
 =?utf-8?B?a2xlRUN4UXU3azdLaUhhaGkvL3R5QlhOUTdGR045akJwYlJhSVNUT0ovQ3VV?=
 =?utf-8?B?Skg5UnFtWTQvVHRiZElLT0NZc2p0YWtMZVh2clJsN242ZWF0QXZMbStoU0Fq?=
 =?utf-8?B?WURSdHJXYUovRkhSbmRkMURrUXg4TCtVeG1JWUtYRHZjK3U1UnJpcksyL1l6?=
 =?utf-8?B?bHUzdERjK1E4RFZyM05MOGVLZU5KYzlQWDl3RzZYT3FHTVpPaUp0Q2VmUGt6?=
 =?utf-8?B?ZmtJUzNIMU9yUnM2VVhFL1hOWUpLcUhPMHExUE5mS0JQU0c1VVkzTFo3Sm5i?=
 =?utf-8?B?WCtFL01vblYrUjAvLzRyRVVxbFN4dXJuUU5TM3RXWXA5d2c2dFd2SXVmcElD?=
 =?utf-8?B?YlVGUWphSlFTemR2Q2NJQUNzMzR6UzZjY3N3UjlDVTg1Ui9FNy82R2U4UjU3?=
 =?utf-8?B?Y3VUTm1GYVA1b1NMVnNiemYvdzU2M0REVFBCNjUxWktMZ21STUVsZUxPWW0r?=
 =?utf-8?B?YncyUTV1RnA1MHc1S0JFOSs0N1JEUUNwV3hRQkpWT1o3MVhDV2pOMnhrbzY2?=
 =?utf-8?B?bkVPQkZFa0V2ZWJiZ0xQSmtTZ1cwcUw5R05LcDNUQnFVMmlCNTh3cGVVakJJ?=
 =?utf-8?Q?yggJdUSLd3ZeVCXsS0hDEU021?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc8d0447-e028-4da5-2b41-08dcc8ad9667
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 04:38:25.8906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NgfDbKX7N6iWFtUtKvaam0wNm0oriU+Hf0pHfKfaqyddC6Q0wAehjvxmOvu2HPGEpuswDrRasOjoQW6paTO6sA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6102



On 30/8/24 09:41, Dan Williams wrote:
> Alexey Kardashevskiy wrote:
> [..]
>>>> - skipping various enforcements of non-SME or
>>>> SWIOTLB in the guest;
>>>
>>> Is this based on some concept of private vs shared mode devices?
>>>
>>>> No mixed share+private DMA supported within the
>>>> same IOMMU.
>>>
>>> What does this mean? A device may not have mixed mappings (makes sense),
>>
>> Currently devices do not have an idea about private host memory (but it
>> is being worked on afaik).
> 
> Worked on where? You mean the PCI core indicating that a device is
> private or not? Is that not indicated by guest-side TSM connection
> state?
> >>> or an IOMMU can not host devices that do not all agree on whether 
DMA is
>>> private or shared?
>>
>> The hardware allows that via hardware-assisted vIOMMU and I/O page
>> tables in the guest with C-bit takes into accound by the IOMMU but the
>> software support is missing right now. So for this initial drop, vTOM is
>> used for DMA - this thing says "everything below <addr> is private,
>> above <addr> - shared" so nothing needs to bother with the C-bit, and in
>> my exercise I set the <addr> to the allowed maximum.
>>
>> So each IOMMUFD instance in the VM is either "all private mappings" or
>> "all shared". Could be half/half by moving that <addr> :)
> 
> I thought existing use cases assume that the CC-VM can trigger page
> conversions at will without regard to a vTOM concept? It would be nice
> to have that address-map separation arrangement, has not that ship
> already sailed?

Mmm. I am either confusing you too much or not following you :) Any page 
can be converted, the proposed arrangement would require that 
convertion-candidate-pages are allocated from a specific pool?

There are two vTOMs - one in IOMMU to decide on Cbit for DMA trafic (I 
use this one), one in VMSA ("VIRTUAL_TOM") for guest memory (this 
exercise is not using it). Which one do you mean?

> 
> [..]
>>> Would the device not just launch in "shared" mode until it is later
>>> converted to private? I am missing the detail of why passing the device
>>> on the command line requires that private memory be mapped early.
>>
>> A sequencing problem.
>>
>> QEMU "realizes" a VFIO device, it creates an iommufd instance which
>> creates a domain and writes to a DTE (a IOMMU descriptor for PCI BDFn).
>> And DTE is not updated after than. For secure stuff, DTE needs to be
>> slightly different. So right then I tell IOMMUFD that it will handle
>> private memory.
>>
>> Then, the same VFIO "realize" handler maps the guest memory in iommufd.
>> I use the same flag (well, pointer to kvm) in the iommufd pinning code,
>> private memory is pinned and mapped (and related page state change
>> happens as the guest memory is made guest-owned in RMP).
>>
>> QEMU goes to machine_reset() and calls "SNP LAUNCH UPDATE" (the actual
>> place changed recenly, huh) and the latter will measure the guest and
>> try making all guest memory private but it already happened => error.
>>
>> I think I have to decouple the pinning and the IOMMU/DTE setting.
>>
>>> That said, the implication that private device assignment requires
>>> hotplug events is a useful property. This matches nicely with initial
>>> thoughts that device conversion events are violent and might as well be
>>> unplug/replug events to match all the assumptions around what needs to
>>> be updated.
>>
>> For the initial drop, I tell QEMU via "-device vfio-pci,x-tio=true" that
>> it is going to be private so there should be no massive conversion.
> 
> That's a SEV-TIO RFC-specific hack, or a proposal?

Not sure at the moment :)

> An approach that aligns more closely with the VFIO operational model,
> where it maps and waits for guest faults / usages, is that QEMU would be
> told that the device is "bind capable", because the host is not in a
> position to assume how the guest will use the device. A "bind capable"
> device operates in shared mode unless and until the guest triggers
> private conversion.

True. I just started this exercise without QEMU DiscardManager. Now I 
rely on it but it either needs to allow dynamic flip from 
discarded==private to discarded==shared (should do for now) or  allow 3 
states for guest pages.

>>>> This requires the BME hack as MMIO and
>>>
>>> Not sure what the "BME hack" is, I guess this is foreshadowing for later
>>> in this story.
>>   >
>>>> BusMaster enable bits cannot be 0 after MMIO
>>>> validation is done
>>>
>>> It would be useful to call out what is a TDISP requirement, vs
>>> device-specific DSM vs host-specific TSM requirement. In this case I
>>> assume you are referring to PCI 6.2 11.2.6 where it notes that TDIs must
>>
>> Oh there is 6.2 already.
>>
>>> enter the TDISP ERROR state if BME is cleared after the device is
>>> locked?
>>>
>>> ...but this begs the question of whether it needs to be avoided outright
>>
>> Well, besides a couple of avoidable places (like testing INTx support
>> which we know is not going to work on VFs anyway), a standard driver
>> enables MSE first (and the value for the command register does not have
>> 1 for BME) and only then BME. TBH I do not think writing BME=0 when
>> BME=0 already is "clearing" but my test device disagrees.
> 
> ...but we should not be creating kernel policy around test devices. What
> matters is real devices. Now, if it is likely that real / production
> devices will go into the TDISP ERROR state by not coalescing MSE + BME
> updates then we need a solution.

True but I do not even know who to ask this question :)

> Given it is unlikely that TDISP support will be widespread any time soon
> it is likely tenable to assume TDISP compatible drivers call a new:
> 
>     pci_enable(pdev, PCI_ENABLE_TARGET | PCI_ENABLE_INITIATOR);
> 
> ...or something like that to coalesce command register writes.
> 
> Otherwise if that retrofit ends up being too much work or confusion then
> the ROI of teaching the PCI core to recover this scenario needs to be
> evaluated.

Agree.

>>> or handled as an error recovery case dependending on policy.
>>
>> Avoding seems more straight forward unless we actually want enlightened
>> device drivers which want to examine the interface report before
>> enabling the device. Not sure.
> 
> If TDISP capable devices trends towards a handful of devices in the near
> term then some driver fixups seems reasonable. Otherwise if every PCI
> device driver Linux has ever seens needs to be ready for that device to
> have a TDISP capable flavor then mitigating this in the PCI core makes
> more sense than playing driver whack-a-mole.
 >
>>>> the guest OS booting process when this
>>>> appens.
>>>>
>>>> SVSM could help addressing these (not
>>>> implemented at the moment).
>>>
>>> At first though avoiding SVSM entanglements where the kernel can be
>>> enlightened shoud be the policy. I would only expect SVSM hacks to cover
>>> for legacy OSes that will never be TDISP enlightened, but in that case
>>> we are likely talking about fully unaware L2. Lets assume fully
>>> enlightened L1 for now.
>>
>> Well, I could also tweak OVMF to make necessary calls to the PSP and
>> hack QEMU to postpone the command register updates to get this going,
>> just a matter of ugliness.
> 
> Per above, the tradeoff should be in ROI, not ugliness. I don't see how
> OVMF helps when devices might be being virtually hotplugged or reset.

I have no clue how exactly hotplug works on x86, is not BIOS playing 
role in it? Thanks,


-- 
Alexey


