Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38A476D77C1
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 11:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237626AbjDEJHp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 05:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237667AbjDEJHl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 05:07:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B71C10F1
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 02:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680685613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Op42h+tgWk/ZcIAwCYA5n1leZv0xk2OCJC0K/gaBy/w=;
        b=Mw+1VQLiY1p/fuoFsjuOokopKf325Wo6EGwexrdimL1to/iMkIqJv6YaTuqXQL3+WMRqq8
        GQKK7657ElSCEb9V2RFDVnKoNAtMnt3tQaToA0ECgpwW8dQQ27Z0pmI0m1RqH6eGdkVqJF
        Y1fnmIRl294DherVhaLi6T6x3Jl78ic=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-kehi_n2FM7yqKu83WyTSyw-1; Wed, 05 Apr 2023 05:06:52 -0400
X-MC-Unique: kehi_n2FM7yqKu83WyTSyw-1
Received: by mail-qv1-f69.google.com with SMTP id f3-20020a0cc303000000b005c9966620daso15779581qvi.4
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 02:06:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680685612;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Op42h+tgWk/ZcIAwCYA5n1leZv0xk2OCJC0K/gaBy/w=;
        b=1LzGBzOCtLGJovelM9+S3QR1XZ8CztDS8v9mkI3hg6Dm8Em25+ZRkVIFnxq+nL0qpk
         GFLDCwGFMR3++xaa6CowYz4wzjQHPaYrkkxc0wdwGan7mysKUeb3PcCEVDWdeMzaNzPg
         vmkhiiBSQPWCKW8KQ07HzFwRu2M47Q0G7HM4UCFjlqFKr0mYY7YgQJVyp+GdetURNIB8
         +NSxIxdATbSXlIlq39C3wKIZ08lA3wWfp++n/WaWTlBDXZlWvXhhBirHsLYKa3P8GDuz
         QAkAopC9SiO+cMEdj86I4N2aZiYYamPcVlFglKDOyZjdOb0w3zpVUOixAnG5jqhjWRMr
         EA9g==
X-Gm-Message-State: AAQBX9daeFrBB8yhDSaRZaHrPD02f2xJG2g3+s3a5zvN0VGJBvzi9Jhn
        0kXg6l4dX7KIl6PZHzdaQlWtx7vWcz0vxmRHNXSssQkTyPu8lWzVEjbAbE0dK88tXV31Ost2TCb
        LTqQK2Ad6/ou7
X-Received: by 2002:a05:622a:3cf:b0:3e6:3c76:84b1 with SMTP id k15-20020a05622a03cf00b003e63c7684b1mr3116770qtx.31.1680685611823;
        Wed, 05 Apr 2023 02:06:51 -0700 (PDT)
X-Google-Smtp-Source: AKy350Y4cYUlpraYG/hsxqzihxyMXu41rcpaxHOQvplE7YBp9Y0U8azCqYzPIaeSsJOA0T7x6oBGOQ==
X-Received: by 2002:a05:622a:3cf:b0:3e6:3c76:84b1 with SMTP id k15-20020a05622a03cf00b003e63c7684b1mr3116759qtx.31.1680685611587;
        Wed, 05 Apr 2023 02:06:51 -0700 (PDT)
Received: from [192.168.8.101] (tmo-066-157.customers.d1-online.com. [80.187.66.157])
        by smtp.gmail.com with ESMTPSA id d14-20020ac8668e000000b003e39106bdb2sm3862176qtp.31.2023.04.05.02.06.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 02:06:50 -0700 (PDT)
Message-ID: <dcdc47df-e9be-3093-9bad-1dbeb4848866@redhat.com>
Date:   Wed, 5 Apr 2023 11:06:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests GIT PULL v3 00/14] s390x: new maintainer,
 refactor linker scripts, tests for misalignments, execute-type instructions
 and vSIE epdx
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, pbonzini@redhat.com,
        andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
References: <20230405084528.16027-1-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230405084528.16027-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/04/2023 10.45, Nico Boehr wrote:
> Hi Paolo and/or Thomas,
> 
> so, here's the <del>second</del><ins>third</ins> try of the first pull request from me :)

Thanks, merged now!

  Thomas


