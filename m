Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3503D1C9650
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 18:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbgEGQVZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 12:21:25 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:45844 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726470AbgEGQVY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 May 2020 12:21:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588868483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uauPqEKc6UVzX7GhKV0bkB/W3wZHCC/w2jsufvTYHDk=;
        b=hW0W3nU+EXJVN+sWFt/Gngn6uVOBEXcVRzh7pFCOmGyi7LqwVMs91mesO9slnLLu/Ob1I3
        a5bn1mfaA+T6s/gHYBDF9/23KYlKHSgs4VQBKXcBaEHY+MKK+oD0gbe0qTIRAvywMM815W
        yaL1H/WQ7R2eroBJO2fV96WrPsfDwlI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-mFnLAfk8MyefPkws0KVXlw-1; Thu, 07 May 2020 12:21:21 -0400
X-MC-Unique: mFnLAfk8MyefPkws0KVXlw-1
Received: by mail-wm1-f71.google.com with SMTP id s12so3691555wmj.6
        for <kvm@vger.kernel.org>; Thu, 07 May 2020 09:21:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uauPqEKc6UVzX7GhKV0bkB/W3wZHCC/w2jsufvTYHDk=;
        b=e52H3nv1fELJdPwcsx3JqB8P2FxWtHkV3Tfn2BXox039HnOhGHnLKGlmF+c+n9IO2b
         HYjv2ur+oau+37JQ4Gx9Tp+dApdYEKZbVjX771UNG7fFDU5ocyFf1t9WqjXamDxY/Jq1
         1H4XVKw2YQ9x21zuPrtGSdLA4+X+hWO9QZIw+UTUuQb7Y5MYzsyPL87MoUKHvuXdUd2/
         NUkuobV64FoC4ySnAp2po0SNUEKJm5ccXNE6FKx7+t6fh9hbF8GPKXG1qAzuB6s9trp+
         wS3lGiyQ2PqrSn/+JZhrC16rOQD4seW53yaXeqJhqByxaP0AWGeu3sgk+UvqDE49uUA4
         vLEA==
X-Gm-Message-State: AGi0Pub0yvmVVmq7M97ggTpcsIexRAA7XB6c6gbdlL1LMTnkKUNHd+PK
        1Yr/CrRLnCYRTUyAkVXlHUXXcpdjcprtXaj/fom65BOT8yMw+n3EWv/SEFPZAFk3cFst4ADbPEo
        yRBA3XZbvH+xf
X-Received: by 2002:adf:e812:: with SMTP id o18mr17170881wrm.185.1588868479598;
        Thu, 07 May 2020 09:21:19 -0700 (PDT)
X-Google-Smtp-Source: APiQypJlD2aWgLcfJmYsanf2JcFh67EG6I64TLsOvj8abuHuKjLOq+W3EmBYLtX1ngf3pRXS6ERGig==
X-Received: by 2002:adf:e812:: with SMTP id o18mr17170857wrm.185.1588868479332;
        Thu, 07 May 2020 09:21:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8d3e:39e5:cd88:13cc? ([2001:b07:6468:f312:8d3e:39e5:cd88:13cc])
        by smtp.gmail.com with ESMTPSA id l1sm9215989wrc.24.2020.05.07.09.21.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 09:21:18 -0700 (PDT)
Subject: Re: [PATCH 9/9] KVM: VMX: pass correct DR6 for GD userspace exit
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20200507115011.494562-1-pbonzini@redhat.com>
 <20200507115011.494562-10-pbonzini@redhat.com>
 <20200507161854.GF228260@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7abe5f7b-2b5a-4e32-34e2-f37d0afef00a@redhat.com>
Date:   Thu, 7 May 2020 18:21:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200507161854.GF228260@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/05/20 18:18, Peter Xu wrote:
>>  		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) {
>> -			vcpu->run->debug.arch.dr6 = vcpu->arch.dr6;
>> +			vcpu->run->debug.arch.dr6 = DR6_BD | DR6_RTM | DR6_FIXED_1;
> After a second thought I'm thinking whether it would be okay to have BS set in
> that test case.  I just remembered there's a test case in the kvm-unit-test
> that checks explicitly against BS leftover as long as dr6 is not cleared
> explicitly by the guest code, while the spec seems to have no explicit
> description on this case.

Yes, I noticed that test as well.  But I don't like having different
behavior for Intel and AMD, and the Intel behavior is more sensible.
Also...

> Intead of above, I'm thinking whether we should allow the userspace to also
> change dr6 with the KVM_SET_GUEST_DEBUG ioctl when they wanted to (right now
> iiuc dr6 from userspace is completely ignored), instead of offering a fake dr6.
> Or to make it simple, maybe we can just check BD bit only?

... I'm afraid that this would be a backwards-incompatible change, and
it would require changes in userspace.  If you look at v2, emulating the
Intel behavior in AMD turns out to be self-contained and relatively
elegant (will be better when we finish cleaning up nested SVM).

Paolo

