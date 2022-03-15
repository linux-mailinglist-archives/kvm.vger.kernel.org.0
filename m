Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 794834DA0F6
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 18:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350486AbiCORPh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 13:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241638AbiCORPd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 13:15:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 45ACF1FCE9
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 10:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647364459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u807ZeNN2qGEsYuS4UPVVqtbsA7t3x+ouYSiSBveyD0=;
        b=FBzoMxqGCTBRgb5zXh2gltNXb2FCY17s019ekhuQMv0tEDHDEuQUZqhq7ef0JN4XcfnrxN
        5GXpY02k3AoCD4r/wpzsXulxH3h2Ol0pCd4BQubn/PIXf7XeNzHHJIWxMlkommlL+6qqtf
        jdgrmcHkI0qvy8+VkCu7ynLCVqN+G9M=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-12-1kEhjS2uOWibhhwFvQACJQ-1; Tue, 15 Mar 2022 13:14:16 -0400
X-MC-Unique: 1kEhjS2uOWibhhwFvQACJQ-1
Received: by mail-wm1-f70.google.com with SMTP id o33-20020a05600c512100b0038a1d06e525so1495226wms.2
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 10:14:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u807ZeNN2qGEsYuS4UPVVqtbsA7t3x+ouYSiSBveyD0=;
        b=1Id2gmQ8cGxIMGvnbqkbpk+RnVpCsd3hxY9gPNXC6D3CvC2Ww2mWJPcUDxvo2qABRO
         Mu+3HgAA735WLADvj0Qcxd2edCCUwvpQV9HFYwqBIH3xrvEpgkmhprx/2gzXTW6hD50G
         kVzApyxI+ByGNshXTlsl6iDf+dtkmI86qxWy9kbrNeS4j4lfqLXyhfB3GG2HnDFSrNDw
         wskp0SMjTHb4JM/gNrVsr7/sDWTYn6ZsMQLkYOQTfRcoeHmgpcayYMxAgoQ5iwdSnjvK
         hvaNcBLY/88+QhPXWdteMFVFAA0VoARhJ/yh+ywRLbSKZ8Y4p2a5ZlgoU+TCgfqdqg5H
         x4Ew==
X-Gm-Message-State: AOAM532fR1kcljjrvXX3I2+ohbhpCNQhY8MMblghO1HrRCLZWErr34E8
        TmRUBNFoaoi6rlV3Zc0IUoJkqGOti0PA48oh3CoHfFTpcThlH8GAKJPNophah7NRGWbqZ8H5t0c
        GTyhgBV4ALLMs
X-Received: by 2002:a5d:5512:0:b0:1ef:5f08:29fb with SMTP id b18-20020a5d5512000000b001ef5f0829fbmr21204931wrv.653.1647364455649;
        Tue, 15 Mar 2022 10:14:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzYqL5fPHSADziBs+XqlZkT9FX7MI9CEk0Zn3ysRNe2yyWlIwJCNPYYOU/70wMG7mwc8FemXw==
X-Received: by 2002:a5d:5512:0:b0:1ef:5f08:29fb with SMTP id b18-20020a5d5512000000b001ef5f0829fbmr21204918wrv.653.1647364455472;
        Tue, 15 Mar 2022 10:14:15 -0700 (PDT)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id u11-20020a05600c19cb00b00389efe9c512sm3184824wmq.23.2022.03.15.10.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 10:14:14 -0700 (PDT)
Date:   Tue, 15 Mar 2022 18:14:12 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        thuth@redhat.com, pbonzini@redhat.com
Subject: Re: [PATCH kvm-unit-tests] arch-run: Introduce QEMU_ARCH
Message-ID: <20220315171412.5esfm4ygjjq2bbjh@gator>
References: <20220315080152.224606-1-drjones@redhat.com>
 <YjCHcV3iyTtSrw3k@monolith.localdoman>
 <20220315151630.obxraie6ikqrwtrw@gator>
 <YjC62NycFfevZ4wx@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjC62NycFfevZ4wx@monolith.localdoman>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 15, 2022 at 04:31:34PM +0000, Alexandru Elisei wrote:
> Well, kvm-unit-tests selects KVM or TCG under the hood without the user
> being involved at all.

The under the hood aspect isn't great. It's best for testers to know what
they're testing. It's pretty obvious, though, that if you choose
ARCH != HOST that you'll end up on TCG. And, since KVM has historically
been the primary focus of kvm-unit-tests, then it's probably reasonable
to assume KVM is used when ARCH == HOST. However, we still silently fall
back to TCG, even when ARCH == HOST, if /dev/kvm isn't available! And,
the whole AArch32 guest support on AArch64 hosts with KVM requiring a
different qemu binary muddies things further...

Anyway, I hope serious test runners always specify ACCEL and QEMU to
whatever they plan to test.

> In my opinion, it's slightly better from an
> usability perspective for kvm-unit-tests to do its best to run the tests
> based on what the user specifically set (QEMU=qemu-system-arm) than fail to
> run the tests because of an internal heuristic of which the user might be
> entirely ignorant (if arm64 and /dev/kvm is available, pick ACCEL=kvm).

If you'd like to post a patch for it, then I'd prefer something like
below, which spells out the condition that the override is applied
and also allows $QEMU to be checked by search_qemu_binary() before
using it to make decisions.

Thanks,
drew

diff --git a/arm/run b/arm/run
index 28a0b4ad2729..128489125dcb 100755
--- a/arm/run
+++ b/arm/run
@@ -10,16 +10,24 @@ if [ -z "$KUT_STANDALONE" ]; then
 fi
 processor="$PROCESSOR"
 
-ACCEL=$(get_qemu_accelerator) ||
+accel=$(get_qemu_accelerator) ||
        exit $?
 
-if [ "$ACCEL" = "kvm" ]; then
+if [ "$accel" = "kvm" ]; then
        QEMU_ARCH=$HOST
 fi
 
 qemu=$(search_qemu_binary) ||
        exit $?
 
+if [ "$QEMU" ] && [ -z "$ACCEL" ] &&
+   [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ] &&
+   [ "$(basename $QEMU)" = "qemu-system-arm" ]; then
+       accel=tcg
+fi
+
+ACCEL=$accel
+
 if ! $qemu -machine '?' 2>&1 | grep 'ARM Virtual Machine' > /dev/null; then
        echo "$qemu doesn't support mach-virt ('-machine virt'). Exiting."
        exit 2

