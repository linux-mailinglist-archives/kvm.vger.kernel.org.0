Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C1C2F6767
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 18:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728494AbhANRUb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 12:20:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbhANRU3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 12:20:29 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3691C061574
        for <kvm@vger.kernel.org>; Thu, 14 Jan 2021 09:19:48 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id x126so3731368pfc.7
        for <kvm@vger.kernel.org>; Thu, 14 Jan 2021 09:19:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1u0hHUSEEliOo8V4yriPq3cyKn6ullY8YW9KiIkobfk=;
        b=ZLp3EJqLl7TKSrMFy/TKrGf2U1rKvMJs7XG0MKq6/Jv5xjQ0FqkHFtNPKAGDqSEUg6
         FAxAKuhq+I5/NhJcaO9RflWofjeog+IfggZW7hrHLRI+3AU3KyzSELXgPqy7dOL+yQde
         jkiWFBfTWTXHCMUcNRWG/kMxZHrELQoalbMyGYO9d13qzinFZm/H9Dx3eEEnmJXGpKmh
         m+cw4LuXB47cfFpnAQ920Tx4rmWPmanVu3SLTovBylVQ8s9zBmPSFN4pD8QY7d+PrQ2F
         rGrrTcjZVFW2bBNhHodDOF5izfhgO2crwZQpgaY/bek9Rb1uMO/qNO8Zd11+rebZoiCV
         Mwqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1u0hHUSEEliOo8V4yriPq3cyKn6ullY8YW9KiIkobfk=;
        b=ISmpfb/WLmAksiYlp528BDx334r08kyPfAdQt81QNSjkq0QYYMR651YXuWUYmzi310
         glTMtY1KYsOiCa5qKCElLEqyOHXv4+HILfaxc2z2Q6vvFiL5QFupWV+cpVHhxk0fP3U1
         Qi4FJP61EMILRcFtCydP04Qx2o3dL7xs5EH0pQ8OMcqOkjHckHuWvedcug7U/fP/FUIl
         dpP8GhI976rPyJs7cgIVt8EJyD9XfvZYREB5TTxbghpzEfYGETLa4Idkc5b09RPaH0ek
         mZE7ec55897hi1YW136aema3Hyv5L9p2osp7nKKgxK0SlCFEAaqLeucwTvOBGVfzQPP0
         XF5w==
X-Gm-Message-State: AOAM530IH25tm5R4Odz09rkHD/clKr4Wfq5g9Hl59SxI3KZOaY04wOJk
        5IniTylzVdL30nlodRD7lTPlew==
X-Google-Smtp-Source: ABdhPJweuJc1T4THuTPmRtUm+GC8wnx68SsRpiLogsaNQieDiFp+SxU8TeWgZA5DbFRruL9nXzfBTw==
X-Received: by 2002:a63:4b16:: with SMTP id y22mr8432122pga.203.1610644788272;
        Thu, 14 Jan 2021 09:19:48 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id u189sm5721402pfb.51.2021.01.14.09.19.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 09:19:47 -0800 (PST)
Date:   Thu, 14 Jan 2021 09:19:40 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Bandan Das <bsd@redhat.com>, Wei Huang <wei.huang2@amd.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, joro@8bytes.org,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, dgilbert@redhat.com
Subject: Re: [PATCH 1/2] KVM: x86: Add emulation support for #GP triggered by
 VM instructions
Message-ID: <YAB9LIIVg8iEfXsb@google.com>
References: <20210112063703.539893-1-wei.huang2@amd.com>
 <X/37QBMHxH8otaMa@google.com>
 <jpgsg76kjsm.fsf@linux.bootlegged.copy>
 <db574a30f50a2f556dc983f18f78f28c933fdac7.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db574a30f50a2f556dc983f18f78f28c933fdac7.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 14, 2021, Maxim Levitsky wrote:
> On Tue, 2021-01-12 at 15:00 -0500, Bandan Das wrote:
> > Sean Christopherson <seanjc@google.com> writes:
> > ...
> > > > -	if ((emulation_type & EMULTYPE_VMWARE_GP) &&
> > > > -	    !is_vmware_backdoor_opcode(ctxt)) {
> > > > -		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
> > > > -		return 1;
> > > > +	if (emulation_type & EMULTYPE_PARAVIRT_GP) {
> > > > +		vminstr = is_vm_instr_opcode(ctxt);
> > > > +		if (!vminstr && !is_vmware_backdoor_opcode(ctxt)) {
> > > > +			kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
> > > > +			return 1;
> > > > +		}
> > > > +		if (vminstr)
> > > > +			return vminstr;
> > > 
> > > I'm pretty sure this doesn't correctly handle a VM-instr in L2 that hits a bad
> > > L0 GPA and that L1 wants to intercept.  The intercept bitmap isn't checked until
> > > x86_emulate_insn(), and the vm*_interception() helpers expect nested VM-Exits to
> > > be handled further up the stack.
> 
> Actually IMHO this exactly what we want. We want L0 to always intercept
> these #GPs, and hide them from the guest.
> 
> What we do need to do (and I prepared and attached a patch for that, is that
> if we run a guest, we want to inject corresponding vmexit (like
> SVM_EXIT_VMRUN) instead of emulating the instruction.

Yes, lack of forwarding to L1 as a nested exit is what I meant by "doesn't
correctly handle".
