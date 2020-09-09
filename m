Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8799E262AE4
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 10:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729940AbgIIIto (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 04:49:44 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:42378 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726970AbgIIItk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Sep 2020 04:49:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599641372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RM/LF0srW4X3w0qE/H6ifSe+v4B7qiyXGdZqizH3L+s=;
        b=H8iGUdYrF3XoUuCTyCUd5SUhnNVv4svnwxK0sIht5Nf8XPa9N70jdzvMFMoTBElW7eHQY3
        ThzncNTmiAe9JmRPpKNe4/4r/E2+iIc5f/pZlnaZYM8F3IC0ENpgKYWCOmzI9c2MBdHJtf
        CYg3ngdQJZwuBNTPdevxLkWKnA92cLo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-D5eT25nFPj--u3E4QxV7Bg-1; Wed, 09 Sep 2020 04:49:30 -0400
X-MC-Unique: D5eT25nFPj--u3E4QxV7Bg-1
Received: by mail-wr1-f69.google.com with SMTP id l15so709562wro.10
        for <kvm@vger.kernel.org>; Wed, 09 Sep 2020 01:49:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=RM/LF0srW4X3w0qE/H6ifSe+v4B7qiyXGdZqizH3L+s=;
        b=Tyr0txxbo0s4J6ONH8JF62526+nRzVpISG46l09udwPVvHlEf1RFTpkZJrjpkk1VpM
         QEMLll7TBPLZrbDrXz02ylV+cLyoywBtYmqUYeCccTGYhUMTKtaUij3jXmwiV9RcbVqv
         lTFFGrlZCxzm9jQAJy1uFLBD7qf/uQzXpc4ACuAmTJSsjzqqJ1AhWRBhizX807oayMH6
         9/vS432a5RgXlnaEB0X5m59DgX+joXz8io4d4yUtbvJanyqz9NSoz5sSzN7vfJYeZ1PB
         2U7OjCk1YzpSdUxCm23Rk/2fgL+qcRb3FZBZxqLsSu8s95mpSslLj7z19H4EFlUmjnxH
         cxaA==
X-Gm-Message-State: AOAM5311DpDx2Zga3N8kli1ZzgQj24L1wCDc0EQFab8X2VQgOLDiwi3K
        D+Kjj29op9eS4CHETiZMVAd+ePAj+DDhuoIfmEGzCol2tMurnMestgCT7TdQfXsTZTNp8Arg63a
        WjBsCPNReuIa/
X-Received: by 2002:a1c:4886:: with SMTP id v128mr2482471wma.139.1599641369238;
        Wed, 09 Sep 2020 01:49:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwVrt9E41zVOwgEplo9t65ZeLxuldO4N393d7CEJUl6gRJybBJn8cvLjZG3Ri7WzFS5QyNjBA==
X-Received: by 2002:a1c:4886:: with SMTP id v128mr2482449wma.139.1599641369042;
        Wed, 09 Sep 2020 01:49:29 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id f6sm3504275wme.32.2020.09.09.01.49.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 01:49:28 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Ingo Molnar <mingo@kernel.org>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH 2/2] x86/kvm: don't forget to ACK async PF IRQ
In-Reply-To: <20200909081613.GB2446260@gmail.com>
References: <20200908135350.355053-1-vkuznets@redhat.com> <20200908135350.355053-3-vkuznets@redhat.com> <20200909081613.GB2446260@gmail.com>
Date:   Wed, 09 Sep 2020 10:49:27 +0200
Message-ID: <878sdjmj1k.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ingo Molnar <mingo@kernel.org> writes:

> * Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
>> Merge commit 26d05b368a5c0 ("Merge branch 'kvm-async-pf-int' into HEAD")
>> tried to adapt the new interrupt based async PF mechanism to the newly
>> introduced IDTENTRY magic but unfortunately it missed the fact that
>> DEFINE_IDTENTRY_SYSVEC() doesn't call ack_APIC_irq() on its own and
>> all DEFINE_IDTENTRY_SYSVEC() users have to call it manually.
>> 
>> As the result all multi-CPU KVM guest hang on boot when
>> KVM_FEATURE_ASYNC_PF_INT is present. The breakage went unnoticed because no
>> KVM userspace (e.g. QEMU) currently set it (and thus async PF mechanism
>> is currently disabled) but we're about to change that.
>> 
>> Fixes: 26d05b368a5c0 ("Merge branch 'kvm-async-pf-int' into HEAD")
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>
> This also fixes a kvmtool regression, but interestingly it does not set 
> KVM_FEATURE_ASYNC_PF_INT either AFAICS:
>
>   kepler:~/kvmtool.git> git grep KVM_FEATURE_ASYNC_PF_INT
>   kepler:~/kvmtool.git> 

My wild guess would be that kvmtool doesn't manually set any of the KVM
PV features:

[vitty@vitty kvmtool]$ git grep KVM_FEATURE_
[vitty@vitty kvmtool]$ 

it just blindly passes whatever it gets from KVM via
KVM_GET_SUPPORTED_CPUID to KVM_SET_CPUID2 and KVM_FEATURE_ASYNC_PF_INT
among other PV features is set there by default.

>
>   kepler:~/kvmtool.git> grep url .git/config
> 	url = https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git
>
> So either I missed the flag-setting in the kvmtools.git source, or maybe 
> there's some other way to trigger this bug?
>
> Anyway, please handle this as a v5.9 regression:
>
> 	Tested-by: Ingo Molnar <mingo@kernel.org>

Thanks!

-- 
Vitaly

