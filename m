Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 508FD5A7E39
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 15:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbiHaNFZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 09:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiHaNFY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 09:05:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87695F227
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 06:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661951121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q5dV2zCvAlOv7vYN6r9UAWLrQOoq+lE+SlipLzsRwko=;
        b=FgP5H+w3QUWO/nA0itrUStl8Rtk1higH3z7iOKUHRP3ulDazAlxcdpd+gdMp4gnHrjeVdE
        fdF2PKlNLBnCriplTqwISjvlkLM3GT5R7NPro8ndXrOWrzrhcmdUa5OYKcvAwwwNByAK5G
        BO24jw4PxsxmXDWsH/WT2e0RTAOc4yg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-651-dEnlelG4MA2siBP7Pt6gtw-1; Wed, 31 Aug 2022 09:05:20 -0400
X-MC-Unique: dEnlelG4MA2siBP7Pt6gtw-1
Received: by mail-wm1-f70.google.com with SMTP id h133-20020a1c218b000000b003a5fa79008bso11683698wmh.5
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 06:05:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Q5dV2zCvAlOv7vYN6r9UAWLrQOoq+lE+SlipLzsRwko=;
        b=IgdENsEU98BMYnK+iSnjkfzfdk96GmPfu4k9DSmQByRwAAJhYtZFiSi8uV7MnAQzzD
         4Y1CvgvQlVDa+x8WdxYHozwfBtarBPoJE7QXP1UAWPWAq/PnPWm0YCTyy99CiWNbcduc
         PTvcWUXX4xUN1rGtYmc9j/Wm9VcEClH1de3z2/vN5oPISqDGwg39enzZPDmZflBUY+9Z
         ikcvnrEXaYRZ80gFMlk0LNlCHGi4I9k6FD46cZ7GhN5iTXPcbtna6LVf1B8XiuF7sGNG
         xEOi+NspXsL9EXYtYgwu8rIsrqISl79nKqHl+EKi0TqEUqRFNbARtHburPya9eB9HcyI
         67PA==
X-Gm-Message-State: ACgBeo1APVRO2weOzoaSXqnWR5ZaYGwXM+uDch9KEpa1ybf0Ji+fhxLx
        I1HVNjh5Wm+UGWmh8QdR9krLKQICnO3vCVdDwlUeKaqiPV10db841+cEPKTCa8f1nC9NERJYkkH
        RKQOCe3NFP+DE
X-Received: by 2002:a05:6000:788:b0:226:e9cd:9fb8 with SMTP id bu8-20020a056000078800b00226e9cd9fb8mr2215597wrb.127.1661951117552;
        Wed, 31 Aug 2022 06:05:17 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4zYvoJRfps/XtV7L2yjT5RVAdA8EQ3uD4h0op1VEqpf2Gu3DmVTuvX//SMyomQn3htXqVVXA==
X-Received: by 2002:a05:6000:788:b0:226:e9cd:9fb8 with SMTP id bu8-20020a056000078800b00226e9cd9fb8mr2215582wrb.127.1661951117360;
        Wed, 31 Aug 2022 06:05:17 -0700 (PDT)
Received: from redhat.com ([2.55.191.225])
        by smtp.gmail.com with ESMTPSA id o14-20020a05600c058e00b003a5ad7f6de2sm2172755wmd.15.2022.08.31.06.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 06:05:16 -0700 (PDT)
Date:   Wed, 31 Aug 2022 09:05:12 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Sergio Lopez <slp@redhat.com>
Subject: Re: [PATCH 1/2] [hack] reserve bit KVM_HINTS_HOST_PHYS_BITS
Message-ID: <20220831090215-mutt-send-email-mst@kernel.org>
References: <20220831125059.170032-1-kraxel@redhat.com>
 <20220831125059.170032-2-kraxel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831125059.170032-2-kraxel@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 31, 2022 at 02:50:58PM +0200, Gerd Hoffmann wrote:
> The KVM_HINTS_HOST_PHYS_BITS bit indicates that qemu has host-phys-bits
> turned on.  This implies the guest can actually work with the full
> available physical address space as advertised by CPUID(0x80000008).
> 
> Temporary hack for RfC patch and testing.  This change must actually be
> done in the linux kernel, then picked up by qemu via header file sync.
> 
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>  include/standard-headers/asm-x86/kvm_para.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/standard-headers/asm-x86/kvm_para.h b/include/standard-headers/asm-x86/kvm_para.h
> index f0235e58a1d3..105b958c0f56 100644
> --- a/include/standard-headers/asm-x86/kvm_para.h
> +++ b/include/standard-headers/asm-x86/kvm_para.h
> @@ -37,7 +37,8 @@
>  #define KVM_FEATURE_HC_MAP_GPA_RANGE	16
>  #define KVM_FEATURE_MIGRATION_CONTROL	17
>  
> -#define KVM_HINTS_REALTIME      0
> +#define KVM_HINTS_REALTIME              0
> +#define KVM_HINTS_HOST_PHYS_BITS        1
>  
>  /* The last 8 bits are used to indicate how to interpret the flags field
>   * in pvclock structure. If no bits are set, all flags are ignored.


Just a clarification.
I think what the bit means is that physical address size
data in cpuid is valid.
Accordingly I would rename it to

+#define KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID        1


or some such.


> -- 
> 2.37.2

