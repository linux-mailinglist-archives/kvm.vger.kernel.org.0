Return-Path: <kvm+bounces-6975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D5D683B96C
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 07:09:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C2CCC1C215A5
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 06:09:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF77410A13;
	Thu, 25 Jan 2024 06:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bZEaZyg5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2068.outbound.protection.outlook.com [40.107.93.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B82F10782;
	Thu, 25 Jan 2024 06:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706162932; cv=fail; b=LEb3fimJTj6NlBBG/kzvHArA/KGvKVdJixAygH74UUoeaKojKkqFu5AyL8x6LT6JED/3cGYZhWvYpu1Wz0e42rOzLPy7TGtNiyyIZcS5gpl9SnCu63dz3FoanFBxT5SY43LlvMHCKlsolOhohhCMqNHOS8ZEoR0i2tefjwbHW/o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706162932; c=relaxed/simple;
	bh=1eZU0ULdGV0CZqBIcwG4stY1M1L05shTuA/m2kl6Sh8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ptA6xwwELERpIgmRtY3XtpKbnJ7j/2ha7adVt3HzUgAEqfq4rm0EqKGmZh15qoa51226HKVsqJJY9Kt1REjQAo6ZnLUbtN/Zgzl2VOo9oRWhHWIhfsSKSemwE9/wob0EQuV6lDxlgmxKEnB3WIB35OQoJCwn8lYNE7bY9qTbMHo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bZEaZyg5; arc=fail smtp.client-ip=40.107.93.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QknJDgDXBdA7vvOpGWlVCJD0u/oUkBxVzOfpPfjs+ORRUD7/WTXBD5INJeL8oj9FZ7MTujcQvZJoGS4VD5s2gdxPGtFGfiz3l+TOI1OxJnijqoeMF+OiJ/TyaedFizJbRbCbaaD6Sr71DWka74/3zODgxpP2ve47DIwhkiHfWtLj8uC7I5lZElhqE3n2IB9fff71kU0wKTxlKYyiP1WNlyHX4Iom3T649DOfNqLqKHLAMT4ItzcGjQp8+GkBI+p9aLd3U3UbDawQut/6oZTOEH9Mbo1q+7v4Tf5uJTmZsSBY4h7SbuxT+mprT7DviAcJxfN91QJYuablmeZMdhsKGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ukjwwLf5/adg9iZDbDRGkkSNYiNx54R2eigUFNBb9ig=;
 b=cOcTOAYOl9hvXX23OfQnUdJR9lS8JgFDekcXVQOBYSRV6fhMZ1x5RatEscRSZ/GllWh2PPVAsrO2qI34EjwytEp6Z9xkyIyLnsGatOInSwfMObAhj881UerzJCdE/LQag9PMVZ1M9mdQwC0p2levarN6QpgmxoWJOaMARwDeGPG4J6UNvx0p9IHfGlJ8vrjyCgazxdJeQ3og8aEIHEcmMV3rjIIYUi+nZ0gCgV2gLpMEie2GcALoVTA0d9UqbrwSiEJOki+JYq5GWYoVFWJqEsDsvoBvG91X7ixUoyXKqIoeCWLDPZBmZCxOpJClokgKp3xi/6S5Y9SRuY6hBNOn4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ukjwwLf5/adg9iZDbDRGkkSNYiNx54R2eigUFNBb9ig=;
 b=bZEaZyg59DPvk/ZfA4BOa6Lh5lQ5oKYxyCRY6Hzi8hg7KrrEPfRgrFv4KMKHD9sRObqlAG/vbIvpTMntrKd4jfZoClHHgPYbmgtSfFSQZD48JSpzHI6qrvsZTapuZDwWkFdPOzIf88ymmZRG3x8HQ//Zcuu5/fn2kZ5n6SMbJ5o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 IA0PR12MB7650.namprd12.prod.outlook.com (2603:10b6:208:436::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.24; Thu, 25 Jan
 2024 06:08:47 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::9c66:393e:556b:7420]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::9c66:393e:556b:7420%4]) with mapi id 15.20.7228.022; Thu, 25 Jan 2024
 06:08:47 +0000
