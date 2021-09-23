Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEAC416316
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 18:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242342AbhIWQYe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 12:24:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45720 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242133AbhIWQYT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Sep 2021 12:24:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632414156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YZm+wiesYVl7zMhS5rKD3EUk7Pvh+YAy8H59fwCRfig=;
        b=cBN/tT4OF8yuqnK67DEQfHn3hsNPHvIy2MYvOXvoMmnVttajDDuGdQkdp+dpY04K/mQBB9
        3HXQI+tMw0UTvIEPqSs08p3vKX4nuW0eM4UyxGnXYR47MoFvSk0+B4OlIP2s0R2jQIluvF
        Jl40AEEIgd+wYFmlWLf6vv48UId5kAQ=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-551-LwHTA8SJP8GUD9boLH2mAA-1; Thu, 23 Sep 2021 12:22:35 -0400
X-MC-Unique: LwHTA8SJP8GUD9boLH2mAA-1
Received: by mail-ed1-f69.google.com with SMTP id q17-20020a50c351000000b003d81427d25cso7257827edb.15
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 09:22:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YZm+wiesYVl7zMhS5rKD3EUk7Pvh+YAy8H59fwCRfig=;
        b=NW4HLAYBUZzDJG8+FTWFV7C21CgwMLzZOD38plvMNxKOH9ynVxiIs3XWv5M8LYDQVI
         /wvbTsgCu4tXWgC+oMuJiJjB0SGOO26himi87fZ+JAzhuJRKKoXbeWNep8TIfdQLf2vm
         1O3M3bxeeE4AbPjUyanQYjmh4bTS8E5c2/GfNN/yocfJq2R7MasxpXJoIna51/vZoNii
         AL0zyRXHydHTuBeU4gN8lnt2c5wyyYk4sLDGd4nxsS1EAv1C5+60/yl7jo5i4Z+6jlVI
         R882ZxIoAL8QUQfoRGdowfl5KmLJyBUxFx+wMP9CpFTIrpNpIqv2c+2fV2B4Ujhd2fIT
         GSfw==
X-Gm-Message-State: AOAM531hohS9QM5+ngxqkuq0BrrtH/X1hmrSSCefgpUvSz6IQdvHejEe
        MrSJfryjYjJ9Ogd8gfJt/0gHsls6x8OSdhKsVUWyCFvYSBQMCRUWGTK6oc7oU/lYb+SX0FPXuKA
        BYLotCDqgiSsh
X-Received: by 2002:a50:e188:: with SMTP id k8mr6673655edl.119.1632414153542;
        Thu, 23 Sep 2021 09:22:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJygd+vg/0b6mTm+/Xz8NPYPMcxf/ymptn1I+uzbwtmBaVt7SEm1YHMnao7pvB3Z1JVD4JBpRg==
X-Received: by 2002:a50:e188:: with SMTP id k8mr6673618edl.119.1632414153289;
        Thu, 23 Sep 2021 09:22:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h8sm3374154ejj.22.2021.09.23.09.22.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Sep 2021 09:22:32 -0700 (PDT)
Subject: Re: [PATCH 0/3] KVM: x86: guest.MAXPHYADDR fix and related cleanup
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+200c08e88ae818f849ce@syzkaller.appspotmail.com
References: <20210831164224.1119728-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5f9dccf3-0b11-a10d-11a2-e8ebe7e4b6dc@redhat.com>
Date:   Thu, 23 Sep 2021 18:22:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210831164224.1119728-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/08/21 18:42, Sean Christopherson wrote:
> Fix a bug exposed by syzkaller where running with guest.MAXPHYADDR < 32
> leads KVM injecting a garbage exception due to mishandling an illegal GPA
> check when "translating" a non-nested GPA.
> 
> Clean up tangentially related code in load_pdptrs() to discourage reading
> guest memory using a potentially-nested GPA.
> 
> Sean Christopherson (3):
>    Revert "KVM: x86: mmu: Add guest physical address check in
>      translate_gpa()"
>    KVM: x86: Subsume nested GPA read helper into load_pdptrs()
>    KVM: x86: Simplify retrieving the page offset when loading PDTPRs
> 
>   arch/x86/include/asm/kvm_host.h |  3 --
>   arch/x86/kvm/mmu/mmu.c          |  6 ----
>   arch/x86/kvm/x86.c              | 56 +++++++++++----------------------
>   3 files changed, 18 insertions(+), 47 deletions(-)
> 

Queued 2 and 3 too now, thanks.

Paolo

