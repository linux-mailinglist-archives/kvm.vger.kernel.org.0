Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0E7C23C01B
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 21:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgHDTk7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 15:40:59 -0400
Received: from mail-eopbgr690087.outbound.protection.outlook.com ([40.107.69.87]:41511
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726090AbgHDTk7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 15:40:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H0XqhSWUCPO8qJa7v500mQN3d1Cq7kyheJ2yRK11V5uyDRaSW92enLb6ja6tzE5QnPuPynR1aC/UqiGRNcsl/nO3nrqHg4GBVHf1H5oMQTakSj+EdPfM6u/A3ILCGuBIm9Ys0unNqtq/qOw26pkS+y+noM9Xal1I30QMx7AUHjZkEPCnhJe+WEQZFuQ+990i7sTGxca467o8X3SGq9RBC+03lPGgx7Aj1J1kptKZ/AirZ4kEMGfVACwXy3GV4P/J/gvWFAQDuKhuNYqevoFz3PDP/M0N3RW7JpagAcireHdnEC50AbWtEFehCxi8VaRt2iiFn46h5iD7qY1e4EvSVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xwh+eH8pyNG28SsBh+XUIzm0T0ad2IRYkZYpAtq1Umw=;
 b=eA8CDg7PQEsAzevnd4laScFxiGqy30rQk7EnrMz510+LDn/XAXnfZB0NpuZ5jwd0xq16bT/rdzTIpCJJXanSmmUzxJ228yD30q6hhVPIsVbpjZhGdZMlRS9rqzxdNN1sSa8uXualSsftiCKiB36NNJ5mtn1PG8nGgdq8CJBiaqhX7I/han9/d/Nco01IQd9J2XmOPK9tNt6G0Wa22wWexqYd2xxJhqv3dVv+rL+b7viuP6gLT5cZhi2obenD/Z29r5hI759yEZpdQiwkohkWloola1+fhEBmqKYiIDjxB6zYOm/jXbElbxzHx63Vt6OyZG/vHPEUqnEDyp9wij0b1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xwh+eH8pyNG28SsBh+XUIzm0T0ad2IRYkZYpAtq1Umw=;
 b=P5XPf+q7esfcyIQFumn4Mv5nBaj8ERS7Ig7PSeyLZ+R+4CVujs448yEPiyNJwcMlCgP0oDOuU2PsswCGeVXc8PwdmPkLeVcneOY86smit0+vveROKHVikZn9Ec6wt+sMN5+ZpSwUSS9ACTWH3YPxVLBjuZT2Ezx88rhyByZbzHo=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2365.namprd12.prod.outlook.com (2603:10b6:802:2e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.21; Tue, 4 Aug
 2020 19:40:56 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8ae:5626:2bf5:3624]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8ae:5626:2bf5:3624%7]) with mapi id 15.20.3239.022; Tue, 4 Aug 2020
 19:40:56 +0000
Cc:     brijesh.singh@amd.com, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        eric van tassell <Eric.VanTassell@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC PATCH 0/8] KVM: x86/mmu: Introduce pinned SPTEs framework
To:     Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200731212323.21746-1-sean.j.christopherson@intel.com>
 <3bf90589-8404-8bd6-925c-427f72528fc2@amd.com>
 <20200803171620.GC3151@linux.intel.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <16ef9998-84a9-1db4-d9a3-a0cab055a8a2@amd.com>
