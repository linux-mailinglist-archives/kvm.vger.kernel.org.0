Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2E5C51B4BF
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 02:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232603AbiEEAjG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 20:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233349AbiEEAi6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 20:38:58 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19DEBCA8
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 17:35:20 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id a191so2437072pge.2
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 17:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=nRQz+DzX5K9kDppTQd32aFWImiUIrhG8Iv4TfGIz1Rc=;
        b=vwoHc3K9L4lz5MJwN79bkZ/uCa4EG9oOxYqQbtUKeW1FwjPxOoOeTFx5S4fEODsG/x
         +iJOgku4ZcBXaAaKns+S8w2rHnxvqmS64trRCSC3VCtjfGbtYTZKR8Uq5qtSVlNXMT/l
         nr4+Z//ef9vj0gKsLMWrhIj+DfTDGt1CvvckmVD1+eyMt66njW5rMyNToZhA85xYxP34
         8/65r05qgloudy3JEWx47bK971JXZrsjaHJNaX4xsrRUTU9W88gPtvS3gnKTFpp+0Boc
         sgziKnfs504yEDtjm20HS3HMs7R59DCYpHLd56lT2iiFNZOk6vZAfU14c+WjR+boM3/G
         zLqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nRQz+DzX5K9kDppTQd32aFWImiUIrhG8Iv4TfGIz1Rc=;
        b=Oi34Xg/V5QHRQR+tFomoMWKALskW7ChnVOUZGHIycpIjLSP3wgHxxYxzIjFoGu9L3J
         Tndvg/n2ewNwykeWj2lk+nALMr8aMJ2yRJIMnkHdy2oS2Y5VyFigszUlzXR74P8K4EnE
         uA6YO20S5fctEOLxi/ZHnOCyoaSbDs4n58Ubve4hgbDKJIDIm82s6TvyuGQzOYcqZ+b9
         Xou5aUcBz5KAdf1YUNEnoNWs5xRx2tGm3BKiaewY9JNRV/74eeTlf7Nb/nuzaXjE+cMM
         DLkOA2njicLIV9665sG0jm9fH1xEo5kXXfiCecEyqqWqeVhHoLHhCT0B8UvBfCQ2AUCW
         27TA==
X-Gm-Message-State: AOAM533xJxrzIhWjO5Q75nrxYSJY7H98r42zvrMalw1jtzSyysX3n/L4
        cVyINdf2Ji0mqInAQVXqIyXJzw==
X-Google-Smtp-Source: ABdhPJznAylvSbK/9EaK3j6RyazErMteTykI6hwny76zzS8UJZdW7Ojzco34NrB02XTmN1LuJ8nizg==
X-Received: by 2002:a05:6a00:2494:b0:50d:805c:8cb7 with SMTP id c20-20020a056a00249400b0050d805c8cb7mr23701137pfv.21.1651710920276;
        Wed, 04 May 2022 17:35:20 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id t27-20020a63535b000000b003c14af50628sm15404725pgl.64.2022.05.04.17.35.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 17:35:19 -0700 (PDT)
Message-ID: <bea2e584-9528-2d97-2aa0-8936a1aff47d@kernel.dk>
Date:   Wed, 4 May 2022 18:35:18 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] entry/kvm: Exit to user mode when TIF_NOTIFY_SIGNAL is
 set
Content-Language: en-US
To:     Seth Forshee <sforshee@digitalocean.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        kvm@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
References: <20220504180840.2907296-1-sforshee@digitalocean.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220504180840.2907296-1-sforshee@digitalocean.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/4/22 12:08 PM, Seth Forshee wrote:
> A livepatch transition may stall indefinitely when a kvm vCPU is heavily
> loaded. To the host, the vCPU task is a user thread which is spending a
> very long time in the ioctl(KVM_RUN) syscall. During livepatch
> transition, set_notify_signal() will be called on such tasks to
> interrupt the syscall so that the task can be transitioned. This
> interrupts guest execution, but when xfer_to_guest_mode_work() sees that
> TIF_NOTIFY_SIGNAL is set but not TIF_SIGPENDING it concludes that an
> exit to user mode is unnecessary, and guest execution is resumed without
> transitioning the task for the livepatch.
> 
> This handling of TIF_NOTIFY_SIGNAL is incorrect, as set_notify_signal()
> is expected to break tasks out of interruptible kernel loops and cause
> them to return to userspace. Change xfer_to_guest_mode_work() to handle
> TIF_NOTIFY_SIGNAL the same as TIF_SIGPENDING, signaling to the vCPU run
> loop that an exit to userpsace is needed. Any pending task_work will be
> run when get_signal() is called from exit_to_user_mode_loop(), so there
> is no longer any need to run task work from xfer_to_guest_mode_work().

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

