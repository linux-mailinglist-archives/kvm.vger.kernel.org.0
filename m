Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A66102D598B
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 12:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732872AbgLJLoW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 06:44:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23817 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729526AbgLJLoN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Dec 2020 06:44:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607600564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KvmqrOo/0XzGZZg0O2HlL38Tea/AMllImc8/xdniceE=;
        b=P6Msabsn7ulzqmTZQZbU7xJYWZup0ju97VDb0jIFQ8Um2bDsVHh2w8FDCK+e86S8wyxRsW
        1H91lHuBTCuT1nk9RYdcBw4yI18N5jFuxLqYJWAFNucye4qBReJrm2EZadb9K7qiiKKmOW
        AkrByAn59ISevZJUja9VHcP76pm6x74=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-AgUeq_ZPNH-xCl0BfitZPA-1; Thu, 10 Dec 2020 06:42:40 -0500
X-MC-Unique: AgUeq_ZPNH-xCl0BfitZPA-1
Received: by mail-ej1-f71.google.com with SMTP id m11so1506022ejr.20
        for <kvm@vger.kernel.org>; Thu, 10 Dec 2020 03:42:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KvmqrOo/0XzGZZg0O2HlL38Tea/AMllImc8/xdniceE=;
        b=PJO59eN1CEkPqeiGLk8OHVxeOdcxxX/NprTPf8fGYswsbwCaPuzdD3yvOf/OAakatN
         GloxRHJlGapwXG30Mp+mBTwCHlM8p63lRGJKMO1AwSqWUS3BEw/VUVOsMWczaRcoPkcI
         WjZ+oBSYD3IEvq3bfZv6mtJDU4h9i8N4aYY6OX2VNDXS67Q+YtD6l3h9LlzTQiOd9yHc
         9dy6BDnjZ9lkdjcr0pVZSBp/O4vZuL5dQnFZCS/quQVUB/jHyllCAFii58WI0e2SYWfG
         nDVVSBgP15vidP2BpOi52/Uzy22EoecTsPBhXbs94DB73U6JVQ2I6K7iyrOeCGgr13eh
         Te6g==
X-Gm-Message-State: AOAM532gtiDR9p000zosigzwK6/uAnZEJYXMVKTxdMvhPsl+yHavzJl9
        YlIYmbS1tPnoQDxNNo2KQYJ1cmTbdY+OtQDe79Rg5Dlni/Q+pr2yGjBE5qX5HdrPkMtcJ26PeQE
        SkRTe8mVrqbsy6ZI/x/HAT7LqM4KPq5xkfs766jWCqZhfnvb51EaLCIT96J1segNU
X-Received: by 2002:aa7:d750:: with SMTP id a16mr6427701eds.252.1607600558928;
        Thu, 10 Dec 2020 03:42:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxDnncFNdeBtR5AbuscJDCn2dnIHlks3zjHEtzQPIlcl3+fqWIq6GSh1UXjMTCzrvAo0u6pJA==
X-Received: by 2002:aa7:d750:: with SMTP id a16mr6427668eds.252.1607600558665;
        Thu, 10 Dec 2020 03:42:38 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id d14sm5110475edn.31.2020.12.10.03.42.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Dec 2020 03:42:37 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 1/3] KVM: x86: implement KVM_{GET|SET}_TSC_STATE
To:     Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Shuah Khan <shuah@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Oliver Upton <oupton@google.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        kvm@vger.kernel.org
References: <20201203171118.372391-1-mlevitsk@redhat.com>
 <20201203171118.372391-2-mlevitsk@redhat.com>
 <87a6uq9abf.fsf@nanos.tec.linutronix.de>
 <1dbbeefc7c76c259b55582468ccd3aab35a6de60.camel@redhat.com>
 <87im9dlpsw.fsf@vitty.brq.redhat.com>
 <875z5d5x9m.fsf@nanos.tec.linutronix.de>
Message-ID: <b6e0656b-4e3f-cf47-5ec9-eead44b2f2e9@redhat.com>
Date:   Thu, 10 Dec 2020 12:42:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <875z5d5x9m.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/12/20 18:41, Thomas Gleixner wrote:
> Right this happens still occasionally, but for quite some time this is
> 100% firmware sillyness and not a fundamental property of the hardware
> anymore.

It's still a fundamental property of old hardware.  Last time I tried to 
kill support for processors earlier than Core 2, I had to revert it. 
That's older than Nehalem.

>> We try to catch such situation in KVM instead of blowing up but
>> this may still result in subtle bugs I believe. Maybe we would be better
>> off killing all VMs in case TSC ever gets unsynced (by default).
> 
> I just ran a guest on an old machine with unsynchronized TSCs and was
> able to observe clock monotonic going backwards between two threads
> pinned on two vCPUs, which _is_ bad. Getting unsynced clocks reliably
> under control is extremly hard.

Using kvmclock?  (Half serious: perhaps a good reason to have per-vCPU 
offsets is to be able to test what happens with unsynchronized TSCs...).

Paolo

