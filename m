Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF98729098D
	for <lists+kvm@lfdr.de>; Fri, 16 Oct 2020 18:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410753AbgJPQSx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Oct 2020 12:18:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38887 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2410728AbgJPQSq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 16 Oct 2020 12:18:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602865125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eD8jVuSLB7bhS1tzZOiVsps5uH3EKR905X+lDjVw/1E=;
        b=Fpg+xh/bADci/JlEqVAd/SlHQ9f+Wx08L5DPeupm8eT3qX+aObHzsKsPIds9QdyEM8u9j3
        rGyKZrqTtAv/w8vQU3U2mgzCCF8zC1V4wVRH7VApZQUAzjgLePrEu+0ttre8eHQKa9anxM
        uPbOqdKukCug1adDYDv9t0TRZHKO+SI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-483-QwYkHJ50Nz2qnD9YkDmW3g-1; Fri, 16 Oct 2020 12:18:43 -0400
X-MC-Unique: QwYkHJ50Nz2qnD9YkDmW3g-1
Received: by mail-wm1-f69.google.com with SMTP id 73so880067wma.5
        for <kvm@vger.kernel.org>; Fri, 16 Oct 2020 09:18:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eD8jVuSLB7bhS1tzZOiVsps5uH3EKR905X+lDjVw/1E=;
        b=KjrN+P3q4xyMbnSliWcMc1fM7zQSpE+VETTTCiWAvkXmWR1ZNFuoC4zeXN72qM4qTa
         e8t7N6bZ0FMGZMN4KaIT9yd2pphuhh6wGcwlCvDuYfNu+UbT/cHIYP7KZpxHpjD6Bsxl
         TkDZ0FWrZZ9MUxcsfT2E3AIhFiAzX1L8cw3wIcBJ0YZI2QtQdVDQjauMpnrm8OQ3nRYA
         IUhCFiLR/vexhfFtPx4s37l3B2myIp4aK5KL0/bui+AiWqN2menosRinSX3tn/IB5lxX
         nmqgSv9ooPd7TzaMWU6ItTkP3uZrw4J1Xc6OjQ4usT9l4cd9/smd3R+OelL+GtEprHAv
         4Gxg==
X-Gm-Message-State: AOAM530Ruzfctytt1lMM3bf7S/lCPyWmoHruQ8XFsIvl9SseeLIewtF2
        m6c58UBmSUbVWE8z0g4zJijTKJluAv9FOQwRo6ZoLqzgdJz7C9ZepjUxAhR5DJA6zs35zxKQVTv
        6XNghspTxDqvx
X-Received: by 2002:a5d:468f:: with SMTP id u15mr4893759wrq.154.1602865122457;
        Fri, 16 Oct 2020 09:18:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwNE1a3lrNF/pwxGalrsxHiv258wT6XJyjXt4igENgxUD08IKd03Tf7FldvIb1/Ed3K1y5Qrw==
X-Received: by 2002:a5d:468f:: with SMTP id u15mr4893690wrq.154.1602865121811;
        Fri, 16 Oct 2020 09:18:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4e8a:ee8e:6ed5:4bc3? ([2001:b07:6468:f312:4e8a:ee8e:6ed5:4bc3])
        by smtp.gmail.com with ESMTPSA id l26sm3250779wmi.39.2020.10.16.09.18.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2020 09:18:41 -0700 (PDT)
Subject: Re: [PATCH v2 17/20] kvm: x86/mmu: Support write protection for
 nesting in tdp MMU
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20201014182700.2888246-1-bgardon@google.com>
 <20201014182700.2888246-18-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c5b511f2-1224-c4b3-539a-0c34dca34c51@redhat.com>
Date:   Fri, 16 Oct 2020 18:18:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201014182700.2888246-18-bgardon@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/10/20 20:26, Ben Gardon wrote:
> +		spte_set = write_protect_gfn(kvm, root, gfn) || spte_set;

Remaining instance of ||.

