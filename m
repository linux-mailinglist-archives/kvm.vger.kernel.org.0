Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE6CC674C0D
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 06:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbjATFXK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 00:23:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbjATFWg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 00:22:36 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF9EBCE39;
        Thu, 19 Jan 2023 21:12:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CZs+uU7wtZ/N0iR+ddJjsSDhjfO45BEBgKdUpNtS9eYCymKz5Z4gIbLj4CawPBUE/KAbh3P5s2AI91/i6BVQfC7NMCjkIaOi2hZogt7ybYFalsE8eBb6WgL3e7iMIB1yX+JJFuYq6WD/KqOepA9wQnXBC+NmxVmU8OAgnkGxrKZatPAek48idtTRXzQqqN02D6bfbM7oM9EhPMTgIPAIXtf4ROb97Sz1Of0L1mrFWJPrGLyZk9E9OFvze99x5imzpPUrQgZNZqJdhYXRgyCU30LrByRYQBipgdlU2+sGeyQsj89qR6QOCEeF0USYgvkfgwTG7s7JRuAO++R3/j02oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rj7h8/ZezDbQTQv7xqKatTYyiv3JpHOQ4m/g+mbpVn4=;
 b=QtMhqDKRa4vEAncT8+7nKX4s02AmvqzNPoDNAa/oQAoWU/eZhM//XYX5KtEhAX/G7QNZVriLliijhhA/LqRYcjNIj5osmNKeTorntgPvKY7Kl6u9bnPz21jtFlE5JMcxFtmhTJYlyXZXXcAqf7HIonspP8BByuagSSka44M2JNoDblFkommP6JdbWxcZU8x/G0BRV3lD+3XtoYGoqlxRzDPU3ZsDU4HfwE1twa0C1GkmSlpPy5Sb+5A3x6tMwVeNcXFauSeBKcex6XmafROFv3Vik30W29TKG0QdkX5Wc9JTzUN/BGBksxhYhOPNmrlEKeMqs/PDb4eRTzGGHSjtpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rj7h8/ZezDbQTQv7xqKatTYyiv3JpHOQ4m/g+mbpVn4=;
 b=KzEp3Dz9jsOc1/VoIKMV6FRmtIHTHXs7y61IVcbz7/VxziUDbDrtKq14sCgKm/gOyWcl1tP/nIM/uxtPE6ckXQKHLvt1s4mJK54D46GGzGOHjlLOuOC/VZ1RbB1Zf2Bb+KTh912bitLt7wiKLqSHAWsn/gPtMbsmQ3cJ1MpLu68=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 DS0PR12MB8575.namprd12.prod.outlook.com (2603:10b6:8:164::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.27; Fri, 20 Jan 2023 05:12:26 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::8079:86db:f2e5:7700]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::8079:86db:f2e5:7700%6]) with mapi id 15.20.5986.018; Fri, 20 Jan 2023
 05:12:26 +0000
Message-ID: <adc11ed3-de89-a389-e629-3c951257469c@amd.com>
Date:   Fri, 20 Jan 2023 10:42:05 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH kernel v3 3/3] x86/sev: Do not handle #VC for DR7
 read/write
Content-Language: en-US
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Yury Norov <yury.norov@gmail.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Kees Cook <keescook@chromium.org>,
        Juergen Gross <jgross@suse.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20230120031047.628097-1-aik@amd.com>
 <20230120031047.628097-4-aik@amd.com>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20230120031047.628097-4-aik@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0221.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::17) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|DS0PR12MB8575:EE_
