Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81E617277E2
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 08:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235079AbjFHGz4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 02:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235095AbjFHGzx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 02:55:53 -0400
Received: from out-28.mta0.migadu.com (out-28.mta0.migadu.com [91.218.175.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BABD2710
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 23:55:50 -0700 (PDT)
Date:   Thu, 8 Jun 2023 08:55:47 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686207349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k3KMHnpd2ZzjfRif/hU+3cx4/hEhz5i2adNVw9xhrJ0=;
        b=Joun3AfbUWBU+5cBtTJl0MGsrjPlKS/Jzcbw+gM4QVfrZCF2D1UEeFAjDoXEFNTYiO4Sbb
        Ejq4IjJmY9rGni7aKiKEMSyZne7vZ+RYcXFT2PixjGbeDs4YN8+lBgogOxDSkHRdF+Y7TZ
        5dmRxUWrISJ7iz8AF1uqZ1ETCF/f+EI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
        alexandru.elisei@arm.com, ricarkol@google.com, shahuang@redhat.com
Subject: Re: [kvm-unit-tests PATCH v6 19/32] lib/efi: Add support for reading
 an FDT
Message-ID: <20230608-315a460eea93647e2514114c@orel>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
 <20230530160924.82158-20-nikos.nikoleris@arm.com>
 <20230607-3bd9b31f3687e53e944e69d3@orel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607-3bd9b31f3687e53e944e69d3@orel>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 07, 2023 at 06:58:22PM +0200, Andrew Jones wrote:
> On Tue, May 30, 2023 at 05:09:11PM +0100, Nikos Nikoleris wrote:
> ...
> > +static void* efi_get_var(efi_handle_t handle, struct efi_loaded_image_64 *image, efi_char16_t *var)
> > +{
> > +	efi_status_t status = EFI_SUCCESS;
> > +	void *val = NULL;
> > +	uint64_t val_size = 100;
> > +	efi_guid_t efi_var_guid = EFI_VAR_GUID;
> > +
> > +	while (efi_grow_buffer(&status, &val, val_size))
> > +		status = efi_rs_call(get_variable, var, &efi_var_guid, NULL, &val_size, val);
> > +
> > +	return val;
> > +}
> 
> I made the following changes to the above function
> 
>     @@ lib/efi.c: static char *efi_convert_cmdline(struct efi_loaded_image_64 *image, i
>      +  uint64_t val_size = 100;
>      +  efi_guid_t efi_var_guid = EFI_VAR_GUID;
>      +
>     -+  while (efi_grow_buffer(&status, &val, val_size))
>     ++  while (efi_grow_buffer(&status, &val, val_size + 1))

I just fixed this fix by changing the '+ 1' to '+ sizeof(efi_char16_t)'
and then force pushed arm/queue.

Thanks,
drew

>      +          status = efi_rs_call(get_variable, var, &efi_var_guid, NULL, &val_size, val);
>      +
>     ++  if (val)
>     ++          ((efi_char16_t *)val)[val_size / sizeof(efi_char16_t)] = L'\0';
>     ++
>      +  return val;
>      +}
>      +
> 
> Before ensuring the dtb pathname was nul-terminated efi_load_image()
> was reading garbage and unable to find the dtb file.
> 
> Thanks,
> drew
> 
> 
> > +
> > +static void *efi_get_fdt(efi_handle_t handle, struct efi_loaded_image_64 *image)
> > +{
> > +	efi_char16_t var[] = ENV_VARNAME_DTBFILE;
> > +	efi_char16_t *val;
> > +	void *fdt = NULL;
> > +	int fdtsize;
> > +
> > +	val = efi_get_var(handle, image, var);
> > +	if (val)
> > +		efi_load_image(handle, image, &fdt, &fdtsize, val);
> > +
> > +	return fdt;
> > +}
> > +
> >  efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
> >  {
> >  	int ret;
> > @@ -211,6 +330,7 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
> >  	}
> >  	setup_args(cmdline_ptr);
> >  
> > +	efi_bootinfo.fdt = efi_get_fdt(handle, image);
> >  	/* Set up efi_bootinfo */
> >  	efi_bootinfo.mem_map.map = &map;
> >  	efi_bootinfo.mem_map.map_size = &map_size;
> > -- 
> > 2.25.1
> > 
