Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 959C015A8A3
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 13:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgBLMD5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 07:03:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46247 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727529AbgBLMD4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 07:03:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581509035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8SxLHhpjAQEJ0JP7IaO9lFnJo84SkkSk2cpXsVcdcUU=;
        b=LrzLAhDAmw0i6p6XnWITaLNmQyDHGH8Ws3q0caVKeQUyJQUnQ9cjehzgNBUniYUkdfyY8x
        i6AdHIA5N4GX39KFl5rgR5+errdeEKrX3KuVOz1T2q43S2XVujlGdiUxiUjTMAQr4wRa+P
        JniPs+aI2frfzjEH8CuJhkzHY1nwsuE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-L3q2DjWcP7GGRLEWc2iLpQ-1; Wed, 12 Feb 2020 07:03:54 -0500
X-MC-Unique: L3q2DjWcP7GGRLEWc2iLpQ-1
Received: by mail-wm1-f71.google.com with SMTP id w12so639467wmc.3
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 04:03:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8SxLHhpjAQEJ0JP7IaO9lFnJo84SkkSk2cpXsVcdcUU=;
        b=a5+5D1gkZIf8c6ju5h/k1IY1JSYzd/fgeUCxgUYiprCWtQHbf8tXlG1nLKwDX1HHJa
         PuaztRcBvVEaRJw6aKpJVpPZl6K1M7IaQ2A/LXIxGHpiRS1Bz7c0t9/TMBEln3kmscD/
         1059aN5yXLY4kCD+2yr223V96TArEqCC/7hWIkIz2slTTQ5AA1FVjkeoFVUELywi55J1
         0q1TxmmGMZWSZQXjP0D1acFmWfdVXX8470NMgqNEcGaFO0sR/r+78QS8DslNu+H9RCip
         1v0XrSD3H+2CgbSsFcjmTJrAzk2Y0NhkiFFR8MaY1lOuYUDNtd2Dkr6LzRIo7y3+BzQ1
         YVfA==
X-Gm-Message-State: APjAAAXd3cRtBlg1lsQeS+hICt/kVLGDdjOiZ7bjLoAwH9svNGnXOkVq
        LGrneKLfwLiFdb534rhSeT1wzZDdSQJ56zAo/79ikNfQzGpf7effr0JbFfozZ4zM2z7scIBZT/a
        WXGV1w3BRI8Zo
X-Received: by 2002:a1c:a5c7:: with SMTP id o190mr6424525wme.183.1581509032965;
        Wed, 12 Feb 2020 04:03:52 -0800 (PST)
X-Google-Smtp-Source: APXvYqxFU8+3CC0ZZTfJ8QSvJAdfRn7RiZT5y+sES9vhIzRMzK18UI+o5Gg8Z/AzdcUapBUasMkkZg==
X-Received: by 2002:a1c:a5c7:: with SMTP id o190mr6424501wme.183.1581509032767;
        Wed, 12 Feb 2020 04:03:52 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:652c:29a6:517b:66d9? ([2001:b07:6468:f312:652c:29a6:517b:66d9])
        by smtp.gmail.com with ESMTPSA id e22sm418585wme.45.2020.02.12.04.03.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 04:03:51 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: Fix perfctr WRMSR for running counters
To:     Eric Hankland <ehankland@google.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20200127212256.194310-1-ehankland@google.com>
 <2a394c6d-c453-6559-bf33-f654af7922bd@redhat.com>
 <CAOyeoRVaV3Dh=M4ioiT3DU+p5ZnQGRcy9_PssJZ=a36MhL-xHQ@mail.gmail.com>
 <c1cec3c8-570f-d824-cb20-6641cf686981@redhat.com>
 <CAOyeoRWX1Xw+iPX52uCZef6Rqk44d-niUTikH1qL-fRoaYJeng@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4445badc-ca82-e9db-2893-ff2a2a961160@redhat.com>
Date:   Wed, 12 Feb 2020 13:03:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CAOyeoRWX1Xw+iPX52uCZef6Rqk44d-niUTikH1qL-fRoaYJeng@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/02/20 23:15, Eric Hankland wrote:
>> Yes, please send it!  Thanks,
> 
> I sent out the test a couple days ago and you queued it (commit
> b9624f3f34bd "Test WRMSR on a running counter").
> Are there any other changes that I should make?

Nope, thanks!

Paolo

