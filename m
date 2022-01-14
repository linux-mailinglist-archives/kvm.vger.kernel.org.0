Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 679C548E71B
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 10:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236423AbiANJIz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 04:08:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:36720 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231254AbiANJIy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 04:08:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642151333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k/tbnGn76vQBdBcG0duWBnDfwWlVcLC0sTsv0law7hM=;
        b=HZX/jDh8jma0VMEfTcFWGRSVYtUq4kGPcbgdjwQEIfBS2aLOlQ23poo2IkUtTq3Q/I7e9L
        3DHwbAQcQZMAArVL5mO95OnyWAiEWhmi4ULhT3Ye+3irgW6nofcY1CMFBhzBnaNY84HH4A
        b59CPEwAA973RovCvyAJuYQLjhS/0e4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-209-tcgIPBTCNrGD2pUMwto8PQ-1; Fri, 14 Jan 2022 04:08:52 -0500
X-MC-Unique: tcgIPBTCNrGD2pUMwto8PQ-1
Received: by mail-wm1-f71.google.com with SMTP id m19-20020a05600c4f5300b00345cb6e8dd4so2066039wmq.3
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 01:08:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k/tbnGn76vQBdBcG0duWBnDfwWlVcLC0sTsv0law7hM=;
        b=LFyiJBSxKBha2lmOcSV2phnzHEdEWSwIzfTyyBudcTknrKT5rbeLylo1iunCINKJHw
         R5hRK/ehYlGhyqJt+NWjO9OQQk9qEBD2dhdqDnl8UUe7JInypXAa5RgQJ198Ams0GW2Z
         ZbO2qDwaDP4D9HxU3Re8bmenhGCv1E2BT6uYRxLFp5vEzpi7BLp8cw1nsZku4+ZRYLF3
         dklMsVFf50eYFWEQW0Ttki9NN9D/Gp1xUJrwPxPjnyJZPiVo1nOn0rF6v1XYkFVnLuY1
         7vKhvpBXqZE76qWMq1GpJXg5fnhn/yhF8pJ2ITyeiPsT1Pr1/pOy3Bxt1Co1gJ1tMFCK
         nPpA==
X-Gm-Message-State: AOAM530J/t72u8+4wI7XIDGPQ5UyCqjtXCUM1fxY80otu/zf1l/z6ImV
        XIEvovgLYKDPv6IPaIAhSixhI5V/a1WOuuZBFiEhZJjnk9MLjDbJUMRMcCQXguHFxf7tUub1Z9a
        2aE5ORPDuurC2
X-Received: by 2002:a05:600c:1987:: with SMTP id t7mr7419117wmq.154.1642151331123;
        Fri, 14 Jan 2022 01:08:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyhfoN2OOQTjZHsQIIXa/cBFJoRQxv2LUVrveuV4ufsBMcmahcNTF92eV8tlV7pZYOpXGshBA==
X-Received: by 2002:a05:600c:1987:: with SMTP id t7mr7419089wmq.154.1642151330842;
        Fri, 14 Jan 2022 01:08:50 -0800 (PST)
Received: from localhost (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id b15sm1339696wrr.50.2022.01.14.01.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 01:08:50 -0800 (PST)
Date:   Fri, 14 Jan 2022 10:08:49 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] KVM: x86: Partially allow KVM_SET_CPUID{,2} after
 KVM_RUN for CPU hotplug
Message-ID: <20220114100849.277c04ee@redhat.com>
In-Reply-To: <YeCEyNz/xqcJBcU/@google.com>
References: <20220113133703.1976665-1-vkuznets@redhat.com>
        <YeCEyNz/xqcJBcU/@google.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 13 Jan 2022 20:00:08 +0000
Sean Christopherson <seanjc@google.com> wrote:

> On Thu, Jan 13, 2022, Vitaly Kuznetsov wrote:
> > Recently, KVM made it illegal to change CPUID after KVM_RUN but
> > unfortunately this change is not fully compatible with existing VMMs.
> > In particular, QEMU reuses vCPU fds for CPU hotplug after unplug and it
> > calls KVM_SET_CPUID2. Relax the requirement by implementing an allowlist
> > of entries which are allowed to change.  
> 
> Honestly, I'd prefer we give up and just revert feb627e8d6f6 ("KVM: x86: Forbid
> KVM_SET_CPUID{,2} after KVM_RUN").  Attempting to retroactively restrict the
> existing ioctls is becoming a mess, and I'm more than a bit concerned that this
> will be a maintenance nightmare in the future, without all that much benefit to
> anyone.

in 63f5a1909f9 ("KVM: x86: Alert userspace that KVM_SET_CPUID{,2} after KVM_RUN is broken")
you mention heterogeneous configuration, and that implies that
a userspace (not upstream qemu today) might attempt to change CPUID
and that would be wrong. Do we still care about that?


> I also don't love that the set of volatile entries is nothing more than "this is
> what QEMU needs today".  There's no architectural justification, and the few cases
> that do architecturally allow CPUID bits to change are disallowed.  E.g. OSXSAVE,
> MONITOR/MWAIT, CPUID.0x12.EAX.SGX1 are all _architecturally_ defined scenarios
> where CPUID can change, yet none of those appear in this list.  Some of those are
> explicitly handled by KVM (runtime CPUID updates), but why should it be illegal
> for userspace to intercept writes to MISC_ENABLE and do its own CPUID emulation?
> 

