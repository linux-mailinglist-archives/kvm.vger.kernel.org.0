Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87813EEA70
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 21:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729904AbfKDUuG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 15:50:06 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:46476 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728409AbfKDUuF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 15:50:05 -0500
Received: by mail-il1-f195.google.com with SMTP id m16so16080467iln.13
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2019 12:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=q3So3ZLQhkdEtF05u3Qylu9NmVpm+eaQVGAjmXYO7mY=;
        b=vy92WCqbsRqR7Pl3etSKn8C+cZczIdHD6qCtgpXLeTGu7BrjvJ2GCtdN8ETWhiHFxe
         /R+/OiSZT4K3Y1ZzQMeqEeFTb4fH8d0oBUdGktvz0dIVrujYCEr+O99DD/RamSb2VFXU
         0livgCt4RykjBCN+hTFP5Kj9/wfmtOsFhRhb5j+pS7PiLNm0eeNUaM6NO/ElJQaJ+ezG
         3uPUTuNWx05GOCQXQ1XUT5f+gh2E+4ma2LIDOwa8HqV9HngGKu05ChalBIu4OmGsmhIc
         kjg6n33c9ShlCa37QzyQYEyVOu/VYcksDQBJy8bZf862XS2A1H/ooNXqPIcpy3JVZrUd
         bUAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=q3So3ZLQhkdEtF05u3Qylu9NmVpm+eaQVGAjmXYO7mY=;
        b=gBTidwOmp2Ke4t+1MtteeEhg/Efh0GuB1Z+MBp8s5dlpcHmelvexbhzYRsFZy/GLkk
         8d9J7NgHUGEtBTU8fiHQed1ZHjx+3bKGckpPuZe/slrtm0ymvvN68tdwVC7+z5ufoC+H
         J8p05qupC14k+CMby3X0IY0eA4kQ/CquPhIzUaNRRTNElnpGEYzkUJtEuQBaahPn6POe
         /UHv6hQPknmfceUII6F2tAArywMg34oX06VDWmwnlDirC5o0NEaPxglQo4C3/s5Lg+Wn
         zomaPUANteHRf/s5gbSyC5ZEmFNCtY4LQTS9RWje1tr+4CJGRshRZf/dWZMEa4cnaKne
         TeVw==
X-Gm-Message-State: APjAAAVWWXV+F2eH2jGGzqm+a1x6YSlG5mnpKtLH54hejjrlE/64aUEG
        816jBPZ/izUy58ASSnMTKLWbyCcQaAnQvA4WvPgCbndC
X-Google-Smtp-Source: APXvYqwceEtJy1zPgR3gC3cxgJNzdoYsveSpVoeYDZ8GqnL/pG8kqiiLm1lDXLcJw3Evpfz+1x1PlM93Cmc9u0+Osqk=
X-Received: by 2002:a92:6e0a:: with SMTP id j10mr25483198ilc.26.1572900604129;
 Mon, 04 Nov 2019 12:50:04 -0800 (PST)
MIME-Version: 1.0
References: <20191022213349.54734-1-jmattson@google.com>
In-Reply-To: <20191022213349.54734-1-jmattson@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 4 Nov 2019 12:49:53 -0800
Message-ID: <CALMp9eR7temnM2XssLbRF0Op+=t0f-vwY-Pn4XgZ4uEaTW57Yw@mail.gmail.com>
Subject: Re: [PATCH] kvm: cpuid: Expose leaves 0x80000005 and 0x80000006 to
 the guest
To:     kvm list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 22, 2019 at 2:33 PM Jim Mattson <jmattson@google.com> wrote:
>
> Leaf 0x80000005 is "L1 Cache and TLB Information." Leaf 0x80000006 is
> "L2 Cache and TLB and L3 Cache Information." Include these leaves in
> the array returned by KVM_GET_SUPPORTED_CPUID.
>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 9c5029cf6f3f..1b40d8277b84 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -730,6 +730,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>                 entry->ecx &= kvm_cpuid_8000_0001_ecx_x86_features;
>                 cpuid_mask(&entry->ecx, CPUID_8000_0001_ECX);
>                 break;
> +       case 0x80000005:
> +       case 0x80000006:
> +               break;
>         case 0x80000007: /* Advanced power management */
>                 /* invariant TSC is CPUID.80000007H:EDX[8] */
>                 entry->edx &= (1 << 8);
> --
> 2.23.0.866.gb869b98d4c-goog
>
Ping.
