Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 839D74C96A
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 10:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbfFTI0N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 04:26:13 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:42483 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbfFTI0N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 04:26:13 -0400
Received: by mail-ot1-f66.google.com with SMTP id l15so1897860otn.9;
        Thu, 20 Jun 2019 01:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZK1UlhpuLZcyd9XHAbHKg7Weff0O7Oy2YAd/unLoi4A=;
        b=nnkUIanp3lEYXFV2dbxujXD0AQeroq9ociTuT+GxtG8gtFJXGYMoHcUilcC4RSZ7OJ
         hG0ZY//LJgvtWdXTsokVukM7VguGsy3isqA+ZOeRjvEeaaM029H6ldMIX1ChluloTShY
         5eU8bXCkjGwnLsGiZTaDwjIxyxGkmkN3XjqwHH01J6Rb2VRQ5HTrtf6fL/t6fFDk4u6+
         oiruNtmCYiBqn63++HlmWjBM15gpHHZn2uJsyYSMuSylVRvs37U+UHaTmir2DAPFas6o
         CYjMq3cI+XEqJLrqkbrLUu3ckaN1aQQsSpTIpJB//PcD/Ofh7p4grVB/hi2Xtt8NdAGt
         zvbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZK1UlhpuLZcyd9XHAbHKg7Weff0O7Oy2YAd/unLoi4A=;
        b=QasyKwcHf9zffXsC6bq9Iy3bntOxsaf1k3O/z9JO+C3QOXUaXdme1Oqw2FNfcbEFWS
         NCeOTusqFsmbSjgD4+ibNk9Hle94iGvlOczsX5CwKHJbcdpJH6BW5MZLaQWQyMRdcxII
         PFumLpwNvUTVuYcMf/gOHaEqSBPzNIOtcJgUFgmD4FN1VcjHMZTcGoPxT/Do8uQcG8NI
         RSc2hZnQWZXazzartrIgoGYMO2l8IFdkVELBD6nVcfUW08PmIxdGhMi6tt5ZUbQ/OLjL
         +B1WbpaFF12YfawZFxTjLgnBBfpwNRH98pNTM26O71KXEc+qpsHHED1ztaLEB8Oq9pqx
         WPHg==
X-Gm-Message-State: APjAAAUlOXTh55egG8ne50RNQAYhRSBynU+PJbuIsh2SB6kTCBvFuDT5
        y25LmiFTKWWbFaw4G3TvSOiJVljxowShAye3F9M=
X-Google-Smtp-Source: APXvYqznCjofjv9h5iAunLzMajmGqWLPKuoV36Wf7dOUzKqxEjXuu92WyZuJvAUq4F9DXoNnBY465TaLLOpYwuprVmM=
X-Received: by 2002:a9d:6959:: with SMTP id p25mr48678695oto.118.1561019172278;
 Thu, 20 Jun 2019 01:26:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190620050301.1149-1-tao3.xu@intel.com> <CANRm+Cwg7ogTN1w=xNyn+8CfxwofdxRykULFe217pXidzEhh6Q@mail.gmail.com>
 <f358c914-ae58-9889-a8ef-6ea9f3b2650e@linux.intel.com> <b3f76acd-cc7e-9cd7-d7f7-404ba756ab87@redhat.com>
In-Reply-To: <b3f76acd-cc7e-9cd7-d7f7-404ba756ab87@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 20 Jun 2019 16:27:26 +0800
Message-ID: <CANRm+Cy_oo7BkYXD-nc0Ro=rivJircL6aheuFujMv6twS3gk=g@mail.gmail.com>
Subject: Re: [PATCH] KVM: vmx: Fix the broken usage of vmx_xsaves_supported
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@linux.intel.com>,
        Tao Xu <tao3.xu@intel.com>, Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 20 Jun 2019 at 16:17, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 20/06/19 08:46, Xiaoyao Li wrote:
> >>
> >> It depends on whether or not processors support the 1-setting instead
> >> of =E2=80=9Cenable XSAVES/XRSTORS=E2=80=9D is 1 in VM-exection control=
 field. Anyway,
> >
> > Yes, whether this field exist or not depends on whether processors
> > support the 1-setting.
> >
> > But if "enable XSAVES/XRSTORS" is clear to 0, XSS_EXIT_BITMAP doesn't
> > work. I think in this case, there is no need to set this vmcs field?
>
> vmx->secondary_exec_control can change; you are making the code more
> complex by relying on the value of the field at the point of vmx_vcpu_set=
up.
>
> I do _think_ your version is incorrect, because at this point CPUID has
> not been initialized yet and therefore
> vmx_compute_secondary_exec_control has not set SECONDARY_EXEC_XSAVES.
> However I may be wrong because I didn't review the code very closely:
> the old code is obvious and so there is no point in changing it.

Agreed, in addition, guest can enable/disable cpuid bits by grub
parameter, should we call kvm_x86_ops->cpuid_update() in
kvm_vcpu_reset() path to reflect the new guest cpuid influence to
exec_control? e.g. the first boot guest disable xsaves in grub, kvm
disables xsaves in exec_control; then guest reboot w/ xsaves enabled,
it still get an #UD when executing.

Regards,
Wanpeng Li
