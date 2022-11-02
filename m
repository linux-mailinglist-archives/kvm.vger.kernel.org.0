Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33CDD61699F
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 17:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbiKBQr7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 12:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231947AbiKBQrk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 12:47:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F56BF52
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 09:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667407400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fTFZdSVqI0N+O3i56sH80q79jqwRkWzhFiqZV68haTk=;
        b=RvBWXnVQjs/BeBa3GnnpAK1GoR48nB1uLqZtxe1eRf0+Uo8c3I3K5A1As5oU5cGRKIMSFn
        ZlYWObRs/aQIbg/mivfHw36NYA//lJIYNdg5yon5GDaGazBn7usvtESH5fnn5JHZY1zErF
        Y+rUO0fbFMs5v8MqFdijL65TsWXz+Yc=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-399-Hmj9QwozP_qVxPABoP3elA-1; Wed, 02 Nov 2022 12:43:19 -0400
X-MC-Unique: Hmj9QwozP_qVxPABoP3elA-1
Received: by mail-qt1-f199.google.com with SMTP id a19-20020a05622a02d300b0039a3711179dso12527270qtx.12
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 09:43:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fTFZdSVqI0N+O3i56sH80q79jqwRkWzhFiqZV68haTk=;
        b=Wt6AVlBj//a14hiTMOobVxbQovXv7KGeudtyYkiehQLTnHlPJCEY12KMZJL6/8kged
         molZRp6dicboL0IgBjeZU/LDoT2Om1AWKKL3anatZen1XpFpi6IqnkxZvZwBHIUgDAQj
         yisaw/94ULfP3IK9mcq4yZB/sVAlE6gzCeSjCfE8Hh7B0bKQkDRRRk18Fc3F9H3P4jBS
         VgwbDPPxodC/AiUwHbUfQZXRMMtngorwfjHP8Ic7gebyrTvHXb/nxrJrG8yBVvacv9WV
         irdJ9oiqy5lm0c/ifKdkk5OkGt9mDDdkorcYYJRoHNpFw5yR19cGlReU2B0OvmV20MMo
         ckmg==
X-Gm-Message-State: ACrzQf1Xwnpz5DoLJDOPgMc9VCiPh6gCX4m5kmcnc1ho6uiYQpzpPR37
        /eoSoYf03UIMkq46sqVu9fyZvABDsRbepBYYlXQ5FSFuVH18QNyDrG3m5TbwIZND5E5Zk6qzos7
        0TM9Mlc0pcddk
X-Received: by 2002:a37:5586:0:b0:6fa:39c4:2ca9 with SMTP id j128-20020a375586000000b006fa39c42ca9mr10011512qkb.247.1667407399318;
        Wed, 02 Nov 2022 09:43:19 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4/rvQXdCAyIe0HFz95uUEGgTNvP6HVoipjnQ1WNKjj3y50tjMcIRaYfVVUhCu1DT+83sBt5A==
X-Received: by 2002:a37:5586:0:b0:6fa:39c4:2ca9 with SMTP id j128-20020a375586000000b006fa39c42ca9mr10011503qkb.247.1667407399083;
        Wed, 02 Nov 2022 09:43:19 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id f16-20020ac80690000000b0035ce8965045sm6757917qth.42.2022.11.02.09.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 09:43:18 -0700 (PDT)
Date:   Wed, 2 Nov 2022 12:43:16 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Gavin Shan <gshan@redhat.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
        ajones@ventanamicro.com, bgardon@google.com,
        catalin.marinas@arm.com, dmatlack@google.com, will@kernel.org,
        pbonzini@redhat.com, oliver.upton@linux.dev, james.morse@arm.com,
        shuah@kernel.org, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v7 1/9] KVM: x86: Introduce KVM_REQ_DIRTY_RING_SOFT_FULL
Message-ID: <Y2KeJGYUxnOOcXMj@x1n>
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-2-gshan@redhat.com>
 <Y2F17Y7YG5Z9XnOJ@google.com>
 <Y2J+xhBYhqBI81f7@x1n>
 <867d0de4b0.wl-maz@kernel.org>
 <Y2KZdDAQN4889W9V@x1n>
 <Y2Kby0yXu0/Zi2P1@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y2Kby0yXu0/Zi2P1@google.com>
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 02, 2022 at 04:33:15PM +0000, Sean Christopherson wrote:
> On Wed, Nov 02, 2022, Peter Xu wrote:
> > Might be slightly off-topic: I didn't quickly spot how do we guarantee two
> > threads doing KVM_RUN ioctl on the same vcpu fd concurrently.  I know
> > that's insane and could have corrupted things, but I just want to make sure
> > e.g. even a malicious guest app won't be able to trigger host warnings.
> 
> kvm_vcpu_ioctl() takes the vCPU's mutex:
> 
> static long kvm_vcpu_ioctl(struct file *filp,
> 			   unsigned int ioctl, unsigned long arg)
> {
> 	...
> 
> 	/*
> 	 * Some architectures have vcpu ioctls that are asynchronous to vcpu
> 	 * execution; mutex_lock() would break them.
> 	 */
> 	r = kvm_arch_vcpu_async_ioctl(filp, ioctl, arg);
> 	if (r != -ENOIOCTLCMD)
> 		return r;
> 
> 	if (mutex_lock_killable(&vcpu->mutex))
> 		return -EINTR;
> 	switch (ioctl) {
> 	case KVM_RUN: {

Ah, makes sense, thanks!

-- 
Peter Xu

