Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E405443668
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 20:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbhKBTWL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 15:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbhKBTWH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Nov 2021 15:22:07 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA50EC061714
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 12:19:31 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id o14so374917plg.5
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 12:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sWN3TjMrZBld01AYwkb5F8yaPd7wPsiAr7ELXp02BzQ=;
        b=IDQkx4oCrvf3VtNZkzftrgRtfHhBvbhY+dM9GKpKRtMcYFDqK+Wk5HeJCZAflfUi1f
         UQlStm4XkHcewqBO6RT8IwfmPm5d+ujdn3wr/DS0geyHM044ExofAYS7a+95kZfJ7bQp
         J1p2KgK+JqEGoDBno5KxFKbE4QOjU/5mNTEZDE+GTY6/ypyW6NGBDrzu0TMf97sNG5Rj
         7HvFZ0NE3FLnjOVRYqC+Hh2SqOENJg5SBxhcY9r1WWM8DTGI5gYdthfhin1qRQJla8k3
         k9xmOt08YFjdpaefBks59XgdoYSIDi7y8t15oOxYEUhzG5sHyzWv+36Ll6wZ5pOyJm57
         FvSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sWN3TjMrZBld01AYwkb5F8yaPd7wPsiAr7ELXp02BzQ=;
        b=KWTNWy4oLWnr91tMsdrebwrQmnxfPjX+exw8UCGwjsxraSQagHM6idpdaqWoALYBl4
         JxKRqGpvMXOsgV8IBM4N65O/I4iIuAgQtUJ0WGjuNYzb3oBRSDBfj3Uj7nBLhFogK3wD
         yq3X1d2PXEKvBnJnBVKmF5XvAo45z6QEdDKM9eKo3aif7FXskCLH7tvAqk/uw89tu6cU
         Ndd5qg7fbWAea3cduQryAbKQbTxJ5EPECk59mgNJAbrS7cVy27QvVaV72f7vyN7WMvqM
         mqmrICC4vzrZlx0hcG0VPP+2ZAdKrxzky5ylqMtrFq6xnwq9KN2Z7Ow2sbe857tliZQ4
         758A==
X-Gm-Message-State: AOAM531Eth/syVG+UKuyyt1+90Vo+nI6HECrdp1eDcXothSaSKE6bQWX
        wJjEPthH/1rOgplwBWq6tJVamw==
X-Google-Smtp-Source: ABdhPJwvKT1RfGsGukb1mgKSAdHnGYGgVb0ffaYoDlO4DN7H5/nBV7MTlaPCQh4iaGGGdd0C+DfzYQ==
X-Received: by 2002:a17:90a:a389:: with SMTP id x9mr9083666pjp.167.1635880771244;
        Tue, 02 Nov 2021 12:19:31 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m7sm16619062pgn.32.2021.11.02.12.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 12:19:30 -0700 (PDT)
Date:   Tue, 2 Nov 2021 19:19:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     Jim Mattson <jmattson@google.com>, pbonzini@redhat.com,
        dmatlack@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: VMX: Add a wrapper for reading
 INVPCID/INVEPT/INVVPID type
Message-ID: <YYGPPgCUWSEt0rQ0@google.com>
References: <20211011194615.2955791-1-vipinsh@google.com>
 <YWSdTpkzNt3nppBc@google.com>
 <CALMp9eRzPXg2WS6-Yy6U90+B8wXm=zhVSkmAym4Y924m7FM-7g@mail.gmail.com>
 <YWhgxjAwHhy0POut@google.com>
 <CALMp9eQ4y+YO7THjfpHzJPmoODkUqoPUURaBvL+OdGjZhAMuTA@mail.gmail.com>
 <CAHVum0eMByJA5Yc0iom6w5+Web105cYoJ-94jxzLPTLVpYOHSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHVum0eMByJA5Yc0iom6w5+Web105cYoJ-94jxzLPTLVpYOHSw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 02, 2021, Vipin Sharma wrote:
> Sorry for the late reply.
> 
> On Thu, Oct 14, 2021 at 10:05 AM Jim Mattson <jmattson@google.com> wrote:
> >
> > On Thu, Oct 14, 2021 at 9:54 AM Sean Christopherson <seanjc@google.com> wrote:
> > > Oh, yeah, definitely.  I missed that SVM's invpcid_interception() has the same
> > > open-coded check.
> > >
> > > Alternatively, could we handle the invalid type in the main switch statement?  I
> > > don't see anything in the SDM or APM that architecturally _requires_ the type be
> > > checked before reading the INVPCID descriptor.  Hardware may operate that way,
> > > but that's uArch specific behavior unless there's explicit documentation.
> >
> > Right. INVVPID and INVEPT are explicitly documented to check the type
> > first, but INVPCID is not.
> 
> It seems to me that I can move type > 3 check to kvm_handle_invpcid()
> switch statement. I can replace BUG() in that switch statement with
> kvm_inject_gp for the default case, I won't even need INVPCID_TYPE_MAX
> in this case.

Yep.

> If you are fine with this approach then I will send out a patch where
> invalid type is handled  in kvm_handle_invpcid() switch statement.

This has my vote.
