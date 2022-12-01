Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7707F63F1F0
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 14:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbiLANrn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 08:47:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbiLANri (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 08:47:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D07BF905
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 05:46:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669902404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7p+KL/F0J55e6WoMkxer5+URAf8GZ2IFvi3UFMd6VjI=;
        b=C0ahN5TrbiK7xHEpeHY7FAuA/Zd0kZm/ayOqaPdp1bwkSjD77y4w1k49Trwnalf2bLPsuQ
        F/Vj+PFaV5FJuyMEYm0AvrNqlgpvqA6HEIFNAu1AtbZVGbcZD28l+6SaqH/v8E+wA0Ex+F
        3cvfVaNf3Zmduf4Ewoqth14Mk7A0D0Y=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-424-xnmnGHpWNW68QVt8p3KqWQ-1; Thu, 01 Dec 2022 08:46:43 -0500
X-MC-Unique: xnmnGHpWNW68QVt8p3KqWQ-1
Received: by mail-qv1-f71.google.com with SMTP id mi12-20020a056214558c00b004bb63393567so5007699qvb.21
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 05:46:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7p+KL/F0J55e6WoMkxer5+URAf8GZ2IFvi3UFMd6VjI=;
        b=qHE7TSryENDYOG1L3SfdYiKlE1gJrxSiO0zdBkzYU8xbtGVCMKnQcfx7U7+upiXSv4
         voBGDGQjIOO41GYNfQCO/nmWcv+tGvB4tmL1pgdpOdyA/PGlaqnXvt/kdu+aYntzsLw3
         RG5KXrRSw00MdGXl3LFpvsgewqw3G7XmZhI6SP1YhkzEdTdeUG2K1G2tJqdhsaobIfu5
         F611NA+cKkjmJcmYvOplqmOmbr7tCaqQBcw3z8Dqmy225bLbm6iY6xRGXxerUFmurp9E
         I9kCMwSq9XnoNXvA5UCyFo4/D5RIQLogsmfeyZKTMQk4j5MUsd+Q5CreUFz8tC45mhkv
         Wguw==
X-Gm-Message-State: ANoB5pkjwp+vDpTdTDAX+2XK52QsZpZBtM1FPNTotXjugkdKcKvRcvaY
        i644tVYBoTzXHoLIh9vwirZB+RZFlQJUuRa5tZaD1Wd/neRVBwnPVdGtNrKH/aM8V0SRhzZoj+a
        Lo+KXiR9fQTDH
X-Received: by 2002:a05:6214:4389:b0:4c6:d796:1b0a with SMTP id oh9-20020a056214438900b004c6d7961b0amr34979921qvb.128.1669902403335;
        Thu, 01 Dec 2022 05:46:43 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7QfBWP5iCLBOFkNEC2xYQDpNdymkXukc2F7E4ZwAli/pyCXR896J7MUDwaCSAKjIpKpAnIAg==
X-Received: by 2002:a05:6214:4389:b0:4c6:d796:1b0a with SMTP id oh9-20020a056214438900b004c6d7961b0amr34979904qvb.128.1669902403173;
        Thu, 01 Dec 2022 05:46:43 -0800 (PST)
Received: from [192.168.149.123] (58.254.164.109.static.wline.lns.sme.cust.swisscom.ch. [109.164.254.58])
        by smtp.gmail.com with ESMTPSA id w25-20020a05620a129900b006fcaa1eab0esm610454qki.123.2022.12.01.05.46.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 05:46:42 -0800 (PST)
Message-ID: <0df5f71c-4f32-5635-3334-b35b5a0a9891@redhat.com>
Date:   Thu, 1 Dec 2022 14:46:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH v3 13/27] svm: remove get_npt_pte extern
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Nico Boehr <nrb@linux.ibm.com>,
        Cathy Avery <cavery@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20221122161152.293072-1-mlevitsk@redhat.com>
 <20221122161152.293072-14-mlevitsk@redhat.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <20221122161152.293072-14-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 22/11/2022 um 17:11 schrieb Maxim Levitsky:
> get_npt_pte is unused
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  x86/svm.h | 1 -
>  1 file changed, 1 deletion(-)
> 
Reviewed-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>

