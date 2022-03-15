Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 352424D957E
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 08:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345587AbiCOHln (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 03:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345590AbiCOHle (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 03:41:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ED1C14B858
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 00:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647330018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uq0Z2NOXqlkVrEm1qJusGexqNZk1tmem0xILqLvczWc=;
        b=flkWWW1HKdXs3++8E25mr0vdkz/5aivM/5EJy7jojqxuUmGmswgh9Unk7DXZH7m4kk4OEO
        ezW7oP9uZg8y+0YSrUQ5K7FED4BW8hHf43MY0MD9+teq/KdyI88TCaQ3HU3oAkvrOYRBXX
        f1z+jIFkD1Bk3/IYxFMNTckuLl7CQ10=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-ZxZ31t3JN4KqrsR-HkFbYg-1; Tue, 15 Mar 2022 03:40:16 -0400
X-MC-Unique: ZxZ31t3JN4KqrsR-HkFbYg-1
Received: by mail-pj1-f72.google.com with SMTP id h15-20020a17090a648f00b001c5f4e43035so1447634pjj.2
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 00:40:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uq0Z2NOXqlkVrEm1qJusGexqNZk1tmem0xILqLvczWc=;
        b=HnvcQdqxG6PDYWgpB4NUsEpGa8DN0rGzVohXBNiwaesIio07NUhiAVutRlwEeDZKr+
         lFNtqvahwT6aCjpYu3BmLJG5Ndw0H9jz7hc/8TElPCwybuufXbjDWWqZwGnMVocNpRGL
         vj8IjdFZNNPRZiZpdRFUv8uHRtcsfvLJQcUwradbLz3v6npivPTMeFL2JftrGOQ2l2Q/
         U97uO29h/0nnFFjkkM/mbCQToZeczJGAzLgijy4m+T44rv3HUkVKAqcRTHfZ65vjWB+U
         1PJetdFi0ZMtjgktCSpyZNcjAl3q8PKtKM0ESyp8SOp5Miwh6YD9dBCO9NR86a97rf8l
         /2AQ==
X-Gm-Message-State: AOAM531y/iwlm2kFXZm5tU406ExHXh4f9mbmupXFRlv0E26fPrJ13cUJ
        J7/+3zgWdbDH5Vl5DtjO33m5MNEbOM77dX2zXfd8CPXjAZmeqVANMLBY0HAz5DlXQbpSFjL8hrT
        xLnw8ZUljFljZ
X-Received: by 2002:a63:4543:0:b0:374:87b6:c9f5 with SMTP id u3-20020a634543000000b0037487b6c9f5mr23348153pgk.302.1647330014626;
        Tue, 15 Mar 2022 00:40:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJztMHMNYKIpNAuJc8FteBiELgu/J7bC35KETwQh5TE/MrV9Kwi39pAoHxQ4fUsa/R32a5KHkg==
X-Received: by 2002:a63:4543:0:b0:374:87b6:c9f5 with SMTP id u3-20020a634543000000b0037487b6c9f5mr23348131pgk.302.1647330014348;
        Tue, 15 Mar 2022 00:40:14 -0700 (PDT)
Received: from xz-m1.local ([191.101.132.43])
        by smtp.gmail.com with ESMTPSA id c7-20020aa78e07000000b004f6e4d8ccc8sm22380450pfr.163.2022.03.15.00.40.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 00:40:14 -0700 (PDT)
Date:   Tue, 15 Mar 2022 15:40:05 +0800
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
Subject: Re: [PATCH v2 01/26] KVM: x86/mmu: Optimize MMU page cache lookup
 for all direct SPs
Message-ID: <YjBC1ZLio2iPkZ0V@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-2-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220311002528.2230172-2-dmatlack@google.com>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 11, 2022 at 12:25:03AM +0000, David Matlack wrote:
> Commit fb58a9c345f6 ("KVM: x86/mmu: Optimize MMU page cache lookup for
> fully direct MMUs") skipped the unsync checks and write flood clearing
> for full direct MMUs. We can extend this further and skip the checks for
> all direct shadow pages. Direct shadow pages are never marked unsynced
> or have a non-zero write-flooding count.

Nit: IMHO it's better to spell out the exact functional change, IIUC those
are the direct mapped SPs where guest uses huge pages but host uses only
small pages for the shadowing?

> 
> Checking sp->role.direct alos generates better code than checking
> direct_map because, due to register pressure, direct_map has to get
> shoved onto the stack and then pulled back off.
> 
> No functional change intended.
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

