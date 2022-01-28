Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5AAB49FB64
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 15:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348069AbiA1OL2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 09:11:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59347 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347774AbiA1OL1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Jan 2022 09:11:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643379087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YNsFnjWqZ84YWknEFOSBbsUZabWkHFytiQN59OiiIQc=;
        b=MOfVECRuCYFIkkwa7tpoWc6u2qYvtUiM5oQREhPwfQs79E5CR7qCTh3jAoc0RLEyZTO4ap
        /SEcvXHpsSc2b9Vo6FogSkttnc/j6BIT3VvNVjSdy0pMOtJtPmRncF4eaSmLE6y5Cl2sL6
        yYIOxDgXZYjvgh83qxdhl6QW7r32XyY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-484-0HiR2_yIMx-CEycYkM3_4A-1; Fri, 28 Jan 2022 09:11:25 -0500
X-MC-Unique: 0HiR2_yIMx-CEycYkM3_4A-1
Received: by mail-wm1-f70.google.com with SMTP id f188-20020a1c1fc5000000b0034d79edde84so1490336wmf.0
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 06:11:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=YNsFnjWqZ84YWknEFOSBbsUZabWkHFytiQN59OiiIQc=;
        b=anmB5R1IJdn3K+06Om00m19Tkzcp4eOBN/1P3/tvobZHmKo0eZFkQbR1+7U1ptvC3G
         jIGKn/axJC/8F78bQjoYWAt7deDQujhenCE2Ghby6KrHDdm59BIphHV5jM2i9NRJS3d1
         OAA8NHWXitgnFFUHc7ipEcWQ2YHgbhy/3weCottxXESuoMCd+3zH2+0l6XMxzj75rF+B
         BuU73XG27KQpFE7EAt9VbzBqAjoHSBwpNFjfTbI8DjAv5Zusv0uG5bOO0GzefZGnEl7H
         RVAgY1W7tgo66+vUJThMnU48DKCI0RMPaedUEWg6/+CpB0bfveqw1ypSq2/ifsg6NbBa
         gAcg==
X-Gm-Message-State: AOAM530u3YJnYwCDB5Qf09SnGrpfTMsmJjljYIeJuUvuJy1rVg/FFxGR
        FPknLfXxfehlNTQiXR+rNR9C7+K1I7bfWfKBTz4TVn5mO4qGa7ISyDIRoaUTWvP1b2graOrXKxM
        YHHks5BNk9hz9ZtT7/7MiE/PNIIf35NrvNtf6xuMer1WdY2/Y9SM+8LIrtz4P8lCj
X-Received: by 2002:a05:6000:2a6:: with SMTP id l6mr7658213wry.601.1643379084462;
        Fri, 28 Jan 2022 06:11:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyT46Xw3cllhWkaFOkaVffH2KheeQT8rFwQR/Q/9ZacgTrx7aiJ5+eRVjnv5irQ1QCrakHUdQ==
X-Received: by 2002:a05:6000:2a6:: with SMTP id l6mr7658188wry.601.1643379084194;
        Fri, 28 Jan 2022 06:11:24 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id f13sm6058576wry.77.2022.01.28.06.11.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 06:11:23 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 0/5] KVM: nVMX: Fix Windows 11 + WSL2 + Enlightened VMCS
In-Reply-To: <86b78fe0-7123-4534-6aaf-12bd30463665@redhat.com>
References: <20220112170134.1904308-1-vkuznets@redhat.com>
 <87k0exktsx.fsf@redhat.com>
 <86b78fe0-7123-4534-6aaf-12bd30463665@redhat.com>
Date:   Fri, 28 Jan 2022 15:11:22 +0100
Message-ID: <87wnikeyr9.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 1/18/22 15:22, Vitaly Kuznetsov wrote:
>> Vitaly Kuznetsov <vkuznets@redhat.com> writes:
>> 
>>> Changes since v2 [Sean]:
>>> - Tweak a comment in PATCH5.
>>> - Add Reviewed-by: tags to PATCHes 3 and 5.
>>>
>>> Original description:
>>>
>>> Windows 11 with enabled Hyper-V role doesn't boot on KVM when Enlightened
>>> VMCS interface is provided to it. The observed behavior doesn't conform to
>>> Hyper-V TLFS. In particular, I'm observing 'VMREAD' instructions trying to
>>> access field 0x4404 ("VM-exit interruption information"). TLFS, however, is
>>> very clear this should not be happening:
>>>
>>> "Any VMREAD or VMWRITE instructions while an enlightened VMCS is active is
>>> unsupported and can result in unexpected behavior."
>>>
>>> Microsoft confirms this is a bug in Hyper-V which is supposed to get fixed
>>> eventually. For the time being, implement a workaround in KVM allowing
>>> VMREAD instructions to read from the currently loaded Enlightened VMCS.
>>>
>>> Patches 1-2 are unrelated fixes to VMX feature MSR filtering when eVMCS is
>>> enabled. Patches 3 and 4 are preparatory changes, patch 5 implements the
>>> workaround.
>>>
>> 
>> Paolo,
>> 
>> would it be possible to pick this up for 5.17? Technically, this is a
>> "fix", even if the bug itself is not in KVM)
>
> Yes, it is.  I have queued the patch

Thanks!

> and feel free to send a 5.16 backport too.

I see your pull request to Linus, will send the backport when it lands.
In fact, all 5 patches apply to 5.16 without issues but I guess stable@
tooling won't pick them up automatically.

-- 
Vitaly

