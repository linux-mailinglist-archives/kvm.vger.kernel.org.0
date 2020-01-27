Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4713B14A77A
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 16:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729518AbgA0Psk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jan 2020 10:48:40 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:33671 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728783AbgA0Psk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Jan 2020 10:48:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580140118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ev2DavOVeAfQ+Vr264Gj58ZrieELq0AxbNA2pCfvoOE=;
        b=BqrlSLP8xnuv4ZR1wDAuiDZcH/tZ1BPPDSGMFtvYD6jJT9xW1paQJcELmVg2BpN+fLHNKz
        uehnrHXUF7fD4zRf/kjqtDzzYRa8R30GGGYZk47qTPNoWKzA2YJCWor7jwCA6+ZfVlthB5
        htyTzkVqdLfaynBrZnRgWNJEpYuuns8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-p7oRtRRNN1S0dy9g8eSEVw-1; Mon, 27 Jan 2020 10:48:37 -0500
X-MC-Unique: p7oRtRRNN1S0dy9g8eSEVw-1
Received: by mail-wm1-f70.google.com with SMTP id g26so1478210wmk.6
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2020 07:48:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ev2DavOVeAfQ+Vr264Gj58ZrieELq0AxbNA2pCfvoOE=;
        b=NNtUtADjuZP2JR9ZyRjvkND8YLPnAAKPkpXdyKXd3zgn7Zij+jKbinblGyJSDob5BL
         yTRb+OZj2hDF/dGIsQFEGNhYMPMyDNO2ZAdBhF4IyBss5eVNg6SxwM0T2PzWQ5Vm0P6b
         fnI6Fwau8FuRCyCdzTPOWY4NMb9jg0P8DnhNzmgechW7QovCdDnoDTmniqsgv/mdacXz
         v3FLUAKeiOVC+F+x9H6unfyFA7N9QK48QijCY8bNE/eCIBpZoXPXi4rwtM3eUiTkLvw7
         UFKb+OgSO6Y8bYgaB/n7K8Eun99p91xwPt9gcn+z/+wcmA1SL72+T9DrYnoXcVdWLyFW
         WsZw==
X-Gm-Message-State: APjAAAWUS9klC0STnUWGMs7jcamfYnkQVkSpssZRkze0jsxtCzKQd2MP
        wroW5S42daMUCo6erRqauMhP3yv4YpslxfqfYzq/Z+uQT7FsdEeWvzw0VFhkoDDG3VN18i0wliF
        EXIXWKXMtUBX2
X-Received: by 2002:a7b:c19a:: with SMTP id y26mr15306297wmi.152.1580140115579;
        Mon, 27 Jan 2020 07:48:35 -0800 (PST)
X-Google-Smtp-Source: APXvYqyz7Ff2a08B/s8P5i+xjyQx3D2QYf/6C1n6kzVc+oMGzILnnFPXnRX3sq5VnGumfLVmxX4BYQ==
X-Received: by 2002:a7b:c19a:: with SMTP id y26mr15306280wmi.152.1580140115405;
        Mon, 27 Jan 2020 07:48:35 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id w13sm21846893wru.38.2020.01.27.07.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 07:48:34 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/3] KVM: x86: VM alloc bug fix and cleanup
In-Reply-To: <20200127004113.25615-1-sean.j.christopherson@intel.com>
References: <20200127004113.25615-1-sean.j.christopherson@intel.com>
Date:   Mon, 27 Jan 2020 16:48:34 +0100
Message-ID: <87zhe8lx2l.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Fix a (fairly) long standing NULL pointer dereference if VM allocation
> fails, and do a bit of clean up on top.
>
> I would have preferred to omit patch 01, i.e. fix the bug via patch 02,
> but unfortunately (long term support) kernel 4.19 doesn't have the
> accounting changes, which would make backporting the fix extra annoying
> for no real benefit.
>
> Sean Christopherson (3):
>   KVM: x86: Gracefully handle __vmalloc() failure during VM allocation
>   KVM: x86: Directly return __vmalloc() result in ->vm_alloc()
>   KVM: x86: Consolidate VM allocation and free for VMX and SVM
>

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

