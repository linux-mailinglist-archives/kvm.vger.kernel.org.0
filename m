Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4CE8431184
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 09:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbhJRHo2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 03:44:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36803 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230328AbhJRHo1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 03:44:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634542936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PkKZR0ydWpQcV2cI2b2paL4JcmSe2Tsq+vsPxwTuJW4=;
        b=iu5rp/sTIH5wQFnYYyicWmoWBv29Qyi7+5VDK0t15Pwvdy5GI/DSn5XwimF7D7a2Nm+HXF
        L6I+znWzCtHTj/0UrLswgUtGAfSFH5pP2+GVPscLhoWFt3AGrdDKCz607wy6156g0vn7tJ
        AATg6e4fUktkNjoArLe73Z/r/6tbO5c=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-xUyTD9hPMJ2u9O4in59xBg-1; Mon, 18 Oct 2021 03:42:15 -0400
X-MC-Unique: xUyTD9hPMJ2u9O4in59xBg-1
Received: by mail-wm1-f72.google.com with SMTP id o137-20020a1ca58f000000b0030d89b84726so1852289wme.1
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 00:42:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=PkKZR0ydWpQcV2cI2b2paL4JcmSe2Tsq+vsPxwTuJW4=;
        b=ctvyluvneEKHE/eW571eQBWGGv25OV++ISElDRBCwBuxfKTlLXo1uIDoNolxc4ScjX
         02mk+HHyljv2WED7tMix0ExAdufAPFPZGTUspHbD/Uyd8prvGGkBfKKppfegvFEVYlkF
         zsY2xiYOGcNstqq7UcsgHxspdIGU2qGOe9GxU+gZZhdiT7fPweEb9D6StVeQ8FVd/uUZ
         Dyl2r/N/hdkOOQkR1TVXdt6VGWIYD3ZGhcBOFcyLJhSn4qPSLnvew0gyEBS9m/+he/zD
         Bz5cE1bE+TxqmCyJaHoUrSj/8doANtWPEgWFyYr9Ev6WyPRIappx0lPG+AB8M3+SoUA1
         5f/g==
X-Gm-Message-State: AOAM533M58a3iW2332P0xvP/bqhTNLDr1NQ4XjGLJue+sim61ckU+x/d
        MNXEO077Gng876Y14dfV1IGkQEvD7cg4bg/jmsd3IXx7wTG0/qs0C2cRPlzFbnxGm4F1tCT4Gr1
        oBZSe8Upu4L8Z
X-Received: by 2002:adf:8919:: with SMTP id s25mr34633377wrs.185.1634542934030;
        Mon, 18 Oct 2021 00:42:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyuY2oK9YuFg+e4sq5jURUHpJRG0fumvJ1oDp86UxpmKWeEHZ3cXuEXwjo5HOMeI92dMlrxmA==
X-Received: by 2002:adf:8919:: with SMTP id s25mr34633353wrs.185.1634542933873;
        Mon, 18 Oct 2021 00:42:13 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id z6sm12065728wro.25.2021.10.18.00.42.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 00:42:13 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Matlack <dmatlack@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] KVM: SVM: reduce guest MAXPHYADDR by one in case
 C-bit is a physical bit
In-Reply-To: <eaddf15f13aa688c03d53831c2309a60957bb7f4.camel@redhat.com>
References: <20211015150524.2030966-1-vkuznets@redhat.com>
 <YWmdLPsa6qccxtEa@google.com>
 <eaddf15f13aa688c03d53831c2309a60957bb7f4.camel@redhat.com>
Date:   Mon, 18 Oct 2021 09:42:12 +0200
Message-ID: <87bl3mye23.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> On Fri, 2021-10-15 at 15:24 +0000, Sean Christopherson wrote:
>> On Fri, Oct 15, 2021, Vitaly Kuznetsov wrote:
>> > Several selftests (memslot_modification_stress_test, kvm_page_table_test,
>> > dirty_log_perf_test,.. ) which rely on vm_get_max_gfn() started to fail
>> > since commit ef4c9f4f65462 ("KVM: selftests: Fix 32-bit truncation of
>> > vm_get_max_gfn()") on AMD EPYC 7401P:
>> > 
>> >  ./tools/testing/selftests/kvm/demand_paging_test
>> >  Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
>> >  guest physical test memory offset: 0xffffbffff000
>> 
>> This look a lot like the signature I remember from the original bug[1].  I assume
>> you're hitting the magic HyperTransport region[2].  I thought that was fixed, but
>> the hack-a-fix for selftests never got applied[3].
>
> Hi Vitaly and everyone!
>
> You are the 3rd person to suffer from this issue :-( Sean Christopherson was first, I was second.
>
> I reported this, then I think we found out that it is not the HyperTransport region after all,
> and I think that the whole thing lost in 'trying to get answers from AMD'.
>
> https://lore.kernel.org/lkml/ac72b77c-f633-923b-8019-69347db706be@redhat.com/
>
>
> I'll say, a hack to reduce it by 1 bit is still better that failing tests,
> at least until AMD explains to us, about what is going on.
>
> Sorry that you had to debug this.

I didn't spend too much time on this, that's the reson for 'RFC' :-) I
agree we need at least a short-term solution as permanently failing
tests may start masking newly introduces issues.

-- 
Vitaly

