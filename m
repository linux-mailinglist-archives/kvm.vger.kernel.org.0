Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3BA7D8782
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 19:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbjJZRYf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 13:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbjJZRYe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 13:24:34 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5BB990
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 10:24:31 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d9c4ae201e0so1132618276.1
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 10:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698341071; x=1698945871; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GatHVTLVnQhttOezHvDF6an1rysQIrElqbDH0zmxJVc=;
        b=lbKqI8a7l5EDJHd+wAcDZRN0ZaPIOxr87+qCjnM+TDu0+M4HXmfzzXI+rn0KhHtdEk
         o/G/dtd6/uQXnyPSXcMAwpdFpNxMy/zO6u4Rv9tyRKVsXCtX8bzQTApf0WG9e0bWmzKF
         VlqspD13ohmhpnZB+Ry4PST+WLx+jEaDR33ctqMuyonZVLhZF6H2d2Sg2GEBqjmSJnGW
         TKpeG55Wh72VzacOiMPflUthpreRQ77WWsa56xxPMprRSwmOZv3tT5s1YurdBjWPanAi
         jH+nIdhJN/Kke7IUzgSCyzbqcycDQRFFTLpEr482M9eNAOqnHpPNdVZ1y1AC9n1BTa0Q
         mryQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698341071; x=1698945871;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GatHVTLVnQhttOezHvDF6an1rysQIrElqbDH0zmxJVc=;
        b=UlfmXyTj+pG0J5HUAO2daBfXqy/Y6Pt9u6q5OXAXK+2QhW182xMaPi6yst8XOEL7DF
         18TQ9p7CJh+8T+kgEQXqqlgHGg1Yme4hs+7LyiEXpFIMWbXW1Fh1el+kzHXas69dnar9
         U1sIhifV58P3otCMwcpk1WVweMd5tgo+b7+TbCRYNRbAvv9j2Z64ciWAg9M3BHiOBMxy
         xDWEtZnC7lP+PZX3PxeLRoF9j2ChsrTL8DfvcfyX9b3P9bnE1Jo2CrUSgr88wf3DnOwL
         hML1mvHe6KrWBNgkHqI+Ail7Z1T3TlbYO+U/Zp/uM1zHI7jCpNFUG1sSD7PsgyDxRp3m
         2MvA==
X-Gm-Message-State: AOJu0YwgunAvj6+TvDrXVJAOpMhlQlZgmLJ5YQPnpqW3sWIP9k3PnQQY
        o9XqILvnlbDYEMlfqKhhIuyUOjLnwRw=
X-Google-Smtp-Source: AGHT+IFoIo29n0krAH+TlH9QJyT5lQadiwDHLNCOnAK4kn2PMD28s+3e1hDT1EzxHebYBKuVWvvft+H5oPI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d43:0:b0:da0:56a4:efe3 with SMTP id
 64-20020a250d43000000b00da056a4efe3mr7926ybn.5.1698341071104; Thu, 26 Oct
 2023 10:24:31 -0700 (PDT)
Date:   Thu, 26 Oct 2023 10:24:29 -0700
In-Reply-To: <de1b148c-45c6-6517-0926-53d1aad8978e@intel.com>
Mime-Version: 1.0
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-7-weijiang.yang@intel.com> <e0db6ffd-5d92-2a1a-bdfb-a190fe1ccd25@intel.com>
 <1347cf03-4598-f923-74e4-a3d193d9d2e9@intel.com> <ZTf5wPKXuHBQk0AN@google.com>
 <de1b148c-45c6-6517-0926-53d1aad8978e@intel.com>
Message-ID: <ZTqgzZl-reO1m01I@google.com>
Subject: Re: [PATCH v6 06/25] x86/fpu/xstate: Opt-in kernel dynamic bits when
 calculate guest xstate size
From:   Sean Christopherson <seanjc@google.com>
To:     Weijiang Yang <weijiang.yang@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, chao.gao@intel.com,
        rick.p.edgecombe@intel.com, john.allen@amd.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 25, 2023, Weijiang Yang wrote:
> On 10/25/2023 1:07 AM, Sean Christopherson wrote:
> > On Fri, Sep 15, 2023, Weijiang Yang wrote:
> > IIUC, the "dynamic" features contains CET_KERNEL, whereas xfeatures_mask_supervisor()
> > conatins PASID, CET_USER, and CET_KERNEL.  PASID isn't virtualized by KVM, but
> > doesn't that mean CET_USER will get dropped/lost if userspace requests AMX/XTILE
> > enabling?
> 
> Yes, __state_size is correct for guest enabled xfeatures, including CET_USER,
> and it gets removed from __state_perm.
> 
> IIUC, from current qemu/kernel interaction for guest permission settings,
> __xstate_request_perm() is called only _ONCE_ to set AMX/XTILE for every vCPU
> thread, so the removal of guest supervisor xfeatures won't hurt guest! ;-/

Huh?  I don't follow.  What does calling __xstate_request_perm() only once have
to do with anything?

/me stares more

OMG, hell no.  First off, this code is a nightmare to follow.  The existing comment
is useless.  No shit the code is adding in supervisor states for the host.  What's
not AT ALL clear is *why*.

