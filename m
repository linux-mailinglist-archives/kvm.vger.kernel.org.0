Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F34F3BC1DD
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 18:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhGERAY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jul 2021 13:00:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35052 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229652AbhGERAX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Jul 2021 13:00:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625504266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NRt+Adp4e/5DqWeJnNZwJwNekN9wq5BW7MLMJkM77B0=;
        b=P36rjB4Aun0s30ZTEq2C0+Lv79XjqyH+aN7Lu7KfaDSWMw8r/oNYx1c3l2GpIbt7VvNcTN
        W5tl1TzglvKJOOFxasmZc+DK2dB0YKf9mlXssy3l3I1GDVdTDXEPOA5V24gR9RgPVyzbks
        sGrWPcOC5MBb5gjxovHttV4bDrXUQ6I=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-HhWumVUANYu2eKLFCamjRA-1; Mon, 05 Jul 2021 12:57:45 -0400
X-MC-Unique: HhWumVUANYu2eKLFCamjRA-1
Received: by mail-wr1-f69.google.com with SMTP id u16-20020a5d6ad00000b0290137417d88cfso153910wrw.20
        for <kvm@vger.kernel.org>; Mon, 05 Jul 2021 09:57:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NRt+Adp4e/5DqWeJnNZwJwNekN9wq5BW7MLMJkM77B0=;
        b=aoqg2fRJn0ud0R8yAmIgRqZuMbYt2CyTNjCYacyFo1j2HWAR+cUhanW8DhYF9WxHdQ
         REPdMXwoW4PTl7618Q3yfhW/hjQHUc8vQb+WyRQZwvRkG+gMt4oRJ7IrZ6DC8d7P8AUU
         YPKXVscuotKYa9jriQF1vE62W/3pF87yJs2eLACLbJqIaystOAdEcYelCABapkt97ahY
         hF6XSF8XH9pI7hZ3B784YKF7WKHT/m5zbb85fWBWr/Dth0xIX1uWp4X9lnBnbvpq6cz9
         OyR0kVgerI1QnBg3jdHxAKVG3pPPzvBm1+0vS6+8PwHYE12Obo5gAkQXaavLB0u/WBGf
         L7Tg==
X-Gm-Message-State: AOAM531NlHTrXaAl7n0haqWtWRSRKKO+VAB72j8VPscPjJE1aqDCJujy
        PjzZKUGYw+M4AKLf6UgqpLdT9uCeTp11aS9573pgDLq9+R/y0jvos9z9aMdGRLg0fslHxvu28/X
        xcRN4aHqCEsfY
X-Received: by 2002:adf:fac7:: with SMTP id a7mr16721557wrs.384.1625504263893;
        Mon, 05 Jul 2021 09:57:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwbCyZ+1Tu2rvGrznxgPZJrHO62wYyvyclAmXH8puX+YGe5rKOQwYBSYJq+dGKas0KoJ49L9A==
X-Received: by 2002:adf:fac7:: with SMTP id a7mr16721541wrs.384.1625504263751;
        Mon, 05 Jul 2021 09:57:43 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id m7sm443159wms.0.2021.07.05.09.57.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jul 2021 09:57:43 -0700 (PDT)
Subject: Re: [RFC PATCH 0/8] Derive XSAVE state component offsets from CPUID
 leaf 0xd where possible
To:     David Edmondson <david.edmondson@oracle.com>, qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, babu.moger@amd.com,
        Cameron Esfahani <dirty@apple.com>,
        Eduardo Habkost <ehabkost@redhat.com>
References: <20210705104632.2902400-1-david.edmondson@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <811b9dd2-1e9f-d0fc-d3cb-c95671ac09ea@redhat.com>
Date:   Mon, 5 Jul 2021 18:57:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210705104632.2902400-1-david.edmondson@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/07/21 12:46, David Edmondson wrote:
> The offset of XSAVE state components within the XSAVE state area is
> currently hard-coded via reference to the X86XSaveArea structure. This
> structure is accurate for Intel systems at the time of writing, but
> incorrect for newer AMD systems, as the state component for protection
> keys is located differently (offset 0x980 rather than offset 0xa80).
> 
> For KVM and HVF, replace the hard-coding of the state component
> offsets with data derived from CPUID leaf 0xd information.
> 
> TCG still uses the X86XSaveArea structure, as there is no underlying
> CPU to use in determining appropriate values.
> 
> This is a replacement for the changes in
> https://lore.kernel.org/r/20210520145647.3483809-1-david.edmondson@oracle.com,
> which simply modifed the hard-coded offsets for AMD systems.
> 
> Testing on HVF is minimal (it builds and, by observation, the XSAVE
> state component offsets reported to a running VM are accurate on an
> older Intel system).

This looks great, thanks, so I am queuing it.

Paolo

> David Edmondson (8):
>    target/i386: Declare constants for XSAVE offsets
>    target/i386: Consolidate the X86XSaveArea offset checks
>    target/i386: Clarify the padding requirements of X86XSaveArea
>    target/i386: Pass buffer and length to XSAVE helper
>    target/i386: Make x86_ext_save_areas visible outside cpu.c
>    target/i386: Observe XSAVE state area offsets
>    target/i386: Populate x86_ext_save_areas offsets using cpuid where
>      possible
>    target/i386: Move X86XSaveArea into TCG
> 
>   target/i386/cpu.c            |  18 +--
>   target/i386/cpu.h            |  41 ++----
>   target/i386/hvf/hvf-cpu.c    |  34 +++++
>   target/i386/hvf/hvf.c        |   3 +-
>   target/i386/hvf/x86hvf.c     |  19 ++-
>   target/i386/kvm/kvm-cpu.c    |  36 +++++
>   target/i386/kvm/kvm.c        |  52 +------
>   target/i386/tcg/fpu_helper.c |   1 +
>   target/i386/tcg/tcg-cpu.c    |  20 +++
>   target/i386/tcg/tcg-cpu.h    |  57 ++++++++
>   target/i386/xsave_helper.c   | 267 ++++++++++++++++++++++++++---------
>   11 files changed, 381 insertions(+), 167 deletions(-)
> 

