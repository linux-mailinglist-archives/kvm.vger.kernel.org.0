Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 515E9644ABD
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 19:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiLFSBG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 13:01:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiLFSBD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 13:01:03 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8CAA37FBA
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 10:00:57 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id h33so14039823pgm.9
        for <kvm@vger.kernel.org>; Tue, 06 Dec 2022 10:00:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IZ/eewSvSWgRvr6BfZF0Ink/Z3lXafgahPjrIsbVO+Q=;
        b=p85BHNs950sX6+YdR/La3bRRURA5Iyad7gJsVNcTC8Sbk+t7TM0n4A5wqFUDrb0J6f
         /+likKUnoCGnHd2e+jdC1CwShBvoYZHib+RPCaAbfYqQFG52EACFXxvD9DYMXO+PEYl+
         qwbqcjtKYsJxS8/I7wW7xnVPOt1zRzkc56jDTXIIAxNmUEyeAa+/1AppO5vfWNEUyFGw
         dJHifqN9g8OH8wzSVQ+WTMB6azYE08A6x/jubP+EiIxvUxNCNZRHXvhwhmPBSJGkocuZ
         n/fDuAJER1/AJr4Z/DDGWOvFemUvWzGKqhRzAHgv9QPr2SjdLwEW1ufcjaCqR61Cj2+h
         TrqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IZ/eewSvSWgRvr6BfZF0Ink/Z3lXafgahPjrIsbVO+Q=;
        b=FKB680BLsLiKYS6DaafMafmYJ3taBRVJ33ce0wayJu7A1n9mApd+pF12vzBpzT9RkR
         OJSejvRJbI2Q9ZlHwGIGcpzsPqS41HXIXbyRAkG9ZUelJ91HM6yfyfKtWbn9sV8Mhls/
         yKLbFtD++OIeL93q1cCt068AdD0sjC4vXAQ1/6W4Z+E8fA2IPlYMG0bU+TdYhN8cEDD+
         nSJXnGvfrR/J+YHlZFPtcJI7lTSlY+rTlCfO2P2N5FomVFYgfcCckZbMiNWvoRbekN3T
         gR4BB0Sr8a+BENGS4eQFKhIgZzd5aTtl60Otr0GtIgqmx2lehU+io1q8TiaiI3/NnmT4
         /LtQ==
X-Gm-Message-State: ANoB5pkZ11EgJyf/5U0k1YUWZJJE2a1m2MbIKYJB9uUjw4sjidpd1k6T
        ndCJMM92F4k0CtBuzSEP1j7X1g==
X-Google-Smtp-Source: AA0mqf7DwpncQilHWw9mPUFGCznhUcmoxZzkWzvwjfoeUCID64NRYsXY8viyrYf11aEBw+RQWiYnsQ==
X-Received: by 2002:a63:4043:0:b0:470:2ecd:333e with SMTP id n64-20020a634043000000b004702ecd333emr80514782pga.596.1670349657037;
        Tue, 06 Dec 2022 10:00:57 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z18-20020a170903019200b00177f4ef7970sm13016894plg.11.2022.12.06.10.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 10:00:56 -0800 (PST)
Date:   Tue, 6 Dec 2022 18:00:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     James Houghton <jthoughton@google.com>
Cc:     David Matlack <dmatlack@google.com>, Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Linux MM <linux-mm@kvack.org>, kvm <kvm@vger.kernel.org>,
        chao.p.peng@linux.intel.com
