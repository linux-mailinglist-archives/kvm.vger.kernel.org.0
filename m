Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5596F3117
	for <lists+kvm@lfdr.de>; Mon,  1 May 2023 14:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbjEAMnZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 May 2023 08:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232554AbjEAMnX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 May 2023 08:43:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2251730
        for <kvm@vger.kernel.org>; Mon,  1 May 2023 05:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682944908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fKMPWxsBfvIcbsbwykvKjWGLcJ2fFrJZa2HJMFlk8k8=;
        b=KTw5bniPoQbwyo5pHXHMORuv2O5Rj1vEW8MLdK4JbFIEnYOZ7TMfngLgPs4XJrQIbCL+M2
        q20qzvNeTSJlwaubgMAW8QGyblhXPFMBHNYPM/v3BvQDc93lrftSTAG6lamxydf3zjs8/h
        ipRN9wtrKR8orst3T5DHaNujv31mkcg=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-306-RLyHG9MVPvevLvJCadTphQ-1; Mon, 01 May 2023 08:41:47 -0400
X-MC-Unique: RLyHG9MVPvevLvJCadTphQ-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1a9259dff6fso1056975ad.0
        for <kvm@vger.kernel.org>; Mon, 01 May 2023 05:41:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682944906; x=1685536906;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fKMPWxsBfvIcbsbwykvKjWGLcJ2fFrJZa2HJMFlk8k8=;
        b=kHcHqu/Ix1Lhz9q/WuP+wN54ZmOhhdWAHgny9iKSVITrwa3X8kcqted329bMhJ8MTN
         I5QjIiyGTlC+ECxLsLmHjz6qNZebSRhm3EQpjOhx7/qCyG3dDnoyfSj3rYzurajDh68X
         AP8vHDGBMetTGYJ/d8R1ehw3UBlZ+e8jsvpYGTURj7WIHmwXTJ95RJZarDGjbRn9nEdT
         UtiSK26RW+1KXYDt8EGsblnD1IjyYGYJDORwcyZSqTBTB8aN6B1jAJuFYqNdREXT9n4u
         g2MOZ4Ph+Wvyr4ogQJqyd4WMb70kJwZdym6WLF3vatnUuNo/G+Akz7e65NSkSDpfP6su
         K9mA==
X-Gm-Message-State: AC+VfDxY6TbwwKpb87EJk3VZ3eJGZdidYJdhAb97VFnBkuVHtXxinF9T
        vLCANFvMAfLv+GDq+QfaYc3zVaaYMEhzKk2PVqC8ImVv8tr3if4deV9Tj5tQEnO3AX1wTO8L8eI
        rp7jH1dn13L711WSWuSiWCFQ31w==
X-Received: by 2002:a17:903:41c4:b0:1a7:db2f:e918 with SMTP id u4-20020a17090341c400b001a7db2fe918mr13620978ple.1.1682944906200;
        Mon, 01 May 2023 05:41:46 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7E9kWQENcbQpSEsKYxzb7I6bzQxCoS7T+2JxMpx98zbJ2WdvOjFhF4Dq4GQRssYxUluFgPbg==
X-Received: by 2002:a17:903:41c4:b0:1a7:db2f:e918 with SMTP id u4-20020a17090341c400b001a7db2fe918mr13620956ple.1.1682944905915;
        Mon, 01 May 2023 05:41:45 -0700 (PDT)
Received: from [10.66.61.39] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o3-20020a170902778300b001a1a07d04e6sm17783018pll.77.2023.05.01.05.41.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 May 2023 05:41:45 -0700 (PDT)
Message-ID: <c458cf99-d0a9-1279-8bae-ad14ccb45a06@redhat.com>
Date:   Mon, 1 May 2023 20:41:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v5 02/29] x86: Move x86_64-specific EFI
 CFLAGS to x86_64 Makefile
Content-Language: en-US
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
 <20230428120405.3770496-3-nikos.nikoleris@arm.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230428120405.3770496-3-nikos.nikoleris@arm.com>
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



On 4/28/23 20:03, Nikos Nikoleris wrote:
> Compiler flag -macculate-outgoing-args is only needed by the x86_64
> ABI. Move it to the relevant Makefile.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   Makefile            | 4 ----
>   x86/Makefile.x86_64 | 4 ++++
>   2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 6ed5deac..307bc291 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -40,14 +40,10 @@ OBJDIRS += $(LIBFDT_objdir)
>   
>   # EFI App
>   ifeq ($(CONFIG_EFI),y)
> -EFI_ARCH = x86_64
>   EFI_CFLAGS := -DCONFIG_EFI
>   # The following CFLAGS and LDFLAGS come from:
>   #   - GNU-EFI/Makefile.defaults
>   #   - GNU-EFI/apps/Makefile
> -# Function calls must include the number of arguments passed to the functions
> -# More details: https://wiki.osdev.org/GNU-EFI
> -EFI_CFLAGS += -maccumulate-outgoing-args
>   # GCC defines wchar to be 32 bits, but EFI expects 16 bits
>   EFI_CFLAGS += -fshort-wchar
>   # EFI applications use PIC as they are loaded to dynamic addresses, not a fixed
> diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
> index f483dead..2771a6fa 100644
> --- a/x86/Makefile.x86_64
> +++ b/x86/Makefile.x86_64
> @@ -2,6 +2,10 @@ cstart.o = $(TEST_DIR)/cstart64.o
>   bits = 64
>   ldarch = elf64-x86-64
>   ifeq ($(CONFIG_EFI),y)
> +# Function calls must include the number of arguments passed to the functions
> +# More details: https://wiki.osdev.org/GNU-EFI
> +CFLAGS += -maccumulate-outgoing-args
> +
>   exe = efi
>   bin = so
>   FORMAT = efi-app-x86_64

-- 
Shaoqin

