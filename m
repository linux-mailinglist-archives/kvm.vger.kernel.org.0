Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF960518ACE
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 19:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240150AbiECRSK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 13:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240139AbiECRSJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 13:18:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DB8A439816
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 10:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651598080;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=25yruawK82BRU8PPmLT07Lb5GnX+f2J1Ef9rIEwDi98=;
        b=fUUXauQyXVVhPzG4hyQTYye9i+RI9oZY+R0YggKmRZY0RB02Edivptx4osarVAANvXO69P
        aaAkMiKuHM6cFazrc/hRuruqkDKhdyjNm4DtnmTGSUIqnni5FGUFbyujO2WtCMfkaqfM7p
        /WSOim2+zONNxqdZWAW7sNmoua5SdjA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-111-r_cKIf9WNPqpmnl4DeT2eQ-1; Tue, 03 May 2022 13:14:28 -0400
X-MC-Unique: r_cKIf9WNPqpmnl4DeT2eQ-1
Received: by mail-wr1-f69.google.com with SMTP id y13-20020adfc7cd000000b0020ac7c7bf2eso6587552wrg.9
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 10:14:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=25yruawK82BRU8PPmLT07Lb5GnX+f2J1Ef9rIEwDi98=;
        b=InoG0Y6kTxoz+cbQc9DcbzEbdsGDOrBrnCdARG9Pm5Eo8zUehf4IkiGZwdztNsn2Ic
         8TVspqIA3JcnXtvk+VskEfMxP0xh94UZB+H8MKPjHCgZjzMBzlf3vz/Lfb1dvM+wXcmg
         ZseGcCQZ5qYqUIjkhJBPYYoMBgbc2gHhGKlDyVHmp5wHtdi7/k3bIwILCfSsGmylLXl7
         9cJmqPJvBeVSh658Rlu7+eWxWOHtD5oMe+713TH2GbmrFmvVFfHiXptPmNKS06Tk8BPe
         kLObxje/67kaXFoIy44UjNbfLx/dWPHOBq2YNMMTZUANiX2HdS4r44lzX2EsmhheBggo
         hMew==
X-Gm-Message-State: AOAM533QQS1/KZgFxF7UlSLx5VoZSwjdFC3WW182mbXh9xkIMvjil0oO
        kkkcwGapijFXjZx8fv6aGduhIWya89DuG2WVDi8x1dS0yEkTfg8HXvfwc8wLdXH0SPIhFlEpk7g
        l6MDgs9LBiAHL
X-Received: by 2002:adf:dc41:0:b0:205:8df5:464c with SMTP id m1-20020adfdc41000000b002058df5464cmr12717027wrj.445.1651598066883;
        Tue, 03 May 2022 10:14:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzp+8F7z9GHuGzIhq2lALuMJAAd+ac92PrS3GkXeyK/gh4fux9ihDLCHNWr3aNse5TC7eJquw==
X-Received: by 2002:adf:dc41:0:b0:205:8df5:464c with SMTP id m1-20020adfdc41000000b002058df5464cmr12717009wrj.445.1651598066613;
        Tue, 03 May 2022 10:14:26 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id l12-20020a7bcf0c000000b003942a244ee3sm1863346wmg.40.2022.05.03.10.14.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 10:14:26 -0700 (PDT)
Message-ID: <da752e67-1fff-e27f-bcaf-e29aaa536532@redhat.com>
Date:   Tue, 3 May 2022 19:14:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 1/4] KVM: arm64: vgic: Check that new ITEs could be
 saved in guest memory
Content-Language: en-US
To:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, andre.przywara@arm.com,
        drjones@redhat.com, alexandru.elisei@arm.com, oupton@google.com,
        reijiw@google.com, pshier@google.com
References: <20220427184814.2204513-1-ricarkol@google.com>
 <20220427184814.2204513-2-ricarkol@google.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20220427184814.2204513-2-ricarkol@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
