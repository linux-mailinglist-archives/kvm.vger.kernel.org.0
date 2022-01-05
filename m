Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B543484F28
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 09:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbiAEIR3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 03:17:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41780 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232262AbiAEIR3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 03:17:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641370648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yvW/DnCdE78aEIkeksaSIoN+DLz7taEJ8XulSnNVAMM=;
        b=EVzwz1wczyqvNT/qhHA3nYzjoxPRfRq4V/uYNwChOi2jNyvCsDAQQhGS0PqzNnDCPNPJkZ
        /V9vgcviENGUEyNW35xLZ6BNcV+QNsPWIqNn1vnomrcA+b1TiZg8p+lqgPoBFzWBabSevz
        +qXW9Fn7kqkPZ36k7421c5hm2XCFVJU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-344-hm5jE5DyM666YM6nuP2_VQ-1; Wed, 05 Jan 2022 03:17:27 -0500
X-MC-Unique: hm5jE5DyM666YM6nuP2_VQ-1
Received: by mail-wr1-f72.google.com with SMTP id d13-20020adf9b8d000000b001a2aa837f8dso12313095wrc.3
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 00:17:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yvW/DnCdE78aEIkeksaSIoN+DLz7taEJ8XulSnNVAMM=;
        b=SVlYN83w499M9FDiLDznrn2pCB8dgIGx1uRk0vgR0RYUzDCSK4V2lE9xG95qi9oIlM
         mIQ5BnQ9zdJqs89dAzUrS3CsQNmdASuvJeBaIcCagqUrBePhtCJKCcR0CAcIDqUkwuvf
         mq0Vb/77EFsDtoK3eflDN6EB0DpESbqncZ8eCHLxO51Py6pjDMBnJipOA8mU1A7kPJrH
         uH5N7r/l1Kcx+skSvussZL9aU8+ivalz8GPv7MWqKzhXpRPgFbUQTc3nPDlJR7PDaJIE
         IdaYqSLRGZo0jgc5U3NKh7rsPltELGKKXV6TbuFL10BUIYrQBRaDV3bXOnbQORLvqQ6e
         2UPw==
X-Gm-Message-State: AOAM5335cI02fPLEuXJ7sXfT61SHVfCGlGW801abHk6bX07B3kcrZhbh
        4o/ZqgYgPRQhlTVPPKwy6M6FJhogEt0K4ACD4sSCSiIU6cHRSeb/LtdklVRea55ES2qy6GnOJZ2
        uq9aCGBUSADN2
X-Received: by 2002:adf:9ccf:: with SMTP id h15mr1569436wre.120.1641370646396;
        Wed, 05 Jan 2022 00:17:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxkGfAtxJCsf+CSfHihfWoWkwEHWAyZHDoSUQBjRCCkE7SpfgywhIzhn9HMa1uEmnFoEkacvg==
X-Received: by 2002:adf:9ccf:: with SMTP id h15mr1569425wre.120.1641370646168;
        Wed, 05 Jan 2022 00:17:26 -0800 (PST)
Received: from localhost (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id l16sm45540855wrx.117.2022.01.05.00.17.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 00:17:25 -0800 (PST)
Date:   Wed, 5 Jan 2022 09:17:24 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN
Message-ID: <20220105091724.1a667275@redhat.com>
In-Reply-To: <875yr1q8oa.fsf@redhat.com>
References: <20211122175818.608220-1-vkuznets@redhat.com>
        <20211122175818.608220-3-vkuznets@redhat.com>
        <16368a89-99ea-e52c-47b6-bd006933ec1f@redhat.com>
        <20211227183253.45a03ca2@redhat.com>
        <61325b2b-dc93-5db2-2d0a-dd0900d947f2@redhat.com>
        <87mtkdqm7m.fsf@redhat.com>
        <20220103104057.4dcf7948@redhat.com>
        <875yr1q8oa.fsf@redhat.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 03 Jan 2022 13:56:53 +0100
Vitaly Kuznetsov <vkuznets@redhat.com> wrote:

> Igor Mammedov <imammedo@redhat.com> writes:
> 
> > On Mon, 03 Jan 2022 09:04:29 +0100
> > Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> >  
> >> Paolo Bonzini <pbonzini@redhat.com> writes:
> >>   
> >> > On 12/27/21 18:32, Igor Mammedov wrote:    
> >> >>> Tweaked and queued nevertheless, thanks.    
> >> >> it seems this patch breaks VCPU hotplug, in scenario:
> >> >> 
> >> >>    1. hotunplug existing VCPU (QEMU stores VCPU file descriptor in parked cpus list)
> >> >>    2. hotplug it again (unsuspecting QEMU reuses stored file descriptor when recreating VCPU)
> >> >> 
> >> >> RHBZ:https://bugzilla.redhat.com/show_bug.cgi?id=2028337#c11
> >> >>     
> >> >
> >> > The fix here would be (in QEMU) to not call KVM_SET_CPUID2 again. 
> >> > However, we need to work around it in KVM, and allow KVM_SET_CPUID2 if 
> >> > the data passed to the ioctl is the same that was set before.    
> >> 
> >> Are we sure the data is going to be *exactly* the same? In particular,
> >> when using vCPU fds from the parked list, do we keep the same
> >> APIC/x2APIC id when hotplugging? Or can we actually hotplug with a
> >> different id?  
> >
> > If I recall it right, it can be a different ID easily.
> >  
> 
> It's broken then. I'd suggest we revert the patch from KVM and think
> about the strategy how to proceed.

Can you post a patch, then?

> Going forward, we really want to ban
> KVM_SET_CPUID{,2} after KVM_RUN (see the comment which my patch moves).
> E.g. we can have an 'allowlist' of things which can change (and put
> *APICids there) and only fail KVM_SET_CPUID{,2} when we see something
> else changing.

It might work, at least on QEMU side we do not allow mixing up CPU models
within VM instance (so far). So aside of APICid (and related leafs
(extended APIC ID/possibly other topo related stuff)) nothing else should
change ever when a new vCPU is hotplugged.

> In QEMU, we can search the parked CPUs list for an entry
> with the right *APICid and reuse it only if we manage to find one.
In QEMU, 'parked cpus' fd list is a generic code shared by all supported
archs. And I'm reluctant to push something x86 specific there (it's not
impossible, but it's a crutch to workaround forbidden KVM_SET_CPUID{,2}).

