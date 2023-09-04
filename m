Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38703791501
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 11:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241251AbjIDJut (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 05:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbjIDJus (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 05:50:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F60C130
        for <kvm@vger.kernel.org>; Mon,  4 Sep 2023 02:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693821001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2GBK+++3DmyVfbTlMHxqD/SiwodzazSVJ3fOLKjraPE=;
        b=AEtekDcme+LgHprXYB89V/z/ctqe9xMt7WE1l7JF5ZJGYjNbIBLBK0YDmIKLWqoJaebd0R
        IBuMKb+d30FASOfVpGVUW/YLCtiVnEpkBDguSr+Ls0LpxFwKx5ANZtMX89jkzK8sW++WuD
        VgOezsgaS99qtiLgtj+/UO15pFN1YVk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-261-eWt3ryanN-SYVno04xErCw-1; Mon, 04 Sep 2023 05:49:59 -0400
X-MC-Unique: eWt3ryanN-SYVno04xErCw-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-401d8873904so8555935e9.0
        for <kvm@vger.kernel.org>; Mon, 04 Sep 2023 02:49:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693820998; x=1694425798;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2GBK+++3DmyVfbTlMHxqD/SiwodzazSVJ3fOLKjraPE=;
        b=jyrveL6qtcT3/PXHpu/2OpJQ+JbaCUhsO8AtmkFN47YC/VL7Z+gb9d93tEFPVUoJwo
         Ne1ckaRWFa2rbpoXPqZRRNyTz3HY4ulR9LO2VSB18MWOISGSpPhTeSQo9mqGMMyV5wJi
         l6o3iMNtzxpvPSIdkWsX1Z9CUi47ODwdXEVxW+3r3eYp4jhFWY7vb/azZWoBqsdN99gt
         sh26/+7vsutl8OHjFZ2iJFufj8VxDBHs91lyOHFVAnaMat1ZrHc99ly+Ey2RUr13ZRRG
         1mheC2iVyWfY8DxM5taMVOcbLQLxleWZEwvj1x8lX4xqD8jXy218KUfFp+4dVQ8OZhp8
         gxkw==
X-Gm-Message-State: AOJu0YxBXqiyFmEYXyuh0lcRC4ifLUdfeLIizPVYsIUpeULp0zhprHA7
        OkTsaBReFzl+ij9Y7IaKU1wy9obvir5KMrxNEJo7sB57mBYIQZ5ZAvn3zEHP4h8ulRgpLLn1Zah
        4UaGwsZaruuKB
X-Received: by 2002:a7b:c7cc:0:b0:3fe:c7fe:206e with SMTP id z12-20020a7bc7cc000000b003fec7fe206emr6268925wmk.16.1693820998675;
        Mon, 04 Sep 2023 02:49:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFDY5qZxtKjv7rRsKpuuk9dy61SBGRElvZ0/wJTMHqNE5lVas01adwKpcMZzr6/mUVc6i9Peg==
X-Received: by 2002:a7b:c7cc:0:b0:3fe:c7fe:206e with SMTP id z12-20020a7bc7cc000000b003fec7fe206emr6268914wmk.16.1693820998370;
        Mon, 04 Sep 2023 02:49:58 -0700 (PDT)
Received: from [10.33.192.199] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id p1-20020a05600c204100b003fe1630a8f0sm16489470wmg.24.2023.09.04.02.49.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Sep 2023 02:49:57 -0700 (PDT)
Message-ID: <bc1418ce-5f40-c84b-973d-d81281eda682@redhat.com>
Date:   Mon, 4 Sep 2023 11:49:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [kvm-unit-tests PATCH v6 1/8] lib: s390x: introduce bitfield for
 PSW mask
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230904082318.1465055-1-nrb@linux.ibm.com>
 <20230904082318.1465055-2-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230904082318.1465055-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/09/2023 10.22, Nico Boehr wrote:
> Changing the PSW mask is currently little clumsy, since there is only the
> PSW_MASK_* defines. This makes it hard to change e.g. only the address
> space in the current PSW without a lot of bit fiddling.
> 
> Introduce a bitfield for the PSW mask. This makes this kind of
> modifications much simpler and easier to read.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   lib/s390x/asm/arch_def.h | 26 +++++++++++++++++++++++++-
>   s390x/selftest.c         | 34 ++++++++++++++++++++++++++++++++++
>   2 files changed, 59 insertions(+), 1 deletion(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

