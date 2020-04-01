Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B40619A596
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 08:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731858AbgDAGqy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 02:46:54 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:34443 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731735AbgDAGqx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Apr 2020 02:46:53 -0400
Received: by mail-oi1-f196.google.com with SMTP id d3so16734590oic.1;
        Tue, 31 Mar 2020 23:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=czSx9377GYpy/1wb2yZJ0MIsP0PMgtaOO/qXXQM+uDI=;
        b=G9rC5EhkbfmsW7j5QvkHH75YNwQJxfR9ct1y223SSvT2GZWjNVqCuiM1pjpa+RY+ci
         bbfUrqIxkhfCQaMLN2LobgWDJw0PPxw8GSpqFatl4PYNF000CN8bBRSSX8HU5W6bwtdn
         0WyKmKTD/6o4uO7esRPxwnlzDVZBlq4W0zdzOFbOraRQAeYg0y50KB6Sr4AHKjk6gDkU
         hddsghbhcQQV3ZxNZCntZY10ymIWKMBwW1cd529jK06TMAgSF1fxjssuEa76CGvNULgy
         vnBJQA1lzUlieftILirVdJweYgzeN0pbmKKxR947/IR2+2AnFx+o0NQwoyp6SOTGkAB0
         3+UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=czSx9377GYpy/1wb2yZJ0MIsP0PMgtaOO/qXXQM+uDI=;
        b=dfR7K4/bXY3C1gZE3hC2k/yYSSF/7zgUk+6BfRVYrAtHq8FuEeY0AoXQRT+E3PpRvA
         NHOMnqh6BSmo8lBQOJU5zfacn10IP60rYqsLVizZWjoPU5hX5rRAGEzgcSWpQaLasOdc
         dJ6A6c4sLsehATJVWtE7rvUcDvnLm7KAEHUQcWRtYWlIQzvn3sWDy6+woLAX4+2/uHE5
         gHJ5V5ubdpsAiyrdVyVOMF/pUQCywEB/nkmSoHxGiiujsfwaqIOBdk01szj492KkJcav
         4mDhnK8NMv2q/1B4lDZJ324AmxSGVQe9F4GnHqoPJyKX77ayvtFba693iNapEnY38WDD
         fr3Q==
X-Gm-Message-State: AGi0PubRmUquaIa3Y3vpSsAq3mT4rN0FuInCXmlxrV3wcr/dAf53YiXe
        pbUMG4waUG3hbtBG9G1ZqB/rtVA4s5hRKVcGyDc=
X-Google-Smtp-Source: APiQypIubsswkhEDjT1/kyw7FRBlDrAGMw3nmD1HU9SlYKgIEINkraztP1Dzc/C9m/pRnTRoe5NRPeowRo8zL+ecNAM=
X-Received: by 2002:a05:6808:b3b:: with SMTP id t27mr1832300oij.5.1585723613321;
 Tue, 31 Mar 2020 23:46:53 -0700 (PDT)
MIME-Version: 1.0
References: <1585700362-11892-1-git-send-email-wanpengli@tencent.com>
 <1585700362-11892-2-git-send-email-wanpengli@tencent.com> <6de1a454-60fc-2bda-841d-f9ceb606d4c6@redhat.com>
In-Reply-To: <6de1a454-60fc-2bda-841d-f9ceb606d4c6@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 1 Apr 2020 14:46:41 +0800
Message-ID: <CANRm+CzB3dWatF7qOO_WajXM_ZBn1U6Z8+uq4NxCuLG3TgwY1Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: LAPIC: Don't need to clear IPI delivery
 status in x2apic mode
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Nadav Amit <namit@vmware.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cc more people,
On Wed, 1 Apr 2020 at 08:35, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 01/04/20 02:19, Wanpeng Li wrote:
> > -             /* No delay here, so we always clear the pending bit */
> > -             val &= ~(1 << 12);
> > +             /* Immediately clear Delivery Status in xAPIC mode */
> > +             if (!apic_x2apic_mode(apic))
> > +                     val &= ~(1 << 12);
>
> This adds a conditional, and the old behavior was valid according to the
> SDM: "software should not assume the value returned by reading the ICR
> is the last written value".

Nadav, Sean, what do you think?

    Wanpeng
