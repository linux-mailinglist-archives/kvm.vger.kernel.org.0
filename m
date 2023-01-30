Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69DF8681E62
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 23:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjA3Wtp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 17:49:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjA3Wto (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 17:49:44 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF05E2ED4C
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 14:49:43 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id v23so13247473plo.1
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 14:49:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F9HZhx2ICs/dQrVRuXY4PPD7+NhQ8AWXpwIlEW5fxyA=;
        b=CqFUFS+zE+qJZgv18fS7BhtDTrbDaKNvFTUke3dA9MMkx5XOSdUIiMERrs9D41ASrJ
         pQR9ftvS61GwpDSrw2DoXyzxDLp97csKK1yoY+UmxGnBeCx+RVF9imK1BhzMBJ/o8V8D
         UnIqoCSfLdY8nxH3GchTWx6+cwZlHTtuKVIGqtwrDyjW5hBoHzvdfui5JQxRvhQJXHbT
         wRHPDEVl0uKVDeRCfk4n0TIF4TPcqwGEhpos+dx+iWrijT4M2P/2SmVzyJG29WhdwM2h
         hDBRdpfwG4PP+dQ2FbeaIGRABOKkQP/fQadtTretG1ME9A/dJFjS5ZjwG1mJpQO86yAD
         rzgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F9HZhx2ICs/dQrVRuXY4PPD7+NhQ8AWXpwIlEW5fxyA=;
        b=kyFCvzAmj+gU2vvLhAomYLP76+TlGQXE1P3xZKZ78KiTKJMIY09fLfN3Jf+leTMLt5
         /6TqWcRKwr4dJnpsoCfUDsSVOtmw2iJUQAVZaFRKBJrBszmGBzJnq9nNsWKaNurEgj9B
         rtfEAGBS5Etv4zfuSDW+bMDTLpDgHva4dimyfKzwAUkz3mBFTgB3Sk5i8esoq59efzX/
         8GpdeI2IKHdGMhPJKyrSxAsDn/0BV0dl9+mJy/meeRi7nV2CDy5JCyqx1Nptou+XOMQg
         /EOm0N8TCe25LqIWX4cpWtPGBSl5llTAQffRDuAWlXi2nhZWoSbGnvCoXYcDh7DeP28z
         FtSA==
X-Gm-Message-State: AO0yUKWu6bitD6aJd+HKD6r1QDfsSn0SHS5Pc6rJEFDtLBiAv41O8LcX
        rHpelas34thp3t6a9eTvlY4NvA==
X-Google-Smtp-Source: AK7set89yZ51T89ghtmsMbgYLIHswEsQ/wW0614R7M4IJVc2lCeI/VRKY26Kq7W0y/qPnImG0Pw9zA==
X-Received: by 2002:a17:902:d70a:b0:193:256d:8afe with SMTP id w10-20020a170902d70a00b00193256d8afemr984510ply.2.1675118982990;
        Mon, 30 Jan 2023 14:49:42 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x15-20020a170902ec8f00b001968b529c98sm1977389plg.128.2023.01.30.14.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 14:49:42 -0800 (PST)
Date:   Mon, 30 Jan 2023 22:49:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch] KVM: x86/mmu: Make optimized __handle_changed_spte() for
 clear dirty log
Message-ID: <Y9hJg9hDQFD3X720@google.com>
References: <20230125213857.824959-1-vipinsh@google.com>
 <Y9GmiyRQ6sULCjEG@google.com>
 <CANgfPd9T7jdh1Cjjo4y6DcxC2poTaGhQ7wNLf6OgGtStg-yKJg@mail.gmail.com>
 <Y9HcHRBShQgjxsQb@google.com>
 <CAHVum0cd=YKvEKi7xZZHCTBn9XAxiax92JHV_W47R8rYvvnF-g@mail.gmail.com>
 <Y9gH3OHA4ftegU7X@google.com>
 <CAHVum0eReWgo_3yWxdtbyFGxeTnWUiEn9uVu0W5XX3KfHAgikw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHVum0eReWgo_3yWxdtbyFGxeTnWUiEn9uVu0W5XX3KfHAgikw@mail.gmail.com>
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

On Mon, Jan 30, 2023, Vipin Sharma wrote:
> On Mon, Jan 30, 2023 at 10:09 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Sat, Jan 28, 2023, Vipin Sharma wrote:
> > > On Wed, Jan 25, 2023 at 5:49 PM Sean Christopherson <seanjc@google.com> wrote:
> > > > -static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> > > > -                               u64 old_spte, u64 new_spte, int level,
> > > > -                               bool shared)
> > > > -{
> > > > -       __handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level,
> > > > -                             shared);
> > > >         handle_changed_spte_acc_track(old_spte, new_spte, level);
> > > > -       handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte,
> > > > -                                     new_spte, level);
> > > > +
> > > > +       /* COMMENT GOES HERE. */
> > >
> > > Current "shared" callers are not making a page dirty. If a new
> > > "shared" caller makes a page dirty then make sure
> > > handle_changed_spte_dirty_log is called.
> > >
> > > How is this?
> >
> > I was hoping for a more definitive "rule" than "KVM doesn't currently do XYZ".
> >
> > > > +       if (!shared)
> > > > +               handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte,
> > > > +                                             new_spte, level);
> > > >  }
> > > >
> 
> What if implementation is changed a little more? I can think of two options:
> 
> Option 1:
> Remove handle_changed_spte_dirty_log() and let the callers handle
> mark_page_dirty_in_slot(). Similar to how fast page faults do this.
> This will get rid of the "shared" variable and defining its rules for
> the shared and nonshared flow.
> 
> Option 2:
> Changing meaning of this variable from "shared" to something like
> "handle_dirty_log"
> Callers will know if they want dirty log to be handled or not.
> 
> I am preferring option 1.

Sorry, what I meant by "definitive rule" was an explanation of why KVM doesn't
need to do dirty log tracking for tdp_mmu_set_spte_atomic().

Figured things out after a bit o' archaeology.  Commit bcc4f2bc5026 ("KVM: MMU:
mark page dirty in make_spte") shifted the dirtying of the memslot to make_spte(),
and then commit 6ccf44388206 ("KVM: MMU: unify tdp_mmu_map_set_spte_atomic and
tdp_mmu_set_spte_atomic_no_dirty_log") covered up the crime.

Egad!  I believe that means handle_changed_spte_dirty_log() is dead code for all
intents and purposes, as there is no path that creates a WRITABLE 4KiB SPTE without
bouncing through make_spte().  set_spte_gfn() => kvm_mmu_changed_pte_notifier_make_spte()
only creates !WRITABLE SPTEs, ignoring for the moment that that's currently dead
code too (see commit c13fda237f08 ("KVM: Assert that notifier count is elevated in
.change_pte()")).

So I _think_ we can do option #1 simply by deleting code.
