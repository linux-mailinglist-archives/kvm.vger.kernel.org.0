Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE16426E06
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 17:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243123AbhJHPsw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 11:48:52 -0400
Received: from mail-bn8nam12on2044.outbound.protection.outlook.com ([40.107.237.44]:33387
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243073AbhJHPst (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 11:48:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iXUZxnBf71QKW7AMgdj1ls4RCJ8Cg8lXqTo1zakPsltiH60nyKK8X4KMkTccX6c2kFVoSZnEcLZOsBDXtaQHtwxAMo+FgMsCbPTdrOuDNcDxgGvnbm7BVnCzrB2EaM1S/o2ccNRlJ5AS7f1gqhzDlbH/Zmn9C0pIa64+y6VRrSkqF9PGOveysgNrvTHcx3kWNwPc6UoBaII9uy3OuQ7DXNgQSj1N64Q/22HakXu9BTy8axIVBiQoUpMeOe3Tvwq4n1drDLvo1QVTs3w+pj3cTiSz790+pxcP1kvz+ny2Bw/i2Gd79BdgSVHQwCZhfgC9Z7gEZU7Ng0xg1mL2GlzYgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GgDmcdgz4VZE6hThyp/Yd28EgOnuOqLEzYXjG5zi61s=;
 b=TgiUd9xgCGqkKXbyM24JPF1XRbEFN2sgfmO/XqsFbPfLqPOnzKwExEUljLT+6QCQVPmeQ6ckf0oBslZlY1HwfU8b52CO+O96vRlWRj7Zu6R+4dTFXuok2107IAfSqm5z7oRXJ2J8nkgrTGRGZBQd9wGQR6UezhfRhZYq4EqXVhK0y7/QcApsKwGOXr0AKZiz+Zx2H+BpYZCIzx3TsLTSFnDD8CGfbX0ya0wPiPZAt1e5CQi+WVDyqSJqZkLLfPsSZvyzlZ0xMfJVIRUf7ZTcK3BwKHfL4GL0h8caLn1E2iwsI4F5BNvk081DnO7VQCbwKj0z++PnYYw69t+Jg2Z7OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GgDmcdgz4VZE6hThyp/Yd28EgOnuOqLEzYXjG5zi61s=;
 b=pNvhpbxf5tjnim9Uvd5NFzPCknrXyxdNm48fg+V1fuo5f1GwSXPH6xyob3d/2iyxHLfJ2RdAaX0y1hl876VhH75kWgqNRdw5pVlQQfyZiGt7SnQpOXZYJeK9OM/tKMN4RqGTJ2Hu7m5jPFSlyGihj9beD8mC7rZy0oXjo/esNwM=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2448.namprd12.prod.outlook.com (2603:10b6:802:28::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Fri, 8 Oct
 2021 15:46:50 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4587.022; Fri, 8 Oct 2021
 15:46:50 +0000
Cc:     brijesh.singh@amd.com, kvm@vger.kernel.org,
        Sergio Lopez <slp@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        "Daniel P . Berrange" <berrange@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [PATCH v3 13/22] target/i386/sev: Remove stubs by using code
 elision
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org
References: <20211002125317.3418648-1-philmd@redhat.com>
 <20211002125317.3418648-14-philmd@redhat.com>
 <84e1213b-c6c0-85a4-0d3e-854cd3dc0fa0@redhat.com>
 <6a6629d7-2441-1711-d181-8b2b2127dd21@redhat.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <bdd96643-45f4-e00e-17ad-16be6ad160f7@amd.com>
Date:   Fri, 8 Oct 2021 10:46:48 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <6a6629d7-2441-1711-d181-8b2b2127dd21@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: SA9P221CA0027.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::32) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from Brijeshs-MacBook-Pro.local (165.204.77.11) by SA9P221CA0027.NAMP221.PROD.OUTLOOK.COM (2603:10b6:806:25::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Fri, 8 Oct 2021 15:46:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08a8ace3-059d-431c-acc6-08d98a72d821
X-MS-TrafficTypeDiagnostic: SN1PR12MB2448:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2448565296D48E82B1FBEABAE5B29@SN1PR12MB2448.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PpDnKWqn/vixftadbg57UhTj6WIcREIoJSMLI82G1b8UZ2gPZkYc/pS2IyvtvI2f4T8FAOuzv07FVXi+WoIs59xtlVfWidENlueNNA8tVS0UUkOOEPqvcrZR1eabNLNjL38mQnEA0JVGriKrlhBVv++GkL3hZga2yZITn/HgqYf32sBzkRrCz8qMQxiBb1PZhnetOYcOoVSTg7EYVoSOs2S8BLzNjbWraZMq4/qIAnSHn6w2TlH7wraWVWp9LzdBak6DzAF5+IqgZ/7as+/3FRN4VVYMkMO00hpSbhB2xM8hVu2RC1t9iz7/mWOlUCosMDiAgtXi9dcBbmkzcnKuVgE/BLID8fJMykuna/K6A3cJ7XHPCZCM2TbUwC22u7Noa+paNHOauCuo7GSTx2I7QWIZM0bo+uJU3gcP7R9sZw9wNsqQiyWo05s0wVOnKUnOzZeCMTKzB2iBo64mfMRgisPV1A9R3aExxenSSkvj1EYL+xZ3r1TXhtC3vG/yJZMDN9WaT3zXVthJnh0VpNfN04zLWbGPt8Csg7zD3QeXzxANDZHYc19insyCGKT0CdkD+UyDolhDmz/jqD/jhSjl4YVH4hbIV8YzHbaZvLSUuPzPOVmUPof8lz6DYF9wckJChvcqv2mb7sDAmJFWx3N5K5cmmGemUTYXGlN4VjQCUH6dt2/JiaVDdWxVVzcTKUSYAt69AkA2n9kpOmIQtmf/IgRHpf0xzb+JhhuxkYfWCT2fjMC7ZhbYSyLklqOGepze
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(110136005)(54906003)(31686004)(7416002)(6506007)(66946007)(53546011)(44832011)(66556008)(86362001)(66476007)(31696002)(316002)(2616005)(956004)(26005)(186003)(83380400001)(38100700002)(8676002)(6486002)(2906002)(5660300002)(6512007)(36756003)(4326008)(508600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SU1LbE92WlVtaEFmemQ0eU8rLzhCckR5Wll0VUFzcDNETlczcDJwK0QrRDBi?=
 =?utf-8?B?M25FdzVCNzdFWCsvdnZRUHNTUzBoWHU0U1czNXdUb1pFbTBncVFDakN6TzBD?=
 =?utf-8?B?eG1Wb2s2NnZzZmUzbnFkc2pyMHRDcXBSK0EzUGRJWkY5MWhFUkc4ejBncGow?=
 =?utf-8?B?djFnTllFaHQvR2ZZR2gwcytXWVREc0dvZHFjdFVEY0tWelU4OURZR0IrVGRh?=
 =?utf-8?B?djVadFFIQldveGd2eWRjcHRndTdVaHk1S09VZVlGSEs2VDNudWQraEo4NXlR?=
 =?utf-8?B?OUxTcUJuM0FmbTNZSmE0T1EydS83SnRNWjNES20yVXhPbkZPMmJicUtZUVY5?=
 =?utf-8?B?dE8rNWNCWHFpd0MxNWpHeVp4UnJWS3ZhRG9xb2FjS1hxWWtKZy9waThpL3Fh?=
 =?utf-8?B?bzROMjlteEdhZUFYRHZQYmY2NEFZcTY4UjI5WU41bDg1TUZYU3ZYWmJZbDE5?=
 =?utf-8?B?UFI4OWk4TUxkTXY3Q1pPVmRvTWtxYmEvcEoxNVFrVGt6bUtTY2plR2RqUzdv?=
 =?utf-8?B?T3d6a3RjT2diUVlkSmQ5SVRZOXMyOFRtZ2VTL045TmNsYy9XTXBwcjZEbEJO?=
 =?utf-8?B?K0VkOURHYVRHcGlMSVNZbHRKSFRYNVVXb1g3N0pBbjVORjN6UnhueHRzZ1hK?=
 =?utf-8?B?N2xxMGhXaXlGZ095ek1JbXFOOUNhSUVkcU9jNzR1QnZrU1NpUmZqd2NEemdQ?=
 =?utf-8?B?QWlVREdhOTA4M2N0TUl0QUUyczkvSkJZbXgrRHd4SjJMM0V3ZGN4aTJadVZR?=
 =?utf-8?B?cXdVZ08xemVOTEhoaFVZWUtHb3NYNHZEeWFMMkgzeXB6T3lNRjVFSnlOaEha?=
 =?utf-8?B?N0orSDlsYVhEZzhjcFNGRktnMmwxbUhRZ1FPMnVzVFNLTHd4eG5Hb0Y4MHhI?=
 =?utf-8?B?Q25UWEE0S3dxMnBlMTBhdjVIL3VZamppNEhCNk9SY3RMQUZlWjJJUnRlaW5M?=
 =?utf-8?B?VXIxckFvTWkrVTdOMjE0Mi9xaEEwUzhZRU5HRkN0NVRxUW13VGVkL1NkamFD?=
 =?utf-8?B?NG84UDlyZjlEakZJejY2QTYvR1NiSUJ2dlJ0SGhhS0hCdnUzMng3NHNyVk1M?=
 =?utf-8?B?SzYvM1JyMXlFalB6K3hKQTBwNm9iREtGTHlnYVZHRFg4ZWJTSGtqQVBFR0tv?=
 =?utf-8?B?MGJPV1dhVUNrTENDZ3BZWXFaYjA3cWVqSkd3dTE3Q2VVK0pmK3VudzZMRmpK?=
 =?utf-8?B?bGJqVTRnb2QrakRKdXhpQTR6OUY4Q2JsVVhiN0FRaXdSdElYY3FvRmp4MDVD?=
 =?utf-8?B?NVY5RWdqQkpvbHIyb2hOQ1dwYnJMM3FnYVN4cDUzNTdQRVVzSHE1ZERrWWh6?=
 =?utf-8?B?NUREajlLdndHbjBCVHhMcmJXbmJwbXVzcWk2QzJhUU1yU3JlamtkQ1BxM3kx?=
 =?utf-8?B?bHdsK2RzY1V2UFZETXpKOFFETVdXVnpIY1ZFeDYxUW9YT0dUT3M2VVZNd1ZT?=
 =?utf-8?B?M1NEbFpYcjFETjdTa3ZpTUcyaTZBT3l5RWlWeWpnTStGUVdNcUsyenN5c0hM?=
 =?utf-8?B?NmVRN1haWkN2VlAwZW93Y3RZdzRsYTVpcUI0aWZyRkttaXFJZXdrekk3c3Rz?=
 =?utf-8?B?UFJ0YkRQb1RaSGhxeFhKMHVjZ3Y4ODc4NkdkeFQxczlCcXZsQVJTVzdnT2sx?=
 =?utf-8?B?NkFlQlRkM2ZJYnNVeXR1ZDgxL2dsdnNITFEzYUh0RzJGTTYvdkFKT3hqT3hD?=
 =?utf-8?B?WFV3OVhvL1FscG1UK1ZEZlBzakxCNXFxMjVUOGd4bGlucW51Y0c2bmRyeGtu?=
 =?utf-8?Q?fvO+IDtV8kUQnId2Ka8FeOWPoBviMSiY3BD0P+s?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08a8ace3-059d-431c-acc6-08d98a72d821
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 15:46:50.8705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bXrGxVkq2GMRQITU7slGB7DoOMf3iLHup3b+6TBmAzIrWSOSav8gdRBJbm2Xa1GqY+Y3P79oien7kzgA5giJDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2448
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/6/21 11:55 AM, Philippe Mathieu-Daudé wrote:
> On 10/4/21 10:19, Paolo Bonzini wrote:
>> On 02/10/21 14:53, Philippe Mathieu-Daudé wrote:
>>> Only declare sev_enabled() and sev_es_enabled() when CONFIG_SEV is
>>> set, to allow the compiler to elide unused code. Remove unnecessary
>>> stubs.
>>>
>>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>>> ---
>>>   include/sysemu/sev.h    | 14 +++++++++++++-
>>>   target/i386/sev_i386.h  |  3 ---
>>>   target/i386/cpu.c       | 16 +++++++++-------
>>>   target/i386/sev-stub.c  | 36 ------------------------------------
>>>   target/i386/meson.build |  2 +-
>>>   5 files changed, 23 insertions(+), 48 deletions(-)
>>>   delete mode 100644 target/i386/sev-stub.c
>>>
>>> diff --git a/include/sysemu/sev.h b/include/sysemu/sev.h
>>> index a329ed75c1c..f5c625bb3b3 100644
>>> --- a/include/sysemu/sev.h
>>> +++ b/include/sysemu/sev.h
>>> @@ -14,9 +14,21 @@
>>>   #ifndef QEMU_SEV_H
>>>   #define QEMU_SEV_H
>>>   -#include "sysemu/kvm.h"
>>> +#ifndef CONFIG_USER_ONLY
>>> +#include CONFIG_DEVICES /* CONFIG_SEV */
>>> +#endif
>>>   +#ifdef CONFIG_SEV
>>>   bool sev_enabled(void);
>>> +bool sev_es_enabled(void);
>>> +#else
>>> +#define sev_enabled() 0
>>> +#define sev_es_enabled() 0
>>> +#endif
>> This means that sev.h can only be included from target-specific files.
>>
>> An alternative could be:
>>
>> #ifdef NEED_CPU_H
>> # include CONFIG_DEVICES
> <command-line>: fatal error: x86_64-linux-user-config-devices.h: No such
> file or directory
>
>> #endif
>>
>> #if defined NEED_CPU_H && !defined CONFIG_SEV
>> # define sev_enabled() 0
>> # define sev_es_enabled() 0
>> #else
>> bool sev_enabled(void);
>> bool sev_es_enabled(void);
>> #endif
>>
>> ... but in fact sysemu/sev.h _is_ only used from x86-specific files. So
>> should it be moved to include/hw/i386, and even merged with
>> target/i386/sev_i386.h?  Do we need two files?
> No clue, I don't think we need. Brijesh?


Sorry for the late reply, we do not need two files and it can be easily
merged.

thanks
