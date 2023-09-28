Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D70FA7B2382
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 19:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbjI1RPd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 13:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbjI1RPa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 13:15:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA74C0
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 10:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695921279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IoOMdWsqx13KyfLDmhd8kwn+FZuK3U7Zd1iwFOjjXP0=;
        b=IqJxie0C2PYnojl6KJqT/K1pUvAykASHFbzvV17yMBYfbc8ZAVvT43wTSaqpgyFOV7G7hL
        AvhfTfGZN/D0nYZ7ApiF5LERMhHniObphVC/6XDeAzwNV4XQ6oABbRC6yKOEXUk4NSts2w
        YZ2GrBh10eihKdn/Mb2KbK4rF/QsJ30=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-326-fi9gIxhQNfCZFkfmuVkX_Q-1; Thu, 28 Sep 2023 13:14:37 -0400
X-MC-Unique: fi9gIxhQNfCZFkfmuVkX_Q-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-32480c0ad52so1443706f8f.0
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 10:14:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695921277; x=1696526077;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IoOMdWsqx13KyfLDmhd8kwn+FZuK3U7Zd1iwFOjjXP0=;
        b=sFRfPmNllUyutg7pFN8xcMySPKvtWWIURctUg6Eqdu7Y4sceAv/HLbJz2DcP3xm7X9
         GInZ3KLtNHYpnAVQ0/tEDb+wLR/XT95635KC1MxydguzAn6EBtOFHLTB1WyMq97BXfH+
         aB11OnFr5RkbN3vDJIyl3pZ6gcIjkFoUydceGmaGggKjOsccF5HvFGvPiyRBhVUjl4G/
         7KU1RIc2dxPsjpjA5uQo3I3qeMOWUS45TEkJEMHkhXdOslyjH8KhIWXNUJWMH9fQO8ux
         H8TAOvzu8n8zKXnD72Fcg9tYEfoihXqdAO4e25Wp5eWHRq2HKe6GwsXvz+inihmM9M9+
         wgEg==
X-Gm-Message-State: AOJu0YwH544oq6KQ0uFHrHEspKfCm6M4Pl5NEqoepgtuaC0LqMbcOfgL
        2StCOY55B1iLQF9HB/ujv/Tf4b/+Jqj5P5VUyj+gOLh7C5GyPein0r0Zv2B6wuWu/ETYWWU+GAX
        qpxswqjNYbb/Y
X-Received: by 2002:a5d:4d45:0:b0:31f:fcee:afcf with SMTP id a5-20020a5d4d45000000b0031ffceeafcfmr1675078wru.71.1695921276833;
        Thu, 28 Sep 2023 10:14:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGaHAI0Jl7BgDloLvOXP39Cbg4Q6f6RcYSSUyl32ffjmWzsxBgubexMfj/vYKlBpyoT2n5HAQ==
X-Received: by 2002:a5d:4d45:0:b0:31f:fcee:afcf with SMTP id a5-20020a5d4d45000000b0031ffceeafcfmr1675065wru.71.1695921276488;
        Thu, 28 Sep 2023 10:14:36 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id e21-20020a056402149500b005256d80cdaesm9954826edv.65.2023.09.28.10.14.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Sep 2023 10:14:35 -0700 (PDT)
Message-ID: <fd764cff-f4bc-a13d-96dc-a7eaab8434f2@redhat.com>
Date:   Thu, 28 Sep 2023 19:14:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Isaku Yamahata <isaku.yamahata@linux.intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Michael Roth <michael.roth@amd.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Xu Yilun <yilun.xu@intel.com>,
        Quentin Perret <qperret@google.com>, wei.w.wang@intel.com,
        Fuad Tabba <tabba@google.com>
References: <cover.1695327124.git.isaku.yamahata@intel.com>
 <ZQynx5DyP56/HAxV@google.com>
 <20230922194029.GA1206715@ls.amr.corp.intel.com>
 <ZQ3573rbNQpbNf09@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH v2 0/6] KVM: gmem: Implement test cases for
 error_remove_page
In-Reply-To: <ZQ3573rbNQpbNf09@google.com>
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

On 9/22/23 22:32, Sean Christopherson wrote:
> Unless we can't extend fadvise() for some reason, I think we should pursue
> FADV_HWPOISION.  The enabling should be downright trivial, e.g. just implement
> file_operations.fadvise() for guest_memfd, have it handle FADV_HWPOISON, and pass
> everything else to generic_fadvise().
> 
> It'll basically be your ioctl() just without a dedicated ioctl().
> 
> At the very least, we should run the idea past the fs maintainers.

fadvise() is different from madvise() though and not necessarily a great 
match.  Looking at the list of flags in advise(), something like 
FADV_POPULATE_READ, FADV_PAGEOUT or FADV_COLD would make sense, but I 
can't really think of any other flag that would be useful in a general 
case for fadvise.  Everything else would have to be very spcific to 
memfd or guest_memfd.

In particular FADV_HWPOISON would not make sense for anything that is 
not backend by memory.  There are some flags that could be useful on 
gmem file descriptors, such as hypothetically {WIPE,KEEP}ONFORK or 
SOFT_OFFLINE, but again they're not something that can be applied to 
fadvise().

So a ioctl implementation does have some advantages after all.  I 
suggest that we reuse MADV_* flags in the ioctl arguments, to leave the 
door open for future extensions and avoid ioctl proliferation.  The 
ioctl could be implemented by memfd, too, and perhaps even by /dev/zero.

Paolo

