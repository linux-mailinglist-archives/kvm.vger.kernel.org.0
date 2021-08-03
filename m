Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACB1A3DEA86
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 12:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235283AbhHCKK6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 06:10:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45513 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235199AbhHCKKg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 06:10:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627985424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OfOI5BQLkvmy3gTPFxCm3AerU5X6fkkIIhM9umQ8DpQ=;
        b=DvT7R9lwMBCqvAk3A2/RiL6UsVkzMILvAmHtlapLjM2APqxQKY/yeBpS/zIWqeQD3tvFnv
        0o0TzcYacWTUBwHc9aITrvtRQtIsoHnAXDg+tzGqcB0Vb6NBuLgENI4FKUNN5tu8QfvS9n
        6/aeHgeuOX+2pwrZjFpBisQdo31VQtk=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-jlWGcMYbOIaTfdA1MbagMQ-1; Tue, 03 Aug 2021 06:10:23 -0400
X-MC-Unique: jlWGcMYbOIaTfdA1MbagMQ-1
Received: by mail-ej1-f72.google.com with SMTP id nb40-20020a1709071ca8b02905992266c319so2368075ejc.21
        for <kvm@vger.kernel.org>; Tue, 03 Aug 2021 03:10:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OfOI5BQLkvmy3gTPFxCm3AerU5X6fkkIIhM9umQ8DpQ=;
        b=WrLChdgr2Oo47GpCbittEkPxEeqG0WAIEu5YM2l5GlDh1HYOulhn3yhmIm32YB3If7
         PDaUM839WBch/u1r/kePtKEOveUyMVI///VbDM8rUJ+xIWquOJsuxhYMpw6epSAPzuj5
         qATYndmbhz0yWvLzbw29neWcBJQQLgke0IiAbfr15fZWu2aG1u1e9pX3MmZP6dhA6fTz
         8V3Y+rttZRn1TavNC1G43IgNboSBOpojyjllQm/CvkHIj3xaA2+0fDjTQatmsqACjILC
         OqUJzn8iVCQhB/UUHsjoXUXbnn6nzkXeOkkGGZwn9uzSxnB4fFM15usia8vMhIPqtn0A
         zJ5w==
X-Gm-Message-State: AOAM532mCcIj1foU/ASj3G5PRoE65rdR9FD8BJyzIzGot3IGW1eJGQ5N
        f+DPHLYWL5YBibw2bq01NRPF0yvIVruFQaqjfcpEylAZMK/e72Bi9pdjbVMcvetB1VDHb6Nrmo/
        Vn/7L2L6+kZs/
X-Received: by 2002:aa7:c792:: with SMTP id n18mr25043035eds.269.1627985422208;
        Tue, 03 Aug 2021 03:10:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz3kVrw5MTcDI9OybfehAfSQ7erslosbBvvpZwwtNS45igYKMuMk4BoT1R5P8G1dajNAUraxQ==
X-Received: by 2002:aa7:c792:: with SMTP id n18mr25043014eds.269.1627985422004;
        Tue, 03 Aug 2021 03:10:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id cf16sm7767366edb.92.2021.08.03.03.10.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 03:10:21 -0700 (PDT)
Subject: Re: [PATCH 4/4] KVM: selftests: Test access to XMM fast hypercalls
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
References: <20210730122625.112848-1-vkuznets@redhat.com>
 <20210730122625.112848-5-vkuznets@redhat.com>
 <20210730143530.GD20232@u366d62d47e3651.ant.amazon.com>
 <878s1namap.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1939b03b-cec3-2c2e-2f67-b0dfc2c83735@redhat.com>
Date:   Tue, 3 Aug 2021 12:10:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <878s1namap.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/07/21 16:50, Vitaly Kuznetsov wrote:
>> Should we also do WRITE_ONCE(nr_ur, 0) here?
> It could probably make sense to replace 'nr_ud = 0' above with this so
> compiler doesn't screw us up one day..
> 

It should be okay with the "memory" clobber.

Paolo

