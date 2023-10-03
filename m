Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 783867B70CB
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 20:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240780AbjJCS1i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 14:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240779AbjJCS1g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 14:27:36 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2063.outbound.protection.outlook.com [40.107.92.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20612BB;
        Tue,  3 Oct 2023 11:27:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CTCHEqSu3RPfv9mstYrkBQIoGjd/kxJOjTgIMe2nDEJb15MBPBGw1sQjytLx12+p7qwmgr2Uynd7kZGw14SJNVM1+a0ysDeFkUxjLfgmP3HZkD1b7PrnZFTBIEZ6x7Crij6XR2OoVCIMU8TuPZNTd1FnBMOsQm/5DMU/LCdNkWDHkFtMpyr6BTzqN5aW14++c5YG7+ail7F7btV25JPWHAgwYqMhrFeKdT7/VmYtIPIO/Cw2dDMAf23v3Lu2Sm5SApuAzLJ5rmaLzzJ7Y4v88kX4TmyERvQ5IprvmD9o84LVDA1ircTTafvwNlSzxQ+Pt+P9XZarHIYxR1cdGQcVng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nl3/eyEKlta8WpveTOZZmzYEJsusCJI1gqdrxd7kOlE=;
 b=IRqOSQzpCHT/7KWVo5Tt8QQCF7RV6qlb3JaA9M4MNl8qDhODrZwUXxb7FJToi5CUE2f2hY0aMrXXHe0lwNapeoZpjnBD/kWEE7hPFW713lfkfFwfbvA8SIyGkyCw1kswzfc5Q1EJsHeJ9+bjJY3KwyVERckmvDZwGVRmbmqiqUPY+f5Il4ZDMJ+QpjLzjRxivZbcvQ6w9TL1Zq0tC/zFH7YNGbduMhhaY+WxrK5gaVNgLxbiXgi6iuJAynNfoTdHRKDAPOVNtarDyoa4EC6P6JHY/+8FVssz5nUPvk0KPf3tPv4mq4NKG3oKYCM5WIIQQGlQyKOlqamWz9RHqBNiqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nl3/eyEKlta8WpveTOZZmzYEJsusCJI1gqdrxd7kOlE=;
 b=QmrKBvLzHFnzCe46Mql0V0GRA/0Aqkh2vJchYRMB1RK7CbfGDIsVwQi0GGa+PIQ1qyUeAd1kFfUrBxT3k2OFZXJPGgYT0dIu9ODRrsCM0IP96G/fRWJOZnkr7lxaQ4PHjrC9R/S6KEWqfElAXS+zuZIYtXQ/xlw3FvwYmp3TjJY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by SJ0PR12MB6928.namprd12.prod.outlook.com (2603:10b6:a03:47a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.25; Tue, 3 Oct
 2023 18:27:27 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::2b54:7ddf:9e2e:751c]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::2b54:7ddf:9e2e:751c%3]) with mapi id 15.20.6838.033; Tue, 3 Oct 2023
 18:27:24 +0000
Message-ID: <a16814ee-28e8-d240-d672-8f9511b832cb@amd.com>
Date:   Tue, 3 Oct 2023 13:27:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] arch/x86: Set XSS while handling #VC intercept for CPUID
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>,
        Jinank Jain <jinankjain@linux.microsoft.com>,
        seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, jinankjain@microsoft.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     wei.liu@kernel.org, tiala@microsoft.com
References: <20231003092835.18974-1-jinankjain@linux.microsoft.com>
 <e7ae2b89-f2c4-e95f-342b-fcf92a2e0ae3@intel.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <e7ae2b89-f2c4-e95f-342b-fcf92a2e0ae3@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0036.namprd13.prod.outlook.com
 (2603:10b6:806:22::11) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|SJ0PR12MB6928:EE_
