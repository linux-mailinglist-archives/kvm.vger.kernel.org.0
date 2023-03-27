Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF5886CA78B
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 16:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbjC0O0m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 10:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbjC0O01 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 10:26:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5D027690
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 07:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679927065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HCb5CYARt/ke0PXUaZENV1Zy7rv4z1suyv4cHWiEzRY=;
        b=FEsrlDTBKnCdpzcc9dVJltK0BTCgCABlqPigis6xjD9VgPY6I7uyUhj582cArbkGoA5ve0
        oKMH1IoUFDFgZWOBVFLJuyU1JL2nskxTR5Mu8CSuEn81YVD90gXbo2ZipYtxxVVhC00hZn
        KxiAeBoaWkW20R9/wNXeyxSE1G43yTk=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-371-xc06ov46Mj6XNaNbCjhUvw-1; Mon, 27 Mar 2023 10:24:24 -0400
X-MC-Unique: xc06ov46Mj6XNaNbCjhUvw-1
Received: by mail-ua1-f72.google.com with SMTP id cg20-20020a0561300c1400b007654e97787cso995327uab.17
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 07:24:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679927062;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HCb5CYARt/ke0PXUaZENV1Zy7rv4z1suyv4cHWiEzRY=;
        b=tbIIpQWoeuJbGyVulPUA+ifdQ8HprSnatZX13ZGNkBREEnEN4/hGINbIQOY2mXSxYR
         laz1WIK2rFIrESALCRSvf0o541ODFgeMzpl2p4pFIIf43mBXhGuxlryFvOlUbI79AkIy
         dnoYLlj5Ct+Bs76zk0sbvPntJz2gzDW2LqJk3k+qAHOKSgISntDxgLc5iRPHoARR0VxN
         M3XSqPOTGCtfjG8YzFupxSR+A1xR3CifqkogIwv2wnppcHMVMNSbg7YTrxI1n5M8a56d
         lr4AD+jBQAKedXmk34fRMNT7WfFxYsdqYsKi7NzmpliEWM4QQJ0b+Ez0Htlk1N4a4HY4
         Pmgg==
X-Gm-Message-State: AAQBX9f/QWVZqZRjXi80wTc7bq2f3qspFkqulWoioGvLcugD4f9E9FAc
        1ZoW+Tk+r+i5mIy8OO275MBkaBvlsugC2E68H4fGZpYCFzt2NDfcBmkwNcy+Hp3KtVcUtjD3xzR
        hDl+86yLiaphufrHwOkctYz0VfAYg42dKb19KkBs=
X-Received: by 2002:a05:6130:c91:b0:68b:94c5:7683 with SMTP id ch17-20020a0561300c9100b0068b94c57683mr8105352uab.0.1679927062160;
        Mon, 27 Mar 2023 07:24:22 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZKtMex/tpaadhC7/A3kbiPaqwpdCTnb7TmvYuHGDG5Er/ULTE+vcIozX5oGSBN+/KNP3M3qgRvXJabwVIbX7U=
X-Received: by 2002:a05:6130:c91:b0:68b:94c5:7683 with SMTP id
 ch17-20020a0561300c9100b0068b94c57683mr8105338uab.0.1679927061918; Mon, 27
 Mar 2023 07:24:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAAhSdy320bsv7=EBLcdiXyJcO6NWUFK9_XUvwF_KvFF8v91RpA@mail.gmail.com>
In-Reply-To: <CAAhSdy320bsv7=EBLcdiXyJcO6NWUFK9_XUvwF_KvFF8v91RpA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Mon, 27 Mar 2023 16:24:10 +0200
Message-ID: <CABgObfaCR0NDj7ipZg2YYHnv4vQbOW4yz9140e+nyZBnF0QgyA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv fixes for 6.3, take #1
To:     anup@brainfault.org
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pulled, thanks.

Paolo

On Fri, Mar 17, 2023 at 12:33=E2=80=AFPM Anup Patel <anup@brainfault.org> w=
rote:
>
> Hi Paolo,
>
> We have one KVM RISC-V fix for 6.3:
> 1) Fix VM hang in case of timer delta being zero
>
> Please pull.
>
> Regards,
> Anup
>
> The following changes since commit eeac8ede17557680855031c6f305ece2378af3=
26:
>
>   Linux 6.3-rc2 (2023-03-12 16:36:44 -0700)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-6.3-1
>
> for you to fetch changes up to 6eff38048944cadc3cddcf117acfa5199ec32490:
>
>   riscv/kvm: Fix VM hang in case of timer delta being zero.
> (2023-03-17 13:32:54 +0530)
>
> ----------------------------------------------------------------
> KVM/riscv fixes for 6.3, take #1
>
> - Fix VM hang in case of timer delta being zero
>
> ----------------------------------------------------------------
> Rajnesh Kanwal (1):
>       riscv/kvm: Fix VM hang in case of timer delta being zero.
>
>  arch/riscv/kvm/vcpu_timer.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>

