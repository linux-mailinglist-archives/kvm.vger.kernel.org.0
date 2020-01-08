Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF19F134A8F
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 19:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgAHSlG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 13:41:06 -0500
Received: from mail-dm6nam10on2055.outbound.protection.outlook.com ([40.107.93.55]:6241
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725941AbgAHSlF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 13:41:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NxVGWL9fciEH9/e9lNWDBXQu7cnBQJPVADzDI63GHaXkrsTznqb2qM9qT6cQHUcK9M8VwZPXI3ei3MJAFl5RtnPedDfTnbRGSrh09iOBCc0LJFMRoR4nVpikIJ4NaH8JWL6GJwg+qApMaYCRJeBmT4wtrF77njowaIbqRNuNEcKWaEjUMB64lhD6pWaPYfKf2s8iDeYXn6Z5M+joaHrD7M8bR+7j/GsbxGBPifomzpKZbFq+OVL41OEOS6MpjQprczqgiq6mTsLJ0ZfrybVAyms/zgQqGqdBW1hSJTbws23qIMCZpTm7lGoMHzbFWjCzyuE8yxvPcCGPTtfr9hK/NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zJC6SyCN1Izu9JZRaQCPdwQVhnWLTyutTEsZXidI9Cs=;
 b=VXK9wlBeL1lZGQwGPpk9pet2g58aKyrfJZwm89iyH8St25Z8+g8PF/4tWQvfRrJwhCqyrUJZO5vDmrM6+ZFpbxVcPpV0pb2UmBtKgITmCl7Fzk1LJOc3U5vjK3wnyqzXqc8lXJOUulNoBFB3BqzlgwX8DW5RtHZBBducgECJGJpIQB1Gvev8QWh98zpFy0KYTEdJyVYdfkEzopraUAFMhtKF+9JyDsegcRHt2DTAlYH4Jp5NNyGTVIJThSEK1Cr64fGMK+YUh8r73sk07riqcLXhRuYiN7Vtdw6R/8NdbwBP4r+uuMaRXAhn6lmIhmPeDVyHh6K7/Qf/CBchwgLqEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zJC6SyCN1Izu9JZRaQCPdwQVhnWLTyutTEsZXidI9Cs=;
 b=EGDMw8mChy/a6R6BNg2rGb+MDO3RIC7Yv64PFIlXiYic2whpmTg6UjMcKtxTzGJXnAAdtI92ZmPQEImT4K7GMMqbAjIq/li66BJ1D+cHJ3r7dB82iJJ+BQfsNYcjhSAruLJXi98amYFOF162kICrvKvInlSGuZSjbhc7e7M3UKI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.71.154) by
 DM6PR12MB3179.namprd12.prod.outlook.com (20.179.104.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Wed, 8 Jan 2020 18:41:03 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::a0cd:463:f444:c270]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::a0cd:463:f444:c270%7]) with mapi id 15.20.2602.017; Wed, 8 Jan 2020
 18:41:03 +0000
Subject: Re: [PATCH v2] KVM: SVM: Override default MMIO mask if memory
 encryption is enabled
From:   Tom Lendacky <thomas.lendacky@amd.com>
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
 <a4fb7657-59b6-2a3f-1765-037a9a9cd03a@amd.com>
 <20200107222813.GB16987@linux.intel.com>
 <298352c6-7670-2929-9621-1124775bfaed@amd.com>
 <20200107233102.GC16987@linux.intel.com>
 <c60d15f2-ca10-678c-30aa-5369cf3864c7@amd.com>
 <20200108000412.GE16987@linux.intel.com>
 <e2b183a8-ffea-2df4-2929-a7f67cba8a81@amd.com>
Message-ID: <ac5e2a0b-10dc-9750-061c-2b2e44f7d820@amd.com>
Date:   Wed, 8 Jan 2020 12:41:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
In-Reply-To: <e2b183a8-ffea-2df4-2929-a7f67cba8a81@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR05CA0035.namprd05.prod.outlook.com
 (2603:10b6:805:de::48) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:15e::26)
