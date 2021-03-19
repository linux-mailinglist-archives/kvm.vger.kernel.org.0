Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3DCA341846
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 10:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbhCSJaZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 05:30:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35364 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229791AbhCSJ3u (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Mar 2021 05:29:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616146189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SbkmFgN3EcF0DHZgzYCL+pJPCgZ6KwTo3BoCnQDKIqE=;
        b=OcH+x8WCKBm3PRQp0wxCOoytXsT6j0a9Gb7HRAxSh8eipw9qlkrOva3VBQlq5wkDO5yA7L
        MwqKmMX5Ey1ZcTMVnLNlbTbIn6rEkiPlTYoYdKnJbSfMY74HWKr3BzZwIaJNrql5vsTess
        5iW/rNrp7fw62meLa2Gzgy42DnAlo8g=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-z600s_fZPvSqxErH8CUiAA-1; Fri, 19 Mar 2021 05:29:47 -0400
X-MC-Unique: z600s_fZPvSqxErH8CUiAA-1
Received: by mail-ej1-f69.google.com with SMTP id 11so17936626ejz.20
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 02:29:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=SbkmFgN3EcF0DHZgzYCL+pJPCgZ6KwTo3BoCnQDKIqE=;
        b=DEZBBsOY8tn+xA8piba15aDU5wHjJQ0OxFO4ba6YKDDiSTpwJ8Q+OscJBBOZmhqbsi
         spxAK6TMx1pHfZw1revp/hI2t77z/1Fhc31lYhhlV/B8EEdlLxQVRF9SmofV81Shp/ys
         X62S8fm8eUt49YzYYiuTpv4rCST/v3vnBpi/ELF1aeO7a38bWxN7PSeu8pu0Yf/oYrok
         N+2fr9+VPxevzDgl1YWntw4XisNpOgM9GMfHIH/NGLK8kuOrZbamqwzRPVOqkvgBLThu
         RVp16ulXJ91TAfzxn5FvVBVluHwq32uQHs0pJ+lA+8l3lqhnyfiSDgQbVgGfRtOzx0u6
         cdOg==
X-Gm-Message-State: AOAM532dkdXXw9ZzRdYpfEPG68T4CNPteo8yUO9MsALKLPXEhEPQe7Hp
        NzGlsFdGx5nrwMlz3Pwc50lH8/9PIzAq4ksz8I6VaWV6BkJ6WQk29UNPV7t94ZtTOxPzOykR2Qq
        WMyiVpwYvD5dR
X-Received: by 2002:aa7:cc94:: with SMTP id p20mr8575373edt.353.1616146186005;
        Fri, 19 Mar 2021 02:29:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzd0BWDTO0siWJMvo6psUBoDO3koG3h0sVMsq9efkvKlzctS6e1Mafj7REl4AQs+yJuo5iIuA==
X-Received: by 2002:aa7:cc94:: with SMTP id p20mr8575359edt.353.1616146185818;
        Fri, 19 Mar 2021 02:29:45 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id r5sm3767632eds.49.2021.03.19.02.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 02:29:45 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 2/4] KVM: x86: hyper-v: Prevent using not-yet-updated
 TSC page by secondary CPUs
In-Reply-To: <20210318183042.GA42884@fuller.cnet>
References: <20210316143736.964151-1-vkuznets@redhat.com>
 <20210316143736.964151-3-vkuznets@redhat.com>
 <20210318170208.GB36190@fuller.cnet> <20210318180446.GA41953@fuller.cnet>
 <5634f6c9-bee9-ae07-c8ce-8e79bd2bd1a7@redhat.com>
 <20210318183042.GA42884@fuller.cnet>
Date:   Fri, 19 Mar 2021 10:29:44 +0100
Message-ID: <87tup75w53.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Marcelo Tosatti <mtosatti@redhat.com> writes:

> On Thu, Mar 18, 2021 at 07:05:49PM +0100, Paolo Bonzini wrote:
>> On 18/03/21 19:04, Marcelo Tosatti wrote:
>> > > 
>> > > Not clear why this is necessary, if the choice was to not touch TSC page
>> > > at all, when invariant TSC is supported on the host...
>> > 	
>> > 	s/invariant TSC/TSC scaling/
>> > 
>> > > Ah, OK, this is not for the migration with iTSC on destination case,
>> > > but any call to kvm_gen_update_masterclock, correct?
>> 
>> Yes, any update can be racy.
>> 
>> Paolo
>
> Which makes an unrelated KVM_REQ_MASTERCLOCK_UPDATE -> kvm_gen_update_masterclock 
> sequence to inadvertedly reduce performance a possibility, unless i am
> missing something.
>
> Ah, OK, it should be enabled again at KVM_REQ_CLOCK_UPDATE.

Right,

this patch is loosely related to the original problem, it's just
something I've noticed while debugging. Unlike kvmclock, which is
per-cpu, TSC page is global so only vCPU0 updates it in
kvm_guest_time_update() but the potential problem is: some other vCPU
may enter the guest before we manage to update the page on vCPU0 and
this is racy. Here, we just follow TLFS: invalidate TSC page while we're
updating it (on KVM_REQ_MASTERCLOCK_UPDATE).

PATCH4, which avoids updating TSC page when re-enlightenment is enabled,
also disables this invalidation. This is OK as we're not going to update
it.

-- 
Vitaly

