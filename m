Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 800351A17AF
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 00:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbgDGWEr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 18:04:47 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:44946 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726492AbgDGWEr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Apr 2020 18:04:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586297086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xrH2lLfAiq23v5Jxv+IpDhUxu2udMFmlhuyHKnLXEqg=;
        b=Ty2m+DFz7lUNx5rs1/BO9KlFnCh2z6B1VSRHYD2XqW8e2O2sPdH7CiJZHYG82HCqa/zjW4
        bd12/5JtpE0g83uxR/SZqxq1fu9/XKX/PnWUuVs+RUaUUATN2P+VbceFQATk4Y0IfoblaX
        zem0GB1E2vCxa0XZptRKCxj+yGJZwNQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-NaIyqciNPO2OWvP2Q06mpA-1; Tue, 07 Apr 2020 18:04:43 -0400
X-MC-Unique: NaIyqciNPO2OWvP2Q06mpA-1
Received: by mail-wm1-f72.google.com with SMTP id s15so1725495wmc.0
        for <kvm@vger.kernel.org>; Tue, 07 Apr 2020 15:04:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xrH2lLfAiq23v5Jxv+IpDhUxu2udMFmlhuyHKnLXEqg=;
        b=TlRoPnZeIIhNfqOFWj5obVc+baGlJMqLFpvws5ImDi91HXMEY/NBwVO8XqmFUQILvQ
         idiKzsi1rmcg+XKRV4nfPDvbS8Tlef2xXqsZZdDWWIIzfYzMGiKrpEi5OivnkR9VrLtX
         +Tgwkw+3HvVsYjUAmFw1p8NnxKHZA7JuRdQmAjlA+NTX1VOq3aiG7zKhaCMFUIpOlgyh
         Eu7QK8BkHYZRbdacCc3Fe7ycgswUMg4AWkfxY6YOG7OufFQtpUUVwkYoXf517k+AnM0v
         /TzMHRWhhwkSi7omjfHMxIi613V1IMnh5AHux8fpmOfYX5/1/xgY0cTut+6zzHti/xWf
         MX1w==
X-Gm-Message-State: AGi0PuapncTOARyPfCK8TsLQ69TfF/W4JT7zI/mUyp66KP3MxR/EcJel
        kVkAMfHnr8aEvhQAPeE3gFrO8TXyXFsdtjPDf4GCryEdvO3XhSS6BKCLHIZbdOrpQ68nyyJDzo3
        mF1aLeB0ImcQk
X-Received: by 2002:adf:8b5c:: with SMTP id v28mr4563546wra.98.1586297082515;
        Tue, 07 Apr 2020 15:04:42 -0700 (PDT)
X-Google-Smtp-Source: APiQypLGbUTjfdz6MpZ4qxUe2T9cFiSjdOrwlcJVFzepk8Hol5dhGGIbKBsCKOQCM8Zck3xQ0lCQsQ==
X-Received: by 2002:adf:8b5c:: with SMTP id v28mr4563476wra.98.1586297081368;
        Tue, 07 Apr 2020 15:04:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:bd61:914:5c2f:2580? ([2001:b07:6468:f312:bd61:914:5c2f:2580])
        by smtp.gmail.com with ESMTPSA id t17sm28293907wrv.53.2020.04.07.15.04.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 15:04:40 -0700 (PDT)
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
To:     Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Vivek Goyal <vgoyal@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
References: <20200407172140.GB64635@redhat.com>
 <772A564B-3268-49F4-9AEA-CDA648F6131F@amacapital.net>
 <87eeszjbe6.fsf@nanos.tec.linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ce81c95f-8674-4012-f307-8f32d0e386c2@redhat.com>
Date:   Wed, 8 Apr 2020 00:04:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <87eeszjbe6.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/04/20 22:20, Thomas Gleixner wrote:
>>> Havind said that, I thought disabling interrupts does not mask exceptions.
>>> So page fault exception should have been delivered even with interrupts
>>> disabled. Is that correct? May be there was no vm exit/entry during
>>> those 10 seconds and that's why.
> No. Async PF is not a real exception. It has interrupt semantics and it
> can only be injected when the guest has interrupts enabled. It's bad
> design.

Page-ready async PF has interrupt semantics.

Page-not-present async PF however does not have interrupt semantics, it
has to be injected immediately or not at all (falling back to host page
fault in the latter case).  So page-not-present async PF definitely
needs to be an exception, this is independent of whether it can be
injected when IF=0.

Hypervisors do not have any reserved exception vector, and must use
vectors up to 31, which is why I believe #PF was used in the first place
(though that predates my involvement in KVM by a few years).  These
days, #VE would be a much better exception to use instead (and it also
has a defined mechanism to avoid reentrancy).

Paolo

