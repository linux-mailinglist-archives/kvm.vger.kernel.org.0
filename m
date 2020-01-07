Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7B513307D
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 21:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbgAGUQn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 15:16:43 -0500
Received: from mail-bn8nam11on2063.outbound.protection.outlook.com ([40.107.236.63]:43105
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728379AbgAGUQn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 15:16:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CoIsC/cCBZ46AQUkQu1pKarxWQs+3Zl8ClgM8bn/ly5B7CYkR3WFiqz+3cJRwMXmcG0LcGlgTg4au9GQ8Wxniy4JruUqu0wdpmhpDhBhxfaHpOkodlGgda1KTqCr12yMFiMa8gy0CHMjpePsieYf33ZyXqznCWUVBKZyqHs8vWB5Mqlmg4+qg1H94XQeq6cEeQKukJZxUkEWBr+fdWXPqAhKRhtOAxHH71f2kfA+buWFXek9yULLPrHBEhi3VB/uaOvHz4KhcJmKIfnNqWg1MFfYUfNNPzYeT2Woe2B/SZ0IyROQ6N0hl3Dcg4G9Wlt7ownUnXCeo9k6xx+WJoaGeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SKHZ30Cvzabcrsk7Sy8A4LjLrswDhrdcGSXUfMUHsms=;
 b=Of8y0k56lwYMDBO4Sn7WHtLqrqLOlndCSriaMe4DxilMWdpVXNxibW7VoZiMnYAfyC0d0I3Bqx/ZGFTE5HhnpNkQo3LoJIwpmfIqO97CC4VivoC0lAHosods18Tp/1wNqDyY7OqZuFzsPSo8lclpCuKNyUvRc0f9u2Lubsw4w3Bgc19qf4r8IXeNXxKnS9Wz3Q3O56ABXk5tQqf13ZjucpnwKKwGR5DAoFW9B9EfXE/rf0Ut1jJJlMPAM2843JiGRuLc+P67C03a1UzoARV+zd/vS40hV1cjWS4QiOqrrRP175T1XCnj/69fB+KBcnLarJKrANUIjLPZuvaiKxJVZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SKHZ30Cvzabcrsk7Sy8A4LjLrswDhrdcGSXUfMUHsms=;
 b=vJ3QKVYMlpRTdsligrsG9W0ij0wMW2gWe1oeWobCBTM+zlVT/SG9gGt7wS2XZZGiBAAINjB0eEFvIbb8NQhj7lYL9kBUZankpcR+JjHGHiIXcMFtqvTu/Di4e/AUs4jaxdqRj+cEttp00tJFFIHlsXEuGX9i6H9GYvua5qAR+NI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.71.154) by
 DM6PR12MB3355.namprd12.prod.outlook.com (20.178.29.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.13; Tue, 7 Jan 2020 20:16:39 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::a0cd:463:f444:c270]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::a0cd:463:f444:c270%7]) with mapi id 15.20.2602.016; Tue, 7 Jan 2020
 20:16:39 +0000
Subject: Re: [PATCH v2] KVM: SVM: Override default MMIO mask if memory
 encryption is enabled
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <d741b3a58769749b7873fea703c027a68b8e2e3d.1577462279.git.thomas.lendacky@amd.com>
 <20200106224931.GB12879@linux.intel.com>
 <f5c2e60c-536f-e0cd-98b9-86e6da82e48f@amd.com>
 <20200106233846.GC12879@linux.intel.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <a4fb7657-59b6-2a3f-1765-037a9a9cd03a@amd.com>
Date:   Tue, 7 Jan 2020 14:16:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
In-Reply-To: <20200106233846.GC12879@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR01CA0006.prod.exchangelabs.com (2603:10b6:805:b6::19)
 To DM6PR12MB3163.namprd12.prod.outlook.com (2603:10b6:5:15e::26)
