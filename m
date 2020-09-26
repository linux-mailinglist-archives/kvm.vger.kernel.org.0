Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F472795D0
	for <lists+kvm@lfdr.de>; Sat, 26 Sep 2020 03:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729836AbgIZBJW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 21:09:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40316 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729685AbgIZBJW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 21:09:22 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601082561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xhIG5lIeSniauUXqSeFzOVd/HOplR5lP9oJTjmYBwr4=;
        b=AQuL3FxoPeZbxoFLv9PmEz7H3e36NXYAB+Fk36rseB3mQJnzvlRHRXtppDeZvIH3GTYV0P
        HgvlPoB56lM/LKPBNluWW/x33OcaYXQF3lgZy2jHT2m+/9f0RdwYSIGov4sruvuuJejjQ4
        OM8Ga0QSSmLxxYILzuS0xxKMPNWmd0k=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-YwanLN7UP4u14s4At-48wg-1; Fri, 25 Sep 2020 21:09:19 -0400
X-MC-Unique: YwanLN7UP4u14s4At-48wg-1
Received: by mail-wr1-f70.google.com with SMTP id v5so1746603wrs.17
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 18:09:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xhIG5lIeSniauUXqSeFzOVd/HOplR5lP9oJTjmYBwr4=;
        b=uKYTdCirdx+1duly8fLmcx4+GuWz5i/bMUkYsoZPljh1OqRkLSa8yx9TQ0WoIxP6ze
         PadB3zKNJDVVqeeat7LyEkzxB5/vV9igwKn0hS1wP/7CHCyy3UPSXmzSGPMxwBptuUwl
         NmzRTwGSPn2YRMyVI0mLbvQaIe5EJzB1zJ9gmw7Ev/5QGPAao79QckUmPHM/k/jauqlo
         fmOj3ZQV3PaxAK2qfmx6CZ/lItKkZ5FqE2e9SoZTS8DcFjuL35yEALjJjuS1bEk/wXF2
         vQWq4cIopdGp3NXFTkVcegPAlgrMMjA9zntEalFpAvtGqh7+Z1lgtsjqGR52XB6dNG3O
         AOSQ==
X-Gm-Message-State: AOAM532x1BqgGhxflblFpG5QM9b4ZALEBMjfc/R+QcRjk+HjYorxl2Je
        dpnxrfhLk1gtZu7ipwEKsxOvFy6eSQHvyKoC9rhEH5JQNdxQjsqxMe4DK2XySC4gIYo6AFChEqC
        OQol4haZ1PrL/
X-Received: by 2002:a1c:31c6:: with SMTP id x189mr247360wmx.83.1601082557852;
        Fri, 25 Sep 2020 18:09:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyzLUyQP75wWdVj638jZZOHVrM+HQw/Dru+TIGIm46WWePJ54+CuKgTNe0RK+yLBktmQDLL8Q==
X-Received: by 2002:a1c:31c6:: with SMTP id x189mr247346wmx.83.1601082557623;
        Fri, 25 Sep 2020 18:09:17 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec9b:111a:97e3:4baf? ([2001:b07:6468:f312:ec9b:111a:97e3:4baf])
        by smtp.gmail.com with ESMTPSA id n14sm732281wmi.33.2020.09.25.18.09.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 18:09:17 -0700 (PDT)
Subject: Re: [PATCH 18/22] kvm: mmu: Support disabling dirty logging for the
 tdp MMU
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-19-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <44822999-f5dc-6116-db12-a41f5bd80dd8@redhat.com>
Date:   Sat, 26 Sep 2020 03:09:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200925212302.3979661-19-bgardon@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/09/20 23:22, Ben Gardon wrote:
> +	for_each_tdp_pte_root(iter, root, start, end) {
> +		if (!is_shadow_present_pte(iter.old_spte) ||
> +		    is_last_spte(iter.old_spte, iter.level))
> +			continue;
> +

I'm starting to wonder if another iterator like
for_each_tdp_leaf_pte_root would be clearer, since this idiom repeats
itself quite often.  The tdp_iter_next_leaf function would be easily
implemented as

	while (likely(iter->valid) &&
	       (!is_shadow_present_pte(iter.old_spte) ||
		is_last_spte(iter.old_spte, iter.level))
		tdp_iter_next(iter);

Paolo

