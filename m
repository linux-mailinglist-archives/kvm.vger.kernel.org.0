Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A84F13769C0
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 19:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbhEGR7R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 13:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhEGR7R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 May 2021 13:59:17 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE886C061761
        for <kvm@vger.kernel.org>; Fri,  7 May 2021 10:58:14 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id z18so1930279plg.8
        for <kvm@vger.kernel.org>; Fri, 07 May 2021 10:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7b05HQwQFJbiC5hEzCCygGe/UudPuvMm6AH3d8lkYuo=;
        b=KYOZ2sJKADhfuZ/uHMMrB7Yz4pjkf+WtoJEvVJeLQAI9RAcsyiddelzeYpgeq/WBRf
         aYbEM6iM2YzK07SC+oosCVwJBCI1UdqnphuM+V9hK8PeM5SJyF3N1k9UbJSaoW0Iqd+G
         SXr8hLPVtRDKqwh8waGJhlnzYj+7ZWnb45KzLXh4dDbIxRKVegBZXC9njBPFtj6qOHSF
         oHCkSGUDqH3uc4QH4u+yj95GJanLrZdcpWxl4Irl0QPl4rBsU48qszWvPraQRjub2pLL
         iMPaWawIKjMH7c9YyQocMUFO8/Po/Z4fmRlR+s9laHvYUbfUQkyUdvXfcqN/6AHFnBe5
         xWdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7b05HQwQFJbiC5hEzCCygGe/UudPuvMm6AH3d8lkYuo=;
        b=U0tYwMbyKHNiCFkF+/av+ZjbDWCWWoHyhy+LZCKXpffIB+PsYoqtpUzE4dsZG+YNmE
         BcOyTZhByfQ02At4eeBg5VUdhpx4iocnjti1UU8AiezI9noMkQJutPiahOoD2MAXHUIv
         nqQNOAj2IczfNumDpbuvPWQ5wdE9QYLI4D0mhcgkAunfgTeK1JjzYuhAfkaxrAxG5u8q
         sz+I5Y7VeunhoNtqfTW+ORtym7ODaMBYM3lqT09/qXKfvu7cFbWEoQms0xuCnrStMdHM
         cf1oc92yf1/KCzyDf5kMdJr4SHQi0w56og4FwBcj0IMUAqCoAp+VP6YrHagHtJcxxoxs
         gJNA==
X-Gm-Message-State: AOAM531Uy39zNji4juUEbzoYVZYop5wNhzZifCMPjLOsE/1S7Gcs8pd+
        EUyb6GlFhT9rXNF7KucJYVjGSA==
X-Google-Smtp-Source: ABdhPJwD2CO9NKfxU5WpcWIllCqKoM1ASKfW7Uz7zvc9BLuit6NQMTeRMxVNBgjQlKWm/XUN11ik5g==
X-Received: by 2002:a17:902:b20a:b029:ef:463:365a with SMTP id t10-20020a170902b20ab02900ef0463365amr5403349plr.17.1620410294246;
        Fri, 07 May 2021 10:58:14 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id q7sm3220941pfq.172.2021.05.07.10.58.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 10:58:13 -0700 (PDT)
Date:   Fri, 7 May 2021 17:58:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Venkatesh Srinivas <venkateshs@chromium.org>
Cc:     Jon Kohler <jon@nutanix.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: use X86_FEATURE_RSB_CTXSW for RSB stuffing in
 vmexit
Message-ID: <YJV/sZvgA8uN/23k@google.com>
References: <20210507150636.94389-1-jon@nutanix.com>
 <CAA0tLEoyy_ogDc11r_1T907Rp5CwgM64hFwRt5SX40THp2+C3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA0tLEoyy_ogDc11r_1T907Rp5CwgM64hFwRt5SX40THp2+C3A@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 07, 2021, Venkatesh Srinivas wrote:
