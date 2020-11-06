Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC612A94EB
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 11:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbgKFK4v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 05:56:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36574 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727205AbgKFK4u (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Nov 2020 05:56:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604660209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pjlo5JUIOTDUV4ZXiqwdy+qZTg/eMHp+BKLRgYqZ8mE=;
        b=YKbDNetRgbdn2vcwhW+MuEfQwcfmWXMrj2pCeY4aOXhU5efkY6FGhkdkc1vgJzXx8gMJQo
        N01atffNGOVWyoO6Pc98BxSV5UzowOv8h8IRwB3FB//HyWdeAZX99p+qrwg/yXPSXszjpm
        fxk7+N6Khv2vi6sF/VQJDLmp+F1uFpg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-6ZpK2RyeP2ed1_BHIqDB1g-1; Fri, 06 Nov 2020 05:56:45 -0500
X-MC-Unique: 6ZpK2RyeP2ed1_BHIqDB1g-1
Received: by mail-wm1-f69.google.com with SMTP id e15so290398wme.4
        for <kvm@vger.kernel.org>; Fri, 06 Nov 2020 02:56:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Pjlo5JUIOTDUV4ZXiqwdy+qZTg/eMHp+BKLRgYqZ8mE=;
        b=hc3PMfp52fgwt7pSu/NNvFHwc4ryW2uksQ7nudBWgTorHlcGV17R6+bV73+BwYGv9z
         2MGK3X4z3azbuXGJ3k/JXhUiFtttGVvZ9u+mT49TEMActm+n3KHC6cmtrh8ZsSmhG9Ul
         A0xmVut+OtLLQBkGfwce1C7QmqPpxjbZdaqKieToTcrrSYe1n6cvOMFsyQytpSCKnJSs
         TIiMnn5odgyxxN5B2K6qwJvoha45668EkV+dzdwnv9m9ekpVeh57HElwamunor3Iuzjh
         HxyB/vKhYIWYpdPo7jNhjHekyVUwvzzJSWB4GQ734LmFTKAk4zonU8hhaNu0A2G69XrJ
         h0yA==
X-Gm-Message-State: AOAM53177XjA1NeWR1q/UgsmL/laziv7OKzMOd9vdS+xlII6p/pP0qlr
        IEouy1jIYPxsXizfplodOFsJxc7iCcDefPrPeloSP1NGXY3cNqLM712g9LcOMJgzhma04QfH7yg
        UAZB7H3jtg87t
X-Received: by 2002:adf:e8d0:: with SMTP id k16mr1971721wrn.362.1604660203951;
        Fri, 06 Nov 2020 02:56:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxLhEYbJDRRuZZgGWT3qR8WnLrV1z/VwRATvbIzR/qs/MGtS5CJWD0uCE9tv38R2N1EHXwZLw==
X-Received: by 2002:adf:e8d0:: with SMTP id k16mr1971707wrn.362.1604660203733;
        Fri, 06 Nov 2020 02:56:43 -0800 (PST)
Received: from [192.168.10.118] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id b8sm1655312wmj.9.2020.11.06.02.56.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2020 02:56:42 -0800 (PST)
Subject: Re: [PATCH v13 05/14] KVM: X86: Implement ring-based dirty memory
 tracking
To:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Lei Cao <lei.cao@stratus.com>
References: <20201001012044.5151-1-peterx@redhat.com>
 <20201001012222.5767-1-peterx@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a03b7cf0-8847-2a60-ea2b-b83f5d82939a@redhat.com>
Date:   Fri, 6 Nov 2020 11:56:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201001012222.5767-1-peterx@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just very few changes:

On 01/10/20 03:22, Peter Xu wrote:
> @@ -6373,3 +6386,107 @@ ranges that KVM should reject access to.
>   In combination with KVM_CAP_X86_USER_SPACE_MSR, this allows user space to
>   trap and emulate MSRs that are outside of the scope of KVM as well as
>   limit the attack surface on KVM's MSR emulation code.
> +
> +8.28 KVM_CAP_DIRTY_LOG_RING
> +---------------------------

Here I made a few edits, but nothing major.  Throughout the patch I 
replaced "collected" with "harvested" since the documentation was using 
it already and it's a bit more unique ("collect" reminds me too much of 
garbage collection and perhaps could be confused with the kernel's 
operation for the reset ioctl).

> +#ifdef CONFIG_X86
> +		return KVM_DIRTY_RING_MAX_ENTRIES * sizeof(struct kvm_dirty_gfn);
> +#else
> +		return 0;
> +#endif

And this can be "#if KVM_DIRTY_LOG_PAGE_OFFSET > 0" instead.

Paolo

