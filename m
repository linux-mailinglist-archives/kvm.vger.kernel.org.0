Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 809FD4807E1
	for <lists+kvm@lfdr.de>; Tue, 28 Dec 2021 10:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235974AbhL1JhT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Dec 2021 04:37:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:43198 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229617AbhL1JhT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Dec 2021 04:37:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640684238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AYLIplJ3WjgSI8SbwSsxJ350FVB/5lVENewKIQD7sgA=;
        b=JWyl0V/XB/uLN3wX2HNw+nC64SmZPDVhM2jJF8zcN9q5JqVlu03WS8PEhMXSK3RENz37E3
        QTKEYT9M81G2qU7dpl5CKQBc1//b7L327C+Q45QDD3xRurbg+6vE5iFWaxvg7eSsJgSxDi
        Itc/g6qEOthWNghBhBLzjHorsF0MkSk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-219-tTgQkVLJPG-AvCJhcxtKoA-1; Tue, 28 Dec 2021 04:37:17 -0500
X-MC-Unique: tTgQkVLJPG-AvCJhcxtKoA-1
Received: by mail-ed1-f70.google.com with SMTP id dm10-20020a05640222ca00b003f808b5aa18so12778810edb.4
        for <kvm@vger.kernel.org>; Tue, 28 Dec 2021 01:37:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AYLIplJ3WjgSI8SbwSsxJ350FVB/5lVENewKIQD7sgA=;
        b=WVCQia0UARrvon39NkZrBhQRCf8NS5Ap9CZt1lAt2YTsnXj4nXntX9WANI3sxaBF4n
         8Pqxe1xO6yebbLJa5fhAJRcQUWyb4QTvQpX2lagZWBmdbirb3V1d9XqKK79lgGxiA62e
         FwY9Lzp2ifLqLzhQH1pWoHJTgpd/WqaDcBmajh103MCIHmAczVElxNqseu0njVb6s46V
         /IyfimoUwWfWfSytRZnv05uw6hg4kbYncQzNT9pyX1tIyny0vdaSKkW0+ZB00vj3LcZi
         y8KvsS9JoSfQYQ5lPFU45hsoOKTBq5IO5wl2wCqn0Lj2o07SpeD4m98kqnG+AGVk31+5
         LUqg==
X-Gm-Message-State: AOAM530oH6F/DpSB3bEpnauUk8oug9zx55qwxSvxgKQYOwDqhOcjNrn1
        /Uoseakr+fLMTEk4ZNpJzv5aacco54HMtlNFjEbrUIf4emUP0d8MuOF61KVH94ZYOf8uE0xWkAW
        0s3xPGEf6Is4h
X-Received: by 2002:a17:907:9493:: with SMTP id dm19mr16506702ejc.161.1640684235976;
        Tue, 28 Dec 2021 01:37:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzn/IYvjgtKdfByEeqLamctbBePIR3Zp/W7Yd+MA4ywG47nuGYWfeA0m+aOzjm3+NNCTMN9og==
X-Received: by 2002:a17:907:9493:: with SMTP id dm19mr16506692ejc.161.1640684235840;
        Tue, 28 Dec 2021 01:37:15 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id qf22sm5908178ejc.85.2021.12.28.01.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 01:37:15 -0800 (PST)
Date:   Tue, 28 Dec 2021 10:37:13 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: Re: [PATCH v2 1/6] KVM: selftests: arm64: Initialise default guest
 mode at test startup time
Message-ID: <20211228093713.moolqqxijvtt5gj7@gator.home>
References: <20211227124809.1335409-1-maz@kernel.org>
 <20211227124809.1335409-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211227124809.1335409-2-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 27, 2021 at 12:48:04PM +0000, Marc Zyngier wrote:
> As we are going to add support for a variable default mode on arm64,
> let's make sure it is setup first by using a constructor that gets
> called before the actual test runs.
> 
> Suggested-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  tools/testing/selftests/kvm/lib/aarch64/processor.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index b4eeeafd2a70..b509341b8411 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -432,3 +432,12 @@ uint32_t guest_get_vcpuid(void)
>  {
>  	return read_sysreg(tpidr_el1);
>  }
> +
> +/*
> + * arm64 doesn't have a true default mode, so start by computing the
> + * available IPA space and page sizes early.
> + */
> +void __attribute__((constructor)) init_guest_modes(void)
> +{
> +       guest_modes_append_default();
> +}
> -- 
> 2.30.2
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

