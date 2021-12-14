Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357B2474B80
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 20:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237294AbhLNTHI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 14:07:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:58609 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234429AbhLNTHH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Dec 2021 14:07:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639508826;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=HOzCAE3c6dRn8HPfbf96Cq/1+14h4R0XM0GEA+jE+MI=;
        b=HDldfEp6BPFgZcjOYL+/9H9e69/tkHs9ACkuZJ9Ere17hGnbN47FzBvnBg/+0RyCWbnMom
        YJifKpV35klTkeyowGZtSmTy64i5CavBFFQsTlEUbux0BmwionIM12nUc1N/D8Wti3lM8c
        iybIGqYeklwq8sgko+OcpZerO8klp7s=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-15-Q0djITydOg-gkbR_Th4LXQ-1; Tue, 14 Dec 2021 14:07:05 -0500
X-MC-Unique: Q0djITydOg-gkbR_Th4LXQ-1
Received: by mail-wr1-f70.google.com with SMTP id v17-20020adfedd1000000b0017c5e737b02so5015054wro.18
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 11:07:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :user-agent:reply-to:date:message-id:mime-version;
        bh=HOzCAE3c6dRn8HPfbf96Cq/1+14h4R0XM0GEA+jE+MI=;
        b=QZIzgiLSU8YhKxVZgiAuYOki/MxMJSMugJ1v+S1XrtBRBNAtMG204npcNx+JNV3HFg
         H3GwPMY2l1RnzyE2o9Sgu1NNtZ8/bMWWmdeUZAm74P9ydNZBcJ2u/FZWfgCsrBZr3iGW
         pj4XZ2sIfG81/KOpXrFJT2HoX9YSIZOhnqCcNfh/e8/4tewi4JRtV19ECOMS14mYhIpD
         c4TThkMIlMJ6D3QOFUwvYsqYzrkVzhBqj9v6DSdjJh0GG7IU2huSBBBfFfcSsNWacGLq
         eVLGvQkZME9Llreqp3MkCfM2drN/4S7/doFXZu+3r+CNVHh4gQQsRPVs/+ajvKJLMuTg
         eeLw==
X-Gm-Message-State: AOAM532emLmF3rxrqVGda0s0uRt6ZRINCpRXCCL9iDrzhI0GHpnUNqyv
        0xYgIywCT7XM/zRWBrFFhY9qqOrhIsi3S2dJp2upGGHw6bWJh8+bdPR+iIWv0Skq4GXEUdbJXgl
        GhPZSBKY6ouFx
X-Received: by 2002:a5d:670e:: with SMTP id o14mr950653wru.539.1639508824212;
        Tue, 14 Dec 2021 11:07:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzphrkVErOHrCT2GDQz7ePk99TsQi6uw2NF/UWoHk3LfELoreZ0jajxipbEEGEJ5sYFpxhulw==
X-Received: by 2002:a5d:670e:: with SMTP id o14mr950617wru.539.1639508823998;
        Tue, 14 Dec 2021 11:07:03 -0800 (PST)
Received: from localhost (static-58-87-86-188.ipcom.comunitel.net. [188.86.87.58])
        by smtp.gmail.com with ESMTPSA id w8sm656462wrk.112.2021.12.14.11.07.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 11:07:03 -0800 (PST)
From:   Juan Quintela <quintela@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     "Wang, Wei W" <wei.w.wang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Sean Christoperson <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [patch 5/6] x86/fpu: Provide fpu_update_guest_xcr0/xfd()
In-Reply-To: <87r1afrrjx.ffs@tglx> (Thomas Gleixner's message of "Tue, 14 Dec
        2021 19:04:50 +0100")
References: <20211214022825.563892248@linutronix.de>
        <20211214024948.048572883@linutronix.de>
        <854480525e7f4f3baeba09ec6a864b80@intel.com> <87zgp3ry8i.ffs@tglx>
        <b3ac7ba45c984cf39783e33e0c25274d@intel.com> <87r1afrrjx.ffs@tglx>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Tue, 14 Dec 2021 20:07:02 +0100
Message-ID: <87k0g7qa3t.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> wrote:
> Wei,
>
> On Tue, Dec 14 2021 at 16:11, Wei W. Wang wrote:
>> On Tuesday, December 14, 2021 11:40 PM, Thomas Gleixner wrote:
>>> On Tue, Dec 14 2021 at 15:09, Wei W. Wang wrote:
>>> > On Tuesday, December 14, 2021 10:50 AM, Thomas Gleixner wrote:
>>> >> + * Return: 0 on success, error code otherwise  */ int
>>> >> +__fpu_update_guest_features(struct fpu_guest *guest_fpu, u64 xcr0,
>>> >> +u64
>>> >> +xfd) {
>>> >
>>> > I think there would be one issue for the "host write on restore" case.
>>> > The current QEMU based host restore uses the following sequence:
>>> > 1) restore xsave
>>> > 2) restore xcr0
>>> > 3) restore XFD MSR
>>> 
>>> This needs to be fixed. Ordering clearly needs to be:
>>> 
>>>   XFD, XCR0, XSTATE
>>
>> Sorry, just to clarify that the ordering in QEMU isn't made by us
>> for this specific XFD enabling.
>> It has been there for long time for the general restoring of all the
>> XCRs and MSRs.
>> (if you are interested..FYI:
>> https://github.com/qemu/qemu/blob/master/target/i386/kvm/kvm.c#L4168).
>> - kvm_put_xsave()
>> - kvm_put_xcrs()
>> - kvm_put_msrs()
>>
>> We need to check with the QEMU migration maintainer (Dave and Juan CC-ed)
>> if changing that ordering would be OK.
>> (In general, I think there are no hard rules documented for this ordering)
>
> There haven't been ordering requirements so far, but with dynamic
> feature enablement there are.
>
> I really want to avoid going to the point to deduce it from the
> xstate:xfeatures bitmap, which is just backwards and Qemu has all the
> required information already.

Hi

First of all, I claim ZERO knowledge about low level x86_64.

Once told that, this don't matter for qemu migration, code is at

target/i386/kvm/kvm.c:kvm_arch_put_registers()


    ret = kvm_put_xsave(x86_cpu);
    if (ret < 0) {
        return ret;
    }
    ret = kvm_put_xcrs(x86_cpu);
    if (ret < 0) {
        return ret;
    }
    /* must be before kvm_put_msrs */
    ret = kvm_inject_mce_oldstyle(x86_cpu);
    if (ret < 0) {
        return ret;
    }
    ret = kvm_put_msrs(x86_cpu, level);
    if (ret < 0) {
        return ret;
    }

If it needs to be done in any other order, it is completely independent
of whatever is inside the migration stream.

I guess that Paolo will put some light here.

Later, Juan.

