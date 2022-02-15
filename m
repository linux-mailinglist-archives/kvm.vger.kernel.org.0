Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADBD54B6CBE
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 13:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233998AbiBOMxT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 07:53:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232760AbiBOMxP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 07:53:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0CE15205C1
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 04:53:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644929585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k3LaYVmXlDDI4cCdjtUd/PNJ1ur2w6Wmc9rP2novD74=;
        b=U7n7meQ4/+s/QkYtPpLJ6/U9tNx3ymTb2y8A4NbPKk7ldxc1ebjbAU1+CcJqqMa58aac73
        ZeLOQmXPbWkPECtzACH01igo83xUA3cB0Y5B7su6uQdVL7QCoM8K9oPFdvsocGNEbVCBq7
        pc4gCkqjSVQeWDpHXAyTy+Q84nEHRns=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-McQozc2jNUK4VAcMQvEkPA-1; Tue, 15 Feb 2022 07:53:03 -0500
X-MC-Unique: McQozc2jNUK4VAcMQvEkPA-1
Received: by mail-ej1-f69.google.com with SMTP id sa22-20020a1709076d1600b006ce78cacb85so2376199ejc.2
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 04:53:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k3LaYVmXlDDI4cCdjtUd/PNJ1ur2w6Wmc9rP2novD74=;
        b=NzMhWpDMthI7hox+XrgBJ5kXn7ksh8uqjZbDnj1hFBtKSaKM1trgderB00yQkj2+US
         DEYv/ytMqR40wVqFyxrSBzd3+kF7di+7LWgsaz8Dc4Vm/vtC26RfzrJs6aoIM3hLy149
         DL1DKfzsUo3rRkiXn0DcJnKyHVfa+NcQBsaaZRzNKd4LuKAzETSEtbqQkdOT2wD+1Bh4
         2Vt+RDxCiogaGDeI/OIUl3zXGkBCQUUJiXH/0jLAGEytCl/Yu3BqKBvEYRdoxeoFv1lY
         dWdenzb0QZRsjnaAXP6i+IrnccbRWrTqWtmh+JHpF25HsZdO1UsXdSkhGdG5mzTI64dP
         ta6g==
X-Gm-Message-State: AOAM532+0Dc2N7FypLuJazQY3WH4zCEPT4tEpUyt/PlQOEf2U37ktemi
        FEgrkO4KuKyQziCT7wi2Qaq4WjqS+czfL467XMrjPk2Uguv/RL+VYoj8lHEr3aOtbkkvL93Xy/S
        xYO6oHXWwShhS
X-Received: by 2002:a17:907:2d08:: with SMTP id gs8mr2968438ejc.106.1644929582845;
        Tue, 15 Feb 2022 04:53:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzFXKUrgCdrDtZ6C8DaK/lbWSixiyPDRl8e5+HHXCtoljbyEz+QJO6Le4dOJMjK4J9yRtBjew==
X-Received: by 2002:a17:907:2d08:: with SMTP id gs8mr2968428ejc.106.1644929582661;
        Tue, 15 Feb 2022 04:53:02 -0800 (PST)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id q19sm10241696ejm.74.2022.02.15.04.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 04:53:02 -0800 (PST)
Date:   Tue, 15 Feb 2022 13:53:00 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Marc Zyngier <maz@kernel.org>, pbonzini@redhat.com,
        thuth@redhat.com, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] lib/devicetree: Support 64 bit addresses
 for the initrd
Message-ID: <20220215125300.6b5ff3luxikc4jhd@gator>
References: <20220214120506.30617-1-alexandru.elisei@arm.com>
 <20220214135226.joxzj2tgg244wl6n@gator>
 <YgphzKLQLb5pMYoP@monolith.localdoman>
 <20220214142444.saeogrpgpx6kaamm@gator>
 <YgqBPSV+CMyzfNlv@monolith.localdoman>
 <87k0dx4c23.wl-maz@kernel.org>
 <20220215073212.fp5lh4gfxk7clwwc@gator>
 <Ygt7PbS6zW9H1By4@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ygt7PbS6zW9H1By4@monolith.localdoman>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 15, 2022 at 10:07:16AM +0000, Alexandru Elisei wrote:
> 
> I've started working on the next iteration of the kvmtool test
> runner support series, I'll do my best to make sure kvmtool wll be able to run
> the tests when kvm-unit-tests has been configured with --arch=arm.
>

Excellent!

BTW, I went ahead an pushed a patch to misc/queue to improve the initrd
address stuff

https://gitlab.com/rhdrjones/kvm-unit-tests/-/commit/6f8f74ed2d9953830a3c74669f25439d9ad68dec

It may be necessary for you if kvmtool shares its fdt creation between
aarch64 and aarch32 guests, emitting 8 byte initrd addresses for both,
even though the aarch32 guest puts the fdt below 4G.

Thanks,
drew

