Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7532230D867
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 12:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234164AbhBCLTB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 06:19:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35384 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234113AbhBCLSw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 06:18:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612351046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YDwwnV6oAoWgNtINek2BnDn+JyBU0+eXPvom2Xfx5pY=;
        b=esJ1Mpz+PkdJTken4H+RaUKcWmJA6Vyu1tMRlZvELPo0gj/8WH+Sj+cpGS2DzF/UH3jFQ2
        4EW9R6hW9S2ioLZVwnrRJ09H0EkdSuX7bk9J+LKaRCY7wXugduE4HRPofX/+ojH0Jv6ygh
        vmz1UJHcrs40lUeUUtQNh3VsD9IFAhY=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-2ea39i7bMNWDXXIE6H6qCg-1; Wed, 03 Feb 2021 06:17:24 -0500
X-MC-Unique: 2ea39i7bMNWDXXIE6H6qCg-1
Received: by mail-ej1-f70.google.com with SMTP id d15so11738632ejc.21
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 03:17:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YDwwnV6oAoWgNtINek2BnDn+JyBU0+eXPvom2Xfx5pY=;
        b=iQStR1c+oH43BNd+uWHVNcaia4+Cw9gA/KM2J+d1iwmnLvR+ZUDUsVS7WVeP3mXXf2
         4DszX9Vpln7Gxrelx5A92yh9MG3dG7I9L5NY0hJ6Lomv9a9i/a5IHEiJRWUyN55iDKpm
         w/Jr5mCpHVIvsjC0TeRLJnBtq6pIJXfkaq6AANesRv9yrKykZC4bSHbv7kM0BY+yXhIc
         6SE+jB1G6cagoIcR/+4wd3TuVhf4cG4qbtO5jmi6ji8q1nBG0bCUw3oBQSJThMi1+Ze/
         IvMcET2+/Oqi8yYsSFQ1cPenyUzr3ID1vjVwIcLKhHcjC0JtlC/JtXAZ0LtINxNpOSmt
         X0Gw==
X-Gm-Message-State: AOAM533kerI7EX85IiqbAEVQxFUr3vWHM8j0+DRDkhNjh+wDqelPVgvi
        GZuF0sU21dCMELiqd2RFmjMDeBu3s6mLeQ34ZOoAIF/VPgoQNxIJq6f6w6dFvYLv49mrfG6nrzO
        Ns5Cg5ALQQAlM
X-Received: by 2002:a50:fd84:: with SMTP id o4mr2377539edt.340.1612351043440;
        Wed, 03 Feb 2021 03:17:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx6DJB/yfWm5CLZI+cgY4t/zSaoLhE/4PGymObqGlzKNfu+A+pz91uz/yL9ObXeu3kpsxISnQ==
X-Received: by 2002:a50:fd84:: with SMTP id o4mr2377519edt.340.1612351043304;
        Wed, 03 Feb 2021 03:17:23 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r9sm856518eju.74.2021.02.03.03.17.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 03:17:22 -0800 (PST)
Subject: Re: [PATCH v2 22/28] KVM: x86/mmu: Mark SPTEs in disconnected pages
 as removed
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
References: <20210202185734.1680553-1-bgardon@google.com>
 <20210202185734.1680553-23-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cb7108c7-e4f2-ea59-24f4-7c7da45054a8@redhat.com>
Date:   Wed, 3 Feb 2021 12:17:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210202185734.1680553-23-bgardon@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/02/21 19:57, Ben Gardon wrote:
> 
> +			 * Marking the SPTE as a removed SPTE is not
> +			 * strictly necessary here as the MMU lock should

"should" is a bit too weak---the point of !shared is that the MMU lock 
*will* stop other threads from concurrent modifications of the SPTEs.

Paolo

> +			 * stop other threads from concurrentrly modifying
> +			 * this SPTE. Using the removed SPTE value keeps
> +			 * the shared and non-atomic cases consistent and
> +			 * simplifies the function.
> +			 */
> +			WRITE_ONCE(*sptep, REMOVED_SPTE);


