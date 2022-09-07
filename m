Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E03225B02F4
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 13:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbiIGLd3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 07:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbiIGLd1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 07:33:27 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF3DBB69F0;
        Wed,  7 Sep 2022 04:33:25 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A8A4E1042;
        Wed,  7 Sep 2022 04:33:31 -0700 (PDT)
Received: from [10.57.15.197] (unknown [10.57.15.197])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 63EA73F7B4;
        Wed,  7 Sep 2022 04:33:20 -0700 (PDT)
Message-ID: <4ca6383e-bd21-59bf-cc4e-cf3313164957@arm.com>
Date:   Wed, 7 Sep 2022 12:33:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [RFC PATCH v3 4/7] bus/cdx: add cdx-MSI domain with gic-its
 domain as parent
Content-Language: en-GB
To:     Marc Zyngier <maz@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
Cc:     Nipun Gupta <nipun.gupta@amd.com>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, gregkh@linuxfoundation.org,
        rafael@kernel.org, eric.auger@redhat.com,
        alex.williamson@redhat.com, cohuck@redhat.com,
        puneet.gupta@amd.com, song.bao.hua@hisilicon.com,
        mchehab+huawei@kernel.org, f.fainelli@gmail.com,
        jeffrey.l.hugo@gmail.com, saravanak@google.com,
        Michael.Srba@seznam.cz, mani@kernel.org, yishaih@nvidia.com,
        will@kernel.org, joro@8bytes.org, masahiroy@kernel.org,
        ndesaulniers@google.com, linux-arm-kernel@lists.infradead.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, kvm@vger.kernel.org, okaya@kernel.org,
        harpreet.anand@amd.com, nikhil.agarwal@amd.com,
        michal.simek@amd.com, aleksandar.radovanovic@amd.com, git@amd.com
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220906134801.4079497-1-nipun.gupta@amd.com>
 <20220906134801.4079497-5-nipun.gupta@amd.com> <YxeBCsA32jnwMjSj@nvidia.com>
 <87leqvv3g7.wl-maz@kernel.org>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <87leqvv3g7.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-11.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-09-07 12:17, Marc Zyngier wrote:
> On Tue, 06 Sep 2022 18:19:06 +0100,
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>>
>> On Tue, Sep 06, 2022 at 07:17:58PM +0530, Nipun Gupta wrote:
>>
>>> +static void cdx_msi_write_msg(struct irq_data *irq_data,
>>> +			      struct msi_msg *msg)
>>> +{
>>> +	/*
>>> +	 * Do nothing as CDX devices have these pre-populated
>>> +	 * in the hardware itself.
>>> +	 */
>>> +}
>>
>> Huh?
>>
>> There is no way it can be pre-populated, the addr/data pair,
>> especially on ARM, is completely under SW control.
> 
> There is nothing in the GIC spec that says that.
> 
>> There is some commonly used IOVA base in Linux for the ITS page, but
>> no HW should hardwire that.
> 
> That's not strictly true. It really depends on how this block is
> integrated, and there is a number of existing blocks that know *in HW*
> how to signal an LPI.
> 
> See, as the canonical example, how the mbigen driver doesn't need to
> know about the address of GITS_TRANSLATER.
> 
> Yes, this messes with translation (the access is downstream of the
> SMMU) if you relied on it to have some isolation, and it has a "black
> hole" effect as nobody can have an IOVA that overlaps with the
> physical address of the GITS_TRANSLATER register.
> 
> But is it illegal as per the architecture? No. It's just stupid.

If that were the case, then we'd also need a platform quirk so the SMMU 
driver knows about it. Yuck.

But even then, are you suggesting there is some way to convince the ITS 
driver to allocate a specific predetermined EventID when a driver 
requests an MSI? Asking for a friend...

Cheers,
Robin.
