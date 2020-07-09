Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 997AC21A654
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 19:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728485AbgGIRvz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 13:51:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23404 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728371AbgGIRvy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 13:51:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594317113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lm9MgZD36ADnk2YR9CzyFzRTbWxkMgc22jnTyO1aW40=;
        b=fkxaY4rVHtXv9YUUnNZWBci+Kf0+slb9hSOel5n6IHn4uCELhSmoYSE1cTqpzG8J5NECc9
        6GZL6435CM9EP+/TZEyNIYhtArasE62zKlRAd2XGODi7xKdv3TkYc6pE4Hc32Rjt0NNDHl
        +howUqrCF/JZ49AE68VzyE+Xfsmq5mc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-dgEpLptEORyAaxRUG1KS4g-1; Thu, 09 Jul 2020 13:51:52 -0400
X-MC-Unique: dgEpLptEORyAaxRUG1KS4g-1
Received: by mail-wm1-f70.google.com with SMTP id c124so2936193wme.0
        for <kvm@vger.kernel.org>; Thu, 09 Jul 2020 10:51:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lm9MgZD36ADnk2YR9CzyFzRTbWxkMgc22jnTyO1aW40=;
        b=iy0pJObylwTfMAt2ki8C0eVx2EKJxkutb/h6yh/80ZM9pYTZnqAQVV65bux7n2Jt+8
         EOeEKfXA423eG1e7B3cYPI7gMCUUP9T4FLbrXP18V7j9ViJ9YAX57vKJhzft19tmbdY0
         7qdQVEfAhswHqjcDPMKt7E0FSFAQAjpSlmcZHa6zmuxqeepKnRALiQqC3hp+Qlu8pX16
         9NFDm/fAVvEN27eT6JPu0Pms40N7hIYvmcXeTP81dPOWPDb1oFaft9hRkhFof5gE/KNp
         ZFfFewBnMLd0sxS9IZVqRe3Q7Wobp9C6TSXIAZ0xTW9m/pTeMFA+2nlJrW1uxBfwn5Nb
         Okng==
X-Gm-Message-State: AOAM533702bN5ZWFuUuB1Xor3X7XvRPH3AEzY0AmWHe9nyQY4Z6Qp0km
        F1nyFic1Z1O8qAdJ1axqA5TMURK+Gdy14rXg3XDRU/uPORmjK7NrKOTH6cnEOIEe79QpxG/wW2e
        MxGJ02RqUlq6M
X-Received: by 2002:a05:600c:2f88:: with SMTP id t8mr1140776wmn.186.1594317110845;
        Thu, 09 Jul 2020 10:51:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyb8c8Um027PE4qgR05yIvGPjE72YLpKE1WfO/2Nt5q9OLncvJMT/L6sEMtjkQN6gL0G+2kcw==
X-Received: by 2002:a05:600c:2f88:: with SMTP id t8mr1140758wmn.186.1594317110623;
        Thu, 09 Jul 2020 10:51:50 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id 2sm5578474wmo.44.2020.07.09.10.51.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 10:51:50 -0700 (PDT)
Subject: Re: [PATCH v3 6/9] KVM: nSVM: move kvm_set_cr3() after
 nested_svm_uninit_mmu_context()
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        linux-kernel@vger.kernel.org
References: <20200709145358.1560330-1-vkuznets@redhat.com>
 <20200709145358.1560330-7-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2782f686-1fd5-7042-1a4a-72875ebbf5cf@redhat.com>
Date:   Thu, 9 Jul 2020 19:51:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200709145358.1560330-7-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/07/20 16:53, Vitaly Kuznetsov wrote:
> Note, the change is effectively a nop: when !npt_enabled,
> nested_svm_uninit_mmu_context() does nothing (as we don't do
> nested_svm_init_mmu_context()) and with npt_enabled we don't
> do kvm_set_cr3() but we're about to switch to nested_svm_load_cr3().

Thanks for pointing this out!

Paolo

