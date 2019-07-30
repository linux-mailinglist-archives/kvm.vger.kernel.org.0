Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0597AE4B
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 18:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729438AbfG3QpD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 12:45:03 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34671 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729426AbfG3QpC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 12:45:02 -0400
Received: by mail-wr1-f66.google.com with SMTP id 31so66558277wrm.1
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 09:45:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=44PWnsZlugzoF8OgUVXZACuqPGycODVBbu6h4inAI8o=;
        b=lJvmhurF89j4h6J9MivgJvIszWvc2QsfdrU0kFqgYd9EzZNin9GqquxSFl1C5CYUIt
         iPVLNRmJZsUQZ9jM5lp9+DKfbyptC1LPlS7oUxmXl+TeGUhhBer3b0wC0TrxIfYTo09U
         lqkfKQorhhWBoDGBp17wZbKU+OQKzeK4agAOjh0pLMFEsWpleAY7YHaUONyjpZaDs4ds
         8uAfbsEVRMblSyG7ZZTbveUa/Qn05QAkFXxZPbLBXeiaxpU4up8ycpp5zHX91kapTcvy
         vxioCwC3sYvn3y9SlGCYZ6RzQc/zJdDRbYLlTLA8YeC2wAzSkbgk/CYsLBG+iIXEdAGo
         GSCQ==
X-Gm-Message-State: APjAAAWYvlSHqmZe7TXDjvwvwqLqC0lTYOhPF4zMHzy9ZmxyMEimoPBH
        jE3E36BbVaprp4S8/mceJNAARQ==
X-Google-Smtp-Source: APXvYqyxNaQbCpzEb+xWh4DJMWsbihpOAJ8VYcDfTamWG5R6SzfItdFfDyhi3S+O1mCc7qBb9fVfJQ==
X-Received: by 2002:a5d:628d:: with SMTP id k13mr1679873wru.69.1564505099684;
        Tue, 30 Jul 2019 09:44:59 -0700 (PDT)
Received: from [192.168.43.238] (63.red-95-127-155.staticip.rima-tde.net. [95.127.155.63])
        by smtp.gmail.com with ESMTPSA id k124sm107600279wmk.47.2019.07.30.09.44.58
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 09:44:59 -0700 (PDT)
Subject: Re: [Qemu-devel] [PATCH 3/3] i386/kvm: initialize struct at full
 before ioctl call
To:     Andrey Shinkevich <andrey.shinkevich@virtuozzo.com>,
        qemu-devel@nongnu.org, qemu-block@nongnu.org
Cc:     vsementsov@virtuozzo.com, berto@igalia.com, ehabkost@redhat.com,
        kvm@vger.kernel.org, mtosatti@redhat.com,
        mdroth@linux.vnet.ibm.com, armbru@redhat.com, den@openvz.org,
        pbonzini@redhat.com, rth@twiddle.net
References: <1564502498-805893-1-git-send-email-andrey.shinkevich@virtuozzo.com>
 <1564502498-805893-4-git-send-email-andrey.shinkevich@virtuozzo.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Openpgp: id=89C1E78F601EE86C867495CBA2A3FD6EDEADC0DE;
 url=http://pgp.mit.edu/pks/lookup?op=get&search=0xA2A3FD6EDEADC0DE
Message-ID: <7a78ef04-4120-20d9-d5f4-6572c5676344@redhat.com>
Date:   Tue, 30 Jul 2019 18:44:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1564502498-805893-4-git-send-email-andrey.shinkevich@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/30/19 6:01 PM, Andrey Shinkevich wrote:
> Not the whole structure is initialized before passing it to the KVM.
> Reduce the number of Valgrind reports.
> 
> Signed-off-by: Andrey Shinkevich <andrey.shinkevich@virtuozzo.com>
> ---
>  target/i386/kvm.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index dbbb137..ed57e31 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -190,6 +190,7 @@ static int kvm_get_tsc(CPUState *cs)
>          return 0;
>      }
>  
> +    memset(&msr_data, 0, sizeof(msr_data));

I wonder the overhead of this one...

>      msr_data.info.nmsrs = 1;
>      msr_data.entries[0].index = MSR_IA32_TSC;
>      env->tsc_valid = !runstate_is_running();
> @@ -1706,6 +1707,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
>  
>      if (has_xsave) {
>          env->xsave_buf = qemu_memalign(4096, sizeof(struct kvm_xsave));
> +        memset(env->xsave_buf, 0, sizeof(struct kvm_xsave));

OK

>      }
>  
>      max_nested_state_len = kvm_max_nested_state_length();
> @@ -3477,6 +3479,7 @@ static int kvm_put_debugregs(X86CPU *cpu)
>          return 0;
>      }
>  
> +    memset(&dbgregs, 0, sizeof(dbgregs));

OK

>      for (i = 0; i < 4; i++) {
>          dbgregs.db[i] = env->dr[i];
>      }

We could remove 'dbgregs.flags = 0;'

Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>
