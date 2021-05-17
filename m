Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33AA383BFD
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 20:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244029AbhEQSOe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 14:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236964AbhEQSOe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 14:14:34 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE6EC061573
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 11:13:17 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id t4-20020a05683014c4b02902ed26dd7a60so6351771otq.7
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 11:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EfKCKWBlWMB6WX2+gtYhC171DsA3+5IpegRuV4Mh9HU=;
        b=Dc8Fi3CxSz/2Frmp7p/Ljzs3veaW9TpCZJGgQ4e6DcOz+Fqyg3dNGp8K0JmlghN9fC
         rV0WWGPTdqxPArPg6Qro/+2M+bLWTmATE+NM9MXiBcfNtkpzMD0jtD+r4IPiWZiHZtJx
         QJ0EFp6RkY5XHBuNFWud3yVeiF/7o9S/SCytM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EfKCKWBlWMB6WX2+gtYhC171DsA3+5IpegRuV4Mh9HU=;
        b=q5HkyRmOfKfI6NpxeGkxptD7c+s87sp5v6tUZDxqMuNQJDj8wlGEwx73hvYphVoAe1
         Ridab2bIdoU6X+YH97+2GdMUMieesUkLOhWl0CNPaddi4OIYI+2Pm0v35tIoQrjtxHEU
         0zSiEkITDsUb7IctYgMuWQp7kH/IwBlgYEwpKDMJpzNQjJfgZ9dDrJ6Kp12tvyTcNnjn
         xfFpKh0Q80zQZ3Bfjs0KyM/SVhXxfEZI+ppHRbi5GJyzqEAAmIcMRzyZmqzzE276Unp1
         4PkOqRoo+dc9lcUvUUxTAUy02WJ64DfAAPTVFIqccBjdGpqdOctDL4iDExjuucRlj4NT
         RFpg==
X-Gm-Message-State: AOAM530lXZvXAcT1QMQoRE8dn95pAUiVJCs20eixgM62oOR+9sdPzHUQ
        8BrYVf7NuuqDXnR7C0/2vnPrg4OKzoU5vTTBMwJxPA==
X-Google-Smtp-Source: ABdhPJxRcZ4Th/QCihyaKvX4fEEMVd/QmFmnKjGIk2Ki7mLJyY7rABhu90g+mCaVb3F1SP3ncmyWmKMpUNLwJTq4bH8=
X-Received: by 2002:a9d:2966:: with SMTP id d93mr743560otb.56.1621275196944;
 Mon, 17 May 2021 11:13:16 -0700 (PDT)
MIME-Version: 1.0
References: <1621260028-6467-1-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1621260028-6467-1-git-send-email-wanpengli@tencent.com>
From:   Venkatesh Srinivas <venkateshs@chromium.org>
Date:   Mon, 17 May 2021 11:13:23 -0700
Message-ID: <CAA0tLEqeAK76CcyMHkARGFvXsYxLnzm75aUm7bGaoQn939MfvA@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] KVM: exit halt polling on need_resched() for both
 book3s and generic halt-polling
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Ben Segall <bsegall@google.com>,
        David Matlack <dmatlack@google.com>,
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

Reviewed-by: Venkatesh Srinivas <venkateshs@chromium.org>
