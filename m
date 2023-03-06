Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA496AC201
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 14:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjCFN5j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 08:57:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbjCFN5h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 08:57:37 -0500
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD90F30289
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 05:57:36 -0800 (PST)
Received: by mail-qv1-xf2b.google.com with SMTP id o3so6656063qvr.1
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 05:57:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1678111056;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GmA2ePEzRRQc73jhPODT2wkiXWYmm8Zye+szvA29uao=;
        b=UAuT69Iva6Y5Q9vXW0yORioDG50uwICCfsAQ6iCSfwASQGzx7S8/SDEbtX7HL9mEC1
         kXFA69dsqd9CspV6FwZo3lIxi6RBUh87k+8tHWBH42RFsB4XN2Ez+t64v5pMgYtJZk76
         Obdkhfslj6+yvs4i8rQmo9hw7meTTH+/2dHTFayd7Kbq17LhNVYxb+AK5sIG2h+5DRk3
         DmAzGrWcr2oBerZlBcYaOgrKFfy0yBHanZoZ3Ao2d+H4W7ZbVAAWxg+tje2jsXceibom
         epuEWVgCQFuzdjpamjKA/Xt9ySnszKl8vu/Lphd167yCtPki4r8QfdLW8FBoPj9lm5t6
         X6AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678111056;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GmA2ePEzRRQc73jhPODT2wkiXWYmm8Zye+szvA29uao=;
        b=GHoxaXGsQJJM5wRPVKxczQRC/MfLbU0gEcWGW4ElRSgfOyQ2/x03dX1Ctk3wofWa6Y
         SGWYHh8bBWgDqgxasegJosTw8QE2rzmL3P1RXhUnuhfmAKPdGDld4RIpSyTmfKOrdeS9
         FTcjn/PbHUc1PcxKjKLddapRNoe+hJ4BzSTesTndrTjkvht4T4k6zH90pr86WFfAVXsg
         sludlnea3RMKgJ8dOIthNcqblMhY1Q3DLGKIVtBjYusCh7zEc3waxxbX2pSPbnpFGEF3
         0SCcePGoegHDvxIKUDVHPirAPhVF0yxZu8W9S3LR17YNRpJ8ggRsSODMvNTETrRAc6sr
         +0iw==
X-Gm-Message-State: AO0yUKXUU+XvywYo4P+w8EPY+ewlKuiu+GvA7IQoH2Kjbqc/GK7fy10E
        A+L1IzPcdWHPDcMiWHLtXMOcpg==
X-Google-Smtp-Source: AK7set+xu3a5y5TdFxFDxJnv0QKElNGgr/wZ8g0z/9UIRGa/GPpvhPKo8/RjGkS7BQXZrFfmFpoewg==
X-Received: by 2002:a05:6214:5089:b0:56f:8ef:693 with SMTP id kk9-20020a056214508900b0056f08ef0693mr18088668qvb.0.1678111055926;
        Mon, 06 Mar 2023 05:57:35 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-25-194.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.25.194])
        by smtp.gmail.com with ESMTPSA id u19-20020a05620a121300b007424376ca4bsm7456920qkj.18.2023.03.06.05.57.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 05:57:34 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1pZBLK-00CcHk-6V;
        Mon, 06 Mar 2023 09:57:34 -0400
Date:   Mon, 6 Mar 2023 09:57:34 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "K V P, Satyanarayana" <satyanarayana.k.v.p@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        alex.williamson@redhat.com, cohuck@redhat.com
Subject: Re: [PATCH] vfio/pci: Add DVSEC PCI Extended Config Capability to
 user visible list.
Message-ID: <ZAXxTiWU489dDssW@ziepe.ca>
References: <20230303055426.2299006-1-satyanarayana.k.v.p@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230303055426.2299006-1-satyanarayana.k.v.p@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 03, 2023 at 05:54:26AM +0000, K V P, Satyanarayana wrote:
> Intel Platform Monitoring Technology (PMT) support is indicated by presence
> of an Intel defined PCIe Designated Vendor Specific Extended Capabilities
> (DVSEC) structure with a PMT specific ID.However DVSEC structures may also
> be used by Intel to indicate support for other features. The Out Of Band Management
> Services Module (OOBMSM) uses DVSEC to enumerate several features, including PMT.
> 
> The current VFIO driver does not pass DVSEC capabilities to virtual machine (VM)
> which makes intel_vsec driver not to work in the VM. This series adds DVSEC
> capability to user visible list to allow its use with VFIO.
> 
> Signed-off-by: K V P Satyanarayana <satyanarayana.k.v.p@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_config.c | 8 ++++++++
>  1 file changed, 8 insertions(+)

Wasn't the IDXD/SIOV team proposing to use the fact that DVSEC doesn't
propogate to indicate that IMS doesn't work?

Did this plan get abandoned? It seems at odds with this patch.

Why would you use a "Platform Monitoring Technology" device with VFIO
anyhow?

Honestly I'm a bit reluctant to allow arbitary config space, some of
the stuff people put there can be dangerous.

Jason
