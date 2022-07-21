Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1728C57CDE6
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 16:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiGUOmN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 10:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGUOmN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 10:42:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 408927C19C
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 07:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658414531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ETGjmT2JL2PraKGO03bftrjJZ3DkGyZ8T/dEPja2F48=;
        b=BlHnIf1crdO/AB1oNF9Ycvk/kLCpKOfOlJrSkVEH1a0jDuy+hXlIND6FzZrdUGvJRk2c/R
        cTgrthmRDKvGhGFkNYwXm9BK51Ra0hyDGeYnoF5pT0O/ajKjOzMG8LCh3VG298lWFX4+d2
        hoyEEvFkUf5kf7y2gE3upziYoVSmU/k=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-364-wzYUva3nOQ-Ny-N72KFnJw-1; Thu, 21 Jul 2022 10:42:07 -0400
X-MC-Unique: wzYUva3nOQ-Ny-N72KFnJw-1
Received: by mail-ed1-f70.google.com with SMTP id w15-20020a056402268f00b0043ac600a6bcso1244706edd.6
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 07:42:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ETGjmT2JL2PraKGO03bftrjJZ3DkGyZ8T/dEPja2F48=;
        b=nI0GXPSA8WPXQ3NZ3LyLpsxi1ryeae4EhFaeJuIMOMJOEKU5rj5L4QAvrwfTmeUeoK
         3Ee5ruFUXUia96whhSQspuPCVMi2UZcIMPdHorNJMLfImxktFpfjn4xIMW6Fm/7INmdE
         qlu4sB05QMkHI0NMwICILhnEcgDW1I4fCMJJE0t51wkkNfRteXY/+4isqcpQWU6uTUQP
         6KBAX1e8Q3UCTKx8vU6RwPUE1amcZwsBHdOZaCRvrlYCoNGu/AfpIb1EYvp3BXSdPFNQ
         ZF9GOKkOEqK+4sShyy9S5qg1gLwC7CQgdhaXSCoi5ZsMS0zs7uoDXW4cAr6eFgz1pHlW
         wXuQ==
X-Gm-Message-State: AJIora9qqDY5EwSS9aSEshVAXlYP41DmtkAo3+nCqPs9scqVr4g/zh+O
        4R6NU5lLFdKVWpIC3gd9cmdOBNeWox4zF59rA8um+sWwmwayWmYgYm2uCxPLe0dEsEjRtDMNTEE
        uJjJWqlwL2Yu2
X-Received: by 2002:a17:906:6a0f:b0:72b:64ce:289d with SMTP id qw15-20020a1709066a0f00b0072b64ce289dmr39234757ejc.663.1658414526798;
        Thu, 21 Jul 2022 07:42:06 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vy8QuPW9zECMk5hGE/N69CO/x9Ew68dW+DY+f39ELjiTgulwvNhQSDonPFVwB0MghB2/ceIg==
X-Received: by 2002:a17:906:6a0f:b0:72b:64ce:289d with SMTP id qw15-20020a1709066a0f00b0072b64ce289dmr39234717ejc.663.1658414526276;
        Thu, 21 Jul 2022 07:42:06 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id t8-20020aa7db08000000b0043bba84ded6sm1086730eds.92.2022.07.21.07.42.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jul 2022 07:42:05 -0700 (PDT)
Message-ID: <be68776d-a690-2d53-10dd-c922673cde11@redhat.com>
Date:   Thu, 21 Jul 2022 16:42:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [kvm-unit-tests GIT PULL 00/12] s390x: improve error reporting,
 more storage key tests
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com
References: <20220721140701.146135-1-imbrenda@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220721140701.146135-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/21/22 16:06, Claudio Imbrenda wrote:
> Hi Paolo,
> 
> please merge the following changes:
> * new testcases to test storage keys functionality
> * improved parsing of interrupt parameters
> * readability improvements
> * CI fix to overcome a qemu bug exposed by the new tests
> * better error reporting for SMP tests
> 
> MERGE:
> https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/merge_requests/34
> 
> PIPELINE:
> https://gitlab.com/imbrenda/kvm-unit-tests/-/pipelines/593541216
> 
> PULL:
> https://gitlab.com/imbrenda/kvm-unit-tests.git s390x-next-2022-07
> 
> 
> Claudio Imbrenda (5):
>    lib: s390x: add functions to set and clear PSW bits
>    s390x: skey.c: rework the interrupt handler
>    lib: s390x: better smp interrupt checks
>    s390x: intercept: fence one test when using TCG
>    s390x: intercept: make sure all output lines are unique
> 
> Janis Schoetterl-Glausch (7):
>    s390x: Fix sclp facility bit numbers
>    s390x: lib: SOP facility query function
>    s390x: Rework TEID decoding and usage
>    s390x: Test TEID values in storage key test
>    s390x: Test effect of storage keys on some more instructions
>    s390x: Test effect of storage keys on diag 308
>    s390x/intercept: Test invalid prefix argument to SET PREFIX
> 
>   lib/s390x/asm/arch_def.h  |  75 ++++++-
>   lib/s390x/asm/facility.h  |  21 ++
>   lib/s390x/asm/interrupt.h |  65 ++++--
>   lib/s390x/asm/pgtable.h   |   2 -
>   lib/s390x/fault.h         |  30 +--
>   lib/s390x/sclp.h          |  18 +-
>   lib/s390x/smp.h           |   8 +-
>   lib/s390x/fault.c         |  58 ++++--
>   lib/s390x/interrupt.c     |  79 ++++++--
>   lib/s390x/mmu.c           |  14 +-
>   lib/s390x/sclp.c          |   9 +-
>   lib/s390x/smp.c           |  11 +
>   s390x/diag288.c           |   6 +-
>   s390x/edat.c              |  25 ++-
>   s390x/intercept.c         |  27 +++
>   s390x/selftest.c          |   4 +-
>   s390x/skey.c              | 408 ++++++++++++++++++++++++++++++++++++--
>   s390x/skrf.c              |  14 +-
>   s390x/smp.c               |  18 +-
>   s390x/unittests.cfg       |   1 +
>   20 files changed, 712 insertions(+), 181 deletions(-)
> 

Merged, thanks!

Paolo

