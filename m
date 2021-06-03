Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96064399CF6
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 10:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhFCIrf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 04:47:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21659 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229486AbhFCIrf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Jun 2021 04:47:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622709950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rsIrqOylEA4TXgHkwdm9Q9btGTKDmHBsUJC+um8PyV0=;
        b=WeAVoRouBD7HYaD6HIRcfWbKrrZp900M0FkThKVurVbI9IpC9kcruoAcM0WV0CK0zQ8/1B
        DGw8ferT5mbzG5V3kixqwjcyYqde29MYkIZ4UZJvsrxc1zWSVX6Opb/1kNpaVAcK09cJm7
        geV7MtT8JF6F7qCfl2mB78fqIv6n46A=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-cgdzhSXQNJa1ODBSF2OR5g-1; Thu, 03 Jun 2021 04:45:49 -0400
X-MC-Unique: cgdzhSXQNJa1ODBSF2OR5g-1
Received: by mail-ed1-f69.google.com with SMTP id m16-20020a0564024310b029039182495fb1so634179edc.16
        for <kvm@vger.kernel.org>; Thu, 03 Jun 2021 01:45:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=rsIrqOylEA4TXgHkwdm9Q9btGTKDmHBsUJC+um8PyV0=;
        b=KbJbvTMfknhMJA1bE2XIYKC3yJ4r1lxQ8BzuG4JgJvwVzHJ8t5Mi3DsRYDCubTbg59
         jOUVRcXf+aF5+qpQC0iH8j6pG/8cCqq2iWu7ra22qbrGROjiCq2elWoWOiFNc5Tq3Ffr
         10pCAVzFLBrxJ1A4sZqllq5ViTix0SfibdWRXvm++IjoxO1mqd7Y2RMF7DM9Z94uKGWG
         xr+aTlAzMz3xTeqjSUSMhSipzpK0lLu8rK0yfcQXqX4RuJr1rPReFzcutIrs1MZulSA4
         VvqiaA48XxdG0AD5AMrBO0w7N7qnn5RAnFPIa++F8YZFG0UJvbhcawxXXyr9FMeP8aQR
         u0Lw==
X-Gm-Message-State: AOAM5333/7+/EWZhRGlUyGPd+PnAN8aSmNYu9tYMdWOdGwFMpEnU/Ay7
        +nkwp8MOgV6YJaF1HPrqPvP25rDtB85DEjEoZirR7E26gpIWPgy79O2FG4kXGWX71s/3w6L5XlL
        yGGutPEQ1PY3g
X-Received: by 2002:aa7:de8b:: with SMTP id j11mr43173902edv.363.1622709948160;
        Thu, 03 Jun 2021 01:45:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxtl3t6xoNuHDquuwwnUekQkranRmTDb8RVJaJaPeFXmqJ+LF35yJOGAC0j7s3n6gmctl6VfA==
X-Received: by 2002:aa7:de8b:: with SMTP id j11mr43173883edv.363.1622709947975;
        Thu, 03 Jun 2021 01:45:47 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id w11sm1496921ede.54.2021.06.03.01.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 01:45:47 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Eduardo Habkost <ehabkost@redhat.com>,
        Claudio Fontana <cfontana@suse.de>
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Cameron Esfahani <dirty@apple.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>, qemu-devel@nongnu.org
Subject: Re: [PATCH 1/2] i386: reorder call to cpu_exec_realizefn in
 x86_cpu_realizefn
In-Reply-To: <20210601184832.teij5fkz6dvyctrp@habkost.net>
References: <20210529091313.16708-1-cfontana@suse.de>
 <20210529091313.16708-2-cfontana@suse.de>
 <20210601184832.teij5fkz6dvyctrp@habkost.net>
Date:   Thu, 03 Jun 2021 10:45:45 +0200
Message-ID: <87o8cn1gli.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Eduardo Habkost <ehabkost@redhat.com> writes:

>> 
>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>> index 9e211ac2ce..6bcb7dbc2c 100644
>> --- a/target/i386/cpu.c
>> +++ b/target/i386/cpu.c
>> @@ -6133,34 +6133,6 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
>>      Error *local_err = NULL;
>>      static bool ht_warned;
>>  
>> -    /* Process Hyper-V enlightenments */
>> -    x86_cpu_hyperv_realize(cpu);
>
> Vitaly, is this reordering going to affect the Hyper-V cleanup
> work you are doing?  It seems harmless and it makes sense to keep
> the "realize" functions close together, but I'd like to confirm.
>

Currently, x86_cpu_hyperv_realize() is designed to run before
kvm_hyperv_expand_features() (and thus x86_cpu_expand_features()):
x86_cpu_hyperv_realize() sets some default values to
cpu->hyperv_vendor/hyperv_interface_id/hyperv_version_id... but in
'hv-passthrough' mode these are going to be overwritten by KVM's values.

By changing the ordering, this patch changes the logic so QEMU's default
values will always be used, even in 'hv-passthrough' mode. This is
undesireable. I'd suggest we keep x86_cpu_hyperv_realize() call where it
is now, I'll think about possible cleanup later (when both this patch
and the rest of my cleanup lands).

-- 
Vitaly

