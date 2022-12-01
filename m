Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9821563F1EF
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 14:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbiLANre (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 08:47:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbiLANrd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 08:47:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA99BF91B
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 05:46:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669902393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vrGtKhqWa0aDuF/YmwAz5dW1Mdk/BXysmGJhcb1Lzjw=;
        b=QY3cPIoYpc67eMBS8+G5Ppnerm7XSz/vjbro1uKkF1OpC/eMU6tXBDZ9umHw+Pc9i48gpf
        s/INrHb418790DmMIw2iNgt1Egu6MqLZPGH1So9+w7LfKzy94g7KYGKk6OBpIrOezjVoB2
        p2wMGc+8JD/fx2KjjD12CoAjLFexC2g=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-619-ev_V5_VrODa8l6WZobfVHg-1; Thu, 01 Dec 2022 08:46:32 -0500
X-MC-Unique: ev_V5_VrODa8l6WZobfVHg-1
Received: by mail-qt1-f198.google.com with SMTP id s14-20020a05622a1a8e00b00397eacd9c1aso4532624qtc.21
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 05:46:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vrGtKhqWa0aDuF/YmwAz5dW1Mdk/BXysmGJhcb1Lzjw=;
        b=pp16/NbVCZeIWFNTd37h2ARJSiDG6fNV7Ay+yXsoYugBN5y+9P31h4pNs2Mv+4QU5L
         A6xVdgIH1nV7k96J2PNpoPswtypTvFRe3HdimcgsEXTK++0ZKWrZjnrF9IetZRS+QkvA
         z0QB4E9yj7mKtXyJn75D6zrF3exxl4SHxrV/QgCz0+m/11DwGW0Q8EhSE2htTXm8CgXA
         PX/UOyMTFIDEazTXLEA27JUpwHIggUCtgXHNZieUiGzkwQXzVdwcofPflybCuP7oHhl9
         uibA1OGVHc8og3jJzehfunoLQY3xEugrEoNffOsKSRODkImcdF8EUrmuc8BPQDHZOEeM
         1w9Q==
X-Gm-Message-State: ANoB5pnWJ4eYdv1U97usay+bvEFbed4q7ohx9S7AvU/P31HtMFGESNgJ
        tsOK+IRPIfUgF7n9VzAikMFbL7tRlAEEaexogunTmbGbD7VAR6lWcR1ADz8ToigHxAPBggfVbnK
        XUTdjmW9w2a3/
X-Received: by 2002:a0c:aa56:0:b0:4c7:19e4:de7e with SMTP id e22-20020a0caa56000000b004c719e4de7emr9588277qvb.123.1669902392518;
        Thu, 01 Dec 2022 05:46:32 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6C+GIS3stnlIQnFEcVtJ7NQjdl1LgbnkleiDccYwPIvC78dpvS6T14md4UlBtx6aauZ/h+kg==
X-Received: by 2002:a0c:aa56:0:b0:4c7:19e4:de7e with SMTP id e22-20020a0caa56000000b004c719e4de7emr9588261qvb.123.1669902392335;
        Thu, 01 Dec 2022 05:46:32 -0800 (PST)
Received: from [192.168.149.123] (58.254.164.109.static.wline.lns.sme.cust.swisscom.ch. [109.164.254.58])
        by smtp.gmail.com with ESMTPSA id ay40-20020a05622a22a800b003a57a317c17sm2525653qtb.74.2022.12.01.05.46.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 05:46:32 -0800 (PST)
Message-ID: <309bc922-5fe6-7290-7b85-117ae33e55c8@redhat.com>
Date:   Thu, 1 Dec 2022 14:46:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH v3 02/27] x86: introduce sti_nop() and
 sti_nop_cli()
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
 <20221122161152.293072-3-mlevitsk@redhat.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <20221122161152.293072-3-mlevitsk@redhat.com>
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
> Add functions that shorten the common usage of sti
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> 

Reviewed-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>

