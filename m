Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7BEEDF1C1
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 17:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729476AbfJUPlM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 11:41:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27528 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727344AbfJUPlM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 11:41:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571672470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=uUcM1JsMmI/DwaYZrQj9OYriCGxM/IxKarb+jxdv4Gc=;
        b=FcjrMbA8lMsshslYLyHtHgFbuvYSlrZ1lqBEUgE6LKamxMAykpriagT7us143tKTV4ZWMc
        Ih9LYv4fgLKutGtxVu8awFEb7nM3dRU0o21fSUGURWe2HYIE7UYnAGk069jGykexWSQ2IU
        msujfZx2Bug+CS9c44dVQIVmcZ+EIJ8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-F82qZlZuNiOWIXEPoP5wuQ-1; Mon, 21 Oct 2019 11:41:07 -0400
Received: by mail-wm1-f72.google.com with SMTP id m68so1359935wme.7
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 08:41:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ChElHiyGJ1JAMv5XXN9coMj2t+12jgK/1cGjR+cKbCw=;
        b=Kn5L9go1CTgY4or/srJcBqxGnnOJerFdsDe9dMLCHLsYhRdF7X2DM2j43w7LK/Wrwz
         MkrC7GF4STOkHrIdElbpahCQipM1MxatVc9PnNn8qSNvdPy7PClrrTE0t+m43pdefMbi
         KR6uV/McPAon8aBZf+Z6AkDimFTYSd47d+spNYvN6WjRKCivyaYDGdWy+q+2tWgmVgQE
         /l++dylGWHc5wM12lbli/Y4VnpoxhzT38LSX637Kz3QwICIamshtDsBpj70Ha81brz/k
         Vou3XL06GSoXnwfbhOxw2XCHXaAamk+G0s8eryjdwavLau0kNVmvunavNtRgvQryBU9q
         Nwjg==
X-Gm-Message-State: APjAAAVuuvdR+hWmJ7ppinCeuJac2N4vT0ukygmqk/1M9VfQO+/gH7mX
        ktzgBcLI06vhOMq+WqI57elcECu86j77PksdYecFuZih5aXR1sp7cFYmMm3zwynHRdainIBa811
        UW+Ekbo4aH5ok
X-Received: by 2002:a1c:7311:: with SMTP id d17mr18659208wmb.49.1571672466199;
        Mon, 21 Oct 2019 08:41:06 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzWvfbwd0CVMXUvuG9GJ5aMAR7n2M/yXqVEsZAjQQU5ezlDAxV84nRyvKufMZ6Q4xGjZp1bIA==
X-Received: by 2002:a1c:7311:: with SMTP id d17mr18659190wmb.49.1571672465917;
        Mon, 21 Oct 2019 08:41:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:847b:6afc:17c:89dd? ([2001:b07:6468:f312:847b:6afc:17c:89dd])
        by smtp.gmail.com with ESMTPSA id i3sm11406516wrw.69.2019.10.21.08.41.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2019 08:41:05 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 2/2] x86: realmode: use inline asm to get
 stack pointer
To:     Jim Mattson <jmattson@google.com>, Bill Wendling <morbo@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, alexandru.elisei@arm.com
References: <20191012235859.238387-1-morbo@google.com>
 <20191012235859.238387-3-morbo@google.com>
 <CALMp9eSK_O24gYg6J7U-eL1Lq4Y=YaXSaQVZhXs+1RSM+h83ew@mail.gmail.com>
 <CALMp9eTGd6MWdePCfwG5QBLpfmVoTg8XGH55MkXxzfa=biG1WA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <9861cdc5-8f0f-10c8-649c-785e1d65dec5@redhat.com>
Date:   Mon, 21 Oct 2019 17:41:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eTGd6MWdePCfwG5QBLpfmVoTg8XGH55MkXxzfa=biG1WA@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: F82qZlZuNiOWIXEPoP5wuQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/19 23:52, Jim Mattson wrote:
> Never mind. After taking a closer look, esp[] is meant to provide
> stack space for the code under test, but inregs.esp should point to
> the top of this stack rather than the bottom. This is apparently a
> long-standing bug, similar to the one Avi fixed for  test_long_jmp()
> in commit 4aa22949 ("realmode: fix esp in long jump test").
>=20
> For consistency with test_long_jmp, I'd suggest changing the
> inregs.esp assignment to:
>        inregs.esp =3D (u32)(esp+16);
>=20
> Note that you absolutely must preserve the esp[] array!
>=20

Agreed, thanks Jim for the review.

Paolo

