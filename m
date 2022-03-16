Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0E9B4DACF6
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 09:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354691AbiCPIzU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 04:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346087AbiCPIzP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 04:55:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E9CB148E6F
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 01:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647420840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JP3Ykjoa4mUmb5BGwhHBlaqhkdFz67EQLDFR5ioKGxU=;
        b=Dg/0Lx5rsN02zZUTtL1F91keIRq/u8t2ed+94egYESBWwzWowlfYfOAy/ApZtUpQmA9hZA
        87NsRkr/RpjCtsmgFrPcqh4OKUP8ZC6fNNmdbbvNhYHHUWweZ2xDe/3ABmptqxji+oHQ1u
        UD5lleN0i10p3mNjWr64wRR4Iv1gQDA=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-372-EhTn_NeSOhCisRQAkeNYZg-1; Wed, 16 Mar 2022 04:53:58 -0400
X-MC-Unique: EhTn_NeSOhCisRQAkeNYZg-1
Received: by mail-pf1-f200.google.com with SMTP id c62-20020a621c41000000b004f7ea6d51bcso1427290pfc.22
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 01:53:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JP3Ykjoa4mUmb5BGwhHBlaqhkdFz67EQLDFR5ioKGxU=;
        b=RtD2DvCTn32s6TfpI0liF0hTBT4slTywRxB2tzmPZZcNzBfoza5UFU/Wp95BPuaOPb
         cRaeTY8XtiJgwWhrtH63p6EJKoKHPX0bd8e2SZ/LwqNwt0vkxMqs0ffzK8pWzvyAu4LX
         aQBO+ERg0I8tY59bNGt5tPuWPkMlpH1NSBGNaP9njsya1Ke8iozJMddNRPZtC1E1exeo
         DgshQ64B+imgll8udPPTYWXnOAsuYQHDOCu/ypAsYtekGrOuT1FgiaGwS8SXcaWbP5Hf
         uRFasD+q7M1uviAHLuFOrtUIJHgVZYlYGjn8Cx17iBHsBborCZThlzLznSjCu9IceyIo
         mU7A==
X-Gm-Message-State: AOAM533KxpMBwbAgZbopSvT7SYqfKfbChNErxOSMv9/ifYbEgRT+zY57
        v0fiE27o+87SVNgwZg9ZeiahULhJdmLiJgYaaVTh5P3GCpRQI305Rk3xk8fETs2bSNoWk9wQUoe
        EIGGP+MunLwzx
X-Received: by 2002:a05:6a00:23c5:b0:4f7:878:850f with SMTP id g5-20020a056a0023c500b004f70878850fmr32541401pfc.80.1647420837611;
        Wed, 16 Mar 2022 01:53:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxg+2QPvorb661B5qQOPrFyWOnG5+8eT2vD44dyAewSHPUWuWYJt2MRoEccIaejd2wV4N8cBQ==
X-Received: by 2002:a05:6a00:23c5:b0:4f7:878:850f with SMTP id g5-20020a056a0023c500b004f70878850fmr32541378pfc.80.1647420837364;
        Wed, 16 Mar 2022 01:53:57 -0700 (PDT)
Received: from xz-m1.local ([191.101.132.128])
        by smtp.gmail.com with ESMTPSA id q11-20020a056a00084b00b004f73e6c26b8sm2072273pfk.25.2022.03.16.01.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 01:53:56 -0700 (PDT)
Date:   Wed, 16 Mar 2022 16:53:48 +0800
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
Subject: Re: [PATCH v2 19/26] KVM: x86/mmu: Refactor drop_large_spte()
Message-ID: <YjGlnDJeSX/wBH6D@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-20-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220311002528.2230172-20-dmatlack@google.com>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 11, 2022 at 12:25:21AM +0000, David Matlack wrote:
> drop_large_spte() drops a large SPTE if it exists and then flushes TLBs.
> Its helper function, __drop_large_spte(), does the drop without the
> flush.
> 
> In preparation for eager page splitting, which will need to sometimes
> flush when dropping large SPTEs (and sometimes not), push the flushing
> logic down into __drop_large_spte() and add a bool parameter to control
> it.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

The new helpers looks much better indeed..

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

