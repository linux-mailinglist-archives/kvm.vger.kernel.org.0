Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B991E4A60C9
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 16:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240737AbiBAPxg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 10:53:36 -0500
Received: from foss.arm.com ([217.140.110.172]:48486 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240724AbiBAPxe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 10:53:34 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0D1D711B3;
        Tue,  1 Feb 2022 07:53:34 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 033AB3F40C;
        Tue,  1 Feb 2022 07:53:32 -0800 (PST)
Date:   Tue, 1 Feb 2022 14:57:58 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Martin Radev <martin.b.radev@gmail.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>
Subject: Re: [PATCH kvmtool 3/5] virtio/net: Warn if virtio_net is
 implicitly enabled
Message-ID: <20220201145758.0907f590@donnerap.cambridge.arm.com>
In-Reply-To: <670fbbab84c770292118e9fb00bdfcdf1237678b.1642457047.git.martin.b.radev@gmail.com>
References: <cover.1642457047.git.martin.b.radev@gmail.com>
        <670fbbab84c770292118e9fb00bdfcdf1237678b.1642457047.git.martin.b.radev@gmail.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Jan 2022 00:12:01 +0200
Martin Radev <martin.b.radev@gmail.com> wrote:

Hi,

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

I am a bit unsure about it. We recently tried to get rid of those molly
guard messages, so I am not sure we should issue a *warning* here. After
all, nothing is wrong, it's documented behaviour.

Cheers,
Andre

>  
>  		net_params = (struct virtio_net_params) {
>  			.guest_ip	= kvm->cfg.guest_ip,

