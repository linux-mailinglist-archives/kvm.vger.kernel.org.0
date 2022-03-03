Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C46FF4CC9CC
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 00:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbiCCXHw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 18:07:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbiCCXHv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 18:07:51 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B191A398
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 15:07:03 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id em10-20020a17090b014a00b001bc3071f921so9097274pjb.5
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 15:07:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wsytA5en+ItUqruLb4F/YGyRxRL/LbEBBpbjnswyCM8=;
        b=EOrYv2zrhk9TWezM970VEXgU/SbfP82z4FbUmK+LjtSUU9pY+C+Wk+f/zBqYlSXA/a
         Ww4tMAL8LjMgy1f4nmU4kUSwmRL019Y4izs5Fmy/y53ymi/qopXdHs+h1vUSXv8omro2
         ieXiH/PlD215WhzH562QpXM8rNA40+XvObuhuAxeOpwsw73HDBcE1idHi3mvm4pJcOD5
         2Fw3IY0MLMmMTG7SbfX4bqXvYSQpSAUE58VlDRA3N4wZvixHXZ7ZwNU77D9PUjr7j5CA
         uhB0ioX7fVTwQix49pvqHEGzC9JZt99Sz6mPcTUxSwWN2xM6KcIq9TiVWC8s+Ko25WyL
         4zBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wsytA5en+ItUqruLb4F/YGyRxRL/LbEBBpbjnswyCM8=;
        b=DTymfvX9247Bvd3FAjCTxuFaf7Em0EYMjPXca3dzWlkjHGCzxdAji9F91JD777Xnqo
         D5XD+HU0GaD60oR4D4urlKsR6y2djxigldOYiiDcn93po1XvM5V5M1BCLFzdGDd49fSI
         ZMDXnzj9qrNj/gkIu/w6QN8o5bRAyN0DQoCYKAFFvwtV8aVC4yG0laABXVRrXAKFo9QX
         bO6AAlVynA8qSxr88UzL3Tp/GNZqmmjbIgjd8hVSJWyd46OJVQ5bq48ayVU7M/UN08ID
         eXLBEHjpNnJV3Fs/qfQcnDWJkYjIXXI5cOpwTuV1sA9X9WvOPl8DjDcJTNKH2awF1q18
         RJnw==
X-Gm-Message-State: AOAM533WyFHT0sHhi+CO3TRz9UN0JNodH6sjlIZ8JhPq71Ck+xTcj8zL
        iXmN6HFjDbpNQ5On3HWaWTUVBw==
X-Google-Smtp-Source: ABdhPJwo9c8LbCkavdKfpoadHPuUcYrp0SSG4dnjNHU5gp2pCtsaa3ksUhu2md7xyaz1S92gcf2Hxw==
X-Received: by 2002:a17:903:41d0:b0:151:8b0c:5dd1 with SMTP id u16-20020a17090341d000b001518b0c5dd1mr14207833ple.160.1646348822205;
        Thu, 03 Mar 2022 15:07:02 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m20-20020a634c54000000b003739af127c9sm2942153pgl.70.2022.03.03.15.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 15:07:01 -0800 (PST)
Date:   Thu, 3 Mar 2022 23:06:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v3 15/28] KVM: x86/mmu: Add dedicated helper to zap TDP
 MMU root shadow page
Message-ID: <YiFKEQPLzlcA403J@google.com>
References: <20220226001546.360188-1-seanjc@google.com>
 <20220226001546.360188-16-seanjc@google.com>
 <YiEw7z9TCQJl+udS@google.com>
 <YiEyEWDkNxNIAn/z@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YiEyEWDkNxNIAn/z@google.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 03, 2022, Mingwei Zhang wrote:
> On Thu, Mar 03, 2022, Mingwei Zhang wrote:
> > > +	/*
> > > +	 * No need to try to step down in the iterator when zapping an entire
> > > +	 * root, zapping an upper-level SPTE will recurse on its children.
> > > +	 */
> > > +	for_each_tdp_pte_min_level(iter, root, root->role.level, start, end) {
> > > +retry:
> > > +		/*
> > > +		 * Yielding isn't allowed when zapping an unreachable root as
> > > +		 * the root won't be processed by mmu_notifier callbacks.  When
> > > +		 * handling an unmap/release mmu_notifier command, KVM must
> > > +		 * drop all references to relevant pages prior to completing
> > > +		 * the callback.  Dropping mmu_lock can result in zapping SPTEs
> > > +		 * for an unreachable root after a relevant callback completes,
> > > +		 * which leads to use-after-free as zapping a SPTE triggers
> > > +		 * "writeback" of dirty/accessed bits to the SPTE's associated
> > > +		 * struct page.
> > > +		 */
> > 
> > I have a quick question here: when the roots are unreachable, we can't
> > yield, understand that after reading the comments. However, what if
> > there are too many SPTEs that need to be zapped that requires yielding.
> > In this case, I guess we will have a RCU warning, which is unavoidable,
> > right?
> 
> I will take that back. I think the subsequent patches solve the problem
> using two passes.

Yes, but it's worth noting that the yielding problem is also solved by keeping
roots reachable while they're being zapped (also done in later patches).  That
way if a mmu_notifier event comes along, it can guarantee the SPTEs it cares about
are zapped (and their metadata flushed) even if the MMU root is no longer usable
by a vCPU.
