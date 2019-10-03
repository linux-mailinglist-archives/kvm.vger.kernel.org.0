Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA72CA3E4
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 18:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389804AbfJCQT7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 12:19:59 -0400
Received: from mail-io1-f42.google.com ([209.85.166.42]:43636 "EHLO
        mail-io1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388486AbfJCQT5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 12:19:57 -0400
Received: by mail-io1-f42.google.com with SMTP id v2so6865262iob.10
        for <kvm@vger.kernel.org>; Thu, 03 Oct 2019 09:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M6NbRuCRqWY3+AVuSHzh420O9dVJf9FOyseKWdMJdmc=;
        b=MVmRN5z/rjEyH1zP4RLxRZGoJtzVco8dp8AXxZSIfuv0h9yYFA5w8o/AuO2eFdN2XH
         UGkfKecOwHQBEY8Y4+NZBUkRu5TYwErcVm1tXXQ8LCKNZ7TnHJU5Jat4zsGptIYkAER8
         YvDmqaq7P635fL0Y9Ys4WJuGgomxUJiWkxcTwKhZvU6Chcz7M92J8IUfvYw0soscKJNu
         i5SpKmkh7RvtRfGKOUpH1V1xm0ZIlnSq9jZpHZXWaAdfvRKCIxaBTlReS9tyJqiNwIqr
         5+8sOVyoDZIQ9quPTQNSINUeiLjMr/Vj8rRqm8vaM3yDB7XmKIaro3vJTO8KDQiCDNfk
         W7zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M6NbRuCRqWY3+AVuSHzh420O9dVJf9FOyseKWdMJdmc=;
        b=Kg+diWAFxmwYmCNBVGyTxTfAYlOAdIIV5YoItRWDmtzc2YkfQlV/Oi+l6lhW3VT6Az
         bfOTYftYp+/e/tZEhaLmA+GzaMhl/8JxAs2u3yLGnsM+RAJf/iDUAKB6u0d4FGc7Mwg8
         xQdDunNe55fLUoyQPBpJhilpADl9YIoHK9mcSsDEt0ivuI4tgNWNYScqvjSGgJ9xSoj5
         HYAYD1Z3hqhdYfVLU41HZ85Jlnnak4YzNQ1MEQQh5A26/N1YKQ1wQI6bx2N7w3PvFvUJ
         42lfgC9JapHmI0DDxfWYY0S0agjrj/NZfsQTbT+pv88ufwJCEU8TE42YSikQfr4qHvHf
         2NaQ==
X-Gm-Message-State: APjAAAXRMwbItqY/LqFMRy41Ima7KakiCsGcjtu52nvqHGIgBx1Ff1xt
        Ki6/PuH7Xv51JQkKiB3OjFiXryGRh6I9/rGpwEH1FPD3ZAs=
X-Google-Smtp-Source: APXvYqzjyQr20Pz+52vdBXJGDbJJ6qOv+6UTbRGIJrSpm2c1pIAaXJjaqq803RoG12igOqw3xZVUzoR3y/8rRswyHzI=
X-Received: by 2002:a02:a70c:: with SMTP id k12mr10099511jam.75.1570119596451;
 Thu, 03 Oct 2019 09:19:56 -0700 (PDT)
MIME-Version: 1.0
References: <CALMp9eRPgZygwsG+abEx96+dt6rKyAMQJQx0qoHVbaTKFh0CqA@mail.gmail.com>
 <6220e2b4-be59-736c-bc98-30573d506387@redhat.com>
In-Reply-To: <6220e2b4-be59-736c-bc98-30573d506387@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 3 Oct 2019 09:19:45 -0700
Message-ID: <CALMp9eS=QEnpQV7OQ3gS61PJecJG7vaah-yGb6MGw7CFDTFxKw@mail.gmail.com>
Subject: Re: A question about INVPCID without PCID
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 3, 2019 at 8:37 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 01/10/19 21:48, Jim Mattson wrote:
> > Does anyone know why kvm disallows enumerating INVPCID in the guest
> > CPUID when PCID is not enumerated? There are many far more nonsensical
> > CPUID combinations that kvm does allow, such as AVX512F without XSAVE,
> > or even PCID without LM. Why is INVPCID without PCID of paramount
> > concern?
> >
>
> I guess you're looking at this code:
>
>                 /* Exposing INVPCID only when PCID is exposed */
>                 bool invpcid_enabled =
>                         guest_cpuid_has(vcpu, X86_FEATURE_INVPCID) &&
>                         guest_cpuid_has(vcpu, X86_FEATURE_PCID);
>
> The INVPCID instruction will be disabled if !PCID && INVPCID, but it
> doesn't really disallow *enumerating* INVPCID.  There is no particular
> reason for that, it was done like that originally ("KVM: VMX: Implement
> PCID/INVPCID for guests with EPT") and kept this way.
>
> With !PCID && INVPCID you could use PCID=0 operations as a fancy INVLPG,
> I suppose, but it is probably uninteresting enough that no one bothered
> changing it.
>
> Paolo

I was actually looking at the code a few lines lower:

if (!invpcid_enabled) {
        exec_control &= ~SECONDARY_EXEC_ENABLE_INVPCID;
        guest_cpuid_clear(vcpu, X86_FEATURE_INVPCID);
}

The call to guest_cpuid_clear *does* disallow enumerating INVPCID if
PCID isn't also enumerated. I'm just wondering why we bothered, since
we do so little sanitization of guest CPUID.
