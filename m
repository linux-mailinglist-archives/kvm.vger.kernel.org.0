Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7927723CEE4
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 21:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbgHETIQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 15:08:16 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:47347 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728497AbgHES4u (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Aug 2020 14:56:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596653785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hymn0Sfg1TJ19WBAjozBxwIK1aOHio4HHWImCGmRqUw=;
        b=YY4oq6dvmNz2EbdHNw/P43Fm3eXDoTuVyqNvrBPvFcuMyX2c2r2fz0cNiacmmnDN+n6tpt
        8teVDQxcXr3vPKscbjXT7pKvVJ7w/mXkmsOt/Zb4KaLd75zcQDvwXTX4/hKvJ7o+MKDhLD
        B0KOsxJj7JIw0R1xyIGmqbFHeUPCueA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-6zfyguSoNgW2lCmetZhJGQ-1; Wed, 05 Aug 2020 14:48:06 -0400
X-MC-Unique: 6zfyguSoNgW2lCmetZhJGQ-1
Received: by mail-wr1-f70.google.com with SMTP id 89so13853376wrr.15
        for <kvm@vger.kernel.org>; Wed, 05 Aug 2020 11:48:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hymn0Sfg1TJ19WBAjozBxwIK1aOHio4HHWImCGmRqUw=;
        b=hL8rmRJZi9mPay2MKswyvgjv5dQE206XlZ90Qr4PAd1R+2tiaQRRFXQJqbogdETSxM
         E8apWQBf0DKHA8mn+aDkYk+uhfeXX7Pk5xf3rPLix698X9xZqlE/3PPfcP+zkiDN+CNb
         KvtF5LsOJmHMTaJlqSrPP1P8ySDdgwuviotMJ7s6EFJEznTvd4C97if2HixPBi3GW+ej
         u10dr2v37rYJi5eB2UcxPqvQz3CDuOPCIWeFj8VSwDUO1ehpqHL0op1PTinJ664/Dyyd
         gNylKQN8ta+TWouLNsly5pfkC4z7iQBEkZRnBKzBMFOnrbz/qEF7IJ6XxToRrEOOFDLs
         AC9w==
X-Gm-Message-State: AOAM5307PlEylR/MumoSXuAPrZ3MqltYCnve2loHoQY8BAMu1wFqhzWd
        TuHJlXj6Xh+2TlSEsK9ckUv3IkSHMBt/VR+9u0GXiDyhrP2JrVJ6mMsaSR8FNgLT3H/Fo6cjYqs
        npQSCqq0erNem
X-Received: by 2002:a1c:286:: with SMTP id 128mr4206650wmc.37.1596653284954;
        Wed, 05 Aug 2020 11:48:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxMFtqWVfa9ps/xQ0YYj/MHXx500Q/j+ugxOTprbSKK6roqR5QcQxjQa6u8ZT4SfEKfWTMCUg==
X-Received: by 2002:a1c:286:: with SMTP id 128mr4206635wmc.37.1596653284682;
        Wed, 05 Aug 2020 11:48:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7841:78cc:18c6:1e20? ([2001:b07:6468:f312:7841:78cc:18c6:1e20])
        by smtp.gmail.com with ESMTPSA id l18sm3776157wrm.52.2020.08.05.11.48.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2020 11:48:03 -0700 (PDT)
Subject: Re: [PATCH 1/1] kvm: mmu: zap pages when zapping only parent
To:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Peter Shier <pshier@google.com>
References: <20200727203324.2614917-1-bgardon@google.com>
 <20200804211444.GA31916@linux.intel.com>
 <CANgfPd9kbnzW+eaBi+dwA1+E2VXEd6JfN4n2PstWrmh4VPRFjA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cf54ab19-611c-c975-8080-b49e13c966f3@redhat.com>
Date:   Wed, 5 Aug 2020 20:48:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CANgfPd9kbnzW+eaBi+dwA1+E2VXEd6JfN4n2PstWrmh4VPRFjA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/08/20 19:10, Ben Gardon wrote:
>>
>> Alternatively, what about moving this logic into mmu_page_zap_pte()?  That
>> can be done with a little massaging of FNAME(invlpg) and would avoid what is
>> effectively redundant checks on is_shadow_present_pte() and is_last_spte().
>> Patches attached and somewhat tested.
> That seems like a good change to me and the patches you attached look
> good to me. I'm happy to review them more if you want to send them to
> the mailing list as their own series. Thanks for putting them
> together.
> 

Thanks, I'll wait for that.

Paolo

