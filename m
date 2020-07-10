Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F11CE21B4AF
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 14:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgGJMIm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 08:08:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27379 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726664AbgGJMIl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 08:08:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594382919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yUM81AcWibXXrILu9PnL4nPQ7aWzJJ4/rrMIE6yN0eA=;
        b=XXLR4UdlKhkgKn4V33706zrG0id3lsa0a/ctss/nO4MmFUJYt25J46E34p8s8gQ+/ptKih
        oZ5mhcXbHIPvheulXC5tRR7DTxrwHnWP57jqgEI7eMetnPde/Rc5nNgfpA0ExNIKSX+pHQ
        obG7UKJp96MDC0s1DTh7tmR4ShbS3ao=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-9h6zBlE8N7u0AJl0Y4ehJQ-1; Fri, 10 Jul 2020 08:08:36 -0400
X-MC-Unique: 9h6zBlE8N7u0AJl0Y4ehJQ-1
Received: by mail-wr1-f71.google.com with SMTP id a18so5871491wrm.14
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 05:08:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yUM81AcWibXXrILu9PnL4nPQ7aWzJJ4/rrMIE6yN0eA=;
        b=ODyPIRuSZiHp2LMqswIgtALeh4nxALsdAJ0sWNVdMyCywzBJG6zzPba42GgjNul+pS
         0p5A1is2p4HqKXS70WfPgDXUUOki+gecZvW6V4hKTv6cb7Ud7iBXLLZMP0XRtv0vaHbI
         3pQqqLGOc3ZrZfGfTHUW5XAON6TUVOWWmWUVI0LOAtJjvtF4D6jRxLbIbdNUOWurD8qc
         BGpLmoWM7E5fyDFkSOXBBRCd3CabdbmMOzw+p0x/FrgPVDiMEF7fXM+fST5JW77mJjIm
         RxHeUUhRJupzPJ+1QOlprFARVniJcqS/CwTnEus+ZoOEbPrreuM0J18JAdEsrKf8Ibbc
         frbw==
X-Gm-Message-State: AOAM530NqSLf4RzCpkTi5/e3qA+i9cOfIRQPgOInqMJesDure/r1S8nj
        +ZUc2iUVI1r0z+RLSKXHYWy5EE3rggkmaJ1OqkWVe21VSp0vzr6Z8ALo3nd01jJu9nxs5zsg2KV
        Uu7zW7GLINezI
X-Received: by 2002:a1c:e383:: with SMTP id a125mr4959069wmh.11.1594382915491;
        Fri, 10 Jul 2020 05:08:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxOdj3lOQRQAqdOohxOFjumLYLWOtiMbXwLu3ucinw7uGGA/neD+tlggraDTeMElYLqzhTuRQ==
X-Received: by 2002:a1c:e383:: with SMTP id a125mr4959047wmh.11.1594382915183;
        Fri, 10 Jul 2020 05:08:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id v15sm8708872wmh.24.2020.07.10.05.08.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2020 05:08:34 -0700 (PDT)
Subject: Re: [PATCH v3 7/9] KVM: nSVM: implement nested_svm_load_cr3() and use
 it for host->guest switch
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        linux-kernel@vger.kernel.org
References: <20200709145358.1560330-1-vkuznets@redhat.com>
 <20200709145358.1560330-8-vkuznets@redhat.com>
 <4d3f5b01-72d9-c2c5-08e8-c2b1e0046e5e@redhat.com>
 <c7c65e0e-0c8f-106b-6249-ac706e702259@redhat.com>
 <87blknvbre.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <353dc97c-9754-68f9-6fb7-13671995e0a2@redhat.com>
Date:   Fri, 10 Jul 2020 14:08:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <87blknvbre.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/07/20 13:40, Vitaly Kuznetsov wrote:
> Hm, it seems I missed svm_set_nested_state() path
> completely. Surprisingly, state_test didn't fail)
> 
> I'm struggling a bit to understand why we don't have kvm_set_cr3() on
> svm_set_nested_state() path: enter_svm_guest_mode() does it through
> nested_prepare_vmcb_save() but it is skipped in svm_set_nested_state().
> Don't we need it at least for !npt_enabled case?

In svm_set_nested_state you'll have CR3 already set to the right value.
 On the source, KVM_GET_SREGS returns the vmcb12's CR3 and it is already
restored with KVM_SET_SREGS on the destination before set_nested_state.

So, only the nested_cr3 has to be set.

Paolo

> We'll have to extract
> nested_cr3 from nested_vmcb then.

