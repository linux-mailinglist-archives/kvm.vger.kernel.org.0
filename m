Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24F0C38E7FD
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 15:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232851AbhEXNsQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 09:48:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45532 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232409AbhEXNsQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 09:48:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621864008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1zKaniUke1CTgDP/v1gmAVeJGY1+eRl2in4CVL6GC9M=;
        b=g2Of2tua3aM77IpHtD6M3I2+EJYR9y7g2lB7a3wciWWYCdu0E9I+NvZoZPygjIi/IwlLE9
        QxBw6XGFE3Xs/Z0r+ZGUVWZRrfxLZ63+vYCjpYt0eKU+HGvtPUaMd+81FF6B81ZzbdUSWT
        BJr9KKccXkEdOHJ5K/l1pP6vLfuMvZ0=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-DxPfuvGIOWmBbq_aDOKZMA-1; Mon, 24 May 2021 09:46:46 -0400
X-MC-Unique: DxPfuvGIOWmBbq_aDOKZMA-1
Received: by mail-ej1-f72.google.com with SMTP id m18-20020a1709062352b02903d2d831f9baso7562614eja.20
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 06:46:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1zKaniUke1CTgDP/v1gmAVeJGY1+eRl2in4CVL6GC9M=;
        b=f2zSJYdIklOLJcKNSDRomOqp5fIRfsfGp/yywRUUdgzjze9ds9mlaeRoqx9pFCaXuC
         u1uztwyz3vhozCZwJXfS8L1Pp6Q967IOPCedtA3v4Q23ZoORwhFS8wMf/2o/H8BuAf6S
         N4LdPUzaWIr3w9O7aYfOLcY6fmqDe2uyqB8wW+4IZXdVD/rxFeCdwULJM8wLeETgh7Vu
         rrzWhsQhs5TJfEow6cdHWULebsdK+cWOA+NyuH9PI3+QMcR67J9VpokonMwnyVdNh/XS
         hwDgldFiEfilGTq2BASQNtXhRb8Rt5P+NLjGRTqWTVI3scVZ6l6k27dMiHZ0JUZ6ut2l
         w55w==
X-Gm-Message-State: AOAM533aivuEKjiUxeyWdiSCxuI5e9NXNFIWkeC8dS8Wfq6Ci8M/8WLS
        KPNEK4UA8kzjBOq6FVHjEk3evWIJn9VHbzX+mEjITdBasCwHRPSsRHSbVZfdFSpOBKVuXlHNP17
        CVDt3FFfo3/fg
X-Received: by 2002:a17:906:6a93:: with SMTP id p19mr23652405ejr.319.1621864005358;
        Mon, 24 May 2021 06:46:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxL+MPEX0xHstZztgHZk1ZfQV9cHQqyq1YhQQZRhVxtKLp+Hm/Y1Lt2xqMCJwNwQrdOxuyViA==
X-Received: by 2002:a17:906:6a93:: with SMTP id p19mr23652383ejr.319.1621864005203;
        Mon, 24 May 2021 06:46:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x10sm9233166edd.30.2021.05.24.06.46.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 06:46:44 -0700 (PDT)
Subject: Re: [PATCH v4 1/5] KVM: exit halt polling on need_resched() for both
 book3s and generic halt-polling
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Ben Segall <bsegall@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>,
        David Matlack <dmatlack@google.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
References: <1621339235-11131-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f0247587-e90a-1695-1399-47a67c44d861@redhat.com>
Date:   Mon, 24 May 2021 15:46:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <1621339235-11131-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/05/21 14:00, Wanpeng Li wrote:
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
> Reviewed-by: David Matlack <dmatlack@google.com>
> Reviewed-by: Venkatesh Srinivas <venkateshs@chromium.org>
> Cc: Ben Segall <bsegall@google.com>
> Cc: Venkatesh Srinivas <venkateshs@chromium.org>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: David Matlack <dmatlack@google.com>
> Cc: Paul Mackerras <paulus@ozlabs.org>
> Cc: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v3 -> v4:
>   * rename to kvm_vcpu_can_poll
> v2 -> v3:
>   * add a helper function
> v1 -> v2:
>   * update patch description
> 
>   arch/powerpc/kvm/book3s_hv.c | 2 +-
>   include/linux/kvm_host.h     | 2 ++
>   virt/kvm/kvm_main.c          | 8 ++++++--
>   3 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 28a80d240b76..7360350e66ff 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -3936,7 +3936,7 @@ static void kvmppc_vcore_blocked(struct kvmppc_vcore *vc)
>   				break;
>   			}
>   			cur = ktime_get();
> -		} while (single_task_running() && ktime_before(cur, stop));
> +		} while (kvm_vcpu_can_poll(cur, stop));
>   
>   		spin_lock(&vc->lock);
>   		vc->vcore_state = VCORE_INACTIVE;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 2f34487e21f2..ba682f738a25 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1583,4 +1583,6 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
>   /* Max number of entries allowed for each kvm dirty ring */
>   #define  KVM_DIRTY_RING_MAX_ENTRIES  65536
>   
> +bool kvm_vcpu_can_poll(ktime_t cur, ktime_t stop);
> +
>   #endif
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 6b4feb92dc79..62522c12beba 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2945,6 +2945,11 @@ update_halt_poll_stats(struct kvm_vcpu *vcpu, u64 poll_ns, bool waited)
>   		vcpu->stat.halt_poll_success_ns += poll_ns;
>   }
>   
> +bool kvm_vcpu_can_poll(ktime_t cur, ktime_t stop)
> +{
> +	return single_task_running() && !need_resched() && ktime_before(cur, stop);
> +}
> +
>   /*
>    * The vCPU has executed a HLT instruction with in-kernel mode enabled.
>    */
> @@ -2973,8 +2978,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>   				goto out;
>   			}
>   			poll_end = cur = ktime_get();
> -		} while (single_task_running() && !need_resched() &&
> -			 ktime_before(cur, stop));
> +		} while (kvm_vcpu_can_poll(cur, stop));
>   	}
>   
>   	prepare_to_rcuwait(&vcpu->wait);
> 

Queued all five, thanks.

Paolo

