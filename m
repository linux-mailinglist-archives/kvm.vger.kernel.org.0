Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1126D2ED621
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 18:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728965AbhAGRz2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 12:55:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34113 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728251AbhAGRz1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Jan 2021 12:55:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610042041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K6GQmzJAdTbPNgN/TmIYptrmtmdvKcTL/LS3Q66JubM=;
        b=dt07wlikwzGF23HlS6detPW3oGBilTfrsWUKFt08IR9TMbWtJ82aCPdAn14mmtEChveZDr
        1dkcwNUXDFe4rWYjyiHPk2/pw7YAzyLKesj/LTkSC6XPDN3oJy/YLK7jnw8PM0YpgKZe3v
        fxLukp52mfQX+vJPqCEYcNc2BXcyAqQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-urJpSbynO5KuQT19ACTM6Q-1; Thu, 07 Jan 2021 12:54:00 -0500
X-MC-Unique: urJpSbynO5KuQT19ACTM6Q-1
Received: by mail-ed1-f71.google.com with SMTP id y19so3583532edw.16
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 09:54:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K6GQmzJAdTbPNgN/TmIYptrmtmdvKcTL/LS3Q66JubM=;
        b=C6FCBncWa9+9sdqo52TNBfZXFgNcnzm7p6lSi1yqJEzAxig9TSnQCNXXuG4v8VZRW+
         omj1tiXDFPg2WEhcCuyFZyl/VmkaO2M2i4U4SZct3Z0Pz3t5qZuT8vFCLAz5ZD5HEAtw
         BR0M3GO+fRtkk54vOIkSsauaDKKZLbQK5W/GcjCuWmg4rZqjSQuz4cgt+6l314b7G3Vz
         OieSr0zPRv3USGT188BKOzYChUC8TIuHk9ZWUZ48a7TETEb7nMDn03VShwmzuRf8bTmY
         TVKuFr5wRZnZQTyBlGlFHoUiV7qnmh6/j6pYzaF++IwfPIbTHtln/F68ZecnlhHTCPex
         6U5g==
X-Gm-Message-State: AOAM533XCeQllolDLTkbbxpzg7vWFkjuARr7jAePK/8EUo+wpiEbU7PA
        Wsx0HFA3WvrNr0ADXZPVlEnRYWWrM4iV9AGpQ2GBclnCRNfC7Iu7Nc+R/3lgztfrtAA55shlAMa
        2dy47DsnQkzsJ
X-Received: by 2002:a17:907:e9e:: with SMTP id ho30mr3052502ejc.529.1610042039044;
        Thu, 07 Jan 2021 09:53:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwUmwEXqBL7daFEotytllonxdak4JkeaZiDz9BhtX0hPPREL2/RRc65HY2CrqgZeN6FTCLGzw==
X-Received: by 2002:a17:907:e9e:: with SMTP id ho30mr3052492ejc.529.1610042038914;
        Thu, 07 Jan 2021 09:53:58 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id dd18sm2694365ejb.53.2021.01.07.09.53.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jan 2021 09:53:58 -0800 (PST)
Subject: Re: [PATCH v3 1/2] KVM: x86/mmu: Ensure TDP MMU roots are freed after
 yield
To:     Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Peter Shier <pshier@google.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Leo Hou <leohou1402@gmail.com>
References: <20210107001935.3732070-1-bgardon@google.com>
 <X/dHpSoi5AkPIrfc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a1a9346c-e403-618a-91e8-02ce4b7105c8@redhat.com>
Date:   Thu, 7 Jan 2021 18:53:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <X/dHpSoi5AkPIrfc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/01/21 18:40, Sean Christopherson wrote:
> /*
>   * The yield_safe() variant of the TDP root iterator gets and puts references to
>   * the roots it iterates over.  This makes it safe to release the MMU lock and
>   * yield within the loop, but the caller MUST NOT exit the loop early.
>   */
> 

Nicer, thanks!

Paolo

