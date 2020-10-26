Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0A062990FD
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 16:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1783848AbgJZP3O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 11:29:14 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40403 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1783835AbgJZP3O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 11:29:14 -0400
Received: by mail-lj1-f194.google.com with SMTP id 23so10621587ljv.7
        for <kvm@vger.kernel.org>; Mon, 26 Oct 2020 08:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2ASN/DBUumncOIXrVy0+uLgrT6nDM6lupwXazfbf6yY=;
        b=EPBJN71/a4yW2KNB4CZyN2SstX8ZPfZe1Yd139rZU2H/AwTqQzrPycVY6F8BH3y5le
         M17ZN9EGRHCQoaOFgHizwD/0aSwS0IR8u9gI6qpG9095ryTwpm2quspWyd4aUNAEMJfS
         dnuyNKQ3oEopLbKSb8KK1C5I5pTFhSC/KBYQRCMD1sojSqVQvF2PwE4ekq739Ek1IVMi
         Osw4L0hbOLYHvCtZvPh+pb+sNDXAn2nQnXvmOVadPjo4KZF/eGYtRHF2abtExs28HhiO
         vNOXFSDMNEs+i17/qL42Z/227K0y061wpPZyhXrmN3EsjeZorN4ietGRKYwjB8zr9wRx
         Olbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2ASN/DBUumncOIXrVy0+uLgrT6nDM6lupwXazfbf6yY=;
        b=p3rwB6gjsyxNLIFm2cucfJ7/Vh9gyeYct06QeKgZFGQBgPgU3KYiSF52KkGyzgBZ0C
         MsV0zvJ2nRHddEyeZF4mOLjaqZ0zPDhOyDDGmLHkuy8O9F1potX1hDVV0HkY0C3e+Y21
         lMlDuuxnR4rGZqBtipHqpcN9xG2JOVdZZQpF1KsKsTeWhXcyRRKNjMVWReLMCOoEPmem
         ZExfSfZIfIbRC3vlMkSk4OsP5VpDXx903Kt8O0y2oeVk05L57dAhYRDRf1ZmiY7w3CAb
         F4gmyHyU39nTwrudqq5gSCWaLXNKslbEjA75dbKK70stdpViiOcBt1a/ru3Nm1loeLJC
         Py4w==
X-Gm-Message-State: AOAM530xyJdX6PQztgS17JUfsrKc2ZT3FPn5yzmJ4p9RCE1NdzLEsxiq
        K2waDOHmHoPS9S2V23N6V3QCnA==
X-Google-Smtp-Source: ABdhPJwgJmr5qqnTpZrUz2JUkooPo2pPwM+xTp1Z3a13ceXJJ/6BSAtswICdSIuB01sAfeHKJH2E+Q==
X-Received: by 2002:a2e:9255:: with SMTP id v21mr6267205ljg.228.1603726150222;
        Mon, 26 Oct 2020 08:29:10 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id z11sm1222830ljk.7.2020.10.26.08.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 08:29:09 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id CAA6010366B; Mon, 26 Oct 2020 18:29:10 +0300 (+03)
Date:   Mon, 26 Oct 2020 18:29:10 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [RFCv2 00/16] KVM protected memory extension
Message-ID: <20201026152910.happu7wic4qjxmp7@box>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
 <CALCETrXn_ghtLK34jmKSSp5_SF6hh5GOfBLKdxXgp5ZTbN8uEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXn_ghtLK34jmKSSp5_SF6hh5GOfBLKdxXgp5ZTbN8uEA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 21, 2020 at 11:20:56AM -0700, Andy Lutomirski wrote:
> > On Oct 19, 2020, at 11:19 PM, Kirill A. Shutemov <kirill@shutemov.name> wrote:
> 
> > For removing the userspace mapping, use a trick similar to what NUMA
> > balancing does: convert memory that belongs to KVM memory slots to
> > PROT_NONE: all existing entries converted to PROT_NONE with mprotect() and
> > the newly faulted in pages get PROT_NONE from the updated vm_page_prot.
> > The new VMA flag -- VM_KVM_PROTECTED -- indicates that the pages in the
> > VMA must be treated in a special way in the GUP and fault paths. The flag
> > allows GUP to return the page even though it is mapped with PROT_NONE, but
> > only if the new GUP flag -- FOLL_KVM -- is specified. Any userspace access
> > to the memory would result in SIGBUS. Any GUP access without FOLL_KVM
> > would result in -EFAULT.
> >
> 
> I definitely like the direction this patchset is going in, and I think
> that allowing KVM guests to have memory that is inaccessible to QEMU
> is a great idea.
> 
> I do wonder, though: do we really want to do this with these PROT_NONE
> tricks, or should we actually come up with a way to have KVM guest map
> memory that isn't mapped into QEMU's mm_struct at all?  As an example
> of the latter, I mean something a bit like this:
> 
> https://lkml.kernel.org/r/CALCETrUSUp_7svg8EHNTk3nQ0x9sdzMCU=h8G-Sy6=SODq5GHg@mail.gmail.com
> 
> I don't mean to say that this is a requirement of any kind of
> protected memory like this, but I do think we should understand the
> tradeoffs, in terms of what a full implementation looks like, the
> effort and time frames involved, and the maintenance burden of
> supporting whatever gets merged going forward.

I considered the PROT_NONE trick neat. Complete removing of the mapping
from QEMU would require more changes into KVM and I'm not really familiar
with it.

About tradeoffs: the trick interferes with AutoNUMA. I didn't put much
thought into how we can get it work together. Need to look into it.

Do you see other tradeoffs?

-- 
 Kirill A. Shutemov
