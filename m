Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB6E429A61
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 02:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234188AbhJLAXw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 20:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233311AbhJLAXv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 20:23:51 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC81C06161C
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 17:21:50 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id y7so6583751pfg.8
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 17:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=n459MQOlWwd6ptzNZBJzvaoErNGrU6E1S82qnsrtuLg=;
        b=Q8ahDM2cS8ZsSkgGOs8wn39AcY2HNyWksVxrM/UkiiMS+yzKKVYPKksTHvqam8QNCR
         2H1kE+SBXF9XUPDBTKDs1K7oSZqoK7I2IawyOb7FOgwkCPDX360v/mmuz5ak1Wbtta9A
         N1M31XGdDVw6z7dN9N3IuIgPQDDbhqewOOqZc3xjDkH1RmF60P+K0qg8z4wdvt3II+xC
         YNR3ONvv6Br16Kp25cDzfcuRZOL1FHMv6EI5XmQLH2ZQWeVEgT7PJmCj9Z2Qh8h7DlME
         lAYEbUxYzso4t14GwetkL7h0t8H2vbI7jwxR7ko2UOVjUfmMjSf4JP4M5R6wQhUYrtIv
         z/bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=n459MQOlWwd6ptzNZBJzvaoErNGrU6E1S82qnsrtuLg=;
        b=gCbPShqH+MtBWICStDhCmuvVNVdCjqV7U470uiieo//nysw1y5D9Rx9nOY4nieBpdQ
         A61vdN6Cwzje4yH/hiNCdSz2O5mqpVTbr6dWldPs0q0wwdfay1PzkCQoVAQQIyhXOmoJ
         8sMBFw4H7eh3Se/vC5oJtqzh9ff2Bu3SqFDTkbvpOAxEd1mUz7cIZVqmEd1rzo/vCxNU
         aPDWxK9rg/wyGAb8Vi0x5VEIURbf3GWRp78Wr64rPuz9IHohQll07cktc5jTqRcAV2O7
         CCnr755BeY59Kd4zMhvX5fndb4wv4f2JGBHZEnSf2V71kywPG2V/WQu8fqFPzqu4n4JO
         aQqg==
X-Gm-Message-State: AOAM531J7sh41zRPVZFPTRwO+d5btmEMlGfQam1V9Ghr5lErlBxt1l1A
        JNtyEgFvzpJsRPE3EBuE6DgBDA==
X-Google-Smtp-Source: ABdhPJy2L2VgOs2YW1MTifaPx+BYcn3AzPzFFDo67xDEIdnNEoumVjuITkFIccRaC0dy1uuNFPxIjw==
X-Received: by 2002:aa7:94a8:0:b0:44c:f3e0:81fb with SMTP id a8-20020aa794a8000000b0044cf3e081fbmr16029819pfl.6.1633998109653;
        Mon, 11 Oct 2021 17:21:49 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x35sm10054611pfh.52.2021.10.11.17.21.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 17:21:49 -0700 (PDT)
Date:   Tue, 12 Oct 2021 00:21:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Bandan Das <bsd@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Wei Huang <wei.huang2@amd.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH 07/14] KVM: x86: SVM: add warning for CVE-2021-3656
Message-ID: <YWTVGaX4V1eR6k0k@google.com>
References: <20210914154825.104886-1-mlevitsk@redhat.com>
 <20210914154825.104886-8-mlevitsk@redhat.com>
 <f0c0e659-23a8-59ab-edf8-5b380d723493@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0c0e659-23a8-59ab-edf8-5b380d723493@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 23, 2021, Paolo Bonzini wrote:
> On 14/09/21 17:48, Maxim Levitsky wrote:
> > Just in case, add a warning ensuring that on guest entry,
> > either both VMLOAD and VMSAVE intercept is enabled or
> > vVMLOAD/VMSAVE is enabled.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >   arch/x86/kvm/svm/svm.c | 6 ++++++
> >   1 file changed, 6 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 861ac9f74331..deeebd05f682 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -3784,6 +3784,12 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
> >   	WARN_ON_ONCE(kvm_apicv_activated(vcpu->kvm) != kvm_vcpu_apicv_active(vcpu));
> > +	/* Check that CVE-2021-3656 can't happen again */
> > +	if (!svm_is_intercept(svm, INTERCEPT_VMSAVE) ||
> > +	    !svm_is_intercept(svm, INTERCEPT_VMSAVE))
> > +		WARN_ON(!(svm->vmcb->control.virt_ext &
> > +			  VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK));
> > +
> >   	sync_lapic_to_cr8(vcpu);
> >   	if (unlikely(svm->asid != svm->vmcb->control.asid)) {
> > 
> 
> While it's nice to be "proactive", this does adds some extra work. Maybe it
> should be under CONFIG_DEBUG_KERNEL.  It could be useful to make it into its
> own function so we can add similar intercept invariants in the same place.

I don't know that DEBUG_KERNEL will guard much, DEBUG_KERNEL=y is very common,
e.g. it's on by default in the x86 defconfigs.  I too agree it's nice to be
proactive, but this isn't that different than say failing to intercept CR3 loads
when shadow paging is enabled.

If we go down the path of effectively auditing KVM invariants, I'd rather we
commit fully and (a) add a dedicated Kconfig that is highly unlikely to be turned
on by accident and (b) audit a large number of invariants.
