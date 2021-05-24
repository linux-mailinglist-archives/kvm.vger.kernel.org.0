Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D92138F261
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 19:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233468AbhEXRlf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 13:41:35 -0400
Received: from mail-dm6nam10on2071.outbound.protection.outlook.com ([40.107.93.71]:38241
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232860AbhEXRle (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 13:41:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l2/9juB8Khyt+REKkc8NxpXv7s8jy7b3P4bWqMbVsQnMMZYVNHufqmx8GJsdL/UpHLapAXklPXUaLcE8CzDVza84QWLmVZefcf2bJdqBsO5jLGAQ6fdIhKNH1iq9yDxMsAXQaswaF/hIdXAbSITvUFsbfTinvzGh2fmMG3CtYHPzsSGhxGOycrr8va5OUWpnJpK7vG5oM1o8MJt5/SrrDI9FB8yCRT5hs0sOO6KnThMsgSePd6PzhEuwQiPBw7odpFzqZgYMAmzPngnbStttlRdiSLs1RWnWx/VtF1d+taSJOG2PBWewg0ZcI0+GSAjhLCW8Q/CH2Iaj6CDPlYk1Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LBdH2Y4dnMiPzwrOg0/m9OWP/PUF+l7kJBLUtgftf/I=;
 b=jFcMN5FZQRGbkyouToMB2so/03bSPcJYfwi8w6nhjieD8RkdVwS4oeTYEsjxPk4gkHxHUP2Q9D24sFZARlYebxlrS4Cuno2xv7//O3WteZKVAyI6rRCDy8Je49kmR/oCkRD5KR5acMh9bKu7UX5IKOtxkxizmblVQSmIdF6RxCOP/WSKcSROIh3rYBEPH1qQx51dO2e4xzALw23Hz8A2nlCVgxu6I7i48z8wLPFCxze20XYKiCCATCDNdL56/TiRdE3pKo1rE6n6VDK7gB++LaTDCcbkFxcoC/ebVIZiEOhaekOfg2szk2HpxjulhyTBRJqmsrJ/3YNtHK7N1ahZQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LBdH2Y4dnMiPzwrOg0/m9OWP/PUF+l7kJBLUtgftf/I=;
 b=q95YTT429cFGkz786tcRFYbHAx9pfVdzYHoPd3f+8FUVywqYXNhnIKcAqjMqBXXsSmjfUPvxIVWir3jWMGoqtVd9j3TLb/BVzR7IUa4tDLp+DnO+PndtIaYnYfsWh944zZlhKcushL70Rw1UO6BL3WFkeNjS5fUS8F33hrdOEJM=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4075.namprd12.prod.outlook.com (2603:10b6:5:21d::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4150.27; Mon, 24 May 2021 17:40:05 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4150.027; Mon, 24 May
 2021 17:40:04 +0000
Subject: Re: [PATCH] KVM: SVM: Assume a 64-bit hypercall for guests with
 protected state
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
References: <d0904f0d049300267665bd4abf96c3d7e7aa4825.1621701837.git.thomas.lendacky@amd.com>
 <87pmxg73h7.fsf@vitty.brq.redhat.com>
 <a947ee05-4205-fb3d-a1e6-f5df7275014e@amd.com>
 <87tums8cn0.fsf@vitty.brq.redhat.com>
 <211d5285-e209-b9ef-3099-8da646051661@amd.com>
 <c6864982-b30a-29b5-9a10-3cfdd331057e@redhat.com>
 <YKvcYeXaxTQ//87M@google.com>
 <0e2544cd-b594-7266-4400-f9c5886ff1c4@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <d5cd6225-5be6-0194-d531-2cb0a33c41fa@amd.com>
Date:   Mon, 24 May 2021 12:40:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <0e2544cd-b594-7266-4400-f9c5886ff1c4@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA9PR10CA0014.namprd10.prod.outlook.com
 (2603:10b6:806:a7::19) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA9PR10CA0014.namprd10.prod.outlook.com (2603:10b6:806:a7::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26 via Frontend Transport; Mon, 24 May 2021 17:40:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a95d926-8496-4921-7ee9-08d91edaf6eb
X-MS-TrafficTypeDiagnostic: DM6PR12MB4075:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB407506BC1C269E341DA17EE1EC269@DM6PR12MB4075.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G3cxc+jEzIfkf9gGC8osqV9+73NvmXAhn1gNKNFYQcxW12CCNJpQvfAsLGHi2selN2ehJkGo2kobhdM2ZXF2qapnLbElEMtyjfFmn3UXqkRVh8K1/KEmXhSG7u8aArHmUibMZkuW5DftYllUvDP3c1YUpK8J9SPdMRddpjKYlUddZ6noqjI04ARQYb4BGWi4wXMGKo6ONjEHwdDZXhO82MoCgAz8fMdAp9D+rfeCaUcWC63C2d4YrtkHVbn1ZAVdbz1SvoEiqWGrxMnzTe5xzRz7c2CkfAxJJoULMmGz0D4p49RAfH5tZMFm8bttstgZPQ6t9cYCEb32AJLNqjHQDoFOuwQ16PchiKtTDuw94UggXROqozp/Flp7okoW6km0HpfkSw66lMTnzHUd5AvIYbIEs8XFrBL3r16E14YQDxN/vEtIsFPy2goVvVT793eTnJxwwC+rdb1NXi3/JRzuRQHnVij12mseG4/WVKFWCtTDzKYy4xU0PtIv1vqtFVj1nSuuC+w0gSyOe7hhYuROVJhHjBsqor/TVdwEULuyOlGIPzKBfZWM5RgmKGJ38RB/SnGT1NTf9js3U3LkKkhnAcBTFhLy/NNt/y3rndCGmncM3IEILcKxTYRQFHDrrtA1AQtbm43GUcscqe/Y9DeYDTIWZ8WO8vcLFwmChYwsgU45A5X449q3wsoyc5OeRgQt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(366004)(346002)(39860400002)(86362001)(31696002)(38100700002)(66946007)(478600001)(66476007)(66556008)(2906002)(2616005)(53546011)(5660300002)(956004)(16526019)(186003)(7416002)(8676002)(6486002)(8936002)(6506007)(54906003)(110136005)(316002)(31686004)(6512007)(26005)(36756003)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NUlRNHRFTkNoSXpIWmcrajkvbXpIMWtNMlQ3MDR3YTZmN1ExcFVrbzNBTWMv?=
 =?utf-8?B?NWt1SmxFcE0zZ2pzQVRGM0UvVWE4Nzh0V0RMRTd2UjUyYUI3ZUR6OGlYck9T?=
 =?utf-8?B?dU1EZ29zUmRrNWhaTUt6VW5HRGt4cldIRmFuSmJHU21vUGt5UGY0ZlNKY3ZT?=
 =?utf-8?B?dll6TitKOUdUTFNiYTR4bC9nUU94Vjh3ejRuaER5VzhNcXZlTVhuZTVqVXBQ?=
 =?utf-8?B?cHN2QVlLVlBsQTczK084bHY3Q3hrZ28xQUN4VmRXK2laVjBhT2U0dWFoY0Ry?=
 =?utf-8?B?Q0dFRkJqa3pTcGVlN2lueElzT21WeHJKTm9Cc1lmenA3NXF0SDl0bER2Y1Vy?=
 =?utf-8?B?eGxpT3hCZnhGZ2drR3BMOW1uQ3htYlhHZ3JNRnE0VE1ZeUhrR1F0K21ETHVN?=
 =?utf-8?B?dWFCeHU1UWZmZlU3UDRiT1dzNnNSU3lkTlpoNWdyVEk0ODlkRU1CN3FYRjNn?=
 =?utf-8?B?Z00yS2c4eHk2QWx0ZzVuU3ZrSjZZTFJPVEcxUC9oWmhyVTE5Wm9iSjlQRWsr?=
 =?utf-8?B?aVBFTlFBMm5OZXEwSDVOckVrMVg3VmhaTlE0YktjU21ZUHhTbWhUVHo2UGdr?=
 =?utf-8?B?VzMxZkY5ejRGK1VDU0FsVW1ZbGNDMjlvOUZneTU3azlwZkozeUVndmxmM21i?=
 =?utf-8?B?djhRRGZKM0Y3UFVVMXMzLytINGcyb1g2TzFEQUMraXowVUtMcGVidm9pZ1dL?=
 =?utf-8?B?Q2Nja2ZjRjJhSXN0OUlaR0VidWNaWmVhUndkTzdydlk2dUk2Zy9Rb3B6aWVn?=
 =?utf-8?B?R21TSHQ5N1FKVDVTeVFPSGlsN1pwL1hmQ1dKSGVmL0NybmNtbmtMYzFjbGc0?=
 =?utf-8?B?bW5IcUZBNUhJbkttNk1tTUNibnNseE1uWGtRTHZQZnA2bk01UzhwRlhLQnRT?=
 =?utf-8?B?Wnd5RU9ueGR1M045QkRPTytVWUkwRWplQ0d5QnRsQlB1Wkd2MWF4UHYyeTFG?=
 =?utf-8?B?Nm1rWDB3M2VBSGYwY25HSGxkMXhDNXFlTnBMOHgrMUVtMEk4ZStuNzY5SVRM?=
 =?utf-8?B?bW16a3psRTFvRDFXcXZra1NTQ3VqTGxRZFgzWlEzSnkvREdQeUh4QkRocktI?=
 =?utf-8?B?VVRNZ01hek9EWUZSRitNNmxCcnVYMW4yRFRXNDhBSGhMcXY3UDdJcDk2eUVB?=
 =?utf-8?B?dWZpVDRZWFBTdTB4TDFjWnI0eFVmYnVBTWc2Y2lMMzNVWnljcEZlczQ5M3dH?=
 =?utf-8?B?T0lwTjRRaGhGajI5M2g4Yy9RN3pDREthcFBrL0tPV1F2ZDU4cUlBcHdhL1NJ?=
 =?utf-8?B?bllwL1lCNTNqQlJBQW9ONjJZY0R4M2V5eTluVXp0ZDE3YVZ1eGRUUFNsMmwx?=
 =?utf-8?B?bWJELzVKNEZLaFFUUTdrRVYwbGhEUmJnSzhVaGswZ1ZrZVRGU2xicE9SOE1P?=
 =?utf-8?B?WlptRUgwdmNreFFtalBHdVBldC8wbWJpUVZ1Vll1NkgrSk8rNmU2QndQT0tn?=
 =?utf-8?B?Wk8vakJKNWk0eDZEOWcvSjZTbUY3Rnp2bmhzV3ppK2YrUjRERWJZNFJDdTMw?=
 =?utf-8?B?UHlUNlhVV0Z6TjVkVFYrNE5vUFE1M1I5RE9IdFM4ejhkRWFLU0pwMHJwMU9G?=
 =?utf-8?B?L1ozZ1hZcEhuWndnWlhvSkFZcWYrbWJzdU1TU1RlMnVmREZNbzl4S28yRzkz?=
 =?utf-8?B?SWE1LzN3RFV5SWFXb1NhVlBOMzdJRDZaS2tBRytLeDRpbndmUk85UCtDMHQ5?=
 =?utf-8?B?Z3dLZ2hOYlZQdjVxNGlNL3Fsb1lJWGp3OUN1bGZuOTZPbUloU1pOV2ZRckVo?=
 =?utf-8?Q?KauQydghcYeheJPgjza6yKtQdGSoGFlDukDOyph?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a95d926-8496-4921-7ee9-08d91edaf6eb
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2021 17:40:04.6087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +MLG/stU08O2LkOk9/rZa9h68YjgRJeS/yqYG3t7Mmt9WsQs9Ero41pPCguFp6+83Ww7jW6miZW2h+jeF9qumw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/24/21 12:06 PM, Paolo Bonzini wrote:
> On 24/05/21 19:03, Sean Christopherson wrote:
>>> Let's introduce a new wrapper is_64_bit_hypercall, and add a
>>> WARN_ON_ONCE(vcpu->arch.guest_state_protected) to is_64_bit_mode.
>>
>> Can we introduce the WARN(s) in a separate patch, and deploy them much more
>> widely than just is_64_bit_mode()?  I would like to have them lying in
>> wait at
>> every path that should be unreachable, e.g. get/set segments, get_cpl(),
>> etc...
> 
> Each WARN that is added must be audited separately, so this one I'd like
> to have now; it is pretty much the motivation for introducing a new
> function, as the other caller of is_64_bit_mode, kvm_get_linear_rip() is
> already "handling" SEV-ES by always returning 0.

The kvm_register_{read,write}() functions also call is_64_bit_mode(). But...

The SVM support uses those for CR and DR intercepts. CR intercepts are not
enabled under SEV-ES. DR intercepts are only set for DR7. DR7 reads don't
actually exit, the intercept is there to trigger the #VC and return a
cached value from the #VC handler. DR7 writes do exit but don't actually
do much since we don't allow guest_debug to be set so kvm_register_read()
is never called.

The x86 support also uses those functions for emulation and SMM, both of
which aren't supported under SEV-ES.

Thanks,
Tom

> 
> But yes adding more WARNs can only be good.
> 
> Paolo
> 
>> Side topic, kvm_get_cs_db_l_bits() should be moved to svm.c. 
>> Functionally, it's
>> fine to have it as a vendor-agnostic helper, but practically speaking it
>> should
>> never be called directly.
>>
> 
