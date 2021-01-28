Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 785A530793C
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 16:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbhA1PMh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 10:12:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59645 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232511AbhA1PL2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 10:11:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611846602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hhj0Ci4ubmUQAoG6OK5IyEkrRViQ/scCNDoyVb3q4mQ=;
        b=NR3dnObxx8Eihp52ZBg7xx6uODXZTAQrz8M00b1FoBBTgoAm7TVGTS1c6wpaB7k4HXfG+W
        gYx44Sh5QdE/IW5yqbWCNQCNXaBQPTIUP+Ux6uSZhinQpk14oWB9iI4GesP/kkCsO5fj5H
        5Me+JHF0rGuPjYfSTx/Y+RW1WqsvXEo=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-_Lc6Vl1LOPys18dWiahEYg-1; Thu, 28 Jan 2021 10:10:00 -0500
X-MC-Unique: _Lc6Vl1LOPys18dWiahEYg-1
Received: by mail-ej1-f72.google.com with SMTP id m4so2307971ejc.14
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 07:09:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Hhj0Ci4ubmUQAoG6OK5IyEkrRViQ/scCNDoyVb3q4mQ=;
        b=IulpF1MeioO9XPFUPQkxOZq3cTm10B4GQJNaOaDmM03PKo8WGmGWZOBiXmgVvNoWRK
         04uB5dXcsvRciSfG9fE91FM2+8RtdXbLI3yR8fgrdPZCle29DBo3HoTr26PIPilTj6Kw
         nCzOYwE8Mbd/iOBEqjjXK5THRrpCsbqhov6KUynkrw9U4+LOrfAK29eYe90GHc0QcoKq
         x3d2RJXyj6LLl6nultZCVQC+AOtEiwDhFbPpPuRqTL9jWfs0cDb4IhqHD7SnO8jAxhOh
         Tpi9LO3H9ncmrofMHQmguODGi0ByIglsQwH6UnpPO5aCKVGyh0ojAmvtQDiNgBpJsEUm
         tjCw==
X-Gm-Message-State: AOAM530Ew6Lt8w11sJSn/frQ3fDMhn5HR9hjiKd6NV8jKe1bEiUr2HWO
        IWKaBBZkRiVGZsTndpRSFM6JMtie7IvF2zmRxPAlvfxK33OOik5Ory6t2Vcwckn/hqXJ4TPT93I
        xzlm6hSsfdPjm
X-Received: by 2002:a05:6402:3487:: with SMTP id v7mr14873148edc.68.1611846597817;
        Thu, 28 Jan 2021 07:09:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx1REmvoZPIJf+xL+eFSS8Ak+MJ/YNFFHwKFPfHuNuoqq5vaw2RU+a2VckY/qs6e13g6PjcYA==
X-Received: by 2002:a05:6402:3487:: with SMTP id v7mr14873116edc.68.1611846597610;
        Thu, 28 Jan 2021 07:09:57 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s22sm2381402ejd.106.2021.01.28.07.09.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 07:09:56 -0800 (PST)
Subject: Re: [PATCH v2 04/14] x86/cpufeatures: Assign dedicated feature word
 for AMD mem encryption
To:     Borislav Petkov <bp@suse.de>,
        Sean Christopherson <seanjc@google.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20210114003708.3798992-1-seanjc@google.com>
 <20210114003708.3798992-5-seanjc@google.com> <20210114113528.GC13213@zn.tnic>
 <YAB6yLXb4Es+pJ8G@google.com> <20210114171631.GD13213@zn.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c177d918-7421-9441-fb24-45ffe46f8298@redhat.com>
Date:   Thu, 28 Jan 2021 16:09:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210114171631.GD13213@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/01/21 18:16, Borislav Petkov wrote:
> On Thu, Jan 14, 2021 at 09:09:28AM -0800, Sean Christopherson wrote:
>> Hmm, patch 05/14 depends on the existence of the new word.  That's a non-issue
>> if you're planning on taking this for 5.11.  If it's destined for 5.12, maybe
>> get an ack from Paolo on patch 05 and take both through tip?
> 
> Yeah, I guess that. Both are not urgent 5.11 material to take 'em now.
> So I guess I'll wait for Paolo's ACK.

If you think this patch is valuable go ahead and pick it.  I can wait 
until after the merge window to queue patch 5.  It is independent from 
the others and I had questions, so I am just queuing the others for 5.12.

Paolo

>> I can drop them from this series when I send v3. In hindsight, I
>> should have split these two patches into a separate mini-series from
>> the get-go.
> 
> Nah, no worries. We do patch acrobatics on a daily basis. :-)

