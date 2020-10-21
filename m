Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0F4294EFE
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 16:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442791AbgJUOq6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 10:46:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23707 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2442789AbgJUOq4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Oct 2020 10:46:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603291614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=McsFIc3uuC39J5CjXN1eYmGbwChHomet0XT2rkjh0/Q=;
        b=RBgAkl0efYBv4KWMToSdaYOchmD5Mn2nGgIgo0CPpzdtX3glVGYhH6MShNWTO4svb3PtkS
        0HAkS63OJ9wZofqZ0alq0ujI+zIYstRD0dNyhvTb89i17w3ykwlKsmXiokt6Gfslh8G9x/
        wt4mgpvdBWJv4pv59EfP1AuOfFWDTe8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-XFyW1589NXqxXyHGlPuCVQ-1; Wed, 21 Oct 2020 10:46:52 -0400
X-MC-Unique: XFyW1589NXqxXyHGlPuCVQ-1
Received: by mail-wm1-f69.google.com with SMTP id s12so1501795wmj.0
        for <kvm@vger.kernel.org>; Wed, 21 Oct 2020 07:46:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=McsFIc3uuC39J5CjXN1eYmGbwChHomet0XT2rkjh0/Q=;
        b=YScG/RU4u1dFhnWCe76GJ6/EELsYnWg6iYARkPmQBUoFV+c1iyeXr+3jYIlGWLJjJi
         ZC7DqCa1+JLBXgJealGyCXghyZisVw3S25YfeEuukb1aoD3GqIvMz2AZ/sn3DSgHB3VV
         Usiao19gfws22b2pzQs+RXysrT9ipsiElHDE3KE9gYOJYwp0xfNC4iLKbtHX8pAOpBic
         8/QY7V/oQpqWbqqtFizA/BlBX/HDfzxIXUq4I/ggNHOtYdrr94jBUfsXgkBWl6rX0hG/
         qpXK+3htkGFYNLa+Gn2tdwuKO0M+/9eZ7JbNbq0bGoaItqULktA+GA3JTJBVQ7vkH9VM
         y5Zw==
X-Gm-Message-State: AOAM532twG+AzK8+OIUpMdTM58l5RqdnLq8R1QPLbI0+GCuzy3DyKt/8
        jjLAPtWFlS3M8gf7E5/BMz5iIafGZ6oL5fkLdFa1ig/dKq48mtLF7/4o2f+uM6uHxqOivtbAwI4
        YyH2sILqy+YyK
X-Received: by 2002:adf:c3cd:: with SMTP id d13mr5175544wrg.15.1603291611222;
        Wed, 21 Oct 2020 07:46:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyLuiHz/EA1MVlnS6k5vCNG0L0fXDex1R+1gOApxkZZ9bGeCuNXSExKywBkiIGO4shIJ4ZYZg==
X-Received: by 2002:adf:c3cd:: with SMTP id d13mr5175499wrg.15.1603291610994;
        Wed, 21 Oct 2020 07:46:50 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id j17sm3943426wrw.68.2020.10.21.07.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 07:46:50 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe\, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen\, Andi" <andi.kleen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [RFCv2 00/16] KVM protected memory extension
In-Reply-To: <20201020134924.2i4z4kp6bkiheqws@box>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com> <87ft6949x8.fsf@vitty.brq.redhat.com> <20201020134924.2i4z4kp6bkiheqws@box>
Date:   Wed, 21 Oct 2020 16:46:48 +0200
Message-ID: <87eelr4ox3.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Kirill A. Shutemov" <kirill@shutemov.name> writes:

> On Tue, Oct 20, 2020 at 09:46:11AM +0200, Vitaly Kuznetsov wrote:
>> "Kirill A. Shutemov" <kirill@shutemov.name> writes:
>> 
>> > == Background / Problem ==
>> >
>> > There are a number of hardware features (MKTME, SEV) which protect guest
>> > memory from some unauthorized host access. The patchset proposes a purely
>> > software feature that mitigates some of the same host-side read-only
>> > attacks.
>> >
>> >
>> > == What does this set mitigate? ==
>> >
>> >  - Host kernel ”accidental” access to guest data (think speculation)
>> >
>> >  - Host kernel induced access to guest data (write(fd, &guest_data_ptr, len))
>> >
>> >  - Host userspace access to guest data (compromised qemu)
>> >
>> >  - Guest privilege escalation via compromised QEMU device emulation
>> >
>> > == What does this set NOT mitigate? ==
>> >
>> >  - Full host kernel compromise.  Kernel will just map the pages again.
>> >
>> >  - Hardware attacks
>> >
>> >
>> > The second RFC revision addresses /most/ of the feedback.
>> >
>> > I still didn't found a good solution to reboot and kexec. Unprotect all
>> > the memory on such operations defeat the goal of the feature. Clearing up
>> > most of the memory before unprotecting what is required for reboot (or
>> > kexec) is tedious and error-prone.
>> > Maybe we should just declare them unsupported?
>> 
>> Making reboot unsupported is a hard sell. Could you please elaborate on
>> why you think that "unprotect all" hypercall (or rather a single
>> hypercall supporting both protecting/unprotecting) defeats the purpose
>> of the feature?
>
> If guest has some data that it prefers not to leak to the host and use the
> feature for the purpose, share all the memory to get through reboot is a
> very weak point.
>

My point that if it knows that there's something sensitive in its
memory it should clean it up even today without your feature before
rebooting to an unknown target.

>> 
>> clean up *all* its memory upon reboot, however:
>> - It may only clean up the most sensitive parts. This should probably be
>> done even without this new feature and even on bare metal (think about
>> next boot target being malicious).
>> - The attack window shrinks significantly. "Speculative" bugs require
>> time to exploit and it will only remain open until it boots up again
>> (few seconds).
>
> Maybe it would be cleaner to handle reboot in userspace? If we got the VM
> rebooted, just reconstruct it from scratch as if it would be new boot.

We are definitely not trying to protect against malicious KVM so maybe
we can do the cleanup there (when protection was enabled) so we can
unprotect everything without risk of a leak?

-- 
Vitaly

