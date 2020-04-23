Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5A81B581A
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 11:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgDWJ0L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 05:26:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46796 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726410AbgDWJ0K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 05:26:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587633969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MGgmr4DwO0KzfyPWlPuSjwCWCAlutT/YH5ClZ1SR4T4=;
        b=ilxYUyh/A0yAJ7uvLJPHUnYzxEBnf1rYXNzBrWJHnT2D7MBiWojVzeRPA+KSgKTGVa7pxj
        rVbF/SVaGJMf31ayaQHinVbxK6XHhXHCbJ19s1yp7dtx5LI1hm/9m2oyCHB59p0vbSjRIZ
        UNMjG2rXP3fDq/LfYwGIk1GlNfbuQHs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-M32CqW7UOc-An-pmTRe98Q-1; Thu, 23 Apr 2020 05:26:07 -0400
X-MC-Unique: M32CqW7UOc-An-pmTRe98Q-1
Received: by mail-wr1-f71.google.com with SMTP id 11so2576280wrc.3
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 02:26:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MGgmr4DwO0KzfyPWlPuSjwCWCAlutT/YH5ClZ1SR4T4=;
        b=TvdoUt0fM1kNleaYiIxZzyRm5VWf6N2bYQwdBlw9ZT2HuAHu1U6tR+QqYZmvccLWIJ
         h70L3YE99cu6Omx/sOFg8lhoN73bWefRGKMm0Ujfo6wribM8SP7hlf+GvCNn9y6pxtxb
         sCUQCi7KStSZB5+EmgoiG8kC7kDlHH73F2vkDyGa7vuR42qqxS3ZixaGClC3HxaDcPYo
         w2odVnUjm+MFfLwyQxFQq+LZ7Xfa+3b14VdFU4eOIVRHV+8hGpfybIxWWjuyYEAbgCYZ
         E+6qFxTzT0zdyKBVnzGB9Uzu0ADpVgYh6SaqnQmOjdoSk+pFgRcJe0pTUywOHTTh4Rc0
         Aepg==
X-Gm-Message-State: AGi0Pub/tEBIx5lS/Q556fWtZHK/Fr/h6yIem8c6hM6kOV0IDtEi9RGr
        sr6WNxQYjH8n+4qQkdPfNqxkuOBi9biEE27oZUyus0MxqJi3TlJ+l5GfSj8ua3DOmCq531gnliv
        p1sVobkgS167+
X-Received: by 2002:adf:ee91:: with SMTP id b17mr3881549wro.109.1587633966465;
        Thu, 23 Apr 2020 02:26:06 -0700 (PDT)
X-Google-Smtp-Source: APiQypKViKVqjhZYWHhmD4gX+L181e384ppt9H3dp83Sm4GYTaac8jfbTOwhBotE8r0qEIg2tyXvIA==
X-Received: by 2002:adf:ee91:: with SMTP id b17mr3881512wro.109.1587633966196;
        Thu, 23 Apr 2020 02:26:06 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d0a0:f143:e9e4:2926? ([2001:b07:6468:f312:d0a0:f143:e9e4:2926])
        by smtp.gmail.com with ESMTPSA id z18sm2779590wrw.41.2020.04.23.02.26.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 02:26:05 -0700 (PDT)
Subject: Re: [PATCH 4/5] kvm: Replace vcpu->swait with rcuwait
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Marc Zyngier <maz@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
        tglx@linutronix.de, kvm@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>,
        torvalds@linux-foundation.org, bigeasy@linutronix.de,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        joel@joelfernandes.org, will@kernel.org,
        kvmarm@lists.cs.columbia.edu
References: <20200422040739.18601-1-dave@stgolabs.net>
 <20200422040739.18601-5-dave@stgolabs.net> <20200423094140.69909bbb@why>
 <f07f6f55-9339-04b0-3877-d3240abd6d9c@redhat.com>
 <20200423091911.GP20730@hirez.programming.kicks-ass.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1a1e2aa6-64b2-f642-1e19-d3f5684d70b3@redhat.com>
Date:   Thu, 23 Apr 2020 11:26:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200423091911.GP20730@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/04/20 11:19, Peter Zijlstra wrote:
>>
>> 1) Davidlohr, please post only patches 1-3 to "equalize" the swait and
>> rcuwait APIs.
>>
>> 2) Peter, please prepare a topic branch for those, or provide Acked-by
> I don't think I have anything that conflicts with this, so sure, take
> the whole thing through KVM.
> 
> For 1-3 (and I'll send a small niggle for 3 right after this):
> 
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Great thanks.  I assume you have no issue with rcuwait_active either.

Paolo

> I'll keep 5 as it is unrelated.
> 

