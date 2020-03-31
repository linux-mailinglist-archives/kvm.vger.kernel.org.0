Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 435F8199375
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 12:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730341AbgCaKdc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 06:33:32 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26840 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729925AbgCaKdc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 06:33:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585650810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MJdyJmHlbCZZThjXBqpe8IJpm68daaGiHI8h/gWVt6A=;
        b=P9M1LRwVcOL4W+2DU7Hu/IYm0S7TwWq+TwjOLeBO+HRpko7pMgNyiRWYmv2L8NHZR+GL9/
        LoJqd8prm3TI6+ozsY19hymAUtoYoSYROIxta0IuJgd9cYAYjkraPRl8UIwCF8EDzZ0Cj4
        XdHDaPs091UqhBCN75FlXzHQsUpdXaA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-1m0Jrt5QMheYL5DhiX2KGA-1; Tue, 31 Mar 2020 06:33:29 -0400
X-MC-Unique: 1m0Jrt5QMheYL5DhiX2KGA-1
Received: by mail-wr1-f72.google.com with SMTP id e10so12863905wrm.2
        for <kvm@vger.kernel.org>; Tue, 31 Mar 2020 03:33:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=MJdyJmHlbCZZThjXBqpe8IJpm68daaGiHI8h/gWVt6A=;
        b=R9k2cpNRxc5JRKjFBe7mkAypR64pbYe+WM8hwFsGkEvZkqVlEBV6auBwScniDvZK1+
         m8s20lQkQvrYIoJjLMCOUlS3qHhWVKwIWFTp9hxjRCg25Ock2nVaOPSE7DnF5ZVT8FF7
         pivQUKy2PIlqbEY0v+dCRJE23esZglHptiBepwG2L8XqBk2VkJuzDtYca2bH39oCDOLK
         pyNKPrf02LaieLv1PyA250vVUxTVY456Y/g+W+CJPTHUSxIO6TeyLlKe8+V4KZ0U32zn
         5zUnu1bH1zQibMR6KiuAO+65GXYt5Rpr8MmYNSyabfzl8LVBjFmlTo+g4T7HFHU5x4gA
         dNoQ==
X-Gm-Message-State: ANhLgQ2u5arapTjIQkpMgkU2tT20ZmDAaZHNWOjn597/YKaDH+wwn7IG
        oSBOMsnwUt2+INzyQ5PsYWnycApK3u4UMecNB5MmR0U2PAwmPtiBpwhD0Al0Ay2x9hwqN6jT5kS
        ds8iYZwGW+Sjj
X-Received: by 2002:a5d:464a:: with SMTP id j10mr19529900wrs.3.1585650807776;
        Tue, 31 Mar 2020 03:33:27 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuGDenkotV0E4MljO6odBu9a/SuA+iY8rESIFQiotSoUzHd7WaDBOTrgjAOfKcqt355r2SW4g==
X-Received: by 2002:a5d:464a:: with SMTP id j10mr19529882wrs.3.1585650807537;
        Tue, 31 Mar 2020 03:33:27 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id z1sm14381769wrp.90.2020.03.31.03.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 03:33:26 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH 1/3] KVM: x86: introduce kvm_mmu_invalidate_gva
In-Reply-To: <20200330184726.GJ24988@linux.intel.com>
References: <20200326093516.24215-1-pbonzini@redhat.com> <20200326093516.24215-2-pbonzini@redhat.com> <20200328182631.GQ8104@linux.intel.com> <2a1f9477-c289-592e-25ff-f22a37044457@redhat.com> <20200330184726.GJ24988@linux.intel.com>
Date:   Tue, 31 Mar 2020 12:33:25 +0200
Message-ID: <87v9mk24qy.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Mon, Mar 30, 2020 at 12:45:34PM +0200, Paolo Bonzini wrote:
>> On 28/03/20 19:26, Sean Christopherson wrote:
>> >> +	if (mmu != &vcpu->arch.guest_mmu) {
>> > Doesn't need to be addressed here, but this is not the first time in this
>> > series (the large TLB flushing series) that I've struggled to parse
>> > "guest_mmu".  Would it make sense to rename it something like nested_tdp_mmu
>> > or l2_tdp_mmu?
>> > 
>> > A bit ugly, but it'd be nice to avoid the mental challenge of remembering
>> > that guest_mmu is in play if and only if nested TDP is enabled.
>> 
>> No, it's not ugly at all.  My vote would be for shadow_tdp_mmu.
>
> Works for me.  My vote is for anything other than guest_mmu :-)
>

Oh come on guys, nobody protested when I called it this way :-)

Peronally, I don't quite like 'shadow_tdp_mmu' because it doesn't have
any particular reference to the fact that it is a nested/L2 related
thing (maybe it's just a shadow MMU?) Also, we already have a thing
called 'nested_mmu'... Maybe let's be bold and rename all three things,
like

root_mmu -> l1_mmu
guest_mmu -> l1_nested_mmu
nested_mmu -> l2_mmu (l2_walk_mmu)

or something like that?

-- 
Vitaly

