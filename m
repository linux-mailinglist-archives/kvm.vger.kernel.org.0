Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3D5476A296
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 23:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjGaVYu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 17:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjGaVYs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 17:24:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2474A10F6
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 14:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690838641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PTqKIyP+8QjHd2CeZ0ivuYsdhtM4vC5XouYymdmLlRw=;
        b=WYwYO9rQbSZA2zyUZg7wVAjnOzA5v3ILyMh47YsJMgcoeiiqP4lQEKTi4uaatkRgXAUsDa
        BbMndW3RKUnzvn2zxrJNNmwnRZHFKLeGycHYw89zRHGw4nW3XQ2h7tmFnQhw31Z+a7u1RN
        FD2IwdUqED2nv2BRxkwosKdctvUEGaM=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-_SYvUzlyM82iKaXlYH-IiA-1; Mon, 31 Jul 2023 17:23:59 -0400
X-MC-Unique: _SYvUzlyM82iKaXlYH-IiA-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4054266d0beso11542671cf.0
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 14:23:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690838639; x=1691443439;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PTqKIyP+8QjHd2CeZ0ivuYsdhtM4vC5XouYymdmLlRw=;
        b=YNb/21696jHIy7cNqkrEf6rPhWnRuLdV9cgIo04BUChKCjNRHxMAT15XgjUJnhe0tO
         4o8xFjuqiRonn9OrF6oHnu0CZOdXmTaJMwPXhjWn9pifJWMgutpEvaqa6KA4kQW3/MoH
         RLb6fnPkAuQAXO6uV/LoP5TIQhYvNRhBMjE75N4yJ2ZsNJ37hoEmxMUPDn0qskANR/ZQ
         eUCm//txHWo3TL7nEmgq1M/d6OW3QR8m47zUuzYYy/9jZhEElocPHAgmQXTrtywxtGH3
         t2/BUfCL7jBJfrhSp0vknzTukaYJR3mAD1NQHgxlFctRDQZ3OIba1rug9DN3TWZroHnw
         kl1g==
X-Gm-Message-State: ABy/qLYuhz30gCi46pVU+GBU7l4Z37yQ+gQs5pQHAz7vLSnTBDSgqtPC
        FUn3XoVfdf/8VkMUIQxor9K4UumLQYYTAX1gDpWuzvC77udj0KitdKzuT17/KoQYbFTlPDaeqmz
        waFZAMAvHHOce
X-Received: by 2002:ad4:5b83:0:b0:63c:f5fd:d30f with SMTP id 3-20020ad45b83000000b0063cf5fdd30fmr10962073qvp.1.1690838639010;
        Mon, 31 Jul 2023 14:23:59 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEYHqrFI7EZFpBux2VqE7D+hh0uzgUPIcnUR449EgzybpVrYgHBidpiJ/WjnkIRm4YgwKpJcw==
X-Received: by 2002:ad4:5b83:0:b0:63c:f5fd:d30f with SMTP id 3-20020ad45b83000000b0063cf5fdd30fmr10962059qvp.1.1690838638706;
        Mon, 31 Jul 2023 14:23:58 -0700 (PDT)
Received: from x1n (cpe5c7695f3aee0-cm5c7695f3aede.cpe.net.cable.rogers.com. [99.254.144.39])
        by smtp.gmail.com with ESMTPSA id q14-20020a0cf5ce000000b0063d30c10f1esm4110904qvm.70.2023.07.31.14.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 14:23:58 -0700 (PDT)
Date:   Mon, 31 Jul 2023 17:23:55 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 04/19] memory: Introduce
 memory_region_can_be_private()
Message-ID: <ZMgma0cRi/lkTKSz@x1n>
References: <20230731162201.271114-1-xiaoyao.li@intel.com>
 <20230731162201.271114-5-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230731162201.271114-5-xiaoyao.li@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 31, 2023 at 12:21:46PM -0400, Xiaoyao Li wrote:
> +bool memory_region_can_be_private(MemoryRegion *mr)
> +{
> +    return mr->ram_block && mr->ram_block->gmem_fd >= 0;
> +}

This is not really MAP_PRIVATE, am I right?  If so, is there still chance
we rename it (it seems to be also in the kernel proposal all across..)?

I worry it can be very confusing in the future against MAP_PRIVATE /
MAP_SHARED otherwise.

Thanks,

-- 
Peter Xu

