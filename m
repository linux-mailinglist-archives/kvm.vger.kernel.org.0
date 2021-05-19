Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3721389727
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 21:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbhEST7z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 15:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232460AbhEST7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 15:59:54 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C333C06175F
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 12:58:34 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id i6so2839895plt.4
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 12:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=j5nrfmcF93AKRgieL57ZADJtNONxgrPmJG86D6uJFj4=;
        b=SO21Jy/1gMSCHCoovzZ45WTy76Hy7+vgbq0ShV9jDL1liNPLWyjF5M75F14keRkJP1
         Is1Fdp5HWchYoHA8kvOCkZDALx3mp3YjHKOOhnUmPYQt2p7ZVQJl18E7Sbfb1bWZCicX
         GAyYpyr+adzDEteRVkaTzDbL2Im9W/iMRDdUlWg1YuK0+nahq0YnW8XddHLL9woFUcrj
         Jtcq1+RSkIV9DQvqBFMKqk+UdS+lmIF1r3c+4Q3Ng/C7C0zoccWU48HcZ5Kxa4v/qwLC
         MVPL2atl7AkILaS/4n9fEeYK8ZjWO1QCL3QfIGuSJMJgcO3NqhTBADNJ0BCO4p6JST7U
         ihKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=j5nrfmcF93AKRgieL57ZADJtNONxgrPmJG86D6uJFj4=;
        b=KGAKdseJP8LwbaE20CKu1KIcsD5Gy6izMvaC8zNuPyZKXWWpVYmLEzvgO/zduvdThD
         LfEdl2tTqieFSm15pbYTRVlyQ2rU92wZrtemePmna18WY9HfUK19Qtc/MdLIa9rkwnor
         i0diKMX3YLiyfq9l6VeF1+aXyaEe/1R8D1+ffDNDK3T8eBdV6lAph/9CVEOMwGM8GUza
         lfbK3UvPdu7fVo8srmdESBCazkCEsF66MQFh2atdMcSAjONIs9P8slh0Q0K3Dv2lLJXE
         iD2slasMCbDCqtBUVcL6MgTxeifzxjfLVtaUz8oy64DRVVzfhZiKU8aQamx8l598bk+S
         q2Fg==
X-Gm-Message-State: AOAM5304xvL2S/4j8VmQM2sCyH4/7yPh4zqanlREpr6taAJ1Fvax/Jlk
        Dc67yyY5tiVl4YxrYxiiUxkjRQ==
X-Google-Smtp-Source: ABdhPJyzhx1FtKRNVT6lwCbyTf/m5HXdEAfJf2CsHerYKwPsWe5O63zA+6yN8pqyQtfqiKgNNeE92Q==
X-Received: by 2002:a17:90a:a10a:: with SMTP id s10mr668570pjp.59.1621454313950;
        Wed, 19 May 2021 12:58:33 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id c134sm192434pfb.135.2021.05.19.12.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 12:58:33 -0700 (PDT)
Date:   Wed, 19 May 2021 19:58:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 29/43] KVM: SVM: Tweak order of cr0/cr4/efer writes at
 RESET/INIT
Message-ID: <YKVt5XVIQMUCUIHd@google.com>
References: <20210424004645.3950558-1-seanjc@google.com>
 <20210424004645.3950558-30-seanjc@google.com>
 <CAAeT=FzpUBXpzuCT3eD=3sRnV14OYLA+28Eo7YFioC+vc=xVsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAeT=FzpUBXpzuCT3eD=3sRnV14OYLA+28Eo7YFioC+vc=xVsA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 19, 2021, Reiji Watanabe wrote:
