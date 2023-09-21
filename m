Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B02797A9EDD
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbjIUUNm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 16:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjIUUNV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 16:13:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B95744B0
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695317041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PQo3cP8ubnIFxn8GyzNBkh6mW/MSQ9HqXpxlK6ZJiTA=;
        b=X0HqJhnmXHXAcU7s8dvT+c1JhkiLV8h45gzn9thObgWdNWcFTvw1ffuYEJY1Tfh7YPeXwT
        w3Nr1Woax3H8MpLDceSyFnLE4TEhQ/u+TEymvZGt5C21sP6dc+41hN2rsH5/fCmjDaM4bG
        9ByM/j9J+INo9w9VNQnZbr36jc/47VE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-548-ol8969O6MTGHiWmyy2_FZw-1; Thu, 21 Sep 2023 04:56:27 -0400
X-MC-Unique: ol8969O6MTGHiWmyy2_FZw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-32006e08483so507899f8f.0
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 01:56:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695286586; x=1695891386;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PQo3cP8ubnIFxn8GyzNBkh6mW/MSQ9HqXpxlK6ZJiTA=;
        b=MKv95KfBYzueyeZXqc0Xp0Zqpkd0QFWsPIorQ6BPBjF2QDVjfJ35Tr5hkbVBlHRjtg
         CoDC+EBY+sFjRp3+Vxaadrcadr1hXdc9D3A7sR16niT7rQ9dZZX1cOU2uD6accpqWFdN
         i7a+/7kpSP78J+LnRSYxbNOOmP88/EomHk9NJJrdqSlglYBI3M23dLSXEp5psyvOm/vR
         LdsQ4Sldvcp28cjQ8giQ6Pd5WENAgcJ5KaOJfKkd8eyATlHrPWmhalhQUR8WfQzmHLqq
         BDKKo87uv9Oa+H+Tnd1FPVCrj4T12aYk73ESquxGYr/UP/sVr9K+aJSvcGQNCz7jqNH7
         ltfw==
X-Gm-Message-State: AOJu0Yw1xmFGvO2bZ99nKvJOnijj6zWZWwy6hvA0Y/uf1l3tRFZnADTt
        Ra8UQIGMPm7hkipuf9O3ImD30uYuYXcha412cpuixe+EC/xI4tazsCf0ofKZ9fMWtjcqRqTmeJq
        J3UkcUWy4LbIj
X-Received: by 2002:adf:e253:0:b0:31a:dd55:e69c with SMTP id bl19-20020adfe253000000b0031add55e69cmr4279921wrb.60.1695286586214;
        Thu, 21 Sep 2023 01:56:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF4a6zpCosFq3hmujQ4zTcT38YOWqiaKd28jQERYVCmRpaHM+ECvPdd2GHEzhC9vCufTHkxJg==
X-Received: by 2002:adf:e253:0:b0:31a:dd55:e69c with SMTP id bl19-20020adfe253000000b0031add55e69cmr4279904wrb.60.1695286585929;
        Thu, 21 Sep 2023 01:56:25 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70d:3c00:9eab:fce5:e6f3:e626? (p200300cbc70d3c009eabfce5e6f3e626.dip0.t-ipconnect.de. [2003:cb:c70d:3c00:9eab:fce5:e6f3:e626])
        by smtp.gmail.com with ESMTPSA id z16-20020a056000111000b003176eab8868sm1131747wrw.82.2023.09.21.01.56.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Sep 2023 01:56:25 -0700 (PDT)
Message-ID: <3f8955f6-c261-d3f3-08a2-54f0bd9caf8e@redhat.com>
Date:   Thu, 21 Sep 2023 10:56:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [RFC PATCH v2 05/21] kvm: Enable KVM_SET_USER_MEMORY_REGION2 for
 memslot
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
 <20230914035117.3285885-6-xiaoyao.li@intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230914035117.3285885-6-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14.09.23 05:51, Xiaoyao Li wrote:
> From: Chao Peng <chao.p.peng@linux.intel.com>
> 
> Switch to KVM_SET_USER_MEMORY_REGION2 when supported by KVM.
> 
> With KVM_SET_USER_MEMORY_REGION2, QEMU can set up memory region that
> backend'ed both by hva-based shared memory and gmem fd based private
> memory.
> 
> Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
> Codeveloped-by: Xiaoyao Li <xiaoyao.li@intel.com>

"Co-developed-by".

-- 
Cheers,

David / dhildenb

