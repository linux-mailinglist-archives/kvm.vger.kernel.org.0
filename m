Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3869471F7B3
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 03:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233282AbjFBBVV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 21:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233389AbjFBBVS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 21:21:18 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18EDE49
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 18:21:12 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-651e298be0aso547397b3a.2
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 18:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685668872; x=1688260872;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nYaRS4hy6K5UX5g2Ux6WO8Fk52iNEjArjQfyIhsZNzc=;
        b=GjXrmI7y3NI4wta0EFGuBM4IbRGt13OU/GMtUaGHFszp4Ig/3PsB7uXakLuiQvrVDp
         isRrUniWRSAMcVrNS7CAdkWJb85U2CoxIS13wfOxQ1LR9FhjiX7Czk33haSbPMXOnxki
         RoQkRuh1qdG803VSW5DQP83+HdEPd/uUE1MOV51DZSJQjaBTFbkyXKTz/lmnwwdO3xCK
         PSHNMPSfanTZsLjMek3FlGtQ3eBHDshVAIKAnxOgHE78U0MxSuKqJ0IvrSaAprG+hcEF
         Dzt6LhCGCjCcKmCDwwFTMVpvLUYCE9+Uw2uaq6j2aP7O87FK0qBj3Xc8SQOXWlO1nBoO
         6rtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685668872; x=1688260872;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nYaRS4hy6K5UX5g2Ux6WO8Fk52iNEjArjQfyIhsZNzc=;
        b=G5Y+oBil+ZmJ+Rdt5URCvIXrX/cj+PyFPbhExzAcRuByLg6A6MQmjFR60XaFHNK5Xr
         ejcUJivuL7xh7MFxGmJzIeBDmia9pLRz8Bm9pM2iTDW+CSUaKVeKRDzvR9AwoWsLZnNq
         meEXIB66MZqGUtmqI2JgQxtrBee/miv1FePqDaBq/8BPDc5kcR4vR7QnTG+HdT1/stHL
         dPb9hXjQJAxoyNzq7DAEmbrkcoR1CXmVBolTqgb2o4CRGTGikKajyk/caB+UUlHle1Hr
         B7LaQBNfhjNr4PbI7JeQLFtc4a8eOy2609GGBqF8wKJoft7zTbk9//VIi7ZTyap+pDpG
         XBJQ==
X-Gm-Message-State: AC+VfDzLuQ/Br4rHAc2vyEh7pBVtm7W5tE76O7YMKq/1WtCets2tX2Yn
        /2nDN9WBcPidvcInJW404ufdduxI08s=
X-Google-Smtp-Source: ACHHUZ6D1n7zVCLDuc8v5UpZpY9L+26mvS+ip9OdDnE6K1Wbgq3eYV5xUoHu7/n4SC1LUvCO5rCiDvqVibc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:234f:b0:643:92c0:5dd6 with SMTP id
 j15-20020a056a00234f00b0064392c05dd6mr4035934pfj.6.1685668872508; Thu, 01 Jun
 2023 18:21:12 -0700 (PDT)
Date:   Thu,  1 Jun 2023 18:20:54 -0700
In-Reply-To: <20230327175457.735903-1-mhal@rbox.co>
Mime-Version: 1.0
References: <20230327175457.735903-1-mhal@rbox.co>
X-Mailer: git-send-email 2.41.0.rc2.161.g9c6817b8e7-goog
Message-ID: <168565253704.663070.17775614379616029612.b4-ty@google.com>
Subject: Re: [PATCH] KVM: Don't kfree(NULL) on kzalloc() failure in kvm_assign_ioeventfd_idx()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
        Michal Luczaj <mhal@rbox.co>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 27 Mar 2023 19:54:57 +0200, Michal Luczaj wrote:
> On kzalloc() failure, taking the `goto fail` path leads to kfree(NULL).
> Such no-op has no use. Move it out.
> 
> 

Applied to kvm-x86 generic, thanks!

[1/1] KVM: Don't kfree(NULL) on kzalloc() failure in kvm_assign_ioeventfd_idx()
      https://github.com/kvm-x86/linux/commit/70b0bc4c0a05

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
