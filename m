Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0684167ED
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 00:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243442AbhIWWZe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 18:25:34 -0400
Received: from mail-bn7nam10on2059.outbound.protection.outlook.com ([40.107.92.59]:59488
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243425AbhIWWZd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 18:25:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CUs0h4v2FY5AWFI/iYgQQ3vl4enVVgjtfb4MIra/CFERwvEsi8P2r+kpZwqcuJXLMrN0mvmYr4jfo0BNXjPOpLvlxqED5+3T6b0rDt6YbLXAdZXYaKpkBEXwD/fvdEpaw6lHTIrkpF0MCsM3QUk864vRCbKZjs4/0sWB5WRKrFhLUl3m2+M989ULOkfQEezNdkliv61DI18PUXXVSdSfLd46045/TS6uyFi1LEWvER6cU6Vmvzb52cV+DaS8zhCFQfW1TpfVeY5VyK8E9SryRovJt3jVcLyVwSSRKfDUYzBxJwA4aeP1FchJHeT7zO9wE2/qy1VZxKtYUBmWyEwdgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=TILGgBHNK5iX4iEzDaB+qi6p3SwfwEk6BQWXKUa4PAA=;
 b=XuE4UxBjcdWrDV+UMKajyd+iV5bB+bG0aJinQtcA9Et2m25t+DQhxXba1p0OUaWtn20jD3eTCrlOmbT9vycWrD6/iU10kFzI7QcUI7xn1ZVdU0XCYhLTXqhVQ0b/mxk3Nk0+Np3ZrYPN4SRTS9fCJhBVacY4BJlQxUHnA2brp1mxoejOYDFw81vMIGJAPjibEwV7394GaOq2mqGD97r1j3EzzDYtVDWtNyh+TXXtFnm0eHjc8BWKQ7+qLefiJiAAcF9o9VHxPD6/9Z7b/0StyCHUSK0bLA00m9clK8ZroM+FyCVBw8fpbXJFR0q6I01HPRbl4MYa33OQWGiAQPF+fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TILGgBHNK5iX4iEzDaB+qi6p3SwfwEk6BQWXKUa4PAA=;
 b=jUimGBVkXVGoEFNrmTGI/5JEup+qeznuwesCn82DePjuaNvtA0cqgHasIQ9YHzvnoyqX3+rdZ9kDjZ9cFZzko19zJk3od4uZbsb5kbPcia/lpyHbFdLBldzfFnM+yDf3bXJYXSJguH6Ty5Xjaw29MexonjuvQgHXOdC2ZpC68u0=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4511.namprd12.prod.outlook.com (2603:10b6:806:95::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Thu, 23 Sep
 2021 22:23:58 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4523.022; Thu, 23 Sep 2021
 22:23:58 +0000
Subject: Re: [PATCH Part2 v5 21/45] KVM: SVM: Make AVIC backing, VMSA and VMCB
 memory allocation SNP safe
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-22-brijesh.singh@amd.com> <YUt8KOiwTwwa6xZK@work-vm>
 <b3f340dc-ceee-3d04-227d-741ad0c17c49@amd.com> <YUzJ1VHbSIrKYy0c@work-vm>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <21eff550-265e-cbd9-0751-73ee87049044@amd.com>
Date:   Thu, 23 Sep 2021 17:23:55 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <YUzJ1VHbSIrKYy0c@work-vm>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: SA9PR13CA0101.namprd13.prod.outlook.com
 (2603:10b6:806:24::16) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SA9PR13CA0101.namprd13.prod.outlook.com (2603:10b6:806:24::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.7 via Frontend Transport; Thu, 23 Sep 2021 22:23:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 751a1848-4414-414e-4f49-08d97ee0d626
X-MS-TrafficTypeDiagnostic: SA0PR12MB4511:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4511D95F83CA3800A359EB02E5A39@SA0PR12MB4511.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iOd4PGxclgsVHihH6Fa0jAO5hWYrrr3vmzmeHPfrPV9Xt5bdgZNI4c74tfjtFSN20pzwO/AFdYfQ6pkp6l6YI+EmvywTLVOHZ8XVjW4zrh37hrwSy/WJTB28ZNqr3oO1wHj+lAJBzKBzl7OMgAOyvE4NSXvUefbrIl0TgaQOyoxeRnPOqhH+pcvfBoeIfE9W7V5wLQwrf/+dV+w2ATYHhHtQjcTzYAodci21j7fCkQuIJjpr/raSy5wmNqze8pu6b60EyNmHDsAbTbY2hr5IYMly7NwumEqzFpUnCVQD+g4boyy5Fkrx5tal31airi9dj0P8CddrHlEPdUSxnSiqDj2gof7jNlzUKjorUK/FyqcHuHmMrVU2Drw1MI0Sw6jcp1NLeFuq5NbNOG2mCuoUJR3lIDAunPIaq6zx0p/qFocjCrUqFwsfF/1RrBOYf+hCOWk3cMR9Qxw/GWtz1l9NX4eY6jxqROXDjWs2gg0wkiIatlGV9OFpROhBO9iOkX6NUpjVffHvXLZ6cEiCcewgfqPwbmdb3oALsOevNZ3vz5v0t5mpb0cIuEI/xMGQCl83Rjf7Mc50qkN6kMkogrhvf6ZkErkmXvI72OgGVQZMZafjiIyNGUmRmtQc4iw1edYEJgyqb4yLD6cqs3Ur0wm9ln7DknfIbdp3TvxQmzGYEqWzkljOU+RLUYs3qfxBA+Ou481vomAOLqO95h2SHVsgQv5Mf5/d1TXbj6vLgpVlSiI837GJ9P2HJwCsP4JqI9g8BIk1rjY6gPrN/a0LZD+Jsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(508600001)(5660300002)(8936002)(2906002)(6506007)(53546011)(6916009)(36756003)(2616005)(26005)(8676002)(316002)(956004)(66946007)(7406005)(83380400001)(54906003)(66556008)(7416002)(186003)(66476007)(31686004)(4326008)(31696002)(86362001)(44832011)(6512007)(38350700002)(38100700002)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MTJwejdOY0tya2t3a0IrbzR1T0dhMlptWkI0SDJNTk9hRXNnT2xsUUt1Nm1N?=
 =?utf-8?B?blVleTNneXlleThXMEdvT3lTa3NuTFNwRGVqcDBPeE10OS9QTkxMRHR1dnlE?=
 =?utf-8?B?Kzc5RXh1VEJSWTlGM3o5bnVuVjd3dVJPNUtQdi9xeHpkbTdDREhWMFR5VS9Z?=
 =?utf-8?B?amcyS3FLc1daUVdFUDcwa0F1UXhiNFdWWSsvSzFyUDVTODVodW5ZcitTa1hE?=
 =?utf-8?B?UnpWZUxmd1J4dkt0MVFDV3l4VXBpZjY3Q3lGVzRieEZqaFk1c3IvZWtaV1VO?=
 =?utf-8?B?TnZ3c0E4OVhxaGpycFQxUW0rYngzT2R0eCtLajJ6TGxLUE1OY0VPaVJENktm?=
 =?utf-8?B?UEQvelptV3BYNm9MOHVCcHV6ZFk4WEdjYjMrU3BsbkRvcGVYTVc1MnVmdHhZ?=
 =?utf-8?B?R2ljaHEzWU1ETTc3TXFmRG1FUlB1bDJ5dzdVenJkYTZwTUN6bEFISWRUNjJy?=
 =?utf-8?B?ZHFRcnRGY3N6anF2NEl6WGFDU0pmRVFrUkVoakc4ZXNKUGw2WEZLcGpNNkhQ?=
 =?utf-8?B?dDc3QTZOYXc5dDV2ZHFVbDZ4VkxLallhMTZldC84MVFhZFVQOGJOMmxTWjZK?=
 =?utf-8?B?K0wzbTBzWmU4RWVQdnRYQnFoUmk0SWJSdk1KQWdBRjQ0RWtwUk5JcEV4dUMv?=
 =?utf-8?B?OXZUK0RlN3J1UnR1WEdES2N3Z2pkcjFnTjE3b29uTXJyMHJjbDFSbVc4ZDVF?=
 =?utf-8?B?VHYyVDR6RnRsdzE4cUxtUUFJTnRERTcvSXlKZjJNVE1mQVRjRzVqbzJ5djhC?=
 =?utf-8?B?MjhBc2d4TlBnM2ZCdWRsTDA4SEJIcVdybGhVS205bytjN1pEQklXdkp5bDZ1?=
 =?utf-8?B?YXpRT2RpdUR5ODlOTnRXMHByN1FtR2Z0Zm0wd0VqczVLSG94d1pXeWxaK0tt?=
 =?utf-8?B?M25la2JiUHlBWFRlczFGaFhXUGNlaEp4OU0vUUExaHZHV0daMGxmUCtNV3Iv?=
 =?utf-8?B?WVNNMkRhVC9XMWNWb3FDSEJodjR1YzNNT0pzR25SOEZ2K2tRS1NGQzBQS2Yz?=
 =?utf-8?B?KzZyTXBGRDU5SmRsU0lGT1c5cXJhQmMyV2EzZ2RLWUhpdGVzZlhLbW5JckhV?=
 =?utf-8?B?SFQraCtRRkVZUHZQaFF5azAwY3plZStLVXVtYXpCUHRzQ3VXZFhvVjh2ZW5k?=
 =?utf-8?B?WnlrbnJsU3Z2QVhIQTVwdlA1cVhxNlJkMVVVRllWYkhmbnIvQ0NMbDh3amRQ?=
 =?utf-8?B?UjlIVkY5UmEwT0pGMmhNUnN4NzJMSVBpMEFKbEZ5aW5NNWdEL0VRM2VaU1NG?=
 =?utf-8?B?NFBXZFFqUE5jcXBmRjluODRCZUtvR2NkeC82dGsvOUM1aE9aWlJJSFdsaEs1?=
 =?utf-8?B?YjYvSUxtYjBhR3YzVk5VbDVINzEyZ1JCdWxhczBOTFdUZnZyNU1KSG1Eek41?=
 =?utf-8?B?Q0Z2U1dPM0c3WXVXYm95cGtIeTdWaTFWN3dDcTFNN29XMDdxS3RnUmNld2t3?=
 =?utf-8?B?YXEyTXQwMk4xcHZkdUdnRzRXcHNFNEhUQ3hxbmUzTEFwR2JBdzJuZXc4bWZX?=
 =?utf-8?B?cVV0SVJMUVZGNjRPVzAzeU1IVVNoM2JVQ1BNb2NOMmhPcEVtVjg4a09HQjZ5?=
 =?utf-8?B?OTJPcWlxaGJ1cDN6aWx5UzdDeDFvVFBPWERSM1IrMll2Y0ttTkxtbk5ZRDdK?=
 =?utf-8?B?NXRqbkVaTmdqVnd3L0NYdTRjL3ArclR6R1g0MHdXTUpFNlY3NFJ6WjJSUmV4?=
 =?utf-8?B?cXBISEhiME5Kc1hGR090cVlKR3QydktBOWFJQXNvOGgySlRGMlQwRm50bDlV?=
 =?utf-8?Q?hPA9z/mWSprYjZ4BgNqiaZU4A33ha3uHMSsynsW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 751a1848-4414-414e-4f49-08d97ee0d626
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2021 22:23:58.3772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TWV3H7u1IwfjqAE6A2ncjefGMTPUE3TeKG59Z5iWbzz0rbYsSGJtJGV2ZrxDcASaXdOWMfDm2tWLKNYD723u8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4511
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/23/21 1:39 PM, Dr. David Alan Gilbert wrote:
> * Brijesh Singh (brijesh.singh@amd.com) wrote:
>> On 9/22/21 1:55 PM, Dr. David Alan Gilbert wrote:
>>> * Brijesh Singh (brijesh.singh@amd.com) wrote:
>>>> Implement a workaround for an SNP erratum where the CPU will incorrectly
>>>> signal an RMP violation #PF if a hugepage (2mb or 1gb) collides with the
>>>> RMP entry of a VMCB, VMSA or AVIC backing page.
>>>>
>>>> When SEV-SNP is globally enabled, the CPU marks the VMCB, VMSA, and AVIC
>>>> backing   pages as "in-use" in the RMP after a successful VMRUN.  This is
>>>> done for _all_ VMs, not just SNP-Active VMs.
>>> Can you explain what 'globally enabled' means?
>> This means that SNP is enabled in  host SYSCFG_MSR.Snp=1. Once its
>> enabled then RMP checks are enforced.
>>
>>
>>> Or more specifically, can we trip this bug on public hardware that has
>>> the SNP enabled in the bios, but no SNP init in the host OS?
>> Enabling the SNP support on host is 3 step process:
>>
>> step1 (bios): reserve memory for the RMP table.
>>
>> step2 (host): initialize the RMP table memory, set the SYSCFG msr to
>> enable the SNP feature
>>
>> step3 (host): call the SNP_INIT to initialize the SNP firmware (this is
>> needed only if you ever plan to launch SNP guest from this host).
>>
>> The "SNP globally enabled" means the step 1 to 2. The RMP checks are
>> enforced as soon as step 2 is completed.
> So I think that means we don't need to backport this to older kernels
> that don't know about SNP but might run on SNP enabled hardware (1), since
> those kernels won't do step2.

Correct.

thanks

