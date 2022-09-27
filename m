Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5293D5EC9CF
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 18:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbiI0QoU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 12:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbiI0QoR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 12:44:17 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65CB01E05D3
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 09:44:15 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id u59-20020a17090a51c100b00205d3c44162so2912618pjh.2
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 09:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=hka2MB6GtBxZvbqko4sxk5z5NDTLJ3qOesEZCD0X7vU=;
        b=i/cUOlzvOFqjpGlqE7Jt5HlWISkyhBpSqtHRYPwIs2x/jE14c88WOLIDeVswI5sXGi
         /JZEoefvgVUIUeEmIgtO345p6YNqrwTSqHX1ME9QhHmNciQix8sRA9s3FCuUhDawbhh8
         4EspsgU1Z30HYK8eA575FPhVusVE7l+aj5FGoGsPLxSFF9GSmvIlt+pIK7FI/YInT1nT
         CKxSDbXfHgxDKQmQarcXrnT+OufYvQFXHZ52c1Zf8qINJbeZtGzQhsJAPdd9MY16bagL
         Gyw9A2mOz0JDIEOkepz+uaJEDHNgCbyV474fp0QClmBSRxtevHIoZQV7LlPiVYK1eqZV
         YOKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=hka2MB6GtBxZvbqko4sxk5z5NDTLJ3qOesEZCD0X7vU=;
        b=fJRalAGHdLteY44zmxPy7BnsJl7bkh3IaGAg+Nylnk+r4HeXv8XN6BSTtMTh2Vw+vz
         ygY0Xmm8+rwVo5WSFPMY/DWOrpIAhC9lZ3F4PovwgwTQJbip0JG7Qy/mRU7OB3/oC1En
         CC7qPIISXJFSuadVl9n8YNNk2MpwgFFoySzQedWqhh1CWpc/YnxucKLGwBYWHGQb7xXp
         qd4CyF+5J3rU5quUlom0KRu5IaTlAlg0iskUuuPt3AFgQ2mpYEFkayU5YI+4mEN+Gq2q
         E870HBMMv1zgngaJSt/mX5e+3eyL+gQpw1Q6jw3FEXOcgUOm8Mg2G5FMxcI02ptSmkQp
         pVxQ==
X-Gm-Message-State: ACrzQf3DbTEpp/b8SE5LN8Dv6EKVTnHGnC3WRx9rnxJNlm18zbrfK65R
        3JTyPihckVJh9xvpwvrcqyLljg==
X-Google-Smtp-Source: AMsMyM5ZMAA2SXfBrFTNG9fxkYHpjr6RQ+BUu3NQP5cpiVcAurwmVWV/yehxLHBCN2cZdEEycppZlw==
X-Received: by 2002:a17:903:247:b0:179:b5e1:54b7 with SMTP id j7-20020a170903024700b00179b5e154b7mr27777288plh.84.1664297054476;
        Tue, 27 Sep 2022 09:44:14 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id mn22-20020a17090b189600b001fde265ff4bsm158957pjb.4.2022.09.27.09.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 09:44:13 -0700 (PDT)
Date:   Tue, 27 Sep 2022 16:44:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     David Matlack <dmatlack@google.com>,
        Hou Wenlong <houwenlong.hwl@antgroup.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/6] KVM: x86/mmu: Fix wrong gfn range of tlb flushing
 in validate_direct_spte()
Message-ID: <YzMoWghqNJdYBlaE@google.com>
References: <cover.1661331396.git.houwenlong.hwl@antgroup.com>
 <c0ee12e44f2d218a0857a5e05628d05462b32bf9.1661331396.git.houwenlong.hwl@antgroup.com>
 <f6fd8ccff13f9f48cbca06f0a5278654198d0d06.camel@linux.intel.com>
 <YyoHNMz3CH4SnJwJ@google.com>
 <CALzav=f=y7-2uOnXUi---hvCTa2otDBPsY1VoUtDWnS7+0QX=w@mail.gmail.com>
 <d55ccf1c085d4adadc8dbbbae6443059a94eaf90.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d55ccf1c085d4adadc8dbbbae6443059a94eaf90.camel@linux.intel.com>
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

On Tue, Sep 27, 2022, Robert Hoo wrote:
> On Tue, 2022-09-20 at 11:44 -0700, David Matlack wrote:
> > That being said, we might as well replace the WARN_ON_ONCE() with
> > KVM_BUG_ON(). That will still do a WARN_ON_ONCE() but has the added
> > benefit of terminating the VM.
> 
> Yeah, here was my point, WARN_ON_ONCE() might not be warning obviously
> enough, as it usually for recoverable cases. But terminating VM is also
> over action I think.

Agreed, from the helper's perspective, killing the VM is unnecessary, e.g. it can
simply flush the entire TLB as a fallback.

	if (WARN_ON_ONCE(!sp->role.direct)) {
		kvm_flush_remote_tlbs(kvm);
		return;
	}

But looking at the series as a whole, I think the better option is to just not
introduce this helper.  There's exactly one user, and if that path encounters an
indirect shadow page then KVM is deep in the weeds.  But that's a moot point,
because unless I'm misreading the flow, there's no need for the unique helper.
kvm_flush_remote_tlbs_sptep() will do the right thing even if the target SP happens
to be indirect.

If we really want to assert that the child is a direct shadow page, then
validate_direct_spte() would be the right location for such an assert.  IMO that's
unnecessary paranoia.  The odds of KVM reaching this point with a completely messed
up shadow paging tree, and without already having hosed the guest and/or yelled
loudly are very, very low.

In other words, IMO we're getting too fancy for this one and we should instead
simply do:

		child = to_shadow_page(*sptep & SPTE_BASE_ADDR_MASK);
		if (child->role.access == direct_access)
			return;

		drop_parent_pte(child, sptep);
		kvm_flush_remote_tlbs_sptep(kvm, sptep);

That has the added benefit of flushing the same "thing" that is zapped, i.e. both
operate on the parent SPTE, not the child.

Note, kvm_flush_remote_tlbs_sptep() operates on the _parent_, where the above
snippets retrieves the child.  This becomes much more obvious once spte_to_child_sp()
comes along: https://lore.kernel.org/all/20220805230513.148869-8-seanjc@google.com.
