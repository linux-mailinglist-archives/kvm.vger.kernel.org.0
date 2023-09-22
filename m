Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1910D7AA9BB
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 09:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbjIVHJf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 03:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbjIVHJd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 03:09:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663F4192
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 00:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695366525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1CcFN6GxFH9huBFe0Pnc3FcwLcThuqa1WEQXANaBaw4=;
        b=TQKnrykh+MMYG4OPdlFs6a7/i3TN5hZXtEJY7ezc1+oTg8BrTSKv+CG0QhWFQztmgT7OPH
        rwvt3NVOfVXl1YqhzxoZ/I2Q+mMf1+Mt9kx9YMKQqUf3zqiV4loPzi/eyaBM63/xm+lS6Z
        57QYYRv2Jqu5kpHDTuQG3Z9NkSembzA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-312-kpYNvqvmMMCbJBLyMuOkVw-1; Fri, 22 Sep 2023 03:08:43 -0400
X-MC-Unique: kpYNvqvmMMCbJBLyMuOkVw-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-317d5b38194so111348f8f.0
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 00:08:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695366522; x=1695971322;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1CcFN6GxFH9huBFe0Pnc3FcwLcThuqa1WEQXANaBaw4=;
        b=Ml6zT/Rb0nHoYc89zQ09eRcXo+ssmQ9Gvdaz2LfX3VXnVLpexF8I/EGjzNJpjT7NNF
         eMaaNqHeiagY6p1kdde5UDA3FOYd6HSeiRLu3TIDun6iUG0aQBzs7sLlvQ05Ar/LhIpU
         ycthWmXrgKKBCbcpghhfPXSiLUIPdYXdXSPnLV/yKdgAU/Tj38jN1YXd5C+SB6+eEFqX
         OYlqUpgofoHBJBWbCrh+IzfuhDqjIYipuMJrwcXjX3ooHHWeVS0QqwsUc2ibLZlhtZIb
         43SvEWxzWRzssmzbgB2oBsm5k99eCDDlOlRaztZ0M8vZAeyHzKikew0mSuhpsiShsq08
         F0Og==
X-Gm-Message-State: AOJu0YzdO7Li3VOf/xBempj3iHDCwS/Pa50MQJVnXMaHVcK0luIJBfO4
        OUiDhHRJ21dsptvrgwmQOwbGKhvwPYRlFFJ9B8PnePEMxSQWPzGcTEmKz5aavrW+mze/luXZL5w
        GR4id2jbTW5jC
X-Received: by 2002:adf:ea46:0:b0:319:5234:5c92 with SMTP id j6-20020adfea46000000b0031952345c92mr991660wrn.35.1695366521874;
        Fri, 22 Sep 2023 00:08:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG02HYVlxwI9+3ZDqaZGIK64u65OFG9u8GfhI4GFppH1eUv+kvAH1plrNDYSBgfA28RUhIkYw==
X-Received: by 2002:adf:ea46:0:b0:319:5234:5c92 with SMTP id j6-20020adfea46000000b0031952345c92mr991640wrn.35.1695366521372;
        Fri, 22 Sep 2023 00:08:41 -0700 (PDT)
Received: from ?IPV6:2003:cb:c71a:7100:dfaf:df8b:54b9:7303? (p200300cbc71a7100dfafdf8b54b97303.dip0.t-ipconnect.de. [2003:cb:c71a:7100:dfaf:df8b:54b9:7303])
        by smtp.gmail.com with ESMTPSA id h16-20020adffd50000000b0031ad5fb5a0fsm3680632wrs.58.2023.09.22.00.08.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Sep 2023 00:08:40 -0700 (PDT)
Message-ID: <998a0ef6-a74c-feec-eca2-644aee91f27b@redhat.com>
Date:   Fri, 22 Sep 2023 09:08:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [RFC PATCH v2 02/21] RAMBlock: Add support of KVM private gmem
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
 <20230914035117.3285885-3-xiaoyao.li@intel.com>
 <678bf0bf-57e7-a596-1ddf-6d0b47cd8677@redhat.com>
 <6eeb5568-2faa-85c3-8f42-ed6317ea376c@intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <6eeb5568-2faa-85c3-8f42-ed6317ea376c@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22.09.23 02:22, Xiaoyao Li wrote:
> On 9/21/2023 4:55 PM, David Hildenbrand wrote:
>> On 14.09.23 05:50, Xiaoyao Li wrote:
>>> From: Chao Peng <chao.p.peng@linux.intel.com>
>>>
>>> Add KVM gmem support to RAMBlock so both normal hva based memory
>>> and kvm gmem fd based private memory can be associated in one RAMBlock.
>>>
>>> Introduce new flag RAM_KVM_GMEM. It calls KVM ioctl to create private
>>> gmem for the RAMBlock when it's set.
>>
>>
>> But who sets RAM_KVM_GMEM and when?
> 
> The answer is in the next patch. When `private` property of memory
> backend is set to true, it will pass RAM_KVM_GMEM flag to
> memory_region_init_ram_*()

Okay, assuming that patch (and property) will go away, I assume this 
flag can also go away, right?

-- 
Cheers,

David / dhildenb

