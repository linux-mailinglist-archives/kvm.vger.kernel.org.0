Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 467DE7A9A20
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 20:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbjIUSgi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 14:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbjIUSgL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 14:36:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0073F43C88
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695316562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qT83k5KL55IHPMxMrxHeCEwMFmX72whvKRfXhwzkqs4=;
        b=SuZl5d9RWu8v12kkPm1EYsAZKy3ct2RSw8bv+e+/Ce5O4TPMxD33BzdPAos3MFqGF6jLla
        CktXrZo+yxW91xGoxCYx0uNlE8o8LZszhz/y7eQkzzCKb8pLZ3Fx3pPzQEGkOk054miUqz
        cC+aUf3+5/f866IuiG3JdulSOEGx8bE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-424-ra6RfpOfMFmNgQM2Yt3CTw-1; Thu, 21 Sep 2023 04:46:10 -0400
X-MC-Unique: ra6RfpOfMFmNgQM2Yt3CTw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-402d63aeea0so5478785e9.2
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 01:46:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695285969; x=1695890769;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qT83k5KL55IHPMxMrxHeCEwMFmX72whvKRfXhwzkqs4=;
        b=LXFQ0I/HlCwP/0Tg2On9/43T1CgeVxrOXXw3+tIBvSX6hnrwsdnVF+gzoroZBtjw8q
         PS3pLdTKuzGejCllOR2Qu8RO8tCC76KjKslL2TcFNLEvwnG3V4gVcyryhb9q+m64mpcd
         2sK7Mm+aGOAviO8s8TOqsegYTFpvOBvxTuB63qRNgdhy+Cyzs+FfjXsh3RScnB8UmMBJ
         GISFT4270gcRxax0FaYq3+OMkfK+TY8x/HjTSwz5H16V8c4bqKpAPFo8l64WIhi4REie
         G1LN/1ESfKe4g19iA3iirdMdHej886hzBRyiXAwdue+pyFrd1X/riD0RDeZeztNF6aS/
         QScA==
X-Gm-Message-State: AOJu0YzWjb8Zt/OlGmDY8AhOxju7hIXBia9BizIIteJhLp6W9xR5GMaG
        W2PiW41yUiv+uIyHrgsCuDGp9ffJe/o999ZoMr3AV/DhNuNtsYixFK1q+hXx8o4lH+U2mIWw4ye
        gtM2rb0GtS5UD
X-Received: by 2002:a05:600c:290:b0:3fd:3006:410b with SMTP id 16-20020a05600c029000b003fd3006410bmr4635444wmk.34.1695285969270;
        Thu, 21 Sep 2023 01:46:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHEKqCuAIJwnQJsQZZ8qqBZ0geuqmHsPXvhx9v7opOsIwmZxaAVauR+DFVx/KCsQqfrlHMEpA==
X-Received: by 2002:a05:600c:290:b0:3fd:3006:410b with SMTP id 16-20020a05600c029000b003fd3006410bmr4635410wmk.34.1695285968901;
        Thu, 21 Sep 2023 01:46:08 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70d:3c00:9eab:fce5:e6f3:e626? (p200300cbc70d3c009eabfce5e6f3e626.dip0.t-ipconnect.de. [2003:cb:c70d:3c00:9eab:fce5:e6f3:e626])
        by smtp.gmail.com with ESMTPSA id k1-20020adfe3c1000000b0031ff1ef7dc0sm1123795wrm.66.2023.09.21.01.46.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Sep 2023 01:46:08 -0700 (PDT)
Message-ID: <f525d4da-0878-b4bc-f9cf-7b824abfef0a@redhat.com>
Date:   Thu, 21 Sep 2023 10:46:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [RFC PATCH v2 04/21] memory: Introduce
 memory_region_has_gmem_fd()
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        Sean Christopherson <seanjc@google.com>,
        Claudio Fontana <cfontana@suse.de>
References: <20230914035117.3285885-1-xiaoyao.li@intel.com>
 <20230914035117.3285885-5-xiaoyao.li@intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230914035117.3285885-5-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14.09.23 05:51, Xiaoyao Li wrote:
> Introduce memory_region_has_gmem_fd() to query if the MemoryRegion has
> KVM gmem fd allocated.

*probably* best to just squash that into patch #2.

-- 
Cheers,

David / dhildenb

