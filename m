Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67D66571989
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 14:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233111AbiGLMMH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 08:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233103AbiGLMMD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 08:12:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6A839B5D3A
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 05:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657627918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A9nXHDLA+aj6px0VjCk5pTVFb/x1kM7mKf9a3TUvwwQ=;
        b=Bf9xA18gZOYTD3ZMKl3RtX2qbSqQt4bQR6oKpZCc0KIOMQUIWM6I4aIGUyo7dsU8kIW0GU
        v3pg/Ze3bquLjh9HxqxfN6GOQm64Tlg3KMoFnjk0sBLLvgkpF+/Ge9XDF31/i3AGLeOw79
        usyiQkMQ6LwaQRWO05Bvqa0A8olMCzo=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-TOPnma1yOpex80uLUjvpSQ-1; Tue, 12 Jul 2022 08:11:55 -0400
X-MC-Unique: TOPnma1yOpex80uLUjvpSQ-1
Received: by mail-qv1-f70.google.com with SMTP id u15-20020a0ced2f000000b004732a5e7a99so1676575qvq.5
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 05:11:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=A9nXHDLA+aj6px0VjCk5pTVFb/x1kM7mKf9a3TUvwwQ=;
        b=zzk89awBiBseZcQOUgndEq23THHeNeJYcwcJyrrWDJ+akGr7NrruMFSndQUPfXQnLV
         231fx7yhIAZG7q3AlM0qJTFh2zGwnRQjG66TqwP2TYMr3qmL+GGImvvd7tvhL++F+OTE
         4l5QLkraag4TSYSFa4Ry+xJ0qzYOKDdaF47Jdcu9hDGRuJkGlm/h5fX7TsuqvY9VDJri
         ToteBFSMyjvJchRgAsBVzDPzfgV44H6Wqzhmeui+PAmlQpcDgN1jy4fnzA56f9j2XlzR
         U29ih0AvhxtajugKWeD2GgURoQo4/r8rFiBFVtrCjevbE2Lapn8d88w2TYm8Z35X5404
         GAYw==
X-Gm-Message-State: AJIora8NMbaFXvcqJ9XVZG7wNRNFSV6juGq/cD5qFzo60V+rZqHEdIro
        EQ/5XClguviwGOYoL3mYWYeUQ7okFCcHkpy3Tr/qIH0TkiCOXlygjiC8/GRCU2p8nYB9i7vz58Y
        EPxhDPCUW8YA1
X-Received: by 2002:a05:620a:3199:b0:6af:52bc:d448 with SMTP id bi25-20020a05620a319900b006af52bcd448mr14822383qkb.637.1657627914479;
        Tue, 12 Jul 2022 05:11:54 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v4Zewel6mbdoe+fB5QSMfVct/iEpAbmuRjiGhgbHpjBp+abvTPS8Tw2XH4IjDuiG6rdqisgg==
X-Received: by 2002:a05:620a:3199:b0:6af:52bc:d448 with SMTP id bi25-20020a05620a319900b006af52bcd448mr14822363qkb.637.1657627914286;
        Tue, 12 Jul 2022 05:11:54 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id x21-20020a05620a0b5500b006af147d4876sm5207334qkg.30.2022.07.12.05.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 05:11:53 -0700 (PDT)
Message-ID: <018653fac9bd964f65e6fd28fd07da8cb24a61c2.camel@redhat.com>
Subject: Re: [PATCH v3 25/25] KVM: nVMX: Use cached host MSR_IA32_VMX_MISC
 value for setting up nested MSR
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 12 Jul 2022 15:11:50 +0300
In-Reply-To: <20220708144223.610080-26-vkuznets@redhat.com>
References: <20220708144223.610080-1-vkuznets@redhat.com>
         <20220708144223.610080-26-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-07-08 at 16:42 +0200, Vitaly Kuznetsov wrote:
> vmcs_config has cased host MSR_IA32_VMX_MISC value, use it for setting
 ^^ typo
> up nested MSR_IA32_VMX_MISC in nested_vmx_setup_ctls_msrs() and avoid the
> redundant rdmsr().
> 
> No (real) functional change intended.
> 
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 3d386c663fac..8026dab71086 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -6754,10 +6754,7 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
>                 msrs->secondary_ctls_high |= SECONDARY_EXEC_ENCLS_EXITING;
>  
>         /* miscellaneous data */
> -       rdmsr(MSR_IA32_VMX_MISC,
> -               msrs->misc_low,
> -               msrs->misc_high);
> -       msrs->misc_low &= VMX_MISC_SAVE_EFER_LMA;
> +       msrs->misc_low = (u32)vmcs_conf->misc & VMX_MISC_SAVE_EFER_LMA;
>         msrs->misc_low |=
>                 MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS |
>                 VMX_MISC_EMULATED_PREEMPTION_TIMER_RATE |

Besides the typo,
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
 Maxim Levitsky


