Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B15036B56D
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 17:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233988AbhDZPKb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 11:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233573AbhDZPKa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 11:10:30 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48BEFC061574
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 08:09:49 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id y62so6510478pfg.4
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 08:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=jkRMHjrSCZPTvq0vYCKIhPuB3sHp9mEl5+KCAGLgqhY=;
        b=BC255GuEXgIFcphCVXnJjpn/yY9uAy6wVw0MRO1UsJsMZHgxebRSh2+QI57//qMEyv
         Zu9Fcb43MIJ3HFmP9knQRNBGE1bZkWDlhGHRd2IWxjzrA/NvYcyh+vl9m5l32uOo2Yjh
         Cdek7gxGFBhwIHLiMA7bTKHzzNu2Ou+7KeDXI9fgqxYw24a1DEDTqkqfvp7hE6GOFdFr
         tS6CkxhefAh4haOT88fqCaYG5uGq7ae45bkMSnwWV88YB3N4Naz2F1TiV2z/iXAxvouM
         Wd+QwvRxOSY2hC4KURCitUE9yheLl76gidD/qy43skuLSF+NHoOi84Y/eF+MaiEIkPsg
         lKsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=jkRMHjrSCZPTvq0vYCKIhPuB3sHp9mEl5+KCAGLgqhY=;
        b=GGorbdvp5JiByD4s8g/Nh4qzWSsxR3elwJ8szforZEl+T4hN1s7KdcauqRKugJfr2V
         bBTjFNNKIMKnl0x86OKSWhTVGsqzvg3L0P97sRYQFtRs3s3ZMma6TjZxekgpG+L3ZVTn
         pO50xPndjoNlO98UlxCjQskaTZImJADmm08L11ZCb9VKCdxzwJLpd6cvPnf+3nkT7U4y
         8D7Uzb7pFGgpQSwlM8pO+ShCADlZ6TMrel0Z2eFVDc2rKT+u2SjX+ceEgCRbg3qFN8jN
         FyDfqGTuZgUP3iQ7eIMLdqzYS5eONGxhiR3gC7Jw/1Znq5DmbJtuwsOldHXhSJMRcN3g
         zwsA==
X-Gm-Message-State: AOAM532FVVACHCQw7iscjRzxlvs06Wgn1liGhiwz1/TB5eco/Iq1zi/F
        ObuO9TXgtn/VdQIhLlhemy8LCw==
X-Google-Smtp-Source: ABdhPJycw88+zgGR+lUaMUyVXFbk30NVIRdTViB8sEDFCafSyfaBak/frZMBGh2Hror9H6AOCJeNLQ==
X-Received: by 2002:a63:1f25:: with SMTP id f37mr6637053pgf.142.1619449788778;
        Mon, 26 Apr 2021 08:09:48 -0700 (PDT)
Received: from ?IPv6:2603:8001:6301:5a88:95bc:39d4:dfd7:ed9e? (2603-8001-6301-5a88-95bc-39d4-dfd7-ed9e.res6.spectrum.com. [2603:8001:6301:5a88:95bc:39d4:dfd7:ed9e])
        by smtp.gmail.com with ESMTPSA id o15sm15512939pjk.48.2021.04.26.08.09.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 08:09:48 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2 2/2] KVM: VMX: Invoke NMI handler via indirect call instead of INTn
Date:   Mon, 26 Apr 2021 08:09:46 -0700
Message-Id: <E67D7461-68B3-44E5-ADB5-52E5A4D3897D@amacapital.net>
References: <20210426145104.GW1401198@tassilo.jf.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshanlai+lkml@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Andy Lutomirski <luto@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20210426145104.GW1401198@tassilo.jf.intel.com>
To:     Andi Kleen <ak@linux.intel.com>
X-Mailer: iPhone Mail (18D70)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> On Apr 26, 2021, at 7:51 AM, Andi Kleen <ak@linux.intel.com> wrote:
>=20
> =EF=BB=BF
>>=20
>>> The original code "int $2" can provide the needed CPU-hidden-NMI-masked
>>> when entering #NMI, but I doubt it about this change.
>>=20
>> How would "int $2" block NMIs?  The hidden effect of this change (and I
>> should have reviewed better the effect on the NMI entry code) is that the=

>> call will not use the IST anymore.
>=20
> My understanding is that int $2 does not block NMIs.
>=20
> So reentries might have been possible.
>=20

The C NMI code has its own reentrancy protection and has for years.  It shou=
ld work fine for this use case.

> -Andi
