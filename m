Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6685F72513E
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 02:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240009AbjFGAxb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 20:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234763AbjFGAx3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 20:53:29 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B29AE5E
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 17:53:28 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-ba8337ade1cso10866861276.2
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 17:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686099208; x=1688691208;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BIfTG0o6Jw63aOncREeIhxJraVmcJKp/jWwMG0WZpaM=;
        b=aTWq0ILYYDRTgBT7kbya/DbxjqBEcJuFxaBuUXadHEOee9C3+D+zrSEZRRnHKUYxgt
         DZ7WuijcW8UZj639YEc2AXWgvRM1S6u9+0HXF9jJqpTLDpD6OzfrFa4OtNWJQy39TP/U
         iGrXRDzJMxRaBrxcPeqq0O6cliLmvP/f69p4o4hOhatP+Vc/i8HUEtOxpBtNJFcWpMEC
         347Dp8kRZuWPq7+yUqnty10yb5bwSGFOwu1eKtBRINqTMBoBvgDz9zRqRcLHg+dgauDV
         jnug+5KwZXdsqD+eSjoz8r3OC/lTP2cp26pgCgRdheE0uVTfLSeFbFWd3VG5w8ekIme7
         lk3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686099208; x=1688691208;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BIfTG0o6Jw63aOncREeIhxJraVmcJKp/jWwMG0WZpaM=;
        b=KxQrMLCQCsmKPtR6jdL4jMnWwJ2ztk64CM3btX3sGjeCgZ6MaIF5Gp9iRDEpnPvWOJ
         sigxLs5hdTONeXuOqyILRz1V/p7M1ymyEZ2zrkMev23Q03rAUTtFonCivBm72k3Px4Xm
         DfDQasPHFJhim1WNeJFX6CosW0VfNL8HgxZqwRj4Jxz0SpUpzJKZVNUSm5LG2B6+Jnwd
         1fW18gQi3r2LsIKYacoLhv+Duj9l8o7jtOYqn2NZDqfpu8TBB6dZcSLZh3Z2IiLw/Pv1
         Ql/QtbGzb5O+QWGHiV3tscXhxL8xPpTjx+gPS/v0hBENQC7rHOhKFo2qPT4LPmQxFLad
         AK+w==
X-Gm-Message-State: AC+VfDzBm6asx54wK/Wnfla+348H7NPWkdLgQxitDypCBBKuGnvdDVb5
        W6Iw8ETCJtPUFbOxGAwqEhMEOSMXc98=
X-Google-Smtp-Source: ACHHUZ456IwAlUdRUqPbj9ttC3mp03tCoqKDOhysgXcms+SrbcKTidJ4b9TijGD3ine8jjyyXroyqEvELhc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:4c87:0:b0:ba8:1e5f:850f with SMTP id
 z129-20020a254c87000000b00ba81e5f850fmr1344595yba.10.1686099207933; Tue, 06
 Jun 2023 17:53:27 -0700 (PDT)
Date:   Tue,  6 Jun 2023 17:53:21 -0700
In-Reply-To: <20230605114852.288964-1-mhal@rbox.co>
Mime-Version: 1.0
References: <20230605114852.288964-1-mhal@rbox.co>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <168608936821.1367329.5605772918599028548.b4-ty@google.com>
Subject: Re: [PATCH] KVM: Clean up kvm_vm_ioctl_create_vcpu()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Michal Luczaj <mhal@rbox.co>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
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

On Mon, 05 Jun 2023 13:44:19 +0200, Michal Luczaj wrote:
> Since c9d601548603 ("KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond")
> 'cond' is internally converted to boolean, so caller's explicit conversion
> from void* is unnecessary.
> 
> Remove the double bang.
> 
> 
> [...]

Applied to kvm-x86 generic, thanks!

[1/1] KVM: Clean up kvm_vm_ioctl_create_vcpu()
      https://github.com/kvm-x86/linux/commit/5f643e460ab1

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
