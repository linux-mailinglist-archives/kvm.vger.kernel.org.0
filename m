Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0AE22AAAAE
	for <lists+kvm@lfdr.de>; Sun,  8 Nov 2020 12:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbgKHLXg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Nov 2020 06:23:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21828 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727348AbgKHLXe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 8 Nov 2020 06:23:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604834613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kK7wQQ53oSka40mp7QzYkAA57zy/9qtuGomTT4kIpYI=;
        b=fmmcRIJrGZNYp2Qta9V7lrjDbf7kmp/9JpkRXKeGDP0+Nqn4iVUskIlMiNH1itKHYSUfTO
        NP0bDmXfXs2xJ/CACPc3npUsmCbRYtaGuca7y7NUBeAUwmBdORX2zL9qFcWTTTxziYN1/T
        I8BJkETw0+c0jmj6yLD90YDQOsKjC9s=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-p2xU-qNcPCK_hZi_18fTZg-1; Sun, 08 Nov 2020 06:23:30 -0500
X-MC-Unique: p2xU-qNcPCK_hZi_18fTZg-1
Received: by mail-ej1-f72.google.com with SMTP id p19so2551343ejy.11
        for <kvm@vger.kernel.org>; Sun, 08 Nov 2020 03:23:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kK7wQQ53oSka40mp7QzYkAA57zy/9qtuGomTT4kIpYI=;
        b=A6z6Ja/qlpo8IPmNEq5EDIfGcpWbe9iM1ZdrHGNNNHHbAy+WibVJChBf+7W12t52BS
         91mo2DGOHs8CTykjghE4pSr7qjFoYAXQRBLZ80mYN95/LhcjzBWbhbDDjvVccSvP8yUQ
         DYMZJeAcqX7p+taKS10prmCsBzPFkwxyO+V5xj6GCFHH9pO0avl2t6bwB1GhH0kGJ7ox
         nY6JhVmnW6R6oQKgyzq4VhhqvDikZCH27DTTFbgU5xUobIu9BEsqnR2VE9mgvSzWZGkV
         rRsw0Hj0qwKKhuuDX+q3La6Y0kXZ+J6QdTqnuuTr8vO5I6jBcNw5slWmZf0TEH/eZ9zn
         6r5A==
X-Gm-Message-State: AOAM5333VYkDLaL0Mkdp8tna3QTUitji2/WZlJ1YEYuImhOdEt56jjwG
        yEp30I8QiDxmaVxvi8t7PD3Q97SDU+F9qQW4YdNGl0YZt1tNCayO+ayJfDy/xOELgIqE8qskimR
        w8fj8Du343Bag
X-Received: by 2002:a05:6402:3d9:: with SMTP id t25mr10598155edw.338.1604834609358;
        Sun, 08 Nov 2020 03:23:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw+DAcudGnhBWkKul66N68aDAIJeVrpT00S+qFBU5inTk55z2YADV4bsEFbGYyF+z6bk2xYyQ==
X-Received: by 2002:a05:6402:3d9:: with SMTP id t25mr10598144edw.338.1604834609191;
        Sun, 08 Nov 2020 03:23:29 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:73b1:3acc:3ebd:4fd4? ([2001:b07:6468:f312:73b1:3acc:3ebd:4fd4])
        by smtp.gmail.com with ESMTPSA id l8sm5819902ejk.67.2020.11.08.03.23.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Nov 2020 03:23:28 -0800 (PST)
Subject: Re: [PATCH] mm, kvm: account kvm_vcpu_mmap to kmemcg
To:     Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20201106202923.2087414-1-shakeelb@google.com>
 <20201106205245.GB2285866@carbon.dhcp.thefacebook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <67c2912d-e861-d660-61f0-912a72eff01d@redhat.com>
Date:   Sun, 8 Nov 2020 12:23:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201106205245.GB2285866@carbon.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/11/20 21:52, Roman Gushchin wrote:
> On Fri, Nov 06, 2020 at 12:29:23PM -0800, Shakeel Butt wrote:
>> A VCPU of a VM can allocate couple of pages which can be mmap'ed by the
>> user space application. At the moment this memory is not charged to the
>> memcg of the VMM. On a large machine running large number of VMs or
>> small number of VMs having large number of VCPUs, this unaccounted
>> memory can be very significant. So, charge this memory to the memcg of
>> the VMM. Please note that lifetime of these allocations corresponds to
>> the lifetime of the VMM.
>>
>> Signed-off-by: Shakeel Butt <shakeelb@google.com>
>> ---
> 
> Acked-by: Roman Gushchin <guro@fb.com>
> 
> Thanks, Shakeel!
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

If this patch is not merged via -mm, please ping me again once its 
dependency is part of Linus's tree.

Thanks,

Paolo

