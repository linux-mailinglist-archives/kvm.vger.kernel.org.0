Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2943313AA
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 17:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbhCHQpF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 11:45:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbhCHQpB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 11:45:01 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE9C1C06175F
        for <kvm@vger.kernel.org>; Mon,  8 Mar 2021 08:45:01 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id n9so5794247pgi.7
        for <kvm@vger.kernel.org>; Mon, 08 Mar 2021 08:45:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iLW4p27vj1YK1a09zBC63IOwGVQvzr8I/pdVVsxQoyM=;
        b=dJZZA9KySyT/iRgRCP0Bhl/FyT1PTnP/oQUROzUdCz+27QozfYk7TXX3YQCM1EvzQG
         5d4NpSsLN4yoBZn9fI503M9osDOH0wP8LNqMgzcs8RLaS0oJHApG34uA/xCSOZPkz4JV
         GV4Cj6BYqCOGclsSZYFqPcPbJljYX/z5blhYgMYoWbgk5jSVRNg2dE2XTVvRYDj1eYq8
         sS0NlmK535hFtBP6wGrugEb+tfREvIB2q9j+lukvtG24NPCKcear49qahGnu6ycmujlz
         jFva29bsCuU3W6X+/t+plwrbT3AZzvep6sQvaGjKuVfFlmN/YTy+oYpfzTz5F8tosPnU
         Hb9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iLW4p27vj1YK1a09zBC63IOwGVQvzr8I/pdVVsxQoyM=;
        b=OWyrBlY7A2pC3mqhSog05VyWgxeI4KPwxb70/Wf4wBc/oi2tUQ0sl6wcVqqpyLjRrf
         Y3fc0BNuTU6xqg7TqZqoY7Mq52kuUl3TlL85Ju21gvkwHoDnTydKMCPnxCW9FsKqM/8q
         HkwW1XoHMErF9DuZUwEzGAaQIqBASCJEV+7VVU1/TfEr43FHCzaNtNFrWBWxNSmsKB1b
         FwKiUv904ASnTmTApexTc1XkpI1Q0k/VMHban9mTmlxqWHyiyQO++F4B+8Z8AJAkseN4
         up3q47oCApI9Ms2BvjF4IqiGsYIfEEVAppDMPWc/iMCdKV5kqguJU6ZR2bOqZa6bSWpq
         myng==
X-Gm-Message-State: AOAM533sKnOzSQP2QGZl0jspdmfaoKT2jNVzb6rYVzbMO5788aJgCfQe
        c30D8K0UBqYceNv2BgwzbyUG5Q==
X-Google-Smtp-Source: ABdhPJzAMQaZlNN78AIZD+iQDC84gC+nH7X+yEPa0HdKTiYuCoy0T1DJbj4B0JnxU0+HRmdEu0K7lA==
X-Received: by 2002:a63:461d:: with SMTP id t29mr20862531pga.192.1615221900941;
        Mon, 08 Mar 2021 08:45:00 -0800 (PST)
Received: from google.com ([2620:15c:f:10:cc8b:42a0:da69:7e82])
        by smtp.gmail.com with ESMTPSA id y8sm11651516pfe.36.2021.03.08.08.44.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 08:45:00 -0800 (PST)
Date:   Mon, 8 Mar 2021 08:44:53 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 03/28] KVM: nSVM: inject exceptions via
 svm_check_nested_events
Message-ID: <YEZUhbBtNjWh0Zka@google.com>
References: <YELdblXaKBTQ4LGf@google.com>
 <fc2b0085-eb0f-dbab-28c2-a244916c655f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc2b0085-eb0f-dbab-28c2-a244916c655f@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Mar 06, 2021, Paolo Bonzini wrote:
> On 06/03/21 02:39, Sean Christopherson wrote:
> > Unless KVM (L0) knowingly wants to override L1, e.g. KVM_GUESTDBG_* cases, KVM
> > shouldn't do a damn thing except forward the exception to L1 if L1 wants the
> > exception.
> > 
> > ud_interception() and gp_interception() do quite a bit before forwarding the
> > exception, and in the case of #UD, it's entirely possible the #UD will never get
> > forwarded to L1.  #GP is even more problematic because it's a contributory
> > exception, and kvm_multiple_exception() is not equipped to check and handle
> > nested intercepts before vectoring the exception, which means KVM will
> > incorrectly escalate a #GP->#DF and #GP->#DF->Triple Fault instead of exiting
> > to L1.  That's a wee bit problematic since KVM also has a soon-to-be-fixed bug
> > where it kills L1 on a Triple Fault in L2...
> 
> I agree with the #GP problem, but this is on purpose.  For example, if L1
> CPUID has MOVBE and it is being emulated via #UD, L1 would be right to set
> MOVBE in L2's CPUID and expect it not to cause a #UD.

The opposite is also true, since KVM has no way of knowing what CPU model L1 has
exposed to L2.  Though admittedly hiding MOVBE is a rather contrived case.  But,
the other EmulateOnUD instructions that don't have an intercept condition,
SYSENTER, SYSEXIT, SYSCALL, and VMCALL, are also suspect.  SYS* will mostly do
the right thing, though it's again technically possible that KVM  will do the
wrong thing since KVM doesn't know L2's CPU model.  VMCALL is also probably ok
in most scenarios, but patching L2's code from L0 KVM is sketchy.

> The same is true for the VMware #GP interception case.

I highly doubt that will ever work out as intended for the modified IO #GP
behavior.  The only way emulating #GP in L2 is correct if L1 wants to pass
through the capabilities to L2, i.e. the I/O access isn't intercepted by L1.
That seems unlikely.  If the I/O is is intercepted by L1, bypassing the IOPL and
TSS-bitmap checks is wrong and will cause L1 to emulate I/O for L2 userspace
that should never be allowed.  Odds are there isn't a corresponding emulated
port in L1, i.e. there's no major security flaw, but it's far from good
behavior.

I can see how some of the instructions will kinda sorta work, but IMO forwading
them to L1 is much safer, even if it means that L1 will see faults that should
be impossible.  At least for KVM-on-KVM, those spurious faults are benign since
L1 likely also knows how to emulate the #UD and #GP instructions.
