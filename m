Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7361254E82F
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 18:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241355AbiFPQ6y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 12:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345057AbiFPQ6u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 12:58:50 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9073B546;
        Thu, 16 Jun 2022 09:58:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dTEM4LG1UVjbFQQO0ekctctr1sQg6AgpO6WwWJjyRGXyXLHooFWz7VxQsn5Y/3P3iefgNMgoPjuD6RxcnPrBzBOUWFj9IVuWOFaXYDKmoHS9yMfCMriJttdr6iZF0NFdqV/R6OgrEfuvHEQu2ZrJ+cIfXzwbz0COGeZTKf9nFCSxq5gD6cKX/wrqMDgVLXmJtNbYg4aDsLel8eCwSOw5imCFX/CgnFTsX/59x/uEMdKaMyYDPQb4wOkC1x+doDC8fo2kyH5QIBd5P3lYvsayrazL1qpok85Xt7CqknxSujdjNLnGBLcMGWFNTO6iF6iv2MQRdJpmltozb/+qBdRL2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=624zNFanFXZLwD9Y7k5Su5NEQKeVxbGF0MfpFYCC2ME=;
 b=hfeuqz9MEP/JM3mtUI8hd1j/o8FcQc3a1hGPFsGMcXfaA+PVci2WXzEPn5K2kKmMMNlvaw+cHEbTutBdDep0PoPtXDwFOz35OQojRTg5B3zg7HmCL84hAg4W5feZDdBvLgxgj9+uuYCgGkvIutL3hQF+Wi51vfikiAKafv8c7DWS9QIVixmAS8UZ6bd/VHAssOUnrZ6E2+cm19PXCtwwoSwuRYAw2WvDBDDQ4901tiejcHXsxnOka1J8Z1Jkd6hDKsN7Xjs3jY8MT7Og7i7g1yIVg3IannRtmotQb5NAvqFweUOjESyfRuCKGV5doSszVXyowMOLTryqJFmAY1P1RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=624zNFanFXZLwD9Y7k5Su5NEQKeVxbGF0MfpFYCC2ME=;
 b=btKK+X15UMCF8SboDKgIfmMFI6nuwanX9V0NI+uz1h1H4e2c19YJWTC93UEu89kAFVzqI0OZpPxQpNQpzOeyuKH0BPv4DtJ63oSUa816XizkAn2cyDnRuB68XVVZNOStGoYP8ep2AAuY4Aj9ZdlEgVKeB1Slli0sk2Y80q92RPs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by BN7PR12MB2658.namprd12.prod.outlook.com (2603:10b6:408:25::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Thu, 16 Jun
 2022 16:58:47 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::3839:4183:6783:b1d1]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::3839:4183:6783:b1d1%6]) with mapi id 15.20.5332.022; Thu, 16 Jun 2022
 16:58:47 +0000
Message-ID: <2201fe5f-5bd8-baaf-aad5-eaaea2f1e20e@amd.com>
Date:   Thu, 16 Jun 2022 11:58:42 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 1/2] x86: notify hypervisor about guest entering s2idle
 state
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, Dmytro Maluka <dmy@semihalf.com>,
        Zide Chen <zide.chen@intel.corp-partner.google.com>,
        Peter Fang <peter.fang@intel.corp-partner.google.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sachi King <nakato@nakato.io>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Dunn <daviddunn@google.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:ACPI" <linux-acpi@vger.kernel.org>,
        "open list:HIBERNATION (aka Software Suspend, aka swsusp)" 
        <linux-pm@vger.kernel.org>, Dominik Behr <dbehr@google.com>,
        Dmitry Torokhov <dtor@google.com>
References: <20220609110337.1238762-1-jaz@semihalf.com>
 <20220609110337.1238762-2-jaz@semihalf.com> <YqIJ8HtdqnoVzfQD@google.com>
 <CAH76GKNRDXAyGYvs2ji5Phu=5YPW8+SV8-6TLjizBRzTCnEROg@mail.gmail.com>
 <YqNVYz4+yVbWnmNv@google.com>
 <CAH76GKNSfaHwpy46r1WWTVgnsuijqcHe=H5nvUTUUs1UbdZvkQ@mail.gmail.com>
 <Yqtez/J540yD7VdD@google.com>