> > @@ -1204,18 +1204,13 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
> >         init_sys_seg(&save->ldtr, SEG_TYPE_LDT);
> >         init_sys_seg(&save->tr, SEG_TYPE_BUSY_TSS16);
> >
> > +       svm_set_cr0(vcpu, X86_CR0_NW | X86_CR0_CD | X86_CR0_ET);
> >         svm_set_cr4(vcpu, 0);
> >         svm_set_efer(vcpu, 0);
> >         save->dr6 = 0xffff0ff0;
> >         kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
> >         vcpu->arch.regs[VCPU_REGS_RIP] = 0x0000fff0;
> >
> > -       /*
> > -        * svm_set_cr0() sets PG and WP and clears NW and CD on save->cr0.
> > -        * It also updates the guest-visible cr0 value.
> > -        */
> > -       svm_set_cr0(vcpu, X86_CR0_NW | X86_CR0_CD | X86_CR0_ET);
> 
> AMD's APM Vol2 (Table 14-1 in Revision 3.37) says CR0 After INIT will be:
> 
>    CD and NW are unchanged
>    Bit 4 (reserved) = 1
>    All others = 0
> 
> (CR0 will be 0x60000010 after RESET)
> 
> So, it looks the CR0 value that init_vmcb() sets could be
> different from what is indicated in the APM for INIT.
> 
> BTW, Intel's SDM (April 2021 version) says CR0 for Power up/Reset/INIT
> will be 0x60000010 with the following note.
> -------------------------------------------------
> The CD and NW flags are unchanged,
> bit 4 is set to 1, all other bits are cleared.
> -------------------------------------------------
> The note is attached as '2' to all Power up/Reset/INIT cases
> looking at the SDM.  I would guess it is erroneous that
> the note is attached to Power up/Reset though.

Agreed.  I'll double check that CD and NW are preserved by hardware on INIT,
and will also ping Intel folks to fix the POWER-UP and RESET footnote.

Hah!  Reading through that section yet again, there's another SDM bug.  It
contradicts itself with respect to the TLBs after INIT.

  9.1 INITIALIZATION OVERVIEW: 
    The major difference is that during an INIT, the internal caches, MSRs,
    MTRRs, and x87 FPU state are left unchanged (although, the TLBs and BTB
    are invalidated as with a hardware reset)

while Table 9-1 says:

  Register                    Power up    Reset      INIT
  Data and Code Cache, TLBs:  Invalid[6]  Invalid[6] Unchanged

I'm pretty sure that Intel CPUs are supposed to flush the TLB, i.e. Tabel 9-1 is
wrong.  Back in my Intel validation days, I remember being involved in a Core2
bug that manifested as a triple fault after INIT due to global TLB entries not
being flushed.  Looks like that wasn't fixed:

https://www.intel.com/content/dam/support/us/en/documents/processors/mobile/celeron/sb/320121.pdf

  AZ28. INIT Does Not Clear Global Entries in the TLB
  Problem: INIT may not flush a TLB entry when:
    • The processor is in protected mode with paging enabled and the page global enable
      flag is set (PGE bit of CR4 register)
    • G bit for the page table entry is set
    • TLB entry is present in TLB when INIT occurs
    • Software may encounter unexpected page fault or incorrect address translation due
      to a TLB entry erroneously left in TLB after INIT.

  Workaround: Write to CR3, CR4 (setting bits PSE, PGE or PAE) or CR0 (setting
              bits PG or PE) registers before writing to memory early in BIOS
	      code to clear all the global entries from TLB.
	      
  Status: For the steppings affected, see the Summary Tables of Changes.

AMD's APM also appears to contradict itself, though that depends on one's
interpretation of "external intialization".  Like the SDM, its table states that
the TLBs are not flushed on INIT:

  Table 14-1. Initial Processor State

  Processor Resource         Value after RESET      Value after INIT
  Instruction and Data TLBs  Invalidated            Unchanged

but a blurb later on says:

  5.5.3 TLB Management

  Implicit Invalidations. The following operations cause the entire TLB to be
  invalidated, including global pages:

    • External initialization of the processor.


All in all, that means KVM also has a bug in the form of a missing guest TLB
flush on INIT, at least for VMX and probably for SVM.  I'll add a patch to flush
the guest TLBs on INIT irrespective of vendor.  Even if AMD CPUs don't flush the
TLB, I see no reason to bank on all guests being paranoid enough to flush the
TLB immediately after INIT.
