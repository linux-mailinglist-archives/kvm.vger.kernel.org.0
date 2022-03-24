Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80A54E6859
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 19:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236368AbiCXSI0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 14:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236126AbiCXSIZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 14:08:25 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762EEB6E65;
        Thu, 24 Mar 2022 11:06:52 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id p8so4567761pfh.8;
        Thu, 24 Mar 2022 11:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=va6vB0JxaeEC/9iYPBXdEorJ6d/FgW4lIryhnUZxEn8=;
        b=HWEQ5au8ofgr8daab02R4CLe5wfB7+XNGyC/qTPF+vbNamIIdvtzVYJH/yeNDPah5H
         zHCjZUcz0Gm3jgnM9mjyIygMHl2mAX9cafsxTwn2GRkjlAXukGRgMczAvjfTdsj+iIQ5
         rRqODA67hnV+atDl7NNH57+moI3ulEG9UM8kiQT94JVPQZfeR+4UdP/f8pi8H5zu57tf
         AEbz/THuxjNqjIgtqpHh6Slk4EXvdcuUE91S3Qjh9vMZuNy8tL2mzxML5WtYOXTZgCQ5
         jy0JPfizWmRtsgySF7RUYctMGGvdA9AGxmD4K4w+p2l5oLY0Wr77A5jUbsBh+bNE3QRy
         Vh8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=va6vB0JxaeEC/9iYPBXdEorJ6d/FgW4lIryhnUZxEn8=;
        b=X9Fv4g6srOAFsaKnj6ERazNPMOUXxHBbdFX5moytBHiR7FIA3B5V6p1fLZD3sp9Wi1
         5Yf1pyaTfWvqm14flxKX5nblBTvZHb2H2MXmVsL8PIu2FQv4TVNlmpluEGZBb9WSY+E7
         vKf0P78aCtn8HdTPs70xOrOnfMtfa1P2ofs8W8WmAOESVt6CzmFmdGHIerIS+johvmrm
         0KBYB+bEp9PF82bqJZfifkge90v94FXzQdpAY+SkVZcG+33xXhggywfI2tje+Zw39cpn
         pT8QEbptiHMplcK5Cq4lrQGu/q9Zn4MAu2iq89c4k5WPQnLvDe7hDh4xevItvw/n6O0X
         yDRg==
X-Gm-Message-State: AOAM531mNrxhVpAkDBk+34Au005Dj+ytZWmeDiYmjKvDiesrLI4pbpeS
        izQiELtzxNm1qexv2EuY16o=
X-Google-Smtp-Source: ABdhPJxaYrCHoLMfqT4lC+q0cokWmSpoK8lXGReoONjQAWNtNYJtPiRHIe73DUDHVEEY4qf8BpOu0Q==
X-Received: by 2002:a05:6a00:228f:b0:4fa:e4c9:7b3b with SMTP id f15-20020a056a00228f00b004fae4c97b3bmr5926163pfe.61.1648145211800;
        Thu, 24 Mar 2022 11:06:51 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id z14-20020aa7888e000000b004f79f59827asm4054292pfe.139.2022.03.24.11.06.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 11:06:51 -0700 (PDT)
Date:   Thu, 24 Mar 2022 11:06:48 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dave.hansen@intel.com, seanjc@google.com, pbonzini@redhat.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, ak@linux.intel.com, dan.j.williams@intel.com,
        isaku.yamahata@intel.com, isaku.yamahata@gmail.com
Subject: Re: [PATCH v2 13/21] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Message-ID: <20220324180648.GB1212881@ls.amr.corp.intel.com>
References: <cover.1647167475.git.kai.huang@intel.com>
 <bb38ed2511163fbd2026680e23e9b27223a99ab8.1647167475.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb38ed2511163fbd2026680e23e9b27223a99ab8.1647167475.git.kai.huang@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 13, 2022 at 11:49:53PM +1300,
Kai Huang <kai.huang@intel.com> wrote:

> diff --git a/arch/x86/virt/vmx/tdx.c b/arch/x86/virt/vmx/tdx.c
> index 1939b64d23e8..c58c99b94c72 100644
> --- a/arch/x86/virt/vmx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx.c
> @@ -21,6 +21,7 @@
>  #include <asm/cpufeatures.h>
>  #include <asm/virtext.h>
>  #include <asm/e820/api.h>
> +#include <asm/pgtable.h>
>  #include <asm/tdx.h>
>  #include "tdx.h"
>  
> @@ -66,6 +67,16 @@
>  #define TDMR_START(_tdmr)	((_tdmr)->base)
>  #define TDMR_END(_tdmr)		((_tdmr)->base + (_tdmr)->size)
>  
> +/* Page sizes supported by TDX */
> +enum tdx_page_sz {
> +	TDX_PG_4K = 0,
> +	TDX_PG_2M,
> +	TDX_PG_1G,
> +	TDX_PG_MAX,
> +};
> +
> +#define TDX_HPAGE_SHIFT	9
> +
>  /*
>   * TDX module status during initialization
>   */
> @@ -893,7 +904,7 @@ static int create_tdmrs(struct tdmr_info **tdmr_array, int *tdmr_num)
>  	 * them.  To keep it simple, always try to use one TDMR to cover
>  	 * one RAM entry.
>  	 */
> -	e820_for_each_mem(e820_table, i, start, end) {
> +	e820_for_each_mem(i, start, end) {

This patch doesn't change e820_for_each_mem.  This hunk should go into the
previous patch?

thansk,

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
