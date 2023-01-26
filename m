Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E273267D3C3
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 19:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbjAZSIv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 13:08:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbjAZSIt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 13:08:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717BD3BD8A
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 10:08:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674756481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XUfd3F8yHjau4G5KPqumqUM9hybLXhtOYrry+/TZmlo=;
        b=iETK/kl406j0ReX+Bl1XYrInUvnB3JLinufRyIi8F4JQI5zbA0VXqrpK4EU6fJCpZRl6yI
        Ls2U8DZZV93Opseb69PUk4okeTlO/YSGuPPOFehNPP0CG1NZudiep+1fNJ/u6ztDg0RAhW
        qx2uBdStFdg18evJ9JzZoOtHUAZ8Bl0=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-295-bMrkrQGlPfSV48YAc46DXQ-1; Thu, 26 Jan 2023 13:07:59 -0500
X-MC-Unique: bMrkrQGlPfSV48YAc46DXQ-1
Received: by mail-ej1-f69.google.com with SMTP id hr22-20020a1709073f9600b0086ffb73ac1cso1731377ejc.23
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 10:07:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XUfd3F8yHjau4G5KPqumqUM9hybLXhtOYrry+/TZmlo=;
        b=Y4aEDtFAdgRHxT/K9BMDA25eyM4+F5jKJX/gxDdKTEemuD8WeU37Tz4TzgJbC6Lzsy
         bCAaJEXBS/3Yo6q1osvDA6AanYQcMF1+ZzS0CKsRkj4IGrsKZDpjdvkbJxS398v7y7h+
         lELbzs3doEWOInLUUDFO4vUyNN5QYSENhGzT4B0cylV54mN6mqoakCPy5bhAnOK1D7bN
         fgiNNr2e00TWMTFwsdRgjjQJ+rYlp95383kgYBemKkznC8uU6/q3QBfFvVplda5uWWzx
         UlLCYfstbQzW/Yk4PUkmgplnIN1x0W7nMR4YmXObJv5zoDn8vnwAyIVPyvoO/alcTMHI
         UNVA==
X-Gm-Message-State: AFqh2krKPuw8aHZcDggJuUHhmK7yTxwhUsemsHpCcDL2cac+B9nidXy9
        t6vxgZCjaW+w7ma7SHkrk2dbwsciTuxT+2D8jrJ5CiJNdoo/3x4W3PBrP1hXPvPYNTacXe5Vj+9
        PPTo1cHaodIWk
X-Received: by 2002:aa7:c14e:0:b0:46d:cead:4eab with SMTP id r14-20020aa7c14e000000b0046dcead4eabmr38099638edp.6.1674756478860;
        Thu, 26 Jan 2023 10:07:58 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtL4hpxUyRcguCbXdNrK+On8IRA8vMxk/pILqCXE3JqnaFU+54IoqEfM/EXPc/vxP89/HLn5g==
X-Received: by 2002:aa7:c14e:0:b0:46d:cead:4eab with SMTP id r14-20020aa7c14e000000b0046dcead4eabmr38099623edp.6.1674756478688;
        Thu, 26 Jan 2023 10:07:58 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id t13-20020a50d70d000000b00458b41d9460sm1084145edi.92.2023.01.26.10.07.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Jan 2023 10:07:58 -0800 (PST)
Message-ID: <10480ae9-9838-9e9c-dfda-626df0d7a240@redhat.com>
Date:   Thu, 26 Jan 2023 19:07:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 2/3] KVM: x86/emulator: Fix comment in
 __load_segment_descriptor()
Content-Language: en-US
To:     Michal Luczaj <mhal@rbox.co>, kvm@vger.kernel.org
Cc:     seanjc@google.com
References: <20230126013405.2967156-1-mhal@rbox.co>
 <20230126013405.2967156-3-mhal@rbox.co>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230126013405.2967156-3-mhal@rbox.co>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/26/23 02:34, Michal Luczaj wrote:
> The comment refers to the same condition twice. Make it reflect what the
> code actually does.
> 
> No functional change intended.
> 
> Signed-off-by: Michal Luczaj <mhal@rbox.co>
> ---
>   arch/x86/kvm/emulate.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 81b8f5dcfa44..91581bfeba22 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -1633,7 +1633,7 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
>   	case VCPU_SREG_SS:
>   		/*
>   		 * segment is not a writable data segment or segment
> -		 * selector's RPL != CPL or segment selector's RPL != CPL
> +		 * selector's RPL != CPL or DPL != CPL
>   		 */
>   		if (rpl != cpl || (seg_desc.type & 0xa) != 0x2 || dpl != cpl)
>   			goto exception;

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

