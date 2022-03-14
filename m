Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB43F4D8DDA
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 21:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244249AbiCNUJJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 16:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244928AbiCNUJI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 16:09:08 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0375C209
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 13:07:58 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id z7so19774537iom.1
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 13:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5/64AAEf4Vzs1A/LiRdwPiWTgC6wn0RFoaoEGIYS0K0=;
        b=qm68+ONcoiq70dlktTbSNWbKZczAYgBGwZhIZ/TCBXLlcnEgoXErDNKwxkmfapE/54
         PTEL1lKRg2IAH7cVdEVFVAvCBmewE0HrgTTPrnMWrHk+MPOzMIw5rUXPmi8Y5/H1gRez
         859U1z7DBPH6FPvSI0hvnipljJ4ADXURCyDlTeYJmNZ9ebJs4R7l4K5MVDF42BY6TNIT
         xnH6CcG7sUGUYNdTJ5r9lM/oLxYYKhu1euBNh51o+Ui5s9E2bmfqEsICS0yQZ5cEw5sf
         g0b2C3UITVh6uavnGAIFFQ+ncGVq4H6EWgNjHawb22qaRmnDZpwWrAOtZSZOl/X1NLJG
         K0bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5/64AAEf4Vzs1A/LiRdwPiWTgC6wn0RFoaoEGIYS0K0=;
        b=evMyjbWPbbYicJCGxcF0zMPGeljggiwKJ6rC0x3eljyCztBW3lKSk4H9k14N3iv5e1
         TIRqxw757oYjsHikbpHW1aROelPhiJEJq9KZiF57kQL1isWyrr+GTvzfuzdHdSnVWAz9
         h8I6oMLNr3oOIEStoN+ERV2J3lwq9z41PtmcJAiOCDQ+GElhkxVY9MBDoHx+70XEHYBT
         L1P8FIbdnzuJMsuMnsM/PLXnwHoJxhTF20l7/v+O2qm38FeImT6BAxkyAVKYS/43UKD5
         /NVnoJ5b8PQ31H7518f4aob9tsrgacxBOSMUpGzUv1PnvSukrCmWHlIymPCD2ARqVAo3
         i44Q==
X-Gm-Message-State: AOAM531mQYnYhtb53J86IwmSX71FhCmZ4YEEG+bYhTJy5+QSdMo6bxQi
        G4jvmg9XZe4owTu7O9vFVlIwwQ==
X-Google-Smtp-Source: ABdhPJx+cCT9RbztBLcxVFaSRxxa8KxO45I5CoBY2KZENSIpHruKS+BfdUba5UJey30qxO8YNS+AMQ==
X-Received: by 2002:a05:6638:1616:b0:31a:131c:9079 with SMTP id x22-20020a056638161600b0031a131c9079mr2603879jas.89.1647288477157;
        Mon, 14 Mar 2022 13:07:57 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id b25-20020a5d8059000000b00644ddaad77asm9076916ior.29.2022.03.14.13.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 13:07:56 -0700 (PDT)
Date:   Mon, 14 Mar 2022 20:07:53 +0000
From:   Oliver Upton <oupton@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [PATCH v4 1/3] KVM: arm64: Generalise VM features into a set of
 flags
Message-ID: <Yi+gmV6xuiCkAtbh@google.com>
References: <20220314061959.3349716-1-reijiw@google.com>
 <20220314061959.3349716-2-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314061959.3349716-2-reijiw@google.com>
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

On Sun, Mar 13, 2022 at 11:19:57PM -0700, Reiji Watanabe wrote:
> From: Marc Zyngier <maz@kernel.org>
> 
> We currently deal with a set of booleans for VM features,
> while they could be better represented as set of flags
> contained in an unsigned long, similarily to what we are
> doing on the CPU side.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Reiji Watanabe <reijiw@google.com>

Gee, that's one popular patch! Just as a heads up, I rebased it on top
of kvmarm/next in:

  http://lore.kernel.org/r/20220311174001.605719-2-oupton@google.com

since kvm_arch picked up another bool.

--
Oliver
