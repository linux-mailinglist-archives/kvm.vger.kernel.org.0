Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94CFE279243
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 22:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbgIYUgx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 16:36:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52736 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726281AbgIYUgw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 16:36:52 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601066211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+/GOsrQrrQl6btTDui7fNUi9Aoo0FB3G5PnvswRPvVk=;
        b=LdJ+Gu0HvTIS3Z6Ty5US1cjiZVMOQcWtrnqCUfUrPP5/jnNEldYtVH8sBA6T3pjJ6/sNo6
        4ReA0ZIcgsK+b9Tf37+kasowcxOqwDlbyugI49atMWuNwcz0SX04RfhjIYkg4MlmTtJJv4
        yAyfl4sLo5Y9f7iUWJMQ10N1kRGmm0Y=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-551-YsipiNsuMG21eknRQgl8bQ-1; Fri, 25 Sep 2020 16:36:49 -0400
X-MC-Unique: YsipiNsuMG21eknRQgl8bQ-1
Received: by mail-wr1-f70.google.com with SMTP id s8so1516734wrb.15
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 13:36:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+/GOsrQrrQl6btTDui7fNUi9Aoo0FB3G5PnvswRPvVk=;
        b=L06ubi3Gz5MODqL4CnhsSXJtcSVTK81J7DBO9e1LwJVINvWNgcCoAcxSHGf3PVPzFd
         YzZjtfNz9Fsf+MzYCrNeIoF449gaJpKtBKRmF4kYJoKmJeuMjOfPhgzBEn5TRSAWA3kg
         LmpqNzPI0DG6Gi7fscIARB/VBAjUz85SGyRt7wzW4fPD/NRqK5EqcwkfyN51kh5xCKi0
         Np7Sfof7RPA2bZswovLHnKokndy9yR5ilCs7KqUe9PhIxgyLS16lX89wJ50H6opMCUjR
         e92vPC10JMyMAmhukCGIQ29jQ1TOlj/veijprMc0L7EQ5/5IWd2EKyxQ4iLEKLeU64B+
         cjAg==
X-Gm-Message-State: AOAM533fP6YHpKEG7xqfQlWk5dCVZk0N9/hZXLQ9o2rSfOG7FvvmFTR6
        AaC1oryCsxyQroBp/yS9CJEBn18XHrNVT1AEjSZD5wb85t/itiCbMDEP1dcM/CaXqhjETLWL+8G
        FSmynmOsH0on4
X-Received: by 2002:a1c:398a:: with SMTP id g132mr324855wma.41.1601066208381;
        Fri, 25 Sep 2020 13:36:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyzhsEe4eTVrJHnr9BtKCl7LEwWuko/Hy4c5s58G9XXC4Q1lSW1zw0amiObj48Q/lEg2qw4kg==
X-Received: by 2002:a1c:398a:: with SMTP id g132mr324840wma.41.1601066208143;
        Fri, 25 Sep 2020 13:36:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec9b:111a:97e3:4baf? ([2001:b07:6468:f312:ec9b:111a:97e3:4baf])
        by smtp.gmail.com with ESMTPSA id t1sm194124wmi.16.2020.09.25.13.36.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 13:36:47 -0700 (PDT)
Subject: Re: [PATCH v3 2/2] KVM: x86/MMU: Recursively zap nested TDP SPs when
 zapping last/only parent
To:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Shier <pshier@google.com>
References: <20200923221406.16297-1-sean.j.christopherson@intel.com>
 <20200923221406.16297-3-sean.j.christopherson@intel.com>
 <CANgfPd9LLhLMsOHtMS1begL_J676Szve5y-qruY85WAu5MpYVw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0a2a8e8a-3fbb-3da1-0342-8d6f24ab5c70@redhat.com>
Date:   Fri, 25 Sep 2020 22:36:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CANgfPd9LLhLMsOHtMS1begL_J676Szve5y-qruY85WAu5MpYVw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/09/20 01:29, Ben Gardon wrote:
> Reviewed-by: Ben Gardon <bgardon@google.com>
> (I don't know if my review is useful here, but the rebase of this
> patch looks correct! Thank you for preventing these from becoming
> undead, Sean.)

It is; I had your patch on my todo list in case Sean didn't get to it,
but of course it's even better that you guys sorted it out. :)  I have
queued both, thanks.

Paolo

