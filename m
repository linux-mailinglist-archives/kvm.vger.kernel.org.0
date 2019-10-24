Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD9FE3B63
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 20:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504150AbfJXSzm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 14:55:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35055 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2504146AbfJXSzm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 14:55:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571943340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=cAOA+N2bN71EPKITY5yL6YjRkecKDZKZUWEIs+kDJNY=;
        b=hYKW+ozsgIyjd0RURRSoKLeKhhSrwt/KaeeelOcJhbQbccTiSAO0RBpvP30ELAcnHE7vkw
        Dm5dkqqYtok2xpFicSfnKwV2L9MpoJZFAB4Lm8PWDlcB+fznF50TxWXkX5MsIvn5xR/aCq
        d77w6kuYtIVzfw741JmF0R6oDmHRN/k=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235--VMG0kPAOYmyd8Uc--k9mQ-1; Thu, 24 Oct 2019 14:55:39 -0400
Received: by mail-wm1-f72.google.com with SMTP id l184so1625893wmf.6
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 11:55:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wCgGFS2sMIWU7eHJyxNrAtaBgTBkC6SZ8IaR5N1ucQE=;
        b=uZkZAzv8miprF9OVfvhuNaG70zjTulxe3orf4qVAwzdp3zpEjIkHPUVbtCBfAXn1QT
         PllznOajeIlKVYSpxKV2KhYG4Pp2oYz6147K9XNC2ZxHE9zBsOWv+MHXW3VpcnMpehhJ
         CldOWz9QkZYq6YfHYdZUAGsyK35m1lI+IWngCgHb6+rlYWZIEGjmLH5zEeDDwosstosG
         5twVVjpiJ73xUSClo5jaWrWXGw2iw76jo22cKr4rLNCvu9ANYnltF4QFwirdyYUCnvqg
         k/SC9EUr2y0wLOxFvS2nugIZeofzNnYKdptefuJfX011y+mqcf6Q2VaXLsjPn3/kU2OG
         qqwA==
X-Gm-Message-State: APjAAAVQGAMkpSzogtS9unQivxDhp056+SXkvCwU0Z4ZTiP3BQ8GedX+
        Jo9fTqoZniRGtoix/vD69fOPZTUK+9yglM1XxyFTFcKyiq2SPBwHhgv3E/slVfdEQlJpoa9HFj1
        rxsgVr2AcRQWE
X-Received: by 2002:a5d:640e:: with SMTP id z14mr5106688wru.311.1571943338326;
        Thu, 24 Oct 2019 11:55:38 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyDG7cquRlsTppc4UOYrFRk4iS3+7GSH/tYTHi28UFOv+a2qbu8dwzgZMtlTYBEeGYz9SN0eA==
X-Received: by 2002:a5d:640e:: with SMTP id z14mr5106670wru.311.1571943337977;
        Thu, 24 Oct 2019 11:55:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:302c:998e:a769:c583? ([2001:b07:6468:f312:302c:998e:a769:c583])
        by smtp.gmail.com with ESMTPSA id 1sm8535942wrr.16.2019.10.24.11.55.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2019 11:55:37 -0700 (PDT)
Subject: Re: [PATCH] kvm: call kvm_arch_destroy_vm if vm creation fails
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        John Sperbeck <jsperbeck@google.com>
References: <20191023171435.46287-1-jmattson@google.com>
 <20191023182106.GB26295@linux.intel.com>
 <7e1fe902-65e3-5381-1ac8-b280f39a677d@google.com>
 <4d81887e-12d7-baaf-586b-b85020bd5eaf@redhat.com>
 <20191024181403.GD20633@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <8011b53a-5155-945e-2a46-540dc75c8922@redhat.com>
Date:   Thu, 24 Oct 2019 20:55:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191024181403.GD20633@linux.intel.com>
Content-Language: en-US
X-MC-Unique: -VMG0kPAOYmyd8Uc--k9mQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/10/19 20:14, Sean Christopherson wrote:
> On Thu, Oct 24, 2019 at 12:08:29PM +0200, Paolo Bonzini wrote:
>> On 24/10/19 04:59, Junaid Shahid wrote:
>>> AFAICT the kvm->users_count is already 0 before kvm_arch_destroy_vm()
>>> is called from kvm_destroy_vm() in the normal case.
>>
>> Yes:
>>
>>         if (refcount_dec_and_test(&kvm->users_count))
>>                 kvm_destroy_vm(kvm);
>>
>> where
>>
>> | int atomic_inc_and_test(atomic_t *v);
>> | int atomic_dec_and_test(atomic_t *v);
>> |
>> | These two routines increment and decrement by 1, respectively, the
>> | given atomic counter.  They return a boolean indicating whether the
>> | resulting counter value was zero or not.
>>
>>> So there really
>>> shouldn't be any arch that does a kvm_put_kvm() inside
>>> kvm_arch_destroy_vm(). I think it might be better to keep the
>>> kvm_arch_destroy_vm() call after the refcount_set() to be consistent
>>> with the normal path.
>>
>> I agree, so I am applying Jim's patch.
>=20
> Junaid also pointed out that x86 will dereference a NULL kvm->memslots[].
>=20
>> If anything, we may want to WARN if the refcount is not 1 before the
>> refcount_set.
>=20
> What about moving "refcount_set(&kvm->users_count, 1)" to right before th=
e
> VM is added to vm_list, i.e. after arch code and init'ing the mmu_notifie=
r?
> Along with a comment explaining the kvm_get_kvm() is illegal while the VM
> is being created.
>=20
> That'd eliminate the atmoic_set() in the error path, which is confusing,
> at least for me.  It'd also obviate the need for an explicit WARN since
> running with refcount debugging would immediately flag any arch that
> tried to use kvm_get_kvm() during kvm_arch_create_vm().
>=20
> Moving the refcount_set() could be done along with rearranging the memslo=
ts
> and buses allocation/cleanup in a preparatory patch before adding the cal=
l
> to kvm_arch_destroy_vm().

Sounds good.

Paolo

