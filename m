Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6385254CD
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 20:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357681AbiELSYq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 14:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357664AbiELSYf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 14:24:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2C862273F70
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 11:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652379870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BUipXYGpzy61gaNTZl1OVqejinDUo/aiIgVccormcMQ=;
        b=Tc22caAx5slfkb5UPwAwVP+Uywg6J1E8xsCdZn1DlyTQzfKNxPWUouP7GzuYVa0275ges4
        7Mf5M0e9ATFklTJGsCVG9SjyRELVNsY1tl4q0vR2CokYqbVLgotvS9jT7NcSKm2ksbz1t8
        pHcnnFZwwYpvDQ4MWaIDIhen2YfeMCY=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-436-YbaWsc_7M564p84zsBXZKA-1; Thu, 12 May 2022 14:24:26 -0400
X-MC-Unique: YbaWsc_7M564p84zsBXZKA-1
Received: by mail-io1-f71.google.com with SMTP id d7-20020a0566022d4700b0065aa0c91f27so3522763iow.14
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 11:24:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=BUipXYGpzy61gaNTZl1OVqejinDUo/aiIgVccormcMQ=;
        b=MX55S4lvROThuGSWwywbmlcWhxBemqgMejDyJSkbLfoNBCltIMBF4AbZvfcJKJAs0H
         qh6H8oG3dI8ny+AsD6OpmnF3YRUbpJgco8KyFCgoPpDu5n3k+kas3C1rtYo61DRojQWL
         sDMoILIiOPt6RNCGQBN/GIAEo7gR0jPVpYkyeR8B/g+hLow0dfFzdgkTKvdzmZC0Rryc
         NP5v7+ZGp+Ok34GX4324w0nITbeq9UXjRsoBIryfBN4I2yLqWO/69frsBvek4lZrpVpa
         eh4d7CquB5c44BXfLs3/20+HUaYSlvj8+GmrvbVMp3fF1tTsAa2zxEgpwAYClZ/G70rA
         Snyw==
X-Gm-Message-State: AOAM533AhlInhaGusJ2l5XEsptjP/eslyiGcWnwUB+M4Ky+OxgBiAtUi
        zCnnjhKTXMEdpqZKJeizchUQ6uqWQTgXKhuawwH2AFAQrXhsxbj6JxrWnpfSJI+2HsOjvqpL0IJ
        KTn2XZrQvsaCy
X-Received: by 2002:a05:6638:130a:b0:32b:b608:1676 with SMTP id r10-20020a056638130a00b0032bb6081676mr701465jad.108.1652379866081;
        Thu, 12 May 2022 11:24:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyT71z4UzaGmdnLfz7oJQ3xNaGnUHjeaEty38FEuwmEm9bJ1H/7jpXzfFOIYD6//DZPSPFKTw==
X-Received: by 2002:a05:6638:130a:b0:32b:b608:1676 with SMTP id r10-20020a056638130a00b0032bb6081676mr701447jad.108.1652379865673;
        Thu, 12 May 2022 11:24:25 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id h23-20020a0566380f9700b0032b3a781751sm71985jal.21.2022.05.12.11.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 11:24:25 -0700 (PDT)
Date:   Thu, 12 May 2022 12:24:24 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v3 0/8] Remove vfio_group from the struct file facing
 VFIO API
Message-ID: <20220512122424.446ee8be.alex.williamson@redhat.com>
In-Reply-To: <20220506162501.457063f6.alex.williamson@redhat.com>
References: <0-v3-f7729924a7ea+25e33-vfio_kvm_no_group_jgg@nvidia.com>
        <20220506162501.457063f6.alex.williamson@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 6 May 2022 16:25:01 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Wed,  4 May 2022 16:14:38 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> ...
> >  virt/kvm/vfio.c                  | 381 ++++++++++++++-----------------
> >  4 files changed, 262 insertions(+), 307 deletions(-)  
> 
> Hi Paolo,
> 
> Reviews obviously welcome here, but all the changes are on the vfio
> side of the interface if you'd like to toss an ack for this series.

Paolo, ping.  Thanks,

Alex

