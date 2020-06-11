Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E7F1F6AF5
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 17:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbgFKP16 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 11:27:58 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:44967 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726497AbgFKP14 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Jun 2020 11:27:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591889274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tubQTvMCayyEO7VGNY1bAGU+lqkLOkwFY6fIG7RPrrg=;
        b=AiW797L7xYUyHVCoMm373X8PqbX4OLiKu/k6El3vEwLWT/3mGLNFTun9zjH4thBI7qzFTE
        l65gdcxEHp6kZN9Yip3M3WD6WF8OAsVai7b9UphgNGk939CM5o+z600iVrG8YZhDCSUTnA
        U8DuVNVDtKQhDs9Hq/Ko8mN/KTuDYZ4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-yoHZSv1YO9Six2EpvqSfDA-1; Thu, 11 Jun 2020 11:27:51 -0400
X-MC-Unique: yoHZSv1YO9Six2EpvqSfDA-1
Received: by mail-wm1-f69.google.com with SMTP id r1so1461747wmh.7
        for <kvm@vger.kernel.org>; Thu, 11 Jun 2020 08:27:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tubQTvMCayyEO7VGNY1bAGU+lqkLOkwFY6fIG7RPrrg=;
        b=XMnu24FxPtzTN3zVs2Kmcl+1Xxua/KTvK9S2zRmjLrXvrm2demzVDrZTkvssQf+5Co
         /MNDNXGF3tUxvf/FkJDDutNatqUqXineJG2L9Bm9guuSXnfySunhSmnnaGY9ctTQnBuf
         Ef0G8NGNOIUj0BM1GftiM3r1icCYd1ycmeSjv3YjyiUKQGKAZumy4C5pPIiVm76Wr3gj
         UOHxdhTRg8DSSF6MdtA5f+yfrK1Cyw+2z0jvTyAxSpTMOPZINHhIu8kqkEDHwBeMdCW6
         1qpyZO2zO/2MvQQ0Qmp8h9mhE9zmr51I6dT+nYH61MWTV280ELRL7xx0ylgW+zMTU9zC
         7egA==
X-Gm-Message-State: AOAM5325Jb71aLuj9h3jMr3ED6WSktp889yDySLkf4Azb0rJDqdvqmsn
        kZw4sUBG88evY9BSPp54/vCncb1r5PuKAyViiWteNVvlp9gcBaWb6UufBUrxoAz7GnjT8dkAGIB
        DrnpW2sh+zqul
X-Received: by 2002:a1c:2183:: with SMTP id h125mr8260908wmh.112.1591889269893;
        Thu, 11 Jun 2020 08:27:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJybUgRWiUuIG0MwV8QKdmngDG0hRIBA7dEUisc28nbd4b+WXjrTb/klVvugUgYwmfSnG7C9AA==
X-Received: by 2002:a1c:2183:: with SMTP id h125mr8260888wmh.112.1591889269567;
        Thu, 11 Jun 2020 08:27:49 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:29ed:810e:962c:aa0d? ([2001:b07:6468:f312:29ed:810e:962c:aa0d])
        by smtp.gmail.com with ESMTPSA id l17sm5621237wrq.17.2020.06.11.08.27.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2020 08:27:49 -0700 (PDT)
Subject: Re: [PATCH] KVM: check userspace_addr for all memslots
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>
References: <20200601082146.18969-1-pbonzini@redhat.com>
 <dde19d595336a5d79345f3115df26687871dfad5.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b97854bd-ff63-71ee-3c27-2602326a26b8@redhat.com>
Date:   Thu, 11 Jun 2020 17:27:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <dde19d595336a5d79345f3115df26687871dfad5.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/06/20 16:44, Maxim Levitsky wrote:
> On Mon, 2020-06-01 at 04:21 -0400, Paolo Bonzini wrote:
>> The userspace_addr alignment and range checks are not performed for private
>> memory slots that are prepared by KVM itself.  This is unnecessary and makes
>> it questionable to use __*_user functions to access memory later on.  We also
>> rely on the userspace address being aligned since we have an entire family
>> of functions to map gfn to pfn.
>>
>> Fortunately skipping the check is completely unnecessary.  Only x86 uses
>> private memslots and their userspace_addr is obtained from vm_mmap,
>> therefore it must be below PAGE_OFFSET.  In fact, any attempt to pass
>> an address above PAGE_OFFSET would have failed because such an address
>> would return true for kvm_is_error_hva.
>>
>> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> I bisected this patch to break a VM on my AMD system (3970X)
> 
> The reason it happens, is because I have avic enabled (which uses
> a private KVM memslot), but it is permanently disabled for that VM,
> since I enabled nesting for that VM (+svm) and that triggers the code
> in __x86_set_memory_region to set userspace_addr of the disabled
> memslot to non canonical address (0xdeadull << 48) which is later rejected in __kvm_set_memory_region
> after that patch, and that makes it silently not disable the memslot, which hangs the guest.
> 
> The call is from avic_update_access_page, which is called from svm_pre_update_apicv_exec_ctrl
> which discards the return value.
> 
> 
> I think that the fix for this would be to either make access_ok always return
> true for size==0, or __kvm_set_memory_region should treat size==0 specially
> and skip that check for it.

Or just set hva to 0.  Deletion goes through kvm_delete_memslot so that
dummy hva is not used anywhere.  If we really want to poison the hva of
deleted memslots we should not do it specially in
__x86_set_memory_region.  I'll send a patch.

Paolo

