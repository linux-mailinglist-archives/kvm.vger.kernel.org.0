Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA6D26C71F
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 20:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbgIPSSu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 14:18:50 -0400
Received: from mail-co1nam11on2076.outbound.protection.outlook.com ([40.107.220.76]:41825
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727897AbgIPSSL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 14:18:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MEnzqIXnilsK/CxvzJcEpELkFu0A0j3bJfCSDyfpxYy8d0Epi9oW6TLVIwZX690kG4mD7aR3JMOWoxt0p6vMMkCyu3hjImqjZeh44HSvMyH1WtYwwDJx93P28C6xzmwWHr2ghfsSSo+ofjD6L1molLqO+sZf2OJahzj/PuAIQI7gXdv6+p4XS+mFYxnO7KrA2FmhTQ1gWPG2+ceadW4yUnWAgXf2KKK9R2e5gmOYLRlrbIW/+hpTQxWaRzRkTMHoQ/KK2uvgq/y4k9fy9UjQt1cTeAqcSJDnDq7jw89veb6QWRSYFl7XREMX8AbydYyQoKKO3upjCmKIJSOpvN+GFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OoD7E5ugCDirOjjb1nna/SbBKuUyyrhoX8p0F6X9NbA=;
 b=O3Y/IJsjsZfAmipZ49XLV+FwqBWJLu65gdndh1lvTapOdvYiiXqKuycWnLBBpNdzn/3MKrDMTFsxyCweEYdqmPss8PZAuYrBMqnhyMOepNTDxs1f+Kj0TXne0jEjkn6HDqpPig2RQ/LaQWOfz8hUz8d7UQu0oAVElfNSIq/wKnDMEw2YGVa8xfD7vDn7z4sSM01iu6KAz0qeVu1G0JYN9sOXCBIBbZ8Lhy332zhiLN7KGoz1kzCVVcLcPWBFyUhWWuw7HH1qFFTAMog/ZQPIeS5RBtRynWo1XcNL0BIlIxIR2tSxhk30nRWGQNTK8MRWJKdIO7CRI8353JwtC1FyHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OoD7E5ugCDirOjjb1nna/SbBKuUyyrhoX8p0F6X9NbA=;
 b=P96apt+kz9IPqMT9WaSZ1gSdngDfyuyS3eDJvdioOx7mcMagomGKuEBhKJtxGF7WzYAQj6up7l8Yfqz1aaT39a0NGl6E3C/iii1URSY9E7aXGUs1CVpHn8vTrTY1XR/UqRkvvs9Cuj7d36Bb5Y7AIcJ37uUHKhe4mdju350sg8o=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3468.namprd12.prod.outlook.com (2603:10b6:5:38::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3391.11; Wed, 16 Sep 2020 16:38:40 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3391.011; Wed, 16 Sep 2020
 16:38:40 +0000
Subject: Re: [RFC PATCH 08/35] KVM: SVM: Prevent debugging under SEV-ES
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
 <58093c542b5b442b88941828595fb2548706f1bf.1600114548.git.thomas.lendacky@amd.com>
 <20200914212601.GA7192@sjchrist-ice>
 <fd790047-4107-b28a-262e-03ed5bc4c421@amd.com>
 <20200915163010.GB8420@sjchrist-ice>
 <aff46d8d-07ff-7d14-3e7f-ffe60f2bd779@amd.com>
 <5e816811-450f-b732-76f7-6130479642e0@amd.com>
 <20200916160210.GA10227@sjchrist-ice>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <b62e055a-000e-ff7b-00e4-41b5b39b55d5@amd.com>
Date:   Wed, 16 Sep 2020 11:38:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200916160210.GA10227@sjchrist-ice>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR10CA0006.namprd10.prod.outlook.com
 (2603:10b6:5:60::19) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by DM6PR10CA0006.namprd10.prod.outlook.com (2603:10b6:5:60::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Wed, 16 Sep 2020 16:38:39 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3b3310e7-cfde-470e-b278-08d85a5ef7a3
X-MS-TrafficTypeDiagnostic: DM6PR12MB3468:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB346858073C2DDEAF815CA3EBEC210@DM6PR12MB3468.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vyyzwFJnXyFR/Ts/JDkaGs81eGE7FkElYXCGDKLZpvqN8U579hZNpK7Pcxb4D5qfIqlHTGBYLJ3JSXXBCJWa5sSTqotiZRJnIRDFgGCRNwvLt2mk9Oh4eivojcoygVInpDJMl4tThF7M/OE8qA990i9xVSiqHGimU+IJGBCrLwcDofJBoQx3fFJsS/ohri+aFhREerVjLQdUWtoiH6Cmx+st8vBaXCwOrDagrQHK39FeA2kFzlmVno4yvO1Xs6mfk0Jdo3m0sZagvwrfvuwrJpdufdgCjL5FnsurVcu54Z1J+7pAL/SmE2Al8PIEPmjn1QUBnen/RXFy9j18HQuXz3z9yKx88YVtrkGKFtYO1dQ79DAg6pp9emfVJGklacXf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(396003)(136003)(39860400002)(8676002)(6486002)(6916009)(86362001)(5660300002)(66946007)(66556008)(66476007)(54906003)(53546011)(31696002)(8936002)(316002)(16576012)(52116002)(2906002)(36756003)(7416002)(26005)(31686004)(4326008)(478600001)(956004)(186003)(16526019)(83380400001)(2616005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: i9WU298unPzuqZoIVAZMledXEuvu2ayjA4S32i2MCLxg4UV9szyV3loiJjNdcetpYFxXvsu82fAbkNX+OenUoTVdH2tCoknFV0xAYAr/jOboyI2jy+dXBB1uuPDwlRyw3Ws7v5TbhHYkRY/hbKeAaLcRtoPdJKyDKax9qygOvkKaXDjlfC+MKP7EE50Om46AKBUCQGlYCeO4a4aLxodqLFlLgXj1oaYwah3J0xNVzn2Q2i0BRzvkP95nRssfiRVAGoX6nUZZFGYo8hi2X4qUNwAQl4W8v+PKOcp3/WNUpvgEGEuC0kAkqgfqUxWbWNq3Eh8FnPGjmy1TCFL0sdH/pSsgTCizvtAoOfnJLwKcnjg5+qUtX1uf4U+bPdgl+BQIvCNX21clPQhdArqMVBybzKk/q8XvbWm3UqjhIIkf+Z/JUaAT1ZORwGNmnhhtaySRCnaPAdl8xIospVoetcsvT4QRlKxbP9Q/q7Xd9pyMMKoIOI2E27OK8Pu7ogoFBSBZJcRQdCdRCcbPAzQtBDa5DpJc+EW2dRugC3/cLFaA+RfSk1clQAVVtEdQydw1NcnfswF3gvkcx3J6/CrQEABrp6QYWjAsKZHOhn/QhkkOi6J8ZcHqg+xoOzBNN9KcDJs9pUE+keX8Gt2DqYWrqzJ6Pw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b3310e7-cfde-470e-b278-08d85a5ef7a3
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2020 16:38:40.2900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t9mjVPN6wck7D/2MQAo1aonLa1pOePs2ch1+KtpZAuCRj5CzCzHSUuTGhBbzleMOrBfZNWoBCiaCshzkbdsHgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3468
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/16/20 11:02 AM, Sean Christopherson wrote:
> On Wed, Sep 16, 2020 at 10:11:10AM -0500, Tom Lendacky wrote:
>> On 9/15/20 3:13 PM, Tom Lendacky wrote:
>>> On 9/15/20 11:30 AM, Sean Christopherson wrote:
>>>> I don't quite follow the "doesn't mean debugging can't be done in the future".
>>>> Does that imply that debugging could be supported for SEV-ES guests, even if
>>>> they have an encrypted VMSA?
>>>
>>> Almost anything can be done with software. It would require a lot of
>>> hypervisor and guest code and changes to the GHCB spec, etc. So given
>>> that, probably just the check for arch.guest_state_protected is enough for
>>> now. I'll just need to be sure none of the debugging paths can be taken
>>> before the VMSA is encrypted.
>>
>> So I don't think there's any guarantee that the KVM_SET_GUEST_DEBUG ioctl
>> couldn't be called before the VMSA is encrypted, meaning I can't check the
>> arch.guest_state_protected bit for that call. So if we really want to get
>> rid of the allow_debug() op, I'd need some other way to indicate that this
>> is an SEV-ES / protected state guest.
> 
> Would anything break if KVM "speculatively" set guest_state_protected before
> LAUNCH_UPDATE_VMSA?  E.g. does KVM need to emulate before LAUNCH_UPDATE_VMSA?

Yes, the way the code is set up, the guest state (VMSA) is initialized in
the same way it is today (mostly) and that state is encrypted by the
LAUNCH_UPDATE_VMSA call. I check the guest_state_protected bit to decide
on whether to direct the updates to the real VMSA (before it's encrypted)
or the GHCB (that's the get_vmsa() function from patch #5).

Thanks,
Tom

> 
>> How are you planning on blocking this ioctl for TDX? Would the
>> arch.guest_state_protected bit be sit earlier than is done for SEV-ES?
> 
> Yep, guest_state_protected is set from time zero (kvm_x86_ops.vm_init) as
> guest state is encrypted/inaccessible from the get go.  The flag actually
> gets turned off for debuggable TDX guests, but that's also forced to happen
> before the KVM_RUN can be invoked (TDX architecture) and is a one-time
> configuration, i.e. userspace can flip the switch exactly once, and only at
> a very specific point in time.
> 
