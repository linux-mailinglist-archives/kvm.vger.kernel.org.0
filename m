Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 368A7377C76
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 08:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbhEJGl7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 02:41:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36440 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229608AbhEJGl6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 02:41:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620628854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AhkvvC0oMUJmsEQCW6Q1nd0/KwtGO4qGTTgVWNfA7vM=;
        b=Igt4ggngxHsZbauKxw5vh7cAinzcxm62D2vZwqr0uoIV54LBWzrgjWXnP9rv6NudvYw7rA
        rfLi1+waPi4eMP3iUPXcjbgW+cBKYBHFTW+98aJpMNRSkaZ/zcYFJOPBoZCRIyKDjHP1w3
        u0fPJw0W9wbR/3vHxAbhIWULqT2o2Yo=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-zApqHrbcOoaGdNKUTcyOLg-1; Mon, 10 May 2021 02:40:52 -0400
X-MC-Unique: zApqHrbcOoaGdNKUTcyOLg-1
Received: by mail-ed1-f71.google.com with SMTP id i17-20020a50fc110000b0290387c230e257so8533462edr.0
        for <kvm@vger.kernel.org>; Sun, 09 May 2021 23:40:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AhkvvC0oMUJmsEQCW6Q1nd0/KwtGO4qGTTgVWNfA7vM=;
        b=GhxPpYYYFxw0m12q9FE34dnvLd4r/CzXs3e89sBHxbMpGJbur2AyJOxKzYa1zFuYyD
         qadvYksrZeCO0SaMwzjw0Sw3v9B6xjCHBeFgDdUGg1XSynKugNLNrGKGI1q6OJsCkmSV
         2hhC2s0i2wxkKny4UEJDRpBbES2HHHRAoiEHEZdRus+zIXkeZr4YcXSsFuV3z8nKRalm
         ROGjatiwiJoJN7HBdxRt7IELZroIAqyIJTfqdeIHlki7mk5Pf7foDLgy7gu81WPLTkvd
         Jizm1+6tNbcaw7eaKSf2TsU9OhKnOk8nppQCrIZDyWH9QVbBD5/vVpwSAlG7BCs7LpBm
         8sbQ==
X-Gm-Message-State: AOAM5301Q/sEjLVgq348H4hXOlhENsa9txQKD2QmOF+9SrwXw8Z1aLSm
        p8UnLDUyP2E0tggLqAZXDb0Ux21BZ8y88SOUFLGIXuLLDetT2Kea4S9SAhfrTO0LFlIeYzi3juV
        0mNCrQEOYzVIypfwFRcfgBe+IrAvJmq9B+WQs+CkCRskKOiRPrGs/VcMXVW/Bo68=
X-Received: by 2002:a05:6402:3585:: with SMTP id y5mr27515700edc.233.1620628851360;
        Sun, 09 May 2021 23:40:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy79W7vGg+HWZl+58lL8SGrEdJrYPWGAcRD5CxRhKSms3qnClb4ZaME1e4VxVzhNQ90K2UDtw==
X-Received: by 2002:a05:6402:3585:: with SMTP id y5mr27515677edc.233.1620628851164;
        Sun, 09 May 2021 23:40:51 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id g11sm2970883edt.85.2021.05.09.23.40.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 23:40:50 -0700 (PDT)
Date:   Mon, 10 May 2021 08:40:48 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, ricarkol@google.com, eric.auger@redhat.com,
        alexandru.elisei@arm.com, pbonzini@redhat.com
Subject: Re: [PATCH 4/6] KVM: arm64: selftests: get-reg-list: Provide config
 selection option
Message-ID: <20210510064048.m7ezciiratbesqjj@gator>
References: <20210507200416.198055-1-drjones@redhat.com>
 <20210507200416.198055-5-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210507200416.198055-5-drjones@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 07, 2021 at 10:04:14PM +0200, Andrew Jones wrote:
> Add a new command line option that allows the user to select a specific
> configuration, e.g. --config:sve will give the sve config. Also provide
> help text and the --help/-h options.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  .../selftests/kvm/aarch64/get-reg-list.c      | 76 +++++++++++++++++--
>  1 file changed, 70 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> index 68d3be86d490..f5e122b6b257 100644
> --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> @@ -38,6 +38,17 @@
>  #define reg_list_sve() (false)
>  #endif
>  
> +enum {
> +	VREGS,
> +	SVE,
> +};
> +
> +static char * const vcpu_config_names[] = {
> +	[VREGS] = "vregs",
> +	[SVE] = "sve",
> +	NULL
> +};
> +
>  static struct kvm_reg_list *reg_list;
>  static __u64 *blessed_reg, blessed_n;
>  
> @@ -502,34 +513,87 @@ static void run_test(struct vcpu_config *c)
>  	kvm_vm_free(vm);
>  }
>  
> +static void help(void)
> +{
> +	char * const *n;
> +
> +	printf(
> +	"\n"
> +	"usage: get-reg-list [--config:<selection>[,<selection>...]] [--list] [--list-filtered] [--core-reg-fixup]\n\n"
> +	" --config:<selection>[,<selection>...] Used to select a specific vcpu configuration for the test/listing\n"

I just realized I left this <selection>[,<selection>...] help text and
some other kruft, like the vcpu_config_names[] array, from a different
design I scrapped. That design, which used getsubopt(), was more
complicated than it was worth.

I'll send a v2 to get this cleaned up, but I'll wait a day or so first
for more comments.

Thanks,
drew

