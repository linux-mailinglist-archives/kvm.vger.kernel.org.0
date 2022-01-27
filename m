Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E29E49DE29
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 10:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbiA0Jg2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 04:36:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:52739 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234153AbiA0Jg1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Jan 2022 04:36:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643276186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PV01ELli/hyFaStUxqX6n9QaOQmZ2C+YT0HIqDtWr78=;
        b=PD/vRxvkLzpuofTBrI5y6GEAjzyU0OBKnkyC+AhwjhBaje5oUZpG/6UkZ34YWLcNStX+ym
        +Oagl86ufVHeToF/7c5+8TDlqXAvNcZfpsluxqxfvYGx0TAI4ftDsOC5caH4/RPBZ9Pvap
        +m1LaIBlruM2JU2c3tqeRxLV3JbBBxM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-67-yWokpziLO4aOQBNqyjZyJA-1; Thu, 27 Jan 2022 04:36:24 -0500
X-MC-Unique: yWokpziLO4aOQBNqyjZyJA-1
Received: by mail-ed1-f69.google.com with SMTP id a18-20020aa7d752000000b00403d18712beso1115703eds.17
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 01:36:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=PV01ELli/hyFaStUxqX6n9QaOQmZ2C+YT0HIqDtWr78=;
        b=mvW2FVPdAA6hgrwmx2Dq+nYZPC/sbfsF6gBW2ejfcsryd3Brir+rxg/TVE+JIRVj4t
         TVIt8j5GAzxkIwhzR4Lf6GbPp+9XbTmlhnNurB2t4WlZpBbUcAFsBRzcig1IwW8hRmxC
         69XcnmZFOrHabSv36triGIaGmo5VLZQg/9P7ZzLwrkRfxXZdOfsVa1Fp8ddvwYHxaHz5
         7LSVFIs55q4OAHCY5+ZwIpx2Jr7ulGQdQyNWZEaodCnuy36/H3A/cCQTWS07pOxbMKHA
         eMK47i1rQNjT0qY1vGvc+rqH+jV+GBeQjN0PDDOAucbNgiPV/xBI0HbQKZ7hNcecOtbZ
         8Cqw==
X-Gm-Message-State: AOAM531aRSUvFRbEVlgaR0IHFGA7X27aLF9GW1sAnJdbLamb2gJN/XrJ
        ws3OnwTK5CABDQLtp4AQqjCTN2x7SvRAqZGb2OanMzbNeQ4c/GOzwvHmjP99Q3gLCHnkuHbOa6X
        mK4NYSHd2qiZ8nxxzWr3o2leoLv5vowjwDNNq2KDU4djRWlZTZAngxt7DTJpTrqph
X-Received: by 2002:aa7:c40a:: with SMTP id j10mr2815819edq.232.1643276183832;
        Thu, 27 Jan 2022 01:36:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzSDbYtEKfjFx4mZY8KRDFwpmKOB6JY/3sQYjWOBAHu7dHGUuXD0KB1JiyVurp5evEm9AatQw==
X-Received: by 2002:aa7:c40a:: with SMTP id j10mr2815802edq.232.1643276183640;
        Thu, 27 Jan 2022 01:36:23 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id i16sm8495187eja.8.2022.01.27.01.36.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 01:36:23 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 0/5] KVM: nVMX: Fix Windows 11 + WSL2 + Enlightened VMCS
In-Reply-To: <87k0exktsx.fsf@redhat.com>
References: <20220112170134.1904308-1-vkuznets@redhat.com>
 <87k0exktsx.fsf@redhat.com>
Date:   Thu, 27 Jan 2022 10:36:22 +0100
Message-ID: <87ee4th65l.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

> Vitaly Kuznetsov <vkuznets@redhat.com> writes:
>
>> Changes since v2 [Sean]:
>> - Tweak a comment in PATCH5.
>> - Add Reviewed-by: tags to PATCHes 3 and 5.
>>
>> Original description:
>>
>> Windows 11 with enabled Hyper-V role doesn't boot on KVM when Enlightened
>> VMCS interface is provided to it. The observed behavior doesn't conform to
>> Hyper-V TLFS. In particular, I'm observing 'VMREAD' instructions trying to
>> access field 0x4404 ("VM-exit interruption information"). TLFS, however, is
>> very clear this should not be happening:
>>
>> "Any VMREAD or VMWRITE instructions while an enlightened VMCS is active is
>> unsupported and can result in unexpected behavior."
>>
>> Microsoft confirms this is a bug in Hyper-V which is supposed to get fixed
>> eventually. For the time being, implement a workaround in KVM allowing 
>> VMREAD instructions to read from the currently loaded Enlightened VMCS.
>>
>> Patches 1-2 are unrelated fixes to VMX feature MSR filtering when eVMCS is
>> enabled. Patches 3 and 4 are preparatory changes, patch 5 implements the
>> workaround.
>>
>
> Paolo,
>
> would it be possible to pick this up for 5.17? Technically, this is a
> "fix", even if the bug itself is not in KVM)

Ping)

-- 
Vitaly

