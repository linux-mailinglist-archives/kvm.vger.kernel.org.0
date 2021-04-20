Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1AF0366271
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 01:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234425AbhDTXVT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 19:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234378AbhDTXVS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 19:21:18 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9774C06138A
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 16:20:46 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id 10so17949984pfl.1
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 16:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vyTe8Ms9FDLBu/1T/x8kUEzX4NU16oUdBt56Knk8t10=;
        b=IXOtUGVzoaFybE1JXWdVUc0brrGQQ9rijuh9/2+D2h3tbuKsWnb/G9OiCQ5PRmkDSa
         7gESD/a1HzlQ6hmRdU2FtuWt4ANc9t1zBJaHC7nX0rDwHHi3HNGGD+R+dpQIPxD3ySIp
         H+znu8/jXOxrj0YmNDPkrPzCYs4+4A1JlKI23lK5qpjMr667cysaJLUSoo2k/GtJz6SY
         gn/QgnC0CxXB+vFDHwgQPdYJJIPFEuKJwfhFW0NKfe577qB9luSxpTQ8umellcRloqro
         qj4ecNRrRKuF7Nd75qzL80TxqpU6a3OHaKDi4/4PzGAhAOZMF3ngOuTPFaAtOjlEcDbH
         urOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vyTe8Ms9FDLBu/1T/x8kUEzX4NU16oUdBt56Knk8t10=;
        b=j1AhjXHF4QJdrEL10sjSZkVjVHvOg9d2ENU7HQ2xESZoBYltTm4KkEWw7MnB+BWHJl
         EXYgt+QsFoGquvLN21bPn7ev+AZYkS3CK7tmI+u6avNSmIrmHm0yP1I0nCJGH4BBT9Pb
         Udxx8msmJVHZ2mxTXvbXkoX6Fuu2AqMAfOTPsnAXj0YAKhvoehqJOLSCnL08IOdhxhSJ
         f9WjwgIKczOcjlCI+FGsPkUXtAHU8yTZz31ImQbPwslV2k0dk11jCel7u7IME3+PbcYa
         O0w2cCXIKR30NcH5a8s92sfvZ4X3BMRPYD+rvB5gtMkTC0S/OnATzGWD7lvXcOMAtpp8
         GU7Q==
X-Gm-Message-State: AOAM531YFXJSNB9q/AQRpBzFLxdgGjIMU6MdBMI0BHfeL1ejyiuaL6lo
        SctdwJFguUA7bhUaa+vUVam6kg==
X-Google-Smtp-Source: ABdhPJx9sA2NEs5JYDbJjTHEh6AwgKHilfwWjxt71fELh6XIPe1jItzcK6RL+S3en9qwVsq+tAu89A==
X-Received: by 2002:a62:51c5:0:b029:257:5416:15fc with SMTP id f188-20020a6251c50000b0290257541615fcmr5048181pfb.62.1618960846203;
        Tue, 20 Apr 2021 16:20:46 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id x1sm92396pfj.209.2021.04.20.16.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 16:20:45 -0700 (PDT)
Date:   Tue, 20 Apr 2021 23:20:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        srutherford@google.com, joro@8bytes.org, brijesh.singh@amd.com,
        thomas.lendacky@amd.com, venu.busireddy@oracle.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>,
        x86@kernel.org, Ashish Kalra <ashish.kalra@amd.com>
Subject: Re: [PATCH 0/3] KVM: x86: guest interface for SEV live migration
Message-ID: <YH9hyid+zyQN1GUw@google.com>
References: <20210420112006.741541-1-pbonzini@redhat.com>
 <YH8P26OibEfxvJAu@google.com>
 <05129de6-c8d9-de94-89e7-6257197433ef@redhat.com>
 <YH8lMTMzfD7KugRg@google.com>
 <YH82qgTLCKUoSyNa@google.com>
 <4b96c4fc-23a4-0bd2-ea58-fa6d81e50b15@redhat.com>
 <YH9aj8FLQ4z4Po/x@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YH9aj8FLQ4z4Po/x@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 20, 2021, Sean Christopherson wrote:
> On Tue, Apr 20, 2021, Paolo Bonzini wrote:
> > On 20/04/21 22:16, Sean Christopherson wrote:
> > > On Tue, Apr 20, 2021, Sean Christopherson wrote:
> > > > On Tue, Apr 20, 2021, Paolo Bonzini wrote:
> > > > > In this particular case, if userspace sets the bit in CPUID2 but doesn't
> > > > > handle KVM_EXIT_HYPERCALL, the guest will probably trigger some kind of
> > > > > assertion failure as soon as it invokes the HC_PAGE_ENC_STATUS hypercall.
> > > 
> > > Oh!  Almost forgot my hail mary idea.  Instead of a new capability, can we
> > > reject the hypercall if userspace has _not_ set KVM_CAP_ENFORCE_PV_FEATURE_CPUID?
> > > 
> > > 			if (vcpu->arch.pv_cpuid.enforce &&
> > > 			    !guest_pv_has(vcpu, KVM_FEATURE_HC_PAGE_ENC_STATUS)
> > > 				break;
> > 
> > Couldn't userspace enable that capability and _still_ copy the supported
> > CPUID blindly to the guest CPUID, without supporting the hypercall?
> 
> Yes.  I was going to argue that we get to define the behavior, but that's not
> true because it would break existing VMMs that blindly copy.  Capability it is...

Hrm, that won't quite work though.  If userspace blindly copies CPUID, but doesn't
enable the capability, the guest will think the hypercall is supported.  The
guest hopefully won't freak out too much on the resulting -KVM_ENOSYS, but it
does make the CPUID flag rather useless.

We can make it work with:

		u64 gpa = a0, npages = a1, enc = a2;

		if (!guest_pv_has(vcpu, KVM_FEATURE_HC_PAGE_ENC_STATUS))
			break;

		if (!PAGE_ALIGNED(gpa) || !npages ||
		    gpa_to_gfn(gpa) + npages <= gpa_to_gfn(gpa)) {
			ret = -EINVAL;
			break;
		}

		if (!vcpu->kvm->arch.hypercall_exit_enabled) {
			ret = 0;
			break;
		}

		vcpu->run->exit_reason        = KVM_EXIT_HYPERCALL;
		vcpu->run->hypercall.nr       = KVM_HC_PAGE_ENC_STATUS;
		vcpu->run->hypercall.args[0]  = gpa;
		vcpu->run->hypercall.args[1]  = npages;
		vcpu->run->hypercall.args[2]  = enc;
		vcpu->run->hypercall.longmode = op_64_bit;
		vcpu->arch.complete_userspace_io = complete_hypercall_exit;

That's dancing pretty close to hypercall filtering, which I was hoping to avoid.
I guess it's not reaaaally filtering since the exit check happens after the
validity checks.

> > > (BTW, it's better to return a bitmask of hypercalls that will exit to
> > > userspace from KVM_CHECK_EXTENSION.  Userspace can still reject with -ENOSYS
> > > those that it doesn't know, but it's important that it knows in general how
> > > to handle KVM_EXIT_HYPERCALL).

Speaking of bitmasks, what about also accepting a bitmask for enabling the
capability?  (not sure if the above implies that).  E.g.

		if (!(vcpu->kvm->arch.hypercall_exit_enabled & BIT_ULL(nr))) {
			ret = 0;
			break;
		}