From:   "Limonciello, Mario" <mario.limonciello@amd.com>
In-Reply-To: <Yqtez/J540yD7VdD@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR19CA0025.namprd19.prod.outlook.com
 (2603:10b6:610:4d::35) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6139956b-efd3-4cc0-a2bf-08da4fb97a7d
X-MS-TrafficTypeDiagnostic: BN7PR12MB2658:EE_
X-Microsoft-Antispam-PRVS: <BN7PR12MB2658F227A148869D2E608E0CE2AC9@BN7PR12MB2658.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i+BiIN1RVpBeeHY2oLMX2nqh9IezcdoMYbBm/ihThdF/puY4DOrFdDdYkRTZ8b3v51ED9IlYYRyZcegV8W8zEh3YevZlzK4Eviq4ssVk+gquxUdRRVcfVu1bfsiQE4GmNrfZTW5I7mdekkYnv3reegCJqKqQ6V90tcMq2SsgOfsRrzLjjcDIckTECXtB9dgugZVVgmn+fbHk1vSYMsMwLboqYriowCm71BZ5JQrHYDhoA+5r0ldvDe1d3XyLyRmkuR9BAi2+c8pUc3PWfF6t04n9c95jK9/FFkeWZYOvk/c9sYGCdPDu2WcW3Eixqav3EP1efNuF1xn66L2KXrdh+YlESy7ygJHCirSx+rFKVh27UCnGGZbQAPK0q0W0PADWVitAJy4nOpzzZLxAAJqHP8ppD+u7EcJ9jDsvAqYOjO6e3odJBgNq0F5FbS/nIV7NAzfoiJRJHGwHPt13mUwe3tYUh77JCfV8ZsbQzN9b3eTXDkkh7FpMmE3wOMuYM0A1x4telgSLjLJdduUmQXsHRZcKSAGo0vPIgG5j74eygyoAU3WsFLaZ7bz13hQ5iw9qJU+VYidElhnIfedL02Temriy0Z/pIsooHExEbN2IC7vm4ZNqw9nyLJk/nLv6Kfyvz4pDr/eUhkNwMpcC27Urs4GCEkPolkiwxIHmuokItznawoBrPwTrCPhMVd9fAZk/qOVfTjBXYima6uzOKNjIU9liUJqO7apCpVM2JkEj2dFICEl1JP9K+wr9AOGjS8PG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(31686004)(86362001)(36756003)(8676002)(4326008)(8936002)(7406005)(5660300002)(6486002)(508600001)(66476007)(7416002)(66946007)(110136005)(316002)(2906002)(54906003)(6506007)(2616005)(66556008)(26005)(186003)(31696002)(6666004)(53546011)(45080400002)(38100700002)(83380400001)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OUtaVStqWUZiWnVScEdUZ0M5VTVsdXVGbWJVb3NoZFE0aHdLUkM3S1p1dDMy?=
 =?utf-8?B?SGZlY3kzQ3VQeXhpMm1oWlMvOWJ1bXVsdU9PaFpWa3ozTFN2WS9JV01EV296?=
 =?utf-8?B?N0JBcUF0YmJ4WVEwWGI2ejhFZWtnVSs0R2U1WEJNZTJCVUxodFdadkJyaUVI?=
 =?utf-8?B?MEV2bW4raDc3NGh0YWI4SmNKV0RySGhNWGR5eE9SRkVCS1ZVbS9qQTBGT0xz?=
 =?utf-8?B?ZnpJSlZIZytsaG5aR3BURGsra3JhVFZvVnkya3lBWXcrdVgrZThrVVlCN0dK?=
 =?utf-8?B?N0NWUWlYeGtYMGJNWnFOR2ZGdmQzc2k1WGhYamxRaXF5V1d3WHBmbjJISGNm?=
 =?utf-8?B?aGxvbmMrYyttbE9kMERwb0lCQlNvVUpadndmYU5RVkNtUXNPOGRxTklUYnVP?=
 =?utf-8?B?ZUNrUTJTOVB1UFFDY1pDa0tiOE81QkZDU2xucmw1bGV3TENWZ200NERWbXVn?=
 =?utf-8?B?TkptOHBncGp5dkRRMTl0NFR4UlFaekt1Z2J6SkhPTGxHcVlXRENDai9BalZH?=
 =?utf-8?B?bmJvR1BsV3FzZ1JKYjBlaG5RWVBINXQvT2NCWUJQNGpWemhRV3RlSXh6NUNh?=
 =?utf-8?B?R2x4andlK05SZTQ2OE1FNElDRWhyWFUrTS96OHo3MlpSRHhKWktjOVg3bEh2?=
 =?utf-8?B?bkw1RzVTaUxpTEhDOC9DaUU4c08wcEd3MW5lZXFWRDlWMkNnOUo4WjBZR1lj?=
 =?utf-8?B?SGh4YXFzUEsyd3pnOTBXSXlTMU5HK2xzNTdFUTlWS3lzNVRuYlJuSVNlKzd1?=
 =?utf-8?B?ZXBhMTNySmJ5OCtmQzBmaWlRL1RLODdCUDczQXJXNXhHYmppR1FJa1pJTzZO?=
 =?utf-8?B?L1I3dGFGc0NXSUFSSVZVWW0vVEQ2SGg4YWVZZitxLzJvOVZmWGlLbXJyUW4y?=
 =?utf-8?B?UUlaaG12SVlWbXBqMzlqOFYwNm5jUUhWQXBaZ1lPaWlEbEtlN3VNbmszWE9K?=
 =?utf-8?B?MFIydEhYNEt6bHZIZ2dMcGw1RjE0cE04NVgxbFdkTUE2djZIZEJyTTdaYXdI?=
 =?utf-8?B?eE9UeG5xbEZSN0R6RnRyR1dUT0E1WW96TXdCVjVsOG5QMGtNTlZCbjUvejBo?=
 =?utf-8?B?OVkwNjUvSy8xVDQ3YkN3MG9sZ0x6TEQ5ZDBIdjhTck9UajNUVUJ6ZkFYY2Vk?=
 =?utf-8?B?RjA1NlBPMzJBOTRLZktGbTJoanVWUWdkaXlDUWlIb1p6cEwzT2ExTTBNNmtW?=
 =?utf-8?B?UmdNL2k3aFJyUDF3bGZ5L3huNXFzNFo4QUcyWnFOdXROVWpvbFhBS2E3SFlr?=
 =?utf-8?B?MXFaZmdaTzB0T2VySm9Jd3owZlhQRlpPR3RYQlBwRWNvUGEvWGJHNTFHWlc1?=
 =?utf-8?B?U2pNOHRPNW01dUY4SGZnNVVhd0RNaE0yMU1sVG9ua0lLKy84RlhZNW9zZEVP?=
 =?utf-8?B?RjV4SVVKWGlkL0RjaVZpcXE3VFJRREFxVlJtYXpGTStSTkFyajVHamN6NFFs?=
 =?utf-8?B?Mit0Sy9HOGIzbCtBUXZJU0JENEN5VmpDT2UxNVNTWXdwNkw2UkJEYXVNRFUx?=
 =?utf-8?B?Sm91NEpic2tCS0U5MHQveEEvNncwNXJiMG4xSXhFdEh2QlBtbWltaGVkMWZV?=
 =?utf-8?B?bEpucEVmK3dHZTd4cFBxNDM1YTY2U2NteHdUQW1XeS9YTXVoMVREdlc1VVQ5?=
 =?utf-8?B?a1M1RHBQTENZN3hQOVBSSW9kZGVpaHNpcngvVzNkeGZmOHNvZ2VUNUhwa0do?=
 =?utf-8?B?ZFhhcGE3Y1p3bEN4UG9aNTZCbjlEL1ZCOW9ML0hDQjZQWVVNZzdDTEVQbk9x?=
 =?utf-8?B?QnhVNGFDUjlTemlNUXRmWnV6ODljSkhKdE5qUmllZ3BCQTVFdm1zV2tycFo0?=
 =?utf-8?B?OE4xMU1wOWVCNDZPdUsvbjgrSENnamR0SHR4eHZua25EZVJZazg1T0dLeFFO?=
 =?utf-8?B?cTRpaW5iMFdzL2F5Z0d6QlFMVTFFdU9TNDNpVGpEUFg4c0krT3lpbi92b0hF?=
 =?utf-8?B?T3pXcUZvSXR2TDJTdkFxWE9vTm9FTUN6OEZpYUplU3JqRjE5Z2dIUUFwMTM4?=
 =?utf-8?B?eWY0OEYyNlpCYUVLaDhxTHRMUTJDcDJjRkxsbzAxaWNLN1FUdFc3S2RLS2dT?=
 =?utf-8?B?RzFrWEQ0YUlRY3FGY21lN2pyeFFibDZ5aDErU0hMTGJzazhRcVpDd1JlSExa?=
 =?utf-8?B?ZU51ZVcrRFZYYjJvc25GQ3hhNkU3Nkd4TndYZ0c2bjZPMUU0QUtJMVp5YXpR?=
 =?utf-8?B?VUpVSC9UZjA0WC9CTW0xQWxOQ2NoNnMrQXFlTDlNVFZ6WkVFdldnSWVaSkZO?=
 =?utf-8?B?V2dQN29HSlJpeHRQaHgvS0ZFTzJ4czBVZ2VqY3dFQkduUzFzUndBTElZZDI4?=
 =?utf-8?B?blNFZlFUekZCMEdGNWFLb0VKajFjK3ZlRUJFOEQ0S1hubHhSTDhBUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6139956b-efd3-4cc0-a2bf-08da4fb97a7d
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 16:58:47.0663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QtcuqTw/NwZ3oiii0IDakCnRrfgCf0EtiLjkjcnqWSHVJUPRMJJAAqMaQ615ajVx2npsdVPo2SvBX/tYYhoMoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2658
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/16/2022 11:48, Sean Christopherson wrote:
> On Wed, Jun 15, 2022, Grzegorz Jaszczyk wrote:
>> pt., 10 cze 2022 o 16:30 Sean Christopherson <seanjc@google.com> napisał(a):
>>> MMIO or PIO for the actual exit, there's nothing special about hypercalls.  As for
>>> enumerating to the guest that it should do something, why not add a new ACPI_LPS0_*
>>> function?  E.g. something like
>>>
>>> static void s2idle_hypervisor_notify(void)
>>> {
>>>          if (lps0_dsm_func_mask > 0)
>>>                  acpi_sleep_run_lps0_dsm(ACPI_LPS0_EXIT_HYPERVISOR_NOTIFY
>>>                                          lps0_dsm_func_mask, lps0_dsm_guid);
>>> }
>>
>> Great, thank you for your suggestion! I will try this approach and
>> come back. Since this will be the main change in the next version,
>> will it be ok for you to add Suggested-by: Sean Christopherson
>> <seanjc@google.com> tag?
> 
> If you want, but there's certainly no need to do so.  But I assume you or someone
> at Intel will need to get formal approval for adding another ACPI LPS0 function?
> I.e. isn't there work to be done outside of the kernel before any patches can be
> merged?

There are 3 different LPS0 GUIDs in use.  An Intel one, an AMD (legacy) 
one, and a Microsoft one.  They all have their own specs, and so if this 
was to be added I think all 3 need to be updated.

As this is Linux specific hypervisor behavior, I don't know you would be 
able to convince Microsoft to update theirs' either.

How about using s2idle_devops?  There is a prepare() call and a 
restore() call that is set for each handler.  The only consumer of this 
ATM I'm aware of is the amd-pmc driver, but it's done like a 
notification chain so that a bunch of drivers can hook in if they need to.

Then you can have this notification path and the associated ACPI device 
it calls out to be it's own driver.
