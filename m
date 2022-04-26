Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED03F5104E0
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 19:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348997AbiDZRJT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 13:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353660AbiDZRJG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 13:09:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0BF932FFD2
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 10:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650992757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+nUIB3g8f9uxnzNLN589WlRjcnfLvvRo4xwM30Nbexc=;
        b=WfAkWB7gMKfIM7NWtvT6olyNeEDDZOq2JJn//QHMhu/PM/cTQrDVQ7jmis5pZxoAx31hyv
        8R+XXUBcLe0Jd1VRj0rf0scPWaiMFOh3SnoeOk4e8v7VT7FQ3y/gFdS2CONf+KcdBA/I/Y
        IvOQwhWb2TxaX3qLaAtYCjIbhzEqtgw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-101-5RW1xqG7MSmuyuSRAfGMMQ-1; Tue, 26 Apr 2022 13:05:55 -0400
X-MC-Unique: 5RW1xqG7MSmuyuSRAfGMMQ-1
Received: by mail-wm1-f72.google.com with SMTP id b12-20020a05600c4e0c00b003914432b970so1112613wmq.8
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 10:05:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+nUIB3g8f9uxnzNLN589WlRjcnfLvvRo4xwM30Nbexc=;
        b=2dNHRbnnzR9O6iK1mqJMJYK+IlrwvDcgP8Nj+ONmrCWLQiCVF69Sd4v7jrgB4aA3mG
         3KkGuFVNJvPB20cdbwQhUDpeAS3iI5aouw4EqcSIWmOpehLuqrXBX5vuzuVmy17HdiqM
         IWZ/yXd22s/jR3obrsTKv7WjA3Y2jCtIgWpzQnJE8KMfvcBAA/SbkFc849bz8QeoF4zq
         c0xp08NuIK3IBGTQjajs8P3LDRkNQAEgSWia1n2kOcNu8We1n75jlB19H5wE81LD3etK
         RfdvjYYzHL8sc8nEJXRKOHTg461BPx7AS/s5V80irK+uSDq88p+ZB7ifBP51S1qctErr
         WJww==
X-Gm-Message-State: AOAM532BaP22JuYa0oHFS/wFAz2kSNYR3FJzed2i7+hpSTaXgkxxhacx
        bXJ/aDWDZyDoMTathmqjwn0a9csaBtU/78ySv0LV6HAKAsuvdL37Bpqm8bvjFuS+7z2kkDMhfxp
        DcHI/m0+hzl1C
X-Received: by 2002:adf:dc41:0:b0:205:8df5:464c with SMTP id m1-20020adfdc41000000b002058df5464cmr18116689wrj.445.1650992754143;
        Tue, 26 Apr 2022 10:05:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxuZrLw1rBDX+CrC9ywqaqqtxIaRdPySnx9uVgKsFcRPMNhSiimZEQCONPBD6w36u33OTBp9w==
X-Received: by 2002:adf:dc41:0:b0:205:8df5:464c with SMTP id m1-20020adfdc41000000b002058df5464cmr18116676wrj.445.1650992753890;
        Tue, 26 Apr 2022 10:05:53 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id u16-20020a05600c441000b0038ebcbadcedsm72325wmn.2.2022.04.26.10.05.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 10:05:53 -0700 (PDT)
Message-ID: <9eb9d0db-f8d1-e555-567c-b76a85997701@redhat.com>
Date:   Tue, 26 Apr 2022 19:05:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: Another nice lockdep print in nested SVM code
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>
References: <8aab89fba5e682a4215dcf974ca5a2c9ae0f6757.camel@redhat.com>
 <17948270d3c3261aa9fc5600072af437e4b85482.camel@redhat.com>
 <7a627c97-0fb1-cb35-8623-7893e228852c@redhat.com>
 <2dea96f99ee7b3b47702292a699d9ac7af1afaaf.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <2dea96f99ee7b3b47702292a699d9ac7af1afaaf.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/26/22 18:56, Maxim Levitsky wrote:
>> Yeah, in that case I can't think of anything better than triple fault.
>>
>> Paolo
>>
> But do you think that it would be better to keep the vmcb12 page mapped/pinned while doing the nested run
> which will both solve the problem of calling sleeping function and allow us
> to remove the case of map failing on vm exit?
> 
> If I remember correctly, vmx does something like that.

Yes, it does, but that's because vmx would have to do a lot of mapping 
and unmapping for vmread/vmwrite on highmem (32-bit) kernels.  So it 
maps at vmptrld and unmaps and vmclear.  I wouldn't consider it an 
example to follow.

Paolo

