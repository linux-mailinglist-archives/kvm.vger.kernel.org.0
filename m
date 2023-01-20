Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4626C6747ED
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 01:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjATAUV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 19:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjATAUL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 19:20:11 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5EDA9F38E
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 16:20:09 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-434eb7c6fa5so35527617b3.14
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 16:20:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jCScDiApSenKlNpE338137C1AmpBHhu2hWQ6PhmNabM=;
        b=kvIlVEy9xqlwnI40FKNohnAx22N5IHMzAOxer+hyp+Rn5IyOOZG+NtoHEQPJk4Gagk
         exP7IsxcCZaZvlkxJmzv+0oobnKCBRaqXJSdq0VjC6jfCtONAMxWwJq127EknW1Hzk3d
         ljtIMPNRcRaEiizN+A9xfPi+EFlkS0biNLVgDqxNxiPyY396j6KbHbquSILZH7n0lVbj
         938LwL1NXmxkZXNX1UHehL11c6OPHWuQXcXRl8PyXpsL9+YZL4sBYRkRYJja/UzQTlQo
         5XqerFznt+6GfsZu+zVOVM5OK/wYUss4+F0DZWPU7JX9C5+tQKVb/K7akdnZkI/GwPUt
         PauA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jCScDiApSenKlNpE338137C1AmpBHhu2hWQ6PhmNabM=;
        b=4bMX91qGoVYmj5SDY6d1JyeoGNxLZcGwvvklAb31Cfn9UKEIGKaFRALy3vayTBGNvs
         7wEPoZ7NfKqgzG9arZaQ2xFj5+KiMfE4hdPBkFdFWFdld22YL8yNEsV+BfTS9DzLdnw+
         9TlV6YBdtjDw/amFMPrhMNUxmy3MaMbC+PjRzsbg7nEcdnN3smqwzNltsXon9ujM5fy4
         XKgpb1y306CyqSYwVmivkCv6dehuPCxxZCchC2CAZ8c/3iMLmjkk1u2Y3gceFt100ZZ6
         t20AfoYKV4omndRVfpH1HsCepaqxIHqWYLgK62+o7CzoDMxp8LGHwOEfymGihMUTfmNQ
         7hJg==
X-Gm-Message-State: AFqh2krfLlP7KUAzECrpIcxCmpBNnvl5uYbm16jVLQPS3hfBQ5cjECbu
        T63jtBvrNLYo7jNYzA4zLh4rui0NG4c=
X-Google-Smtp-Source: AMrXdXvo48s/HlDfO6AJTyWrQejxbnPdROQLxzcuQjSZ/zMqqFWcRXUvPDBxBGuzKGX/YQhEztr9feg7QT0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d215:0:b0:762:b86:e833 with SMTP id
 j21-20020a25d215000000b007620b86e833mr1707488ybg.404.1674174009151; Thu, 19
 Jan 2023 16:20:09 -0800 (PST)
Date:   Fri, 20 Jan 2023 00:19:41 +0000
In-Reply-To: <20230106040625.8404-1-lirongqing@baidu.com>
Mime-Version: 1.0
References: <20230106040625.8404-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <167416930101.2562670.15576694562845886911.b4-ty@google.com>
Subject: Re: [PATCH][resend] KVM: x86: fire timer when it is migrated and
 expired, and in oneshot mode
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        pshier@google.com, Li RongQing <lirongqing@baidu.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 06 Jan 2023 12:06:25 +0800, Li RongQing wrote:
> when the vCPU was migrated, if its timer is expired, KVM _should_ fire
> the timer ASAP, zeroing the deadline here will cause the timer to
> immediately fire on the destination
> 
> 

Applied to kvm-x86 apic, thanks!

[1/1] KVM: x86: fire timer when it is migrated and expired, and in oneshot mode
      https://github.com/kvm-x86/linux/commit/e9de8741ecfb

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
