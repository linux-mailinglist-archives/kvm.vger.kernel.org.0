Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C375676E02B
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 08:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbjHCG0a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 02:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233351AbjHCG0I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 02:26:08 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2062.outbound.protection.outlook.com [40.107.93.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD4C3AA6
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 23:25:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b2ASHRIqCTvoxc3Hw5lsMLgFXdWWRCN9cM4d/J1J+FVcfu3gqv9dzzuFxy4Q8fZqAGhEfsW+pAwlRaWAfzoWsa6eOowwdFw9FH+vv35vYZgulyo7xKdq5+ranRuqMOIe/prSPM3zINIMlbPO/aQXe84eFN/AjNPOhZ0l708CWtn3bbbyXCvQd2hQfSKOPf+aZv8AzzXD4tJmkJaUdu8kmTY2k+nytb8tIpZd6ejkzdB/iwWXC3ch/lzTh34RIPPyMcBOFHb5hA+VAhULeu/VtjpUGwH5qoyY5H91yNUl1I0Lzb0itwFRwkGzwOJWWQZ/A544b9JqLpbLgBz0lC3Zmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qkyupGunf2EqW7d+bTe/yYi7w94o/n8/ZX2ZGKiA2fo=;
 b=SIvUwghGfdjaDXXRMlWikSLi7EzU6KrUqyo/LhQnmW5McGhm/jQ5SENRRtrIJwbm4IT1AqlR9FVIwVxXycNVVoiUtmYsZ4MfzFxkdEpP70jcU4FUNXQmSk1ciXZTs2K8oomaAJL/LaEHXJ7h95T0O6JptvCBqxwMd60iNLO1rSYeB0u4m10GUdxrC1LlRwz043URhbNmPPezt2Ckh7OE1Lkw05fOGYlHyRaaSrhs+retyqmnS7e3+c0Lr700gYqFS+q9azZJ0T1zm8I1AhMxl1lKkG6KG8Mg0NnJHI+6tsgukXcEYygGytjN1IU9ZRpj8qZfwZuNhOxuz6YiDQ4iOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qkyupGunf2EqW7d+bTe/yYi7w94o/n8/ZX2ZGKiA2fo=;
 b=5Txqo7CZiOe9zbHVjKpUyk9iepvIHJ6nZg7UHyeMFfbOWg7rMVj0aq2IewMUNsRRv71bu/jP/yxeytklrtnUXH0PVSV0DHGKx5OhW3RIXJhdyEPZ2/NgusNY0yHM5IlWkw02LqSjlgv6ImBG+Gt74NP1o0HjSI8La3uRYWqVNIk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 MW4PR12MB5641.namprd12.prod.outlook.com (2603:10b6:303:186::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6631.47; Thu, 3 Aug 2023 06:25:44 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::9ade:451:96c3:7b54]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::9ade:451:96c3:7b54%3]) with mapi id 15.20.6631.045; Thu, 3 Aug 2023
 06:25:44 +0000
Message-ID: <d34ea89c-9cbc-9485-a6db-2b72ce8bf0e3@amd.com>
Date:   Thu, 3 Aug 2023 11:55:27 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Reply-To: nikunj@amd.com
Subject: Re: [PATCH] KVM: SVM: Add exception to disable objtool warning for
 kvm-amd.o
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>,
        Arnd Bergmann <arnd@arndb.de>
References: <20230802091107.1160320-1-nikunj@amd.com>
 <ZMph82WH/k19fMvE@google.com>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <ZMph82WH/k19fMvE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0161.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:c8::17) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|MW4PR12MB5641:EE_
