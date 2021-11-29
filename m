Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1504461D35
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 18:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348699AbhK2SBz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 13:01:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:57247 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349425AbhK2R7x (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Nov 2021 12:59:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638208594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1vzx8zkonNlgqsej18YvSiZADgZZl0ApWDT4xKZBBxE=;
        b=XWBTkUedNZDDDjjRn5OZfgbVU6Ki3hJF2qYKif8Wnx6oc/bnoH0md+KbgbWgQJSaHzECHR
        Ks3wX5kAj7BSjbX53eXaG4s+E78aUJOb2Xs+KMivpVYHB5qBpwdEogYWAkSxumkEckAjSi
        X3FLPpoO4Qwzhj5V+yDZVYyifO250TY=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-85-in_V1F1vNIONnmM1xH-Urg-1; Mon, 29 Nov 2021 12:56:32 -0500
X-MC-Unique: in_V1F1vNIONnmM1xH-Urg-1
Received: by mail-ot1-f72.google.com with SMTP id f79-20020a9d03d5000000b0055c7d2f07ffso10023335otf.14
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 09:56:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1vzx8zkonNlgqsej18YvSiZADgZZl0ApWDT4xKZBBxE=;
        b=Z7HqebeDm4giJq5gcVJJDazTh4opCHeuKBffnNq6ubjXfki8KokikU/Gpf+5Vgl6R2
         Oa1pDg3nnT68LNyfsLZ5qnWkEG2b4Ry35b53AAtyXvDQiw+gPRQ00TLzBjB03zyl5S3J
         Jr6rTVgBBcOMPbfOmKYeHDPIIq90DBY+frKwGlnpiiqTCau2g/lF3adZQd52X4OAV/Dk
         1MQoHRWIJ5QqoCFn/gV0r8aoc9KLWiBz8LvF7fnfGEZvpMYSWqBx5nXHJwzuWIbm/c0T
         M8m1CkGaCoe/PjfR8wdzViRBc0OqsVS1U9EZ/sUj1OEVeqQzVGZxItTWE++fIGGBtdPv
         ba1A==
X-Gm-Message-State: AOAM531EHoBcLwUVJwPu8kKz4gz9vjitv8k/maVwGurmutnils7dSrby
        qfSyry+uAwC72IFidOWJmVqqiGGW3F60+gwHdxqICN4gR75+jvN0qBipykiZUZ043MqNM1mvWqg
        zpn8daFxqQuWW
X-Received: by 2002:a9d:6e06:: with SMTP id e6mr45288991otr.381.1638208592180;
        Mon, 29 Nov 2021 09:56:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxZSz0QhJHiP90aeY9fuv0nh7inMxCOR/7HjTqjhc+RxIh8h/aLcnLrkrQrn1dVajxB49ufoQ==
X-Received: by 2002:a9d:6e06:: with SMTP id e6mr45288975otr.381.1638208591973;
        Mon, 29 Nov 2021 09:56:31 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id i3sm2322837ooq.39.2021.11.29.09.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 09:56:31 -0800 (PST)
Date:   Mon, 29 Nov 2021 10:56:29 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Matthew Ruffell <matthew.ruffell@canonical.com>
Cc:     linux-pci@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, nathan.langford@xcelesunifiedtechnologies.com
Subject: Re: [PROBLEM] Frequently get "irq 31: nobody cared" when passing
 through 2x GPUs that share same pci switch via vfio
Message-ID: <20211129105629.5ddfb6cf.alex.williamson@redhat.com>
In-Reply-To: <CAKAwkKs=p3bHQL5VXuh_Xhu3A+mg0mSEuFJ_fy4Zh6E6YG4aag@mail.gmail.com>
References: <d4084296-9d36-64ec-8a79-77d82ac6d31c@canonical.com>
        <20210914104301.48270518.alex.williamson@redhat.com>
        <9e8d0e9e-1d94-35e8-be1f-cf66916c24b2@canonical.com>
        <20210915103235.097202d2.alex.williamson@redhat.com>
        <2fadf33d-8487-94c2-4460-2a20fdb2ea12@canonical.com>
        <20211005171326.3f25a43a.alex.williamson@redhat.com>
        <CAKAwkKtJQ1mE3=iaDA1B_Dkn1+ZbN0jTSWrQon0=SAszRv5xFw@mail.gmail.com>
        <20211012140516.6838248b.alex.williamson@redhat.com>
        <CAKAwkKsF3Kn1HLAg55cBVmPmo2y0QAf7g6Zc7q6ZsQZBXGW9bg@mail.gmail.com>
        <CAKAwkKsoKELnR=--06sRZL3S6_rQVi5J_Kcv6iRQ6w2tY71WCQ@mail.gmail.com>
        <20211104160541.4aedc593.alex.williamson@redhat.com>
        <CAKAwkKs=p3bHQL5VXuh_Xhu3A+mg0mSEuFJ_fy4Zh6E6YG4aag@mail.gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 24 Nov 2021 18:52:16 +1300
Matthew Ruffell <matthew.ruffell@canonical.com> wrote:

> Hi Alex,
> 
> I have forward ported your patch to 5.16-rc2 to account for the vfio module
> refactor that happened recently. Attached below.
> 
> Have you had an opportunity to research if it is possible to conditionalise
> clearing DisINTx by looking at the interrupt status and seeing if there is a
> pending interrupt but no handler set?

Sorry, I've not had any time to continue looking at this.  When I last
left it I had found that interrupt bit in the status register was not
set prior to clearing INTxDisable in the command register, but the
status register was immediately set upon clearing INTxDisable.  That
suggests we could generalize re-masking INTx since we know there's not
a handler for it at this point, but it's not clear how this state gets
reported and cleared.  More generally, should the interrupt code leave
INTx unmasked for any case where there's no handler.  I'm not sure.

> We are testing a 5.16-rc2 kernel with the patch applied on Nathan's server
> currently, and we are also trying out the pci=clearmsi command line parameter
> that was discussed on linux-pci a few years ago in [1][2][3][4] along with
> setting snd-hda-intel.enable_msi=1 to see if it helps the crashkernel not get
> stuck copying IR tables.
> 
> [1] https://marc.info/?l=linux-pci&m=153988799707413
> [2] https://lore.kernel.org/linux-pci/20181018183721.27467-1-gpiccoli@canonical.com/
> [3] https://lore.kernel.org/linux-pci/20181018183721.27467-2-gpiccoli@canonical.com/
> [4] https://lore.kernel.org/linux-pci/20181018183721.27467-3-gpiccoli@canonical.com/
> 
> I will let you know how we get on.

Ok.  I've not had any luck reproducing audio INTx issues, any trying to
test it has led me on several tangent bug hunts :-\  Thanks,

Alex

