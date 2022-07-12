Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B15E4571B62
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 15:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233001AbiGLNe2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 09:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233068AbiGLNe0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 09:34:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0CD27B23D4
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 06:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657632864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JgAcjPtcpgNCqfpVZQXf86mfKwE3gQAGcZaJHiCWMKk=;
        b=ReWYX6C9ABSaYjNuCCCgEkUnczggQ+afTZuKYeDC6v2wC9rvvCYktEynNFn4cCtxXhM9iW
        Y+hl5hx8RQgdR+uTSHBn8QVrTkWmUzqn1Yr42OEs26+RiVuS7gZ0/ubCjy/8QZkqvHoXg1
        QCUBLxHobI0u0rGRjTdmDtHelXM3y9Q=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-wRNbo61CNb2jxhBtNnu2zg-1; Tue, 12 Jul 2022 09:34:23 -0400
X-MC-Unique: wRNbo61CNb2jxhBtNnu2zg-1
Received: by mail-qk1-f197.google.com with SMTP id bi1-20020a05620a318100b006b572361789so7846092qkb.10
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 06:34:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=JgAcjPtcpgNCqfpVZQXf86mfKwE3gQAGcZaJHiCWMKk=;
        b=amPkLgQw6pHI2u2wDNbtBHCBVF6s256ewKadDRyisd6QIix9Vd2RQqfetlo3b/f0bi
         hLEKX8mvVRJGHqFODv2b9rV7YLG+cX12ULbxnCYJ+KLmKQ0LD5vMWa533hTF8o1vyegt
         UnhWF2EKeUm35qPGhsqmj5bX5i8Vshv9kmpwFyrePrkuaNQ3wpsDXwnHmFUy24Rlr2Xc
         cU1TDh0Ctp1oM/UmQmxOm7CX5dQR70pUPPaBW1bjwk27hGLPviIyDLvEkuRl0TcbHDoR
         1XmyGK3aoAmCE2Og35oRNeu33nqEf+aGjfg7I9NZGKxp+wUR99jjs0uHTQulJsOh2kCl
         aAlw==
X-Gm-Message-State: AJIora+gUlbaE5hq8sU1ilYKGaTKQF038Zg93eVxw/ZNgrmNjzQIoUs2
        h09PdNXFSur9oeThZWvMa00DPh4rFRrtGCQWMxjr1HoBz7F26thPjnFLmz+3q/SzwUT8UvrVUDd
        aBGtdiFjhA7iP
X-Received: by 2002:a05:620a:4507:b0:6af:348b:85fe with SMTP id t7-20020a05620a450700b006af348b85femr15472596qkp.629.1657632862389;
        Tue, 12 Jul 2022 06:34:22 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tt12hXbsGNmSGrHijJdRfb2UWBkKIk2+Hj7xIUXmNIV/+XqGFV5QYF/4rRDFpC+66nbAiX1Q==
X-Received: by 2002:a05:620a:4507:b0:6af:348b:85fe with SMTP id t7-20020a05620a450700b006af348b85femr15472560qkp.629.1657632862055;
        Tue, 12 Jul 2022 06:34:22 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id a187-20020ae9e8c4000000b006b5517da3casm8706942qkg.22.2022.07.12.06.34.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 06:34:21 -0700 (PDT)
Message-ID: <649b5c71b5ad40e3c74f76c86ad0ca89f9dac3e1.camel@redhat.com>
Subject: Re: [PATCH 3/3] KVM: x86: WARN only once if KVM leaves a dangling
 userspace I/O request
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+760a73552f47a8cd0fd9@syzkaller.appspotmail.com,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Hou Wenlong <houwenlong.hwl@antgroup.com>
Date:   Tue, 12 Jul 2022 16:34:18 +0300
In-Reply-To: <20220711232750.1092012-4-seanjc@google.com>
References: <20220711232750.1092012-1-seanjc@google.com>
         <20220711232750.1092012-4-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-07-11 at 23:27 +0000, Sean Christopherson wrote:
> Change a WARN_ON() to separate WARN_ON_ONCE() if KVM has an outstanding
> PIO or MMIO request without an associated callback, i.e. if KVM queued a
> userspace I/O exit but didn't actually exit to userspace before moving
> on to something else.  Warning on every KVM_RUN risks spamming the kernel
> if KVM gets into a bad state.  Opportunistically split the WARNs so that
> it's easier to triage failures when a WARN fires.
> 
> Deliberately do not use KVM_BUG_ON(), i.e. don't kill the VM.  While the
> WARN is all but guaranteed to fire if and only if there's a KVM bug, a
> dangling I/O request does not present a danger to KVM (that flag is truly
> truly consumed only in a single emulator path), and any such bug is
> unlikely to be fatal to the VM (KVM essentially failed to do something it
> shouldn't have tried to do in the first place).  In other words, note the
> bug, but let the VM keep running.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 567d13405445..50dc55996416 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10847,8 +10847,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>                 r = cui(vcpu);
>                 if (r <= 0)
>                         goto out;
> -       } else
> -               WARN_ON(vcpu->arch.pio.count || vcpu->mmio_needed);
> +       } else {
> +               WARN_ON_ONCE(vcpu->arch.pio.count);
> +               WARN_ON_ONCE(vcpu->mmio_needed);
> +       }
>  
>         if (kvm_run->immediate_exit) {
>                 r = -EINTR;

At some point in the future, the checkpatch.pl should start to WARN the
patch submitter if WARN_ON and not WARN_ON_ONCE was used ;-)

It already bugs the user about BUG_ON ;-)

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

