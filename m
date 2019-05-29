Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64E392D3E3
	for <lists+kvm@lfdr.de>; Wed, 29 May 2019 04:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbfE2Ci5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 22:38:57 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54559 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbfE2Ci5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 22:38:57 -0400
Received: by mail-wm1-f66.google.com with SMTP id i3so444899wml.4
        for <kvm@vger.kernel.org>; Tue, 28 May 2019 19:38:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pP3fYcLgKNcn4ZGi02aByM6WGyk5AzcIbGUQ+cLa/MU=;
        b=KnwSV6+WbB2asib47STmXx/9zbxc7ox+Rh1m2J03iT6fm9aVYWHUT9QIwlGLwbN4Zw
         LBPer9T5tqw0FlKz6B4tGgrRcsoWaNXjegy5o8YVm/57gjM7fCoKvqK5Lix6mL3djyOP
         b+olSBcBI/w+brcFs1aGQz8AkieEXSAIThi3zeuli2dAB2wI3dq379JkJyR2kvl+9/ay
         lr6oD6nCYEQQGqxg/xPSabwEvfONyzXF4YE+2hYy2SNg5HsTJ7yDVruvAf5SIURblGkP
         5sLTbs8HBZMqH3bbzs0PvLZFH1BIQkQSEviCO9MkfxaoBasfznXY3pC/DKT7jEEpzD+0
         XryQ==
X-Gm-Message-State: APjAAAUisytW3oJw+DS4brcXQYlJXdzl26oeAb8kzDGmdajhJvQKMMHr
        dKkoJc1AgwLKpiLWm8InJ+Yp4axXuuk=
X-Google-Smtp-Source: APXvYqwWFZgfUA/y6b7pztK6v2VYoXi6rFrIYAUoQFJJ01BZd4wPg7v9e3QmiJigMbe2sIgRafm9ew==
X-Received: by 2002:a05:600c:214d:: with SMTP id v13mr4998628wml.12.1559097534873;
        Tue, 28 May 2019 19:38:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c43e:46a8:e962:cee8? ([2001:b07:6468:f312:c43e:46a8:e962:cee8])
        by smtp.gmail.com with ESMTPSA id q9sm3063089wmq.9.2019.05.28.19.38.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 19:38:54 -0700 (PDT)
Subject: Re: [PATCH v2 1/3] KVM: x86: add support for user wait instructions
To:     Tao Xu <tao3.xu@intel.com>
Cc:     rkrcmar@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        sean.j.christopherson@intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jingqi.liu@intel.com
References: <20190524075637.29496-1-tao3.xu@intel.com>
 <20190524075637.29496-2-tao3.xu@intel.com>
 <419f62f3-69a8-7ec0-5eeb-20bed69925f2@redhat.com>
 <c1b27714-2eb8-055e-f26c-e17787d83bb6@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b5daf72d-d764-baa4-8e7f-b09dff417786@redhat.com>
Date:   Wed, 29 May 2019 04:38:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <c1b27714-2eb8-055e-f26c-e17787d83bb6@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/05/19 04:05, Tao Xu wrote:
>>
> 
> Thank you Paolo, but I have another question. I was wondering if it is
> appropriate to enable X86_FEATURE_WAITPKG when QEMU uses "-overcommit
> cpu-pm=on"?

"-overcommit" only establishes the behavior of KVM, it doesn't change
the cpuid bits.  So you'd need "-cpu" as well.

Paolo

> Or just enable X86_FEATURE_WAITPKG when QEMU add the feature
> "-cpu host,+waitpkg"? User wait instructions is the wait or pause
> instructions may be executed at any privilege level, but can use
> IA32_UMWAIT_CONTROL to set the maximum time.

