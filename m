Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F082332F38
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 20:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbhCITnM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 14:43:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbhCITnE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 14:43:04 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C0BC06175F
        for <kvm@vger.kernel.org>; Tue,  9 Mar 2021 11:43:04 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id n10so9498262pgl.10
        for <kvm@vger.kernel.org>; Tue, 09 Mar 2021 11:43:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nrSjbcfbtpDu99fWTpmyTiTS4z7P8iLrCevZq+OwJDk=;
        b=fxZkdSwllM3KcD1tprgJ8Qwwl3PI5A+cU8oORbvgRMWthQA0elQUWYTsTefxo87ZMH
         csmfaAMMCvh7WBAPvVauUmDmZGZj1yKsoDGNatLLTaHDvpE93tQVrzeqnmrkE8dw+19g
         H4NzNxqJTkhxUUKb6moJUDCHrSdkD3Mn2YC8vv8/ax319/eIZFWqVitKiicr3Q9vwnWL
         C8iZA/cO52ZIoF+Y0a8FtA3ipQmjOmywD6Dl4b4oDoU8/FL4gYiEU9PEuhi7cG6ryrpP
         LpmHctDWZMDMaQIz2OpaVQeOHmmf0/qTOSIh/dx5RZKdqq6dBJPmVN2QpiTqphqK9QNM
         SSGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nrSjbcfbtpDu99fWTpmyTiTS4z7P8iLrCevZq+OwJDk=;
        b=QUSMlGksfOfcA8gdqD/svJH+PrV4Nao5MwLY9OzWYoK2AYGZc5C6Wi1u/EQrgPCjKd
         pw3AvCwgA9SD+el66v+u6+X1OYhbkVvSv5TDjs5tIeRq1pVhXlCG/J916PvotYVDpfZE
         sxn4d8hPUs79S3JLJoQ4Sg9KBO2AFO8JYexKYMffDguKclDPntLzqp3f3N/UhEU4RohK
         SZ6h9B3lKHTm7WZQ9iTpHC/OrrEsUQpTgF38wAXJQNDIoYgeKnfjMHbdPiOu4LPRHrqU
         6GjYwiv2PswlYmk2Sb0mUTu/a235X0W6BZeaF/kcll2S6QeLcadazBLVTJsc3BaJj2t9
         /2dA==
X-Gm-Message-State: AOAM533b3Rw5jgyf1dlCzjDzVH7U99CvHRoqpddTKJq6aw8CP6pN6Wxl
        DEluXdAyxH/PpQJXc8nvB/rpsw==
X-Google-Smtp-Source: ABdhPJxG0mCqsNk6TCaFJMi2aql7w63MaxtH/VOu8x+69eBxPHe97w/5N8Km/Rme/8HzauKwfNe/gw==
X-Received: by 2002:a62:3085:0:b029:1ec:a6b8:6dd2 with SMTP id w127-20020a6230850000b02901eca6b86dd2mr26760622pfw.7.1615318983949;
        Tue, 09 Mar 2021 11:43:03 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e4dd:6c31:9463:f8da])
        by smtp.gmail.com with ESMTPSA id 25sm14296910pfh.199.2021.03.09.11.43.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 11:43:03 -0800 (PST)
Date:   Tue, 9 Mar 2021 11:42:56 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Steve Rutherford <srutherford@google.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <ashish.kalra@amd.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "venu.busireddy@oracle.com" <venu.busireddy@oracle.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v10 10/16] KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIST
 ioctl
Message-ID: <YEfPwD6/XiTp7v0y@google.com>
References: <20210224175122.GA19661@ashkalra_ubuntu_server>
 <YDaZacLqNQ4nK/Ex@google.com>
 <20210225202008.GA5208@ashkalra_ubuntu_server>
 <CABayD+cn5e3PR6NtSWLeM_qxs6hKWtjEx=aeKpy=WC2dzPdRLw@mail.gmail.com>
 <20210226140432.GB5950@ashkalra_ubuntu_server>
 <YDkzibkC7tAYbfFQ@google.com>
 <20210308104014.GA5333@ashkalra_ubuntu_server>
 <YEaAXXGZH0uSMA3v@google.com>
 <bdf0767f-c2c4-5863-fd0d-352a3f68f7f9@amd.com>
 <CABayD+ftv5DNdXj-Bs8MXGeFNKx7-aTt99fPuD2R6w1mJ2u8TQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABayD+ftv5DNdXj-Bs8MXGeFNKx7-aTt99fPuD2R6w1mJ2u8TQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 08, 2021, Steve Rutherford wrote:
