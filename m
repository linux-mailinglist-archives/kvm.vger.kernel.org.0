Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE6E257CC3E
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 15:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbiGUNnX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 09:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiGUNmz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 09:42:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4F302823A4
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 06:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658410972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eB2t6MCwiJG1ExNDB+Ljjom6WV2GQK9LC4WD3rPXQFM=;
        b=AbG0no7aimDpwFzVwvVXDWtWvspzvAoR6e3WPJKEIM/fa6A7M4nOp9UkGI7JDk6rgmvDf1
        4jPtG4szPgz3gIDlcKDjQ7DX8qMq/3x1Fi0VPGsBxE/uehKFez7BGdvmU64klJCkS6jZzS
        V9p6iNjuIa6onXlIQmDlMlwzvgO7OCQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-499-HbFgVMrFOv2Gf1Hm30gHwQ-1; Thu, 21 Jul 2022 09:42:48 -0400
X-MC-Unique: HbFgVMrFOv2Gf1Hm30gHwQ-1
Received: by mail-wm1-f72.google.com with SMTP id r127-20020a1c4485000000b003a2fdeea756so2834956wma.2
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 06:42:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eB2t6MCwiJG1ExNDB+Ljjom6WV2GQK9LC4WD3rPXQFM=;
        b=MMntmG9otY22584E1WO8Ygot95P9OLZfRsSZc5On5MII8NVS3ISQ9OOB5Qx7zFUNsr
         DkmMChRUULsatf7iumyRpSOWFHPA/gKRGzwX/lhNDZw2UnSgqHBz6DU/klrMXZxRdeZo
         9opyikdsNsPHzPivzcyQIJbIgN/qOox+XNkzUC9QH4QJeHQdLob3C68xHndZPKlnTV+2
         J5+Nz2ZTiPYK95gbcHBrdPheb5Zh2a1jwVMAvFtKlNOAzYueMUDeXTshHq9CVcio40v9
         a/pUj35Uf7s0xLapD+U1jHbpmMug2men8K76Ik80sM5XAxdx2CYIzGz7W3BAZFUvMBqL
         UN1A==
X-Gm-Message-State: AJIora9eop5aCFAG2Je+IkkOyr0IhO9UGwdM4vJR1nDkKpjyBTvv/DYu
        TZxIXTmidOBqfvDvY2YxrKhfRqFyjs92Ra0pYwIZztDyu8Dm8DnbbnAXDBkcy3mPwiU55fjpbae
        FKsaFU0BChSnx
X-Received: by 2002:a7b:c314:0:b0:3a0:5750:1b4a with SMTP id k20-20020a7bc314000000b003a057501b4amr8321579wmj.20.1658410967532;
        Thu, 21 Jul 2022 06:42:47 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1ug2ArlCJqt7J1dKmM5rfPnxaF/fjypmxrD5aWpELpC2SRJSk58l4vg/VOciBPY0TDmY3lVgw==
X-Received: by 2002:a7b:c314:0:b0:3a0:5750:1b4a with SMTP id k20-20020a7bc314000000b003a057501b4amr8321560wmj.20.1658410967327;
        Thu, 21 Jul 2022 06:42:47 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-179-217.web.vodafone.de. [109.43.179.217])
        by smtp.gmail.com with ESMTPSA id o9-20020a05600c058900b0039c54bb28f2sm1893473wmd.36.2022.07.21.06.42.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jul 2022 06:42:46 -0700 (PDT)
Message-ID: <163212be-f3b2-ca68-d28b-df4cf4039bc3@redhat.com>
Date:   Thu, 21 Jul 2022 15:42:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 2/2] s390x: intercept: make sure all output lines are
 unique
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, qemu-s390x@nongnu.org
Cc:     frankja@linux.ibm.com
References: <20220721133002.142897-1-imbrenda@linux.ibm.com>
 <20220721133002.142897-3-imbrenda@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220721133002.142897-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/07/2022 15.30, Claudio Imbrenda wrote:
> The intercept test has the same output line twice for two different
> testcases.
> 
> Fix this by adding report_prefix_push() as appropriate.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   s390x/intercept.c | 6 ++++++
>   1 file changed, 6 insertions(+)

Reviewed-by: Thomas Huth <thuth@redhat.com>

