Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21B4C7C6FAF
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 15:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378739AbjJLNuW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 09:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343859AbjJLNuU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 09:50:20 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9CB6D7
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 06:50:18 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id af79cd13be357-77575531382so61627685a.3
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 06:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1697118618; x=1697723418; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LnL6Hnef2NasdmdBgZGxwmWpqimetY/l8WjQZjAdJ28=;
        b=DABMWPwpBXw305KNDg6onlTw9KiIz6scYsOiVXwH2xVhZTlRTsdpKakbofMh9ZO0iI
         ejtleNRwNqMTIfefvtysEgj4vxZ5cJZ1BkOVmD2CWdTBNgB6+lm2hFDGwjlzSWEoMMfM
         0MmBOcFyeSso9tJaVIEN2Z1kmJb6BoVNBdnjoaubNxUIHgqx9jLY1gAz8yBNOQ2uD2BA
         oiZl/DmwtxjaGrQGtEsb50BEINQNeEMz92bCh4joXaq5s43kANk85STEXjwajQ1rly89
         1IskapWXKgsq9Gf9F2x2GdFWQif9VwiTkx2+ZMzDlUbVj22gaK8Tmsz5C/66GE2cTRBe
         1QRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697118618; x=1697723418;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LnL6Hnef2NasdmdBgZGxwmWpqimetY/l8WjQZjAdJ28=;
        b=VUETgJma4DIShQx/fuXDR8rDoaN31s9TP7JouqGoE4Y/bVhLbl+BifbpctWhf0EGU0
         eMDoEN3LM733ain71cSIbFmBH7lZR2NiPsjCpv4+tLQj4ndLVUP0hJrODe6n4jhjAguH
         NC1rNvYEI4BDlZV41sH+DsSYFkjvOuMtRMZS7Hdjfe2UhPXFngTqZwUIOYdQfazE94h5
         JLTBfDsOk/k1MZLKNxPMfO320/ozE5lwPalQbbGbCL4nAy0SYnoNhKC+Yi2VYidZX+6z
         idAa8ZxQsvFa4pb34157tJLnLUYe1MQdPFkWpYAaq/chO2Do5K5orKBlUgsL7+hxKjwM
         PnDA==
X-Gm-Message-State: AOJu0YzIfP73hrN1/5ULqT+K2LcuzrTqMqFoSYmU+bK3hMMSfVg9tZXq
        qxBQIWLGKn4DE4hkjJC8AZad6g==
X-Google-Smtp-Source: AGHT+IHRiGoFwFv2FYMS1d7JQeLsjrqR5yecWQjBMOOK2SnAreo0qN3NXTS57EzrnG/Mal6+CvR4sg==
X-Received: by 2002:a05:6214:240e:b0:66d:1edd:1d4c with SMTP id fv14-20020a056214240e00b0066d1edd1d4cmr406180qvb.14.1697118618028;
        Thu, 12 Oct 2023 06:50:18 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-26-201.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.26.201])
        by smtp.gmail.com with ESMTPSA id p9-20020a0cf549000000b0065b17ec4b49sm6654706qvm.46.2023.10.12.06.50.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Oct 2023 06:50:17 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qqw4u-0018jt-UD;
        Thu, 12 Oct 2023 10:50:16 -0300
Date:   Thu, 12 Oct 2023 10:50:16 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     Brett Creeley <brett.creeley@amd.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "dan.carpenter@linaro.org" <dan.carpenter@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: Re: [PATCH v2 vfio 2/3] pds/vfio: Fix mutex lock->magic != lock
 warning
Message-ID: <20231012135016.GJ55194@ziepe.ca>
References: <20231011230115.35719-1-brett.creeley@amd.com>
 <20231011230115.35719-3-brett.creeley@amd.com>
 <591f90f071454dcd82d8de1178241e3c@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <591f90f071454dcd82d8de1178241e3c@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 12, 2023 at 09:00:09AM +0000, Shameerali Kolothum Thodi wrote:

> > Also, don't destroy the mutex on close because the device may
> > be re-opened, which would cause mutex to be uninitialized. Fix this by
> > implementing a driver specific vfio_device_ops.release callback that
> > destroys the mutex before calling vfio_pci_core_release_dev().
> > 
> > Signed-off-by: Brett Creeley <brett.creeley@amd.com>
> > Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
> 
> Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> 
> Looks like mutex destruction logic needs to be added to HiSilicon driver as well.
> From a quick look mlx5 also doesn't destroy the state_mutex.

FWIW, mutex_destroy is a debugging feature, it is nice if you can do it, but
not a bug if it is missing..

Jason
