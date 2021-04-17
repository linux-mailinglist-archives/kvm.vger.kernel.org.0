Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B60363003
	for <lists+kvm@lfdr.de>; Sat, 17 Apr 2021 15:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236407AbhDQMrx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Apr 2021 08:47:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33979 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236283AbhDQMrs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 17 Apr 2021 08:47:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618663641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uQtldtf06vCuCMFfu9MNiH7bfVCIHZm3b7M33WAhmmY=;
        b=Iq4UnRzZ8pMt3eW7c6efytqE4RAj775x77Xleh9ZGSFsXD4CAJKl04o9i9bYGnT4fjenh+
        pz1lA9VmbfZ1fT5FbRtQpvxoV/AVFBG6ROFawVk8HJUefBhZqyIlmk92RwzEpFNLJZDf2J
        4wMc2Gi9aDRuQU0nDM0C4ob2f2pDa/A=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-y7k0XThbNIO8daseIQiCvg-1; Sat, 17 Apr 2021 08:47:20 -0400
X-MC-Unique: y7k0XThbNIO8daseIQiCvg-1
Received: by mail-ed1-f72.google.com with SMTP id bm19-20020a0564020b13b02903789d6e74b5so8556281edb.21
        for <kvm@vger.kernel.org>; Sat, 17 Apr 2021 05:47:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uQtldtf06vCuCMFfu9MNiH7bfVCIHZm3b7M33WAhmmY=;
        b=aP8SI5r2Oi33y6j3TqA9jHv6A16ogN0TW3OYLHSBBbOhgoyVbJtuq1wMf59hkYnNNG
         aJzdCIADOK5qEqvPjXCUp4YM043c5L+zlXN4gHI/W8ywQv+x8k/riy9B/mp+1HQD9FhY
         nuZDkP/ac302iuiZaU7tEF2UarSEH4N7lSNSAT5ZPjF65AIHqFwtOur3UMgavnHxDrwZ
         1HtiZ4ND1z/KYZYJ5v53+LZSFk+Dy1bWUpzpa3lYgLGnf7LglGf73v87egEziy2yLVWN
         aIsaqdJIbWbkVNFZHexx8ZaHhHjKNuWhzGrNQLd1o6o6RGt6ZQI6e0dnmpVCUZa4JQgE
         WWyw==
X-Gm-Message-State: AOAM5309lRrQW0p5dbNmis3RJflGE2QJ76O4e2yOqhjWIJw1BzeSi6I7
        jqEv6k4qb5eeMseMee11sjzyIRKek34Y73XUlPxZ3lT7Vj3E24Dm66kaUOAA1EWOjSblbi9/wof
        OXRQUWpVujWea
X-Received: by 2002:a05:6402:5252:: with SMTP id t18mr15723030edd.258.1618663638886;
        Sat, 17 Apr 2021 05:47:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwXta7hhelgA+r2YxcZQcgzga5nb49Ilr6PXHoMp2MOVXvEcQCEpv0JEj0sDeDgNSu2LdGdow==
X-Received: by 2002:a05:6402:5252:: with SMTP id t18mr15723004edd.258.1618663638740;
        Sat, 17 Apr 2021 05:47:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id bh14sm6293284ejb.104.2021.04.17.05.47.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Apr 2021 05:47:18 -0700 (PDT)
Subject: Re: [PATCH v2 0/8] ccp: KVM: SVM: Use stack for SEV command buffers
To:     Sean Christopherson <seanjc@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
References: <20210406224952.4177376-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1932d295-5e16-ebb6-b25a-5957f5d7d3ea@redhat.com>
Date:   Sat, 17 Apr 2021 14:47:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210406224952.4177376-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/04/21 00:49, Sean Christopherson wrote:
> This series teaches __sev_do_cmd_locked() to gracefully handle vmalloc'd
> command buffers by copying _all_ incoming data pointers to an internal
> buffer before sending the command to the PSP.  The SEV driver and KVM are
> then converted to use the stack for all command buffers.
> 
> Tested everything except sev_ioctl_do_pek_import(), I don't know anywhere
> near enough about the PSP to give it the right input.
> 
> v2:
>    - Rebase to kvm/queue, commit f96be2deac9b ("KVM: x86: Support KVM VMs
>      sharing SEV context").
>    - Unconditionally copy @data to the internal buffer. [Christophe, Brijesh]
>    - Allocate a full page for the buffer. [Brijesh]
>    - Drop one set of the "!"s. [Christophe]
>    - Use virt_addr_valid() instead of is_vmalloc_addr() for the temporary
>      patch (definitely feel free to drop the patch if it's not worth
>      backporting). [Christophe]
>    - s/intput/input/. [Tom]
>    - Add a patch to free "sev" if init fails.  This is not strictly
>      necessary (I think; I suck horribly when it comes to the driver
>      framework).   But it felt wrong to not free cmd_buf on failure, and
>      even more wrong to free cmd_buf but not sev.
> 
> v1:
>    - https://lkml.kernel.org/r/20210402233702.3291792-1-seanjc@google.com
> 
> Sean Christopherson (8):
>    crypto: ccp: Free SEV device if SEV init fails
>    crypto: ccp: Detect and reject "invalid" addresses destined for PSP
>    crypto: ccp: Reject SEV commands with mismatching command buffer
>    crypto: ccp: Play nice with vmalloc'd memory for SEV command structs
>    crypto: ccp: Use the stack for small SEV command buffers
>    crypto: ccp: Use the stack and common buffer for status commands
>    crypto: ccp: Use the stack and common buffer for INIT command
>    KVM: SVM: Allocate SEV command structures on local stack
> 
>   arch/x86/kvm/svm/sev.c       | 262 +++++++++++++----------------------
>   drivers/crypto/ccp/sev-dev.c | 197 +++++++++++++-------------
>   drivers/crypto/ccp/sev-dev.h |   4 +-
>   3 files changed, 196 insertions(+), 267 deletions(-)
> 

Queued, thanks.

Paolo

