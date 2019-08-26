Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11A339D426
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 18:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732574AbfHZQhq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 12:37:46 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:41137 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729357AbfHZQhq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 12:37:46 -0400
Received: by mail-io1-f67.google.com with SMTP id j5so38784634ioj.8
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2019 09:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6PBet8kiFCLsyoY5k5933kx3p3updcUzabH4H7FnS/U=;
        b=kZEZnPxT6pshXHiHmaWOMBBQIfFt0A6n6skg8q03gbcNm1yQ0oZPYGt6SUeA0aW9yj
         +NoZTwD6etHrAepmKT9Oirhcg0SQdal7YoQrMWposxSoBrsFeHCoNz6XOU0w+vMSnvKf
         sjkfxythhztMlXWJ3U+db87fiPRvlSBl3N7YYaEhxLs/ivAFRRz39Fn8kAkXNzRv0BR6
         c+uUWHfk0OuvbJnnx9/Mn391EYWDBvVgwg+NYM8/k2RMfnjV/+7zfNAbnn3HpGCPBtqi
         LEpO6A6feV9V4cTlUML1Xd4ooyBJ3VMaPDuv6U09aCexNS5eh/1eNewEx+5T9S3Eb7iU
         BP3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6PBet8kiFCLsyoY5k5933kx3p3updcUzabH4H7FnS/U=;
        b=oHZ2BC57tfRRMHDyR9Z8/tbeIuDZ0zuDsQ9NHT9+cEISdrsnWXOL7bz8H5dpcQKoeP
         sGWlWnM4N7ZRZbagKhr2pvf2NtGymwnOWRT8YSjTxadIPx15zOtr+cB0xx5JdwhZr7nc
         vq0ushQWvFMnQ2tTlDkahQ5PTZ/pA/O7OEBjiiozVW9WaMvpA3C8BMYiZM3GImOXqoz2
         hacNR6I1eivdk4ylo7duwva2LknO5DE0CHnieB78Kdaa0xuNu3U+QcyXEp5SY8MVvxNn
         NHLeB2mVIQ06ISejsIJjor3ww4tVl7bXkwy2i6aJ+zmPcgVZPB16mQazXvPJBHWwd5o0
         z5Rw==
X-Gm-Message-State: APjAAAWpIsDW/Mb0QHFjsH7EEXIydA5pa3WdyClzdyoLU0kDTIM48EqS
        TUd2MJi98w6uxb1p/g2ERNaduTbtGKTiHP51AHI34w==
X-Google-Smtp-Source: APXvYqxfJF1Yzniskkn6Y+VLsEA8+Ldv5wLLTs/6E1dAOMnZSUJHLmE1dIOVzVk8f2v8EDaXEDgV31FqHO7AVNxedME=
X-Received: by 2002:a6b:6a15:: with SMTP id x21mr16306436iog.40.1566837465281;
 Mon, 26 Aug 2019 09:37:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190826102449.142687-1-liran.alon@oracle.com> <20190826102449.142687-2-liran.alon@oracle.com>
In-Reply-To: <20190826102449.142687-2-liran.alon@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 26 Aug 2019 09:37:33 -0700
Message-ID: <CALMp9eQeB-e0-8-7uvQN37L7aEL6OaXU+5v4-wwCQfqdLQdm2A@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: VMX: Introduce exit reason for receiving INIT
 signal on guest-mode
To:     Liran Alon <liran.alon@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Bhavesh Davda <bhavesh.davda@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 26, 2019 at 3:25 AM Liran Alon <liran.alon@oracle.com> wrote:
>
> According to Intel SDM section 25.2 "Other Causes of VM Exits",
> When INIT signal is received on a CPU that is running in VMX
> non-root mode it should cause an exit with exit-reason of 3.
> (See Intel SDM Appendix C "VMX BASIC EXIT REASONS")
>
> This patch introduce the exit-reason definition.
>
> Reviewed-by: Bhavesh Davda <bhavesh.davda@oracle.com>
> Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
> Co-developed-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
> Signed-off-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
