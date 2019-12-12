Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2117011C6D4
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 09:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbfLLIMK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 03:12:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53581 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728150AbfLLIMK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 03:12:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576138329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3vbKumHRhYv4hi2VaZ7lUNT3xifUzCtPM0UHF+6l3NA=;
        b=RKc0WyrgCu87JJ6B2k6WKHdDUJtltniPy+8EuVvBgTbjq6DSG0OGzD9Sc+/AC9meLkWa/4
        9//MUBhSAvhIdzudevdODc2av492nKnzSxQCP3D46nG9/2OZ6m0YQQ4+oL1fMw1HC6Bjm0
        KyqmNRReKrCfEq8hVpTU3S5tca+BCYw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-S9tzEtohPRuP2KtsF7Y_6A-1; Thu, 12 Dec 2019 03:12:07 -0500
X-MC-Unique: S9tzEtohPRuP2KtsF7Y_6A-1
Received: by mail-wr1-f72.google.com with SMTP id f10so720329wro.14
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2019 00:12:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3vbKumHRhYv4hi2VaZ7lUNT3xifUzCtPM0UHF+6l3NA=;
        b=Ew6LJvjt6eggeOwZB25Gtfq8gju2IhD5tkRpopZVh4LEzAoY8KJIKrfuEgJzqV//Kr
         HOY1eEd8xtlMsKuThC1/vNcibRqKM5lCbLuDHHS5+R40UzJ86OXCVV1BT4DClpmYih3q
         QUgxnPA+KPg8CuozqbpyLhfjbn5iZ03ZOiOiTX9hN8Af93v7lgCHLhG20+K63in3TTqt
         SQ/1Lx870SWVeIiEMoAni7f7hVlHmrO+D0wcRFB23dEX6ICpQwsjwmOBSmjN0CnxAWRS
         mN7mAnpB9r+vA9bRPrSB95i1j8iMVhssr9YnRNsjCymuI0RzFIGkt3+pMn5M8k5IR56x
         QJcw==
X-Gm-Message-State: APjAAAW2Cjj5o8A5ufOJffzZL2x5QprmJlDdJJRMYNdyPZk79mChGkBh
        wEunZwTwrvIUSH+holPXwORAGCoPr036NqtSA+NBUWt2LszE+m10ds8b4raWPJNv9ucIK34KOyI
        C0Vos818e7MaE
X-Received: by 2002:adf:fbc9:: with SMTP id d9mr4916140wrs.20.1576138326655;
        Thu, 12 Dec 2019 00:12:06 -0800 (PST)
X-Google-Smtp-Source: APXvYqzxhPY9tb9EraSB3/G5RixEIryJ8sYFEuzvoUZhFyLUeSxfGbn39kUpvyoDawp63DhfWRplrA==
X-Received: by 2002:adf:fbc9:: with SMTP id d9mr4916109wrs.20.1576138326388;
        Thu, 12 Dec 2019 00:12:06 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id g9sm5198355wro.67.2019.12.12.00.12.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2019 00:12:05 -0800 (PST)
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <20191211063830-mutt-send-email-mst@kernel.org> <20191211205952.GA5091@xz-x1>
 <20191211172713-mutt-send-email-mst@kernel.org>
 <46ceb88c-0ddd-0d9a-7128-3aa5a7d9d233@redhat.com>
 <20191212023154-mutt-send-email-mst@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <74edef57-c1c7-53cb-4b93-291d9f816688@redhat.com>
Date:   Thu, 12 Dec 2019 09:12:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191212023154-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/12/19 08:36, Michael S. Tsirkin wrote:
> On Thu, Dec 12, 2019 at 01:08:14AM +0100, Paolo Bonzini wrote:
>>>> I'd say it won't be a big issue on locking 1/2M of host mem for a
>>>> vm...
>>>> Also note that if dirty ring is enabled, I plan to evaporate the
>>>> dirty_bitmap in the next post. The old kvm->dirty_bitmap takes
>>>> $GUEST_MEM/32K*2 mem.  E.g., for 64G guest it's 64G/32K*2=4M.  If with
>>>> dirty ring of 8 vcpus, that could be 64K*8=0.5M, which could be even
>>>> less memory used.
>>>
>>> Right - I think Avi described the bitmap in kernel memory as one of
>>> design mistakes. Why repeat that with the new design?
>>
>> Do you have a source for that?
> 
> Nope, it was a private talk.
> 
>> At least the dirty bitmap has to be
>> accessed from atomic context so it seems unlikely that it can be moved
>> to user memory.
> 
> Why is that? We could surely do it from VCPU context?

Spinlock is taken.

>> The dirty ring could use user memory indeed, but it would be much harder
>> to set up (multiple ioctls for each ring?  what to do if userspace
>> forgets one? etc.).
> 
> Why multiple ioctls? If you do like virtio packed ring you just need the
> base and the size.

You have multiple rings, so multiple invocations of one ioctl.

Paolo

