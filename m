Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D59C176268
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 19:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbgCBSWN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 13:22:13 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56861 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726451AbgCBSWN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Mar 2020 13:22:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583173332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ih5//RAv6LhCAV7ANNWMSlbgMbwpFxJEPQWnbvDX1pk=;
        b=bN5i+rDRRehkh6Ub9LLvs7GniUBaTvaMvyCIXVrfio8rZEHSNUGYEuyw34Hru5jmEOiejA
        y3RMBqcGnzNLf+vpX94ooMCflne/uh9idDqPW/RkKMMLRcaY9YzQrV0FhhXwJBa9vjl6Q8
        R70pDOHF6wgCm89qig/2WYtpRGgM/50=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73-nrdEyi_9Ns-PXnBHF-Bodg-1; Mon, 02 Mar 2020 13:22:11 -0500
X-MC-Unique: nrdEyi_9Ns-PXnBHF-Bodg-1
Received: by mail-wr1-f71.google.com with SMTP id w6so59762wrm.16
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2020 10:22:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ih5//RAv6LhCAV7ANNWMSlbgMbwpFxJEPQWnbvDX1pk=;
        b=Bpo/bRH88mHRnNz9Wps/y06SqkKdZaLowGde+LwoNZ9QVNUc9CSnMrjqiYYK6xPWi4
         vyN+E0KYA/42iaCHoJeNFlihWhGZMsI0AQoJLGi0JBE2eBD0Jc+5Yg+UteWXIi7Tvg5u
         Hn5KDa8zCr2e31LnAyNfwVTwE2AaY838IPwwtLfK1w3J8+sL+ZT1Of0H8yEqNepjfUuC
         tjtdJBoWIUMJYh82EZPi11urubdDOmCtaliN5cifwyTNTm2W1Ax2wdUgtHQZB4cmN0Yq
         O1gn78NNox3s6iAMIyNxRdeUbtokPDiTjYLvAmv1qPIg6OgSeN/FqyJXPb0jdOcXrttX
         eGWA==
X-Gm-Message-State: ANhLgQ1u8WRRanc+Cni6IngvIt2Lnuwe8/Xkj5MSxl7suww7yeUQPvq4
        CHdH7OM0SMQ43jeuVejvxecCXMBcwy6QSl949Fg29qxgzXpcht75qFB50NaUXmlqLh43jRclKX/
        c+O9FNRzv1AvH
X-Received: by 2002:a1c:cc06:: with SMTP id h6mr40737wmb.118.1583173330032;
        Mon, 02 Mar 2020 10:22:10 -0800 (PST)
X-Google-Smtp-Source: ADFU+vs9ZQ2SoIISj8TdDsBbhc3slcREpZ8XKsZ1xcKoa/2yEi4GDeN1FpR2ke/iKZ7ArhjCgTZ7JA==
X-Received: by 2002:a1c:cc06:: with SMTP id h6mr40717wmb.118.1583173329766;
        Mon, 02 Mar 2020 10:22:09 -0800 (PST)
Received: from [192.168.178.40] ([151.30.85.6])
        by smtp.gmail.com with ESMTPSA id a184sm346359wmf.29.2020.03.02.10.22.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 10:22:09 -0800 (PST)
Subject: Re: [PATCH v3] KVM: X86: Just one leader to trigger kvmclock sync
 request
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <1582859921-11932-1-git-send-email-wanpengli@tencent.com>
 <87lfoihpwt.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f0fe943d-bdd0-1150-6d22-e7e48416da6d@redhat.com>
Date:   Mon, 2 Mar 2020 19:22:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <87lfoihpwt.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/03/20 14:01, Vitaly Kuznetsov wrote:
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9389,11 +9389,9 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
>  
>         mutex_unlock(&vcpu->mutex);
>  
> -       if (!kvmclock_periodic_sync)
> -               return;
> -
> -       schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
> -                                       KVMCLOCK_SYNC_PERIOD);
> +       if (vcpu->vcpu_idx == 0 && kvmclock_periodic_sync)
> +               schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
> +                                     KVMCLOCK_SYNC_PERIOD);
>  }

> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Good idea, I squashed the change.

Paolo

