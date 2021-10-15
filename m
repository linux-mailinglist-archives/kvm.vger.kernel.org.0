Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B75542F9F3
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 19:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242165AbhJORSl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 13:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242163AbhJORSj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 13:18:39 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52AD5C061762
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 10:16:33 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id r2so9145765pgl.10
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 10:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Yz4DxDEI/Cdimscz6u8043i4TbobnMf/UyaeMP7e7fk=;
        b=R+KdF0sGuMsU7NaWwXEV/CtpO8oPzKODFyJvx0XbcWSvuHqF6hiQZv0LcDzeZlPsPp
         1Wk/T7I/I2ySHJMwuJCIw1zOMTF39MFy3f0A/U1Yj4qhbbOwEyMh6lTbrhzhoLsVb/1G
         Wy5ziNpFCQ9trOiwO5Yn9yB5nzCOxN1IH6C8L6ebAdFNj0zM1jJPBnEgUP1cLTVTItg5
         OR4GLXAbs+Wrs8agQaTMqNPq5uqBhKNbp4UnFMPc5saHaH0gV3JwymJCdLlQYlmE9XyU
         RdfTsPcPKpc2OApqgCf5oKTjrzZiMVwLPni1+ovOkHwwYg6ibTiFy20NBmOBy74jdQFL
         hq7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Yz4DxDEI/Cdimscz6u8043i4TbobnMf/UyaeMP7e7fk=;
        b=aNgyK542nHzysaqYO/yfuUWsl1/W20atp5PBNQWyoTikrdjO6T60QY7lV5uZG7Xy2R
         8Ph8t7GrR58qVQUel0NAFuYxAoGxssFqPjdYSgmPgUVPOa1heJl8yrggOgLFlZ/GfHTF
         SJeHzpPp9SinJaUNAqHBNXfdOQpt7AwgZHWAKCwbxLXpoK5eQY3/W4qtLhUr54ReJ+Hh
         /Y7+Yv8yBC0KcrJFDfHzqMpfIE0A3jC8Yxc9V4AZ/8KmeoSdtlpXikDvGQ9IPnfAJdMK
         yQy5nzyBasM0ZrY6b1Avt5PjuqSFKyyiU9BNIeYWVsrhMoLDY+XfwKyudO0EsuVqyUL/
         s+cw==
X-Gm-Message-State: AOAM531FfkoR1DTywub2qZFmLHTgNfTK8jWpAOj59u0le/jT+HqESE1H
        lF7tQLbEzM7AlWfY5TJAA2nkJw==
X-Google-Smtp-Source: ABdhPJzhWqYnWQxyRmrq2ph14bPlsygjQ8Zd2kY5FuLjbc+VOkShpD1Vy52EHoVShBuQrHaJwf5uKQ==
X-Received: by 2002:a62:9215:0:b0:44c:4de1:f777 with SMTP id o21-20020a629215000000b0044c4de1f777mr12957675pfd.31.1634318192625;
        Fri, 15 Oct 2021 10:16:32 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a7sm5398634pfo.32.2021.10.15.10.16.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 10:16:31 -0700 (PDT)
Date:   Fri, 15 Oct 2021 17:16:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
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
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 39/45] KVM: SVM: Introduce ops for the post gfn
 map and unmap
Message-ID: <YWm3bOFcUSlyZjNb@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-40-brijesh.singh@amd.com>
 <YWYm/Gw8PbaAKBF0@google.com>
 <YWc+sRwHxEmcZZxB@google.com>
 <4e41dcff-7c7b-cf36-434a-c7732e7e8ff2@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e41dcff-7c7b-cf36-434a-c7732e7e8ff2@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 15, 2021, Brijesh Singh wrote:
> 
> On 10/13/21 1:16 PM, Sean Christopherson wrote:
> > On Wed, Oct 13, 2021, Sean Christopherson wrote:
> >> On Fri, Aug 20, 2021, Brijesh Singh wrote:
> >>> When SEV-SNP is enabled in the guest VM, the guest memory pages can
> >>> either be a private or shared. A write from the hypervisor goes through
> >>> the RMP checks. If hardware sees that hypervisor is attempting to write
> >>> to a guest private page, then it triggers an RMP violation #PF.
> >>>
> >>> To avoid the RMP violation, add post_{map,unmap}_gfn() ops that can be
> >>> used to verify that its safe to map a given guest page. Use the SRCU to
> >>> protect against the page state change for existing mapped pages.
> >> SRCU isn't protecting anything.  The synchronize_srcu_expedited() in the PSC code
> >> forces it to wait for existing maps to go away, but it doesn't prevent new maps
> >> from being created while the actual RMP updates are in-flight.  Most telling is
> >> that the RMP updates happen _after_ the synchronize_srcu_expedited() call.
> > Argh, another goof on my part.  Rereading prior feedback, I see that I loosely
> > suggested SRCU as a possible solution.  That was a bad, bad suggestion.  I think
> > (hope) I made it offhand without really thinking it through.  SRCU can't work in
> > this case, because the whole premise of Read-Copy-Update is that there can be
> > multiple copies of the data.  That simply can't be true for the RMP as hardware
> > operates on a single table.
> >
> > In the future, please don't hesitate to push back on and/or question suggestions,
> > especially those that are made without concrete examples, i.e. are likely off the
> > cuff.  My goal isn't to set you up for failure :-/
> 
> What do you think about going back to my initial proposal of per-gfn
> tracking [1] ? We can limit the changes to just for the kvm_vcpu_map()
> and let the copy_to_user() take a fault and return an error (if it
> attempt to write to guest private). If PSC happen while lock is held
> then simplify return and let the guest retry PSC.

That approach is also broken as it doesn't hold a lock when updating host_write_track,
e.g. the count can be corrupted if writers collide, and nothing blocks writers on
in-progress readers.

I'm not opposed to a scheme that blocks PSC while KVM is reading, but I don't want
to spend time iterating on the KVM case until consensus has been reached on how
exactly RMP updates will be handled, and in general how the kernel will manage
guest private memory.