X-MS-Office365-Filtering-Correlation-Id: 878bc5e3-546e-4af4-230d-08dafaa4ebb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MHUvWI726HD0YxKvuQ5o2t5WqWsqkdYc9gAliV1TjOLYiZOtSallX0hbGiAjBdIGb4xxY9PQmQZMn6/4Fx6xi+reBIXkpGhHb3GvVEsAj6MyUwa9lWUv4B6R4fEWvcrYX9D9U5aHHe+Z/bIdpOewtQ20L5a9ma6hqhIG+BqzkcPZ2mZoMx4JL0D6N/LWtaw/Yh73JtVNVtFCQxALkcvjHXqMlwj/MVFgG2VQexnd+R2KxyWsVGthZk72HXd6xq3qKcPypErMIkX4/DL1GgnDR6nZCYGJ6AH1QciLFq9uPcJInIwNMSsPP3lk3KpC6lSbT+iW/45M5Om6BwZgkZnZ/U9pN64EZYMSHEMjicT7uTAVlcHiRuT96Sq5MGyjjlTPcROPpZuvqQmqyUsHf0/FGPDsniivATH8V3Mxif3Ltj/HS/iZPkLf2GQ0m8k/OX/sTO66rYAwb5u46sHrBnAQOwU/tU+l4p2SgRrX6kuHDCjbPrCHMJhaMcS+QdcsO2jS0jfngtkC8eJEBEP+23p/oRPGi1UO81KU5xer7P9HiCIgLFK4kJVqlAiADePYfXZ+ykBa0D+O6CjptxdMBhzgZbVoSB90VpmyGbFH9Ta/d93/Ohec1fj0RsfGeKYUC3nOPwJ6R7HsglAN8xAbomg6CWDWQVXxn65E++ZpKOWj2pD4dyVcOv/PBoUd1yw7983qBH0+RgNdRqxIqfDtb2EhWg4JW/LUK+PqPqmk2Ke4aQFbsTtdGBquVnbMAEmZhUKI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(396003)(136003)(346002)(366004)(451199015)(53546011)(966005)(6486002)(6636002)(316002)(478600001)(37006003)(41300700001)(31686004)(6512007)(38100700002)(31696002)(7416002)(36756003)(4744005)(54906003)(6862004)(8936002)(5660300002)(186003)(26005)(6666004)(2616005)(2906002)(6506007)(66476007)(66556008)(4326008)(8676002)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGV3RFJtc3hMSWM0ZHVVR1lXcm5YQ3lROXZud0xpc3M1NGRQeTU2SThaSDVL?=
 =?utf-8?B?QWh4bTJ2SGNyQnJoeExxY3ZqVlNnWng4TytaaGJDME94ekJlNzByNUw4aVdT?=
 =?utf-8?B?RTd3ZE1kMjFWdTZpSjRqbFp4MktRSGVLSUY4SE1HT1NmeEVySS9rcUQreDls?=
 =?utf-8?B?QTZFRFZFMEJCcTA5a1l0b204OGYxSTR3MEgrSW1DWDJzOCt4bkxNR2VHdUlp?=
 =?utf-8?B?bjFxYXQxV0hhbTE1ZS9vSDFIVmxpQzMwTUFCM3lkZnJIZ0I4akNPY1hJU3ZY?=
 =?utf-8?B?WW5oY2VtUFFxMzdYN1BTSzc4YlFwdXNUMk0zTm9EdGcxbW4xdGxmWkxMdCtW?=
 =?utf-8?B?aGsrT3gyYmV2RktlK3NmRlE0c1pNSjA1NHVWL2Y0MWJqaFBhSTF4NTFNdFZK?=
 =?utf-8?B?V3VIMVVlcEtjZVdJRkswUHo1OThqazBsNHdJS1BTVFU4aTdJcXlYM1k2SG45?=
 =?utf-8?B?VVp0bklSSENobk5nVnNWWXJSTWI5d2JwZ1JYc2ErbkJJNEwxaTVxaVBuZGpY?=
 =?utf-8?B?RWNlT2h3WnZxSG5WeHltMUw0SlBjU3hPZy9QWjJzU0R1QWpyRHdZQUQ4SGxP?=
 =?utf-8?B?Y0tjd1g2ODhXVmhGYVVaRmYyYXNoWDJIUWZMb2l4SFl6d1FINVQrNTg3Qldh?=
 =?utf-8?B?VFFFeHIyd1NxQmg4YkR4U2RHNGUyaFN4SFduWjN1Qmw0aGdGTTRzK0puRGNE?=
 =?utf-8?B?WSs5cEZ3VW96aldIYlhmTEhmb2dhNVFuUTVKSFZCckFYQjJDcFVxdlBod3NI?=
 =?utf-8?B?RURBM3NHTkFpaUZQTllKU2J5eDFrMEJFUXNOUHBlTTF2R2tSaWV6U1hVOXNX?=
 =?utf-8?B?d2FrNHZxYU9hcTZpVnhNaFpJRWtYWUdyUXNScExJMjNzblc5RWJvRFJWMWxu?=
 =?utf-8?B?aFU0MnZYTWltemc5RTBIZER5MzZheVJ2aW95bmNlVndLRmhuM1psdlFoZG94?=
 =?utf-8?B?c2JUeFlGSGM1QmU4dVFmUmN3eXBTZlRjWmJzUXJWc1ZtWEkzV0JuTU9vQ3kv?=
 =?utf-8?B?RmxKR2ExTG9NNzkweXM0Uk5oVlF1UXdlQW56M09oaWpWcWdkSUE0dE1Bay93?=
 =?utf-8?B?eXkwQ1dLNEFscEZTN0hkL1lCcU5mcHVkREEwRmdDeENGZE1Da2NYU1NzZ05t?=
 =?utf-8?B?eVNiYmlzL0oyY243VXJPRzJQbmZubm1uZVd3d290K2x0WlRuZEJxSXRRaURX?=
 =?utf-8?B?WFBrVm0wTzdsMzZnblRsTG1kZXQ0dml5Z2dENmd0SzNhUnZkWnN2SjdJUnpH?=
 =?utf-8?B?VGtnNEQ5czBVa25tN1E0TFQxdU1ielBXUU9GUGJvbjhlanVJQ3R1VWdIWVVy?=
 =?utf-8?B?U3RNUVNKc25CcE5xR3RYZ1diNUF3N1p1aDF0aEJSNUYyMWpYam1GTDlhVXkr?=
 =?utf-8?B?VXpxeUlDNitOZDhld3lYOXVpcDYvdGhvbVU4SzQzcFowRHY3QVp1a0JKNkN1?=
 =?utf-8?B?WWlVNytaOXBLbXErTjZVR01Id2hEbnAwTGRNRy9pQTN1bkpyOU4yMy96SjVP?=
 =?utf-8?B?M09TSlFIb1lGYjJJZWJVZWc3VkpDdm10Vk9TNWtQOThKdnZEN0RwNVpQN0Vq?=
 =?utf-8?B?aEo4OTBrdTVqUUE1UFRJMURRamp2TVZrOW5XZDRrL1d5Ly80ZmFrYTVNK203?=
 =?utf-8?B?QVMyOUFPbTMvdFVGZ2lSOHY5ZXlkajNDdGVQajVCUm52Ui9yeXN3cEd5MzZO?=
 =?utf-8?B?RHhqREpOcmFXZHJiTlhCSVNMWm1TZHV6UXBQOVc4Q3U4Qk5pMUkrKzBZRVJl?=
 =?utf-8?B?amVxcjVROEFzcjQ2SDZSWlAxRUoxUlJkeXM1WDdIa0pFeGlrN0VZejYxeTQr?=
 =?utf-8?B?djdUUlVVSmp0elJHTVRHRjc0M0kyZ3JUVEVMR0FkaTJ5aXpyQ3NKYW9xRzVD?=
 =?utf-8?B?VXF0MlowQzJYeXErZTF2YlBvQ05NSWF5dFlXai9lbDRmU2JWRHhIb25pZFY4?=
 =?utf-8?B?Y21uZG5ORzJPc2RqdDB0djRMRk1YVkgwaHovY2pUNHBTcGk0OXIxeHAyQUlE?=
 =?utf-8?B?cnpqWk9LR0dVQWhkWWVhLzJFNkc5T0dzV1ZrLzEvTE9KNXlyOXc4YkRqSGNn?=
 =?utf-8?B?THNzQml6WFZJdUJmbnJBR1dHUllmRmdVbitWWlhoQk5rR2gzeWRlcSs0bHcr?=
 =?utf-8?Q?nh/reQR4QVmEEBNMUqnmvF+T+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 878bc5e3-546e-4af4-230d-08dafaa4ebb0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 05:12:26.6346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qqIJoSrG00s1aTpQDzj3GYHo71mNJsFV+1cQmbBUwN422jMJDkktD0jR+uA0E7pQcus9Qb/2FK3TVoGzsvqNxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8575
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/01/23 08:40, Alexey Kardashevskiy wrote:
> With MSR_AMD64_SEV_DEBUG_SWAP enabled, the VM should not get #VC
> events for DR7 read/write which it rather avoided.
> 

SNP guest feature negotiation patch is part of tip now: https://lore.kernel.org/lkml/167414649850.4906.1693185384677559889.tip-bot2@tip-bot2/

MSR_AMD64_SNP_DEBUG_SWAP is already defined. As this requires guest side changes, please add MSR_AMD64_SNP_DEBUG_SWAP as part of SNP_FEATURES_PRESENT bit mask.

Regards
Nikunj

