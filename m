Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D826E40CDAA
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 22:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhIOUGV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 16:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbhIOUGU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Sep 2021 16:06:20 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB84C061574
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 13:04:51 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id c8so9064365lfi.3
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 13:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PJmcziiXmV8RIDbZ5D5UGsw521UNmkikWzjsy2xatzI=;
        b=qYfsUO72jzT4TWWeJIe6bnU4+xaGNqkuwhxq7qPUJWGcVmmE5nrH7w4PwgOVP/45i6
         D6JCUo6tVAYsJy51Xvn+OiLGsnYNha2MvjzXv8QYcO3NdMMAV2fcBogsClVqHnnVc+HB
         EUuJGikXwdM6Ga3rUvHG502bJiXyBCWfkOnQ1JuFr5XXVCh+Zxfk9Q1F10pmP0vagj41
         bHQvOeDYwZh2UkF9bB58Wc/gHQwSTrRs4iZLWMinpicl1khA6fit3JvQSwMDRvmXheqF
         wkLv1G99JxZdvfklwZSY6QAuLXEdLfO2HVMQvfBXlR4G/HjFD5sqRF1Ow6kcW2PlrVYg
         +AZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PJmcziiXmV8RIDbZ5D5UGsw521UNmkikWzjsy2xatzI=;
        b=2uwgOmMqQBiZ3a0EtxlBxgtcATXgpkeGVGX+jvfqcjfe5/5dahhaCTX/qhAsZIc7Uy
         z0CsJwe8KAIiS8yMff4G95jdBCZ0fQ5q6Ha4Sz7chrZlyXwTNLqBPk+kcCoiESaj9Moc
         4hsVIAI57oG8IxFSHZjDX9mJYopmAb+fxgpx2aNmO12UgD0FELpof2f8XzMf9fYEIqP/
         ISLf2X7E2UKnvUeliJwd6NKviFCDjaOW6jytAiponnmX/PNPr4AsJNIhr3GfqG8E1roA
         qK8Qsoic5Rj/Y/tPoiX2muiW28BGAzXlkZLehkROMyUmMzMIKws4O5Z8FPzJb12213xK
         KFUg==
X-Gm-Message-State: AOAM533lBeDHBg3IACQReTXp1YX3LM/CW+Z+DURJTI2Dg57mFGz0p+YF
        af+Mqe8ZIKcv6HAvedwTGms+eA==
X-Google-Smtp-Source: ABdhPJxjPfwH2g9ak/eK9haf/qlkdtExND36Ul9ulD+4sIjr7HF+ctNlv6IsgFBwf9d9RA8jxd6Xjg==
X-Received: by 2002:a05:6512:1329:: with SMTP id x41mr1241997lfu.9.1631736289779;
        Wed, 15 Sep 2021 13:04:49 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id t15sm93908ljo.102.2021.09.15.13.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 13:04:48 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 26905102F9E; Wed, 15 Sep 2021 23:04:52 +0300 (+03)
Date:   Wed, 15 Sep 2021 23:04:52 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     David Hildenbrand <david@redhat.com>
Cc:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>,
        Andi Kleen <ak@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Dario Faggioli <dfaggioli@suse.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-coco@lists.linux.dev,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
Subject: Re: [RFC] KVM: mm: fd-based approach for supporting KVM guest
 private memory
Message-ID: <20210915200452.wp6ippdvjz6zpv6a@box.shutemov.name>
References: <20210824005248.200037-1-seanjc@google.com>
 <20210902184711.7v65p5lwhpr2pvk7@box.shutemov.name>
 <YTE1GzPimvUB1FOF@google.com>
 <20210903191414.g7tfzsbzc7tpkx37@box.shutemov.name>
 <02806f62-8820-d5f9-779c-15c0e9cd0e85@kernel.org>
 <20210910171811.xl3lms6xoj3kx223@box.shutemov.name>
 <20210915195857.GA52522@chaop.bj.intel.com>
 <51a6f74f-6c05-74b9-3fd7-b7cd900fb8cc@redhat.com>
 <20210915142921.bxxsap6xktkt4bek@black.fi.intel.com>
 <ca80775c-6bcb-f7c2-634b-237bc0ded52a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca80775c-6bcb-f7c2-634b-237bc0ded52a@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 15, 2021 at 04:59:46PM +0200, David Hildenbrand wrote:
