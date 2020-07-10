Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0680621B42E
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 13:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgGJLkp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 07:40:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23447 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726757AbgGJLko (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 07:40:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594381242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VHkgHsP2LMXiJzMuU12W+yp4KrE8aOeFbQ7+oDie8jo=;
        b=bN7cFop6vK2Uokdc33+xClDEDX6y37vbnqFJaBqz1GZ7wUCtaQysfdDMHLPHOB1wVz6Luc
        QHE3G0G1z3hQ1E9KWqi2UMrv5htVALfmz9ZDbINuZBr2QDbbg8hesShw/cgIwsuamR9yWY
        vN8U3hvuFf8+DF+5sLjKk6aDeZrKBws=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-7roEM9ujN621F5hsmDgUag-1; Fri, 10 Jul 2020 07:40:41 -0400
X-MC-Unique: 7roEM9ujN621F5hsmDgUag-1
Received: by mail-wm1-f71.google.com with SMTP id v11so6530959wmb.1
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 04:40:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=VHkgHsP2LMXiJzMuU12W+yp4KrE8aOeFbQ7+oDie8jo=;
        b=q3heYDy2G7e4iOVAKzhJVUd51wgafRnHfsnlSxSbuQ8hTk5GUBj0YI6jjGwf7yCpxi
         mAAN7D9V60gg+MIemT0HOtYpu6r5es7GoxmPsfRzMyupmkIyzmu86nMU8P8ZWsQLf8DU
         YMCCaXGxaVosINNBJlH/ey529rHeiDoB48lNvyxSiaiKe0DuVBruBCrd8tImW5FVcLKS
         Ig18vcLiSeHxrw+B7u17vxXuHOR3CKCFVyAHsntNPzGkRREpkqU08tKT1iNkDJ/0vGtz
         o5Ms3ySFkIUosh85t09FNS7zk4VBcYls8MhjW7Pujn0Y7wwQJOjMpsTejbZx4YiPY8LB
         Lzrg==
X-Gm-Message-State: AOAM533c9dvlmDfJHSO2oizBOImTduFtJ7SKDf5xgA8HnXQmc7Am3jED
        OLKII+4wZsu2MVt9rAd2z58uZuenBoLiHbrOsSEbVeMwnsBVNHyzfQIFJGgQjdhAIIVd7oCWP8T
        h7ConqqdW/Oak
X-Received: by 2002:a1c:4846:: with SMTP id v67mr5008220wma.175.1594381239904;
        Fri, 10 Jul 2020 04:40:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzexHDpMo1ULLtIMbhLiWf3L2m1aZ1l+TwAjQ9GHUa2QztMKPPmHnEuaReNPKxs3BoWz2+j/w==
X-Received: by 2002:a1c:4846:: with SMTP id v67mr5008197wma.175.1594381239727;
        Fri, 10 Jul 2020 04:40:39 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id t2sm9040491wma.43.2020.07.10.04.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 04:40:39 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/9] KVM: nSVM: implement nested_svm_load_cr3() and use it for host->guest switch
In-Reply-To: <c7c65e0e-0c8f-106b-6249-ac706e702259@redhat.com>
References: <20200709145358.1560330-1-vkuznets@redhat.com> <20200709145358.1560330-8-vkuznets@redhat.com> <4d3f5b01-72d9-c2c5-08e8-c2b1e0046e5e@redhat.com> <c7c65e0e-0c8f-106b-6249-ac706e702259@redhat.com>
Date:   Fri, 10 Jul 2020 13:40:37 +0200
Message-ID: <87blknvbre.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 09/07/20 19:57, Paolo Bonzini wrote:
>> On 09/07/20 16:53, Vitaly Kuznetsov wrote:
>>> +	if (nested_npt_enabled(svm))
>>> +		nested_svm_init_mmu_context(&svm->vcpu);
>>> +
>>>  	ret = nested_svm_load_cr3(&svm->vcpu, nested_vmcb->save.cr3,
>>>  				  nested_npt_enabled(svm));
>> 
>> This needs to be done in svm_set_nested_state, so my suggestion is that
>> the previous patch includes a call to nested_svm_load_cr3 in
>> svm_set_nested_state, and this one adds the "if" inside
>> nested_svm_load_cr3 itself.
>
> Actually no, that doesn't work after the next patch.  So the best option
> is probably to extract nested_svm_init_mmu as a separate step in
> enter_svm_guest_mode.  This also leaves nested_prepare_vmcb_save as a
> void function.
>

Hm, it seems I missed svm_set_nested_state() path
completely. Surprisingly, state_test didn't fail)

I'm struggling a bit to understand why we don't have kvm_set_cr3() on
svm_set_nested_state() path: enter_svm_guest_mode() does it through
nested_prepare_vmcb_save() but it is skipped in svm_set_nested_state().
Don't we need it at least for !npt_enabled case? We'll have to extract
nested_cr3 from nested_vmcb then.

-- 
Vitaly

