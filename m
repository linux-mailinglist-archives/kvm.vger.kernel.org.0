Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF8259E60B
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 17:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242234AbiHWPcx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 11:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242894AbiHWPcd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 11:32:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF8124F66C
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 04:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661253402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TqNe+Th4aK2Q98TPaxOFOH3G9LLq73SYLTeqj2rEziM=;
        b=Zv8zVFxesUjqjkK7AmGsETNMCRGA69sLr9sWl2iWouPWEZylsExQVnT2qcloNYHF8utLF3
        NdaZKXMTK/LV6sZGhtQWD6mGuVJL9DTJlPI9Eut3f3S26rpgYe2Y47jixWnUvbkts+S6Zc
        bSkQIAmHiadFhjzK0Hi1+Ff8AiypXSM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-590-QrR1YWKBNiqfgldafdQhqg-1; Tue, 23 Aug 2022 07:16:41 -0400
X-MC-Unique: QrR1YWKBNiqfgldafdQhqg-1
Received: by mail-wm1-f69.google.com with SMTP id i7-20020a1c3b07000000b003a534ec2570so8601377wma.7
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 04:16:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=TqNe+Th4aK2Q98TPaxOFOH3G9LLq73SYLTeqj2rEziM=;
        b=SuDdx9Nih4a9ZscUrYl+d0khPw7L1ESjhXu7NYRc0vRR2JDC02/gBwZMg5dgGqtNhM
         SZvEI4svz/BwAns2ae2wsTxRETXSBP2ad7TRa2myQSiugEcZE5uLltXl+cvIPZHM944S
         8uPiBg3obXQQfzdQbhKuJThT5G/6TOnkK77i4KHpEBbI2Lvu5gNrzrwEZwQr01sp17lM
         PEJkGMu8qmc+IezByJDiD0SRvXOHuR/GfpLM7X9plfhwy34vJUpgDcvjg8h4SH05I1VW
         WVilWwJV0JoKZrNEYmb0Nt27kddbNH5Xpcizj1GkHKEDfztk3hccH0Xkei2sOLwdPd7h
         UGgw==
X-Gm-Message-State: ACgBeo2ZAbgZpkdgB4vNZ1n6+90dLcSQ/QQLiv3eiwhqxvA4DR6A05C1
        RyCQMiU9UvssDGsNY5ggzx5FFP2J793xx3O9zjK+9Zdp+53byHttzWjeuw3K1u4L0iA/Ina2HTK
        q9fU+N9tWvCHB
X-Received: by 2002:a05:600c:3551:b0:3a5:dcf3:1001 with SMTP id i17-20020a05600c355100b003a5dcf31001mr1825475wmq.58.1661253400073;
        Tue, 23 Aug 2022 04:16:40 -0700 (PDT)
X-Google-Smtp-Source: AA6agR40y3FPJ0mJmr81YcIXbeFvPTaATtOeSxIZkxqpC/MDDR2f2yjfTjn8te05iBLVDrJ4+ZxKVw==
X-Received: by 2002:a05:600c:3551:b0:3a5:dcf3:1001 with SMTP id i17-20020a05600c355100b003a5dcf31001mr1825464wmq.58.1661253399829;
        Tue, 23 Aug 2022 04:16:39 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-178-217.web.vodafone.de. [109.43.178.217])
        by smtp.gmail.com with ESMTPSA id d12-20020adff2cc000000b002238ea5750csm17242753wrp.72.2022.08.23.04.16.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 04:16:39 -0700 (PDT)
Message-ID: <30485f8b-342b-2c54-8f25-bb2eaad0b1c3@redhat.com>
Date:   Tue, 23 Aug 2022 13:16:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [kvm-unit-tests PATCH v6 4/4] s390x: add pgm spec interrupt loop
 test
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com
References: <20220823103833.156942-1-nrb@linux.ibm.com>
 <20220823103833.156942-5-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220823103833.156942-5-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/08/2022 12.38, Nico Boehr wrote:
> An invalid PSW causes a program interrupt. When an invalid PSW is
> introduced in the pgm_new_psw, an interrupt loop occurs as soon as a
> program interrupt is caused.
> 
> QEMU should detect that and panic the guest, hence add a test for it.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@de.ibm.com>
> ---
>   s390x/Makefile         |  1 +
>   s390x/panic-loop-pgm.c | 38 ++++++++++++++++++++++++++++++++++++++
>   s390x/unittests.cfg    |  6 ++++++
>   3 files changed, 45 insertions(+)
>   create mode 100644 s390x/panic-loop-pgm.c

Reviewed-by: Thomas Huth <thuth@redhat.com>


