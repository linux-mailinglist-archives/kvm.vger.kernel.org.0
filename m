Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0797F1DCF0E
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 16:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729843AbgEUOIe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 May 2020 10:08:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56614 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729810AbgEUOId (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 May 2020 10:08:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590070112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KYPruZ8qzCyc8Zuc6WzgrqHrImI6iIZQ3tFwxDcY6eQ=;
        b=WxnF8KBGBcrKr+ZP6/55jsOICaV7MSdgVrywBtIxXkd6Oe/HNj8SFmz9LR3ViZqXevgyTq
        A11iXGIEroZTTMmv8836AR0rCqLXhuW58baccSjgwXd6D7MsTQ9GbOEW6//fQZ//iejB19
        ZG62JpwXU65TRPd/o+7HsYK6kic4gbE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-Y2ams0TDMiqCMfuuWMzfbA-1; Thu, 21 May 2020 10:08:22 -0400
X-MC-Unique: Y2ams0TDMiqCMfuuWMzfbA-1
Received: by mail-wr1-f69.google.com with SMTP id z8so2961384wrp.7
        for <kvm@vger.kernel.org>; Thu, 21 May 2020 07:08:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KYPruZ8qzCyc8Zuc6WzgrqHrImI6iIZQ3tFwxDcY6eQ=;
        b=MqrqD+MFj9KTPfqhP9yVhiF7Mk3YSsU6SNFUwSqERNuw1g5AyFAyzQzvShHsbwDVcP
         gKnB9wFmYDE4bcMjvrBC8hwXJMV8V9tNatFslSqWUUJv+OWi/9pIA9KXPrlLahDociKy
         C2mpfi9D+DxlC0ZvawqMkTxwkbP9TLNzfoGyM7zCh88ZaI1ner3sRExdjUHwY8B7PzKF
         vwbExj9Fj5EAQ9oqhuM9ciQhaL/dE3SiP7r7hQfFJm6pGbdvqbpiP9jUTAedQjY+OTRc
         XDdXkAQfToskYjZiSmxsUMvsqYkgWgPamL1PYwI1tCewVH8nHqP/I+ZG4F7zM04CE4Ao
         IC1w==
X-Gm-Message-State: AOAM531N+0a8IohpUcAuI0HYXKEjf93zC2zPLx/zEGJLFTGitIdFNHmd
        jhJ2vAhnvqN0u93HMFrwf6MBv2NPNsOeFJCjGcB0ubCfvSPWua5SPNl5qZbee3hP8C9j+FdB51Z
        DafZHEdlA3Ly4
X-Received: by 2002:a1c:7c0b:: with SMTP id x11mr9419091wmc.149.1590070101175;
        Thu, 21 May 2020 07:08:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxeqE8s6kqITQ5zRCGAR7thbTgJ+XBuN/t8JKtVxsAPKAeoBu546k0CmcwDaZnB6+qd45/Ykw==
X-Received: by 2002:a1c:7c0b:: with SMTP id x11mr9419073wmc.149.1590070100967;
        Thu, 21 May 2020 07:08:20 -0700 (PDT)
Received: from [192.168.178.58] ([151.30.94.134])
        by smtp.gmail.com with ESMTPSA id q144sm7012698wme.0.2020.05.21.07.08.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2020 07:08:20 -0700 (PDT)
Subject: Re: [PATCH v2 03/22] KVM: SVM: immediately inject INTR vmexit
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     wei.huang2@amd.com, cavery@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20200424172416.243870-1-pbonzini@redhat.com>
 <20200424172416.243870-4-pbonzini@redhat.com>
 <87blmhsb7y.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8bc4c38a-1717-1e4f-b322-fdd51f614717@redhat.com>
Date:   Thu, 21 May 2020 16:08:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <87blmhsb7y.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/05/20 14:50, Vitaly Kuznetsov wrote:
> Sorry for reporting this late but I just found out that this commit
> breaks Hyper-V 2016 on KVM on SVM completely (always hangs on boot). I
> haven't investigated it yet (well, this is Windows, you know...) but
> what's usually different about Hyper-V is that unlike KVM/Linux it has
> handlers for some hardware interrupts in the guest and not in the
> hypervisor.

"Always hangs on boot" is easy. :)  At this point I think it's easiest
to debug it on top of the whole pending SVM patches that remove
exit_required completely (and exit_required is not coming back anyway).

Can you get a trace and send it to me?

Paolo

