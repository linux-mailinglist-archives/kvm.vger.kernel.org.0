Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9538762242C
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 07:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiKIGxJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 01:53:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiKIGxH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 01:53:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574A31FF9C
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 22:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667976729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PEQm6ll15sTbXHinKEExTDczQQxF7mS5pezlmOAp8H4=;
        b=fZP10jW9GPeGeQwlJoHybgdpMJj4SI4skPgz+1ZHoYNRyQTsPgMx+MsotaJfEQLeOeS/AA
        BmmsuKoZjW2p7QJ06IORAgtXA79KOLC4zX4WGl3JFpDpmgOHZzCXN5xlllLF8Q85Rzau8I
        dDA8zd8zgvusxY8ki5JlXkiJ1d54P0o=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-314-nY76A9EAMfu_1dx5b_d9mw-1; Wed, 09 Nov 2022 01:52:08 -0500
X-MC-Unique: nY76A9EAMfu_1dx5b_d9mw-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-13b041fd3cbso8205478fac.16
        for <kvm@vger.kernel.org>; Tue, 08 Nov 2022 22:52:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PEQm6ll15sTbXHinKEExTDczQQxF7mS5pezlmOAp8H4=;
        b=vkO3XynPZw/gWQN8dEq9FFFzKX1zm+rVOULKyd6NQsy3ZFDNErpjpSzRsPsore+4B0
         xxyFX0F0vqnJ1jrUlw8LbVS7yNTqJ6ysrNWHkg4bLmDHrsxEiOMcnNidxTj6q3msulhV
         DPCfhb+Fm3IsnRH0ghty5cX+ox0at99NHPb+uhX22sIHQWAPNESl8Ggqi6Gcdi7F3QHc
         GZiQGDzkIZdiSFo7eX3UIK5We1SpXGi5Doy7CJs3CMYISa6ms7ClPUKhCwoPcOWrwCPZ
         dNJHc4UB1ff0tMCku/ZTg2hOKtxNgJNKrfRCoH5NcRpNL9s69BoMffyhnGlIzp6+U+JG
         5nHw==
X-Gm-Message-State: ACrzQf1tdR6hcUavVymmGmK5wAg4LcE5LcsideKLCENN2DmMjryV9vUB
        vBALDmLFADwCAqFEuC2jNS8cp4Y/m6HCMhhQPD2Rf3PUXoqNxeY/zLCzo1E8xMkKDiLyAWD9vrF
        dvMswIPecLqpeMlMXLR4zToUR99/g
X-Received: by 2002:a05:6808:181e:b0:35a:5959:5909 with SMTP id bh30-20020a056808181e00b0035a59595909mr15034518oib.35.1667976728080;
        Tue, 08 Nov 2022 22:52:08 -0800 (PST)
X-Google-Smtp-Source: AMsMyM4qtLuPh0nKXATGmBFwCEqcdI+mDTOIOAIjlRFKg/2JfSc3O/3P80AYknl85fIYJF2/IYcsnQ6UHQu8+qfn8Xo=
X-Received: by 2002:a05:6808:181e:b0:35a:5959:5909 with SMTP id
 bh30-20020a056808181e00b0035a59595909mr15034512oib.35.1667976727889; Tue, 08
 Nov 2022 22:52:07 -0800 (PST)
MIME-Version: 1.0
References: <20221107093345.121648-1-lingshan.zhu@intel.com>
In-Reply-To: <20221107093345.121648-1-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 9 Nov 2022 14:51:56 +0800
Message-ID: <CACGkMEs9af1E1pLd2t8E71YBPF=rHkhfN8qO9_3=x6HVaCMAxg@mail.gmail.com>
Subject: Re: [PATCH 0/4] ifcvf/vDPA implement features provisioning
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, hang.yuan@intel.com, piotr.uminski@intel.com
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

On Mon, Nov 7, 2022 at 5:42 PM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>
> This series implements features provisioning for ifcvf.
> By applying this series, we allow userspace to create
> a vDPA device with selected (management device supported)
> feature bits and mask out others.

I don't see a direct relationship between the first 3 and the last.
Maybe you can state the reason why the restructure is a must for the
feature provisioning. Otherwise, we'd better split the series.

Thanks

>
> Please help review
>
> Thanks
>
> Zhu Lingshan (4):
>   vDPA/ifcvf: ifcvf base layer interfaces work on struct ifcvf_hw
>   vDPA/ifcvf: IRQ interfaces work on ifcvf_hw
>   vDPA/ifcvf: allocate ifcvf_adapter in dev_add()
>   vDPA/ifcvf: implement features provisioning
>
>  drivers/vdpa/ifcvf/ifcvf_base.c |  32 ++-----
>  drivers/vdpa/ifcvf/ifcvf_base.h |  10 +-
>  drivers/vdpa/ifcvf/ifcvf_main.c | 156 +++++++++++++++-----------------
>  3 files changed, 89 insertions(+), 109 deletions(-)
>
> --
> 2.31.1
>

