Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A86B6E9793
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 16:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbjDTOuC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 10:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233098AbjDTOt7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 10:49:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4103C49F3
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 07:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682002150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EUb3YvO/wIrjR5ODzmimb+GAFSaZ6gkz0JLMjhCNuXo=;
        b=EX8+Kc0HCjEcLB7RrmNrxk3ynrWRhzthTM/hz+1FYByGTLMuPgXM9hNyCPJ0wb91XjJ0Ts
        RjqUZua8Yyg2dpaIN8l7S1G1I2TlaIYMLYE1GMokUcqmp882LXUJ9smgcWcT928VPJn0fP
        SnDVvJubsLgJL9rsTCYuySzkqcG2Zwo=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-WumiwFj1N_OxdcgMIVA_lw-1; Thu, 20 Apr 2023 10:49:09 -0400
X-MC-Unique: WumiwFj1N_OxdcgMIVA_lw-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-32b42b751bcso6145875ab.3
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 07:49:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682002148; x=1684594148;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EUb3YvO/wIrjR5ODzmimb+GAFSaZ6gkz0JLMjhCNuXo=;
        b=f35eYUyF/iPumkV78UBXcopHRbKFlJ7wqiN7G9i2P/hhWjwFPTmEB8jPfJGis9R/qr
         ZYbum36FgpYWuGGkoHAEocx71o1MY+PPN5z0oXLJ9g9hpO+2oSlLsTw3QqawfxhK4uSL
         UKyfgBrQhsp5qKLwtfDellq6/t/PLk9XX4ep8WsZNg8wT4RjaPh7CI3wUmNl/YjAlb0n
         EQEVO4jUOySA53kSzJ0QtnQJ/6jNoigW5Sk26tZzXHwBqMOywC7wWwF4pVBQBONe/TZ0
         378/XiAAtZawnpgcmWwnyAgv+0KHK/LAnqSVrCiVnmBrl3jfRx0vA+SqEeVmT9hHMQFP
         eq8Q==
X-Gm-Message-State: AAQBX9dVdgAQX/A9C0HOig4efZiV/BctpBEyHU5vV4DZZkuuFc4aAmb5
        2J89E2Hq4iqLcruL9yUBhUDbAe4LOsJlBdePTfWoo1SbvPmaAslerEGoZpkIN8sXJkiACJXMdrF
        s1aA6LWGLUvigzyQSTAZ1
X-Received: by 2002:a92:a30a:0:b0:32b:6433:668f with SMTP id a10-20020a92a30a000000b0032b6433668fmr1405434ili.4.1682002148443;
        Thu, 20 Apr 2023 07:49:08 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZM4/NPXZvDqlpTo2XPVjWlGmQ+vov+dMQ64Rg338eTxD/JAqaVGnP8msaPqebeE2XRFKNAHA==
X-Received: by 2002:a92:a30a:0:b0:32b:6433:668f with SMTP id a10-20020a92a30a000000b0032b6433668fmr1405423ili.4.1682002148139;
        Thu, 20 Apr 2023 07:49:08 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id 127-20020a021185000000b0040fb5d5429fsm537563jaf.131.2023.04.20.07.49.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 07:49:07 -0700 (PDT)
Date:   Thu, 20 Apr 2023 08:49:06 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
Subject: Re: RMRR device on non-Intel platform
Message-ID: <20230420084906.2e4cce42.alex.williamson@redhat.com>
In-Reply-To: <6cce1c5d-ab50-41c4-6e62-661bc369d860@arm.com>
References: <BN9PR11MB5276E84229B5BD952D78E9598C639@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20230420081539.6bf301ad.alex.williamson@redhat.com>
        <6cce1c5d-ab50-41c4-6e62-661bc369d860@arm.com>
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

On Thu, 20 Apr 2023 15:19:55 +0100
Robin Murphy <robin.murphy@arm.com> wrote:

