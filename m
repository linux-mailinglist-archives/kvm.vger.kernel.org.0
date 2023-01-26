Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2815667D3C2
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 19:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbjAZSIo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 13:08:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjAZSIm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 13:08:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B931DBA7
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 10:07:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674756474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JPJcZCJeMXtNIVcSvHlLHeN+QFqCFf0Z1zlozMPClWw=;
        b=Ntx7U5JoVx4+n+3t/jB7oXzNkbJ/RO8Avk5Bm/tIb1RCQVXabS8Tiz7T8QGlvzIkwjogQe
        PybySW1MsUDJxSv5hzjnP3d6NoRsvLDDRilMIw/EHEMYZz46uFIPCrUYMtbRwg1DQAiqf/
        pupm6sT11TjEy/wsi57HYWkB1koMPZA=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-320-XrIDimyfODS1NS0wj09-QQ-1; Thu, 26 Jan 2023 13:07:53 -0500
X-MC-Unique: XrIDimyfODS1NS0wj09-QQ-1
Received: by mail-ej1-f70.google.com with SMTP id hq7-20020a1709073f0700b0086fe36ed3d0so1734269ejc.3
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 10:07:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JPJcZCJeMXtNIVcSvHlLHeN+QFqCFf0Z1zlozMPClWw=;
        b=1xhcTnb9ZmqzpWHLakJTj1C9rRqYTzBCYaaGvRxU6mQt5e1n5JDhayvtBicA3MXo9m
         r7+aDHuhKcx+NtLH9QutZ30dw9vpR70Sbjl0BSObEGdX/qjBcSehdEjaWViNNyGANiCs
         7FFzYyPP+00dZ+CihBbnDFE32jDxbR/FYBbRA4+FLzE1fNUAjwAwYscCWG+AFlZKtcpV
         V9Ke7JfoX3lqkTbAqMWCwPGexuw+hWQV3jBzKehIBqFQ1qu5b7S1460oQeZ0efnV7fMq
         qpyIFZI5q3zfXr7GsB5JdI8K3LVcYzgwMoKFfnGuk8EuHiyR7cPSz3FNVt8GAx5Bs5iJ
         WBOg==
X-Gm-Message-State: AO0yUKUqJkGuLlmavjDSrPjrGkjM5eq/686PW9hGa1p4bTRL1//Slz4j
        4zw9ppqpvkjqYvsx9ckPXXuBS60N0u8Wl+0Wyj7jSKUHabX7mbNv4PcU+RIu2c6CMQ+z8bFuOrB
        +bd3soIcvOUnG
X-Received: by 2002:a17:906:2c03:b0:878:734d:1d87 with SMTP id e3-20020a1709062c0300b00878734d1d87mr1968164ejh.47.1674756472007;
        Thu, 26 Jan 2023 10:07:52 -0800 (PST)
X-Google-Smtp-Source: AK7set+e9dDlpXORthWM1Snp5LdPVU6ymxzecZzigYkUZU4rX8EVpaxIztZgQSCgh+vGG+C0vFcEtg==
X-Received: by 2002:a17:906:2c03:b0:878:734d:1d87 with SMTP id e3-20020a1709062c0300b00878734d1d87mr1968151ejh.47.1674756471805;
        Thu, 26 Jan 2023 10:07:51 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id b13-20020aa7cd0d000000b004a028d443f9sm1075564edw.55.2023.01.26.10.07.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Jan 2023 10:07:51 -0800 (PST)
Message-ID: <c4b2d1e1-c255-8cd3-6ec9-2748fd2951cb@redhat.com>
Date:   Thu, 26 Jan 2023 19:07:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 1/3] KVM: x86/emulator: Fix segment load privilege level
 validation
Content-Language: en-US
To:     Michal Luczaj <mhal@rbox.co>, kvm@vger.kernel.org
Cc:     seanjc@google.com
References: <20230126013405.2967156-1-mhal@rbox.co>
 <20230126013405.2967156-2-mhal@rbox.co>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230126013405.2967156-2-mhal@rbox.co>
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
> Intel SDM describes what steps are taken by the CPU to verify if a
> memory segment can actually be used at a given privilege level. Loading
> DS/ES/FS/GS involves checking segment's type as well as making sure that
> neither selector's RPL nor caller's CPL are greater than segment's DPL.
> 
> Emulator implements Intel's pseudocode in __load_segment_descriptor(),
> even quoting the pseudocode in the comments. Although the pseudocode is
> correctly translated, the implementation is incorrect. This is most
> likely due to SDM, at the time, being wrong.
> 
> Patch fixes emulator's logic and updates the pseudocode in the comment.
> Below are historical notes.
> 
> Emulator code for handling segment descriptors appears to have been
> introduced in March 2010 in commit 38ba30ba51a0 ("KVM: x86 emulator:
> Emulate task switch in emulator.c"). Intel SDM Vol 2A: Instruction Set
> Reference, A-M (Order Number: 253666-034US, _March 2010_) lists the
> steps for loading segment registers in section related to MOV
> instruction:
> 
>    IF DS, ES, FS, or GS is loaded with non-NULL selector
>    THEN
>      IF segment selector index is outside descriptor table limits
>      or segment is not a data or readable code segment
>      or ((segment is a data or nonconforming code segment)
>      and (both RPL and CPL > DPL))   <---
>        THEN #GP(selector); FI;
> 
> This is precisely what __load_segment_descriptor() quotes and
> implements. But there's a twist; a few SDM revisions later
> (253667-044US), in August 2012, the snippet above becomes:
> 
>    IF DS, ES, FS, or GS is loaded with non-NULL selector
>    THEN
>      IF segment selector index is outside descriptor table limits
>      or segment is not a data or readable code segment
>      or ((segment is a data or nonconforming code segment)
>        [note: missing or superfluous parenthesis?]
>      or ((RPL > DPL) and (CPL > DPL))   <---
>        THEN #GP(selector); FI;
> 
> Many SDMs later (253667-065US), in December 2017, pseudocode reaches
> what seems to be its final form:
> 
>    IF DS, ES, FS, or GS is loaded with non-NULL selector
>    THEN
>      IF segment selector index is outside descriptor table limits
>      OR segment is not a data or readable code segment
>      OR ((segment is a data or nonconforming code segment)
>          AND ((RPL > DPL) or (CPL > DPL)))   <---
>        THEN #GP(selector); FI;
> 
> Signed-off-by: Michal Luczaj <mhal@rbox.co>
> ---
>   arch/x86/kvm/emulate.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 5cc3efa0e21c..81b8f5dcfa44 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -1695,11 +1695,11 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
>   		/*
>   		 * segment is not a data or readable code segment or
>   		 * ((segment is a data or nonconforming code segment)
> -		 * and (both RPL and CPL > DPL))
> +		 * and ((RPL > DPL) or (CPL > DPL)))
>   		 */
>   		if ((seg_desc.type & 0xa) == 0x8 ||
>   		    (((seg_desc.type & 0xc) != 0xc) &&
> -		     (rpl > dpl && cpl > dpl)))
> +		     (rpl > dpl || cpl > dpl)))
>   			goto exception;
>   		break;
>   	}

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

