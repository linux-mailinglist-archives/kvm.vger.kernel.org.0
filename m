Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 672F2239D93
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 05:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgHCDAV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Aug 2020 23:00:21 -0400
Received: from mail-dm6nam11on2041.outbound.protection.outlook.com ([40.107.223.41]:55392
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725820AbgHCDAU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Aug 2020 23:00:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ahSoLvLNGdltTfAzA5VP0OvHUBzSgmXsgQO/J+hW5NejsGVFgwqxOEA/NV4cPJTl9HtOhqd/11qj9RDug9IffvHDt3bfrWdHMfNi9R080VUehjqc9t2ohrg5zqOTIfFSh5s9w/0rPB/pM9GkZ88OaMf2FYYnTUmjOmneSH9Hb+youLWAX9y75XCHBjVrRU1Z5mXFj1BtTFesggncG+0pAI6papjfrJ6n3K+X72WXxz5DO7+3As8EAfpGlvcDJzENlCH9TXB9B5neVcNuweCUryz3gI06PaJuND/yGDFSCZniAd0zNIrbyWm2+VluyEvkcoMszCU1HjMgLor0I/aaSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gj0Pj66E9gFyC2PrIGgefAQvP71HaSepBzXsitVrYBw=;
 b=l24OK3N01g9PF7HxEITpG3eqp7SNodNDLcUgeCx71OjKsNy5Ez9u9DJyiPe/nRXRUFnCxTmjJv6RjonB5A38OTgyuHqigCFboRj1hjzBBpvgYO8euaFJ9L9/qnDGktg5W/AudyXyoiaI34xGseUSLtrunC/ure1NVejDYkktKYXG4plD19Ibrzi8S1KleaZI1A62bb8AvQ6aIzr4TvOQkASELPDA+WhLBqdnn9Icg80HDm5cGp2YsmLGIGncXJ/VpcNvLh2jy840O6GQNdBHVBjdfhEH2N0QlZ8qJ9ylhjREMq4ILFJtyEXLHAMjZ0t9XG3Kgj4xdYF2xZ8+GqrphA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gj0Pj66E9gFyC2PrIGgefAQvP71HaSepBzXsitVrYBw=;
 b=YDp34FgqsLTW6spUkMkvixliiM6p1/E7AXW7Z0rjpLIDPtD7eTqsDfG9dteHezuT6yzwnmH0NJ1klAr97MsPrgGsSJOrxQ0iXRMBsBp24fM/piNXr82/eifEmGmFkoteFr147cj0meE8rZzLWqdgUHzsZ1ReuFzz1id7XiRlhao=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 DM6PR12MB2716.namprd12.prod.outlook.com (2603:10b6:5:49::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3239.21; Mon, 3 Aug 2020 03:00:16 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::15d7:c2da:d92a:2162]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::15d7:c2da:d92a:2162%11]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 03:00:16 +0000
