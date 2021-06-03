Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890B339A9A7
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 20:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhFCSDm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 14:03:42 -0400
Received: from mail-pl1-f179.google.com ([209.85.214.179]:41924 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbhFCSDl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 14:03:41 -0400
Received: by mail-pl1-f179.google.com with SMTP id e8so2458585plh.8
        for <kvm@vger.kernel.org>; Thu, 03 Jun 2021 11:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Z5kNm+LNrwmVEe8fXLD1P6L9e9YhdVUhcQol6wGk2ls=;
        b=Aad59Cr3pmAr49rU5h93PBjojoKRjJE8i4uDG9qQHowDS4UnFAJn+E/YjeQ7AzY2NN
         lWD1VzHfgSvXyUmvExmsamj2DdN4ipqRR0eZV6l1Huy87Kgm1HULSVa339hK/cSJQDZ7
         AYUEmRvWMc9AKKJnWswh9r2uDLeolkC08O16IqOlu03nXgRKy3dzl6YH3MCOfJM/XNP9
         Jtv3thiDJz2B1YXZ41/YEmFSNwT6MKs3Bbd4OR0OOejlAjx8XyQVZaN3WNY70vuVoxSj
         8SK4reoN3Z9UxBHiewm104kNNN1rIlUVeOuKVkzAI318CACRXlJqefTj+119+SBrL7+H
         +fJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Z5kNm+LNrwmVEe8fXLD1P6L9e9YhdVUhcQol6wGk2ls=;
        b=ia1br7sTV1p68OcMUAwWXzSn1bqfGuotRmPN9ZIJBLVWjTK8ol/Dl4mEn57pRMqnca
         qyFlfAvgbuKWxJnf9aPIPpVmzGtd8N7WR4+3qlqIgjwGTfWQJ2cPHuCayLki6REzzmGw
         W7s0+t9ymxVfmcMMK1kW6aiO4SAef2q+9FdtHjDzHwzFAIwfZk4nY368UWfmDnw6rZ8z
         TtEujUul/JFe5HR8rUZ+NHNM+C9WmYmLXGnrCD/ib6KDLW8CoGrNS2wSefP34hz6eSrP
         j68sGEQ4KnbcfHvxXrpgPM2PWme8SHFM8Qqrxi5cweBycXbi92qugG+h47DrqL4oehwS
         OYZA==
X-Gm-Message-State: AOAM5319R11eWKS9IowLt2ssLe/FZRiqEwz1Cxrcn6IpJOPjUmwImW6a
        nsbhlX/0BywiYynZ4x03KhXKQA==
X-Google-Smtp-Source: ABdhPJy00t26VSZEdy83QHmGt/IYwwC2E61BljJuqq6AgazLNf8wlYl14icS3LFIGOAcPd0ZCsUZOw==
X-Received: by 2002:a17:90a:3484:: with SMTP id p4mr480992pjb.2.1622743190176;
        Thu, 03 Jun 2021 10:59:50 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id d15sm3259838pgu.84.2021.06.03.10.59.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 10:59:49 -0700 (PDT)
Date:   Thu, 3 Jun 2021 17:59:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH V2] KVM: X86: MMU: Use the correct inherited permissions
 to get shadow page
