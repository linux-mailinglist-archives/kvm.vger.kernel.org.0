Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEFE4C44FE
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 13:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240780AbiBYMyT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 07:54:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiBYMyS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 07:54:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE751B3087;
        Fri, 25 Feb 2022 04:53:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 010D161BA7;
        Fri, 25 Feb 2022 12:53:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0045C340E7;
        Fri, 25 Feb 2022 12:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645793625;
        bh=jjBQuBeYq3qaMfp8i+UQXNPw/kN4Q0Mg9LOFbd3gysI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WCqPyv+zxFiY8sTgXAyj29WG6lI03Iz69wsxSc+15tnqswX0riTTvEfZUxrt8mwSV
         9LLMZC8I58YC5Qz2ABrJuPRBtA9AMXnxt8BWoqfg7Kf9kv9LjvOftd3Jo/x5XXoWx5
         8K1QzTydyvwSibjqZEn4XR9T5DWR4VCvlolaH0B4=
Date:   Fri, 25 Feb 2022 13:53:43 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        adrian@parity.io, ardb@kernel.org, ben@skyportsystems.com,
        berrange@redhat.com, colmmacc@amazon.com, decui@microsoft.com,
        dwmw@amazon.co.uk, ebiggers@kernel.org, ehabkost@redhat.com,
        graf@amazon.com, haiyangz@microsoft.com, imammedo@redhat.com,
        jannh@google.com, kys@microsoft.com, lersek@redhat.com,
        linux@dominikbrodowski.net, mst@redhat.com, qemu-devel@nongnu.org,
        raduweis@amazon.com, sthemmin@microsoft.com, tytso@mit.edu,
        wei.liu@kernel.org
Subject: Re: [PATCH v4] virt: vmgenid: introduce driver for reinitializing
 RNG on VM fork
Message-ID: <YhjRVz2184xhkZK3@kroah.com>
References: <CAHmME9pJ3wb=EbUErJrCRC=VYGhFZqj2ar_AkVPsUvAnqGtwwg@mail.gmail.com>
 <20220225124848.909093-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220225124848.909093-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 25, 2022 at 01:48:48PM +0100, Jason A. Donenfeld wrote:
> +static struct acpi_driver acpi_driver = {
> +	.name = "vmgenid",
> +	.ids = vmgenid_ids,
> +	.owner = THIS_MODULE,
> +	.ops = {
> +		.add = vmgenid_acpi_add,
> +		.notify = vmgenid_acpi_notify,
> +	}
> +};
> +
> +static int __init vmgenid_init(void)
> +{
> +	return acpi_bus_register_driver(&acpi_driver);
> +}
> +
> +static void __exit vmgenid_exit(void)
> +{
> +	acpi_bus_unregister_driver(&acpi_driver);
> +}
> +
> +module_init(vmgenid_init);
> +module_exit(vmgenid_exit);

Nit, you could use module_acpi_driver() to make this even smaller if you
want to.

thanks,

greg k-h
