Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB2B05E8606
	for <lists+kvm@lfdr.de>; Sat, 24 Sep 2022 00:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbiIWWqs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 18:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiIWWqq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 18:46:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D6815FC3
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 15:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663973204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TbpJrmGSZ/Fcv2wT55HywsC5o8heQwVobd1UKBeGb7k=;
        b=Jkl3/yo65ghvkfIX/VNCxxFV+ztbk+xiPle2jmk7ao1VZJzXi1ZK+EErwptM+cPKY8umkZ
        sZMIDcTb6SYuUIJzH9D9rGRkQNPecZfELczHd9rFQGL1pMLs7J6IY6IsFKn4Iv2/QZhhed
        VDE636F25U8OI3ea7pUBoqAaApIKTwk=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-195-bsjJfO6xPNKlXeOBtjjA9A-1; Fri, 23 Sep 2022 18:46:43 -0400
X-MC-Unique: bsjJfO6xPNKlXeOBtjjA9A-1
Received: by mail-qk1-f199.google.com with SMTP id bm21-20020a05620a199500b006cf6a722b16so1065501qkb.0
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 15:46:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=TbpJrmGSZ/Fcv2wT55HywsC5o8heQwVobd1UKBeGb7k=;
        b=3XsZeeOodb8suAlYeiMWKh+HpfRTbbqfXmNOTcALMM4qUu6G/hOkymsyIakJGDczC2
         XC/EyTQVI4+x6DBItMY4N0juTzXkbLXAtmaZFZmirXAqWjMmhnjhx6AXMiT8OfajHm7Y
         4TRFgWERafya4mRZ9XHaxyBWAL850m+M8hFO+JGcs5S0ge4EBbtu2d+gIt3otafKs1gR
         iAivMO/E2QMqhAGkyboVp85LZYtMI2l51XL21t4Sim5TLm+57qy30is4axNLLASFwOmJ
         KB/6u6+klllsmDZ45QX9bpQL0YNPsQfvvSxYsENVlF1D7fI0kcaW6kbTCn2Q7NXDb+FN
         09mA==
X-Gm-Message-State: ACrzQf1Z+qnpoRi/LwBGBxWjYLegt33cCIWqWIYftDRTSXzJVjPTrdwy
        LkYYGZMPjiOjrXoYKzqSsCPCA70nbUfD/T7YoyczuP79NtM0DdJULshTWc51wkQYwCcc3Qa+3D/
        Bz9Qo06rEEa2v
X-Received: by 2002:a0c:a951:0:b0:4a2:acf0:1554 with SMTP id z17-20020a0ca951000000b004a2acf01554mr8702025qva.115.1663973202841;
        Fri, 23 Sep 2022 15:46:42 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4knnqsS3j7k/xo7xq7uc5YnqAb2QAyUrPOQPVgzzeIt5MtETEWirytZ1XgcutqajbAvYbzng==
X-Received: by 2002:a0c:a951:0:b0:4a2:acf0:1554 with SMTP id z17-20020a0ca951000000b004a2acf01554mr8702015qva.115.1663973202687;
        Fri, 23 Sep 2022 15:46:42 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id bp30-20020a05620a459e00b006c479acd82fsm7643222qkb.7.2022.09.23.15.46.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 15:46:42 -0700 (PDT)
Date:   Fri, 23 Sep 2022 18:46:40 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
        andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com,
        pbonzini@redhat.com, zhenyzha@redhat.com, shan.gavin@gmail.com,
        gshan@redhat.com, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 3/6] KVM: x86: Select CONFIG_HAVE_KVM_DIRTY_RING_ORDERED
Message-ID: <Yy43UM/+qTxc+/qt@x1n>
References: <20220922170133.2617189-1-maz@kernel.org>
 <20220922170133.2617189-4-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220922170133.2617189-4-maz@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 22, 2022 at 06:01:30PM +0100, Marc Zyngier wrote:
> Since x86 is TSO (give or take), allow it to advertise the new
> ORDERED version of the dirty ring capability. No other change is
> required for it.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/x86/kvm/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index e3cbd7706136..eb63bc31ed1d 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -29,6 +29,7 @@ config KVM
>  	select HAVE_KVM_PFNCACHE
>  	select HAVE_KVM_IRQFD
>  	select HAVE_KVM_DIRTY_RING
> +	select HAVE_KVM_DIRTY_RING_ORDERED
>  	select IRQ_BYPASS_MANAGER
>  	select HAVE_KVM_IRQ_BYPASS
>  	select HAVE_KVM_IRQ_ROUTING

Before patch 2-3, we only have HAVE_KVM_DIRTY_RING.

After that, we'll have:

HAVE_KVM_DIRTY_LOG
HAVE_KVM_DIRTY_RING
HAVE_KVM_DIRTY_RING_ORDERED

I'm wondering whether we can just keep using the old HAVE_KVM_DIRTY_RING,
but just declare a new KVM_CAP_DIRTY_LOG_RING_ORDERED only after all memory
barrier patches merged (after patch 1).

IIUC it's a matter of whether any of the arch would like to support
!ORDERED version of dirty ring at all, but then IIUC we'll need to have the
memory barriers conditional too or not sure how it'll help.

Thanks,

-- 
Peter Xu

