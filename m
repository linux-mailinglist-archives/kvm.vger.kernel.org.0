Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEE4190BFC
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 12:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbgCXLH5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 07:07:57 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:22759 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727217AbgCXLH5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 07:07:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585048075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zG8RK9BOQ+DeO4IAkLRYrCB5fJrkacKNwyoRhJalGZg=;
        b=JB3tNJVlDSdYjf40mpAFJdnoOQHJ8tJhz2ySTPc8q9B/ZC11uwxh85T1vrRdjn89/aCyMK
        ETlI588xVaQlH0dvdMPzwyAVZxxiYji7RCyRDZgHp+0qutaoBd3estPi9I797r+sH0WZjf
        kgc3O4VNofa4Nzs2unuE/YEufTmE7/s=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-zjYdlJGnNbuhjZUoitDiPA-1; Tue, 24 Mar 2020 07:07:53 -0400
X-MC-Unique: zjYdlJGnNbuhjZUoitDiPA-1
Received: by mail-wm1-f70.google.com with SMTP id f9so1131776wme.7
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 04:07:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zG8RK9BOQ+DeO4IAkLRYrCB5fJrkacKNwyoRhJalGZg=;
        b=tEm1H15KAzgB1Wkez7NYdddoaa5h0guU7u+n59B5d0QX9Rcvy9yAILbQTmsueIlo1k
         x+giOOu+lTw8S4kbQI/ycw44RegW6ccAzDuzG6OADBSFJVUtUXxW7d8zH6zqxLhGCJgW
         pgnz6xcKLiaFyDJaoC2w7mN7TEgnnRtja3VD+JGUErUfQgoFzulhAH6Mepi8fHi917sC
         WQKqboaqGKwZc+oOHzRjGUS9iViIp82rS3ea8HMEd55+apaTp1z+9nu8gZd+sC3tIQN7
         Enj0+RY/7c2t8w7ZPNDMcp6NwFwPchlQLPFjdaThQv6q63GJ5izyLZmVT10UdsQ0Ke56
         nm6g==
X-Gm-Message-State: ANhLgQ0CJqe03YxcAQqfLEEYZlvjWHJ7xB88V4mefb4GeudikWEjQ7hn
        tgcdB754k7SfEJSkW4toDzhgm51bTMmSjgWWz34GdpheRfVmV9ZvqzTcqRg8mntq5nUVfuT9BaB
        5yZvBl5BV8F7X
X-Received: by 2002:a5d:4fcf:: with SMTP id h15mr29634744wrw.262.1585048072740;
        Tue, 24 Mar 2020 04:07:52 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vu/UT8MN6YxcWR3YXGd/k11KtMYJrljPCwBesOx54uQRTbpk4R6hZP/ktXslgwbAdbPtItyQg==
X-Received: by 2002:a5d:4fcf:: with SMTP id h15mr29634705wrw.262.1585048072432;
        Tue, 24 Mar 2020 04:07:52 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7848:99b4:482a:e888? ([2001:b07:6468:f312:7848:99b4:482a:e888])
        by smtp.gmail.com with ESMTPSA id u5sm21502309wrp.81.2020.03.24.04.07.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2020 04:07:51 -0700 (PDT)
Subject: Re: [PATCH v3 31/37] KVM: x86/mmu: Add separate override for MMU sync
 during fast CR3 switch
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
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
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
 <20200320212833.3507-32-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1227ad9e-0b91-f9a7-10b0-b02203ba52ca@redhat.com>
Date:   Tue, 24 Mar 2020 12:07:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200320212833.3507-32-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/03/20 22:28, Sean Christopherson wrote:
> Add a separate "skip" override for MMU sync, a future change to avoid
> TLB flushes on nested VMX transitions may need to sync the MMU even if
> the TLB flush is unnecessary.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

I added a WARN_ON(skip_tlb_flush && !skip_mmu_sync); which could help
catching misordered parameters.

Paolo

