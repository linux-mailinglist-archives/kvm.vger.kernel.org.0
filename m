Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D901F779441
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 18:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234991AbjHKQVz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 12:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234567AbjHKQVw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 12:21:52 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A5B26A2
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 09:21:51 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id 46e09a7af769-6bcac140aaaso1993760a34.2
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 09:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691770911; x=1692375711;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8jKg5N5hbfx4G4nkzdYxZRRyiyKKwYaqTNfjWvIZvAs=;
        b=zc0817VRKQzK7Y4+3Am75b8whnYU7udMNvGIpoU3Z8J2LZooos78Pf0S7KAzda0Lbl
         RG/GkzpkzGwbakOyRZgdZXaZ2vQBMGuzWhbw5nNv/UY86xwVjSd3jU+3mS0fh3k8bGcW
         nzpItkgM6eqfr5PnZgX3guWO+mj+MUJRBGfneMpMQ7qzP54RiJVSYgHk7cpm/G/1rZS6
         gcSonm2agGtfO50G7iuyLBha4zeQOek8O4Zd1sCVenxENz7qicCc7mnNJm/9cP3OiFZL
         HQrM9N2GgkkdmgrXcOwrNpFnxDCZlrPrx3sHkqIbKeWq1bPlzqNeFqcli3sJJgTXp/UB
         2H6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691770911; x=1692375711;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8jKg5N5hbfx4G4nkzdYxZRRyiyKKwYaqTNfjWvIZvAs=;
        b=KfnZnppTD3K2xlbkbEkVKeqf3RfiENud+0gG+U/UMHAso+QidbseXOIV13Re2IMvP2
         oTMriFPsfg6aKrnsRbfanvZBYVgd1RtC1CkLkluiF5doGW9j+9ZqktWNsM27NQ+34cjw
         XMH7kRSxLE26SNW9C4i2Ezb8yYx5p0y5t0w8fHccVR/ydGPNPCInWIYrKca7hkWjkjPR
         XHIS9sAXGIpmZnJJ6IgQa3T/xMADtDXxKNHDfbLO5DT8scgbT7h3SVFH+BDyC99tvWeh
         ypvlB+FWBXvkniBOeWH/x7EnHREJd1bMGUiwd4YUKTgg7LvtguK6S9jSBr05ODf0DK8S
         KP8Q==
X-Gm-Message-State: AOJu0YwxZmxiSas98g4txLEVWLWfUEvYbHZUAEtc4YRgHF4gsdy9XjeP
        faKcufwYXb95Ef2B/J5tSeZn/LgBriwj4LCoQTjAQu9CylQcOqTPV0I=
X-Google-Smtp-Source: AGHT+IFmKhXLjuhqGamOxB2zZ0eLH2ZXhspjGba8e6gZO1qouLQ+iinPZIolJfdLMgZLIbhkI3norwAebs/9sotSWVs=
X-Received: by 2002:a05:6870:d782:b0:1bb:83ae:1512 with SMTP id
 bd2-20020a056870d78200b001bb83ae1512mr2750088oab.24.1691770910745; Fri, 11
 Aug 2023 09:21:50 -0700 (PDT)
MIME-Version: 1.0
References: <20230808114711.2013842-1-maz@kernel.org> <20230808114711.2013842-12-maz@kernel.org>
In-Reply-To: <20230808114711.2013842-12-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Fri, 11 Aug 2023 09:21:39 -0700
Message-ID: <CAAdAUtj-5PeXCH3tzdFYogg94aBRd4k7sr8x9SWD793XeFBS9Q@mail.gmail.com>
Subject: Re: [PATCH v3 11/27] KVM: arm64: Add missing HCR_EL2 trap bits
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Tue, Aug 8, 2023 at 4:48=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote:
>
> We're still missing a handfull of HCR_EL2 trap bits. Add them.
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Reviewed-by: Miguel Luis <miguel.luis@oracle.com>
> ---
>  arch/arm64/include/asm/kvm_arm.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kv=
m_arm.h
> index 58e5eb27da68..028049b147df 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -18,10 +18,19 @@
>  #define HCR_DCT                (UL(1) << 57)
>  #define HCR_ATA_SHIFT  56
>  #define HCR_ATA                (UL(1) << HCR_ATA_SHIFT)
> +#define HCR_TTLBOS     (UL(1) << 55)
> +#define HCR_TTLBIS     (UL(1) << 54)
> +#define HCR_ENSCXT     (UL(1) << 53)
> +#define HCR_TOCU       (UL(1) << 52)
>  #define HCR_AMVOFFEN   (UL(1) << 51)
> +#define HCR_TICAB      (UL(1) << 50)
>  #define HCR_TID4       (UL(1) << 49)
>  #define HCR_FIEN       (UL(1) << 47)
>  #define HCR_FWB                (UL(1) << 46)
> +#define HCR_NV2                (UL(1) << 45)
> +#define HCR_AT         (UL(1) << 44)
> +#define HCR_NV1                (UL(1) << 43)
> +#define HCR_NV         (UL(1) << 42)
>  #define HCR_API                (UL(1) << 41)
>  #define HCR_APK                (UL(1) << 40)
>  #define HCR_TEA                (UL(1) << 37)
> --
> 2.34.1
>
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>

Jing
