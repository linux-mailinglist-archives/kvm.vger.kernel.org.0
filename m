Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3ED94DA47A
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 22:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351920AbiCOVUz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 17:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244702AbiCOVUy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 17:20:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 198545B3F3
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 14:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647379181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7jUK/Zy3c/rIDtBsF8csvV0VQ7PgqvLYqxZFFngnNhM=;
        b=dhOTTN/Gw8Pa0jUX5nkag6O8mkP73vyNc4w+ekkaodxYMsl3XDQ1bTjtmaUHfGCjfJtKMb
        /rGbG10oEnrKjt1krLJI1hJ+VUFwGILynBs0Pp0RnG3mCq87fnFKD5aSPDGI1juPLjGfn6
        D7/fGkNkbM1otl0NaYxuig7cBbd1ylM=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-222-rD3waI9bMNOuzadb1z4kuw-1; Tue, 15 Mar 2022 17:19:40 -0400
X-MC-Unique: rD3waI9bMNOuzadb1z4kuw-1
Received: by mail-ej1-f69.google.com with SMTP id el10-20020a170907284a00b006db9df1f3bbso74299ejc.5
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 14:19:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7jUK/Zy3c/rIDtBsF8csvV0VQ7PgqvLYqxZFFngnNhM=;
        b=5NaUUkMREFFTR5pr4KXlrAmze6YND2lZGCx0SsGZ3Z2MgaGfUoG3Ag1g5mPW9RxBYU
         O8aHe9RUL75l8DgRREgMgkZbKB/WFi63Y62lNF45ihsbB7K6grqexW5RgTcmTc40vD2Y
         RdVxLJPZlzuTtKw/gKA7PPvWQZTy26OUhh0AvSNPxvYb92gMj8MqFTx0B2pgpoN9EMzq
         zhqzxHjJjXsqXJnZAf9XJ5KGAUOS9SSZTxzIHJtCrA3LhYhEeUf+8pQADo9Y+XIswaCs
         huqURz18b20rjbhQQ914QRnqkeyoKrBzyNCCsoxvDNCQYufKq59UfHyTgGRsx32epG/V
         e3cA==
X-Gm-Message-State: AOAM530QVgqpCDUkjdAuLyjsQkYWa343vtyYQqfpalnFcvztxnecJfBd
        Knu19jN/YsgDWK21s6SNWZldmzcJpE+iCDYXoNU6q3HqBDs/hS7hTTZ8JUEU86gHHHcP001ZEHL
        hmiH3g+0uwQmS
X-Received: by 2002:a50:a6d2:0:b0:418:63e1:e4ac with SMTP id f18-20020a50a6d2000000b0041863e1e4acmr16209295edc.169.1647379178872;
        Tue, 15 Mar 2022 14:19:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxGoQOeEdXSq9l09EDd9Ie4vogmFni75MTcsHW4UVuCdrEbQa5cQxionuGJWQcEe9HBBX5IXQ==
X-Received: by 2002:a50:a6d2:0:b0:418:63e1:e4ac with SMTP id f18-20020a50a6d2000000b0041863e1e4acmr16209280edc.169.1647379178687;
        Tue, 15 Mar 2022 14:19:38 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id z11-20020a50e68b000000b00412ec8b2180sm43881edm.90.2022.03.15.14.19.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Mar 2022 14:19:38 -0700 (PDT)
Message-ID: <f9c0542b-f2cc-c90d-1644-fba62a11e85d@redhat.com>
Date:   Tue, 15 Mar 2022 22:19:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [GIT PULL 0/7] KVM: s390: Fix, test and feature for 5.18 part 2
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
References: <20220315141137.357923-1-borntraeger@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220315141137.357923-1-borntraeger@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/15/22 15:11, Christian Borntraeger wrote:
> Paolo,
> 
> the 2nd chunk for 5.18 via kvm/next.
> 
> The following changes since commit 3d9042f8b923810c169ece02d91c70ec498eff0b:
> 
>    KVM: s390: Add missing vm MEM_OP size check (2022-02-22 09:16:18 +0100)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-next-5.18-2

Pulled, thanks.

Paolo

> for you to fetch changes up to 3bcc372c9865bec3ab9bfcf30b2426cf68bc18af:
> 
>    KVM: s390: selftests: Add error memop tests (2022-03-14 16:12:27 +0100)
> 
> ----------------------------------------------------------------
> KVM: s390: Fix, test and feature for 5.18 part 2
> 
> - memop selftest
> - fix SCK locking
> - adapter interruptions virtualization for secure guests

