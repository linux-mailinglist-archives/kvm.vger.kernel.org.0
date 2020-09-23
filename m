Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3ED6275E6F
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 19:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgIWRQQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 13:16:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31993 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726610AbgIWRQQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Sep 2020 13:16:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600881374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j6lyST6OFqSp3wXFZUXKiJrEGOfZYQRYSp6oi5Lyb1E=;
        b=Qwjbfk744PZUhva5BHgm8r6m2AxhVbqfs3Muu7vZfPR5SqjGj/YnUVVWSAJl5tMOAy/ozN
        qti//63o/JvDUQnxFjtaX2W9DbsCOqi2uT0x9A82NbcAK2/ae7ZE/5kIyh1QApsluSNNxx
        DoJzRlg3XXWKCX6Q0Zj0iNDdJk79lag=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-EVOVJO7XOEyYh8zTH7hq3g-1; Wed, 23 Sep 2020 13:16:13 -0400
X-MC-Unique: EVOVJO7XOEyYh8zTH7hq3g-1
Received: by mail-wr1-f70.google.com with SMTP id f18so90685wrv.19
        for <kvm@vger.kernel.org>; Wed, 23 Sep 2020 10:16:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j6lyST6OFqSp3wXFZUXKiJrEGOfZYQRYSp6oi5Lyb1E=;
        b=KcZVlBmIMVL0t8s4NcEsk9j+Z7On1fxRAG8LfbmZ/xXvFsGh95L623jJAGOsJY8GCn
         7NX5SmeZ9rYA/bBIOdO1dDBHkewTyiB3fSfFJ88bdS9mr9hCHqU8RT8tageFE+yivIB3
         KrTBxD42gcxqpCsXgBTz8UUZ6X8GQHFe1u27oM0GIKEL6DPFMdExpi2IANFJSXixFSsE
         vwc2ZHAr5+QvAdkJixV67mBw6zbUXUEj88gurN6ZqZ/WuYJAVNc2JkJGnPrWUq47sjdj
         /vWG853kcyzHH5pO7CryKsWqshxUIgslX7GEAwMPtDlXqJ8SGapSeDqLx0aop51omgzC
         vMGQ==
X-Gm-Message-State: AOAM530QadGSefuUhYnq7I5jRGGuXr2QqmT2YtCDw+aOopj7t/FgeP6O
        aw8qmg5Q7PMHhXUfm9Jg6IzdQfvBFE5uW5VKF3dSbDrxtg8tso43BlTqwzoWxoRcgBcvKYlXeui
        n2CXnogIx3DWp
X-Received: by 2002:a1c:dd45:: with SMTP id u66mr547609wmg.117.1600881371874;
        Wed, 23 Sep 2020 10:16:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwBQZUkAml+/LYsKte8cnjwy8zg/1tkQYiaknmCWyZZ4jYwsCvCbzOMxy5MpbTqXnEspn1mFA==
X-Received: by 2002:a1c:dd45:: with SMTP id u66mr547580wmg.117.1600881371683;
        Wed, 23 Sep 2020 10:16:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:15f1:648d:7de6:bad9? ([2001:b07:6468:f312:15f1:648d:7de6:bad9])
        by smtp.gmail.com with ESMTPSA id e18sm439361wrx.50.2020.09.23.10.16.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 10:16:10 -0700 (PDT)
Subject: Re: [PATCH] KVM: SVM: Mark SEV launch secret pages as dirty.
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Cfir Cohen <cfir@google.com>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        Lendacky Thomas <thomas.lendacky@amd.com>,
        Singh Brijesh <brijesh.singh@amd.com>,
        Grimm Jon <Jon.Grimm@amd.com>,
        David Rientjes <rientjes@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
References: <20200807012303.3769170-1-cfir@google.com>
 <20200919045505.GC21189@sjchrist-ice>
 <5ac77c46-88b4-df45-4f02-72adfb096262@redhat.com>
 <20200923170444.GA20076@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <548b7b73-7a13-8267-414e-2b9e1569c7f7@redhat.com>
Date:   Wed, 23 Sep 2020 19:16:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200923170444.GA20076@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/20 19:04, Sean Christopherson wrote:
>> Two of the three instances are a bit different though.  What about this
>> which at least shortens the comment to 2 fewer lines:
> Any objection to changing those to "Flush (on non-coherent CPUs)"?  I agree
> it would be helpful to call out the details, especially for DBG_*, but I
> don't like that it reads as if the flush is unconditional.

Hmm... It's already fairly long lines so that would wrap to 3 lines, and
the reference to the conditional flush wasn't there before either.

sev_clflush_pages could be a better place to mention that (or perhaps
it's self-explanatory).

Paolo

