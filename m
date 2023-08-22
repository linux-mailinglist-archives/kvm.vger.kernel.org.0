Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0999783B7A
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 10:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233692AbjHVINf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 04:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233679AbjHVINe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 04:13:34 -0400
X-Greylist: delayed 352 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Aug 2023 01:13:32 PDT
Received: from out-29.mta1.migadu.com (out-29.mta1.migadu.com [IPv6:2001:41d0:203:375::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A46193
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 01:13:32 -0700 (PDT)
Date:   Tue, 22 Aug 2023 10:07:34 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1692691656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+SA2ZE4Ws386QTZn7EKz9TL8CME5anz6G1wou/4cNSI=;
        b=Y1z3hxe2ipOiXukZZwecS+Pcm6E6e/fd4cM7Q9pdrOdOCBkcqcNvzUEtWF7war1feoVp96
        uUznCdiDrLp+8kbHZarNRweQHnkR1VO+Y/MrodagvNwhcST4e6KyfXTYzn/rsD1HUtgKFg
        3Vh2F4uTNfVmXdqBX0xjI3djgRnCPt0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] Makefile: Move -no-pie from CFLAGS into
 LDFLAGS
Message-ID: <20230822-9d8220313ad17bce9ddc55ef@orel>
References: <20230822074906.7205-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230822074906.7205-1-thuth@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 22, 2023 at 09:49:06AM +0200, Thomas Huth wrote:
> "-no-pie" is an option for linking, not for compiling, so we must put
> this into the lDFLAGS, not into CFLAGS. Without this change, the linking
                ^ L

> currently fails on Ubuntu 22.04 when compiling on a s390x host.
> 
> Reported-by: Janosch Frank <frankja@linux.ibm.com>
> Fixes: e489c25e ("Rework the common LDFLAGS to become more useful again")
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  Makefile | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 8809a8b6..e7998a40 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -80,7 +80,7 @@ COMMON_CFLAGS += $(if $(U32_LONG_FMT),-D__U32_LONG_FMT__,)
>  ifeq ($(CONFIG_EFI),y)
>  COMMON_CFLAGS += $(EFI_CFLAGS)
>  else
> -COMMON_CFLAGS += $(fno_pic) $(no_pie)
> +COMMON_CFLAGS += $(fno_pic)
>  endif
>  COMMON_CFLAGS += $(wclobbered)
>  COMMON_CFLAGS += $(wunused_but_set_parameter)
> @@ -92,7 +92,7 @@ CFLAGS += -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
>  
>  autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d
>  
> -LDFLAGS += -nostdlib -z noexecstack
> +LDFLAGS += -nostdlib $(no_pie) -z noexecstack
>  
>  $(libcflat): $(cflatobjs)
>  	$(AR) rcs $@ $^
> -- 
> 2.39.3
> 

Otherwise,

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

Thanks,
drew
