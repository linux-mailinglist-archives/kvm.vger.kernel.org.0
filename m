Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF7C1EA7DF
	for <lists+kvm@lfdr.de>; Mon,  1 Jun 2020 18:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727808AbgFAQfc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 12:35:32 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38628 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726125AbgFAQfa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Jun 2020 12:35:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591029328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zc9wyn742yLh7B24rM+A2xhouSXE07FcUGUaBsY67qY=;
        b=U2udZ4KsHx99spbHkWJNs8eqckmHUt2pBmVbw068zob615uYoDcrw6GZJmVJwgJD8HNP17
        EYVo3O/khHaLQYUnmAyPsc5Q7ylba1MW+em2BPIn7HylVsaoEgEg3/qgs/brYjle09RpV/
        i1FoX8WxoZqDznuVRFco/QyqPFvo3qU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-FXZLW3amPxyMftO2ZsWA3w-1; Mon, 01 Jun 2020 12:35:27 -0400
X-MC-Unique: FXZLW3amPxyMftO2ZsWA3w-1
Received: by mail-wr1-f69.google.com with SMTP id r5so214155wrt.9
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 09:35:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zc9wyn742yLh7B24rM+A2xhouSXE07FcUGUaBsY67qY=;
        b=sjidSMobVg4WuC+pqDuguN7xXsSQGCBWHSAe79qMWPG1Ue2MRgRQbWppXnmS2W3kDq
         mUI9ktOjkwl/JL8RCCJA3CsLBHBYnDNE5Sn2pPd6TjLqOSa9eLQLhRl260EMX1wCyrkI
         pSWFItW3/bxhcq6SPkG/Qw4LyapIi9FtkYEMfuPDz4cJS/qXCItLQU4noGenztvzoVUl
         ObRElvk9++E2jd1aUVu8nFKvLB9XrpcgcJDX07Mdx8I0oUcsjbg9jxMMtls3GQRhAJvl
         s9+1dsQRS0HcH3x7ONpxFbK3lIPI/Rsge6oklaj+ijFc4V5zgeN3kmHNwzQ5xuHgyvh+
         K0tQ==
X-Gm-Message-State: AOAM533IkYtqEGiFOxgcY5pOXWXlNi+EuEUDECQDxDofvo6oDKbKPkT5
        HRkhDIb8ASlmhw4KHtfxN+rZY/BDZl8WG8pTlZOC1syfYaINKqhwkt46qGUj1711KLBSc00so+F
        924mv/T2K5DxS
X-Received: by 2002:a1c:3585:: with SMTP id c127mr186477wma.34.1591029324726;
        Mon, 01 Jun 2020 09:35:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9UvBpHprFyqkB9INncZbq9Zh/UjdnJcRudmhYbCdzWCCop0k8OMkWVXIN62P1rQ5lrNmQZw==
X-Received: by 2002:a1c:3585:: with SMTP id c127mr186466wma.34.1591029324534;
        Mon, 01 Jun 2020 09:35:24 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id 138sm194273wma.23.2020.06.01.09.35.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 09:35:23 -0700 (PDT)
Subject: Re: [RFC 06/16] KVM: Use GUP instead of copy_from/to_user() to access
 guest memory
To:     "Kirill A. Shutemov" <kirill@shutemov.name>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
 <20200522125214.31348-7-kirill.shutemov@linux.intel.com>
 <87a71w832c.fsf@vitty.brq.redhat.com> <20200525151755.yzbmemtrii455s6k@box>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a5acc4c8-2ee6-9e5d-c0a5-2a6f7c54c059@redhat.com>
Date:   Mon, 1 Jun 2020 18:35:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200525151755.yzbmemtrii455s6k@box>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/05/20 17:17, Kirill A. Shutemov wrote:
>> Personally, I would've just added 'struct kvm' pointer to 'struct
>> kvm_memory_slot' to be able to extract 'mem_protected' info when
>> needed. This will make the patch much smaller.
> Okay, can do.
> 
> Other thing I tried is to have per-slot flag to indicate that it's
> protected. But Sean pointed that it's all-or-nothing feature and having
> the flag in the slot would be misleading.
> 

Perhaps it would be misleading, but it's an optimization.  Saving a
pointer dereference can be worth it, also because there are some places
where we just pass around a memslot and we don't have the struct kvm*.

Also, it's an all-or-nothing feature _now_.  It doesn't have to remain
that way.

Paolo

