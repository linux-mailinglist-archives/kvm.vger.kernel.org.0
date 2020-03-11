Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E980181A9B
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 15:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729652AbgCKOAT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 10:00:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:47950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729428AbgCKOAT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 10:00:19 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D44A21D56;
        Wed, 11 Mar 2020 14:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583935218;
        bh=0OhcIcZrD2BAj+IbJhSUJLV6Mv2HMcdowWmdsbMbNhY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hT3EYx6uOpjy1EAwyCTjY6+WpJ5Jl4+nlTYOM1Vi2FQKFukSHtjNZeet9m2Em3MkX
         ypwcs2QckRkoy2Vw4PJxXmM1eFw+8XI4FBzqmEwoVmOzFY8DCKKfvQwJttcf4jjYi+
         b1nE90aNOKAZrzYelCvCXhL5i4jKplfAXywUiTgc=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jC1uC-00BvZI-Lr; Wed, 11 Mar 2020 14:00:16 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 11 Mar 2020 14:00:16 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Auger Eric <eric.auger@redhat.com>
Cc:     Zenghui Yu <yuzenghui@huawei.com>, eric.auger.pro@gmail.com,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org, drjones@redhat.com,
        andre.przywara@arm.com, peter.maydell@linaro.org,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v5 10/13] arm/arm64: ITS: INT functional
 tests
In-Reply-To: <46f0ed1d-3bda-f91b-e2b0-addf1c61c373@redhat.com>
References: <20200310145410.26308-1-eric.auger@redhat.com>
 <20200310145410.26308-11-eric.auger@redhat.com>
 <d3f651a0-2344-4d6e-111b-be133db7e068@huawei.com>
 <46f0ed1d-3bda-f91b-e2b0-addf1c61c373@redhat.com>
Message-ID: <301a8b402ff7e480e927b0f8f8b093f2@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: eric.auger@redhat.com, yuzenghui@huawei.com, eric.auger.pro@gmail.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org, drjones@redhat.com, andre.przywara@arm.com, peter.maydell@linaro.org, alexandru.elisei@arm.com, thuth@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-03-11 13:48, Auger Eric wrote:
> Hi Zenghui,
> 
> On 3/11/20 12:59 PM, Zenghui Yu wrote:
>> Hi Eric,
>> 
>> On 2020/3/10 22:54, Eric Auger wrote:
>>> Triggers LPIs through the INT command.
>>> 
>>> the test checks the LPI hits the right CPU and triggers
>>> the right LPI intid, ie. the translation is correct.
>>> 
>>> Updates to the config table also are tested, along with inv
>>> and invall commands.
>>> 
>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>> 
>>> ---
>> 
>> [...]
>> 
>>> +static void test_its_trigger(void)
>>> +{
>>> +    struct its_collection *col3, *col2;
>>> +    struct its_device *dev2, *dev7;
>>> +
>>> +    if (its_prerequisites(4))
>>> +        return;
>>> +
>>> +    dev2 = its_create_device(2 /* dev id */, 8 /* nb_ites */);
>>> +    dev7 = its_create_device(7 /* dev id */, 8 /* nb_ites */);
>>> +
>>> +    col3 = its_create_collection(3 /* col id */, 3/* target PE */);
>>> +    col2 = its_create_collection(2 /* col id */, 2/* target PE */);
>>> +
>>> +    gicv3_lpi_set_config(8195, LPI_PROP_DEFAULT);
>>> +    gicv3_lpi_set_config(8196, LPI_PROP_DEFAULT);
>>> +
>>> +    its_send_invall(col2);
>>> +    its_send_invall(col3);
>> 
>> These two INVALLs should be issued after col2 and col3 are mapped,
>> otherwise this will cause the INVALL command error as per the spec
>> (though KVM doesn't complain it at all).
> Yes you're right. reading the spec again:
> 
> A command error occurs if any of the following apply:
> ../..
> The collection specified by ICID has not been mapped to an RDbase using
> MAPC.
> 
> But as mentionned in the cover letter, no real means to retrieve the
> error at the moment.

That is still a problem with the ITS. There is no architectural way
to report an error, even if the error numbers are architected...

One thing we could do though is to implement the stall model (as 
described
in 5.3.2). It still doesn't give us the error, but at least the command
queue would stop on detecting an error.

         M.
-- 
Jazz is not dead. It just smells funny...
