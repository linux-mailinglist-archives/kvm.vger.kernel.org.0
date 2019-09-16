Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F24FB42C9
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2019 23:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391647AbfIPVOI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Sep 2019 17:14:08 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43501 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391594AbfIPVOI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Sep 2019 17:14:08 -0400
Received: by mail-wr1-f65.google.com with SMTP id q17so865517wrx.10
        for <kvm@vger.kernel.org>; Mon, 16 Sep 2019 14:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=aJQBtttQb/9gppC0RS5BroTu8sD1MvrCpTBBP2JR2WE=;
        b=dHy+OyPIeQopiDqL06E2feYFy7NdPJeLoj3hKTVcp07q1js5jS/4Cpy7yelvUkkUJN
         9f4ZGm6jFqS145NiSBaYriCbsb7RpOheVYwYbRoLx7vUAiDlQfJegxzhwR1IXOxnZLDt
         HvSz3fErSjbZMQNDNVgpYK20X24TZ5N7h97tcLAUXxJgPthrVTEzn0yZFFbHYD31nk/k
         QjakocVgrmqKP6KA1XaiYOiGxD2n4eql/MGeLxYBYD+VkGnCKWziAI9yitn7KiVdOfx8
         GBQ2AeoMlVvpIszR/NgTRKXxukXFoqVhaKcrEPjIyJzg3dZl+KcleHR/hAszCcfdMZok
         xwCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=aJQBtttQb/9gppC0RS5BroTu8sD1MvrCpTBBP2JR2WE=;
        b=nv9lIPNhF7c00Iue2MqJzUXl95oJQfrLj9WFkSRGpLS1R3BHRtZysCfe2qUFsV6IVM
         a5SVGtq6OY/5fScb+Wjubd51wxTfSYMvztnPZJmQXnHoDK2JhqQ4qjztOzRmZMARuKIZ
         BuRvbwZ0S8B/vzX2sRlmNywiGJM/cjQ6fQV+7tE52qtaTG3upH3IexiErT8nmXwK09Il
         99J5N2na5UJlfGGUOE5Cd5jpw8+xqIO3TGtqfD3RHMl/cj+44kuyRSsritpUguux2ngs
         4AP0JaSQXCg8mBJuS98VA73fWisIvwtzGIhyaDno00erBW/xmw+akbsVdb1tvMfrnnrF
         qv2Q==
X-Gm-Message-State: APjAAAWhVYIejOe9KhpSimHYCc0SQBL7gJA7YGtN0R9KDmMlw0mmSYNi
        7fbQhSGXBJ7VAeBPhRKjCyaM7ACE7MTK1/k8M02pFMJShvg=
X-Google-Smtp-Source: APXvYqwVddoR/+GX0HxGxMGHE5So/k+Cjp2Ro42J1TkJgChvlotfeKqKq5fhBHOz2dxKSTVU+zTLk02nJRiiyewZ7iM=
X-Received: by 2002:a05:6000:1281:: with SMTP id f1mr232785wrx.247.1568668445549;
 Mon, 16 Sep 2019 14:14:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190914003940.203636-1-marcorr@google.com>
In-Reply-To: <20190914003940.203636-1-marcorr@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Mon, 16 Sep 2019 14:13:54 -0700
Message-ID: <CAA03e5EECP=FBscuzmxCswRtoBu0fSmnTjUd++WHjCE=rLm3mw@mail.gmail.com>
Subject: Re: [PATCH v2] kvm: nvmx: limit atomic switch MSRs
To:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +static inline bool vmx_control_verify(u32 control, u32 low, u32 high)
> +{
> +       return fixed_bits_valid(control, low, high);
> +}
> +
> +static inline u64 vmx_control_msr(u32 low, u32 high)
> +{
> +       return low | ((u64)high << 32);
> +}
> +
>  static void vmx_disable_shadow_vmcs(struct vcpu_vmx *vmx)
>  {
>         secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_SHADOW_VMCS);
> @@ -856,6 +866,17 @@ static int nested_vmx_store_msr_check(struct kvm_vcpu *vcpu,
>         return 0;
>  }
>
> +static u64 vmx_control_msr(u32 low, u32 high);

Oops, I forgot to delete this declaration, which is no longer needed
after applying Sean's suggestions, in v2. I can send out a v3 with
this line removed after folks comment on this version.
