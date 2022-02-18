Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07FFA4BC2AD
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 23:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240121AbiBRWuW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 17:50:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240086AbiBRWuW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 17:50:22 -0500
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49DB727374F
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 14:50:04 -0800 (PST)
Received: by mail-oo1-xc35.google.com with SMTP id d134-20020a4a528c000000b00319244f4b04so5293900oob.8
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 14:50:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+cdiIGkssQ+NChVNtB3F7NzFL5cEUK11+I7KTdnPHCg=;
        b=RLI1w2G6OXRv9chHjkl3uFc/Me0bhCfGJIT8IcPlguaxc0fqvFtNRl5+5VgBzzkCsm
         b40D8Rp/rZas7tZmbAUZCcvFdexD/jDXb7d0XUjpvhXiBEqfvTVi414nViOoTVjzSzy4
         m+5WKB/qLSGvGT/NXNBeVbvC7wIfSQa9eEsUAc3/6cF1sZqRldOoWBkt9XOp1YKQQPCu
         wM7GPJVy3VgplHTx5ULmug3ZLxE8KjDJ5S0DAlJcQm8fFbnXjWzgdfaVuRMEMaUgqg3u
         P91MqNq31GL194KCHEiCj+xw1xYz70sYN1Gy8oSSnu7iFjOcZb9xw9QuHMQYTIvSNbDN
         UaWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+cdiIGkssQ+NChVNtB3F7NzFL5cEUK11+I7KTdnPHCg=;
        b=HhgumDudbw2CxgBmHx1l7dt1OyCJGunBBofCrimjZFtHM5tleq872cVJ1wZ7VZO51t
         EEmeINgXjEPdUbTtWotEWvDHHcz4NPq/k8X9/rdbUJwOeuh2LFtT5YzFaEAJLC7Oxu1A
         aEVx3kcfQ2vnLbh2qBNUBwVJh+h07PSAWXzGTMgkxShowc888VmGFFpRdZD4GLgevQVB
         xfTL+2k7kUDYWffGPMfJ00zec0uF38z37wICK6SgS8XMOSKQDD/+yodQEBcArOBqD856
         Ia4WGya+4vmyh1yj/JrUa9//jozt+d/xbv9ZNMWiLcXO2Du6xfLIW1cEjptVQzIbHDXC
         i0IQ==
X-Gm-Message-State: AOAM530nC4ftXqzVBWSts30pAt8RVCbiskLWKaA/jmSbQEyQb8vWLHsC
        mlMmkLKTBA8+om6y1kVxMZpoqqJs8vUSoH6mZsi31w==
X-Google-Smtp-Source: ABdhPJxnI9G31O1tb1jcxHv5OWlRyDwN+PgaZ15TmgRAyLnIT8LAwDMBVuQOI4o3yLZw3jLVMECRNbFjySI4RzRAhkA=
X-Received: by 2002:a05:6870:2890:b0:d3:f439:2cbb with SMTP id
 gy16-20020a056870289000b000d3f4392cbbmr1196901oab.139.1645224602006; Fri, 18
 Feb 2022 14:50:02 -0800 (PST)
MIME-Version: 1.0
References: <20220218221820.950118-1-swine@google.com>
In-Reply-To: <20220218221820.950118-1-swine@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 18 Feb 2022 14:49:51 -0800
Message-ID: <CALMp9eQzCQQ7ADMkNDDjHu1Rkx1qr2ABY+aA8e8rt976hLbVdg@mail.gmail.com>
Subject: Re: [PATCH 1/2] kvm/x86: rename kvm's read_tsc() as kvm_read_host_tsc()
To:     Pete Swain <swine@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Johan Hovold <johan@kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 18, 2022 at 2:18 PM Pete Swain <swine@google.com> wrote:
>
> Avoid clash with host driver's INDIRECT_CALLABLE_SCOPE read_tsc()
>
> Signed-off-by: Pete Swain <swine@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
