Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE4F4872EF
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 07:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbiAGGHM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 01:07:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiAGGHK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jan 2022 01:07:10 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FDECC061245
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 22:07:10 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id ie13so4375459pjb.1
        for <kvm@vger.kernel.org>; Thu, 06 Jan 2022 22:07:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2q58XOryfIlXBk+Ga94YK5KAiqVRv5tmtrlFtSkfC0E=;
        b=ochKJUmv9jcYYqjl8Ri0yXzDhwacQ2/M9JFDOvS2FBy8XLGNBzhfSvKLa9ii/FgSHR
         lKXPiHPPHOi42VPVoABzyceIiJ8F+Kbs3IS0k75hH2A5mdF2XigOH5lmdKWrpcwtxdbr
         ezxvlB8NX6lqdXgr7vLxp+V4EZIGdh1LCkEFmJztS6KTyCd2fXWSEdqhhi3oBwVmS13w
         /pYkJOH9knWKKZPd/LGxDD94eatNe6H5EBW+iGlQr71hEgAmZVB6ZiK24VPUj2ooMIaj
         42ZKBZFHvnOHD474TolWmS+OmhGNji04Be9HsERGLppfG0rRjME6jGJDuXtYXGuWgZIu
         K72Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2q58XOryfIlXBk+Ga94YK5KAiqVRv5tmtrlFtSkfC0E=;
        b=8NDlb7b3He75R6Td61Dy1ylYH7ISjBiSgspclfYL//J5BnicfhzrdcSOpdjN01jkRc
         5/Kqq9S3VVMKSyi5EhRSVZSiPvHE2ycgtAXRuynEjvxUihbrESfslnurwcNseBTgl9Fo
         amM3Hp8KsY+z/nPgEDEqj2YJWAMNrfB8SG7DoahKwObWJEZnh62tUEdZIPTU3NdhM4WI
         7ym9uRqJwnzvPtqD5mu9w090ihG/akj1EnSuqiQXIOxSf5uS79U8JOiq4qCIfVYgEmC3
         ECI4xomX/HCx96RrIcs5wDatiWAXMxMv9LzU9OLYn5nhUYS64NZWUOEXNljaBgWZSb61
         yBPw==
X-Gm-Message-State: AOAM533CApPmsT9aPRJjP/N7Nf38+1FqjsSM6B9K+vtq77ogAOrO80mY
        yl1StC2TrBfNEOEGAzZoiC/2Z+IBLRTx4ZzujBiuAg==
X-Google-Smtp-Source: ABdhPJzi8RhMHj39b+4Rn0KshD189vXaFIX2vj8EwamLndmdEQUpG8o9KUsh8L5L/q0EpOVykikO8FcKUk+BveZguG8=
X-Received: by 2002:a17:902:c652:b0:148:f1a5:b7bf with SMTP id
 s18-20020a170902c65200b00148f1a5b7bfmr62134703pls.122.1641535629407; Thu, 06
 Jan 2022 22:07:09 -0800 (PST)
MIME-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com> <20220104194918.373612-2-rananta@google.com>
In-Reply-To: <20220104194918.373612-2-rananta@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Thu, 6 Jan 2022 22:06:53 -0800
Message-ID: <CAAeT=Fxyct=WLUvfbpROKwB9huyt+QdJnKTaj8c5NKk+UY51WQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 01/11] KVM: Capture VM start
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Raghu,

On Tue, Jan 4, 2022 at 11:49 AM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> Capture the start of the KVM VM, which is basically the
> start of any vCPU run. This state of the VM is helpful
> in the upcoming patches to prevent user-space from
> configuring certain VM features after the VM has started
> running.
>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  include/linux/kvm_host.h | 3 +++
>  virt/kvm/kvm_main.c      | 9 +++++++++
>  2 files changed, 12 insertions(+)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index c310648cc8f1..d0bd8f7a026c 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -623,6 +623,7 @@ struct kvm {
>         struct notifier_block pm_notifier;
>  #endif
>         char stats_id[KVM_STATS_NAME_SIZE];
> +       bool vm_started;

Since KVM_RUN on any vCPUs doesn't necessarily mean that the VM
started yet, the name might be a bit misleading IMHO.  I would
think 'has_run_once' or 'ran_once' might be more clear (?).


>  };
>
>  #define kvm_err(fmt, ...) \
> @@ -1666,6 +1667,8 @@ static inline bool kvm_check_request(int req, struct kvm_vcpu *vcpu)
>         }
>  }
>
> +#define kvm_vm_has_started(kvm) (kvm->vm_started)
> +
>  extern bool kvm_rebooting;
>
>  extern unsigned int halt_poll_ns;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 72c4e6b39389..962b91ac2064 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3686,6 +3686,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
>         int r;
>         struct kvm_fpu *fpu = NULL;
>         struct kvm_sregs *kvm_sregs = NULL;
> +       struct kvm *kvm = vcpu->kvm;
>
>         if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_dead)
>                 return -EIO;
> @@ -3723,6 +3724,14 @@ static long kvm_vcpu_ioctl(struct file *filp,
>                         if (oldpid)
>                                 synchronize_rcu();
>                         put_pid(oldpid);
> +
> +                       /*
> +                        * Since we land here even on the first vCPU run,
> +                        * we can mark that the VM has started running.
> +                        */

It might be nicer to add a comment why the code below gets kvm->lock.

Anyway, the patch generally looks good to me, and thank you
for making this change (it works for my purpose as well).

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thanks,
Reiji


> +                       mutex_lock(&kvm->lock);
> +                       kvm->vm_started = true;
> +                       mutex_unlock(&kvm->lock);
>                 }
>                 r = kvm_arch_vcpu_ioctl_run(vcpu);
>                 trace_kvm_userspace_exit(vcpu->run->exit_reason, r);
> --
> 2.34.1.448.ga2b2bfdf31-goog
>
