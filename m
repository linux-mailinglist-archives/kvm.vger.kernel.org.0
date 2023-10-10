Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF9F57BF9D3
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 13:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbjJJLfO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 07:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbjJJLfN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 07:35:13 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D50A4;
        Tue, 10 Oct 2023 04:35:11 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9AB1C433C8;
        Tue, 10 Oct 2023 11:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1696937711;
        bh=Dgl0erwYB9qFKvNeOVGhClGJ2XJSfTqlW8vQXJ16jwE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lo18jUpaQDYGWwjRo5pwiCs8yx9ipILrzsSMZQ0R0MKZzc6ICJSPpb+hEl5NdWk4K
         XoSQaYMpxaNs78W/9Vqy2uDV4djSIQUaE8o+k8DgbLH3Ze2Eu8AgM5LRcwXhDZsX2z
         g/o6YR/zmdh2S04QblPAcSQ879RY7ZPv2YrU0p6c=
Date:   Tue, 10 Oct 2023 13:35:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?Q?Jos=E9?= Pekkarinen <jose.pekkarinen@foxhound.fi>
Cc:     seanjc@google.com, pbonzini@redhat.com, skhan@linuxfoundation.org,
        dave.hansen@linux.intel.com, kvm@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, tglx@linutronix.de,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] kvm/sev: make SEV/SEV-ES asids configurable
Message-ID: <2023101050-scuff-overstay-9b43@gregkh>
References: <20231010100441.30950-1-jose.pekkarinen@foxhound.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231010100441.30950-1-jose.pekkarinen@foxhound.fi>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 10, 2023 at 01:04:39PM +0300, José Pekkarinen wrote:
> There are bioses that doesn't allow to configure the
> number of asids allocated for SEV/SEV-ES, for those
> cases, the default behaviour allocates all the asids
> for SEV, leaving no room for SEV-ES to have some fun.

"fun"?

Also, please use the full 72 columns for your changelog.

> If the user request SEV-ES to be enabled, it will
> find the kernel just run out of resources and ignored
> user request. This following patch will address this
> issue by making the number of asids for SEV/SEV-ES
> configurable over kernel module parameters.
> 
> Signed-off-by: José Pekkarinen <jose.pekkarinen@foxhound.fi>
> ---
>  arch/x86/kvm/svm/sev.c | 28 +++++++++++++++++++++++-----
>  1 file changed, 23 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 07756b7348ae..68a63b42d16a 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -51,9 +51,18 @@
>  static bool sev_enabled = true;
>  module_param_named(sev, sev_enabled, bool, 0444);
>  
> +/* nr of asids requested for SEV */
> +static unsigned int requested_sev_asids;
> +module_param_named(sev_asids, requested_sev_asids, uint, 0444);
> +
>  /* enable/disable SEV-ES support */
>  static bool sev_es_enabled = true;
>  module_param_named(sev_es, sev_es_enabled, bool, 0444);
> +
> +/* nr of asids requested for SEV-ES */
> +static unsigned int requested_sev_es_asids;
> +module_param_named(sev_es_asids, requested_sev_asids, uint, 0444);

Why more module parameters?  Why can't this "just work" properly without
forcing a user to make manual changes?  This isn't the 1990's anymore.


> +
>  #else
>  #define sev_enabled false
>  #define sev_es_enabled false
> @@ -2194,6 +2203,11 @@ void __init sev_hardware_setup(void)
>  	if (!max_sev_asid)
>  		goto out;
>  
> +	if (requested_sev_asids + requested_sev_es_asids > max_sev_asid) {
> +		pr_info("SEV asids requested more than available: %u ASIDs\n", max_sev_asid);

Why isn't this an error?

thanks,

greg k-h
