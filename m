Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDBB500958
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 11:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241539AbiDNJKP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 05:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241521AbiDNJKL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 05:10:11 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3176D962;
        Thu, 14 Apr 2022 02:07:47 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-2ec42eae76bso48363707b3.10;
        Thu, 14 Apr 2022 02:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=du9kKSyZ8/iyPYFYOsIaQUov6kGR9ZIsAFs+iWQKGeE=;
        b=F1Zm9GWuALLdmCRFLyjKZXBMImjjZWjGYMZa6T0Lvy+l/3R+klqHuyhvmq57oK8ilf
         D/Rf57UIwsxvUSzPtnI7z/BubVJwUyl7Zoq854nzvjQyjPgA2Q3jNsqBX3RcUVU8G3ki
         ekM+iscNfZ0wSf8eDe3O+raroMVcz4XNrng1odjeirUcoxWjy+b/omiaH35wUDIteTvr
         sUkHP1tj2SQb0/QoeRF677h5wYes1Hll8MK7HAAA2dbMW8/MQGaVrUotcwyF71Glb58W
         t2IQM2BfsxiMws/TmWvrZA9nIwNwU8/C300ULYgPGOQRmvaMmlNFSDv9FJVDFVh2p27I
         gQUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=du9kKSyZ8/iyPYFYOsIaQUov6kGR9ZIsAFs+iWQKGeE=;
        b=GSlIQyNRZqebljdSSUvTmD3zlydwlsdKi9Fnw9j/YeZRo6M3BKOHHzNNPQbnciJUm4
         Gx5DUU8VhkwlT9ZTJIIPuaD1SWvKfVp8Ni41ab3mhlqn9EBz0A28zcSILgfQI1muZU1t
         ziItnSHPlIlOeYDbaQdWQr/b1uk1PjkE5tdlHJ02kPdyvHmJsAoMvtyNx3iN97Z/kP9F
         uxbSoa0LlMB7RvS+yPt8gBCtZtOPzzlzZrEtfu6gJNgtPjdjWOp9olOdBDl55UDaAhtP
         dCUxNSk+qdofpuL2oPaXGxAGMDTf++Jsr+Y+imOPST8AjYGRiSYc7o6+3IpRxDjB6P7l
         Eyyg==
X-Gm-Message-State: AOAM531e75HaGsJrLvu/yLomCKPJrI3YdJewN2/bI2JBzdi/TMzCIRPA
        dh8o4lE/g0PDhQh0WX3fZfjmEZOI2V6Sl6DcxtSV/lrWXI0=
X-Google-Smtp-Source: ABdhPJyDWj6uTxEyHSC/A79SvoyTUflzd7mvIcnj3ZJm/Gun9HLsmkI18Cg5MvBTXESQMQuygmpOwEErmMRyqfKOLXI=
X-Received: by 2002:a81:178e:0:b0:2eb:ed49:8241 with SMTP id
 136-20020a81178e000000b002ebed498241mr1166903ywx.417.1649927266264; Thu, 14
 Apr 2022 02:07:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220330132152.4568-1-jiangshanlai@gmail.com> <20220330132152.4568-4-jiangshanlai@gmail.com>
 <YlXrshJa2Sd1WQ0P@google.com>
In-Reply-To: <YlXrshJa2Sd1WQ0P@google.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Thu, 14 Apr 2022 17:07:34 +0800
Message-ID: <CAJhGHyD-4YFDhkxk2SQFmKe3ooqw_0wE+9u3+sZ8zOdSUfbnxw@mail.gmail.com>
Subject: Re: [RFC PATCH V3 3/4] KVM: X86: Alloc role.pae_root shadow page
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 13, 2022 at 5:14 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Mar 30, 2022, Lai Jiangshan wrote:
> > From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> >
> > Currently pae_root is special root page, this patch adds facility to
> > allow using kvm_mmu_get_page() to allocate pae_root shadow page.
>
> I don't think this will work for shadow paging.  CR3 only has to be 32-byte aligned
> for PAE paging.  Unless I'm missing something subtle in the code, KVM will incorrectly
> reuse a pae_root if the guest puts multiple PAE CR3s on a single page because KVM's
> gfn calculation will drop bits 11:5.

I forgot about it.

>
> Handling this as a one-off is probably easier.  For TDP, only 32-bit KVM with NPT
> benefits from reusing roots, IMO and shaving a few pages in that case is not worth
> the complexity.
>

I liked the one-off idea yesterday and started trying it.

But things were not going as smoothly as I thought.  There are too
many corner cases to cover.  Maybe I don't get what you envisioned.

one-off shadow pages must not be in the hash, must be freed
immediately in kvm_mmu_free_roots(), taken care in
kvm_mmu_prepare_zap_page() and so on.

When the guest is 32bit, the host has to free and allocate sp
every time when the guest changes cr3.  It will be a regression
when !TDP.

one-off shadow pages are too distinguished from others.

When using one-off shadow pages, role.passthough can be one
bit and be used only for 5-level NPT L0 for 4-level NPT L1,
which is neat.  And role.pae_root can be removed.

I want the newly added shadow pages to fit into the current
shadow page management and root management.

I'm going to add sp->pae_off (u16) which is 11:5 of the cr3
when the guest is PAE paging. It needs only less than 10 lines
of code.

Thanks.
Lai
