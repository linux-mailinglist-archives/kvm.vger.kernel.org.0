Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7784127431B
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 15:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgIVNcV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 09:32:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52663 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726593AbgIVNcV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 09:32:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600781539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9KOUboBhuauCRUBcQ6dQyRqiY0Af0JRbBDZbe0s5vHo=;
        b=iC8zIniEp5Q4feR2tP3QHezhN5nYKNWace4svKXmeYR2Pl+XmMMcuiHLeWPZ1pBVOEvLBR
        cbc/+D80c3lMKZnGVkf+ZKGJGF7Pch89mPyACAxdopASdoHYbkjhaex98/Yk/p+mQXNOUY
        qeGCT3kqFkc74isJtvr31GyKyz8G2L4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-128-zDjhxwl2OIqSyNEjdUZJww-1; Tue, 22 Sep 2020 09:32:17 -0400
X-MC-Unique: zDjhxwl2OIqSyNEjdUZJww-1
Received: by mail-wm1-f71.google.com with SMTP id w3so921475wmg.4
        for <kvm@vger.kernel.org>; Tue, 22 Sep 2020 06:32:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9KOUboBhuauCRUBcQ6dQyRqiY0Af0JRbBDZbe0s5vHo=;
        b=pq7xLWNx7Ihl3InbCAeWTXlfOa72pK7IAHu+vw/6QfPVE8qVrFBHkytCdc0ZHIIAa7
         eOAold1quMeVy3Sjbp5jGU2LVwrGLGhLaOvNIoksQm5Ql/ceG17fYlKCls9gDIv66ZuA
         u5E1rrgr0fu8SrMWKZj2A0QxYj/7/HXz9M0T9yrrKc9QKpSSqF8FNhLHfStspGqQdVfB
         hRZYyx5sBguPvbehbGXEzvULKN5qO6GlEcRtzaV0pikj2X+dsJR5s0C7ztL2gFq4gUbP
         eaQB/ZvsfEWaQkAFu76rrtZd9q3KBA+19WRCjS6lBYYScG849Dn4MyqpARIeFrNI88/E
         Ouyg==
X-Gm-Message-State: AOAM5312W2srqBPQgkhy82cDENBjVUYCOygx0WAc4yJqixy3u54nNkKB
        cVwkfdPh+HK2MSWdAZ9qBg/sTqV7vRh/ogEFDoIPCs1Ow5ltriLwe52f+/kGgyyXEVQGw0yzPOE
        AImehmu6aIGS1
X-Received: by 2002:adf:ec92:: with SMTP id z18mr5763124wrn.53.1600781535755;
        Tue, 22 Sep 2020 06:32:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzxS6S+odf+HnI1PTGOP+NH8DPAXdJWGHQkG7uXGUMcWXEDVQMGMKrusLYnD3TH4JbKLX4KtA==
X-Received: by 2002:adf:ec92:: with SMTP id z18mr5763105wrn.53.1600781535530;
        Tue, 22 Sep 2020 06:32:15 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec2c:90a9:1236:ebc6? ([2001:b07:6468:f312:ec2c:90a9:1236:ebc6])
        by smtp.gmail.com with ESMTPSA id a15sm28371867wrn.3.2020.09.22.06.32.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 06:32:14 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: Add kvm_x86_ops hook to short circuit emulation
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20200915232702.15945-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0fe8dc75-4aa3-cd84-5fff-1d2f23c01c6a@redhat.com>
Date:   Tue, 22 Sep 2020 15:32:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200915232702.15945-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/09/20 01:27, Sean Christopherson wrote:
> Replace the existing kvm_x86_ops.need_emulation_on_page_fault() with a
> more generic is_emulatable(), and unconditionally call the new function
> in x86_emulate_instruction().
> 
> KVM will use the generic hook to support multiple security related
> technologies that prevent emulation in one way or another.  Similar to
> the existing AMD #NPF case where emulation of the current instruction is
> not possible due to lack of information, AMD's SEV-ES and Intel's SGX
> and TDX will introduce scenarios where emulation is impossible due to
> the guest's register state being inaccessible.  And again similar to the
> existing #NPF case, emulation can be initiated by kvm_mmu_page_fault(),
> i.e. outside of the control of vendor-specific code.
> 
> While the cause and architecturally visible behavior of the various
> cases are different, e.g. SGX will inject a #UD, AMD #NPF is a clean
> resume or complete shutdown, and SEV-ES and TDX "return" an error, the
> impact on the common emulation code is identical: KVM must stop
> emulation immediately and resume the guest.
> 
> Query is_emulatable() in handle_ud() as well so that the
> force_emulation_prefix code doesn't incorrectly modify RIP before
> calling emulate_instruction() in the absurdly unlikely scenario that
> KVM encounters forced emulation in conjunction with "do not emulate".

Ahah, I love those adverb + adjective pairs (my favorite is
https://patchwork.kernel.org/cover/10710751/ which unfortunately was in
the cover letter and thus was not immortalized in linux.git).

"is_emulatable" is not very grammatical, so I'd rather call it
"can_emulate_instruction" instead.  Either way, it's an improvement over
"need".  Queued, thanks.

Paolo

