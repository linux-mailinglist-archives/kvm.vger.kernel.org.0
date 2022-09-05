Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82A75AD784
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 18:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbiIEQc5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 12:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbiIEQcu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 12:32:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604042FFE2
        for <kvm@vger.kernel.org>; Mon,  5 Sep 2022 09:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662395568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nq/yrAoY/S8Xm7ZtUA1bcp3k0IAyIFeAXHDNpfXqDek=;
        b=IXHOLSKjW3jzQvSuaJh5cjXqImf+B4kQKWQYjNDK0J6zgwafiOIlIQFnb/tx7L1uSebm/h
        x5GXGlr04z4t5qPNqal/Jm7JoTZiAp461lrIU+5b+v6a2Sj1HXSWMdCQvQFJBF92yzGaKw
        8nyYbACaGS+ziBy6oiDGkm0OeQeC3OU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-648-oI5QDtjKMI6nOOu-V3NRPQ-1; Mon, 05 Sep 2022 12:32:32 -0400
X-MC-Unique: oI5QDtjKMI6nOOu-V3NRPQ-1
Received: by mail-wm1-f71.google.com with SMTP id h133-20020a1c218b000000b003a5fa79008bso7634855wmh.5
        for <kvm@vger.kernel.org>; Mon, 05 Sep 2022 09:32:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=Nq/yrAoY/S8Xm7ZtUA1bcp3k0IAyIFeAXHDNpfXqDek=;
        b=kef8YcmKYjoZpbUDw+Q6CZIzAB3rnx+yIAC27MzRruXH45akVyeC8qTl+7mQOnsf/s
         NfE1QhmHsSQuwZGJVMu58EYC61OiRKqu+id4Hea1gU6qbfPTDojqL3DatSCMkuOsIvGG
         gQ9wWan1AjqPFGRBwU+HgzsO0Npnlme+nGRDlrd+uwNP4RQGdkW3wvygHYM824Bv3My8
         NlXgsvFAzGQHPMyzL0iCkxLkHaxiJ141t2TATwaH3Lk4jBhXcudcA3gBWiAQajln3bHl
         IpTMCqQhkF221fQSr4Jb7jPeGwJIe/UTH6fZKT+lJUC1D//eG6jSN5fdf1mu4+14inl8
         tmYg==
X-Gm-Message-State: ACgBeo2iLOpu9PPnlMDFREYAuR+FttgUbU8YIrP2iCAmAxYbb7+BqJpf
        7HQWnpwVpMtT1PatXBqaZ4dOkz0lOT54LyqLw2M0GHOhkvUlhp9J0C136dL6f2xbp1QCMF7IqzA
        kX46qLfJMcT/x
X-Received: by 2002:a05:600c:410c:b0:3ab:ac5:c126 with SMTP id j12-20020a05600c410c00b003ab0ac5c126mr10014968wmi.158.1662395551505;
        Mon, 05 Sep 2022 09:32:31 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7UaTlgCWrird/WwC6iciEBOOSvADvM81ZF6WYU89A5DSeixda30BJUGqKXUQGmLy6BKMHOWQ==
X-Received: by 2002:a05:600c:410c:b0:3ab:ac5:c126 with SMTP id j12-20020a05600c410c00b003ab0ac5c126mr10014954wmi.158.1662395551253;
        Mon, 05 Sep 2022 09:32:31 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0d:ba00:c951:31d7:b2b0:8ba0? (p200300d82f0dba00c95131d7b2b08ba0.dip0.t-ipconnect.de. [2003:d8:2f0d:ba00:c951:31d7:b2b0:8ba0])
        by smtp.gmail.com with ESMTPSA id bd7-20020a05600c1f0700b003a331c6bffdsm11341158wmb.47.2022.09.05.09.32.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Sep 2022 09:32:30 -0700 (PDT)
Message-ID: <08c54ddd-b74e-9f6c-f5eb-13e994530ad6@redhat.com>
Date:   Mon, 5 Sep 2022 18:32:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, svens@linux.ibm.com
References: <20220905084148.234821-1-pmorel@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH] KVM: s390: vsie: fix crycb virtual vs physical usage
In-Reply-To: <20220905084148.234821-1-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05.09.22 10:41, Pierre Morel wrote:
> Prepare VSIE for architectural changes where lowmem kernel real and
> kernel virtual address are different.

Bear with me, it used to be

	crycb = (struct kvm_s390_crypto_cb *) (unsigned long)crycb_o;
	apcb_o = (unsigned long) &crycb->apcb0;

and now it's

	apcb_o = crycb_o + offsetof(struct kvm_s390_crypto_cb, apcb0);


So the real issue seems to be

	crycb = (struct kvm_s390_crypto_cb *) (unsigned long)crycb_o;

because crycb_o actually is a guest address and not a host address.


But now I'm confused, because I would have thought that the result 
produced by both code would be identical (I completely agree that the 
new variant is better).

How does this interact with "lowmem kernel real and kernel virtual 
address are different." -- I would have thought that &crycb->apcb0 
doesn't actually access any memory and only performs arithmetical 
operations?

> 
> When we get the original crycb from the guest crycb we can use the
> phys_to_virt transformation, which will use the host transformations,
> but we must use an offset to calculate the guest real address apcb
> and give it to read_guest_real().

Can you elaborate where phys_to_virt() comes into play?

If this is an actual fix (as indicated in the patch subject), should 
this carry a

	Fixes: 56019f9aca22 ("KVM: s390: vsie: Allow CRYCB FORMAT-2")

-- 
Thanks,

David / dhildenb

