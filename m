Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 674EE449C5
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfFMRgW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:36:22 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:40198 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbfFMRgV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:36:21 -0400
Received: by mail-io1-f68.google.com with SMTP id n5so18780648ioc.7
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2019 10:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wuyZxNfgrI7BM+E+ydWJGlXujwTzOschBVbnlzkKX0I=;
        b=WMxpmd17td2/uZVkrQ11LSHO6aGT4MeYtJ3LToPljmZu085pzyCNyQz3yFsPk6m88c
         PU7JjCLNDqaLB+h6c5n12fZPks+X17B2TNVzQaSeBz4ZdtwSpBRSxqjB4fGwdZYTKj3a
         4BA+H0yQgU7gNc0kDRsTSZ8iWMKStcOtlZxIKc2HE+ci29O6wDGAZpyYsZlwO3/0bArZ
         mEcyaadhF5+0AcEBEdAN39AjKDTnt4nxWXSg2Ni/6CyjmMaxHC6f512+4tRciRolfY90
         9yJ1GDnHvyNYAN6n3DPi0za4hc105E14Sic8E1mHxNLJzfEk4U0T2+c7ikBl8RnL1ZcU
         2bHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wuyZxNfgrI7BM+E+ydWJGlXujwTzOschBVbnlzkKX0I=;
        b=VBLhk6pr2R4nqFFIYA52ckjjA1x7OEii27MYiHvNy9Mp4c8jTr3R1jXlZmVwWB4+O9
         iKvNxaQK60TF5n1aQAyePEpRtLbk9jJia+jH5RGWimJpXixIvp+ZYd80ype1C3GC68V7
         XNkrR4yzMvY9SIrep1gazKphyvCcg1dbOrww7Yum04snN51oyDM+Q1nDL5XPF75Q+uol
         g2mGEdIy5hZkBhrUCtdoBcB9DTTTzINayj8j3sCdc3k/fvRDJiegMIR8tpQ8jSbHHLup
         ugPlwDC6pMLw5q+EhC/noIJImdcOx4YT0228HdYMmo7ZithM0kYtxUVbMA2UtBR0FVfQ
         vKbQ==
X-Gm-Message-State: APjAAAX8PhA08JI0PC4S209q0KbboCrdfLeKNlGXFjnn01+WbI3SKavE
        jR638sYBDwQ1ubYYQh39sYJkE8bXzZ3cz3oToN3asQ==
X-Google-Smtp-Source: APXvYqyPB3Kyskq7hut+OLgzxHcWQ80LiIMDj7RRGsc1Ky50UShxrRDQfPiXKyT0DlmGxqY589dhPuXBDrk3PDLKwPI=
X-Received: by 2002:a02:781c:: with SMTP id p28mr61530969jac.31.1560447380886;
 Thu, 13 Jun 2019 10:36:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190507153629.3681-1-sean.j.christopherson@intel.com>
 <20190507153629.3681-2-sean.j.christopherson@intel.com> <CALMp9eRb8GC1NH9agiWWwkY5ac4CKxZqzobzmLiV5FiscV_B+A@mail.gmail.com>
 <9d82caf7-1735-a5e8-8206-bdec3ddf12d4@redhat.com>
In-Reply-To: <9d82caf7-1735-a5e8-8206-bdec3ddf12d4@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 13 Jun 2019 10:36:09 -0700
Message-ID: <CALMp9eQU-OLnGX40=tCjYPWen5ee3rziMHQOTt7fyd1NVdaAsw@mail.gmail.com>
Subject: Re: [PATCH 1/7] KVM: nVMX: Intercept VMWRITEs to read-only shadow
 VMCS fields
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Liran Alon <liran.alon@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 13, 2019 at 10:18 AM Paolo Bonzini <pbonzini@redhat.com> wrote:

> Also, while this may vary dynamically based on the L2 guest that is
> running, this is much less true for unrestricted-guest processors.
> Without data on _which_ scenarios are bad for a static set of shadowed
> fields, I'm not really happy to add even more complexity.

Data supporting which scenarios would lead you to entertain more
complexity? Is it even worth collecting data on L3 performance, for
example? :-)
