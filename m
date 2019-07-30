Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7567F7B324
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 21:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387682AbfG3TU2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 15:20:28 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40669 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbfG3TU2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 15:20:28 -0400
Received: by mail-wr1-f67.google.com with SMTP id r1so66957360wrl.7
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 12:20:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/2TgMA0mYoYMd5S0AGn7Pqo7CSYyTHhdztpWfXjyaM0=;
        b=W5BaLLsAfcrvvZeF5FEsQbS1M+gjDVGt+QjRrklm1cZVfEoSrZUEknQznwBD5WF9Wt
         NdLFplxLDMe4etdNCrW+q61RIlLO4n7GL1DcL4oAWSC/bAcULIXehzelFevI2BiSMW3P
         yhdFEy+y+gM1C/BKJAeHgwsyhJisK2wQxp3yVm/RjoYweYgKdIbJFQ4sUhUmfHvA0mNS
         piTBOu5Z+X1GGP5xz0Ce4WEufLSYtBa063FdkKr6FSPBVyO+H1bqMpgY5EwVkrTY2dmJ
         +bwv/prYtqRMKOlY0KTR4u33L0rScCnNfsXnyH9Ikfnyj6ymy8CGAJUo39TPTXzXb9/g
         Xxkg==
X-Gm-Message-State: APjAAAX4etLOb0LaLNaJ6rOZYqCUtSkjWFCFFsp3UTclpofvF6MPtpWy
        udDgLKa6I3jvHHSg2OY+98CukA==
X-Google-Smtp-Source: APXvYqxQc619Ttv8elSAbEScDJ0KLNuX3zpIM7M/dRaGKaHkghb51Vn3myAbx5BxOfb/n77rj0R3Rg==
X-Received: by 2002:adf:eacf:: with SMTP id o15mr7061714wrn.171.1564514426019;
        Tue, 30 Jul 2019 12:20:26 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:29d3:6123:6d5f:2c04? ([2001:b07:6468:f312:29d3:6123:6d5f:2c04])
        by smtp.gmail.com with ESMTPSA id b15sm81335227wrt.77.2019.07.30.12.20.24
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 12:20:25 -0700 (PDT)
Subject: Re: [PATCH 3/3] i386/kvm: initialize struct at full before ioctl call
To:     Andrey Shinkevich <andrey.shinkevich@virtuozzo.com>,
        qemu-devel@nongnu.org, qemu-block@nongnu.org
Cc:     kvm@vger.kernel.org, berto@igalia.com, mdroth@linux.vnet.ibm.com,
        armbru@redhat.com, ehabkost@redhat.com, rth@twiddle.net,
        mtosatti@redhat.com, den@openvz.org, vsementsov@virtuozzo.com,
        Christian Borntraeger <borntraeger@de.ibm.com>
References: <1564502498-805893-1-git-send-email-andrey.shinkevich@virtuozzo.com>
 <1564502498-805893-4-git-send-email-andrey.shinkevich@virtuozzo.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <14b60c5b-6ed4-0f4d-17a8-6ec861115c1e@redhat.com>
Date:   Tue, 30 Jul 2019 21:20:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1564502498-805893-4-git-send-email-andrey.shinkevich@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/07/19 18:01, Andrey Shinkevich wrote:
> Not the whole structure is initialized before passing it to the KVM.
> Reduce the number of Valgrind reports.
> 
> Signed-off-by: Andrey Shinkevich <andrey.shinkevich@virtuozzo.com>

Christian, is this the right fix?  It's not expensive so it wouldn't be
an issue, just checking if there's any better alternative.

Paolo

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
>      msr_data.info.nmsrs = 1;
>      msr_data.entries[0].index = MSR_IA32_TSC;
>      env->tsc_valid = !runstate_is_running();
> @@ -1706,6 +1707,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
>  
>      if (has_xsave) {
>          env->xsave_buf = qemu_memalign(4096, sizeof(struct kvm_xsave));
> +        memset(env->xsave_buf, 0, sizeof(struct kvm_xsave));
>      }
>  
>      max_nested_state_len = kvm_max_nested_state_length();
> @@ -3477,6 +3479,7 @@ static int kvm_put_debugregs(X86CPU *cpu)
>          return 0;
>      }
>  
> +    memset(&dbgregs, 0, sizeof(dbgregs));
>      for (i = 0; i < 4; i++) {
>          dbgregs.db[i] = env->dr[i];
>      }
> -- 
> 1.8.3.1
> 