> On Fri, May 7, 2021 at 8:08 AM Jon Kohler <jon@nutanix.com> wrote:
> >
> > cpufeatures.h defines X86_FEATURE_RSB_CTXSW as "Fill RSB on context
> > switches" which seems more accurate than using X86_FEATURE_RETPOLINE
> > in the vmxexit path for RSB stuffing.
> >
> > X86_FEATURE_RSB_CTXSW is used for FILL_RETURN_BUFFER in
> > arch/x86/entry/entry_{32|64}.S. This change makes KVM vmx and svm
> > follow that same pattern. This pairs up nicely with the language in
> > bugs.c, where this cpu_cap is enabled, which indicates that RSB
> > stuffing should be unconditional with spectrev2 enabled.
> >         /*
> >          * If spectre v2 protection has been enabled, unconditionally fill
> >          * RSB during a context switch; this protects against two independent
> >          * issues:
> >          *
> >          *      - RSB underflow (and switch to BTB) on Skylake+
> >          *      - SpectreRSB variant of spectre v2 on X86_BUG_SPECTRE_V2 CPUs
> >          */
> >         setup_force_cpu_cap(X86_FEATURE_RSB_CTXSW);
> >
> > Furthermore, on X86_FEATURE_IBRS_ENHANCED CPUs && SPECTRE_V2_CMD_AUTO,
> > we're bypassing setting X86_FEATURE_RETPOLINE, where as far as I could
> > find, we should still be doing RSB stuffing no matter what when
> > CONFIG_RETPOLINE is enabled and spectrev2 is set to auto.
> 
> If I'm reading https://software.intel.com/security-software-guidance/deep-dives/deep-dive-indirect-branch-restricted-speculation
> correctly, I don't think an RSB fill sequence is required on VMExit on
> processors w/ Enhanced IBRS. Specifically:
> """
> On processors with enhanced IBRS, an RSB overwrite sequence may not
> suffice to prevent the predicted target of a near return from using an
> RSB entry created in a less privileged predictor mode.  Software can
> prevent this by enabling SMEP (for transitions from user mode to
> supervisor mode) and by having IA32_SPEC_CTRL.IBRS set during VM exits
> """
> On Enhanced IBRS processors, it looks like SPEC_CTRL.IBRS is set
> across all #VMExits via x86_virt_spec_ctrl in kvm.
> 
> So is this patch needed?

Venkatesh belatedly pointed out (off list) that KVM VMX stops intercepting
MSR_IA32_SPEC_CTRL after the first (successful) write by the guest.  But, I 
believe that's a non-issue for ENHANCED_IBRS because of this blurb in Intel's
documentation[*]:

  Processors with enhanced IBRS still support the usage model where IBRS is set
  only in the OS/VMM for OSes that enable SMEP. To do this, such processors will
  ensure that guest behavior cannot control the RSB after a VM exit once IBRS is
  set, even if IBRS was not set at the time of the VM exit.

The code and changelog for commit 706d51681d63 ("x86/speculation: Support
Enhanced IBRS on future CPUs") is more than a little confusing:

  spectre_v2_select_mitigation():
	if (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED)) {
		mode = SPECTRE_V2_IBRS_ENHANCED;
		/* Force it so VMEXIT will restore correctly */
		x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
		wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
		goto specv2_set_mode;
	}


  changelog:
	Kernel also has to make sure that IBRS bit remains set after
	VMEXIT because the guest might have cleared the bit. This is already
	covered by the existing x86_spec_ctrl_set_guest() and
	x86_spec_ctrl_restore_host() speculation control functions.

but I _think_ that is simply saying that MSR_IA32_SPEC_CTRL.IBRS needs to be
restored in order to keep the mitigations active in the host.   I don't think it
contradicts the documentation that says VM-Exit is automagically mitigated if
IBRS has _ever_ been set.

[*] https://software.intel.com/security-software-guidance/deep-dives/deep-dive-indirect-branch-restricted-speculation