Message-ID: <YLkYkcn+1MJhQYMf@google.com>
References: <20201120095517.19211-1-jiangshanlai@gmail.com>
 <20210603052455.21023-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210603052455.21023-1-jiangshanlai@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 03, 2021, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> Commit 41074d07c78b ("KVM: MMU: Fix inherited permissions for emulated
> guest pte updates") said role.access is common access permissions for
> all ptes in this shadow page, which is the inherited permissions from
> the parent ptes, and should not from any children pte.
> 
> But the commit did not enforce this definition when kvm_mmu_get_page()
> is called in FNAME(fetch). Rather, it uses a whole combined access of

Nit: I'd like to avoid "combined access" as "combined" has a specific meaning
in Intel's EPT terminology.

> the first accessing vitual address except the ternimating pte. And the
                      ^^^^^^                    ^^^^^^^^^^^
		      virtual                   terminating

> permissions won't be checked again in next FNAME(fetch) since the spte
> is present. It might fail to meet guest's expectation when guest uses
> shared pagetables.

Alternatively, I'd be completely ok not even mentioning commit 41074d07c78b.
It's definitely a similar bug, but not directly related. 

> For example, here is a shared pagetable:
>    pgd[]   pud[]        pmd[]            virtual address pointers
>                      /->pmd1(u--)->pte1(uw-)->page1 <- ptr1 (u--)
>         /->pud1(uw-)--->pmd2(uw-)->pte2(uw-)->page2 <- ptr2 (uw-)
>    pgd-|           (shared pmd[] as above)
>         \->pud2(u--)--->pmd1(u--)->pte1(uw-)->page1 <- ptr3 (u--)
>                      \->pmd2(uw-)->pte2(uw-)->page2 <- ptr4 (u--)
>   pud1 and pud2 point to the same pmd table, so:
>   ptr1 and ptr3 points to the same page.
>   ptr2 and ptr4 points to the same page.
> 
> (pud1 and pud2 here are pud entries, not pud pagtable pointer
>  pmd1 and pmd2 here are pmd entries, not pmd pagtable pointer)
> 
>   The guess read-accesses to ptr1 first. So the hypervisor gets the
> shadow page table with role.access=u-- for ptr1's pud1 and ptr1's pmd1.
> (Note: current pt->access is the combined access of pgd, pud1 and
> pmd1, so it is "u--".  But the current code uses this pt->access to
> get pagetable for pud1 which violate the definition in the comment
> which should be the combined access of pgd, pud1, a.k.a "uw-".)
> 
>   And then the guest write-accesses to ptr2, and the hypervisor
> set up shadow page for ptr2.
> (Note: current pt->access=uw-, but pud1 points to a shadow pmd
> table with role.access=u--.  Since pud1 is present, the hypervisor
> silencely accepts it without recheck the access in FNAME(fetch))
> 
>   After that, the guess read-accesses to ptr3, the hypervisor
> reused the same shadow pmd page table for pud2 as ptr1.
> (Note: because current pt->access=u--, which is the access of pgd, pud2
> and pmd1)
> 
>   At last, the guest writes to ptr4 without vmexit nor pagefault.
> Which should cause pagefault as the guest expects.
> 
> Any kind of shared pagetable might have the similar problem when in
> virtual machine without TDP enabled if the permissions are different
> from different ancestors.
> 
> In order to fix the problem, we change pt->access to be an array, and
> any access in it will not combind accesses from child ptes.
                            ^^^^^^^
			    combine

This typo aside, can we rewrite this paragraph and hoist it to the top?  I love
the in-depth analysis, but the downside is that describing the change after the
analysis makes it difficult to understand the actual code change.

I'd also like to provide a more detailed explanation of why the fix works, which
ties in a bit with the first two paragraphs.

Maybe drop the first two paragraphs and combine the info into something like this?

  When computing the access permissions of a shadow page, use the effective
  permissions of the walk up to that point, i.e. the logic AND of its parents'
  permissions.  Two guest PxE entries that point at the same table gfn need to
  be shadowed with different shadow pages if their parents' permissions are
  different.  KVM currently uses the effective permissions of the last
  non-leaf entry for all non-leaf entries, which can lead to incorrectly
  reusing a shadow page if a lower-level entry has more restrictve permissions,
  and eventually result in a missing guest protection page fault.

> The test code is: https://lore.kernel.org/kvm/20210603050537.19605-1-jiangshanlai@gmail.com/ 
> Remember to test it with TDP disabled.
> 
> The problem had existed long before the commit 41074d07c78b ("KVM: MMU:
> Fix inherited permissions for emulated guest pte updates"), and it
> is hard to find which is the culprit.  So there is no fixes tag here.

We definitely want a Fixes or manual Cc: stable@.  I think this is appropriate:

  Fixes: cea0f0e7ea54 ("[PATCH] KVM: MMU: Shadow page table caching")

AFAICT, KVM didn't reuse shadow pages for PxEs with different parents.

> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
> Changed from V1:
> 	Update changelog only


Apologies for neglecting to respond to your questions many months ago.  

On Mon, Nov 30, 2020 at 5:31 PM Lai Jiangshan <jiangshanlai@gmail.com> wrote:
>
> On Tue, Dec 1, 2020 at 1:41 AM Sean Christopherson <seanjc@google.com> wrote:
>
> > Hmm, yes, KVM would incorrectly handle this scenario.  But, the proposed patch
> > would not address the issue as KVM always maps non-leaf shadow pages with full
> > access permissions.
> >
>
> Is it possible to exactly copy the access permissions from the guest
> for non-leaf shadow pages?

The answer is: my analysis was wrong.  KVM does map non-leaf shadow pages with
full permissions, but changing the shadow page's access permissions causes KVM
to use a different shadow page, which is key.  Using a different shadow page
means that KVM creates a completely different tree and thus a different leaf
SPTE (with more restricted permissions), even though the guest PTEs are one and
the same.

> Any protection from hypervisor (such as dirty track, rmap_write_protect) can
> only play on the leaf shadow ptes.
>
> > Can we have a testcase in kvm-unit-tests?  It's okay of course if it
> > only fails with ept=0.
>
> Yes, it may have a flaw with ept=0. I don't get what "It's okay of course"
> means. Is it related to kvm-unit-tests? Or no cloud provider uses
> ept=0?

Paolo was saying that it's okay if the unit test relies on legacy shadow paging,
as opposed to setting up nested EPT or neset NPT.

> @@ -418,13 +418,15 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
>  		}
>  
>  		walker->ptes[walker->level - 1] = pte;
> +
> +		/* Convert to ACC_*_MASK flags for struct guest_walker.  */

I'd drop the comment about converting the mask, that's mostly self-explanatory
given the rest of the code.  What I'd like to do instead is explain why
walker->pt_access[] needs to compute the parent permissiona and only the parent
permissions.

> +		walker->pt_access[walker->level - 1] = FNAME(gpte_access)(pt_access ^ walk_nx_mask);

I think it makes sense to hoist this up to where table_gfn is set.  There's no
harm in filling pt_access[] on a fault, e.g. if this point isn't reached because
the pte is not-present.

That will allow dropping pt_access, associate pt_access more closely with
table_gfn, and make it more difficult to incorrectly incorporate the pte's
permission in the pt_access, e.g. if someone in the future thinks using pt_access
instead of pte_access is a typo.

E.g. for the comment and dropping of pt_access;

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 823a5919f9fa..cefbaa917ad8 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -316,7 +316,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
        pt_element_t pte;
        pt_element_t __user *ptep_user;
        gfn_t table_gfn;
-       u64 pt_access, pte_access;
+       u64 pte_access;
        unsigned index, accessed_dirty, pte_pkey;
        unsigned nested_access;
        gpa_t pte_gpa;
@@ -362,7 +362,6 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
        do {
                unsigned long host_addr;
 
-               pt_access = pte_access;
                --walker->level;
 
                index = PT_INDEX(addr, walker->level);
@@ -374,6 +373,17 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
                walker->table_gfn[walker->level - 1] = table_gfn;
                walker->pte_gpa[walker->level - 1] = pte_gpa;
 
+               /*
+                * The access permissions of the table are the logical AND of
+                * its parent's permissions, i.e. everything that's been
+                * collected so far.  The PxE's pt_access is combined with its
+                * its table_gfn (and other data) to generate the tag/key for
+                * the cache of shadow pages.  Two guest PxEs that point at the
+                * same table_gfn but have different parent permissions must
+                * use different shadow pages.
+                */
+               walker->pt_access[walker->level - 1] = FNAME(gpte_access)(pte_access ^ walk_nx_mask);
+
                real_gpa = mmu->translate_gpa(vcpu, gfn_to_gpa(table_gfn),
                                              nested_access,
                                              &walker->fault);
@@ -407,7 +417,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
                 * Inverting the NX it lets us AND it like other
                 * permission bits.
                 */
-               pte_access = pt_access & (pte ^ walk_nx_mask);
+               pte_access &= (pte ^ walk_nx_mask);
 
                if (unlikely(!FNAME(is_present_gpte)(pte)))
                        goto error;
@@ -418,9 +428,6 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
                }
 
                walker->ptes[walker->level - 1] = pte;
-
-               /* Convert to ACC_*_MASK flags for struct guest_walker.  */
-               walker->pt_access[walker->level - 1] = FNAME(gpte_access)(pt_access ^ walk_nx_mask);
        } while (!is_last_gpte(mmu, walker->level, pte));
 
        pte_pkey = FNAME(gpte_pkeys)(vcpu, pte);
