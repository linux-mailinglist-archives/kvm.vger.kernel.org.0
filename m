Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A447237CBE0
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 19:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237700AbhELQib (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 12:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbhELQ2E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 12:28:04 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F269C08C5E8
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 09:01:46 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 36-20020a9d0ba70000b02902e0a0a8fe36so14679536oth.8
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 09:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=67GBblEAGB9WLgeOeBpApB9usk3bEbWD/2tEfYYl+aE=;
        b=ibX0o4sOwz+ZsYSZLITzJYNKwD1kn1hUz8/1cjc6MwGged417D8SwQSR8RJIiA4QQe
         +rbhxtBxMhiSCIcYwK10O/GXssX2h/sKlNO0IfSFF/X8YPFkrOmWOPzQP+BDtTUemeLq
         UbjC2rjrB+RaQ/0P9wdlLXu9YlSqHrvWuqbXPTfUzo4lp3azmdLi86gDiYMfMwPXpuRD
         E+ykqAfFGXyn/f271bPNKEeujb0nvBEOfwaYC+AURvJZnfUlHM80OK50Q05hLO1s8NSG
         WEWTYXZnPVcTnCzxZaehInx+SOtj3dqjlYRIcHgVg2+3cw9kn4111mLgyfR5d6p+2rUC
         RpEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=67GBblEAGB9WLgeOeBpApB9usk3bEbWD/2tEfYYl+aE=;
        b=H88u2crVPmxqomGdFkrPzZAiq1XK/FfdI40zXZil//kRZZNRkua5snf6MvmwMesjEp
         L7ScQJzv1BH6kU/xzekVItzRZj4Y9fauiRaWJVREmpjkoZSt8ViuzcK3Z+ZpbLOv1i8a
         E1pXLVvlU8j/YA0X0AVtiNY9KOCPap2t2mTG2ie12Sa/X1702MksJMVmGbwsasH03dNz
         PE5rbbrcaHAPMHUOWz13B0IEh1NDtWkSyhekQrn4saWxnmMkbOE1iM9iY4AoI2jZ8Ypp
         j0nQ4PcXjFhbRIqRQ0Oyn4G9OA/hYOqAB3N2asvjVx+o6qnoUTVmfUDOA+nsDDyWRi1+
         zXlA==
X-Gm-Message-State: AOAM532som04q3MULB0+papTfHvkQzxi7r4Cd/ECJ/HN6zzxTwidkbqJ
        myRUe0hBSmXKEAZYqyW/9tOEZZQliZoSaU4vLX3n5w==
X-Google-Smtp-Source: ABdhPJwkfD2EDTzipneN2U+5nUeKD3bcPbP8g8eG4VB/l1TIvn0XesMRARIc85pMHniAYYuxyyE2OUlbLXF6njT6TEk=
X-Received: by 2002:a9d:2966:: with SMTP id d93mr10799288otb.56.1620835304872;
 Wed, 12 May 2021 09:01:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210512014759.55556-1-krish.sadhukhan@oracle.com> <20210512014759.55556-3-krish.sadhukhan@oracle.com>
In-Reply-To: <20210512014759.55556-3-krish.sadhukhan@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 12 May 2021 09:01:33 -0700
Message-ID: <CALMp9eTCgEG=kkQTn+g=DqniLq+RRmzp7jeK_iexoq++qiraxQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: nVMX: Add a new VCPU statistic to show if VCPU
 is running nested guest
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021 at 7:37 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
> Add the following per-VCPU statistic to KVM debugfs to show if a given
> VCPU is running a nested guest:
>
>         nested_guest_running
>
> Also add this as a per-VM statistic to KVM debugfs to show the total number
> of VCPUs running a nested guest in a given VM.
>
> Signed-off-by: Krish Sadhukhan <Krish.Sadhukhan@oracle.com>

This is fine, but I don't really see its usefulness. OTOH, one
statistic I would really like to see is how many vCPUs have *ever* run
a nested guest.