MIME-Version: 1.0
Received: from [10.236.30.74] (165.204.77.1) by SN6PR05CA0035.namprd05.prod.outlook.com (2603:10b6:805:de::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.4 via Frontend Transport; Wed, 8 Jan 2020 18:41:02 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 14b43a1a-e11a-40b2-af32-08d7946a5075
X-MS-TrafficTypeDiagnostic: DM6PR12MB3179:|DM6PR12MB3179:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB31791DDA78743B08A4B47E72EC3E0@DM6PR12MB3179.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 02760F0D1C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(396003)(366004)(376002)(136003)(199004)(189003)(6486002)(2616005)(31696002)(2906002)(4326008)(31686004)(86362001)(316002)(53546011)(956004)(5660300002)(16576012)(54906003)(36756003)(52116002)(6916009)(478600001)(16526019)(8676002)(81166006)(186003)(8936002)(81156014)(26005)(66476007)(66556008)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3179;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PeBa+kZPFPdbd0U8t1BwfcCw66z+80VheC4zLznQE6lcxiCIAoabeY0EPJDwOeuQMQGR5ewh0hhD1dg9fDqU0faLINJDG/FatB5zhhO5LYm8wtysr3xjlQmF2oMEQUyuqV80xzUhA18X5okLbme5aJJrg13XuyXKS8Yxy5l2SRMFtmKMHNnwpqygvyKj4x2O4e9YQ6ekrKtLy9N7MKZCk4LVTmShsCKWefLBGIobZ/d2FrZdYKBOFj2oaxXUdbayNBAUllb5C3gqwIKklEMrdzNv+COAeguqnvJ++ptZT4F4IKOoJd1TOO+EQxJpN8ABu795Gmi21dmFowHqOHV7BE70uoRpji2rd6+7+b739bs0Jby6E4Y+FlvoCdF+6GspgB2ZcaHLJqZayCZj3Bq5Og/dgI6v79PgVAI9EkeGza1pt+mx8Gzh8ocPKPZM3ObA
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14b43a1a-e11a-40b2-af32-08d7946a5075
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2020 18:41:03.6736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gq765lgufZm3zZ/73EgU+MhnCNGGj4+aHFBeQvuOuLqaN/I+TJdP2JvWhDVTz9XCmp45zcnhbbFNK+RWKBzkGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3179
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/8/20 7:57 AM, Tom Lendacky wrote:
> On 1/7/20 6:04 PM, Sean Christopherson wrote:
>> On Tue, Jan 07, 2020 at 05:51:51PM -0600, Tom Lendacky wrote:
>>> On 1/7/20 5:31 PM, Sean Christopherson wrote:
>>>> AIUI, using phys_bits=48, then the standard scenario is Cbit=47 and some
>>>> additional bits 46:M are reserved.  Applying that logic to phys_bits=52,
>>>> then Cbit=51 and bits 50:M are reserved, so there's a collision but it's
>>>
>>> There's no requirement that the C-bit correspond to phys_bits. So, for
>>> example, you can have C-bit=51 and phys_bits=48 and so 47:M are reserved.
>>
>> But then using blindly using x86_phys_bits would break if the PA bits
>> aren't reduced, e.g. C-bit=47 and phys_bits=47. AFAICT, there's no
>> requirement that there be reduced PA bits when there is a C-bit.  I'm
>> guessing there aren't plans to ship such CPUs, but I don't see anything
>> in the APM to prevent such a scenario.
> 
> I can add in extra checks to see if C-bit == phys_bits, etc. and adjust
> with appropriate limit checking. It's in the init path, so the extra
> checks aren't a big deal.

Just sent V3 of the patch. I believe I have all the areas we discussed
covered. I also went back to using rsvd_bits() as was used before the
L1TF changes. Let me know what you think.

Thanks,
Tom

> 
> Thanks,
> Tom
> 
>>
>> Maybe the least painful approach would be to go with a version of this
>> patch and add a check that there are indeeded reserved/reduced bits?
>> Probably with a WARN_ON_ONCE if the check fails.
>>