Subject: Re: [RFC] Improving userfaultfd scalability for live migration
Message-ID: <Y4+DVdq1Pj3k4Nyz@google.com>
References: <CADrL8HVDB3u2EOhXHCrAgJNLwHkj2Lka1B_kkNb0dNwiWiAN_Q@mail.gmail.com>
 <Y4qgampvx4lrHDXt@google.com>
 <Y44NylxprhPn6AoN@x1n>
 <CALzav=d=N7teRvjQZ1p0fs6i9hjmH7eVppJLMh_Go4TteQqqwg@mail.gmail.com>
 <Y442dPwu2L6g8zAo@google.com>
 <CADrL8HV_8=ssHSumpQX5bVm2h2J01swdB=+at8=xLr+KtW79MQ@mail.gmail.com>
 <Y46VgQRU+do50iuv@google.com>
 <CADrL8HVM1poR5EYCsghhMMoN2U+FYT6yZr_5hZ8pLZTXpLnu8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADrL8HVM1poR5EYCsghhMMoN2U+FYT6yZr_5hZ8pLZTXpLnu8Q@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 06, 2022, James Houghton wrote:
> On Mon, Dec 5, 2022 at 8:06 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Mon, Dec 05, 2022, James Houghton wrote:
> > > On Mon, Dec 5, 2022 at 1:20 PM Sean Christopherson <seanjc@google.com> wrote:
> > > >
> > > > On Mon, Dec 05, 2022, David Matlack wrote:
> > > > > On Mon, Dec 5, 2022 at 7:30 AM Peter Xu <peterx@redhat.com> wrote:
> > > > > > ...
> > > > > > I'll have a closer read on the nested part, but note that this path already
> > > > > > has the mmap lock then it invalidates the goal if we want to avoid taking
> > > > > > it from the first place, or maybe we don't care?
> > >
> > > Not taking the mmap lock would be helpful, but we still have to take
> > > it in UFFDIO_CONTINUE, so it's ok if we have to still take it here.
> >
> > IIUC, Peter is suggesting that the kernel not even get to the point where UFFD
> > is involved.  The "fault" would get propagated to userspace by KVM, userspace
> > fixes the fault (gets the page from the source, does MADV_POPULATE_WRITE), and
> > resumes the vCPU.
> 
> If we haven't UFFDIO_CONTINUE'd some address range yet,
> MADV_POPULATE_WRITE for that range will drop into handle_userfault and
> go to sleep. Not good!

Ah, right, userspace would still need to register UFFD for the region to handle
non-KVM (or incompatible KVM) accesses and could loop back on itself.

> So, going with the no-slow-GUP approach, resolving faults is done like this:
> - If we haven't UFFDIO_CONTINUE'd yet, do that now and restart
> KVM_RUN. The PTEs will be none/blank right now. This is the common
> case.
> - If we have UFFDIO_CONTINUE'd already, if we were to do it again, we
> would get EEXIST. (In this case, we probably have some type of swap
> entry in the page tables.) We have to change the page tables to make
> fast GUP succeed now *without* using UFFDIO_CONTINUE now.
> MADV_POPULATE_WRITE seems to be the right tool for the job. This case
> happens if the kernel has swapped the memory out, is migrating it, has
> poisoned it, etc. If MADV_POPULATE_WRITE fails, we probably need to
> crash or inject a memory error.
> 
> So with this approach, we never need to take the mmap_lock for reading
> in hva_to_pfn, but we still need to take it in UFFDIO_CONTINUE.
> Without removing the mmap_lock from *both*, we don't gain much.
> 
> So if we disregard this tiny mmap_lock benefit, the other approach
> (the PF_NO_UFFD_WAIT approach) seems better.

Can you elaborate on what makes it better?  Or maybe generate a list of pros and
cons?  I can think of (dis)advantages for both approaches, but I haven't identified
anything that would be a blocking issue for either approach.  Doesn't mean there
isn't one or more blocking issues, just that I haven't thought of any :-)

> When KVM_RUN exits:
> - If we haven't UFFDIO_CONTINUE'd yet, do that now and restart KVM_RUN.
> - If we have, then something bad has happened. Slow GUP already ran
> and failed, so we need to treat this in the same way we treat a
> MADV_POPULATE_WRITE failure above: userspace might just want to crash
> (or inject a memory error or something).
> 
> - James
