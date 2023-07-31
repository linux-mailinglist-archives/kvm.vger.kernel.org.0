Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF9B768E0C
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 09:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbjGaHTm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 03:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231770AbjGaHSr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 03:18:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 858B546B6
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 00:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690787732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uBfpOagrTrr5J584ZsKzPTICJSqpSEt1rQjOESpOFDg=;
        b=VW576xy4OGzLeD9o4/jCVlsNUoHYclVlYUHd5HmwJb/KF3e2JXTCYb+SlEYYGHbnRKoLNJ
        O+NR8LC58pmJqV1RPU+4BGDrO0iuTzqJ7CLyYxsDEYmkz622SCHcK578d2Pfwb9Ts3tDOw
        ufLFm8CGMNFV5hUzdFRwvKshCYOv8uY=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-VduCLiD0NuGn0N7y5iZtAA-1; Mon, 31 Jul 2023 03:15:30 -0400
X-MC-Unique: VduCLiD0NuGn0N7y5iZtAA-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2688304be26so1827618a91.2
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 00:15:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690787730; x=1691392530;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uBfpOagrTrr5J584ZsKzPTICJSqpSEt1rQjOESpOFDg=;
        b=XcpFm/ymOdnBrPzqrxHc9pjttHA4rmPBeth0n6ReqGcz6sXCRzjJXhLOFRHaY62SHi
         NsCaIM08fbK2xX8dnC51rIRl6/s/LX5GTggZSh2j7EcfpxbZ02zZOIkaO8hzHnSYh/r7
         v3UsrimmeQIKjILxzmi2TNJv/A7AngzWd/ATFxETzgUpHigRwp+V2wS9C/M5ZxzgJicC
         S4LppWsDkSdZNeggG4IMYlZxJ38xMpXqceRopK+O8YoPIhdbZOcTbGFf6VVupamNauVP
         Duna2C5g06UtcWIwsCfnBjFQro0vvLWHV6DI4URcETcZVHUnB90k3OpCoG9TqKhaf0+3
         1YsQ==
X-Gm-Message-State: ABy/qLaMOXme60BHAf7Fer1kqAEtaY/38ogvf7ubkVmtP+7yiB8pteTB
        RXkIMSMNy36NquWSEdsLilhH3k6RuZLz+vCCDcXisADaDzmx9fzpMAz43SKAtmsH6q+KFd6CHFj
        xQfpFG0OIg9ss
X-Received: by 2002:a17:90a:fd0d:b0:267:f9c4:c0a8 with SMTP id cv13-20020a17090afd0d00b00267f9c4c0a8mr7567840pjb.4.1690787729929;
        Mon, 31 Jul 2023 00:15:29 -0700 (PDT)
X-Google-Smtp-Source: APBJJlE6hfmOHKxfxzg1eIjUW80fC5o6Wzto5PO402pDEoZmV/SRx7UpSShK118LcjAmfk+zNRHOEw==
X-Received: by 2002:a17:90a:fd0d:b0:267:f9c4:c0a8 with SMTP id cv13-20020a17090afd0d00b00267f9c4c0a8mr7567830pjb.4.1690787729639;
        Mon, 31 Jul 2023 00:15:29 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id 29-20020a17090a005d00b002612150d958sm7895363pjb.16.2023.07.31.00.15.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jul 2023 00:15:29 -0700 (PDT)
Message-ID: <0b23a5f5-0539-47f5-2cd9-e79c120e1bb8@redhat.com>
Date:   Mon, 31 Jul 2023 17:15:24 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH for-8.2 2/2] arm/kvm: convert to kvm_get_one_reg
Content-Language: en-US
To:     Cornelia Huck <cohuck@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20230718111404.23479-1-cohuck@redhat.com>
 <20230718111404.23479-3-cohuck@redhat.com>
From:   Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230718111404.23479-3-cohuck@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/18/23 21:14, Cornelia Huck wrote:
> We can neaten the code by switching the callers that work on a
> CPUstate to the kvm_get_one_reg function.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>   target/arm/kvm.c   | 15 +++---------
>   target/arm/kvm64.c | 57 ++++++++++++----------------------------------
>   2 files changed, 18 insertions(+), 54 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

Thanks,
Gavin

