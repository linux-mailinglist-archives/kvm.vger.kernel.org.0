Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26B3C6F315E
	for <lists+kvm@lfdr.de>; Mon,  1 May 2023 15:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbjEANBp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 May 2023 09:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232475AbjEANBm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 May 2023 09:01:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98E6103
        for <kvm@vger.kernel.org>; Mon,  1 May 2023 06:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682946057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DrRzX6M8f5Q1D4e3/DNWMqR/82OR/fzVqNrYR5M4KjI=;
        b=Zgb8f1WIe0LkgML+YnPaSBSU0V9ZMLlFn5EtbvUYpJCQ1984tNNsl15/QjvRZkUDlzKVMs
        YAzOi/L0OPQHCk7ml6sUFtgT3YYTuDpvlJmQ66HdhmkSFCxW8JGexsYaFynGCuYpQj8saX
        BgS5bTrLI4bjGU21o2yefO6F6YnpUNQ=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-Bi6isEktM52QeRRF4-gUDw-1; Mon, 01 May 2023 09:00:55 -0400
X-MC-Unique: Bi6isEktM52QeRRF4-gUDw-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1a6a5debce1so1257695ad.0
        for <kvm@vger.kernel.org>; Mon, 01 May 2023 06:00:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682946054; x=1685538054;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DrRzX6M8f5Q1D4e3/DNWMqR/82OR/fzVqNrYR5M4KjI=;
        b=Q/OZKJYBa4fKWDLSjjrR9ZjGtLgeA9WlfLttjYSx96+dzQaNhujgbe93ol4tlcpN+U
         5lqKNvirjqZT4HDuKtSvopraHqmsjzhqacWoy19djYFLatcqeHWBj/kGYWTPG+gb69Yw
         F67b5IWYUAB4k7V4mzPQh6F+b+djewtX8rVOiIKNgXm2ZOCi1mSIi5gOpTlyKZFDv0YJ
         0WWE92YBhSH7y0ooz23pjOQA1A7EhgS6kE7IqOrDTVEKoK8SyoCxDBc53wc+TOncBDCj
         tMULS91NALgcv7s+Ce+ZWZTIRFdUo1kekd64vY6ycuMAHzIRrxlwD9iwYaUIjHDJSjRs
         JIIQ==
X-Gm-Message-State: AC+VfDxbuRSSonfIpqCoHZKlpC+fI6L35ew1OpybWpBY7EciUm7CCWwc
        fDxyr2gy07L3LIjLFJLyHkEFwBS5tRjwNsGuDE9zHR9XA9TEgk+8+38kq9RlPeNUNfLwVpkU9AE
        XHU0olZUhvgT7
X-Received: by 2002:a17:902:dac1:b0:1a6:93cc:924b with SMTP id q1-20020a170902dac100b001a693cc924bmr17134917plx.3.1682946054088;
        Mon, 01 May 2023 06:00:54 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7sJ8XYGjYfoGsFAQAkPFhfWxXemh27korpKb7et1oT9bj+Ty6RFc50SRgi1w1XYm/lZRZEmA==
X-Received: by 2002:a17:902:dac1:b0:1a6:93cc:924b with SMTP id q1-20020a170902dac100b001a693cc924bmr17134900plx.3.1682946053798;
        Mon, 01 May 2023 06:00:53 -0700 (PDT)
Received: from [10.66.61.39] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id jl13-20020a170903134d00b001a9666376a9sm14015518plb.226.2023.05.01.06.00.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 May 2023 06:00:53 -0700 (PDT)
Message-ID: <6ed566b3-c27b-182c-7c67-b262414bb61e@redhat.com>
Date:   Mon, 1 May 2023 21:00:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v5 28/29] lib: arm: Print test exit status
Content-Language: en-US
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, pbonzini@redhat.com,
        ricarkol@google.com
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
 <20230428120405.3770496-29-nikos.nikoleris@arm.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230428120405.3770496-29-nikos.nikoleris@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/28/23 20:04, Nikos Nikoleris wrote:
> From: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> The arm tests can be run under kvmtool, which doesn't emulate a chr-testdev
> device. Print the test exit status to make it possible for the runner
> scripts to pick it up when they have support for it.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   lib/arm/io.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/lib/arm/io.c b/lib/arm/io.c
> index 19f93490..c15e57c4 100644
> --- a/lib/arm/io.c
> +++ b/lib/arm/io.c
> @@ -149,6 +149,13 @@ extern void halt(int code);
>   
>   void exit(int code)
>   {
> +	/*
> +	 * Print the test return code in the following format which is
> +	 * consistent with powerpc and s390x. The runner can pick it
> +	 * up when chr-testdev is not present.
> +	 */
> +	printf("\nEXIT: STATUS=%d\n", ((code) << 1) | 1);
> +
>   	chr_testdev_exit(code);
>   	psci_system_off();
>   	halt(code);

-- 
Shaoqin

