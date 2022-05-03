Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5027D518ACB
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 19:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240136AbiECRR7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 13:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240139AbiECRR5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 13:17:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F3681CFF1
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 10:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651598064;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h0UT80e2OsE53D4hX7NPBQUv2OnFyP0f8Hl74ukax6s=;
        b=YXCN42ZohroXeAir3fUjamHo1Pr77cTvvK8DDdHrBeV6KwoplPInncx77zY9I/pFanXMzG
        BP7cO9LdA2TLNHPQ5ke/Z+GSPfpcCQFRqrsPVZtrHeZq9xMKVW2vjPlLBIr2G8/W7lqBQd
        p1csMNVjZwlsizfVf6CfNH62aQ/YSlI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-568-RPcpQ73ONri7me7WJ95Z0g-1; Tue, 03 May 2022 13:14:23 -0400
X-MC-Unique: RPcpQ73ONri7me7WJ95Z0g-1
Received: by mail-wr1-f70.google.com with SMTP id y13-20020adfc7cd000000b0020ac7c7bf2eso6587470wrg.9
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 10:14:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=h0UT80e2OsE53D4hX7NPBQUv2OnFyP0f8Hl74ukax6s=;
        b=ZstLgbAr9vWRDg5SgNE3ezFRJNeIjJ+MOybM7PvHlA/jA4F+scLFtChEUEvikTYIjQ
         xUjiQrmLLPIZaEUOKdJVwUb1oeLMCLqfO/jlwVIer2qUR7TZgwJSK4u/IC9CJUv3mZw3
         NWwM7xC5dhZ/ejcS7FuKhLlsksQiLrOEwVm6NspII2RzNJJbUCZpayiYY1LgxIXRckpx
         GoR3IteVQ7txNzpZnsfz3qPV36qWyUVBP/jiX0AIBQCiCdRFi5E6ax/0FQmDMGRwF2n8
         EqgnIEJxibyYYzKYV2A5cpG04tOlHsco85Hk0Mg8vegU8FAvyIeOM2v5/T1fV0Eh9Ge6
         9cmg==
X-Gm-Message-State: AOAM530k+VMJO78HFVJ1yM4U5BQZsOI66F+jQEm89DuXrYrW7A4bOemr
        nheXHmAZm+uv32s/p5QnaPTmwTQB749hOelzJrcZUZKr/cY94P0lINzVTyPq0GyrhuSl/sZfHUk
        zHpNdgD+mKIqq
X-Received: by 2002:adf:b64c:0:b0:1e3:16d0:3504 with SMTP id i12-20020adfb64c000000b001e316d03504mr13448945wre.333.1651598061959;
        Tue, 03 May 2022 10:14:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJya43tZ6jxxsbkw9572l1+qFt/gUK79IGQU1kaGfQ6INDKO08w2SsPjVH/HLOTiYFV5o9hkTQ==
X-Received: by 2002:adf:b64c:0:b0:1e3:16d0:3504 with SMTP id i12-20020adfb64c000000b001e316d03504mr13448923wre.333.1651598061742;
        Tue, 03 May 2022 10:14:21 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id l20-20020a05600c1d1400b003942a244ed1sm2461871wms.22.2022.05.03.10.14.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 10:14:20 -0700 (PDT)
Message-ID: <b29fcba7-2599-bf1b-0720-26b05cc37fd4@redhat.com>
Date:   Tue, 3 May 2022 19:14:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 2/4] KVM: arm64: vgic: Add more checks when restoring
 ITS tables
Content-Language: en-US
To:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, andre.przywara@arm.com,
        drjones@redhat.com, alexandru.elisei@arm.com, oupton@google.com,
        reijiw@google.com, pshier@google.com
References: <20220427184814.2204513-1-ricarkol@google.com>
 <20220427184814.2204513-3-ricarkol@google.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20220427184814.2204513-3-ricarkol@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On 4/27/22 20:48, Ricardo Koller wrote:
> Try to improve the predictability of ITS save/restores (and debuggability
> of failed ITS saves) by failing early on restore when trying to read
> corrupted tables.
>
> Restoring the ITS tables does some checks for corrupted tables, but not as
> many as in a save: an overflowing device ID will be detected on save but
> not on restore.  The consequence is that restoring a corrupted table won't
> be detected until the next save; including the ITS not working as expected
> after the restore.  As an example, if the guest sets tables overlapping
> each other, which would most likely result in some corrupted table, this is
> what we would see from the host point of view:
>
> 	guest sets base addresses that overlap each other
> 	save ioctl
> 	restore ioctl
> 	save ioctl (fails)
>
> Ideally, we would like the first save to fail, but overlapping tables could
> actually be intended by the guest. So, let's at least fail on the restore
> with some checks: like checking that device and event IDs don't overflow
> their tables.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arch/arm64/kvm/vgic/vgic-its.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index e14790750958..fb2d26a73880 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -2198,6 +2198,12 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
>  	if (!collection)
>  		return -EINVAL;
>  
> +	if (find_ite(its, dev->device_id, event_id))
> +		return -EINVAL;
Unsure about that. Nothing in the arm-vgic-its.rst doc says that the
KVM_DEV_ARM_ITS_RESTORE_TABLES ioctl cannot be called several times
(although obviously useless)
> +
> +	if (!vgic_its_check_event_id(its, dev, event_id))
> +		return -EINVAL;
> +
>  	ite = vgic_its_alloc_ite(dev, collection, event_id);
>  	if (IS_ERR(ite))
>  		return PTR_ERR(ite);
> @@ -2319,6 +2325,7 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
>  				void *ptr, void *opaque)
>  {
>  	struct its_device *dev;
> +	u64 baser = its->baser_device_table;
>  	gpa_t itt_addr;
>  	u8 num_eventid_bits;
>  	u64 entry = *(u64 *)ptr;
> @@ -2339,6 +2346,12 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
>  	/* dte entry is valid */
>  	offset = (entry & KVM_ITS_DTE_NEXT_MASK) >> KVM_ITS_DTE_NEXT_SHIFT;
>  
> +	if (find_its_device(its, id))
> +		return -EINVAL;
same here.
> +
> +	if (!vgic_its_check_id(its, baser, id, NULL))
> +		return -EINVAL;
> +
>  	dev = vgic_its_alloc_device(its, id, itt_addr, num_eventid_bits);
>  	if (IS_ERR(dev))
>  		return PTR_ERR(dev);
Thanks

Eric

