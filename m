Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1C106569BE
	for <lists+kvm@lfdr.de>; Tue, 27 Dec 2022 12:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiL0LMK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Dec 2022 06:12:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiL0LMJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Dec 2022 06:12:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 645DE2E9
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 03:11:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672139481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WsCNe46n9ddWwjhOAxc7hwn4WEFVPHSKWtHXt0UTIho=;
        b=IhOlla4eZDRHqJ32dHnt36DuxTHtEB561GWBD7wB+w8AHj11fMAAWAfntlBRGx6keiL6lW
        gW7spfiG0Fge1/Hh6bwx2hloXE1v7jFP7qRBUrZzhzsIJs5iYJJTgNS+/N7nN+G3EKUJBX
        YiTb4UfEYczwrfd3gdAiaJwNdmOVhWo=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-474-TILfDWKAPVeU9YQpzqAzEg-1; Tue, 27 Dec 2022 06:11:20 -0500
X-MC-Unique: TILfDWKAPVeU9YQpzqAzEg-1
Received: by mail-ej1-f70.google.com with SMTP id hs18-20020a1709073e9200b007c0f9ac75f9so8813740ejc.9
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 03:11:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WsCNe46n9ddWwjhOAxc7hwn4WEFVPHSKWtHXt0UTIho=;
        b=TUi71swVUZos6ryPFYxn+DcqSyh5tfScq9zmABon9SjXEXyw70zkRml4791wMDbXVM
         VWlOMDaCfLfkXdZx9opT2ra1Cf83Gslb5Za563AoNvcGerp9MidX9szW30VN4rz0dcl0
         s2w+LfNmISQuogXuB4mX3rhVJ/eyzRW6F0fMN6CbHeGlNTGyYh44jePvT1277qWlXXbq
         4TQLpzFMlao+hZ+AWWKx+FnVEPgREImbRvAcluD6vQlGaaj1RqeA8Zn9OdoxuZfwCsab
         9EAqalQhVnDAFrirQVHxLJzWreSCcm7sHJUSroC4fYaNYjAwh6LxE3Fc78OZzAPAAZkW
         HgvQ==
X-Gm-Message-State: AFqh2kr6wG88L9DX0V+dyNr+PECUZk1p/7nqaKXJsSLdozfqS2vdN7lS
        epeCx8QfxUQm9kVSsgCe0oynzA7DnB68vKC7cm0UBp5VNQbjKqKtBZwwjGdoys6FkTXCsM9Ozx9
        BMvJHrZSSAvlY
X-Received: by 2002:a17:907:a641:b0:7c0:f7b0:95d3 with SMTP id vu1-20020a170907a64100b007c0f7b095d3mr18622113ejc.36.1672139479179;
        Tue, 27 Dec 2022 03:11:19 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvx+3qzO3Q7VgBQjTVzHdY5jtx7sniGAOvp1pB7Qo1ua/wfSk6LVTR6kHvV2aASTgoNanZEig==
X-Received: by 2002:a17:907:a641:b0:7c0:f7b0:95d3 with SMTP id vu1-20020a170907a64100b007c0f7b095d3mr18622102ejc.36.1672139478920;
        Tue, 27 Dec 2022 03:11:18 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id 13-20020a170906300d00b007c0985aa6b0sm5904469ejz.191.2022.12.27.03.11.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Dec 2022 03:11:18 -0800 (PST)
Message-ID: <af3846d2-19b2-543d-8f5f-d818dbdffc75@redhat.com>
Date:   Tue, 27 Dec 2022 12:11:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC PATCH 1/2] KVM: x86/xen: Fix use-after-free in
 kvm_xen_eventfd_update()
Content-Language: en-US
To:     Michal Luczaj <mhal@rbox.co>, kvm@vger.kernel.org
Cc:     dwmw2@infradead.org, paul@xen.org, seanjc@google.com
References: <20221222203021.1944101-1-mhal@rbox.co>
 <20221222203021.1944101-2-mhal@rbox.co>
 <42483e26-10bd-88d2-308a-3407a0c54d55@redhat.com>
 <ea97ca88-b354-e96b-1a16-0a1be29af50c@rbox.co>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <ea97ca88-b354-e96b-1a16-0a1be29af50c@rbox.co>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/24/22 12:14, Michal Luczaj wrote:
>> This lock/unlock pair can cause a deadlock because it's inside the SRCU
>> read side critical section.  Fortunately it's simpler to just use
>> mutex_lock for the whole function instead of using two small critical
>> sections, and then SRCU is not needed.
> Ah, I didn't think using a single mutex_lock would be ok. And maybe that's
> a silly question, but how can this lock/unlock pair cause a deadlock? My
> assumption was it's a*sleepable*  RCU after all.
> 

This is a pretty simple AB-BA deadlock, just involving SRCU and a mutex 
instead of two mutexes:

Thread 1			Thread 2
				mutex_lock()
srcu_read_lock()
mutex_lock()  // stops here
				synchronize_srcu()  // stops here
				mutex_unlock()
mutex_unlock()
srcu_read_unlock()

Thread 2's synchronize_srcu() is waiting for srcu_read_unlock(), which 
however won't happen until thread 1 can take the mutex.  But the mutex 
is taken by thread 2, hence the deadlock.

Paolo

