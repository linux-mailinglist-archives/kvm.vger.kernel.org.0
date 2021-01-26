Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDA9C303EE4
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 14:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392670AbhAZNjP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 08:39:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36101 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728794AbhAZNjE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 08:39:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611668257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8TyWVTjlaOo6oRIw2dkI6QGbyH0y/a53XlLXFFwcB34=;
        b=aIXm+SlsOKpZCEoj/7cLHerYh/Wt8DRdCuRM2R50rFD1Rfny+D4EKmAnC1+rp+0jq02BFI
        /KfNaSytc766zizjBBOAsdgFmO0pHkL4QsWU0G7oOt6XMFsYllUxvhX0w8WUFoXkNlwVI5
        DFrnoUUtYihiOzEpWYSKFgCAjZguidI=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-Rr0Ifz4oOCWF9S1tAXW_pQ-1; Tue, 26 Jan 2021 08:37:35 -0500
X-MC-Unique: Rr0Ifz4oOCWF9S1tAXW_pQ-1
Received: by mail-ed1-f72.google.com with SMTP id ck25so9328268edb.16
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 05:37:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8TyWVTjlaOo6oRIw2dkI6QGbyH0y/a53XlLXFFwcB34=;
        b=WJNsg12qDBsPIxlomoAh/F7iTL8M7fcLZc/Pjfi8lvAU2vep8kPr3hWGoUahxoJgC9
         JDSEk4AZ83PqsG2rWxEoc7qS5+wHwgr+20fQdsCf+5QfGc1U/TwMquOp84rRsellWaCh
         MvIlMRGZ9gQASmEOlHl9jX7H0RfPiIvrgWk2SkHwNl6USBkESCsweGugobIpDofS9IAl
         hnhN+ZnhBXO2mn93SfyDeN90Uo7zcpA0VjafTHtr59w06dnnjtOxkeitEC6ohEvHOa9q
         dMmHMBNJygbA5KkixhRkeI7artOcYczxl6vljX0ObIFN7O52NP+OVzZC2BFuPLzonkKL
         VALQ==
X-Gm-Message-State: AOAM533CpNczJlmbBtlat+O3Wz/TRt0eibZU3DIu7WT0YbGz2ZpuwjuD
        ni1871Zf0mZo+dTvoPuMzBm9VL6RQ2dnXPgS8w/dy6R3cxLYr1muGysC9JNGPJWCwDX2wTBL9F9
        aPJY9ni0dMhjR
X-Received: by 2002:a17:907:9483:: with SMTP id dm3mr3437688ejc.120.1611668254634;
        Tue, 26 Jan 2021 05:37:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxGyzK0fAsrFSstAx+t/GMMgs8MBxN3xGakklU4iQlGLozOsBNIZgExzL4/3isBPTc7H3Ke1w==
X-Received: by 2002:a17:907:9483:: with SMTP id dm3mr3437672ejc.120.1611668254470;
        Tue, 26 Jan 2021 05:37:34 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id i15sm9866203ejj.28.2021.01.26.05.37.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 05:37:33 -0800 (PST)
Subject: Re: [PATCH 19/24] kvm: x86/mmu: Protect tdp_mmu_pages with a lock
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20210112181041.356734-1-bgardon@google.com>
 <20210112181041.356734-20-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <14147680-740d-6e7f-e00d-aa7698fd2ba6@redhat.com>
Date:   Tue, 26 Jan 2021 14:37:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210112181041.356734-20-bgardon@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/01/21 19:10, Ben Gardon wrote:
> +	 *  May be acquired under the MMU lock in read mode or non-overlapping
> +	 *  with the MMU lock.
> +	 */
> +	spinlock_t tdp_mmu_pages_lock;

Is this correct?  My understanding is that:

- you can take tdp_mmu_pages_lock from a shared MMU lock critical section

- you don't need to take tdp_mmu_pages_lock from an exclusive MMU lock 
critical section, because you can't be concurrent with a shared critical 
section

- but then, you can't take tdp_mmu_pages_lock outside the MMU lock, 
because you could have

    write_lock(mmu_lock)
                                      spin_lock(tdp_mmu_pages_lock)
    do tdp_mmu_pages_lock stuff  !!!  do tdp_mmu_pages_lock stuff
    write_unlock(mmu_lock)
                                      spin_unlock(tdp_mmu_pages_lock)

Paolo

