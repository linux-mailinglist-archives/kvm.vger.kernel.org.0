Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC195258CE5
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 12:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgIAKhK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 06:37:10 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:30111 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726050AbgIAKgr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Sep 2020 06:36:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598956605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AEINv34Fu2CdWohARgHW6X/rv0Y1PeRzDZvhyy6A9Hw=;
        b=HoTrQxvcHi1OEOdzfxI14tpuQCdDOcvLSJ6phrToeRFHXDQMYY/lkX5dZqN9pP/RxGCzv6
        9F8CAsXotDdXSzkRXqS8GUkHZDiWx/tOfsX+Ph3NjLlBVUh/zRUxGzgFwMUJPPzdV55+JX
        sGSc4csbWRHcByRjdDdRfwGnBYgh6vM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-qShp9gKhOAaUA-S2z1glzA-1; Tue, 01 Sep 2020 06:36:44 -0400
X-MC-Unique: qShp9gKhOAaUA-S2z1glzA-1
Received: by mail-wm1-f72.google.com with SMTP id c198so298111wme.5
        for <kvm@vger.kernel.org>; Tue, 01 Sep 2020 03:36:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=AEINv34Fu2CdWohARgHW6X/rv0Y1PeRzDZvhyy6A9Hw=;
        b=F2tE1fc8/AUIKnhfXHV3nzIo42RcN5HnPiC/lF+09eWZvvZFlsKOm7iA77dj5RDLiN
         S0SB67ESExG9ieTPy6+1Atc1Y3ZfWNMRLIeUw17gTza7LcEuxSZPVPbcCiwrXED8bvJO
         kkvZ0lHtJqLOAG9HosvOLu0FMyJ1Ls0LHuOqevpH3Jl9YuAJdOaItRBsMNbtH8KvIsLD
         5GdEmk0aYbiy6WnVjCgFB9Ok6kvmacHy8rTrb2By06xC4ilrXVrincgqAT8E9+zEjfiC
         3mwrsYh5vPGnBELcMknGxu1mc65qLnw7XJvB8lKv1hKSguRDrkOdqX7/GSeK5G/hwdpa
         o84g==
X-Gm-Message-State: AOAM533ios6QtxO3QQtl7CaY/TgJm06PnzZ9SNtZUQtknnHmNxtsptqu
        Zmvwmvm6PodkNfKLNh+EqMH+uQgV9B6dQy/Lzah4LOEyXICseHD17kBae40MNU9OgvDpLXDYDoN
        ELuupcg3IKXCh
X-Received: by 2002:adf:8b1d:: with SMTP id n29mr1078498wra.383.1598956602596;
        Tue, 01 Sep 2020 03:36:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy3p55BcW/B1gRIkaQp0176fOY3DHBYTFK/XSRZMR0fLQx7LPfXuDNXAxisUTOh0txmQK8fNw==
X-Received: by 2002:adf:8b1d:: with SMTP id n29mr1078479wra.383.1598956602379;
        Tue, 01 Sep 2020 03:36:42 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id w1sm1318093wmc.18.2020.09.01.03.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 03:36:41 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: fix crash cleanup when KVM wasn't used
In-Reply-To: <20200825000920.GB15046@sjchrist-ice>
References: <20200401081348.1345307-1-vkuznets@redhat.com> <CALMp9eROXAOg_g=R8JRVfywY7uQXzBtVxKJYXq0dUcob-BfR-g@mail.gmail.com> <20200822034046.GE4769@sjchrist-ice> <CALMp9eRHh9KXO12k4GaoenSJazFnSaN68FTVxOGhE9Mxw-hf2A@mail.gmail.com> <CALMp9eS1HusEZvzLShuuuxQnReKgTtunsKLoy+2GMVJAaTrZ7A@mail.gmail.com> <20200825000920.GB15046@sjchrist-ice>
Date:   Tue, 01 Sep 2020 12:36:40 +0200
Message-ID: <87pn75wzpj.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Mon, Aug 24, 2020 at 03:45:26PM -0700, Jim Mattson wrote:
>> On Mon, Aug 24, 2020 at 11:57 AM Jim Mattson <jmattson@google.com> wrote:
>> >
>> > On Fri, Aug 21, 2020 at 8:40 PM Sean Christopherson
>> > <sean.j.christopherson@intel.com> wrote:
>> > > I agree the code is a mess (kvm_init() and kvm_exit() included), but I'm
>> > > pretty sure hardware_disable_nolock() is guaranteed to be a nop as it's
>> > > impossible for kvm_usage_count to be non-zero if vmx_init() hasn't
>> > > finished.
>> >
>> > Unless I'm missing something, there's no check for a non-zero
>> > kvm_usage_count on this path. There is such a check in
>> > hardware_disable_all_nolock(), but not in hardware_disable_nolock().
>> 
>> However, cpus_hardware_enabled shouldn't have any bits set, so
>> everything's fine. Nothing to see here, after all.
>
> Ugh, I forgot that hardware_disable_all_nolock() does a BUG_ON() instead of
> bailing on !kvm_usage_count.

But we can't hit this BUG_ON(), right? I'm failing to see how
hardware_disable_all_nolock() can be reached with kvm_usage_count==0.

-- 
Vitaly

