Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2285C4F0699
	for <lists+kvm@lfdr.de>; Sun,  3 Apr 2022 00:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbiDBWlg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Apr 2022 18:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiDBWle (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 Apr 2022 18:41:34 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB6212ADF
        for <kvm@vger.kernel.org>; Sat,  2 Apr 2022 15:39:40 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id y16so4362270ilq.6
        for <kvm@vger.kernel.org>; Sat, 02 Apr 2022 15:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qLNzO18ajat1m0fs1W8NtMq/BQbLXFrYLsmtTPYjHJ8=;
        b=fcII4z0VLNKpeNeV5LH4dIsf92I/nz7pTv6mXarO0z2A11z7ck/GMqJi+mc9XrUnxE
         7ky3roY//u2Cwlvh1KM0wmujjr5BS+CZNvL3i0q0IUGBgQlGPDqkUlsdz9Qv1m66ZKzd
         HUOzOXtq18Kbx0+9BgZG3O3uS/BXrP9TCj3i5us0XTuANYrokrPw2idLLomuPfpJv8MV
         MqesIUQFeoKbaIKGe8DYFJGZ3X9qr7HNrbkmzuUn75LQH0PREvjnh8TLoylFd+uLK0Z/
         ZxPIuqa4F4XSGj5MeJFtlf3eE0d0OJLE0rGeVLUdGNRN2V7z4fMMqSDJhJVSalF7jDPT
         j4Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qLNzO18ajat1m0fs1W8NtMq/BQbLXFrYLsmtTPYjHJ8=;
        b=BvB68BGo8ifmW1mmHnCmMVWNwc1hKe81vapWY2S8kDyj1cqTrC//B9LquBpWYgvGkK
         NqjdXYTFzVcwO1y9ZJcX9mKJOlunPc2gZKX4pAG1uHKZxVJnnBo+XAZ96zRT5LZCEx3u
         LMYWx1v/Sj/xn6NrWfCJKClEo6AI84RlJNLbv8ZNkSV+g2nozpTetUF50th+l52fHMIK
         dkjPKTKVxm9HiRyVOTn4UJcZKfoaqQk+xK75K3AtwG8TEFq6I4HYxEWVMICQZ06sMy/a
         TIt1a8q9d91ULAgEwxWp6Y/yl5pCQE+v05JXiqbnz2rbPY6tIhQ0a/xkNVX36m5KoBWY
         w5PQ==
X-Gm-Message-State: AOAM530hhEQn1UXId+w79NnffJnE2d1t89oGqGdY2Mi+DDYl5623OiGR
        z3U5qaHWdHlvdahZHW/MwZN3Nw==
X-Google-Smtp-Source: ABdhPJzkTWYehe59rde3kRAtZPzzbA6tHyxqruaUsn3Kn0DRZ6Wh/jC8BaavKN0yp+ne9/VWwnP0fw==
X-Received: by 2002:a92:6a01:0:b0:2b6:87b7:180b with SMTP id f1-20020a926a01000000b002b687b7180bmr2725039ilc.82.1648939179643;
        Sat, 02 Apr 2022 15:39:39 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id r9-20020a6bd909000000b00649276ea9fesm3648152ioc.7.2022.04.02.15.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Apr 2022 15:39:37 -0700 (PDT)
Date:   Sat, 2 Apr 2022 22:39:34 +0000
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, stable@kernel.org
Subject: Re: [PATCH 1/4] KVM: arm64: vgic: Don't assume the VM debugfs
 directory exists
Message-ID: <YkjQpoS4Y+3+dwjp@google.com>
References: <20220402174044.2263418-1-oupton@google.com>
 <20220402174044.2263418-2-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220402174044.2263418-2-oupton@google.com>
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

On Sat, Apr 02, 2022 at 05:40:41PM +0000, Oliver Upton wrote:
> Unfortunately, there is no guarantee that KVM was able to instantiate a
> debugfs directory for a particular VM. To that end, KVM shouldn't even
> attempt to create new debugfs files in this case. If the specified
> parent dentry is NULL, debugfs_create_file() will instantiate files at
> the root of debugfs.
> 
> Since it is possible to create the vgic-state file outside of a VM
> directory, the file is not cleaned up when a VM is destroyed.
> Nonetheless, the corresponding struct kvm is freed when the VM is
> destroyed.
> 
> Plug the use-after-free by plainly refusing to create vgic-state when
> KVM fails to create a VM debugfs dir.
> 
> Cc: stable@kernel.org
> Fixes: 929f45e32499 ("kvm: no need to check return value of debugfs_create functions")
> Signed-off-by: Oliver Upton <oupton@google.com>

Thinking about this a bit more...

The game of whack-a-mole for other files that possibly have the same bug
could probably be avoided if kvm->debugfs_dentry is initialized to
PTR_ERR(-ENOENT) by default. That way there's no special error handling
that needs to be done in KVM as any attempt to create a new file will
bail.

Going to test and send out a v2 most likely, just want to make sure no
other use of debugfs in KVM will flip out from the change.

--
Thanks,
Oliver
