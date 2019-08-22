Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9218A99E5B
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 19:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732381AbfHVR7A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 13:59:00 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:46434 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731583AbfHVR7A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 13:59:00 -0400
Received: by mail-io1-f66.google.com with SMTP id x4so13619407iog.13
        for <kvm@vger.kernel.org>; Thu, 22 Aug 2019 10:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iXUFpwgRMQAkXsVfvJV1TUf/CGJ/vagejuy2962A3p8=;
        b=nQFlsMCNIXyiVhnrHPDUzScyZZTVDrU/VlfmSVvVDt/Var8ppF8oh87Kreshfxzksv
         BeLS3mMJy8mtzum9T2SPG9HeGMBOVmlW/TkLIrH+njTGpcMtyryLfSlYBs7CvnE8QRKE
         +kSI7EbBdgNZ1qKr1k13fwR+qWQ/vKMzX3qUh+wbKZE+9FnprzIVhvXYJ/ZOnHb/aBbi
         ov/5ngyFM6BpM0ThAyIrx4dAl1gADLRdw6zI8ZHEGrml04SoPn9cTlzRcw+WsMSZ3MV5
         T/QP1x3gLPv+LWFB32W7mruEPZ1C/CdPCbcbymqF8KPB5AKxW9kOEiu8UcSslFQEXReW
         TJAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iXUFpwgRMQAkXsVfvJV1TUf/CGJ/vagejuy2962A3p8=;
        b=b79EImchN50kYJGd56ZibSlQTeL/+svXb9RHYmkDNDHSZrPtsxGa5qPE5YK2t+qozz
         85lRw6B5b+DVObVI5nrenF4ng2QxyP+qCBkXJuCSPv378bW+fw8tBQEwPA5QMCO05rnM
         YhnJYl6+ndYrsD/Ku840fRB00Li6ha9DvCzpd37sajkoAKJJzdxCTk13r1ULbwuDNzHw
         c+hfeaYvaLNwXiE7j6p9J1h7c2w+qZD/JmJlscpEKBG4l7FmRoDB25k8AFpkiwigdytM
         /GuHchaf5CWoBfct2moxRpG/5lu0VV/ffjz1PmAltV7uwg9YNSnTWdp9qySuC+mgcNdf
         Uquw==
X-Gm-Message-State: APjAAAUM2T7AA77Gowt/6bIXfwh2ThskF2HH7RrVTr6SbFCGWnvd5LM0
        ydvmYh4jXaZU+pfijhfAQIc7LI+uke0D23qXj5gAuh9V1pvGFA==
X-Google-Smtp-Source: APXvYqxF6bfGevFIJzv3TWYOTFa61ZdWV4AOXNBTCzzBp93v8tUpvKD4WKXIMvanx8T3SmNDyMvmJWMx9i8Sm+F0j8I=
X-Received: by 2002:a02:c65a:: with SMTP id k26mr831793jan.18.1566496738916;
 Thu, 22 Aug 2019 10:58:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190819214650.41991-1-nikita.leshchenko@oracle.com> <20190819214650.41991-2-nikita.leshchenko@oracle.com>
In-Reply-To: <20190819214650.41991-2-nikita.leshchenko@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 22 Aug 2019 10:58:47 -0700
Message-ID: <CALMp9eRkhDcK+uJwQ1NPnwBaEUyPcxDPBME3yDid6EvR=sUgRw@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: nVMX: Always indicate HLT activity support in
 VMX_MISC MSR
To:     Nikita Leshenko <nikita.leshchenko@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>, Liran Alon <liran.alon@oracle.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 19, 2019 at 2:47 PM Nikita Leshenko
<nikita.leshchenko@oracle.com> wrote:
>
> Before this commit, userspace could disable the GUEST_ACTIVITY_HLT bit in
> VMX_MISC yet KVM would happily accept GUEST_ACTIVITY_HLT activity state in
> VMCS12. We can fix it by either failing VM entries with HLT activity state when
> it's not supported or by disallowing clearing this bit.
>
> The latter is preferable. If we go with the former, to disable
> GUEST_ACTIVITY_HLT userspace also has to make CPU_BASED_HLT_EXITING a "must be
> 1" control, otherwise KVM will be presenting a bogus model to L1.
>
> Don't fail writes that disable GUEST_ACTIVITY_HLT to maintain backwards
> compatibility.
>
> Reviewed-by: Liran Alon <liran.alon@oracle.com>
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 46af3a5e9209..24734946ec75 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1102,6 +1102,14 @@ static int vmx_restore_vmx_misc(struct vcpu_vmx *vmx, u64 data)
>         if (vmx_misc_mseg_revid(data) != vmx_misc_mseg_revid(vmx_misc))
>                 return -EINVAL;
>
> +       /*
> +        * We always support HLT activity state. In the past it was possible to
> +        * turn HLT bit off (without actually turning off HLT activity state
> +        * support) so we don't fail vmx_restore_vmx_misc if this bit is turned
> +        * off.
> +        */
> +       data |= VMX_MISC_ACTIVITY_HLT;
> +
>         vmx->nested.msrs.misc_low = data;
>         vmx->nested.msrs.misc_high = data >> 32;
>

This change breaks live migration to an upgraded kernel, since it
doesn't allow the IA32_VMX_MISC MSR to be restored to its original
value. I think this warrants a quirk.
