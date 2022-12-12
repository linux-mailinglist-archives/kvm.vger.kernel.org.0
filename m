Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADC364A2D1
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 15:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbiLLOGv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 09:06:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbiLLOGs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 09:06:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F73E01F
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 06:05:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670853958;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uajs6U0hhaeyeVDe/bjj7cZ7ryR5qrPd0pvS+U5SVuY=;
        b=gVtuGpOiHIbmfaHrHtlh9qSnbVN6VbPfEXo9/C3PL9wNxaPoxmRZN6iX16sp6nN8/2mbx2
        id4bX+pYPKNAiOLve1DuEebsCaxb4xAx6swdx0RM36Eli1fIRD+TvdXmP4N78dho86L8BY
        xBkOYdyNQrxKpL141XmT8aHp8VJq9gw=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-481-00KCQ7VvM32q5VeE5SSVRw-1; Mon, 12 Dec 2022 09:05:52 -0500
X-MC-Unique: 00KCQ7VvM32q5VeE5SSVRw-1
Received: by mail-ua1-f70.google.com with SMTP id a16-20020ab00810000000b00419396f7955so5338461uaf.23
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 06:05:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uajs6U0hhaeyeVDe/bjj7cZ7ryR5qrPd0pvS+U5SVuY=;
        b=E3+BHQTKMHY4+mY2V3jvEkMem4N5+nRw6oDJphvnFs6KOGUVL6bW4zLiTsntxwFYhq
         5xvQVvFPc55cbT/RzffbcGJiIHfUEgUnZPiRTOFT3LOvRfB9w5cexO2O2qI6QVYy7IQS
         1FgENWqrayugIPfWT2V+LL0vXTRq0Fzm9gJSJXkK+Ibp8uX4854KZ4yrX+Jx3sJ4I3Z/
         dY8ulclEvJNM2xMhbe7JKVcQUsjfeOM/BTtsVZIwIxM43NsBayezHxWlENzSjx4eW/pt
         5muOMHL5TVNSXXvuEC66zZDyVYTmZmYNT84OWnib7xA2VibVW1XROuPTRgEnfcmIJxb+
         f3tA==
X-Gm-Message-State: ANoB5pl/mALDlSjlkgqgVlQ6h+Q0AipsNfRf4uBdbEcn+tCSn1lxCJcY
        F8Z9MxZB8VM3oPb+S+i+l4DtCUTCQWieBOQZDvHFVmTWp/JOlaBfT6HpYuEQ/CRTdwi7OeOZiEZ
        JoobjOBzNW42efwfcHOW0fr3uhxKc
X-Received: by 2002:a05:6102:2221:b0:3b0:4a83:954d with SMTP id d1-20020a056102222100b003b04a83954dmr45823962vsb.62.1670853951801;
        Mon, 12 Dec 2022 06:05:51 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6lVCd09X3oDho+YhdWpmFYyrYm2BN0E5ykxJQrwbC/h3XZ0H9Sx+5sJzH3tBlZC71g1FbsAu0DSKsAhtOSVYM=
X-Received: by 2002:a05:6102:2221:b0:3b0:4a83:954d with SMTP id
 d1-20020a056102222100b003b04a83954dmr45823957vsb.62.1670853951532; Mon, 12
 Dec 2022 06:05:51 -0800 (PST)
MIME-Version: 1.0
References: <CAAhSdy0qihfFCXTV-QUjP-5XiQQqBC4_sP-swx77k6PC3uTmmw@mail.gmail.com>
 <CABgObfZ7Ar-t5m0+p=H1h0_bk-dJ5rYSVRCo6ZP5Wa0Qva2sLQ@mail.gmail.com> <CAAhSdy0c5_oa27axsG_YnZmJqoTVXAeR2XQ=sqvLtBMaB3wB1Q@mail.gmail.com>
In-Reply-To: <CAAhSdy0c5_oa27axsG_YnZmJqoTVXAeR2XQ=sqvLtBMaB3wB1Q@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Mon, 12 Dec 2022 15:05:39 +0100
Message-ID: <CABgObfYmusq1LPoWCexYsP+=2pYLkfcNzRchJY9UmG_ktE-CGQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.2
To:     Anup Patel <anup@brainfault.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 12, 2022 at 2:08 PM Anup Patel <anup@brainfault.org> wrote:
> > It's a small set of changes, so I'm going to defer this pull request
> > to the second week of the merge window.
>
> Should I send another PR ?
> OR
> Should I re-create the kvm-riscv-6.2-1 tag ?


No, for this time it's fine.

Paolo

