Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACE7E5620F0
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 19:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235411AbiF3RLU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 13:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235463AbiF3RLS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 13:11:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2351D3EF31
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 10:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656609075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JUOdzSO2oUbBwTqVsnQybwkshzKjPN1FQaK1nqX25to=;
        b=aGXD9F5F5PXAknVJSAZSuXSXJRX3vMmPT+q4ZRFuAj/7iZwWt7OLQNQgcLxoWZBWSwIeGN
        78vY4CkTAP43ShIvUEC1Zkkkz4ywx0jB7vEEvXbWduISkaoVJZb5H+o8ARUbi+DAtqO5f+
        tzNLyIKex5IFatfHnbB5koZm7HH+COM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-448-s7RmowzkPruPU1cMCE7ivA-1; Thu, 30 Jun 2022 13:11:12 -0400
X-MC-Unique: s7RmowzkPruPU1cMCE7ivA-1
Received: by mail-wm1-f70.google.com with SMTP id v8-20020a05600c214800b003a1819451b1so1166756wml.7
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 10:11:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JUOdzSO2oUbBwTqVsnQybwkshzKjPN1FQaK1nqX25to=;
        b=2hxd+DCKjVkMXl4Hnm62WHk581faPsiAtNrTdGdfNTdjr25N5IAZmkHNPi5qDwukk7
         JWygGO26xl22mX1mw909GJcJzW57Xq45hUi5LrmumCZv37QndZCOR+ZkBLvytrR0rKAE
         JEa6pAF6CwxMMs9zMMatujPaJEtOQot+b8k6lLy5O1x75pkfkzB81aU9YEN2NcLxHZqJ
         Yd4otXSnJqtJSSwfR6qyqgngW27kuBBCDrmFExhgVUNeWf70nPQwInQKiQk4bQhHrAq3
         w5sEz+Tdqjva0RfN2emuvPGnIwWf/FVKEnyPf0JzQK6wDWp6ZHm9OrW1SysK2+OiqjAd
         Iqcg==
X-Gm-Message-State: AJIora/bDS889covy3bAxQ+nmejEdGMtgeHMRzKK/FSF/JxUWfmJJjRw
        V1vkJR0XmYlPtfbaIVpl9WkO6ltnXTw46kvfrDcJJ5dWTaObycCvmhqvk7Cd6Hvd5u/StkKmpMk
        +p8Yoh7ZSjYrE
X-Received: by 2002:a05:600c:1d96:b0:3a0:30b6:bb1a with SMTP id p22-20020a05600c1d9600b003a030b6bb1amr12787107wms.93.1656609070902;
        Thu, 30 Jun 2022 10:11:10 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s10GRhnhicYja7eIwUqagyOtGj985hy18rMk27XChhm0UIb5PrlgWH3C/QnwSYivs8HJgcbQ==
X-Received: by 2002:a05:600c:1d96:b0:3a0:30b6:bb1a with SMTP id p22-20020a05600c1d9600b003a030b6bb1amr12787092wms.93.1656609070585;
        Thu, 30 Jun 2022 10:11:10 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-179-66.web.vodafone.de. [109.43.179.66])
        by smtp.gmail.com with ESMTPSA id m9-20020a056000024900b0020c5253d907sm3704470wrz.83.2022.06.30.10.11.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 10:11:09 -0700 (PDT)
Message-ID: <c58d2ce5-66c0-2072-5788-9463a6003888@redhat.com>
Date:   Thu, 30 Jun 2022 19:11:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [kvm-unit-tests PATCH v1 3/3] s390x: add pgm spec interrupt loop
 test
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com
References: <20220630113059.229221-1-nrb@linux.ibm.com>
 <20220630113059.229221-4-nrb@linux.ibm.com>
 <dd270d92-a5dc-8a75-0edc-e9fdbb254cc9@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <dd270d92-a5dc-8a75-0edc-e9fdbb254cc9@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/06/2022 16.38, Janis Schoetterl-Glausch wrote:
> On 6/30/22 13:30, Nico Boehr wrote:
>> An invalid PSW causes a program interrupt. When an invalid PSW is
>> introduced in the pgm_new_psw, an interrupt loop occurs as soon as a
>> program interrupt is caused.
>>
>> QEMU should detect that and panick the guest, hence add a test for it.
> 
> Why is that, after all in LPAR it would just spin, right?

Not sure what the LPAR is doing, but the guest is certainly completely 
unusable, so a panic event is the right thing to do here for QEMU.

> Also, panicK.
> How do you assert that the guest doesn't spin forever, is there a timeout?

I agree, it would be good to have a "timeout" set in the unittests.cfg for 
this test here (some few seconds should be enough).

  Thomas