Date:   Tue, 4 Aug 2020 14:40:49 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200803171620.GC3151@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: DM6PR12CA0036.namprd12.prod.outlook.com
 (2603:10b6:5:1c0::49) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (165.204.77.11) by DM6PR12CA0036.namprd12.prod.outlook.com (2603:10b6:5:1c0::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.18 via Frontend Transport; Tue, 4 Aug 2020 19:40:54 +0000
X-Originating-IP: [165.204.77.11]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c8e9d964-913a-47b7-b984-08d838ae4e09
X-MS-TrafficTypeDiagnostic: SN1PR12MB2365:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB23650C7BDBB8022E74D17684E54A0@SN1PR12MB2365.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +lW4SbrFwGLu6BPXD9PRmTt6lOwjgDeVQh1RGDiBL+EK0fo42enSEvCKJyQ+ZRZB1adCD3KaRGBdGCYGdv0abhVQX0N2qE3jAIgCOd87zqN858sS2at2FZ4HBoNFlkkwey6vK40RvUD0eZsKhweyoqFHKw/ZLs4vppQLGiTN2pTW8xvyRar/ptHnJ1JHEDL6/pOb1QboZ4c/FLFE6BxHJoLvqcGr4Dx5p1itNqRi6894kUTl+BKJIibC9e+MOU6v1DEdRJwubrg75tWxqGpNHMgDp+47qrd2NVUg1B6Rx3Eaogr8gtDpFnF6NZWWxj3Ceys4qXOAkm5ALGEYVSfdIspvgoUlFmcNt6xxbbCiIKXwneIsSQkMQbR3jUoeX2V7WusUbCOL5rtZOF1z1sIlaBbvrNK1Ny/RQc3HklcXk+SuGooC/Cf9l1JRykkqsHrMONZBMxJj4FwlijXh2tHiZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(376002)(136003)(396003)(346002)(966005)(478600001)(5660300002)(66476007)(83380400001)(66946007)(8936002)(66556008)(31696002)(8676002)(6666004)(86362001)(36756003)(31686004)(2906002)(44832011)(956004)(2616005)(16526019)(186003)(26005)(6512007)(6486002)(6506007)(52116002)(53546011)(6916009)(54906003)(4326008)(45080400002)(316002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: TpS8YLdKhODbV/MZnkHhpdSraj7Nw6qHAX9tBVzIbqkuvlKQVDUhfkArD1v/3EzIMfaP8DcPJrCZxbma+vmNwqBc+QrQwL9IQuoasTPVhiD2TUx8cyfg63wXrUcWM5T38F886PxekDibyAg0XphyNgnK5UEkyD71vqxvGelvWPs7W6FNUGw64GX0t/DhyFee74dPlB3PluoI5iaeU2SdvQ/dcqwKNLVy00r6nKhVkgeH0VGBJtjopa2TPM/Rp8dbOoyVCgrA+7VMTGo0Sm2yFQXGwhhplYDE4GIm46tV7+rWISqk5e2ed1VWYR0kLHJ/HfZs3tl8VftNzbKrMC2mFbVwZ04QQxmdPWNr2juhYL980jelGR3zvdo7IVlWZDtY3PqnAPcnH1/XR4iZdconfNykTh+RRE9m79I4tF+dagi8g4/rdWFUxoyBolRUzKYVUxM9NnB4O3zH7bN/100PjcdOxncRcr6liv8HDu5oPRv4oAVqRf9PEIP4Ujx3frJ+iqurfZmCfYo+xNpTrr73SLren3tMDMmAIS/lXiCs0uOY8nPDvXwrdUXWE0kROIuRMtOx0QXYwu5CIFO4oE/Up6Ocma5fzwKoVZaxTjWVM6Uz6cEvKLFL3zt5d88t1enn+qdt6I7i3EEf4xqd/S6YBg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8e9d964-913a-47b7-b984-08d838ae4e09
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2020 19:40:55.9099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wFxaN1xknqArP9O82YT14QceBy3t+67DWC5a4wb80NKlq9opd6QVj0PU/gpNIt49GP14hGjA4ljLP1WpUTqhiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2365
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/3/20 12:16 PM, Sean Christopherson wrote:
> On Mon, Aug 03, 2020 at 10:52:05AM -0500, Brijesh Singh wrote:
>> Thanks for series Sean. Some thoughts
>>
>>
>> On 7/31/20 4:23 PM, Sean Christopherson wrote:
>>> SEV currently needs to pin guest memory as it doesn't support migrating
>>> encrypted pages.  Introduce a framework in KVM's MMU to support pinning
>>> pages on demand without requiring additional memory allocations, and with
>>> (somewhat hazy) line of sight toward supporting more advanced features for
>>> encrypted guest memory, e.g. host page migration.
>>
>> Eric's attempt to do a lazy pinning suffers with the memory allocation
>> problem and your series seems to address it. As you have noticed,
>> currently the SEV enablement  in the KVM does not support migrating the
>> encrypted pages. But the recent SEV firmware provides a support to
>> migrate the encrypted pages (e.g host page migration). The support is
>> available in SEV FW >= 0.17.
> I assume SEV also doesn't support ballooning?  Ballooning would be a good
> first step toward page migration as I think it'd be easier for KVM to
> support, e.g. only needs to deal with the "zap" and not the "move".


Yes, the ballooning does not work with the SEV.


>
>>> The idea is to use a software available bit in the SPTE to track that a
>>> page has been pinned.  The decision to pin a page and the actual pinning
>>> managment is handled by vendor code via kvm_x86_ops hooks.  There are
>>> intentionally two hooks (zap and unzap) introduced that are not needed for
>>> SEV.  I included them to again show how the flag (probably renamed?) could
>>> be used for more than just pin/unpin.
>> If using the available software bits for the tracking the pinning is
>> acceptable then it can be used for the non-SEV guests (if needed). I
>> will look through your patch more carefully but one immediate question,
>> when do we unpin the pages? In the case of the SEV, once a page is
>> pinned then it should not be unpinned until the guest terminates. If we
>> unpin the page before the VM terminates then there is a  chance the host
>> page migration will kick-in and move the pages. The KVM MMU code may
>> call to drop the spte's during the zap/unzap and this happens a lot
>> during a guest execution and it will lead us to the path where a vendor
>> specific code will unpin the pages during the guest execution and cause
>> a data corruption for the SEV guest.
> The pages are unpinned by:
>
>   drop_spte()
>   |
>   -> rmap_remove()
>      |
>      -> sev_drop_pinned_spte()
>
>
> The intent is to allow unpinning pages when the mm_struct dies, i.e. when
> the memory is no longer reachable (as opposed to when the last reference to
> KVM is put), but typing that out, I realize there are dependencies and
> assumptions that don't hold true for SEV as implemented.


So, I tried this RFC with the SEV guest (of course after adding some of
the stuff you highlighted below), the guest fails randomly. I have seen
a two to three type of failures 1) boot 2) kernbench execution and 3)
device addition/removal, the failure signature is not consistent. I
believe after addressing some of the dependencies we may able to make
some progress but it will add new restriction which did not existed before.

