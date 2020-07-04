Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA7B21478A
	for <lists+kvm@lfdr.de>; Sat,  4 Jul 2020 18:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbgGDQuN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Jul 2020 12:50:13 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:55745 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727007AbgGDQuN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 4 Jul 2020 12:50:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593881410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=9vBqyjqJxTJ0Hvxp9gEsOjSbaRC8ShXJ1Dv3lfyjp2o=;
        b=BoGidCY0ba5BOJW+I4UwPP6mzbN3DuO5Ou696fHzRg6YMSi5/rrA31z2umg0NSaOjYGsK7
        P+dGEmFvlx0jHukqDFEr+33yamS5tZSpq3AV4jI1q0o4G1HDD7SIk4bm+5rwlALt+5AcJX
        HFX1OdfDF30Ob8YEDdL6Ab//Swe6Izs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-J1y4h6b2NI6xOLLOIKrryg-1; Sat, 04 Jul 2020 12:50:07 -0400
X-MC-Unique: J1y4h6b2NI6xOLLOIKrryg-1
Received: by mail-wm1-f71.google.com with SMTP id g6so34084569wmk.4
        for <kvm@vger.kernel.org>; Sat, 04 Jul 2020 09:50:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=9vBqyjqJxTJ0Hvxp9gEsOjSbaRC8ShXJ1Dv3lfyjp2o=;
        b=rQQ9+vagTUXfAfi8dh7ze0hImukJ3swDcYbFfO3pxQJrVIeHxmmP6G0qE6Mnfv+FCX
         mpaHivP1zknJLCsrpr6qhkwcXX83bV6wKfDeHoo2aLGQcIUN8uLdXmgtoDGlNtlOf0Tm
         P89rOiKn+Tf7hsrA3aKTADQbfUaz99DhnwO6Aq5UBL0kwcSKnHhsUSZWR7zlDgvEliIX
         JAnQcN7p6uuCmjacRhh6qBdqc24utms2JYAGJ6r2E8jx6ToE8Om1DstFwIa6OnDPWsTD
         5p9T6tRGTmGwAUZ7+7+8+EQw3Yr11o1zfilyyboYdaQPOKloRQSRFiB/e5jtctCpUvxv
         N2AA==
X-Gm-Message-State: AOAM531UJjiBYFCzQf6F/1JYFytyQBxtPOfcOvugTAZXDHLs53z5JA1a
        vCzym4v+6973iPdc20hXCwDzqeHVlVQl8OtuthU+nQ1fan0kbUgKkmuvbHmJnWasHfLwUJpm4Jc
        cIO8fcO0uYSh9
X-Received: by 2002:a5d:5187:: with SMTP id k7mr7357830wrv.39.1593881406104;
        Sat, 04 Jul 2020 09:50:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxTu9xKJJ+4NEHwYeOQqcTVFMTxH/iLT8xbseTSVWgbfrhk7KNCWKiN4O1uFOWjQ3oy3wsIgg==
X-Received: by 2002:a5d:5187:: with SMTP id k7mr7357818wrv.39.1593881405956;
        Sat, 04 Jul 2020 09:50:05 -0700 (PDT)
Received: from [192.168.1.39] (1.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.1])
        by smtp.gmail.com with ESMTPSA id v3sm17580444wrq.57.2020.07.04.09.50.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Jul 2020 09:50:05 -0700 (PDT)
Subject: Re: [PATCH 0/7] accel/kvm: Simplify few functions that can use global
 kvm_state
To:     qemu-devel@nongnu.org
Cc:     Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Richard Henderson <rth@twiddle.net>, qemu-s390x@nongnu.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Peter Maydell <peter.maydell@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, qemu-arm@nongnu.org,
        Cornelia Huck <cohuck@redhat.com>, qemu-ppc@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Huth <thuth@redhat.com>
