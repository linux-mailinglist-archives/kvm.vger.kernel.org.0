Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C90851B587C
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 11:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgDWJqZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 05:46:25 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:27508 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726375AbgDWJqY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Apr 2020 05:46:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587635183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KaFdX++ChHNsDdrE29TfUYlzOreRcNHe/xIToCcwxcE=;
        b=Jdokqy/Y+kEC5+J1WaIfFhLpoXXhLWpR4v3YkoBfq7PKVZJWSeGvlk42+A8iaNzDKCXic7
        S4pbuMEWP0SPHxnRytWJVZE3uu97g0Rk01I68Qh+lJyKyhxsa4C8KqNXaLCbdga+pwB0l9
        FOqlK8Zojau1sdRx/fDGaVyONgo4aSs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-Op0xtSTmNcmVEjGDtFVjJQ-1; Thu, 23 Apr 2020 05:46:20 -0400
X-MC-Unique: Op0xtSTmNcmVEjGDtFVjJQ-1
Received: by mail-wr1-f70.google.com with SMTP id e5so2561324wrs.23
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 02:46:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=KaFdX++ChHNsDdrE29TfUYlzOreRcNHe/xIToCcwxcE=;
        b=A2jezacYw/SvHhz9LsvkBdHGOuIv/njrvxjgdHyaOqj/lULmEn/EalKlwjWLOP2bta
         VXbjYQTcZO7h3PX1k9Nt2lixhOLK2YYJO9trykEdIX664F80CNZ+uhAgqf9c7fSXPclC
         Jx5ulCDY4HCCpGpAnjXPhrfUYGuxBod3CxXWpNq+2KA8wDxW99ns0jfrC/ar2W6v3pBO
         81lQi4GTZcvoTJD+DzDb/IbqPY5fHYsvxkbEZpphdVyN0IKgmk1TrmeUiM75Bzsq00Jj
         TXrx8IHfY+/b8QyMH8vXBj3/EXE4i3aiA3ZEt0muPXEE8+ag5txd9ccMq+Gov7neja4g
         4mEA==
X-Gm-Message-State: AGi0PuZS7Bvpp9I0G4xBjxAelUklfrE/0+JVZS0YYH0dQ66Xx/yul+Ja
        gtB3SyR7qMGFfI4LGq0R05TzGJF1Oe1lX9Oo8/APaKEViTE8vdD203j0M/RNRxXcxF/DD4fGaKb
        HZfSOwWaxViFL
X-Received: by 2002:a05:600c:21d6:: with SMTP id x22mr3325469wmj.95.1587635179208;
        Thu, 23 Apr 2020 02:46:19 -0700 (PDT)
X-Google-Smtp-Source: APiQypLeQTwZRBWWH7mjBHXRBPiFSgXSmaey5vhzcyNkf/fCfxWQ9eAAj3YDWjuUu3+kujKLWHGwTw==
X-Received: by 2002:a05:600c:21d6:: with SMTP id x22mr3325445wmj.95.1587635178966;
        Thu, 23 Apr 2020 02:46:18 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id y63sm2945360wmg.21.2020.04.23.02.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 02:46:18 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     mikelley@microsoft.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v2 4/4] asm-generic/hyperv: Add definitions for Get/SetVpRegister hypercalls
In-Reply-To: <20200422195737.10223-5-mikelley@microsoft.com>
References: <20200422195737.10223-1-mikelley@microsoft.com> <20200422195737.10223-5-mikelley@microsoft.com>
Date:   Thu, 23 Apr 2020 11:46:16 +0200
Message-ID: <87r1wepmaf.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Michael Kelley <mikelley@microsoft.com> writes:

> Add definitions for GetVpRegister and SetVpRegister hypercalls, which
> are implemented for both x86 and ARM64.
>
> Signed-off-by: Michael Kelley <mikelley@microsoft.com>
> ---
>  include/asm-generic/hyperv-tlfs.h | 51 +++++++++++++++++++++++++++++++
>  1 file changed, 51 insertions(+)
>
> diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hyperv-tlfs.h
> index 1f92ef92eb56..262fae9526b1 100644
> --- a/include/asm-generic/hyperv-tlfs.h
> +++ b/include/asm-generic/hyperv-tlfs.h
> @@ -141,6 +141,8 @@ struct ms_hyperv_tsc_page {
>  #define HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX	0x0013
>  #define HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX	0x0014
>  #define HVCALL_SEND_IPI_EX			0x0015
> +#define HVCALL_GET_VP_REGISTERS			0x0050
> +#define HVCALL_SET_VP_REGISTERS			0x0051
>  #define HVCALL_POST_MESSAGE			0x005c
>  #define HVCALL_SIGNAL_EVENT			0x005d
>  #define HVCALL_RETARGET_INTERRUPT		0x007e
> @@ -439,4 +441,53 @@ struct hv_retarget_device_interrupt {
>  	struct hv_device_interrupt_target int_target;
>  } __packed __aligned(8);
>  
> +
> +/* HvGetVpRegisters hypercall input with variable size reg name list*/
> +struct hv_get_vp_registers_input {
> +	struct {
> +		u64 partitionid;
> +		u32 vpindex;
> +		u8  inputvtl;
> +		u8  padding[3];
> +	} header;
> +	struct input {
> +		u32 name0;
> +		u32 name1;
> +	} element[];
> +} __packed;
> +
> +
> +/* HvGetVpRegisters returns an array of these output elements */
> +struct hv_get_vp_registers_output {
> +	union {
> +		struct {
> +			u32 a;
> +			u32 b;
> +			u32 c;
> +			u32 d;
> +		} as32 __packed;
> +		struct {
> +			u64 low;
> +			u64 high;
> +		} as64 __packed;
> +	};
> +};
> +
> +/* HvSetVpRegisters hypercall with variable size reg name/value list*/
> +struct hv_set_vp_registers_input {
> +	struct {
> +		u64 partitionid;
> +		u32 vpindex;
> +		u8  inputvtl;
> +		u8  padding[3];
> +	} header;
> +	struct {
> +		u32 name;
> +		u32 padding1;
> +		u64 padding2;
> +		u64 valuelow;
> +		u64 valuehigh;
> +	} element[];
> +} __packed;
> +
>  #endif

Thank you for making these changes,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

