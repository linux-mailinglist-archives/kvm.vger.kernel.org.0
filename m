Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2648E8C227
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 22:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbfHMUhS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 16:37:18 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45169 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbfHMUhS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 16:37:18 -0400
Received: by mail-wr1-f68.google.com with SMTP id q12so18717630wrj.12
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 13:37:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fXQYOy/yjTf1vLfsL/bRWAaIklMscCyyRDl7sqhaYGE=;
        b=gOgPGRqvkllQg2IFdeNAsGCDjoeaQq7kMRV2RH0EIeJikDoV8zUeMH6guySPTGjb+h
         83UIB3afw+l/QXuq2o8ewBlKYEtEWPu5p12Y1NujcufJpeSh0hg1925IJuhEnTNs5zUd
         SLK+04+eB5R7Co+Jz0boe5MSedL9gUUPOTuglLnPaLPku8tdu0XR6wLo64Aqqx0qxhWh
         5G7UVtjXZYo7ZB0ZGCgGk7+ZpxS+ULgu1jDgUPBuYk6PUEUeWYs6oxXcZz9IM7nRt23w
         wMUXQfAAnnhyjh+x8/4F+Pc4ON77n1bZB6U8EV5N+rNEsYlUWOw/RxUq5u/6ecM3oesS
         /MAg==
X-Gm-Message-State: APjAAAU56ultabx4TXBP6TjJymCDUdY2cjrOdD2aPspkF10nijSounxy
        FzUtuJzGSV8h7vLK+u3PuIiXtA==
X-Google-Smtp-Source: APXvYqwTwI46jFjqiIJAHNAQxZG7HOY2JutzJEBlH32tv9eokjCMINkLnGxtcyogXnRo7K6eyXRNzg==
X-Received: by 2002:a5d:528d:: with SMTP id c13mr47743533wrv.247.1565728636150;
        Tue, 13 Aug 2019 13:37:16 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5193:b12b:f4df:deb6? ([2001:b07:6468:f312:5193:b12b:f4df:deb6])
        by smtp.gmail.com with ESMTPSA id 39sm23788092wrc.45.2019.08.13.13.37.14
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 13:37:15 -0700 (PDT)
Subject: Re: [PATCH v2 11/27] KVM: x86/mmu: Zap only the relevant pages when
 removing a memslot
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Xiao Guangrong <guangrong.xiao@gmail.com>
References: <20190205205443.1059-1-sean.j.christopherson@intel.com>
 <20190205210137.1377-11-sean.j.christopherson@intel.com>
 <20190813100458.70b7d82d@x1.home> <20190813170440.GC13991@linux.intel.com>
 <20190813115737.5db7d815@x1.home> <20190813133316.6fc6f257@x1.home>
 <20190813201914.GI13991@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <cd9e5c9d-a321-b2f3-608d-0b8f74a5075f@redhat.com>
Date:   Tue, 13 Aug 2019 22:37:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190813201914.GI13991@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/08/19 22:19, Sean Christopherson wrote:
> Yes?  Shadow pages are stored in a hash table, for_each_valid_sp() walks
> all entries for a given gfn.  The sp->gfn check is there to skip entries
> that hashed to the same list but for a completely different gfn.
> 
> Skipping the gfn check would be sort of a lightweight zap all in the
> sense that it would zap shadow pages that happend to collide with the
> target memslot/gfn but are otherwise unrelated.
> 
> What happens if you give just the GPU BAR at 0x80000000 a pass, i.e.:
> 
> 	if (sp->gfn != gfn && sp->gfn != 0x80000)
> 		continue;
> 
> If that doesn't work, it might be worth trying other gfns to see if you
> can pinpoint which sp is being zapped as collateral damage.
> 
> It's possible there is a pre-existing bug somewhere else that was being
> hidden because KVM was effectively zapping all SPTEs during (re)boot,
> and the hash collision is also hiding the bug by zapping the stale entry.
> 
> Of course it's also possible this code is wrong, :-)

Also, can you reproduce it with one vCPU?  This could (though not really
100%) distinguish a missing invalidation from a race condition.

Do we even need the call to slot_handle_all_level?  The rmap update
should be done already by kvm_mmu_prepare_zap_page (via
kvm_mmu_page_unlink_children -> mmu_page_zap_pte -> drop_spte).

Alex, can you replace it with just "flush = false;"?

Thanks,

Paolo
