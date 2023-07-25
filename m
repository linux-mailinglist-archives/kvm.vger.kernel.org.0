Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 037F5760E23
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 11:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbjGYJQe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 05:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjGYJQd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 05:16:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F7C110B;
        Tue, 25 Jul 2023 02:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6C8hcMCgit825O3VB0e4u+R1Hv7FslUAGURuPpZzojA=; b=MyjXusb0p33yGR6a5Z9dxTRWhu
        oXE4zXVbWOCFSo4C0ogJ1zUbsojMiTFOXTuJZ+rFCiVixM7DjjBGG0h9ykYfK3Fpzr4N0ZIhd/4/a
        daibtTNyNrq3bfNRJDXy55JH5/O5TWRkEYrd9LjvtqHHQcYDTN+7x4+gpWz1+hhT96Bwv6vBc0F4g
        68FM7JRLhmYuytJUl+HtrjKmxTaP/4+RIDXqepmQjuJMLf0upAbGVVYTo3+3vQ9wo8mV+hwxYyRyk
        GLVVXjc1Z5GloW1R2AC2i/xvqM2ESKLEOTBdGwjW/nbr+M4o0asaoFlCK20FENjfDX7xPDPdRNYmV
        NEp3+dGQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qOE9M-005JxU-Fy; Tue, 25 Jul 2023 09:16:12 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 8925B300095;
        Tue, 25 Jul 2023 11:16:11 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 73BAD2B20499D; Tue, 25 Jul 2023 11:16:11 +0200 (CEST)
Date:   Tue, 25 Jul 2023 11:16:11 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>
Subject: Re: [PATCH v4 14/19] KVM: SVM: Check that the current CPU supports
 SVM in kvm_is_svm_supported()
Message-ID: <20230725091611.GA3766257@hirez.programming.kicks-ass.net>
References: <20230721201859.2307736-1-seanjc@google.com>
 <20230721201859.2307736-15-seanjc@google.com>
 <20230724212150.GH3745454@hirez.programming.kicks-ass.net>
 <ZL7vs9zMatFRl6IH@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZL7vs9zMatFRl6IH@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 24, 2023 at 02:40:03PM -0700, Sean Christopherson wrote:
> On Mon, Jul 24, 2023, Peter Zijlstra wrote:
> > On Fri, Jul 21, 2023 at 01:18:54PM -0700, Sean Christopherson wrote:
> > > Check "this" CPU instead of the boot CPU when querying SVM support so that
> > > the per-CPU checks done during hardware enabling actually function as
> > > intended, i.e. will detect issues where SVM isn't support on all CPUs.
> > 
> > Is that a realistic concern?
> 
> It's not a concern in the sense that it should never happen, but I know of at
> least one example where VMX on Intel completely disappeared[1].  The "compatibility"
> checks are really more about the entire VMX/SVM feature set, the base VMX/SVM
> support check is just an easy and obvious precursor to the full compatibility
> checks.
> 
> Of course, SVM doesn't currently have compatibility checks on the full SVM feature
> set, but that's more due to lack of a forcing function than a desire to _not_ have
> them.  Intel CPUs have a pesky habit of bugs, ucode updates, and/or in-field errors
> resulting in VMX features randomly appearing or disappearing.  E.g. there's an
> ongoing buzilla (sorry) issue[2] where a user is only able to load KVM *after* a
> suspend+resume cycle, because TSC scaling only shows up on one socket immediately
> after boot, which is then somehow resolved by suspend+resume.
> 
> [1] 009bce1df0bb ("x86/split_lock: Don't write MSR_TEST_CTRL on CPUs that aren't whitelisted")
> [2] https://bugzilla.kernel.org/show_bug.cgi?id=217574

Is that using late loading of ucode? Anything that changes *any* feature
flag must be early ucode load, there is no other possible way since
einux does feature enumeration early, and features are fixed thereafter.

This is one of the many reasons late loading is a trainwreck.

Doing suspend/resume probably re-loads the firmware and re-does the
feature enumeration -- I didn't check.

Also, OMG don't you just love computers :/
