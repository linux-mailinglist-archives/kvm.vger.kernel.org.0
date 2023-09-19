Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE27F7A5C64
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 10:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbjISIVS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Sep 2023 04:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjISIVR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Sep 2023 04:21:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC22114
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 01:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695111625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GRJyxaNCdh5UcI/31P9hieAgHH3op5LoYI7ipTFtsHE=;
        b=N/0sc+/YqGA+ZRHtRNvTQpeIFjuLFuIGzmO+Cz5Hcp70fNUjZv+inKSVNFX8qtTLUgcMvr
        PPqmhXTnoe4sL56BmjlFjZ0BG0p8jPKSWpUxJWycsNTNwrRz+aJlCMu07eiTsX+BMi4Dqt
        BAabopYF2ZhpG7k+eFkgfUbOJus2VZ0=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-386-NHseDdFiP4-Dop5ldZf3jw-1; Tue, 19 Sep 2023 04:20:24 -0400
X-MC-Unique: NHseDdFiP4-Dop5ldZf3jw-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-502f46691b4so4744323e87.3
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 01:20:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695111623; x=1695716423;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :from:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GRJyxaNCdh5UcI/31P9hieAgHH3op5LoYI7ipTFtsHE=;
        b=h3gBZSoWRDG8VrSrxBM4I/nNFuDmvXFNNgPFkKJVbg4lkTIrU98SHwXP6FTXEN//yJ
         4H6wQXYp1ilaOkbLKTRzka1XPubMjOhfwtASZpyjizW2xE0gqQm2VEbpDTCpyQ37coNy
         l7Y4jHSq773dRuEx+KVe1g3u3fj4lS7W8aj8q/wcob8IsgI4LZe4EFT1xokhkLHTRglN
         knm0zeOJV7JJJ1zhNvoIr8SwFc9licM+MUyqmyRM0mBywZa3oJXL29SlEgipawi8mh0c
         nrvzAnrpsbmkuA5I/Xa0ml6n4xK5zkRZrJLEdX9seXjgSKKTY8Fj2/Onwt9kaeXbptet
         HSFw==
X-Gm-Message-State: AOJu0YwkSc80VxlopqF+WDaNTT3mXI2CHTtXU07eRj8V9s4SgfQdDQ8K
        zAohBa/h/IQu21RJjnHw0OQLfA5nOH9NXExTeFlApivRis1fI9txkTxXzDdZU/mmT/PWbFHE18K
        6Oeg8JCR4EWZC
X-Received: by 2002:a05:6512:2390:b0:502:f740:220 with SMTP id c16-20020a056512239000b00502f7400220mr11862962lfv.58.1695111622936;
        Tue, 19 Sep 2023 01:20:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEc41Tb6Foy5g1JTtZ7U0/DfIQOTmfhMsfTw2RpRAm0LCUxd+feKVGStpln1KWC8TLvLpMUhw==
X-Received: by 2002:a05:6512:2390:b0:502:f740:220 with SMTP id c16-20020a056512239000b00502f7400220mr11862926lfv.58.1695111622493;
        Tue, 19 Sep 2023 01:20:22 -0700 (PDT)
Received: from ?IPV6:2003:cb:c702:1300:c409:8b33:c793:108e? (p200300cbc7021300c4098b33c793108e.dip0.t-ipconnect.de. [2003:cb:c702:1300:c409:8b33:c793:108e])
        by smtp.gmail.com with ESMTPSA id n4-20020a1c7204000000b00402f713c56esm14476201wmc.2.2023.09.19.01.20.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Sep 2023 01:20:21 -0700 (PDT)
Message-ID: <90303827-7879-7b9e-836d-5026b2be73dd@redhat.com>
Date:   Tue, 19 Sep 2023 10:20:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 00/16] virtio-mem: Expose device memory through
 multiple memslots
Content-Language: en-US
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Michal Privoznik <mprivozn@redhat.com>,
        =?UTF-8?Q?Daniel_P_=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        kvm@vger.kernel.org
References: <20230908142136.403541-1-david@redhat.com>
 <87e38689-c99b-0c92-3567-589cd9a2bc4c@redhat.com>
Organization: Red Hat
In-Reply-To: <87e38689-c99b-0c92-3567-589cd9a2bc4c@redhat.com>
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

On 11.09.23 09:45, David Hildenbrand wrote:
> @MST, any comment on the vhost bits (mostly uncontroversial and only in
> the memslot domain)?
> 
> I'm planning on queuing this myself (but will wait a bit more), unless
> you want to take it.

I'm queuing this to

https://github.com/davidhildenbrand/qemu.git mem-next

and plan on sending a PULL request on Friday.

So if anybody has objections, please let me know ASAP :)

-- 
Cheers,

David / dhildenb

