Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06801737124
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 18:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbjFTQEn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 12:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233070AbjFTQEj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 12:04:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE42F4
        for <kvm@vger.kernel.org>; Tue, 20 Jun 2023 09:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687277036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+QqdU7GkDQhFCN54Fcp3vfTEcL3yBRMC5K6R5qPbNUw=;
        b=QirtAxL3i/LOOWl01t4F/94ByIDBM+OEjuLL7qlZW5giDAA1mFnwmIRJ+c6bZmoxvlVjB4
        BYKjQ9ePMzLHVEXfbJHNitBFxYK9W9WYA0SBbMVTTBl85zoKbWBNsOwN8l+MqHRXUclRBb
        6JlYZ7IyMoqqIBAcy7Hq1eTwsCqubTk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-18-D0zU7V6bNnWpwxZ8k6k7Bg-1; Tue, 20 Jun 2023 12:03:44 -0400
X-MC-Unique: D0zU7V6bNnWpwxZ8k6k7Bg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f7e4dc0fe5so26320765e9.3
        for <kvm@vger.kernel.org>; Tue, 20 Jun 2023 09:03:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687277012; x=1689869012;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+QqdU7GkDQhFCN54Fcp3vfTEcL3yBRMC5K6R5qPbNUw=;
        b=K/tIPJxzaudH0mvobfJmmAY8b+zYbCek+njZsLGcWsB73PDaSZ3mejFvGlXijsMRak
         r2IDWm4UFOEv5MUDDw/kDsh2OOwOsSMtyCF57GxaeMR4LmWrqeZp1zVLmoBPsLsqb1RT
         puAEpazZkco69uBG7OZuo4gEulaUsCr9vR5W/9mzni94kvU/dkRBIQQXDJf0G+YBYP3F
         9cEzF/9CrNm7I6EolmeimKG8iAfqyduBrw15V6BwInefIDwe/XBFqmBNEWobs6WNCq6L
         SSVgqvY+4QoO8MZ5Z2YoXY7P8XSy7RdCAhPasygzqtAQXtZ0VmsMuoqVWlECr7S31585
         MM0A==
X-Gm-Message-State: AC+VfDwAS8fWarPDRtXupBlWdxGh4/PG6E7vbR1djMt2PQUGTnIqkukv
        dOBJcFIJr8ba1geRHPS1BGgdVhOi3bmlD1Jlsk1cPRK4hdV0vdgqH4BRAkOhVsXMcMiRnSSYmWP
        xgfliKRSitSm0
X-Received: by 2002:a7b:cd89:0:b0:3f9:137:af7c with SMTP id y9-20020a7bcd89000000b003f90137af7cmr10011877wmj.10.1687277012289;
        Tue, 20 Jun 2023 09:03:32 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ61lrarMfjZlrZkjJ/W1vUZw/v7MfmOMrcSXIPEfWRJscK2bUg0DxFkiod61KlmAL7Fgz7IcA==
X-Received: by 2002:a7b:cd89:0:b0:3f9:137:af7c with SMTP id y9-20020a7bcd89000000b003f90137af7cmr10011844wmj.10.1687277011873;
        Tue, 20 Jun 2023 09:03:31 -0700 (PDT)
Received: from ?IPV6:2003:cb:c739:d200:8745:c520:8bf6:b587? (p200300cbc739d2008745c5208bf6b587.dip0.t-ipconnect.de. [2003:cb:c739:d200:8745:c520:8bf6:b587])
        by smtp.gmail.com with ESMTPSA id k4-20020a05600c0b4400b003f727764b10sm2714531wmr.4.2023.06.20.09.03.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jun 2023 09:03:31 -0700 (PDT)
Message-ID: <216753fd-c659-711e-12d0-d12e34110efc@redhat.com>
Date:   Tue, 20 Jun 2023 18:03:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, kirill.shutemov@linux.intel.com,
        tony.luck@intel.com, peterz@infradead.org, tglx@linutronix.de,
        seanjc@google.com, pbonzini@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1685887183.git.kai.huang@intel.com>
 <86f2a8814240f4bbe850f6a09fc9d0b934979d1b.1685887183.git.kai.huang@intel.com>
 <723dd9da-ebd5-edb0-e9e5-2d8c14aaffe2@redhat.com>
 <f64ee1a5-d96f-d888-14a7-8b4c5e7a9a2f@intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v11 04/20] x86/cpu: Detect TDX partial write machine check
 erratum
In-Reply-To: <f64ee1a5-d96f-d888-14a7-8b4c5e7a9a2f@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20.06.23 17:39, Dave Hansen wrote:
> On 6/19/23 05:21, David Hildenbrand wrote:
>> So, ordinary writes to TD private memory are not a problem? I thought
>> one motivation for the unmapped-guest-memory discussion was to prevent
>> host (userspace) writes to such memory because it would trigger a MC and
>> eventually crash the host.
> 
> Those are two different problems.
> 
> Problem #1 (this patch): The host encounters poison when going about its
> normal business accessing normal memory.  This happens when something in
> the host accidentally clobbers some TDX memory and *then* reads it.
> Only occurs with partial writes.
> 
> Problem #2 (addressed with unmapping): Host *userspace* intentionally
> and maliciously clobbers some TDX memory and then the TDX module or a
> TDX guest can't run because the memory integrity checks (checksum or TD
> bit) fail.  This can also take the system down because #MC's are nasty.
> 
> Host userspace unmapping doesn't prevent problem #1 because it's the
> kernel who screwed up with the _kernel_ mapping.

Ahh, thanks for verifying. I was hoping that problem #2 would get fixed 
in HW as well (and treated like a BUG).


Because problem #2 also sounds like something that directly violates the 
first paragraph of this patch description "violations of
this integrity protection are supposed to only affect TDX operations and
are never supposed to affect the host kernel itself."

So I would expect the TDX guest to fail hard, but not other TDX guests 
(or the host kernel).

-- 
Cheers,

David / dhildenb

