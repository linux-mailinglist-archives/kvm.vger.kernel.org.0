Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F621C7C14
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 23:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729614AbgEFVOD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 17:14:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60214 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729497AbgEFVOD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 17:14:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588799640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NZxhiJYbxM1qqUjtcTHTmwQVVAW7Looq+iFDFA5dqgo=;
        b=TPnm6EJy+Fn+FlpRf5xvFxl9hZo7VGtvQYACSLSf1aCaCAysbA2VtzPqmZb+qAos83a4b4
        0I/J7zQkWXQwhYqTJ7en69+pxhWfAfRHqHGPKRBAtrrzZ5ChZVratQzjtvHFafC/2wDQR5
        HW1qEaCcryesgtkW77UfcN1HUqM3yus=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-a72CGt9TOI6cY1TWRVsNPg-1; Wed, 06 May 2020 17:13:59 -0400
X-MC-Unique: a72CGt9TOI6cY1TWRVsNPg-1
Received: by mail-qv1-f69.google.com with SMTP id 65so3663944qva.17
        for <kvm@vger.kernel.org>; Wed, 06 May 2020 14:13:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=NZxhiJYbxM1qqUjtcTHTmwQVVAW7Looq+iFDFA5dqgo=;
        b=ncHeu/7IfcRZkztIDdXufA0jN2RqpixnynWuKXI0JjwLfHJf+Z7T225KOyi63RSaJ2
         9cM7VgTtyvrhy032IND693Jzs/HzBVONAvtYYhZxRCXwtj4biUKta2k2ZLGdcMUEMsDj
         duZNFcMbtI3CwqEH6iwhTeg6FfPp2z4X667Iw9tagJGBPqdgubYP2H3+RpzxyKE97x3I
         IYsGg3aq0Tq3v6phaK60E2WGHpcSS8oWkexGaLLDzimzBv2JpcEVufpwYYoD7mJNmXoC
         eJtX/OUKmes6h6lMMSJRi8gRKhS+Zak3YU7uuTn6MEmS0sK0I/Q20ifnDIfKgCcvYLSo
         xyVQ==
X-Gm-Message-State: AGi0PuYZfBf2Uzx2ApdLl77cYgnLuD7sOPyaBCwxZ0yzHAaVuHe79E18
        1zWh4AC9NDdRsey/CqCTI5RqoQwYRmZ9F4L5+se8NfpvU6aEQD0lw9n79S3LYCO6oO4ptIv4jxC
        LDtxQNAwE6Edl
X-Received: by 2002:a37:a310:: with SMTP id m16mr9623001qke.346.1588799638486;
        Wed, 06 May 2020 14:13:58 -0700 (PDT)
X-Google-Smtp-Source: APiQypJBI0yo8r3Z8dCk2QYAiBQX+xeNtOpc5CrXQmfe7B7XVovD+2ApSgkbXVcQhsnFI4RYRJRQwg==
X-Received: by 2002:a37:a310:: with SMTP id m16mr9622975qke.346.1588799638100;
        Wed, 06 May 2020 14:13:58 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id x125sm2716746qke.34.2020.05.06.14.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 14:13:57 -0700 (PDT)
Date:   Wed, 6 May 2020 17:13:56 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 8/9] KVM: x86, SVM: do not clobber guest DR6 on
 KVM_EXIT_DEBUG
Message-ID: <20200506211356.GD228260@xz-x1>
References: <20200506111034.11756-1-pbonzini@redhat.com>
 <20200506111034.11756-9-pbonzini@redhat.com>
 <20200506181515.GR6299@xz-x1>
 <8f7f319c-4093-0ddc-f9f5-002c41d5622c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8f7f319c-4093-0ddc-f9f5-002c41d5622c@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 06, 2020 at 10:07:15PM +0200, Paolo Bonzini wrote:
