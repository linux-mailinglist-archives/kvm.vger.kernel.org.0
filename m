Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35790628668
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 18:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238165AbiKNRAd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 12:00:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237735AbiKNQ7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 11:59:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4954044D
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 08:58:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668445086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pmBBWwaPJPkgmEXjkzTKUyrnTfbv4onB3U5DS2RZCPY=;
        b=XCfwLgJUEY7c0aRJ8yWTj6Cdsoa79feRzWAO22bfwaH60ljtp9LJ1PGlVSgXUgI1AKvZav
        TDt1un+k77zTAKTaNRGjBIQY3AnNNilaBwN8egCmjsmfmNUFoqfQaed9XNZr6+GLOmxxn2
        1jnjoog7YzihUWDztWYbcNmxM6PfYf0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-7-GyF4R9ZSMjupMD-uY4eIXQ-1; Mon, 14 Nov 2022 11:58:04 -0500
X-MC-Unique: GyF4R9ZSMjupMD-uY4eIXQ-1
Received: by mail-ej1-f70.google.com with SMTP id sh31-20020a1709076e9f00b007ae32b7eb51so5716157ejc.9
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 08:58:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pmBBWwaPJPkgmEXjkzTKUyrnTfbv4onB3U5DS2RZCPY=;
        b=Y0fEoaOXgj9MjvnXyY72rimQQtYh35AGDO39/sEOtCFRLeLOYb6V1DCULbNBQEw+i8
         GoGDlTsj6umoYBIHFGjmIpSFYNYToCQYHCWUOGj8KjRh25s4m953ORhn2dt2VYT8Qtxz
         3ZZmaNpZDgGzuGRQqldf0woNlXZ685xx4QnNJ3GLqBMypIsTyoqnG2U0y7W+GgVOWBfR
         IlT3l9O44vxH4fRlxvMr6dmm6nUo+T684PXIuhJUlupSvqoJR3DBKJz/z/zY7GjDQtii
         K/S6+QwQcJt/lo8nnoVsjbCm5ri5uUkQFY13OCvyXJjwrz58l+5BMhqRZB92qq013AgV
         7oow==
X-Gm-Message-State: ANoB5pmym73iceiNykLKnB6yo9IeRo6fYbzE9CXWXcdMGD8SEJwFDKQb
        MKgdxFU9ELY5aF8l2tb1gPQpzhxy2JnX9E9QIJ30gJmzxRnTJ8JKidQTX4rJUyu67O8Qnb4lApY
        GxueKElVC4eBd
X-Received: by 2002:a17:906:16d6:b0:7ae:c45b:98fb with SMTP id t22-20020a17090616d600b007aec45b98fbmr10842091ejd.478.1668445083157;
        Mon, 14 Nov 2022 08:58:03 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4vb0TAkSrfum73/F+c97jDaxz2ndrowgmArwX7dHQA7RT+4hxfKkDd3tHbZZfKyPWhhFSIqw==
X-Received: by 2002:a17:906:16d6:b0:7ae:c45b:98fb with SMTP id t22-20020a17090616d600b007aec45b98fbmr10842072ejd.478.1668445082883;
        Mon, 14 Nov 2022 08:58:02 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id s6-20020a170906bc4600b007aed2057eaesm3774436ejv.161.2022.11.14.08.58.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Nov 2022 08:58:02 -0800 (PST)
Message-ID: <b958c3f4-4970-133d-b23f-4dce2c4e4935@redhat.com>
Date:   Mon, 14 Nov 2022 17:58:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Content-Language: en-US
To:     "Woodhouse, David" <dwmw@amazon.co.uk>,
        "seanjc@google.com" <seanjc@google.com>
Cc:     "mhal@rbox.co" <mhal@rbox.co>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Durrant, Paul" <pdurrant@amazon.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Kaya, Metin" <metikaya@amazon.co.uk>
References: <20221027161849.2989332-1-pbonzini@redhat.com>
 <20221027161849.2989332-4-pbonzini@redhat.com> <Y1q+a3gtABqJPmmr@google.com>
 <c61f6089-57b7-e00f-d5ed-68e62237eab0@redhat.com>
 <c30b46557c9c59b9f4c8c3a2139bd506a81f7ee1.camel@infradead.org>
 <994314051112513787cc4bd0c7d2694e15190d0f.camel@amazon.co.uk>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 03/16] KVM: x86: set gfn-to-pfn cache length consistently
 with VM word size
In-Reply-To: <994314051112513787cc4bd0c7d2694e15190d0f.camel@amazon.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/14/22 15:53, Woodhouse, David wrote:
> Most other data structures, including the pvclock info (both Xen and
> native KVM), could potentially cross page boundaries. And isn't that
> also true for things that we'd want to use the GPC for in nesting?

Yes, for kvmclock we likely got away with it because Linux page-aligns 
it (and has been since 2013: commit ed55705dd, originally done for 
vsyscall support).  I have checked OpenBSD and FreeBSD and I think they 
do as well.

I am very very tempted to remove support for "old-style" kvmclock MSRs 
and retroactively declare new-style MSRs to accept only 32-byte aligned 
addresses.  However that doesn't solve the problem.

Paolo

