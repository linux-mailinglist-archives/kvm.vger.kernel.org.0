Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 479F04652B1
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 17:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350280AbhLAQ1A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 11:27:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350209AbhLAQ07 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 11:26:59 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562DFC061574
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 08:23:38 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id z6so25000683pfe.7
        for <kvm@vger.kernel.org>; Wed, 01 Dec 2021 08:23:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KXlDbDHfm6MPpsIvUexZXkH+Oo9wCHRMsnEAQA6kjIo=;
        b=lcqV50x1HrgXfVhXY5D5JKXgkYr1FUZYfbMRQflyIJQE6UrA7g56VucLgGn3xsZ7hO
         1FClIo5U/3GH4H8hNd60p8EvXmi2onk+efUkewDJwg0oVb6VI7bUd/ls0K68IrZrvAIf
         SOomzc9JPnD5ctRRIVkE78U1LmXDuNbHnb3c1uzg3EWgTnooY0r4GKeisD7TVl1gSDEF
         TqOPrLHgUdUEpdF4f+7xpaQwjerOvCcODZDNMyc0kDjpa7k6i4Ne4MdxBxzBUGmJz77m
         Jm0tC/jVtT3DTvfpP6i5nxQ9vim+iDOOCw/52v+uYK8TYwF/dY/jSV4wtXprG8PRm8nj
         4uXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KXlDbDHfm6MPpsIvUexZXkH+Oo9wCHRMsnEAQA6kjIo=;
        b=skG4BjSt01Y2lesedMhtVeYqhTUz+va0f3UaKzwofnPW4ce4GseQwTkLAKNpn76MBJ
         i601mUo9v0ON26qW07nLT7hXPuf7YRTK5Xcpc5mFTkm5NJfERw4oiZQ8W48OZJu+qNTp
         DM/5EjvxTfFXaM92whPItOFPxyhKyfyg5SDTN+7uRQbGReI/YIZwRCHsXq+sp46xcWRx
         T+EvYKJDcotLSDpI9abCr8z3bpnId67dCqApO58lfWdRXmuNsmR4JF3QgzzxSKxAXIF/
         ACAfhrvvMARvQZlo4/7FEvPs/gc77K2LKFvuFb0JuSfZD71E13c01tkhiKfthiFYFHP6
         1akw==
X-Gm-Message-State: AOAM531orWH/VQw5mV/Rr0YkrIRJZV6GBfAlm/kRHOSIop1qYy4a5Lcg
        jDFQ8PcZeGEm5SgpXCxPhwiNlw==
X-Google-Smtp-Source: ABdhPJyBL07bl8kieStSK+Wj6FYYCzBo3wL7q1LXnaEGhsvYbQVXbGT/IEE+Can6YtJ9beFrHU6X0g==
X-Received: by 2002:a05:6a00:84c:b0:494:6d40:ed76 with SMTP id q12-20020a056a00084c00b004946d40ed76mr6940144pfk.65.1638375817560;
        Wed, 01 Dec 2021 08:23:37 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a3sm192787pgj.2.2021.12.01.08.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 08:23:36 -0800 (PST)
Date:   Wed, 1 Dec 2021 16:23:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 21/29] KVM: Resolve memslot ID via a hash table
 instead of via a static array
Message-ID: <YaehhRR75OB+qos8@google.com>
References: <cover.1638304315.git.maciej.szmigiero@oracle.com>
 <a6b62e0bdba2a82bbc31dcad3c8525ccc5ff0bff.1638304316.git.maciej.szmigiero@oracle.com>
 <Yabj3Qr8e85qhSg3@google.com>
 <c1dca71f-99d7-93b2-b4fe-d02526fefc81@maciej.szmigiero.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1dca71f-99d7-93b2-b4fe-d02526fefc81@maciej.szmigiero.name>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 01, 2021, Maciej S. Szmigiero wrote:
> On 01.12.2021 03:54, Sean Christopherson wrote:
> > On Tue, Nov 30, 2021, Maciej S. Szmigiero wrote:
> > > From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> > > 
> > > Memslot ID to the corresponding memslot mappings are currently kept as
> > > indices in static id_to_index array.
> > > The size of this array depends on the maximum allowed memslot count
> > > (regardless of the number of memslots actually in use).
> > > 
> > > This has become especially problematic recently, when memslot count cap was
> > > removed, so the maximum count is now full 32k memslots - the maximum
> > > allowed by the current KVM API.
> > > 
> > > Keeping these IDs in a hash table (instead of an array) avoids this
> > > problem.
> > > 
> > > Resolving a memslot ID to the actual memslot (instead of its index) will
> > > also enable transitioning away from an array-based implementation of the
> > > whole memslots structure in a later commit.
> > > 
> > > Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> > > Co-developed-by: Sean Christopherson <seanjc@google.com>
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > 
> > Nit, your SoB should come last since you were the last person to handle the patch.
> > 
> 
> Thought that my SoB should come first as coming from the author of this
> patch.
> 
> Documentation/process/submitting-patches.rst says that:
> > Any further SoBs (Signed-off-by:'s) following the author's SoB are from
> > people handling and transporting the patch, but were not involved in its
> > development. SoB chains should reflect the **real** route a patch took
> > as it was propagated to the maintainers and ultimately to Linus, with
> > the first SoB entry signalling primary authorship of a single author.
> 
> So "further SoBs follow[] the author's SoB" and "the first SoB entry
> signal[s] primary authorship".
> But at the same time "SoB chains should reflect the **real** route a
> patch took" - these rules contradict each other in our case.

Yeah, this is a unusual case.  If we wanted to be super strict, for patches written
by you without a Co-developed-by, the SoB chain should be:

  Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
  Signed-off-by: Sean Christopherson <seanjc@google.com>
  Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

but that's a bit ridiculous and probably unnecessary since my changes were little
more than code review feedback, which is why I think it's ok to just drop my SoB
for patches authored solely by you.

Co-developed-by is a slightly different case.  Because patches with multiple
authors are likely handed back and forth multiple times, as was the case here,
and because each author needs a SoB anyways, the normal rules are tweaked slightly
to require that the person submitting the patch is always last to capture that they
were the person that did the actual submission.  

There's another "When to use Acked-by:, Cc:, and Co-developed-by:" section in
submitting-patches.rst that covers this:

  Co-developed-by: states that the patch was co-created by multiple developers;
  it is used to give attribution to co-authors (in addition to the author
  attributed by the From: tag) when several people work on a single patch.  Since
  Co-developed-by: denotes authorship, every Co-developed-by: must be immediately
  followed by a Signed-off-by: of the associated co-author.  Standard sign-off
  procedure applies, i.e. the ordering of Signed-off-by: tags should reflect the
  chronological history of the patch insofar as possible, regardless of whether
  the author is attributed via From: or Co-developed-by:.  Notably, the last
  Signed-off-by: must always be that of the developer submitting the patch.
  
  Note, the From: tag is optional when the From: author is also the person (and
  email) listed in the From: line of the email header.
  
  Example of a patch submitted by the From: author::
  
          <changelog>
  
          Co-developed-by: First Co-Author <first@coauthor.example.org>
          Signed-off-by: First Co-Author <first@coauthor.example.org>
          Co-developed-by: Second Co-Author <second@coauthor.example.org>
          Signed-off-by: Second Co-Author <second@coauthor.example.org>
          Signed-off-by: From Author <from@author.example.org>
  
  Example of a patch submitted by a Co-developed-by: author::
  
          From: From Author <from@author.example.org>
  
          <changelog>
  
          Co-developed-by: Random Co-Author <random@coauthor.example.org>
          Signed-off-by: Random Co-Author <random@coauthor.example.org>
          Signed-off-by: From Author <from@author.example.org>
          Co-developed-by: Submitting Co-Author <sub@coauthor.example.org>
          Signed-off-by: Submitting Co-Author <sub@coauthor.example.org>
  
