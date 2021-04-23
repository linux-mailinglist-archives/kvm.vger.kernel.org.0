Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 257C536963D
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 17:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243055AbhDWPea (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 11:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242984AbhDWPe3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 11:34:29 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B04C061574
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 08:33:52 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id kb13-20020a17090ae7cdb02901503d67f0beso4674344pjb.0
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 08:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VYRSamfmSN5NeV2/coRcqwrjLzMH1bGIzsGw1q0g8JE=;
        b=tmy1BHDBvZFz17vMssnaQ0aCzf5m+bOpE01fTLkv60uKsXJdu+h0/i8o8tfj8RycfL
         wBzkz8EPcdCQFBl9IeQSw0AvdIMv3bSYy7VDdaHlIQJKLwASfQkclLKU4j5jblwCyfir
         mGb4c3SoSKyfiYEo9u7RSKE7GrE+BJqOFelSb/1Elpxszh7SLeWLiJL2sA/lUk2iYXhW
         Ai/QZxQ4bJ7WyLRbHmoDgkpf9kRkq6sNka9aMOwQ3DdGYlfPdxedYemtqa96yasBBkRO
         UFwNcbb3e5dZvZifhE1wc5XqSjLJ9W2mUn3D766qUFerYwQicYS4HtDVP/gCqXduEtLe
         cE1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VYRSamfmSN5NeV2/coRcqwrjLzMH1bGIzsGw1q0g8JE=;
        b=TLA+YtaCnubR/rxo029hG0pJUD3Re4MBlaT4/vob2Su5fox9Y3wzsAr2MUthhwtN2F
         K2aiLAFbPCzVZV5bfrcfTkINRD/Lxc+dm6K4m9KVelaMwwxoomKOixO1GLh6rT4Uf8hB
         btWluxV1rzUyIa/tZguOJ+3ISMMwIkFWK3YFXm8TF22hJ3f2dWKqqP7mKDs5fLxZhBMw
         KVOAuqfzl5u1u+AxQ/oRZSsUUzStQyi2bj9ooNe7yFIsq2DODNeJO2w96QzD5eDl9xv3
         OszjHJbQCVF4TLCwoHL0QEPivLsXb2fzwRW9gZ8jg7uRzSUcFZnziJSOo/82YKdj7oVf
         YxOA==
X-Gm-Message-State: AOAM531+kjd9Pe9i682/iWarc5eNNoLqt3cOGnQB9feghQVqH0uUlAte
        d9iVRcVeoKkIzeMayubtHE64+Q==
X-Google-Smtp-Source: ABdhPJwgI3xmYlqdQPtoYfcjqvmehUxDut53Kh8ms2j14Rpb53uuDkSYzWvqU8G2e79lzzqWlg6vtw==
X-Received: by 2002:a17:902:eccd:b029:ea:ed20:b646 with SMTP id a13-20020a170902eccdb02900eaed20b646mr4362458plh.4.1619192032144;
        Fri, 23 Apr 2021 08:33:52 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id l18sm7532008pjq.33.2021.04.23.08.33.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 08:33:51 -0700 (PDT)
Date:   Fri, 23 Apr 2021 15:33:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Edmondson <dme@dme.org>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] kvm: x86: Allow userspace to handle emulation
 errors
Message-ID: <YILo26WQNvZNmtX0@google.com>
References: <20210421122833.3881993-1-aaronlewis@google.com>
 <cunsg3jg2ga.fsf@dme.org>
 <CAAAPnDH1LtRDLCjxdd8hdqABSu9JfLyxN1G0Nu1COoVbHn1MLw@mail.gmail.com>
 <cunmttrftrh.fsf@dme.org>
 <CAAAPnDHsz5Yd0oa5z15z0S4vum6=mHHXDN_M5X0HeVaCrk4H0Q@mail.gmail.com>
 <cunk0oug2t3.fsf@dme.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cunk0oug2t3.fsf@dme.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 22, 2021, David Edmondson wrote:
> On Wednesday, 2021-04-21 at 12:01:21 -07, Aaron Lewis wrote:
> 
> >> >
> >> > I don't think this is a problem because the instruction bytes stream
> >> > has irrelevant bytes in it anyway.  In the test attached I verify that
> >> > it receives an flds instruction in userspace that was emulated in the
> >> > guest.  In the stream that comes through insn_size is set to 15 and
> >> > the instruction is only 2 bytes long, so the stream has irrelevant
> >> > bytes in it as far as this instruction is concerned.
> >>
> >> As an experiment I added[1] reporting of the exit reason using flag 2. On
> >> emulation failure (without the instruction bytes flag enabled), one run
> >> of QEMU reported:
> >>
> >> > KVM internal error. Suberror: 1
> >> > extra data[0]: 2
> >> > extra data[1]: 4
> >> > extra data[2]: 0
> >> > extra data[3]: 31
> >> > emulation failure
> >>
> >> data[1] and data[2] are not indicated as valid, but it seems unfortunate
> >> that I got (not really random) garbage there.
> >>
> >> Admittedly, with only your patches applied ndata will never skip past
> >> any bytes, as there is only one flag. As soon as I add another, is it my
> >> job to zero out those unused bytes? Maybe we should be clearing all of
> >> the payload at the top of prepare_emulation_failure_exit().
> >>
> >
> > Clearing the bytes at the top of prepare_emulation_failure_exit()
> > sounds good to me.  That will keep the data more deterministic.
> > Though, I will say that I don't think that is required.  If the first
> > flag isn't set the data shouldn't be read, no?
> 
> Agreed. As Jim indicated in his other reply, there should be no new data
> leaked by not zeroing the bytes.
> 
> For now at least, this is not a performance critical path, so clearing
> the payload doesn't seem too onerous.

I feel quite strongly that KVM should _not_ touch the unused bytes.  As Jim
pointed out, a stream of 0x0 0x0 0x0 ... is not benign, it will decode to one or
more ADD instructions.  Arguably 0x90, 0xcc, or an undending stream of prefixes
would be more appropriate so that it's less likely for userspace to decode a
bogus instruction.

I don't see any reason why unused insn bytes should be treated any differently
than unused mmio.data[], or unused internal.data[], etc... 

IMO, the better option is to do nothing and let userspace initialize vcpu->run
before KVM_RUN if they want to avoid consuming stale data.  
