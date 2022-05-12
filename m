Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8C0252538F
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 19:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357030AbiELR2B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 13:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357028AbiELR2A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 13:28:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ADE2A994C8
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 10:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652376478;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tCD+8lP+xu7DSPBX9O/+vBKxjmnHI/OPG8q73tAYrnQ=;
        b=TvN+aQBLFLfxLPR8eW2oWY6hztnqgAGQknqw0kIw3ImybpEbqAaeRInqJgEczVV7nFZX9D
        a1NeWE+9pkdT823YSOnIJTixzmrBLIvTmtkFmu7/Sutbe26V01KzRpro+KNuIypadHyX4c
        +LswKhVrAWI3h0A66Q5l6CaxPBzxPZE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-425-kPMfk2IuN-e0Fj_skP7TdQ-1; Thu, 12 May 2022 13:27:52 -0400
X-MC-Unique: kPMfk2IuN-e0Fj_skP7TdQ-1
Received: by mail-wm1-f71.google.com with SMTP id c125-20020a1c3583000000b0038e3f6e871aso1887766wma.8
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 10:27:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tCD+8lP+xu7DSPBX9O/+vBKxjmnHI/OPG8q73tAYrnQ=;
        b=OQhqoN+gGp2YWd07WDqzk8IVVL0EEq1Sb/bAMnoMHkDiCuLKKZLw/kVr9XOHe2GhcN
         Vk+6eXNAuhX6DtLAE8Z6NUiMewlX68Vhh93pEvJ2wBeXFvG37jh2ESUk63vDEtP4clVP
         tIXT2N1HCyOj8ZauF9bfziBrJwMh+L5FgpqbUfeBMXvJwYZ3/JOO9/vHpNpVQcQbmaCK
         otD8Ayqa89FXWRph8K5I1ko4aRl36wry5k8GDfedz79IiL4C8Jq0on7P5IpQx3NB0F4w
         jONuzlLWcpM3kaQr2wrkpYFGH55IfGSNdtOUP7YUru4TG28VmkLMlR1QCSoGzgRmGexp
         aFcw==
X-Gm-Message-State: AOAM533CGrgy0jN2CnikTJCDYzMPRD+nVXvjXUyOCRZn1A5bAAytcA1e
        aeQMdADAUEvyLILfk1vi3iJu4fdHWMC5bYiktL57QuVwnWs7W+lpWRUCWMrxnofusKLpKV/AofJ
        524mJQHOkjqO+
X-Received: by 2002:a5d:47a7:0:b0:20c:5b3e:ff7 with SMTP id 7-20020a5d47a7000000b0020c5b3e0ff7mr683062wrb.362.1652376470552;
        Thu, 12 May 2022 10:27:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz3srJE4qB6x11g/cGuO/5n+uGKjdPkkRDRS6CiXRIBa/uR33ZYaYztU6Mw7Uixet5KfvEsQQ==
X-Received: by 2002:a5d:47a7:0:b0:20c:5b3e:ff7 with SMTP id 7-20020a5d47a7000000b0020c5b3e0ff7mr683049wrb.362.1652376470345;
        Thu, 12 May 2022 10:27:50 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id l7-20020a1ced07000000b0038eba413181sm3361695wmh.1.2022.05.12.10.27.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 10:27:49 -0700 (PDT)
Message-ID: <5cdb2ddb-eef1-e522-d41d-7ba0facf6dd7@redhat.com>
Date:   Thu, 12 May 2022 19:27:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH] vfio: Remove VFIO_TYPE1_NESTING_IOMMU
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Will Deacon <will@kernel.org>,
        Vivek Kumar Gautam <Vivek.Gautam@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <0-v1-0093c9b0e345+19-vfio_no_nesting_jgg@nvidia.com>
 <0e2f7cb8-f0d9-8209-6bc2-ca87fff57f1f@arm.com>
 <20220510181327.GM49344@nvidia.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20220510181327.GM49344@nvidia.com>
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

Hi,

On 5/10/22 20:13, Jason Gunthorpe wrote:
> On Tue, May 10, 2022 at 06:52:06PM +0100, Robin Murphy wrote:
>> On 2022-05-10 17:55, Jason Gunthorpe via iommu wrote:
>>> This control causes the ARM SMMU drivers to choose a stage 2
>>> implementation for the IO pagetable (vs the stage 1 usual default),
>>> however this choice has no visible impact to the VFIO user. Further qemu
>>> never implemented this and no other userspace user is known.
>>>
>>> The original description in commit f5c9ecebaf2a ("vfio/iommu_type1: add
>>> new VFIO_TYPE1_NESTING_IOMMU IOMMU type") suggested this was to "provide
>>> SMMU translation services to the guest operating system" however the rest
>>> of the API to set the guest table pointer for the stage 1 was never
>>> completed, or at least never upstreamed, rendering this part useless dead
>>> code.
>>>
>>> Since the current patches to enable nested translation, aka userspace page
>>> tables, rely on iommufd and will not use the enable_nesting()
>>> iommu_domain_op, remove this infrastructure. However, don't cut too deep
>>> into the SMMU drivers for now expecting the iommufd work to pick it up -
>>> we still need to create S2 IO page tables.
>>>
>>> Remove VFIO_TYPE1_NESTING_IOMMU and everything under it including the
>>> enable_nesting iommu_domain_op.
>>>
>>> Just in-case there is some userspace using this continue to treat
>>> requesting it as a NOP, but do not advertise support any more.
>> I assume the nested translation/guest SVA patches that Eric and Vivek were
>> working on pre-IOMMUFD made use of this, and given that they got quite far
>> along, I wouldn't be too surprised if some eager cloud vendors might have
>> even deployed something based on the patches off the list. 

thank you Robin for the heads up.
> With upstream there is no way to make use of this flag, if someone is
> using it they have other out of tree kernel, vfio, kvm and qemu
> patches to make it all work.
>
> You can see how much is still needed in Eric's tree:
>
> https://github.com/eauger/linux/commits/v5.15-rc7-nested-v16
>
>> I can't help feeling a little wary about removing this until IOMMUFD
>> can actually offer a functional replacement - is it in the way of
>> anything upcoming?
> From an upstream perspective if someone has a patched kernel to
> complete the feature, then they can patch this part in as well, we
> should not carry dead code like this in the kernel and in the uapi.

On the other end the code is in the kernel for 8 years now, I think we
could wait for some additional weeks/months until the iommufd nested
integration arises and gets tested.

Thanks

Eric
>
> It is not directly in the way, but this needs to get done at some
> point, I'd rather just get it out of the way.
>
> Thanks,
> Jason
>