> On 2023-04-20 15:15, Alex Williamson wrote:
> > On Thu, 20 Apr 2023 06:52:01 +0000
> > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> >   
> >> Hi, Alex,
> >>
> >> Happen to see that we may have inconsistent policy about RMRR devices cross
> >> different vendors.
> >>
> >> Previously only Intel supports RMRR. Now both AMD/ARM have similar thing,
> >> AMD IVMD and ARM RMR.  
> > 
> > Any similar requirement imposed by system firmware that the operating
> > system must perpetually maintain a specific IOVA mapping for the device
> > should impose similar restrictions as we've implemented for VT-d
> > RMMR[1].  Thanks,  
> 
> Hmm, does that mean that vfio_iommu_resv_exclude() going to the trouble 
> of punching out all the reserved region holes isn't really needed?

While "Reserved Memory Region Reporting", might suggest that the ranges
are simply excluded, RMRR actually require that specific mappings are
maintained for ongoing, side-band activity, which is not compatible
with the ideas that userspace owns the IOVA address space for the
device or separation of host vs userspace control of the device.  Such
mappings suggest things like system health monitoring where the
influence of a user-owned device can easily extend to a system-wide
scope if the user it able to manipulate the device to deny that
interaction or report bad data.

If these ARM and AMD tables impose similar requirements, we should
really be restricting devices encumbered by such requirements from
userspace access as well.  Thanks,

Alex

> > [1]https://access.redhat.com/sites/default/files/attachments/rmrr-wp1.pdf
> >   
> >> RMRR identity mapping was considered unsafe (except for USB/GPU) for
> >> device assignment:
> >>
> >> /*
> >>   * There are a couple cases where we need to restrict the functionality of
> >>   * devices associated with RMRRs.  The first is when evaluating a device for
> >>   * identity mapping because problems exist when devices are moved in and out
> >>   * of domains and their respective RMRR information is lost.  This means that
> >>   * a device with associated RMRRs will never be in a "passthrough" domain.
> >>   * The second is use of the device through the IOMMU API.  This interface
> >>   * expects to have full control of the IOVA space for the device.  We cannot
> >>   * satisfy both the requirement that RMRR access is maintained and have an
> >>   * unencumbered IOVA space.  We also have no ability to quiesce the device's
> >>   * use of the RMRR space or even inform the IOMMU API user of the restriction.
> >>   * We therefore prevent devices associated with an RMRR from participating in
> >>   * the IOMMU API, which eliminates them from device assignment.
> >>   *
> >>   * In both cases, devices which have relaxable RMRRs are not concerned by this
> >>   * restriction. See device_rmrr_is_relaxable comment.
> >>   */
> >> static bool device_is_rmrr_locked(struct device *dev)
> >> {
> >> 	if (!device_has_rmrr(dev))
> >> 		return false;
> >>
> >> 	if (device_rmrr_is_relaxable(dev))
> >> 		return false;
> >>
> >> 	return true;
> >> }
> >>
> >> Then non-relaxable RMRR device is rejected when doing attach:
> >>
> >> static int intel_iommu_attach_device(struct iommu_domain *domain,
> >>                                       struct device *dev)
> >> {
> >> 	struct device_domain_info *info = dev_iommu_priv_get(dev);
> >> 	int ret;
> >>
> >> 	if (domain->type == IOMMU_DOMAIN_UNMANAGED &&
> >> 	    device_is_rmrr_locked(dev)) {
> >> 		dev_warn(dev, "Device is ineligible for IOMMU domain attach due to platform RMRR requirement.  Contact your platform vendor.\n");
> >> 		return -EPERM;
> >> 	}
> >> 	...
> >> }
> >>
> >> But I didn't find the same check in AMD/ARM driver at a glance.
> >>
> >> Did I overlook some arch difference which makes RMRR device safe in
> >> those platforms or is it a gap to be fixed?
> >>
> >> Thanks
> >> Kevin
> >>  
> >   
> 

