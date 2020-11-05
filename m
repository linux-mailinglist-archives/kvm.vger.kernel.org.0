Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612242A83A4
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 17:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731060AbgKEQi2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 11:38:28 -0500
Received: from mail.skyhub.de ([5.9.137.197]:39180 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730871AbgKEQi1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Nov 2020 11:38:27 -0500
Received: from zn.tnic (p200300ec2f0ee5006c78cd15f1739a31.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:e500:6c78:cd15:f173:9a31])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 55BC71EC0455;
        Thu,  5 Nov 2020 17:38:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1604594306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=jWNgDg4lYdXRL3LCMZDyDp5A0hzWOPD9tfl4ojqe1KQ=;
        b=HFtefqslVW9yuh/GVWrb4wPt4B40pEiNPX2MdvoIH1gWXMoJ5Jkjal70s7yckVCbCQaHzX
        71k5BY7ibV6GEjjurPWAT/SIzHpxNTobl3sVfB2fLss6L7UGQ881bB524NxsBWvdytIrGC
        R+vY0C5SUOBAwCHyQI07I3wDJcwvWwA=
Date:   Thu, 5 Nov 2020 17:38:12 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Michael Roth <michael.roth@amd.com>
Cc:     Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Juergen Gross <jgross@suse.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Mike Stunes <mstunes@vmware.com>,
        Kees Cook <keescook@chromium.org>, kvm@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Cfir Cohen <cfir@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        virtualization@lists.linux-foundation.org,
        Martin Radev <martin.b.radev@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andy Lutomirski <luto@kernel.org>, hpa@zytor.com,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH v7 01/72] KVM: SVM: nested: Don't allocate VMCB
 structures on stack
Message-ID: <20201105163812.GE25636@zn.tnic>
References: <20200907131613.12703-1-joro@8bytes.org>
 <20200907131613.12703-2-joro@8bytes.org>
 <160459347763.31546.3911053208379939674@vm0>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <160459347763.31546.3911053208379939674@vm0>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 05, 2020 at 10:24:37AM -0600, Michael Roth wrote:
> >  out_set_gif:
> >         svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));
> > -       return 0;
> > +
> > +       ret = 0;
> > +out_free:
> > +       kfree(save);
> > +       kfree(ctl);
> 
> This change seems to trigger a crash via smm-test.c (and state-test.c) KVM
> selftest when we call vcpu_load_state->KVM_SET_NESTED_STATE. I think what's
> happening is we are hitting the 'goto out_set_gif;'

No out_set_gif upstream anymore after

d5cd6f340145 ("KVM: nSVM: Avoid freeing uninitialized pointers in svm_set_nested_state()")

and it looks like you hit the issue this patch is fixing.

Can you test with the above commit cherrypicked ontop of your what looks
like 5.9.1-ish tree?

If that fixes it, we should route this patch to stable.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
