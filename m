Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82926134E55
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 22:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbgAHVCj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 16:02:39 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:32707 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725446AbgAHVCi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Jan 2020 16:02:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578517357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nGgN9vS1pt4ksqqsIyVSootRX5TIRrFfQTFcrvkrQVM=;
        b=ZeeyqsrI81vurStZDEWnv6dJwuqh4BymATtODPW4t/GCU3HVQGrhzB/2oR+2eq5apZGvYg
        L3n47obxDCSYZ/3Vxd3xX0Y4ee5v/tFN5HHtBbh0c+S8y3F2f+o2ovhOak8lb46h7/TLKl
        g80N7n+wH72Jy4XCSww37vTMGqL/wuI=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-t1da2hBSMrKOiqDGAvkqnA-1; Wed, 08 Jan 2020 16:02:36 -0500
X-MC-Unique: t1da2hBSMrKOiqDGAvkqnA-1
Received: by mail-qt1-f199.google.com with SMTP id x8so2836473qtq.14
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2020 13:02:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nGgN9vS1pt4ksqqsIyVSootRX5TIRrFfQTFcrvkrQVM=;
        b=aADribNa02fplAynYSLqOeeIca8eNMRCmemF3MmN6IMLRv5bJLUVnEDbe0gE524TUR
         pIJW4voiupE6X2NPTGYsFFgqlKKfkivRstzBDfadWu43l3B/V8YyAh2tvR+M1Bob31wG
         Cl9HO+aNujlHhWxK389FCzIHYBPtxSC5kUPkt4zS2hHMHADrZgQRAPl+qwbgq9Q2R7uJ
         y4CWxlsO0B5Fm9v4lfJKP1w7oP+rt2/zoXs53Xk+cSHN2ibMMtblsHfiSjnY1SyhdyE6
         i6vQU8YM6h3xmVn1fPxtkONi1KYIsrJJFKW9RkDA4/LRsI2/6D0R+WbIbaFK46HGV++g
         qV8w==
X-Gm-Message-State: APjAAAU7LEukzM85P7+Qmym+JvwU6mccu9UeMKnSG/FuhsX5tHooj6DI
        zeqyCedMIjO5LLg1CHof2sU1bducZpoOPPvN22dTgzgf5dpaVsJ3P8B1dAUjFOxb2Fmtu/Nh5il
        nlZmEyYwQZ3lu
X-Received: by 2002:a05:620a:2010:: with SMTP id c16mr6009753qka.386.1578517355931;
        Wed, 08 Jan 2020 13:02:35 -0800 (PST)
X-Google-Smtp-Source: APXvYqxYrsmBQhSUcSU8OxBGrkXOCI6I2eG4Uc4kbWRdqrSrtUE4hSkuhX6El/2K5pmjXdYiJ3dxqA==
X-Received: by 2002:a05:620a:2010:: with SMTP id c16mr6009735qka.386.1578517355755;
        Wed, 08 Jan 2020 13:02:35 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id u24sm1942858qkm.40.2020.01.08.13.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 13:02:34 -0800 (PST)
Date:   Wed, 8 Jan 2020 16:02:33 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RESEND v2 03/17] KVM: X86: Don't track dirty for
 KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
Message-ID: <20200108210233.GI7096@xz-x1>
References: <20191221014938.58831-1-peterx@redhat.com>
 <20191221014938.58831-4-peterx@redhat.com>
 <cf232ce8-bc07-0192-580f-d08736980273@redhat.com>
 <20191223172737.GA81196@xz-x1>
 <851bd9ed-3ff3-6aef-725c-b586d819211c@redhat.com>
 <20191223201024.GB90172@xz-x1>
 <e56d4157-1a0a-3f45-0e02-ac7c10fccf96@redhat.com>
 <20200108191512.GF7096@xz-x1>
 <649c77ba-94a7-d0bf-69e7-fa0276f536d1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <649c77ba-94a7-d0bf-69e7-fa0276f536d1@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 08, 2020 at 08:44:09PM +0100, Paolo Bonzini wrote:
> Yeah, it should be okay assuming you test with lockdep.

I didn't turn it on for this work, but I'll make sure to be with it
starting from now.  Thanks,

-- 
Peter Xu

