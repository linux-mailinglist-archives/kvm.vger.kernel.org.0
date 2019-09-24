Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 650A6BC99E
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 16:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391395AbfIXOBP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 10:01:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43877 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730528AbfIXOBO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 10:01:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569333673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IfbpZPEsHSj39V3B/gslbKp0F2Lm4thTQilGsqz+MQY=;
        b=diP/rKbLlJ8t045ugOslrhtBu8mYEuNbONy9ImUKbgFWL0zJyFmxT/8SlIa7wFR+esR0sK
        x7T1hURXHUBPPwD7iQbVyHl33w5EHqyYvCcHyDhdtibDfCFU7XjFpVn37/lJhuikSHyVeL
        Grvw6hDi4ugMZolomJdb3VRpBabHwco=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-pLK_go4oMHCWKEO_a7Q43Q-1; Tue, 24 Sep 2019 10:01:11 -0400
Received: by mail-wr1-f70.google.com with SMTP id v13so605270wrq.23
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 07:01:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IfbpZPEsHSj39V3B/gslbKp0F2Lm4thTQilGsqz+MQY=;
        b=WrEunc6LPREwskuS5/gugnsxjryOvXtWOUQ1ic5YgjGsIduOnOmikqe9DSOWZIxyU5
         //GfqRldxGev/rdMoSwe6DwiogBoqwVIIPneYBnHTiXNj3LAdIBINaQvmQfljya8vK8z
         s2IQ0oRE+oniWQHHa1+oYQUPn8E3GkSSpTOrakE7mVAcGXA7jTgvVAfHHrcl+p9zGMiM
         OsQfwPlgZKz5iLSh2L1uvTjhnTNtnx2K/i4O/r5DjMOlNp1JyDetLCnCriRDjNZvNcFP
         eG3r6ANczEAbXYdnF5WbTfuLoHMbWy+bwzaPoUsIL9EWMionmT3U6Z1G8AebbAY4FhaD
         H+hw==
X-Gm-Message-State: APjAAAWKoGxegEPTsNHuedCD0jhlW3HA2W4TUPE2YfG5YCR/ctacClDh
        Khp376sBuEDHfz76RBZoFXumTjzQpgcPsZJrz+2io9nysx2lRF0rm8HPcjFRvLPXDT/8oJArU1r
        UWAdGOjfJ0kR5
X-Received: by 2002:a1c:5444:: with SMTP id p4mr156823wmi.69.1569333669687;
        Tue, 24 Sep 2019 07:01:09 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw8EyCUNkLRzQ1FO6w7GeYIvxdOOBZ/BSpICm/A2LF9JkbZdnq6n4OgMa3qtSmgMmaN7Ta3+A==
X-Received: by 2002:a1c:5444:: with SMTP id p4mr156791wmi.69.1569333669431;
        Tue, 24 Sep 2019 07:01:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id c8sm1333418wrr.49.2019.09.24.07.01.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Sep 2019 07:01:08 -0700 (PDT)
Subject: Re: [RFC][PATCH] kvm: x86: Improve emulation of CPUID leaves 0BH and
 1FH
To:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Steve Rutherford <srutherford@google.com>,
        Jacob Xu <jacobhxu@google.com>, Peter Shier <pshier@google.com>
References: <20190912232753.85969-1-jmattson@google.com>
 <20190918174308.GC14850@linux.intel.com>
 <CALMp9eQSd8kMKEdLYTF2ugAYjQO-wAR-PoYmf0NgD2Z4ZVr5FA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <986c2e6d-3784-6f12-b6e8-c859a2d8c166@redhat.com>
Date:   Tue, 24 Sep 2019 16:01:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQSd8kMKEdLYTF2ugAYjQO-wAR-PoYmf0NgD2Z4ZVr5FA@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: pLK_go4oMHCWKEO_a7Q43Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/09/19 20:22, Jim Mattson wrote:
> Aside from the fact that one should never call check_cpuid_limit on
> AMD systems (they don't do the "last basic leaf" nonsense), an
> approach like this should work.

Yeah, I agree it's enough.  If there's a complex or really weird
behavior that userspace would most definitely get wrong, we should
design the API to simplify its job.

Paolo

