Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10C5667837A
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 18:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232489AbjAWRlk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 12:41:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232506AbjAWRli (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 12:41:38 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5661D29E00
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 09:41:37 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id z4-20020a17090a170400b00226d331390cso11669986pjd.5
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 09:41:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LbwTDYMRu9gYgFEmzOB7a5k3KTI/CGWeiffYSoSJM/8=;
        b=bSR8x1dp1OJJEGgBKEo94lMiIDjFnwQ+h+QM4TlIxZ70pvRpwjY/RSOYnGLypBXx1R
         L+slvx4Em3isvfG08lLRztf9zxqsggUrDdn66wTfYwdx1EqM0p7vaX3Gqg7Na6BhdikG
         HnxE0vZF+pH69/nV6khq28hiuYAWwYpf2jInqlXR8eLebw2CmBrZ1+6B8HOxzMlwG0lw
         cmJCfZ7eEmc5YtNMV03pc9nnpxOHsrtdPMf41+eMiF3Y0ruMr5pnfX2nyYH1zB/iMV4w
         e0jm5ZHVwWPMJy93MpwgUBmNSNTxUP+AByfPi1Dh72RaXon0YrxO8CLbeGOtauHPul4t
         PIrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LbwTDYMRu9gYgFEmzOB7a5k3KTI/CGWeiffYSoSJM/8=;
        b=lUyVDXUBulDr4MjUhCQgZMzrMTGSVEEwcsafu+7uq+VY3cV7hRan219EyJ/Javbz+/
         fHxBmKBpbF7l4Nhw4I23JsHK47IaELIQiyb1HOl4S3kpTmdRqfR3K88Rd9fgdkIV6OrN
         bSb9HHY4VUJePBwLV7pWiq9reElHUfZXFIcUnpwjXoLM/u8w2pLPVnJWF3eZBId3LSEp
         b0Q1Z4GmylP5TmNaRAoofOLQxbVmSK67O1+e6pyTQPxOGS1dMStvY8i8rXCYnWJDJlnG
         SI9XGu3drfwNjgrRAUKM4preJ2LRhbEKk86Ypa1IK38s9IjaoPJwe4LIePEIDQaLWaNO
         FPcw==
X-Gm-Message-State: AFqh2kp8DRrlIThUVdhMLw5xdGdwI0mlfO89vdLkkug6yGhS/DSk8uPt
        pgaMQXIe4hHGV2g3diPwL3nMqw==
X-Google-Smtp-Source: AMrXdXs8GDn7un6vNlXLIGv6kMT+p8VF53e6suDda8FNqVIkMyGAuzLHIJZcFHNo2UvDxRwY25qQsQ==
X-Received: by 2002:a17:902:b111:b0:191:1543:6b2f with SMTP id q17-20020a170902b11100b0019115436b2fmr587472plr.3.1674495696622;
        Mon, 23 Jan 2023 09:41:36 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c4-20020a170903234400b0019338ecad52sm27845290plh.190.2023.01.23.09.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 09:41:36 -0800 (PST)
Date:   Mon, 23 Jan 2023 17:41:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "dmatlack@google.com" <dmatlack@google.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
Message-ID: <Y87GzHrx8vxZLBEJ@google.com>
References: <Y8cMnjHFNIFaoX27@google.com>
 <eadc4a4e37ea0b04b8348395244b792bd34a762d.camel@intel.com>
 <Y8ljwsrrBBdh1aYw@google.com>
 <02b0e551647beed9ec3a2fefd3b659eb52c4846c.camel@intel.com>
 <Y8m34OEVBfL7Q4Ns@google.com>
 <1c71eda35e03372f29162c6a5286f5b4d1e1d7e1.camel@intel.com>
 <Y8ndcGHUHQjHfbF9@google.com>
 <CALzav=d4vwHTnXP8wetA_Hqd3Tzc_NLp=3M-akwNSN1-ToL+Eg@mail.gmail.com>
 <Y8st2PjGDQ+Q0LlW@google.com>
 <3951e178bc38191074f5cccadc442212ff15c737.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3951e178bc38191074f5cccadc442212ff15c737.camel@intel.com>
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

On Mon, Jan 23, 2023, Huang, Kai wrote:
> > 
> > 
> > Intel folks,
> > 
> > Do you happen to know exactly what scenario prompted adding the freeze+unfreeze
> > code?  Is there something I'm forgetting/missing, or is it possible we can go
> > with a simpler implementation?
> 
> It's documented in the "TDX TDP MMU design doc" patch:
> 
> +TDX concurrent populating
> +-------------------------
> ......
> +
> +Without freezing the entry, the following race can happen.  Suppose two vcpus
> +are faulting on the same GPA and the 2M and 4K level entries aren't populated
> +yet.
> +
> +* vcpu 1: update 2M level EPT entry
> +* vcpu 2: update 4K level EPT entry
> +* vcpu 2: TDX SEAMCALL to update 4K secure EPT entry => error
> +* vcpu 1: TDX SEAMCALL to update 2M secure EPT entry

Ooh, the problem isn't that two SEAMCALLs to the same entry get out of order, it's
that SEAMCALLs operating on child entries can race ahead of the parent.  Hrm.

TDX also has the annoying-but-understandable restriction that leafs need to be
removed before parents.  A not-yet-relevant complication on that front is that the
TDP MMU's behavior of recursively removing children means we also have to worry
about PRESENT => !PRESENT transitions, e.g. zapping a child because the parent is
being removed can race with a different vCPU try to populate the child (because
the vCPU handling a page fault could have seen the PRESENT parent).

I think there's an opportunity and motivation to improve the TDP MMU as a whole on
this front though.  Rather than recursively zap children in handle_removed_pt(),
we can use the RCU callback to queue the page table for removal.  Setting the parent
(target page table) !PRESENT and flushing the TLBs ensures that all children are
unreachable, i.e. KVM doesn't need to immediately set children !PRESENT.  Unlike
the shadow MMU, which maintains a hash table of shadow pages, once a parent page
table is removed from the TDP MMU, its children are unreachabled.

The RCU callback must run in near-constant time, but that's easy to solve as we
already have a workqueue for zapping page tables, i.e. the RCU callback can simply
add the target page to the zap workqueue.  That would also allow for a (very minor)
simplification of other TDP MMU code: tdp_mmu_zap_root() wouldn't needed to zap in
two passes since zapping children of the top-level SPTEs would be deferred to the
workqueue.

Back to TDX, to play nice with the restriction that parents are removed only after
children are removed, I believe KVM can use TDH.MEM.RANGE.BLOCK to make the parent
!PRESENT.  That will effectively prune the S-EPT entry and all its children, and
the RCU callback will again ensure all in-flight SEAMCALLs for the children complete
before KVM actually tries to zap the children.

And if we rework zapping page tables, I suspect we can also address David's concern
(and my not-yet-voiced concern) about polluting the TDP MMU code with logic that is
necessary only for S-EPT (freezing SPTEs before populating them).  Rather than update
S-EPT _after_ the TDP MMU SPTE, do the S-EPT update first, i.e. invoke the KVM TDX
hook before try_cmpxchg64() (or maybe instead of?).  That way KVM TDX can freeze the
to-be-installed SPTE without common TDP MMU needing to be aware of the change.

> ( I guess such material will be more useful in the comment.  And perhaps we can
> get rid of the "TDX TDP MMU design doc" patch in this series at least for now as
> probably nobody will look at it :-) )

Please keep the design doc, I'll definitely read it.  I'm just chasing too many
things at the moment and haven't given the TDX series a proper review, i.e. haven't
even glanced through all of the patches or even the shortlog.
