Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C613D2865CF
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 19:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbgJGRVn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 13:21:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48500 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727891AbgJGRVk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Oct 2020 13:21:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602091299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ev7l4o4ItRm1VhP9wG9Pez+Vrn0NjvK4cwa9rKvbPLQ=;
        b=cE8xFAvf+8+eCuOaY7aG7Wx28oP8iLNzexqYemzS1hPwRpAvz7dkEPqwsy/IptPEkODECx
        eCQgawL8hw6e6eF6B0Q2mFGbJNYzWP2yzWkaWwKtcVofptmYtVrqg8vlnZvovaLlhQqJOs
        /RK2ANwFuwGjkhWfGUyH1e6R0xloc6k=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-fMjgk4z5O82lPwQxExcxmw-1; Wed, 07 Oct 2020 13:21:36 -0400
X-MC-Unique: fMjgk4z5O82lPwQxExcxmw-1
Received: by mail-wr1-f70.google.com with SMTP id l20so1604581wrc.20
        for <kvm@vger.kernel.org>; Wed, 07 Oct 2020 10:21:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ev7l4o4ItRm1VhP9wG9Pez+Vrn0NjvK4cwa9rKvbPLQ=;
        b=mebkQYP3CNwUKzT/qf+ShPtgxxhgLOJ+YIjfs5kNIByELighG9WPbYPYxLrMVHPQUK
         7BDzQ3zTqyeUsQ0Fi68fHNnR8sdHu/Kix/WIuTnwfEWxYmWrs4P5RMWruGn3g3mXHK9/
         q+cGq50n9xMK6tiWFXY3jTtYh3e4N/OlGkE9CZHLB794oe1rZcsvXAEdpcs85SjwWPiJ
         QchUqV7fDg+5wcAKZa8PogVezjZeHfg4TMFAF/VLjqe8oDGwjn59OtNxKnO0/6dq6dF7
         Brwdig1YjSfxzc/dspu0/WafkHuT7gcw99dhQF0MTMPVwCpXtqJWLdlCS6A1dY8FbLO5
         EBeg==
X-Gm-Message-State: AOAM531ylCRl4a9Rlv2ZJAKoUCjp5/YGqNj6qoEF6Mzg1makp6rCUlRz
        SKMWUNzn7w6pfBKA/d/SA48AVLNFINHIXibz5w79SpMLosbpK5fLSvWTtQKkxPahdj4Zp3s0mwy
        eDx+jv8KsCcIP
X-Received: by 2002:a7b:cb04:: with SMTP id u4mr4378675wmj.130.1602091295388;
        Wed, 07 Oct 2020 10:21:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyu5tg4RKDgSfRgtwbzjic91GX3ld6PSc87MB+VHzwPP3V2K3ebPcKG7RE4ZJ9NAurnMXOkXQ==
X-Received: by 2002:a7b:cb04:: with SMTP id u4mr4378514wmj.130.1602091293028;
        Wed, 07 Oct 2020 10:21:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d2f4:5943:190c:39ff? ([2001:b07:6468:f312:d2f4:5943:190c:39ff])
        by smtp.gmail.com with ESMTPSA id n2sm3737510wrt.82.2020.10.07.10.21.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2020 10:21:32 -0700 (PDT)
Subject: Re: [PATCH 18/22] kvm: mmu: Support disabling dirty logging for the
 tdp MMU
To:     Ben Gardon <bgardon@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Cannon Matthews <cannonmatthews@google.com>,
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
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-19-bgardon@google.com>
 <44822999-f5dc-6116-db12-a41f5bd80dd8@redhat.com>
 <CANgfPd_dQ19sZz2wzSfz7-RzdbQrfP6cYJLpSYbyNyQW6Uf09Q@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5dc72eec-a4bd-f31a-f439-cdf8c5b48c05@redhat.com>
Date:   Wed, 7 Oct 2020 19:21:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CANgfPd_dQ19sZz2wzSfz7-RzdbQrfP6cYJLpSYbyNyQW6Uf09Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/10/20 18:30, Ben Gardon wrote:
>> I'm starting to wonder if another iterator like
>> for_each_tdp_leaf_pte_root would be clearer, since this idiom repeats
>> itself quite often.  The tdp_iter_next_leaf function would be easily
>> implemented as
>>
>>         while (likely(iter->valid) &&
>>                (!is_shadow_present_pte(iter.old_spte) ||
>>                 is_last_spte(iter.old_spte, iter.level))
>>                 tdp_iter_next(iter);
> Do you see a substantial efficiency difference between adding a
> tdp_iter_next_leaf and building on for_each_tdp_pte_using_root with
> something like:
> 
> #define for_each_tdp_leaf_pte_using_root(_iter, _root, _start, _end)    \
>         for_each_tdp_pte_using_root(_iter, _root, _start, _end)         \
>                 if (!is_shadow_present_pte(_iter.old_spte) ||           \
>                     !is_last_spte(_iter.old_spte, _iter.level))         \
>                         continue;                                       \
>                 else
> 
> I agree that putting those checks in a wrapper makes the code more concise.
> 

No, that would be just another way to write the same thing.  That said,
making the iteration API more complicated also has disadvantages because
if get a Cartesian explosion of changes.

Regarding the naming, I'm leaning towards

    tdp_root_for_each_pte
    tdp_vcpu_for_each_pte

which is shorter than the version with "using" and still clarifies that
"root" and "vcpu" are the thing that the iteration works on.

Paolo

