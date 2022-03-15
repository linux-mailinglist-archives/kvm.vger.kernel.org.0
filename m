Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB1E4D98F1
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 11:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233588AbiCOKki (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 06:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245566AbiCOKkg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 06:40:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8FCC14F9EB
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 03:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647340763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kJDd/9JiDZbTHZohyZFbEtBTCygNnRdmmrmfy8MFg0M=;
        b=SNrc0B7LfQET7HJElrLhlhklWn3/m126GaZV1xU2K1WinqUGy2QgUbrj2rYoqtg86TzXjW
        YFjOGiSXRwwpw1YAJS2cdJh79LrXai3wFKUZ3HFlB6KAVbx1lM1MJNPBQTKwnl+GYKVrqK
        rEPPDitgjWmsZbmERBL0Bo1YH+iqWYA=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-362-ZPc3LiGlPWWYjSIH3y7j6w-1; Tue, 15 Mar 2022 06:39:22 -0400
X-MC-Unique: ZPc3LiGlPWWYjSIH3y7j6w-1
Received: by mail-pj1-f70.google.com with SMTP id ge20-20020a17090b0e1400b001c64f568305so129827pjb.8
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 03:39:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kJDd/9JiDZbTHZohyZFbEtBTCygNnRdmmrmfy8MFg0M=;
        b=GItIpSKPOysYHEjKJr6iVoD9BFEWzOmSsuLmUy4N60ITyqtkISfNKweXsg78r9n5yO
         tuu+1OksqNFiXLBJH33sNikDd5W3j/ob8/K2BV1s8xIWYhLYzde9LVKE4q7lyYE2UO/S
         Rqn4dVPMbtJHvZfaDCZJbaEPEEYmdnD6Cy0pBbht7W8uWFJrRiZDB1CZKizp1357d5rw
         BYzLHKX1ditzpe3d47tCud1pFtrKsSjcU4qGnLg/YgRHO2cHDXLVs2HF1WtAy93SFB0W
         xog2TqyzCfJ0VGWJeA/RQ5p9k+kGeDJXh5WzqWfiz44BDoHn+deYU/UI/zAUQa51stM1
         uf9w==
X-Gm-Message-State: AOAM5317lfVz2zeKpjFKr5IMv5QX3lyUpNykqBPhU3rt3mQ+cnr1EgVU
        a0SuNU61HnvFwV5Gl5NuWfNxNCGvEmK3T2Jlcs3QZUAQHlJRbc/3Yu48hUW9Qy0gzSAQETwbcRq
        TWQKVgDNimqdH
X-Received: by 2002:a05:6a00:140f:b0:4e0:6995:9c48 with SMTP id l15-20020a056a00140f00b004e069959c48mr27468840pfu.59.1647340760977;
        Tue, 15 Mar 2022 03:39:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwSfNOcUi9xy2ekJmnOxedBPrTrKX0N/yrTIaL/Gy94SQN4Gb5kFP9OF6Ce9WSip5I+m8Q7zA==
X-Received: by 2002:a05:6a00:140f:b0:4e0:6995:9c48 with SMTP id l15-20020a056a00140f00b004e069959c48mr27468818pfu.59.1647340760732;
        Tue, 15 Mar 2022 03:39:20 -0700 (PDT)
Received: from xz-m1.local ([191.101.132.43])
        by smtp.gmail.com with ESMTPSA id q2-20020a056a00150200b004f8d80ced3csm4351131pfu.40.2022.03.15.03.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 03:39:20 -0700 (PDT)
Date:   Tue, 15 Mar 2022 18:39:11 +0800
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
Subject: Re: [PATCH v2 15/26] KVM: x86/mmu: Update page stats in __rmap_add()
Message-ID: <YjBsz/V7FLsNkNh3@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-16-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220311002528.2230172-16-dmatlack@google.com>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 11, 2022 at 12:25:17AM +0000, David Matlack wrote:
> Update the page stats in __rmap_add() rather than at the call site. This
> will avoid having to manually update page stats when splitting huge
> pages in a subsequent commit.
> 
> No functional change intended.
> 
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

