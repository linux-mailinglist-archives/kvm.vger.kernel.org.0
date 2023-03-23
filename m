Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 673FC6C6688
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 12:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbjCWL1Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 07:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjCWL1O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 07:27:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E5A2E82C
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 04:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679570786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8KUbQxs8kI66eH9ZThh/ululwM7KepG2IoJ0H/h7J2I=;
        b=Ld+HNi2CT4cuxa/wLIVzg/aZ3wfXofr6TJjlNFa5wQ3eW4oM0HNvxzvi5LG+5bEtJa9NgR
        q4BFUd2gR/YiXN782URVQ3bbJ9m6BABxzAigYyKbRMzPO1yPjXoYFjwHgKeOiYdAz0bHgN
        Mrm6LtGpPXI4X4wEAfG+zerjZJsC7VA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-37-Mm5nqhEwMwOjdACNw_tlfg-1; Thu, 23 Mar 2023 07:26:24 -0400
X-MC-Unique: Mm5nqhEwMwOjdACNw_tlfg-1
Received: by mail-ed1-f72.google.com with SMTP id dn8-20020a05640222e800b004bd35dd76a9so32074915edb.13
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 04:26:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679570784;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8KUbQxs8kI66eH9ZThh/ululwM7KepG2IoJ0H/h7J2I=;
        b=YFgCoz+gxCejEqokIqJXjffrJY1i7XRooMDKWNoIkfcF0AGiQRMPwuv34XuOjLjYHl
         mVeS/yQ1rL0lyoYOORsQY0+tOkAqO7Mx6uw4FJ0k7P4Eu0WAzWIlrqdNhfG1Vjf9Ye8R
         itFJfN+iEvQT0ndpZfcbB3k2CotAHK4uypc0E8NlnrnuA2ZSbWL/PNwyU+NwIUUy/jum
         jXHe5IcYDNnKHtwqIOTyXUm8VzhktgOJW5uBn06SJeBO+uQj10yDwWlOmLFm2SBINgRh
         sv5ZF5Y7I0hzGXCzrZ5CX2rqKUd5bceWJeNNlVd+xFDLkldqQvlCko+6r7GYem3Cm+hz
         vorA==
X-Gm-Message-State: AO0yUKU0ymZhoQmNQtNPEF2LKtr9Ma7AAdqIm1/c+AP6i3AFmf0ADr61
        GenXBOGY41CrFndfbQojMtnjpJgG/JYVHMv+BsB2PKyHibiQy9mSkGxvNdx85gifmLIDEbylS4R
        l2BRG7kIanrRm
X-Received: by 2002:a17:906:46ce:b0:931:ad32:79ed with SMTP id k14-20020a17090646ce00b00931ad3279edmr10870305ejs.12.1679570783953;
        Thu, 23 Mar 2023 04:26:23 -0700 (PDT)
X-Google-Smtp-Source: AK7set+ZVhfJ2B9nEDKBwWSRNArm/QDK/E4mI2IbTuDLm2MI0YhFfX6ov54O1VjaGE43kuNwtTLf2Q==
X-Received: by 2002:a17:906:46ce:b0:931:ad32:79ed with SMTP id k14-20020a17090646ce00b00931ad3279edmr10870285ejs.12.1679570783640;
        Thu, 23 Mar 2023 04:26:23 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-179-146.web.vodafone.de. [109.43.179.146])
        by smtp.gmail.com with ESMTPSA id t21-20020a50d715000000b004af7191fe35sm8987398edi.22.2023.03.23.04.26.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 04:26:23 -0700 (PDT)
Message-ID: <ec852041-dc53-f50c-534c-a0f5c1dd153b@redhat.com>
Date:   Thu, 23 Mar 2023 12:26:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests v2 02/10] powerpc: add local variant of SPR test
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Laurent Vivier <lvivier@redhat.com>
References: <20230320070339.915172-1-npiggin@gmail.com>
 <20230320070339.915172-3-npiggin@gmail.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230320070339.915172-3-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/03/2023 08.03, Nicholas Piggin wrote:
> This adds the non-migration variant of the SPR test to the matrix,
> which can be simpler to run and debug.
> 
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   powerpc/unittests.cfg | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/powerpc/unittests.cfg b/powerpc/unittests.cfg
> index 1e74948..3e41598 100644
> --- a/powerpc/unittests.cfg
> +++ b/powerpc/unittests.cfg
> @@ -68,5 +68,9 @@ groups = h_cede_tm
>   
>   [sprs]
>   file = sprs.elf
> +groups = sprs

Looking at this again, I think you don't really need a "groups =" entry here 
... I'd suggest to drop that line.

  Thomas


> +[sprs-migration]
> +file = sprs.elf
>   extra_params = -append '-w'
>   groups = migration

