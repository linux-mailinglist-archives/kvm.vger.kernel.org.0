Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D94E56AEB6
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 00:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236565AbiGGWrJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 18:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbiGGWrI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 18:47:08 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C57EC5073C
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 15:47:06 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id b9so5995976pfp.10
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 15:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=k+m9xndrEVogn4UNNIC2n16CcYTa0z3ZXhM1HLDkBjM=;
        b=TydelTAwAa4eGTpazSqNuIiD7itOzqcNBA+U88a230OX9KGADCgmA4zPjqlydWgPU8
         Eqqh5cvCKl+XqdCEfl4R7z2mtJjy3jHOCh0VS9H610rlMdRluVNzGmsz0aHR4w6dUrbD
         gsn08raGW6vup7/kAENTSDseBQZnp0iZqE26t3j6Ln6H+vnfW/f61TZ6/voLJxZETDox
         4N780WO0xF9pUZAQ3qhYcLRGRWOBayJHjtv8wnVmlCuLMGaf4YKYUWk9aM9lDDp7ZsgB
         dx+4sLMS0SisSFldoVAzwylKOQVDqa26r4uEDRHdfAv8CPMnOH0HU1MFtOk8LitCwPcI
         q9jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k+m9xndrEVogn4UNNIC2n16CcYTa0z3ZXhM1HLDkBjM=;
        b=WuIv56cN5WOYNuttKX9nfljgXlfn0E8QD+JwtrmSogQS8zEMZlLOLPxUqIRaCrVGw9
         IUYcqrPOUB8dhHydaMaqCsw09SHmhLv1stFXxyhxc70oUx3u+03brp52gxKIA4u+Rold
         CzK+fRDYh+uq68YMXclKzK9oseW6VjYBluRSKz8ROuMhMrDWs270uG4tx5D+XEeIU2Jk
         gT5weCYnrqY5HjCFpVpiTjKTqjr/kcUtl4nchkYGpn3IJ6gpg98MREp5CIZlUo+JbfQd
         wDJ4hkHKTxYhh9FTBvlr7UMutBjyfBV0yUTdt1jsirAovvhrWBfrn1abwdGuHPxFnW7F
         6d6w==
X-Gm-Message-State: AJIora9yLNp15L+meec/BofD7DAENZIuZRBtE6mqAO3g0fbkJ+C8yCus
        k0NP+J4/BXsE2CrDrjd1vU2WtV6QjK0ZzA==
X-Google-Smtp-Source: AGRyM1tCjKHzVatwgeDBwjMuyukTx03peOGiilV2bNfDEtYojbP0OJirTDnFBtcgnOsduVbet0w7zg==
X-Received: by 2002:a63:5346:0:b0:412:9544:1ff2 with SMTP id t6-20020a635346000000b0041295441ff2mr360152pgl.504.1657234026238;
        Thu, 07 Jul 2022 15:47:06 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id x9-20020a056a00188900b0050dc762818csm27687814pfh.102.2022.07.07.15.47.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 15:47:05 -0700 (PDT)
Date:   Thu, 7 Jul 2022 22:47:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH v3] KVM: VMX: Avoid a JMP over the RSB-stuffing sequence
Message-ID: <YsdiZTwutNAKXRyI@google.com>
References: <20220707212049.3833395-1-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707212049.3833395-1-jmattson@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 07, 2022, Jim Mattson wrote:
> RSB-stuffing after VM-exit is only needed for legacy CPUs without
> eIBRS. Instead of jumping over the RSB-stuffing sequence on modern
> CPUs, just return immediately.
> 
> Note that CPUs that are subject to SpectreRSB attacks need
> RSB-stuffing on VM-exit whether or not RETPOLINE is in use as a
> SpectreBTB mitigation. However, I am leaving the existing mitigation
> strategy alone.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
