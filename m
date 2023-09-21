Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB0457A9F9A
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbjIUUZ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 16:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231920AbjIUUYr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 16:24:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828C4F830
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695317016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CXzfBnb6s0TokTe/yNIjNnut/xFJqsbkbtECAXTqWzs=;
        b=gIG26wtUMDyzclkWnjl8Rl1oWY/COB99sElv2JP4qw3Fy4/TQMzUaL3f9T392vka6GPvEs
        ZjNEOIXZfbcYtGfmNN7R8SWnhtZAe+i0t2cbVD3zR/m943guMEcXCXZjKEs4JJCMqQ0ELe
        hVbqZS+yG1cgn54IzeChwEO4F1yw3NE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-507-zjqiL_oIM5-uCpSRyXHcbg-1; Thu, 21 Sep 2023 04:55:56 -0400
X-MC-Unique: zjqiL_oIM5-uCpSRyXHcbg-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-31f79595669so754797f8f.0
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 01:55:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695286555; x=1695891355;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CXzfBnb6s0TokTe/yNIjNnut/xFJqsbkbtECAXTqWzs=;
        b=mpSYj5ODBZVfQP5O/KwItzd4o5zaSCnqyuXAdXlM1aRmbhLnUY8AibkeZYWOlAhFdD
         7IZJBksOpPIuyhL0g0FaWpR2Yxbe2pFykkvyK/bX4sHZKc9OIqAcXqaeL4S0ucEKQ9WJ
         dyAPkxlelblCecobRqAiRkapccHXzCSWm08qDTiko43aRd90Xr2YOvylF+sANT2/lUIZ
         O2xcotUvVfX3U4Pl/uMxmp16zyZ0STCO3P+txBE/YHPMjFc4kIrACCnntpNA+pzf9ctX
         jv0efWzVOiKT0+oCSdTkkHHbHUgQ1NpbbcK8aT3QIDYQ8CqJ8RietgzndboeiS62AQDM
         8a9Q==
X-Gm-Message-State: AOJu0Yzp7O4ezboigW5jPYvRGb968OJAHgkON0FCQe1FN4lMQs+N4pbE
        rftQMpAFF2R4x5bnksC44DUutp2/tIcLk9anH42im3FQ1oJu5Vz59UmSAqMzdYF4VwuVa9oYRtU
        LxCOX8ogEafMn
X-Received: by 2002:adf:f24d:0:b0:314:c6b:b9a2 with SMTP id b13-20020adff24d000000b003140c6bb9a2mr4283830wrp.13.1695286554887;
        Thu, 21 Sep 2023 01:55:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFr1B68OlonHq+x2Ayf/NCpEV9vQxh6aDgWzz7JLCnpauVUgrdLv8UXHvYUV8oS8X50orAakw==
X-Received: by 2002:adf:f24d:0:b0:314:c6b:b9a2 with SMTP id b13-20020adff24d000000b003140c6bb9a2mr4283803wrp.13.1695286554511;
        Thu, 21 Sep 2023 01:55:54 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70d:3c00:9eab:fce5:e6f3:e626? (p200300cbc70d3c009eabfce5e6f3e626.dip0.t-ipconnect.de. [2003:cb:c70d:3c00:9eab:fce5:e6f3:e626])
        by smtp.gmail.com with ESMTPSA id x5-20020adfdcc5000000b0031c6581d55esm1150709wrm.91.2023.09.21.01.55.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Sep 2023 01:55:54 -0700 (PDT)
Message-ID: <678bf0bf-57e7-a596-1ddf-6d0b47cd8677@redhat.com>
Date:   Thu, 21 Sep 2023 10:55:52 +0200
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
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230914035117.3285885-3-xiaoyao.li@intel.com>
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

On 14.09.23 05:50, Xiaoyao Li wrote:
> From: Chao Peng <chao.p.peng@linux.intel.com>
> 
> Add KVM gmem support to RAMBlock so both normal hva based memory
> and kvm gmem fd based private memory can be associated in one RAMBlock.
> 
> Introduce new flag RAM_KVM_GMEM. It calls KVM ioctl to create private
> gmem for the RAMBlock when it's set.


But who sets RAM_KVM_GMEM and when? Don't we simply allocate it for all 
RAMBlocks under such special VMs? What's the downside of doing that?


-- 
Cheers,

David / dhildenb