> On 06/05/20 20:15, Peter Xu wrote:
> > On Wed, May 06, 2020 at 07:10:33AM -0400, Paolo Bonzini wrote:
> >> On Intel, #DB exceptions transmit the DR6 value via the exit qualification
> >> field of the VMCS, and the exit qualification only contains the description
> >> of the precise event that caused a vmexit.
> >>
> >> On AMD, instead the DR6 field of the VMCB is filled in as if the #DB exception
> >> was to be injected into the guest.  This has two effects when guest debugging
> >> is in use:
> >>
> >> * the guest DR6 is clobbered
> >>
> >> * the kvm_run->debug.arch.dr6 field can accumulate more debug events, rather
> >> than just the last one that happened.
> >>
> >> Fortunately, if guest debugging is in use we debug register reads and writes
> >> are always intercepted.  Now that the guest DR6 is always synchronized with
> >> vcpu->arch.dr6, we can just run the guest with an all-zero DR6 while guest
> >> debugging is enabled, and restore the guest value when it is disabled.  This
> >> fixes both problems.
> >>
> >> A testcase for the second issue is added in the next patch.
> > 
> > Is there supposed to be another test after this one, or the GD test?
> 
> It's the GD test.

Oh... so is dr6 going to have some leftover bit set in the GD test if without
this patch for AMD?  Btw, I noticed a small difference on Intel/AMD spec for
this case, e.g., B[0-3] definitions on such leftover bits...

Intel says:

        B0 through B3 (breakpoint condition detected) flags (bits 0 through 3)
        — Indicates (when set) that its associated breakpoint condition was met
        when a debug exception was generated. These flags are set if the
        condition described for each breakpoint by the LENn, and R/Wn flags in
        debug control register DR7 is true. They may or may not be set if the
        breakpoint is not enabled by the Ln or the Gn flags in register
        DR7. Therefore on a #DB, a debug handler should check only those B0-B3
        bits which correspond to an enabled breakpoint.

AMD says:

        Breakpoint-Condition Detected (B3–B0)—Bits 3:0. The processor updates
        these four bits on every debug breakpoint or general-detect
        condition. A bit is set to 1 if the corresponding address- breakpoint
        register detects an enabled breakpoint condition, as specified by the
        DR7 Ln, Gn, R/Wn and LENn controls, and is cleared to 0 otherwise. For
        example, B1 (bit 1) is set to 1 if an address- breakpoint condition is
        detected by DR1.

I'm not sure whether it means AMD B[0-3] bits are more strict on the Intel ones
(if so, then the selftest could be a bit too strict to VMX).

> >> +		/* This restores DR6 to all zeros.  */
> >> +		kvm_update_dr6(vcpu);
> > 
> > I feel like it won't work as expected for KVM_GUESTDBG_SINGLESTEP, because at
> > [2] below it'll go to the "else" instead so dr6 seems won't be cleared in that
> > case.
> 
> You're right, I need to cover both cases that trigger #DB.
> 
> > Another concern I have is that, I mostly read kvm_update_dr6() as "apply the
> > dr6 memory cache --> VMCB".  I'm worried this might confuse people (at least I
> > used quite a few minutes to digest...) here because latest data should already
> > be in the VMCB.
> 
> No, the latest guest register is always in vcpu->arch.dr6.  It's only
> because of KVM_DEBUGREG_WONT_EXIT that kvm_update_dr6() needs to pass
> vcpu->arch.dr6 to kvm_x86_ops.set_dr6.  Actually this patch could even
> check KVM_DEBUGREG_WONT_EXIT instead of vcpu->guest_debug.  I'll take a
> look tomorrow.

OK.

> 
> > Also, IMHO it would be fine to have invalid dr6 values during
> > KVM_SET_GUEST_DEBUG.  I'm not sure whether my understanding is correct, but I
> > see KVM_SET_GUEST_DEBUG needs to override the in-guest debug completely.
> 
> Sort of, userspace can try to juggle host and guest debugging (this is
> why you have KVM_GUESTDBG_INJECT_DB and KVM_GUESTDBG_INJECT_BP).

I see!

> 
> > If we worry about dr6 being incorrect after KVM_SET_GUEST_DEBUG is disabled,
> > IMHO we can reset dr6 in kvm_arch_vcpu_ioctl_set_guest_debug() properly before
> > we return the debug registers to the guest.
> > 
> > PS. I cannot see above lines [1] in my local tree (which seems to be really a
> > bugfix...).  I tried to use kvm/queue just in case I missed some patches, but I
> > still didn't see them.  So am I reading the wrong tree here?
> 
> The patch is based on kvm/master, and indeed that line is from a bugfix
> that I've posted yesterday ("KVM: SVM: fill in
> kvm_run->debug.arch.dr[67]"). I had pushed that one right away, because
> it was quite obviously suitable for 5.7.

Oh that's why it looks very familiar (because I read that patch.. :).  Then it
makes sense now.  Thanks!

-- 
Peter Xu

