Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C16904F8AAE
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 02:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232449AbiDGXPe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 19:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiDGXPb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 19:15:31 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9850132E96
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 16:13:29 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id e13so5340669ils.8
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 16:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=L4fHai+CVJ704RAyIzXx7UBiXAfW8hOkOCH96r8LwIE=;
        b=fj/pPVxMRNWzY1oImmsyI339onLzicgyJFmCpwHy0HDMrzBcANRgIYbkayFwqtavSx
         NX/G797eXnSjJkTsgTx2VT2rD8h0aRn5krf380dfEEEbhVC01s59b2kz7TlfVpZQ7Ul8
         y0Jns+JGphnP7Kyn8AZvIoehQ49owGizSUebyLqF8zIt7fv8EEYfG+yHwbkA0jDTd7gz
         yJhH/tJ+TpFKuzR4a2y16RcpU8ehKwTTGkRUO0l5i1nSVpLK9bWbjfvr7Ig3BdJwD90h
         G/8p4obbTu6ohpX3XQ7+LdI2flSGVqPjjdpXfcu9k/+kwnwdq+GpS7xPTy0eHVBpv3uD
         b3IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L4fHai+CVJ704RAyIzXx7UBiXAfW8hOkOCH96r8LwIE=;
        b=ylx0joQIVnhTlCtFK7GKeP8OVywpr8BzRxgFfhhkBVF2lm6Z3JpM86Ky0v+GUPzf5q
         mouj94AKmd4aLnu4e4e8INFxREIQ4G+xIwk2sBPsBuL+QwMTBPSo9z0Bk1xjRxifBqvd
         QUK/DdMbFztyVc4e+7EAYcV5+C5+StCsJz9V2GDLVe8SvP15e/xkQORDVDuCK2NYqmar
         f6KETTlLah+CdC4kKuGfbpaT2C6eN04hl+dImOSIaoC3RFOxb04XmLYq13jIFWxTvzNz
         O+Jxjbl4mlp5lSXh7iZX2bAPC2zP+ZuZxdTsPbqyi3muIKAXUN4kDieksfNyKFsn+4uv
         LX4w==
X-Gm-Message-State: AOAM530urAj1gonxD4xyJbFtKWgNp5BTjpv+JRAFdMnyGZhRtq6r47YO
        Iw7omP8t9eYBOw0Pb/I1pYzK3Q==
X-Google-Smtp-Source: ABdhPJyuIZVicGu9eRU49wNxNY7a+lyPuJiNe708yC/RuIlyD08rKZEC6MV9WSnZKPgvVIo/O005Uw==
X-Received: by 2002:a05:6e02:b42:b0:2c8:1fb1:7992 with SMTP id f2-20020a056e020b4200b002c81fb17992mr7439894ilu.9.1649373208819;
        Thu, 07 Apr 2022 16:13:28 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id m4-20020a0566022e8400b006463059bf2fsm13739427iow.49.2022.04.07.16.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 16:13:28 -0700 (PDT)
Date:   Thu, 7 Apr 2022 23:13:24 +0000
From:   Oliver Upton <oupton@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH v2 3/4] KVM: arm64: vgic-v3: Implement MMIO-based LPI
 invalidation
Message-ID: <Yk9wFMICRqF6ROti@google.com>
References: <20220405182327.205520-1-maz@kernel.org>
 <20220405182327.205520-4-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405182327.205520-4-maz@kernel.org>
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

On Tue, Apr 05, 2022 at 07:23:26PM +0100, Marc Zyngier wrote:
> Since GICv4.1, it has become legal for an implementation to advertise
> GICR_{INVLPIR,INVALLR,SYNCR} while having an ITS, allowing for a more
> efficient invalidation scheme (no guest command queue contention when
> multiple CPUs are generating invalidations).
> 
> Provide the invalidation registers as a primitive to their ITS
> counterpart. Note that we don't advertise them to the guest yet
> (the architecture allows an implementation to do this).
> 

I'll admit that this part tripped me up a bit, odd stuff.

> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oupton@google.com>
