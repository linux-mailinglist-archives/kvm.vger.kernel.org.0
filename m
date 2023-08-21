Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC4DE7835CC
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 00:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbjHUWas (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 18:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231587AbjHUWar (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 18:30:47 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85EC133
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 15:30:40 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1bdbbede5d4so29970175ad.2
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 15:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692657040; x=1693261840;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nNPzaFzeYLsSfgRlWm4jcR7ku+ZIkaKbn5zIZ6TjKtY=;
        b=pzvPd8tmhLGnA1NIqaWnNAu7ROyL7dNs/agavNLrdKuHf2F54+ZiBCdeys0WG3DlBf
         el9IGjmbNeiL/HCaKLSZ1g6wruUAlE/CqYyg+nCwRuN1lPOWn3M6KbDU34Yuq8XyQHv0
         VQdCHtiZqTJ+ieR9ls9FQeklmE/NswJ1gFxsFM1mnlxcB0gcHO+uy/XskHSNPin6G0uI
         vdPNmvXwRYgMBPgR+3Lrhj2ZCOBgvBqToMsdenqQBzEMwz0rVsR/EuCFjaSBbHbQk6mI
         /155oVL8bhN6ztVI2Sg2HpSPXjbQeD7v2oSWuWJqNi7M7DijUPzixEiGRD7p2Ngv/k/8
         AbaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692657040; x=1693261840;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nNPzaFzeYLsSfgRlWm4jcR7ku+ZIkaKbn5zIZ6TjKtY=;
        b=AHVj3pYTeBFJCj3k6RRiKUu+pyqAYXLA4WNoCbo5Zl38U/z9fWMaOiAsC/NXjo4mbT
         yQyKrMbCpqpskcjgiDzCOPV5hH1K9Uf/Ja0Znr4li857uZa1+6RYqu5KUDD8ndeNI5EC
         Q8Hv+7Zj6Q4Y/T1xz8510B5EzbTV3e/e9ftmqNJjkOxyxpzDF/oS9K4bxL6f7A+tHfjx
         9mDJakm2QsV9fizHa+9lhDzc69pKF1VUiN4QNqLuqKxMx+D6VkoMQWGQrW2al9HdTLEz
         W7H83ppb918fAw3NtlSoYD0RpCe/JkgppmVCd46B2wqrgYWwDCkW2SkHJkMG+b/7aQoH
         DDQg==
X-Gm-Message-State: AOJu0YyLxohv91uWxsCTUP9vs8NCgf9CufDjvnZTveRCWA4x6KPArnlq
        0sriSG9yK/4IfdVm8htAEaw=
X-Google-Smtp-Source: AGHT+IGzfcemV/qSVwWRmG53F6Lzz+WBODZzzn6pWTlhZnymN0nr+ZQgh107vhpIB+nAnO1Z4Yn8Vg==
X-Received: by 2002:a17:902:7684:b0:1bc:e6a:205a with SMTP id m4-20020a170902768400b001bc0e6a205amr7188735pll.4.1692657040230;
        Mon, 21 Aug 2023 15:30:40 -0700 (PDT)
Received: from localhost ([192.55.55.51])
        by smtp.gmail.com with ESMTPSA id r21-20020a170902be1500b001bbbc655ca1sm7544906pls.219.2023.08.21.15.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Aug 2023 15:30:39 -0700 (PDT)
Date:   Mon, 21 Aug 2023 15:30:38 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com, Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH v2 45/58] i386/tdx: Limit the range size for MapGPA
Message-ID: <20230821223038.GA3642077@ls.amr.corp.intel.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-46-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230818095041.1973309-46-xiaoyao.li@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 18, 2023 at 05:50:28AM -0400,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> If the range for TDG.VP.VMCALL<MapGPA> is too large, process the limited
> size and return retry error.  It's bad for VMM to take too long time,
> e.g. second order, with blocking vcpu execution.  It results in too many
> missing timer interrupts.

This patch requires the guest side patch. [1]
Unless with large guest memory, it's unlikely to hit the limit with KVM/qemu,
though.

[1] https://lore.kernel.org/all/20230811021246.821-1-decui@microsoft.com/

> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  target/i386/kvm/tdx.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index 0c43c1f7759f..ced55be506d1 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -994,12 +994,16 @@ static hwaddr tdx_shared_bit(X86CPU *cpu)
>      return (cpu->phys_bits > 48) ? BIT_ULL(51) : BIT_ULL(47);
>  }
>  
> +/* 64MB at most in one call. What value is appropriate? */
> +#define TDX_MAP_GPA_MAX_LEN     (64 * 1024 * 1024)
> +
>  static void tdx_handle_map_gpa(X86CPU *cpu, struct kvm_tdx_vmcall *vmcall)
>  {
>      hwaddr shared_bit = tdx_shared_bit(cpu);
>      hwaddr gpa = vmcall->in_r12 & ~shared_bit;
>      bool private = !(vmcall->in_r12 & shared_bit);
>      hwaddr size = vmcall->in_r13;
> +    bool retry = false;
>      int ret = 0;
>  
>      vmcall->status_code = TDG_VP_VMCALL_INVALID_OPERAND;
> @@ -1018,12 +1022,25 @@ static void tdx_handle_map_gpa(X86CPU *cpu, struct kvm_tdx_vmcall *vmcall)
>          return;
>      }
>  
> +    if (size > TDX_MAP_GPA_MAX_LEN) {
> +        retry = true;
> +        size = TDX_MAP_GPA_MAX_LEN;
> +    }
> +
>      if (size > 0) {
>          ret = kvm_convert_memory(gpa, size, private);
>      }
>  
>      if (!ret) {
> -        vmcall->status_code = TDG_VP_VMCALL_SUCCESS;
> +        if (retry) {
> +            vmcall->status_code = TDG_VP_VMCALL_RETRY;
> +            vmcall->out_r11 = gpa + size;
> +            if (!private) {
> +                vmcall->out_r11 |= shared_bit;
> +            }
> +        } else {
> +            vmcall->status_code = TDG_VP_VMCALL_SUCCESS;
> +        }
>      }
>  }
>  
> -- 
> 2.34.1
> 
> 

-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>
