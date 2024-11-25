Return-Path: <kvm+bounces-32415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16F3B9D842B
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 12:16:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C04EE28A2B7
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 11:16:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E93116F8F5;
	Mon, 25 Nov 2024 11:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JiYyuU+A"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2086.outbound.protection.outlook.com [40.107.94.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814E61922E0;
	Mon, 25 Nov 2024 11:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732533405; cv=fail; b=BHzz5v0jP4HRZZtjqcunvSiUsY6HEyb/1c/GXVGqeuFhuVDUK7LVtA4ugG3TMmHT5tcwlK8wWKuRuYoRi5hYgPVb8Qs4phrXFNwXm+jC5YG5Pv7ZX/sEchvKTxh/+W3GcQrT+pq6zdotLkHSJptELXNwBI0V5JHaaPMJnzdmP/k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732533405; c=relaxed/simple;
	bh=+4civSCPlTT4SHbtCz5MarUncuecBmmE/Ev9WogB0gg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=A1uNXzJgFqx1z7C5PgUh47P73fpAM5gKB93AdUGlOal+TUGRZ80/7Y3Yp6ko3Zyjgul19uD3khis95X2xJtdPeq/FC8ie03TCztQOcOa2TBcs1ARhb50HS8UPAKc5efpTzr8q041LdZmG3kqmvsg5WLZhhkQV5pHaddKU99GxV0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JiYyuU+A; arc=fail smtp.client-ip=40.107.94.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yQTmVMISW1EXSrfvv0NJvi4aZMBrIwcw7ZJKBi7r4k4msqN+s5QneP6Pov4LbPAlLVPG0VbHPjExEvqSVRF6i/JrGoGz3eGhz7TGz96z9D5oPbnsF1ypa8ynEC7GbFTwa2oLZGIDr+cDnWN8BO/GZLLpfwO88AEITuzw5TGDrMN2IX47P5SRyeEbnK110VXuk6Qq+96SL2K27UFDPc9f9PyIwjMjC3c/EeR453cUzVU1KhMc4kKlOE4RtAx015cHowc6LWrbX7qBBc5Ij/ASCRLlMwywJwuJUbJ5LmqJN/E95kftvNxs683/+zyvnlL3Z7RsICvzxPcXf2TqzNTt/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lGK26DSosQGJpTW1lj09rsDeF5ji3Kimxo9oARsy+cQ=;
 b=kPbybDi6ZOVi7ltDlPU90btf6H2+xE/cTXcSoTEmdBW6twKQRsTAmPxAmI9R5kANi3e1VXc+wsz1rnpf9Ds3uPJgskJiPK9qUlojH6k4I0zhE4E3Un5uMiuuYpmtNZYtkRNvJCAQVaqnalu0qL1G5vMyD/Ln9bWrviG2OJ29YDm/fek+y6+6ehmNEBy4sn19K/OCr21DoyibZhLcqmDxPaOnY49YaZlGZNrSF7jjgTNK6NiBYJ9b+SjNbkNga9xBQ/m0SeItNvBZKFlL9bmSALMrFFJEcQpM/zdja+YQ2CffpwM9hHMgGsgPhyslzpOOa3NxftGXQ0GV+GnhHqSpGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lGK26DSosQGJpTW1lj09rsDeF5ji3Kimxo9oARsy+cQ=;
 b=JiYyuU+AiG4yr9nH+LSD5+MslLNxbxoMTUyJu5BHyDwTHEvGKIJWmZXuYBokYkWX+/ZAkJO/H6NLeUQNQ2knKtzV7Fiyz2C7PlevRShe33lx91ic1LGou/dQwN4Me0qxMfhK0AtuT1FxX5uV31FHAHgK5ajBqjPJn780rEM8+NM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 PH8PR12MB6745.namprd12.prod.outlook.com (2603:10b6:510:1c0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.20; Mon, 25 Nov
 2024 11:16:39 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%3]) with mapi id 15.20.8182.018; Mon, 25 Nov 2024
 11:16:38 +0000
