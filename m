Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9025FBA96
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 22:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfKMVXU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 16:23:20 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:34437 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbfKMVXU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 16:23:20 -0500
Received: by mail-oi1-f196.google.com with SMTP id l202so3235306oig.1
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 13:23:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G+uEAcqOgMk3UBhqAO1tpF1W3Ac+oxGGdsfy8LhT97A=;
        b=qP5X0/RCr0RgUzRSC6icyElHM86ot4DymfU69LcegaNgEbkoYr/AyCpYI9W9Wqmb8N
         xGUyIzmOitKOYcZiSy3M0EwPt2hnzaPXhBeIUQBOZN5D09AWG1g7P0FCVzHcWEeJLEEm
         kj0FzRcRBx3oqQ+avvn2BBC953gDrHUqiOqhJGZcqFFqJSswIkCZ+4sddaM6zcGnSyOK
         OuCVUsA6SEwpucLxH1dMuDGDeT1B4LeCHYYNGRhZDd9fn3UXeTdlO6XpDcvnbTyZxaXW
         niI+CfXQ1zGtDpNaZ7FORBLYm0vWfSnp1VyS295OVB44qsBCodGQbvzHoZ0ZHhxcwCXv
         swqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G+uEAcqOgMk3UBhqAO1tpF1W3Ac+oxGGdsfy8LhT97A=;
        b=hvVMKlAciv6K8yZll8LsYrGJ9dINB+XKAqeX/WAGMHGrxgxuKWeldEOEOlZNMqC36j
         6nLSyj6VR+2typycOmO6WDzfZMSwHDiEJmiBWdFfuLH9l4m1+CjhCVB7Kx4Je0ku5CuO
         xgOXVAOWf826VEyoWd3AOU9EqQ+sGri85AUk7CDP8h892ef+GZXxr1REwOlDXa6ItmC9
         ug+n06yMe/Qgohj8p6aOvta17NZFCVTCaZkQLdZ5qFzzxTCkYBbjtjeiCDPZ5O68U39Z
         5OpluYawZiVB3rVCY33atnAJml5xy80gXs6ULE3PMYrmz2p0PjaohZ/8113eiN6X0lH5
         9ZUg==
X-Gm-Message-State: APjAAAWhTyxoxfzD+MaQn6VjWjf8bLAp1wPWJHOTVIA04pblgG9sT/un
        vG8wHDqA51+OmIQbXwpw8olPGVm0mFB4xmfQ1c/fXg==
X-Google-Smtp-Source: APXvYqwT5MV1EAd6B8E7HzUsPm8h3pM2RdCEQfS3rFJpTfTLTC9FrmzoxGeW3dQHZ+L2mD7hSUt2wrNptFTUOLYvy30=
X-Received: by 2002:a05:6808:b04:: with SMTP id s4mr597320oij.163.1573680199148;
 Wed, 13 Nov 2019 13:23:19 -0800 (PST)
MIME-Version: 1.0
References: <20191113160523.16130-1-maz@kernel.org> <2b846839-ea81-e40c-5106-90776d964e33@de.ibm.com>
In-Reply-To: <2b846839-ea81-e40c-5106-90776d964e33@de.ibm.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Wed, 13 Nov 2019 21:23:07 +0000
Message-ID: <CAFEAcA8c3ePLXRa_-G0jPgMVVrFHaN1Qn3qRf-WShPXmNXX6Ug@mail.gmail.com>
Subject: Re: [PATCH] KVM: Forbid /dev/kvm being opened by a compat task when CONFIG_KVM_COMPAT=n
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvm-devel <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 13 Nov 2019 at 18:44, Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
> On 13.11.19 17:05, Marc Zyngier wrote:
> > On a system without KVM_COMPAT, we prevent IOCTLs from being issued
> > by a compat task. Although this prevents most silly things from
> > happening, it can still confuse a 32bit userspace that is able
> > to open the kvm device (the qemu test suite seems to be pretty
> > mad with this behaviour).
> >
> > Take a more radical approach and return a -ENODEV to the compat
> > task.

> Do we still need compat_ioctl if open never succeeds?

I wondered about that, but presumably you could use
fd-passing, or just inheriting open fds across exec(),
to open the fd in a 64-bit process and then hand it off
to a 32-bit process to call the ioctl with. (That's
probably only something you'd do if you were
deliberately playing silly games, of course, but
preventing silly games is useful as it makes it
easier to reason about kernel behaviour.)

thanks
-- PMM
