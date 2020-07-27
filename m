Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8934622F4B0
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 18:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731550AbgG0QRG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 12:17:06 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:57073 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731548AbgG0QRE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Jul 2020 12:17:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595866622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BsUwnhDK87WKgN3gqd90CcbtRyIxe05OQOcWAwl8fSE=;
        b=AFoLLC2qS99U3G9pEMQhxwwf5A9rH4NoyCWBiy1jyRpZd30b82U905HQ+02H0kGXnabuUa
        nFsAz8udCXgmwrz49sRt8rrqr/DNGI/8XVs6hbjfTtZ0Xp+NuZOjMDrYdux5V36cDeCgu/
        HOUOAuz7dF1u98iQvCwbQHXLQLtpS14=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-67-onv0KavHMWGMq9CX_B4SUw-1; Mon, 27 Jul 2020 12:17:00 -0400
X-MC-Unique: onv0KavHMWGMq9CX_B4SUw-1
Received: by mail-wr1-f70.google.com with SMTP id d6so2552387wrv.23
        for <kvm@vger.kernel.org>; Mon, 27 Jul 2020 09:16:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BsUwnhDK87WKgN3gqd90CcbtRyIxe05OQOcWAwl8fSE=;
        b=Mqrg07cIGhvYwsheqXwoDiSS2E4srK8dR8C6urFpr565dpRmW6EX2RyPb+yfljcmZI
         Ue5zxeq4NEsB0wz53aH6mVPLZGPnain6QqCGzjgDIHK5kWiPHPDKg9k6Xqb3JLgGYFaW
         enVgHkC8KEkYwuNXQx1mrCh4F0uwFFA7mTIMekZ3Tt90mztZxH0n/7NSHvBPFwSWhJJ/
         MXoSSzZqQHF5dq0pg4ripqv8n1LWfmvxKlMqux9HxOGHegk1wXQlUcxT6UBjbV1D4HJi
         EVHKUI9Mh9mTP6mZISkLZCPkKgeSGWwTSaCmRTc/gjp4Ccgt3a/5ZqA34cnNpd1DvPU2
         3ZXQ==
X-Gm-Message-State: AOAM5311f2XJbK8otv/FIOj46mLYrw9Mku8gNzSN0HtqeSk7DlGxWnQy
        dLGQJM79cNQBz9ws5K5CnMDipZyOQLTRWXfUh/A+qXUDgE9I/to/f004E9Rbc3XF5IWBHjWZd6Y
        SEnXhEvSLJRle
X-Received: by 2002:a1c:6408:: with SMTP id y8mr84044wmb.52.1595866618759;
        Mon, 27 Jul 2020 09:16:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxLKcAmtjP5qdwtcop3VZz69phHqUmhA/GYnUvT8EjsYnFf+2mjdi7w0x6HCc4EEuewJ9M+uA==
X-Received: by 2002:a1c:6408:: with SMTP id y8mr84025wmb.52.1595866618480;
        Mon, 27 Jul 2020 09:16:58 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id u66sm76686wmu.37.2020.07.27.09.16.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2020 09:16:57 -0700 (PDT)
Subject: Re: [PATCH] KVM: nVMX: properly pad struct kvm_vmx_nested_state_hdr
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
References: <20200713082824.1728868-1-vkuznets@redhat.com>
 <20200713151750.GA29901@linux.intel.com>
 <878sfntnoz.fsf@vitty.brq.redhat.com>
 <85fd54ff-01f5-0f1f-1bb7-922c740a37c1@redhat.com>
 <20200727154654.GA8675@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5d50ea1e-f2a2-8aa9-1dd3-4cbca6c6f885@redhat.com>
Date:   Mon, 27 Jul 2020 18:16:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200727154654.GA8675@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/07/20 17:46, Sean Christopherson wrote:
>> It might as well send it now if the code didn't attempt to zero the
>> struct before filling it in (this is another good reason to use a
>> "flags" field to say what's been filled in).
> The issue is that flags itself could hold garbage.
> 
> https://lkml.kernel.org/r/20200713151750.GA29901@linux.intel.com

Quoting from there:

> Which means that userspace built for the old kernel will potentially send in
> garbage for the new 'flags' field due to it being uninitialized stack data,
> even with the layout after this patch.

Userspace should always zero everything.  I don't think that the padding
between fields is any different from the other bytes padding the header
to 128 bytes.

>   struct kvm_vmx_nested_state_hdr hdr = {
>       .vmxon_pa = root,
>       .vmcs12_pa = vmcs12,
>   };
> 
> QEMU won't see issues because it zero allocates the entire nested state.
> 
> All the above being said, after looking at the whole picture I think padding
> the header is a moot point.  The header is padded out to 120 bytes[*] when
> including in the full nested state, and KVM only ever consumes the header in
> the context of the full nested state.  I.e. if there's garbage at offset 6,
> odds are there's going to be garbage at offset 18, so internally padding the
> header does nothing.

Yes, that was what I was hinting at with "it might as well send it now"
(i.e., after the patch).

(All of this is moot for userspace that just uses KVM_GET_NESTED_STATE
and passes it back to KVM_SET_NESTED_STATE).

> KVM should be checking that the unused bytes of (sizeof(pad) - sizeof(vmx/svm))
> is zero if we want to expand into the padding in the future.  Right now we're
> relying on userspace to zero allocate the struct without enforcing it.

The alternative, which is almost as good, is to only use these extra
fields which could be garbage if the flags are not set, and check the
flags (see the patches I have sent earlier today).

The chance of the flags passing the check will decrease over time as
more flags are added; but the chance of having buggy userspace that
sends down garbage also will.

> [*] Amusing side note, the comment in the header is wrong.  It states "pad
>     the header to 128 bytes", but only pads it to 120 bytes, because union.
> 
> /* for KVM_CAP_NESTED_STATE */
> struct kvm_nested_state {
> 	__u16 flags;
> 	__u16 format;
> 	__u32 size;
> 
> 	union {
> 		struct kvm_vmx_nested_state_hdr vmx;
> 		struct kvm_svm_nested_state_hdr svm;
> 
> 		/* Pad the header to 128 bytes.  */
> 		__u8 pad[120];
> 	} hdr;

There are 8 bytes before the union, and it's not a coincidence. :)
"Header" refers to the stuff before the data region.

> Odds are no real VMM will have issue given the dynamic size of struct
> kvm_nested_state, but 

... *suspence* ...

Paolo

