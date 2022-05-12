Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65F725249E6
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 12:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352441AbiELKCD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 06:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352479AbiELKB6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 06:01:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A57B03135C
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 03:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652349716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3arBzyEj0Y+10rY33HKP6mUUeQUbMaPvYDzVucF481c=;
        b=Ei8vjMSEuzKei3VGnrrRA3cFxJ3KA4eFo9t6IDp7gbRzQ7tVTC7yFsUIDZy4hnsKMs3UJO
        mBHqkZdhlZyCfvvMgAgqWfRV1tFdkj1vqPg/XjPN+tu97SpE1JvHVVLBOOQYEFUnDoMpPW
        UUxpoFsJCqnPfksUowpw4edAJWKClsc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-349-DAFFyQ8SPVmEmX5oQAqcKw-1; Thu, 12 May 2022 06:01:55 -0400
X-MC-Unique: DAFFyQ8SPVmEmX5oQAqcKw-1
Received: by mail-wm1-f71.google.com with SMTP id c125-20020a1c3583000000b0038e3f6e871aso1435770wma.8
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 03:01:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=3arBzyEj0Y+10rY33HKP6mUUeQUbMaPvYDzVucF481c=;
        b=5TfIVHjXCN23QKljyQh2PDEcTMe7/mA86slCKY/Js7IVLu5i3wPsVCHX2Za2hmITTX
         ao8yDoh2TSUNdghkqXgxx48+Xh3YRubecN5B9Bq+vEKb+KlHXYvxyGcekQ83QRxTXvTU
         MZEY6eVtWRyV6RyppiND2Ez4acFcx14DE3vH/+0sG54m3+tEWfdAVb3fvyIKJjeMb2T2
         fRT8GqHTWGA6CoSWR8MZLRtDlSHUXOsVNMGtIjiCGyJZ+tYa5NazbEAOt4Jx8qw6IiMJ
         HIYlMOzaaKbeORp4QbmKvCQJgPRUpKh5AdvGT61HbNsXunK2/SybXWP/j1prUykQlJs5
         GFdw==
X-Gm-Message-State: AOAM533194paqqAbu8HJOgOpuGHL01L2F6QkaFxWVP+ygSB109Ew3Jt8
        KiWOa/gtxC/JhA4UMrBfnfYkzFzz9qO0RxioPGl2kh2lFWMquVbgurVhTrSfuMzfkAgMK7YJ+26
        mlgKfmksyeeEp
X-Received: by 2002:a5d:4a0a:0:b0:20a:c899:cb7b with SMTP id m10-20020a5d4a0a000000b0020ac899cb7bmr27316349wrq.618.1652349714382;
        Thu, 12 May 2022 03:01:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxRhDGBs9YTvxkam9DUV8EFQnoG6RsdfM4bAsBLkkDwQvHU5eaODpobFR9pjyP7q6gQhfIqPA==
X-Received: by 2002:a5d:4a0a:0:b0:20a:c899:cb7b with SMTP id m10-20020a5d4a0a000000b0020ac899cb7bmr27316320wrq.618.1652349714148;
        Thu, 12 May 2022 03:01:54 -0700 (PDT)
Received: from ?IPV6:2003:cb:c701:d200:ee5d:1275:f171:136d? (p200300cbc701d200ee5d1275f171136d.dip0.t-ipconnect.de. [2003:cb:c701:d200:ee5d:1275:f171:136d])
        by smtp.gmail.com with ESMTPSA id w17-20020a05600018d100b0020c5253d90asm3878293wrq.86.2022.05.12.03.01.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 03:01:52 -0700 (PDT)
Message-ID: <70a7d93c-c1b1-fa72-0eb4-02e3e2235f94@redhat.com>
Date:   Thu, 12 May 2022 12:01:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v9 3/3] s390x: KVM: resetting the Topology-Change-Report
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        thuth@redhat.com, hca@linux.ibm.com, gor@linux.ibm.com,
        wintera@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20220506092403.47406-1-pmorel@linux.ibm.com>
 <20220506092403.47406-4-pmorel@linux.ibm.com>
 <76fd0c11-5b9b-0032-183b-54db650f13b1@redhat.com>
 <20220512115250.2e20bfdf@p-imbrenda>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220512115250.2e20bfdf@p-imbrenda>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>>
>> I think we prefer something like u16 when copying to user space.
> 
> but then userspace also has to expect a u16, right?

Yep.

-- 
Thanks,

David / dhildenb

