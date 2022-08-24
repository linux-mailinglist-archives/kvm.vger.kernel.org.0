Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3372B59F559
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 10:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235800AbiHXIcK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 04:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236021AbiHXIb5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 04:31:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560A47FE53
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 01:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661329905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3QSwGcSUNyfs2IVdfNC4n+71Rc4AYhdi1BVhqDrMV0Y=;
        b=jIkII7z9k0OjogIsGXSMIGIsXcOr1qcEl06ZTs6ngw6HHiadC3xPTBvOsDfbog5TN7C3zy
        IwLljR8ZWxr8EhHjZf34VsG/ruq4eURhM3g7abm3NG3sYkMbfC0d+KjoWvaQBDTPUTVhuR
        62etK1WRyWeazzjTEt7bAP6FpAPXsLk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-284-k2vFJ464PHaPnNr-ZvsEfg-1; Wed, 24 Aug 2022 04:31:41 -0400
X-MC-Unique: k2vFJ464PHaPnNr-ZvsEfg-1
Received: by mail-wm1-f69.google.com with SMTP id c5-20020a7bc005000000b003a63a3570f2so250495wmb.8
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 01:31:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=3QSwGcSUNyfs2IVdfNC4n+71Rc4AYhdi1BVhqDrMV0Y=;
        b=uf5eUNx1Wr8XAzl9XcOulI0MiunST30qbb02OfVDQ0T6TNYePSFwsGIJiJOFxxCZfR
         iE+wdtLo3t1MM0eZ1xiC+YHK3COBFijMLeKB1WtxlRG8fL1ujG3Btn54N7vxtT0SrdEf
         om8GVR4n31nsOJBhjSHicSpzYAWy/0XU4taANsqIIFgLPApN3xkS8l+N8/ziDIkT/9+H
         JQdlEUv340ls6C91yGofL5Rcf28GRac5j/R7n6e/jwgs4tzcUrrDNEpZqJ2i521shRn1
         WABc0RlYf5+6pPwkke9ky8DSb4dY5AehKZaccbXJzV1lY+tyihfTLrZZqNIYrnHP5cne
         nd0Q==
X-Gm-Message-State: ACgBeo2HjVKAr1XzC9Wv4EDWImYi5d1ROmf9En0lVe2JReY6VWLgpLWM
        TpaeH16f5R2kd9BA7C/bDLsqEcc6WvERYEi6DCh2hbfW+bXbKHoG5JoB46wknp9gno52csS8Jlp
        +ezfcv925RyVS
X-Received: by 2002:adf:f282:0:b0:221:7a12:7a48 with SMTP id k2-20020adff282000000b002217a127a48mr15676866wro.459.1661329900328;
        Wed, 24 Aug 2022 01:31:40 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6HMAAQLGpSp5c94wFyGDJMLuYGKo8lZ2SJ6DkBGWKu7YpHPllMZSfd5YG5xHA/JHuQlhXiaQ==
X-Received: by 2002:adf:f282:0:b0:221:7a12:7a48 with SMTP id k2-20020adff282000000b002217a127a48mr15676849wro.459.1661329900046;
        Wed, 24 Aug 2022 01:31:40 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-176-177.web.vodafone.de. [109.43.176.177])
        by smtp.gmail.com with ESMTPSA id g17-20020a5d46d1000000b0020fff0ea0a3sm16317919wrs.116.2022.08.24.01.31.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Aug 2022 01:31:39 -0700 (PDT)
Message-ID: <e9b6b40e-f2ad-9f03-71e7-8c3412924520@redhat.com>
Date:   Wed, 24 Aug 2022 10:31:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [kvm-unit-tests PATCH v3 1/1] s390x: verify EQBS/SQBS is
 unavailable
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     imbrenda@linux.ibm.com
References: <20220803135851.384805-1-nrb@linux.ibm.com>
 <20220803135851.384805-2-nrb@linux.ibm.com>
 <b1383c10-fa60-56b5-7d57-7d6d59efd572@redhat.com>
 <b238301e-3f43-062e-920d-d322548c55ba@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <b238301e-3f43-062e-920d-d322548c55ba@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/08/2022 09.40, Janosch Frank wrote:
> On 8/4/22 00:17, Thomas Huth wrote:
>> On 03/08/2022 15.58, Nico Boehr wrote:
>>> QEMU doesn't provide EQBS/SQBS instructions, so we should check they
>>> result in an exception.
>>
>> I somewhat fail to see the exact purpose of this patch... QEMU still doesn't
>> emulate a lot of other instructions, too, so why are we checking now these
>> QBS instructions? Why not all the others? Why do we need a test to verify
>> that there is an exception in this case - was there a bug somewhere that
>> didn't cause an exception in certain circumstances?
> 
> Looking at the patch that introduced the QEMU handlers (1eecf41b) I wonder 
> why those two cases were added. From my point of view it makes sense to 
> remove the special handling for those two instructions.

Ah, there are handlers for these instructions in QEMU - that's what I was 
missing. But I agree with you, these do not look very useful and should just 
be dropped on the QEMU side.

  Thomas

