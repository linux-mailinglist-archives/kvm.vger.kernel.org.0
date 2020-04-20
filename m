Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7EA81B1806
	for <lists+kvm@lfdr.de>; Mon, 20 Apr 2020 23:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgDTVHb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 17:07:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47275 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726294AbgDTVHa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Apr 2020 17:07:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587416849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T/IYN1616yr1SA6PkPQ11e2tZILCIQKcMMBO70ZP5s8=;
        b=MRo8NdHHz4DMRiPozfQUng94r0qHEsdC4Movr/ZnOgbOW0MMrtM/e6mfyIxBuzNsJE6N4A
        F12TCKVPc6d52Oz8NK7c1X8qWqJDMGdKOMERx/nbYjy2hZtRI5GK0Z2Wu16//jp/km+nyU
        yaw90Zy9xQHH+SQHmjg1KrObKam4/s4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-q4DJKvGYOTiaof3fZ1H9_g-1; Mon, 20 Apr 2020 17:07:28 -0400
X-MC-Unique: q4DJKvGYOTiaof3fZ1H9_g-1
Received: by mail-wm1-f71.google.com with SMTP id f81so454619wmf.2
        for <kvm@vger.kernel.org>; Mon, 20 Apr 2020 14:07:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T/IYN1616yr1SA6PkPQ11e2tZILCIQKcMMBO70ZP5s8=;
        b=P+zvXE+YEgeuW6PEmYZdCPiRaeXvQ1dp496gvaqUa9qOd5I7xcvSKOL2EJ6XfbyWiM
         t+mAsilMPf8Zwy8TH42fkHtdva/p9LdX0E/HfedJngcWe0DMYyxBdBHrXVazi6f33j0P
         HxIApwmZls2K+YCUV43O73LRhFHa4HQtKEbTMbeegoxM0cHUbDF2AwPZeMxYtOuI/eGC
         nWqqJlEm+ZD4LSnkd/4+znD5TvFwXm2Ph8BdERppLQgI4MzjTRe0JJKQfHDWcJN3gYdC
         L9W0MKhh2NO1r4Co8kG4/vgu8E9MRcdvYoUuHKcCaU+FKt/CYcRdIytLSjFMR/J9TppF
         +kqQ==
X-Gm-Message-State: AGi0PubiWnD6S3Dwj/mmfszIcEB7baZmbtyEAKazCY6B3wpVNkJ+VxpP
        MYu7nLpIfj2tHoC86/ArMXlGKJaNS2/a7KxJTlYRn5zg8giRbqETNAOu8JhM0b68n7G0axmZOO1
        su4TnWi3vTwsL
X-Received: by 2002:adf:dec9:: with SMTP id i9mr17364170wrn.197.1587416846888;
        Mon, 20 Apr 2020 14:07:26 -0700 (PDT)
X-Google-Smtp-Source: APiQypJOqoIAgfv+Cg9KTxLRZbcaffpkxlufOwb7c1SleGl00WZf2mNcXeq7YYmz7qNJxCGApScq8g==
X-Received: by 2002:adf:dec9:: with SMTP id i9mr17364149wrn.197.1587416846652;
        Mon, 20 Apr 2020 14:07:26 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5c18:5523:c13e:fa9f? ([2001:b07:6468:f312:5c18:5523:c13e:fa9f])
        by smtp.gmail.com with ESMTPSA id b191sm809910wmd.39.2020.04.20.14.07.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 14:07:26 -0700 (PDT)
Subject: Re: [PATCH] kvm: add capability for halt polling
To:     Jon Cargille <jcargill@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200417221446.108733-1-jcargill@google.com>
 <87d083td9f.fsf@vitty.brq.redhat.com>
 <CANxmayg3ML5_w=pY3=x7_TLOqawojxYGbqMLrXJn+r0b_gvWgA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <02848f20-ecf9-550b-9b55-0260b05f6ecd@redhat.com>
Date:   Mon, 20 Apr 2020 23:07:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CANxmayg3ML5_w=pY3=x7_TLOqawojxYGbqMLrXJn+r0b_gvWgA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/04/20 20:47, Jon Cargille wrote:
> Great question, Vitaly.  We actually implemented this as a per-VCPU property
> initially; however, our user-space implementation was only using it to apply
> the same value to all VCPUs, so we later simplified it on the advice of
> Jim Mattson. If there is a consensus for this to go in as per-VCPU rather
> than per-VM, I'm happy to submit that way instead. The per-VM version did
> end up looking simpler, IMO.

Yeah, I am not sure what the usecase would be for per-vCPU halt polling.

You could perhaps disable halt polling for vCPUs that are not placed on
isolated physical CPUs (devoting those vCPUs to housekeeping), but it
seems to me that this would be quite hard to get right.  But in that
case you would probably prefer to disable HLT vmexits completely, rather
than use halt polling.

Paolo

