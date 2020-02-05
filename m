Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B354D1533CC
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 16:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgBEPWy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 10:22:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51718 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726359AbgBEPWx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 10:22:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580916172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vKHNNfcl+r6URdhvtsRg9I1PCC+GPUyhu2TKclBNVok=;
        b=R37HaykiseAX+83N6o7BC5LaHGImjvlRcVfLQ/pyY/xdAwYRnXpzjreL1ILs4dU3r8qejt
        FahZ9onjttYwR5zNod0rY6D2UkfON3FoFPDVhDB3WEAl9gzadZHenkfQRt48hBaeMn5LEo
        NWnROMBUstWKqqN2Pid0SO9ofOxDvBU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-p_nfrLSvN_e4aksm_cIMXg-1; Wed, 05 Feb 2020 10:22:50 -0500
X-MC-Unique: p_nfrLSvN_e4aksm_cIMXg-1
Received: by mail-wr1-f72.google.com with SMTP id d8so1332745wrq.12
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 07:22:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=vKHNNfcl+r6URdhvtsRg9I1PCC+GPUyhu2TKclBNVok=;
        b=nJeyD3+lZBsMMV2M2IqMDyWZ3F8JEMXbvU9BrRkBqCe483h2BbuioIGfCFhPF82Az0
         5Ps1XL1D39CdwHjGassxyYXjhdCociw35dk8ty2J1QW4J8CaQSh0p35Fv46aE1JbhPjt
         vxdnNd37MSyUbFWK3nXUIT5YhTa0/QEjLSZeG9v8ErvRqUkvWGeTfke0AHMexpbF71qU
         Q+1U/dzYE7bAG/v0PUUiMSWGNyiDB0VnTp8p+yJoRtFiRqtb/TQ08QvL+4mjX9SlQpB8
         bCsKS2QvHKLT9Z7tNQyy25i9f4i9j8VVd4k4AFkx0O4W4sg5IgG7PIH7lUFHQlH1AnLq
         2H7w==
X-Gm-Message-State: APjAAAW3zLnC5/yKmydb951HTapoeaYOh6wAUUnKIiR1wJSInrJS0lKt
        UXrTbhK0yqWlmZcQqVTKdoZ1HYEidETIjvcpL5IUXGyOQq78QwnAYnkAwAgAOn3yNZWhsAeuKNL
        lKdaj/uyj/M7j
X-Received: by 2002:a1c:48c1:: with SMTP id v184mr6184622wma.5.1580916169775;
        Wed, 05 Feb 2020 07:22:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqz1P6wGbDoWJ9U0FwfPyYZ8Yoaq4xJQ1R49Y2GfyL0piQVH3Iy3Xv1yALh03UKBJFamJjwwVQ==
X-Received: by 2002:a1c:48c1:: with SMTP id v184mr6184584wma.5.1580916169331;
        Wed, 05 Feb 2020 07:22:49 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id i204sm8952711wma.44.2020.02.05.07.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 07:22:48 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 04/26] KVM: x86: Add a kvm_x86_ops hook to query virtualized MSR support
In-Reply-To: <20200205145923.GC4877@linux.intel.com>
References: <20200129234640.8147-1-sean.j.christopherson@intel.com> <20200129234640.8147-5-sean.j.christopherson@intel.com> <87eev9ksqy.fsf@vitty.brq.redhat.com> <20200205145923.GC4877@linux.intel.com>
Date:   Wed, 05 Feb 2020 16:22:48 +0100
Message-ID: <8736bpkqif.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Wed, Feb 05, 2020 at 03:34:29PM +0100, Vitaly Kuznetsov wrote:
>> Sean Christopherson <sean.j.christopherson@intel.com> writes:
>> 
>> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>
> Stooooooop!  Everything from this point on is obsoleted by kvm_cpu_caps!
>

Oops, this was only a week old series! Patches are rottening fast
nowadays!

-- 
Vitaly

