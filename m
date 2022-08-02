Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE5C9588353
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 23:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbiHBVPt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 17:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233140AbiHBVPq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 17:15:46 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCFCCE3F
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 14:15:44 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id g12so14700716pfb.3
        for <kvm@vger.kernel.org>; Tue, 02 Aug 2022 14:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc;
        bh=PSrBHxPWluJ3SPnUdgnn+A5sduE4vEc26pQQqsqpylU=;
        b=naiDmLfjW9TFOYEKoo2rRzCQFy7S2Tw99Nld5iUX8l1sjxybDvIgu9/6Utcb54PatM
         5BsRRaqfp/OGw829GTDLRCqBtv5CW+tA54cVCB35qm37VAmDoQfABwHKZff15Ho2cWt1
         Fl6Jlu0FTgiSxEQDtSrfRq++SaKLawrbbnzK30cDpqWu63fIkHSq+/vlUdHaqwc+jiHa
         nFc9cQIDpK6k/qM6S/f5+dISEFjGn0h6uvWkhydbDiuQpRyjjA1o2uywOfBwSyGwOaDp
         DMm30kIOdqeQpYkxrCu/6PBxzuaUxFQDGTjKRb72BaRghvCAVszxzGluef8RdLyiz2ZH
         IClQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=PSrBHxPWluJ3SPnUdgnn+A5sduE4vEc26pQQqsqpylU=;
        b=3Gl/KyA6Fk7bFHBKfghdLSl1aoSIJ5aQhEJKInktAQY8fzASPOThzhZ1AuP78iavh3
         AQZIa5Unfei0CyFU6dqZPt1VIUSbHkdPaNpFc3pPszYYp47IwiJz4EmcZu1YlWLIqU0u
         3T8fNJVYtSuOLIrGdXVXPkKTIhqr442iCK7R9UbrReYbXgk5g7+ovaR8Lzzblx5Kfwuo
         hCRv8254yyL8TpUPd42tn83HBwi9/OK/StMjlpSjaixjd6BHlQVucMvjaal18Gq9y6L9
         jKFqSUDX/fPAf/0z4MnOR+zXf0tHReMjEUuqX4VjSrIesJMFkWlzr3xG5y+epN2aKWCj
         EbWA==
X-Gm-Message-State: ACgBeo32zwUmC+b5pLROB2V9NVkBhU7UdnugXRB/lOWN1V7VDK7JRrrI
        GnFifsZ5b2nYwmL8moa6+3goOw==
X-Google-Smtp-Source: AA6agR50aPW/001j3DlTVBL8vBUfk5C55k/s9ecCK0/N97TbSRA4JeHsoD4gapRg5DilUF8nzkcJEw==
X-Received: by 2002:aa7:9386:0:b0:52d:c0e5:51ee with SMTP id t6-20020aa79386000000b0052dc0e551eemr7260945pfe.49.1659474943844;
        Tue, 02 Aug 2022 14:15:43 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x11-20020a170902ec8b00b0016a6caacaefsm151496plg.103.2022.08.02.14.15.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 14:15:43 -0700 (PDT)
Date:   Tue, 2 Aug 2022 21:15:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 2/4] KVM: x86/mmu: Fully re-evaluate MMIO caching when
 SPTE masks change
Message-ID: <YumT+6joTz2M1zZP@google.com>
References: <20220728221759.3492539-1-seanjc@google.com>
 <20220728221759.3492539-3-seanjc@google.com>
 <9104e22da628fef86a6e8a02d9d2e81814a9d598.camel@intel.com>
 <YuP3zGmpiALuXfW+@google.com>
 <f313c41ed50e187ae5de87b32325c6cd4cc17c79.camel@intel.com>
 <YufgCR9CpeoVWKF7@google.com>
 <244f619a4e7a1c7079830d12379872a111da418d.camel@intel.com>
 <YuhfuQbHy4P9EZcw@google.com>
 <4fd3cea874b69f1c8bbcaf19538c7fdcb9c22aab.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4fd3cea874b69f1c8bbcaf19538c7fdcb9c22aab.camel@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 02, 2022, Kai Huang wrote:
