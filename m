Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74908274262
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 14:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgIVMul (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 08:50:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23774 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726563AbgIVMuk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 08:50:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600779039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rBy/ewZFYuHcIeTKmOeoXntrF9t6VS/+90A1J5EVLLs=;
        b=bmZvDR7YNHYZi11nqmzumm30s44rpA838tlVBrEpoXSKh2l86HO7rsCYPZ/S3hMkHwimd0
        zYx1vCNKh42d2ffCAwdqaByOdvgJPYJrfXIXjsZ3o3FacQoJCP20gR1pkvhFKf5naM8acO
        MfrCfoBluEUuqZUmoUTPmFsTDPJz2co=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-HUr0jzRPPDWcgHzwt8UI7w-1; Tue, 22 Sep 2020 08:50:37 -0400
X-MC-Unique: HUr0jzRPPDWcgHzwt8UI7w-1
Received: by mail-wr1-f69.google.com with SMTP id h4so7409695wrb.4
        for <kvm@vger.kernel.org>; Tue, 22 Sep 2020 05:50:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rBy/ewZFYuHcIeTKmOeoXntrF9t6VS/+90A1J5EVLLs=;
        b=hQz6uMgOnHsrtfbOMItq+KYiUTeaoxYaqQ7JG4yf3t0/cg8g7Kr4FKq4wRb3CCjqDg
         PMStrtdN2LrIpv+S0yOBCnaS3MtYoVelXa5LNk5CRLUygIc9YAEirsrCA8ANCvsVz8fz
         UPiDTSJm185u+KclZgjkTnnM5eUeGrdAfYkoQmf2yt/h10nTFk+ITfXi0hJrw7vXCT08
         MQ89WpAj+39dR3O79gEBzz02KA45l44Ww3N8+4BfSlB+HmdJZnvn8h/SEz3QkgIEB+cs
         /qcgx+uxbpgOTpgg/9rZ/T0oCEPnNsnk0R5B+NoLgR4hWIWv6yTqqy6I+G10bkDX5h0F
         UPrA==
X-Gm-Message-State: AOAM531RKP4P2OGgsD+tIxjiJ6evA/6Lm4D5xDzAzIbqDNRcy6TsOgHy
        TD+DzzZc8lUTvEuhDTxX7gA2IQ5VItbyLXOpOZeZoCgsoFqWfUxEqV4hBP4JvTDnMOnrGfrTUoy
        sSsc4u7a/UwZI
X-Received: by 2002:a5d:570b:: with SMTP id a11mr5367291wrv.139.1600779036412;
        Tue, 22 Sep 2020 05:50:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxaMutgSK9zT2Z/t3qizYV4H60BXFyLtlUFxU1c3gSGzb45WPn7A4MrDiZBlX0euAM5Vo8FYw==
X-Received: by 2002:a5d:570b:: with SMTP id a11mr5367262wrv.139.1600779036221;
        Tue, 22 Sep 2020 05:50:36 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec2c:90a9:1236:ebc6? ([2001:b07:6468:f312:ec2c:90a9:1236:ebc6])
        by smtp.gmail.com with ESMTPSA id v17sm27868565wrc.23.2020.09.22.05.50.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 05:50:35 -0700 (PDT)
Subject: Re: [PATCH v2 1/1] KVM: x86: fix MSR_IA32_TSC read for nested
 migration
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20200921103805.9102-1-mlevitsk@redhat.com>
 <20200921103805.9102-2-mlevitsk@redhat.com>
 <20200921162326.GB23989@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <de9411ce-aa83-77c8-b2ae-a3873250a0b1@redhat.com>
Date:   Tue, 22 Sep 2020 14:50:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200921162326.GB23989@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/09/20 18:23, Sean Christopherson wrote:
> Avoid "should" in code comments and describe what the code is doing, not what
> it should be doing.  The only exception for this is when the code has a known
> flaw/gap, e.g. "KVM should do X, but because of Y, KVM actually does Z".
> 
>> +		 * return it's real L1 value so that its restore will be correct.
> s/it's/its
> 
> Perhaps add "unconditionally" somewhere, since arch.tsc_offset can also contain
> the L1 value.  E.g. 
> 
> 		 * Unconditionally return L1's TSC offset on userspace reads
> 		 * so that userspace reads and writes always operate on L1's
> 		 * offset, e.g. to ensure deterministic behavior for migration.
> 		 */
> 

Technically the host need not restore MSR_IA32_TSC at all.  This follows
the idea of the discussion with Oliver Upton about transmitting the
state of the kvmclock heuristics to userspace, which include a (TSC,
CLOCK_MONOTONIC) pair to transmit the offset to the destination.  All
that needs to be an L1 value is then the TSC value in that pair.

I'm a bit torn over this patch.  On one hand it's an easy solution, on
the other hand it's... just wrong if KVM_GET_MSR is used for e.g.
debugging the guest.

I'll talk to Maxim and see if he can work on the kvmclock migration stuff.

Paolo

