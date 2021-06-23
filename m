Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 913D53B1ED9
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 18:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbhFWQnl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 12:43:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43293 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229523AbhFWQnk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 12:43:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624466482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ynli02bru2/iFuBR+RJeS0ZwL27DEp0PRrtJUjqVDDQ=;
        b=XMPTKliHfBZvUtyq+0/eG7NnC9QHpFL84UuQfOWExIi2nFlhsoLpokniBIbrroPgMPxEDc
        /DNGUkZrQEquX7+VKpSfmPm9xwAzuiiwM+hVwK7P8jukjBGvqEapZUwnGqVrryWU+wTV6G
        QrtcXxfjAFXpRcwqnhWG+x/hl1CaAV4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-R5wAtjYEOu6k-YxXs6jVbg-1; Wed, 23 Jun 2021 12:41:20 -0400
X-MC-Unique: R5wAtjYEOu6k-YxXs6jVbg-1
Received: by mail-ed1-f71.google.com with SMTP id m4-20020a0564024304b0290394d27742e4so1638222edc.10
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 09:41:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ynli02bru2/iFuBR+RJeS0ZwL27DEp0PRrtJUjqVDDQ=;
        b=VLzNKTRZz+xM5LWq+93o2zz1MvWv9LW6nfRHU1aIEPE/eoyagoj/xpIJtYT9N8Js1S
         AruZhgU8QJMA1BnTDTMhQWeO3P2Bjtylc/5z7qkH9WnOCiqlE2ivwwq3EbWL5sJY7ooA
         Ao/TYLBGRoy16g9WWkqzFoN6YUOjQvyhsn6mOqDb/EHPdxu8G+HkO4VOcEQodG4ojklJ
         YVuB1jV0olu2T4JFAkLb8Ervl11vVIAqw8sDtKwNlZ1EvnnZ4iTnl0SIDzpID4usdyVn
         VhriXt8sLRRQu88l1ETQYVTJaE8COt/jU/K49u3m1rfJ5IJiU7NfhWZ9/t0Q7ILGEqTl
         E7Rg==
X-Gm-Message-State: AOAM531yqpiiJwtO443EhQsEZKIhJiQHBfJbYqtAHTYHkUGvbcfSJ00E
        HOesJ+5xl0q/trbvz+XgbjsHhECzqUinS9066ugv37jlq1NKTRBIh3MOJIUbKYJlOKWBBEKhMql
        N4P9wSx90/k97
X-Received: by 2002:a05:6402:40c4:: with SMTP id z4mr899713edb.364.1624466479822;
        Wed, 23 Jun 2021 09:41:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxGYf2bIPtd6IssXH+uNOdj4qa4yCHAz5dsjWzB7o0RMDCxlFvyB20ju7RNqXmiyMvp+mEt8g==
X-Received: by 2002:a05:6402:40c4:: with SMTP id z4mr899685edb.364.1624466479678;
        Wed, 23 Jun 2021 09:41:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g15sm117603ejb.103.2021.06.23.09.41.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 09:41:19 -0700 (PDT)
Subject: Re: [PATCH 10/54] KVM: x86/mmu: Replace EPT shadow page shenanigans
 with simpler check
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <20210622175739.3610207-11-seanjc@google.com>
 <8ce36922-dba0-9b53-6f74-82f3f68b443c@redhat.com>
 <YNNegF8RcF3vX2Sh@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <df77b8e9-b2bb-b085-0789-909a8b9d44c3@redhat.com>
Date:   Wed, 23 Jun 2021 18:41:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YNNegF8RcF3vX2Sh@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/21 18:17, Sean Christopherson wrote:
>> What the commit message doesn't say is, did we miss this
>> opportunity all along, or has there been a change since commit
>> 47c42e6b4192 ("KVM: x86: fix handling of role.cr4_pae and rename it
>> to 'gpte_size'", 2019-03-28) that allows this?
>
> The code was wrong from the initial "unsync" commit.  The 4-byte vs.
> 8-byte check papered over the real bug, which was that the roles were
> not checked for compabitility.  I suspect that the bug only
> manisfested as an observable problem when the GPTE sizes mismatched,
> thus the PAE check was added.

I meant that we really never needed is_ept_sp, and you could have used 
the simpler check already at the time you introduced gpte_is_8_bytes. 
But anyway I think we're in agreement.

Paolo

