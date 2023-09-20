Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE9E7A882D
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 17:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235369AbjITPYE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 11:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235115AbjITPYB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 11:24:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 030FF94
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 08:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695223391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+AodFqipq+4zzyepowhdy7gCv0Zx+sMPiLh2d6JJB00=;
        b=SHZIujf/yE/MrR4RJsz+dWvmwj9CCHhyURWcD3vCJAzjLEoq7sP+ld3aQXkky4xgezpq6L
        q8hw3mZUmRjmSV9RIjgzEx5qP64g09Phc1AAe57N7IHySkeWJP4FSwu8kJbIWYmTRb/Ojr
        GoDTtN1D9wEWvd2w7R/EBQ/tauskeE0=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-300-xcTKMB_QNgSiE3_twWFbjw-1; Wed, 20 Sep 2023 11:23:09 -0400
X-MC-Unique: xcTKMB_QNgSiE3_twWFbjw-1
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-48fd47fe55cso3100722e0c.1
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 08:23:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695223389; x=1695828189;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+AodFqipq+4zzyepowhdy7gCv0Zx+sMPiLh2d6JJB00=;
        b=JptislcBkpWX3jakaJCP+La4GJdcY/4T2kLB2k8DTafJ5uOK3ebJf7eiySTqA0FuBE
         jWrW/BDEr5oixHET4pACrm24iuwJOX1vPloeTibDQYmFMGDXbpBFgSl/cJcf3e4/K5i5
         fwxZlKIanioAyMLY21vvNpY8iFTxbl9Tf55x26OKejOjVdEveIzWgd5EkohHyBN3k6JX
         RaJB5BwnqjbAd8CycQRxbBgPf5IMzZCqYXS++RqFYGdrjLYc/41k18LFAPfjuRfOQIbV
         HAn601HxGLH0T244TrRvrf3795TdAiiu1G45XXVOwsSdcd+h1TAftxcR7idKyfUYBRco
         U6Mw==
X-Gm-Message-State: AOJu0YyA20D5E2459D4HbZvmaUfQji1DiCISg3L1toYHJt1KWjobrinm
        phnysPH1v3Ex2o800sJr6tARW38uoCflrS3z4cPeZuqQCj+TXfMM3RckbQo+8DOosLyWGp1Zes7
        eoeTP6iWh1/DMPld6Z6MUyNFhpxPu
X-Received: by 2002:a1f:e043:0:b0:495:e530:5155 with SMTP id x64-20020a1fe043000000b00495e5305155mr3129253vkg.3.1695223389092;
        Wed, 20 Sep 2023 08:23:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEvd/n8XEaJH7/YuJPXjPqPkp72tTLpM+DiKiB8tpdFg764ZKkrqCGUIqlRMG016VedD0OAjrNvfB9CJHZiKU8=
X-Received: by 2002:a1f:e043:0:b0:495:e530:5155 with SMTP id
 x64-20020a1fe043000000b00495e5305155mr3129240vkg.3.1695223388856; Wed, 20 Sep
 2023 08:23:08 -0700 (PDT)
MIME-Version: 1.0
References: <20230915014949.1222777-1-zhaotianrui@loongson.cn>
 <CAAhV-H5fbyoMk9XWsejU0zVg4jPq_t2PT3ODKiAnc1LNARpBzA@mail.gmail.com>
 <fed0bbb0-9c94-7dac-4956-f6c9b231fc0d@loongson.cn> <CAAhV-H5_KwmkEczws2diHpk5gDUZSAmy_7Zgi=CowhGZN9_d_A@mail.gmail.com>
 <e53a4428-7533-61cd-81c5-0a65877041fd@loongson.cn> <CAAhV-H7QKBEV_dSfX8nprZ838HRCcDt8cziPip4UdSMuYvERzQ@mail.gmail.com>
In-Reply-To: <CAAhV-H7QKBEV_dSfX8nprZ838HRCcDt8cziPip4UdSMuYvERzQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed, 20 Sep 2023 17:22:57 +0200
Message-ID: <CABgObfaWiNYWFhR5528=3_1RBqTwTDqNpBHDRbvkd-9UyrCDpg@mail.gmail.com>
Subject: Re: [PATCH v21 00/29] Add KVM LoongArch support
To:     Huacai Chen <chenhuacai@kernel.org>
Cc:     zhaotianrui <zhaotianrui@loongson.cn>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 16, 2023 at 5:17=E2=80=AFAM Huacai Chen <chenhuacai@kernel.org>=
 wrote:
> I can test now, during my tests I may ask some other questions about
> your patches. You just need to answer my questions and I will adjust
> the code myself if needed. After that I will give you a final version
> with Tested-by and you can simply send that as V22.

Since you are preparing yourself the v22, you could also send it to me
as a pull request.

Thanks,

Paolo

