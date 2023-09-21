Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0B277A9EE8
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbjIUUOS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 16:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjIUUN6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 16:13:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6246040064
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695316442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gnC0b6lnMLSijKr/atWkBSroYyOyTuQCBV6iB+70E5U=;
        b=FuRcg8uUC82NSmRINvqSnN9lZ1HYj51/8EvIs+NZ4g5BTpytbikGrpsKiEuMwXETd+6MiQ
        Yfl7W+kHfQfxFZ4KwCA6DwQEKAPqvAA0ZvqD3GuyawRsHZIh+5LvaobbpMuwiBWDLvjjoQ
        Fo0kyxyUwwws1iSalq3CDdDCEdsbwSE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-83-GpJAXFVMOpCeJRpiE_MTCQ-1; Thu, 21 Sep 2023 04:45:10 -0400
X-MC-Unique: GpJAXFVMOpCeJRpiE_MTCQ-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f41a04a297so5448075e9.3
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 01:45:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695285909; x=1695890709;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gnC0b6lnMLSijKr/atWkBSroYyOyTuQCBV6iB+70E5U=;
        b=HDHxIWKyb0HR+kE5s0vCdfnf+lFWhsUKSkyX4ZoyNI1T00jXwzMs+dvDlMNmX20gnP
         h+BWqPdNKO8dDxHr9SabeEsAgZN5RyCikQ2I7iZy14aKy7XsQ0aQeesSJOdLDX9n5s8m
         BEkNOF8Dozrsu4M1znRHV/Bbb2cQjm9KpUDAVvsF4ECp5PfKerp7ttSSf83k+6mzsSSD
         0ypVEJipfMqLsRwrH4x0LN/BxE0hIrv2eV0WMnzhIe0zpsDrSCJDDwfA1QWod+piwAqK
         zthZgLhzeNfwC/Y+J0k1vD904VcbIcVG/PwO8BAcjjz4zK6++/dH/5zReQoB6/nlBHYl
         IJOg==
X-Gm-Message-State: AOJu0YwcoZtOQmNYQ1/jCDN++sn0ayJ9pW+FBasiZ0yT1g3YiUxfM8ju
        UuK+EUZ92GIwsGJfoeHEuqHW7PdGeEVi2Fbp0Yk1K6crC3o1Diq4UFbjR6ZHdwvVkRb6vtkeWnp
        CbzXaD3WeXZor
X-Received: by 2002:a05:600c:218b:b0:403:cc79:44f3 with SMTP id e11-20020a05600c218b00b00403cc7944f3mr5121906wme.19.1695285909192;
        Thu, 21 Sep 2023 01:45:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEGzwcPETrm4TKLsoChY5Abm1s7seZpAUSF3G1TlEcLkchunVKE8bc2ry5zu6jntFooMTj++w==
X-Received: by 2002:a05:600c:218b:b0:403:cc79:44f3 with SMTP id e11-20020a05600c218b00b00403cc7944f3mr5121885wme.19.1695285908840;
        Thu, 21 Sep 2023 01:45:08 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70d:3c00:9eab:fce5:e6f3:e626? (p200300cbc70d3c009eabfce5e6f3e626.dip0.t-ipconnect.de. [2003:cb:c70d:3c00:9eab:fce5:e6f3:e626])
        by smtp.gmail.com with ESMTPSA id x10-20020a05600c21ca00b004051b994014sm4134912wmj.19.2023.09.21.01.45.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Sep 2023 01:45:08 -0700 (PDT)
Message-ID: <a1e34896-c46d-c87c-0fda-971bbf3dcfbd@redhat.com>
Date:   Thu, 21 Sep 2023 10:45:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [RFC PATCH v2 03/21] HostMem: Add private property and associate
 it with RAM_KVM_GMEM
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Markus Armbruster <armbru@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        isaku.yamahata@gmail.com, Sean Christopherson <seanjc@google.com>,
        Claudio Fontana <cfontana@suse.de>
References: <20230914035117.3285885-1-xiaoyao.li@intel.com>
 <20230914035117.3285885-4-xiaoyao.li@intel.com> <8734zazeag.fsf@pond.sub.org>
 <d0e7e2f8-581d-e708-5ddd-947f2fe9676a@intel.com>
 <878r91nvy4.fsf@pond.sub.org>
 <da598ffc-fa47-3c25-64ea-27ea90d712aa@intel.com>
 <091a40cb-ec26-dd79-aa26-191dc59c03e6@redhat.com>
 <87msxgdf5y.fsf@pond.sub.org>
 <cfa3ac58-fb1f-b255-772a-ab369a68be68@intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <cfa3ac58-fb1f-b255-772a-ab369a68be68@intel.com>
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

>>> I think as long as there is no demand to have a TDX guest with this property be set to "off", then just don't add it.
>>>
>>> With a TDX VM, it will can be implicitly active. If we ever have to disable it for selective memory backends, we can add the property and have something like on/off/auto. For now it would be "auto".
>>
>> Makes sense to me.
> 
> OK. I think I get the answer of open #1 in cover letter.
> 

Yes.

> If no other voice, I'll drop this patch and allocate gmem RAM when
> vm_type is TDX.

Good!

-- 
Cheers,

David / dhildenb