> On Mon, Mar 8, 2021 at 1:11 PM Brijesh Singh <brijesh.singh@amd.com> wrote:
> > On 3/8/21 1:51 PM, Sean Christopherson wrote:
> > > If the guest does the hypercall after writing the page, then the guest is hosed
> > > if it gets migrated while writing the page (scenario #1):
> > >
> > >   vCPU                 Userspace
> > >   zero_bytes[0:N]
> > >                        <transfers written bytes as private instead of shared>
> > >                      <migrates vCPU>
> > >   zero_bytes[N+1:4095]
> > >   set_shared (dest)
> > >   kaboom!
> >
> >
> > Maybe I am missing something, this is not any different from a normal
> > operation inside a guest. Making a page shared/private in the page table
> > does not update the content of the page itself. In your above case, I
> > assume zero_bytes[N+1:4095] are written by the destination VM. The
> > memory region was private in the source VM page table, so, those writes
> > will be performed encrypted. The destination VM later changed the memory
> > to shared, but nobody wrote to the memory after it has been transitioned
> > to the  shared, so a reader of the memory should get ciphertext and
> > unless there was a write after the set_shared (dest).

Sorry, that wasn't clear, there's an implied page table update to make the page
shared before zero_bytes.

> > > If userspace does GET_DIRTY after GET_LIST, then the host would transfer bad
> > > data by consuming a stale list (scenario #2):
> > >
> > >   vCPU               Userspace
> > >                      get_list (from KVM or internally)
> > >   set_shared (src)
> > >   zero_page (src)
> > >                      get_dirty
> > >                      <transfers private data instead of shared>
> > >                      <migrates vCPU>
> > >   kaboom!
> >
> >
> > I don't remember how things are done in recent Ashish Qemu/KVM patches
> > but in previous series, the get_dirty() happens before the querying the
> > encrypted state. There was some logic in VMM to resync the encrypted
> > bitmap during the final migration stage and perform any additional data
> > transfer since last sync.

It's likely that Ashish's patches did the correct thing, I just wanted to point
out that both host and guest need to do everything in a very specific order.

> > > If both guest and host order things to avoid #1 and #2, the host can still
> > > migrate the wrong data (scenario #3):
> > >
> > >   vCPU               Userspace
> > >   set_private
> > >   zero_bytes[0:4096]
> > >                      get_dirty
> > >   set_shared (src)
> > >                      get_list
> > >                      <transfers as shared instead of private>
> > >                    <migrates vCPU>
> > >   set_private (dest)
> > >   kaboom!
> >
> >
> > Since there was no write to the memory after the set_shared (src), so
> > the content of the page should not have changed. After the set_private
> > (dest), the caller should be seeing the same content written by the
> > zero_bytes[0:4096]
>
> I think Sean was going for the situation where the VM has moved to the
> destination, which would have changed the VEK. That way the guest
> would be decrypting the old ciphertext with the new (wrong) key.

I think that's what I was saying?

I was pointing out that the userspace VMM would see the page as "shared" and so
read the guest memory directly instead of routing it through the PSP.

Anyways, my intent wasn't to point out a known issue anywhere.  I was working
through how GET_LIST would interact with GET_DIRTY_LOG to convince myself that
the various flows were bombproof.  I wanted to record those thoughts so that I
can remind myself of the requirements when I inevitably forget them in the future.

> > > Scenario #3 is unlikely, but plausible, e.g. if the guest bails from its
> > > conversion flow for whatever reason, after making the initial hypercall.  Maybe
> > > it goes without saying, but to address #3, the guest must consider existing data
> > > as lost the instant it tells the host the page has been converted to a different
> > > type.
> > >
> > >> For the above reason if we do in-kernel hypercall handling for page
> > >> encryption status (which we probably won't require for SEV-SNP &
> > >> correspondingly there will be no hypercall exiting),
> > > As above, that doesn't preclude KVM from exiting to userspace on conversion.
> > >
> > >> then we can implement a standard GET/SET ioctl interface to get/set the guest
> > >> page encryption status for userspace, which will work across SEV, SEV-ES and
> > >> SEV-SNP.
