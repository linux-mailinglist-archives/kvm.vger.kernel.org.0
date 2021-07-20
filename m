Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46F1F3D0398
	for <lists+kvm@lfdr.de>; Tue, 20 Jul 2021 23:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbhGTUZy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jul 2021 16:25:54 -0400
Received: from mail-dm6nam10on2080.outbound.protection.outlook.com ([40.107.93.80]:57313
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234691AbhGTUXl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jul 2021 16:23:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LsYsYqDcw6doVoeEOYfuSmH/TE6ZWcoV4LzVdeRwjUGk40cF84rE1a0pRA2B7TiNliAwJ9UucFSgjQbr5w88vrUwA88DwdsO1v6LB68IwACsSzN89ue1lSN/XAAVzb5yhs2Z1/1R4TdAYR90z7iKQgF9WDjh7KY4tDc8j2l1Itmt/7FXlZ5+2hirNrxtJws84Iov9PH4nFqK/OpAexbIH2+s8epfAU7aL74OyzbayANXgsDw+1D+7V6Sep/DlnsAVW4zF7DPfXirPoKdm83k+iwgOP/53ZrgHvx2ZQYxXgRQ01UrVqugmvtfbPDp1FW2MNLD5nubwc87GKIwYJLp/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b8/pCTmRn/xUA3j8lBj4ql2SnU9TzjY18SW2zbwrbcc=;
 b=Q8sKu0GNezE+WymqT6QxeZuvRsQCd5Odrfz5r8kAPtKj5KUIODNU6iSBwQS5LNcSIcx1+fOoHBlToIMdSYBVxsRnDFJh6zeWjuHdP3txim6HJglGtBniV43W1W+n5HFSoEp0VDhfIu7ndeiHl71x0dZUpikdxElKkD0ZaALOmNG++HnvBvC/P3EZDHAU2YlpMlTsf9vUW+0GUYTcWuIKKCyecD8V8mOHwuANJEE/VE6OSzcIYcv8nVmCvwBDj+3543oeontSlHnJtfUXSSmtRHYplXt7JEw17CbthPbx+XmxW9SCt+FDxTJzeIFcQicKRBtnBJvZBYyx0w9dLgAXRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b8/pCTmRn/xUA3j8lBj4ql2SnU9TzjY18SW2zbwrbcc=;
 b=JnRnbCJdcodPuLg6OR6ztanR6a4g1+i2QvmT+IahGgS8i8scxE+i8QlsG7wccLBFa4NFdZt7VpS0/GLhp2OXhFoceAlChFtQTkH7FoKIIflERN7d1pbVHm9JUnTwEJOvixhT5wthQaeA2zZKqYGDgWx7IO/a2PEsKgLNVi/Tbc/JNQ5lRxYilNPDvl2I2LuCrkgkf9dEE3JVB2U5avSGb2fBPhiRYi0FwpnQQHmRG5s0V8NH7gyROtRYpCvd4VQZ1fipGP5r9wR1PPLN1k/eibfCiIob52B/0zVgZJQNj9FFjGvNzIZRdiWy6Na+W0AxsyNLl6ZJtKd7Zd7jkVXUNg==
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3823.namprd12.prod.outlook.com (2603:10b6:208:168::26)
 by BL0PR12MB2401.namprd12.prod.outlook.com (2603:10b6:207:4d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.32; Tue, 20 Jul
 2021 21:04:15 +0000
Received: from MN2PR12MB3823.namprd12.prod.outlook.com
 ([fe80::dcee:535c:30e:95f4]) by MN2PR12MB3823.namprd12.prod.outlook.com
 ([fe80::dcee:535c:30e:95f4%6]) with mapi id 15.20.4331.034; Tue, 20 Jul 2021
 21:04:15 +0000
From:   Zi Yan <ziy@nvidia.com>
To:     Yang Shi <shy828301@gmail.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Huang Ying <ying.huang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mel Gorman <mgorman@suse.de>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Michal Hocko <mhocko@suse.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH] mm,do_huge_pmd_numa_page: remove unnecessary TLB flushing code
Date:   Tue, 20 Jul 2021 17:04:09 -0400
X-Mailer: MailMate (1.14r5812)
Message-ID: <0D75A92F-E2AA-480C-9E9A-0B6EE7897757@nvidia.com>
In-Reply-To: <CAHbLzkp6LDLUK9TLM+geQM6+X6+toxAGi53UBd49Zm5xgc5aWQ@mail.gmail.com>
References: <20210720065529.716031-1-ying.huang@intel.com>
 <eadff602-3824-f69d-e110-466b37535c99@de.ibm.com>
 <CAHbLzkp6LDLUK9TLM+geQM6+X6+toxAGi53UBd49Zm5xgc5aWQ@mail.gmail.com>
Content-Type: multipart/signed;
 boundary="=_MailMate_D798A0F0-2E50-454C-8B5B-D2901548270E_=";
 micalg=pgp-sha512; protocol="application/pgp-signature"
X-ClientProxiedBy: MN2PR15CA0057.namprd15.prod.outlook.com
 (2603:10b6:208:237::26) To MN2PR12MB3823.namprd12.prod.outlook.com
 (2603:10b6:208:168::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.2.55.80] (216.228.112.21) by MN2PR15CA0057.namprd15.prod.outlook.com (2603:10b6:208:237::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Tue, 20 Jul 2021 21:04:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c05d3cf-cf13-4256-5779-08d94bc1eeb0
X-MS-TrafficTypeDiagnostic: BL0PR12MB2401:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB24012187485D225587F5C04AC2E29@BL0PR12MB2401.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SggTt3SEXdSwmlZR70C7oZ+sO63g6UFBL2wZnH/FGpt9DLDizGDBxaYgnIeMdux1Os30e9hiaXw4sDIAew7Avef6FpbZX0IEfGgdIqoYwaQqCqet4z1llL2GbWAKeKGLbHWiLchfzPNJqRqJ+81BzoSI7nfn3cCVgSGCamP49v3p991V7kGjnpSQWDAQXILTehCYrpH8/k5bO854UavfJTEwag/JnOw3xdxGJZ3AkE3IUDMLICSzLBIySSEnWLTztHDiDtnbHAAghaOU+JAc3lpH+VyZJJzQ09O+YOdl1ABLcYyhaTRcBEKtgjuHFCI9pfruuYkDojcysn1CW2wTFEcigkWGOQLSnJakv/0QA3EH+Y0MsDPj5dem5NeF85wDNE6yuZkKRay5Itj9DLTJvN1e6I4F+hTr754hKHAyW7BDo7B5wyTKGgAiO/uGn1LCkxP0h25VPvJGEAhyN3hLqoZ2iQr9ig6QflzoKo4/w6sxkJx4gcvAIUVXgmJzreNGFv5ExS0AIuikGJf6oXIOxGb9/zg9hgKfh2seW83CCwidpL/58nOgOi3n1JMTW3pvDwqhGg/fStcN30SQVWIMM6ghC2uVcW7gVNkfFHTjLJ/BZn4wafW9Vj0ynSyOm70C2u9OrcCOR7MAsUqIV5qzawWSFhCV8ahNky/K/ES3QP8BYiFTs5jrEtIRIXO9VpsOqpbBJLrEHroTFbW3CLK+R0g4SfHLHGtzMglDqgKmJelCG/Vw2xTxJkWt8yWKMypf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3823.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(7416002)(508600001)(956004)(2616005)(38100700002)(2906002)(4326008)(16576012)(33656002)(6486002)(86362001)(316002)(36756003)(66476007)(33964004)(6666004)(26005)(6916009)(5660300002)(235185007)(186003)(83380400001)(53546011)(21480400003)(66946007)(66556008)(8676002)(8936002)(14583001)(45980500001)(72826004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZEhuYnpSMnM4Vkg3U1kwWVBUVkhtODdPS0pybytqb0xuRnJxd0RJa1RBeDM2?=
 =?utf-8?B?bndydE9IeXpJdlUxNzlzM0JVK25zQmttOXZ4ZmFMcERPV3pSZS9Fek5lcXNE?=
 =?utf-8?B?c1ZzMlBYWlU3dTBxS3hmVnFIVUs5bkNWL3ZDb1Z4cEtTY3Uzc0ZDUW1lMFdE?=
 =?utf-8?B?MUhXQjVpUlJNODlDcWQrVWtRZFJtOUxZWW9udVp1RlRSZTR4K2dsZWlQL214?=
 =?utf-8?B?Ri83c1RVb25FLzBoTUhsZ1JDQkpsVnRDMTlnSXpUd0wySVNvQVhPalhUaVMw?=
 =?utf-8?B?RDMrTGFoMURkdE8xZUlWaDFEanFDUGQzWFI0alY4azlhTllZSG5DbmVTZThV?=
 =?utf-8?B?QWVQWFNMbHBJTS9aOUZsODQyYmhJWi9KMzdxbkw0NXcyaWRKbVB6dDkrRXBW?=
 =?utf-8?B?TmdvSFhaUlJlUTl0MTY2T3JPYXh6TjhCRWJKWU5tdU5EVzM5cFZwcE9tUk5M?=
 =?utf-8?B?cDlyWVdxYTErbnZCL2JSSnI4eU11dk5CbnJRMk9rcE1mWERtZE96VHJSUTJ6?=
 =?utf-8?B?UkJHMVd0T2d4SFMvTFNwdHcxeXhOS252T205R3l5WUFkRlRIdi9CTkFzU2hz?=
 =?utf-8?B?YkF3djZJZ2N3ZGJuek55ZFgvTTN2SWdOeitjVDVFTjJrcXJiaThnaWdkR2RP?=
 =?utf-8?B?WXU5NURldENYdTN6ZjkvamlEaE8zSlNUSjJWVzY3ZU1jVW0vREZWTVlZQm9N?=
 =?utf-8?B?QjdWMndncVBqTXh1dWRIYThnTDhNa3BlR1hhNjV4MDdMcG1YSHU2dU1EQTd0?=
 =?utf-8?B?bWRPR0NlZ29PRTBnZWRwb1RCVlBnL01BaCt0Ty9RSVd2TUpoR0JHL1FISXJ4?=
 =?utf-8?B?Qi9iT1ppV2t6Ym13TCtpV3VWTzdYNzRPYjAxUXplUUdCTzBTbk1rNUx5U1VZ?=
 =?utf-8?B?NXg0a2R5dnBIZjlKYVd4UG9KQm1IeTQ4a1ljdzhGL2VFbzhrZGFQQ2FhZCtG?=
 =?utf-8?B?MnlLWHIxUUZCLzVxdnIvUzV4NTN5QlpDaVJLQ0NrMW1Sbk1SUGxoWlMxODhw?=
 =?utf-8?B?NlJWRXlteTg0TXk3ZmM2RlZvWWprSHdUQ1FRRGV4K2Z5Um51WFRwKzNraEZG?=
 =?utf-8?B?bW9ZS0IvS1dBQnA4OGo5anh4TEZKbkNnT2hZRHZHbzBrWGpTemhDRXh1aC90?=
 =?utf-8?B?ckxRMVViRnFETnhtY1Jvc203ZE5GTUthR1NTU2lXcmxadDUyakZKYjRZM3Y4?=
 =?utf-8?B?Rzl4WHVMRXovV2Q4cllReVJRUUVmZndiSVlaMjYwd2VsY01TbzBsdlMyQnlH?=
 =?utf-8?B?OXlVZnlpQVprVHpEWlVnVGdvdEV1VFR6WFVMQWE5Y0xHWUJBZGVoL2o2KzZy?=
 =?utf-8?B?ZWtuTUc2L25xajVsdkJ5ZlBZNWYyYVVRcEMvNzFLVUlDYnM0cEEzOEZiSC9r?=
 =?utf-8?B?M2NzRUZiTHptMFhnc200VzJKaEVoTW1MaGpoWXB3VGx4VUVVVFhMMGZqbHlJ?=
 =?utf-8?B?WHNndkN0TXkrSnJBVHhTN3pqNC9odE5xMGhCbU01YzhSbGtQVDVMdzJJWWtP?=
 =?utf-8?B?WnN0NkJyL01RTU52dWVsdVVnMFM4eVNTN0RhUnhVb0pQeGNnQzRvN21WVDJt?=
 =?utf-8?B?ejRGREtpZ1pxb2ErSTFJa1c1NS9XSU0wbkJvMFFkZjl6TTNQNDhTNTRxRWFM?=
 =?utf-8?B?Ny9ZZWg3WTNPeGdSTFVZNzBTajc5SnQvSnpYaTltRzV4bHMxOFRGeVZ0WUN6?=
 =?utf-8?B?MkxndWQwZTRweFc3clRtYm5FNzVkS0ovNVl3VzVZVTNWZnNVY0lpRXIzSmU3?=
 =?utf-8?Q?jXH5Zt7PbAJMBq8CkJsxvp79HNHvj12XvLctzNJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c05d3cf-cf13-4256-5779-08d94bc1eeb0
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3823.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 21:04:15.6740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8KoeziYgrSkyLByOmcDSkHDzSQFI1oUhtR6ikQglX1yHPKDTayuKKiD2UhJ6BfLm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2401
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--=_MailMate_D798A0F0-2E50-454C-8B5B-D2901548270E_=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 20 Jul 2021, at 16:53, Yang Shi wrote:

> On Tue, Jul 20, 2021 at 7:25 AM Christian Borntraeger
> <borntraeger@de.ibm.com> wrote:
>>
>>
>>
>> On 20.07.21 08:55, Huang Ying wrote:
>>> Before the commit c5b5a3dd2c1f ("mm: thp: refactor NUMA fault
>>> handling"), the TLB flushing is done in do_huge_pmd_numa_page() itsel=
f
>>> via flush_tlb_range().
>>>
>>> But after commit c5b5a3dd2c1f ("mm: thp: refactor NUMA fault
>>> handling"), the TLB flushing is done in migrate_pages() as in the
>>> following code path anyway.
>>>
>>> do_huge_pmd_numa_page
>>>    migrate_misplaced_page
>>>      migrate_pages
>>>
>>> So now, the TLB flushing code in do_huge_pmd_numa_page() becomes
>>> unnecessary.  So the code is deleted in this patch to simplify the
>>> code.  This is only code cleanup, there's no visible performance
>>> difference.
>>>
>>> Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
>>> Cc: Yang Shi <shy828301@gmail.com>
>>> Cc: Dan Carpenter <dan.carpenter@oracle.com>
>>> Cc: Mel Gorman <mgorman@suse.de>
>>> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
>>> Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
>>> Cc: Heiko Carstens <hca@linux.ibm.com>
>>> Cc: Hugh Dickins <hughd@google.com>
>>> Cc: Andrea Arcangeli <aarcange@redhat.com>
>>> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>>> Cc: Michal Hocko <mhocko@suse.com>
>>> Cc: Vasily Gorbik <gor@linux.ibm.com>
>>> Cc: Zi Yan <ziy@nvidia.com>
>>> ---
>>>   mm/huge_memory.c | 26 --------------------------
>>>   1 file changed, 26 deletions(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index afff3ac87067..9f21e44c9030 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -1440,32 +1440,6 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fau=
lt *vmf)
>>>               goto out;
>>>       }
>>>
>>> -     /*
>>> -      * Since we took the NUMA fault, we must have observed the !acc=
essible
>>> -      * bit. Make sure all other CPUs agree with that, to avoid them=

>>> -      * modifying the page we're about to migrate.
>>> -      *
>>> -      * Must be done under PTL such that we'll observe the relevant
>>> -      * inc_tlb_flush_pending().
>>> -      *
>>> -      * We are not sure a pending tlb flush here is for a huge page
>>> -      * mapping or not. Hence use the tlb range variant
>>> -      */
>>> -     if (mm_tlb_flush_pending(vma->vm_mm)) {
>>> -             flush_tlb_range(vma, haddr, haddr + HPAGE_PMD_SIZE);
>>> -             /*
>>> -              * change_huge_pmd() released the pmd lock before
>>> -              * invalidating the secondary MMUs sharing the primary
>>> -              * MMU pagetables (with ->invalidate_range()). The
>>> -              * mmu_notifier_invalidate_range_end() (which
>>> -              * internally calls ->invalidate_range()) in
>>> -              * change_pmd_range() will run after us, so we can't
>>> -              * rely on it here and we need an explicit invalidate.
>>> -              */
>>> -             mmu_notifier_invalidate_range(vma->vm_mm, haddr,
>>> -                                           haddr + HPAGE_PMD_SIZE);
>>> -     }
>>> CC Paolo/KVM list so we also remove the mmu notifier here. Do we need=
 those
>> now in migrate_pages? I am not an expert in that code, but I cant find=

>> an equivalent mmu_notifier in migrate_misplaced_pages.
>> I might be totally wrong, just something that I noticed.
>
> Do you mean the missed mmu notifier invalidate for the THP migration
> case? Yes, I noticed that too. But I'm not sure whether it is intended
> or just missed.

=46rom my understand of mmu_notifier document, mmu_notifier_invalidate_ra=
nge()
is needed only if the PTE is updated to point to a new page or the page p=
ointed
by the PTE is freed. Page migration does not fall into either case.
In addition, in migrate_pages(), more specifically try_to_migrate_one(),
there is a pair of mmu_notifier_invalidate_range_start() and
mmu_notifier_invalidate_range_end() around the PTE manipulation code, whi=
ch should
be sufficient to notify secondary TLBs (including KVM) about the PTE chan=
ge
for page migration. Correct me if I am wrong.

=E2=80=94
Best Regards,
Yan, Zi

--=_MailMate_D798A0F0-2E50-454C-8B5B-D2901548270E_=
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCgAtFiEEh7yFAW3gwjwQ4C9anbJR82th+ooFAmD3OkkPHHppeUBudmlk
aWEuY29tAAoJEJ2yUfNrYfqKAk0P/i1jBQI9JtqfYGX3GuND2cVqeqXu+Eij6qEI
5B4dDvv0RP/wR8vocXbNuL8k7U3pfr2ovMAbT0M//qlICy/yBio8jkI2Z2jIHwYC
p6b9RqLepK+7ONH9mIHxqLVz5edJ6xTtcnfZrYUTCVCD9oKUzabVekoQ1zqkBYle
tUFwdj3VSC1LJG+vMpF0S6YI/uWri2mOXcdxtTh/GFXZHZc6rC822gRWzVhH8WJf
FMsbLlAfy8PK8HbG5oPaZRZhmSK4ufQIYrX39HRsDwP1FpdiSLcgAovsTPwOM4eM
EBTaP5sUneXIYkKfrTjTwfEELEPF117d1WZALcwd5OzIQ2jUQ87MFyd623mRtjF3
Jdet8P6FAucip8I023mz1U5cuX6ZRE/SSpEe9b9aTyvDyxNAPIGD6rxpwq1bZOJ9
IYc1S53a573BhjXT9WzIBT58MxorlzFYI/WA2CsmxZZVaJV3TTJa7hVNlT61Y4z8
vliTIV0JiN5UfUAuTOZB64x58akXf+Mydnb/odOMs0R3Ow0o+8IBZggmlj/jztku
yU755En/Hptk8XtzV84E+yBhT0JTjvd47dteaaJHJmUz7sJlOqaIecS3J6dyfclM
XEV2Jl6kwsuY/CLRNO60QBzXQSb88X4IJ3lHSNzVWdszDQDJT9AAfGxx1epKKB6v
yUWRwQ7g
=NcMV
-----END PGP SIGNATURE-----

--=_MailMate_D798A0F0-2E50-454C-8B5B-D2901548270E_=--
