Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99E716CA7BB
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 16:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232795AbjC0OcN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 10:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233020AbjC0OcF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 10:32:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE5930FE
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 07:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679927421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b9eLalqstdpKeNqF0JPU3M2QxGoZ4TRTo+/fHn6qaXM=;
        b=W5RrRHfimNJGpq7IZPMo5sB6oA2OYWGF3er+UCIsIoXrWZmRo/dwiUTGBkRfOz2avMwQC/
        YN/+yCgdGURXCk2nBSkh0g2tgQM4+ClcUcWKT1LDdB7AIex+z2IAXYV5L5vf5ObjWiigIK
        J92XkX27T86AAuUqYzGVFZfv/8rZcYM=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-472-yF0VdhMXO1-m6bTjOVNVLg-1; Mon, 27 Mar 2023 10:30:20 -0400
X-MC-Unique: yF0VdhMXO1-m6bTjOVNVLg-1
Received: by mail-ua1-f69.google.com with SMTP id y14-20020ab020ae000000b0074fa36da8adso4252965ual.19
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 07:30:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679927419;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b9eLalqstdpKeNqF0JPU3M2QxGoZ4TRTo+/fHn6qaXM=;
        b=UQZ2lszksC2B2FU4KPn96jJMPdQTtwdq0Jo2g766/4L52qIklnyBdGgjjHK+7H8WTP
         T13Dvw03nwuoqLzUrB8GdIUiTBG1Ywh02vr31gkgRuNBwn5O0A0ZAwZoFSS3HAKFgJJq
         gGRdq8KgumRBRBzsV/44xsD7vt12PrT+ywDLD0rYVTlpSTqPYccWqlrXuBA6irRj0X9Z
         2mgh/+UEBFDS9Cg+9Yzr1pjBlYxVnjYRjrhFRGKVKVlQDmdXczO8ddQIU+DHZk11Xpdh
         Mci0gPY67oaQnyUQSCrjXrKgla12umCXgmy/N4hc01Zkvu26UN0/ScX8hFuVZYO7oK32
         MHIQ==
X-Gm-Message-State: AAQBX9flMZPzWoIgG63+bc/G88hrCK7cznz6FNiV6nMmeoUA+RkULneG
        poTF7mVB2iedw9PJckXrvA+ZVQP24gLasAeUdLeED++ESmHtJ+IjexoQc6b9+2ZlD7OMeW6CojM
        LU8+IXfBHNoQKn84eqhxk0+EREUoU
X-Received: by 2002:a67:d38a:0:b0:425:f1d7:79f7 with SMTP id b10-20020a67d38a000000b00425f1d779f7mr4978432vsj.1.1679927419560;
        Mon, 27 Mar 2023 07:30:19 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZBJzcBuNyKB0YgU78aQbtfnHpOo/1hx3Lod2lhUFlL73sSXMO7lEsmWLpjRWYdHAzSDPiCPFwRZXYUZy02d0Q=
X-Received: by 2002:a67:d38a:0:b0:425:f1d7:79f7 with SMTP id
 b10-20020a67d38a000000b00425f1d779f7mr4978424vsj.1.1679927419307; Mon, 27 Mar
 2023 07:30:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230322093117.48335-1-likexu@tencent.com>
In-Reply-To: <20230322093117.48335-1-likexu@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Mon, 27 Mar 2023 16:30:08 +0200
Message-ID: <CABgObfYfiUDf4zY=izcg_32yGCbUxxVc+JAkHGHwiQ0VmGdOgA@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: x86/pmu: Fix emulation on Intel counters' bit width
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Wed, Mar 22, 2023 at 10:31=E2=80=AFAM Like Xu <like.xu.linux@gmail.com> =
wrote:
>
> From: Like Xu <likexu@tencent.com>
>
> Per Intel SDM, the bit width of a PMU counter is specified via CPUID
> only if the vCPU has FW_WRITE[bit 13] on IA32_PERF_CAPABILITIES.
> When the FW_WRITE bit is not set, only EAX is valid and out-of-bounds
> bits accesses do not generate #GP. Conversely when this bit is set, #GP
> for out-of-bounds bits accesses will also appear on the fixed counters.
> vPMU currently does not support emulation of bit widths lower than 32
> bits or higher than its host capability.

Can you please point out the date and paragraph of the SDM?

Paolo

