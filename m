Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 167E314231F
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2020 07:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgATGQe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jan 2020 01:16:34 -0500
Received: from mail-eopbgr770085.outbound.protection.outlook.com ([40.107.77.85]:47073
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725783AbgATGQd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jan 2020 01:16:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eViEwMYFw938s1G7k5CZJnMHlHz2b+eoYttn16q/zgxbX1B90SzVkpZIQ/ThvCRETk966PNoA1PrUNKnlXGp/9QM3j94oJCNFJJ/iaHlVJ9h+3K1nVON7FZNKFcMMW8RS5XBN4qzXCYlSWwqKo0Emx059VGZw5Om+EUuRvgS5o9FWkyqqKDPOEQUL4n7fkv/f4N7CNwpyiOE8xS7u/42REv3FnBavyiMBJAOaCHHO8EytxY6JCFamabEDzlIFGZ1+Lbo7+OULtGIkIa6WyAZ6q2VQlhkOBKy9Xdb2NggOpPgj/OTgZJZ9DL6lc8llr303bJPKG8lgF20N78Ycuj/Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UdLb9D5Gt2A43LYbPPnUoblTuI1crEaVEqFv4JerRIk=;
 b=mbzpPiWnAkmfO3WlhREHVrTWMBtz6rB9oCpyVVoNCoPcFdNVeAURPULac+16XnXMgak6sn6bv9ft5zEWXrwC8Qhy27bwDePV9oeUwc+I+WSaPbidF4aWh2OqPgab8BBhvaJby8sGEOw8VsO3KA2P0qYMJmuNb4zPSHFA0at6eIfzSIVcHm8PBnqoGgevKfPoSae2M2xz8kStPoDXt7WkoUL0X0xenv2b0rv0he9Ysf6YvsOMeo3Z88WMmjNYzYsEDtEajqcXNe+VdnfrXMAJ4fUxy/DlFJh4WwGwMhtYwBpgPZDVvLjjqmU/SC/4MKKUOhX0SPRS3nGOMmygIezKlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UdLb9D5Gt2A43LYbPPnUoblTuI1crEaVEqFv4JerRIk=;
 b=ysDRdfFSnpeUbkSVAh3PPeDVlk4yd6TbMkX+mVA7WTdeeCdsghbZ7cIXhFqjab1xRanqAidWiK90/NnKBVc29h14WbdZB1gKTyz3hmIOMbgbsxA8fSejep1qcbAfODTEW8FhyPoNKUYJ430+n5YzejoqTcnXFYyRKzcd1NWTCBA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.172.206) by
 DM6PR12MB2682.namprd12.prod.outlook.com (20.176.118.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Mon, 20 Jan 2020 06:16:24 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::fdd1:4a97:85cc:d302]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::fdd1:4a97:85cc:d302%3]) with mapi id 15.20.2644.024; Mon, 20 Jan 2020
 06:16:23 +0000
Subject: Re: [PATCH v5 00/18] kvm: x86: Support AMD SVM AVIC w/ in-kernel
 irqchip mode
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, joro@8bytes.org,
        vkuznets@redhat.com, rkagan@virtuozzo.com, graf@amazon.com,
        jschoenh@amazon.de, karahmed@amazon.de, rimasluk@amazon.com,
        jon.grimm@amd.com
References: <1573762520-80328-1-git-send-email-suravee.suthikulpanit@amd.com>
 <9e3e9692-d786-844e-c625-62b69505d2c9@amd.com>
Message-ID: <b4fa2422-f479-e1e4-11c6-5a4dfda53b74@amd.com>
Date:   Mon, 20 Jan 2020 13:16:11 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
In-Reply-To: <9e3e9692-d786-844e-c625-62b69505d2c9@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0055.apcprd02.prod.outlook.com
 (2603:1096:4:54::19) To DM6PR12MB3865.namprd12.prod.outlook.com
 (2603:10b6:5:1c4::14)
