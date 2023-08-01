Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1144C76B9AF
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 18:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbjHAQeR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 12:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjHAQeQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 12:34:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024751FEF
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 09:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690907610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2LFFHMZCPpFrHj9GHUN3Fmk401Wjxwu92uWmwSv+p1U=;
        b=JpkFREeY7vLdod9kf/zVQG5TC9Oil3rQl/l1DyoHZuS2nX+kz/L+aSMLl6TOEmNBYdvuKa
        Nqqt9+VH/G8qzLNSRYmVb3dH8eeaP7L9QLhB6Y0hJ0YiEL4ZDOm1M4XtTA1pVi89TqtDKh
        0YZkPsok11sCaN6p3VdSUhcmBSiTHWM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-n8Mha6dMN1OkyTQ4QD_mvA-1; Tue, 01 Aug 2023 12:33:22 -0400
X-MC-Unique: n8Mha6dMN1OkyTQ4QD_mvA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3fbb34f7224so40172945e9.2
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 09:33:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690907600; x=1691512400;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2LFFHMZCPpFrHj9GHUN3Fmk401Wjxwu92uWmwSv+p1U=;
        b=JJ0mhi63sv6V1GnL/RKYl0a4N56yZ5Jxzcm2eHgH5csPr6csWbCsa7GB0zi+98mxmr
         EyEXlyvIJ+Qwj9IAmKBdGTO4Wp9SV0lB3wxf9tAdL6Rpi1HCQrmOXLwckVNr6Kdb1cI/
         n1JPYQUE49DEER6DRei5Khzhidwcc6ID+pLNXoo8x0xPiLVoIW4F6gIAizzLzCcu2JC8
         MVhZSv8dVB2QK1KMduGU1pvZDHabdTeWLN/yofX5IwgzsTLg/cfpwsN6OXCfv6ftW9Zx
         HjiSTrTuG+C02K48PWSNQJemD33PfguUFsgmknBeeI056pL5PCNU1deaCX6KIzs4QibY
         PbwQ==
X-Gm-Message-State: ABy/qLZX+D5E/g0m7/wQ1DL6iv/1d1sEivZE9LqwytZEL+HkLikfW9Ba
        b8bvYGmkqjjcGJjZ4wnRhQyNY/OkBRd9KzCszojdgMGPm+tAaBBn7EYU8dv2J1K+baMOyyB/96z
        lSrIil+COj9y6
X-Received: by 2002:a7b:ce07:0:b0:3fb:d1db:545b with SMTP id m7-20020a7bce07000000b003fbd1db545bmr2900135wmc.20.1690907600557;
        Tue, 01 Aug 2023 09:33:20 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHSbUqrv1Zne7pCMT8HI7XTC9rr5ni1gbnrW3jfHSN9SjJ2jRf6Ff96/2UP1i0YrsVgDMUo4g==
X-Received: by 2002:a7b:ce07:0:b0:3fb:d1db:545b with SMTP id m7-20020a7bce07000000b003fbd1db545bmr2900100wmc.20.1690907600047;
        Tue, 01 Aug 2023 09:33:20 -0700 (PDT)
Received: from ?IPV6:2003:cb:c705:d100:871b:ec55:67d:5247? (p200300cbc705d100871bec55067d5247.dip0.t-ipconnect.de. [2003:cb:c705:d100:871b:ec55:67d:5247])
        by smtp.gmail.com with ESMTPSA id cs5-20020a056000088500b0031435731dfasm16773081wrb.35.2023.08.01.09.33.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Aug 2023 09:33:19 -0700 (PDT)
Message-ID: <65e55994-620d-f3c7-2f1f-dd69dd915ff5@redhat.com>
Date:   Tue, 1 Aug 2023 18:33:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20230731162201.271114-1-xiaoyao.li@intel.com>
 <20230731162201.271114-4-xiaoyao.li@intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [RFC PATCH 03/19] RAMBlock: Support KVM gmemory
In-Reply-To: <20230731162201.271114-4-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31.07.23 18:21, Xiaoyao Li wrote:
> From: Chao Peng <chao.p.peng@linux.intel.com>
> 
> Add KVM gmem support to RAMBlock so we can have both normal
> hva based memory and gmem fd based memory in one RAMBlock.
> 
> The gmem part is represented by the gmem_fd.
> 
> Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>

So, *someone* creates a RAMBlock in QEMU.

Who'll squeeze a gmem_fd in there? When? How?

Shouldn't we create the RAM memory region / RAMBlock already with the 
gmem_fd, and set that when initializing these things?

-- 
Cheers,

David / dhildenb

