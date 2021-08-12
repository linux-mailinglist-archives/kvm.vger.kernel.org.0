Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907483EA93D
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 19:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235090AbhHLRPc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 13:15:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58122 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234442AbhHLRPc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Aug 2021 13:15:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628788506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hl2q/IBeDF11InTwkjo+Q88yO1GQYT5aRVKT9ieIQAI=;
        b=FT+ry8+qt1epauQX3tA7iZAI3cisYNrBewW2C/2M3Fd8o9ofEBJjAX2nKbT7u6wjpUuX8I
        2wCmA6OqgMHoqgVkJdLrBARE5hLgT0lcZDDoEIcNHw5lzpdU4FptFDdywwvTKQtMxWMiI7
        qMpaa5S8lnUxjZxOAbAk2H+xhlqoTSE=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-x8j_O3tcOwGWThqqf94WAg-1; Thu, 12 Aug 2021 13:15:05 -0400
X-MC-Unique: x8j_O3tcOwGWThqqf94WAg-1
Received: by mail-ej1-f72.google.com with SMTP id q19-20020a1709064cd3b02904c5f93c0124so2075516ejt.14
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 10:15:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Hl2q/IBeDF11InTwkjo+Q88yO1GQYT5aRVKT9ieIQAI=;
        b=m4eEcWPfS4L7cIEG+V9s5w/eB/txeD3f7UxtKRUnNorOPuxHRDQBB1WWYuJqZXs+ws
         YXoKnWyi9TuXpQJNn2Y4XdXqsdBrvzbPQIHeWlop6TltMDMWmz7AoqoW6tPczegOEbDh
         dVTuLeRc5JxDKkaD/JmcENbzEvAjK7TQC1co/R1ZlhZH8dVRALEt7iZlYYANllGJqPjC
         p9tyM+PPoKR4BW0ZdF1wNMejBJ4dqoT6J3Adeb1BuYUqkz/BvFzsTXOm/rnWlG5cb7yI
         P+EjwoAtb0OJPoW6tQXHWLrwqfDiN70eSwY0+rU6Ad5fQMMe073BX2ZD0miOW51hueiB
         Kb4g==
X-Gm-Message-State: AOAM532ox7tqkQ/zOAqLSbiuV01Vi4+dJRZzBrW603vAyF5sV2dP1QcZ
        f6i4EKeSQGb3wvVC6lUDYEgKiwK8YLjSeQr5ys31L9oR6oabcEe6e5ojtPaieeRlFwd4xl5wkMi
        rep5YLgrefics
X-Received: by 2002:a17:906:27c2:: with SMTP id k2mr4767551ejc.83.1628788503851;
        Thu, 12 Aug 2021 10:15:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyxEeKcRzmOwBpp9BraLT3nidE1aRoYWBwP+lWqClH2qMMa+9atOOooDHgiCXS/nS9PCTgByA==
X-Received: by 2002:a17:906:27c2:: with SMTP id k2mr4767524ejc.83.1628788503613;
        Thu, 12 Aug 2021 10:15:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n26sm1408416eds.63.2021.08.12.10.15.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 10:15:02 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Don't step down in the TDP iterator
 when zapping all SPTEs
To:     Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20210812050717.3176478-1-seanjc@google.com>
 <20210812050717.3176478-3-seanjc@google.com>
 <CANgfPd8HSYZbqmi21XQ=XeMCndXJ0+Ld0eZNKPWLa1fKtutiBA@mail.gmail.com>
 <YRVVWC31fuZiw9tT@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <928be04d-e60e-924c-1f3a-cb5fef8b0042@redhat.com>
Date:   Thu, 12 Aug 2021 19:15:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YRVVWC31fuZiw9tT@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/08/21 19:07, Sean Christopherson wrote:
> Yeah, I was/am on the fence too, I almost included a blurb in the cover letter
> saying as much.  I'll do that for v2 and let Paolo decide.

I think it makes sense to have it.  You can even use the ternary operator

	/*
	 * When zapping everything, all entries at the top level
	 * ultimately go away, and the levels below go down with them.
	 * So do not bother iterating all the way down to the leaves.
	 */
	int min_level = zap_all ? root->role.level : PG_LEVEL_4K;

Paolo