MIME-Version: 1.0
Received: from [10.236.30.74] (165.204.77.1) by SN6PR01CA0006.prod.exchangelabs.com (2603:10b6:805:b6::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.8 via Frontend Transport; Tue, 7 Jan 2020 20:16:38 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 27609db1-de51-4c75-11ef-08d793ae80ed
X-MS-TrafficTypeDiagnostic: DM6PR12MB3355:|DM6PR12MB3355:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3355DA22047940119A472C8EEC3F0@DM6PR12MB3355.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 027578BB13
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(39860400002)(396003)(376002)(346002)(199004)(189003)(81156014)(2906002)(6916009)(5660300002)(16576012)(8936002)(81166006)(316002)(8676002)(86362001)(31696002)(6486002)(2616005)(956004)(36756003)(26005)(186003)(4326008)(53546011)(31686004)(16526019)(66476007)(52116002)(66556008)(54906003)(478600001)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3355;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zMpvyS2xRvc1SOGTwolDzeL8T/g4PqcqR1+DvvKyx5ruqPG7WtD+E/I638xW606BmNxub88y0WqIDeGFug6jVutbkbj/+YwkGUBo9V7IrWeb6RlH/1P4bkb5P6dT07LhOa7IAkKhlQF3PQ3K//almIktCaI09C8c7a/+Vj3URrzIb7Vs+dt9Rr+oDSxA5okXF13uk4KjAUMjwhln+iwrk1ITQfvX990XQMUMRUzGWtLfJx2ho5yk1xAWwlv1knR9WzK7KHPfJbBwtm0WqbN8t8WX/pZsl+qAAtOj3i6Mja4cQSmDWBrJTukbjB+1c7FSQ4PmprqM4aX4dXLG/jjmXJgm7Kkv5EUBTpu0Ap5u+6SXoIp2pGo8PWne+O0j4P3Qxi4Zw1d0QfTeb5rpscQAHSkIXa3Rwi1ZRJ2mVb0Au8QE7PbLGqJjdn1qCJPNxPdU
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27609db1-de51-4c75-11ef-08d793ae80ed
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2020 20:16:39.4626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qO7K0Fry01MG87+r8tSUSn5ZOaZOQBDGyCGzQOaEBepAf4JapITT5UNnhN+HdW6O7L+n7oW+nsxYdMbbut4Ncg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3355
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/6/20 5:38 PM, Sean Christopherson wrote:
> On Mon, Jan 06, 2020 at 05:14:04PM -0600, Tom Lendacky wrote:
>> On 1/6/20 4:49 PM, Sean Christopherson wrote:
>>> This doesn't handle the case where x86_phys_bits _isn't_ reduced by SME/SEV
>>> on a future processor, i.e. x86_phys_bits==52.
>>
>> Not sure I follow. If MSR_K8_SYSCFG_MEM_ENCRYPT is set then there will
>> always be a reduction in physical addressing (so I'm told).
> 
> Hmm, I'm going off APM Vol 2, which states, or at least strongly implies,
> that reducing the PA space is optional.  Section 7.10.2 is especially
> clear on this:
> 
>   In implementations where the physical address size of the processor is
>   reduced when memory encryption features are enabled, software must
>   ensure it is executing from addresses where these upper physical address
>   bits are 0 prior to setting SYSCFG[MemEncryptionModEn].

It's probably not likely, but given what is stated, I can modify my patch
to check for a x86_phys_bits == 52 and skip the call to set the mask, eg:

	if (msr & MSR_K8_SYSCFG_MEM_ENCRYPT &&
	    boot_cpu_data.x86_phys_bits < 52) {

> 
> But, hopefully the other approach I have in mind actually works, as it's
> significantly less special-case code and would naturally handle either
> case, i.e. make this a moot point.

I'll hold off on the above and wait for your patch.

Thanks,
Tom

> 
> 
> Entry on SYSCFG:
> 
>   3.2.1 System Configuration Register (SYSCFG)
> 
>   ...
> 
>   MemEncryptionMode. Bit 23.  Setting this bit to 1 enables the SME and
>   SEV memory encryption features.
> 
> The SME entry the above links to says:
> 
>   7.10.1 Determining Support for Secure Memory Encryption
> 
>   ...
> 
>   Additionally, in some implementations, the physical address size of the
>   processor may be reduced when memory encryption features are enabled, for
>   example from 48 to 43 bits. In this case the upper physical address bits are
>   treated as reserved when the feature is enabled except where otherwise
>   indicated. When memory encryption is supported in an implementation, CPUID
>   Fn8000_001F[EBX] reports any physical address size reduction present. Bits
>   reserved in this mode are treated the same as other page table reserved bits,
>   and will generate a page fault if found to be non-zero when used for address
>   translation.
> 
>   ...
> 
>   7.10.2 Enabling Memory Encryption Extensions
> 
>   Prior to using SME, memory encryption features must be enabled by setting
>   SYSCFG MSR bit 23 (MemEncryptionModEn) to 1. In implementations where the
>   physical address size of the processor is reduced when memory encryption
>   features are enabled, software must ensure it is executing from addresses where
>   these upper physical address bits are 0 prior to setting
>   SYSCFG[MemEncryptionModEn]. Memory encryption is then further controlled via
>   the page tables.
> 
