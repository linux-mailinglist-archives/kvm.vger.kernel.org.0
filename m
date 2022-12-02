Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 557CB640E5E
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 20:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbiLBTXS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 14:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234039AbiLBTXR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 14:23:17 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B297E11A2
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 11:23:16 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id x13-20020a17090a46cd00b00218f611b6e9so6020058pjg.1
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 11:23:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DRtF/uYiJ/kcxCwlPoNOeHMIq7w92wCouUM7CJCyU/o=;
        b=NCvJmBPLvyaAE2ksHvId3GwYS5DhVdKP/yu0Orst532MhP8ZbImrJNJBEdH9hcgoYQ
         pIRjLrLeKetxbCbbS6JmWleH/xD9QiqnKAjIlaEIrC9MLHE7Qa3VgGo5ZLidOLNcbYFw
         g0RmqQFbKtsRe+W2vQqSIBZjcbxIM8nQ/UwIh6in5oY/mPa+xXP7l4kuUDmjCmr8/d9S
         ha7ZS/5MBQ6edT3YcUPceCrMTA/N4xC4USaj/fmL+OuTb6WIc1DuaYI1psM0esnzb0+F
         I6QC3VFt8hPuqc+k/EW8EmBn8yPPNr5fm6kggMU4myebUNH9aVyfrno+ZNwJD5yJkhRw
         kZHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DRtF/uYiJ/kcxCwlPoNOeHMIq7w92wCouUM7CJCyU/o=;
        b=hzWlQDLEMqnWXKl6vEk+D4LqODt47yfZ36fbCECIssJ5Leg0/Dv/Z53ZJI/uRoiDS1
         K8A2ga+7sZgMl4g2rivc5l8pXkGQYxu5m4JJrDtztfVk4Yu+5YvwE+MTN5d6D2qVhul8
         OS7NDk6bapF/9EqlPg/YwA4NkfM/1a60VFIPetVND49U3nHt++PKpKwphARNxw+r8gGv
         pI+H85NxSs/RRJluEs6j3qvoMnfQ8faY3i3QmKzFQZr8Jm9XrunaSssDugVz0UhQP1pf
         GKhN1PSO1pjt01bhZqya8DKLibb3PXiVNd2s2qS1Jpsps2VJFcOvLG1lzhKlQGBeqnuH
         lMBg==
X-Gm-Message-State: ANoB5pnWyoIlrpFD8wy267F5rmMIWOnEF4aw4dyvwKOxGySGkfjnr+cu
        zxtOcp9oZDO2lBIT9n0RpmFgOQ==
X-Google-Smtp-Source: AA0mqf7memne5cid1mg7iribYwmyia8hyhFD47wJWq3+hlbUbIdJre/KwBJhzsGjsxRp3ERZNmxmng==
X-Received: by 2002:a17:902:e54f:b0:189:6a7f:3046 with SMTP id n15-20020a170902e54f00b001896a7f3046mr37023479plf.88.1670008995855;
        Fri, 02 Dec 2022 11:23:15 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a9-20020a170902ecc900b0017f7628cbddsm6015757plh.30.2022.12.02.11.23.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 11:23:15 -0800 (PST)
Date:   Fri, 2 Dec 2022 19:23:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Hao Peng <flyingpenghao@gmail.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        inux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] KVM: x86: Keep the lock order consistent
Message-ID: <Y4pQoHRWfxGsdOQd@google.com>
References: <CAPm50a++Cb=QfnjMZ2EnCj-Sb9Y4UM-=uOEtHAcjnNLCAAf-dQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPm50a++Cb=QfnjMZ2EnCj-Sb9Y4UM-=uOEtHAcjnNLCAAf-dQ@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 08, 2022, Hao Peng wrote:
> From: Peng Hao <flyingpeng@tencent.com>
> 
> Acquire SRCU before taking the gpc spinlock in wait_pending_event() so as
> to be consistent with all other functions that acquire both locks.  It's
> not illegal to acquire SRCU inside a spinlock, nor is there deadlock
> potential, but in general it's preferable to order locks from least
> restrictive to most restrictive, e.g. if wait_pending_event() needed to
> sleep for whatever reason, it could do so while holding SRCU, but would
> need to drop the spinlock.
> 
> Thanks Sean Christopherson for the comment.
> 
> Signed-off-by: Peng Hao <flyingpeng@tencent.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> ---

Merged to kvm/queue, thanks!

https://lore.kernel.org/all/Y4lHxds8pvBhxXFX@google.com
