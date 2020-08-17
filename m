Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F109D24737B
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 20:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731755AbgHQS4v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 14:56:51 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35556 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731503AbgHQS42 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Aug 2020 14:56:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597690585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P+SWVW+pjg81S9WWqotQ3smvkOJqzR+CExLaQMZK0Pw=;
        b=CgyWaklZe6AsBRIFWF/a9yoBbRsG6/1Bpj3dShckOTgWs+/SBRkLuOP2cxzNeRrq4KwHio
        i3U+ayLUSAwP5lhLP3LJOf6mnCbzlJN9bSmeSP+Bcp2NcJCnK1f53N4hVxgelb1UFWq9HJ
        Q2Zkt8WYltes/XUGNJL7ur+/u/MwJ/k=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-ctqtSjf9MOqR0IcZ8Y2faw-1; Mon, 17 Aug 2020 14:56:24 -0400
X-MC-Unique: ctqtSjf9MOqR0IcZ8Y2faw-1
Received: by mail-wm1-f70.google.com with SMTP id u144so6347203wmu.3
        for <kvm@vger.kernel.org>; Mon, 17 Aug 2020 11:56:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P+SWVW+pjg81S9WWqotQ3smvkOJqzR+CExLaQMZK0Pw=;
        b=Y39AiB/A/WfmadINqM+HsvzfNTgQO2RK5Wk2ali4+9phfiylPJ7IIR0ddubI16Lkpm
         NI1YCXB+f+wXhUTk0i0UdNM7hd5EGXrZZUJc1RSPhdkr5z4caY29SNN9SnUBAdsPyMiW
         hBvJr1NNmSvmBgJPagyvIjYHy8NJLeM2AM6wUMGS8ptCeCaQdyqKycE27fqM2BJRW5Lo
         O25/4phxvnXTcC4WkckDBfA2kTseNNIVaqPouvGceRFKgu25yOvwzPG9WkhRiBJmsM9E
         Qb1oOVSywDJLbwgOI79cc42YGQQYwl01FUqF7Xs6+/e+YUG8bzyqi5WsyS9JFnp9AP9I
         WqGQ==
X-Gm-Message-State: AOAM530SOfy/OaTZCS4N44p3oz8MjRRD+r76JLEcejIpjla7QFW5993o
        zMI5tKvWOBVjM+6jD2vra43fI37xBmYQl+zXFCadGEjRw+mbToW00zG34035yjsPOpOQLYbBR+l
        2K2XWwv0lCYW/
X-Received: by 2002:adf:c64d:: with SMTP id u13mr17359824wrg.114.1597690582796;
        Mon, 17 Aug 2020 11:56:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxGUy0KGjJ9kvMSrkyDxzgiWSlEfsMpPG6GXCMoIUDIQxE8HoMxA0+bqfacNF2voEz97rN3kA==
X-Received: by 2002:adf:c64d:: with SMTP id u13mr17359814wrg.114.1597690582593;
        Mon, 17 Aug 2020 11:56:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:a0d1:fc42:c610:f977? ([2001:b07:6468:f312:a0d1:fc42:c610:f977])
        by smtp.gmail.com with ESMTPSA id d21sm31344948wmd.41.2020.08.17.11.56.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 11:56:21 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: fix access code passed to gva_to_gpa
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20200817180042.32264-1-pbonzini@redhat.com>
 <20200817184226.GJ22407@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2f1dd99d-f19d-fec2-bbe1-53b8861bfe9e@redhat.com>
Date:   Mon, 17 Aug 2020 20:56:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200817184226.GJ22407@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/08/20 20:42, Sean Christopherson wrote:
> 
> Don't suppose you'd be in the mood to kill the bare 'unsigned'?
> 
>   WARNING: Prefer 'unsigned int' to bare use of 'unsigned'

u32 is even better.

> Alternatively, what about capturing the result in a new variable (instead of
> defining the mask) to make the wrap suck less (or just overflow like the
> current code), e.g.:
> 
>         u32 access = error_code &
>                      (PFERR_WRITE_MASK | PFERR_FETCH_MASK | PFERR_USER_MASK);
> 
>         if (!(error_code & PFERR_PRESENT_MASK) ||
>             vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, access, &fault) != UNMAPPED_GVA) {

Sure, that's better.

Paolo

