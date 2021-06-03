Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 626D539A288
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 15:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhFCNyU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 09:54:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24144 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229744AbhFCNyT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Jun 2021 09:54:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622728355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aGzYnwJ/79uwHhGm7246c+BQzOFvMTF+2K8gC73yhXY=;
        b=PRs0PZEdcngDjg5rn2TmVCT0JvWyeb1MqnqQuVuU3NKhDVqkgUw3cTZ8WIRgUYuChjzlKg
        Qb6t/7uUWS7uEfqut4mz6cfriitXh47HDkmdJ4UGqJ8McA0vDr4uukNGSFk+/aFqw1GviI
        3w8eVVS+S2qddeARdoqXRJEkmbSMx3w=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-Of1hluDhMKSwZXZUcb9rtQ-1; Thu, 03 Jun 2021 09:52:33 -0400
X-MC-Unique: Of1hluDhMKSwZXZUcb9rtQ-1
Received: by mail-ed1-f69.google.com with SMTP id c12-20020aa7d60c0000b029038fccdf4390so3296363edr.9
        for <kvm@vger.kernel.org>; Thu, 03 Jun 2021 06:52:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=aGzYnwJ/79uwHhGm7246c+BQzOFvMTF+2K8gC73yhXY=;
        b=Uf5U+zvBhdgWD5ou9HePAUVodUHSbleqhj9fxVSgcnTFvtuqRMtmK1/uN7GlqqBpIU
         O2lWY4052N6tTVfLmhNRzRsokucBoMuj0Q6ccC8Fz34UwURlUeDuz0YdKI0+0+Q5MHvu
         J6Maal1yeQwlGec+7qlLNAiJX3f3IvPl9tzOw6CdH08MiQ5syboDq9OkVOzq12OyTmDU
         H/3igiyZeBea00LJbjxVelVRaaYhqnJUpi8H8Ow3msfhw7VvX8pwb87y2Iio8CxeC8MH
         1v7Q2wZC9zD4czlqM3bM4z98yuX4QnBlnqOpUxOCktqt8T3hRY5lvfJptgNCB5eTIiLF
         uy1A==
X-Gm-Message-State: AOAM533+UebdRifWG+MA86yij5tq53IQZiFTryDdFQOR4UnA96pc1sjk
        Bz06iRrb5dm/oz6nhJzA5LDukdigyEeu1A5a4Y3N/w9Wan1e2DXhbjaTY5fcD+NcOfqHnkeKthd
        kHXCcKYo8Ml6F
X-Received: by 2002:aa7:db94:: with SMTP id u20mr43820042edt.381.1622728352472;
        Thu, 03 Jun 2021 06:52:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFTkGs1V14Wf6MLgMSIw4+iLzsxca6I0DcvG4KjZ50QkzIyM+lKtiGeOU4iF2LT4KYVoFfPA==
X-Received: by 2002:aa7:db94:: with SMTP id u20mr43820025edt.381.1622728352333;
        Thu, 03 Jun 2021 06:52:32 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id p7sm1824947edw.43.2021.06.03.06.52.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 06:52:31 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>, Tao Xu <tao3.xu@intel.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Subject: Re: [PATCH v2] KVM: VMX: Enable Notify VM exit
In-Reply-To: <660ceed2-7569-6ce6-627a-9a4e860b8aa9@intel.com>
References: <20210525051204.1480610-1-tao3.xu@intel.com>
 <871r9k36ds.fsf@vitty.brq.redhat.com>
 <660ceed2-7569-6ce6-627a-9a4e860b8aa9@intel.com>
Date:   Thu, 03 Jun 2021 15:52:30 +0200
Message-ID: <87fsxz12e9.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> On 6/2/2021 6:31 PM, Vitaly Kuznetsov wrote:
>> Tao Xu <tao3.xu@intel.com> writes:
>> 
>>> There are some cases that malicious virtual machines can cause CPU stuck
>>> (event windows don't open up), e.g., infinite loop in microcode when
>>> nested #AC (CVE-2015-5307). No event window obviously means no events,
>>> e.g. NMIs, SMIs, and IRQs will all be blocked, may cause the related
>>> hardware CPU can't be used by host or other VM.
>>>
>>> To resolve those cases, it can enable a notify VM exit if no event
>>> window occur in VMX non-root mode for a specified amount of time
>>> (notify window). Since CPU is first observed the risk of not causing
>>> forward progress, after notify window time in a units of crystal clock,
>>> Notify VM exit will happen. Notify VM exit can happen incident to delivery
>>> of a vectored event.
>>>
>>> Expose a module param for configuring notify window, which is in unit of
>>> crystal clock cycle.
>>> - A negative value (e.g. -1) is to disable this feature.
>>> - Make the default as 0. It is safe because an internal threshold is added
>>> to notify window to ensure all the normal instructions being coverd.
>>> - User can set it to a large value when they want to give more cycles to
>>> wait for some reasons, e.g., silicon wrongly kill some normal instruction
>>> due to internal threshold is too small.
>>>
>>> Notify VM exit is defined in latest Intel Architecture Instruction Set
>>> Extensions Programming Reference, chapter 9.2.
>>>
>>> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>> Signed-off-by: Tao Xu <tao3.xu@intel.com>
>>> ---
>>>
>>> Changelog:
>>> v2:
>>>       Default set notify window to 0, less than 0 to disable.
>>>       Add more description in commit message.
>> 
>> Sorry if this was already discussed, but in case of nested
>> virtualization and when L1 also enables
>> SECONDARY_EXEC_NOTIFY_VM_EXITING, shouldn't we just reflect NOTIFY exits
>> during L2 execution to L1 instead of crashing the whole L1?
>> 
>
> yes. If we expose it to nested, it should reflect the Notify VM exit to 
> L1 when L1 enables it.
>
> But regarding nested, there are more things need to be discussed. e.g.,
> 1) It has dependence between L0 and L1, for security consideration. When 
> L0 enables it, it shouldn't be turned off during L2 VM is running.
>     a. Don't expose to L1 but enable for L1 when L2 VM is running.
>     b. expose it to L1 and force it enabled.

Could you please elaborate on the 'security' concern? My understanding
that during L2 execution:
If L0 enables the feature and L1 doesn't, vmexit goes to L0.
If L1 enables the feature and L0 doesn't, vmexit goes to L1.
If both L0 and L1 enable the feature, vmexit can probably (I didn't put
enough though in it I'm afraid) go to the one which has smaller window.

>
> 2) When expose it to L1, vmcs02.notify_window needs to be 
> min(L0.notify_window, L1.nofity_window)
>
> We don't deal with nested to make this Patch simple.

Sure, I just wanted to check with you what's the future plan and if the
behavior you introduce is desireable in nested case.

-- 
Vitaly

