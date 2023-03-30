Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 012AF6CFBE9
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 08:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbjC3Guf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 02:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjC3Gud (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 02:50:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16BBB61BF
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 23:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680158981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+HljoYyE0A4dfFt+IDGioQ59lFVM9ZhkEwh8bnOu3Vk=;
        b=A4tTl00OKsCiM8FlsgKpojNFAHyvEAisX1yoBgg4D/xQ+hnURawzx6tNsmFZsIoUvmSPL3
        uSe0F7BTERodZ47yEPGmF4hxpRIcr9YQBfVgx9tU4RIZuXPC3OHHCMEbbRBsMVk/1DyfGZ
        KcIPP+r6I1Hj6caM+VQt3IHazu0RTD8=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-481-mxEj7N2vMcOSnRS63BI4Tg-1; Thu, 30 Mar 2023 02:49:39 -0400
X-MC-Unique: mxEj7N2vMcOSnRS63BI4Tg-1
Received: by mail-pl1-f200.google.com with SMTP id f6-20020a170902ce8600b001a25ae310a9so5071738plg.10
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 23:49:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680158978; x=1682750978;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+HljoYyE0A4dfFt+IDGioQ59lFVM9ZhkEwh8bnOu3Vk=;
        b=NmPNtQ4pwYUXgkJ6i5Akjt8Zukrz2TkoLzesaG5Ai03b3DCrkI043VobKCm1nTRnaw
         QDoNC9AlnOhH2uklHEYy9dDPjSSHTsAH+S0e0D3x7D1TdeDGHtWKxTfqV2/Y/m/ZN1Jb
         +NILgSbn3bWjKs29li6KCqweEJW1xLP+Xo44w31wnKSe45jyhAkqACZ+4JaT2Wd1O1fF
         BddfEh3IXcrKDdU5gyW9rPna4OzmiHc4/5Zu0fj9N/8BKnSh2qXnc/r3STA2o+ixtTuG
         TtUqspRUcVoq0NWDZjEBAF2ELRK55GPGdxZd5RkpghizJudxAesmvX4gvULh+3hlpTHS
         nQ7w==
X-Gm-Message-State: AAQBX9fofyjmT2cmMOoE1hnCSlv36pGIzFABEHCh93GCrBkbU01+g9JX
        zmXxkV5UWY9JvigCTU9StEBcGwhEPTib2WMq2rd+LHwRNvRqIbRJSmy6H0BQNWylpV6/fUdXzsF
        iIwup+kajohMg
X-Received: by 2002:a05:6a20:7fa4:b0:d9:ec4b:82b4 with SMTP id d36-20020a056a207fa400b000d9ec4b82b4mr1754097pzj.1.1680158978539;
        Wed, 29 Mar 2023 23:49:38 -0700 (PDT)
X-Google-Smtp-Source: AKy350YtUaPWBGGCMAs8Xf3BCWlvYX/FlSXZ9uqmvdzXiNkbTZlWKF2YXQ5ww1SBp0SsotUVOky6RQ==
X-Received: by 2002:a05:6a20:7fa4:b0:d9:ec4b:82b4 with SMTP id d36-20020a056a207fa400b000d9ec4b82b4mr1754081pzj.1.1680158978270;
        Wed, 29 Mar 2023 23:49:38 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id p18-20020a62ab12000000b005809d382016sm14403050pff.74.2023.03.29.23.49.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Mar 2023 23:49:37 -0700 (PDT)
Message-ID: <9412d307-3fd8-b694-7c18-8bf248070f3c@redhat.com>
Date:   Thu, 30 Mar 2023 14:49:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v4 25/30] arm64: Change GNU-EFI imported code to use
 defined types
Content-Language: en-US
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
References: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
 <20230213101759.2577077-26-nikos.nikoleris@arm.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230213101759.2577077-26-nikos.nikoleris@arm.com>
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

Hi Nikos,

On 2/13/23 18:17, Nikos Nikoleris wrote:
> Convert some types to avoid dependency on gnu-efi's <efi.h> and
> <efilib.h>.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>   arm/efi/reloc_aarch64.c | 9 +++------
>   1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/arm/efi/reloc_aarch64.c b/arm/efi/reloc_aarch64.c
> index 08672796..fa0cd6bc 100644
> --- a/arm/efi/reloc_aarch64.c
> +++ b/arm/efi/reloc_aarch64.c
> @@ -34,14 +34,11 @@
>       SUCH DAMAGE.
>   */
>   
> -#include <efi.h>
> -#include <efilib.h>
> - > +#include "efi.h"

In [PATCH v4 27/30] lib: Avoid external dependency in libelf. The 
Include header file changed again.

So why not move this change early?

diff --git a/arm/efi/reloc_aarch64.c b/arm/efi/reloc_aarch64.c
index fa0cd6bc..3f6d9a6d 100644
--- a/arm/efi/reloc_aarch64.c
+++ b/arm/efi/reloc_aarch64.c
@@ -34,8 +34,7 @@
      SUCH DAMAGE.
  */

-#include "efi.h"
-#include <elf.h>
+#include <efi.h>

Thanks,
Shaoqin
>   #include <elf.h>
>   
> -EFI_STATUS _relocate (long ldbase, Elf64_Dyn *dyn,
> -		      EFI_HANDLE image EFI_UNUSED,
> -		      EFI_SYSTEM_TABLE *systab EFI_UNUSED)
> +efi_status_t _relocate(long ldbase, Elf64_Dyn *dyn, efi_handle_t image,
> +		       efi_system_table_t *sys_tab)
>   {
>   	long relsz = 0, relent = 0;
>   	Elf64_Rela *rel = 0;

-- 
Shaoqin

