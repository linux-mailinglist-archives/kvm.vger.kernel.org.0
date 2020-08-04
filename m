Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A65D323BF75
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 20:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgHDSrL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 14:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbgHDSrK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 14:47:10 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777EBC061756
        for <kvm@vger.kernel.org>; Tue,  4 Aug 2020 11:47:10 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id w12so29692834iom.4
        for <kvm@vger.kernel.org>; Tue, 04 Aug 2020 11:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LeVbzIBEA3JOaGe5Ny64vb+/3rlySwvGG6S0dU+z+gY=;
        b=G8ZdWUEjxxyHgWzCQe0B1ecAHZLk61NFOtDkk9m2clW3KnV5q2QOH2uzn4EervoKWP
         kcibGnUOV/LrvKpwtTWQpnlSk6EglvK2qrnADqmESgCBgb4CZdsXNrT1H0avWeD1LmFo
         85/wFyyIp6Ap5IDOkR/n8vooOtrYyaEcU7n8QI+8fVyqeqSDtNzDJU0sn9hmjhx6+MfI
         MhEsbJzU5BXrgaJbR92ZTRkdRpH5Pu8uIhTcen1Ld/laoaCf7PH46J5qgt9COr3uiV/t
         partRNOaoamryeI1wR8OauRcPhHfbIpLxVkf9uDEYwSQQa6VwdDmcueeakaKF779Hcco
         PObA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LeVbzIBEA3JOaGe5Ny64vb+/3rlySwvGG6S0dU+z+gY=;
        b=YYbCMMTkWPoOXqXfo3RW/IbmqaJriHu0UKRx4ZpuDqAmXRjjI4L1ZWle1y+agmsSLr
         NxGUFjjK5sFsv8UmqCYNPq82Ga0dyfcqFebAReNEKe+KbqcLyoaFkMPO57s7aJG38EZ9
         cKzsoNVKtgDQkxJ8xAijIiU5/RD/BHHnTdXa+LJD2VxRNF2FRd311L/ZiRLVJAX9n1Gv
         dTTXc1wo7fuWbTXNQLPwCVQanKkXoV/tTXNHEoV8Ynd6d8n17lzWX8X3GSIvE9g86lJ0
         f8Sl8tQ4w6hPHzRZ4eobxVuyxv5S2LrwsHxsr6X8joUMT6xVNJjcfCq7dxYr6uDbNz+e
         oe2g==
X-Gm-Message-State: AOAM531VucpdrK1F3B8XmgizeRyuQA6xZLnjDbYkA/x9Ihwt5musiWwy
        HAbu3mQ3tiRO9Kjb793UUBkpeJikL9rd0vad0iqs2g==
X-Google-Smtp-Source: ABdhPJxHnlBlIg2y23Vk8YRGymkBF+ZKaZSs9iYjqD9jaNATOvINcmXJQoQGshzeLXGR+Y6Qz7mSWpgkBGBZx6373PQ=
X-Received: by 2002:a02:394c:: with SMTP id w12mr7393543jae.18.1596566829493;
 Tue, 04 Aug 2020 11:47:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200714015732.32426-1-sean.j.christopherson@intel.com> <20200804184146.GA16023@linux.intel.com>
In-Reply-To: <20200804184146.GA16023@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 4 Aug 2020 11:46:58 -0700
Message-ID: <CALMp9eQb32UB_tLowkr5T+Rt9SBdJbTkjHWyWFg+6ruJ_OuaKw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Don't attempt to load PDPTRs when 64-bit mode
 is enabled
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

On Tue, Aug 4, 2020 at 11:41 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:

> Ping.  This really needs to be in the initial pull for 5.9, as is kvm/queue
> has a 100% fatality rate for me.

I agree completely, but I am curious what guest you have that toggles
CD/NW in 64-bit mode.