Subject: Re: [RFC PATCH 0/8] KVM: x86/mmu: Introduce pinned SPTEs framework
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        eric van tassell <Eric.VanTassell@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20200731212323.21746-1-sean.j.christopherson@intel.com>
From:   Eric van Tassell <evantass@amd.com>
Message-ID: <b5cc5643-4790-3c88-e767-1a7506afb2ae@amd.com>
Date:   Sun, 2 Aug 2020 22:00:13 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
In-Reply-To: <20200731212323.21746-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR02CA0037.namprd02.prod.outlook.com
 (2603:10b6:5:177::14) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.252.16.211] (165.204.77.11) by DM6PR02CA0037.namprd02.prod.outlook.com (2603:10b6:5:177::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16 via Frontend Transport; Mon, 3 Aug 2020 03:00:14 +0000
X-Originating-IP: [165.204.77.11]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1b2c9cd9-fb6e-48c8-b680-08d837595936
X-MS-TrafficTypeDiagnostic: DM6PR12MB2716:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB2716BB1DA53B35A60887D423E74D0@DM6PR12MB2716.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RWOoHPNQc40vFQbsC1hu3mx9EOBYsVJ0EiRNu68X9v2Qo1p7mNRyT9PiO/9/kxrwwnUp55TWxXUdIryKUsdjwDz7tXW8P+kSRzDVS5QYlnlWYYZbCMtvqCkWseQSC/lxyAW7r/C1sEZSiL9LgSN+qMiyxBuZUXeGXN+jW5ANpO8DcOoIMQEoonz0gEJTZOyQDQZerXvj7+2agWWGb8moUVAUYi8E9F7U7xTFjdNKftMqd53yoZdw+HqslGqC4315R1r6tyngSN6BvW/pE4tsyu6DvUA0itxUjP5Y9yRDkCUtufspuO6S+H7pSiEImKUqgobi/bVa3WarpztcSn+RidJ5veT8nrO5iF8CHCFD4WnYd/bgkS363LwmnnVak337
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(376002)(366004)(136003)(346002)(8676002)(478600001)(36756003)(8936002)(31696002)(66946007)(2906002)(83380400001)(66476007)(66556008)(110136005)(54906003)(316002)(16576012)(53546011)(5660300002)(31686004)(956004)(2616005)(6486002)(16526019)(186003)(26005)(52116002)(4326008)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: b5F2MKArBYVhS6VtQnPhMXUxiTzN4qyOpRfTwQTHB/faUDrY9gJOTooTlwJG5ndJAAj7MRMUT6jc75ftwuQp/IXN2URJjHTFf9U2/GbaDt/doo7FGPAY7Lk0OMw8gyPsxUXLcuBn9MyD4502EtSKSSYfQrUcJ+QouM0DsaN+zDb2233QyK8zta07Cks6xlA204kTr70SCgB+zA5FT+4VSF25r7hUoKYOWrdhfFCUO6g7yxUfCepwvSC/CEH8EAPp6eX6dTjHf/8eMdL/9vAOmHnGETXZJHEZbB+Gl3J9A6Ii0l2UrXo07CV+Hf3o0lIM3Y9I9FOMcYfzsT+VVy++YuT2ztPzoRzZBMj0dXk0Xmx7/eJ22S/CUZZKcEbCrkUyKI/i9mSqv+FZujEirHuS+bHgnzoCyTXMDLm3MX1o77Xe+ICShh4EmJx68GxIwftae0RdY2KIxoipsVc24RJyQQjQKxYBa1cFrw3T9jl/XHnA84yvslSLU+t2d6jTuXvpJkLlFKbt/hiwHK+RMGlDHohBxH4JmCl0QaD6K/D0DrXbA64lZGBsQNyYUyxYykTRPFUWX+uCwQdYfE30SKsZstTufO6mr+bOZZ1Ap9C7F/0dUEcwlfop+1aEOPJbofjdfq/+jBfqEWmhalTdqW+aHw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b2c9cd9-fb6e-48c8-b680-08d837595936
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2020 03:00:16.4838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EbeHsoPpmFtmJD57vAht7XKl/C4ALaUL3Hz/Q+JNfCKh50yXIbotD9SFXHhl7VGh7MJldiZANxTlhnAQzm6mSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean,
	What commit did you base your series  on?
	Thanks.

-evt(Eric van Tassell)

On 7/31/20 4:23 PM, Sean Christopherson wrote:
> SEV currently needs to pin guest memory as it doesn't support migrating
> encrypted pages.  Introduce a framework in KVM's MMU to support pinning
> pages on demand without requiring additional memory allocations, and with
> (somewhat hazy) line of sight toward supporting more advanced features for
> encrypted guest memory, e.g. host page migration.
> 
> The idea is to use a software available bit in the SPTE to track that a
> page has been pinned.  The decision to pin a page and the actual pinning
> managment is handled by vendor code via kvm_x86_ops hooks.  There are
> intentionally two hooks (zap and unzap) introduced that are not needed for
> SEV.  I included them to again show how the flag (probably renamed?) could
> be used for more than just pin/unpin.
> 
> Bugs in the core implementation are pretty much guaranteed.  The basic
> concept has been tested, but in a fairly different incarnation.  Most
> notably, tagging PRESENT SPTEs as PINNED has not been tested, although
> using the PINNED flag to track zapped (and known to be pinned) SPTEs has
> been tested.  I cobbled this variation together fairly quickly to get the
> code out there for discussion.
> 
> The last patch to pin SEV pages during sev_launch_update_data() is
> incomplete; it's there to show how we might leverage MMU-based pinning to
> support pinning pages before the guest is live.
> 
> Sean Christopherson (8):
>    KVM: x86/mmu: Return old SPTE from mmu_spte_clear_track_bits()
>    KVM: x86/mmu: Use bits 2:0 to check for present SPTEs
>    KVM: x86/mmu: Refactor handling of not-present SPTEs in mmu_set_spte()
>    KVM: x86/mmu: Add infrastructure for pinning PFNs on demand
>    KVM: SVM: Use the KVM MMU SPTE pinning hooks to pin pages on demand
>    KVM: x86/mmu: Move 'pfn' variable to caller of direct_page_fault()
>    KVM: x86/mmu: Introduce kvm_mmu_map_tdp_page() for use by SEV
>    KVM: SVM: Pin SEV pages in MMU during sev_launch_update_data()
> 
>   arch/x86/include/asm/kvm_host.h |   7 ++
>   arch/x86/kvm/mmu.h              |   3 +
>   arch/x86/kvm/mmu/mmu.c          | 186 +++++++++++++++++++++++++-------
>   arch/x86/kvm/mmu/paging_tmpl.h  |   3 +-
>   arch/x86/kvm/svm/sev.c          | 141 +++++++++++++++++++++++-
>   arch/x86/kvm/svm/svm.c          |   3 +
>   arch/x86/kvm/svm/svm.h          |   3 +
>   7 files changed, 302 insertions(+), 44 deletions(-)
> 
