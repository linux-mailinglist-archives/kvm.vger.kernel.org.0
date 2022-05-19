Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F30252CAAB
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 06:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233467AbiESEG2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 00:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbiESEG0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 00:06:26 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FFF9C2DA
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 21:06:25 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id t2so2849319ilm.13
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 21:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HhVEShRLiA+12WawJvWgAJ+fjJb0wYw/1qh/Y9aGX+I=;
        b=ogz7DNKJecGaILna/pIfBmTkCUQ0IDjLM2lIY6bVnXStms7HvXaWhPNFVZQpJOuME7
         hiG4Cb1R6gAcg/a3LGJ965Y8bLxqp0aoRviXvUlJxaCsebI9UP2TCTu8kHf4bleXAp81
         e99Kto6D6axTTBBJyJaqH2EjkDI1+V+V88XAoqwFlcD64vlvpKvYTfUYO8GRzy009Yq3
         21ndy5uCKoq8ktMtl8mH5vq/rHB8TKMKS85J48+H6vBh2lPwYKzNlb9Q5tP6i03/1c7K
         waeMCDk0aGZav8FsSXwMaSQTo/3ruW7wsqQNPXt3esPBlFxxP5RdPjU4i3LLlag85HnM
         JN0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HhVEShRLiA+12WawJvWgAJ+fjJb0wYw/1qh/Y9aGX+I=;
        b=nZjkBQyw9wbEEa18ZdQw8ExTYLxH3BDoHBZkU8dqXm48q9taqbsbopsMAFby3Dkm87
         TZN9mUak6TAaYZZJLNInym/yW13ZH8fNacO5O02yVD9tXRpY98ja+T4nHb+KfyVnJMwq
         NvCernJO/dtywmBcPUPGE3a7tZE4FB8JkNqVD7ITvN+qcwdymSILnEuNegYliYLdL0xj
         a8b2XdLyxLuzGyzvcGK3oO/YGlqA9L+ZQ3DhktxrFFmM/OzQarMIV/xuorc8wHRustfW
         U+WVXiBclD6NwbalLcchl/ZsvFhAVWcy08puJ7GbHquclGsbIewdm4CFU6ZyaepIDBq3
         OcQA==
X-Gm-Message-State: AOAM531oAnjdo+Jo1lG7F5PKW2LeA1o3yzV5lYIb6L0AcsJIb/enfw+e
        MnX+yHgHYTtcZHZAZSpmBRiJxQ==
X-Google-Smtp-Source: ABdhPJyDNKNdKdzRYimEVo3cF1jsSGbss7PpQ0XEbUzPSBGtA2IzoggWnfSxssA4jHP2jFRJSxKILQ==
X-Received: by 2002:a92:c985:0:b0:2d1:2e3b:bfc7 with SMTP id y5-20020a92c985000000b002d12e3bbfc7mr1569358iln.186.1652933184615;
        Wed, 18 May 2022 21:06:24 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id f13-20020a02a80d000000b0032e868301casm192326jaj.45.2022.05.18.21.06.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 21:06:23 -0700 (PDT)
Date:   Thu, 19 May 2022 04:06:19 +0000
From:   Oliver Upton <oupton@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, axelrasmussen@google.com
Subject: Re: [PATCH v3 05/13] KVM: selftests: Add missing close and munmap in
 __vm_mem_region_delete
Message-ID: <YoXCOxjjfu4WUuEC@google.com>
References: <20220408004120.1969099-1-ricarkol@google.com>
 <20220408004120.1969099-6-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408004120.1969099-6-ricarkol@google.com>
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

On Thu, Apr 07, 2022 at 05:41:12PM -0700, Ricardo Koller wrote:
> Deleting a memslot (when freeing a VM) is not closing the backing fd,
> nor it's unmapping the alias mapping. Fix by adding the missing close
> and munmap.
> 
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>

Reviewed-by: Oliver Upton <oupton@google.com>
