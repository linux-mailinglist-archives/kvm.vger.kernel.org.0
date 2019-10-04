Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F85ECB570
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 09:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730045AbfJDHmx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 03:42:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27351 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728841AbfJDHmx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 03:42:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570174970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=aqehLXaXoxAk0FwHZXOGuzJYSxJSLBJhzUvAd2716fk=;
        b=et6hH5W/RGabOlSHdEEPbyvyyP4FNjIiNl7+YZWSfQU4xJLUncJ4UVBlpwt1Q/g+SbpEs/
        DvSgL93Rp3axFgyxlhz/okPMg1jbwxrK5Hd6q34yAU8/Lrm8h+q5IRJWImoHWCbmnLcd79
        1dwC79MMGPUg1RzSCiM9X8npy9eNo00=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-152-Z463oJSvPnuCfHLStbSEvg-1; Fri, 04 Oct 2019 03:42:48 -0400
Received: by mail-wr1-f71.google.com with SMTP id w2so2339910wrn.4
        for <kvm@vger.kernel.org>; Fri, 04 Oct 2019 00:42:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZnjEcv9bwMt98xcjyHQJSlCaW2NwBRCddFAr5LLLNdM=;
        b=U4OgQgEq9CdtwF+FDW+vTMc93MEnE2d2eSCpiVhrpa94mBT86DHbWQAn7dllBrV3zI
         bREPPbfwzHhDdK5Zs1TzMx+VbHFH7vSPp9Uvxt+LJ+SeofKeDlgvg7PksOfZWSM6dS+Z
         OtL84LVZu8gR2zWYU0fudmaxl8/uxx9tridqMns05DdRQsQBYLWIBKYL49nCvmJYiKuf
         cZcevBDbljz6QzoINPsmF2ihTCiKKKBB3U+Jd+u6Q9qUY3zjmvUAwFgWPNCO+EIu+Wi3
         HIcOy6baXLCprjzFId3mNSZouapMgeJsKOB7za+K2m9/gkFfXWKTTlwkLUfaJrmJGpTI
         Q6xg==
X-Gm-Message-State: APjAAAUpHxYJKRFonvZAyZahACscrISCf8+g0NhgJubjBZlFSVyYYFEr
        nku0ogjn+x99wREJts6m5mj41x1tSKOrC67pXnT9kPFTOP2wQfo8Ns5nUBfYCRALKROMFeOHs4f
        8fMei/UxzXXY1
X-Received: by 2002:a7b:c74c:: with SMTP id w12mr444763wmk.156.1570174967433;
        Fri, 04 Oct 2019 00:42:47 -0700 (PDT)
X-Google-Smtp-Source: APXvYqynjOXyxUR2wfWfnrZSAIIZmvVR76cHGNJO3pxfQrVbC+uRcG6jmeTYWszrSV/kMcDcAbBeIQ==
X-Received: by 2002:a7b:c74c:: with SMTP id w12mr444744wmk.156.1570174967153;
        Fri, 04 Oct 2019 00:42:47 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id o1sm7711517wrs.78.2019.10.04.00.42.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Oct 2019 00:42:46 -0700 (PDT)
Subject: Re: [RFC PATCH 05/13] kvm: Add #PF injection for KVM XO
To:     Rick Edgecombe <rick.p.edgecombe@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        luto@kernel.org, peterz@infradead.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, keescook@chromium.org
Cc:     kristen@linux.intel.com, deneen.t.dock@intel.com
References: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
 <20191003212400.31130-6-rick.p.edgecombe@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <08e46327-7d98-5c63-58ba-e9a171790c25@redhat.com>
Date:   Fri, 4 Oct 2019 09:42:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191003212400.31130-6-rick.p.edgecombe@intel.com>
Content-Language: en-US
X-MC-Unique: Z463oJSvPnuCfHLStbSEvg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/10/19 23:23, Rick Edgecombe wrote:
> +=09if (!vcpu->arch.gva_available)
> +=09=09return 0;

Please return RET_PF_* constants, RET_PF_EMULATE here.

> +=09if (error_code & PFERR_WRITE_MASK)
> +=09=09fault_error_code |=3D X86_PF_WRITE;
> +
> +=09fault.vector =3D PF_VECTOR;
> +=09fault.error_code_valid =3D true;
> +=09fault.error_code =3D fault_error_code;
> +=09fault.nested_page_fault =3D false;
> +=09fault.address =3D vcpu->arch.gva_val;
> +=09fault.async_page_fault =3D true;

Not an async page fault.

> +=09kvm_inject_page_fault(vcpu, &fault);
> +
> +=09return 1;

Here you would return RET_PF_RETRY - you've injected the page fault and
all that's left to do is reenter execution of the vCPU.

[...]

> +=09if (unlikely(vcpu->arch.xo_fault)) {
> +=09=09/*
> +=09=09 * If not enough information to inject the fault,
> +=09=09 * emulate to figure it out and emulate the PF.
> +=09=09 */
> +=09=09if (!try_inject_exec_only_pf(vcpu, error_code))
> +=09=09=09return RET_PF_EMULATE;
> +
> +=09=09return 1;
> +=09}

Returning 1 is wrong, it's also RET_PF_EMULATE.  If you change
try_inject_exec_only_pf return values to RET_PF_*, you can simply return
the value of try_inject_exec_only_pf(vcpu, error_code).

That said, I wonder if it's better to just handle this in
handle_ept_violation.  Basically, if bits 5:3 of the exit qualification
are 100 you can bypass the whole mmu.c page fault handling and just
inject an exec-only page fault.

Thanks,

Paolo

