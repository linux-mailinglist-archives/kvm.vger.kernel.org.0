Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 363883583D8
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 14:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbhDHMwq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 08:52:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45210 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231801AbhDHMwc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Apr 2021 08:52:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617886341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4S1xhqNTpv3IJ0yxypseMcfA4gi2Db1hR2vDlBKzCkU=;
        b=A2VOyqkG7ycRDwOOA+/UauXuwzsJljvB3POHODVnH4QL/wXyIQAWDDCPgpTyzEFfQAvZGS
        QJMaK7i6wyYFkn4PtbxFTErKol3GEOMBAhVYGUAWT12piHyvGcu2BRHuZOe9+qlNknmgSF
        3WkyoykbxFKlKV9fzG6NDV2Dsac7F7o=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-BYJlc5nRNtKnYxJrl0WAHA-1; Thu, 08 Apr 2021 08:52:19 -0400
X-MC-Unique: BYJlc5nRNtKnYxJrl0WAHA-1
Received: by mail-ed1-f71.google.com with SMTP id j18so979667edv.6
        for <kvm@vger.kernel.org>; Thu, 08 Apr 2021 05:52:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=4S1xhqNTpv3IJ0yxypseMcfA4gi2Db1hR2vDlBKzCkU=;
        b=YjS6JJzVnHuFuaKOVVgJwHtt3ejudZi+nco+3dANNbfTHiDNggTcLGvEJEmHWHBWrl
         nxAPptBk8HdfgGdXUV3l7nYfV348RNTwPwi8tAUQ9WXJEx8TdMTiBy7yI6hb7oB3/Chu
         Qp3islCR7qPDeezJIu4VMAkrMZhXjq8Elx1XI62wqAgduYUFjypFfz6tMQhmydmcaX/n
         w0TkmX2j9zD92I9vD9Y+DoDV//JbcOqlAgttfJDaptkOl9LpErSn4uJDepj/nCeR7aiY
         Upp+SMuyX1pl9G+wx9torPg2g/Bx6JGtWeoLKQZVrwQ04GnRAIUDuBa3hfJJA71l1K+F
         iDLA==
X-Gm-Message-State: AOAM530WFEnBQVlRdDzFEMAQ7Jb5Pswht6iROMlAAFVQQxQmZaxMRQ5/
        WYM0lmlM2CGM4AXgV+N5eFEC2go4LQ6h3ax1+FYAWcyHTcisyYFzjOz+RZ4s9sUplQHAv4/6+vN
        WNkGeXpqvvkFe
X-Received: by 2002:a50:9fa1:: with SMTP id c30mr2365353edf.66.1617886338690;
        Thu, 08 Apr 2021 05:52:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyxbF93yjemzoR4e6xZdoBnB/y33lLc3fLY1c5uNkCMBQilxA+808u9E8cSRoq+VR5heR8REg==
X-Received: by 2002:a50:9fa1:: with SMTP id c30mr2365326edf.66.1617886338487;
        Thu, 08 Apr 2021 05:52:18 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id a12sm10363569ejy.87.2021.04.08.05.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 05:52:18 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>
Cc:     Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 3/4] KVM: x86: kvm_hv_flush_tlb use inputs from XMM
 registers
In-Reply-To: <01fc0ac9-f159-d3df-6c8c-8f8122fe31ea@redhat.com>
References: <20210407211954.32755-1-sidcha@amazon.de>
 <20210407211954.32755-4-sidcha@amazon.de>
 <87eefl7zp4.fsf@vitty.brq.redhat.com>
 <01fc0ac9-f159-d3df-6c8c-8f8122fe31ea@redhat.com>
Date:   Thu, 08 Apr 2021 14:52:16 +0200
Message-ID: <878s5t7xbz.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 08/04/21 14:01, Vitaly Kuznetsov wrote:
>> 
>> Also, we can probably defer kvm_hv_hypercall_read_xmm() until we know
>> how many regs we actually need to not read them all (we will always
>> need xmm[0] I guess so we can as well read it here).
>
> The cost is get/put FPU, so I think there's not much to gain from that.
>

Maybe, I just think that in most cases we will only need xmm0. To make
the optimization work we can probably do kvm_get_fpu() once we figured
out that we're dealing with XMM hypercall and do kvm_put_fpu() when
we're done processing hypercall parameters. This way we don't need to do
get/put twice. We can certainly leave this idea to the (possible) future
optimizations.

-- 
Vitaly

