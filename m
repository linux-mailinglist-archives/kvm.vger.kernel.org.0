Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35BFE3C8DD
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 12:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405388AbfFKK0A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 06:26:00 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:40106 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405196AbfFKK0A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 06:26:00 -0400
Received: by mail-oi1-f195.google.com with SMTP id w196so8525831oie.7;
        Tue, 11 Jun 2019 03:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GQNk2X+mqFzYu/l14YqOj+MZd5VlmZKor3lgSCt8XE0=;
        b=ZazrBdVDFN8xniS08ceQaj2CoYGYZdy/ZbsdBHxGR4WGi7Bp8XyaC8+AfJ1eSNyb2S
         uJi+eqLRcTo4KVFmVW/3nP0TXpWRSWKY6NRle6hwXroCAAfKp46B6fOrjXjnSvJ4hNGJ
         4nCnwcLQSlVPXwLyf56rgRYBS51zXNz9RiytZg+ZF0ArVPZSB8v7VlyVHQUDr/Vpo8lO
         btygHZC2671DTDknU3K3q3oud3HO+mIm5RmBMiPD8AIoXasM36pt3nKJ00vNJibLjxAa
         HqmDbo2BujiaEwcmjgzd+ufqyV510KsVC2n4/d/YVxteYgVGpHjB7SPNh3XCsEQAJD8V
         +HLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GQNk2X+mqFzYu/l14YqOj+MZd5VlmZKor3lgSCt8XE0=;
        b=pSV0BX+tkl0UO3Pg0j6sR2TLAZRy1mWEs1Hqms9S3caRP6GDIgCH1WVahSNMLHB/xT
         chwfQxE9QBAOHlOupAyJ5ca3OJxuFmnjN6dxf5YVOjZO237vaOFfL5L5h/ZieBNFNoRL
         h4ydcR7Aur5c4xC38wTTNjQYDgU+iDBqgvnXO6HN/T79CaWybrFw5FMcBaq5U3yoFi0P
         dR9O9LLE3beD8fBgwJiy3gIXoJdVRpH9g8ooRzE3dUpf/iVCELvY6S0dqAlXPZj/MTgk
         fkO3ENJ4qtmEY7FTJgElpoYYx4862krWHOHh/P511QNMh/f4VpFlxidvsbtu68vhVBQ+
         ezsQ==
X-Gm-Message-State: APjAAAXnoXr8g+od1Ag1hKdDePaelK0V2Nwm4ySDGU+Dj/sR39LFSgiR
        QGvW7zo+rkDE2NTgdK3B5duMpFrzAUIP8P/SWY8=
X-Google-Smtp-Source: APXvYqwCLPt2cDR6MpqGZkxAfKD7ViSk4snzzshaqe0gkPdTYUQk+Gfv6tdgkW1/hkqIlnJm3WFjB8AjqvTf/Cl03VQ=
X-Received: by 2002:aca:b9d4:: with SMTP id j203mr3907896oif.5.1560248759174;
 Tue, 11 Jun 2019 03:25:59 -0700 (PDT)
MIME-Version: 1.0
References: <1559178307-6835-1-git-send-email-wanpengli@tencent.com> <20190610143420.GA6594@flask>
In-Reply-To: <20190610143420.GA6594@flask>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 11 Jun 2019 18:26:43 +0800
Message-ID: <CANRm+CwgE5d0hQif0Rj-=q-orxMpSZq+tKLvrkZuatmatYxjWg@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] KVM: Yield to IPI target if necessary
To:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 10 Jun 2019 at 22:34, Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.c=
om> wrote:
>
> 2019-05-30 09:05+0800, Wanpeng Li:
> > The idea is from Xen, when sending a call-function IPI-many to vCPUs,
> > yield if any of the IPI target vCPUs was preempted. 17% performance
> > increasement of ebizzy benchmark can be observed in an over-subscribe
> > environment. (w/ kvm-pv-tlb disabled, testing TLB flush call-function
> > IPI-many since call-function is not easy to be trigged by userspace
> > workload).
>
> Have you checked if we could gain performance by having the yield as an
> extension to our PV IPI call?

It will extend irq disabled time in __send_ipi_mask(). In addition,
sched yield can be used to optimize other synchronization primitives
in guest I think.

Regards,
Wanpeng Li
