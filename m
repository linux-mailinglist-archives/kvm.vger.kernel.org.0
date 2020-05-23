Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2AA31DFB9F
	for <lists+kvm@lfdr.de>; Sun, 24 May 2020 01:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388115AbgEWXOr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 May 2020 19:14:47 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:23285 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388034AbgEWXOr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 23 May 2020 19:14:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590275686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/MzHc18owJsea3S0pNt/rgvBciUHqh90tS1+xejWc1g=;
        b=MPsUp3WT8ZuU0BOnBT5QS6uQBWxiMXtWTV4lohdIQql2QJYzijh4+RvHY6CMSZMGoNDvUc
        c5W1hTQKfvLn7Rzdt1MZVw1UK4eflqxH/olxSXrAJC4npm1XbV1Tb/EfqcEBZOZbOYwcQK
        Fy+QAANzqcuD6g3PMVcAMjdpavZrbqc=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-gcV0IjnUM8aHNwSpyWyHJA-1; Sat, 23 May 2020 19:14:44 -0400
X-MC-Unique: gcV0IjnUM8aHNwSpyWyHJA-1
Received: by mail-qk1-f200.google.com with SMTP id d190so4029150qkc.20
        for <kvm@vger.kernel.org>; Sat, 23 May 2020 16:14:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/MzHc18owJsea3S0pNt/rgvBciUHqh90tS1+xejWc1g=;
        b=VnFu3n+hwPMRxaPvIQXKovTrDXoCENvfx2cToy5hdxYagx+eDHnW2S7TtQVFZErQke
         VXE/iCLyYb+bT5OE/I7F2JTtBc8aM2V08LmYckSuyMPB3rxGgcwLeQJyPQWjvbgyz7ht
         MX2ijpu34oGyJuMCqmDY/g9NarCDLEiHbiOqP2cM62CmsGNNT7oOVRXn6cVcK6p5mkEY
         A4WrA7hGTViTVav4C605Taqu+1DbJOEB6kHNlp2XgIyzYWX5k6gN0o6uqymB4sH9Z1Ml
         SAw+/vMZ8XwLG7dbbl6f8PMfT9C5rRhHzC+ymzJUwj5CnYt5IolOym2mhGlXq+Sc18UG
         UDaA==
X-Gm-Message-State: AOAM533JofSyLkYNDJIt3GQOK0CYDILw+NpEVc1pWG40N2/1CsCfsLan
        ovWBTfUbEBNDKkU8w/KF/f+1cT278Ewav3Xt7WU5eMiyMyiDUOlYl0Rdj5V4h7BGhSMhtW5LYv8
        oaoKY42dpRlzp
X-Received: by 2002:a0c:8e84:: with SMTP id x4mr10010267qvb.175.1590275684053;
        Sat, 23 May 2020 16:14:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzg2V3f8vAVlVmyPgxPifwONVk1iV05bsQWUMpAUKMaaP31/PMeICcUqi8DAc/chgJvp8iwaA==
X-Received: by 2002:a0c:8e84:: with SMTP id x4mr10010251qvb.175.1590275683837;
        Sat, 23 May 2020 16:14:43 -0700 (PDT)
Received: from xz-x1 (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id n31sm12353018qtc.36.2020.05.23.16.14.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 16:14:42 -0700 (PDT)
Date:   Sat, 23 May 2020 19:14:41 -0400
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: Re: [PATCH v9 00/14] KVM: Dirty ring interface
Message-ID: <20200523231441.GB939059@xz-x1>
References: <20200523225659.1027044-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200523225659.1027044-1-peterx@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 23, 2020 at 06:56:45PM -0400, Peter Xu wrote:
> KVM branch:
>   https://github.com/xzpeter/linux/tree/kvm-dirty-ring
> 
> QEMU branch for testing:
>   https://github.com/xzpeter/qemu/tree/kvm-dirty-ring
> 
> v9:
> - patch 3: __x86_set_memory_region: squash another trivial change to return
>   (0xdeadull << 48) always for slot removal [Sean]
> - pick r-bs for Drew

Sorry to always have forgotten to add Drew in the CC list, so it would be a
partial series again...  It'll be there for the next post.  Thanks,

-- 
Peter Xu

