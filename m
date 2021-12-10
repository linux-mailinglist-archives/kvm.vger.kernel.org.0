Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47CD2470561
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 17:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240201AbhLJQRT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 11:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235802AbhLJQRQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 11:17:16 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C37C061746;
        Fri, 10 Dec 2021 08:13:41 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id v1so31913804edx.2;
        Fri, 10 Dec 2021 08:13:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MeaT6sP369ZHHfFlIktP/ijwsUKGGwQi8Na1ysopui0=;
        b=awGSNUEdqU3eYue93Og7j1+edp3YABdgj0N9Ga98N5ubOQFsdyrgkZk2BBZ4p513Tq
         ifeWlcUvxk5atK2BK8Fr7zju6mVQR3Bpgl9jrTaXLGs/epBNkcTn8OKsvy9I4vn6cuGl
         ALSc+O5jaFLVV6BZKbsvepgRRAzwPh5bWgWsUJ1lGmMMMRmJDB0GaTcDsjZ2V2/b0pQ+
         gZFb+sG2ZGFnKXURT7S6ZVfFmUcO+7bdJmQJdx29sksBpCJpm5jtBkpZ+QmWsQ2w1aiH
         66LiLrhQX/cLrxjnQ6Rw7xkzRm4QRk761c/nWg6kDmACGiQSHbwfCeOn4krmIdQjiJLu
         u4iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MeaT6sP369ZHHfFlIktP/ijwsUKGGwQi8Na1ysopui0=;
        b=qjB6TF9XoQF1trm2dTWnp+glx+tet2go0Sd1pOkohIi1pr+K6jKWiQMO1PjSqfY4iQ
         uwJ17Zwbsm2HdhCu8zzWqOaSagLebpDUnX+2HMW3bYQ0psMD2KMnAfWlgY5XqD0tA+re
         NetV/DKTT5jbp/VvlnhyZrEw4BsEqKPcJy+47nHXHFv3EOUPR+kRaWD03rqHh8zJP6UC
         2IWXZJcyJOMBtEcTWCeagjYktx/wUbm5z0ddhJ6qL7yN0tUAEWr26BuqIuEnJB/K1Fxt
         Ym3XuW7ilC2O4c5gD5wG5wusdymM7W3MHWoJdA9w1Fl17NMpGmgys8FY2cjui8oWWcSt
         EB2A==
X-Gm-Message-State: AOAM532n63LJG1F8cu08xYTqCeZklE3fiDtMha2bufhbST18YGaNKFjQ
        jFwpHK30Kwpn6+SIVikO19k=
X-Google-Smtp-Source: ABdhPJzRiRJoaivdEdM1HH35JPF4ywUVtOqJvo2pTQyXc9KWsiWb7HO9CClNbRJMS6BT0j/CTz+4Kg==
X-Received: by 2002:a17:907:2454:: with SMTP id yw20mr25180988ejb.428.1639152819557;
        Fri, 10 Dec 2021 08:13:39 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:48f9:bea:a04c:3dfe? ([2001:b07:6468:f312:48f9:bea:a04c:3dfe])
        by smtp.googlemail.com with ESMTPSA id jg32sm1900192ejc.43.2021.12.10.08.13.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 08:13:38 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <8ab8833f-2a89-71ff-98da-2cfbb251736f@redhat.com>
Date:   Fri, 10 Dec 2021 17:13:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 1/7] KVM: x86: Retry page fault if MMU reload is pending
 and root has no sp
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
References: <20211209060552.2956723-1-seanjc@google.com>
 <20211209060552.2956723-2-seanjc@google.com>
 <c94b3aec-981e-8557-ba29-0094b075b8e4@redhat.com>
 <YbN58FS67bEBOZZu@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YbN58FS67bEBOZZu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/10/21 17:01, Sean Christopherson wrote:
>> KVM_REQ_MMU_RELOAD is raised after kvm->arch.mmu_valid_gen is fixed (of
>> course, otherwise the other CPU might just not see any obsoleted page
>> from the legacy MMU), therefore any check on KVM_REQ_MMU_RELOAD is just
>> advisory.
> 
> I disagree.  IMO, KVM should not be installing SPTEs into obsolete shadow pages,
> which is what continuing on allows.  I don't _think_ it's problematic, but I do
> think it's wrong.
>
> [...] Eh, for all intents and purposes, KVM_REQ_MMU_RELOAD very much says
> special roots are obsolete.  The root will be unloaded, i.e. will no
> longer be used, i.e. is obsolete.

I understand that---but it takes some unspoken details to understand 
that.  In particular that both kvm_reload_remote_mmus and 
is_page_fault_stale are called under mmu_lock write-lock, and that 
there's no unlock between updating mmu_valid_gen and calling 
kvm_reload_remote_mmus.

(This also suggests, for the other six patches, keeping 
kvm_reload_remote_mmus and just moving it to arch/x86/kvm/mmu/mmu.c, 
with an assertion that the MMU lock is held for write).

But since we have a way forward for having no special roots to worry 
about, it seems an unnecessary overload for 1) a patch that will last 
one or two releasees at most 2) a case that has been handled in the 
inefficient way forever.

Paolo

> The other way to check for an invalid special root would be to treat
> it as obsolete if any of its children in entries 0-3 are present and
> obsolete.  That would be more precise, but it provides no benefit
> given KVM's current implementation.
> 
> I'm not completely opposed to doing nothing, but I do think it's
> silly to continue on knowing that the work done by the page fault is
> all but gauranteed to be useless.
> 

