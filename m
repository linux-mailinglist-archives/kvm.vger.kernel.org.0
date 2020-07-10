Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E50E821C004
	for <lists+kvm@lfdr.de>; Sat, 11 Jul 2020 00:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgGJWkz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 18:40:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40591 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726588AbgGJWkz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 18:40:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594420854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6kXSGvxmjXAElBrTZSgjzZPkpnuWLKdwi49fRDvDKG8=;
        b=h2rA6VDrdY57wyBpxczO7quhVBJW5Gpc1nBpxS6MaGWOHnG6RYDFgMNms2Gz8RgkEBxOmi
        KC5MT32k0t+8r8WOtEpdCC8nCChYU1UNlkDBsqIhKBjjgId9xQPgn7xNW1LMjZQQbHx4gc
        I0mXT+YMYoAPqULewhiAbqwHgZ0MIGY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-HzFQdwmjOJ2ylqes8uht4Q-1; Fri, 10 Jul 2020 18:40:50 -0400
X-MC-Unique: HzFQdwmjOJ2ylqes8uht4Q-1
Received: by mail-wm1-f70.google.com with SMTP id u68so8253198wmu.3
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 15:40:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6kXSGvxmjXAElBrTZSgjzZPkpnuWLKdwi49fRDvDKG8=;
        b=ZHu0rf5mgHjTZtIx04X/EifkCrlPv1T1mBSOZlZ7SFPWwl451hUtDEwz/R5JMP2TFZ
         XLf1kXyxRs/UnI/2dWKdXe6DZA2OF62lnO2kenVrRQ3jVbTdn6L0bxg3NTmhpXZMYFXj
         LzZmX0ZrAI55QGLXh8CUZknMCqyOdZ7rJnrXaxhoh4Wvf6vYVilKkib3ve8ombSkJdH2
         JJ2b9/jUK5Cby5abRwpsnUzG7i0g1XKXIoQN1IeBikyemaLOYq57N78aAEs5qdctyj0k
         aMH8IV9SFBLobqppceQVrR2k1klrk5uj+jOA0QHoIOD3FuM80CugrYkhnR9r4JOQci/4
         GLDA==
X-Gm-Message-State: AOAM533hyf++Bv8Bl+MnMADLFuTWhWVm+aJHS8Hq7oDexPsb+VhxhuDd
        IxyI8gPNoSi8Y4yT6mlQwUTMcyl8EhQW6sUJQh/02nReKtBjzgZAy8cA2CF7r9y3Bt2/+mQmLZs
        qDOG3IUwGXNrC
X-Received: by 2002:a05:600c:2295:: with SMTP id 21mr6956466wmf.29.1594420849418;
        Fri, 10 Jul 2020 15:40:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzmVJZUPBUzG5MEIOnz/sc3j7x2we1u6N+BGCek/uv6VvBPC9wIf8Loz5HgKE+Wc6qz+QkOxg==
X-Received: by 2002:a05:600c:2295:: with SMTP id 21mr6956449wmf.29.1594420849212;
        Fri, 10 Jul 2020 15:40:49 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ef:39d9:1ecb:6054? ([2001:b07:6468:f312:ef:39d9:1ecb:6054])
        by smtp.gmail.com with ESMTPSA id r8sm11620509wrp.40.2020.07.10.15.40.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2020 15:40:48 -0700 (PDT)
Subject: Re: [PATCH 1/4] kvm: x86: add KVM_{GET,SET}_TSC_OFFSET ioctls
To:     Jim Mattson <jmattson@google.com>
Cc:     Oliver Upton <oupton@google.com>, kvm list <kvm@vger.kernel.org>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Hornyack <peterhornyack@google.com>
References: <20200710200743.3992127-1-oupton@google.com>
 <61da813b-f74b-8227-d004-ccd17c72da70@redhat.com>
 <CALMp9eS1NB25OjVmAOLPEHu7eEMSJFy1FpYbXLSSKwp0iDs_QA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <35f1f26a-3d50-26b1-9c83-478da9017d59@redhat.com>
Date:   Sat, 11 Jul 2020 00:40:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eS1NB25OjVmAOLPEHu7eEMSJFy1FpYbXLSSKwp0iDs_QA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/07/20 00:09, Jim Mattson wrote:
>>  But I have a fundamental question that isn't answered by either the
>> test or the documentation: how should KVM_SET_TSC_OFFSET be used _in
>> practice_ by a VMM?
>
> One could either omit IA32_TIME_STAMP_COUNTER from KVM_SET_MSRS, or
> one could call KVM_SET_TSC_OFFSET after KVM_SET_MSRS. We do the
> former.

Other questions:

1) how do you handle non-synchronized TSC between source and destination?

2) how is KVM_REQ_MASTERCLOCK_UPDATE triggered, since that's the main
function of the various heuristics?

Paolo

