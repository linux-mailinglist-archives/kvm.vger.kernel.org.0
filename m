Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 789B63AD660
	for <lists+kvm@lfdr.de>; Sat, 19 Jun 2021 02:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234621AbhFSA5I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 20:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbhFSA5G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Jun 2021 20:57:06 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C455EC061574
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 17:54:55 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id g4so6724498pjk.0
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 17:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ExdjdCZ9W2I6Eb+ZLwMzoFUlQ7BLp1QJ3GzPjrm246k=;
        b=iLkoRx1YjZAaJsZhM5kYUkrva9uMr3Cu5I9p9tS68rumKS3dXEsidUiNY+/npogvPv
         kGT0yQii553FVr8t6WWtonrWotzvEY/ArwzoljIfVLAXqBD0+lnGsx8UbGKRqcvGcScd
         pal8l4ScElazp1Yh8j3OgS9NZH33WdOxB9vQ5sWw97xbmA6DaSmndwvyDPXDSsSm11ri
         n5Icl89b0NN2ZjRUrHEOBmSqzBtjTM6OJkJx3HfLXs+9sIt1MNWmjEnXxyXzlbVYbfoY
         +FYebnYo9WRojWaKY/rsKp+N74X8d89NNQH5LdWIPjN4cGQc8VcBTLqUoGDB3bjFnimD
         1OiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ExdjdCZ9W2I6Eb+ZLwMzoFUlQ7BLp1QJ3GzPjrm246k=;
        b=GifNpxls9Zn67vJtrlsdwHlTPxfGOJGjn73IN2Kp1c6bILPjkM1LeJNZJFEb0Or2rG
         n4xZ1Vidvfjuj7Uy7j4SOj8bDGkDYvNvmxMtIpwdSiL5OACU7XpEJ5mlQb5nz84ognbl
         sQx3FFTFg3ZKRWkflcaHvmtce2OpcWHEffm0H4tvFGXoJuxj6bv17Aj0OQYvh/Q0G1YH
         X/drLFQvt+pyhCUh0rVB9JglaBAKhe5SIl0dYLM2XAK105/Vfmd2f0Rvr44TQoZy5Nuz
         YDM+MuRZ0M1iaaVlgYOciqL8ID/QwH0BAelX5r7AKb4hWeMIe5it4tnYpLTHKK//ORwM
         36Cg==
X-Gm-Message-State: AOAM530HuvZWhh/dfm+KdiRkLOzUpg0HhN13eZnR2GAJlu2lDG4QZ7je
        XHSp5Mhz8A1yWAKhsxjhwEywQZJGBlfDTg==
X-Google-Smtp-Source: ABdhPJzdyB7j76iVSbmSdc/TdlzvYICkayH9Wi7wqLM46oU/mhRWs9O+UFlR9+quzqz3mY94mEIJwg==
X-Received: by 2002:a17:90a:7641:: with SMTP id s1mr5340858pjl.123.1624064095146;
        Fri, 18 Jun 2021 17:54:55 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s13sm10193202pgi.36.2021.06.18.17.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 17:54:54 -0700 (PDT)
Date:   Sat, 19 Jun 2021 00:54:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     stsp <stsp2@yandex.ru>
Cc:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>
Subject: Re: guest/host mem out of sync on core2duo?
Message-ID: <YM1AWuoRm6xh+OVr@google.com>
References: <bd4a2d30-5fb4-3612-c855-946d97068b9a@yandex.ru>
 <YMeMov42fihXptQm@google.com>
 <73f1f90e-f952-45a4-184e-1aafb3e4a8fd@yandex.ru>
 <YMtfQHGJL7XP/0Rq@google.com>
 <23b00d8a-1732-0b0b-cd8d-e802f7aca87c@yandex.ru>
 <CALMp9eSpJ8=O=6YExpOtdnA=gQkWfQJ+oz0bBcV4gOPFdnciVA@mail.gmail.com>
 <ca311331-c862-eed6-22ff-a82f0806797f@yandex.ru>
 <CALMp9eQxys64U-r5xdF_wdunqn8ynBoOBPRDSjTDMh-gF3EEpg@mail.gmail.com>
 <YM0fBtqYe+VyPME7@google.com>
 <4834cc76-72d5-4d23-7a56-63e455683db5@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4834cc76-72d5-4d23-7a56-63e455683db5@yandex.ru>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 19, 2021, stsp wrote:
> 19.06.2021 01:32, Sean Christopherson пишет:
> > Argh!  Check out this gem:
> > 
> > 	/*
> > 	 *   Fix the "Accessed" bit in AR field of segment registers for older
> > 	 * qemu binaries.
> > 	 *   IA32 arch specifies that at the time of processor reset the
> > 	 * "Accessed" bit in the AR field of segment registers is 1. And qemu
> > 	 * is setting it to 0 in the userland code. This causes invalid guest
> > 	 * state vmexit when "unrestricted guest" mode is turned on.
> > 	 *    Fix for this setup issue in cpu_reset is being pushed in the qemu
> > 	 * tree. Newer qemu binaries with that qemu fix would not need this
> > 	 * kvm hack.
> > 	 */
> > 	if (is_unrestricted_guest(vcpu) && (seg != VCPU_SREG_LDTR))
> > 		var->type |= 0x1; /* Accessed */
> > 
> > 
> > KVM fixes up segs when unrestricted guest is enabled, but otherwise leaves 'em
> > be, presumably because it has the emulator to fall back on for invalid state.
> > Guess what's missing in the invalid state check...
> > 
> > I think this should do it:
> Until when will it run on an emulator in this case?  Will it be too slow
> without a slightest hint to the user?

KVM would emulate until the invalid state went away, i.e. until the offending
register was loaded with a new segment that set the Accessed bit.

> If it is indeed the performance penalty for no good reason, then my
> preference would be to get an error right from KVM_SET_SREGS instead, or
> maybe from KVM_RUN, but not run everything on an emulator.

Sadly, to be consistent with other segments (SS and CS), I believe detecting and
emulating is the right "fix".  Ideally, KVM would differentiate between "invalid
for !unrestricted_guest" and "always invalid", with the latter being rejected and
punted to userspace.  E.g. I don't think it's possible for a physical CPU to have
a loaded segment with the Accessed bit set.  Unfortunately that ship sailed long,
long ago.

One possibility would be to try disabling emulate_invalid_guest_state via module
param.  That should cause failure instead of emulating.  But I suspect that that
appraoch will cause explosions for your core2duo users as KVM is probably
emulating at other points for them.  :-/

The other thing you could do would be to add a bit instrumention to query the
number of instructions KVM has emulated and alert the user if it exceeds some
arbitrary threshold.  The hiccup there is that KVM's stats are currently on
debugfs, which is usually root-only.

  $ tail /sys/kernel/debug/kvm/insn_emulation
  0
