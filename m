Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA63579D346
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 16:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235875AbjILOIc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 10:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbjILOIa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 10:08:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 664AB10D9
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 07:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694527660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QRN2zNzEIRdt9mVIxmAhTfWZatfHk2JC63APMxesKYw=;
        b=AKv58k9rYl1tGQatSnVpo0Mr7TiPNBgOe4AITe54nH6/ocVHaGi0rkGkkUcGo1/XfLTkL+
        nbfEb0oaJHe5JDrxv5KRKpSDTWl/lUzWPqfMTDI6ItpQCykVOjjmb488cIqpNyBZrMzoK7
        fTSHteacCGDyDUCmbRYMYmprgQrUp4s=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-e5VYUccBN3Wuab5TkUeMDw-1; Tue, 12 Sep 2023 10:07:39 -0400
X-MC-Unique: e5VYUccBN3Wuab5TkUeMDw-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-402d1892cecso25138695e9.1
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 07:07:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694527658; x=1695132458;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QRN2zNzEIRdt9mVIxmAhTfWZatfHk2JC63APMxesKYw=;
        b=lFo8DEBhVfprufUFoo/099K3JZuK/QQ3F3d2L690x67rZoIP0ZUIwRybvRPVu8cVZX
         iLtZ/g3jseQCQemrVjGNAqZdSIjmJu3wkrOCwqIfFgLmrpDwiByQieKhVoOmFhgN5JPH
         x5zT5gUyv8vTxq1tVfXjWtuwWm6bWYbHEO7tBZqaZ20VryZLhIvBvbQ9WrtwUwITVguv
         kOcCUuwrwKV/1oY7uD7P9mVM64pK0fftsP5u54Pip+p0Fg/Qn8aIcVmUlJCzJBYScGgl
         ewW50iykPTC+fqc0olHawOuo/GHQYRvjFq3e/3DGTWS/OF5cRsM0vS2FMWaPN4LnEkam
         rZOw==
X-Gm-Message-State: AOJu0YweFiVyiLZvI3FrqgVyINfBaHZPzkhTCp4Oc98XPQHkOPnuPsU9
        xMC+6qPTYufhiGmygowefp47YHtcJ2iVc5zCDMmB+anqY2TMzdcMLH5veDwmQ9aUDpp5w8wMETS
        8xVJZc1zy/1oX
X-Received: by 2002:a7b:ca47:0:b0:3fb:c075:b308 with SMTP id m7-20020a7bca47000000b003fbc075b308mr2071599wml.12.1694527657840;
        Tue, 12 Sep 2023 07:07:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF7DFNhJSaXDU85WH3j5/sSakZlESk56Xn91pig/o3p2nP0S9nFEbdN3YcyLiQgbtnDSG6WhQ==
X-Received: by 2002:a7b:ca47:0:b0:3fb:c075:b308 with SMTP id m7-20020a7bca47000000b003fbc075b308mr2071575wml.12.1694527657499;
        Tue, 12 Sep 2023 07:07:37 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id y18-20020adfd092000000b003179d5aee67sm13007052wrh.94.2023.09.12.07.07.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Sep 2023 07:07:36 -0700 (PDT)
Message-ID: <fabf2451-e8ad-8171-b583-16b238c578e7@redhat.com>
Date:   Tue, 12 Sep 2023 16:07:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v4 0/3] target/i386: Restrict system-specific features
 from user emulation
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        =?UTF-8?Q?Daniel_P_=2e_Berrang=c3=a9?= <berrange@redhat.com>
References: <20230911211317.28773-1-philmd@linaro.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230911211317.28773-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/11/23 23:13, Philippe Mathieu-Daudé wrote:
> Too many system-specific code (and in particular KVM related)
> is pulled in user-only build. This led to adding unjustified
> stubs as kludge to unagressive linker non-optimizations.
> 
> This series restrict x86 system-specific features to sysemu,
> so we don't require any stub, and remove all x86 KVM declarations
> from user emulation code (to trigger compile failure instead of
> link one).
> 
> Philippe Mathieu-Daudé (3):
>    target/i386: Check kvm_hyperv_expand_features() return value
>    RFC target/i386: Restrict system-specific features from user emulation
>    target/i386: Prohibit target specific KVM prototypes on user emulation

At least, patch 2 should be changed so that the #ifdef'ery is done at a 
higher level.

However, the dependency of user-mode emulation on KVM is really an 
implementation detail of QEMU.  It's very much baked into linux-user and 
hard to remove, but I'm not sure it's a good idea to add more #ifdef 
CONFIG_USER_ONLY around KVM code.

Paolo

