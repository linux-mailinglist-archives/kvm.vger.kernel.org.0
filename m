Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 287532DC306
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 16:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgLPPYz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 10:24:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31689 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725905AbgLPPYy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Dec 2020 10:24:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608132208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y8bGZBwnTpNbARrYz124sdWvgtnobEQBNsq3VmZPC0s=;
        b=djjdhExT6UPd2CrmYaJabCq35p3f38R7cjvsO4+lFj0u4ecOtHIfERmUX2s7uqNtML03n+
        GwmSsVkXVKd9/3yHwbGBmkmme/CFXk7j3qTYeCgj2abRFwSgLASNbQNt2U37eBfkgz1644
        t/Maryxh1MJ2gqkEayyGl0OhxgdCHfc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-08S5i0zQP5CcCVNMTse3rQ-1; Wed, 16 Dec 2020 10:23:26 -0500
X-MC-Unique: 08S5i0zQP5CcCVNMTse3rQ-1
Received: by mail-ed1-f72.google.com with SMTP id r16so11901930eds.13
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 07:23:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y8bGZBwnTpNbARrYz124sdWvgtnobEQBNsq3VmZPC0s=;
        b=amJGpfn4rvB3LdpLYq612BRZzOXDHUUC9pvvOWSlgAjwi4b3hIx7H9MDzlYW2bFz7M
         IY5YnTIKyphjkA/muCsnyr7zBAGpQPxTQaxk88N0wdTme/02qO94OiywGEwRAhycHi5K
         iJjtSASXX0GsdPzXWN1S0VQRY9rVYcYTj51Tve/UOtYUJApVrgh3s8fUrMZf+zJlXvdE
         oHXrAbmvwzeHpcf6bH5oNzLfSdTsPdUWWtBqtCSKM8TRQPYARqg1EKR37fHwYv0IsX1U
         Mb+x1LuGkWV5suze0ZLkuT8AWByd3Inq4PUYug+TL/1xWxGIsAzxkw5maS1GwEM8PizF
         pG0Q==
X-Gm-Message-State: AOAM533XJX4ZonDbzxoqcmm5+6F5/xDrS85kY6E0MIbh7EvCkDVzEEGN
        DWIFA55uQlcuOxVyxIYtxRvN/UkCAHVk2ckb9D/3Wwgwllq0hu1YLIOqkrd0ckUd4wT/N6LBDm2
        z10BKKt1BulJJ
X-Received: by 2002:a17:906:7f11:: with SMTP id d17mr31213669ejr.534.1608132205035;
        Wed, 16 Dec 2020 07:23:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyq9p3k0wcFSTVZbYtjn8uIyhUmE2cpCRqBSIw40bvFGpNXL3zgfsmLt+0rXpaWivsMCtZ8RA==
X-Received: by 2002:a17:906:7f11:: with SMTP id d17mr31213642ejr.534.1608132204821;
        Wed, 16 Dec 2020 07:23:24 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id zn5sm1641200ejb.111.2020.12.16.07.23.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Dec 2020 07:23:23 -0800 (PST)
Subject: Re: [PATCH v2] KVM: SVM: use vmsave/vmload for saving/restoring
 additional host state
To:     Michael Roth <michael.roth@amd.com>,
        Andy Lutomirski <luto@amacapital.net>
Cc:     Sean Christopherson <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Andy Lutomirski <luto@kernel.org>
References: <20201214220213.np7ytcxmm6xcyllm@amd.com>
 <98F09A9A-A768-4B01-A1FA-5EE681146BC5@amacapital.net>
 <20201215181747.jhozec5gpa4ud5qt@amd.com>
 <20201216151203.utpaitooaer7mdfa@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f22e2410-d4e3-f5fd-8e40-4225a83851c0@redhat.com>
Date:   Wed, 16 Dec 2020 16:23:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201216151203.utpaitooaer7mdfa@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/12/20 16:12, Michael Roth wrote:
> It looks like it does save us ~20-30 cycles vs. vmload, but maybe not
> enough to justify the added complexity. Additionally, since we still
> need to call vmload when we exit to userspace, it ends up being a bit
> slower for this particular workload at least. So for now I'll plan on
> sticking to vmload'ing after vmexit and moving that to the asm code
> if there are no objections.

Yeah, agreed.  BTW you can use "./x86/run x86/vmexit.flat" from 
kvm-unit-tests to check the numbers for a wide range of vmexit paths.

Paolo

> current v2 patch, sample 1
>    ioctl entry: 1204722748832
>    pre-run:     1204722749408 ( +576)
>    post-run:    1204722750784 (+1376)
>    ioctl exit:  1204722751360 ( +576)
>    total cycles:         2528
> 
> current v2 patch, sample 2
>    ioctl entry: 1204722754784
>    pre-vmrun:   1204722755360 ( +576)
>    post-vmrun:  1204722756720 (+1360)
>    ioctl exit:  1204722757312 ( +592)
>    total cycles          2528
> 
> wrgsbase, sample 1
>    ioctl entry: 1346624880336
>    pre-vmrun:   1346624880912 ( +576)
>    post-vmrun:  1346624882256 (+1344)
>    ioctl exit:  1346624882912 ( +656)
>    total cycles          2576
> 
> wrgsbase, sample 2
>    ioctl entry: 1346624886272
>    pre-vmrun:   1346624886832 ( +560)
>    post-vmrun:  1346624888176 (+1344)
>    ioctl exit:  1346624888816 ( +640)
>    total cycles:         2544
> 

