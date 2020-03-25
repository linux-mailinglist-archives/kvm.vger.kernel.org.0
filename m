Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A30F192DDD
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 17:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbgCYQLw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 12:11:52 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:39334 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727174AbgCYQLw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Mar 2020 12:11:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585152710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WK74JkL+kdH++Ab+Y2UEWtM7+ELlujDygy01aFZtgRs=;
        b=A4t81eQEbSyC0YiMyDUgRMjZQr+ofjbltiDHsnbPRR/4VcAQ3MVzCL2NyEs9ZR2sEsKHuV
        46S98c62GZReJnwZM2vBdFSOxn5oieseMYdZc29mrpIJUgNVqaFxsRj9Fu8blp7+D9Id3E
        HwCg92gGDzwfLEanuPd7ECVJDKI5mTA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-wU1ghkrQPQCRSMhdtiE7qA-1; Wed, 25 Mar 2020 12:11:47 -0400
X-MC-Unique: wU1ghkrQPQCRSMhdtiE7qA-1
Received: by mail-wr1-f72.google.com with SMTP id d1so1356115wru.15
        for <kvm@vger.kernel.org>; Wed, 25 Mar 2020 09:11:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=WK74JkL+kdH++Ab+Y2UEWtM7+ELlujDygy01aFZtgRs=;
        b=WxRm9goSs8e2pSmG0j/ilpa3h3RPT5SiarkcVhGcytootmMCpQ8OC+sOjTK1gUPG5C
         IJSnIfHhcUDUf0ZZ9PqQ1nKnHQsIPsgTOZsSRO46D9SMvHcZyaGeKlO/f3QvG8dM6y4k
         hpF5djC3U7CLjfWMsPw2N0v6ZEWdd4F47UhiReFEoqVBX3SDsyYE8tmO8cs1eJyL4RGS
         yVm0wMweozW2yB/gsbNiW1xKGBkR5TzUJefXBhVP0LHRzrIr0cINQpgHq6LSJ8QDYjAQ
         XOx+QTfXarcBeuY8u7rEa5zMPIJtFYwxsaKdQVwTndbmMV/aFu8iRDF0iLwlBFIZYJFU
         kPuA==
X-Gm-Message-State: ANhLgQ3AGVdePNxzhiaEL7+xIbHuuUU/UPHHPDQjhXh/bVUBi7WhLDX+
        7bG7CQzoUj95i3FMmj4EjO14P+699KwgeiOauBpWbXs/HEpiYtH1cCXDQHpjqmXybEcSoCRYuVL
        Jfgi275MTnJGv
X-Received: by 2002:a1c:9e85:: with SMTP id h127mr3981641wme.145.1585152706092;
        Wed, 25 Mar 2020 09:11:46 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsYBX3PP2TE3uLGVZ5ua0iVAgFrVapbEo+dHcG+zgdrgx5u4qJ+y4Cikt03oJ6SuGqjHr8Abw==
X-Received: by 2002:a1c:9e85:: with SMTP id h127mr3981619wme.145.1585152705850;
        Wed, 25 Mar 2020 09:11:45 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id u5sm26527192wrq.85.2020.03.25.09.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 09:11:44 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v3 14/37] KVM: x86: Move "flush guest's TLB" logic to separate kvm_x86_ops hook
In-Reply-To: <20200325154810.GE14294@linux.intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com> <20200320212833.3507-15-sean.j.christopherson@intel.com> <87369w7mxe.fsf@vitty.brq.redhat.com> <20200325154810.GE14294@linux.intel.com>
Date:   Wed, 25 Mar 2020 17:11:42 +0100
Message-ID: <87d0905s8x.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Wed, Mar 25, 2020 at 11:23:41AM +0100, Vitaly Kuznetsov wrote:
>> Sean Christopherson <sean.j.christopherson@intel.com> writes:
>> I *think* I've commented on the previous version that we also have
>> hyperv-style PV TLB flush and this will likely need to be switched to
>> tlb_flush_guest().
>
> Oh, you most definitely commented about HyperV's PV TLB flush, looking at
> that code is what led me down this rabbit hole :-)

Ah, I was just worried it's Groundhog Day all over again :-) And I
didn't see you touching hyperv.c 

-- 
Vitaly

