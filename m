Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A28CC6A96FE
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 13:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbjCCMIK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 07:08:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjCCMIH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 07:08:07 -0500
Received: from out-26.mta1.migadu.com (out-26.mta1.migadu.com [IPv6:2001:41d0:203:375::1a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417D51024B
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 04:08:06 -0800 (PST)
Date:   Fri, 3 Mar 2023 13:08:00 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1677845283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MFvIFOj655htJb0T58EwR5SPuf4Kw8SDISa3u05xsAw=;
        b=lq3eAZqtOX8y1ppEtSrQbQ0RAcPAnrYhNK6RJB0/Sxg54a8WgtmPk0Rfu3EZdbJwDtw9oX
        EVtXQgtsIA0IBl8zdUEqIT+/hnCqx3dFAEEIyDuLscf98gHokKXBXzUvCWZ4NPxjr38RXx
        ux50WsG3ESbNWc3IvyGxaPNX/DQ+7i8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Jean-Philippe Brucker <jpb@kernel.org>
Cc:     Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Itaru Kitayama <itaru.kitayama@gmail.com>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>,
        James Morse <james.morse@arm.com>,
        Joey Gouly <Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Price <steven.price@arm.com>,
        Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.cs.columbia.edu
Subject: Re: [RFC] Support for Arm CCA VMs on Linux
Message-ID: <20230303120800.ahtyc6et77ig4s27@orel>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <Y9PtKJ3Wicc19JF1@myrica>
 <CANW9uyud8RTkqgiL=64wV712QMxtAyubqeyCJ0vpcADJ42VqJA@mail.gmail.com>
 <Y/8Y3WLmiw6+Z5AS@myrica>
 <CANW9uysnvGCwANu+_6dp9+3rvHGOkThT9d0K2qpQV4exdmYWoA@mail.gmail.com>
 <20230303094618.GC361458@myrica>
 <1c91b777-982e-e71a-4829-51744e9555c5@arm.com>
 <20230303113905.GD361458@myrica>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230303113905.GD361458@myrica>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 03, 2023 at 11:39:05AM +0000, Jean-Philippe Brucker wrote:
> On Fri, Mar 03, 2023 at 09:54:47AM +0000, Suzuki K Poulose wrote:
> > On 03/03/2023 09:46, Jean-Philippe Brucker wrote:
> > > On Thu, Mar 02, 2023 at 07:12:24AM +0900, Itaru Kitayama wrote:
> > > > > > I've tried your series in Real on CCA Host, but the KVM arch init
> > > > > > emits an Invalid argument error and terminates.
> > > 
> > > This was the KVM_SET_ONE_REG for the SVE vector size. During my tests I
> > > didn't enable SVE in the host but shrinkwrap enables more options.
> > 
> > Does the Qemu check for SVE capability on /dev/kvm ? For kvmtool, we
> > changed to using the VM instance and that would prevent using SVE,
> > until the RMM supports it.
> 
> Yes, QEMU does check the SVE cap on /dev/kvm. I can propose changing it or
> complementing it with a VM check in my next version, it seems to work
> (though I need to double-check the VM fd lifetime). Same goes for
> KVM_CAP_STEAL_TIME, which I need to disable explicitly at the moment.

I'm probably missing something since I haven't looked at this, but I'm
wondering what the "VM instance" check is and why it should be necessary.
Shouldn't KVM only expose capabilities which it can provide? I.e. the
"VM instance" check should be done by KVM and, when it fails, the SVE and
steal-time capabilities should return 0.

Thanks,
drew
