Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812E422F456
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 18:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgG0QJj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 12:09:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33819 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726942AbgG0QJj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jul 2020 12:09:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595866177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OPQOqiZCF/CXGUjGCPsDuUPFb0RD1RJET28Zyk3zKE4=;
        b=hCjtKjd7/AELjjEaFiP7dQoPy6xdxdTT4b8Q24hbxY4aI2xDAXDKX5FbzWwT7UEB+9cIZt
        kBTYOmJ2lPUBp6g3XXRznMEpF9Pz/bov0Y2dzy2Lz0ePHrH6dOkO5CyDJHJYPZc4GOPLM1
        G0F/0/lPuzgjk1+5Ct3kY9n0m4JchSM=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-9PoBM5gwOm-5sCmb6W2S7Q-1; Mon, 27 Jul 2020 12:09:35 -0400
X-MC-Unique: 9PoBM5gwOm-5sCmb6W2S7Q-1
Received: by mail-ej1-f71.google.com with SMTP id l7so633889ejr.7
        for <kvm@vger.kernel.org>; Mon, 27 Jul 2020 09:09:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=OPQOqiZCF/CXGUjGCPsDuUPFb0RD1RJET28Zyk3zKE4=;
        b=sWHVJKKfZH20b6CyQ3AKrPPFy/BBo9jmjvrf7OJOLV/dAeMGZ9cQEuuAl/Af9saZra
         xscCwjUOMoMK3o4LoYgXCeV/vERA9M+V5yJyo78X4Qwyoxxb12uB9DAI+pXlVSMOy2VK
         TjAu19GisfNfWN86Am1Y0bzVjXN6ri+9lKmbPVEaAjiYzkkcAi9FukS7cK7SiV0o6A1t
         WXGOgCxz7PvA5sNK/4+aAYH1XFjPlRf00806FVHPn12owFVp3XwF174SB61kR7eWwMyV
         +ZMfINZ8vdWBv0fK9AwP7Oy8YiBYwdXoxQKYwqLxQrt9uSo5SUfoVNTvCz9uZUGfHsVm
         g/6w==
X-Gm-Message-State: AOAM533SUVw+7gH8W/VtgB1aQVGWiTCOPscs+SyznwnPrIIm5xFEuPz5
        QurEz5oo5YVaXma6uY5+pvGtcF/6ZCvqSPoWnLoUnZTyTZvXRnKpHaWTTnq5UN9unWcqP2BCVwO
        b/pa3LyecdWxE
X-Received: by 2002:a05:6402:cb:: with SMTP id i11mr9374794edu.372.1595866174555;
        Mon, 27 Jul 2020 09:09:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/hhArY+P/WnFI9GEc6R3AlSG06qBpjRYmUOuaXpr8IMw0UcMbxhNf3VfCAhBOae5V8WHpqw==
X-Received: by 2002:a05:6402:cb:: with SMTP id i11mr9374774edu.372.1595866174365;
        Mon, 27 Jul 2020 09:09:34 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id gh25sm1891816ejb.109.2020.07.27.09.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 09:09:33 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vivek Goyal <vgoyal@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     virtio-fs-list <virtio-fs@redhat.com>, pbonzini@redhat.com,
        sean.j.christopherson@intel.com
Subject: Re: [PATCH v4] kvm,x86: Exit to user space in case page fault error
In-Reply-To: <20200727135603.GA39559@redhat.com>
References: <20200720211359.GF502563@redhat.com> <20200727135603.GA39559@redhat.com>
Date:   Mon, 27 Jul 2020 18:09:32 +0200
Message-ID: <87ft9dlz2b.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Mon, Jul 20, 2020 at 05:13:59PM -0400, Vivek Goyal wrote:
>> Page fault error handling behavior in kvm seems little inconsistent when
>> page fault reports error. If we are doing fault synchronously
>> then we capture error (-EFAULT) returned by __gfn_to_pfn_memslot() and
>> exit to user space and qemu reports error, "error: kvm run failed Bad address".
>
> Hi Vitaly,
>
> A gentle reminder. How does this patch look now?
>

Sorry, I even reviewd it but never replied. It looks good to me!

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