The commit says it's necessary because the "permission bitmap is only relevant
for user states":

  commit 781c64bfcb735960717d1cb45428047ff6a5030c
  Author: Thomas Gleixner <tglx@linutronix.de>
  Date:   Thu Mar 24 14:47:14 2022 +0100

    x86/fpu/xstate: Handle supervisor states in XSTATE permissions
    
    The size calculation in __xstate_request_perm() fails to take supervisor
    states into account because the permission bitmap is only relevant for user
    states.

But @permitted comes from:

  permitted = xstate_get_group_perm(guest);

which is either fpu->guest_perm.__state_perm or fpu->perm.__state_perm.  And
__state_perm is initialized to:

	fpu->perm.__state_perm		= fpu_kernel_cfg.default_features;

where fpu_kernel_cfg.default_features contains everything except the dynamic
xfeatures, i.e. everything except XFEATURE_MASK_XTILE_DATA:

	fpu_kernel_cfg.default_features = fpu_kernel_cfg.max_features;
	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;

So why on earth does this code to force back xfeatures_mask_supervisor()?  Because
the code just below drops the supervisor bits to compute the user xstate size and
then clobbers __state_perm.

	/* Calculate the resulting user state size */
	mask &= XFEATURE_MASK_USER_SUPPORTED;
	usize = xstate_calculate_size(mask, false);

	...

	WRITE_ONCE(perm->__state_perm, mask);

That is beyond asinine.  IIUC, the intent is to apply the permission bitmap only
for user states, because the only dynamic states are user states.  Bbut the above
creates an inconsistent mess.  If userspace doesn't request XTILE_DATA,
__state_perm will contain supervisor states, but once userspace does request
XTILE_DATA, __state_perm will be lost.

And because that's not confusing enough, clobbering __state_perm would also drop
FPU_GUEST_PERM_LOCKED, except that __xstate_request_perm() can' be reached with
said LOCKED flag set.

fpu_xstate_prctl() already strips out supervisor features:

	case ARCH_GET_XCOMP_PERM:
		/*
		 * Lockless snapshot as it can also change right after the
		 * dropping the lock.
		 */
		permitted = xstate_get_host_group_perm();
		permitted &= XFEATURE_MASK_USER_SUPPORTED;
		return put_user(permitted, uptr);

	case ARCH_GET_XCOMP_GUEST_PERM:
		permitted = xstate_get_guest_group_perm();
		permitted &= XFEATURE_MASK_USER_SUPPORTED;
		return put_user(permitted, uptr);

and while KVM doesn't apply the __state_perm to supervisor states, if it did
there would be zero harm in doing so.

	case 0xd: {
		u64 permitted_xcr0 = kvm_get_filtered_xcr0();
		u64 permitted_xss = kvm_caps.supported_xss;

Second, the relying on QEMU to only trigger __xstate_request_perm() is not acceptable.
It "works" for the current code, but only because there's only a single dynamic
feature, i.e. this will short circuit and prevent computing a bad ksize.

	/* Check whether fully enabled */
	if ((permitted & requested) == requested)
		return 0;

I don't know how I can possibly make it any clearer: KVM absolutely must not assume
userspace behavior.

So rather than continue with the current madness, which will break if/when the
next dynamic feature comes along, just preserve non-user xfeatures/flags in
__guest_perm.
 
If there are no objections, I'll test the below and write a proper changelog.
 
--
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 26 Oct 2023 10:17:33 -0700
Subject: [PATCH] x86/fpu/xstate: Always preserve non-user xfeatures/flags in
 __state_perm

Fixes: 781c64bfcb73 ("x86/fpu/xstate: Handle supervisor states in XSTATE permissions")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kernel/fpu/xstate.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index ef6906107c54..73f6bc00d178 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1601,16 +1601,20 @@ static int __xstate_request_perm(u64 permitted, u64 requested, bool guest)
 	if ((permitted & requested) == requested)
 		return 0;
 
-	/* Calculate the resulting kernel state size */
+	/*
+	 * Calculate the resulting kernel state size.  Note, @permitted also
+	 * contains supervisor xfeatures even though supervisor are always
+	 * permitted for kernel and guest FPUs, and never permitted for user
+	 * FPUs.
+	 */
 	mask = permitted | requested;
-	/* Take supervisor states into account on the host */
-	if (!guest)
-		mask |= xfeatures_mask_supervisor();
 	ksize = xstate_calculate_size(mask, compacted);
 
-	/* Calculate the resulting user state size */
-	mask &= XFEATURE_MASK_USER_SUPPORTED;
-	usize = xstate_calculate_size(mask, false);
+	/*
+	 * Calculate the resulting user state size.  Take care not to clobber
+	 * the supervisor xfeatures in the new mask!
+	 */
+	usize = xstate_calculate_size(mask & XFEATURE_MASK_USER_SUPPORTED, false);
 
 	if (!guest) {
 		ret = validate_sigaltstack(usize);

base-commit: c076acf10c78c0d7e1aa50670e9cc4c91e8d59b4
-- 
