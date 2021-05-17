Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C80B3383A7D
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 18:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236764AbhEQQvP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 12:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240906AbhEQQvE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 12:51:04 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35499C075389
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 09:35:04 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id z1so6680852ils.0
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 09:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8XjCzUGwVIiP3+YZrLjLAcXTaHRHGnoKVgLiqwR9S0M=;
        b=Q6bRC7J4OtYLgKndA++vo/4BHK+kvEiFv6aZ8jWWH77vI3wtldPu8UuBa/t1erlYQM
         T9idF8OhWYtD4zivdzckr+jwdarqAhWdL9CsBic6mokrIQJq4owNlFkKFmTYWAlWgF1S
         buzzozZu0YuX24RDIBlPoWalnO7Y8mpaLV+LZ4JC7Z7vgp4pk/rjuft2exRvDVyZo05N
         UnayAVciQIo5al9hYnYbt+HnJkklbO7h56O5J6IZfcUnUGM0hJMghwzRvT0ezkG8wAUU
         1Q8Is/HVfDrTV5SZUAMLudhbv00hpSn56L6Tm7auH3RSOIUMUJLNHSv9g6ASVHr+kh0D
         88HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8XjCzUGwVIiP3+YZrLjLAcXTaHRHGnoKVgLiqwR9S0M=;
        b=iDdndN18Q/6PpxOg35YZuNf8Vf3CioAX7KNCEDpuA3BN+eMwLL1VsrhBUX0l/0h2iK
         fHfv8I0yIUsIqbRmLXybldDznID6jwLfvorgmcctz/MBtOxV/2n/YX4BzFcChs/FwwwV
         0tFZ5gak1ewLi/tJ/kGnaz4KwU5SRBuT2b8UKz2tOMLUuI+pfJtQtg3OLzpeSvz+79hv
         Wb6yzC/h/DzOiVRatOq4SlVnNHRrPu3hgJ8reze8zD8zgODEzYHmSyYzbKL+7ILsvAoJ
         NMkwWgrEfFetBtAM02KKqWdxeHMWW7sG1/AnqOaSkBEE8hrZVr9wNP9tjecqraecjKbN
         +yQw==
X-Gm-Message-State: AOAM531ntT2j6ZHebMuKIm6PTbN0rxpXI6NHogE/Z7bSPqbG5Jf2MFUI
        E+uuYpVqKaVhZC5VYOM72Xj4rpdovTJ1VVTdKk+DGQ==
X-Google-Smtp-Source: ABdhPJz0NB7vJP6/zgoqy7G+HsgYZlposuUO5ZTrETUd2kYON8RUI88LoaUUJPMRD7ZtJUnnXCq7UIfwvLcbolZTWsY=
X-Received: by 2002:a92:cda5:: with SMTP id g5mr457366ild.245.1621269303543;
 Mon, 17 May 2021 09:35:03 -0700 (PDT)
MIME-Version: 1.0
References: <1621260028-6467-1-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1621260028-6467-1-git-send-email-wanpengli@tencent.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 17 May 2021 09:34:38 -0700
Message-ID: <CALzav=c+=Bi5HeuYfYKi3FRB6V88o7hCsGbgG+x3a4Mf3e9nVA@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] KVM: exit halt polling on need_resched() for both
 book3s and generic halt-polling
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Ben Segall <bsegall@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 17, 2021 at 7:01 AM Wanpeng Li <kernellwp@gmail.com> wrote:
>
> From: Wanpeng Li <wanpengli@tencent.com>
>
> Inspired by commit 262de4102c7bb8 (kvm: exit halt polling on need_resched()
> as well), CFS_BANDWIDTH throttling will use resched_task() when there is just
> one task to get the task to block. It was likely allowing VMs to overrun their
> quota when halt polling. Due to PPC implements an arch specific halt polling
> logic, we should add the need_resched() checking there as well. This
> patch adds a helper function that to be shared between book3s and generic
> halt-polling loop.
>
> Cc: Ben Segall <bsegall@google.com>
> Cc: Venkatesh Srinivas <venkateshs@chromium.org>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: David Matlack <dmatlack@google.com>
> Cc: Paul Mackerras <paulus@ozlabs.org>
> Cc: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
> v2 -> v3:
>  * add a helper function
> v1 -> v2:
>  * update patch description
>
>  arch/powerpc/kvm/book3s_hv.c | 2 +-
>  include/linux/kvm_host.h     | 2 ++
>  virt/kvm/kvm_main.c          | 9 +++++++--
>  3 files changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 28a80d240b76..360165df345b 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -3936,7 +3936,7 @@ static void kvmppc_vcore_blocked(struct kvmppc_vcore *vc)
>                                 break;
>                         }
>                         cur = ktime_get();
> -               } while (single_task_running() && ktime_before(cur, stop));
> +               } while (kvm_vcpu_can_block(cur, stop));
>
>                 spin_lock(&vc->lock);
>                 vc->vcore_state = VCORE_INACTIVE;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 2f34487e21f2..bf4fd60c4699 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1583,4 +1583,6 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
>  /* Max number of entries allowed for each kvm dirty ring */
>  #define  KVM_DIRTY_RING_MAX_ENTRIES  65536
>
> +bool kvm_vcpu_can_block(ktime_t cur, ktime_t stop);
> +
>  #endif
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 6b4feb92dc79..c81080667fd1 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2945,6 +2945,12 @@ update_halt_poll_stats(struct kvm_vcpu *vcpu, u64 poll_ns, bool waited)
>                 vcpu->stat.halt_poll_success_ns += poll_ns;
>  }
>
> +
> +bool kvm_vcpu_can_block(ktime_t cur, ktime_t stop)

nit: kvm_vcpu_can_poll() would be a more accurate name for this function.

> +{
> +       return single_task_running() && !need_resched() && ktime_before(cur, stop);
> +}
> +
>  /*
>   * The vCPU has executed a HLT instruction with in-kernel mode enabled.
>   */
> @@ -2973,8 +2979,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>                                 goto out;
>                         }
>                         poll_end = cur = ktime_get();
> -               } while (single_task_running() && !need_resched() &&
> -                        ktime_before(cur, stop));
> +               } while (kvm_vcpu_can_block(cur, stop));
>         }
>
>         prepare_to_rcuwait(&vcpu->wait);
> --
> 2.25.1
>
