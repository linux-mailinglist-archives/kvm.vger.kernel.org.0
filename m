Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7199217C065
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 15:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbgCFOju (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 09:39:50 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:34446 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726054AbgCFOju (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Mar 2020 09:39:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583505588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dyVmr7aNt8RWb7ivdXkwQxg3/2gkQb2bOSMC9koKSyU=;
        b=IH7rWHX5jGxv4qqRgMgZg+FRONCsGmHjY4/F4eoeKaDQMHY1bZGza7k0liD25KphEh87UN
        38utyKApL+ejMuvtD6+Wfo1Ez9cFqa4PT54JP7+wu59U68JUXz7r8xl7xKTnhmp9jSVxm9
        pVQSkJOtS0xmOCOM+TKfjLKjZfrU3vw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-BC1d8YM8N26GR4rlcd_fAA-1; Fri, 06 Mar 2020 09:39:46 -0500
X-MC-Unique: BC1d8YM8N26GR4rlcd_fAA-1
Received: by mail-wr1-f72.google.com with SMTP id p11so1080103wrn.10
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2020 06:39:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dyVmr7aNt8RWb7ivdXkwQxg3/2gkQb2bOSMC9koKSyU=;
        b=eoKTaOLUjwKjFk73byBedFV9yBP9TNimj6zX9WqdNWNcg7uM9oVh3xQmW8lv+NJ9FX
         NMTXs5v60dVKgtbIsFgLH1kWLqsaWbDKdWG7KHAkj9XfaVZbxOQEQ15LUdJuMzRx3oPZ
         P+mrFBHU/1OJotFtN6oflSrs3+5U033YwTjx8V46QhCwBtfFRULZNHhYUo1CU8LtwUEj
         lsvaSwQ+Wx1tV3BCtEb8P+ddMNFyj7Q0KWOareyJKmtt7A73x4lvEUuoNVvHQ008mDMx
         ILWy+OW/YoftB8wz94kLNJx+SnKrcW3U6FaSYC53uVOlF2eUdHcMjaVg7eaXWEPoctiW
         4s5Q==
X-Gm-Message-State: ANhLgQ1wUIi3v1D0qyX4iFR7uqd11KtnzI7TKRhIUUYYIoaMbxFr9ohQ
        2BU8vZaep3lQijkxjzC7Tt6oxs2uh4y08JLLPPGI1J2hnxPucss+szDHX6/B7cSkgRb2o2m/1ps
        mjIbUOZsBHnZc
X-Received: by 2002:a5d:4384:: with SMTP id i4mr4323116wrq.396.1583505581124;
        Fri, 06 Mar 2020 06:39:41 -0800 (PST)
X-Google-Smtp-Source: ADFU+vvaDWb7pBEzAZ78eCr8V+iO9t8Fp1wpAzMpXGVG1XSGWO2upieUdHbVIp58sVbwLcZ3gXAxFA==
X-Received: by 2002:a5d:4384:: with SMTP id i4mr4323100wrq.396.1583505580881;
        Fri, 06 Mar 2020 06:39:40 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:8cd7:8509:4683:f03a? ([2001:b07:6468:f312:8cd7:8509:4683:f03a])
        by smtp.gmail.com with ESMTPSA id m21sm13636090wmi.27.2020.03.06.06.39.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2020 06:39:40 -0800 (PST)
Subject: Re: [PATCH RFC 4/4] kvm: Implement atomic memory region resizes via
 region_resize()
To:     David Hildenbrand <david@redhat.com>, qemu-devel@nongnu.org
Cc:     Richard Henderson <rth@twiddle.net>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org
References: <20200303141939.352319-1-david@redhat.com>
 <20200303141939.352319-5-david@redhat.com>
 <102af47e-7ec0-7cf9-8ddd-0b67791b5126@redhat.com>
 <3b67a5ba-dc21-ad42-4363-95bb685240b9@redhat.com>
 <2a8d8b63-d54f-c1e7-9668-5d065e36aa1d@redhat.com>
 <d5704319-e9b8-be6b-6c95-d2e2edc6614c@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2b1d9549-5564-94e6-a55f-ca80996c6ef9@redhat.com>
Date:   Fri, 6 Mar 2020 15:39:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <d5704319-e9b8-be6b-6c95-d2e2edc6614c@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/03/20 15:30, David Hildenbrand wrote:
>> Assuming we're only talking about CPU ioctls (seems like a good
>> approximation) maybe you could use start_exclusive/end_exclusive?  The
>> current_cpu->in_exclusive_context assignments can be made conditional on
>> "if (current_cpu)".
>>
>> However that means you have to drop the BQL, see
>> process_queued_cpu_work.  It may be a problem.
>>
> Yeah, start_exclusive() is expected to be called without the BQL,
> otherwise the other CPUs would not be able to make progress and can
> eventually be "caught".
> 
> It's essentially the same reason why I can't use high-level
> pause_all_vcpus()/resume_all_vcpus(). Will drop the BQL which is very
> bad for resizing code.

But any other synchronization primitive that you do which blocks all
vCPUs will have the same issue, otherwise you get a deadlock.

Paolo