> 
> > > I don't think we are, it still feels like we are in the early prototype
> > > phase (even way before a PoC). I'd be happy to see something "cleaner" so to
> > > say -- it still feels kind of hacky to me, especially there seem to be many
> > > pieces of the big puzzle missing so far. Unfortunately, this series hasn't
> > > caught the attention of many -MM people so far, maybe because other people
> > > miss the big picture as well and are waiting for a complete design proposal.
> > > 
> > > For example, what's unclear to me: we'll be allocating pages with
> > > GFP_HIGHUSER_MOVABLE, making them land on MIGRATE_CMA or ZONE_MOVABLE; then
> > > we silently turn them unmovable, which breaks these concepts. Who'd migrate
> > > these pages away just like when doing long-term pinning, or how is that
> > > supposed to work?
> > 
> > That's fair point. We can fix it by changing mapping->gfp_mask.
> 
> That's essentially what secretmem does when setting up a file.
> 
> > 
> > > Also unclear to me is how refcount and mapcount will be handled to prevent
> > > swapping,
> > 
> > refcount and mapcount are unchanged. Pages not pinned per se. Swapping
> > prevented with the change in shmem_writepage().
> 
> So when mapping into the guest, we'd increment the refcount but not the
> mapcount I assume?

No. The only refcount hold page cache. But we inform KVM via callback
before removing the page from the page cache. It is similar to
mmu_notifier scheme KVM uses at the moment.

> 
> > 
> > > who will actually do some kind of gfn-epfn etc. mapping, how we'll
> > > forbid access to this memory e.g., via /proc/kcore or when dumping memory
> > 
> > It's not aimed to prevent root to shoot into his leg. Root do root.
> 
> IMHO being root is not an excuse to read some random file (actually used in
> production environments) to result in the machine crashing. Not acceptable
> for distributions.

Reading does not cause problems. Writing does.

> I'm still missing the whole gfn-epfn 1:1 mapping discussion we identified as
> requirements. Is that supposed to be done by KVM? How?

KVM memslots that represents a range of GFNs refers to memfd (and holds
file pin) plus offset in the file. This info enough to calculate offset in
the file and find PFN. memfd tied 1:1 to struct kvm and KVM would make
sure that there's only one possible gfn for a file offset.

> > > ... and how it would ever work with migration/swapping/rmap (it's clearly
> > > future work, but it's been raised that this would be the way to make it
> > > work, I don't quite see how it would all come together).
> > 
> > Given that hardware supports it migration and swapping can be implemented
> > by providing new callbacks in guest_ops. Like ->migrate_page would
> > transfer encrypted data between pages and ->swapout would provide
> > encrypted blob that can be put on disk or handled back to ->swapin to
> > bring back to memory.
> 
> Again, I'm missing the complete picture. To make swapping decisions vmscan
> code needs track+handle dirty+reference information. How would we be able to
> track references? Does the hardware allow for temporary unmapping of
> encrypted memory and faulting on it? How would page_referenced() continue
> working? "we can add callbacks" is not a satisfying answer, at least for me.
> Especially, when it comes to eventual locking problems and races.

HW doesn't support swapping yet, so details will be just speculation.
IIUC, there's an accessed bit in EPT that can be used for tracking.

> Maybe saying "migration+swap is not supported" is clearer than "we can add
> callbacks" and missing some details on the bigger picture.
> 
> Again, a complete design proposal would be highly valuable, especially to
> get some more review from other -MM folks. Otherwise there is a high chance
> that this will be rejected late when trying to upstream and -MM people
> stumbling over it (we've had some similar thing happening just recently
> unfortunately ...).

I only work on core-mm side of the story. We will definitely need to look
at whole picture again once all pieces are somewhat ready.

-- 
 Kirill A. Shutemov
