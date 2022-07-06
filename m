Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98D9F568642
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 12:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233169AbiGFK4o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 06:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232377AbiGFK4m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 06:56:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EBFC327CF0
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 03:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657104998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z/wJBIQMjQXHihYW5LMkQtlLCNLD2Wr07KvMl7IsHW4=;
        b=EZgP9vbru6aNLDiq4P9R6cBxVDO2AJOtsoHopn9+NZqOH5Pli2AVLqRIYSgzHcFCOFesYg
        QwjbVB2Akch5Q1l+GoH6E+YzTnMsp3ECXdqSOO7w5Ot6qbvSirhVUqq8tPAeeE/IQ7LbsK
        2lOvLS3TqhuAmU0tztHofzUJZAn6Ptk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-3LK_uJJFNPaPbpItZboZng-1; Wed, 06 Jul 2022 06:56:37 -0400
X-MC-Unique: 3LK_uJJFNPaPbpItZboZng-1
Received: by mail-wm1-f72.google.com with SMTP id 130-20020a1c0288000000b003a18127d11aso7129316wmc.6
        for <kvm@vger.kernel.org>; Wed, 06 Jul 2022 03:56:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Z/wJBIQMjQXHihYW5LMkQtlLCNLD2Wr07KvMl7IsHW4=;
        b=Akz9Z2SPz/YQKOl4y50Z0bb+cHNxx2tUlP+jn6AL0XwEWAFOF94aEsxf5vWTF/pRVo
         2iftHCO1CzFHaP+xTNTy1CRaWblj+JIy0aoqa/nzV2c59vX3dtVuPfOpbsXGJlszLq3/
         98Z866lZpbbnZ+W5+FbMWahMQQ7h+ir2gbNok0XboWQaEpJjrCTB2SZCIrU+NqOyl8pr
         N9YRGC2eZbJtctr/38e22hxaGkLwdqFZ58sF1e6n1SUGXZEZmlxW9mc7g/050d13KbmG
         +cngiBbQlu++CokElLf6nDp0SjWkJasHtXqQAGnhqaLU7xqa9My9MRGFaEVHcImkkMjC
         d/9w==
X-Gm-Message-State: AJIora+TanJO7GHEpx8nV9YdRO7qeKddkeGeMueY8SiagKEFnbZnuNIr
        XuLjjvA2MD0brJJ9DaXl0JoNVlCEVNAlZkHa+WrW0iZvmwbjx1tl8u0MwEYSpGwRKkrZF3UcfH5
        1t8iES/rBANN2
X-Received: by 2002:adf:d845:0:b0:21d:7aad:4802 with SMTP id k5-20020adfd845000000b0021d7aad4802mr3960296wrl.298.1657104996676;
        Wed, 06 Jul 2022 03:56:36 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tVRo3xdQzziMgNyy3w+U0LX+6pVPdWBhaUjBqu26EhEo4yp8pMXXkY8E7GbEjBz4b071ZXcw==
X-Received: by 2002:adf:d845:0:b0:21d:7aad:4802 with SMTP id k5-20020adfd845000000b0021d7aad4802mr3960271wrl.298.1657104996459;
        Wed, 06 Jul 2022 03:56:36 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-176-21.web.vodafone.de. [109.43.176.21])
        by smtp.gmail.com with ESMTPSA id r11-20020adfce8b000000b0021d77625d90sm3176005wrn.79.2022.07.06.03.56.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jul 2022 03:56:36 -0700 (PDT)
Message-ID: <932d0d05-5518-da8b-ef9f-986cf6b613e0@redhat.com>
Date:   Wed, 6 Jul 2022 12:56:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] s390x: split migration test into vector and gs test
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com
References: <20220704133002.791395-1-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220704133002.791395-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/07/2022 15.30, Nico Boehr wrote:
> Since we now have a few more migration tests, let's split migration.c
> into two files for vector and gs facilities. Since guarded-storage and vector
> facilities can be en-/disabled independant of each other, this simplifies the
> code a bit and makes it clear what the scope of the tests is.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   s390x/Makefile                         |   3 +-
>   s390x/migration-gs.c                   | 122 +++++++++++++++++++++++++
>   s390x/{migration.c => migration-vec.c} |  54 +----------
>   s390x/unittests.cfg                    |  15 ++-
>   4 files changed, 136 insertions(+), 58 deletions(-)
>   create mode 100644 s390x/migration-gs.c
>   rename s390x/{migration.c => migration-vec.c} (77%)

Makes sense.

Acked-by: Thomas Huth <thuth@redhat.com>

PS: Please have a look at the end of the README.md file to see how to set a 
better default subjectprefix for k-u-t patches. Thanks!

