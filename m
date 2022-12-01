Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5466E63EC7B
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 10:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbiLAJ37 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 04:29:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiLAJ3y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 04:29:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC1CB47312
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 01:28:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669886936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DqJwh6hYdcIFrfwArsCxvaHceaf9hhtSNB2KWeumwNo=;
        b=DjEIuSRPYGKlw+Lewzu86+97CZhdlx86nAZx4/ccBXN1hsj/ZfjKL8kPlgZn0q0B22dq3w
        QO9eL9kHo9L8Jz3rmHMTqitvQvih6JXhQOrWKiIyF8s27uvevrLEDlz2TgK4PdI+E+jcaI
        L/HlTtMqw+7R7WZUCJC4yTzYeY7a+Pw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-444-KkMOVYFmPwyY6Vw6gMkwrw-1; Thu, 01 Dec 2022 04:28:54 -0500
X-MC-Unique: KkMOVYFmPwyY6Vw6gMkwrw-1
Received: by mail-wm1-f71.google.com with SMTP id 1-20020a05600c028100b003cf7833293cso2289832wmk.3
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 01:28:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DqJwh6hYdcIFrfwArsCxvaHceaf9hhtSNB2KWeumwNo=;
        b=L02rXB62o2ZOTPfm+yi6COo/3uNtRREX+JoUm+PjSEjTqWrsJfJW0jDCuvGoqHIePR
         b8q1o+kJD9rOjpsVua+JueF/NiieOQgtTR1H8fgl/g6ROMQO8K1yarpt6We9DDKE7iPw
         1gvZTihnjFoL6MkI3vmtruLf1gbyfoqj+JBpenX9NqSs5inqJAnCiBnFYMoA66hl6ggF
         AxjCvPD86QGSoc0odNajvOhiq1cwQhv8IhfWOGBHv48BzTrOhY9GvDf2Ynu6IobzuPZC
         8yK+/m0WmEpZsEYCHGBwiOVu+lL6n3ZG5WikvRDyW2iru/UlNp3TW6z4lfOL1fkGo6go
         jkqA==
X-Gm-Message-State: ANoB5pl/iA45ciwnJyV3VHqfnj3KhuxTACIe5Ix/cxUWNG+7rNr9E05+
        iWv5cAH1N8yk98LuTSrG33qFEq0Fbjswp1tnmxeTaqaeT5HG/T1yjgeb1rh5z56O86UjqfYIpYB
        pfgNYUdWbM6BHjCNWtj0kYiyT2AVYqaezmZvpeOD7mR4JRTliai8Y+wOBk91Xm09q
X-Received: by 2002:a5d:6045:0:b0:242:16ad:9a91 with SMTP id j5-20020a5d6045000000b0024216ad9a91mr12300843wrt.197.1669886933636;
        Thu, 01 Dec 2022 01:28:53 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7Q06N1wMVePOK6Bx8fS032S/PPHK8GF5CDS+4WAHNvDrSE9S6kZ4/8Pw1TsqL6DFgeERm6dA==
X-Received: by 2002:a5d:6045:0:b0:242:16ad:9a91 with SMTP id j5-20020a5d6045000000b0024216ad9a91mr12300825wrt.197.1669886933379;
        Thu, 01 Dec 2022 01:28:53 -0800 (PST)
Received: from ovpn-194-141.brq.redhat.com (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id y16-20020adfd090000000b002364c77bcacsm3868668wrh.38.2022.12.01.01.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 01:28:52 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: restore special vmmcall code layout
 needed by the harness
In-Reply-To: <Y4ffgC+HbftkPbaW@google.com>
References: <20221130181147.9911-1-pbonzini@redhat.com>
 <Y4ffgC+HbftkPbaW@google.com>
Date:   Thu, 01 Dec 2022 10:28:51 +0100
Message-ID: <87r0xjh3qk.fsf@ovpn-194-141.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Nov 30, 2022, Paolo Bonzini wrote:
>> Commit 8fda37cf3d41 ("KVM: selftests: Stuff RAX/RCX with 'safe' values
>> in vmmcall()/vmcall()", 2022-11-21) broke the svm_nested_soft_inject_test
>> because it placed a "pop rbp" instruction after vmmcall.  While this is
>> correct and mimics what is done in the VMX case, this particular test
>> expects a ud2 instruction right after the vmmcall, so that it can skip
>> over it in the L1 part of the test.
>> 
>> Inline a suitably-modified version of vmmcall() to restore the
>> functionality of the test.
>>
>> Fixes: 8fda37cf3d41 ("KVM: selftests: Stuff RAX/RCX with 'safe' values in vmmcall()/vmcall()"
>> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>
> We really, really need to save/restore guest GPRs in L1 when handling exits from L2.

+1, the amount of stuff we do to workaround the shortcoming (and time
we waste debugging) is getting ridiculously high. 

>
> For now,
>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
>

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

