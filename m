Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4D31BCF32
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 23:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgD1Vzg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 17:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725934AbgD1Vzf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 17:55:35 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D99DC03C1AC
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 14:47:03 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id r2so445875ilo.6
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 14:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=76NwtcJFolRpkssepMqzzHW6HjfTr+1YoDKxexuV45Y=;
        b=MPCuda/sCllNWtDmaB2Z8BpFCPmPYapCKuY71j1CJ3zJn0c1Rh5QkHwgW2snCRZsgp
         HV3ItMCtbPp9p14VV+dchHw5H5QSxUNJwE7Ay+0fRQnxVytV3Tf3iYlUKDVhSIzdc4va
         /snaOKzBHe5dUgseXI6IqCnpJsPLz6pHO3JSuSX4QcLFVh9hdKUROM+2O/V5D934uP3Q
         rbd7adUyVoUJ2VaOqvxbiFbItcLHKxAUtiAbwP8yhyWXrYoC6UEzX5YUrnD1c4Jdd0KC
         FiNNuvnN0PSPR0pRrcjM+iOLTmEysfF21xRQbwcnvZkLW0ucwG8cTFH68TRnhzDOy/Qf
         gJOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=76NwtcJFolRpkssepMqzzHW6HjfTr+1YoDKxexuV45Y=;
        b=XmI30kvsbSVm8mkesu4oe/flfMeeIY6cW0H5/PzCUAeuiDai2WS8dwJRf1keJkfraV
         aOUMTdUSlz/qCoUoue6qqj7KVmm1OFzrHVXGVUI9z5kAFLvDFodBOXBaJt/qnHfhWsPN
         AVkmNjDgDtLFmbhGpPcEk7ZnYq0dmgEWcsj37naVXs6LePhuRVzO/1oQwDi86XCpjagt
         ETa1Z6i7tPpeZJadMqr5iRc/BGy6qBEUf1xSKoZ0fmzRZK210ZRJVUD2i6lMLknVVTa1
         b3nJDTLZk//+TJwioC+uL0kbD7dCfxH16hTe2ZDND+vuhFNa7rIGksgWsz8ysOA28Yyu
         b1LQ==
X-Gm-Message-State: AGi0Puav9kCR3Q9jZk8uhDy3zDWo3V/XsVaJO+o6cGh+uu5jXxjtMvlh
        szIXMfx8mG6UScBIpe9YEAs+3hTgNwcN/RablAdtnw==
X-Google-Smtp-Source: APiQypJBobtGHzmKTfOmqkB1rhDOoIuXbsBLejVtVlTBZageEuCay/mjHv6SX62C34lGE/3iCsJIY5BzlgGxahZuE1g=
X-Received: by 2002:a92:da4e:: with SMTP id p14mr28469010ilq.296.1588110422235;
 Tue, 28 Apr 2020 14:47:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200423022550.15113-1-sean.j.christopherson@intel.com> <20200423022550.15113-7-sean.j.christopherson@intel.com>
In-Reply-To: <20200423022550.15113-7-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 28 Apr 2020 14:46:51 -0700
Message-ID: <CALMp9eTFm9T1b66Za2BXxUhZmNRaXNjid3RJ3YMLmg68imx6=Q@mail.gmail.com>
Subject: Re: [PATCH 06/13] KVM: nVMX: Report NMIs as allowed when in L2 and
 Exit-on-NMI is set
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 22, 2020 at 7:26 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Report NMIs as allowed when the vCPU is in L2 and L2 is being run with
> Exit-on-NMI enabled, as NMIs are always unblocked from L1's perspective
> in this case.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
