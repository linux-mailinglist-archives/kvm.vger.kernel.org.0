Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 642752C6A1A
	for <lists+kvm@lfdr.de>; Fri, 27 Nov 2020 17:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731440AbgK0Qs5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Nov 2020 11:48:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26127 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731169AbgK0Qs5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Nov 2020 11:48:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606495735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nGp/DntBx65LrgMqUH3vUA33NqIvtHitHZjJU3bsRLY=;
        b=a/gE0UgJ1wrv7UwhdU4x33dZo1PJYs/AyIjHXWvpNnaQm1geTieizj+8W5J4jSV0opaaCu
        /P0GiPgCJ4wcZlSTv6JJoMjVUTtAUSrf6yeKgfr+1kDe12A8Uz+gLXMSgdMxTIAslJxk2s
        DkRGxR85IkkG6f0DfAGZV3uz2GxeF98=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-KztvyAuiOFWCwrG0YIA9zA-1; Fri, 27 Nov 2020 11:48:54 -0500
X-MC-Unique: KztvyAuiOFWCwrG0YIA9zA-1
Received: by mail-ej1-f70.google.com with SMTP id e7so2142122eja.15
        for <kvm@vger.kernel.org>; Fri, 27 Nov 2020 08:48:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nGp/DntBx65LrgMqUH3vUA33NqIvtHitHZjJU3bsRLY=;
        b=hImbFuz+SCTVRggbWdnOQUYNDdc6cZ2uGJ8BRynDMP/PwhMj0y14+eal6RgA3v7bf2
         RO0W2Stde3bhYw5UU/iYFTgwHG1V2UACSc9mHQp6XtJRztK/dzfBbyN3VsxJPv8lhyvy
         cEnifT4hU3pNMykSAnyX2Qk/iyQTueVnPtJ1I2xQ+1qAd8CcKVgeGsnhuNHZHnTSGP/e
         qLk9te8rM3/GkurCX56Zaoxswshl90EVuIl2kmSRx4NN4JhbfdVk4Pbl82dIEv/clZQr
         4mlXxSxg+GHLdUVNWnH3gDAKRM3zJ3ViWK5AeUphE9/eYrgkk7DdGKERmA35x5u23rSN
         RoRw==
X-Gm-Message-State: AOAM5306ayPOgdH+avpb1Bn+fFw2VdHGzLgLKaLhGAr1QUQrd85t2G1R
        LZAYP4pJnx4QdGgVrZ5SOmLMqTwl6p3FIlQ0d7IGwbcbBkuafXHqC8OW+cNmzdlycxuK26Je1GJ
        6IdhNlefOh+fu
X-Received: by 2002:a17:906:6b82:: with SMTP id l2mr8531385ejr.241.1606495732775;
        Fri, 27 Nov 2020 08:48:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzJUDCnzieJYN1ooH1FMZWePLUiObAU18Z7hCPD7yuVFtkt12b8hACer7ziwEvurg6/0HZMEQ==
X-Received: by 2002:a17:906:6b82:: with SMTP id l2mr8531363ejr.241.1606495732591;
        Fri, 27 Nov 2020 08:48:52 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b20sm557564eja.30.2020.11.27.08.48.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Nov 2020 08:48:51 -0800 (PST)
Subject: Re: [PATCH] kvm/x86/mmu: use the correct inherited permissions to get
 shadow page
To:     Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@qumranet.com>, linux-doc@vger.kernel.org
References: <20201120095517.19211-1-jiangshanlai@gmail.com>
 <20201126000549.GC450871@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0724aeb9-3466-5505-8f12-a5899144e68f@redhat.com>
Date:   Fri, 27 Nov 2020 17:48:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201126000549.GC450871@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/11/20 01:05, Sean Christopherson wrote:
> On Fri, Nov 20, 2020, Lai Jiangshan wrote:
>> From: Lai Jiangshan <laijs@linux.alibaba.com>
>>
>> Commit 41074d07c78b ("KVM: MMU: Fix inherited permissions for emulated
>> guest pte updates") said role.access is common access permissions for
>> all ptes in this shadow page, which is the inherited permissions from
>> the parent ptes.
>>
>> But the commit did not enforce this definition when kvm_mmu_get_page()
>> is called in FNAME(fetch). Rather, it uses a random (last level pte's
>> combined) access permissions.
> 
> I wouldn't say it's random, the issue is specifically that all shadow pages end
> up using the combined set of permissions of the entire walk, as opposed to the
> only combined permissions of its parents.
> 
>> And the permissions won't be checked again in next FNAME(fetch) since the
>> spte is present. It might fail to meet guest's expectation when guest sets up
>> spaghetti pagetables.
> 
> Can you provide details on the exact failure scenario?  It would be very helpful
> for documentation and understanding.  I can see how using the full combined
> permissions will cause weirdness for upper level SPs in kvm_mmu_get_page(), but
> I'm struggling to connect the dots to understand how that will cause incorrect
> behavior for the guest.  AFAICT, outside of the SP cache, KVM only consumes
> role.access for the final/last SP.
> 

Agreed, a unit test would be even better, but just a description in the 
commit message would be enough.

Paolo

