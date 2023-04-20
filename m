Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C96B6E96D3
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 16:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbjDTOQ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 10:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232043AbjDTOQa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 10:16:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3275040C2
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 07:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682000143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KHtItohlMimKkEP2hNqh88Wn+W8r/ovnf3iKQc3h81A=;
        b=H4NYihIZMQYIkKSrBg8DZDSFjdcz3h94iLUlJhWj2yVOrO7Lk2USipRTM+TGFhrWER53cf
        ehWuYbiUHK0GtuIw2qw3QJvWScpBLEWYv3j3KmDz3/tLZkjY6lRCy3jZjjbeu+m/SSQ/FU
        FuG3OKwBQdkkfdyPJQr6D8wkk6DZdNg=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-d1TnzQ4sPFiEcURZKpiJJw-1; Thu, 20 Apr 2023 10:15:41 -0400
X-MC-Unique: d1TnzQ4sPFiEcURZKpiJJw-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7636c775952so92463539f.2
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 07:15:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682000141; x=1684592141;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KHtItohlMimKkEP2hNqh88Wn+W8r/ovnf3iKQc3h81A=;
        b=Fb+F5NvnjzEyXJuWm6ospS2ZtbR8CQzeUyzqg42zX9ajzv+INNPgLgFlcB+0jNknJ5
         9bV2OB8Qa1QcfVG1Qw2vGJqdi62VvHaIVMm4OQ6mTPt4/cWl1hFSBv7t+EjSjOuqtOTZ
         BHio4sfqqtSv09qRPA6ZJzdF92ZZDd8Uut3ZjcGhbBzmOx2wlHqmzL1Mc4PjA3crib8N
         LOfnDmER6G6spEuQffJ2yhNAVgzPjzqjeB/+d9hHrv7j+/jrstD+N32yGlos1gp2rvRw
         I0K9cTowdWAF5FtTZ/NQURk6NA8EM9l4iFvZKJWTttnncsRMKdfLHOA0RjA/zPejkHcN
         EJxQ==
X-Gm-Message-State: AAQBX9dc+uqMtT+649VRIimUtIu3Kji1Dn0PVr9rMOIpAXT3nkCwsFCa
        YkZDni5Mp4KS3baQmSkv9u2v6GDzrKGvW/TIN0AvtehRlG7YYdQzvZFBfSNFka6mypJusWlWG0m
        wrdo1GBqn9v0w
X-Received: by 2002:a6b:5b0f:0:b0:760:a07c:322a with SMTP id v15-20020a6b5b0f000000b00760a07c322amr1371844ioh.19.1682000141066;
        Thu, 20 Apr 2023 07:15:41 -0700 (PDT)
X-Google-Smtp-Source: AKy350bU+94qs0c104x1ZVxCUmrOc+6uqD7OfuljJGoS19DxMv5FUHNvmQAXcSEjbtCs06eAoy6hLQ==
X-Received: by 2002:a6b:5b0f:0:b0:760:a07c:322a with SMTP id v15-20020a6b5b0f000000b00760a07c322amr1371826ioh.19.1682000140759;
        Thu, 20 Apr 2023 07:15:40 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id z7-20020a05660200c700b00760f8bae7aasm453392ioe.51.2023.04.20.07.15.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 07:15:40 -0700 (PDT)
Date:   Thu, 20 Apr 2023 08:15:39 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: Re: RMRR device on non-Intel platform
Message-ID: <20230420081539.6bf301ad.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB5276E84229B5BD952D78E9598C639@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <BN9PR11MB5276E84229B5BD952D78E9598C639@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 20 Apr 2023 06:52:01 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> Hi, Alex,
> 
> Happen to see that we may have inconsistent policy about RMRR devices cross
> different vendors.
> 
> Previously only Intel supports RMRR. Now both AMD/ARM have similar thing,
> AMD IVMD and ARM RMR.

Any similar requirement imposed by system firmware that the operating
system must perpetually maintain a specific IOVA mapping for the device
should impose similar restrictions as we've implemented for VT-d
RMMR[1].  Thanks,

Alex

[1]https://access.redhat.com/sites/default/files/attachments/rmrr-wp1.pdf

> RMRR identity mapping was considered unsafe (except for USB/GPU) for
> device assignment:
> 
> /*
>  * There are a couple cases where we need to restrict the functionality of
>  * devices associated with RMRRs.  The first is when evaluating a device for
>  * identity mapping because problems exist when devices are moved in and out
>  * of domains and their respective RMRR information is lost.  This means that
>  * a device with associated RMRRs will never be in a "passthrough" domain.
>  * The second is use of the device through the IOMMU API.  This interface
>  * expects to have full control of the IOVA space for the device.  We cannot
>  * satisfy both the requirement that RMRR access is maintained and have an
>  * unencumbered IOVA space.  We also have no ability to quiesce the device's
>  * use of the RMRR space or even inform the IOMMU API user of the restriction.
>  * We therefore prevent devices associated with an RMRR from participating in
>  * the IOMMU API, which eliminates them from device assignment.
>  *
>  * In both cases, devices which have relaxable RMRRs are not concerned by this
>  * restriction. See device_rmrr_is_relaxable comment.
>  */
> static bool device_is_rmrr_locked(struct device *dev)
> {
> 	if (!device_has_rmrr(dev))
> 		return false;
> 
> 	if (device_rmrr_is_relaxable(dev))
> 		return false;
> 
> 	return true;
> }
> 
> Then non-relaxable RMRR device is rejected when doing attach:
> 
> static int intel_iommu_attach_device(struct iommu_domain *domain,
>                                      struct device *dev)
> {
> 	struct device_domain_info *info = dev_iommu_priv_get(dev);
> 	int ret;
> 
> 	if (domain->type == IOMMU_DOMAIN_UNMANAGED &&
> 	    device_is_rmrr_locked(dev)) {
> 		dev_warn(dev, "Device is ineligible for IOMMU domain attach due to platform RMRR requirement.  Contact your platform vendor.\n");
> 		return -EPERM;
> 	}
> 	...
> }
> 
> But I didn't find the same check in AMD/ARM driver at a glance.
> 
> Did I overlook some arch difference which makes RMRR device safe in
> those platforms or is it a gap to be fixed?
> 
> Thanks
> Kevin
> 

