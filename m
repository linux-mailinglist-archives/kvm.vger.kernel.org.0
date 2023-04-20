Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEE7D6E96E8
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 16:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbjDTOVK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 10:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjDTOVJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 10:21:09 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 744C45594
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 07:20:34 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 94180152B;
        Thu, 20 Apr 2023 07:20:44 -0700 (PDT)
Received: from [10.1.34.43] (010265703453.arm.com [10.1.34.43])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 320363F6C4;
        Thu, 20 Apr 2023 07:20:00 -0700 (PDT)
Message-ID: <6cce1c5d-ab50-41c4-6e62-661bc369d860@arm.com>
Date:   Thu, 20 Apr 2023 15:19:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: RMRR device on non-Intel platform
Content-Language: en-GB
To:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
References: <BN9PR11MB5276E84229B5BD952D78E9598C639@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230420081539.6bf301ad.alex.williamson@redhat.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20230420081539.6bf301ad.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-04-20 15:15, Alex Williamson wrote:
> On Thu, 20 Apr 2023 06:52:01 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
> 
>> Hi, Alex,
>>
>> Happen to see that we may have inconsistent policy about RMRR devices cross
>> different vendors.
>>
>> Previously only Intel supports RMRR. Now both AMD/ARM have similar thing,
>> AMD IVMD and ARM RMR.
> 
> Any similar requirement imposed by system firmware that the operating
> system must perpetually maintain a specific IOVA mapping for the device
> should impose similar restrictions as we've implemented for VT-d
> RMMR[1].  Thanks,

Hmm, does that mean that vfio_iommu_resv_exclude() going to the trouble 
of punching out all the reserved region holes isn't really needed?

Robin.

> 
> Alex
> 
> [1]https://access.redhat.com/sites/default/files/attachments/rmrr-wp1.pdf
> 
>> RMRR identity mapping was considered unsafe (except for USB/GPU) for
>> device assignment:
>>
>> /*
>>   * There are a couple cases where we need to restrict the functionality of
>>   * devices associated with RMRRs.  The first is when evaluating a device for
>>   * identity mapping because problems exist when devices are moved in and out
>>   * of domains and their respective RMRR information is lost.  This means that
>>   * a device with associated RMRRs will never be in a "passthrough" domain.
>>   * The second is use of the device through the IOMMU API.  This interface
>>   * expects to have full control of the IOVA space for the device.  We cannot
>>   * satisfy both the requirement that RMRR access is maintained and have an
>>   * unencumbered IOVA space.  We also have no ability to quiesce the device's
>>   * use of the RMRR space or even inform the IOMMU API user of the restriction.
>>   * We therefore prevent devices associated with an RMRR from participating in
>>   * the IOMMU API, which eliminates them from device assignment.
>>   *
>>   * In both cases, devices which have relaxable RMRRs are not concerned by this
>>   * restriction. See device_rmrr_is_relaxable comment.
>>   */
>> static bool device_is_rmrr_locked(struct device *dev)
>> {
>> 	if (!device_has_rmrr(dev))
>> 		return false;
>>
>> 	if (device_rmrr_is_relaxable(dev))
>> 		return false;
>>
>> 	return true;
>> }
>>
>> Then non-relaxable RMRR device is rejected when doing attach:
>>
>> static int intel_iommu_attach_device(struct iommu_domain *domain,
>>                                       struct device *dev)
>> {
>> 	struct device_domain_info *info = dev_iommu_priv_get(dev);
>> 	int ret;
>>
>> 	if (domain->type == IOMMU_DOMAIN_UNMANAGED &&
>> 	    device_is_rmrr_locked(dev)) {
>> 		dev_warn(dev, "Device is ineligible for IOMMU domain attach due to platform RMRR requirement.  Contact your platform vendor.\n");
>> 		return -EPERM;
>> 	}
>> 	...
>> }
>>
>> But I didn't find the same check in AMD/ARM driver at a glance.
>>
>> Did I overlook some arch difference which makes RMRR device safe in
>> those platforms or is it a gap to be fixed?
>>
>> Thanks
>> Kevin
>>
> 
