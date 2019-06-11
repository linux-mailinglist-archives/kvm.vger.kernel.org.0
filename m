Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE6663CAF8
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 14:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387934AbfFKMSK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 08:18:10 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:42468 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387780AbfFKMSJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 08:18:09 -0400
Received: by mail-oi1-f195.google.com with SMTP id s184so8746199oie.9;
        Tue, 11 Jun 2019 05:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0EMixU0L4b0ZCFegtw+unlifhiqds/4ljlhVrZwVzq4=;
        b=olo+i1fvsbiRzte8WBg6b/XYI4OTLZjRNtelDmZCpC/ugvjSPtaGA+OROyLdIZ5XAM
         Y7hYZmkUaNvH7Cn+fvA2T5mlNSF5V78Pkr654NIle8cn2fGYYCBZb4AWad4pPeSixZdl
         nYiGEpF7V5RfHsZoS4OgCr3mgC9v1Z5l4YctKKRGjiN4ZCo9+XJKOLDPwNK79ybWW0z1
         Uwgy+lI71VenOlzdOQ6uuH+RXpsRj86i9DVcb1nrwUBCujtYWDoeXigFQ3faJrli4T7s
         cV+i6iAKkri1gJHGSGgedONa98GFXZuw8TLVYZF9o29WUrp4oLWj4o9LKEqPA9fSXe0z
         Ygpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0EMixU0L4b0ZCFegtw+unlifhiqds/4ljlhVrZwVzq4=;
        b=PPj06HsKUVDVHoa9K6oN6WKWbIUBwMT1366IH6BGHMg6XlLMk8DRpaAYf5m3kqMBIB
         e3ei8goisdg8JiQy4/zTgW33oW9IvA4sWt97As5QhBTJ6yzlPAJ4D239/2xEVTP6I0J+
         UozIshstniS9HFbFXwaGsacKRcMlDjHmMHtuylAXA4I0U2wCCvLhn8NAeNne8KhRQ4q9
         v0fOu2/50Wmo0XX785D3YLGAjhXgLaLNx47Ps7J+ahhXrvpmYjNs1/WAF+L6KZBcKofR
         7g1rGiCgVn2fofsp926FlagbxUI+cxXrdpLbC1gRRaBeAcTt676XlnMfZFslHn3+KVvw
         k4qQ==
X-Gm-Message-State: APjAAAWruYSVFpwop6SfTQnZTwHPH6gfc+zelLIw80y7ndmyLaZz0ez3
        XqKHJr242/5V90udMfbQz6qMFo6jCnsK+I/6pS4=
X-Google-Smtp-Source: APXvYqwhX1Fh6qevzYmBcohucTwsr0U7S/n5WBCtBR3Xup9JGDJ09uPKIozcmODtjO9rtlvHTEfxvxZKtWGmkV16udM=
X-Received: by 2002:aca:e0d6:: with SMTP id x205mr14784719oig.47.1560255489254;
 Tue, 11 Jun 2019 05:18:09 -0700 (PDT)
MIME-Version: 1.0
References: <1559799086-13912-1-git-send-email-wanpengli@tencent.com>
 <1559799086-13912-3-git-send-email-wanpengli@tencent.com> <c5530947-d48d-e3da-3056-ed64f7fa9a9d@redhat.com>
In-Reply-To: <c5530947-d48d-e3da-3056-ed64f7fa9a9d@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 11 Jun 2019 20:18:53 +0800
Message-ID: <CANRm+CzgLov6AYDVLYOFvZvo+bLS9AA+3J_qSis6PK3f9_2utw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM: LAPIC: lapic timer interrupt is injected by
 posted interrupt
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Jun 2019 at 19:40, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 06/06/19 07:31, Wanpeng Li wrote:
> > +static inline bool can_posted_interrupt_inject_timer(struct kvm_vcpu *vcpu)
> > +{
> > +     return posted_interrupt_inject_timer_enabled(vcpu) &&
> > +             !vcpu_halt_in_guest(vcpu);
> > +}
> > +
>
> I agree with Radim, what you want here is just use kvm_hlt_in_guest.

Do it in v3.

>
> I'll post shortly a prerequisite patch to block APF artificial halt when
> kvm_hlt_in_guest is true.

Thanks Paolo!

Regards,
Wanpeng Li
