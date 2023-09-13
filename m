Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E34E79E4ED
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 12:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbjIMKaM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 06:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjIMKaK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 06:30:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E3C2419B6
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 03:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694600959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0bxFVe/E2XvfrFqG8Yrr1bPRLJ8gbzxCcYIWyf9wMMg=;
        b=SEtO//4XqdqmKw26OrP4dGeP0BtkzRCKMU1sOZYgw0lLSlE6xI4Jncj2P9cdecJnkNg8ao
        iK3uuFAbgQrlBSiJrrk9htTKdzJE8BU4iu0rqF7CRd8+w+qMDeqo2W5idS3CL4ufPxo27t
        8EIscCNvwbL0GoyrIV5s1Y/oMj9Yz1E=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-49-HxFj8HFcPnSLhc1zFQegRw-1; Wed, 13 Sep 2023 06:29:18 -0400
X-MC-Unique: HxFj8HFcPnSLhc1zFQegRw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f5df65fa35so49867525e9.3
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 03:29:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694600957; x=1695205757;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0bxFVe/E2XvfrFqG8Yrr1bPRLJ8gbzxCcYIWyf9wMMg=;
        b=HcTMWFf3pA2uI2i8bS4hWgleXH4nDbBa4oSwTbXAYcdLFoVnNOrjbGR7i///IqM7tM
         Ymdt1C53AxhTHbO8xeUfJAB5M7kpZr1/Syd0s8CIWVAy8cF1lbhU3RRLEVAiy735FRj8
         I/moABSzCoKI1eEWH3iWFOd3ubY1S2M+QgPvjyT2Z/1l6+GD4/i3IUNqbvqmXek8ii6H
         kPPfKsWy5pI6sEk+saDZ1UHOHaFBBE9U/nvs0dI/d0sova74schWEiSmCRKLx6mtfl6F
         y7fIH7IOEJq5UWcUA3GKANA46EAzgq03DoumvQ8LrmqcgaY03FXHfFBqOQAuh8eJaSLh
         NbEA==
X-Gm-Message-State: AOJu0Yxg0ZfVl8bkYbAfGcl/8JSclXQahS3K1nddbiznIffxZlhRGg8X
        l+5vkDom9o2Kzc2JImsvPCTOobguvELsggownZQQT2nv4eTvy3RTdiSW2cAy4tdq+rbItRusK1k
        T2M2yjxjDMh4/
X-Received: by 2002:a1c:7213:0:b0:401:d5bb:9b40 with SMTP id n19-20020a1c7213000000b00401d5bb9b40mr1791338wmc.15.1694600957305;
        Wed, 13 Sep 2023 03:29:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHJQ20OnDZTTPIGLgVTuejcFW7U3fILnen/CmHvty2+jekejpqdkNJ3ZrDotViC4vJgjVrZ9Q==
X-Received: by 2002:a1c:7213:0:b0:401:d5bb:9b40 with SMTP id n19-20020a1c7213000000b00401d5bb9b40mr1791319wmc.15.1694600956978;
        Wed, 13 Sep 2023 03:29:16 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id a16-20020a5d4570000000b00317f70240afsm15203183wrc.27.2023.09.13.03.29.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Sep 2023 03:29:16 -0700 (PDT)
Message-ID: <7b544940-0cf2-652e-732e-934dfac63182@redhat.com>
Date:   Wed, 13 Sep 2023 12:29:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v5 0/6] target/i386: Restrict system-specific features
 from user emulation
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Daniel_P_=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Kevin Wolf <kwolf@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
References: <20230913093009.83520-1-philmd@linaro.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230913093009.83520-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/13/23 11:30, Philippe Mathieu-Daudé wrote:
> Since v4:
> - Addressed Paolo's suggestions (clearly better)
> 
> Too many system-specific code (and in particular KVM related)
> is pulled in user-only build. This led to adding unjustified
> stubs as kludge to unagressive linker non-optimizations.
> 
> This series restrict x86 system-specific features to sysemu,
> so we don't require any stub, and remove all x86 KVM declarations
> from user emulation code (to trigger compile failure instead of
> link one).

I'm still not sure about patch 5, though I'd like to have something like 
patch 6.  But fortunately patches 1-3 are enough to placate clang, so I 
have queued them.

Thanks Philippe!

Paolo


