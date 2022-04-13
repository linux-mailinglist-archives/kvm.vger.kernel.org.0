Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2826250007A
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 23:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237702AbiDMVDB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 17:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238031AbiDMVC6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 17:02:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2EAFB4EF79
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 14:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649883635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n+VYFBlOYdxlhDGjMtukpheMaR3WldPQTuTWc9yER7c=;
        b=NfB+/L1VRqXLHVKEHK3deX8QY7NcoLmoB7qFph4KwWI/o8Djc3x+gZaVhBVxJi7JZHB6uO
        r6A9ZK5w8R8cGASWYfqZl2YnfA45rx3VWtB+LSLlf1HRdiR6zCGqFoBHwNrNf0nLuqevCq
        cJe/7sU+/DkaaQQyftWiknNjA2fl7cw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-147-iWt4v_L8MeKssOSs--TkhQ-1; Wed, 13 Apr 2022 17:00:33 -0400
X-MC-Unique: iWt4v_L8MeKssOSs--TkhQ-1
Received: by mail-wm1-f71.google.com with SMTP id l19-20020a05600c1d1300b0038e736f98faso1400464wms.4
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 14:00:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=n+VYFBlOYdxlhDGjMtukpheMaR3WldPQTuTWc9yER7c=;
        b=ojfHnIu71U5//l8+wFC9I53DU+6BuKKizKWUklTGNzZ7v9ioe07spUyHTu58iuHjUw
         eAqJKiRc2XG/Es9RBk74m/4BAqoEVgTpMOiTP+++GvNLegFpsmEj2DobFo4Y2Ra00DzW
         Dxh3CvVPC+MBDRH6+irvmJCALVYc/m/8Dni2gnLLCrxGFbTD1/mJa+Nl4EHhnsOCX2Xw
         +twO7Cl4L3B+nsnZGEhCXWLEQaYi33OIM0IfackzDAqYkUxdN2jW60RyzMtONTU3+7rU
         rxjoJmHM0hhgVYnUtQpTGuNOfB+casEm0cqAN3Vdt0drbcdyx2N7E0zm3v60sUaYQ1lX
         fZsA==
X-Gm-Message-State: AOAM533ZcvaYaeBMgtnpM9APYcJ7p5YqxYS3Fw1wZOMojZj9xWwkRonM
        5MDQmHnL8+IbL2FmYT2x66MRqU/O5hgBMSt/RiMELAtcNeb6N4NaEEdoSAMTy1I+QPeaxdxkM3A
        S4LvIuiQ7470s
X-Received: by 2002:adf:ec4c:0:b0:207:a66e:1011 with SMTP id w12-20020adfec4c000000b00207a66e1011mr460922wrn.599.1649883632228;
        Wed, 13 Apr 2022 14:00:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyRXO59Ge512bfuVWWeBVmySq/zk07sj67GKPv5/dp1gMHL407ur8Y1/dfvGqFYYj7c8sO82A==
X-Received: by 2002:adf:ec4c:0:b0:207:a66e:1011 with SMTP id w12-20020adfec4c000000b00207a66e1011mr460910wrn.599.1649883632031;
        Wed, 13 Apr 2022 14:00:32 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id v15-20020a056000144f00b002057eac999fsm97367wrx.76.2022.04.13.14.00.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Apr 2022 14:00:30 -0700 (PDT)
Message-ID: <537a6994-01b1-7d2b-fa38-2158cde1d166@redhat.com>
Date:   Wed, 13 Apr 2022 23:00:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [kvm-unit-tests PATCH] x86: efi: Fix pagetable creation
Content-Language: en-US
To:     Varad Gautam <varad.gautam@suse.com>, kvm@vger.kernel.org
Cc:     drjones@redhat.com, marcorr@google.com, zxwang42@gmail.com,
        jroedel@suse.de
References: <20220406123312.12986-1-varad.gautam@suse.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220406123312.12986-1-varad.gautam@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/6/22 14:33, Varad Gautam wrote:
> setup_page_table() ends up filling invalid page table entries
> at ptl2 due to improper typecasting. This sometimes leads to
> unhandled pagefaults when writing to APIC registers. Fix it.
> 
> Fixes: e6f65fa464 ("x86 UEFI: Set up page tables")
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> ---
>   lib/x86/setup.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/x86/setup.c b/lib/x86/setup.c
> index bbd3468..7bc7c93 100644
> --- a/lib/x86/setup.c
> +++ b/lib/x86/setup.c
> @@ -258,7 +258,7 @@ static void setup_page_table(void)
>   	curr_pt = (pgd_t *)&ptl2;
>   	flags |= PT_ACCESSED_MASK | PT_DIRTY_MASK | PT_PAGE_SIZE_MASK | PT_GLOBAL_MASK;
>   	for (i = 0; i < 4 * 512; i++)	{
> -		curr_pt[i] = ((phys_addr_t)(i << 21)) | flags;
> +		curr_pt[i] = ((phys_addr_t) i << 21) | flags;
>   	}
>   
>   	if (amd_sev_es_enabled()) {

Applied, thanks.

Paolo

