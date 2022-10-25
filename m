Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDE560C898
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 11:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbiJYJms (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 05:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbiJYJmn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 05:42:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B219B9C2FC
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 02:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666690961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6+c6bP909bJHcHOCGyo96Lvt6YOrc+6UqMGU5ShIzww=;
        b=PS2lXyUHw93bOBF/6CZxcTGKi5ZF19dALBpVG02sxOEDXszCP8f/lEiLfQ9IQ2n4h1UmXj
        r065ltN7vsPrXO9qAFFDdMQfvVQgOwn3nJhkd2PQjBSrP/46JJmtxd0gafRfx3F6urw0xd
        g7NS0oUk3NveNp32Jh3CYkKJX/xHLj4=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-290-KA47IH4oPCCi9VO9nos_mA-1; Tue, 25 Oct 2022 05:42:40 -0400
X-MC-Unique: KA47IH4oPCCi9VO9nos_mA-1
Received: by mail-qv1-f72.google.com with SMTP id mi12-20020a056214558c00b004bb63393567so3344132qvb.21
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 02:42:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6+c6bP909bJHcHOCGyo96Lvt6YOrc+6UqMGU5ShIzww=;
        b=fk0r2tOgVrQi5FxGpxpznWaXxbGDZ/+cTtv7tR0uNXM0uW1nK6x2HoKNknWGLNxjct
         IyNQNA53inV5Bw9QDmba8xrCG/osbtXedN/f07N/ovuoUVnSMduEbamzpPM+fdTZFZ+t
         5Oa5V/vOyzcEvZhuipGm5j1BD8AdMWVo2ilnsvheW4vcIVimjkPflW4AkwAOwxFbCQM2
         zu4KG5bG6Yws410gsWFnlAnpNcypD6UeeE/7IZb5+KPjpqT/InEe36Me/NJ9g0P0xm+n
         jOe3MHnUnM0R/+gjWEypOViXHW7qlp+CDyi/0SjW+5W9sjhNP2bCvhSIgAYXQtJ/572k
         b8Uw==
X-Gm-Message-State: ACrzQf2TKVS1beCvYZ31cD3eqtGt9SMF2KKdZv6gKG7e6N2sdLptSPSQ
        tXOcBJHLhLfXoVUHZNfRigls9hM3HYBU7CTdSxvHgxo+q+pzUan2omtcqtw5jnMzN1GDyD52iAE
        CA0Wa1tTx9+Gz
X-Received: by 2002:a05:622a:1183:b0:39c:606d:1f7f with SMTP id m3-20020a05622a118300b0039c606d1f7fmr30963742qtk.313.1666690959635;
        Tue, 25 Oct 2022 02:42:39 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4u4PBjKEkxQAZBqNdtmV640oUq7rIw3hrHhUko3dJRZj5WH1kjJbMhGjw6D/OpPCGm27OjAg==
X-Received: by 2002:a05:622a:1183:b0:39c:606d:1f7f with SMTP id m3-20020a05622a118300b0039c606d1f7fmr30963731qtk.313.1666690959355;
        Tue, 25 Oct 2022 02:42:39 -0700 (PDT)
Received: from [10.201.49.36] (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.googlemail.com with ESMTPSA id x7-20020ac86b47000000b0039a372fbaa5sm1317028qts.69.2022.10.25.02.42.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Oct 2022 02:42:38 -0700 (PDT)
Message-ID: <58d6167b-e1bd-df9f-5518-3173a9ab0581@redhat.com>
Date:   Tue, 25 Oct 2022 11:42:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [GIT PULL] KVM patches for Linux 6.1-rc2
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Graf <graf@amazon.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20221023174307.1868939-1-pbonzini@redhat.com>
 <CAHk-=wgL7sh-+6mPk7FGCFtjuh36fhOLNRTT0_4g3yd380P0+w@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAHk-=wgL7sh-+6mPk7FGCFtjuh36fhOLNRTT0_4g3yd380P0+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/24/22 00:15, Linus Torvalds wrote:
> 
> compat_ptr() also happens to get the address space right (ie it
> returns a "void __user *" pointer). But since the non-compat 'struct
> kvm_msr_filter_range' bitmap member doesn't get that right either
> (because it uses the same type for kernel pointers as for user
> pointers - ugly uglt), that isn't such a big deal. The kvm code
> clearly doesn't do proper user pointer typing, and just uses random
> casts instead.
In general KVM ioctl arguments very rarely have __user pointers in them, 
so there's not much need for compat ioctls at all.  KVM_GET_DIRTY_LOG 
and KVM_CLEAR_DIRTY_LOG get it right, but this one indeed can be 
improved with compat_ptr().  Will do for 6.2, thanks for the review.

Paolo

