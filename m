Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF244D35AC
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 18:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237314AbiCIRJx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 12:09:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237608AbiCIRIi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 12:08:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B7A2C0854
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 08:58:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646845100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SAUeJG8UY6RhUcIGm8viMKGF/F+Mz8ELefSwyfTVQTI=;
        b=dpCUdjg3+Q4yz4bbRXsZLlFaFOlzklO2Cg4ZJJps1VC7YZb3hu641+BJd9Uf/tt6dF4EwF
        LZ403oPO7tii9NdLgyXKT8jBse1/pm7IxJR8BU+ejegeVny33Sq/PYtiMqJnUtuxKvtsVJ
        6/r4jcUxId1NhA3JmVorJrnvL1JoYHs=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-yFm4yLw3NSaZuXxbCSumUA-1; Wed, 09 Mar 2022 11:58:17 -0500
X-MC-Unique: yFm4yLw3NSaZuXxbCSumUA-1
Received: by mail-ej1-f69.google.com with SMTP id ey18-20020a1709070b9200b006da9614af58so1622033ejc.10
        for <kvm@vger.kernel.org>; Wed, 09 Mar 2022 08:58:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SAUeJG8UY6RhUcIGm8viMKGF/F+Mz8ELefSwyfTVQTI=;
        b=fW3k3NyaEAATpfT9vK1r6KYDT0ROao4rlT5G0qBIBMGCnmVY6J0GDMCg35mrjfipWd
         BlL+PBtkzTxY88qkjJR7+5jwdadtsmID8yv94EmRaZqKQJ477of/s/JBUTq3+BRUmHbb
         pE6OVvGn1VuwKFAvXQ3wJ+aI3RrKuzic7JYSLoBTCoStHEnOGcbkaAks7oOhC7+j/apT
         2A+MLSMXn6W4lUSWLrEugGK5Iki+Zi3ODbbzsKRcduUX2UCs2x1AYJWDlZBBpTxgvatn
         u3ToTX/vfPcMZo/gn2du46EYDHJzpAcw7bnZG1MJTcX0eW/wNJp6Ilez1KYroHXTaSHG
         Jimg==
X-Gm-Message-State: AOAM532Y10IlUwyroXP6qQmKvT1ZeG2q07mKq2wK44zYCMMvvBomXFC6
        jt4uQuMfS5yRulatHZLuwt+7ECMCpj9AzUfuzKSbVTHRToUVQFohyDR2zuvvhIoZR7WnvNlYHt2
        FvIDVGnTMvcpA
X-Received: by 2002:a17:907:c1c:b0:6db:62b7:8357 with SMTP id ga28-20020a1709070c1c00b006db62b78357mr637255ejc.536.1646845096315;
        Wed, 09 Mar 2022 08:58:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzLGi3RtaPnymESOcjh/lKXdPE2+WXXCEbhupK9tOpWsDHLVS5te2YjIiSdqV+8bbb7Q0NcVg==
X-Received: by 2002:a17:907:c1c:b0:6db:62b7:8357 with SMTP id ga28-20020a1709070c1c00b006db62b78357mr637236ejc.536.1646845096102;
        Wed, 09 Mar 2022 08:58:16 -0800 (PST)
Received: from gator (cst-prg-78-140.cust.vodafone.cz. [46.135.78.140])
        by smtp.gmail.com with ESMTPSA id v2-20020a509d02000000b00412d53177a6sm1071505ede.20.2022.03.09.08.58.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 08:58:15 -0800 (PST)
Date:   Wed, 9 Mar 2022 17:58:12 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH 2/2] arm/run: Fix using
 qemu-system-aarch64 to run aarch32 tests on aarch64
Message-ID: <20220309165812.46xmnjek72yrv3g6@gator>
References: <20220309162117.56681-1-alexandru.elisei@arm.com>
 <20220309162117.56681-3-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220309162117.56681-3-alexandru.elisei@arm.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 09, 2022 at 04:21:17PM +0000, Alexandru Elisei wrote:
> From: Andrew Jones <drjones@redhat.com>
> 
> KVM on arm64 can create 32 bit and 64 bit VMs. kvm-unit-tests tries to
> take advantage of this by setting the aarch64=off -cpu option. However,
> get_qemu_accelerator() isn't aware that KVM on arm64 can run both types
> of VMs and it selects qemu-system-arm instead of qemu-system-aarch64.
> This leads to an error in premature_failure() and the test is marked as
> skipped:
> 
> $ ./run_tests.sh selftest-setup
> SKIP selftest-setup (qemu-system-arm: -accel kvm: invalid accelerator kvm)
> 
> Fix this by setting QEMU to the correct qemu binary before calling
> get_qemu_accelerator().
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> [ Alex E: Added commit message, changed the logic to make it clearer ]
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/run | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arm/run b/arm/run
> index 2153bd320751..5fe0a45c4820 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -13,6 +13,11 @@ processor="$PROCESSOR"
>  ACCEL=$(get_qemu_accelerator) ||
>  	exit $?
>  
> +# KVM for arm64 can create a VM in either aarch32 or aarch64 modes.
> +if [ "$ACCEL" = kvm ] && [ -z "$QEMU" ] && [ "$HOST" = "aarch64" ]; then
> +	QEMU=qemu-system-aarch64
> +fi
> +
>  qemu=$(search_qemu_binary) ||
>  	exit $?
>  
> -- 
> 2.35.1
>

So there's a bug with this patch which was also present in the patch I
proposed. By setting $QEMU before we call search_qemu_binary() we may
force a "A QEMU binary was not found." failure even though a perfectly
good 'qemu-kvm' binary is present.

I'll try to come up with something better.

Thanks,
drew