X-MS-Office365-Filtering-Correlation-Id: 87553730-b2a5-4a8b-61f5-08dbc43e63dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6fntcTkXwntc5pIBKaVwKcC4QESgZhK31pFX+aNUU5KqoARwomD/Kl8/1OILJf1SaIZWT3SAZjfqWx4c82jlXbgRGyP7PxquVWAcnFOMkacUSGLMov+b/XGngXqVsIC0UaaawSJj69Phqs9/OqA0Smnc/usiulZqcmVcR14SvTr0TnbVOMgxZf8Qpgy7Q85MO9XopR/TH33J0Oj0Lj4dblZcYhHZNYrdiRbym+aLJ54pcxthO5hfezfl/pOcP/GOrBpg/jFwfEfAm+hGjUDVuAqvt8fQ13dG4VktlNhceo84Y3CW9qBAuEWc/gXkeAc9hWIM4qpb3dBzcG6yM2y1lGlOevMGL1ZZd865BLsjzDdMam0eQitJXVMO/sKoNH3ncQ+vwUxCOLOTulXIFACkiB6C1PxIQ+47y7oa4kHfM7QcEJ3+Kb/oXcbUjoXBaJoPMYqzADB9gvAeygul314WiSS06GLOj1DGfDqpGQ4/4qjPQI15vC0IzKucKBBLar01c+2cLSKjvuJ88CUnY17iPgfRS5iY+Gc3QJMS3D1YOiVKbg8Wsu5JfY4MTF2lYJha0upivd3JjF39alERCo+SXhCIhEz9eHbPwCq1KeizIN8LdPeg8V77ThzRHYb+d6B9pTZ0VZoKDGS1Mw/R/0B5QZEynP7UIFCmNboHWzfjsU0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(39860400002)(346002)(376002)(136003)(230922051799003)(186009)(64100799003)(451199024)(1800799009)(2906002)(83380400001)(66899024)(7416002)(31696002)(86362001)(36756003)(921005)(38100700002)(316002)(53546011)(66946007)(66476007)(66556008)(6512007)(6506007)(110136005)(41300700001)(2616005)(6486002)(478600001)(31686004)(4326008)(8676002)(5660300002)(26005)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THR1d3k5UlBVUWNOWDZ3T04wa1JkbmNLZDdWaFNQdFlmM1dIQzFUOG0zQ1RD?=
 =?utf-8?B?eklyYXlPQ3ZhQ1lPQkZhNUxHbjgzVVR0dThTNmpTS2tQa251K0piUGsyYzUv?=
 =?utf-8?B?RGo4NVcyMEdPa2I4T2RsY3JWemtabHh1UTlTaVprcjlMYUI2K3YwWDhuWjli?=
 =?utf-8?B?Y25uRFRDVUY2NkxTY2RseGZOMFNUdEZRVjA4LzVqVWlFdnp0ckI3OW85bkhT?=
 =?utf-8?B?S1N5N2MwNDdjQUdGZXNrUFFRQVhURzlzTDJvNFJEY29hS3hDUmlnL0lWZ3l3?=
 =?utf-8?B?TzAxYzVrQU12ZTRPQ1RKK0tnMzhJcUpIeTJVSFpsNis1ZDloWFlTQUcyL2d5?=
 =?utf-8?B?ZVBiTGxKcGoyOUNxUW5CWlNtbCt5eTk4dlBMSVNPZERNcWVyaVN5U2RaS2pG?=
 =?utf-8?B?cXNxR2RySXh2V045SDNHdUkwMUQyQ2xid0VHa2tLbzRodmlIRllkRmdHbWMx?=
 =?utf-8?B?NFppOW9IY0RNUmxTclFjclAxaTBhWUI0b2FUZ2lMK3BOYlIxbkZWcis2a1Bu?=
 =?utf-8?B?NUU5OTBuR01yazR4WnhicFN2d2Y3cVZJOGVNUi8wK2FMSHB5R1dBczBSSktZ?=
 =?utf-8?B?R0xYOXRROUZtbGFNOTJ1SytWYU5SMWcwYnM5dWRheUhSQytsS2pDRDVSY0l2?=
 =?utf-8?B?bU5mUDhDcUF3Q3pZbGpQNVFFVXJwYzdMbVNPNWZKQW8wSlZKRmh0dVArWEI3?=
 =?utf-8?B?UFNTVXJjSnYzZm9ua0djUzN3VmpIVnJrSjVUWEw2TUpCZHFSTzV6ZExkQXhL?=
 =?utf-8?B?SHN3c3BLdGtGeWh0clUrWWVRRzhjcEtxWmhZWUFUdHVlWGkyQUZhWU5CR1Zm?=
 =?utf-8?B?SmNwcGxqL3pidkYxeEVHK2h3bDlMQnJDMjBib1BMTFVYYi9uNWZHOEZHclpS?=
 =?utf-8?B?eW02U0lxZnR1VFlTZ3RCcHZTTExPWTNDbGdOQXBJOXF5dkVWMjMyc0tKbDRi?=
 =?utf-8?B?MGdFME45RVRoeGg1UXhERnhkWGxiODM2R21VVnVpWExSd3EwbTRlMERKTXhB?=
 =?utf-8?B?QkpwUWlNUGtWN0Y4UnRJMGpDTkloRmJmR1ZVcjNXY3UvOFBheElDVExWM3Bw?=
 =?utf-8?B?Tk8vZ1F3a21qRERuekdKVXo5SXkzcGh6QzVXaGt6MzhXbjl2TU52Ny8rcTc2?=
 =?utf-8?B?QkxsamNJeHU4Z2JZSnlvaXBSZnVKWWt2QmYrSTVOVzI3eFM4Mm81Q01HWnhw?=
 =?utf-8?B?emc2a1o5ZXI3aVpIcG5FT0ZiYjNSREZzNWtzcnZaQUUwbVd6NkE5RFNQUTJn?=
 =?utf-8?B?bytNYTJydDNHUDVLZkRlTlFaOHlSZUVua0ZZaGVVbyswb1hiMGZFUHhlMWRK?=
 =?utf-8?B?MlRyMUhtUVdrZDhkcjJIK0hQazBiRGZvcGRJTWdMOXcwOEE3V0dYZkFXQzJ5?=
 =?utf-8?B?bElxUkcxeEV4UHkvM3N2NllVV3N0WkRFTFhZM2lVVUpzMm9IQ21pSlQvREFu?=
 =?utf-8?B?bndyNnVDbHFQRVJ6ZWwyV0FWWUJSc3FKYklBaE5TcHBtVWZhVldEaFRLSW1V?=
 =?utf-8?B?VUNpTHFEOXlzVmRKT3VrTkFtZW04akYxSkdLeEZWbjJVckRlQXlaK3NvWncy?=
 =?utf-8?B?bis0Q0FrN3NCb0lpaWNYZ0ZILy82Q3paV3BXU0NCazUvOC9RRDhxcjU4ZU51?=
 =?utf-8?B?NElDdHprbGE0OFN6ZWZoS2pUcUppeGp6NzJRNVlVUVdIL2R3aWtzSnhDeUx4?=
 =?utf-8?B?dnZ3UTd3NWtsYVVkRTg5Ylh6RTFWSW0zMlUzSldvZ0lhMXBGd3YyTWxrVWZ6?=
 =?utf-8?B?RFdYcHJkVmNDK0RicmlYY3Q5NEVyWjRoRU51aE4rbEpVdEpXQWZUOU9IdHU3?=
 =?utf-8?B?Y3pGclBuSGYxTjE3cGtyT2huTS9SK3ZMbGRUMG1Uc1d3cGV0aC95dkpnU1hm?=
 =?utf-8?B?ZTJaalFMNnJsb1NFVjhMOG5UejZ5UytyWjVMQ2E3Q2dka2VMbU9pWGw3Y1Ew?=
 =?utf-8?B?RFFQUURjV1ZWcW12OWJOZTMxT1QyR1AzaXhhS2lVS0k3S2ZpeVAvbHppN294?=
 =?utf-8?B?dHRUTDd3UitUYlRCOFQ4RlN3bkgwK3FueUw2cjE3Z2ZlMTVENkYyK2Y1OWVp?=
 =?utf-8?B?blBObUJYWEFpUzFVTnl4QksrMllsTmYrWElnMHRXcFdFR3Z2cUFtNW5ReURr?=
 =?utf-8?Q?j3WMpCcEI3YvPro9IGhUxSPly?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87553730-b2a5-4a8b-61f5-08dbc43e63dc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2023 18:27:24.8177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jzr40/IetPwI3962pWcQSFz2Y92suFZeMEkjkGHNQD9HmRYge61hdM/AmxqlKj94Q5KCgoufJpk0P3EZTKfiQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6928
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/3/23 11:07, Dave Hansen wrote:
> On 10/3/23 02:28, Jinank Jain wrote:
> ...
>> diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
>> index 2eabccde94fb..92350a24848c 100644
>> --- a/arch/x86/kernel/sev-shared.c
>> +++ b/arch/x86/kernel/sev-shared.c
>> @@ -880,6 +880,9 @@ static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
>>   	if (snp_cpuid_ret != -EOPNOTSUPP)
>>   		return ES_VMM_ERROR;
>>   
>> +	if (regs->ax == 0xD && regs->cx == 0x1)
>> +		ghcb_set_xss(ghcb, 0);
> 
> The spec talks about leaf 0xD, but not the subleaf:
> 
>> XSS is only required to besupplied when a request forCPUID 0000_000D
>> is made andthe guest supports the XSS MSR(0x0000_0DA0).
> Why restrict this to subleaf (regx->cx) 1?

Today, only subleaf 1 deals with XSS, but we could do just what you say 
and set it for any 0xD subleaf to be safe.

> 
> Second, XCR0 is being supplied regardless of the CPUID leaf.  Why should
> XSS be restricted to 0xD while XCR0 is universally supplied?

XCR0 is really only required for 0xD, I'm not sure why it is being setting 
all the time (unless similar to above, it becomes required for some other 
CPUID leaf in the future?)

> 
> Third, why is it OK to supply a garbage (0) value?  If the GHCB field is
> required it's surely because the host *NEEDS* the value to do something.
>   Won't a garbage value potentially confuse the host?

Ideally, the guest should be checking if XSAVES is enabled, which requires 
checking CPUID leaf 0xD, subleaf 1. So a bit of a chicken and egg thing 
going on the very first time. And then the guest should read MSR_IA32_XSS 
to get the actual value. This MSR is virtualized, so the hypervisor needs 
to not intercept access in order for the guest to actually set/get a 
value. Today, KVM/SVM doesn't support that since XSS is used (mainly/only) 
for shadow stack and KVM shadow stack support is only getting looked at now.

So the guest support for XSS and ES/SNP guests needs to be thought out a 
bit more.

Thanks,
Tom

> 
