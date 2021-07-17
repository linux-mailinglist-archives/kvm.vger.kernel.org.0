Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0CF3CC05B
	for <lists+kvm@lfdr.de>; Sat, 17 Jul 2021 02:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbhGQAth (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 20:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231837AbhGQAtf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jul 2021 20:49:35 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23FD7C06175F
        for <kvm@vger.kernel.org>; Fri, 16 Jul 2021 17:46:39 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id b8-20020a17090a4888b02901725eedd346so8038814pjh.4
        for <kvm@vger.kernel.org>; Fri, 16 Jul 2021 17:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=u/IsvU1kqurQZC76XNFVOghfUpyMawBFCFuK0AQGEPM=;
        b=NuCt8dbb8sG/61BzzDfSqZdk1jTtBf3jihYSLd2BtQD1axvderSNU/SgNFmdYw9yVF
         CPsb6YE00bicpuzx4V/RNNSkWuQ1sd0VhHol83yyNvPkrQGOlnbPs9ITEow4f49hdw9z
         YDYlNHFx5vt+MgN/Y51hhSiDu9BrX8ZWKnI4AtF1f5OkN/gldMEAGVZppOMdp4rQv5IA
         +wJ170ZMv1RCOwHSztImvpX9LKSn0tHn/B9uhbFcDdIwyXrMfIJfHUANecYKm2exm1QQ
         7WySfTfcqN7JP8GUbUmnvRv3aGtutSGWprJDzeeeRiXmCJ3HOgNfyphJ5fDz6kf7hTSz
         RPCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u/IsvU1kqurQZC76XNFVOghfUpyMawBFCFuK0AQGEPM=;
        b=btuQWHdM+2iCqiKgGelml5mDsLK9UUTxJ7ihrf1UiySlmXfGJBKI/0gxpA9cE8QpDY
         fvtgi70rrTTFhSbHCR1QkFhRxUXspVGw8UW+LL1o/PFxQEfTL8PEPF/BdDeJZKHm8PDr
         sXD6WWw5+QXMOO4q+ddO92YPmliNf2NrkEsoKNmS2TBf2rm+RERhU+pMiVryd9X6F6d/
         sNmxl3cv6Tcto+maM2utIiBCnZXkRsWEt/0Xk1nGqVZuagYfF6sVH3EBR6/qQPrjNuft
         7bRT5MqbyCvbTSfVYGlmqn1OpI+AkFPZ5QeoeuUukYkAVbfs5x9anx5H9BRsAKMRpm3H
         WqzQ==
X-Gm-Message-State: AOAM531G/uKtLlvdghJhVI0Exb57bFycEvzWbN3nreKt9lLVjxdKa6fk
        XBbf9TurMltoFfjh3KDAaZzg2w==
X-Google-Smtp-Source: ABdhPJxrswPajbOgVL6Nn4Vj+gROMrISPPW53TbQlFyRjN5Y9ZDDm/vzxRO3O2TefotPh/hbXLdwIA==
X-Received: by 2002:a17:902:9890:b029:120:1299:678e with SMTP id s16-20020a1709029890b02901201299678emr9822840plp.32.1626482798329;
        Fri, 16 Jul 2021 17:46:38 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j2sm11921868pfb.53.2021.07.16.17.46.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jul 2021 17:46:37 -0700 (PDT)
Date:   Sat, 17 Jul 2021 00:46:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-efi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>, tony.luck@intel.com,
        npmccallum@redhat.com, brijesh.ksingh@gmail.com
Subject: Re: [PATCH Part2 RFC v4 25/40] KVM: SVM: Reclaim the guest pages
 when SEV-SNP VM terminates
Message-ID: <YPIoaoDCjNVzn2ZM@google.com>
References: <20210707183616.5620-1-brijesh.singh@amd.com>
 <20210707183616.5620-26-brijesh.singh@amd.com>
 <YPHnb5pW9IoTcwWU@google.com>
 <2711d9f9-21a0-7baa-d0ff-2c0f69ca6949@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2711d9f9-21a0-7baa-d0ff-2c0f69ca6949@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 16, 2021, Brijesh Singh wrote:
> 
> On 7/16/21 3:09 PM, Sean Christopherson wrote:
> > On Wed, Jul 07, 2021, Brijesh Singh wrote:
> >> +			e = snp_lookup_page_in_rmptable(region->pages[i], &level);
> >> +			if (unlikely(!e))
> >> +				continue;
> >> +
> >> +			/* If its not a guest assigned page then skip it. */
> >> +			if (!rmpentry_assigned(e))
> >> +				continue;
> >> +
> >> +			/* Is the page part of a 2MB RMP entry? */
> >> +			if (level == PG_LEVEL_2M) {
> >> +				val.pagesize = RMP_PG_SIZE_2M;
> >> +				pfn &= ~(KVM_PAGES_PER_HPAGE(PG_LEVEL_2M) - 1);
> >> +			} else {
> >> +				val.pagesize = RMP_PG_SIZE_4K;
> > This raises yet more questions (for me) as to the interaction between Page-Size
> > and Hyperivsor-Owned flags in the RMP.  It also raises questions on the correctness
> > of zeroing the RMP entry if KVM_SEV_SNP_LAUNCH_START (in the previous patch).
> 
> I assume you mean the LAUNCH_UPDATE because that's when we need to
> perform the RMPUPDATE.

Doh, yes.

> The hypervisor owned means all zero in the RMP entry.

Figured out where I went wrong after reading the RMPUDPATE pseudocode.  RMPUPDATE
takes the page size as a parameter even though it unconditionally zeros the page
size flag in the RMP entry for unassigned pages.

A wrapper around rmpupdate() would definitely help, e.g. (though level might need
to be an "int" to avoid a bunch of casts).

  int rmp_make_shared(u64 pfn, enum pg_level level);

Wrappers for "private" and "firmware" would probably be helpful too.  And if you
do that, I think you can bury both "struct rmpupdate", rmpupdate(), and
X86_TO_RMP_PG_LEVEL() in arch/x86/kernel/sev.c.  snp_set_rmptable_state() might
need some refactoring to avoid three booleans, but I guess maybe that could be
an exception?  Not sure.  Anyways, was thinking something like:

  int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid);
  int rmp_make_firmware(u64 pfn);

It would consolidate a bit of code, and more importantly it would give visual
cues to the reader, e.g. it's easy to overlook "val = {0}" meaning "make shared".

Side topic, what happens if a firmware entry is configured with page_size=1?

And one architectural question: what prevents a malicious VMM from punching a 4k
shared page into a 2mb private page?  E.g.

  rmpupdate(1 << 20, [private, 2mb]);
  rmpupdate(1 << 20 + 4096, [shared, 4kb]);

I don't see any checks in the pseudocode that will detect this, and presumably the
whole point of a 2mb private RMP entry is to not have to go walk the individual
4kb entries on a private access.

  NEW_RMP = READ_MEM.o [NEW_RMP_PTR]

  IF ((NEW_RMP.PAGE_SIZE == 2MB) && (SYSTEM_PA[20:12] != 0))  <-- not taken, 4kb entry
          EAX = FAIL_INPUT
          EXIT

  IF (!NEW_RMP.ASSIGNED && (NEW_RMP.IMMUTABLE || (NEW_RMP.ASID != 0))  <-- not taken, new entry valid
          EAX = FAIL_INPUT
          EXIT

  RMP_ENTRY_PA = RMP_BASE + 0x4000 + (SYSTEM_PA / 0x1000) * 16
  IF (RMP_ENTRY_PA > RMP_END)
          EAX = FAIL_INPUT
          EXIT

  // System address must have an RMP entry
  OLD_RMP = READ_MEM_PA.o [RMP_ENTRY_PA]
  IF (OLD_RMP.IMMUTABLE) <-- passes, private entry not immutable
          EAX = FAIL_PERMISSION
          EXIT

  IF (NEW_RMP.PAGE_SIZE == 4KB)
          IF ((SYSTEM_PA[20:12] == 0) && (OLD_RMP.PAGE_SIZE == 2MB)) <- not taken, PA[12] == 1
                  EAX = FAIL_OVERLAP
                  EXIT
  ELSE
          IF (Any 4KB RMP entry with (RMP.ASSIGNED == 1) exists in 2MB region)
                  EAX = FAIL_OVERLAP
                  EXIT
          ELSE
                  FOR (I = 1; I < 512, I++) {
                          temp_RMP = 0
                          temp_RMP.ASSIGNED = NEW_RMP.ASSIGNED
                          WRITE_MEM.o [RMP_ENTRY_PA + I * 16] = temp_RMP;
                  }
