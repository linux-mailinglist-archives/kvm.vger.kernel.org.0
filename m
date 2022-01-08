Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E18E488046
	for <lists+kvm@lfdr.de>; Sat,  8 Jan 2022 02:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbiAHBGI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 20:06:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiAHBGI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jan 2022 20:06:08 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10542C061574
        for <kvm@vger.kernel.org>; Fri,  7 Jan 2022 17:06:08 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id z30so3641162pge.4
        for <kvm@vger.kernel.org>; Fri, 07 Jan 2022 17:06:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=P/JdDvFQ/rU7zLe6irNqXlDeNuS6rYc6yuVZLjuKGyc=;
        b=Gg5eWfiQzwLIDi3YoPnouPv9dHbr42UFFA0692cmMc7iSKB3cfJ5APAG23uGy/zbsp
         oya7+4PV908NfHJWxCkXmdBerdH+HzKm70zC7wBiD7lEiagilEozr/p5HxVIv0JMB9vt
         xfp8BL/sZlkI5ZvY1XM8Jj4+ooVgNxixfzOcEOuiWvDD1VZTA79hUIEOzDnjgqtGr6hZ
         hFxCBC2uNj4kC8Q3E5BaaaOPYm0J39TVtvw/a4HH6csoTDS1yZK43b7wD9i7v81Y1H47
         sYePq+D7zHxdjOge2j+M+0YN2yDtjEwxUZGKuxBuCJB1Gir0mUYamaCWzpw3NzO3l2yx
         d6aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P/JdDvFQ/rU7zLe6irNqXlDeNuS6rYc6yuVZLjuKGyc=;
        b=Wx8QRJHMYH7u4IwCV/JN03PFIs57H0h4uEcHA6Ewy/F2JrHb4xCqrrG0DCvXqckmga
         xuVpwcR+avrISfGxVZ7de58I8cNz1rT4sXByMLsYGPIsN6q92helS88mvxsrOaHmglNQ
         2BM8mr16O1z/ZcVK1BQeW1wJHo63205U5blPS1DC2F4JpiXDva0ebdx1LcNQMzmxhHg8
         mWoMJwndzSZXvI8EnfFgcOESyLVYZtEcsj0xGd24llQJ3Gm1xVZknGODr6i2cif49XiZ
         E6zKHB4AaHhMqFlzhL2Z8+1bHHXqly7SCzLUq1QrbrtGg6UcIDd2K/NpbnPLUbnd33Gq
         bIQQ==
X-Gm-Message-State: AOAM530tsLpGSk1fJ4Ma/Kxld13kWrX1rJ7Nl3cIZjMrGZBpJlcIchr3
        PWUEOpfsOMlBCyiRxG+uLRW+Lg==
X-Google-Smtp-Source: ABdhPJxZQQtD46lRS+IB/vTcxBt5snfvk4QQYFbDeXg0NYPG6jAhHnl2lRG1C3Wa5MqAPv4pOwoSvQ==
X-Received: by 2002:a63:44a:: with SMTP id 71mr57292354pge.453.1641603967292;
        Fri, 07 Jan 2022 17:06:07 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c124sm121598pfb.139.2022.01.07.17.06.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 17:06:06 -0800 (PST)
Date:   Sat, 8 Jan 2022 01:06:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v3 01/11] KVM: Capture VM start
Message-ID: <Ydjje8qBOP3zDOZi@google.com>
References: <20220104194918.373612-1-rananta@google.com>
 <20220104194918.373612-2-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220104194918.373612-2-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 04, 2022, Raghavendra Rao Ananta wrote:
> Capture the start of the KVM VM, which is basically the

Please wrap at ~75 chars.

> start of any vCPU run. This state of the VM is helpful
> in the upcoming patches to prevent user-space from
> configuring certain VM features after the VM has started
> running.

Please provide context of how the flag will be used.  I glanced at the future
patches, and knowing very little about arm, I was unable to glean useful info
about exactly who is being prevented from doing what.

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
>  	struct notifier_block pm_notifier;
>  #endif
>  	char stats_id[KVM_STATS_NAME_SIZE];
> +	bool vm_started;
>  };
>  
>  #define kvm_err(fmt, ...) \
> @@ -1666,6 +1667,8 @@ static inline bool kvm_check_request(int req, struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> +#define kvm_vm_has_started(kvm) (kvm->vm_started)

Needs parantheses around (kvm), but why bother with a macro?  This is the same
header that defines struct kvm.

> +
>  extern bool kvm_rebooting;
>  
>  extern unsigned int halt_poll_ns;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 72c4e6b39389..962b91ac2064 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3686,6 +3686,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
>  	int r;
>  	struct kvm_fpu *fpu = NULL;
>  	struct kvm_sregs *kvm_sregs = NULL;
> +	struct kvm *kvm = vcpu->kvm;

If you're going to bother grabbing kvm, replace the instances below that also do
vcpu->kvm.

>  
>  	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_dead)
>  		return -EIO;
> @@ -3723,6 +3724,14 @@ static long kvm_vcpu_ioctl(struct file *filp,
>  			if (oldpid)
>  				synchronize_rcu();
>  			put_pid(oldpid);
> +
> +			/*
> +			 * Since we land here even on the first vCPU run,
> +			 * we can mark that the VM has started running.

Please avoid "we", "us", etc..

"vm_started" is also ambiguous.  If we end up with a flag, then I would prefer a
much more literal name, a la created_vcpus, e.g. ran_vcpus or something.

> +			 */
> +			mutex_lock(&kvm->lock);

This adds unnecessary lock contention when running vCPUs.  The naive solution
would be:
			if (!kvm->vm_started) {
				...
			}

> +			kvm->vm_started = true;
> +			mutex_unlock(&kvm->lock);

Lastly, why is this in generic KVM?

>  		}
>  		r = kvm_arch_vcpu_ioctl_run(vcpu);
>  		trace_kvm_userspace_exit(vcpu->run->exit_reason, r);
> -- 
> 2.34.1.448.ga2b2bfdf31-goog
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
