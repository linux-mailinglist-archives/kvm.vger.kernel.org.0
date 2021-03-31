Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1AF34FEC4
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 12:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235085AbhCaK7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 06:59:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39553 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235113AbhCaK6s (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 31 Mar 2021 06:58:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617188328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xWU5TMKCjhzVBEH8qMRMQ/zcHa91RtsSwCRdI3QSHW4=;
        b=eezDCj4N4mfNGgrVm/ej0/Xp4QQSPhiSFl3CFwVJTk5egLbLW2OVZWvlrCnNsINV0tPlL2
        yy4Etk3BHy61fA5Gnc69y22GrfnNGpqp5/5E4YtAheEwtf/cXmmO7atTfkAnvDj8gl/xs1
        0HIsnyNz7MrPFAXvmdMJLUGHDVca+7U=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-y4tMBSHHOHmew-KmkZT9xw-1; Wed, 31 Mar 2021 06:58:46 -0400
X-MC-Unique: y4tMBSHHOHmew-KmkZT9xw-1
Received: by mail-ej1-f71.google.com with SMTP id e13so607394ejd.21
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 03:58:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xWU5TMKCjhzVBEH8qMRMQ/zcHa91RtsSwCRdI3QSHW4=;
        b=UittL1xOo8FVxSlcECSyXoAKn06ouHkp4yeWv4do5GG4Dd8SyRK81e8qyOZMK2ZYoZ
         EMoO5v71ExZzbVintNkBcqSyjF58IA+eGYUilYQdlz/3u3qvFhLkemU3MPXenH/g0URa
         G9AmwQUbgPJtRIrBBLWjk/nR//N0GCU8GTsu/J6a06BjK7ygvnhlwLFeAT2t59gvjVWq
         GAyl653/6ZOWT8Du3X4nzbWA6usVhqavK8VZI5fDmPSDEJuArsNZ6k1drFLMYdg+0Tgy
         tKtRkCShqI2XyiIxuIIzE9hj3HNEJlSulV36vSkfKT9pxsZXyDfRo42Ypsu35A5nmNrY
         kJlg==
X-Gm-Message-State: AOAM530XIYZRuZ23txSfBAziJzD+DxfOFeBuoJqnjs15yCL2dRGiMkSb
        fk861iiJw3c0Or97+8zshPDQlQof5EjU4kyORf3gvfMEf6+HihUGjEQBw/lnXIHp+NXJaZfJ9hz
        yY6gRr2OVuo6W
X-Received: by 2002:a17:906:f0c8:: with SMTP id dk8mr2886566ejb.300.1617188325281;
        Wed, 31 Mar 2021 03:58:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwC4DVCQ5zAoVUBlqhYUB60RzKONa5jzI6wIXVgLfsl+qRAw4oEVA4ohMWyi771lhN1AsQsTQ==
X-Received: by 2002:a17:906:f0c8:: with SMTP id dk8mr2886553ejb.300.1617188325064;
        Wed, 31 Mar 2021 03:58:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id a22sm1265537edu.14.2021.03.31.03.58.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Mar 2021 03:58:43 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] KVM: x86: hyper-v: Properly divide maybe-negative
 'hv_clock->system_time' in compute_tsc_page_parameters()
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
References: <20210329114800.164066-1-vkuznets@redhat.com>
 <20210329114800.164066-2-vkuznets@redhat.com>
 <20210330131236.GA5932@fuller.cnet> <87ft0cu2eq.fsf@vitty.brq.redhat.com>
 <4d7f375c-c912-fbeb-edd1-03d742d49dcb@redhat.com>
 <87a6qju97s.fsf@vitty.brq.redhat.com>
 <7c6f61e9-f2a6-46dc-7ab6-dc6ae86c7b60@redhat.com>
 <871rbvtzi8.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <de306f6d-6a64-b340-4d76-a51fbde8d2de@redhat.com>
Date:   Wed, 31 Mar 2021 12:58:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <871rbvtzi8.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/03/21 11:59, Vitaly Kuznetsov wrote:
> Paolo Bonzini <pbonzini@redhat.com> writes:
>> On 31/03/21 08:29, Vitaly Kuznetsov wrote:
>>> I'm leaning towards making a v3 and depending on how complex it's going
>>> to look like we can decide which way to go.
> 
> Ok, I convinced myself this is correct:
> 
> @@ -5744,8 +5745,22 @@ long kvm_arch_vm_ioctl(struct file *filp,
>                   * pvclock_update_vm_gtod_copy().
>                   */
>                  kvm_gen_update_masterclock(kvm);
> -               now_ns = get_kvmclock_ns(kvm);
> -               kvm->arch.kvmclock_offset += user_ns.clock - now_ns;
> +
> +               /*
> +                * This pairs with kvm_guest_time_update(): when masterclock is
> +                * in use, we use master_kernel_ns + kvmclock_offset to set
> +                * unsigned 'system_time' so if we use get_kvmclock_ns() (which
> +                * is slightly ahead) here we risk going negative on unsigned
> +                * 'system_time' when 'user_ns.clock' is very small.
> +                */
> +               spin_lock(&ka->pvclock_gtod_sync_lock);
> +               if (kvm->arch.use_master_clock)
> +                       now_ns = ka->master_kernel_ns;
> +               else
> +                       now_ns = get_kvmclock_base_ns();
> +               ka->kvmclock_offset = user_ns.clock - now_ns;
> +               spin_unlock(&ka->pvclock_gtod_sync_lock);
> +
>                  kvm_make_all_cpus_request(kvm, KVM_REQ_CLOCK_UPDATE);
>                  break;
>          }
> 
> In !masterclock case kvm_guest_time_update() uses get_kvmclock_base_ns()
> (and get_kvmclock_ns() is just get_kvmclock_base_ns() + ka->kvmclock_offset)
> so we're good. Also, it looks like a good idea to put the whole
> calculation under spinlock here.

Yes, sounds good.

Note that I posted a series that changes pvclock_gtod_sync_lock to use 
spin_lock_irqsave/spin_unlock_irqrestore, so please base your patch on 
those and switch to spin_lock_irq.

Paolo

