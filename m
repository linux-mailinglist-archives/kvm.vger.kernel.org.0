Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89B71CC1CA
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 15:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbgEIN2w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 May 2020 09:28:52 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:39899 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726942AbgEIN2t (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 9 May 2020 09:28:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589030929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pgV5qMXPn6nUxGDkwIRdUCv59PWTCDtCRVhIT5FCAXg=;
        b=ViJD2OeXJGeO0/dMmP4Ut1WB0Bz7I9SyImS0CsMu/I9g1Jj2F3ZM0ekuOcWV/9G26jCLWZ
        GYgAqqhZZxZAlh/OirorMuh/gPR9gA7cLuGK9GOKMBDO6mSSEb8RgMJaW4758jJ0Xn9Xth
        f5/dEaf7bj84RfnHpxmLw+8SnKc/mwM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-m4rbHNbbN9611UdwSF_qaw-1; Sat, 09 May 2020 09:28:47 -0400
X-MC-Unique: m4rbHNbbN9611UdwSF_qaw-1
Received: by mail-wr1-f69.google.com with SMTP id r11so2374848wrx.21
        for <kvm@vger.kernel.org>; Sat, 09 May 2020 06:28:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pgV5qMXPn6nUxGDkwIRdUCv59PWTCDtCRVhIT5FCAXg=;
        b=a5WjPIyJMzQbVjhD4YDbBI0USmYsAYupgYfRosZPCXqzpe3Gl5AH8gndBvlpSSTeYR
         W4gC5KJrnR8p6kq9kKdFu2y21AV5fdi09g3A2B0Y3rCkZ6Q6kHPB8uXpfbeFExSUUpr/
         d81XcdLWPP+/IlzUkAGdRFh3rWiNJPa6lvpRbNL6G35ILoBK7PxJvIHYZnIizL0Z7aHb
         J9dq6IXOi6+YE9ASQneb+kFOKmI0mJ2Gid7sTuWkpaELlSIJ4oZmXmCPHhYLHWMi8ayj
         gXTNxFzSrhUXQO+TUyprd6ZJOreUXtLuJ7fK6WAYbmO4fCKjHM5yf2DrPt5brHC+LMP+
         xUQA==
X-Gm-Message-State: AGi0Pua6ohK6i8zY6l96bwbhWGjSzZo8RNmBOerJYxN5fCG1kQ31Z+3Z
        2COWi1XBWP64ACQw+VGcdpA5sYII7vJE6USLjLAl5IecFsyM8FkVZTiaSF9I1bvaYF+SQuWGaP6
        1Uqel2Mj1YuRn
X-Received: by 2002:a5d:66c9:: with SMTP id k9mr6288186wrw.307.1589030925673;
        Sat, 09 May 2020 06:28:45 -0700 (PDT)
X-Google-Smtp-Source: APiQypI2iks93LwOr88tUV8jDKcOHKVjqxqThuwkg1n5O41W5X1Qga1b8PVXal6PWA7BMuHirdznnQ==
X-Received: by 2002:a5d:66c9:: with SMTP id k9mr6288169wrw.307.1589030925435;
        Sat, 09 May 2020 06:28:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1cb4:2b36:6750:73ce? ([2001:b07:6468:f312:1cb4:2b36:6750:73ce])
        by smtp.gmail.com with ESMTPSA id f123sm4155582wmf.44.2020.05.09.06.28.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 May 2020 06:28:44 -0700 (PDT)
Subject: Re: [PATCH v2 8/9] KVM: x86, SVM: isolate vcpu->arch.dr6 from
 vmcb->save.dr6
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20200507115011.494562-1-pbonzini@redhat.com>
 <20200507115011.494562-9-pbonzini@redhat.com> <20200507192808.GK228260@xz-x1>
 <dd8eb45b-4556-6aaa-0061-11b9124020b1@redhat.com>
 <20200508153210.GZ228260@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a0dd65bc-bfea-75b8-60d7-5060b9ee6c51@redhat.com>
Date:   Sat, 9 May 2020 15:28:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200508153210.GZ228260@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/05/20 17:32, Peter Xu wrote:
> On Fri, May 08, 2020 at 12:33:57AM +0200, Paolo Bonzini wrote:
>> On 07/05/20 21:28, Peter Xu wrote:
>>>> -	svm->vcpu.arch.dr6 = dr6;
>>>> +	WARN_ON(svm->vcpu.arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT);
>>>> +	svm->vcpu.arch.dr6 &= ~(DR_TRAP_BITS | DR6_RTM);
>>>> +	svm->vcpu.arch.dr6 |= dr6 & ~DR6_FIXED_1;
>>> I failed to figure out what the above calculation is going to do... 
>>
>> The calculation is merging the cause of the #DB with the guest DR6.
>> It's basically the same effect as kvm_deliver_exception_payload.
> 
> Shall we introduce a helper for both kvm_deliver_exception_payload and here
> (e.g. kvm_merge_dr6)?  Also, wondering whether this could be a bit easier to
> follow by defining:

It would make sense indeed but I plan to get rid of this in 5.9 (so in
about a month), as explained in the comment.

Paolo

