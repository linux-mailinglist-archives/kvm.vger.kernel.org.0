Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C197177B69A
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 12:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234663AbjHNKYW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 06:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236836AbjHNKYL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 06:24:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBBFA10C1
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 03:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692008601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TeLUVrGt92hyTJJZe96M/I16QCmsjhVESaM/SouixQg=;
        b=GjPq9Qp4wG4GFjxN9RlDln3yKmgMrGtJRFYX09YcGCLHRyYr9Rx+jVAvY9h0jdBLFb9ZBU
        rSPP0rCwKcAQytxizQC6RrvaP5GCY9V2mVy5AWFkbpSfr4cjmIF2nH8+0z4/UWGLa0ATyw
        dEVZK4zoYcJrmLnJGSl6RyxMekVtctk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-587-sTiaBPrQN4-UVvjDUn0adg-1; Mon, 14 Aug 2023 06:23:19 -0400
X-MC-Unique: sTiaBPrQN4-UVvjDUn0adg-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-313c930ee0eso2400763f8f.0
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 03:23:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692008598; x=1692613398;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TeLUVrGt92hyTJJZe96M/I16QCmsjhVESaM/SouixQg=;
        b=J3tSEDqtFlZ+E/nfY7UXYFwmdj1tyNsSzYB0PW1ADWbgeTBfC5cPJHC+WywF2JKP4G
         KXjlftd0dtT+vgK9Jnveda5yhc0gkrJktmRqycB9knJAKlwkVQGsbIPAMFuB1uQxGWsd
         XBFouQ0IPG6m17DEYFQTJsBhA9GPDsNvzVk+lH3xChJK4ITE8XhNe9XXPj45mL9ZXn5m
         gqmVU4iCq4L8318hNPCJezNekll81n96wOYz5clu7VtUJ7O4asy3DhcQua9clJTsSFPs
         eIjzOF+tlXz2Sn6pz6WcI+jn4LmmOS0fBcFylo/gbkPEZbjbMNm3q+bH5Hl8qXM9qEvX
         cK9g==
X-Gm-Message-State: AOJu0YxTBO2PBfMAOLhPcbygZxiybxIyCi33WZAPiEoom4c7+ysZbbKM
        I8CDi5R0mrRprvATaALG8jpjsYIdgqMpnvC9XZDca9sRSklcjhO/rbAilxnFaT77mq9aYtxPRtZ
        3lDpMTCF4I6pBlJlqpGe4
X-Received: by 2002:adf:f041:0:b0:313:fe1b:f444 with SMTP id t1-20020adff041000000b00313fe1bf444mr6025598wro.68.1692008598492;
        Mon, 14 Aug 2023 03:23:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGk431CcIU0nC/ZlJfr94Ibz0UhYGVcUu0oIkiQ3p0YVUUYgb6a+HDazlSMtQNjlj7nkmH1Xg==
X-Received: by 2002:adf:f041:0:b0:313:fe1b:f444 with SMTP id t1-20020adff041000000b00313fe1bf444mr6025590wro.68.1692008598171;
        Mon, 14 Aug 2023 03:23:18 -0700 (PDT)
Received: from [192.168.8.105] (dynamic-046-114-244-033.46.114.pool.telefonica.de. [46.114.244.33])
        by smtp.gmail.com with ESMTPSA id t7-20020a05600001c700b0031423a8f4f7sm14163529wrx.56.2023.08.14.03.23.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Aug 2023 03:23:17 -0700 (PDT)
Message-ID: <b25d92c6-7d2a-337f-10d6-ee7e6b9d7288@redhat.com>
Date:   Mon, 14 Aug 2023 12:23:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [kvm-unit-tests PATCH v1] s390x: spec_ex: load full register
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, nsg@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230811112949.888903-1-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230811112949.888903-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/08/2023 13.29, Nico Boehr wrote:
> There may be contents left in the upper 32 bits of executed_addr; hence
> we should use a 64-bit load to make sure they are overwritten.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   s390x/spec_ex.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
> index e3dd85dcb153..72b942576369 100644
> --- a/s390x/spec_ex.c
> +++ b/s390x/spec_ex.c
> @@ -142,7 +142,7 @@ static int psw_odd_address(void)
>   		"	larl	%%r1,0f\n"
>   		"	stg	%%r1,%[fixup_addr]\n"
>   		"	lpswe	%[odd_psw]\n"
> -		"0:	lr	%[executed_addr],%%r0\n"
> +		"0:	lgr	%[executed_addr],%%r0\n"
>   	: [fixup_addr] "=&T" (fixup_psw.addr),
>   	  [executed_addr] "=d" (executed_addr)
>   	: [odd_psw] "Q" (odd)

Reviewed-by: Thomas Huth <thuth@redhat.com>

