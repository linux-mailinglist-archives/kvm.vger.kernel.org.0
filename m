Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6005B5F59F2
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 20:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbiJESir (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 14:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231695AbiJESia (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 14:38:30 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E644C80E80
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 11:38:08 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id o128so3864079pfb.4
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 11:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tfsF3rK6+f1YUj9RsN72Nz/nj2bMoE74f9/IOE7duwk=;
        b=oMNM9fR3Ng5UJjWEFNhHC+eqprsfJQYyI8QICmxFx3ycQCkEqpELBO7oVPkbhNDkR5
         xfbZU9Pw6Ircz+Tx8Zhq1C0avqKwwmluhQ8kbgu2YkWFUOL/qPGzZNSOPnIzegDfpcdo
         yf1UTY5EW3NUqzgamnbOUt21I5O5twuSZz8ifTZSgZhnilDjFr57gXvgKS2glL27xh9B
         uB9uxoGTX44977h6nr60eV7C0kcCB/4YYO1dNDWFfExNAU8/6Rk1HmpNOCQ6rghOzuWe
         zzP+noFbx/zhGqeeJHwXroitPkFjnl5IIXESzhVRTZ3wzwdTJuDpyGCF5hZQ0z0uORSi
         AUMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tfsF3rK6+f1YUj9RsN72Nz/nj2bMoE74f9/IOE7duwk=;
        b=ieBeZPR3AbuuZUTTe08sEiJGzFecAutHDy0mh1tCM08EYMXXGSyPGT1VKniiGFF3Nr
         N+pTCsrQaPijD8ON+L1r/QTclwUDC6ymZkvAxZF8AxXjnYzL3ZsCd+/lE6qZhB9wGAPZ
         FAXByYTyPC1Z588QIKCFTkeP3I6dolIWc57L2+bAOXvQl1R+b8/zfXI7JVSsXdJhe5Ik
         0O+fiQvgdpJ1cSWGyeNG7i9jaSw9wLXr8mez6hZ4mfvxCmTb4QNGtsaR9A99UALPsF4n
         wChyXuqvbMPFHEnphg7/CyrbPUXNZnTzUPT30wCKAB0+mlomBcOI9fJUH+WvHdWfWIyg
         XI0A==
X-Gm-Message-State: ACrzQf1Deb+cMdDWj4Aca4WkmsWJdDL3+ppF1bJL8HyMTt+dLxgItIP9
        sTHe4w3I/3a/O+w3vsGAHaZihg==
X-Google-Smtp-Source: AMsMyM5rYdjeUkyW/WXIBHlZhpM+/J3cDJI+vZX/hCXR5YdnhUdUCRSM/bv86cr94AoRkYpAdxuQ4w==
X-Received: by 2002:a63:fc4f:0:b0:453:f99f:b252 with SMTP id r15-20020a63fc4f000000b00453f99fb252mr993257pgk.279.1664995088333;
        Wed, 05 Oct 2022 11:38:08 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o11-20020a62f90b000000b0053b850b17c8sm11228031pfh.152.2022.10.05.11.38.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 11:38:07 -0700 (PDT)
Date:   Wed, 5 Oct 2022 18:38:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zixuan Wang <zxwang@fb.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        shankaran@fb.com, somnathc@fb.com, marcorr@google.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de,
        zxwang42@gmail.com
Subject: Re: [kvm-unit-tests RFC PATCH 5/5] x86/efi: Update README with
 standalone instructions
Message-ID: <Yz3PDMsaMVAgvXOe@google.com>
References: <20220816175413.3553795-1-zxwang@fb.com>
 <20220816175413.3553795-6-zxwang@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816175413.3553795-6-zxwang@fb.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 16, 2022, Zixuan Wang wrote:
> Update the `x86/efi/README.md` with instructions to build and run
> standalone test cases with UEFI.
> 
> Signed-off-by: Zixuan Wang <zxwang@fb.com>
> ---
>  x86/efi/README.md | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/x86/efi/README.md b/x86/efi/README.md
> index aa1dbcd..f740225 100644
> --- a/x86/efi/README.md
> +++ b/x86/efi/README.md
> @@ -30,6 +30,16 @@ the env variable `EFI_UEFI`:
>  
>      EFI_UEFI=/path/to/OVMF.fd ./x86/efi/run ./x86/msr.efi
>  
> +### Build and standalone test cases with UEFI

s/and// ?

> +
> +To build:
> +
> +    ./configure --enable-efi
> +    make standalone
> +    (send tests/some-test somewhere)
> +    (go to somewhere)
> +    EFI_UEFI=/path/to/OVMF.fd ./some-test

This makes me wonder if the scripts should try to locate OVMF.fd, same as they
do for QEMU.  It's odd that specifying QEMU is optional, but for EFI_UEFI it's
mandatory.
