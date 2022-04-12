Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B185C4FDA1A
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 12:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353570AbiDLJ6X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 05:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380208AbiDLIVb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 04:21:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BAD1330F65
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 00:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649749770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OG+b8XR8kIG1NTnOndyXW6RIWuaIfi44i3pndShsMQ8=;
        b=AdkudwlrVVsQWbakqCBhGFi0LgcNuKyV4WUiSP1ToF/Pq42uap4GrLwujytcDHhJv/M6XV
        7bVUVX9KUgGxzW3c16x/uBiDTDzfNT5XZJJ9vmWLsUzSwhs3NQWWEI6K2CH5hUDCOBM4eo
        AkshhZN8u39CuFHC8FYV67/IWsheIEs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-301-7wv63TatMy6pSnDOOySmnQ-1; Tue, 12 Apr 2022 03:49:29 -0400
X-MC-Unique: 7wv63TatMy6pSnDOOySmnQ-1
Received: by mail-wm1-f71.google.com with SMTP id r127-20020a1c4485000000b0038eaca2b8c9so918516wma.7
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 00:49:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OG+b8XR8kIG1NTnOndyXW6RIWuaIfi44i3pndShsMQ8=;
        b=gm8He8Q/0WE7YKUZxl0Jk8OJNuvnS/T7E7mq2W29YCSr1+n/YzXp+0iOuCS5gdvIAx
         k5p6iN8MNFvdcWUGoT7rIRbCbojRn7NzmorzZTORx0VXUqfNcZbSmLos+Rw3RSukAKq8
         ECctEs6Afr51K+g6Z9yxk3cJo1SluVF3ol+cj1QVgJF5c86kPkPB/yIvOkBHIYYnXpFJ
         r64HM9c25CdrEqRLN+Qc2C1ICA0APmxWfTYHA3enXDO+R90QrJJBXFwjyll/IFl47bDN
         ar2DFLLeQHI+MYPuCBzMpS9k4tKPWwzgrEm7TsZIbtwz9LOuaLPHIVjrTfJQzUL5SHvi
         e1Bw==
X-Gm-Message-State: AOAM530TibvErsgvfkLDtNkQX7KMVlpDj6svybhXBgdZGEuyhezKK3O1
        rLFKRyswYJrB7md8LkJDAdHVZZJUXyGsoTivPG8bSaZiABkyTWjosW0eprIEdDQeLXf9MCTGYoM
        rA/bmxTIKmS5f
X-Received: by 2002:a1c:7519:0:b0:38e:6bc6:ec7f with SMTP id o25-20020a1c7519000000b0038e6bc6ec7fmr2856343wmc.53.1649749768203;
        Tue, 12 Apr 2022 00:49:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw9Frwsa5AmU5trCGWjKgeNe3CigmzaFCanXNtpBZpPhgAf3HVbRSAYp4kZYEZxQqArgH+vVg==
X-Received: by 2002:a1c:7519:0:b0:38e:6bc6:ec7f with SMTP id o25-20020a1c7519000000b0038e6bc6ec7fmr2856325wmc.53.1649749767989;
        Tue, 12 Apr 2022 00:49:27 -0700 (PDT)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id q14-20020a1cf30e000000b0038986a18ec8sm1597083wmq.46.2022.04.12.00.49.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 00:49:27 -0700 (PDT)
Message-ID: <9e87f40c-3270-ebc3-7afe-13a3489940d1@redhat.com>
Date:   Tue, 12 Apr 2022 09:49:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [kvm-unit-tests PATCH v1 4/4] s390x: add selftest for migration
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com
References: <20220411100750.2868587-1-nrb@linux.ibm.com>
 <20220411100750.2868587-5-nrb@linux.ibm.com>
 <5073d0fc-1017-5be6-2ec5-2709be14c93c@redhat.com>
 <4b7a793f9ab64eb6c5375a12844006bc86c0c752.camel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <4b7a793f9ab64eb6c5375a12844006bc86c0c752.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/04/2022 09.41, Nico Boehr wrote:
> On Mon, 2022-04-11 at 17:30 +0200, Thomas Huth wrote:
>> Thanks for tackling this!
>>
>> Having written powerpc/sprs.c in the past, I've got one question /
>> request:
>>
>> Could we turn this into a "real" test immediately? E.g. write a sane
>> value
>> to all control registers that are currently not in use by the k-u-t
>> before
>> migration, and then check whether the values are still in there after
>> migration? Maybe also some vector registers and the "guarded storage
>> control"?
>> ... or is this rather something for a later update?
> 
> My plan was to first add the infrastructure for migration tests
> including the selftest and then later one by one add "real" tests.
> 
> But if you think it is preferable, I can extend the scope and add some
> inital "real" tests in this series.

I think a simple test that checks some register values should not be too 
hard to implement, so I'd prefer that instead of this simple selftest ... 
but if you're too short in time right now, I also won't insist.

  Thomas