> Try to improve the predictability of ITS save/restores by failing
> commands that would lead to failed saves. More specifically, fail any
> command that adds an entry into an ITS table that is not in guest
> memory, which would otherwise lead to a failed ITS save ioctl. There
> are already checks for collection and device entries, but not for
> ITEs.  Add the corresponding check for the ITT when adding ITEs.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arch/arm64/kvm/vgic/vgic-its.c | 51 ++++++++++++++++++++++++----------
>  1 file changed, 37 insertions(+), 14 deletions(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index 2e13402be3bd..e14790750958 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -894,6 +894,18 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
>  	return update_affinity(ite->irq, vcpu);
>  }
>  
> +static bool __is_visible_gfn_locked(struct vgic_its *its, gpa_t gpa)
> +{
> +	gfn_t gfn = gpa >> PAGE_SHIFT;
> +	int idx;
> +	bool ret;
> +
> +	idx = srcu_read_lock(&its->dev->kvm->srcu);
> +	ret = kvm_is_visible_gfn(its->dev->kvm, gfn);
> +	srcu_read_unlock(&its->dev->kvm->srcu, idx);
> +	return ret;
> +}
> +
>  /*
>   * Check whether an ID can be stored into the corresponding guest table.
>   * For a direct table this is pretty easy, but gets a bit nasty for
> @@ -908,9 +920,7 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
>  	u64 indirect_ptr, type = GITS_BASER_TYPE(baser);
>  	phys_addr_t base = GITS_BASER_ADDR_48_to_52(baser);
>  	int esz = GITS_BASER_ENTRY_SIZE(baser);
> -	int index, idx;
> -	gfn_t gfn;
> -	bool ret;
> +	int index;
>  
>  	switch (type) {
>  	case GITS_BASER_TYPE_DEVICE:
> @@ -933,12 +943,11 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
>  			return false;
>  
>  		addr = base + id * esz;
> -		gfn = addr >> PAGE_SHIFT;
>  
>  		if (eaddr)
>  			*eaddr = addr;
>  
> -		goto out;
> +		return __is_visible_gfn_locked(its, addr);
>  	}
>  
>  	/* calculate and check the index into the 1st level */
> @@ -964,16 +973,30 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
>  	/* Find the address of the actual entry */
>  	index = id % (SZ_64K / esz);
>  	indirect_ptr += index * esz;
> -	gfn = indirect_ptr >> PAGE_SHIFT;
>  
>  	if (eaddr)
>  		*eaddr = indirect_ptr;
>  
> -out:
> -	idx = srcu_read_lock(&its->dev->kvm->srcu);
> -	ret = kvm_is_visible_gfn(its->dev->kvm, gfn);
> -	srcu_read_unlock(&its->dev->kvm->srcu, idx);
> -	return ret;
> +	return __is_visible_gfn_locked(its, indirect_ptr);
> +}
> +
> +/*
> + * Check whether an event ID can be stored in the corresponding Interrupt
> + * Translation Table, which starts at device->itt_addr.
> + */
> +static bool vgic_its_check_event_id(struct vgic_its *its, struct its_device *device,
> +		u32 event_id)
> +{
> +	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
> +	int ite_esz = abi->ite_esz;
> +	gpa_t gpa;
> +
> +	/* max table size is: BIT_ULL(device->num_eventid_bits) * ite_esz */
> +	if (event_id >= BIT_ULL(device->num_eventid_bits))
> +		return false;
> +
> +	gpa = device->itt_addr + event_id * ite_esz;
> +	return __is_visible_gfn_locked(its, gpa);
>  }
>  
>  static int vgic_its_alloc_collection(struct vgic_its *its,
> @@ -1061,9 +1084,6 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
>  	if (!device)
>  		return E_ITS_MAPTI_UNMAPPED_DEVICE;
>  
> -	if (event_id >= BIT_ULL(device->num_eventid_bits))
> -		return E_ITS_MAPTI_ID_OOR;
I would put
    if (!vgic_its_check_event_id(its, device, event_id))
        return E_ITS_MAPTI_ID_OOR;
here instead of after since if the evend_id not correct, no use to look
the ite for instance.
> -
>  	if (its_cmd_get_command(its_cmd) == GITS_CMD_MAPTI)
>  		lpi_nr = its_cmd_get_physical_id(its_cmd);
>  	else
> @@ -1076,6 +1096,9 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
>  	if (find_ite(its, device_id, event_id))
>  		return 0;
>  
> +	if (!vgic_its_check_event_id(its, device, event_id))
> +		return E_ITS_MAPTI_ID_OOR;
> +
>  	collection = find_collection(its, coll_id);
>  	if (!collection) {
>  		int ret = vgic_its_alloc_collection(its, &collection, coll_id);
Besides look good to me
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

