Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 051945FFD62
	for <lists+kvm@lfdr.de>; Sun, 16 Oct 2022 07:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbiJPFtw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Oct 2022 01:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiJPFtu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Oct 2022 01:49:50 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2067.outbound.protection.outlook.com [40.107.101.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282EF1C40A;
        Sat, 15 Oct 2022 22:49:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=inBVL7muKWv8CvmEdSpDZo8kaEd3R4VxazwjnLwc1cPjJ5b9J0mdnZ9sUVNnZsbuZSmMRkIEJuFkQNTVcIbxAk8Z5uFo9s/CcTUrfDJfZVhyX7FPX+MupzC29bf3ZrMPrTfQnNg7Hu8QXcKcYi2moRm+RuP1BqwimsdzkID9WE71jI1IdnrsChuOGvtaIL9lNp3Wgde6wdU3QC5od9yBrJyXCSwwo/B9dx7m9LPwDNvw6JHIvQ9QIKD2PVvBWhKTNAXel02M5lm0mjPDm4Q93E//TWeQ2dRy0W76gHaOazr3gbFp9R4pGqHIY62VcvJB7Ux9rPRzs1pd2OmqGgUsSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BiTc/vu11w1SHNZYbVMVl14MXo8s+r15rg8r2rVNBWU=;
 b=Zvf39mB3KRaq1mKJ0qE1Kg1E4EX/VUWHFwLrEG2xAuSUtbMo9jhbMdsRcMVCa3k/Ak2X2ahsa8RpK8P9rqmzH4xzsruiKA0LtYZhmdwZCvv1ujG5OdZkdcdMNgR6KAYkL67csiVa1+H+PssodWu0Y9cN2X4xa2GJvyg2xwLqPlth/Z6qrTRgpXbN3zx0gaZ6kAO0R2l6ljvTZfmVe6GvI2xAYJBgjD+FJ4CGqEFcK7ttOxeMslBD7U1LuzSQY3CYlAZMwY7Ouh5dlJJS5iWixgkhNpLNjRdAdo/bHPYTyoXdNu2RDL8pfLaOEWMU2nhd6OwffaAEJBd0PezUCzMk4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BiTc/vu11w1SHNZYbVMVl14MXo8s+r15rg8r2rVNBWU=;
 b=Ojv8dwjE5x0tbtQ/nmeBFlh94yDDNa124UgXqb2c53AaMq6MvvmeIPJDcEy2Fqxj8MfptGqSJPBxLAHZql3FMAF+ohk0DUqyuRxBZlyvnpC4xjujH2TKQwpSvQUbu6uvy/m34LSoL41WHjE4FLSCf9UkyM8c/oy2XUbfC7dUvUA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by CH2PR12MB4166.namprd12.prod.outlook.com (2603:10b6:610:78::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Sun, 16 Oct
 2022 05:49:46 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::3bd9:dc6b:7c66:d776]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::3bd9:dc6b:7c66:d776%7]) with mapi id 15.20.5709.017; Sun, 16 Oct 2022
 05:49:45 +0000
Message-ID: <b76e36d0-88d5-be32-a9b2-e3d476e44556@amd.com>
Date:   Sun, 16 Oct 2022 11:19:28 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCHv4 0/8] Virtual NMI feature
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mlevitsk@redhat.com,
        mail@maciej.szmigiero.name
References: <20220829100850.1474-1-santosh.shukla@amd.com>
 <Yz8hIY9XdlycXE+N@google.com> <b8a6ac33-eb39-5bf3-db55-a2189d67d202@amd.com>
 <Y0Q/jVzFz3MoP26d@google.com>
