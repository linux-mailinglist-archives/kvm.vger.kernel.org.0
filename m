Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889C223A9E2
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 17:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgHCPwL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Aug 2020 11:52:11 -0400
Received: from mail-mw2nam10on2044.outbound.protection.outlook.com ([40.107.94.44]:30912
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726772AbgHCPwJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Aug 2020 11:52:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UINAq+Hu8ghRIdBQxFFlYQ7OYXQ58WmShWCCQqPX5Slf0e5ut/ZnPHwZ7rhQuvha9pfYXLfbJtgJu/x5MTQ7ZV9HbffbtYILofIC6jr3C0ei9cBbjfZe5qF7qD40wh9uTeZTRknsASmHM0jQ/HwQ7vNLVjMMB119dsulwyjvqFXAQdIZPk/L2TI/VYe/CqxJRJK75Q21wsUKgSuV2fPRoiCqu8RRmvgDUn3xGXq7RFlKlNGJKcG5SfwH/ay5+8AopQiAavmzF8bEF1tNgnvgrsUlF+qIGQ/RKRzRpWJK9Sny+jfHdr6x8SFZKzgC1vtAOxDSEM8Yn33jFFV9PS515g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vjt7LYu7TyDpgrz9ordaryNKlomnHRDfmdunXXJ7XWc=;
 b=eEbveb3QCiTPgEGXWq39F2FgcJYX13eBjMxaaCggITVJGge3CAGW27T/VRtv3JNQ8B4PVkPnoQFd8OTs8tQ87KlYu2rK8rk2geUy3yZbwpCTG1C1re/6rUZocUbBu4+xRwGvccwEk1k5h3Ohr40n8tVnAgodK9p2YAJZ+Z4Xk7pOXzl9AbeUTcULz7APM8BLMSUobIcsAFN1gilqmTvfSuerXCPQ4wYiC63EKPl6bamD3rBjoFERbS2AgZfTfqOuE2+XoSt7gEt8n6M3Bh+h6EcvzG7upOZ4/aSRcgvnfpYu70OCLYF/07RRTzojaDpTZ3vLJzzb2sMxOiZpe7QcDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vjt7LYu7TyDpgrz9ordaryNKlomnHRDfmdunXXJ7XWc=;
 b=DDfQ4n2jRYXMrIHcDSHOvaLkjHVoqcEby+fjFijdoc+V82y5mEetYj3zMUU2p1u/W7Y1sVUm1N+/IzVsm9DOgrpzWECun68joWMX8mGGfiCfAnjXMi2n138urIqggTu9C+8bFGy4yo6HQc6xUAE4aK6sRnRu3PurZuP9vcfR830=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2719.namprd12.prod.outlook.com (2603:10b6:805:6c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17; Mon, 3 Aug
 2020 15:52:07 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8ae:5626:2bf5:3624]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8ae:5626:2bf5:3624%7]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 15:52:06 +0000
