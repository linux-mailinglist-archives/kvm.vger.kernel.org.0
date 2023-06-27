Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE08373F651
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 10:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbjF0ICa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 04:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbjF0ICV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 04:02:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE5E1FC7
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 01:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687852891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oZVrQ3elX4XCNFCp5FYtuzZCCkQ+mBaJA/Ngz6/9n5g=;
        b=Q6B7Dy5rkzntzlrlfxoxUR5DwLFTh2Ub+K5FB+od2+egd+KNPg/n/hDPLOOZRAxha9BJDp
        UQpC3iU0WjjtzDsGchWIhqdo8GIFgKljIrawQnIobEC6uNrAbbNnIDDhUGQdtzI7HpGcYj
        h7BOAW3dFV3+B/99WeIs7eP6e4ajYrw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-465-Z0aFKDevOZOm1XzNYy5f0w-1; Tue, 27 Jun 2023 04:01:27 -0400
X-MC-Unique: Z0aFKDevOZOm1XzNYy5f0w-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-98277fac2a1so312679266b.3
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 01:01:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687852883; x=1690444883;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oZVrQ3elX4XCNFCp5FYtuzZCCkQ+mBaJA/Ngz6/9n5g=;
        b=UEBXMz+UixKOrlq+G2YPiUTrUN2oEPATNBE0MvpafjQZxBcteNRzUUiBHAc9jJ+wtJ
         wJgDlE+bgCAc21m59BUERLbULtufIQyUiBzDwiumjycQMvKUfGClM5WBtLHFtdpgBRS+
         fjUsfpEPpmm45laBkLVYfP5qZXFPThn6aFyB6+N73Mn6WcEDm+Jz+mDMjC5TdhmF3Bgz
         V2IDQVnTjG3gPzc0mqIYcQvZ9YtvuwYdf1pxZLvm8ie2Rtc4uPqFIOcqyZkAxXT9jeNF
         JpAmow8Kq1zY8eLa5GyOYopflu4bZCisprdxN+L0+KokZw73Y80mm6V/JZW8EWfR4ELc
         p28Q==
X-Gm-Message-State: AC+VfDzBA8QDTbngs5/RSZULgujGgoPT3XHVHk5JGiCywiLI2a1pVtRk
        99NH65rpUroCGgaxcpXWJHkD+E7UMJwOvJUNwMu5dRkHhw8u/ldHdhR97Qu1Y4C12aNsKvQQDjF
        mW/7aVCPEq4cl
X-Received: by 2002:a17:907:16a1:b0:988:d1d5:cd5b with SMTP id hc33-20020a17090716a100b00988d1d5cd5bmr22462635ejc.75.1687852883133;
        Tue, 27 Jun 2023 01:01:23 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7Z0J/vWmfnxp6OJSKZUcEDuPdK0byEs7sKI3sU5hfyvYS5pWlrPir4/Xy8z0GyEbfTC147Zw==
X-Received: by 2002:a17:907:16a1:b0:988:d1d5:cd5b with SMTP id hc33-20020a17090716a100b00988d1d5cd5bmr22462601ejc.75.1687852882783;
        Tue, 27 Jun 2023 01:01:22 -0700 (PDT)
Received: from sgarzare-redhat (host-87-11-6-160.retail.telecomitalia.it. [87.11.6.160])
        by smtp.gmail.com with ESMTPSA id re3-20020a170906d8c300b00977ca5de275sm4307511ejb.13.2023.06.27.01.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 01:01:22 -0700 (PDT)
Date:   Tue, 27 Jun 2023 10:01:11 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v4 00/17] vsock: MSG_ZEROCOPY flag support
Message-ID: <vqh472etosyyht53hd3bafvtuaedwhqsuqwdbmfkd6lyvxkkgq@mnp42ujut5ox>
References: <20230603204939.1598818-1-AVKrasnov@sberdevices.ru>
 <kilgxopbdguge4bd6pfdjb3oqzemttwzf4na54xurwl62hi7uc@2njjwuhox3al>
 <352508dd-1ea2-5d2d-9ccf-dfcfbd2bb911@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <352508dd-1ea2-5d2d-9ccf-dfcfbd2bb911@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023 at 07:55:58AM +0300, Arseniy Krasnov wrote:
>
>
>On 26.06.2023 19:15, Stefano Garzarella wrote:
>> On Sat, Jun 03, 2023 at 11:49:22PM +0300, Arseniy Krasnov wrote:

[...]

>>>
>>>           LET'S SPLIT PATCHSET TO MAKE REVIEW EASIER
>>>
>>> In v3 Stefano Garzarella <sgarzare@redhat.com> asked to split this patchset
>>> for several parts, because it looks too big for review. I think in this
>>> version (v4) we can do it in the following way:
>>>
>>> [0001 - 0005] - this is preparation for virtio/vhost part.
>>> [0006 - 0009] - this is preparation for AF_VSOCK part.
>>> [0010 - 0013] - these patches allows to trigger logic from the previous
>>>                two parts.
>>> [0014 - rest] - updates for doc, tests, utils. This part doesn't touch
>>>                kernel code and looks not critical.
>>
>> Yeah, I like this split, but I'd include 14 in the (10, 13) group.
>>
>> I have reviewed most of them and I think we are well on our way :-)
>> I've already seen that Bobby suggested changes for v5, so I'll review
>> that version better.
>>
>> Great work so far!
>
>Hello Stefano!

Hi Arseniy :-)

>
>Thanks for review! I left some questions, but most of comments are clear
>for me. So I guess that idea of split is that I still keep all patches in
>a big single patchset, but preserve structure described above and we will
>do review process step by step according split?
>
>Or I should split this patchset for 3 separated sets? I guess this will be
>more complex to review...

If the next is still RFC, a single series is fine.

Thanks,
Stefano

