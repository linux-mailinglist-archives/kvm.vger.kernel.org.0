Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB4A21A55F
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 19:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgGIRBM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 13:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbgGIRBM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 13:01:12 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7720C08C5CE
        for <kvm@vger.kernel.org>; Thu,  9 Jul 2020 10:01:11 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id a6so2601049ilq.13
        for <kvm@vger.kernel.org>; Thu, 09 Jul 2020 10:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pxQ/zQslbyaatj+4DJo+g49oP9bHc9a3pxOIionupIU=;
        b=HBL5n2hQ7tibKH6zFDuRXYrP9hRloa1TzUfffPq+NooSnREa1Jaymkrrt4Is/M5tHS
         kTTG4BCuByDfp2MlTAa2TWRVIpY7NnbAIvu890asuhTMtUAoM48V/bYxx1g5zv0uX67L
         flt/bCaGZg4WF+96ax4CNYIB4eWvr/qblC4GWbaM8qOKF5+bGI4GuGQpRkRK1ohdnUdB
         /CObCJ7g8T/ORyY9d4xrOpd1yu1mBLMpHskU1rjo7HtxQ/qWQXLH7i1b/8+qpD8ZzrqV
         3dXsjdyPnuQLla5+ohnngw2m/CYSN8tXsZEnPrzW3OhoZJwW5UQ39tlhfptatlw1aS/m
         u4tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pxQ/zQslbyaatj+4DJo+g49oP9bHc9a3pxOIionupIU=;
        b=K7Zi/XaZkYU+30hIHGxVAJfcYmEln7DFO8/pfFox0EDYbPd553HTBeZxRwvt7eXhkV
         b72KbDVtkRYbmEXL9U8CBTJ52L1V6028tGkw0BXbE7nJL4z6vZN3TaJJgmPMaHSNMhGA
         Z5hfZOmRFFkftKoRq2sZ3bOdin0wo3X6DPTc5sZbghc02KGptqDDh4Pl7q6uwJGpyfTj
         G4jIUiC2V8B/iI0+jfGJLSkuiMh/zwFEK0RD+3M/wxTMfCO2KhVKNG4HuVKzZ+UYMJ6n
         ujzFsL0N0gGMaNKA16tuX2x3BN3hksbbgjOP7O+BNTG/Aw8OhAYgkBsN70ARSJDei/ad
         HHcg==
X-Gm-Message-State: AOAM530p4jhO3A47qbo4bybb4SovZ8q8iKv95Vg6DygE1RsedxIzvu05
        OXDRBtan5Pnv6k++IaTiXEB8tWPpkdXvC1MKzVidzQ==
X-Google-Smtp-Source: ABdhPJzRVQ+Y0SpPndi+v89rrOa93UbwDZyHhDi/MzMpDt2JtDC3aQsTkwCRFg4KJ211U/NpWuVphPV2BKWDHBB3U98=
X-Received: by 2002:a92:c989:: with SMTP id y9mr38741154iln.108.1594314070847;
 Thu, 09 Jul 2020 10:01:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200619155344.79579-1-mgamal@redhat.com> <20200619155344.79579-3-mgamal@redhat.com>
 <20200708171621.GA780932@habkost.net> <20200708172653.GL3229307@redhat.com> <20200709094415.yvdh6hsfukqqeadp@sirius.home.kraxel.org>
In-Reply-To: <20200709094415.yvdh6hsfukqqeadp@sirius.home.kraxel.org>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 9 Jul 2020 10:00:59 -0700
Message-ID: <CALMp9eQnrdu-9sZhW3aXpK4pizOW=8G=bj1wkumSgHVNfG=CbQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86/cpu: Handle GUEST_MAXPHYADDR < HOST_MAXPHYADDR
 for hosts that don't support it
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, mtosatti@redhat.com,
        Pedro Principeza <pedro.principeza@canonical.com>,
        kvm list <kvm@vger.kernel.org>, libvir-list@redhat.com,
        Dann Frazier <dann.frazier@canonical.com>,
        Guilherme Piccoli <gpiccoli@canonical.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Christian Ehrhardt <christian.ehrhardt@canonical.com>,
        qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Mohammed Gamal <mgamal@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>, fw@gpiccoli.net,
        rth@twiddle.net
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 9, 2020 at 2:44 AM Gerd Hoffmann <kraxel@redhat.com> wrote:

> (2) GUEST_MAXPHYADDR < HOST_MAXPHYADDR
>
>     Mostly fine.  Some edge cases, like different page fault errors for
>     addresses above GUEST_MAXPHYADDR and below HOST_MAXPHYADDR.  Which I
>     think Mohammed fixed in the kernel recently.

Doesn't this require intercepting MOV-to-CR3 when the guest is in PAE
mode, so that the hypervisor can validate the high bits in the PDPTEs?