Cc:     brijesh.singh@amd.com, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        eric van tassell <Eric.VanTassell@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC PATCH 0/8] KVM: x86/mmu: Introduce pinned SPTEs framework
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20200731212323.21746-1-sean.j.christopherson@intel.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <3bf90589-8404-8bd6-925c-427f72528fc2@amd.com>
Date:   Mon, 3 Aug 2020 10:52:05 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200731212323.21746-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: DM5PR04CA0031.namprd04.prod.outlook.com
 (2603:10b6:3:12b::17) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by DM5PR04CA0031.namprd04.prod.outlook.com (2603:10b6:3:12b::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17 via Frontend Transport; Mon, 3 Aug 2020 15:52:05 +0000
X-Originating-IP: [70.112.153.56]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 952c93a4-50b2-4798-ac22-08d837c52c59
X-MS-TrafficTypeDiagnostic: SN6PR12MB2719:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB27194663746A4824140F237DE54D0@SN6PR12MB2719.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MtBfxm6SNILykEpSe2YcOyWpl5DEWtPthEJ2pPAw5VuY7OauOuaaIbC4BFPxvN2IbPTqo4h1zoHBaaQk/yYYyMG2JNVjdy4FcUusWLXMndITwbybs0Gy6IRFtNWqXJTy7aLMGya0XFqj0YoP5HjVNFRREGflc+rIwhiPC7bUoab6/55bjXIKIjYKUo/1AyUr9otf0Z9SI+Pw8+ee14n2pVQoMmtLKTxqCnFr4dw8hIszoyQ29BXIlf61O59KzH0bR1uI2be+WXNeIzWF4C6pU5HNLghfiM7Y9P7QQ2CsqBs/G4ug51G5bdzb27cXwpzB0YEKr4DHuhbtyKdiraZ1BReBIriSuMH6JNDY+f2ip+NeYkfUll3o53R0hi8BCubY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(396003)(376002)(346002)(366004)(83380400001)(956004)(8936002)(52116002)(316002)(86362001)(8676002)(36756003)(4326008)(110136005)(478600001)(2906002)(2616005)(31696002)(6486002)(6512007)(44832011)(16526019)(5660300002)(31686004)(6506007)(54906003)(66476007)(66556008)(53546011)(186003)(66946007)(26005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: EFiQEydk1QiL2y9Ex+73u0cxj8eT5ogEn1K9Yp+71iBQv0X5IytyIIAyYpeEz++rNy3jBg+b/eUqyKmbtAvMVvN5JTxQUIW1MxKa3Sfib4897kNu3mXLgM7IdsOxt96p/GAM5hUfd2LRALhoNF1p17d/UzX3kvpJ5/ypGQea87pjq2n7vNnVkc/DKbg5wk3MwXxL04IWDaxX8NSZzHREy5vdNcRYvdmD2KIwHNjIKxtZPaOaM0KXUguIjsihxFtJzWtt6UwvB/CYXLX3UtCEamJN1YjpeKwG14ZmEEfUS8TyJR3ET11zTfAax6p0bHBiGdhajBzLRNNiLq4o8y8iXeI9ysP7L7d8CYQQtAgRzb0MVQSjELlOh1+6U9Zqwg49zVeOGwA4tUK4iZn7jRW5z1V5EshxVXpnZxxsKKe2CWe9tpTNW/J2XFGv7qcBYnoR8xjQsyEneUv5x3OaEhKauchaMGIHnNJBD03YqATt30poUD2NiUDhgprnjASsrHvQrcHjC7bBadH+WtBqYoXrCyBADy67yLGklU2rB7vjQj/ectVdk0eih7qBTKvIEPTqEjpN8w2qM6BkG4qRXk0rfucCZ1DtSK95KmtgsV30gZ1LQANmj9hRCECAdjviWSW+8bcr6anzskBewq4cFIZsNw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 952c93a4-50b2-4798-ac22-08d837c52c59
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2020 15:52:06.7862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1DSJ3mNT3Da044rdrdHTN1CGmaeJ27b5FU+4dD1feGuX31EtOFJdH2Vr7InEOXby0OGZYnAP7vXoZAQWkFL8Gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2719
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks for series Sean. Some thoughts


On 7/31/20 4:23 PM, Sean Christopherson wrote:
> SEV currently needs to pin guest memory as it doesn't support migrating
> encrypted pages.  Introduce a framework in KVM's MMU to support pinning
> pages on demand without requiring additional memory allocations, and with
> (somewhat hazy) line of sight toward supporting more advanced features for
> encrypted guest memory, e.g. host page migration.


Eric's attempt to do a lazy pinning suffers with the memory allocation
problem and your series seems to address it. As you have noticed,
currently the SEV enablement  in the KVM does not support migrating the
encrypted pages. But the recent SEV firmware provides a support to
migrate the encrypted pages (e.g host page migration). The support is
available in SEV FW >= 0.17.

> The idea is to use a software available bit in the SPTE to track that a
> page has been pinned.  The decision to pin a page and the actual pinning
> managment is handled by vendor code via kvm_x86_ops hooks.  There are
> intentionally two hooks (zap and unzap) introduced that are not needed for
> SEV.  I included them to again show how the flag (probably renamed?) could
> be used for more than just pin/unpin.

If using the available software bits for the tracking the pinning is
acceptable then it can be used for the non-SEV guests (if needed). I
will look through your patch more carefully but one immediate question,
when do we unpin the pages? In the case of the SEV, once a page is
pinned then it should not be unpinned until the guest terminates. If we
unpin the page before the VM terminates then there is a  chance the host
page migration will kick-in and move the pages. The KVM MMU code may
call to drop the spte's during the zap/unzap and this happens a lot
during a guest execution and it will lead us to the path where a vendor
specific code will unpin the pages during the guest execution and cause
a data corruption for the SEV guest.

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


I will add the SEV specific bits and  give this a try.

>
> Sean Christopherson (8):
>   KVM: x86/mmu: Return old SPTE from mmu_spte_clear_track_bits()
>   KVM: x86/mmu: Use bits 2:0 to check for present SPTEs
>   KVM: x86/mmu: Refactor handling of not-present SPTEs in mmu_set_spte()
>   KVM: x86/mmu: Add infrastructure for pinning PFNs on demand
>   KVM: SVM: Use the KVM MMU SPTE pinning hooks to pin pages on demand
>   KVM: x86/mmu: Move 'pfn' variable to caller of direct_page_fault()
>   KVM: x86/mmu: Introduce kvm_mmu_map_tdp_page() for use by SEV
>   KVM: SVM: Pin SEV pages in MMU during sev_launch_update_data()
>
>  arch/x86/include/asm/kvm_host.h |   7 ++
>  arch/x86/kvm/mmu.h              |   3 +
>  arch/x86/kvm/mmu/mmu.c          | 186 +++++++++++++++++++++++++-------
>  arch/x86/kvm/mmu/paging_tmpl.h  |   3 +-
>  arch/x86/kvm/svm/sev.c          | 141 +++++++++++++++++++++++-
>  arch/x86/kvm/svm/svm.c          |   3 +
>  arch/x86/kvm/svm/svm.h          |   3 +
>  7 files changed, 302 insertions(+), 44 deletions(-)
>
