Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0421DF563
	for <lists+kvm@lfdr.de>; Sat, 23 May 2020 09:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387667AbgEWHHu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 May 2020 03:07:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22945 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387661AbgEWHHu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 May 2020 03:07:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590217668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=70hlERzGDZeQinZgjimkVAxNg2FOuupLb6i0Dut22jk=;
        b=Gm7+ligHjUkTyq2y/ZVtyDE61d1ls8OyVaPPUYk6/RL3JmOpHSGSnjcCAt19Luzxt3Mv6Y
        WkZUbjnp9i1OOboqXqyAZY0C0AeU9eL9nzSzwuO6wTGS7I/7o+6wKV7e7Yu1sOvzgSWPFB
        R0HlZG5g8TuAsjgzzXgXk9U8ehdoUWQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-91-ev-hIIXgMaKzd-a5Nc2xQQ-1; Sat, 23 May 2020 03:07:46 -0400
X-MC-Unique: ev-hIIXgMaKzd-a5Nc2xQQ-1
Received: by mail-ed1-f71.google.com with SMTP id df5so4587578edb.0
        for <kvm@vger.kernel.org>; Sat, 23 May 2020 00:07:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=70hlERzGDZeQinZgjimkVAxNg2FOuupLb6i0Dut22jk=;
        b=fSI8fWNruD8vUpSV/INBtIzAS86/DrY9n7UNwNGqb8b4dyihGC4fj3obyQrYxj9qL7
         XzlSoPSxWASytDI0iiaE+1tb9ybCJRlQy8hTDMIoEONC1xiqoIszyhMpgMFkk9g5V1qc
         NN/+mY1U9lAuEEK1th1pRkpSUEgyBQhUsAbwEs+v+hF8JML0iT9xyG6xapg8WUa/5rfP
         i/cWXaMZCsmzSQrJNWu7/02TcTvrdyE8Jb6owm6Am4xxlolNqy+O3gtIL8E8jWtSdwno
         WMRlDEo1TwiQp9DWjo1E9MJBcG1rP8CQrkM4qM096RVkdqJUAdZsKk8N0q3dhJi6/Dxp
         XsUA==
X-Gm-Message-State: AOAM531OHbsQAQov/kbF/Y4YG5CeuWlDXzs+8ZBbvJXk9Ta9x1V/Pp9r
        Kq+6tHLoczZGvRIa2Xjg7L1N4kM8GoDqi2rdTwzDxl0ifcFSHtu4+/5Ux8LoRojOmvTnXfCF6MU
        Io2F8JQi7sG7E
X-Received: by 2002:a17:906:81c6:: with SMTP id e6mr10809922ejx.241.1590217665095;
        Sat, 23 May 2020 00:07:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyK4WzufDbtJf0j428CvNaKQEncvtUDgK8bDXpnzoSoQlHZuzzWxyPxlBZ5a9UE6y9mz/wF1Q==
X-Received: by 2002:a17:906:81c6:: with SMTP id e6mr10809903ejx.241.1590217664779;
        Sat, 23 May 2020 00:07:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:803:ce64:3f04:d540? ([2001:b07:6468:f312:803:ce64:3f04:d540])
        by smtp.gmail.com with ESMTPSA id s17sm9575061edr.84.2020.05.23.00.07.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 May 2020 00:07:44 -0700 (PDT)
Subject: Re: [PATCH 21/24] KVM: x86: always update CR3 in VMCB
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, Joerg Roedel <jroedel@suse.de>
References: <20200520172145.23284-1-pbonzini@redhat.com>
 <20200520172145.23284-22-pbonzini@redhat.com>
 <20200520182202.GB18102@linux.intel.com>
 <d85c2e1d-93b3-186d-7df4-80ae6aa03618@redhat.com>
 <20200522224711.GF25128@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <31e88353-e073-83b3-2e56-6a8e85746d7c@redhat.com>
Date:   Sat, 23 May 2020 09:07:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200522224711.GF25128@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/05/20 00:47, Sean Christopherson wrote:
> On Wed, May 20, 2020 at 10:14:47PM +0200, Paolo Bonzini wrote:
>> This patch should probably be split too, so that the Fixes tags are
>> separate for Intel and AMD.
> 
> That would be nice.

Will do.  Anyway this series will be quite different in v2, and there
will be a couple more changes to common code to avoid repeated calls to
kvm_cpu_has_injectable_intr (because on AMD I'd like to avoid
unnecessary calls to enable_irq_window, it is already complicated enough
without those).

Paolo

