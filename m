Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2D086EB5CB
	for <lists+kvm@lfdr.de>; Sat, 22 Apr 2023 01:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233804AbjDUXsF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 19:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233879AbjDUXr7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 19:47:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533621BF5
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 16:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682120833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ToPFBZRZwwcbfkNhosaQClC7SiVbXSkZAsqSyiQXGpI=;
        b=hWZbICNL08wbX3v60ZsxOlSyKIVed7fQJMgEKXoJSryTPEcCryokAbYkZW47bY+jvV4whk
        /XEMkVBBhrVmGCICDaWSZNvkpsLCV015GzCowlZgoMpoqqcgHlvnxsFIkWc5z2UuQmUYUx
        wUwZEsT8b2SeVlXokiI0/g75xpndzXU=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-LtHXheM_P9WILo3bVbE_Tw-1; Fri, 21 Apr 2023 19:47:11 -0400
X-MC-Unique: LtHXheM_P9WILo3bVbE_Tw-1
Received: by mail-ua1-f70.google.com with SMTP id a1e0cc1a2514c-76e162e61efso665052241.3
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 16:47:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682120831; x=1684712831;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ToPFBZRZwwcbfkNhosaQClC7SiVbXSkZAsqSyiQXGpI=;
        b=LpDo1kDUi1xUqr9FHo55Wq1bB6tWe6nJiG0ZPrYdqprY65Z6QrDVEDWz0lGGUHdbt0
         lBcdboHh7L4JecVG02BX4fM9liglQm3jJx7ZAVNqIPNcMHcTvmpQxF/HOhpCHkEw7shh
         fHfi4Tej4zznWt2dyPtIdelq7u4FTn5wC5GEr0MbJ2o47iKKj4pzOd0f9eqelxFaektA
         5wEY72lpFLy6iIJSTYU0RZZdxkENXzRRIs/meU4WI5WwHAzahnsI4djW9Rg1n0UVOuUD
         zmgs0cmK0v2ploPH0DqPGEdJnWE4FbT38sVuvxb7eqd+zWpa7g6HnX1HjaWnf4H/SJHy
         bAoA==
X-Gm-Message-State: AAQBX9efPN5fI6TLVWSrRq6pG7lSXOo6+XoMWsefd0/jFF1jioou8VdG
        bjs2ZgZZOmDx+uzWOwyDjdBClLhjW4dBSQMaHovUlAIfcEAj0joidCyyEDpCaMCQZ3N48c7Luol
        Hxg0N1MtUBNKav34KhMuvAdCXvZTN
X-Received: by 2002:a67:e955:0:b0:42f:e9ec:9d62 with SMTP id p21-20020a67e955000000b0042fe9ec9d62mr3461694vso.29.1682120831276;
        Fri, 21 Apr 2023 16:47:11 -0700 (PDT)
X-Google-Smtp-Source: AKy350Yblf2VVyW6II6dJHXYr/NY8sU+y8q5t6/7PfCe+EngTirCzVpGdJ7Y1vQYsIu5F+LN1JVDdoU8FK7UOLh3KPk=
X-Received: by 2002:a67:e955:0:b0:42f:e9ec:9d62 with SMTP id
 p21-20020a67e955000000b0042fe9ec9d62mr3461688vso.29.1682120831047; Fri, 21
 Apr 2023 16:47:11 -0700 (PDT)
MIME-Version: 1.0
References: <CAAhSdy2RLinG5Gx-sfOqrYDAT=xDa3WAk8r1jTu8ReO5Jo0LVA@mail.gmail.com>
In-Reply-To: <CAAhSdy2RLinG5Gx-sfOqrYDAT=xDa3WAk8r1jTu8ReO5Jo0LVA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Sat, 22 Apr 2023 01:46:58 +0200
Message-ID: <CABgObfbS7ej9pqmV05DKwq1929QD10EQ9XdkEb_Qhtbm1WrkeQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.4
To:     Anup Patel <anup@brainfault.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Atish Patra <atishp@atishpatra.org>,
        Atish Patra <atishp@rivosinc.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 21, 2023 at 7:34=E2=80=AFPM Anup Patel <anup@brainfault.org> wr=
ote:
> Please note that the Zicboz series has been taken by
> Palmer through the RISC-V tree which results in few
> minor conflicts in the following files:
> arch/riscv/include/asm/hwcap.h
> arch/riscv/include/uapi/asm/kvm.h
> arch/riscv/kernel/cpu.c
> arch/riscv/kernel/cpufeature.c
> arch/riscv/kvm/vcpu.c
>
> I am not sure if a shared tag can make things easy for you or Palmer.

It's not just making it easier, it is a requirement because I prefer
to keep an eye on changes to uapi.h and especially to avoid that
conflicts in KVM files reach Linus.

The conflicts may be minor, but they are a symptom of overlooking
"something" in the workflow.

If I can get the shared tag from Palmer then good, otherwise I suppose
this PR will also have to be delayed to the second week of the merge
window.

Paolo