>
>   - Parent shadow pages won't be zapped.  Recycling MMU pages and zapping
>     all SPs due to memslot updates are the two concerns.
>
>     The easy way out for recycling is to not recycle SPs with pinned
>     children, though that may or may not fly with VMM admins.
>
>     I'm trying to resolve the memslot issue[*], but confirming that there's
>     no longer an issue with not zapping everything is proving difficult as
>     we haven't yet reproduced the original bug.
>
>   - drop_large_spte() won't be invoked.  I believe the only semi-legitimate
>     scenario is if the NX huge page workaround is toggled on while a VM is
>     running.  Disallowing that if there is an SEV guest seems reasonable?
>
>     There might be an issue with the host page size changing, but I don't
>     think that can happen if the page is pinned.  That needs more
>     investigation.
>
>
> [*] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flkml.kernel.org%2Fr%2F20200703025047.13987-1-sean.j.christopherson%40intel.com&amp;data=02%7C01%7Cbrijesh.singh%40amd.com%7C8d0dd94297ff4d24e54108d837d0f1dc%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637320717832773086&amp;sdata=yAHvMptxstoczXBZkFCpNC4AbADOJOgluwAtIYCuNVo%3D&amp;reserved=0
>
>>> Bugs in the core implementation are pretty much guaranteed.  The basic
>>> concept has been tested, but in a fairly different incarnation.  Most
>>> notably, tagging PRESENT SPTEs as PINNED has not been tested, although
>>> using the PINNED flag to track zapped (and known to be pinned) SPTEs has
>>> been tested.  I cobbled this variation together fairly quickly to get the
>>> code out there for discussion.
>>>
>>> The last patch to pin SEV pages during sev_launch_update_data() is
>>> incomplete; it's there to show how we might leverage MMU-based pinning to
>>> support pinning pages before the guest is live.
>>
>> I will add the SEV specific bits and  give this a try.
>>
>>> Sean Christopherson (8):
>>>   KVM: x86/mmu: Return old SPTE from mmu_spte_clear_track_bits()
>>>   KVM: x86/mmu: Use bits 2:0 to check for present SPTEs
>>>   KVM: x86/mmu: Refactor handling of not-present SPTEs in mmu_set_spte()
>>>   KVM: x86/mmu: Add infrastructure for pinning PFNs on demand
>>>   KVM: SVM: Use the KVM MMU SPTE pinning hooks to pin pages on demand
>>>   KVM: x86/mmu: Move 'pfn' variable to caller of direct_page_fault()
>>>   KVM: x86/mmu: Introduce kvm_mmu_map_tdp_page() for use by SEV
>>>   KVM: SVM: Pin SEV pages in MMU during sev_launch_update_data()
>>>
>>>  arch/x86/include/asm/kvm_host.h |   7 ++
>>>  arch/x86/kvm/mmu.h              |   3 +
>>>  arch/x86/kvm/mmu/mmu.c          | 186 +++++++++++++++++++++++++-------
>>>  arch/x86/kvm/mmu/paging_tmpl.h  |   3 +-
>>>  arch/x86/kvm/svm/sev.c          | 141 +++++++++++++++++++++++-
>>>  arch/x86/kvm/svm/svm.c          |   3 +
>>>  arch/x86/kvm/svm/svm.h          |   3 +
>>>  7 files changed, 302 insertions(+), 44 deletions(-)
>>>
