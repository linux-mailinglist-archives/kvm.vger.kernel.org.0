Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83C04A602D
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 16:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240423AbiBAPbq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 10:31:46 -0500
Received: from foss.arm.com ([217.140.110.172]:47204 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233563AbiBAPbq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 10:31:46 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D88E4113E;
        Tue,  1 Feb 2022 07:31:45 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0482A3F40C;
        Tue,  1 Feb 2022 07:31:44 -0800 (PST)
Date:   Tue, 1 Feb 2022 15:31:53 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Martin Radev <martin.b.radev@gmail.com>
Cc:     kvm@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com
Subject: Re: [PATCH kvmtool 3/5] virtio/net: Warn if virtio_net is implicitly
 enabled
Message-ID: <YflSTJ0BlC14QK/o@monolith.localdoman>
References: <cover.1642457047.git.martin.b.radev@gmail.com>
 <670fbbab84c770292118e9fb00bdfcdf1237678b.1642457047.git.martin.b.radev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <670fbbab84c770292118e9fb00bdfcdf1237678b.1642457047.git.martin.b.radev@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Martin,

On Tue, Jan 18, 2022 at 12:12:01AM +0200, Martin Radev wrote:
> The virtio_net device is implicitly enabled if user doesn't
> explicitly specify that virtio_net is disabled. This is
> counter-intuitive to how the rest of the virtio commandline
> works.
> 
> For backwards-compatibility, the commandline parameters are
> not changed. Instead, this patch prints out a warning if
> virtio_net is implicitly enabled.
> 
> Signed-off-by: Martin Radev <martin.b.radev@gmail.com>
> ---
>  virtio/net.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/virtio/net.c b/virtio/net.c
> index 9a25bfa..ab75d40 100644
> --- a/virtio/net.c
> +++ b/virtio/net.c
> @@ -1002,6 +1002,9 @@ int virtio_net__init(struct kvm *kvm)
>  
>  	if (kvm->cfg.num_net_devices == 0 && kvm->cfg.no_net == 0) {
>  		static struct virtio_net_params net_params;
> +		pr_warning(
> +			"No net devices configured, but no_net not specified. "
> +			"Enabling virtio_net with default network settings...\n");

I don't think this deserves a warning, as there's nothing inherently wrong
with having a default network device. In fact, this is quite helpful for
users who  want to get a VM up and running without complicated setup. I do
agree that at the moment there's nothing to let the user know that a virtio
network device is being created, not in the usage synopsis for the lkvm run
command, nor in the man page for kvmtool, but I don't think that printing a
warning is the solution here.

What I suggest is that instead you print the virtual network interface
parameters that can be useful for a user to know (like IP address and
netmask, or whatever you think might be useful) using pr_debug() after
virtio_net__init_one() is called successfully below.

Thanks,
Alex

>  
>  		net_params = (struct virtio_net_params) {
>  			.guest_ip	= kvm->cfg.guest_ip,
> -- 
> 2.25.1
> 