> On Mon, 2022-08-01 at 23:20 +0000, Sean Christopherson wrote:
> > On Tue, Aug 02, 2022, Kai Huang wrote:
> > > On Mon, 2022-08-01 at 14:15 +0000, Sean Christopherson wrote:
> > > > Another thing to note is that only the value needs to be per-VM, the mask can be
> > > > KVM-wide, i.e. "mask = SUPPRESS_VE | RWX" will work for TDX and non-TDX VMs when
> > > > EPT is enabled.
> > > 
> > > Yeah, but is more like VMX and TDX both *happen* to have the same mask? 
> > > Theoretically,  VMX only need RWX to trigger EPT misconfiguration but doesn't
> > > need SUPPRESS_VE.
> > 
> > Right, SUPPRESS_VE isn't strictly necessary, but KVM already deliberately avoids
> > bit 63 because it has meaning, e.g. SUPPRESS_VE for EPT and NX for PAE and 64-bit
> > paging.  
> > 
> > > I don't see making mask/value both per-vm is a big issue?
> > 
> > Yes and no.
> > 
> > No, in the sense that it's not a big issue in terms of code.  
> > 
> > Yes, because of the connotations of having a per-VM mask.  While having SUPPRESS_VE
> > in the mask for non-TDX EPT isn't strictly necessary, it's also not strictly necessary
> > to _not_ have it in the mask.  
> > 
> 
> I think the 'mask' itself is ambiguous, i.e. it doesn't say in what circumstance
> we should include one bit to the mask.  My understanding is any bit in the
> 'mask' should at least be related to the 'value' that can enable MMIO caching.

The purpose of the mask isn't ambiguous, though it's definitely not well documented.
The mask defines what bits should be included in the check to identify an MMIO SPTE.
 
> So if SUPPRESS_VE bit is not related to non-TDX EPT (as we want EPT
> misconfiguration, but not EPT violation), I don't see why we need to include it
> to the  'mask'.

Again, it's not strictly necessary, but by doing so we don't need a per-VM mask.
And KVM should also never set SUPPRESS_VE for MMIO SPTEs, i.e. checking that bit
by including it in the mask adds some sanitcy check (albeit a miniscule amount).

> > In other words, having a per-VM mask incorrectly implies that TDX _must_
> > have a different mask.
> 
> I interpret as TDX _can_, but not _must_. 

Right, but if we write the KVM code such that it doesn't have a different mask,
then even that "can" is wrong/misleading.

> > It's also one more piece of information that developers have to track down and
> > account for, i.e. one more thing we can screw up.
> > 
> > The other aspect of MMIO SPTEs are that the mask bits must not overlap the generation
> > bits or shadow-present bit, and changing any of those bits requires careful
> > consideration, i.e. defining the set of _allowed_ mask bits on a per-VM basis would
> > incur significant complexity without providing meaningful benefit.  
> > 
> 
> Agreed on this.
> 
> But we are not checking any of those in kvm_mmu_set_mmio_spte_mask(), right? :)

No, but we really should.

> Also Isaku's patch extends kvm_mmu_set_mmio_spte_mask() to take 'kvm' or 'vcpu'
> as parameter so it's easy to check there -- not 100% sure about other places,
> though.
> 
> > As a result,
> > it's highly unlikely that we'll ever want to opportunsitically "reclaim" bit 63
> > for MMIO SPTEs, so there's practically zero cost if it's included in the mask for
> > non-TDX EPT.
> 
> Sorry I don't understand this.  If we will never "reclaim" bit 63 for MMIO SPTEs
> (for non-TDX EPT), then why bother including it to the mask?

Because then we don't need to track a per-VM mask.
