Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1E29625E43
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 16:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233237AbiKKPXO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 10:23:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbiKKPXA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 10:23:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A6910C9
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 07:21:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668180096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V/2KUIcNea2iSiMMtPiiwN4PyC8vWPzRYRSCfguAA+4=;
        b=ezalUGSjM91lmYRv2qQaZ8Wk0/rzZP2kx1fweLKLBDBRSFY6HRvW6B2yra2nBBAWsXB7ce
        LZGRh3qnA9GAyr0JYUHcqJPDxLDZnV9sTZhJXYKZl7mF4QsoEUdPLZ93KZ8xI8rk2+AH3X
        dtkvLknTlOo9VFxl3YSPzKNMa4KvfQc=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-620-6eL0nlW1Oz-QgKdgTkwewg-1; Fri, 11 Nov 2022 10:21:35 -0500
X-MC-Unique: 6eL0nlW1Oz-QgKdgTkwewg-1
Received: by mail-qk1-f200.google.com with SMTP id o13-20020a05620a2a0d00b006cf9085682dso4946621qkp.7
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 07:21:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V/2KUIcNea2iSiMMtPiiwN4PyC8vWPzRYRSCfguAA+4=;
        b=iWUfXmjvNBb1Qah4Ftact9Sks2N8E2qghvUnIb1VRfw8f9IEYqtiNWFAHCk3bQri3t
         EoC0KTfzEO9rmvkduvYXtaLSuHnKZ91WaL3SBNOQVC7w5HBzmsHAliSiSj6cad/pfzqr
         zQQ287K7Z8+M3iirP5ZOdMT71s7Op5I4WGp/T9DwBhQ28LYTgIV1QOuAqYURaSvYpCQ2
         PgnLAbHZCM/+dOgWG9qULPbK2E7L/hLc/0qAjVPLLKGmiHTgEh8s22t7vUp0XAZufVpD
         3B1TmdGvlfpnn1c1M8An+W35KaOchpsutZQgSQwMthnd/6vAkn7b0eUIhodqYxwUa3wj
         8/Sw==
X-Gm-Message-State: ANoB5pmYIKCjvE4o1XW3HcixtKT486xkiGBa5iNjgpD8UrRklXTnFpwt
        a4NSqa5I3AGdM1hg2YMEGVyJ1OUsb8uzTlAzXzgoNLYB+mRS49bGSF1KCAK9okwvCRnGLQ2xklA
        deO75+mAYqu3b
X-Received: by 2002:a37:a809:0:b0:6fa:1e46:291b with SMTP id r9-20020a37a809000000b006fa1e46291bmr1465828qke.494.1668180094469;
        Fri, 11 Nov 2022 07:21:34 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4obT3Iyq7MtRwR9wMVvHN14BtAVf2chkJjW7Rv7zzWBQO/nMTwoZWfZ6eZpZKrZsTfLu+riQ==
X-Received: by 2002:a37:a809:0:b0:6fa:1e46:291b with SMTP id r9-20020a37a809000000b006fa1e46291bmr1465801qke.494.1668180094202;
        Fri, 11 Nov 2022 07:21:34 -0800 (PST)
Received: from ovpn-194-83.brq.redhat.com (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id g10-20020ae9e10a000000b006fa4cac54a5sm1505749qkm.72.2022.11.11.07.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 07:21:33 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Alexander Potapenko <glider@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Juergen Gross <jgross@suse.com>, srivatsa@csail.mit.edu
Subject: Re: Making KMSAN compatible with paravirtualization
In-Reply-To: <CAG_fn=W0vXvFrQdRhZiCriz7JjM+zLzKQY+z36j+UqPYnsmq_Q@mail.gmail.com>
References: <CAG_fn=W0vXvFrQdRhZiCriz7JjM+zLzKQY+z36j+UqPYnsmq_Q@mail.gmail.com>
Date:   Fri, 11 Nov 2022 16:21:30 +0100
Message-ID: <875yflo6th.fsf@ovpn-194-83.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Alexander Potapenko <glider@google.com> writes:

> Hi,
>
> While investigating KMSAN's incompatibilities with the default Ubuntu
> config (https://github.com/google/kmsan/issues/89#issuecomment-1310702949),
> I figured out that a kernel won't boot with both CONFIG_KMSAN=y and
> CONFIG_XEN_PV=y.
>
> In particular, it may crash in load_percpu_segment():
>
>         __loadsegment_simple(gs, 0);
>         wrmsrl(MSR_GS_BASE, cpu_kernelmode_gs_base(cpu));
>
> Here the value of %gs between __loadsegment_simple() and wrmsrl() is
> zero, so when KMSAN's __msan_get_context_state() instrumentation
> function is called before the actual WRMSR instruction is performed,
> it will attempt to access percpu data and crash.
>
> Unless instructed otherwise (by noinstr or __no_sanitize_memory on the
> source level, or by KMSAN_SANITIZE := n on the Makefile level), KMSAN
> inserts instrumentation at function prologue for every non-inlined
> function, including native_write_msr().
>
> Marking native_write_msr() noinstr actually makes the kernel boot for
> me, but I am not sure if this is enough. In fact we'll need to fix
> every situation in which instrumentation code may be called with
> invalid %gs value. Do you think this is feasible? Overall, should we
> care about KMSAN working with paravirtualization?

I think XEN PV is really special, let's Cc: xen-devel@ first.

-- 
Vitaly