Message-ID: <8098cbb8-646e-42b2-a745-163abffb3c73@amd.com>
Date: Mon, 25 Nov 2024 16:46:27 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 01/14] x86/apic: Add new driver for Secure AVIC
To: Borislav Petkov <bp@alien8.de>
Cc: "Melody (Huibo) Wang" <huibo.wang@amd.com>, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-2-Neeraj.Upadhyay@amd.com>
 <6f6c1a11-40bd-48dc-8e11-4a1f67eaa43b@amd.com>
 <4f0769a6-ef77-46f8-ba78-38d82995aa26@amd.com>
 <20241121054116.GAZz7H_Cub_ziNiBQN@fat_crate.local>
 <6b2d9a59-cfca-4d6c-915b-ca36826ce96b@amd.com>
 <20241121105344.GBZz8ROFlE8Qx2JuLB@fat_crate.local>
 <0042e7cf-764b-4ab9-9c66-0d020fe173e2@amd.com>
 <20241125100805.GAZ0RMhbjUAKad3p8A@fat_crate.local>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <20241125100805.GAZ0RMhbjUAKad3p8A@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0154.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:c8::7) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|PH8PR12MB6745:EE_
X-MS-Office365-Filtering-Correlation-Id: e1e03966-f646-4b5c-7324-08dd0d42a177
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M0RRSFNpUkIzNXpZeGovc1EyMGNOT2NpZGlkckJHbjBqdEhxNVdFWFp3ejZx?=
 =?utf-8?B?V1Q3ODh5eGtzZnYramFxZzZYaTRLWUV3MG1TUDJqc3UxakFNVUlYaStnNUxy?=
 =?utf-8?B?dlJpS1pZcnJoT0RCcTk0eC9BMU5wbnlvd0pPblJtNVN5cC95Yk9RWjhlVVBt?=
 =?utf-8?B?YmhoVDJVS0VSMzBIVnB0aU54T1kzNlFlK2d6cVF1d29kWEQreEdmanVjaHlo?=
 =?utf-8?B?azR0NFpTaENaYUNFK2JMTUZTSDIwbjRNZnFldUhxWWJlUEVvM0gyYVVNSm10?=
 =?utf-8?B?cGc2Rm5ScTF1aW5HNmYzRHpHNkZkVUkyOTQyM1lHdGRzYU83TFV6cmNraWc1?=
 =?utf-8?B?QkQ5OVBXZ0lodzdERjhlNjV1QXlMU2o3TWR1QlR4c2NrYmZDNjRkRGdEZE5D?=
 =?utf-8?B?Ny9FRnM4WDJxY1A3bXFJUzRMNGhyK3dOVmt4Q21PUDUrUFpzejNFc255a2Ri?=
 =?utf-8?B?aGJTOG9vRCtDMjlaM3RFaUNYQWprWXhXTFJ2NFBldFFCL3RobTBRNkZycnJ2?=
 =?utf-8?B?NStZZmlHaDh4M093dmVXS2o3aW5IaVd5V3RWenA3Z0VHa2ZCV3h5UEFrTk83?=
 =?utf-8?B?bGQvNG1jUTZyUWlHWmpZVWEyODFWTFc5Q1FZNkF2OVV0MTFvcFJjZFZHU1pj?=
 =?utf-8?B?NzFEK0VYSHFRcC9FNW9CSmJZMllELzYrZEY2RjJUQ2hPSC9BRFZlTXRJNktW?=
 =?utf-8?B?K2hDTkRocy91ejRRZzdteVBONVg1VmR4SnEyTDFZbEdzRkxkQVY0cWRaRytn?=
 =?utf-8?B?UUgrUjVtNTM0cytMaGdoSnprS0puZElqS2NJSjNmQUMrdHNBUDRzd2dpYlRF?=
 =?utf-8?B?RzZJTFpTeXNzR0NQcVY2Nm5pTVZKZXhyZlVTa1BWeHp0MU1xaloyZFoyaEFU?=
 =?utf-8?B?QjR5S1RNUE4yOHNsSi9hZUp5NzdvYThRSGpSdlg5Z0Z1MUYvTUQwU2JYMlVa?=
 =?utf-8?B?SHBpL2tGNm9GaGUyR2U5cmZQY1NUTUplWUliZk1FN2R2YVFpM0pzTEdvNGc3?=
 =?utf-8?B?dGE3VzZnYitZZ1VESnQzbkwreVg2dHJxYnhOc0RCV1NCVDVJNHFKSE5ZVTBi?=
 =?utf-8?B?OEY1ZFQvOFI4VVUxL0RUeTg2cFRucFZQc2ttZXpqUnYrRlpnaUlzWXNkWkxF?=
 =?utf-8?B?ZW9iMEFwWnJ4Qmx0NnUydDBUN09MSll3eGdlUnVIT1R0ZFRzVHJhdXRSd3do?=
 =?utf-8?B?RithM3NMWVBGWXZHR1RKVUhodDNQUHhJRUd3cHE1UHJDVklnWVUvZHNzRDNv?=
 =?utf-8?B?eHVJR0VDeUxsR1JvVTRYb005WXdpYzlqcDhNUFp4Qnp1MjNsYjBqWnVEZnRJ?=
 =?utf-8?B?TjdHaTBzWTVGSXRBa053VkF6K1J1eDdlekYrb0QxNW04ekE2V3IzeGRVUGcr?=
 =?utf-8?B?T2s3N0EvUkM0Rm9vVnRWT2FRT3FHTzVWWGpYcVc5cXdNbDFncTJTSDVNbXFJ?=
 =?utf-8?B?NFlRTkswc2ZvWVdhOXhrNDZSZWRNSWtsbnhVUFBRSkNJbDF5RVdqOUgwZmJQ?=
 =?utf-8?B?SThaOCszUHFJK205WEVyVTkzMWFvSGlFWm1jQTcrdHdBLzNwSGdEUlZ1dUs3?=
 =?utf-8?B?SWVJV1lFZFFkcWRkTUVNeGJjaENqVHJGdDhEYkdqZ2YycGJETjBsSXgzMkw0?=
 =?utf-8?B?N1RsYjdyaEoxSnoxdUpOeEd1Q1lYNG4xVld3TW8zcDlDeGxxQ0daZmdWRndm?=
 =?utf-8?B?V1o4R2taYVIrYjRKQ3JpYTc2Vk4renBSVW5sWVJmRVpLOUZ2clBIcmNBbkpI?=
 =?utf-8?B?eUNURzhYQ3d0bXF6UEttZTlCRytkMEZ6eXpvU2llamozUkZNR1NRM2pUcWtC?=
 =?utf-8?B?b2F1NkhrWHRSQVJQUjJmdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SEhvazZNWTY2Qkdsd0d0RVUxeS9qY2NLZFF0VERrOHVKb2NFYTN5dXVpZjJT?=
 =?utf-8?B?bTN1N3FlN2s2bVNsUUFKTmRGSWtYYVRmZlFhN0d0UUZReE1FNTV3TjdxWVlk?=
 =?utf-8?B?UmtmZTB3bVY0YmtpcFFLczhxYWhiVXNuR1JaRGRYZEliMWp0RTVqYTJSOGhs?=
 =?utf-8?B?TWpMbHRuVnVFd0VPQTYvSngrWFdHRE9MODY4OGx5bFFBUkM2M0MvbWtma0dC?=
 =?utf-8?B?RC9xREFiK1JJZHNGOHgzelNxeVpNU1VGdnJMVnFkOVUzMXZZa1dnai9PYVJF?=
 =?utf-8?B?dWhQTmh5cStTZ2l5WkZISDNQY3VJQWxIUFY2Ykx5SWhkMXVGT21ySDJBdTdt?=
 =?utf-8?B?bjhPSDFlLytZTEtBMUp5cUtJK3QveEdXN2RxNVU0SDdGd1YrT1BrcHY4YnQy?=
 =?utf-8?B?MjNueGUyaXd3QWJGOW5RMUFPc2NlQ1pXM0JqZ1VJSTNHamNvZ3ArTzI4RCtP?=
 =?utf-8?B?bW9lQ1ZLcldZUDJnUUgvMmNnVDhNMUp4ai96cHJVNGczdGxxaHZPc3k0aEFo?=
 =?utf-8?B?NTRMaXNIcllEYmI1SVFjOEJ3Z3lFam9EWWlDZTBYQUhXTXl2b1NpVk1vSmRP?=
 =?utf-8?B?NVBxelIzRE1sb2ZjeDZCNS9VUm0yVW9uZDBSZEJPL3pHbERFZk4zRnVPZElX?=
 =?utf-8?B?Szd0VlBzQVZXR3Vqb0MyT3JVVHJlK2cvN0pmMUZFNDRoQ0E0TFlpQUdjODBY?=
 =?utf-8?B?UUlubFlhZWxaU1FyVXdWcUpvdVlwQ2QyOVhSN05WcU9hcDZGT1U4Wi9uY3Mz?=
 =?utf-8?B?VnB4NUlYV2JMeXEvOUhoTlFQQlA3ajZibFBFZW1zSWhZYjVHUHZFU1ptclFt?=
 =?utf-8?B?ZWc1di9IWnN2cStkaENCOXVpaW0zRXIwWitoWjkvOWk1bjRMcG8xNENHVVdn?=
 =?utf-8?B?TEdpYysybGUvVENROU9FdkRtT1FURW9GRnpkYU0zS0h1YmlEa1NxMzRUOUVO?=
 =?utf-8?B?UWVUbU9pRlhDa01KVTdKMTJabld0R0FqRmxWd054eXA4dmVDcVJFK0lXWUZM?=
 =?utf-8?B?cnlKQlM4WkduN1lUVEp6dFdUV2J2Q3JzcXkxNGtvMTIvNE1tWFRleGRlVDd6?=
 =?utf-8?B?TG94dzlMampzSmJMSkgvNWYxMFhkNlhZU0VCQmFaM0V1UGg1SFZYbHc3SzZ4?=
 =?utf-8?B?elh4c1VaODJMM1JySU9JKytQZ281MzB4SXAyK28wbEs1ZnRveS9vMDhYTnI5?=
 =?utf-8?B?MWxPUHVXSlZNR1BOQXk5dGVnRlZsUXM5UnBNMm94QXE1TFcvMFZ2dEUyZDZX?=
 =?utf-8?B?T295ZldRSTJ2cUM3bjNvZ0EwdEg3OENhKzcyb0EvbUxIR1FueFAzUy9CcG5D?=
 =?utf-8?B?WFc3Q1hHMFJXOGZSc0g4VjRMcGU0QWlXOHZSL3c0V21DdE5KSWdTbnhLZmpT?=
 =?utf-8?B?UkMvM29WR0hwYlhrMUpQOXNtd1gzRFZUU3VDZm1vRXhDSEI0Y3N3OXdmR3hG?=
 =?utf-8?B?NEtCQ3N2bDcrUDRUbmRyZlVWeDJLSmNzaEhIZDdBcURENGZvMk1TTWtDRGg3?=
 =?utf-8?B?MklycVNmc0xyNVFNS0xTYzVpcFZVY3phQjFuV0kwZklPc2VKdmM5UFlLTE5y?=
 =?utf-8?B?TVJtU3Vwemx2NUUzT2ZYUHRKRmRoT3kveFFCaEdWMWpyQVFLb3R1WEZJVEF6?=
 =?utf-8?B?cHQrd3h3R1MzamkxZjVWbC9EaGR0THF5cm4xSkZzbS94azJjUmF4RXEvODVY?=
 =?utf-8?B?N1J2dWVRdXNxLzZVVitDTHRteGdlaVZIM0l6ZzN0V1VnV3ByMExwQkdFN2d6?=
 =?utf-8?B?MlAvUWRkNmMvclIwdVBuaUtCOWU4am56WTBYUVVLcmg4YkVGL0ZhSUpHTHZ2?=
 =?utf-8?B?VUdNV1F0cTIxRXE4NCtTWHNlVy9hdDNYMnJ2VmV3YjJUeitNK1l2UnRjS3Bu?=
 =?utf-8?B?WU5WUk1qOWMyREUwYVRhbHlFaDhwNVdTQk83Q0dvcGQxK1lkSGRBbFhNclJm?=
 =?utf-8?B?Nm5qUkRpQjV4VGdqWk5jd0RmQkVVZmdRT1gyQlRWa2FKWk1DNU4wbnNJNURG?=
 =?utf-8?B?NjBhMHQwdnY1STRURTdMSStqSDE4T3IvNnNjRzVGZ0E2UTVpYWJzYUVJZUZN?=
 =?utf-8?B?M1hSQldsZ1ZycWUrS0VpNDZ0UTIrWmZURVJ1M2hJZXVtWUNxY1VObHYzcG9Y?=
 =?utf-8?Q?FlqVihM73DxQ6MyAIElpe7arM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1e03966-f646-4b5c-7324-08dd0d42a177
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2024 11:16:38.6090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HoQmIezX1/FXeu4f7xSVV+ZwAT3+xi+sd2HqvGvS6dW8fBf4AUg1lJGgzRiI7uFcdI5oO6PhtmZuCixDI7Jz5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6745



On 11/25/2024 3:38 PM, Borislav Petkov wrote:
> On Mon, Nov 25, 2024 at 12:51:36PM +0530, Neeraj Upadhyay wrote:
>> I see most of that flow required. By removing dependency on CONFIG_X86_X2APIC 
>> and enabling SAVIC, I see below boot issues:
> 
> Ok, then please extend the Kconfig help text so that it explicitly calls out
> the fact that the CONFIG_X86_X2APIC dependency is not only build but
> functional one too and that SAVIC relies on X2APIC machinery being present in
> the guest.
> 

Ok, I will update.


- Neeraj

> Thx.
> 


