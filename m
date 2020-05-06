Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDF91C75C8
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 18:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729927AbgEFQJa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 12:09:30 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:31396 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729418AbgEFQJ3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 12:09:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588781368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LSgQ8YJxEMhLIrqO/YJcdGSlP0f7eNQQ/CQ1CO6dBlo=;
        b=NieykpUA7el+C8mFb/2qgkHAZrHy5wz4Q/oOjOjm/FejcrWEg8dqFku/LLOeNTeZ0dPNoF
        hrjQKbeqvbda7BR3UfeJUl0QMdoI1Ye0PtSTK450w1sA+bbe5KqsOH8uYwfFMPcy5Q9NeP
        VFt9o3z/ztiJUvUEs6lCZZanQkzn4SY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-mgiBIZ4bP7-bz7YuUeEWew-1; Wed, 06 May 2020 12:09:27 -0400
X-MC-Unique: mgiBIZ4bP7-bz7YuUeEWew-1
Received: by mail-wr1-f72.google.com with SMTP id p8so1571247wrj.5
        for <kvm@vger.kernel.org>; Wed, 06 May 2020 09:09:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LSgQ8YJxEMhLIrqO/YJcdGSlP0f7eNQQ/CQ1CO6dBlo=;
        b=I1XzA5YnbfZLsFAhEoJsAlh3vRyjbgUrbsZ0zgVNZyP5rVSfgoTZQ3segPb4nd+0dF
         her0pSXW6S5Re8Sal4KEUIPm7zBarGq9kIladX8DIpDcCEjcAD+sxNShZrixDirUsg0a
         NiIZTIL3umoX3NBQLLMzW5ohLGgsIjPvVauevgLv0QIrEEiA6AWmAQeIT2vAj5fBhvlH
         APN2D/x0T7QFS0CkNc4b1xFwdXKwUkd1mv6FRnE4yZtT19EEqlX3hVoFiKOCUGbMgDx3
         JyLxrBd+eD59LyQtBRHdnHlX1P1KWt0+XXSBwBEwMzO411E8V6HVwyJZ+0Wqw3/IM2CS
         F/uQ==
X-Gm-Message-State: AGi0PuaieNzocpc2+ZKeMyLmOETbreitQbwjfvBRJS/Ar5wkUMhyTjJ9
        84/EmQfSLg5CHlYCwIK9vxSBbCuAtLGxboAATt1LxyM9Ru8bLY0VEQnAzUDI5jHIg/jAsHpZ7pi
        YXKuhFNWNI2yI
X-Received: by 2002:a05:600c:22d6:: with SMTP id 22mr5176817wmg.121.1588781365654;
        Wed, 06 May 2020 09:09:25 -0700 (PDT)
X-Google-Smtp-Source: APiQypI7gzG5qcbx8VG1Ygu0+6ZEU8iGxjvwNjrNCvKqYtR7y1a21HzIpeztonpTyCyr1MPQTdPsGQ==
X-Received: by 2002:a05:600c:22d6:: with SMTP id 22mr5176789wmg.121.1588781365458;
        Wed, 06 May 2020 09:09:25 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:11d7:2f21:f38b:17e? ([2001:b07:6468:f312:11d7:2f21:f38b:17e])
        by smtp.gmail.com with ESMTPSA id m188sm3461061wme.47.2020.05.06.09.09.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2020 09:09:24 -0700 (PDT)
Subject: Re: [PATCH 7/9] KVM: x86: simplify dr6 accessors in kvm_x86_ops
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200506111034.11756-1-pbonzini@redhat.com>
 <20200506111034.11756-8-pbonzini@redhat.com> <20200506160623.GO6299@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2d44c75f-00df-3cae-31a8-982a0b95f0b0@redhat.com>
Date:   Wed, 6 May 2020 18:09:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200506160623.GO6299@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/05/20 18:06, Peter Xu wrote:
> On Wed, May 06, 2020 at 07:10:32AM -0400, Paolo Bonzini wrote:
>> kvm_x86_ops.set_dr6 is only ever called with vcpu->arch.dr6 as the
>> second argument, and for both SVM and VMX the VMCB value is kept
>> synchronized with vcpu->arch.dr6 on #DB; we can therefore remove the
>> read accessor.
>>
>> For the write accessor we can avoid the retpoline penalty on Intel
>> by accepting a NULL value and just skipping the call in that case.
>>
>> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> (I think this patch and the previous one seem to be the same as the previous
>  version.  Anyway...)

Yes, I placed them here because they are needed to solve the SVM bugs in
patch 8.  Sorry for not adding your Reviewed-by.

Paolo

> Reviewed-by: Peter Xu <peterx@redhat.com>

