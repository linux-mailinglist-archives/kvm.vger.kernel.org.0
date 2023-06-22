Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C1A73A517
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 17:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbjFVPdn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 11:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232566AbjFVPda (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 11:33:30 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2053.outbound.protection.outlook.com [40.107.96.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A272C269A;
        Thu, 22 Jun 2023 08:32:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h5tRdG/XBDLrYs3mGKpv0SLVhjkWxL+BMdGmvDND46NzHRsYjXaCafBrPGfNzk1+Ae7w/gl1TAAzalhh+qXU0vZLKpOcEDI1A0mqLdqSz3q/QIIcW9r9IkoKgtqfCAzHR0IUYpIDSJDwKxymBwbqsLfhe0suGDM/JGeEgMVWdxbgwNsZ1/E35EXhHvOau/o51iRmwkUBXcpQz3RbP0tAXIV5vgpiHLD87p0cMPWHP3d/Qh94iLxqtmMu0I9iRuezdO4pehRKIpjLD61HVuK2JYqkalOXVvCre+TG+EK37/v6F66SnAZXj2pk1XoJX2encbL4m/KlnoRCfPAsi3MyXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uOKQ4tLy4lmLfhUwKT8qUOQSzfRJe9PS7pk+tRc7/kQ=;
 b=FaPxzJRkezEgRQp0S7b9tdpxPdnGwA0J/gVMrNr53cQn9qxfqz0VaRNr9T8msI7Rm+WGh/Su+e2mZxBYZQmE0smwGx8LsmtXYDoTNrwOCrTrWbvX8SQdi4eoZw3OE3iuoVky7vSCApXSAXMOn8yphhSsIeVofqYmxQoAsT+slbFnu7sGftSL4dmHwwxRiB51okXsgYAOEBSZ8nErzW0xHn/JgUvlPtZshYNLbnW7AhnkxXQKr7NgSuRsEBdidoThsdqzoDeaAvnjIw1p5o20k9xzawofjoQicLgmGc8AAzzvONb01usFVAvWG8KPAOt/aOx8zIVRCcYw65V5ICljEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uOKQ4tLy4lmLfhUwKT8qUOQSzfRJe9PS7pk+tRc7/kQ=;
 b=qtJ/U/Yddn+08Usex8h9ajqPM1aCPw5uQjeBmacjI9eKctG6hopoCKCqtyMb56uA0DrQ7REfEQ9AuZtXsBQ6O7bbcLNRNs6OdT+OBxalPOIQTxNPEJOjsloIZlZqLo913YmhE7BBJDPJ3HTQcXjmXhPQTO+QSfUGoxvs63W8x2E=
Received: from BN1PR14CA0025.namprd14.prod.outlook.com (2603:10b6:408:e3::30)
 by DM6PR12MB4909.namprd12.prod.outlook.com (2603:10b6:5:1ba::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Thu, 22 Jun
 2023 15:32:48 +0000
Received: from BN8NAM11FT084.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e3:cafe::ca) by BN1PR14CA0025.outlook.office365.com
 (2603:10b6:408:e3::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24 via Frontend
 Transport; Thu, 22 Jun 2023 15:32:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT084.mail.protection.outlook.com (10.13.176.169) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.41 via Frontend Transport; Thu, 22 Jun 2023 15:32:48 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 22 Jun
 2023 10:32:48 -0500
Date:   Thu, 22 Jun 2023 10:32:29 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     "Huang, Kai" <kai.huang@intel.com>
CC:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "tobin@ibm.com" <tobin@ibm.com>,
        "liam.merwick@oracle.com" <liam.merwick@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "Lutomirski, Andy" <luto@kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "srinivas.pandruvada@linux.intel.com" 
        <srinivas.pandruvada@linux.intel.com>,
        "slp@redhat.com" <slp@redhat.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "alpergun@google.com" <alpergun@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
        "Annapurve, Vishal" <vannapurve@google.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "marcorr@google.com" <marcorr@google.com>,
        "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "nikunj.dadhania@amd.com" <nikunj.dadhania@amd.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [PATCH RFC v9 04/51] KVM: x86: Determine shared/private faults
 using a configurable mask
Message-ID: <20230622153229.vjkrzi6rgiolstns@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-5-michael.roth@amd.com>
 <20230614164709.GT2244082@ls.amr.corp.intel.com>
 <20230620202841.7qizls3u3kcck45g@amd.com>
 <20230620211845.GV2244082@ls.amr.corp.intel.com>
 <20230621230031.37hdnymbjzwjgbo2@amd.com>
 <c116b7ab8ca02116f2b8d19a8214161c3b30576c.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c116b7ab8ca02116f2b8d19a8214161c3b30576c.camel@intel.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT084:EE_|DM6PR12MB4909:EE_
X-MS-Office365-Filtering-Correlation-Id: dd641d23-9e0d-4932-1878-08db7335ef3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /H2gTV3W5ku2G3veUjbyBln7S6CRe4ifYof6M/ZC381fHcit92ekthbAwIqL/e5eUCIQknxQQpoGwQJ3FCUDIgXpT8LiCScRyZylJMOpZ+KLqGWvjoZs7b5KAqVYMKCNgp9EXlIG35eGgUEpsByNeKUQA4HKuc2iWGo8bw8KNpiDWtSeMJPV2QbPF2dHVYB4PTd4vZCYM/mzJkWOorcvX0+5gPT4cldt0GeHC2WVzDB68x0gKCQWFgR+VgsKNOhbQ00NEwtISQIFSGMO9XlF0t3aHHywPJPA32vUDf/NP4I2P6mc6WKPRGrQg26OQ6NpQ83azIN7IRk65ERlUd/EYpJsKWofUx4zAniTkqAxSkL5TuulqRUTNk0zTZayhrXkF0xzBE3qClWoalT8NNUCwvYLOB9c4oxo0BcUdtBhC4hPqwi+qZqcWaU8fiTplrw0aXHRSwpziaDmme873CyvpvjSjz/Z620XLGdEpoiBNpYlYYOiK3zVa2jhcsEKT9CQeI/Y0eK+hK7qTkrZM5e+vjss39/0s8wO+cPPf54fhXqd6JWIbnGu6w+89aGA+5Qf17qS0Y5aAJWD16LpEST0cJ0/P9O5/XMm7NU2bEVAMrjcAwoOr1hAToyeVg1reQskmGbqqFU1MfQfFSzPLcVP+HmWh4WLitnXLFP95Cn8C2+xR6yY4NUCNgnmf5KdZFBskaQv+iWebHcyFQoWmSBHHuZ1ah5S06MOW3aZnlJZ/oxlHbUopcCfqq04zbFun6vGIMHRMy+8lQiBIK+jMXsGlyr4TJVMU8Gu+dzQpwcmFHg=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(396003)(39860400002)(376002)(451199021)(46966006)(36840700001)(40470700004)(478600001)(6666004)(54906003)(4326008)(47076005)(40480700001)(336012)(83380400001)(426003)(86362001)(36756003)(36860700001)(40460700003)(2616005)(70586007)(2906002)(82310400005)(1076003)(26005)(966005)(16526019)(186003)(356005)(81166007)(82740400003)(41300700001)(8676002)(7416002)(8936002)(70206006)(6916009)(316002)(7406005)(44832011)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2023 15:32:48.6717
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd641d23-9e0d-4932-1878-08db7335ef3e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT084.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4909
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URI_DOTEDU autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 22, 2023 at 09:55:22AM +0000, Huang, Kai wrote:
> 
> > 
> > So if we were to straight-forwardly implement that based on how TDX
> > currently handles checking for the shared bit in GPA, paired with how
> > SEV-SNP handles checking for private bit in fault flags, it would look
> > something like:
> > 
> >   bool kvm_fault_is_private(kvm, gpa, err)
> >   {
> >     /* SEV-SNP handling */
> >     if (kvm->arch.mmu_private_fault_mask)
> >       return !!(err & arch.mmu_private_fault_mask);
> > 
> >     /* TDX handling */
> >     if (kvm->arch.gfn_shared_mask)
> >       return !!(gpa & arch.gfn_shared_mask);
> 
> The logic of the two are identical.  I think they need to be converged.

I think they're just different enough that trying too hard to converge
them might obfuscate things. If the determination didn't come from 2
completely different fields (gpa vs. fault flags) maybe it could be
simplified a bit more, but have well-defined open-coded handler that
gets called once to set fault->is_private during initial fault time so
that that ugliness never needs to be looked at again by KVM MMU seems
like a good way to keep things simple through the rest of the handling.

> 
> Either SEV-SNP should convert the error code private bit to the gfn_shared_mask,
> or TDX's shared bit should be converted to some private error bit.

struct kvm_page_fault seems to be the preferred way to pass additional
params/metadata around, and .is_private field was introduced to track
this private/shared state as part of UPM base series:

  https://lore.kernel.org/lkml/20221202061347.1070246-9-chao.p.peng@linux.intel.com/

So it seems like unecessary complexity to track/encode that state into
other additional places rather than just encapsulating it all in
fault->is_private (or some similar field), and synthesizing all this
platform-specific handling into a well-defined value that's conveyed
by something like fault->is_private in a way where KVM MMU doesn't need
to worry as much about platform-specific stuff seems like a good thing,
and in line with what the UPM base series was trying to do by adding the
fault->is_private field.

So all I'm really proposing is that whatever SNP and TDX end up doing
should center around setting that fault->is_private field and keeping
everything contained there. If there are better ways to handle *how*
that's done I don't have any complaints there, but moving/adding bits
to GPA/error_flags after fault time just seems unecessary to me when
fault->is_private field can serve that purpose just as well.

> 
> Perhaps converting SEV-SNP makes more sense because if I recall correctly SEV
> guest also has a C-bit, correct?

That's correct, but the C-bit doesn't show in the GPA that gets passed
up to KVM during an #NPF, and instead gets encoded into the fault's
error_flags.

> 
> Or, ...
> 
> > 
> >     return false;
> >   }
> > 
> >   kvm_mmu_do_page_fault(vcpu, gpa, err, ...)
> >   {
> >     struct kvm_page_fault fault = {
> >       ...
> >       .is_private = kvm_fault_is_private(vcpu->kvm, gpa, err)
> 
> ... should we do something like:
> 
> 	.is_private = static_call(kvm_x86_fault_is_private)(vcpu->kvm, gpa, 
> 							    err);

We actually had exactly this in v7 of SNP hypervisor patches:

  https://lore.kernel.org/linux-coco/20221214194056.161492-7-michael.roth@amd.com/T/#m17841f5bfdfb8350d69d78c6831dd8f3a4748638

but Sean was hoping to avoid a callback, which is why we ended up using
a bitmask in this version since it basically all that callback would
need to do. It's unfortunately that we don't have a common scheme
between SNP/TDX, but maybe that's still possible, I just think that
whatever that ends up being, it should live and be contained inside
whatever helper ends up setting fault->is_private.

There's some other awkwardness with a callback approach. It sort of ties
into your question about selftests so I'll address it below...


> 
> ?
> 
> >     };
> > 
> >     ...
> >   }
> > 
> > And then arch.mmu_private_fault_mask and arch.gfn_shared_mask would be
> > set per-KVM-instance, just like they are now with current SNP and TDX
> > patchsets, since stuff like KVM self-test wouldn't be setting those
> > masks, so it makes sense to do it per-instance in that regard.
> > 
> > But that still gets a little awkward for the KVM self-test use-case where
> > .is_private should sort of be ignored in favor of whatever the xarray
> > reports via kvm_mem_is_private(). 
> > 
> 
> I must have missed something.  Why does KVM self-test have impact to how does
> KVM handles private fault? 

The self-tests I'm referring to here are the ones from Vishal that shipped with
v10 of Chao's UPM/fd-based private memory series, and also as part of Sean's
gmem tree:

  https://github.com/sean-jc/linux/commit/a0f5f8c911804f55935094ad3a277301704330a6

These exercise gmem/UPM handling without the need for any SNP/TDX
hardware support. They do so by "trusting" the shared/private state
that the VMM sets via KVM_SET_MEMORY_ATTRIBUTES. So if VMM says it
should be private, KVM MMU will treat it as private, so we'd never
get a mismatch, so KVM_EXIT_MEMORY_FAULT will never be generated.

> 
> > In your Misc. series I believe you
> > handled this by introducing a PFERR_HASATTR_MASK bit so we can determine
> > whether existing value of fault->is_private should be
> > ignored/overwritten or not.
> > 
> > So maybe kvm_fault_is_private() needs to return an integer value
> > instead, like:
> > 
> >   enum {
> >     KVM_FAULT_VMM_DEFINED,
> >     KVM_FAULT_SHARED,
> >     KVM_FAULT_PRIVATE,
> >   }
> > 
> >   bool kvm_fault_is_private(kvm, gpa, err)
> >   {
> >     /* SEV-SNP handling */
> >     if (kvm->arch.mmu_private_fault_mask)
> >       (err & arch.mmu_private_fault_mask) ? KVM_FAULT_PRIVATE : KVM_FAULT_SHARED
> > 
> >     /* TDX handling */
> >     if (kvm->arch.gfn_shared_mask)
> >       (gpa & arch.gfn_shared_mask) ? KVM_FAULT_SHARED : KVM_FAULT_PRIVATE
> > 
> >     return KVM_FAULT_VMM_DEFINED;
> >   }
> > 
> > And then down in __kvm_faultin_pfn() we do:
> > 
> >   if (fault->is_private == KVM_FAULT_VMM_DEFINED)
> >     fault->is_private = kvm_mem_is_private(vcpu->kvm, fault->gfn);
> >   else if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn))
> >     return kvm_do_memory_fault_exit(vcpu, fault);
> > 
> >   if (fault->is_private)
> >     return kvm_faultin_pfn_private(vcpu, fault);
> 
> 
> What does KVM_FAULT_VMM_DEFINED mean, exactly?
> 
> Shouldn't the fault type come from _hardware_?

In above self-test use-case, there is no reliance on hardware support,
and fault->is_private should always be treated as being whatever was
set by the VMM via KVM_SET_MEMORY_ATTRIBUTES, so that's why I proposed
the KVM_FAULT_VMM_DEFINED value to encode that case into
fault->is_private so KVM MMU and handle protected self-test VMs of this
sort.

In the future, this protected self-test VMs might become the basis of
a new protected VM type where some sort of guest-issued hypercall can
be used to set whether a fault should be treated as shared/private,
rather than relying on VMM-defined value. There's some current discussion
about that here:

  https://lore.kernel.org/lkml/20230620190443.GU2244082@ls.amr.corp.intel.com/T/#me627bed3d9acf73ea882e8baa76dfcb27759c440

Going back to your callback question above, that makes things a little
awkward, since kvm_x86_ops is statically defined for both
kvm_amd/kvm_intel modules, and either can run these self-tests guests as
well as these proposed "non-CC VMs" which rely on enlightened guest
kernels instead of TDX/SNPhardware support for managing private/shared
access.

So you either need to duplicate the handling for how to determine
private/shared for these other types into the kvm_intel/kvm_amd callbacks,
or have some way for the callback to say to "fall back to the common
handling for self-tests and non-CC VMs". The latter is what we implemented
in v8 of this series, but Isaku suggested it was a bit too heavyweight
and proposed dropping the fall-back logic in favor of updating the
kvm_x86_ops at run-time once we know whether or not it's a TDX/SNP guest:

  https://lkml.iu.edu/hypermail/linux/kernel/2303.2/03009.html

which could work, but it still doesn't address Sean's desire to avoid
callbacks completely, and still amounts to a somewhat convulated way
to hide away TDX/SNP-specific bit checks for shared/private. Rather
than hide them away in callbacks that are already frowned upon by
maintainer, I think it makes sense to "open-code" all these checks in a
common handler like kvm_fault_is_private() to we can make some progress
toward a consensus, and then iterate on it from there rather than
refining what may already be a dead-end path.

-Mike

