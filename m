Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F27A1DC943
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 11:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbgEUJG3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 May 2020 05:06:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43146 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728657AbgEUJG2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 May 2020 05:06:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590051986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SFef6OF+BENk1H5JbtM/akQLA/a8TYftKd93Z9vdsbk=;
        b=dKab9LKVRg9d69CFIsDXkiWAXFjo81IymJZtC/2w67a+PXwUNi9VQ2WYzb1aMQ8T3806+n
        Os8PH3lmPgXYjuUvqhWAzGso8/WJvkjwU/XY99J9/mexBo/JctrJT5Lpsna+vI9yHHDUS8
        qI54M+Wk9u/qSSZGY38fiN3oEeQ3QhM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-NJ0gTUjdOkG_Uj9c7AWK6g-1; Thu, 21 May 2020 05:06:25 -0400
X-MC-Unique: NJ0gTUjdOkG_Uj9c7AWK6g-1
Received: by mail-wm1-f69.google.com with SMTP id m11so1594371wml.5
        for <kvm@vger.kernel.org>; Thu, 21 May 2020 02:06:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SFef6OF+BENk1H5JbtM/akQLA/a8TYftKd93Z9vdsbk=;
        b=GVxf8RROol4PypsLAMjBSMQOOPdOLv4hMOCTsKTLBf9OZBwgNGdPsA1J2nq6O0aY9G
         gVGycao2tQj0LMpJLERsubE+NxU/XPU2QjxhcLB71UKC9BLpkZydd+lPPoSWQO4XT8r/
         f+eGxl/R0URG6lYKIoL8H68KuKH/b4Gjjl3WRPHAu5QJWtyp2177/AzfT0M0HTK8myyN
         Pt26ifrqY+FSnnesS2y6sy7Mx92RUJMINCanwAHJdP25vNiw/JLyzph/8fSAzcqnSGRR
         K63d46f8rapSIKLlk2JxiaPoDMkOzvUeSE6JwVaghKOt5f4IyAdQil5U0IwY+V6LgYFr
         3YdQ==
X-Gm-Message-State: AOAM533eeHRbsktPnwZCeUN1dDHPFJW1UocVjv/xtZXJ7v0VcOnMEfjA
        eAmdX9RAvhT1wf5pWNmHwlcAuebshz7v7GrsIYCf7JJWJKZUefZBxrP97BRSVDWlRNyPdDFSBW8
        /IAbrI9QRxxNw
X-Received: by 2002:a5d:414f:: with SMTP id c15mr7703474wrq.61.1590051984025;
        Thu, 21 May 2020 02:06:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwL7FmBS85oUXSNz9BGdJ3UqFa+WqgqzKgvKSARq4ktDju8C9BIoMKx7g6q0tq+fDv9IX58vw==
X-Received: by 2002:a5d:414f:: with SMTP id c15mr7703459wrq.61.1590051983809;
        Thu, 21 May 2020 02:06:23 -0700 (PDT)
Received: from [192.168.178.58] ([151.30.94.134])
        by smtp.gmail.com with ESMTPSA id p9sm5703874wrj.29.2020.05.21.02.06.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2020 02:06:23 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] KVM: nVMX: Fix VMX preemption timer migration
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Makarand Sonare <makarandsonare@google.com>
Cc:     kvm@vger.kernel.org, pshier@google.com, jmattson@google.com
References: <20200519222238.213574-1-makarandsonare@google.com>
 <20200519222238.213574-2-makarandsonare@google.com>
 <87v9kqsfdh.fsf@vitty.brq.redhat.com>
 <CA+qz5sppOJe5meVqdgW-H=_2ptmmP+s3H9iVicA0SRBpy4g5tQ@mail.gmail.com>
 <d21f47c0-dd48-53f8-ffbb-8d6f8637b50b@redhat.com>
 <87mu61smho.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <238d656c-df6a-85cd-074b-f4b134b37c6e@redhat.com>
Date:   Thu, 21 May 2020 11:06:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <87mu61smho.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/05/20 10:47, Vitaly Kuznetsov wrote:
>>>
>> Yes, please do so.  The header is exactly for cases like this where we
>> have small fields that hold non-architectural pieces of state.
>>
> This can definitely work here (and I'm not at all against this solution)
> but going forward it seems we'll inevitably need a convenient way to
> handle sparse/extensible 'data'. Also, the header is 128 bytes only.

I'd rather cross that bridge when we get there, so:

- for now, add an u32 to the header that indicates the validity of
header fields other than smm.flags (in this case the preemption timer
deadline)

- if we ever add more stuff to the data, we will 1) always include the
first 8k for backwards compatibility 2) use another u32 in the header to
tell you the validity of the data

Addition to the nested state header should be relatively rare, since
it's only for non-architectural (implementation-specific) state.

Paolo

> I'd suggest we add an u32/u64 bit set to the header (which will be separate
> for vmx/svm structures) describing what is and what's not in vmx/svm
> specific 'data', this way we can easily validate the size and get the
> right offsets. Also, we'll start saving bits in arch neutral 'flags' as
> we don't have that many :-)

