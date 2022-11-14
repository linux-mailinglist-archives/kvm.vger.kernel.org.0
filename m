Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 200ED62840A
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 16:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236409AbiKNPfu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 10:35:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235865AbiKNPfr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 10:35:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515771170
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 07:34:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668440090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uIYsp2CMqcl3IrQ1oHH+TSbURbMTeeY6ds0mSGnvSOU=;
        b=arsl6KddQAB1aQL8CLYjgZdQ90k6LEkYoZvCoz4wW2Ik7B6uofcw/mWtmBJFOg/X15zf1u
        Uc2ASOJKrhh5ZUpP3D7J9UtP5uiaXFtaNlB01CqoGuhknI26N1KujOYgW7IlbPerJxRgxC
        Fphu8BGQCcjJ62N1Mjg+60MBzuCmxvM=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-346-0ilVXsRqNCGUDHsBcTDAGA-1; Mon, 14 Nov 2022 10:34:48 -0500
X-MC-Unique: 0ilVXsRqNCGUDHsBcTDAGA-1
Received: by mail-io1-f72.google.com with SMTP id g13-20020a056602072d00b006c60d59110fso5888010iox.12
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 07:34:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uIYsp2CMqcl3IrQ1oHH+TSbURbMTeeY6ds0mSGnvSOU=;
        b=A/uJl2xey+YmXdDojEBxP0FDpmiNyyA93cOhk/mt6nHPNulT3aC3zdJmejNtDZZ0As
         acoyeOOTIylhkitV0wGTE+AktjQCR3tAFmL7gLMMPCc5SjfPQcNYlos7SUbGdBCoVU/c
         wiZoEIZ2M4V5YIOBQW+vnlOViBSPznMUt8Mz47p8qEt6h2duWJijJnIk7AAd480MOlnJ
         ZjWE/ze2S0fonuMhpAcZjHMSEtyPIkZA6ILXHuvSTql9eDL/JjOvmR61Wj5WOSWC9L10
         Yg+vas6d+kDuj7/2Kup+ihCv1ZSTRcrMLLEaoEy9fikSPNRXeEAxUFeOLxYiRig/qWZL
         skMQ==
X-Gm-Message-State: ANoB5pkP3UQbT2rZLOyPQiM7Q6y4eFAYF6LBs/D8MMHOp6XSCb3oAnWv
        zNy1fygkTKQcX8sEDdScHbNy3Vg8+OzaCzx3DYOqOsod7E2Yfg0oE7TEiK0Gv3vgl3AJHBfYLZZ
        30Fy8TibDm0Uz
X-Received: by 2002:a02:a40c:0:b0:375:2cae:9821 with SMTP id c12-20020a02a40c000000b003752cae9821mr6070332jal.239.1668440088234;
        Mon, 14 Nov 2022 07:34:48 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6lltTTK14TjI0Kkp/Kg9GH86JynYsk0CK0HvZsscfu9ND2PHusPpPnWAso4jOBIplgBc/ccQ==
X-Received: by 2002:a02:a40c:0:b0:375:2cae:9821 with SMTP id c12-20020a02a40c000000b003752cae9821mr6070324jal.239.1668440088018;
        Mon, 14 Nov 2022 07:34:48 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id z10-20020a05660229ca00b006ddb3b698ffsm3900212ioq.23.2022.11.14.07.34.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 07:34:47 -0800 (PST)
Date:   Mon, 14 Nov 2022 08:34:46 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Gupta, Nipun" <Nipun.Gupta@amd.com>
Cc:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Anand, Harpreet" <harpreet.anand@amd.com>
Subject: Re: IRQ affinity from VFIO API interface
Message-ID: <20221114083446.5a1cba71.alex.williamson@redhat.com>
In-Reply-To: <DM6PR12MB3082B79FA197958F10F61205E8059@DM6PR12MB3082.namprd12.prod.outlook.com>
References: <DM6PR12MB3082B79FA197958F10F61205E8059@DM6PR12MB3082.namprd12.prod.outlook.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 14 Nov 2022 10:29:14 +0000
"Gupta, Nipun" <Nipun.Gupta@amd.com> wrote:

> [AMD Official Use Only - General]
> 
> Hi Alex, Cornelia and other VFIO experts,
> 
> We are using VFIO for the user-space applications (like DPDK) and need
> control to affine MSI interrupts to a particular CPU. One of the ways to
> affine interrupts are to use /proc/interrupts interface and set the smp_affinity,
> but we could not locate any API interface in VFIO from where this can be done.
> 
> Can you please let me know if there is any other way to provide the CPU
> affinity, or does it seem legitimate to update "struct vfio_irq_set" to support
> the above said functionality.

There is currently no way to set interrupt affinity via the vfio API.
You're welcome to propose something.  Thanks,

Alex