References: <20200623105052.1700-1-philmd@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Autocrypt: addr=philmd@redhat.com; keydata=
 mQINBDXML8YBEADXCtUkDBKQvNsQA7sDpw6YLE/1tKHwm24A1au9Hfy/OFmkpzo+MD+dYc+7
 bvnqWAeGweq2SDq8zbzFZ1gJBd6+e5v1a/UrTxvwBk51yEkadrpRbi+r2bDpTJwXc/uEtYAB
 GvsTZMtiQVA4kRID1KCdgLa3zztPLCj5H1VZhqZsiGvXa/nMIlhvacRXdbgllPPJ72cLUkXf
 z1Zu4AkEKpccZaJspmLWGSzGu6UTZ7UfVeR2Hcc2KI9oZB1qthmZ1+PZyGZ/Dy+z+zklC0xl
 XIpQPmnfy9+/1hj1LzJ+pe3HzEodtlVA+rdttSvA6nmHKIt8Ul6b/h1DFTmUT1lN1WbAGxmg
 CH1O26cz5nTrzdjoqC/b8PpZiT0kO5MKKgiu5S4PRIxW2+RA4H9nq7nztNZ1Y39bDpzwE5Sp
 bDHzd5owmLxMLZAINtCtQuRbSOcMjZlg4zohA9TQP9krGIk+qTR+H4CV22sWldSkVtsoTaA2
 qNeSJhfHQY0TyQvFbqRsSNIe2gTDzzEQ8itsmdHHE/yzhcCVvlUzXhAT6pIN0OT+cdsTTfif
 MIcDboys92auTuJ7U+4jWF1+WUaJ8gDL69ThAsu7mGDBbm80P3vvUZ4fQM14NkxOnuGRrJxO
 qjWNJ2ZUxgyHAh5TCxMLKWZoL5hpnvx3dF3Ti9HW2dsUUWICSQARAQABtDJQaGlsaXBwZSBN
 YXRoaWV1LURhdWTDqSAoUGhpbCkgPHBoaWxtZEByZWRoYXQuY29tPokCVQQTAQgAPwIbDwYL
 CQgHAwIGFQgCCQoLBBYCAwECHgECF4AWIQSJweePYB7obIZ0lcuio/1u3q3A3gUCXsfWwAUJ
 KtymWgAKCRCio/1u3q3A3ircD/9Vjh3aFNJ3uF3hddeoFg1H038wZr/xi8/rX27M1Vj2j9VH
 0B8Olp4KUQw/hyO6kUxqkoojmzRpmzvlpZ0cUiZJo2bQIWnvScyHxFCv33kHe+YEIqoJlaQc
 JfKYlbCoubz+02E2A6bFD9+BvCY0LBbEj5POwyKGiDMjHKCGuzSuDRbCn0Mz4kCa7nFMF5Jv
 piC+JemRdiBd6102ThqgIsyGEBXuf1sy0QIVyXgaqr9O2b/0VoXpQId7yY7OJuYYxs7kQoXI
 6WzSMpmuXGkmfxOgbc/L6YbzB0JOriX0iRClxu4dEUg8Bs2pNnr6huY2Ft+qb41RzCJvvMyu
 gS32LfN0bTZ6Qm2A8ayMtUQgnwZDSO23OKgQWZVglGliY3ezHZ6lVwC24Vjkmq/2yBSLakZE
 6DZUjZzCW1nvtRK05ebyK6tofRsx8xB8pL/kcBb9nCuh70aLR+5cmE41X4O+MVJbwfP5s/RW
 9BFSL3qgXuXso/3XuWTQjJJGgKhB6xXjMmb1J4q/h5IuVV4juv1Fem9sfmyrh+Wi5V1IzKI7
 RPJ3KVb937eBgSENk53P0gUorwzUcO+ASEo3Z1cBKkJSPigDbeEjVfXQMzNt0oDRzpQqH2vp
 apo2jHnidWt8BsckuWZpxcZ9+/9obQ55DyVQHGiTN39hkETy3Emdnz1JVHTU0Q==
Message-ID: <a36faa0a-6aa9-463d-03a0-b862141a427d@redhat.com>
Date:   Sat, 4 Jul 2020 18:50:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200623105052.1700-1-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kind ping :)

On 6/23/20 12:50 PM, Philippe Mathieu-Daudé wrote:
> Following Paolo's idea on kvm_check_extension():
> https://www.mail-archive.com/qemu-devel@nongnu.org/msg713794.html
> 
> CI:
> https://travis-ci.org/github/philmd/qemu/builds/701213438
> 
> Philippe Mathieu-Daudé (7):
>   accel/kvm: Let kvm_check_extension use global KVM state
>   accel/kvm: Simplify kvm_check_extension()
>   accel/kvm: Simplify kvm_check_extension_list()
>   accel/kvm: Simplify kvm_set_sigmask_len()
>   target/i386/kvm: Simplify get_para_features()
>   target/i386/kvm: Simplify kvm_get_mce_cap_supported()
>   target/i386/kvm: Simplify kvm_get_supported_[feature]_msrs()
> 
>  include/sysemu/kvm.h         |  4 +-
>  accel/kvm/kvm-all.c          | 76 +++++++++++++++----------------
>  hw/hyperv/hyperv.c           |  2 +-
>  hw/i386/kvm/clock.c          |  2 +-
>  hw/i386/kvm/i8254.c          |  4 +-
>  hw/i386/kvm/ioapic.c         |  2 +-
>  hw/intc/arm_gic_kvm.c        |  2 +-
>  hw/intc/openpic_kvm.c        |  2 +-
>  hw/intc/xics_kvm.c           |  2 +-
>  hw/s390x/s390-stattrib-kvm.c |  2 +-
>  target/arm/kvm.c             | 13 +++---
>  target/arm/kvm32.c           |  2 +-
>  target/arm/kvm64.c           | 15 +++---
>  target/i386/kvm.c            | 88 +++++++++++++++++-------------------
>  target/mips/kvm.c            |  6 +--
>  target/ppc/kvm.c             | 34 +++++++-------
>  target/s390x/cpu_models.c    |  3 +-
>  target/s390x/kvm.c           | 30 ++++++------
>  18 files changed, 141 insertions(+), 148 deletions(-)
> 

