Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 372613DA041
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 11:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235587AbhG2Jan (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 05:30:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48906 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235141AbhG2Jam (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 05:30:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627551039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J23iSJURRvqOkAxJMklwOxLv8DDTdOwhOo68zLNGqb0=;
        b=HYpJDx39zXvFxJkye6SNZvN+BMxAJBVE3JzwYACGZQBjNadEOk7tEi7CRKN8Q7vW55/RHF
        BF6TREy9QEvJXR5eC82azUTKU752MUGY+okAslkvLBRLVBUs9rhsKeqMKZt+0dVrekO/RW
        58TJ3cj7suC01RMFdtKXhcw6YXc8xRQ=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-PHmpyreFNfS-eGGu07ySQw-1; Thu, 29 Jul 2021 05:30:38 -0400
X-MC-Unique: PHmpyreFNfS-eGGu07ySQw-1
Received: by mail-ed1-f69.google.com with SMTP id j22-20020a50ed160000b02903ab03a06e86so2647851eds.14
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 02:30:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J23iSJURRvqOkAxJMklwOxLv8DDTdOwhOo68zLNGqb0=;
        b=ojNY9Uffp48W9fY4Ce9c7+5IvD6gzk8OmrxEXdLaddAh7poP/rQ7DTk4kCLf9fDNdW
         vN7rpZGV3kYHpXdwDkTSBdlJDkrc3Y1qvLHRo41IgcfelaDs/uYjWgsgPQ5Ucupflr1O
         312xqY902t5owUaj3mard5tl2CyxmR3vlc/GMRN6GwNu7JGBlWw2nd8/7XttBRgdplXr
         9mCNMrdoTtPjz7ldPuiSSAII24MCLvjKV0dUJVC+oTnqmWaeNonASzzrQhOWcm6+IcIh
         mcf/j3t4x+SmMQ99DWIj1itHirPnT7yEfkLZ24FvAZWzKJnk3uoHkjgX3ArnMWVq7BuX
         mxOw==
X-Gm-Message-State: AOAM530mrG14LnCrQN/j60vBCcGv9DGkQ9HvVKRHJOAhmEAuUvDSjO9G
        nxA2k0mzsKrbygPMAnkoUQQbBhfeEx7cGSBlgygOV3UTI73yCdxpvXDl2HXGaNmhUG6K+11T+6c
        cXoWjTm72aw8A
X-Received: by 2002:a17:907:9d4:: with SMTP id bx20mr3676518ejc.123.1627551036980;
        Thu, 29 Jul 2021 02:30:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx3wIR5FM8ntRVfpyHiOWHksHokdn3YpbAIvZT7i5L+rZrnbhYwfbL3DgrDPF/a7EY6Be57TQ==
X-Received: by 2002:a17:907:9d4:: with SMTP id bx20mr3676502ejc.123.1627551036834;
        Thu, 29 Jul 2021 02:30:36 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id v13sm768791ejh.62.2021.07.29.02.30.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 02:30:36 -0700 (PDT)
Subject: Re: [PATCH v4 03/13] KVM: x86: Expose TSC offset controls to
 userspace
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Oliver Upton <oupton@gooogle.com>
References: <20210729001012.70394-1-oupton@google.com>
 <20210729001012.70394-4-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7cb58a33-316c-58b5-b542-671a43dea89c@redhat.com>
Date:   Thu, 29 Jul 2021 11:30:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210729001012.70394-4-oupton@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/07/21 02:10, Oliver Upton wrote:
> +6. Adjust the guest TSC offsets for every vCPU to account for (1) time
> +   elapsed since recording state and (2) difference in TSCs between the
> +   source and destination machine:
> +
> +   new_off_n = t_0 + off_n = (k_1 - k_0) * freq - t_1

The second = should be a +.

Otherwise the algorithm seems correct.
> +

