Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3BE7E4FA9
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 16:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440538AbfJYO4b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 10:56:31 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27162 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2440504AbfJYO4b (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Oct 2019 10:56:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572015389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=apfDNP7qOTqc98t4L1zft0iAAqrBFsKIrsjuAJggX1U=;
        b=TRedQsttzsmxVV/Esp2rjNcBZ+XT8KAJxT0y74AUD0OMmM5ynsWwogVWqX7UJKSi2OlY0G
        /sM5DGlyxcYqRMSnNnCGP+dt1c5mP3j0G/WNbWy460ony9Q+0FEvYiLqeD3Mlxq3RXRfDJ
        +5dS3uVlIZQUWP+GtI5u8bEizmmzTTA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-Vq0pV2-XP7KeZm2nQyXAiQ-1; Fri, 25 Oct 2019 10:56:26 -0400
Received: by mail-wm1-f70.google.com with SMTP id m68so1113058wme.7
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2019 07:56:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AeZtpGJUzqvV54C8QXNhdSNmQ96ov10tiDoWNcM/ptk=;
        b=Sl7fsmL5hAlQN0FRNSKZqn7KiynEvyJ0UQb01SI4BetVhqhc7eCt1gXq8s11SfvZzK
         z8Y7vWEyM22aTu7ZjOXTVCzZt9OBWRE/X0GWTqfI1Sgs2xS9XVYlJ20oOjMpqoE5fSpF
         SdWcJ6ZexuM0BSAJl35T5Ur3yTHW/khi/B3LbcbgvgGAQ6Emlk3mqtRTSnKsRZpBea0G
         1iaQgDYU2mmzg23dacHWKl32siYIooqhdK6b6U3z0PsWzxBCwIBSH9Y0Tx4H/D7YRNVr
         BY8LgfCVJtDqz0F8DdT1rcOQOz/FcS0QEPtEiQDgQGTHEfvflIuOQZSjpyXnyKwYZXUp
         DSHw==
X-Gm-Message-State: APjAAAUZHxI5nuNFQyHdQLQGT2F30vldK268pKHTr0sXyvQ4uY4pAyPu
        Lo/mutlyHZLSvOl5OS06HaiFkxENnl0oKzXsg6foDGNDOTWK2S63Ol3ptYx+Q15mTQeb9dhJqOJ
        hsBJIFm0j4Zo5
X-Received: by 2002:a7b:c3cf:: with SMTP id t15mr3831537wmj.85.1572015385503;
        Fri, 25 Oct 2019 07:56:25 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy4nkN62YvPlYZq7lWsNCGVMsWsFrFtvtpVzHzn1CC9qRPqlio7LamRXVSAX72pHG2aX1DXfQ==
X-Received: by 2002:a7b:c3cf:: with SMTP id t15mr3831513wmj.85.1572015385208;
        Fri, 25 Oct 2019 07:56:25 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9c7b:17ec:2a40:d29? ([2001:b07:6468:f312:9c7b:17ec:2a40:d29])
        by smtp.gmail.com with ESMTPSA id p1sm2306590wmg.11.2019.10.25.07.56.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Oct 2019 07:56:24 -0700 (PDT)
Subject: Re: [PATCH v3 3/3] kvm: call kvm_arch_destroy_vm if vm creation fails
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        John Sperbeck <jsperbeck@google.com>,
        Junaid Shahid <junaids@google.com>
References: <20191024230327.140935-1-jmattson@google.com>
 <20191024230327.140935-4-jmattson@google.com>
 <20191024232943.GJ28043@linux.intel.com>
 <48109ee1-f204-b7d4-6c4f-458b59f7c428@redhat.com>
 <20191025144848.GA17290@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <7fa85679-7325-4373-55a1-bb2cd274fec3@redhat.com>
Date:   Fri, 25 Oct 2019 16:56:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191025144848.GA17290@linux.intel.com>
Content-Language: en-US
X-MC-Unique: Vq0pV2-XP7KeZm2nQyXAiQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/10/19 16:48, Sean Christopherson wrote:
>> It seems to me that kvm_get_kvm() in=20
>> kvm_arch_init_vm() should be okay as long as it is balanced in=20
>> kvm_arch_destroy_vm().  So we can apply patch 2 first, and then:
> No, this will effectively leak the VM because you'll end up with a cyclic=
al
> reference to kvm_put_kvm(), i.e. users_count will never hit zero.
>=20
> void kvm_put_kvm(struct kvm *kvm)
> {
> =09if (refcount_dec_and_test(&kvm->users_count))
> =09=09kvm_destroy_vm(kvm);
> =09=09|
> =09=09-> kvm_arch_destroy_vm()
> =09=09   |
> =09=09   -> kvm_put_kvm()
> }

There's two parts to this:

- if kvm_arch_init_vm() calls kvm_get_kvm(), then kvm_arch_destroy_vm()
won't be called until the corresponding kvm_put_kvm().

- if the error case causes kvm_arch_destroy_vm() to be called early,
however, that'd be okay and would not leak memory, as long as
kvm_arch_destroy_vm() detects the situation and calls kvm_put_kvm() itself.

One case could be where you have some kind of delayed work, where the
callback does kvm_put_kvm.  You'd have to cancel the work item and call
kvm_put_kvm in kvm_arch_destroy_vm, and you would go through that path
if kvm_create_vm() fails after kvm_arch_init_vm().

Paolo

