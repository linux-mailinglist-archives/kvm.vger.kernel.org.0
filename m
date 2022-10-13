Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C72565FDC04
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 16:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbiJMOHE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 10:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiJMOHD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 10:07:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5514E182
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 07:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665669961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cDpQAoNALIq+h8KbThlvz2lpLVvK17PHPFb0cifDAek=;
        b=OoZm7ZsrfjCd3/83iz/0qe8FqLQPeI/9aKmXEejr8Be3ebH9M9+NEqJk6ybEcyJvOfJqCC
        6c2vkwLyWDAi+NJ9pKjV4gQhMGisyoh72kbNnzbda1X0M7JT6Zlete/YzNYMeu77JeAEhh
        vPOXWkqDQIiZFqPaNota98YDW3hIbvM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-139-th4wSzy-NFaQ0KQ0mOzxjg-1; Thu, 13 Oct 2022 10:01:58 -0400
X-MC-Unique: th4wSzy-NFaQ0KQ0mOzxjg-1
Received: by mail-wr1-f71.google.com with SMTP id e14-20020adf9bce000000b0022d18139c79so592944wrc.5
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 07:01:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cDpQAoNALIq+h8KbThlvz2lpLVvK17PHPFb0cifDAek=;
        b=xrf9Kkg68NVzfFQKKQViRCxgkWeQXdjnQx11TXEdm2rNLL7g41Td/UsPdRF6ITBYbJ
         kk3vgj4GwQWkKSbvSE/MTbnroAWo9XnwtsnY2+zQ94+Z9S+/1dD0XU2djTXFhg3Z4EeA
         uY3o+1PHM282q/XaTYIbCtfAn8fo0QLk0D5M5q+Wlig3Ht1UmHzliG9ZiYxPNK+RSOqv
         uRqgR+BEIYevqPAVfrJ1W6WZuOO0ppo5zpCJ0H86NUf6hdiSKSXWjMtfymBgwjkkGsUX
         3vttuyWVTHhHaCacS1S8duJvNACZBwLzPPkQKg7ckf+qlar08Z3Xx1qv/cYoLn1razd2
         D0pA==
X-Gm-Message-State: ACrzQf33cwlF+VI7YsahDoWVwZCcIxkLF8/gtXVPEPNMhY3fwW/TUao+
        2jJO8yVC847s1IZoGArolrQhIOOoG4vtYe6bJrUYggmxmdgW2crGeiQRYloGyh523RPPSW/cBJB
        hgMEC6VGgheSB
X-Received: by 2002:adf:9d8a:0:b0:230:5212:d358 with SMTP id p10-20020adf9d8a000000b002305212d358mr62935wre.405.1665669717172;
        Thu, 13 Oct 2022 07:01:57 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4imcYQGES8zlCKJ5HwmdvBAJVA4AYX5YQd3dYEFRhf977vBrZlmNHTSJaewCknJLwTPls8BA==
X-Received: by 2002:adf:9d8a:0:b0:230:5212:d358 with SMTP id p10-20020adf9d8a000000b002305212d358mr62913wre.405.1665669716922;
        Thu, 13 Oct 2022 07:01:56 -0700 (PDT)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id bh15-20020a05600c3d0f00b003b31c560a0csm4736635wmb.12.2022.10.13.07.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 07:01:56 -0700 (PDT)
Date:   Thu, 13 Oct 2022 15:01:53 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Michael Roth <michael.roth@amd.com>
Subject: Re: [PATCH 4/4] i386/cpu: Update how the EBX register of CPUID
 0x8000001F is set
Message-ID: <Y0gaUYeH3Wzojd6W@work-vm>
References: <cover.1664550870.git.thomas.lendacky@amd.com>
 <5822fd7d02b575121380e1f493a8f6d9eba2b11a.1664550870.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5822fd7d02b575121380e1f493a8f6d9eba2b11a.1664550870.git.thomas.lendacky@amd.com>
User-Agent: Mutt/2.2.7 (2022-08-07)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Tom Lendacky (thomas.lendacky@amd.com) wrote:
> Update the setting of CPUID 0x8000001F EBX to clearly document the ranges
> associated with fields being set.
> 
> Fixes: 6cb8f2a663 ("cpu/i386: populate CPUID 0x8000_001F when SEV is active")
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  target/i386/cpu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 1db1278a59..d4b806cfec 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -5853,8 +5853,8 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>          if (sev_enabled()) {
>              *eax = 0x2;
>              *eax |= sev_es_enabled() ? 0x8 : 0;
> -            *ebx = sev_get_cbit_position();
> -            *ebx |= sev_get_reduced_phys_bits() << 6;
> +            *ebx = sev_get_cbit_position() & 0x3f; /* EBX[5:0] */
> +            *ebx |= (sev_get_reduced_phys_bits() & 0x3f) << 6; /* EBX[11:6] */
>          }
>          break;
>      default:
> -- 
> 2.37.3
> 
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

