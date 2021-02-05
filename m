Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9459731115F
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 20:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233428AbhBER6C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 12:58:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233250AbhBEP1Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 10:27:16 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E7CC061756
        for <kvm@vger.kernel.org>; Fri,  5 Feb 2021 08:52:06 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id b17so3857851plz.6
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 08:52:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RO4dIZbXCHxgGtgQUSgkK1eNDMrMfPhO1PoHqkge4zU=;
        b=Xmwyxyw3v/HXwd2nQjd/2BUg2EEGJ5fX90Q6UKMSb4EzTrgBS5iYjcbnOepw0ncPUX
         MNKRaX9tjSsWjsVhxWSdBngwSbpeBhJA1hYjeMjhCkXxhPahOwzUzje5amZL9b4pM4OU
         rdf5QRfhRnNvAWtcdfSXgGgHVJ/emBbbgX20A3/lpPcujpGHAjusmJ8SkdwBP7LWj+jx
         vWh9xHx36kYxY5z9RxKdqCtioNQF7vhvuEVA6KHeBDeL+vaWV8toxBiZO8owVG64oCf9
         Ji7V2MEAIt0ZZK1pYiejoy4ukDl7Qa4ssBnyt//2y+oz/T5MX96qYqW+YanUaYzkv7F1
         zUdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RO4dIZbXCHxgGtgQUSgkK1eNDMrMfPhO1PoHqkge4zU=;
        b=Vcvd+RXQE9xxQM4Dp4TQu2hDl1Y6wTTln9LmjhEaj8k9Ec9bS2V4Hru2LLOiZVBBdm
         Teh2lOru40xO5qNBg4bY3C2g9P0vlHqjXCabuEPtn/t0Zx/XuYhx0xI6WNWy1dJoeaY9
         Otg5TbSFqziBvNEjSVA2pAG798RolEMZr9sGoNuXh8ai4Pq+AlOQR91mqnSCx0NvYhAh
         1fNtHLcLO9N9tF2dDOO2Go2Am4+ohou1tuUUXrYBp6Bv3VssKbHnEoT4vfKYzU9ZMM8g
         QkHFvUAUJ7DHdyrB4PkMsK98+QIq1y9g6K6csFvjThJSaTiqGlNkWt6nnoNCniMXRpw+
         +GXw==
X-Gm-Message-State: AOAM530kYtlhL6/eyKN05YnRzvjk3BeLPUsstlSLI2Vgnl9BiiQCmckA
        DH6wLkCM40K6/V3uM7aw1EN5jA==
X-Google-Smtp-Source: ABdhPJw+8Tef3Qby15x0TyDv1F69X4SxvY97339jGVjxV1d4q0Ziwccau8NBcqd2KIPUvOoRgK2HLQ==
X-Received: by 2002:a17:90a:657:: with SMTP id q23mr5076265pje.192.1612543925784;
        Fri, 05 Feb 2021 08:52:05 -0800 (PST)
Received: from google.com ([2620:15c:f:10:d169:a9f7:513:e5])
        by smtp.gmail.com with ESMTPSA id x141sm9765955pfc.128.2021.02.05.08.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 08:52:05 -0800 (PST)
Date:   Fri, 5 Feb 2021 08:51:58 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "luto@kernel.org" <luto@kernel.org>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "b.thiel@posteo.de" <b.thiel@posteo.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "Huang, Haitao" <haitao.huang@intel.com>
Subject: Re: [RFC PATCH v3 00/27] KVM SGX virtualization support
Message-ID: <YB13rk29J8Obs80J@google.com>
References: <c827fed1-d7af-a94a-b69e-114d4a2ec988@intel.com>
 <d044ccde68171dc319d77917c8ab9f83e9a98645.camel@intel.com>
 <YBsyqLHPtYOpqeW4@google.com>
 <b6e0a32f-0070-f97e-5d94-d12f7972d474@intel.com>
 <44b5a747aaf1d42fb8ef388bd28f49614d42cd50.camel@intel.com>
 <YBs/vveIBg00Im0U@google.com>
 <5bd3231e05911bc64f5c51e1eddc3ed1f6bfe6c4.camel@intel.com>
 <YBwgw0vVCjlhFvqP@google.com>
 <635e339e-e3f5-c437-0265-b9d44c180858@intel.com>
 <35808048da366b7e531f291c3611c1172f988d6a.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35808048da366b7e531f291c3611c1172f988d6a.camel@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 06, 2021, Kai Huang wrote:
> Hi Sean,
> 
> If we all agree the fix is needed here, do you want to work on the patch (since you
> already provided your thought), or do you want me to do it, with Suggested-by you?

Nope, all yours.
