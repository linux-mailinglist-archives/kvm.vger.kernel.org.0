Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 906A62BC9B
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 02:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbfE1AyV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 20:54:21 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:43408 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727684AbfE1AyV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 20:54:21 -0400
Received: by mail-oi1-f193.google.com with SMTP id t187so12969765oie.10;
        Mon, 27 May 2019 17:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CyGL+Gzz1OCZVAhgEsSHyzkITvlFztFNw+6oOcVM9cg=;
        b=djnjs2RUSwHGY/v4OQF/ZJrahrla8igfeXdWmA9d3iOjcMQrYgkpiix5xdSCBh98iu
         laFG5cbI4EzTCL2/wU9GBteCHfHopSbi0Dq7TGIurT5VkWo4YveKmWtSn7wh6BupGQVD
         OFujvDeEguyxv1THUl+TX4iWycZEKiVTeL2k3DjFazf233xgKg36xquHlPYMfA/uCWR5
         Dn62HiKT2feDDkqm/qKgjOoe6Ia80dpi3GBbTdqh+xMuP0uKHjXjFkVwyewKPJCopanT
         QwN3LyB7OnqaKdy7ueMN0UDHSEe79iT5PyXlMcBIAnMZmQcFrJ0Jg7SwZu3B74sd7zis
         IHYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CyGL+Gzz1OCZVAhgEsSHyzkITvlFztFNw+6oOcVM9cg=;
        b=FkogbJpqfkyfXd+sVh00liltHQfYFHdz5VWlsE88elNZMfm0DvgbjJ2NNoSZQ8CHgf
         f7fONGDBMIduzwxzXG9HkU7TAcuOgLPhUKYMlEBXcP5E4xQzkqCtvkJobFaEIKQK1zg3
         9cq6JADDmyhuaQRPm03simhqiQmH/JzZ4KTmhtc4ozScW9pJQ0jpxhaXH0ApR1V413r/
         ywbOzFr58B+dFKMI/wZ6uWq1Mg7cBiLxBYfZe1CVCx66BDr+of8EmyfekWyKUbeoVG2K
         YuiHTRsQulkaUnHw6q0CwlO+e+LOX5s6aKNEti5ep0PDeSgyqL87G39YqlDFn8+upjhS
         Fy9g==
X-Gm-Message-State: APjAAAWtuQvbBV3YvAe5vdNc8uLXF+5VUGTQ8IMM2HRW00BNisDEsQR5
        crJuiV8ptrjWZ9YBWH+sGPoo3+HIqb6WhNJVj/s=
X-Google-Smtp-Source: APXvYqy1v0cxAIDP995S1iQku812LGjMdQs7YnIhaPAVVN6yna38JryHmVnsG9yn2jcYCXQtebZ2DBIKcaaEYdTZ0xo=
X-Received: by 2002:aca:b7c1:: with SMTP id h184mr1071347oif.5.1559004860460;
 Mon, 27 May 2019 17:54:20 -0700 (PDT)
MIME-Version: 1.0
References: <1558953255-9432-1-git-send-email-wanpengli@tencent.com>
 <1558953255-9432-3-git-send-email-wanpengli@tencent.com> <0b8525d8-e26b-e4df-508d-b6a4d9c06a76@redhat.com>
In-Reply-To: <0b8525d8-e26b-e4df-508d-b6a4d9c06a76@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 28 May 2019 08:54:14 +0800
Message-ID: <CANRm+CxEa2Z1Ob=pEM03AvryHUfjg-MEc75w5_a-wHzrb9NtvQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: X86: Implement PV sched yield hypercall
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 27 May 2019 at 19:54, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 27/05/19 12:34, Wanpeng Li wrote:
> > +     rcu_read_lock();
> > +     map = rcu_dereference(kvm->arch.apic_map);
> > +     target = map->phys_map[dest_id]->vcpu;
> > +     rcu_read_unlock();
> > +
> > +     kvm_vcpu_yield_to(target);
>
> This needs to check that map->phys_map[dest_id] is not NULL.

Fixed in v2, thanks for the quick review. :)

Regards,
Wanpeng Li
