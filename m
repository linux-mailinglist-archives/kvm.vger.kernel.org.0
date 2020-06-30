Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 941D420F808
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 17:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389305AbgF3POD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jun 2020 11:14:03 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:20710 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389252AbgF3POB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Jun 2020 11:14:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593530040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZKG9midKxWXapiyhsCNvJA81s4+MOL+9sOnG0fsdr5k=;
        b=fV9N6K4de3YD4mme2gOQ7N/HzlFz29P1kIOZ1nwnIQ3q6N3izRpvJUOg7ooDDBLoADWXvl
        NVS3ioAAQ4mfg36th1VwYNz1e8bfDJHPbElqWDW4MNR1adTd9Y90GUwozrXAY2uYI9d7JM
        X6YDbqizUizjeaSFTzJaEmDPajq+ROI=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-3HnzdFKcPQyGyLkBLV96Vw-1; Tue, 30 Jun 2020 11:13:58 -0400
X-MC-Unique: 3HnzdFKcPQyGyLkBLV96Vw-1
Received: by mail-ej1-f71.google.com with SMTP id b24so13200611ejb.8
        for <kvm@vger.kernel.org>; Tue, 30 Jun 2020 08:13:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ZKG9midKxWXapiyhsCNvJA81s4+MOL+9sOnG0fsdr5k=;
        b=A6jOP6/LRfPfJo9wWsOjNYgSyJk9/ucQQR+fgqCwxpGBUmR1BCHtSMmA73UE5baoPp
         Ztkhht04tNUcYIKX8T0ha3spKfF/LBwB6NeTaAl1hJhl2SqfN7JUePjdYyRD1GCW/6bR
         4Ypuk2pnNCQqQcC7D9c8mpW/6u3ldgUD8fCWxGYXqJGgfM2TAPtPRojnnOqM5D7hYF2L
         bDTl0DyBmyTMvbrLeFtKGM0yC3D7MGoXkLRD8ppyK4Yet16EtvKryQnrI0CIb6Ib24QK
         GL2kjyOYFZPdAMqscm6b+LE1Z/xm9cnY9ClWdSsOwGVuvM5PzL2VN+0XrLego8OwbpHv
         Yh6A==
X-Gm-Message-State: AOAM531QnxDJEpT5ygmQm6bKY5Q/CMt96Hpa3q3/pxIvaYpOaA+b+W3O
        Ni3g2MCfSut9Q48xPBt2fYMOPJAeHpYqK8C84RG8qB/5fRRwTuV3Q5wKq+zJCEAtreowD8wgnzW
        hwqqPYzMPKvO4
X-Received: by 2002:a17:906:4b59:: with SMTP id j25mr14217935ejv.301.1593530037379;
        Tue, 30 Jun 2020 08:13:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxWJGag6axKV5Mjrjn/LOB60MJyVmX4lA/dZrG+9uiRT0JIT08wQCFip7z0Hgpd36tFz9mSqQ==
X-Received: by 2002:a17:906:4b59:: with SMTP id j25mr14217917ejv.301.1593530037138;
        Tue, 30 Jun 2020 08:13:57 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id w24sm3145277edt.28.2020.06.30.08.13.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 08:13:55 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     kvm@vger.kernel.org, virtio-fs@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] kvm,x86: Exit to user space in case of page fault error
In-Reply-To: <20200630145303.GB322149@redhat.com>
References: <20200625214701.GA180786@redhat.com> <87lfkach6o.fsf@vitty.brq.redhat.com> <20200626150303.GC195150@redhat.com> <874kqtd212.fsf@vitty.brq.redhat.com> <20200629220353.GC269627@redhat.com> <87sgecbs9w.fsf@vitty.brq.redhat.com> <20200630145303.GB322149@redhat.com>
Date:   Tue, 30 Jun 2020 17:13:54 +0200
Message-ID: <87mu4kbn7x.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Tue, Jun 30, 2020 at 03:24:43PM +0200, Vitaly Kuznetsov wrote:

>> 
>> It's probably me who's missing something important here :-) but I think
>> you describe how it *should* work as I'm not seeing how we can leave the
>> loop in kvm_async_pf_task_wait_schedule() other than by 
>> "if (hlist_unhashed(&n.link)) break;" and this only happens when APF
>> completes.
>
> We don't leave loop in kvm_async_pf_task_wait_schedule(). It will happen
> before you return to user space.
>
> I have not looked too closely but I think following code path might be taken
> after aync PF has completed.
>
> __kvm_handle_async_pf()
>   idtentry_exit_cond_rcu()
>     prepare_exit_to_usermode()
>       __prepare_exit_to_usermode()
>         exit_to_usermode_loop()
> 	  do_signal()
>
> So once you have been woken up (because APF completed),

Ah, OK so we still need to complete APF and we can't kill the process
before this happens, that's what I was missing.

>  you will
> return to user space and before that you will check if there are
> pending signals and handle that signal first before user space
> gets a chance to run again and retry faulting instruction.

...

>
>> 
>> When guest receives the 'page ready' event with an error it (like for
>> every other 'page ready' event) tries to wake up the corresponding
>> process but if the process is dead already it can do in-kernel probing
>> of the GFN, this way we guarantee that the error is always injected. I'm
>> not sure if it is needed though but in case it is, this can be a
>> solution. We can add a new feature bit and only deliver errors when the
>> guest indicates that it knows what to do with them.
>
> - Process will be delivered singal after async PF completion and during
>   returning to user space. You have lost control by then.
>

So actually there's no way for kernel to know if the userspace process
managed to re-try the instruction and get the error injected or if it
was killed prior to that.

> - If you retry in kernel, we will change the context completely that
>   who was trying to access the gfn in question. We want to retain
>   the real context and retain information who was trying to access
>   gfn in question.

(Just so I understand the idea better) does the guest context matter to
the host? Or, more specifically, are we going to do anything besides
get_user_pages() which will actually analyze who triggered the access
*in the guest*?

-- 
Vitaly