X-MS-Office365-Filtering-Correlation-Id: cce06e92-720c-4361-8b3a-08db93ea76c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TD7KWOVRLLKacVPlId+LKQ/LOTvOlh0F/dSQ1qMFMUW2ASCfeH//IQB+iW+hcSJHjk+0LfS3SjjbRfRqkLkixSaMEkToHvGvU+ox4zy1WtopQWRprJP+CFDocOF9RHQHMND9OFNBggaA4doqLYqLBhoa66+H/G1K21id/mf4mGf2ThJ2HD4Y+dIzpyzeTzgppmUtI9jD+vmM/NKlda4btzP+WRZWEFsC1dnR99i009SO0IxjlkbE5R3V90/eTkd+H5PypGxwSbJZIdXKZmxAVbLhCCA2MCVebx251/z+fjIPQgIPzKuFG0YJHPsX9UeBAGezPR1j0FweQNsGyMnoEyO4Gmv8ZFQkAUlEmj2MwVK9pYEnUGTKVVYM61Miqea1GYurSQ1UibANYIzHGocdjhqgvxSiaS79DLDyqLoFVuZV1heAUJTjWJrlzlEn8IrNDU/qntX0uVqhoscphUiDkbMU8TL83mzZQfMsTv8vN38LYiJnbLN0yU7cUsU3IbCri5O6ickBraAVJLem4Nw8lyomK26kMUkuSaWRttUdRLHUiH4SN56uVrFDhahgZ3kaVRqnpJ8O5FEW/VUAHYrnVlPZE82TzK0YpRNIYIIZShv8C1CKUKlPMCjR6hvtQOfah6eAOcAfMHQoSfhUdoAHrw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(366004)(376002)(346002)(39860400002)(451199021)(2616005)(53546011)(6506007)(83380400001)(26005)(186003)(4744005)(316002)(3450700001)(2906002)(66946007)(4326008)(6916009)(66476007)(66556008)(5660300002)(41300700001)(8676002)(8936002)(6666004)(6486002)(966005)(6512007)(478600001)(54906003)(38100700002)(36756003)(31696002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RDdqblltc0JZbk1LQ2NZOE5DK3c4WGJoRjBVVHA5aEhLdG1qdDBVZnAzTU9Q?=
 =?utf-8?B?VkwvYVNlYi93YjNIUWsrT1RvYXlhQW5pSlBkSXNnYjFkcW5xazdzczZ5akN6?=
 =?utf-8?B?UDVRS1pHR0Q0SUc1Tm5tNkVrLzdFT1JqSmU3dDZUS04wVFJrYWVJTENibXJa?=
 =?utf-8?B?ODdoVHgrcWs3b0VRSUoyc3BXbGhHUVIzNjJLSENvMXVxYVpTQVNEVTMwSHdr?=
 =?utf-8?B?UTVqci9lT3ZPTHhLVndtK3BhbEdQVDdUQ29TR2ttQXgzZFdka3gyb25WNDQ1?=
 =?utf-8?B?MW56bkQ0c2tPV1FuSWZNSlN0R1FMengyUlBTOVU4TWxGQ1lLVVFibEE4dCtY?=
 =?utf-8?B?TWxYSzF4M09KT2JzR2FoMFZaMGlTSjR6L2M0Z1N5alpFcSs3Qm42Y3RhYjgy?=
 =?utf-8?B?V21CSHlTVGR2L0o2OStZbG5EbkhsRWZINmxHZkVuMXJrWFhMdldmcmdTY0V3?=
 =?utf-8?B?cG93VU43N2tXVHgrcmFBeHpWZTdqcmQ4anlicUhkazVRNW5qSmRmZ0JuWEVs?=
 =?utf-8?B?aGlWQS91Z29UTGRCbHAzdWJuVjY3WHo3cmd0bW51TW5CK3ltRW5wRFBSazBX?=
 =?utf-8?B?dG84RUJPNWJYbmVTMEIwUURnT3VqYXpidjNvbTg4TlZQMzJ4Mi9GTTNWeGM2?=
 =?utf-8?B?dW1uRWxBaUFMYmFEelBjOTBIYlQrUTlLZW13Y1RoVnhhRTNocXArUThpQkVj?=
 =?utf-8?B?KzhkRGFTbGhadi95VHBKOUZlRlBBL0liMXN5VDNHOTVSYmwxeXlHL0RUMFA4?=
 =?utf-8?B?b0FMUEhIUE1CdW9xdTNnaGhzcDFYeFBUbjdHK3U5Z3N4aTNPTGtmcnJabDgz?=
 =?utf-8?B?ZTZyUGRpb3FkUXdoMTBpRUQwbFB5a21rOGkzTTljMFErelVVYmZlR0YwTlNH?=
 =?utf-8?B?czJtZGxzWGwwQjlLaUxZVXd4b2R4TkN4bHNpUlRLbkxPNXJHck1WM1lZYTBO?=
 =?utf-8?B?UWRSNCtxWXFneFp4UU40dDVLaDBOWXh4NHlnZkdFbmZheXJjS29ETUxHWXdq?=
 =?utf-8?B?Z0JjWCtQdkgrSmhYUkk4YjFiclJEUCtQeGpYdU9Mc2VLMGpGL3ExZEs4R1Bl?=
 =?utf-8?B?TFJUOWZaazNvRVBoTVA2bUNxNDMyVlgrUTdHUnU2QVBoSzZsVlJKTUxKWFI4?=
 =?utf-8?B?aE55Y0JKanBsMkxVc0pRZXY5cTg1eGdqRldxdXh6Tng5NTlIbXV6dkV4ME5n?=
 =?utf-8?B?VjN4T0lwV2pGeXZjcEltY3lNRXJNR0JEdTljK2w5dnNqS1VIV2xLdnNSb3B6?=
 =?utf-8?B?aTV1MUxWS3pOOUdQUjJmZ1l3ZUZjUG90TEhBUVZxRGdxOEZFbUxJMHZ3Um1q?=
 =?utf-8?B?UU4yZEtUZkpwUjVnem9WYlZvL0tScU56blpvenp3R3dGWm1ic2o1dWhXK0xQ?=
 =?utf-8?B?Vm1NeHQvUy9TdG5WTDJpQWd6WHBlUEdEM3l4UzA1U1RKNHNrMS9qYWEwdzNr?=
 =?utf-8?B?OGFpSWtNd3NhcjdZaGdSMFZqWGVpTTBiMElHQ1g5L25kYzN5bXgyYWs5dERH?=
 =?utf-8?B?WkVMTmRmaS84V3ZCTWUwb1VCYlc5NXVuYVJISHZRVnpPcmF5eWMxVFFoc3Ru?=
 =?utf-8?B?YnpkaE1lN00wVldCU09ESkZ3aXRYbGdPdy9pOUxlK1NsamJ4eFp2WmwvakVH?=
 =?utf-8?B?bmlLZTNtUFF1S2dPQ3pUMmN6NDY3YTZkcGdYMnVVOG9vUWRBYlRjTGZIbWJk?=
 =?utf-8?B?S1RFOFl5d2JnbFdYRzhZbXIyU3lwMnY2UWFvSEhLbXljYlR5Yjc5QW5nQmxN?=
 =?utf-8?B?YVpqU1BNZDEyL216ZUFCKzR3czExcFZDbCs3L2lvYS9ObmR3R3UrTllFdjh3?=
 =?utf-8?B?b3JlMVFQTm1yc1NCaUtlNnk2eHlFSmxZRkF1QjBENGkwc1pqUGJnclpRbFow?=
 =?utf-8?B?T0dCcjk4ZnhBd0FSY1dSTU16N0dZalp0M3M0d0lXb1dkMzFSNmh3UFZEYnRl?=
 =?utf-8?B?WmRkRU1sWTNaa2xPeVp5dXROTWtienVtUS82Qms0TVMxZTM4UHJCem80NUkz?=
 =?utf-8?B?UjZHd3FSZU8wckNpMlh1WHlPNkRRQ3VPVksrRmpSUlpyQU1LVkxVREhNSjI1?=
 =?utf-8?B?emVpT1F2dXpsclQ4OHNoZUoxRWloaWtCTmhWQVA4bWFjeFFWYVBTSVZlKzlX?=
 =?utf-8?Q?zwJtzTS9D0j5rrifZb8zwFor3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cce06e92-720c-4361-8b3a-08db93ea76c4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2023 06:25:43.4113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 29XX8RUy9ilgxXqlvpkTJ4k0h3c/CnuPB5OyDa1gUPfhPBR9joirlq0oou/tH5oFcwcFHb9DmQK7TvML1pkZ4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5641
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/2/2023 7:32 PM, Sean Christopherson wrote:
> On Wed, Aug 02, 2023, Nikunj A Dadhania wrote:
>> objtool gives the following warnings in the newer kernel builds:
> 
> Define "newer".  As in, exactly what commit is causing problems?

Not that new it seems, I have tried till v5.19 and the warning is there but 
with a different signature. Do you want me to further bisect it ?

arch/x86/kvm/kvm-amd.o: warning: objtool: .altinstr_replacement+0x4d: call without frame pointer save/setup
arch/x86/kvm/kvm-amd.o: warning: objtool: .altinstr_replacement+0x57: call without frame pointer save/setup

kvm-amd.o warnings were also reported in the below thread:
https://lore.kernel.org/lkml/9698eff1-9680-4f0a-94de-590eaa923e94@app.fastmail.com/

Regards,
Nikunj

