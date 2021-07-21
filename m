Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5298C3D0ED5
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 14:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237010AbhGULwK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 07:52:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58479 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237063AbhGULwD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Jul 2021 07:52:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626870759;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BhZuTxoecOSBTlHMJqTl/6bVqh22YD7O7U2gF62TFQ0=;
        b=SUXtmPsVg/OWymZT3+puZ3Z7Ox+yYnE3dYAYu+KvC0JJy6/9gKPXLpL5lglW0Zbah9kZC7
        qGGkbvwpFvReNuWeNRZUtn6eAX0Nxjh0X4fueShrAcsrzttHl22raG+om5UuyUuu3Ohij0
        hrwDblfP+xsy6TOrrkAbavz/YU2D5h4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-KHF6kwRfN2ej_z2bQP-zFQ-1; Wed, 21 Jul 2021 08:32:36 -0400
X-MC-Unique: KHF6kwRfN2ej_z2bQP-zFQ-1
Received: by mail-ed1-f71.google.com with SMTP id c21-20020aa7d6150000b02903ab03a06e86so961585edr.14
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 05:32:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=BhZuTxoecOSBTlHMJqTl/6bVqh22YD7O7U2gF62TFQ0=;
        b=JmrO52JZVr8dhpL2bXiubpOvdStrGHUHQF4BqE/LvcimrB6zFn92kzlIUdKdNy5zco
         92+xEL68jbmMcuPX5pwmPyZFv2sgz3ffiYZDq/YtOKRhH9y4/sWC+TSEuGZ1PyaDNY8B
         DR9qcUzyLMlyg1utf4UqOPkInzlJEDxxzPlM6sycNh8Zc9hSkDtkv2c6c23xt0dlEMi8
         Hu8dclp0aDrZekwrkzrpJIntWZiA0w7VZapi9z0bwAn1peTID3xDYA49b+Ww9xuMqhAi
         l9atYIOeuDkntZ19d8MapFhBxHczTfZ7n8FGLC3KGDoScirS4Onq83QzgJwA4oWHYlQQ
         dOxg==
X-Gm-Message-State: AOAM532DQy3f6WtsqtRlmJwfTZnbh/ps+OcBJNnXef9twUfoSjcl5GWA
        FZSqxgSSjWAYRaBalJD1sZO7PI3AqL5hmkj1sgBnNoYoic4lRLdquL9koVUpJt038jPFVsHS3WK
        kFlQqWK6ICH5O
X-Received: by 2002:aa7:d353:: with SMTP id m19mr49379413edr.162.1626870755241;
        Wed, 21 Jul 2021 05:32:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxAEr+MuFS8GkfrCrhq3b5owjggB+XDhNH2yRXPavvDb9W9IQvA/XjsEM19tDcZfivypeW8eA==
X-Received: by 2002:aa7:d353:: with SMTP id m19mr49379391edr.162.1626870755109;
        Wed, 21 Jul 2021 05:32:35 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id s18sm810368ejc.52.2021.07.21.05.32.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 05:32:34 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Peter Gonda <pgonda@google.com>, kvm list <kvm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH] KVM: SVM: Do not terminate SEV-ES guests on GHCB
 validation failure
In-Reply-To: <YK/VUPi+zFO6wFXB@google.com>
References: <f8811b3768c4306af7fb2732b6b3755489832c55.1621020158.git.thomas.lendacky@amd.com>
 <CAMkAt6qJqTvM0PX+ja3rLP3toY-Rr4pSUbiFKL1GwzYZPG6f8g@mail.gmail.com>
 <324d9228-03e9-0fe2-59c0-5e41e449211b@amd.com>
 <YKa1jduPK9JyjWbx@google.com>
 <468cee77-aa0a-cf4a-39cf-71b5bfb3575e@amd.com>
 <YK/VUPi+zFO6wFXB@google.com>
Date:   Wed, 21 Jul 2021 14:32:33 +0200
Message-ID: <8735s7sv8e.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Thu, May 20, 2021, Tom Lendacky wrote:
>> On 5/20/21 2:16 PM, Sean Christopherson wrote:
>> > On Mon, May 17, 2021, Tom Lendacky wrote:
>> >> On 5/14/21 6:06 PM, Peter Gonda wrote:
>> >>> On Fri, May 14, 2021 at 1:22 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>> >>>>
>> >>>> Currently, an SEV-ES guest is terminated if the validation of the VMGEXIT
>> >>>> exit code and parameters fail. Since the VMGEXIT instruction can be issued
>> >>>> from userspace, even though userspace (likely) can't update the GHCB,
>> >>>> don't allow userspace to be able to kill the guest.
>> >>>>
>> >>>> Return a #GP request through the GHCB when validation fails, rather than
>> >>>> terminating the guest.
>> >>>
>> >>> Is this a gap in the spec? I don't see anything that details what
>> >>> should happen if the correct fields for NAE are not set in the first
>> >>> couple paragraphs of section 4 'GHCB Protocol'.
>> >>
>> >> No, I don't think the spec needs to spell out everything like this. The
>> >> hypervisor is free to determine its course of action in this case.
>> > 
>> > The hypervisor can decide whether to inject/return an error or kill the guest,
>> > but what errors can be returned and how they're returned absolutely needs to be
>> > ABI between guest and host, and to make the ABI vendor agnostic the GHCB spec
>> > is the logical place to define said ABI.
>> 
>> For now, that is all we have for versions 1 and 2 of the spec. We can
>> certainly extend it in future versions if that is desired.
>> 
>> I would suggest starting a thread on what we would like to see in the next
>> version of the GHCB spec on the amd-sev-snp mailing list:
>> 
>> 	amd-sev-snp@lists.suse.com
>
> Will do, but in the meantime, I don't think we should merge a fix of any kind
> until there is consensus on what the VMM behavior will be.  IMO, fixing this in
> upstream is not urgent; I highly doubt anyone is deploying SEV-ES in production
> using a bleeding edge KVM.

Sorry for resurrecting this old thread but were there any deveopments
here? I may have missed something but last time I've checked a single
"rep; vmmcall" from userspace was still crashing the guest. The issue,
however, doesn't seem to reproduce with Vmware ESXi which probably means
they're just skipping the instruction and not even injecting #GP (AFAIR,
I don't have an environment to re-test handy).

-- 
Vitaly

