Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18275482EE8
	for <lists+kvm@lfdr.de>; Mon,  3 Jan 2022 09:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbiACIEf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jan 2022 03:04:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46328 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230057AbiACIEf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Jan 2022 03:04:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641197074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UdxaGBuR9xauk+WHq8djtOf6D/AnMAtrzYys2hrg50c=;
        b=Enf2PVrqAzN1U1XhH/EQHl2AJz0ZtMJOD7HDMSWY6gyR/7njPtY7LrFfm6K9mcLjrcSZGU
        7i4LQ0UIIFdLSUdKaZLI4aaZKWnnXTwqSMMXJspxkUBxH/OoPg5VaIFC5W/Gbg2A2karGi
        VxzN3YO2h+XJ8hXcaZiJLb5TaP2IyCM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-56YXuo8aMkOOVGn_9Dn9Gg-1; Mon, 03 Jan 2022 03:04:32 -0500
X-MC-Unique: 56YXuo8aMkOOVGn_9Dn9Gg-1
Received: by mail-wr1-f71.google.com with SMTP id s23-20020adf9797000000b001a24674f0f7so10004414wrb.9
        for <kvm@vger.kernel.org>; Mon, 03 Jan 2022 00:04:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=UdxaGBuR9xauk+WHq8djtOf6D/AnMAtrzYys2hrg50c=;
        b=qxwG8nftDCjV3Irpnq66Br+v4xoWs/ogQYax6UwwmBSmh1/wrVDxjxQnxxDvz5EkW7
         yXEMRGn3fMNANpm09jYr+EgC+CtXJa9Sk3luOOMkAwuEL93V8I0MgvzQyFaPqizonjFc
         ThRSea6B/eZDD/2/rwEjnHGX4+GDq+P2cS5wk5mAOapL5mykTXolM6kuD14NtWlC+Obm
         x57/gtvv3FIaVCwTsvZZ0XIB0fNxKI2JhlA7TcGmS25+EOxp6lGncXkjeNQTBXUL2HXT
         529GDn/AfPDQ3eEh5KWZRtUdEzfBYpiwQxlfo9DLeXQdD/ddd0zHn205cc9NDVRKpX6m
         kLqQ==
X-Gm-Message-State: AOAM533/gAwxNswCOixwSR5J88M7GGLcdwIHgRUiYV/i45VE7HcCDcWW
        alkLdSVCKjU4YytRcuAOYd1CiVyCbaCkFLoCne5CrsnDx/FYwehw5jmqygWjEaM/Z21yJzXHRcR
        QF5sELS7i6hoL
X-Received: by 2002:a5d:608a:: with SMTP id w10mr36053906wrt.596.1641197071152;
        Mon, 03 Jan 2022 00:04:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyVtP/aq31R7doXdWIFuANBoKaaKn+9HxKrxNy2cFus2ZwBwWHx5SjUajR9BsycSue2V/+yEw==
X-Received: by 2002:a5d:608a:: with SMTP id w10mr36053893wrt.596.1641197070956;
        Mon, 03 Jan 2022 00:04:30 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id p18sm4961997wmq.23.2022.01.03.00.04.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 00:04:30 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN
In-Reply-To: <61325b2b-dc93-5db2-2d0a-dd0900d947f2@redhat.com>
References: <20211122175818.608220-1-vkuznets@redhat.com>
 <20211122175818.608220-3-vkuznets@redhat.com>
 <16368a89-99ea-e52c-47b6-bd006933ec1f@redhat.com>
 <20211227183253.45a03ca2@redhat.com>
 <61325b2b-dc93-5db2-2d0a-dd0900d947f2@redhat.com>
Date:   Mon, 03 Jan 2022 09:04:29 +0100
Message-ID: <87mtkdqm7m.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 12/27/21 18:32, Igor Mammedov wrote:
>>> Tweaked and queued nevertheless, thanks.
>> it seems this patch breaks VCPU hotplug, in scenario:
>> 
>>    1. hotunplug existing VCPU (QEMU stores VCPU file descriptor in parked cpus list)
>>    2. hotplug it again (unsuspecting QEMU reuses stored file descriptor when recreating VCPU)
>> 
>> RHBZ:https://bugzilla.redhat.com/show_bug.cgi?id=2028337#c11
>> 
>
> The fix here would be (in QEMU) to not call KVM_SET_CPUID2 again. 
> However, we need to work around it in KVM, and allow KVM_SET_CPUID2 if 
> the data passed to the ioctl is the same that was set before.

Are we sure the data is going to be *exactly* the same? In particular,
when using vCPU fds from the parked list, do we keep the same
APIC/x2APIC id when hotplugging? Or can we actually hotplug with a
different id?

-- 
Vitaly

