Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7045B26717
	for <lists+kvm@lfdr.de>; Wed, 22 May 2019 17:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729656AbfEVPog (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 May 2019 11:44:36 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44864 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729596AbfEVPog (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 May 2019 11:44:36 -0400
Received: by mail-wr1-f68.google.com with SMTP id w13so2836961wru.11
        for <kvm@vger.kernel.org>; Wed, 22 May 2019 08:44:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zciqsdHVLeO85LYnRcsvsjpGRr1sFPeogPhHXDz4c/8=;
        b=Oo+SGnw5WIgAYB45CzCX/HuA8EnwMNtTUsC6DOWPiJrhb77XdL9pzdHPQvCkNbUzvA
         6bwkcJ3YIvyHAsNMob8ftjkx2yAYFxPJB1EYAUNqsIKrz4F3Eg5J1aDxBZWZh8dP2kbu
         RN5NJFXXjM4b8mgB7u8EO4R5l+Mz5NCDeB7vPMQdNTwAYRLQbP2vQ+QA1xG4ohyE4oHJ
         SUXMvrR+8gStVwSosdGbpjGBE2jC4hH9jRUc7sykjgCsN6KZRw/v2phjQMBCNeBNWDEu
         VXA1Ao3qEYIcghy+HVjK9m5JplEi2FzQ+tZCiXHByereXLpGKm9vsovuZH4/Munmn2eA
         jLuw==
X-Gm-Message-State: APjAAAWQPlqqCTeocCEYcLC8gNevaRa+m0Oi2FX2udH7pzlZr0XInP3s
        JPKcK0U7k8AdT6z+sOqurqw1Tw==
X-Google-Smtp-Source: APXvYqxLgjoR40ZOAA6aiYgPWGuiGMefP8jEl4YQlssdlmVqcpuIC6D+vWrKqxCzmQjZeM1pkDHb4w==
X-Received: by 2002:adf:dcc8:: with SMTP id x8mr8548758wrm.3.1558539875389;
        Wed, 22 May 2019 08:44:35 -0700 (PDT)
Received: from [10.32.181.147] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id x6sm37203048wru.36.2019.05.22.08.44.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 08:44:34 -0700 (PDT)
Subject: Re: [PATCH] x86: add cpuidle_kvm driver to allow guest side halt
 polling
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm-devel <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <kernellwp@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>
References: <20190517174857.GA8611@amt.cnet>
 <fd5caf49-6d98-4887-0052-ccbc999fc077@redhat.com>
 <20190522150451.GA2317@amt.cnet>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fa7a52af-4cd4-9c60-7a16-138bd0a14de0@redhat.com>
Date:   Wed, 22 May 2019 17:44:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190522150451.GA2317@amt.cnet>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/05/19 17:04, Marcelo Tosatti wrote:
> Consider sequence of wakeup events as follows:
> 20us, 200us, 20us, 200us...

I agree it can happen, which is why the grow/shrink behavior can be
disabled for halt_poll_ns.  Is there a real-world usecase with a
sequence like this?

The main qualm I have with guest-side polling is that it encourages the
guest admin to be "impolite".  But I guess it was possible even now to
boot guests with idle=poll, which would be way more impolite...

Paolo

> If one enables guest halt polling in the first place,
> then the energy/performance tradeoff is bend towards
> performance, and such misses are harmful.
> 
> So going to add something along the lines of:
> 
> "If, after 50 consecutive times, block_time is much larger than
> halt_poll_ns, then set cpu->halt_poll_ns to zero".
> 
> Restore user halt_poll_ns value once one smaller block_time
> is observed.
> 
> This should cover the full idle case, and cause minimal
> harm to performance.
> 
> Is that OK or is there any other characteristic of
> adaptive halt poll you are looking for?

