Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 187467250EB
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 01:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240001AbjFFXoO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 19:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234333AbjFFXoL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 19:44:11 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A01170E;
        Tue,  6 Jun 2023 16:44:10 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-64d44b198baso44839b3a.0;
        Tue, 06 Jun 2023 16:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686095050; x=1688687050;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mEZkIZY9Q7jTP/McBQstCS6PR169uMprlxbbas5+TgM=;
        b=n8hRF4MSiRkNfUvc8i87aRrACp6giMIbhGu+lCaOcY3T23RWe5R6yTEszIukbeyMSm
         weqnE4w2TVNcK7Sym65s37htsxfSTQ/p4IVGtkQX89lCAsXIo8LQCJw4Ln+2dSQZjlVs
         NXwKWSS4mgrfrUqtDtiqCjJmRNPKNQm83Si4eJqbPy0OXr8gkBQJ9LTxaFjLOhwzLbFP
         bliYMmczVVHC9vw1KKOnUH+EAMqRe1jsqINbip5WMtCFYkR4nUI8kIUB1QhyZ8YDt+HA
         LUFg+4G4GsMey4PlvtzlYgg24NGT9EuoIn+Ze44Dz0kBIbKNHB6mjrSOFREAVXPZdcCr
         KnVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686095050; x=1688687050;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mEZkIZY9Q7jTP/McBQstCS6PR169uMprlxbbas5+TgM=;
        b=bNIWSJ5HrhY2F6wFQNINRr755s0o4SRxGL4xwzJJa2JD51ybpYPnq7QAvAzZ0dK6Y3
         +WhPp4qmR1LFujXZ1oQSGFp5aCGPjbj4iZ8WMBmakbsmcyPLSGWv5NeZGNp3bg7OeDIr
         9x+ei1/Stk71s6bI+ovUP0OW2YKE7axsDg+p1a2ZLo9WR8DuL7Iuj0GDWqIk2zrZHxhc
         sTRFWj0HS4Fh36wO7xOdh//mY2k/k8Ybk8QfhWmpN0tNtQVoPqTUQIjorcfnW5WB12r+
         egGm+QaBaMGthjSCJ32x0Sq7XYNndV1z/okTra4rCg9VkxgyaV08RwyZErGqUzF2AOb+
         srJQ==
X-Gm-Message-State: AC+VfDxMSC28cd9MWgtFeBWRnj5s9lOd5RO/46hNOfF1x7Rc7cLWg9YF
        6L1Ak+RIhqiBMycIy6sq2Vg=
X-Google-Smtp-Source: ACHHUZ6ELRc9CiQE6xiKHl+27ELaDVpnZylJ3B8xbEzOwiolUc5ZwT/a+AYfyajhlDYhqp+nzXt2qw==
X-Received: by 2002:a05:6a00:238e:b0:65c:d458:cedc with SMTP id f14-20020a056a00238e00b0065cd458cedcmr3508063pfc.12.1686095049540;
        Tue, 06 Jun 2023 16:44:09 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id b20-20020aa78114000000b00660f0e4da6esm1302157pfi.183.2023.06.06.16.44.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 16:44:09 -0700 (PDT)
Date:   Tue, 6 Jun 2023 16:44:07 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com, isaku.yamahata@gmail.com
Subject: Re: [PATCH v11 02/20] x86/virt/tdx: Detect TDX during kernel boot
Message-ID: <20230606234407.GC2244082@ls.amr.corp.intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
 <af4e428ab1245e9441031438e606c14472daf927.1685887183.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <af4e428ab1245e9441031438e606c14472daf927.1685887183.git.kai.huang@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023 at 02:27:15AM +1200,
Kai Huang <kai.huang@intel.com> wrote:
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> new file mode 100644
> index 000000000000..2d91e7120c90
> --- /dev/null
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -0,0 +1,92 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright(c) 2023 Intel Corporation.
> + *
> + * Intel Trusted Domain Extensions (TDX) support
> + */
> +
> +#define pr_fmt(fmt)	"tdx: " fmt
> +
> +#include <linux/types.h>
> +#include <linux/cache.h>
> +#include <linux/init.h>
> +#include <linux/errno.h>
> +#include <linux/printk.h>
> +#include <asm/msr-index.h>
> +#include <asm/msr.h>
> +#include <asm/tdx.h>
> +
> +static u32 tdx_global_keyid __ro_after_init;
> +static u32 tdx_guest_keyid_start __ro_after_init;
> +static u32 tdx_nr_guest_keyids __ro_after_init;
> +
> +static int __init record_keyid_partitioning(u32 *tdx_keyid_start,
> +					    u32 *nr_tdx_keyids)
> +{
> +	u32 _nr_mktme_keyids, _tdx_keyid_start, _nr_tdx_keyids;
> +	int ret;
> +
> +	/*
> +	 * IA32_MKTME_KEYID_PARTIONING:
> +	 *   Bit [31:0]:	Number of MKTME KeyIDs.
> +	 *   Bit [63:32]:	Number of TDX private KeyIDs.
> +	 */
> +	ret = rdmsr_safe(MSR_IA32_MKTME_KEYID_PARTITIONING, &_nr_mktme_keyids,
> +			&_nr_tdx_keyids);
> +	if (ret)
> +		return -ENODEV;
> +
> +	if (!_nr_tdx_keyids)
> +		return -ENODEV;
> +
> +	/* TDX KeyIDs start after the last MKTME KeyID. */
> +	_tdx_keyid_start = _nr_mktme_keyids + 1;
> +
> +	*tdx_keyid_start = _tdx_keyid_start;
> +	*nr_tdx_keyids = _nr_tdx_keyids;
> +
> +	return 0;
> +}
> +
> +static int __init tdx_init(void)
> +{
> +	u32 tdx_keyid_start, nr_tdx_keyids;
> +	int err;
> +
> +	err = record_keyid_partitioning(&tdx_keyid_start, &nr_tdx_keyids);
> +	if (err)
> +		return err;
> +
> +	pr_info("BIOS enabled: private KeyID range [%u, %u)\n",
> +			tdx_keyid_start, tdx_keyid_start + nr_tdx_keyids);
> +
> +	/*
> +	 * The TDX module itself requires one 'global KeyID' to protect
> +	 * its metadata.  If there's only one TDX KeyID, there won't be
> +	 * any left for TDX guests thus there's no point to enable TDX
> +	 * at all.
> +	 */
> +	if (nr_tdx_keyids < 2) {
> +		pr_info("initialization failed: too few private KeyIDs available.\n");

Because this case is against the admin expectation, pr_warn() or pr_err()?
Except that, looks good to me
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
