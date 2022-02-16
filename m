Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C30484B873F
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 13:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232252AbiBPMAU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 07:00:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbiBPMAT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 07:00:19 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 85E371907E2
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 04:00:07 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EEE35D6E;
        Wed, 16 Feb 2022 04:00:06 -0800 (PST)
Received: from e120937-lin (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E43323F718;
        Wed, 16 Feb 2022 04:00:05 -0800 (PST)
Date:   Wed, 16 Feb 2022 11:59:55 +0000
From:   Cristian Marussi <cristian.marussi@arm.com>
To:     kvm@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com
Cc:     andre.przywara@arm.com, sudeep.holla@arm.com,
        alexandru.elisei@arm.com, james.morse@arm.com
Subject: Re: [RFC PATCH kvmtool 0/2] Introduce VirtIO SCMI Device support
Message-ID: <20220216115955.GB6072@e120937-lin>
References: <20211115101401.21685-1-cristian.marussi@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115101401.21685-1-cristian.marussi@arm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 15, 2021 at 10:13:59AM +0000, Cristian Marussi wrote:
> Hi,
> 
> this short series aims mainly to introduce support (in [01/02]) for the
> emulation of a VirtIO SCMI Device as per the VirtIO specification in [1].
> 
> Afterwards, as a related but independent patch, general support for
> FDT Overlays is also added in [02/02], since this latter is needed to
> craft more complex DT configurations needed from time to time with SCMI
> for testing/development purposes.
> 
> Generally, ARM SCMI protocol [2] defines how an SCMI platform server can
> talk with a number of SCMI Agents (like a Linux Kernel implementing the
> SCMI stack) to manage and control various aspects of System power and
> performance.
> 
> An SCMI Platform firmware could already reside in a number of places and,
> with the recent addition of a VirtIO transport layer in the Linux SCMI
> stack, the SCMI backend can also be deployed in a virtualized environment,
> represented by an emulated VirtIO SCMI Device.
> 
> Since it is clearly not advisable/sensible to implement the whole SCMI
> Server backend logic inside kvmtool (i.e. the SCMI fw), the proposed
> emulated SCMI device will indeed act as 'proxy' device, routing the
> VirtIO SCMI traffic received from the guest OSPM SCMI Agent virtqueues
> back and forth to some external userspace application (acting as an SCMI
> Server) via Unix sockets.
> 
> The aim of this addition to kvmtool is to provide an easy way to debug
> and test the SCMI Kernel stack in the guest during development, so that it
> should be possible to exercise the Kernel SCMI stack without the need to
> have a fully compliant SCMI hw and fw in place: the idea is to be able to
> use as the FW userspace emulation backend (reachable via Unix sockets), a
> simpler stripped down SCMI server supporting only mocked HW and easily
> extendable but also simply configurable to misbehave at will at the SCMI
> protocol level.
> 
> For testing purposes using such a simplified server should be easier than
> using a fully compliant one when it comes to:
> 
>  - implement a new protocol support backend to test the Kernel brand new
>    implementation before some official full SCMI fw support is made
>    available (if ever in case of custom vendor protocols)
> 
>  - mock a variety of fake HW for testing purposes without worrying about
>    real HW (all is mocked really...)
>  
> - force some sort of misbehaviour at the SCMI protocol layer to test
>   the robustness of the Kernel implementation (i.e. late/duplicated/
>   unexpected/out-of-order/malformed SCMI Replies): a fully fledged
>   official SCMI Server implementation is NOT meant/designed to misbehave
>   so it's harder to make it do it.
> 
> The reason I'm posting this as an RFC is mainly because of the usage of
> the custom Unix sockets interface to relay SCMI messages to userspace: this
> is easier and is sufficient for our testing/development scenario above, but
> it is clearly a non standard approach: a more standard way would be to use
> the vhost-user protocol to negotiate the direct sharing of the SCMI vqueues
> between the guest and the userspace FW emulation.
> 
> Such alternative solution would have the main advantage to be able to
> interface also with the standard full fledged SCP SCMI Firmware Server
> (for validation purposes ?) which is recently adding support [3] to be run
> as a vhost-user server: the drawback instead would be the added complexity
> to kvmtool and especially to the simplified userspace SCMI emulation server
> I was blabbing about above (and the fact that the whole vhost-user support
> would have to be added to kvmtool at first and I'm not sure if that is
> something wanted given its nature of an hack tool...but I'd be happy to
> add it if deemed sensible instead...)
> 
> Based on kvmtool:
> 
> commit 39181fc6429f ("vfio/pci: Align MSIX Table and PBA size to guest
> 		      maximum page size")
> 
> Any feedback welcome !
> 
> Thanks,
> Cristian
>

Hi,

after a quick offline discussion with Alexandru (thanks !) it's agreed
that this series should not be merged upstream for now given the current
lack of a generally available and open source SCMI userspace server
backend implementation that can talk with the SCMI proxy device
introduced by this series.

Thanks,
Cristian
