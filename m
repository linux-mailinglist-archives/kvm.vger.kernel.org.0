Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 654847078B0
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 05:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjERD6d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 23:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjERD6c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 23:58:32 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68BD30EC
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 20:58:10 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1ae54b623c2so13431445ad.3
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 20:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1684382290; x=1686974290;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MwR/MBLwVadvtqxIlhzjVFYQdhCDR7Ii81JaCJPJvZs=;
        b=VrZI+Xa6/9MhLk/l3U2AToFKZEO4zZxd2Dl/8O31TlPKkWSfJxemmpYpXLU1cGPRlB
         oyTmKQZcNN9Q8ZVf3BpTO6ovTzg3t/IfRzrKMIVohUAMFJrb3cOQ0gpsE8T9QmETJlC1
         E2gYpfH6OW5n3cUvvXjzqyIrhaWDOV3xFwHTENG2LSriCnR55HJky9ZLpgg71aFaFc5S
         L9I76yVUw2ZKg7j5gi96Qq6nv2bBdBG8jL7jmspxeWXqULRtju790lTI9t4T0OIY2eeT
         ySEtUAgL8mPhnouDarRYobCr6b9fnca+awWv5YYwVsDMKRZPN/dNF3Q3qSDGugLjpfAa
         pyFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684382290; x=1686974290;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MwR/MBLwVadvtqxIlhzjVFYQdhCDR7Ii81JaCJPJvZs=;
        b=fuaHRTvhtRz659D0blpCGabPgGzoaCXCcZS4J01UsY+V1eCGqE17bHmw2wxMOYJx7G
         MAJHF4eTQUJGOor9MrNw/fktO4W/z5LF/cI111V9gTyYnF5IFV7LhYyQAR1HNhaA8uvH
         0zW8O3Pt6mK6qQUgv/xK3OKwdH2+qtOWH7IZyA+m8VRqU3o3S1EI2AvOFTD+S/kOR5nv
         xcuD1RajfdFaDCqoy5ILqfhEFXriwbQdMD7tvniQ2C/i9NuN63yo0ZLk2TQb4LyYOE75
         +HmKbAp6Sv0AYppv7EZXodktbO0+D5nwMapX4941S4Hk08oOgA3I2pDW7e6jnM+OWedy
         rkFQ==
X-Gm-Message-State: AC+VfDyIr+IbfejtgXQNvlF4KnLCUOoFgkOuE3Gp4I3QfzZi7cItAdsD
        V1pJhEwcqpEcAZyQjQW89RKE+Q==
X-Google-Smtp-Source: ACHHUZ5dM9p+w/Tl4roOT7M6b4mt62W2zJIE2K6h3j6JSm8YgZBgaYbs9zWm57rGVtsvhBSmijDHKw==
X-Received: by 2002:a17:902:d382:b0:1aa:dd14:da98 with SMTP id e2-20020a170902d38200b001aadd14da98mr1219183pld.50.1684382290257;
        Wed, 17 May 2023 20:58:10 -0700 (PDT)
Received: from n37-012-157.byted.org ([180.184.51.70])
        by smtp.gmail.com with ESMTPSA id ch9-20020a17090af40900b0024e4aa37b90sm342311pjb.45.2023.05.17.20.58.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 20:58:09 -0700 (PDT)
From:   "dengqiao.joey" <dengqiao.joey@bytedance.com>
To:     joao.m.martins@oracle.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com
Subject: Re: [PATCH] KVM: SVM: Update destination when updating pi irte
Date:   Thu, 18 May 2023 11:58:06 +0800
Message-Id: <20230518035806.938517-1-dengqiao.joey@bytedance.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <3d05fcf1-dad3-826e-03e9-599ced7524b4@oracle.com>
References: <3d05fcf1-dad3-826e-03e9-599ced7524b4@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 17, 2023 at 11:32 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>
> On 17/05/2023 13:04, dengqiao.joey wrote:
> > This seems to be a different issue. Joao's patch tries to fix the issue
> > that IRTE is not changed. The problem I encountered is that IRTE does
> > get changed, thus the destination field is also cleared by
> > amd_iommu_activate_guest_mode().
>
> Whether the amd_iommu_activate_guest_mode() clears the destination field or not
> doesn't change the situation I think. So I don't think that is the problem
> you're having. amd_iommu_activate_guest_mode() will always make IRTEs with
> isRun=0. Which means your VF interrupts get injected via GALog events and the
> DestID is meaningless there :/ Even if you leave the old affinity there with
> isRun=1 bit it's still wrong as by the time you run the vcpu, the wrong affinity
> will be used by the VF. More fundamentally I am not sure that on IRTE routing
> updates in the VM that you can look on vcpu->cpu the way you are using it could
> be potentially invalid when vcpus are blocked/preempted. You're changing IRTEs
> in the whole VM in pi_update_irte()
>
> My changes essentially handle the fact where IRTEs will be always updated with
> the right GATag set in the IRTE ... and then when the vCPU migrates, wakes or
> block+unblocks it will change IRTE[DestID] with the new pcpu (which the vcpu is
> running on) via amd_iommu_update_ga(). So there's a good chance my changes fixes
> your affinity issue.
>
>         Joao

Sorry I forgot to mention before that in my application scenario, the vcpu runs on
a dedicated isolated cpu and uses "mwait" instead of "halt". So it will not be migrated,
blocked/wake and rarely get preempted by other threads. I think your patch can not fix
my issue because the vcpu rarely gets the opportunity to execute amd_iommu_update_ga()
from vcpu_load().

So each time the interrupt affinity is updated I can observe the loss of VF interrupt.
After applying my patch, the problem is solved.