Message-ID: <8cd3e742-2103-44b4-8ccf-92acda960245@amd.com>
Date: Thu, 25 Jan 2024 11:38:37 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v7 00/16] Add Secure TSC support for SNP guests
To: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, dionnaglaze@google.com, pgonda@google.com,
 seanjc@google.com, pbonzini@redhat.com
References: <20231220151358.2147066-1-nikunj@amd.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20231220151358.2147066-1-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0019.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:97::10) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|IA0PR12MB7650:EE_
X-MS-Office365-Filtering-Correlation-Id: ee213f8f-3bc5-4b51-ab25-08dc1d6c179b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	U0gyMgbYLVG6HOrNRMZuVO7kq3c4AFyxaJTNd8vNcE2IJn2+vomERM1LCC/PF4wrfYfcGq/xljSZOs8VQy/NsAFA+BYV+JlTUaJw2hr9kgsG1T63XDiSVNm3pLkkSHGUIjNXlPvAczLQfDxz4hheqmk/sthekZf+Qn6BvDyrFwqSkgbu/X2b+yVvGR5GdpTS5+tnTYEjvapXaZy8tKIKpbu6ihIFw4pp7MI5iCslW2XKPvDDcN1KzlfA77SoL4n+PVuOpBVHHwnugX1NLQS5qLh5B4rkA2DfL7QYZpBFNNR8hsryRRHQGFVASN1CJFPUqEdFnwx//Ow2oL9uq44/6DkeqTErMkXNqvgn8aERqGuoc44ynzsLFqMk1k+797mhciASGWCFeUzXIW6O025HQaezH7dwl/+zh2BqRAOuAfaV4Oas8EpGypkekfG4QULnEvaZz2vpFrdt+RlF5OfIqIIFxYoFtXkZFKc2j7ds8ibbio+R+DGDB0ISz5GuTXhjlC9Knp1p+Vi6hpS0wXv9YrAltTsBe3i1fjz/xnW2Ghi6Xyh7lOKYyM6k7BUsizhQuqg7Eh9uDu1nvEOHI2kJmSZkHHnErJwR4FcfTSd9d2e3y3WRPIdob3wB7VeWJRsrkzRysVKsEN+Kt1COWrOMuMVEUvKt028A3ygO62e9458=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(346002)(366004)(136003)(39860400002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(31686004)(83380400001)(41300700001)(31696002)(36756003)(38100700002)(26005)(2616005)(6486002)(6512007)(966005)(66476007)(6506007)(66946007)(3450700001)(316002)(6666004)(53546011)(66556008)(478600001)(2906002)(7416002)(8676002)(4326008)(5660300002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OEhSUFpaVGkyZVg5NFEyL1RiaXI2ZmJ2MWhMNGFNT3lpY0xETk1yQmhSSUVN?=
 =?utf-8?B?MzE0eVlYMGZDUWFnWVZKK1NrOUpTdlhiK1p1WW42anhTa0JtTW9Dek4yNGYr?=
 =?utf-8?B?d3BadkFrbGVRaXBmcURBeWRZa0FCVFRvWmpCSGpYNVJlbisyS1EzODNWdUNC?=
 =?utf-8?B?cktRQkpEV2Y1SnRuQzlFUTBLbCtEZHQvZHk5eFhhZXk3K3hPNS96cHM3L3Fh?=
 =?utf-8?B?OWREdU9NZ2ppWURpRTBESkM0bG1GcnpPUnErNWs4ODNFMmhCL0N4MXJGR1NF?=
 =?utf-8?B?cDZNWVFmd0Q3SU1jNkN4ckdpaGtPWVZ5cUZjYmwrZjFqWE1sanJIdnZBODI1?=
 =?utf-8?B?QmUzWVNOZlN2OUFFdk1NOXphdW51ZCs4b0swcnB5bU9DWlhlOFRVNVlGNm1t?=
 =?utf-8?B?S2tlV1BZa3hURWw3VXJXSThnU3h4eUtFd05XZFVDV3pzc3ZJZGNKcDlkNzZt?=
 =?utf-8?B?c1Ezck96M1kvYXIvTDJHbWNRWlc5aEFnT0pOdG5jNWZJYXBRTWpqUFJJWkVJ?=
 =?utf-8?B?Q1ZLNnYzZWFvT09saVg5NEU2T1dzOFFqOUpCditkby9lMzlhaTVweVp0QW1C?=
 =?utf-8?B?c001bkZ2NEw2NXIyNGNldzZBR20xN0tTbVlLTDFkVkZpUDlBODZjUUFMQUFi?=
 =?utf-8?B?M0hJd0hhSnRSc01oWXVwSnAzRG95QjlGcXVGYi83c0tOWnJDeGpHWFB0OXg0?=
 =?utf-8?B?d3F1YWYzSUkyMVBFazJUSVV5M3NzckFOMG52WFlSREEvdEFVU3dMWXJITE1l?=
 =?utf-8?B?bTI2VFNiTUtjWkF0azJVcHhXSlhJMWFzbWphYmsxQU9aS2o4VFpaNm42Y3hq?=
 =?utf-8?B?KzFBS0Rva3cvYkoxaGFzdXplZXQ5RStLZUx6K2x0dTF5ZzBaVVplVUs4SUsx?=
 =?utf-8?B?TFQzeDdEdDFZcUh3RmRObGc5bmwrUnRKZU9YY2tMZDBhRlNDRWx0bjdRUTdG?=
 =?utf-8?B?b2x0bk10eVpYUkQwcERuNm9ITTB1eC9nQjJMT1hvdnJ6dysybWhlMkN6Zy9x?=
 =?utf-8?B?TCtJUTdBQ2orWXRyZEw3SGdOQVY1citrSlV6RXZqRzdNQmQwdnpKem15Y2xo?=
 =?utf-8?B?eVdjUTNSbUFKa1dGVmhiSTBIRXZZeGl0ZTVsWEdFWEMzOUVYYVptOW8vNFBy?=
 =?utf-8?B?NzZtOTNzL08vMHVIK21hak1jTkRSek5NcXQyK0ZTWlRwRXpFWmtYRmhtMW9Y?=
 =?utf-8?B?MzNkZ3NwVVJjSWJONU1iTkRuc0d6Ym1sZ3E1dFdyRm1uMGNFNHAxL2tFVmsw?=
 =?utf-8?B?cTRMSFYwMjlTT3kwNUc5d3FJWUttVGxyVFJLQzc0YWpxNU8xZzdpN05LMDcv?=
 =?utf-8?B?eWVQL1F6QnlhWDA3NktrdjRFbGdsT05lcFBXZy9zNWpPOTdMWWhaNGdZVDBn?=
 =?utf-8?B?V01GdWRDa1JVTjFqaUdrdG4yV1JkWjhlRjdLSzNGU3JFZFVnZEd3SWpzNFRJ?=
 =?utf-8?B?YXVJWFZES2xscDZlRVN3b1ZhTGxUditrOVNpRVlVOThWNTFsN0JmbjZsRVNs?=
 =?utf-8?B?emMyS1J0SlBYWW1uakM4Q05wakNMMlBFMWtHYXlDamR5aFI2S3ZKK2FqaTdH?=
 =?utf-8?B?dmJyNzFiTGl0SlFWeXJrRWtSYjZJcTdGcGlTdDJJenBLSC9BckFkQlQ2aUxD?=
 =?utf-8?B?L3NxdUVqSEIwVFo3bVMraDFKUDQrYXVxQXc4V2JQR3pMOW9UUHJlaksxOHVG?=
 =?utf-8?B?b1M2UVQwMlIzdlJ1Zk42enhmOFErckZhcEVNV0xjd0JwWC8ranYwdzB1ODhX?=
 =?utf-8?B?b3lLc01HeDRzb2Vmdk5Sa0NHOWtrdlVXdUl2cy9xZ0x3S0txSlltR2R1clF3?=
 =?utf-8?B?ZWR2WW9zM2lqdmdZYXJGOUM3QXRZQjVlMWE4dThkRHNEYXpoK0VTSFU1ZTFh?=
 =?utf-8?B?Q1R4Zk9qTTBaeGNpU3B3bGdHWFZVSFpITEE3T0NiOEdHTUd1Ti9qVDdHZGc0?=
 =?utf-8?B?SjAzNGcxTGx5VnNYNm41b1l5QTVPZTAwdmlsbFo3RmNtSjV6ZVBvditjUEEx?=
 =?utf-8?B?Z3IwVEc4TkdGQXF6SlpLU2NHOFpuRzBGZXVmMTcxNkRnVGJ6RDQ4bGtBOW1p?=
 =?utf-8?B?Y2pMWEFYWUdsRWxWeDZ5eWJ4eXduakY2Y0svL3ptbmJnNnJuUnQrTE16Q3R2?=
 =?utf-8?Q?LumDnOG4ZyS60ghUBJqba5A2z?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee213f8f-3bc5-4b51-ab25-08dc1d6c179b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2024 06:08:47.3039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9wWo9ILebCOiFhBfxO2033xHtMTxu1kqWD2+V7mZ3eNT1X9yQr2rW89gatOvmy73F8gI+oAJlw93w++vVA3jBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7650

