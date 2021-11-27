Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A2345FE18
	for <lists+kvm@lfdr.de>; Sat, 27 Nov 2021 11:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350919AbhK0KcR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Nov 2021 05:32:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbhK0KaQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Nov 2021 05:30:16 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97EAAC06173E
        for <kvm@vger.kernel.org>; Sat, 27 Nov 2021 02:27:02 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id v1so49126596edx.2
        for <kvm@vger.kernel.org>; Sat, 27 Nov 2021 02:27:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MPZpJPH66VvgDjLv023Lj2UNPGCsEr/n3q5iz+bRalU=;
        b=aMxDJ2lPFm7aC0ZsSu6loXxtx8uNuCrhhAE2Qp3DNDuwSmdU+YgkrFjlfdoaKxiFlE
         /Y5jID2mNvRr07ACNxC6yKoDc6wZ1W8XRuoXGfwkRwCc+r8vAQ9ZOuKawaErZExUC/py
         ZedlWoVYBe0WG4TaA0fPPu41uPpbds1ajbHVkfZ1EI6meCG9zipriFB3X15bfNsSaPXA
         TeXUdIaYAfEvsi4Q6BQiwQU1CF0aq7VV7Q8076VYHAydYdxeaZJ+rYVmEihPx+3CbJT4
         EyvEtZbyND6K1rmaCIWQ3nJ5OgxY9FDx4kK9StCEYgqquKAXFHH0GN83LEhTsHN69G7l
         fgnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MPZpJPH66VvgDjLv023Lj2UNPGCsEr/n3q5iz+bRalU=;
        b=YyTOgLR6GtAf0BFS5UZikHtccicrhJpjaCKjz6D9YBiPCPAGm1zkWqg/9JCKpaWT8R
         rvglQJxIqy2vxEgeER3y6CoRrxhcdRbimXb5r3xHdlQOORIGim04HsXK3s3KJ8iY47Av
         JxEHup/7C66aH+0cTXqyz323aQBvJDeC6GPt7yFW1wzKkpLu1ZK9qiFzVWi9oGOTCjsI
         mZsr5p3EEGgXOk0U4lw+d1fse6UGTb1nG7v5HXHaDe+zSaUsDJ4IciXh7BNWXqzhrtKW
         RxmosIsOddcZzjUktsSrkUoBQ2XorvQTzi2oKEtmsOx+GaW+iKQPXtG05ISp7U/e08K4
         Y+/Q==
X-Gm-Message-State: AOAM5330U5oKg6IWJ9JyWUA3Rp/K3jqhjdPHOIwYljliF4fnMa5xVwVW
        deidqebHO9vNBWvOTjW9pNo=
X-Google-Smtp-Source: ABdhPJxKG0HURUYAvOumSqHLk1n7uSBsGKRn/eHePctUqd3P7XGsArrb2hS7XNx3MLOAy0wsqUFg/w==
X-Received: by 2002:aa7:c353:: with SMTP id j19mr55475557edr.227.1638008821254;
        Sat, 27 Nov 2021 02:27:01 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id h10sm5569259edr.95.2021.11.27.02.26.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Nov 2021 02:27:00 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <669c9fff-e044-d580-8eac-9f83e122d273@redhat.com>
Date:   Sat, 27 Nov 2021 11:26:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH 06/15] KVM: x86/mmu: Derive page role from parent
Content-Language: en-US
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     David Matlack <dmatlack@google.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>
References: <20211119235759.1304274-1-dmatlack@google.com>
 <20211119235759.1304274-7-dmatlack@google.com>
 <62bd6567-bde5-7bb3-ec73-abf0e2874706@redhat.com>
 <CAJhGHyD5uu9+77nWMmg7sW_s0uuO_zfPW+8MjWd__ZZzKpL34A@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAJhGHyD5uu9+77nWMmg7sW_s0uuO_zfPW+8MjWd__ZZzKpL34A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/27/21 03:07, Lai Jiangshan wrote:
> On Sat, Nov 20, 2021 at 9:02 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
>>
>> I have a similar patch for the old MMU, but it was also replacing
>> shadow_root_level with shadow_root_role.  I'll see if I can adapt it to
>> the TDP MMU, since the shadow_root_role is obviously the same for both.
>>
> 
> Hello, Paolo
> 
> I'm sorry to ask something unrelated to this patchset, but related
> to my pending work.
> 
> I will still continue to do something on shadow_root_level.  But I
> would like to wait until your shadow_root_role work is queued.
> And is it a part of work splitting the struct kvm_mmu?

Yes, more or less.  I'm basically splitting the "CPU role" (the basic 
and extended role from the processor registers) used for emulation, from 
the "MMU role" (the basic role used for the root shadow page tables). 
Then shadow_root_level/root_level become respectively mmu_role->level 
and cpu_role->base.level.

Paolo

