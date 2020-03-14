Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD71E1859B4
	for <lists+kvm@lfdr.de>; Sun, 15 Mar 2020 04:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbgCODfX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Mar 2020 23:35:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41058 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726643AbgCODfV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Mar 2020 23:35:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584243320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0LyD0PJgIGGLoQzoojfk9tWf5U8ULkM9R+XCQsoyJqs=;
        b=RqqPZTQVjg390cDJb3QMUqUizuBobFPD2UFO9LMrPVFF+O9XBo5/DzKF5sP5hHK5uXZrPP
        KX/ErysS+fmSAIFCCQG1Xn9NmKwdtk7kMJEQMyunWPlU6d7C7IHg2hUzTSdfmIjjEPmHTp
        QhvUx45rgloTX9Z/IDH2BZCJwAjwTWk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-pqxPpuewOM6HOKSrcMzCHw-1; Sat, 14 Mar 2020 07:31:31 -0400
X-MC-Unique: pqxPpuewOM6HOKSrcMzCHw-1
Received: by mail-wm1-f70.google.com with SMTP id p4so3944335wmp.0
        for <kvm@vger.kernel.org>; Sat, 14 Mar 2020 04:31:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0LyD0PJgIGGLoQzoojfk9tWf5U8ULkM9R+XCQsoyJqs=;
        b=SD7/80wleqZIOByZzyX/Q/P+LQVVUOdbrMAfCGQzuDBaT40AyGHm81j6kKouvUG9t7
         FAlw/PG+QzpTO+RWHMdk1zRZYi83bmA930+PQDFWgbUQFEAneXIaV+57IW6AmiaH7OUU
         t4TOjeACm6Ru6qG37d2Hk7cOJCKi3fRcr4iI9rPLaPlsi1/s014eKIIqiEQjcWfFqtRT
         bn1ZD+HMSzAl2A26kpwEu7u4Olo8Ep7P1OgLKzq/CNcaQuWWoLZx+TtVXHRJbg/af49d
         5kC3O5rzdx4Euzl3ZJY+70l94SdVrXX0WxtnTh/nSleFZoBFX2jJU7vxFuWn7d6paLkB
         DqiA==
X-Gm-Message-State: ANhLgQ0/sy9GqD1FrtQ3ytS26cSWiVPtCULOlOeYr0b5R5GcB8bHq8UM
        GzSTBwH5qYA/aH+LE89i68FogpfRHJg4G3TM6imCqDH0276CyTFh9BxcQYq1FB2FcjZOmeCVnpa
        Mmm0lzKG2/y6d
X-Received: by 2002:a1c:23d5:: with SMTP id j204mr16789902wmj.59.1584185490041;
        Sat, 14 Mar 2020 04:31:30 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vs7P00MYsmC+SvAzqAncBQeg6TZFVmmUDSznYiD+XlMbi+A+TDwdXXwziZQe0yzu+wo3xeiRA==
X-Received: by 2002:a1c:23d5:: with SMTP id j204mr16789874wmj.59.1584185489799;
        Sat, 14 Mar 2020 04:31:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7de8:5d90:2370:d1ac? ([2001:b07:6468:f312:7de8:5d90:2370:d1ac])
        by smtp.gmail.com with ESMTPSA id y3sm47966512wrm.46.2020.03.14.04.31.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Mar 2020 04:31:29 -0700 (PDT)
Subject: Re: [PATCH] KVM: X86: avoid meaningless kvm_apicv_activated() check
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        linmiaohe <linmiaohe@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
References: <1582597279-32297-1-git-send-email-linmiaohe@huawei.com>
 <87d0a2n8g9.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7c0aedea-36dc-bd84-b7ba-1aa6d1cceb11@redhat.com>
Date:   Sat, 14 Mar 2020 12:31:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <87d0a2n8g9.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/02/20 13:43, Vitaly Kuznetsov wrote:
> If I'm not mistaken, the logic this function was supposed to implement
> is: change the requested bit to the requested state and, if
> kvm_apicv_activated() changed (we set the first bit or cleared the
> last), proceed with KVM_REQ_APICV_UPDATE. What if we re-write it like
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2103101eca78..b97b8ff4a789 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8027,19 +8027,19 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_update_apicv);
>   */
>  void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
>  {
> +       bool apicv_was_activated = kvm_apicv_activated(kvm);
> +
>         if (!kvm_x86_ops->check_apicv_inhibit_reasons ||
>             !kvm_x86_ops->check_apicv_inhibit_reasons(bit))
>                 return;
>  
> -       if (activate) {
> -               if (!test_and_clear_bit(bit, &kvm->arch.apicv_inhibit_reasons) ||
> -                   !kvm_apicv_activated(kvm))
> -                       return;
> -       } else {
> -               if (test_and_set_bit(bit, &kvm->arch.apicv_inhibit_reasons) ||
> -                   kvm_apicv_activated(kvm))
> -                       return;
> -       }
> +       if (activate)
> +               clear_bit(bit, &kvm->arch.apicv_inhibit_reasons);
> +       else
> +               set_bit(bit, &kvm->arch.apicv_inhibit_reasons);
> +
> +       if (kvm_apicv_activated(kvm) == apicv_was_activated)
> +               return;

Yes, I got to the same conclusion before seeing you message.  Another
possibility is to use cmpxchg, which I slightly prefer because if there
are multiple concurrent updates it has some possibilities of avoiding
the atomic operation and consequent cacheline bouncing.  I've sent a patch.

Paolo

