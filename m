Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8CA483130
	for <lists+kvm@lfdr.de>; Mon,  3 Jan 2022 13:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbiACM47 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jan 2022 07:56:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30017 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230200AbiACM46 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Jan 2022 07:56:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641214618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=q+0VcHP1CYruqwB40NeEtKv4yl+LXrHLsOptfsKeiRI=;
        b=a0mCJvRsDteHWvAtnk5gKYuNnW0d4dFhtxYSBzvbVLDUVjRCspV+gf72HWQRb1Awsx+X/o
        TItpul5ZXsmKfP2OzIpytvxiK1xQEaMgbY5zA4vrvTcnKRmpMrpbMT+CGx2s120l2AXIRb
        Hj/l8u+PhiZ1S2+f3tsqleqyavLgayU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-56-osgP5TZ1PWaPunEmi2233A-1; Mon, 03 Jan 2022 07:56:56 -0500
X-MC-Unique: osgP5TZ1PWaPunEmi2233A-1
Received: by mail-wr1-f69.google.com with SMTP id h7-20020adfaa87000000b001885269a937so10309933wrc.17
        for <kvm@vger.kernel.org>; Mon, 03 Jan 2022 04:56:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=q+0VcHP1CYruqwB40NeEtKv4yl+LXrHLsOptfsKeiRI=;
        b=58iqQ7AWHCt50oiXSFE+1wxlvRxnb2JP6mdnu7FPG/uA/Dyj70wGz8GH8wsF5I5WAf
         JMqS1FIAHx2YcEodk0hhz3zfr/nmgZR4eAnZLXUqh/4s95eCHzZWjZ+FLiqcmmXFI5An
         rvAMljPyHoqt63Wisqk3HwcrDH4HrEOrWhRvQf+DUWIuy011mTeB2boXb9pu+mvhEqkD
         rmv0mFgr1D7EeHyCFmnSoC3a2qOjdZJ6g936fjJiO+eVmkl2JrKTRY/msyovWndTDr3f
         ZyxrGJpHl2C7foAm+Kr+HoBKUH0M3vsnJ7pkXwpLkoE5KtGsEje/Nuu676yK51eRRTt0
         oNKA==
X-Gm-Message-State: AOAM531vlcIKFysKpvnOJT4/RkgNL3hM5NuuPrIEPPGWRAOZENG5Mc1b
        qDOUvH5CANFJgVS7r4GEaFycaR/d07Dkc+Ymi6iufsEUk7E62cbLKsTLY2EiCeS1Q0/ZIjjHoLr
        erKFF+IuTj0dR
X-Received: by 2002:a5d:64eb:: with SMTP id g11mr8187878wri.135.1641214615690;
        Mon, 03 Jan 2022 04:56:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyDpUMIC/WC+h6hUImHvQqEuiygZq8ljLrr9aVNb+INT15FUbHInzoVOpdVgC/6qO+i+/5zHg==
X-Received: by 2002:a5d:64eb:: with SMTP id g11mr8187862wri.135.1641214615521;
        Mon, 03 Jan 2022 04:56:55 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id l26sm34337226wrz.44.2022.01.03.04.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 04:56:54 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Igor Mammedov <imammedo@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN
In-Reply-To: <20220103104057.4dcf7948@redhat.com>
References: <20211122175818.608220-1-vkuznets@redhat.com>
 <20211122175818.608220-3-vkuznets@redhat.com>
 <16368a89-99ea-e52c-47b6-bd006933ec1f@redhat.com>
 <20211227183253.45a03ca2@redhat.com>
 <61325b2b-dc93-5db2-2d0a-dd0900d947f2@redhat.com>
 <87mtkdqm7m.fsf@redhat.com> <20220103104057.4dcf7948@redhat.com>
Date:   Mon, 03 Jan 2022 13:56:53 +0100
Message-ID: <875yr1q8oa.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Igor Mammedov <imammedo@redhat.com> writes:

> On Mon, 03 Jan 2022 09:04:29 +0100
> Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
>> Paolo Bonzini <pbonzini@redhat.com> writes:
>> 
>> > On 12/27/21 18:32, Igor Mammedov wrote:  
>> >>> Tweaked and queued nevertheless, thanks.  
>> >> it seems this patch breaks VCPU hotplug, in scenario:
>> >> 
>> >>    1. hotunplug existing VCPU (QEMU stores VCPU file descriptor in parked cpus list)
>> >>    2. hotplug it again (unsuspecting QEMU reuses stored file descriptor when recreating VCPU)
>> >> 
>> >> RHBZ:https://bugzilla.redhat.com/show_bug.cgi?id=2028337#c11
>> >>   
>> >
>> > The fix here would be (in QEMU) to not call KVM_SET_CPUID2 again. 
>> > However, we need to work around it in KVM, and allow KVM_SET_CPUID2 if 
>> > the data passed to the ioctl is the same that was set before.  
>> 
>> Are we sure the data is going to be *exactly* the same? In particular,
>> when using vCPU fds from the parked list, do we keep the same
>> APIC/x2APIC id when hotplugging? Or can we actually hotplug with a
>> different id?
>
> If I recall it right, it can be a different ID easily.
>

It's broken then. I'd suggest we revert the patch from KVM and think
about the strategy how to proceed. Going forward, we really want to ban
KVM_SET_CPUID{,2} after KVM_RUN (see the comment which my patch moves).
E.g. we can have an 'allowlist' of things which can change (and put
*APICids there) and only fail KVM_SET_CPUID{,2} when we see something
else changing. In QEMU, we can search the parked CPUs list for an entry
with the right *APICid and reuse it only if we manage to find one.

-- 
Vitaly

