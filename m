Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070DF27F10C
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 20:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbgI3SJA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 14:09:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22013 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbgI3SI7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Sep 2020 14:08:59 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601489338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bwVgHNsMicX6xX4N2svSFj0C/kV9MVkeyeZ49ASRmfs=;
        b=GpYJcp3u4rsVbe7aMfD8u1z4pO+WNPJa90BmjH0jXOG9v5kol0W9eVt0bhYQtMIKHdd7m0
        lq6ni9rLeHxis7Ehv5VEfbWpA7S+xJDxpMp/LDf9aRcqlw5rYx6KxbGS/czXz3Qa9lm012
        VoHcLwHCjJbFEKHMCAfk5HCADHyCIrA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-iuGKB6dNNpGPjKLDUbgW2A-1; Wed, 30 Sep 2020 14:08:56 -0400
X-MC-Unique: iuGKB6dNNpGPjKLDUbgW2A-1
Received: by mail-wm1-f70.google.com with SMTP id x6so139498wmi.1
        for <kvm@vger.kernel.org>; Wed, 30 Sep 2020 11:08:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bwVgHNsMicX6xX4N2svSFj0C/kV9MVkeyeZ49ASRmfs=;
        b=OhA6WCPuTJbJFj2ZwPnHo2VLo6CWZ/Bq+gFFJeGCinF/gdC8A9SENHZbyB3vw9cOMg
         1sIVA0dz+soi1zljrEWmXVo3qvs3HkQta/WQamSh7U1L1pG27KS5ixMVT4CGHcQrBPj5
         cADD78LEN7H/qXEdEiAnHeHSJv0myyDymihHbaaekV5bHauIZ9062L2FJVhfwXqQmh8F
         7sNX1GVnmh5ZrmICDk3xdrQnSM3MvgIzDax47QS2rJlSyz1L3vRQ/cnumCg9q7Qrk/ku
         hx7lZHU5MZxkA+6010m/hcxWyNiKmVWlp/V5AbTqPXQQ/NrVnUBFIFO3BRJLiL8htWHN
         GpwA==
X-Gm-Message-State: AOAM530IlP6Rkrk+GMuEA32AyEig/rWeJ2QTOVUxBNtf7mgipIT2HPzT
        dM1oUOf8chD3KqJv16f7hlmt+ikg+tUT7mcKt+S5+Dt34kT8bhAJtdN8qpw5P6kW1YZ98hfmcaw
        mDBAsn47a2Qd5
X-Received: by 2002:a1c:4e08:: with SMTP id g8mr4270300wmh.53.1601489335628;
        Wed, 30 Sep 2020 11:08:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwWKG5rLY3U++IuIbw2Titxqz2g0w5Mzxk9AjMYWUD881FXfHgUI1n2X0h2mDVzIUr5SDpUvw==
X-Received: by 2002:a1c:4e08:: with SMTP id g8mr4270275wmh.53.1601489335412;
        Wed, 30 Sep 2020 11:08:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:75e3:aaa7:77d6:f4e4? ([2001:b07:6468:f312:75e3:aaa7:77d6:f4e4])
        by smtp.gmail.com with ESMTPSA id u66sm4113015wme.12.2020.09.30.11.08.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 11:08:54 -0700 (PDT)
Subject: Re: [PATCH 17/22] kvm: mmu: Support dirty logging for the TDP MMU
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-18-bgardon@google.com>
 <20200930180438.GH32672@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <48c927aa-5902-138a-eb93-891325976edd@redhat.com>
Date:   Wed, 30 Sep 2020 20:08:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200930180438.GH32672@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/09/20 20:04, Sean Christopherson wrote:
>> +	for_each_tdp_mmu_root(kvm, root) {
>> +		root_as_id = kvm_mmu_page_as_id(root);
>> +		if (root_as_id != slot->as_id)
>> +			continue;
> This pattern pops up quite a few times, probably worth adding
> 
> #define for_each_tdp_mmu_root_using_memslot(...)	\
> 	for_each_tdp_mmu_root(...)			\
> 		if (kvm_mmu_page_as_id(root) != slot->as_id) {
> 		} else
> 

It's not really relevant that it's a memslot, but

	for_each_tdp_mmu_root_using_as_id

makes sense too.

Paolo

