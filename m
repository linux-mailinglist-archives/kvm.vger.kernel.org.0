Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F26EE5332C5
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 23:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241833AbiEXVAt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 17:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238452AbiEXVAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 17:00:47 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3344443F8
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 14:00:46 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id z11so8079476pjc.3
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 14:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rMLYZe5seQUfoZme6gT+f7ho5aBgGSwYKaK8wl4oIOI=;
        b=Jdq0OntSmdnICnvNK2eFTZxT61bSqvUXQKXNf9sJcTRf6WWrBI+p4+ISllQFwJOYiq
         mGYoUFqlXDn6F1g3U+eGkdn550HQp8EJEboxtOxs2Ln9QjKkD8HEyKMYpVKCj+9tATmj
         IKsIL/6t+sfWkYUM2dBTcj/oA4hFiZpdvq/KfscvVifP5AjUm6zpXX5uqgWZ0yLr3Pt9
         dejr/Cf8Y4DD457wcFdMbI1WD+bI2+st8wBumCl8GDAOUjYpf5kT7ehM72/4x375R6sL
         p2y+G4mwQuYEgZ3Yq7ypvdDOlh0DAS6XiW8U2JuDPPWtfHaW05JO35mUXAK+wdBsShux
         C8VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rMLYZe5seQUfoZme6gT+f7ho5aBgGSwYKaK8wl4oIOI=;
        b=EbTcovqV34hBVK901oVqIA2HkLwonNZkg2Mbs7r5FL1FIa+CkuKkU/V6wBtYWriipb
         Qr2cJtjf5DTU7Ddk6/LD9XiLrpVJzut4xLUYwkjS0HJBVwax0eLzxoYxE+dqq15p7nb0
         Q4icGmU0dBJQuHt+W4ZdD8giDLn6cXv0A7wLFadVTJsDoMUUXZrSNe/d8pRnlHr297Tr
         bmzep3PbPxzkNXro4RzvzkliRY2SqUyR8arSGU++7uLVtFvKzsBc3OaVqMWbOfH7+f7Z
         bqD9FQCzS2f9ThiBok28jgyucjVtHKRJglZqTzx5fW13ObipmzwWRwP0AF/+ovRJOYlW
         LB+A==
X-Gm-Message-State: AOAM530k4QOEfysTNHraFD4O03NHTHDNhfjYuK+BVuwLe8QJvz/E/dk4
        gg96eIRcyHoMth/mFmKWVB/dGw==
X-Google-Smtp-Source: ABdhPJw9/Di5LxyocJDf+ROoCJVnY2Q1BO5rz35C4l3MU+cXIMynyJ7S3gX5d5JrduYr/4f5CGNuvg==
X-Received: by 2002:a17:902:b703:b0:158:2667:7447 with SMTP id d3-20020a170902b70300b0015826677447mr28871066pls.92.1653426046115;
        Tue, 24 May 2022 14:00:46 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id r18-20020a170903411200b001619b47ae61sm7565011pld.245.2022.05.24.14.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 14:00:45 -0700 (PDT)
Date:   Tue, 24 May 2022 21:00:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lei Wang <lei4.wang@intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, chenyi.qiang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 2/8] KVM: VMX: Add proper cache tracking for PKRS
Message-ID: <Yo1Hemue8+l5CPIT@google.com>
References: <20220424101557.134102-1-lei4.wang@intel.com>
 <20220424101557.134102-3-lei4.wang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220424101557.134102-3-lei4.wang@intel.com>
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

On Sun, Apr 24, 2022, Lei Wang wrote:
> From: Chenyi Qiang <chenyi.qiang@intel.com>
> 
> Add PKRS caching into the standard register caching mechanism in order
> to take advantage of the availability checks provided by regs_avail.
> 
> This is because vcpu->arch.pkrs will be rarely acceesed by KVM, only in
> the case of host userspace MSR reads and GVA->GPA translation in
> following patches. It is unnecessary to keep it up-to-date at all times.
> 
> It also should be noted that the potential benefits of this caching are
> tenuous because the MSR read is not a hot path. it's nice-to-have so that
> we don't hesitate to rip it out in the future if there's a strong reason
> to drop the caching.


The patch looks fine, but this needs to be moved to the end of the series.
Definitely after "KVM: VMX: Expose PKS to guest", and maybe even after "KVM: VMX:
Enable PKS for nested VM".

If there's a bug with the caching logic, I want to be able to bisect to that.  By
implementing caching before any of the other PKS support, a bug in either the
caching or the virtualization will bisect to the PKS virtualization