On 12/20/2023 8:43 PM, Nikunj A Dadhania wrote:
> Secure TSC allows guests to securely use RDTSC/RDTSCP instructions as the
> parameters being used cannot be changed by hypervisor once the guest is
> launched. More details in the AMD64 APM Vol 2, Section "Secure TSC".
> 
> During the boot-up of the secondary cpus, SecureTSC enabled guests need to
> query TSC info from AMD Security Processor. This communication channel is
> encrypted between the AMD Security Processor and the guest, the hypervisor
> is just the conduit to deliver the guest messages to the AMD Security
> Processor. Each message is protected with an AEAD (AES-256 GCM). See "SEV
> Secure Nested Paging Firmware ABI Specification" document (currently at
> https://www.amd.com/system/files/TechDocs/56860.pdf) section "TSC Info"
> 
> Use a minimal GCM library to encrypt/decrypt SNP Guest messages to
> communicate with the AMD Security Processor which is available at early
> boot.
> 
> SEV-guest driver has the implementation for guest and AMD Security
> Processor communication. As the TSC_INFO needs to be initialized during
> early boot before smp cpus are started, move most of the sev-guest driver
> code to kernel/sev.c and provide well defined APIs to the sev-guest driver
> to use the interface to avoid code-duplication.
> 
> Patches:
> 01-08: Preparation and movement of sev-guest driver code
> 09-16: SecureTSC enablement patches.
> 
> Testing SecureTSC
> -----------------
> 
> SecureTSC hypervisor patches based on top of SEV-SNP Guest MEMFD series:
> https://github.com/nikunjad/linux/tree/snp-host-latest-securetsc_v5
> 
> QEMU changes:
> https://github.com/nikunjad/qemu/tree/snp_securetsc_v5
> 
> QEMU commandline SEV-SNP-UPM with SecureTSC:
> 
>   qemu-system-x86_64 -cpu EPYC-Milan-v2,+secure-tsc,+invtsc -smp 4 \
>     -object memory-backend-memfd-private,id=ram1,size=1G,share=true \
>     -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,secure-tsc=on \
>     -machine q35,confidential-guest-support=sev0,memory-backend=ram1,kvm-type=snp \
>     ...
> 
> Changelog:
> ----------
> v7:
> * Drop mutex from the snp_dev and add snp_guest_cmd_{lock,unlock} API
> * Added comments for secrets page failure
> * Added define for maximum supported VMPCK
> * Updated comments why sev_status is used directly instead of
>   cpu_feature_enabled()

A gentle reminder.

Regards
Nikunj