MIME-Version: 1.0
Received: from Suravees-MacBook-Pro.local (165.204.140.250) by SG2PR02CA0055.apcprd02.prod.outlook.com (2603:1096:4:54::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.20 via Frontend Transport; Mon, 20 Jan 2020 06:16:19 +0000
X-Originating-IP: [165.204.140.250]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d1b32654-b56f-498f-ee6b-08d79d7045c1
X-MS-TrafficTypeDiagnostic: DM6PR12MB2682:|DM6PR12MB2682:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB26828E9B30E8FBF685E235C6F3320@DM6PR12MB2682.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0288CD37D9
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(39860400002)(396003)(346002)(199004)(189003)(31696002)(4326008)(6512007)(186003)(16526019)(81166006)(81156014)(52116002)(6486002)(5660300002)(66946007)(36756003)(53546011)(2616005)(478600001)(66476007)(66556008)(86362001)(6506007)(8676002)(316002)(2906002)(7416002)(956004)(6666004)(31686004)(44832011)(26005)(8936002)(21314003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2682;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7wlBbpLOtPHtilvaU//g0v8bnCTdfOUEgwzdmPUrG2TmokxWdTmIKZLxZotNt5k8v6rcMsO4HzWk1B4ht/XEBbsGRjRwxvx1OqtVzec4FkR8MCJXLzDwHcRa7pzjachRmHErIGG2thI9541NpwlH7pf3XtldIjBIJYI3nBWfCuqz7BsWcDN+KFjBpSmEIpGzQvVVX6fLZ3bJC35jwnjagb80IlA3BJeKtMmHanVF+ZSfSuX/bCOT7gdJyUvzw9/CRG9pVE6P5TFDi2YTqo0cAQQ/KcgQ70CanNqrVupv/vm4oHoVSRuGaEs9gMDunihW2XomcVIL9ch5f3LGlmX61HUgRsiEhbqQShETp5J64CVCbqwIYEpXt6iWLQ6JCFyu+soX5G7zSJ1fANAQ99cZjpaEyHeCQDyviWMwJlf53d5DaQkMtauqPNeszdyCVqW20kdrv/+SqXOAtPbuIrKid3af9tR0YMnbQhl6uOoZs0aiZHSagUItJIfgIYEDKUWYU3pQ8vsmr+TZidK/6RMc+1WDSb5nerph/697E7a4Ei4cE4iSQyUq1DVe61vUNW63
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1b32654-b56f-498f-ee6b-08d79d7045c1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2020 06:16:23.7684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4JNSb5mUbC7AboFoRyZSo5TtovG+ZMsmLVzp8dXEmwd1Uy3A6kOnKidOpvQ6uxyMfc1VuXHVE14XzS2EAuytyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2682
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping

Thanks
Suravee

On 1/2/20 5:17 PM, Suravee Suthikulpanit wrote:
> Paolo,
> 
> Ping. Would you please let me know your feedback when you get a chance to review this series
> 
> Thanks,
> Suravee
> 
> On 11/15/19 3:15 AM, Suravee Suthikulpanit wrote:
>> The 'commit 67034bb9dd5e ("KVM: SVM: Add irqchip_split() checks before
>> enabling AVIC")' was introduced to fix miscellaneous boot-hang issues
>> when enable AVIC. This is mainly due to AVIC hardware doest not #vmexit
>> on write to LAPIC EOI register resulting in-kernel PIC and IOAPIC to
>> wait and do not inject new interrupts (e.g. PIT, RTC).
>>
>> This limits AVIC to only work with kernel_irqchip=split mode, which is
>> not currently enabled by default, and also required user-space to
>> support split irqchip model, which might not be the case.
>>
>> The goal of this series is to enable AVIC to work in both irqchip modes,
>> by allowing AVIC to be deactivated temporarily during runtime, and fallback
>> to legacy interrupt injection mode (w/ vINTR and interrupt windows)
>> when needed, and then re-enabled subsequently (a.k.a Dynamic APICv).
>>
>> Similar approach is also used to handle Hyper-V SynIC in the
>> 'commit 5c919412fe61 ("kvm/x86: Hyper-V synthetic interrupt controller")',
>> where APICv is permanently disabled at runtime (currently broken for
>> AVIC, and fixed by this series).
>>
>> This series contains several parts:
>>    * Part 1: patch 1,2
>>      Code clean up, refactor, and introduce helper functions
>>
>>    * Part 2: patch 3
>>      Introduce APICv deactivate bits to keep track of APICv state
>>      for each vm.
>>    * Part 3: patch 4-10
>>      Add support for activate/deactivate APICv at runtime
>>
>>    * Part 4: patch 11-14:
>>      Add support for various cases where APICv needs to
>>      be deactivated
>>
>>    * Part 5: patch 15-17:
>>      Introduce in-kernel IOAPIC workaround for AVIC EOI
>>
>>    * Part 6: path 18
>>      Allow enable AVIC w/ kernel_irqchip=on
>>
>> Pre-requisite Patch:
>>    * commit b9c6ff94e43a ("iommu/amd: Re-factor guest virtual APIC (de-)activation code")
>>      (https://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git/commit/
>>       ?h=next&id=b9c6ff94e43a0ee053e0c1d983fba1ac4953b762)
>>
>> This series has been tested against v5.3 as following:
>>    * Booting Linux, FreeBSD, and Windows Server 2019 VMs upto 240 vcpus
>>      w/ qemu option "kernel-irqchip=on" and "-no-hpet".
>>    * Pass-through Intel 10GbE NIC and run netperf in the VM.
>>
>> Changes from V4: (https://lkml.org/lkml/2019/11/1/764)
>>    * Rename APICV_DEACT_BIT_xxx to APICV_INHIBIT_REASON_xxxx
>>    * Introduce kvm_x86_ops.check_apicv_inhibit_reasons hook
>>      to allow vendors to specify which APICv inhibit reason bits
>>      to support (patch 08/18).
>>    * Update comment on kvm_request_apicv_update() no-lock requirement.
>>      (patch 04/18)
>>
>> Suravee Suthikulpanit (18):
>>    kvm: x86: Modify kvm_x86_ops.get_enable_apicv() to use struct kvm
>>      parameter
>>    kvm: lapic: Introduce APICv update helper function
>>    kvm: x86: Introduce APICv inhibit reason bits
>>    kvm: x86: Add support for dynamic APICv
>>    kvm: x86: Add APICv (de)activate request trace points
>>    kvm: x86: svm: Add support to (de)activate posted interrupts
>>    svm: Add support for setup/destroy virutal APIC backing page for AVIC
>>    kvm: x86: Introduce APICv x86 ops for checking APIC inhibit reasons
>>    kvm: x86: Introduce x86 ops hook for pre-update APICv
>>    svm: Add support for dynamic APICv
>>    kvm: x86: hyperv: Use APICv update request interface
>>    svm: Deactivate AVIC when launching guest with nested SVM support
>>    svm: Temporary deactivate AVIC during ExtINT handling
>>    kvm: i8254: Deactivate APICv when using in-kernel PIT re-injection
>>      mode.
>>    kvm: lapic: Clean up APIC predefined macros
>>    kvm: ioapic: Refactor kvm_ioapic_update_eoi()
>>    kvm: ioapic: Lazy update IOAPIC EOI
>>    svm: Allow AVIC with in-kernel irqchip mode
>>
>>   arch/x86/include/asm/kvm_host.h |  19 ++++-
>>   arch/x86/kvm/hyperv.c           |   5 +-
>>   arch/x86/kvm/i8254.c            |  12 +++
>>   arch/x86/kvm/ioapic.c           | 149 +++++++++++++++++++++++-------------
>>   arch/x86/kvm/lapic.c            |  35 +++++----
>>   arch/x86/kvm/lapic.h            |   2 +
>>   arch/x86/kvm/svm.c              | 164 +++++++++++++++++++++++++++++++++++-----
>>   arch/x86/kvm/trace.h            |  19 +++++
>>   arch/x86/kvm/vmx/vmx.c          |  12 ++-
>>   arch/x86/kvm/x86.c              |  71 ++++++++++++++---
>>   10 files changed, 385 insertions(+), 103 deletions(-)
>>