From:   Santosh Shukla <santosh.shukla@amd.com>
In-Reply-To: <Y0Q/jVzFz3MoP26d@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0048.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:98::23) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6323:EE_|CH2PR12MB4166:EE_
X-MS-Office365-Filtering-Correlation-Id: b140110e-f942-47c3-bad8-08daaf3a3aba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GxWIId9s5/5xq07I/SlPyhpJPY2wfklr7OJ9LergxB8pfVVAtmdePpDuQ7BPXXVjtg+UB0IZHB1Ipq/8HFkL4sKfKl/QOlqryQbXLSibUQ9/cE8EnpwvlKfAYUHpV4Vbsp/GKC5FDAIMpH5DaQOw27GICSlwG3AYagFSdTeSm+/OsH5Cv6F4xbezohNaRLyQ76PdOs9zsKWvK/4rj4eQAc/vNmXm13G1N7QF8Wj/nZvosEDXevdcJMSiK4XEmqNlp0WCc4tRHpT5M42EwpU3TyTwQwizw/o1CZ6qRGyEZp+zhCD09Us7oZ37yd9eF1I/IeXZr7hAhFZDDtFCY0r3gMYJtgEwc8kLQtZqDmD3IPWcHuW0o3aX4thuu6MlbTNgbRQriJ0tY5A81JtLA74LYZ3XLnUjfePWGtOfshgHiHgtjudeWuQBHLHfv02hlLyEpbHQH6zy3QD2Pl8Jk3fbaxxJEvaVUW24Er/diPi4IaYpCpaUmISZBqe/n6V9e412Da94oo+fdQc8nTlgv02YbIfJfrxDbADjduzSnNy7DDGyQ37q484PwEKJ15UP1qG7Dy11O5dsd7x+F4DQLqOtfU4nN4miZmXiquMIHcaBHstR/295ud7c3LxdggRiu2LWmNGNW2twkF7CZMmr9KyXvdwcDCLII09Tprr2hZtNzYSewZePxQC6FU9Q2Db3pMUhXzSSCupJsMe+F45WpbQxAoVZ+JShJmorHxTjeoVMMMTR3dQW/djJMtu78x4T/D59qy00Ca5B6hoZ2KsDWpCutuxY0O5guV7bXkuCRO9X3uFRNkhJsmTWW4bNKeph/3cCVWCXuChevLu9wW2qN2bEbA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(136003)(396003)(346002)(366004)(451199015)(6486002)(966005)(6916009)(54906003)(316002)(478600001)(6666004)(66556008)(66476007)(6512007)(5660300002)(66946007)(2906002)(8676002)(4326008)(186003)(53546011)(2616005)(6506007)(41300700001)(26005)(44832011)(8936002)(36756003)(86362001)(31696002)(83380400001)(31686004)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bWFQd0hWZUVGTXZqWVJKb29GUkJpN2FpUHJkeDJpcDhJTzdGYjAxd3BKaDl3?=
 =?utf-8?B?eEhOUUp4Q25EYnNNeXdiSXh5SWRnelhYNm9iaEx3b1Z3NjlsREhJaEdxa2Fj?=
 =?utf-8?B?UXVTTjFMVXJOQVJaSXlsOEVnU3prbjRXNjBzWWF0Wkt2Y2ljdFkxQWtFK3Ni?=
 =?utf-8?B?WnVUNVFZMnZxTHFhNjk5bDZ5OUJrMHlMSWZUQy9NcHNZU1FLTmh0WUcwdXVl?=
 =?utf-8?B?OFhnU3ExV0dqd3JadWJ0c3ZYVyszZHdINWMrYkhCU3RBaU1penFhT3lGR3Jx?=
 =?utf-8?B?VlgrSm93WFpjY095T1FodlBUWXpudWJ6cGZMdzltd2FvVGNtaHp2Z211N2RH?=
 =?utf-8?B?YmdEQWhNRlI2dzRjYlJBQ1NEMDM0UHFNLzBOS214WjFmZkJDUlpVUUE2SzhE?=
 =?utf-8?B?S2haK1U3VldQRUQxYngzdW5rTGNjdWtHNXNQdmJ6TTl2V2JmeTRRdVdtN1g0?=
 =?utf-8?B?a1lyTWdvdVhlc1pxT0R1R0VoNDR4c1p6YTU0QnB0YWNJNlpDV3ZRc0NrWEZm?=
 =?utf-8?B?Vk1BUFd1eXpiZ2t5WFk5Vmh3T3lGMzFDbExBVTVaNkRxRXdTR2FUVjlRMjlx?=
 =?utf-8?B?cVlYeEU1czEyR25WRUhYMU5WK0h0dFR6SzNzZVJGdlo5YW00cmd0RHVWRjVi?=
 =?utf-8?B?dkV2MkVOV0lyd21pcXFLU0V5aVpGeVlDYVdndS9uRG1WNTJ4TW0zdFhWRUVL?=
 =?utf-8?B?QUFYYkE4UjMzRjBuWTk1TFN3aEl2WW14TnZMUEdpSEZGZDZhZ3l6V294WHRh?=
 =?utf-8?B?UE9JYlQ5T0FiczFNRWFWMG9BTTk3YWpoa3BwdEJQUk9nSDIyMGdoVG9FOXQ5?=
 =?utf-8?B?Y09GWSs5NVN0TmpHdXROdW15MG1wVGt6OUxwYWxjeTNhbFRYNS96a3ZrdnZU?=
 =?utf-8?B?VXZEV0Rlc2UrajJUY2pUVUNjNGF4U1lNSUdFV0pQN05JcjIzM3VScWsxaW9N?=
 =?utf-8?B?Z2VjbHk0U3R5d1A4S1ZIUkFNYTNiOFJJaDlSUS9YTzlEQXd3MHRabG1DZ3Qr?=
 =?utf-8?B?SzNPRnNFemYzaTZwWHNMV0xab1ZCUEE1RUxaNmNLdjJXYXdhd09WR3VTa2hI?=
 =?utf-8?B?STJRUWx3b1RBYXdLd1BUWmNhV0UxQW9OdGdCSmg4cTVKSkFobGN2K2F3enp5?=
 =?utf-8?B?Y3U3ODY2bVIwN2M1WVZ1YmFrSytPL1lMSjQxOFhGN3ltVks5TEtyZ2RqaEo2?=
 =?utf-8?B?MHdyMUw3V29pVUF0TzhTczJBT21BajQyVVN2NG1aNUJmZ29FOHdneTdRc1ZY?=
 =?utf-8?B?QW1UQmpUWjVpZUJBazVDTjhYNmRkWHA4Z3FKeG1LSmtjSFVPajFrVHp2ZVNx?=
 =?utf-8?B?UVVrS0tISk9ETDdSTm56UnRvSGtZdFJTQ2lzMG1UYUhXUEhnVVFNRHdKdXhH?=
 =?utf-8?B?NlYyZU5VTXlWQ21obTJkOGJHMGJxWWFKVjhtMHFMUkllMFh5T3pFVHFGdWpp?=
 =?utf-8?B?NDFaRGhVQ21mVE4yZ3BzWG50YWFBQk9vZXVLYWFiWVRsOTNJTTJuQ2twSHdm?=
 =?utf-8?B?ZW9hbTg0R04rZTJNVU4vTXkvUkhWYVNsVzRxd21xc1dqU25VQ0hCMXhOd2xR?=
 =?utf-8?B?NkpkRmxHSExTR0pXQW0vYkFJbm5KOFFPZjBqM1BTZlhubmtHekRUdHVPbXl2?=
 =?utf-8?B?dnhXRjduU3hiTUwwR21tRWMyUUtqRVBreEVOS1NtRUZ0cys2OGJzS0xDbE50?=
 =?utf-8?B?Ny9aM3paeFVrU3VYdFBYVDNWWlNwSzRlaWNmQmFQSHpkU0tiekZ0OUZZQzJr?=
 =?utf-8?B?TmdGT1ZLWmQwR081cEtSeXZINjhRQUwzWlc1bCtDckdIRXgzQ1Fad0VTUGVX?=
 =?utf-8?B?YTJzT2V3RDFGdE12ZXlBYklMenZMOTdTWjRGNEZpQVlQYjlCSnQ4U1BzMzVq?=
 =?utf-8?B?dWtOMWhKa0N3NURxSFVEa0h6TUQrUFZJWFl0N1ZScU82YlZac24ydStLQ0lM?=
 =?utf-8?B?MXhFdEkxdC85SkNzdGlpQXNEVGwyaEFLT3BUNnE0c3FxclBib00zcGgwTiti?=
 =?utf-8?B?bkNiSTZtL0ZqWG9CcWpRQnZXK0FkZ3VDYm8wZDUycUxIYzJXUVF4OGNucmMv?=
 =?utf-8?B?cUFrd3FZdXhjMXUvNmd6Y0dlMlhVSnFuWVBEbFg0bUwvNS9mR2hJeWNRMExu?=
 =?utf-8?Q?sb+wZ5z9ffvydzZ9tdCquW2qN?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b140110e-f942-47c3-bad8-08daaf3a3aba
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 05:49:45.8532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E8Zcj63djVj5Kx94CTX6OL1T4jgJmKMlBM9/N0V5PCL9ISXdb7dXkLtw4FS1ada3neLoIrIgp8mBveI8Lu5X/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4166
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/10/2022 9:21 PM, Sean Christopherson wrote:
> On Mon, Oct 10, 2022, Santosh Shukla wrote:
>>
>>
>> On 10/7/2022 12:10 AM, Sean Christopherson wrote:
>>> On Mon, Aug 29, 2022, Santosh Shukla wrote:
>>>> If NMI virtualization enabled and NMI_INTERCEPT bit is unset
>>>> then HW will exit with #INVALID exit reason.
>>>>
>>>> To enable the VNMI capability, Hypervisor need to program
>>>> V_NMI_ENABLE bit 1.
>>>>
>>>> The presence of this feature is indicated via the CPUID function
>>>> 0x8000000A_EDX[25].
>>>
>>> Until there is publicly available documentation, I am not going to review this
>>> any further.  This goes for all new features, e.g. PerfMonv2[*].  I understand
>>> the need and desire to get code merged far in advance of hardware being available,
>>> but y'all clearly have specs, i.e. this is a very solvable problem.  Throw all the
>>> disclaimers you want on the specs to make it abundantly clear that they are for
>>> preview purposes or whatever, but reviewing KVM code without a spec just doesn't
>>> work for me.
>>>
>>
>> Sure Sean.
>>
>> I am told that the APM should be out in the next couple of weeks.
> 
> Probably too late to be of much value for virtual NMI support, but for future
> features, it would be very helpful to release "preview" documentation ASAP so that
> we don't have to wait for the next APM update, which IIUC only happens ~2 times a
> year.

Virtual NMI spec is at [1], Chapter - 15.21.10 NMI Virtualization.

Thanks,
Santosh
[1] https://www.amd.com/en/support/tech-docs/amd64-architecture-programmers-manual-volumes-1-5
