Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 548C37CB5D5
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 23:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233698AbjJPV6b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 17:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232845AbjJPV6a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 17:58:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357369B
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 14:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697493461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=tVT3RQmbEPAnJ6AuCvqmJQKzjg/BeKl9AJogP6t7wVs=;
        b=hBW6RcAllZ5ctDPySsrhgsnUCwrKQXNjn7nmB1iPMqk8I8U5hSyjirTk/7OnTErcqYsK1g
        FUvKHA4knVBMsHTGEHM8fOPV2dY3YDWWBWpDcgi+5zP2U2GHnYYVfr4eDxkAcOmBqisrl9
        YKhv43MTuqYyZ0pvKIrfuGnSytuuaTo=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-536-LKvdEKPSNHCglB8-FnRo_A-1; Mon, 16 Oct 2023 17:57:34 -0400
X-MC-Unique: LKvdEKPSNHCglB8-FnRo_A-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-9ae686dafedso363074866b.3
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 14:57:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697493453; x=1698098253;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tVT3RQmbEPAnJ6AuCvqmJQKzjg/BeKl9AJogP6t7wVs=;
        b=wJZocci6yAZZmSgO3MM0X+FNsrrpVMvazMnQaHYaAwRf9gPePuv8gNSYY9fOBbly6e
         wQzkBxQj13FfNdEpKC6qhOT0Ab3IZbA8+b9r2exDhlOF8OE4WVYc22sC8q66UiFGgGLz
         BatNScWlwWw4QfO9XXtxwzBpPqU70w2qt/nooIYxunZa0WTAknDPOG46kFObOyazDBP1
         /Jr0AzyOWg4pgZaq2MEFT6wHlxVuWohJrkJyOpMTbKo9DhGW+0h4ua6PZZIEXwAFY9yd
         VYPUkIyeqt6RaI0CKfIV49GuRErkmXoy+1gPZ/ggFuYiOfqfHDxFCPRZTsnVHD/Moo0W
         O2eQ==
X-Gm-Message-State: AOJu0YzAvIyr6Inf1hOnpnoz+AXfEPuXg5wM2MMZB1HeQeqz+VV6X5f5
        bMa5LrHEth6Aq9arY59Lve2hPJ7a89lbOQgJ7MqP/PCQ8I7U5R4yv/Rf9kWA2N6Odo/6vcyFHz/
        SH381tnwjGaN1
X-Received: by 2002:a17:907:6093:b0:9b6:550c:71cb with SMTP id ht19-20020a170907609300b009b6550c71cbmr230887ejc.52.1697493453621;
        Mon, 16 Oct 2023 14:57:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGe3chqMntXaEoNKREA/lVw1WsppNYDcnvOsG4u/56RSzqp7qbBZeUjBBKfBXwvI7lfv80xjQ==
X-Received: by 2002:a17:907:6093:b0:9b6:550c:71cb with SMTP id ht19-20020a170907609300b009b6550c71cbmr230870ejc.52.1697493453204;
        Mon, 16 Oct 2023 14:57:33 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id hv7-20020a17090760c700b009bd96eceeb3sm36982ejc.94.2023.10.16.14.57.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Oct 2023 14:57:32 -0700 (PDT)
Message-ID: <62e17c67-953d-469f-84cf-a998a15a8926@redhat.com>
Date:   Mon, 16 Oct 2023 23:57:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 4.14] KVM: x86: Backport support for interrupt-based
 APF page-ready delivery in guest
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Riccardo Mancini <mancio@amazon.com>
Cc:     bataloe@amazon.com, graf@amazon.de, kvm@vger.kernel.org,
        Greg Farrell <gffarre@amazon.com>
References: <877co1cc5d.fsf@redhat.com>
 <20231013163640.14162-1-mancio@amazon.com> <87a5si8xcu.fsf@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <87a5si8xcu.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/16/23 16:18, Vitaly Kuznetsov wrote:
> In case keeping legacy mechanism is a must, I would suggest you somehow 
> record the fact that the guest has opted for interrupt-based delivery 
> (e.g. set a global variable or use a static key) and short-circuit 
> do_async_page_fault() to immediately return and not do anything in this 
> case.

I guess you mean "not do anything for KVM_PV_REASON_PAGE_READY in this 
case"?

Paolo

